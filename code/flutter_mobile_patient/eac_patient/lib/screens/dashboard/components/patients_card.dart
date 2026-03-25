import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import '../../../models/MyFiles.dart';

class PatientsCard extends StatelessWidget {
  const PatientsCard({
    Key? key,
    required this.date,
    required this.name,
    required this.time
  }) : super(key: key);

  final String name;
  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
        ],
      ),
    );
  }
}

