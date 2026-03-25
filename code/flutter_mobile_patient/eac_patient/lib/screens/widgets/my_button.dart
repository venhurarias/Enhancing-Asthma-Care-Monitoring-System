import 'package:flutter/material.dart';

import '../../constants.dart';


class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.yellow.shade100),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: (){},
          child: child,
        ),
      ),
    );
  }
}
