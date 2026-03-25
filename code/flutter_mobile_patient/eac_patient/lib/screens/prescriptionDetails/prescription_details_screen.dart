import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../constants.dart';
import '../../helper/chat_core/firebase_chat_core.dart';
import '../../responsive.dart';

import '../../riverpod/general_riverpod.dart';
import '../onAppointment/components/my_line_graph.dart';

import '../widgets/default_button.dart';
import '../widgets/header.dart';
import '../widgets/header_profile.dart';
import '../widgets/notification_body.dart';
import '../widgets/patient_card_details.dart';



class PrescriptionDetailsScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prescriptionName=ref.watch(prescriptionNameProvider);
    final prescription=ref.watch(prescriptionProvider);
    final prescriptionNote=ref.watch(prescriptionNoteProvider);

    final reason=useTextEditingController();
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
                  ref.read(selectedPage.notifier).state="Prescription";
                },
              ),
            ),
            SizedBox(width: 10,),
            Text(
              "Patient Detail",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18),
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(prescription),
                  ),
                ),
              ),
              Text(
                "NOTES:",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                prescriptionNote,

              ),
            ],
          ),
        )
      ],
    );

  }
}
