import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/users.dart';
import 'auth_controller.dart';

final selectedPage = StateProvider<String>((ref) => "Home");

final mainPageProvider = Provider<int>((ref) {
  final int user = ref.watch(authControllerProvider);

  if(user==-1){
    return -1;
  }else if(user==0){
    return 0;
  }else if(user==1){
    return 1;
  }else if(user==2){
    return 2;
  }else if(user==3){
    return 3;
  }else if(user==4){
    return 4;
  }{
    return -1;
  }
});

final currentUserProvider = StateProvider<Users>((ref) => Users());
final withUserPageProvider = StateProvider<int>((ref) =>0);
final withOutUserPageProvider = StateProvider<int>((ref) =>0);

final scheduleIdProvider = StateProvider<String>((ref) => "");
final roomProvider = StateProvider<Room?>((ref) => null);

final patientIdProvider = StateProvider<String>((ref) => "");
final patientNameProvider = StateProvider<String>((ref) => "");
final doctorIdProvider = StateProvider<String>((ref) => "");
final doctorNameProvider = StateProvider<String>((ref) => "");

final prescriptionNameProvider = StateProvider<String>((ref) => "");
final prescriptionProvider = StateProvider<String>((ref) => "");
final prescriptionNoteProvider = StateProvider<String>((ref) => "");

