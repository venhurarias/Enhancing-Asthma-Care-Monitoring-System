import 'package:flutter/material.dart';

import '../../../constants.dart';



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
                // width: getProportionateScreenWidth(235),
              ),
            ),
            SizedBox(height: 20),
            const Center(
              child: CircularProgressIndicator(color: Colors.white,),
            ),
            Expanded(flex: 10,child: SizedBox()),
          ],
        ),
      ),
    );
  }

}
