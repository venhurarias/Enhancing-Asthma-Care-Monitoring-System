import 'package:flutter/material.dart';

import 'components/body.dart';

class WaitVerifyScreen extends StatelessWidget {
  static String routeName = "/login_success";

  const WaitVerifyScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
      ),
      body: const Body(),
    );
  }
}
