import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../widgets/default_button.dart';

class PeakFlow extends StatelessWidget {
  const PeakFlow({Key? key,required this.patientName, required this.deviceId, required this.patientUuid}) : super(key: key);
  final String deviceId;
  final String patientUuid;
  final String patientName;
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
      if(snapshot.data==null){
        return SizedBox();
      }
      if(!snapshot.data!.snapshot.exists){
        return SizedBox();
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
              DefaultButton(text: "Start New Reading", press: ()async{
                DataSnapshot data=await FirebaseDatabase.instance.ref().child("mydctr").child(patientUuid).get();
                data.children.forEach((element) {
                  print(element.key??"");
                  FirebaseDatabase.instance
                      .ref()
                  .child('n')
                  .child(element.key??"")
                  .push().set({
                    "m":"The peak flow of ${patientName} is open",
                    "ts":ServerValue.timestamp,
                    "r":false
                  });
                });
                FirebaseDatabase.instance
                    .ref()
                    .child('n')
                    .child(patientUuid)
                    .push().set({
                  "m":"Your peak flow is open",
                  "ts":ServerValue.timestamp,
                  "r":false
                });
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
