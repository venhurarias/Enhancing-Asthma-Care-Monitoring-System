import 'package:cloud_firestore/cloud_firestore.dart';
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


import '../widgets/default_button.dart';
import '../widgets/header.dart';
import '../widgets/header_profile.dart';
import '../widgets/notification_body.dart';
import 'components/category_card.dart';
import '../widgets/patient_card_details.dart';
import 'components/tracker_card.dart';


class AppointmentDetailsScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleId=ref.watch(scheduleIdProvider);
    final reason=useTextEditingController();
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('schedule').doc(scheduleId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
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
        if (!snapshot.hasData) {
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
        Map<String,dynamic>? map=snapshot.data?.data();
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
                      ref.read(selectedPage.notifier).state="Schedule";
                    },
                  ),
                ),
                SizedBox(width: 10,),
                Text(
                  "Doctor Detail",
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
                            child: MyPatientCardDetails(name: map['doctor name'],pic: map['doctor pic'],)),
                        SizedBox(height: 20,),
                        CategoryCard(name: "Astma",iconData: FontAwesomeIcons.lungs,),
                        SizedBox(height: 10,),
                        CategoryCard(name: "Heart Rate",iconData: FontAwesomeIcons.chartLine,),
                        SizedBox(height: 10,),
                        CategoryCard(name: "Preciption",iconData: FontAwesomeIcons.lungs,),
                        SizedBox(height: 30,),
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
                        )

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
                      TrackerCard(percent: "95%", name: "Sp02", details: "Avg Sp02",),
                      SizedBox(height: 10,),
                      TrackerCard(percent: "80", name: "bpm", details: "Avg Heart Rate",),
                      SizedBox(height: 10,),

                      InkWell(
                          onTap: ()async{
                            final Room room = await FirebaseChatCore.instance.createRoom(
                                doctorId: map["doctor"],
                                patientImage: map["patient pic"],
                                doctorImage: map["doctor pic"]);
                            ref.read(roomProvider.notifier).state=room;
                            ref.read(selectedPage.notifier).state="Chat";


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


                    ],
                  ))
                ],
              ),
            )
          ],
        );
      },
    );


  }
}
