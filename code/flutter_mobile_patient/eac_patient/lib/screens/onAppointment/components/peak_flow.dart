import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../widgets/default_button.dart';

class PeakFlow extends StatelessWidget {
  const PeakFlow({Key? key, required this.deviceId}) : super(key: key);
  final String deviceId;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance
        .ref()
        .child("d")
        .child(deviceId)
        .child('pf')
        .onValue,
    builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
      if (snapshot.hasError) {
        return Column(
          children: const [
            SizedBox(height: 10),
            Text(
              "An unknown error has occurred",
              style: TextStyle(color: Colors.red),
            )
          ],
        );
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Column(
          children: const [
            SizedBox(height: 10),
            CircularProgressIndicator(
              color: primaryColor,
            )
          ],
        );
      }
      String value='';
      if(snapshot.data?.snapshot?.value!=null) {
        value=(double.tryParse(snapshot.data!.snapshot!.value.toString())??0).toStringAsFixed(2);
      }

      return  Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Peak Flow",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        "Last Reading",
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                      )
                    ],
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          value,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        Text(
                          "L/min",
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                        )
                      ],
                    ),
                  ),

                ],
              ),
              DefaultButton(text: "Start New Reading", press: (){
                FirebaseDatabase.instance
                    .ref()
                    .child("d")
                    .child(deviceId)
                    .child("onPF").set(true);
              },)
            ],
          ),
        ),
      );


    });
  }
}
