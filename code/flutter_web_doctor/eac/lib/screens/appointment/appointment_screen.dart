import 'package:eac/screens/widgets/MyCardGridView.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../constants.dart';
import '../../responsive.dart';

import '../widgets/default_button.dart';
import '../widgets/header.dart';
import '../widgets/header_profile.dart';
import '../widgets/patient_card_details.dart';

class AppointmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: () {},
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Appointment",
              style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Flex(
            direction: Responsive.isDesktop(context)?Axis.horizontal:Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: Responsive.isDesktop(context)?1:0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        constraints: BoxConstraints(maxHeight: 100),
                        child: MyPatientCardDetails(
                          name: "John Venhur Arias",
                          pic: "",
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Date",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              "Change",
                              style: TextStyle(color: Colors.black26),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFE8F3F1),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(15))),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Icon(
                                Icons.calendar_month_sharp,
                                color: primaryColor,
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Wednesday, Aug 23, 2023| 10:00AM",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Reason",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              "Change",
                              style: TextStyle(color: Colors.black26),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFE8F3F1),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(15))),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Icon(
                                Icons.pending_actions,
                                color: primaryColor,
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Chest Pain",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: defaultPadding,
                width: defaultPadding * 4,
              ),
              Expanded(
                  flex: Responsive.isDesktop(context)?1:0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Other Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam... Read more",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      DefaultButton(
                        text: "Accept Appointment",
                        press: () {},
                      )
                    ],
                  ))
            ],
          ),
        )
      ],
    );
  }
}
