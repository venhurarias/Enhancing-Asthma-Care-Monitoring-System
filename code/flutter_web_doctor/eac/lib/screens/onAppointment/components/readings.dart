import 'package:eac/helper/assist.dart';
import 'package:eac/screens/onAppointment/components/peak_flow.dart';
import 'package:eac/screens/widgets/default_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants.dart';
import '../../../riverpod/general_riverpod.dart';
import '../../widgets/patient_card_details.dart';
import 'my_line_graph.dart';

class Readings extends ConsumerWidget {
  const Readings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(roomProvider);
    print(room?.metadata);
    print("Device ::  ${room?.metadata?['device']}");
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance
          .ref()
          .child("d")
          .child(room?.metadata?['device'])
          .child('r')
          .orderByChild('Ts')
          .limitToLast(20)
          .onValue,
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
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
        if (!(snapshot.data?.snapshot.exists ?? false)) {
          return Column(
            children: const [
              SizedBox(height: 10),
              Text(
                "You still don't have reading",
                style: TextStyle(color: primaryColor),
              ),
            ],
          );
        }
        List list = (snapshot.data!.snapshot.value as Map).values.toList();
        List<int> tsList = [];
        List<int> hList = [];
        List<int> oList = [];

        for (var value in list) {
          tsList.add(value['Ts'] ??
              0);
          hList.add(value['h'] ??
              0);
          oList.add(value['o'] ??
              0);
        }
        int highestH = hList.reduce((value, element) => value > element ? value : element);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                constraints: BoxConstraints(maxHeight: 100),
                child: MyPatientCardDetails(
                  name:
                      "${room?.users[1].firstName} ${room?.users[1].lastName}",
                  pic: "${room?.users[1].imageUrl}",
                )),
            SizedBox(
              height: 30,
            ),
PeakFlow(deviceId: room?.metadata?['device'],patientUuid: room?.users[1].id??'',patientName: "${room?.users[1].firstName} ${room?.users[1].lastName}",),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  "SPO2 Reading",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  child: Text(
                    "Last Reading: ${oList.last}%",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              constraints: BoxConstraints(maxHeight: 300),
              child: MyLineGraph(
                list: oList,
                maxY: 120,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  "BPM Reading",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  child: Text(
                    "Last Reading: ${hList.last}",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              constraints: BoxConstraints(maxHeight: 300),
              child: MyLineGraph(
                list: hList,
                maxY: Assist.roundToNearestTens(highestH+40),
              ),
            ),
          ],
        );
      },
    );
  }
}
