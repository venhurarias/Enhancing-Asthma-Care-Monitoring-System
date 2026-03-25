import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../riverpod/auth_controller.dart';
import '../../widgets/default_button.dart';


class Body extends ConsumerWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration:BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'), // Replace with your image path
            fit: BoxFit.contain, // You can use different fit modes as per your needs
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.05), // Adjust the opacity value (0.0 - 1.0)
              BlendMode.modulate, // This blend mode applies the color filter to the image
            ),
          ),

        ),
      child: Column(
        children: [
          Expanded(flex: 8,child: SizedBox()),
          Center(
            child: Lottie.asset(
              "assets/lottie/verify.json",
              // width: getProportionateScreenWidth(235),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "Waiting for the admin the review and verify your account",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const Spacer(),
          DefaultButton(
            text: "Log Out",
            press: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
          Expanded(flex: 10,child: SizedBox()),

        ],
      ),
    );
  }
}
