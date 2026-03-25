import 'package:eac_patient/screens/widgets/MyCardGridView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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


class AllDoctorsScreen extends ConsumerWidget {
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

                },
              ),
            ),
            SizedBox(width: 10,),
            Text(
              "My Doctors",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Expanded(child: SizedBox()),
            DefaultButton(text: "Find New Doctor", press: (){
              ref.read(selectedPage.notifier).state="FindDoctor";
            },)

          ],
        ),
        SizedBox(height: defaultPadding),

        List()
      ],
    );
  }
}

class List extends StatelessWidget {
  const List({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataSnapshot>(
      future: FirebaseDatabase.instance.ref().child("mydctr").child(FirebaseAuth.instance.currentUser?.uid??'').get(),
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
        return  MyCardGridView(
          crossAxisCount: Responsive.isDesktop(context)?2:1,
          childAspectRatio: 4,
          children: snapshot.data!.children.map((e){


            return  Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                      child: InkWell(
                          child: MyDoctorCardPic(id: e.key??'')));
          }).toList(),
        );
      },
    );
  }
}

