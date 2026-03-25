import 'package:eac_patient/screens/widgets/default_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_notification/in_app_notification.dart';

import '../../constants.dart';
import '../../riverpod/general_riverpod.dart';
import '../widgets/custom_modal.dart';
import '../widgets/my_text_form_field.dart';
import '../widgets/notification_body.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final email = useTextEditingController();
    final pass = useTextEditingController();
    final hidePass = useState(true);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          color: primaryColor,
          child: Row(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo.png"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "ENHANCING ASTHMA CARE",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )
                ],
              )),
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: SizedBox()),
                    Container(
                      constraints: BoxConstraints(maxWidth: 450),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Card(
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 40),
                            child: Column(
                              children: [
                                Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                                MyTextFormField(
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.black26,
                                  ),
                                  labelText: "Email",
                                  controller: email,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                MyTextFormField(
                                  controller: pass,
                                  prefixIcon: Icon(Icons.lock_open,
                                      color: Colors.black26),
                                  labelText: "Password",
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
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextButton(
                                    onPressed: () {
                                      ref
                                          .read(
                                              withOutUserPageProvider.notifier)
                                          .state = 2;
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 14),
                                    )),
                                DefaultButton(
                                  text: "Login",
                                  press: () async {
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (BuildContext context) {
                                    //     return CustomDialog(
                                    //       title: "Yeay! Welcome Back",
                                    //       description: "Once again you login successfully into EAC app",
                                    //     ); // Your custom dialog widget
                                    //   },
                                    // );
                                    if (email.text.trim().isEmpty ||
                                        pass.text.trim().isEmpty) {
                                      InAppNotification.show(
                                        child: const NotificationBody(
                                          msg: "Please fill all required field",
                                        ),
                                        context: context,
                                      );
                                      return;
                                    }

                                    try {
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                              email: email.text.trim(),
                                              password: pass.text.trim());
                                      // ref
                                      //     .read(withUserPageProvider.notifier)
                                      //     .state = 1;
                                    } on FirebaseAuthException catch (e) {
                                      print(e);
                                      if (e.code == 'user-not-found') {
                                        InAppNotification.show(
                                          child: const NotificationBody(
                                            msg: "Wrong email or password",
                                          ),
                                          context: context,
                                        );
                                      } else if (e.code == 'wrong-password') {
                                        InAppNotification.show(
                                          child: const NotificationBody(
                                            msg: "Wrong email or password",
                                          ),
                                          context: context,
                                        );
                                      } else if (e.code == 'invalid-email') {
                                        InAppNotification.show(
                                          child: const NotificationBody(
                                            msg: "Wrong email or password",
                                          ),
                                          context: context,
                                        );
                                      }else if (e.code == 'invalid-login-credentials') {
                                        InAppNotification.show(
                                          child: const NotificationBody(
                                            msg: "Wrong email or password",
                                          ),
                                          context: context,
                                        );
                                      }
                                    }
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account?",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 14),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          ref
                                              .read(withOutUserPageProvider
                                                  .notifier)
                                              .state = 1;
                                        },
                                        child: Text(
                                          "Sign Up",
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 14),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
