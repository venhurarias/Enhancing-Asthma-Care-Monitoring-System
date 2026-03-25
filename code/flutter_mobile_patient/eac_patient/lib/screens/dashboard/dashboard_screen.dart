import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eac_patient/screens/widgets/MyCardGridView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../constants.dart';
import '../../responsive.dart';

import '../../riverpod/general_riverpod.dart';
import '../widgets/default_button.dart';
import '../widgets/header.dart';
import '../widgets/header_profile.dart';
import 'components/patients_card.dart';
import 'components/patients_card_proc.dart';


class DashboardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  "Find your desire health solution",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Container(
            decoration: BoxDecoration(
                color: Color(0xFFE8F3F1),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              children: [
                Expanded(flex: 1,child: SizedBox()),
                Expanded(
                    flex: 16,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultPadding, vertical:defaultPadding ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            "Early Protection for\nyour family health",
                            maxLines: 2,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.isDesktop(context)?36:20),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                flex:10,
                                child: DefaultButton(
                                  text: "Learn more",
                                  press: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Container(
                                            width: 360,
                                            height: 500,
                                            constraints: BoxConstraints(maxWidth: 360),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Lottie.asset('assets/lottie/checked.json'),
                                                  SizedBox(height: 20,),
                                                  Text(
                                                    "INFORMATION",
                                                    style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 10,),

                                                  Text(
                                                    """
Our thesis study entitled "Enhancing Asthma Care: An IoT-based Wearable Monitoring System with Edge Computing, Web Application, and Telemedicine Integration," aims to develop an IoT-based wearable asthma monitoring system with edge computing capabilities and a web application that integrates telemedicine and e-prescription features which enables remote monitoring and management of asthmatic patients, providing real-time vital sign measurements and remote communication between patients and physicians.

Proponents: 
Cabagua, Darlene D. 
Cabatuan, Kate C.
Cachuela, Kobe Darryl P.
Dacanay, Denver Van J.
BS Electronics Engineering
                                                    """,
                                                    textAlign: TextAlign.justify,
                                                    style: TextStyle(color: Colors.black87, fontSize: 14),
                                                  ),
                                                  SizedBox(height: 20,),

                                                  DefaultButton(text: "Go to home",press: (){
                                                    Navigator.of(context).pop();
                                                  },),


                                                ],
                                              ),
                                            ),
                                          ),
                                        ); // Your custom dialog widget
                                      },
                                    );
                                  },
                                ),
                              ),
                              Expanded(flex:12,child: SizedBox())
                            ],
                          )
                        ],
                      ),
                    )),
                Expanded(
                    flex: 6,
                    child: Lottie.asset(
                        'assets/lottie/doctor2.json')),
                Expanded(flex: 1,child: SizedBox()),

              ],
            )),
        SizedBox(height: defaultPadding,),
        Flex(
          direction: Responsive.isDesktop(context)?Axis.horizontal:Axis.vertical,
          children: [
            Expanded(
              flex: Responsive.isDesktop(context)?1:0,
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: defaultPadding,),
                      Expanded(
                        child: Text(
                          "Incoming Appointments",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      SizedBox(width: defaultPadding,),
                      TextButton(onPressed: (){
                        ref.read(selectedPage.notifier).state="Appointment";
                      }, child: Text(
                        "See all",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: primaryColor,decoration: TextDecoration.underline, fontSize: 12),
                      )),
                      SizedBox(width: defaultPadding,),
                    ],
                  ),
                  SizedBox(height: 10,),

                  ListOngoing()
                ],
              ),
            ),
            Expanded(
              flex: Responsive.isDesktop(context)?1:0,
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: defaultPadding,),
                      Expanded(
                        child: Text(
                          "Doctors",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      SizedBox(width: defaultPadding,),
                      TextButton(onPressed: (){
                        ref.read(selectedPage.notifier).state="Doctor";

                      }, child: Text(
                        "See all",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: primaryColor,decoration: TextDecoration.underline, fontSize: 12),
                      )),
                      SizedBox(width: defaultPadding,),
                    ],
                  ),
                  ListDoctor1(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class ListOngoing extends StatelessWidget {
  const ListOngoing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid=FirebaseAuth.instance.currentUser?.uid??'';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('schedule').where("patient",isEqualTo: uid).where("status", isEqualTo: "ongoing").limit(2).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Column(
            children: const [
              SizedBox(height: 10),
              Text(
                "An unknown error has occurred",
                style: TextStyle(color: Colors.red),
              )
            ],
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: const [
              SizedBox(height: 10),
              CircularProgressIndicator(
                color: primaryColor,
              )
            ],
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Column(
            children: const [
              SizedBox(height: 10),
              Text(
                "No Schedule to show",
                style: TextStyle(color: primaryColor),
              ),
            ],
          );
        }

        return  Column(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {

            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            String formattedDate = DateFormat('yyyy-MM-dd').format(
              DateTime.fromMillisecondsSinceEpoch(data['appointment date'].millisecondsSinceEpoch),
            );

            String formattedTime = DateFormat('HH:mm:ss').format(
              DateTime.fromMillisecondsSinceEpoch(data['appointment date'].millisecondsSinceEpoch),
            );
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding,vertical: 5),
                child: PatientsCard(name: data['patient name'], date: formattedDate, time: formattedTime));
          }).toList(),
        );
      },
    );
  }
}


class ListDoctor1 extends StatelessWidget {
  const ListDoctor1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser?.uid);
    return FutureBuilder<DataSnapshot>(
      future: FirebaseDatabase.instance.ref().child("mydctr").child(FirebaseAuth.instance.currentUser?.uid??'').limitToFirst(2).get(),
      builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Column(
            children: const [
              SizedBox(height: 10),
              Text(
                "An unknown error has occurred",
                style: TextStyle(color: Colors.red),
              )
            ],
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: const [
              SizedBox(height: 10),
              CircularProgressIndicator(
                color: primaryColor,
              )
            ],
          );
        }
        if (!(snapshot.data?.exists??false)) {
          return Column(
            children: const [
              SizedBox(height: 10),
              Text(
                "You still don't have doctor",
                style: TextStyle(color: primaryColor),
              ),
            ],
          );
        }
        return  Column(
          children: snapshot.data!.children.map((e){
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding,vertical: 5),
                child: PatientsCardProc(id:e.key??''));
          }).toList(),
        );
      },
    );
  }
}
