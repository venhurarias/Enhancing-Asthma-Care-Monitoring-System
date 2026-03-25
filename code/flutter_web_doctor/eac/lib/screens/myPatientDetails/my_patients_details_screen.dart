import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eac/helper/assist.dart';
import 'package:eac/screens/widgets/MyCardGridView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../constants.dart';
import '../../helper/chat_core/firebase_chat_core.dart';
import '../../responsive.dart';

import '../../riverpod/general_riverpod.dart';
import '../onAppointment/components/my_line_graph.dart';
import '../schedule/components/warning_cancel_modal.dart';
import '../schedule/components/warning_modal.dart';
import '../schedule/components/warning_resched_modal.dart';
import '../widgets/default_button.dart';
import '../widgets/header.dart';
import '../widgets/header_profile.dart';
import '../widgets/notification_body.dart';
import 'components/category_card.dart';
import '../widgets/patient_card_details.dart';
import 'components/my_full_patient_card_details.dart';
import 'components/tracker_card.dart';


class MyPatientsDetailsScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientId=ref.watch(patientIdProvider);
    final user = ref.watch(currentUserProvider);

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('patient').doc(patientId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> document) {
        if (document.hasError) {
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

        if (document.connectionState == ConnectionState.waiting) {
          return Column(
            children: const [
              SizedBox(height: 10),
              CircularProgressIndicator(
                color: primaryColor,
              )
            ],
          );
        }
        if (!document.hasData) {
          return Column(
            children: const [
              SizedBox(height: 10),
              Text(
                "Unknown Error",
                style: TextStyle(color: primaryColor),
              ),
            ],
          );
        }
        Map<String,dynamic>? map=document.data?.data();
        if(map==null){
          return Column(
            children: const [
              SizedBox(height: 10),
              Text(
                "Unknown Error",
                style: TextStyle(color: primaryColor),
              ),
            ],
          );
        }
        return StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance
              .ref()
              .child("d")
              .child(map['device'])
              .child('r')
              .orderByChild('Ts')
              .limitToLast(20)
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
            if (!(snapshot.data?.snapshot.exists ?? false)) {
              return Column(
                children: const [
                  SizedBox(height: 10),
                  Text(
                    "You still don't have reading",
                    style: TextStyle(color: primaryColor),
                  ),
                ],
              );
            }
            List list = (snapshot.data!.snapshot.value as Map).values.toList();
            List<int> tsList = [];
            List<int> hList = [];
            List<int> oList = [];

            for (var value in list) {
              tsList.add(value['Ts'] ??
                  0);
              hList.add(value['h'] ??
                  0);
              oList.add(value['o'] ??
                  0);
            }
            int highestH = hList.reduce((value, element) => value > element ? value : element);

            return Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: defaultPadding),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_outlined),
                        onPressed: (){
                          ref.read(selectedPage.notifier).state="Appointment";
                        },
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text(
                      "Patient Detail",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: defaultPadding),
                Container(
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                constraints: BoxConstraints(maxHeight: 200),
                                child: MyFullPatientCardDetails(
                                  name: "${map['firstName']} ${map['lastName']}",
                                  pic: map['pic'],
                                  gender: map['gender'],
                                  address: map['address'],
                                  birthday: DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(map['birthday'].millisecondsSinceEpoch)),)),
                            SizedBox(height: 20,),
                            // CategoryCard(name: "Heart Rate",iconData: FontAwesomeIcons.chartLine,),
                            Row(
                              children: [
                                Text(
                                  "SPO2 Reading",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                SizedBox(
                                  width: defaultPadding,
                                ),

                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              constraints: BoxConstraints(maxHeight: 300),
                              child: MyLineGraph(
                                list: oList,
                                maxY: 120,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text(
                                  "BPM Reading",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                SizedBox(
                                  width: defaultPadding,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              constraints: BoxConstraints(maxHeight: 300),
                              child: MyLineGraph(
                                list: hList,
                                maxY: Assist.roundToNearestTens(highestH+40),
                              ),
                            ),
                            SizedBox(height: 30,),


                          ],
                        ),
                      ),
                      SizedBox(width: defaultPadding*4,),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tracker",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 20,),
                          TrackerCard(percent: "${oList.last}%", name: "Sp02", details: "Avg Sp02",),
                          SizedBox(height: 10,),
                          TrackerCard(percent: "${hList.last}", name: "bpm", details: "Avg Heart Rate",),
                          SizedBox(height: 10,),
                          DefaultButton(text: "Add Prescription", press: (){
                            final uid=FirebaseAuth.instance.currentUser?.uid??'';

                            ref.read(patientIdProvider.notifier).state=patientId;
                            ref.read(patientNameProvider.notifier).state="${map['firstName']} ${map['lastName']}";
                            ref.read(doctorIdProvider.notifier).state=uid;
                            ref.read(doctorNameProvider.notifier).state="${user.firstname} ${user.lastName}";
                            ref.read(selectedPage.notifier).state="Add Prescription";
                          },color: primaryColor,)

                        ],
                      ))
                    ],
                  ),
                )
              ],
            );          },
        );

      },
    );


  }
}
