import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../models/MyFiles.dart';

class PrescriptionCard extends StatelessWidget {
  const PrescriptionCard({
    Key? key,
    required this.name,
    required this.description,
    required this.date,
    this.onTap
  }) : super(key: key);
final String name;
final String date;
final String description;
final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
return InkWell(
  onTap: onTap,
  borderRadius: const BorderRadius.all(Radius.circular(10)),
  child:   Container(
    padding: EdgeInsets.all(defaultPadding),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    child: Row(
      children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Icon(Icons.note_alt_outlined, size: 50, color: primaryColor,),
            ),
          ),
        ),
        SizedBox(width: 5,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              children: [
                Icon(Icons.calendar_month_sharp, size: 14, color: primaryColor,),
                SizedBox(width: 5,),
                Text(
                  date,
                  // DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(map['birthday'].millisecondsSinceEpoch)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        )
      ],
    ),
  ),
);
  }
}

