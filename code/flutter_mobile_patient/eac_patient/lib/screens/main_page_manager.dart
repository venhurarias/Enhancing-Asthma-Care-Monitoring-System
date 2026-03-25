
import 'package:eac_patient/screens/wait_verify/wait_verify_screen.dart';
import 'package:eac_patient/screens/with_user_page_manager.dart';
import 'package:eac_patient/screens/without_user_page_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../riverpod/general_riverpod.dart';
import 'completeProfile/complete_profile.dart';
import 'error/error_screen.dart';
import 'loading/loading_screen.dart';



class MainPageManager extends ConsumerWidget {
  const MainPageManager({Key? key}) : super(key: key);
  static String routeName = "/mainManager";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(mainPageProvider);
    print("page :: ${page}");
    if (page == -1) {
      return const ErrorScreen();
    } else if (page == 0) {
      return const LoadingScreen();
    } else if (page == 1) {
      return const WithoutUserPageManager();
    } else if (page == 2) {
      return const WithUserPageManager();
    }else if (page == 3) {
      return const CompleteProfileScreen();
    }  else {
      return const ErrorScreen();
    }
  }
}
