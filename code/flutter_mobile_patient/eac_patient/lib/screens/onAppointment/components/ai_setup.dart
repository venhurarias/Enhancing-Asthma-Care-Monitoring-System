import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_notification/in_app_notification.dart';

import '../../../constants.dart';
import '../../../riverpod/general_riverpod.dart';
import '../../widgets/default_button.dart';
import '../../widgets/my_text_form_field.dart';
import '../../widgets/notification_body.dart';

class AiSetUp extends HookConsumerWidget {
  const AiSetUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTime = useState(TimeOfDay.now());
    final time=useTextEditingController();
    final spo2=useTextEditingController();
    final BPM=useTextEditingController();
    final status=useState<String?>(null);
    final room = ref.watch(roomProvider);

    return Column(
      children: [
        Text(
          "AI Teaching for Patient",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 20,),
        MyList(room: room,),
      ],
    );
  }
}


class MyList extends StatelessWidget {
  const MyList({Key? key, required this.room}) : super(key: key);
  final Room? room;
  @override
  Widget build(BuildContext context) {


    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance
          .ref()
          .child("ai")
          .child(room?.metadata?['device'])
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
                "You still don't have any data",
                style: TextStyle(color: primaryColor),
              ),
            ],
          );
        }
        Iterable<DataSnapshot> dataList = snapshot.data!.snapshot.children;
        return Column(
          children: [
            Text(
              "Data",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
        Column(
        children: dataList.map((x){
          Map<String, dynamic> e=x.value as Map<String, dynamic>;
          return Row(
            children: [
              Text(
                "Time: ${e['ts']}",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              ),
              SizedBox(width: 10,),
              Text(
                "SPO2: ${e['sp']}",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              ),
              SizedBox(width: 10,),
              Text(
                "BPM: ${e['b']}",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              ),
              SizedBox(width: 10,),
              Text(
                "${e['s']}",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              ),
              SizedBox(width: 10,),

            ],
          );
        }).toList(),
        )
          ],
        );
      },
    );

  }
}
