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
import 'components/tracker_card.dart';


class PatientsDetailsScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleId=ref.watch(scheduleIdProvider);
    final reason=useTextEditingController();
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('schedule').doc(scheduleId).get(),
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
                "You still don't have doctor",
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
                "You still don't have doctor",
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
                                constraints: BoxConstraints(maxHeight: 100),
                                child: MyPatientCardDetails(name: map['patient name'],pic: map['patient pic'],)),
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
                            "About",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            map["full details"],

                          ),
                          SizedBox(height: 20,),

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
                          Text(
                            "Appointment",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Icon(Icons.calendar_month_outlined, size: 14,),
                              Text(
                                DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(map['appointment date'].millisecondsSinceEpoch)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(width: 10,),
                              Icon(Icons.timer_outlined, size: 14,),
                              Text(
                                DateFormat('HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(map['appointment date'].millisecondsSinceEpoch)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          if(map["status"]=="pending")
                            Row(
                              children: [
                                InkWell(
                                  onTap: ()async{
                                    final Room room = await FirebaseChatCore.instance.createRoom(
                                        patientId: map["patient"],
                                        device: map['device'],
                                        patientImage: map["patient pic"],
                                        doctorImage: map["doctor pic"]);
                                    ref.read(roomProvider.notifier).state=room;
                                    ref.read(selectedPage.notifier).state="Chat";
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xFFE8F3F1),
                                        borderRadius: BorderRadius.all(Radius.circular(15))),
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        child: Icon(Icons.chat_outlined, color: primaryColor,)),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(child: DefaultButton(text: "Accept", press: ()async{
                                  final uid=FirebaseAuth.instance.currentUser?.uid??'';
                                  await FirebaseFirestore.instance.collection('schedule').doc(scheduleId).update({
                                    "status":"ongoing",
                                  });
                                  await FirebaseDatabase.instance.ref().child("myptnc").child(uid).child(map["patient"]).set(true);
                                  await FirebaseDatabase.instance.ref().child("mydctr").child(map["patient"]).child(uid).set(true);
                                },color: primaryColor,)),
                                SizedBox(width: 10,),
                                Expanded(child: DefaultButton(text: "Reject", press: (){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return WarningCancelDialog(
                                          title: "Warning",
                                          description: "Are you want to cancel the appointment?",
                                          controller: reason,
                                          proceedPress:()async{
                                            if(reason.text.isEmpty){
                                              InAppNotification.show(
                                                child: const NotificationBody(
                                                  msg: "Please input reason",
                                                ),
                                                context: context,
                                              );
                                              return;
                                            }
                                            await FirebaseFirestore.instance.collection('schedule').doc(scheduleId).update({
                                              "status":"cancelled",
                                              "reason":reason.text.trim()
                                            });
                                            Navigator.of(context).pop();
                                          }
                                      ); // Your custom dialog widget
                                    },
                                  );
                                },color: Colors.red,))
                              ],
                            ),

                          if(map["status"]=="ongoing")
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final Room room = await FirebaseChatCore.instance.createRoom(
                                        patientId: map["patient"],
                                        patientImage: map["patient pic"],
                                        device: map['device'],
                                        doctorImage: map["doctor pic"]);
                                    ref.read(roomProvider.notifier).state=room;
                                    ref.read(selectedPage.notifier).state="Chat";
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xFFE8F3F1),
                                        borderRadius: BorderRadius.all(Radius.circular(15))),
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        child: Icon(Icons.chat_outlined, color: primaryColor,)),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  flex:5,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child: DefaultButton(text: "Cancel", press: (){
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return WarningCancelDialog(
                                                    title: "Warning",
                                                    description: "Are you want to cancel the appointment?",
                                                    controller: reason,
                                                    proceedPress:()async{
                                                      if(reason.text.isEmpty){
                                                        InAppNotification.show(
                                                          child: const NotificationBody(
                                                            msg: "Please input reason",
                                                          ),
                                                          context: context,
                                                        );
                                                        return;
                                                      }
                                                      await FirebaseFirestore.instance.collection('schedule').doc(scheduleId).update({
                                                        "status":"cancelled",
                                                      });
                                                      Navigator.of(context).pop();
                                                    }
                                                ); // Your custom dialog widget
                                              },
                                            );
                                          },color: Colors.red,)),
                                          SizedBox(width: 10,),
                                          Expanded(child: DefaultButton(text: "Reschedule", press: (){
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return WarningRescheduleDialog(
                                                  title: "Warning",
                                                  description: "Are you want to reschedule the appointment?",
                                                  controller: reason,
                                                  scheduleId: scheduleId,
                                                ); // Your custom dialog widget
                                              },
                                            );
                                          },))
                                        ],
                                      ),
                                      DefaultButton(text: "Set as Completed", press: (){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return WarningDialog(
                                                title: "Warning",
                                                description: "Are you want to set the appointment as completed?",
                                                proceedPress:()async{
                                                  await FirebaseFirestore.instance.collection('schedule').doc(scheduleId).update({
                                                    "status":"completed",
                                                  });
                                                  Navigator.of(context).pop();
                                                }
                                            ); // Your custom dialog widget
                                          },
                                        );
                                      },color: primaryColor,),

                                    ],
                                  ),
                                )
                              ],
                            ),

                          if(map["status"]=="completed")
                            InkWell(
                              onTap: ()async{
                                print("create room");

                                final Room room = await FirebaseChatCore.instance.createRoom(

                                    patientId: map["patient"],
                                    patientImage: map["patient pic"],
                                    device: map['device'],
                                    doctorImage: map["doctor pic"]);
                                ref.read(roomProvider.notifier).state=room;
                                ref.read(selectedPage.notifier).state="Chat";

                                print("done create");
                              },
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xFFE8F3F1),
                                        borderRadius: BorderRadius.all(Radius.circular(15))),
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        child: Icon(Icons.chat_outlined, color: primaryColor,)),
                                  ),
                                  SizedBox(width: 10,),
                                  Text("Send Message")
                                ],
                              ),
                            ),

                          DefaultButton(text: "Add Prescription", press: (){
                            print(map["patient"]);
                            print(map["patient name"]);
                            print(map["doctor"]);
                            print(map["doctor name"]);
                            ref.read(patientIdProvider.notifier).state=map["patient"];
                            ref.read(patientNameProvider.notifier).state=map["patient name"];
                            ref.read(doctorIdProvider.notifier).state=map["doctor"];
                            ref.read(doctorNameProvider.notifier).state=map["doctor name"];
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
