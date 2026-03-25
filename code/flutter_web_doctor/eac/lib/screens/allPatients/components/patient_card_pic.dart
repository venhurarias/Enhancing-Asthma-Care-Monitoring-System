import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../models/MyFiles.dart';
import '../../../riverpod/general_riverpod.dart';

class MyPatientCardPic extends ConsumerWidget {
  const MyPatientCardPic({
    Key? key,
    required this.id


  }) : super(key: key);

final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('patient').doc(id).get(),
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
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTap: (){
            ref.read(patientIdProvider.notifier).state=id;
            ref.read(selectedPage.notifier).state="My Patient Details";

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
                    Row(
                      children: [
                        Icon(map['gender']=="Male"?Icons.male_outlined:Icons.female_outlined, size: 14, color: primaryColor,),
                        SizedBox(width: 5,),
                        Text(
                          map['gender'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.cake_outlined, size: 14, color: primaryColor,),
                        SizedBox(width: 5,),
                        Text(
                          DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(map['birthday'].millisecondsSinceEpoch)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(Icons.map_outlined, size: 14, color: primaryColor,),
                        SizedBox(width: 5,),
                        Text(
                          map['address'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
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

