
import 'package:eac_patient/screens/onAppointment/components/peak_flow.dart';
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
    print(room?.users[0].firstName);
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
              0); // Add 'Ts' value to tsList, default to 0 if not found
          hList.add(value['h'] ??
              0); // Add 'h' value to hList, default to 0 if not found
          oList.add(value['o'] ??
              0); // Add 'o' value to oList, default to 0 if not found
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                constraints: BoxConstraints(maxHeight: 100),
                child: MyPatientCardDetails(
                  name:
                      "${room?.users[0].firstName} ${room?.users[0].lastName}",
                  pic: "${room?.users[0].imageUrl}",
                )),
            SizedBox(
              height: 30,
            ),
PeakFlow(deviceId: room?.metadata?['device'],),
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
                maxY: 180,
              ),
            ),
          ],
        );
      },
    );
  }
}
