import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eac_patient/screens/widgets/MyCardGridView.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../constants.dart';
import '../../responsive.dart';

import '../../riverpod/general_riverpod.dart';
import '../widgets/default_button.dart';
import '../widgets/header.dart';
import '../widgets/header_profile.dart';
import 'components/doctor_card_pic.dart';


class FindDoctorsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  ref.read(selectedPage.notifier).state="Doctor";

                },
              ),
            ),
            SizedBox(width: 10,),
            Text(
              "Find Doctors",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Expanded(child: SizedBox()),

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

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('doctor').get(),
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
                "No doctors available",
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
          child: InkWell(
            onTap: (){
              ref.read(selectedPage.notifier).state="Doctor Details";
              ref.read(doctorNameProvider.notifier).state="${map['firstName']} ${map['lastName']}";
              ref.read(doctorTypeProvider.notifier).state=map['type'];
              ref.read(doctorDescriptionProvider.notifier).state=map['description'];
              ref.read(doctorPicProvider.notifier).state=map['pic'];
              ref.read(doctorUidProvider.notifier).state=document.id;

            },
            child: MyDoctorCardPic(
                name: "${map['firstName']} ${map['lastName']}",
                type: map['type'],
            pic: map['pic'],),
          ));

          }).toList(),
        );
      },
    );
  }
}
