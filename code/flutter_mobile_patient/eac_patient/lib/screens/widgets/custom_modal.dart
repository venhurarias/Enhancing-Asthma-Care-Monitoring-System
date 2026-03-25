import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'default_button.dart';


class CustomDialog extends StatelessWidget {
  const CustomDialog({Key? key, required this.title, required this.description}) : super(key: key);
  final String title;
  final String description;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        constraints: BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/lottie/checked.json'),
            SizedBox(height: 20,),
            Text(
              title,
              style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10,),

            Text(
              description,
              style: TextStyle(color: Colors.black38, fontSize: 14),
            ),
            SizedBox(height: 20,),

            DefaultButton(text: "Go to home",press: (){
              Navigator.of(context).pop();
            },)

          ],
        ),
      ),
    );
  }
}