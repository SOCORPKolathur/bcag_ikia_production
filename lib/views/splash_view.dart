import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import 'intro_view.dart';
import 'main_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  User? user = FirebaseAuth.instance.currentUser;
  
  @override
  void initState() {
    getChurchDetails();
    _navigateToNextScreen();
    super.initState();
  } String churchLogo = '';
  String churchName = '';

  getChurchDetails() async {
    var church = await FirebaseFirestore.instance.collection('ChurchDetails').get();
    setState(() {
      churchLogo = church.docs.first.get("logo");
      churchName = church.docs.first.get("name");
    });
  }

  Future<void> _navigateToNextScreen() async {
    var document = await FirebaseFirestore.instance.collection("Users").get();
    await Future.delayed(const Duration(seconds: 1));
    if(user != null){
      for(int i=0;i<document.docs.length;i++){
        if(document.docs[i]['id']==user!.uid){
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (ctx) => MainView(uid: user!.uid,phone: user!.phoneNumber!, userDocId: document.docs[i].id)));
        }
      }
    }else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => const IntroView()));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(imageUrl: churchLogo),
            SizedBox(height: size.height/57.733333333),
            Text(
              churchName,
              style: TextStyle(
                color: Constants().primaryAppColor,
                fontSize: 30,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
                fontFamily: "ArgentumSans",
              ),
            ),
            SizedBox(height: size.height/57.733333333),
            Text(
                "May the lord with us",
                style: GoogleFonts.amaranth(
                  color: Constants().primaryAppColor,
                  fontSize: size.width/29.357142857,
                  fontWeight: FontWeight.bold,
                )
            ),
          ],
        ),
      ),
    );
  }
}
