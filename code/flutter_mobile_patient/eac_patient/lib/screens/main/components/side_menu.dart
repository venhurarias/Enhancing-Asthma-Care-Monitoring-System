import 'package:eac_patient/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../global.dart';
import '../../../riverpod/auth_controller.dart';
import '../../../riverpod/general_riverpod.dart';
import '../../widgets/header.dart';

class SideMenu extends ConsumerWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected=ref.watch(selectedPage);
    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: ListView(
        children: [
          Header(),
          DrawerListTile(
            title: "Home",
            icon: Icons.house_outlined,
            isSelected: selected=="Home",
            press: () {
              drawerKey.currentState?.closeDrawer();
              ref.read(selectedPage.notifier).state="Home";
            },
          ),
          DrawerListTile(
            title: "Doctor",
            icon: Icons.medical_information_outlined,
            isSelected: selected=="Doctor" || selected=="FindDoctor" || selected=="Doctor Details",
            press: () {
              drawerKey.currentState?.closeDrawer();
              ref.read(selectedPage.notifier).state="Doctor";
            },
          ),
          DrawerListTile(
            title: "Schedule",
            icon: Icons.calendar_month_outlined,
            isSelected: selected=="Schedule",
            press: () {
              drawerKey.currentState?.closeDrawer();
              ref.read(selectedPage.notifier).state="Schedule";
            },
          ),
          // DrawerListTile(
          //   title: "Diagnostic",
          //   isSelected: selected=="Diagnostic",
          //   icon: Icons.monitor_heart_outlined,
          //   press: () {
          //     drawerKey.currentState?.closeDrawer();
          //     ref.read(selectedPage.notifier).state="Diagnostic";
          //   },
          // ),
          DrawerListTile(
            title: "Messages",
            isSelected: selected=="Messages",
            icon: Icons.mail_outline,
            press: () {
              drawerKey.currentState?.closeDrawer();
              ref.read(selectedPage.notifier).state="Messages";
            },
          ),
          DrawerListTile(
            title: "Prescription",
            isSelected: selected=="Prescription",
            icon: Icons.note_alt_outlined,
            press: () {
              drawerKey.currentState?.closeDrawer();
              ref.read(selectedPage.notifier).state="Prescription";
            },
          ),
          DrawerListTile(
            title: "Log Out",
            color: Colors.red,
            icon: Icons.logout,
            press: () {
              ref.read(authControllerProvider.notifier).signOut();

            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.press,
    this.isSelected=false,
    this.color
  }) : super(key: key);

  final String title;
  final VoidCallback press;
  final IconData icon;
  final bool isSelected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: FaIcon(icon,color: color??(primaryColor)),
      title: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text(
          title,
          style: TextStyle(color: color??(isSelected?primaryColor: Colors.black45)),
        ),
      ),
    );
  }
}
