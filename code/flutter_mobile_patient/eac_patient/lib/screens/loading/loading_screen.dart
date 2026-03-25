import 'package:eac_patient/constants.dart';
import 'package:flutter/material.dart';
import 'components/body.dart';

class LoadingScreen extends StatelessWidget {
  static String routeName = "/error";

  const LoadingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primaryColor,
      body: Body(),
    );
  }
}
