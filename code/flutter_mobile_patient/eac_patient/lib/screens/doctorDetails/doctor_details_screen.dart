import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eac_patient/screens/widgets/MyCardGridView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../constants.dart';
import '../../responsive.dart';

import '../../riverpod/general_riverpod.dart';
import '../widgets/default_button.dart';
import '../widgets/header.dart';
import '../widgets/header_profile.dart';
import '../widgets/my_text_form_field.dart';
import '../widgets/notification_body.dart';
import 'components/time_button.dart';

class DoctorDetailsScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTime=useState<String?>(null);
    final doctorName=ref.watch(doctorNameProvider);
    final doctorType=ref.watch(doctorTypeProvider);
    final doctorDescription=ref.watch(doctorDescriptionProvider);
    final doctorUid=ref.watch(doctorUidProvider);
    final doctorPic=ref.watch(doctorPicProvider);
    final user = ref.watch(currentUserProvider);
    final reason = useTextEditingController();
    final fullDetails = useTextEditingController();

    final selectedDate=useState<DateTime?>(null);

    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: () {
                  ref.read(selectedPage.notifier).state = "Doctor";
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Doctor Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
        SizedBox(height: defaultPadding),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Flex(
              direction: Responsive.isDesktop(context)
                  ? Axis.horizontal
                  : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: Responsive.isDesktop(context) ? 1 : 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding, vertical: defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(doctorPic),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doctorName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    doctorType,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black38),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Text(
                          "About",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          doctorDescription,
                          style: TextStyle(color: Colors.black38),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  flex: Responsive.isDesktop(context) ? 1 : 0,
                  child: Column(
                    children: [
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
                        controller: reason,
                        labelText: "Enter your reason for appointment",),
                      SizedBox(height: 10,),
                      MyTextFormField(
                        controller: fullDetails,
                        labelText: "Enter the full details for appointment",
                        maxLines: 5,),
                      SizedBox(height: 30,),
                      DefaultButton(
                        press: ()async{

                          if (selectedTime.value==null ||
                              selectedDate.value==null ||
                              reason.text.trim().isEmpty ||
                              fullDetails.text.trim().isEmpty) {
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
                            final uid=FirebaseAuth.instance.currentUser?.uid??'';

                            await FirebaseFirestore.instance.collection('schedule').add({
                              "appointment date":timestamp,
                              "doctor":doctorUid,
                              "doctor name":doctorName,
                              "doctor pic":doctorPic,
                              "patient": uid,
                              "patient name":"${user.firstname} ${user.lastName}",
                              "patient pic":user.pic,
                              "patient gender":user.gender,
                              "patient birthday": Timestamp.fromDate(user.birthday!),
                              "reason":reason.text.trim(),
                              "full details":fullDetails.text.trim(),
                              "status":"pending",
                              "device":user.device,
                              "createdAt":FieldValue.serverTimestamp(),
                            });



                            ref.read(selectedPage.notifier).state="Schedule";
                            InAppNotification.show(
                              child: const NotificationBody(
                                msg: "Successfully Booked Appointment",
                              ),
                              context: context,
                            );
                          }catch(e){
                            InAppNotification.show(
                              child: const NotificationBody(
                                msg: "Unknown Error has occurred",
                              ),
                              context: context,
                            );
                          }


                        },
                          text: "Book Appointment")
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
