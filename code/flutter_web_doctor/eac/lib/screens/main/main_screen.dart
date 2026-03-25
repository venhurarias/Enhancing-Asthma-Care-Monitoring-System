import 'package:eac/screens/addPrescription/add_prescription.dart';
import 'package:eac/screens/myPatientDetails/my_patients_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


import '../../constants.dart';
import '../../global.dart';
import '../../responsive.dart';
import '../../riverpod/general_riverpod.dart';

import '../allPatients/all_patients_screen.dart';
import '../appointment/appointment_screen.dart';
import '../chat/chat.dart';
import '../dashboard/dashboard_screen.dart';
import '../messages/messages_screen.dart';
import '../notification/notification_screen.dart';
import '../onAppointment/on_appointment_screen.dart';
import '../patientDetails/patients_details_screen.dart';
import '../prescription/prescription_screen.dart';
import '../prescriptionDetails/prescription_details_screen.dart';
import '../schedule/schedule_screen.dart';
import '../widgets/header_profile.dart';
import 'components/side_menu.dart';


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: Container(
                color: Color(0xFFF8F8F8),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Column(
                      children: [
                        HeaderProfile(),
                        SizedBox(height: defaultPadding),
                        Expanded(
                          child: Consumer(builder: (context, ref, child){
                            final selected=ref.watch(selectedPage);
                            if(selected=='Home'){
                              return SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: DashboardScreen());
                            }else if(selected=='Patients'){
                              return SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: AllPatientsScreen());
                            }else if(selected=='Prescription'){
                              return SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: PrescriptionScreen());
                            }else if(selected=='Prescription Details'){
                              return SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: PrescriptionDetailsScreen());
                            }else if(selected=='Add Prescription'){
                              return SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: AddPrescriptionScreen());
                            }else if(selected=='Appointment'){
                              return ScheduleScreen();
                            }else if(selected=='Patient Details'){
                              return SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: PatientsDetailsScreen());
                            }
                            // else if(selected=='Appointment'){
                            //   return SingleChildScrollView(
                            //       padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                            //       child: ScheduleScreen());
                            // }
                            else if(selected=='Messages'){
                              return MessagesScreen();
                            }else if(selected=='Chat'){
                              return ChatPage();
                            }else if(selected=='OnAppointment'){
                              return SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: OnAppointment());

                            }else if(selected=='My Patient Details'){
                              return SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: MyPatientsDetailsScreen());
                            }else if(selected=='Notification'){
                              return SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: NotificationScreen());
                            }else{
                              return SizedBox();
                            }
                          },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
