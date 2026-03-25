
import 'package:eac_patient/screens/loading/loading_screen.dart';
import 'package:eac_patient/screens/login/login_screen.dart';
import 'package:eac_patient/screens/signin/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../riverpod/general_riverpod.dart';
import 'error/error_screen.dart';
import 'forgot/forgot.dart';


class WithoutUserPageManager extends ConsumerWidget {
  const WithoutUserPageManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(withOutUserPageProvider);

   if (page == 0) {
      return const LoginScreen();
    } else if (page == 1) {
      return const SignInScreen();
    }else if (page == 2) {
      return const ForgotScreen();
    } else {
      return const ErrorScreen();
    }
  }
}
