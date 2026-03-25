import 'package:eac_patient/screens/widgets/default_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_notification/in_app_notification.dart';

import '../../constants.dart';
import '../../riverpod/general_riverpod.dart';
import '../widgets/custom_modal.dart';
import '../widgets/header.dart';
import '../widgets/my_text_form_field.dart';
import '../widgets/notification_body.dart';

class ForgotScreen extends HookConsumerWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final email=useTextEditingController();

    return Scaffold(
        body: SafeArea(
            child: Container(
                width: size.width,
                height: size.height,
                child: Column(
                    children: [
                      Header(),
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 360),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: IconButton(
                                      onPressed: () {
                                        ref.read(withOutUserPageProvider.notifier).state = 0;
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios_new,
                                      )),
                                ),
                              ),
                              Text(
                                "Forgot Your Password?",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              Expanded(child: SizedBox())
                            ],
                          ),
                          SizedBox(height: 20,),
                          MyTextFormField(
                            controller: email,
                              prefixIcon: Icon(Icons.email_outlined,color: Colors.black26,), labelText: "Email"),
                          SizedBox(height: 20,),
                          DefaultButton(text: "Reset Password",press: (){
                            if (email.text.trim().isEmpty) {
                              InAppNotification.show(
                                child: const NotificationBody(
                                  msg: "Please fill all required field",
                                ),
                                context: context,
                              );
                              return;
                            }
                            FirebaseAuth.instance.sendPasswordResetEmail(email: email.text.trim());
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                  title: "Success!",
                                  description: "We have send an email to reset your password",
                                ); // Your custom dialog widget
                              },
                            );
                          },)





                        ],
                      ),
                    ),
                  )

                ]
                )
            )
        )
    );
  }
}
