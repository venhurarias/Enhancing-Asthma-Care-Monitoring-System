import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../responsive.dart';

class NotificationScreen extends HookWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid=FirebaseAuth.instance.currentUser?.uid??'';
    useEffect(() {
      Future<void>.microtask(() async {
        DatabaseReference ref = FirebaseDatabase.instance.ref().child("n").child(uid);

        // Query for records with 'r' equal to false
        DatabaseEvent event =await ref
            .orderByChild('r')
            .equalTo(false)
            .once();
       Map map= event.snapshot.value as Map;
        map.forEach((key, value) {
          DatabaseReference recordRef = ref.child(key);
          recordRef.update({'r': true});
        });

      });
    },[]);
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance
          .ref()
          .child("n")
          .child(uid)
          .orderByChild('ts')
      .limitToLast(10)
          .onValue,
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasError) {
          return SizedBox();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox();
        }
        if (!(snapshot.data?.snapshot.exists ?? false)) {
          return Text("You don't have any notification yet");
        }

        return Column(
          children: snapshot.data!.snapshot.children.map((e) {
            Map map=e.value as Map;
            return Container(
              padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(map['m'], style: TextStyle(fontSize: 18,fontWeight: map['r']==true?FontWeight.normal:FontWeight.bold),),
              Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(map['ts'])))
            ],
          ),
        );
          }).toList(),
        );
        },
    );


  }
}
