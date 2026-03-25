import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eac/screens/schedule/components/time_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../constants.dart';
import '../../widgets/default_button.dart';
import '../../widgets/my_text_form_field.dart';
import '../../widgets/notification_body.dart';



class WarningRescheduleDialog extends HookWidget {
  const WarningRescheduleDialog({Key? key,required this.scheduleId, required this.title,required this.controller, required this.description,  }) : super(key: key);
  final String title;
  final String description;
  final String scheduleId;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final selectedDate=useState<DateTime?>(null);
    final selectedTime=useState<String?>(null);
    return AlertDialog(
      content: Container(
        width: 360,
        height: 550,
        constraints: BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10,),

            Text(
              description,
              style: TextStyle(color: Colors.black38, fontSize: 14),
            ),
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: CalendarTimeline(
                initialDate: selectedDate.value??DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
                onDateSelected: (d) {
                  selectedTime.value=null;
                  selectedDate.value=d;

                },
                leftMargin: 20,
                monthColor: Colors.blueGrey,
                dayColor: primaryColor,
                activeDayColor: Colors.white,
                activeBackgroundDayColor: primaryColor,
                dotsColor: Colors.white,
                selectableDayPredicate: (date) => date.day != 23,
                locale: 'en_ISO',
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                TimeButton(
                  value: "09:00 AM",
                  selected: selectedTime.value??"",
                  onTap: (){
                    selectedTime.value="09:00 AM";
                  },
                ),
                TimeButton(
                  value: "10:00 AM",
                  selected: selectedTime.value??"",
                  onTap: (){
                    selectedTime.value="10:00 AM";
                  },
                ),
                TimeButton(
                  value: "11:00 AM",
                  selected: selectedTime.value??"",
                  onTap: (){
                    selectedTime.value="11:00 AM";
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimeButton(
                  value: "01:00 AM",
                  selected: selectedTime.value??"",
                  onTap: (){
                    selectedTime.value="01:00 AM";
                  },
                ),
                TimeButton(
                  value: "02:00 AM",
                  selected: selectedTime.value??"",
                  onTap: (){
                    selectedTime.value="02:00 AM";
                  },
                ),
                TimeButton(
                  value: "03:00 AM",
                  selected: selectedTime.value??"",
                  onTap: (){
                    selectedTime.value="03:00 AM";
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimeButton(
                  value: "04:00 AM",
                  selected: selectedTime.value??"",
                  onTap: (){
                    selectedTime.value="04:00 AM";
                  },
                ),
                TimeButton(
                  value: "05:00 AM",
                  selected: selectedTime.value??"",
                  onTap: (){
                    selectedTime.value="05:00 AM";
                  },
                ),
                TimeButton(
                  value: "06:00 AM",
                  selected: selectedTime.value??"",
                  onTap: (){
                    selectedTime.value="06:00 AM";
                  },
                )
              ],
            ),
            SizedBox(height: 10,),

            MyTextFormField(
              controller: controller,
              labelText: "Enter reason",
              maxLines: 5,),
            SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  child: DefaultButton(text: "Continue",press: ()async{
                    if (selectedTime.value==null ||
                        selectedDate.value==null ||
                        controller.text.trim().isEmpty) {
                      InAppNotification.show(
                        child: const NotificationBody(
                          msg: "Please fill all required field",
                        ),
                        context: context,
                      );
                      return;
                    }
                    try{
                      final format = DateFormat('yyyy-MM-dd hh:mm a');
                      DateTime dateTime = format.parse("${DateFormat('yyyy-MM-dd').format(selectedDate.value!)} ${selectedTime.value}");
                      Timestamp timestamp = Timestamp.fromDate(dateTime);
                      await FirebaseFirestore.instance.collection('schedule').doc(scheduleId).update({
                        "appointment date":timestamp,
                        "reason":controller.text.trim()
                      });
                      Navigator.of(context).pop();
                    }catch(e){
                      InAppNotification.show(
                        child: const NotificationBody(
                          msg: "Unknown Error has occurred",
                        ),
                        context: context,
                      );
                    }

                  }
                    ,),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: DefaultButton(text: "Cancel",press: (){
                    Navigator.of(context).pop();
                  },),
                ),
              ],
            ),



          ],
        ),
      ),
    );
  }
}