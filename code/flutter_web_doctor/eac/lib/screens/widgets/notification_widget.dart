import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../riverpod/general_riverpod.dart';

class NotificationWidget extends ConsumerWidget {
  const NotificationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid=FirebaseAuth.instance.currentUser?.uid??'';

    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance
          .ref()
          .child("n")
          .child(uid)
          .orderByChild('r')
      .equalTo(false )
          // .limitToLast(20)
          .onValue,
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasError) {
          return SizedBox();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox();
        }
        // if (!(snapshot.data?.snapshot.exists ?? false)) {
        //   return IconButton(onPressed: (){}, icon: Icon(Icons.notifications_none_outlined,size: 35,),color: Colors.black87);
        // }

        return Badge(
            label: Text('${((snapshot.data?.snapshot.value??{}) as Map).length}'),
            isLabelVisible: snapshot.data?.snapshot.exists ?? false,
            child: IconButton(onPressed: (){
              ref.read(selectedPage.notifier).state="Notification";

            }, icon: Icon(Icons.notifications_none_outlined,size: 35,),color: Colors.black87));        },
    );
  }
}

