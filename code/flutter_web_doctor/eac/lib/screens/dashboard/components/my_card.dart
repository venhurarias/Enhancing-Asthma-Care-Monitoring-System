import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants.dart';
import '../../../models/MyFiles.dart';

class MyCard extends StatelessWidget {
  const MyCard({
    Key? key,
    required this.title,
    required this.smallDesc,
    this.color=Colors.black,
    required this.icon
  }) : super(key: key);

  final String title;
  final String smallDesc;
  final Color color;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FaIcon(icon,size: 40,color: color,),
          Text(
            title,
            maxLines: 1,
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)
          ),
          Text(
            smallDesc,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white70),
          )
        ],
      ),
    );
  }
}

