import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_management_client/views/register_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import 'login_view.dart';

class IntroView extends StatefulWidget {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {

  String churchLogo = '';
  String churchName = '';

  getChurchDetails() async {
    var church = await FirebaseFirestore.instance.collection('ChurchDetails').get();
    setState(() {
      churchLogo = church.docs.first.get("logo");
      churchName = church.docs.first.get("name");
    });
  }

  @override
  void initState() {
    getChurchDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
             /*   image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/dolomite-alps-peaks-italy 1.png"),
                )*/
            ),
          ),
          Container(
            height: size.height,
            width: size.width,
            color: Colors.white70,
          ),
          SizedBox(
            height: size.height,
            width: size.width,
            child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: size.height* 0.26),
                  Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     churchLogo != ""
                         ? Container(
                       height: 100,
                       width: 100,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(200),
                           color:Colors.white
                       ),
                       child: ClipRRect(
                         borderRadius: BorderRadius.circular(200),
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: CachedNetworkImage( imageUrl:
                             churchLogo,
                             height: 110,
                             width: 110,
                           ),
                         ),
                       ),
                     )
                         : const Icon(
                       Icons.church,
                       size: 80,
                     ),
                     // Icon(
                     //   Icons.church,
                     //   size: size.width/5.1375,
                     // ),
                     SizedBox(height: size.height/57.733333333),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                             "Welcome to",
                           style: GoogleFonts.openSans(
                             fontSize: size.width/20.55,
                             fontWeight: FontWeight.w900,
                           ),
                         ),
                         Text(
                          churchName,
                           style: GoogleFonts.openSans(
                             fontSize: size.width/10.275,
                             fontWeight: FontWeight.w900,
                           ),
                         ),
                       ],
                     ),
                     SizedBox(height: size.height/108.25),
                     Text(
                         "May the lord with us",
                         style: GoogleFonts.openSans(
                           color:const Color(0xff000000),
                           fontSize: size.width/29.357142857,
                           fontWeight: FontWeight.w700,
                         )
                     ),
                   ],
                 ),
                  SizedBox(height: size.height* 0.1),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx)=> const LoginView()));
                            },
                            child: Container(
                              height: size.height/17.32,
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                color: Constants().primaryAppColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: GoogleFonts.openSans(
                                  color: const Color(0xffFFFFFF),
                                    fontSize: size.width/22.833333333,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx)=> const RegisterView()));
                            },
                            child: Container(
                              height: size.height/17.32,
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                color: const Color(0xffFFFFFF),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(1,1),
                                    blurRadius: 2,
                                  )
                                ]
                              ),
                              child: Center(
                                child: Text(
                                  "Register",
                                  style: GoogleFonts.openSans(
                                    color: const Color(0xff000000),
                                    fontSize: size.width/22.833333333,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: size.height/43.3),
                      // Text(
                      //   "Or login with",
                      //   style: GoogleFonts.openSans(
                      //     fontSize: size.width/25.6875,
                      //     color: const Color(0xff000000)
                      //   ),
                      // ),
                      // SizedBox(height: size.height/43.3),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     InkWell(
                      //       onTap:(){},
                      //       child: Container(
                      //         height: size.height/19.681818182,
                      //         width: size.width*0.25,
                      //         decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(30),
                      //           border: Border.all(color: Constants().primaryAppColor, width: 2),
                      //         ),
                      //         child: Center(
                      //           child: SvgPicture.asset("assets/Group 10.svg"),
                      //         ),
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap:(){},
                      //       child: Container(
                      //         height: size.height/19.681818182,
                      //         width: size.width*0.25,
                      //         decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(30),
                      //           border: Border.all(color: Constants().primaryAppColor, width: 2),
                      //         ),
                      //         child: Center(
                      //           child: SvgPicture.asset("assets/Group 9.svg"),
                      //         ),
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap:(){},
                      //       child: Container(
                      //         height: size.height/19.681818182,
                      //         width: size.width*0.25,
                      //         decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(30),
                      //           border: Border.all(color: Constants().primaryAppColor, width: 2),
                      //         ),
                      //         child:  Center(
                      //           child: SvgPicture.asset("assets/Vector.svg"),
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      SizedBox(height: size.height * 0.04)
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
