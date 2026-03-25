import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../constants.dart';


class DefaultButton extends StatefulWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    this.color,
    this.press,
  }) : super(key: key);
  final String text;
  final Function? press;
  final Color? color;

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  final RoundedLoadingButtonController _btnController =
  RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {

    return RoundedLoadingButton(
      controller: _btnController,
      elevation: 7,
      borderRadius: 100.0,
      color: widget.color??primaryColor,
      onPressed:  ()async {
        await widget.press!();
        _btnController.stop();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: AutoSizeText(widget.text,
          maxLines: 1,
          textAlign: TextAlign.center,
          style:TextStyle(
            fontSize: 18,
            color: Colors.white,
          )),
      ),
    );
  }
}
