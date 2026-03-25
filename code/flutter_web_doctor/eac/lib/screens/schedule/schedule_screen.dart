import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eac/screens/widgets/MyCardGridView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../constants.dart';
import '../../responsive.dart';

import 'components/schedule_card.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding ),
          child: Row(
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
        ),
        SizedBox(height: defaultPadding),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding*2),
            child: Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFE8F3F1),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ButtonsTabBar(
                        backgroundColor: primaryColor,
                        unselectedBackgroundColor: Color(0xFFE8F3F1),
                        unselectedLabelStyle:
                        TextStyle(color: Colors.black),
                        labelStyle: TextStyle(
                            color: Color(0xFFE8F3F1),
                            fontWeight: FontWeight.bold),
                        tabs: [
                          Tab(
                            text: " Pending ",
                          ),
                          Tab(
                            text: " Upcoming ",
                          ),
                          Tab(
                            text: " Completed ",
                          ),
                          Tab(text:" Canceled "),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: AlwaysScrollableScrollPhysics(),
                        children: [
                          ListPending(),
                          ListOngoing(),
                          ListCompleted(),
                          ListCancelled()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ListPending extends StatelessWidget {
  const ListPending({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid=FirebaseAuth.instance.currentUser?.uid??'';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('schedule').where("doctor",isEqualTo: uid).where("status", isEqualTo: "pending").snapshots(),
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

        return  MyCardGridView(
          physics: AlwaysScrollableScrollPhysics(),
          childAspectRatio: 2,
          crossAxisCount: Responsive.isDesktop(context)?2:1,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {

            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            String formattedDate = DateFormat('yyyy-MM-dd').format(
              DateTime.fromMillisecondsSinceEpoch(data['appointment date'].millisecondsSinceEpoch),
            );

            String formattedTime = DateFormat('HH:mm:ss').format(
              DateTime.fromMillisecondsSinceEpoch(data['appointment date'].millisecondsSinceEpoch),
            );
            return ScheduleCard(
              name: data['patient name'],
              date: formattedDate,
              time: formattedTime,
              desc: data['reason'],
              pic: data['patient pic'],
                showAcceptBtn: true,
                scheduleId: document.id,
                patientId: data['patient']
            );
          }).toList(),
        );
      },
    );
  }
}


class ListOngoing extends StatelessWidget {
  const ListOngoing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid=FirebaseAuth.instance.currentUser?.uid??'';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('schedule').where("doctor",isEqualTo: uid).where("status", isEqualTo: "ongoing").snapshots(),
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

        return  MyCardGridView(
          physics: AlwaysScrollableScrollPhysics(),
          childAspectRatio: 1.7,
          crossAxisCount: Responsive.isDesktop(context)?2:1,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {

            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            String formattedDate = DateFormat('yyyy-MM-dd').format(
              DateTime.fromMillisecondsSinceEpoch(data['appointment date'].millisecondsSinceEpoch),
            );

            String formattedTime = DateFormat('HH:mm:ss').format(
              DateTime.fromMillisecondsSinceEpoch(data['appointment date'].millisecondsSinceEpoch),
            );
            return ScheduleCard(
              name: data['patient name'],
              date: formattedDate,
              time: formattedTime,
              desc: data['reason'],
              pic: data['patient pic'],
                scheduleId: document.id,
                patientId: data['patient'],
              showRescheduleBtn: true,
              showCompletedBtn: true,
            );
          }).toList(),
        );
      },
    );
  }
}


class ListCompleted extends StatelessWidget {
  const ListCompleted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid=FirebaseAuth.instance.currentUser?.uid??'';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('schedule').where("doctor",isEqualTo: uid).where("status", isEqualTo: "completed").snapshots(),
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

        return  MyCardGridView(
          physics: AlwaysScrollableScrollPhysics(),
          childAspectRatio: 2.5,
          crossAxisCount: Responsive.isDesktop(context)?2:1,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {

            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            String formattedDate = DateFormat('yyyy-MM-dd').format(
              DateTime.fromMillisecondsSinceEpoch(data['appointment date'].millisecondsSinceEpoch),
            );

            String formattedTime = DateFormat('HH:mm:ss').format(
              DateTime.fromMillisecondsSinceEpoch(data['appointment date'].millisecondsSinceEpoch),
            );
            return ScheduleCard(
              name: data['patient name'],
              date: formattedDate,
              time: formattedTime,
              pic: data['patient pic'],
                scheduleId: document.id,
                patientId: data['patient']
            );
          }).toList(),
        );
      },
    );
  }
}


class ListCancelled extends StatelessWidget {
  const ListCancelled({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid=FirebaseAuth.instance.currentUser?.uid??'';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('schedule').where("doctor",isEqualTo: uid).where("status", isEqualTo: "cancelled").snapshots(),
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

        return  MyCardGridView(
          physics: AlwaysScrollableScrollPhysics(),
          childAspectRatio: 2.5,
          crossAxisCount: Responsive.isDesktop(context)?2:1,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {

            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            String formattedDate = DateFormat('yyyy-MM-dd').format(
              DateTime.fromMillisecondsSinceEpoch(data['appointment date'].millisecondsSinceEpoch),
            );

            String formattedTime = DateFormat('HH:mm:ss').format(
              DateTime.fromMillisecondsSinceEpoch(data['appointment date'].millisecondsSinceEpoch),
            );
            return ScheduleCard(
              name: data['patient name'],
              date: formattedDate,
              time: formattedTime,
              pic: data['patient pic'],
                scheduleId: document.id,
                patientId: data['patient']
            );
          }).toList(),
        );
      },
    );
  }
}

