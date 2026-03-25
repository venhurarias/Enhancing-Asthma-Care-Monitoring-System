import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'util.dart';

/// Provides access to Firebase chat data. Singleton, use
/// FirebaseChatCore.instance to aceess methods.
class FirebaseChatCore {
  FirebaseChatCore._privateConstructor() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      firebaseUser = user;
    });
  }



  /// Current logged in user in Firebase. Does not update automatically.
  /// Use [FirebaseAuth.authStateChanges] to listen to the state changes.
  User? firebaseUser = FirebaseAuth.instance.currentUser;

  /// Singleton instance.
  static final FirebaseChatCore instance =
      FirebaseChatCore._privateConstructor();


  /// custom data.
  Future<types.Room> createRoom({
    required String patientId,
    required String patientImage,
    required String doctorImage,
    required String device,
    String? additionalMsg}) async {
    final fu = firebaseUser;

    if (fu == null) return Future.error('User does not exist');

    // Sort two user ids array to always have the same array for both users,
    // this will make it easy to find the room if exist and make one read only.
    print("dito naa");
    print(firebaseUser?.uid);
    print(patientId);
    final roomQuery = await FirebaseFirestore.instance
        .collection('rooms')
        .where('id', isEqualTo: (firebaseUser?.uid??'')+patientId)
        .limit(1)
        .get();

    print('hehe');
    // Check if room already exist.
    if (roomQuery.docs.isNotEmpty) {
      final room = (await processRoomsQuery(
        fu,
        FirebaseFirestore.instance,
        roomQuery,
        'doctor',
      ))
          .first;

      return room;
    }
    print("dito na1");

    final currentUser = await fetchUser(
      FirebaseFirestore.instance,
      fu.uid,
      'doctor',
    );
    print("dito na2");
    final otherUser = await fetchUser(
      FirebaseFirestore.instance,
      patientId,
      'patient',
    );
    final myOtherUser=types.User.fromJson(otherUser);
    final myCurrentUser=types.User.fromJson(currentUser);
    final users = [myCurrentUser, myOtherUser];
    final userIds = [fu.uid, patientId];
    final room = await FirebaseFirestore.instance
        .collection('rooms')
        .add({
      'createdAt': FieldValue.serverTimestamp(),
      'patient pic': patientImage,
      'doctor pic': doctorImage,
      'patient name':  "${myOtherUser.firstName} ${myOtherUser.lastName}",
      'doctor name':  "${myCurrentUser.firstName} ${myCurrentUser.lastName}",
      'updatedAt': FieldValue.serverTimestamp(),
      'userIds': userIds,
      'device': device,
      'id':(firebaseUser?.uid??'')+patientId
        });
    if(additionalMsg!=null){
       FirebaseChatCore.instance.sendMessage2(
          types.PartialText(text: additionalMsg),
          room.id,
          myOtherUser.id
      );
    }


    return types.Room(
      id: room.id,
      type: types.RoomType.direct,
      users: users,
    );
  }


  /// Removes message document.
  Future<void> deleteMessage(String roomId, String messageId) async {
    await FirebaseFirestore.instance
        .collection('rooms/$roomId/messages')
        .doc(messageId)
        .delete();
  }

  /// Removes room document.
  Future<void> deleteRoom(String roomId) async {
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .delete();
  }

  /// Removes [types.User] from `users` collection in Firebase.
  Future<void> deleteUserFromFirestore(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .delete();
  }

  /// Returns a stream of messages from Firebase for a given room.
  Stream<List<types.Message>> messages(
    types.Room room, {
    List<Object?>? endAt,
    List<Object?>? endBefore,
    int? limit,
    List<Object?>? startAfter,
    List<Object?>? startAt,
  }) {
    var query = FirebaseFirestore.instance
        .collection('rooms/${room.id}/messages')
        .orderBy('createdAt', descending: true);

    if (endAt != null) {
      query = query.endAt(endAt);
    }

    if (endBefore != null) {
      query = query.endBefore(endBefore);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    if (startAfter != null) {
      query = query.startAfter(startAfter);
    }

    if (startAt != null) {
      query = query.startAt(startAt);
    }

    return query.snapshots().map(
          (snapshot) => snapshot.docs.fold<List<types.Message>>(
            [],
            (previousValue, doc) {
              final data = doc.data();
              final author = room.users.firstWhere(
                (u) => u.id == data['authorId'],
                orElse: () => types.User(id: data['authorId'] as String),
              );

              data['author'] = author.toJson();
              data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
              data['id'] = doc.id;
              data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;

              return [...previousValue, types.Message.fromJson(data)];
            },
          ),
        );
  }

  /// Returns a stream of changes in a room from Firebase.
  Stream<types.Room> room(String roomId) {
    final fu = firebaseUser;

    if (fu == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .asyncMap(
          (doc) => processRoomDocument(
            doc,
            fu,
            FirebaseFirestore.instance,
            'patient',
          ),
        );
  }

  /// Returns a stream of rooms from Firebase. Only rooms where current
  /// logged in user exist are returned. [orderByUpdatedAt] is used in case
  /// you want to have last modified rooms on top, there are a couple
  /// of things you will need to do though:
  /// 1) Make sure `updatedAt` exists on all rooms
  /// 2) Write a Cloud Function which will update `updatedAt` of the room
  /// when the room changes or new messages come in
  /// 3) Create an Index (Firestore Database -> Indexes tab) where collection ID
  /// is `rooms`, field indexed are `userIds` (type Arrays) and `updatedAt`
  /// (type Descending), query scope is `Collection`
  Stream<List<types.Room>> rooms({bool orderByUpdatedAt = false}) {
    final fu = firebaseUser;

    if (fu == null) return const Stream.empty();


    final collection = orderByUpdatedAt
        ? FirebaseFirestore.instance
            .collection('rooms')
            .where('userIds', arrayContains: fu.uid)
            .orderBy('updatedAt', descending: true)
        : FirebaseFirestore.instance
            .collection('rooms')
            .where('userIds', arrayContains: fu.uid);

    return collection.snapshots().asyncMap(
          (query) => processRoomsQuery(
            fu,
            FirebaseFirestore.instance,
            query,
            'patient',
          ),
        );
  }

  void sendMessage2(dynamic partialMessage, String roomId, uid) async {
    if (firebaseUser == null) return;

    types.Message? message;

    if (partialMessage is types.PartialCustom) {
      message = types.CustomMessage.fromPartial(
        author: types.User(id: uid),
        id: '',
        partialCustom: partialMessage,
      );
    } else if (partialMessage is types.PartialFile) {
      message = types.FileMessage.fromPartial(
        author: types.User(id: uid),
        id: '',
        partialFile: partialMessage,
      );
    } else if (partialMessage is types.PartialImage) {
      message = types.ImageMessage.fromPartial(
        author: types.User(id: uid),
        id: '',
        partialImage: partialMessage,
      );
    } else if (partialMessage is types.PartialText) {
      message = types.TextMessage.fromPartial(
        author: types.User(id: uid),
        id: '',
        partialText: partialMessage,
      );
    }

    if (message != null) {
      final messageMap = message.toJson();
      messageMap.removeWhere((key, value) => key == 'author' || key == 'id');
      messageMap['authorId'] = uid;
      messageMap['createdAt'] = FieldValue.serverTimestamp();
      messageMap['updatedAt'] = FieldValue.serverTimestamp();

      await FirebaseFirestore.instance
          .collection('${'rooms'}/$roomId/messages')
          .add(messageMap);

      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .update({'updatedAt': FieldValue.serverTimestamp()});
    }
  }

  /// Sends a message to the Firestore. Accepts any partial message and a
  /// room ID. If arbitraty data is provided in the [partialMessage]
  /// does nothing.
  void sendMessage(dynamic partialMessage, String roomId) async {
    if (firebaseUser == null) return;

    types.Message? message;

    if (partialMessage is types.PartialCustom) {
      message = types.CustomMessage.fromPartial(
        author: types.User(id: firebaseUser!.uid),
        id: '',
        partialCustom: partialMessage,
      );
    } else if (partialMessage is types.PartialFile) {
      message = types.FileMessage.fromPartial(
        author: types.User(id: firebaseUser!.uid),
        id: '',
        partialFile: partialMessage,
      );
    } else if (partialMessage is types.PartialImage) {
      message = types.ImageMessage.fromPartial(
        author: types.User(id: firebaseUser!.uid),
        id: '',
        partialImage: partialMessage,
      );
    } else if (partialMessage is types.PartialText) {
      message = types.TextMessage.fromPartial(
        author: types.User(id: firebaseUser!.uid),
        id: '',
        partialText: partialMessage,
      );
    }

    if (message != null) {
      final messageMap = message.toJson();
      messageMap.removeWhere((key, value) => key == 'author' || key == 'id');
      messageMap['authorId'] = firebaseUser!.uid;
      messageMap['createdAt'] = FieldValue.serverTimestamp();
      messageMap['updatedAt'] = FieldValue.serverTimestamp();

      await FirebaseFirestore.instance
          .collection('${'rooms'}/$roomId/messages')
          .add(messageMap);

      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .update({
        'updatedAt': FieldValue.serverTimestamp(),
        'lastMsg': partialMessage.text
      });
    }
  }

  /// Updates a message in the Firestore. Accepts any message and a
  /// room ID. Message will probably be taken from the [messages] stream.
  void updateMessage(types.Message message, String roomId) async {
    if (firebaseUser == null) return;
    if (message.author.id != firebaseUser!.uid) return;

    final messageMap = message.toJson();
    messageMap.removeWhere(
      (key, value) => key == 'author' || key == 'createdAt' || key == 'id',
    );
    messageMap['authorId'] = message.author.id;
    messageMap['updatedAt'] = FieldValue.serverTimestamp();

    await FirebaseFirestore.instance
        .collection('rooms/$roomId/messages')
        .doc(message.id)
        .update(messageMap);
  }

  /// Updates a room in the Firestore. Accepts any room.
  /// Room will probably be taken from the [rooms] stream.
  void updateRoom(types.Room room) async {
    if (firebaseUser == null) return;

    final roomMap = room.toJson();
    roomMap.removeWhere((key, value) =>
        key == 'createdAt' ||
        key == 'id' ||
        key == 'lastMessages' ||
        key == 'users');

      roomMap['imageUrl'] = null;
      roomMap['name'] = null;


    roomMap['lastMessages'] = room.lastMessages?.map((m) {
      final messageMap = m.toJson();

      messageMap.removeWhere((key, value) =>
          key == 'author' ||
          key == 'createdAt' ||
          key == 'id' ||
          key == 'updatedAt');

      messageMap['authorId'] = m.author.id;

      return messageMap;
    }).toList();
    roomMap['updatedAt'] = FieldValue.serverTimestamp();
    roomMap['userIds'] = room.users.map((u) => u.id).toList();

    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(room.id)
        .update(roomMap);
  }

  /// Returns a stream of all users from Firebase.
  Stream<List<types.User>> users() {
    if (firebaseUser == null) return const Stream.empty();
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.fold<List<types.User>>(
            [],
            (previousValue, doc) {
              if (firebaseUser!.uid == doc.id) return previousValue;

              final data = doc.data();

              data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
              data['id'] = doc.id;
              data['lastSeen'] = data['lastSeen']?.millisecondsSinceEpoch;
              data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;

              return [...previousValue, types.User.fromJson(data)];
            },
          ),
        );
  }
}
