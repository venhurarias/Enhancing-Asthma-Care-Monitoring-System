import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../widgets/default_button.dart';
import '../../widgets/my_text_form_field.dart';



class WarningDialog extends StatelessWidget {
  const WarningDialog({Key? key, required this.title, required this.description,  this.proceedPress}) : super(key: key);
  final String title;
  final String description;
  final Function? proceedPress;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 360,
        height: 400,
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
            Row(
              children: [
                Expanded(
                  child: DefaultButton(text: "Yes",press: proceedPress,),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: DefaultButton(text: "No",press: (){
                    Navigator.of(context).pop();
                  },),
                ),
              ],
            ),



          ],
        ),
      ),
    );
  }
}