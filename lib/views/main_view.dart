import 'dart:math';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'package:church_management_client/views/products_view.dart';
import 'package:church_management_client/views/profile_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:ff_navigation_bar_plus/ff_navigation_bar_plus.dart';
import 'package:ff_navigation_bar_plus/ff_navigation_bar_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/bottom_nav_item_model.dart';
import '../models/response.dart';
import '../models/user_model.dart';
import '../services/messages_firecrud.dart';
import '../services/user_firecrud.dart';
import 'community_view.dart';
import 'connect_view.dart';
import 'headers/community_header.dart';
import 'headers/event_header.dart';
import 'headers/product_header.dart';
import 'home_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, required this.uid, required this.userDocId, required this.phone});

  final String uid;
  final String userDocId;
  final String phone;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin {

  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 5,
      vsync: this,
    );
    super.initState();
  }

  bool isTodaybibleVerseShowed = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<BottomNavItem> bottomNavList = [
      BottomNavItem(
        name: "Home",
        icon: Icons.home,
        header: Container(),
        page: HomeView(uid: widget.uid, userDocId: widget.userDocId,phone: widget.phone),
      ),
      BottomNavItem(
        name: "Connect",
        icon: Icons.message,
        header: const EventHeader(),
        page: ConnectView(phone: widget.phone,userDocId: widget.userDocId,uid: widget.uid),
      ),
      BottomNavItem(
        name: "Products",
        icon: Icons.shopping_cart_rounded,
        header: ProductHeader(uid: widget.uid, userDocId: widget.userDocId),
        page: ProductsView(uid: widget.uid, userDocId: widget.userDocId),
      ),
      BottomNavItem(
        name: "Community",
        icon: Icons.perm_contact_calendar_outlined,
        header: const CommunityHeader(),
        page: const CommunityView(),
      ),
      BottomNavItem(
        name: "Profile",
        icon: Icons.person,
        header: Container(),
        page: ProfileView(uid: widget.uid, userDocId: widget.userDocId),
      )
    ];
    if(!isTodaybibleVerseShowed){
      showTodayBibleVerse(context);
      isTodaybibleVerseShowed = true;
    }
    return Scaffold(
      backgroundColor: Constants().primaryAppColor,
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: size.height * 0.38,
                    width: size.width,
                    child: Stack(
                      children: [
                        Container(
                          height: size.height,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                "assets/cloud1.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        width: size.width,
                        decoration: const BoxDecoration(
                          color: Color(0xffF9F9F9)
                        ),
                    ),
                  ),
                ],
              ),
              Container(
                height: size.height,
                width: size.width,
                color: Colors.white54,
              ),
              Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: size.width,
                      child: TabBarView(
                      controller: _motionTabBarController,
                      children: bottomNavList.map((e) => e.page!).toList(),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(bottomNavList,size),
    );
  }

  bottomBar(List<BottomNavItem> list,Size size) {
    return MotionTabBar(
      controller: _motionTabBarController,
      initialSelectedTab: "Home",
      useSafeArea: true,
      labels: [
        list[0].name!,
        list[1].name!,
        list[2].name!,
        list[3].name!,
        list[4].name!
      ],
      icons: [
        list[0].icon!,
        list[1].icon!,
        list[2].icon!,
        list[3].icon!,
        list[4].icon!
      ],
      badges: [],
      tabSize: 50,
      tabBarHeight: 55,
      textStyle: TextStyle(
        fontSize: size.width/35,
        color: Constants().primaryAppColor,//Colors.white,
        fontWeight: FontWeight.w500,
      ),
      tabIconColor: Constants().primaryAppColor,//Colors.white,
      tabIconSize: 28.0,
      tabIconSelectedSize: 26.0,
      tabSelectedColor: Constants().primaryAppColor,//Colors.white,
      tabIconSelectedColor: Colors.white,//Constants().primaryAppColor,
      tabBarColor: Colors.white,//Constants().primaryAppColor,
      onTabItemSelected: (int value) {
        setState(() {
          _motionTabBarController!.index = value;
        });
      },
    );
  }

  Future<dynamic> showTodayBibleVerse(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    var document = await  FirebaseFirestore.instance.collection('ChurchDetails').get();
    var bible = await  FirebaseFirestore.instance.collection('BibleVerses').get();
    var randnum = Random().nextInt(bible.docs.length);
    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  height: size.height * 0.43,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(1, 2),
                        blurRadius: 3,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: size.width/36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.width / 36),
                      Text(
                        'Bible Verse for Today',
                        style: TextStyle(
                          color: Constants().primaryAppColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: size.width / 36),
                      SizedBox(
                        height: size.height / 7.5625,
                        width: double.infinity,
                        child: Lottie.asset("assets/bible.json"),
                        // child: Image.asset(
                        //     "assets/jesus.png"
                        // ),
                      ),
                      SizedBox(height: size.width / 36),
                      SizedBox(
                        height: size.height / 6.3,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Text(
                            document.docs.first['verseForToday']['date'] == DateFormat('dd-MM-yyyy').format(DateTime.now()) ? document.docs.first['verseForToday']['text'] : bible.docs[DateTime.now().day]['text'],
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Center(
                        child: InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: size.height * 0.05,
                            width: size.width * 0.3,
                            decoration: BoxDecoration(
                              color: Constants().primaryAppColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "OK",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.width / 36),
                    ],
                  ),
                ),
              );
            }
        );
      },
    );
  }


}
