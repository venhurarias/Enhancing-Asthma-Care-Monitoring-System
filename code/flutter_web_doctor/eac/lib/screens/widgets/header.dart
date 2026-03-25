import 'package:flutter/material.dart';

import '../../constants.dart';


class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return                   Column(
      children: [
        Row(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Image.asset("assets/images/logo_only.png")),
            Text(
              "E.A.C",
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 26),
            )
          ],
        ),
        Divider(
          color: primaryColor,
          thickness: 1.5,
        )
      ],
    );
  }
}
