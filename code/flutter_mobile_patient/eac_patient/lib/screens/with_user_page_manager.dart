import 'package:eac_patient/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../riverpod/general_riverpod.dart';
import 'error/error_screen.dart';


class WithUserPageManager extends ConsumerWidget {
  const WithUserPageManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(withUserPageProvider);

    if (page == 0) {
      return const MainScreen();
    } else {
      return const ErrorScreen();
    }
  }
}
