import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../helper/chat_core/firebase_chat_core.dart';
import '../../constants.dart';
import '../../riverpod/general_riverpod.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room=ref.watch(roomProvider);
    final uid=FirebaseAuth.instance.currentUser?.uid??'';
    final isAttachmentUploading=useState(false);

    void _setAttachmentUploading(bool uploading) {
      isAttachmentUploading.value = uploading;
    }

    Future<void> _handlePhotoSelection() async {
      final result = await ImagePicker().pickImage(
        imageQuality: 70,
        maxWidth: 1440,
        source: ImageSource.gallery,
      );


      if (result != null) {
        _setAttachmentUploading(true);

        final bytes = await result.readAsBytes();
        final size = bytes.lengthInBytes;
        final image = await decodeImageFromList(bytes);
        final name = result.name;

        try {
          final reference = FirebaseStorage.instance.ref().child("chat_res/$uid/$name");
          UploadTask uploadTask = reference.putData(await result!.readAsBytes(), SettableMetadata(contentType: result!.mimeType));
          String downloadUrl = await (await uploadTask).ref.getDownloadURL();

          final message = types.PartialImage(
            height: image.height.toDouble(),
            name: name,
            size: size,
            uri: downloadUrl,
            width: image.width.toDouble(),
          );

          FirebaseChatCore.instance.sendMessage(
            message,
            room!.id,
          );
          _setAttachmentUploading(false);
        } finally {
          _setAttachmentUploading(false);
        }
      }

    }
    void _handlePreviewDataFetched(
        types.TextMessage message,
        types.PreviewData previewData,
        ) {
      final updatedMessage = message.copyWith(previewData: previewData);

      FirebaseChatCore.instance.updateMessage(updatedMessage, room!.id);
    }

    void _handleSendPressed(types.PartialText message) {
      FirebaseChatCore.instance.sendMessage(
        message,
        room!.id,
      );
    }
    return Column(
      children: [
        Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: defaultPadding),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      room!.name??"",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  IconButton(onPressed: (){
                    ref.read(selectedPage.notifier).state="OnAppointment";
                  }, icon: Icon(Icons.video_call_outlined, color: primaryColor,size: 30,))

                ],
              ),
            )
        ),
    Expanded(
      child: StreamBuilder<types.Room>(
      initialData: room,
        stream: FirebaseChatCore.instance.room(room!.id),
        builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
          initialData: const [],
          stream: FirebaseChatCore.instance.messages(snapshot.data!),
          builder: (context, snapshot) => Theme(
            data: ThemeData(),
            child: Chat(
              theme: DefaultChatTheme(primaryColor: primaryColor, backgroundColor: Colors.transparent, secondaryColor: Colors.green),
              isAttachmentUploading: isAttachmentUploading.value,
              messages: snapshot.data ?? [],
              onAttachmentPressed: _handlePhotoSelection,
              onPreviewDataFetched: _handlePreviewDataFetched,
              onSendPressed: _handleSendPressed,
              user: types.User(
                id: uid,
              ),
            ),
          ),
        ),
      ),
    )
      ],
    );
  }
}

