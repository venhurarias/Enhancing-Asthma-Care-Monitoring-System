import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';



class MyFullPatientCardDetails extends StatelessWidget {
  const MyFullPatientCardDetails({
    Key? key,
    required this.name,
    required this.pic,
    required this.gender,
    required this.address,
    required this.birthday


  }) : super(key: key);

final String name;
final String pic;
final String gender;
final String address;
final String birthday;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(pic),
              ),
            ),
          ),
          SizedBox(width: 5,),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
            Row(
              children: [
                Icon(gender=="Male"?Icons.male_outlined:Icons.female_outlined, size: 14, color: primaryColor,),
                SizedBox(width: 5,),
                Text(
                  gender,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.cake_outlined, size: 14, color: primaryColor,),
                SizedBox(width: 5,),
                Text(
                  birthday,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            Row(
              children: [
                Icon(Icons.map_outlined, size: 14, color: primaryColor,),
                SizedBox(width: 5,),
                Text(
                  address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
                ]
          )
                )
        ],
      ),
    );
  }
}

