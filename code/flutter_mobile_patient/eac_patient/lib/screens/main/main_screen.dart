import 'package:eac_patient/screens/doctorDetails/doctor_details_screen.dart';
import 'package:eac_patient/screens/findDoctors/find_doctors_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


import '../../constants.dart';
import '../../global.dart';
import '../../responsive.dart';
import '../../riverpod/general_riverpod.dart';

import '../allDoctors/all_doctors_screen.dart';
import '../appointment/appointment_screen.dart';
import '../chat/chat.dart';
import '../dashboard/dashboard_screen.dart';
import '../doctorDetails/appointment_details_screen.dart';
import '../messages/messages_screen.dart';
import '../notification/notification_screen.dart';
import '../onAppointment/patients_details_screen.dart';
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
                            }else if(selected=='Doctor'){
                              return SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: AllDoctorsScreen());
                            }else if(selected=='FindDoctor'){
                              return SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: FindDoctorsScreen());
                            }else if(selected=='Schedule'){
                              return ScheduleScreen();
                            }else if(selected=='Appointment'){
                              return SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: AppointmentScreen());
                            }else if(selected=='Messages'){
                              return MessagesScreen();
                            }else if(selected=='Doctor Details'){
                              return SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: DoctorDetailsScreen());
                            }else if(selected=='Appointment Details'){
                              return SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: AppointmentDetailsScreen());
                            }else if(selected=='Chat'){
                              return ChatPage();
                            }else if(selected=='OnAppointment'){
                              return SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: OnAppointment());

                            }else if(selected=='Prescription'){
                              return SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: PrescriptionScreen());
                            }else if(selected=='Prescription Details'){
                              return SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                                  child: PrescriptionDetailsScreen());
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
