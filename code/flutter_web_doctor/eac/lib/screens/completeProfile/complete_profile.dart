
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

import '../../constants.dart';
import '../../riverpod/auth_controller.dart';
import '../widgets/custom_modal.dart';
import '../widgets/header.dart';
import '../widgets/my_text_form_field.dart';
import '../widgets/notification_body.dart';

class CompleteProfileScreen extends HookConsumerWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery
        .of(context)
        .size;

    final first=useTextEditingController();
    final last=useTextEditingController();
    final mobile=useTextEditingController();
    final address=useTextEditingController();
    final type=useTextEditingController();
    final description=useTextEditingController();
    final birthday=useTextEditingController();
    final licenseNumber=useTextEditingController();

    final image=useState<XFile?>(null);
    final imageLicense=useState<XFile?>(null);
    final bdayVal=useState<DateTime?>(null);
    final gender=useState<String?>(null);

    return Scaffold(
        body: SafeArea(
            child: Container(
                width: size.width,
                height: size.height,
                child: SingleChildScrollView(
                  child: Column(
                      children: [
                        Header(),
                        Container(
                          constraints: BoxConstraints(maxWidth: 360),
                          child: Column(
                            children: [
                              Text(
                                "Complete Profile",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              SizedBox(height: 20,),
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
                                        // image: pickedFile!=null?CachedNetworkImageProvider(pic):FileImage(File(pickedFile!.path))
                                      // image: const AssetImage('assets/images/user_icon_box.png')
                                        image:NetworkImage(image.value!.path)
                                        // image: pickedFile==null?(pic==''?const AssetImage('assets/images/user_icon_box.png'):CachedNetworkImageProvider(pic)as ImageProvider<Object>):(FileImage(File(pickedFile.path)))
                                    ),
                                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  child: image.value!=null?null:Icon(Icons.add, color: primaryColor,size: 50,),
                                ),
                              ),
                              SizedBox(height: 10,),
                              MyTextFormField(
                                controller: first,
                                  labelText: "Enter your first name"),
                              SizedBox(height: 10,),
                              MyTextFormField(
                                controller: last,
                                  labelText: "Enter your last name"),
                              SizedBox(height: 10,),
                              MyTextFormField(
                                controller: mobile,
                                  labelText: "Enter your mobile no."),
                              SizedBox(height: 10,),
                              MyTextFormField(
                                  controller: type,
                                  labelText: "Enter type"),
                              SizedBox(height: 10,),
                              MyTextFormField(
                                  controller: birthday,
                                  labelText: "Enter your birthday",
                                  readOnly: true,
                                  onTap: () async{
                                    List<DateTime?>? list=await showCalendarDatePicker2Dialog(
                                      context: context,
                                      config: CalendarDatePicker2WithActionButtonsConfig(),
                                      dialogSize: const Size(325, 400),
                                      borderRadius: BorderRadius.circular(15),
                                    );
                                    if(list!=null){
                                      bdayVal.value=list.first;
                                      if(bdayVal.value!=null){
                                        String formattedDate = DateFormat('yyyy-MM-dd').format(bdayVal.value!);
                                        birthday.text=formattedDate;
                                      }
                                    }
                                  }

                              ),
                              SizedBox(height: 10,),
                              MyTextFormField(
                                controller: address,
                                  labelText: "Enter your address",
                              maxLines: 5,),
                              SizedBox(height: 10,),
                              MyTextFormField(
                                controller: description,
                                labelText: "Enter short description about yourself",
                                maxLines: 5,),
                              SizedBox(height: 10,),
                              CustomRadioButton(
                                selectedBorderColor: Colors.transparent,
                                unSelectedBorderColor: Colors.transparent,
                                elevation: 10,
                                absoluteZeroSpacing: true,
                                unSelectedColor: Theme.of(context).canvasColor,
                                buttonLables: [
                                  'Male',
                                  'Female'
                                ],
                                buttonValues: [
                                  "Male",
                                  "Female"
                                ],
                                buttonTextStyle: ButtonTextStyle(
                                    selectedColor: Colors.white,
                                    unSelectedColor: Colors.black,
                                    textStyle: TextStyle(fontSize: 16)),
                                radioButtonValue: (value) {
                                  gender.value=value;
                                },
                                selectedColor: primaryColor,
                              ),
                              SizedBox(height: 10,),
                              Text(
                                "License Proof",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                "Picture",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              InkWell(
                                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                onTap: () async {
                                  final ImagePicker picker = ImagePicker();
                                  imageLicense.value = await picker.pickImage(source: ImageSource.gallery);
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: primaryColor,
                                        width: 3
                                    ),

                                    image: imageLicense.value==null?null:DecorationImage(
                                        fit: BoxFit.cover,
                                        image:NetworkImage(imageLicense.value!.path)
                                    ),
                                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  child: imageLicense.value!=null?null:Icon(Icons.folder_copy_outlined, color: primaryColor,size: 50,),
                                ),
                              ),
                              MyTextFormField(
                                controller: licenseNumber,
                                labelText: "Enter your license number"),
                              SizedBox(height: 10,),
                              DefaultButton(text: "Proceed", press: () async{
                                final uid=FirebaseAuth.instance.currentUser?.uid??'';
                                if(uid==''){
                                  InAppNotification.show(
                                    child: const NotificationBody(msg: "Unknown Error has occurred",),
                                    context: context,
                                  );
                                  return;
                                }
                                if (first.text.trim().isEmpty ||
                                    last.text.trim().isEmpty ||
                                    address.text.trim().isEmpty ||
                                    mobile.text.trim().isEmpty ||
                                    type.text.trim().isEmpty ||
                                    description.text.trim().isEmpty ||
                                    licenseNumber.text.trim().isEmpty ||
                                    image.value==null||
                                    imageLicense.value==null) {
                                  InAppNotification.show(
                                    child: const NotificationBody(
                                      msg: "Please fill all required field",
                                    ),
                                    context: context,
                                  );
                                  return;
                                }

                                Reference myRef = FirebaseStorage.instance.ref().child("doctor/$uid.jpg");
                                UploadTask uploadTask = myRef.putData(await image.value!.readAsBytes(), SettableMetadata(contentType: image.value!.mimeType));
                                Reference myRefLicense = FirebaseStorage.instance.ref().child("doctor/$uid-license.jpg");
                                UploadTask uploadLicenseTask = myRefLicense.putData(await imageLicense.value!.readAsBytes(), SettableMetadata(contentType: image.value!.mimeType));

                                String downloadUrl = await (await uploadTask).ref.getDownloadURL();
                                String downloadUrlLicense = await (await uploadLicenseTask).ref.getDownloadURL();

                                FirebaseFirestore.instance.collection('doctor').doc(uid).set({
                                  "firstName":first.text.trim(),
                                  "lastName":last.text.trim(),
                                  "address":address.text.trim(),
                                  "contactNumber":mobile.text.trim(),
                                  "type":type.text.trim(),
                                  "createdAt":FieldValue.serverTimestamp(),
                                  "pic":downloadUrl,
                                  "licenseNumber":licenseNumber.text.trim(),
                                  "license":downloadUrlLicense,
                                  "description":description.text.trim(),
                                  "birthday":Timestamp.fromDate(bdayVal.value!),
                                  "gender":gender.value
                                });

                              },),
                              SizedBox(height: 10,),
                              DefaultButton(text: "Log out", color: Colors.red,press: () async{
                                ref.read(authControllerProvider.notifier).signOut();

                              },)

                            ],
                          ),
                        )

                      ]
                  ),
                )
            )
        )
    );
  }
}
