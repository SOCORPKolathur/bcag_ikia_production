import 'package:church_management_client/Widgets/kText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class SocialMediaView extends StatefulWidget {
  const SocialMediaView({super.key});

  @override
  State<SocialMediaView> createState() => _SocialMediaViewState();
}

class _SocialMediaViewState extends State<SocialMediaView> {



  String facebookUrl = 'https://www.facebook.com/bcagchennai';
  String instaUrl = 'https://www.instagram.com/bcagchennai';
  String youtubeUrl = 'https://youtube.com/@BlessingCentreAGChurch?si=5zcTr5WpvC9cbMYQ';

  bool isView = false;
  bool isFacebook = false;
  bool isInsta = false;

  final initialContent = '<h4> The Page is being loaded Please wait... <h2>';
  String churchLogo = '';
  String churchWebsite = '';

  getAdmin() async {
    var churchDetails = await FirebaseFirestore.instance.collection('ChurchDetails').get();
    setState(() {
      churchLogo = churchDetails.docs.first.get("logo");
      churchWebsite = churchDetails.docs.first.get("website");
    });
  }

  Future<void> launch(String url, {bool isNewTab = true}) async {
    await launchUrl(
      Uri.parse(url),
      webOnlyWindowName: isNewTab ? '_blank' : '_self',
    );
  }

  @override
  void initState() {
    getAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        elevation: 0,
        title: Text("Social Media",
          style: GoogleFonts.amaranth(
            color: Colors.white,
            fontSize: Constants().getFontSize(context, "XL"),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),


      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(height: 20),
              InkWell(
                onTap:() async {
                  // setState(() {
                  //   isView = true;
                  //   isFacebook = true;
                  //   isInsta = false;
                  // });
                  // await Future.delayed(Duration(seconds: 2)).then((value){
                  //   webviewControllerfacebook.loadContent(
                  //     facebookUrl,
                  //     SourceType.url,
                  //   );
                  // });
                  launch(facebookUrl);
                },
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 80,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(
                              child: Icon(
                                Icons.facebook,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          KText(
                            text: "Facebook",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap:() async {
                  // setState(() {
                  //   isView = true;
                  //   isFacebook = false;
                  //   isInsta = true;
                  // });
                  // await Future.delayed(Duration(seconds: 2)).then((value){
                  //   webviewControllerinsta.loadContent(
                  //     instaUrl,
                  //     SourceType.url,
                  //   );
                  // });
                  launch(instaUrl);
                },
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 80,
                    width: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.purple,
                          Colors.pink,
                          Colors.orange,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(
                              child: Image.asset(
                                "assets/insta.png",
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ),
                          KText(
                            text: "Instagram",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap:(){

                },
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 80,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(
                                child: KText(
                                  text: "X",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                            ),
                          ),
                          KText(
                            text: "X",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap:(){

                },
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 80,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(
                              child: Image.asset(
                                "assets/thread.png",
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ),
                          KText(
                            text: "Thread",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap:() async {
                  // setState(() {
                  //   isView = true;
                  //   isFacebook = false;
                  //   isInsta = false;
                  // });
                  // await Future.delayed(Duration(seconds: 2)).then((value){
                  //   webviewControllerchurch.loadContent(
                  //     churchWebsite,
                  //     SourceType.url,
                  //   );
                  // });
                  launch(churchWebsite);
                },
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 80,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  churchLogo,
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ),
                          ),
                          KText(
                            text: "Church Website",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap:() async {
                  // setState(() {
                  //   isView = true;
                  //   isFacebook = false;
                  //   isInsta = false;
                  // });
                  // await Future.delayed(Duration(seconds: 2)).then((value){
                  //   webviewControllerchurch.loadContent(
                  //     churchWebsite,
                  //     SourceType.url,
                  //   );
                  // });
                 // launch(youtubeUrl);
                },
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 80,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Color(0xffFF0000),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Center(
                                child: Icon(Icons.play_arrow,color: Colors.white,)
                            ),
                          ),
                          KText(
                            text: "YouTube",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }
}
