import 'package:eac/screens/widgets/default_button.dart';
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

class SignInScreen extends HookConsumerWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final email=useTextEditingController();
    final pass=useTextEditingController();
    final confirmPass=useTextEditingController();
    final hidePass = useState(true);
    final hideConPass = useState(true);
    return Scaffold(
        body: SafeArea(
            child: Container(
                width: size.width,
                height: size.height,
                child: Column(
                    children: [
Header(),
                  Container(
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
                              "Sign Up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            Expanded(child: SizedBox())
                          ],
                        ),
                        SizedBox(height: 20,),
                        MyTextFormField(
                            labelText: "Enter your email",
                        controller: email,),
                        SizedBox(height: 10,),
                        MyTextFormField(
                            labelText: "Enter your password",
                        controller: pass,
                            obscureText: hidePass.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                  hidePass.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off,
                                  color: Colors.black26),
                              onPressed: () {
                                hidePass.value = !hidePass.value;
                              },
                            )),
                        SizedBox(height: 10,),
                        MyTextFormField(
                            labelText: "Repeat password",
                        controller: confirmPass,
                            obscureText: hideConPass.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                  hideConPass.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off,
                                  color: Colors.black26),
                              onPressed: () {
                                hideConPass.value = !hideConPass.value;
                              },
                            )),
                        SizedBox(height: 10,),
                        DefaultButton(text: "Register",press: () async {
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return CustomDialog(
                          //       title: "Success",
                          //       description: "Your account has been successfully registered",
                          //     ); // Your custom dialog widget
                          //   },
                          // );
                          if(email.text.trim().isEmpty || pass.text.trim().isEmpty || confirmPass.text.trim().isEmpty){
                            InAppNotification.show(
                              child: const NotificationBody(msg: "Please fill all required field",),
                              context: context,);
                            return;
                          }
                          if(pass.text != confirmPass.text){
                            InAppNotification.show(
                              child: const NotificationBody(msg: "Password and confirm password does not match",),
                              context: context,);
                            return;
                          }
                          try {
                            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: email.text.trim(),
                              password: pass.text.trim(),
                            );
                            await FirebaseAuth.instance.currentUser!.sendEmailVerification();
                            // ref.read(withUserPageProvider.notifier).state = 1;
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              InAppNotification.show(
                                child: const NotificationBody(msg: "The password provided is too weak.",),
                                context: context,);
                            } else if (e.code == 'email-already-in-use') {
                              InAppNotification.show(
                                child: const NotificationBody(msg: "The account already exists for that email.",),
                                context: context,
                              );
                            }
                          } catch (e) {
                            InAppNotification.show(
                              child: const NotificationBody(msg: "Unknown Error has occurred",),
                              context: context,
                            );
                          }

                        },)





                      ],
                    ),
                  )

                ]
                )
            )
        )
    );
  }
}
