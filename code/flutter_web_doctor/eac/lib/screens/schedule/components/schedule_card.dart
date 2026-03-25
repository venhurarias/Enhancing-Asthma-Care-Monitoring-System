import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eac/screens/schedule/components/warning_cancel_modal.dart';
import 'package:eac/screens/schedule/components/warning_modal.dart';
import 'package:eac/screens/schedule/components/warning_resched_modal.dart';
import 'package:eac/screens/widgets/default_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../models/MyFiles.dart';
import '../../../riverpod/general_riverpod.dart';
import '../../widgets/custom_modal.dart';
import '../../widgets/notification_body.dart';

class ScheduleCard extends HookConsumerWidget {
  const ScheduleCard({
    Key? key,
    required this.name,
    required this.date,
    required this.time,
    required this.pic,
    this.showAcceptBtn=false,
    this.showRescheduleBtn=false,
    this.showCompletedBtn=false,
    this.desc="",
    required this.scheduleId,
    required this.patientId

  }) : super(key: key);

final String name;
final String date;
final String time;
final String desc;
final String pic;
  final bool showAcceptBtn;
  final bool showRescheduleBtn;
  final String scheduleId;
  final String patientId;
  final bool showCompletedBtn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reason=useTextEditingController();

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Color(0xFFE8F3F1))
      ),
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        desc,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: SizedBox(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(pic),
                    ),
                  ),
                )
              ],
            ),
          ),

          Expanded(
            flex: 5,
            child: Row(
              children: [
                Icon(Icons.calendar_month_outlined, size: 14,),
                Text(
                  date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(width: 10,),
                Icon(Icons.timer_outlined, size: 14,),
                Text(
                  time,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

              ],
            ),
          ),
          if(showRescheduleBtn)
            Expanded(
              flex: 6,
              child: Row(
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
            ),
          if(showAcceptBtn)
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Expanded(child: DefaultButton(text: "Accept", press: ()async{
                    final uid=FirebaseAuth.instance.currentUser?.uid??'';
                    await FirebaseFirestore.instance.collection('schedule').doc(scheduleId).update({
                      "status":"ongoing",
                    });
                    await FirebaseDatabase.instance.ref().child("myptnc").child(uid).child(patientId).set(true);
                    await FirebaseDatabase.instance.ref().child("mydctr").child(patientId).child(uid).set(true);
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
            ),
          if(showCompletedBtn)
            SizedBox(height: 5,),
          if(showCompletedBtn)
            Expanded(
              flex:5,
              child: DefaultButton(text: "Set as Completed", press: (){
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
            ),
          TextButton(
            child: Text("Show Details"),
            onPressed: (){
              ref.read(scheduleIdProvider.notifier).state=scheduleId;
              ref.read(selectedPage.notifier).state="Patient Details";
            },
          )
        ],
      ),
    );
  }
}

