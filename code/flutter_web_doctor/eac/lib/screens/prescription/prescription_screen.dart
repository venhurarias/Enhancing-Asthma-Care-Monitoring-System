import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eac/screens/widgets/MyCardGridView.dart';
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
import 'components/prescription_card.dart';


class PrescriptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(

          children: [
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: defaultPadding),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: (){

                },
              ),
            ),
            SizedBox(width: 10,),
            Text(
              "Prescription",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),

          ],
        ),
        SizedBox(height: defaultPadding),
        List()
      ],
    );
  }
}

class List extends ConsumerWidget {
  const List({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid=FirebaseAuth.instance.currentUser?.uid??'';

    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('prescription').where("doctor",isEqualTo: uid).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
        if (!(snapshot.hasData)) {
          return Column(
            children: const [
              SizedBox(height: 10),
              Text(
                "You still don't have prescription",
                style: TextStyle(color: primaryColor),
              ),
            ],
          );
        }
        return  MyCardGridView(
          crossAxisCount: Responsive.isDesktop(context)?2:1,
          childAspectRatio: 4,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String,dynamic> map=document.data() as Map<String, dynamic>;
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: PrescriptionCard(
                    name:map['patient name'],
                    description: map['name'],
                    date: DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(map['createdAt'].millisecondsSinceEpoch)),
                    onTap: (){
                      ref.read(prescriptionNameProvider.notifier).state=map["name"];
                      ref.read(prescriptionProvider.notifier).state=map["prescription"];
                      ref.read(prescriptionNoteProvider.notifier).state=map["notes"];
                      ref.read(selectedPage.notifier).state="Prescription Details";
                    },
                  ));

            }).toList()

        );
      },
    );
  }
}

