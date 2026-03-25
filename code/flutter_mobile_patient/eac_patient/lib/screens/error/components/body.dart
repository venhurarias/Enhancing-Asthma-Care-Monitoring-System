import 'package:flutter/material.dart';




class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(flex: 8,child: SizedBox()),
            Center(
              child: Image.asset(
                "assets/images/logo.png",
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "An Unknown error has occurred. Please restart the application.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(flex: 10,child: SizedBox()),
          ],
        ),
      ),
    );
  }

}
