import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants.dart';
import '../../../models/MyFiles.dart';
import '../../../riverpod/general_riverpod.dart';

class MyDoctorCardPic extends ConsumerWidget {
  const MyDoctorCardPic({
    Key? key,
    required this.id,

  }) : super(key: key);

final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('doctor').doc(id).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
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
        if (!snapshot.hasData) {
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
        Map<String,dynamic>? map=snapshot.data?.data();
        if(map==null){
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
        return InkWell(
          onTap: (){
            ref.read(selectedPage.notifier).state="Doctor Details";
            ref.read(doctorNameProvider.notifier).state="${map['firstName']} ${map['lastName']}";
            ref.read(doctorTypeProvider.notifier).state=map['type'];
            ref.read(doctorDescriptionProvider.notifier).state=map['description'];
            ref.read(doctorPicProvider.notifier).state=map['pic'];
            ref.read(doctorUidProvider.notifier).state=id;
          },
          child: Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(map['pic']),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${map['firstName']} ${map['lastName']}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      map['type'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black38),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );

  }
}

