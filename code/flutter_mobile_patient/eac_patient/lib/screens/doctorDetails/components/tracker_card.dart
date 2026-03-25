import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants.dart';
import '../../../models/MyFiles.dart';

class TrackerCard extends StatelessWidget {
  const TrackerCard({
    Key? key,
    required this.name,
    required this.details,
    required this.percent
  }) : super(key: key);
  final String percent;
  final String name;
  final String details;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SizedBox(
          width: 128,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    percent,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 32),
                  ),
                  SizedBox(width: 10,),
                  Text(
                    name,
                    style: TextStyle(
                        color: Color(0xFF818BA0),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )
                ],
              ),
              Row(

                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    padding: EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      color: Color(0xFF0F67FE),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  Text(
                    details,
                    style: TextStyle(
                        color: Color(0xFF818BA0),
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  )

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
