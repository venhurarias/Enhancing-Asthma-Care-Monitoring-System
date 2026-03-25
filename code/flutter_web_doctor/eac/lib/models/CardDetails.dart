import 'package:flutter/material.dart';

class BankDetails {
  final String bankName, userName, bankNumber;
  final Color color;

  BankDetails({required this.bankName,required this.userName,required this.bankNumber, required this.color});
}

List demoBankDetails = [
  BankDetails(
      bankName: "GCASH",
      userName: "John Venhur Arias",
      bankNumber: "09452610868",
      color: Colors.blue
  ),
  BankDetails(
      bankName: "MAYA",
      userName: "John Venhur Arias",
      bankNumber: "09452610868",
      color: Color(0xFF010D23)
  ),
  BankDetails(
      bankName: "BPI",
      userName: "John Venhur Arias",
      bankNumber: "0000 0000 0000 0000",
    color: Color(0xFFAD1F23)
  ),
  BankDetails(
      bankName: "BDO",
      userName: "John Venhur Arias",
      bankNumber: "0000 0000 0000 0000",
    color: Color(0xFF204399)
  )
];
