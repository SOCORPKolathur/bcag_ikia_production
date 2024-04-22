import 'dart:math';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/response.dart';
import '../models/user_model.dart';
import 'membership_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key, required this.uid, required this.userDocId});

  final String uid;
  final String userDocId;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}
////

class _ProfileViewState extends State<ProfileView> with SingleTickerProviderStateMixin {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController prayerTitleCon = TextEditingController();
  TextEditingController prayerDescriptionCon = TextEditingController();
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 5, vsync: this);
    getfamilyid();
    super.initState();
  }

  String responseText = 'Profile';



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xffF9F9F9),
        appBar: AppBar(
          backgroundColor: Constants().primaryAppColor,
          elevation: 0,
          title: Text(
            "Profile",
            style: GoogleFonts.amaranth(
              color: Colors.white,
              fontSize: Constants().getFontSize(context, "XL"),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .snapshots()
              .map((snapshot) => snapshot.docs
                  .where((element) => element['id'] == widget.uid)
                  .map((doc) => UserModel.fromJson(doc.data()))
                  .toList()
                  .first),
          builder: (ctx, snaps) {
            if (snaps.hasData) {
              UserModel user = snaps.data!;
              return Container(
                color: const Color(0xffF9F9F9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.18,
                      width: size.width,
                      child: Row(
                        children: [
                          Lottie.asset(
                            'assets/profileanim.json',
                            fit: BoxFit.contain,
                            height: size.height * 0.18,
                            width: size.width * 0.4,
                          ),
                          SizedBox(
                            height: size.height * 0.18,
                            width: size.width * 0.6,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: Constants().primaryAppColor,
                                        ),
                                        SizedBox(width: size.width / 41.1),
                                        KText(
                                          text: "${user.firstName!} ${user.lastName!}",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: Constants()
                                                  .getFontSize(context, 'SM')),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          color: Constants().primaryAppColor,
                                        ),
                                        SizedBox(width: size.width / 82.2),
                                        KText(
                                          text: user.phone!,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: Constants()
                                                  .getFontSize(context, 'S')),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: SizedBox(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.alternate_email,
                                            color: Constants().primaryAppColor,
                                          ),
                                          SizedBox(width: size.width / 82.2),
                                          SizedBox(
                                            width: size.width * 0.5,
                                            child: KText(
                                              text: user.email!,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: Constants()
                                                      .getFontSize(
                                                          context, 'S')),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        height: size.height * 0.06,
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TabBar(
                          controller: tabController,
                          indicator: BoxDecoration(
                              color: Constants().primaryAppColor,
                              borderRadius: BorderRadius.circular(10.0)),
                          labelColor: Colors.white,
                          isScrollable:true,
                          unselectedLabelColor: Colors.black,
                          indicatorPadding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: const [
                            Tab(
                              text: "Personal",
                            ),
                            Tab(
                              text: "Family",
                            ),
                            Tab(
                              text: "My Speech",
                            ),
                            Tab(
                              text: "My Prayer",
                            ),
                            Tab(
                              text: "Testimonials",
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: size.height / 86.6),
                                SizedBox(height: size.height / 86.6),
                               /* Card(
                                  color: Colors.white,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.phone,
                                                  color: Constants()
                                                      .primaryAppColor,
                                                ),
                                                SizedBox(
                                                    width: size.width / 41.1),
                                                KText(
                                                  text: "Phone :",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                              context, 'S')),
                                                ),
                                                SizedBox(
                                                    width: size.width / 82.2),
                                                KText(
                                                  text: user.phone!,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                              context, 'S')),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: size.height / 86.6),
                                          InkWell(
                                            onTap: () {},
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.alternate_email,
                                                  color: Constants()
                                                      .primaryAppColor,
                                                ),
                                                SizedBox(
                                                    width: size.width / 41.1),
                                                KText(
                                                  text: "Email :",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                              context, 'S')),
                                                ),
                                                SizedBox(
                                                    width: size.width / 82.2),
                                                KText(
                                                  text: user.email!,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                              context, 'S')),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height / 86.6),*/
                                Card(
                                  color: Colors.white,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.notes,
                                                  color: Constants()
                                                      .primaryAppColor,
                                                ),
                                                const SizedBox(width: 10),
                                                KText(
                                                  text: "Marital Status : ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                              context, 'S')),
                                                ),
                                                const SizedBox(width: 5),
                                                KText(
                                                  text: user.maritialStatus!,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                              context, 'S')),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  size.height / 48.111111111),
                                          Visibility(
                                            visible: user.maritialStatus ==
                                                "Married",
                                            child: InkWell(
                                              onTap: () {},
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.event,
                                                    color: Constants()
                                                        .primaryAppColor,
                                                  ),
                                                  SizedBox(
                                                      width: size.width / 41.1),
                                                  KText(
                                                    text: "Anniversary date : ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: Constants()
                                                            .getFontSize(
                                                                context, 'S')),
                                                  ),
                                                  SizedBox(
                                                      width: size.width / 82.2),
                                                  KText(
                                                    text: user.anniversaryDate!,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: Constants()
                                                            .getFontSize(
                                                                context, 'S')),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: size.height / 86.6),
                                          InkWell(
                                            onTap: () {},
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.location_pin,
                                                  color: Constants()
                                                      .primaryAppColor,
                                                ),
                                                SizedBox(
                                                    width: size.width / 41.1),
                                                KText(
                                                  text: "Locality :",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                              context, 'S')),
                                                ),
                                                SizedBox(
                                                    width: size.width / 82.2),
                                                KText(
                                                  text: user.locality!,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: Constants()
                                                          .getFontSize(
                                                              context, 'S')),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height / 86.6),
                                Card(
                                  color: Colors.white,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.cases_sharp,
                                                  color: Constants()
                                                      .primaryAppColor,
                                                ),
                                                SizedBox(
                                                    width: size.width / 41.1),
                                                SizedBox(
                                                  child: KText(
                                                    text: "Profession : ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: Constants()
                                                            .getFontSize(
                                                                context, 'S')),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: size.width / 82.2),
                                                SizedBox(
                                                  width: size.width * 0.5,
                                                  child: KText(
                                                    text: user.profession!,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: Constants()
                                                            .getFontSize(
                                                                context, 'S')),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: size.height / 86.6),
                                          InkWell(
                                            onTap: () {},
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.location_city,
                                                  color: Constants()
                                                      .primaryAppColor,
                                                ),
                                                SizedBox(
                                                    width: size.width / 41.1),
                                                SizedBox(
                                                  child: KText(
                                                    text: "Address :",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: Constants()
                                                            .getFontSize(
                                                                context, 'S')),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: size.width / 82.2),
                                                SizedBox(
                                                  width: size.width * 0.5,
                                                  child: KText(
                                                    text: user.address!,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: Constants()
                                                            .getFontSize(
                                                                context, 'S')),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('Families')
                                  .snapshots(),
                              builder: (ctx, snapshot) {
                                bool noData = true;

                                if (snapshot.hasData) {
                                  var data;
                                  snapshot.data!.docs.forEach((element) {
                                    if (element.get("familyId") == familyID) {
                                      data = element;
                                      noData = false;
                                    }
                                  });
                                  return noData
                                      ? Center(
                                          child: Lottie.asset(
                                            'assets/no_data.json',
                                            fit: BoxFit.contain,
                                            height: size.height * 0.4,
                                            width: size.width * 0.7,
                                          ),
                                        )
                                      : SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    height: size.height / 86.6),
                                                SizedBox(
                                                    height: size.height / 86.6),
                                                Card(
                                                  color: Colors.white,
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {},
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .text_fields,
                                                                  color: Constants()
                                                                      .primaryAppColor,
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        41.1),
                                                                KText(
                                                                  text:
                                                                      "Family ID :",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize: Constants().getFontSize(
                                                                          context,
                                                                          'S')),
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        82.2),
                                                                KText(
                                                                  text: data[
                                                                      'familyId'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize: Constants().getFontSize(
                                                                          context,
                                                                          'S')),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  size.height /
                                                                      86.6),
                                                          InkWell(
                                                            onTap: () {},
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .family_restroom,
                                                                  color: Constants()
                                                                      .primaryAppColor,
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        41.1),
                                                                KText(
                                                                  text:
                                                                      "Family Name :",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize: Constants().getFontSize(
                                                                          context,
                                                                          'S')),
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        82.2),
                                                                KText(
                                                                  text: data[
                                                                      'name'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize: Constants().getFontSize(
                                                                          context,
                                                                          'S')),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: size.height / 86.6),
                                                Card(
                                                  color: Colors.white,
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              13.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {},
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.person,
                                                                  color: Constants()
                                                                      .primaryAppColor,
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        41.1),
                                                                KText(
                                                                  text:
                                                                      "Leader Name : ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize: Constants().getFontSize(
                                                                          context,
                                                                          'S')),
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        82.2),
                                                                KText(
                                                                  text: data[
                                                                      'leaderName'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize: Constants().getFontSize(
                                                                          context,
                                                                          'S')),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  size.height /
                                                                      86.6),
                                                          InkWell(
                                                            onTap: () {},
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.phone,
                                                                  color: Constants()
                                                                      .primaryAppColor,
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        41.1),
                                                                KText(
                                                                  text:
                                                                      "Contact Number : ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize: Constants().getFontSize(
                                                                          context,
                                                                          'S')),
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        82.2),
                                                                KText(
                                                                  text: data[
                                                                      'contactNumber'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize: Constants().getFontSize(
                                                                          context,
                                                                          'S')),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  size.height /
                                                                      86.6),
                                                          InkWell(
                                                            onTap: () {},
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .alternate_email,
                                                                  color: Constants()
                                                                      .primaryAppColor,
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        41.1),
                                                                KText(
                                                                  text:
                                                                      "Email :",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize: Constants().getFontSize(
                                                                          context,
                                                                          'S')),
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        82.2),
                                                                KText(
                                                                  text: data[
                                                                      'email'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize: Constants().getFontSize(
                                                                          context,
                                                                          'S')),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: size.height / 86.6),
                                                Card(
                                                  color: Colors.white,
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              13.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {},
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .supervisor_account,
                                                                  color: Constants()
                                                                      .primaryAppColor,
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        41.1),
                                                                KText(
                                                                  text:
                                                                      "Family Member Count : ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize: Constants().getFontSize(
                                                                          context,
                                                                          'S')),
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        82.2),
                                                                KText(
                                                                  text: data[
                                                                          'quantity']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize: Constants().getFontSize(
                                                                          context,
                                                                          'S')),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: size.height / 86.6),
                                                Card(
                                                  color: Colors.white,
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              13.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {},
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Icon(
                                                                  Icons.home,
                                                                  color: Constants()
                                                                      .primaryAppColor,
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        41.1),
                                                                KText(
                                                                  text:
                                                                      "Address : ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize: Constants().getFontSize(
                                                                          context,
                                                                          'S')),
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        82.2),
                                                                SizedBox(
                                                                  width:
                                                                      size.width *
                                                                          0.55,
                                                                  child: Text(
                                                                    data['address']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize: Constants().getFontSize(
                                                                            context,
                                                                            'S')),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: size
                                                                      .height /
                                                                  48.111111111),
                                                          InkWell(
                                                            onTap: () {},
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .location_city,
                                                                  color: Constants()
                                                                      .primaryAppColor,
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        41.1),
                                                                KText(
                                                                  text:
                                                                      "City : ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize: Constants().getFontSize(
                                                                          context,
                                                                          'S')),
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        82.2),
                                                                KText(
                                                                  text: data[
                                                                      'city'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize: Constants().getFontSize(
                                                                          context,
                                                                          'S')),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: size
                                                                      .height /
                                                                  48.111111111),
                                                          InkWell(
                                                            onTap: () {},
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .local_post_office_outlined,
                                                                  color: Constants()
                                                                      .primaryAppColor,
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        41.1),
                                                                KText(
                                                                  text:
                                                                      "Pincode : ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize: Constants().getFontSize(
                                                                          context,
                                                                          'S')),
                                                                ),
                                                                SizedBox(
                                                                    width: size
                                                                            .width /
                                                                        82.2),
                                                                KText(
                                                                  text: data[
                                                                      'zone'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize: Constants().getFontSize(
                                                                          context,
                                                                          'S')),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: size.height / 86.6),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    "Family Members :",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('Members')
                                                      .snapshots(),
                                                  builder: (ctx, snapss) {
                                                    if (snapss.hasData) {
                                                      List memberData = [];
                                                      snapss.data!.docs
                                                          .forEach((element) {
                                                        if (element.get(
                                                                "family") ==
                                                            data['name']) {
                                                          memberData
                                                              .add(element);
                                                        }
                                                      });
                                                      return Card(
                                                        color: Colors.white,
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      13.0),
                                                              child: SizedBox(
                                                                height: (size
                                                                            .height *
                                                                        0.035) *
                                                                    memberData
                                                                        .length,
                                                                child: ListView
                                                                    .builder(
                                                                  itemCount:
                                                                      memberData
                                                                          .length,
                                                                  itemBuilder:
                                                                      (ctx,
                                                                          indexx) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              5,
                                                                          vertical:
                                                                              4),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Icon(
                                                                            memberData[indexx]['gender'] == "Male"
                                                                                ? Icons.male
                                                                                : memberData[indexx]['gender'] == "Female"
                                                                                    ? Icons.female
                                                                                    : Icons.person,
                                                                            color:
                                                                                Constants().primaryAppColor,
                                                                          ),
                                                                          SizedBox(
                                                                              width: size.width / 41.1),
                                                                          KText(
                                                                            text: memberData[indexx]['firstName'] +
                                                                                " " +
                                                                                memberData[indexx]['lastName'],
                                                                            style: TextStyle(
                                                                                color: Colors.black45,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: Constants().getFontSize(context, 'S')),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              )),
                                                        ),
                                                      );
                                                    }
                                                    return Container();
                                                  },
                                                ),
                                                SizedBox(
                                                    height: size.height / 86.6),
                                              ],
                                            ),
                                          ),
                                        );
                                }
                                return Container();
                              },
                            ),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('Speeches')
                                  .snapshots(),
                              builder: (ctx, snapshot) {
                                bool noData = true;
                                if (snapshot.hasData) {
                                  List data = [];
                                  snapshot.data!.docs.forEach((element) {
                                    if (element.get("lastName") == user.phone) {
                                      data.add(element);
                                      noData = false;
                                    }
                                  });
                                  return noData
                                      ? Center(
                                          child: Lottie.asset(
                                            'assets/no_data.json',
                                            fit: BoxFit.contain,
                                            height: size.height * 0.4,
                                            width: size.width * 0.7,
                                          ),
                                        )
                                      : SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                  height: size.height / 86.6),
                                              SizedBox(
                                                  height: size.height / 86.6),
                                              for (int i = 0;
                                                  i < data.length;
                                                  i++)
                                                Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        showSpeechPopUp(
                                                            context, data[i]);
                                                      },
                                                      child: Card(
                                                        color: Colors.white,
                                                        child: SizedBox(
                                                          height: size.height *
                                                              0.18,
                                                          width:
                                                              double.infinity,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(20.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .date_range,
                                                                      color: Constants()
                                                                          .primaryAppColor,
                                                                    ),
                                                                    SizedBox(
                                                                        width: size.width /
                                                                            41.1),
                                                                    KText(
                                                                      text:
                                                                          "Date :",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontSize: Constants().getFontSize(
                                                                              context,
                                                                              'S')),
                                                                    ),
                                                                    SizedBox(
                                                                        width: size.width /
                                                                            82.2),
                                                                    KText(
                                                                      text: data[
                                                                              i]
                                                                          [
                                                                          'Date'],
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize: Constants().getFontSize(
                                                                              context,
                                                                              'S')),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: size
                                                                            .height /
                                                                        86.6),
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .timelapse,
                                                                      color: Constants()
                                                                          .primaryAppColor,
                                                                    ),
                                                                    SizedBox(
                                                                        width: size.width /
                                                                            41.1),
                                                                    KText(
                                                                      text:
                                                                          "Time :",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontSize: Constants().getFontSize(
                                                                              context,
                                                                              'S')),
                                                                    ),
                                                                    SizedBox(
                                                                        width: size.width /
                                                                            82.2),
                                                                    KText(
                                                                      text: data[
                                                                              i]
                                                                          [
                                                                          'Time'],
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize: Constants().getFontSize(
                                                                              context,
                                                                              'S')),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: size
                                                                            .height /
                                                                        86.6),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .text_snippet_sharp,
                                                                      color: Constants()
                                                                          .primaryAppColor,
                                                                    ),
                                                                    SizedBox(
                                                                        width: size.width /
                                                                            41.1),
                                                                    KText(
                                                                      text:
                                                                          "Speech :",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontSize: Constants().getFontSize(
                                                                              context,
                                                                              'S')),
                                                                    ),
                                                                    SizedBox(
                                                                        width: size.width /
                                                                            82.2),
                                                                    SizedBox(
                                                                      height: size
                                                                              .height *
                                                                          0.03,
                                                                      width: size
                                                                              .width *
                                                                          0.5,
                                                                      child:
                                                                          KText(
                                                                        maxLines:
                                                                            1,
                                                                        text: data[i]
                                                                            [
                                                                            'speech'],
                                                                        textOverflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.grey,
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: Constants().getFontSize(context, 'S')),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            size.height / 86.6),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        );
                                }
                                return Container();
                              },
                            ),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('Prayers').snapshots(),
                              builder: (ctx, snapshot) {
                                bool noData = true;
                                if (snapshot.hasData) {
                                  List data = [];
                                  snapshot.data!.docs.forEach((element) {
                                    if (element.get("phone") == user.phone) {
                                      data.add(element);
                                      noData = false;
                                    }
                                  });
                                  return noData
                                      ? Center(
                                    child: Column(
                                      children: [
                                        Lottie.asset(
                                          'assets/no_data.json',
                                          fit: BoxFit.contain,
                                          height: size.height * 0.4,
                                          width: size.width * 0.7,
                                        ),
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              prayerTitleCon.clear();
                                              prayerDescriptionCon.clear();
                                            });
                                            showRequestPrayerPopUp(context, user);
                                          },
                                          child: Material(
                                            elevation: 4,
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(
                                              height: 35,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                color: Constants().primaryAppColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Request Prayer",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                      : SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(height: size.height / 86.6),
                                        SizedBox(height: size.height / 86.6),
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              prayerTitleCon.clear();
                                              prayerDescriptionCon.clear();
                                            });
                                            showRequestPrayerPopUp(context, user);
                                          },
                                          child: Material(
                                            elevation: 4,
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(
                                              height: 35,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                color: Constants().primaryAppColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Add Prayer Request",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: size.height / 86.6),
                                        for (int i = 0; i < data.length; i++)
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Card(
                                              color: Colors.white,
                                              child: SizedBox(
                                                height: size.height * 0.18,
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          KText(
                                                            text: data[i]['date'],
                                                            style: TextStyle(
                                                                color: Colors.grey,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: Constants().getFontSize(context, 'S')),
                                                          ),
                                                          KText(text: data[i]['time'],
                                                            style: TextStyle(
                                                                color: Colors.grey,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: Constants().getFontSize(context, 'S')),
                                                          )
                                                        ],
                                                      ),
                                                      //SizedBox(height: size.height / 86.6),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: size.height * 0.03,
                                                            width: size.width * 0.8,
                                                            child: KText(
                                                              maxLines: 1,
                                                              text: data[i]['title'],
                                                              textOverflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: Constants().getFontSize(context, 'SM'),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: size.height * 0.03,
                                                            width: size.width * 0.8,
                                                            child: KText(
                                                              maxLines: 1,
                                                              text: data[i]['description'],
                                                              textOverflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: Constants().getFontSize(context, 'S'),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: size.height * 0.03,
                                                            width: size.width * 0.8,
                                                            child: KText(
                                                              maxLines: 1,
                                                              text: "Status : " + data[i]['status'],
                                                              textOverflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                color: data[i]['status'].toString().toLowerCase() == 'approved' ? Colors.green: data[i]['status'].toString().toLowerCase() == 'denied' ? Colors.red : Colors.grey,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: Constants().getFontSize(context, 'S'),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('Testimonials').snapshots(),
                              builder: (ctx, snapshot) {
                                bool noData = true;
                                if (snapshot.hasData) {
                                  List data = [];
                                  snapshot.data!.docs.forEach((element) {
                                    if (element.get("phone") == user.phone) {
                                      data.add(element);
                                      noData = false;
                                    }
                                  });
                                  return noData
                                      ? Center(
                                    child: Column(
                                      children: [
                                        Lottie.asset(
                                          'assets/no_data.json',
                                          fit: BoxFit.contain,
                                          height: size.height * 0.4,
                                          width: size.width * 0.7,
                                        ),
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              prayerTitleCon.clear();
                                              prayerDescriptionCon.clear();
                                            });
                                            showRequestTestimonialPopUp(context, user);
                                          },
                                          child: Material(
                                            elevation: 4,
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(
                                              height: 35,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                color: Constants().primaryAppColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Request Testimonial",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                      : SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(height: size.height / 86.6),
                                        SizedBox(height: size.height / 86.6),
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              prayerTitleCon.clear();
                                              prayerDescriptionCon.clear();
                                            });
                                            showRequestTestimonialPopUp(context, user);
                                          },
                                          child: Material(
                                            elevation: 4,
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(
                                              height: 35,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                color: Constants().primaryAppColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Add Testimonials Request",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: size.height / 86.6),
                                        for (int i = 0; i < data.length; i++)
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Card(
                                              color: Colors.white,
                                              child: SizedBox(
                                                height: size.height * 0.18,
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          KText(
                                                            text: data[i]['date'],
                                                            style: TextStyle(
                                                                color: Colors.grey,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: Constants().getFontSize(context, 'S')),
                                                          ),
                                                          KText(text: data[i]['time'],
                                                            style: TextStyle(
                                                                color: Colors.grey,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: Constants().getFontSize(context, 'S')),
                                                          )
                                                        ],
                                                      ),
                                                      //SizedBox(height: size.height / 86.6),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: size.height * 0.03,
                                                            width: size.width * 0.8,
                                                            child: KText(
                                                              maxLines: 1,
                                                              text: data[i]['title'],
                                                              textOverflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                color: Colors.grey,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: Constants().getFontSize(context, 'SM'),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: size.height * 0.03,
                                                            width: size.width * 0.8,
                                                            child: KText(
                                                              maxLines: 1,
                                                              text: data[i]['description'],
                                                              textOverflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                color: Colors.grey,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: Constants().getFontSize(context, 'S'),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: size.height * 0.03,
                                                            width: size.width * 0.8,
                                                            child: KText(
                                                              maxLines: 1,
                                                              text: "Status : " + data[i]['status'],
                                                              textOverflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                color: data[i]['status'].toString().toLowerCase() == 'verified' ? Colors.green: data[i]['status'].toString().toLowerCase() == 'unverified' ? Colors.red : Colors.grey,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: Constants().getFontSize(context, 'S'),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: FutureBuilder(
                        future: checkMemberAccess(user.phone!),
                        builder: (ctx, snap){
                          if(snap.hasData){
                            return snap.data == true ? Container(
                              width: size.width * 0.6,
                              height: 40,
                              child: NeoPopTiltedButton(
                                decoration: NeoPopTiltedButtonDecoration(
                                  color: Constants().primaryAppColor,
                                  showShimmer: true,
                                ),
                                onTapUp: () {
                                  // FirebaseAuth.instance.currentUser == null ?
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) =>
                                  //       Loginpage2("planpage")),
                                  // ) :
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        MembershipView(phone: user.phone!),
                                    ),
                                  );

                                },
                                child: Center(child: Text('Your Membership',style: GoogleFonts.montserrat(
                                    color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15
                                ),)),
                              ),
                            ) : Container();
                          }return Container();
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            }
            return Container();
          },
        )
    );
  }

  String familyID = "";

  getfamilyid() async {
    var members = await FirebaseFirestore.instance.collection('Members').doc(widget.userDocId).get();
    Map<String, dynamic> ? val = members.data();
    setState(() {
      familyID= val!["familyid"];
    });
  }

  Future<bool> checkMemberAccess(String phone) async {
    bool isHaveAccess = false;
    var members = await FirebaseFirestore.instance.collection('Members').where("phone", isEqualTo: phone).get();
    members.docs.forEach((member) {
      if(phone == member.get("phone")){
        isHaveAccess = true;
      }
    });
    return isHaveAccess;
  }

  showSpeechPopUp(context, var data) async {
    Size size = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: size.height * 0.8,
            width: size.width,
            decoration: BoxDecoration(
              color: Constants().primaryAppColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(1, 2),
                  blurRadius: 3,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: size.height * 0.07,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: 'Speech',
                          style: GoogleFonts.openSans(
                            fontSize: Constants().getFontSize(context, 'M'),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: size.height * 0.73,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xffF7FAFC),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data['Date'],
                                style: GoogleFonts.openSans(
                                  color: Colors.grey,
                                  fontSize:
                                      Constants().getFontSize(context, "S"),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                data['Time'],
                                style: GoogleFonts.openSans(
                                  color: Colors.grey,
                                  fontSize:
                                      Constants().getFontSize(context, "S"),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height / 86.6),
                          SizedBox(height: size.height / 216.5),
                          SizedBox(
                            height: size.height * 0.65,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: KText(
                                        text: data['speech'],
                                        style: GoogleFonts.openSans(
                                          fontSize: Constants()
                                              .getFontSize(context, 'S'),
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  showRequestPrayerPopUp(context, UserModel user) async {
    Size size = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: size.height * 0.5,
            width: size.width,
            decoration: BoxDecoration(
              color: Constants().primaryAppColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(1, 2),
                  blurRadius: 3,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: size.height * 0.07,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "Send Prayer Request",
                          style: GoogleFonts.openSans(
                            fontSize: Constants().getFontSize(context, 'M'),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              prayerTitleCon.clear();
                              prayerDescriptionCon.clear();
                            });
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Color(0xffF7FAFC),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Title",
                                  style: GoogleFonts.openSans(
                                    fontSize:
                                    Constants().getFontSize(context, 'S'),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: size.height * 0.08,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: TextField(
                                      maxLines: null,
                                      controller: prayerTitleCon,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(7)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Description",
                                  style: GoogleFonts.openSans(
                                    fontSize:
                                    Constants().getFontSize(context, 'S'),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: size.height * 0.14,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: TextField(
                                      maxLines: null,
                                      controller: prayerDescriptionCon,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(7)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                if (prayerDescriptionCon.text != "" && prayerTitleCon.text != "") {
                                  String docId = getRandomString(16);
                                  FirebaseFirestore.instance.collection('Prayers').doc(docId).set(
                                    {
                                      "id" : docId,
                                      "date" : DateFormat('dd-MM-yyyy').format(DateTime.now()),
                                      "time" : DateFormat('hh:mm a').format(DateTime.now()),
                                      "title" : prayerTitleCon.text,
                                      "description" : prayerDescriptionCon.text,
                                      "timestamp" : DateTime.now().millisecondsSinceEpoch,
                                      "status" : "Pending",
                                      "requestedBy": "${user.firstName} ${user.lastName}",
                                      "phone" : user.phone
                                    }
                                  ).whenComplete(() async {
                                    await CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        text: "Request Sended successfully!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    setState(() {
                                      descriptionController.text = "";
                                    });
                                    Navigator.pop(context);
                                  }).catchError((e) async {
                                    await CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: "Failed to send Request!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                  });
                                }
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 2),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                                  child: Center(
                                    child: KText(
                                      text: "Update",
                                      style: GoogleFonts.openSans(
                                        fontSize: Constants()
                                            .getFontSize(context, 'S'),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  descriptionController.text = "";
                                });
                                ////////////////////
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 2),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                                  child: Center(
                                    child: KText(
                                      text: "Cancel",
                                      style: GoogleFonts.openSans(
                                        fontSize: Constants()
                                            .getFontSize(context, 'S'),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showRequestTestimonialPopUp(context, UserModel user) async {
    Size size = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: size.height * 0.5,
            width: size.width,
            decoration: BoxDecoration(
              color: Constants().primaryAppColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(1, 2),
                  blurRadius: 3,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: size.height * 0.07,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "Send Testimonial Request",
                          style: GoogleFonts.openSans(
                            fontSize: Constants().getFontSize(context, 'M'),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              prayerTitleCon.clear();
                              prayerDescriptionCon.clear();
                            });
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Color(0xffF7FAFC),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Title",
                                  style: GoogleFonts.openSans(
                                    fontSize:
                                    Constants().getFontSize(context, 'S'),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: size.height * 0.08,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: TextField(
                                      maxLines: null,
                                      controller: prayerTitleCon,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(7)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Description",
                                  style: GoogleFonts.openSans(
                                    fontSize:
                                    Constants().getFontSize(context, 'S'),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: size.height * 0.14,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: TextField(
                                      maxLines: null,
                                      controller: prayerDescriptionCon,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(7)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                if (prayerDescriptionCon.text != "" && prayerTitleCon.text != "") {
                                  String docId = getRandomString(16);
                                  FirebaseFirestore.instance.collection('Testimonials').doc(docId).set(
                                      {
                                        "id" : docId,
                                        "date" : DateFormat('dd-MM-yyyy').format(DateTime.now()),
                                        "time" : DateFormat('hh:mm a').format(DateTime.now()),
                                        "title" : prayerTitleCon.text,
                                        "description" : prayerDescriptionCon.text,
                                        "timestamp" : DateTime.now().millisecondsSinceEpoch,
                                        "status" : "Pending",
                                        "requestedBy": "${user.firstName} ${user.lastName}",
                                        "phone" : user.phone
                                      }
                                  ).whenComplete(() async {
                                    await CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        text: "Request Sended successfully!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    setState(() {
                                      descriptionController.text = "";
                                    });
                                    Navigator.pop(context);
                                  }).catchError((e) async {
                                    await CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: "Failed to send Request!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                  });
                                }
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 2),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                                  child: Center(
                                    child: KText(
                                      text: "Update",
                                      style: GoogleFonts.openSans(
                                        fontSize: Constants()
                                            .getFontSize(context, 'S'),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  descriptionController.text = "";
                                });
                                ////////////////////
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 2),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                                  child: Center(
                                    child: KText(
                                      text: "Cancel",
                                      style: GoogleFonts.openSans(
                                        fontSize: Constants()
                                            .getFontSize(context, 'S'),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


}
