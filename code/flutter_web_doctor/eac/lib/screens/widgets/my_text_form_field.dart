

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';


class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    Key? key,
    this.enabled = true,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.controller,
    this.focusNode,
    this.validator,
    this.onFieldSubmitted,
    this.onSaved,
    this.autocorrect = false,
    this.autofillHints,
    this.prefixText,
    this.inputFormatters,
    this.readOnly=false,
    this.maxLines=1,
    this.onTap,
    this.errorText
  })  :super(key: key);
  final bool enabled;
  final bool autocorrect;
  final Iterable<String>? autofillHints;
  final String? labelText;
  final Widget? prefixIcon;
  final String? prefixText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final bool? readOnly;
  final int? maxLines;
  final void Function()? onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      inputFormatters: inputFormatters,
      textAlignVertical: TextAlignVertical.center,
      maxLength: maxLines==1?32:255,
      cursorColor: secondaryColor,
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        // hintStyle: TextStyle(color: Colors.black45),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: labelText,
        // label: Text(widget.labelText??'',style: TextStyle(height: 2, fontSize: 12, color: Colors.black54),),
        prefixIcon: prefixIcon,
        prefixText: prefixText,
        counterText: "",
        filled: true,
        errorText: errorText,
        errorStyle: TextStyle(color: Colors.white,),
        errorMaxLines: 10,
        fillColor: Color(0x05000000),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        labelStyle: TextStyle(height: 1,fontSize: 14, color: Colors.black54),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.black12,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.black12,

          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Colors.red.shade700,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Colors.red.shade400,
          ),
        ),
        disabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      validator: validator,
      enabled: enabled,
      autocorrect: autocorrect,
      autofillHints: autofillHints,
      readOnly: readOnly??false,
      style: TextStyle(fontSize: 14,),
      maxLines: maxLines,
    );
  }
}

