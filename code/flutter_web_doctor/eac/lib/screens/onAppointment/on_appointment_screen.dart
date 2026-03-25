
import 'package:eac/screens/onAppointment/components/join_channel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants.dart';
import '../../responsive.dart';
import '../../riverpod/general_riverpod.dart';
import '../widgets/default_button.dart';
import '../widgets/patient_card_details.dart';
import 'components/ai_setup.dart';
import 'components/my_line_graph.dart';
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
