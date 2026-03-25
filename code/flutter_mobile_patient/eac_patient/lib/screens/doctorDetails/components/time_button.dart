import 'package:eac_patient/constants.dart';
import 'package:flutter/material.dart';

class TimeButton extends StatelessWidget {
  const TimeButton({Key? key, this.disable=false, required this.value, required this.selected, this.onTap}) : super(key: key);
  final bool disable;
  final String value;
  final String selected;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          onTap: disable?null:onTap,
          child: Container(
              decoration: BoxDecoration(
                color: value==selected?primaryColor:Colors.white,
                  border: Border.all(
                    color: primaryColor,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child:  Text(
                  value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: value==selected?Colors.white:Colors.black87),
                ),
              )
          ),
        ),
      ),
    );
  }
}
