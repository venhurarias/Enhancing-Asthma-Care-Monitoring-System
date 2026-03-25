import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eac_patient/screens/widgets/default_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants.dart';
import '../../../models/MyFiles.dart';
import '../../../riverpod/general_riverpod.dart';

class ScheduleCard extends ConsumerWidget {
  const ScheduleCard({
    Key? key,
    required this.name,
    required this.date,
    required this.time,
    required this.pic,
    required this.scheduleId,
    this.desc="",
  }) : super(key: key);

final String name;
final String date;
final String time;
  final String desc;
  final String pic;
  final String scheduleId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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


          TextButton(
            child: Text("Show Details"),
            onPressed: (){
              ref.read(scheduleIdProvider.notifier).state=scheduleId;
              ref.read(selectedPage.notifier).state="Appointment Details";
            },
          )

        ],
      ),
    );
  }
}

