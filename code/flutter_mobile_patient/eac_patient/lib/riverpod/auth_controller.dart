import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/users.dart';
import 'general_riverpod.dart';


final authControllerProvider = StateNotifierProvider<AuthController, int>(
  (ref) => AuthController(ref),
);


class AuthController extends StateNotifier<int> {
  final Ref ref;
  Timer? _timer;

  AuthController(this.ref) : super(0) {

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        state = 1;
      } else {
        FirebaseFirestore.instance.collection('patient').doc(user.uid).snapshots().listen((event) {
          Map<String,dynamic>? map=event.data();
          if(map==null){
            print("NO DATA");
            state=3;
          }else{
            ref.read(currentUserProvider.notifier).state = Users.map(map);
            state = 2;
          }
        }).onError((error, stackTrace){
          print(error);
          state=-1;
        });

      }

    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  void signOut() async {
    // ref.read(currentUserProvider.notifier).state = Users();
    FirebaseAuth.instance.signOut();
  }
}
