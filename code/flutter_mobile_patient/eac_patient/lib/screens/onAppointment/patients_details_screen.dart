import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'components/ai_setup.dart';
import "components/config.dart" as config;
import '../../constants.dart';
import '../../helper/chat_core/firebase_chat_core.dart';
import '../../responsive.dart';

import '../../riverpod/general_riverpod.dart';

import '../widgets/default_button.dart';
import '../widgets/header.dart';
import '../widgets/header_profile.dart';
import '../widgets/notification_body.dart';
import '../widgets/patient_card_details.dart';

import 'components/join_channel.dart';
import 'components/log_sink.dart';
import 'components/readings.dart';





class OnAppointment extends HookConsumerWidget {
  const OnAppointment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: () {
                  ref.read(selectedPage.notifier).state="Chat";

                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "On Going Appointment",
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
          child: Column(
            children: [
              SizedBox(
                  height: 500,
                  child: JoinChannelVideo()),
              Flex(
                direction: Responsive.isDesktop(context)?Axis.horizontal:Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: Responsive.isDesktop(context)?1:0,
                    child: Readings(),
                  ),

                  SizedBox(
                    height: defaultPadding,
                    width: defaultPadding * 4,
                  ),
                  Expanded(
                      flex: Responsive.isDesktop(context)?1:0,
                      child: AiSetUp())
                ],
              )
            ],
          ),
        )
      ],
    );


  }
}
