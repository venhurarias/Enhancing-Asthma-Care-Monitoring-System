import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:eac_patient/screens/widgets/MyCardGridView.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../constants.dart';
import '../../helper/chat_core/firebase_chat_core.dart';
import '../../responsive.dart';

import '../../riverpod/general_riverpod.dart';
import '../widgets/default_button.dart';
import '../widgets/header.dart';
import '../widgets/header_profile.dart';
import '../widgets/patient_card_details.dart';
import 'components/message_card.dart';

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: () {},
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Messages",
              style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child:List(),
            ),
          ),
        )
      ],
    );
  }
}

class List extends ConsumerWidget {
  const List({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    Widget _buildAvatar(types.Room room) {


      final hasImage = room.imageUrl != null;
      final name = room.name ?? '';

      return Container(
        margin: const EdgeInsets.only(right: 16),
        child: CircleAvatar(
          backgroundColor: hasImage ? Colors.transparent : primaryColor,
          backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
          radius: 20,
          child: !hasImage
              ? Text(
            name.isEmpty ? '' : name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white,),
          )
              : null,
        ),
      );
    }


    return StreamBuilder(
      stream: FirebaseChatCore.instance.rooms(orderByUpdatedAt: true),
      initialData:  [],
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
              bottom: 200,
            ),
            child: const Text('You still not creating any chat'),
          );
        }
        return MyCardGridView(
          childAspectRatio: 5,
          crossAxisCount: Responsive.isDesktop(context)?2:1,
          children: snapshot.data!.map((room){
            return MessageCard(
              name: room.name,
              msg: (room.metadata??{})['lastMsg']??'',
              pic: room.imageUrl,
              onTap: (){
                ref.read(roomProvider.notifier).state=room;
                ref.read(selectedPage.notifier).state="Chat";
              },
            );
          }).toList(),

        );


      },
    );
  }
}

