import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:eac/screens/widgets/default_button.dart';
import 'package:eac/screens/widgets/my_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_notification/in_app_notification.dart';

import '../../../constants.dart';
import '../../../riverpod/general_riverpod.dart';
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
        SizedBox(
          height: 10,
        ),
        Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding),
            child: Column(
              children: [
                MyTextFormField(
                    controller: time,
                    labelText: "Enter your Time",
                    readOnly: true,
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime.value,
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: false),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        // Ensure the selected time is a multiple of 15 minutes
                        int minute = (picked.minute / 15).round() * 15;
                        selectedTime.value =
                            TimeOfDay(hour: picked.hour, minute: minute);
                        print(selectedTime.value);
                        time.text =
                        "${selectedTime.value.hour}:${selectedTime.value.minute
                            .toString().padLeft(2, '0')}";
                      }
                    }
                ),
                SizedBox(height: 10,),
                MyTextFormField(
                    controller: spo2,
                    labelText: "Enter SPO2 Value"),
                SizedBox(height: 10,),
                MyTextFormField(
                    controller: BPM,
                    labelText: "Enter BPM Value"),
                SizedBox(height: 10,),
                CustomRadioButton(
                  selectedBorderColor: Colors.transparent,
                  unSelectedBorderColor: Colors.transparent,
                  elevation: 10,
                  absoluteZeroSpacing: true,
                  unSelectedColor: Theme.of(context).canvasColor,
                  buttonLables: [
                    'Critical',
                    'Normal',
                    'Abnormal'
                  ],
                  buttonValues: [
                    'Critical',
                    'Normal',
                    'Abnormal'
                  ],
                  buttonTextStyle: ButtonTextStyle(
                      selectedColor: Colors.white,
                      unSelectedColor: Colors.black,
                      textStyle: TextStyle(fontSize: 16)),
                  radioButtonValue: (value) {
                    status.value=value;
                  },
                  selectedColor: primaryColor,
                ),
                SizedBox(height: 10,),
                DefaultButton(
                    text: "Add Data",
                    press: (){
                      if (time.text.trim().isEmpty ||
                          spo2.text.trim().isEmpty ||
                          BPM.text.trim().isEmpty ||
                          status.value==null) {
                        InAppNotification.show(
                          child: const NotificationBody(
                            msg: "Please fill all required field",
                          ),
                          context: context,
                        );
                        return;
                      }
                      double spVal=0;
                      double bpmVal=0;
                      bool isSpNumeric = false;
                      bool isBpmNumeric = false;
                      try {
                        spVal = double.parse(spo2.text.trim());
                        isSpNumeric = true;
                      } catch (e) {
                        isSpNumeric = false;
                      }

                      try {
                        bpmVal = double.parse(BPM.text.trim());
                        isBpmNumeric = true;
                      } catch (e) {
                        isBpmNumeric = false;
                      }

                      if(!isBpmNumeric){
                        InAppNotification.show(
                          child: const NotificationBody(
                            msg: "BPM is not a number",
                          ),
                          context: context,
                        );
                        return;
                      }

                      if(!isSpNumeric){
                        InAppNotification.show(
                          child: const NotificationBody(
                            msg: "SPO2 is not a number",
                          ),
                          context: context,
                        );
                        return;
                      }
                      print(spVal);

                      if(!(spVal >= 50 && spVal <= 100)){
                        InAppNotification.show(
                          child: const NotificationBody(
                            msg: "SPO2 should range in 50-100",
                          ),
                          context: context,
                        );
                        return;
                      }

                      if(!(bpmVal >= 40 && bpmVal <= 200)){
                        InAppNotification.show(
                          child: const NotificationBody(
                            msg: "BPM should range in 40-200",
                          ),
                          context: context,
                        );
                        return;
                      }

                      FirebaseDatabase.instance
                          .ref()
                          .child("ai")
                          .child(room?.metadata?['device']).push().set({
                        'ts': time.text.trim(),
                        'sp': spVal,
                        'b': bpmVal,
                        's': status.value,
                      });
                      FirebaseDatabase.instance
                          .ref()
                          .child("sync")
                          .child(room?.metadata?['device'])
                      .set(false);
                    })

              ],
            ),
          ),
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
              IconButton(onPressed: ()async{
                print('delete ${x.key!}');
                await FirebaseDatabase.instance
                    .ref()
                    .child("ai")
                    .child(room?.metadata?['device']).child(x.key!).remove();
              }, icon: Icon(Icons.delete_outline, color: primaryColor,))

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
