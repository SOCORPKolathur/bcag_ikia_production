import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../Widgets/kText.dart';
import '../constants.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key, required this.userDocId});

  final String userDocId;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController marriedController = TextEditingController(text: "Select Status");
  TextEditingController anniversaryDateController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  String oldImgUrl = '';

  final ImagePicker _picker = ImagePicker();

  File? profileImage;
  XFile? imageForShow;

  bool isAltreadyRequested = false;

  @override
  void initState() {
    setProfileFields();
    super.initState();
  }

  setProfileFields() async {
    print("--------------------------------");
    var user = await FirebaseFirestore.instance.collection('Users').doc(widget.userDocId).get();
    oldImgUrl = user.get("imgUrl");
    firstNameController.text = user.get("firstName");
    lastNameController.text = user.get("lastName");
    emailController.text = user.get("email");
    phoneController.text = user.get("phone");
    marriedController.text = user.get("maritialStatus");
    anniversaryDateController.text = user.get("anniversaryDate");
    localityController.text = user.get("locality");
    professionController.text = user.get("profession");
    //aboutController.text = user.get("about");
    //addressController.text = user.get("address");
    addressController.text = user.get("resaddress");

    var requests = await FirebaseFirestore.instance.collection('ProfileEditRequest').get();
    requests.docs.forEach((request) {
      if(request.get("userDocId") == widget.userDocId){
        isAltreadyRequested = true;
      }
    });
    setState(() {

    });
  }

  selectImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      profileImage = File(pickedFile!.path);
      imageForShow = pickedFile;
    });
    print(profileImage!.path);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.amaranth(
            color: Colors.white,
            fontSize: Constants().getFontSize(context, "L"),
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Constants().primaryAppColor,
                        image: imageForShow != null
                            ? null : DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(oldImgUrl)
                        ),
                        border: Border.all(color: Constants().primaryAppColor,width: 3),
                      ),
                      child: imageForShow != null ? Image.file(File(imageForShow!.path)) : null,
                    )
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: InkWell(
                      onTap: (){
                        selectImage();
                      },
                      child: Container(
                        height: 40,
                        width: size.width * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Constants().primaryAppColor,
                                width: 3,
                            ),
                        ),
                        child: Center(
                          child: KText(
                              text: "Change Profile Picture",
                              style: TextStyle(
                                color: Constants().primaryAppColor,
                                fontWeight: FontWeight.w600,
                              )
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KText(
                            text: "Firstname :",
                            style: GoogleFonts.poppins(
                              fontSize:
                              Constants().getFontSize(context, 'M'),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: size.height * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              maxLines: null,
                              controller: firstNameController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(7)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KText(
                            text: "Lastname :",
                            style: GoogleFonts.poppins(
                              fontSize:
                              Constants().getFontSize(context, 'M'),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: size.height * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              maxLines: null,
                              controller: lastNameController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(7)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KText(
                            text: "Email :",
                            style: GoogleFonts.poppins(
                              fontSize:
                              Constants().getFontSize(context, 'M'),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: size.height * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              maxLines: null,
                              controller: emailController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(7)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KText(
                            text: "Phone :",
                            style: GoogleFonts.poppins(
                              fontSize:
                              Constants().getFontSize(context, 'M'),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: size.height * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              maxLines: null,
                              controller: phoneController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(7)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KText(
                            text: "Marital Status :",
                            style: GoogleFonts.poppins(
                              fontSize:
                              Constants().getFontSize(context, 'M'),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: size.height * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              isExpanded: true,
                              value: marriedController.text,
                              icon: Icon(Icons.keyboard_arrow_down),
                              underline: Container(),
                              items: [
                                "Select Status",
                                "Single",
                                "Engaged",
                                "Married",
                                "Seperated",
                                "Divorced",
                                "Widow"
                              ].map((items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  marriedController.text = newValue!;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: marriedController.text.toLowerCase() == "married",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KText(
                              text: "Anniversary Date :",
                              style: GoogleFonts.poppins(
                                fontSize:
                                Constants().getFontSize(context, 'M'),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: size.height * 0.07,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextField(
                                maxLines: null,
                                controller: anniversaryDateController,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(7)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KText(
                            text: "Locality :",
                            style: GoogleFonts.poppins(
                              fontSize:
                              Constants().getFontSize(context, 'M'),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: size.height * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              maxLines: null,
                              controller: localityController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(7)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KText(
                            text: "Profession :",
                            style: GoogleFonts.poppins(
                              fontSize:
                              Constants().getFontSize(context, 'M'),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: size.height * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              maxLines: null,
                              controller: professionController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(7)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                 /* Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KText(
                            text: "About :",
                            style: GoogleFonts.poppins(
                              fontSize:
                              Constants().getFontSize(context, 'M'),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: size.height * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              maxLines: null,
                              controller: aboutController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(7)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),*/
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KText(
                            text: "Address :",
                            style: GoogleFonts.poppins(
                              fontSize:
                              Constants().getFontSize(context, 'M'),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: size.height * 0.12,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              maxLines: null,
                              controller: addressController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(7)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: InkWell(
                      onTap: (){
                        updateProfile(size);
                      },
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 40,
                          width: size.width * 0.5,
                          decoration: BoxDecoration(
                            color: Constants().primaryAppColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: KText(
                                text: "Update Profile",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                )
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isAltreadyRequested,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 250,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: size.height / 5.5625,
                        width: double.infinity,
                        child: Lottie.asset("assets/profile_maintanance.json"),
                      ),
                      SizedBox(
                        height: size.height / 10.3,
                        width: double.infinity,
                        child: Text(
                          "Your Profile is under verfication\n Try again later.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  updateProfile(Size size) async {
    String imgUrl = '';
    if(profileImage != null){
      imgUrl = await uploadImageToStorage(profileImage);
    }
    FirebaseFirestore.instance.collection('ProfileEditRequest').doc().set({
      "userDocId": widget.userDocId,
      "imgUrl": profileImage != null ? imgUrl : oldImgUrl,
      "firstName": firstNameController.text,
      "lastName":lastNameController.text,
      "email":emailController.text,
      "phone":phoneController.text,
      "maritalStatus":marriedController.text,
      "anniversaryDate":anniversaryDateController.text,
      "locality":localityController.text,
      "profession":professionController.text,
      "address": addressController.text,
      "about" : aboutController.text,
    });
    await CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Profile Edit Request Sended Successfully.",
        width: size.width * 0.4,
        backgroundColor: Constants()
            .primaryAppColor
            .withOpacity(0.8));
    Navigator.pop(context);
  }

  static Future<String> uploadImageToStorage(file) async {
    var snapshot = await  FirebaseStorage.instance
        .ref()
        .child('dailyupdates')
        .child("${file.path}").putFile(file);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

}
