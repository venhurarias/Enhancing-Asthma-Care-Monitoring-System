import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:random_avatar/random_avatar.dart';

import '../../constants.dart';
import '../../global.dart';
import '../../responsive.dart';
import '../../riverpod/general_riverpod.dart';
import 'notification_widget.dart';


class HeaderProfile extends ConsumerWidget {
  const HeaderProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Column(
      children: [
        Row(
          children: [
            SizedBox(height: 65,),
            if (!Responsive.isDesktop(context))
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: (){
                  drawerKey.currentState?.openDrawer();
                },
              ),
            Expanded(child: SizedBox()),
            NotificationWidget(),
            SizedBox(width: 20,),
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(user.pic),
            ),
            SizedBox(width: 20,),
            Column(
              children: [
                Text(
                  "${user.firstname} ${user.lastName}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  "${user.type}",
                  style: TextStyle(
                      fontSize: 14),
                )
              ],
            )


          ],
        ),
        Divider(
          color: primaryColor,
          thickness: 1.5,
        )
      ],
    );
  }
}
