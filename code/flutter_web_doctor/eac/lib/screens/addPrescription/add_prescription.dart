
import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:eac/screens/widgets/default_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';
import '../../riverpod/general_riverpod.dart';
import '../widgets/custom_modal.dart';
import '../widgets/header.dart';
import '../widgets/my_text_form_field.dart';
import '../widgets/notification_body.dart';

class AddPrescriptionScreen extends HookConsumerWidget {
  const AddPrescriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientName=ref.watch(patientNameProvider);
    final patientId=ref.watch(patientIdProvider);

    final doctorName=ref.watch(doctorNameProvider);
    final doctorId=ref.watch(doctorIdProvider);

    final Size size = MediaQuery
        .of(context)
        .size;

    final name=useTextEditingController();
    final notes=useTextEditingController();


    final image=useState<XFile?>(null);


    return Column(
        children: [
          Header(),
          Container(
            constraints: BoxConstraints(maxWidth: 360),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                            )),
                      ),
                    ),
                    Text(
                      "Complete Profile",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Expanded(child: SizedBox())
                  ],
                ),
                SizedBox(height: 20,),
                Text(
                  "You are giving prescription for ${patientName}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                SizedBox(height: 10,),
                InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    image.value = await picker.pickImage(source: ImageSource.gallery);
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: primaryColor,
                          width: 3
                      ),

                      image: image.value==null?null:DecorationImage(
                          fit: BoxFit.cover,
                          image:NetworkImage(image.value!.path)
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: image.value!=null?null:Icon(Icons.folder_copy_outlined, color: primaryColor,size: 50,),
                  ),
                ),
                SizedBox(height: 10,),
                MyTextFormField(
                    controller: name,
                    labelText: "Enter prescription title"),
                SizedBox(height: 10,),

                MyTextFormField(
                    controller: notes,
                    maxLines: 5,
                    labelText: "Enter notes for the prescription"),
                SizedBox(height: 10,),
                DefaultButton(text: "Give Prescription", press: () async{
                  final uid=FirebaseAuth.instance.currentUser?.uid??'';
                  if(uid==''){
                    InAppNotification.show(
                      child: const NotificationBody(msg: "Unknown Error has occurred",),
                      context: context,
                    );
                    return;
                  }
                  if (name.text.trim().isEmpty ||
                      notes.text.trim().isEmpty ||
                      image.value==null) {
                    InAppNotification.show(
                      child: const NotificationBody(
                        msg: "Please fill all required field",
                      ),
                      context: context,
                    );
                    return;
                  }
                  final uuid = Uuid();
                  String randomFileName = uuid.v4();
                  Reference myRef = FirebaseStorage.instance.ref().child("doctor/$randomFileName.jpg");
                  UploadTask uploadTask = myRef.putData(await image.value!.readAsBytes(), SettableMetadata(contentType: image.value!.mimeType));
                  String downloadUrl = await (await uploadTask).ref.getDownloadURL();

                  await FirebaseFirestore.instance.collection('prescription').add({
                    "name":name.text.trim(),
                    "notes":notes.text.trim(),
                    "patient name":patientName,
                    "patient id":patientId,
                    "doctor":doctorId,
                    "doctor name":doctorName,
                    "createdAt":FieldValue.serverTimestamp(),
                    "prescription":downloadUrl
                  });
                  ref.read(selectedPage.notifier).state="Prescription";

                },)


              ],
            ),
          )

        ]
    );
  }
}
