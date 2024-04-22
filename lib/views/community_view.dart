import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import '../models/user_model.dart';
import '../services/user_firecrud.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView>  with SingleTickerProviderStateMixin {
  String searchString = "";
  TabController? tabController;
  int selectTabIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    getUsers();
    getMembers();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.40;
      if ((maxScroll - currentScroll) <= delta) {
        getUsers();
      }
    });
    _scrollController1.addListener(() {
      double maxScroll = _scrollController1.position.maxScrollExtent;
      double currentScroll = _scrollController1.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.40;
      if ((maxScroll - currentScroll) <= delta) {
        getMembers();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    searchString = "";
    super.dispose();
  }

  List<DocumentSnapshot> usersList = [];
  List<DocumentSnapshot> membersList = [];
  bool isLoading1 = false;
  bool isLoading2 = false;
  bool hasMore = true;
  bool hasMore1 = true;
  int documentLimit = 4;
  DocumentSnapshot? lastDocument;
  DocumentSnapshot? lastDocument1;
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        elevation: 0,
        title: Text("Community",
          style: GoogleFonts.amaranth(
            color: Colors.white,
            fontSize: Constants().getFontSize(context, "XL"),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFCF2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Constants().primaryAppColor, width: 2),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    onChanged: (val) {
                      setState(() {
                        searchString = val;
                      });
                      print(searchString);
                      getUsers();
                      getMembers();
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      icon:
                      SvgPicture.asset("assets/search.svg", height: 23),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: size.height* 0.06,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TabBar(
                    isScrollable:false,
                    controller: tabController,
                    labelColor: Constants().primaryAppColor,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Constants().primaryAppColor,
                    indicatorPadding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 0),
                    labelPadding: const EdgeInsets.all(0),
                    splashBorderRadius: BorderRadius.zero,
                    splashFactory: NoSplash.splashFactory,
                    labelStyle: GoogleFonts.openSans(
                      fontSize: size.width / 20,
                      fontWeight: FontWeight.w800,
                    ),
                    unselectedLabelStyle: GoogleFonts.openSans(
                      fontSize: size.width / 24,
                      fontWeight: FontWeight.w600,
                    ),
                    onTap: (index){
                      setState(() {
                        selectTabIndex = index;
                        isLoading = true;
                      });
                    },
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Users"),
                            // Visibility(
                            //     visible: users.isNotEmpty,
                            //     child: SizedBox(
                            //         width: size.width * 0.01)),
                            // Visibility(
                            //   visible: users.isNotEmpty,
                            //   child: Badge(
                            //     backgroundColor: Constants().primaryAppColor,
                            //     label: Text(
                            //       users.length.toString(),
                            //       style: const TextStyle(
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Members"),
                            // Visibility(
                            //     visible: members.isNotEmpty,
                            //     child: SizedBox(
                            //         width: size.width * 0.01)),
                            // Visibility(
                            //   visible: members.isNotEmpty,
                            //   child: Badge(
                            //     backgroundColor:  Constants().primaryAppColor,
                            //     label: Text(
                            //       members.length.toString(),
                            //       style: const TextStyle(
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    Column(children: [
                      Expanded(
                        child: usersList.isEmpty
                            ? Center(
                          child: Lottie.asset(
                            'assets/no_data.json',
                            fit: BoxFit.contain,
                            height: size.height * 0.4,
                            width: size.width * 0.7,
                          ),
                        )
                            : ListView.builder(
                          controller: _scrollController,
                          itemCount: usersList.length,
                          itemBuilder: (context, index) {
                            UserModel user = UserModel.fromJson(usersList[index].data() as Map<String,dynamic>);
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                              child: Card(
                                color: Colors.white,
                                child: SizedBox(
                                  width: size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Icon(Icons.person_outline, color: Constants().primaryAppColor),
                                              SizedBox(width: size.width/41.1),
                                              Text(
                                                "${user.firstName!} ${user.lastName!}",
                                                style: GoogleFonts.amaranth(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: Constants()
                                                      .getFontSize(context, 'M'),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: size.height/86.6),
                                        InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Icon(Icons.person_pin_outlined,
                                                  color: Constants().primaryAppColor),
                                              SizedBox(width: size.width/41.1),
                                              KText(
                                                text:user.profession!,
                                                style: GoogleFonts.amaranth(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: Constants()
                                                        .getFontSize(context, 'S')),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: size.height/86.6),
                                        SizedBox(
                                          width: size.width,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Icon(Icons.phone, color: Constants().primaryAppColor),
                                                  SizedBox(width: size.width/41.1),
                                                  InkWell(
                                                    onTap: () async {
                                                      final Uri launchUri = Uri(
                                                        scheme: 'tel',
                                                        path:user.phone!,
                                                      );
                                                      await launchUrl(launchUri);
                                                    },
                                                    child: KText(
                                                      text: user.phone!,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: Constants()
                                                              .getFontSize(context, 'S')),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Expanded(child: Container()),
                                              InkWell(
                                                  onTap: () async {
                                                    final Uri launchUri = Uri.parse(
                                                      'https://api.whatsapp.com/send?phone=${user.phone!}&text=Hii%20${user.firstName!} ${user.lastName!},%20I%20got%20your%20contact%20on%20IKIA',
                                                    );
                                                    await launchUrl(launchUri);
                                                  },
                                                  child: Icon(Icons.chat,color: Constants().primaryAppColor)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      isLoading1
                          ? Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(5),
                        //color: Constants().primaryAppColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/simpleloading.json',
                              fit: BoxFit.contain,
                              height: size.height * 0.1,
                            ),
                          ],
                        ),
                      )
                          : Container()
                    ]),
                    Column(children: [
    Expanded(
    child: membersList.isEmpty
    ? Center(
    child: Lottie.asset(
    'assets/no_data.json',
    fit: BoxFit.contain,
    height: size.height * 0.4,
    width: size.width * 0.7,
    ),
    )
        : ListView.builder(
    controller: _scrollController1,
    itemCount: membersList.length,
    itemBuilder: (context, index) {
    var user = membersList[index];
    return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
    child: Card(
    color: Colors.white,
    child: SizedBox(
    width: size.width,
    child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
    InkWell(
    onTap: () {},
    child: Row(
    children: [
    Icon(Icons.person_outline, color: Constants().primaryAppColor),
    SizedBox(width: size.width/41.1),
    Text(
    "${user.get("firstName")!} ${user.get("lastName")!}",
    style: GoogleFonts.amaranth(
    fontWeight: FontWeight.w500,
    fontSize: Constants()
        .getFontSize(context, 'M'),
    ),
    )
    ],
    ),
    ),
    SizedBox(height: size.height/86.6),
    InkWell(
    onTap: () {},
    child: Row(
    children: [
    Icon(Icons.person_pin_outlined,
    color: Constants().primaryAppColor),
    SizedBox(width: size.width/41.1),
    KText(
    text:user.get("position")!,
    style: GoogleFonts.amaranth(
    fontWeight: FontWeight.w500,
    fontSize: Constants()
        .getFontSize(context, 'S')),
    )
    ],
    ),
    ),
    SizedBox(height: size.height/86.6),
    SizedBox(
    width: size.width,
    child: Row(
    mainAxisAlignment:
    MainAxisAlignment.start,
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Icon(Icons.phone, color: Constants().primaryAppColor),
    SizedBox(width: size.width/41.1),
    InkWell(
    onTap: () async {
    final Uri launchUri = Uri(
    scheme: 'tel',
    path:user.get("phone")!,
    );
    await launchUrl(launchUri);
    },
    child: KText(
    text: user.get("phone")!,
    style: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: Constants()
        .getFontSize(context, 'S')),
    ),
    )
    ],
    ),
    Expanded(child: Container()),
    InkWell(
    onTap: () async {
    final Uri launchUri = Uri.parse(
    'https://api.whatsapp.com/send?phone=${user.get("phone")!}&text=Hii%20${user.get("firstName")!} ${user.get("lastName")!},%20I%20got%20your%20contact%20on%20IKIA',
    );
    await launchUrl(launchUri);
    },
    child: Icon(Icons.chat,color: Constants().primaryAppColor)),
    ],
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    );
    },
    ),
    ),
    isLoading2
    ? Container(
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.all(5),
    //color: Constants().primaryAppColor,
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Lottie.asset(
    'assets/load.json',
    fit: BoxFit.contain,
    height: size.height * 0.1,
    ),
    ],
    ),
    )
        : Container()
    ]),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.01),
            ],
          ),
        ),
      ),
    );
  }

  buildUserDataCardList(){
    Size size = MediaQuery.of(context).size;
    return Column(children: [
      Expanded(
        child: usersList.isEmpty
            ? Center(
          child: Lottie.asset(
            'assets/no_data.json',
            fit: BoxFit.contain,
            height: size.height * 0.4,
            width: size.width * 0.7,
          ),
        )
            : ListView.builder(
          controller: _scrollController,
          itemCount: usersList.length,
          itemBuilder: (context, index) {
            UserModel user = UserModel.fromJson(usersList[index].data() as Map<String,dynamic>);
            return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                            child: Card(
                              color: Colors.white,
                              child: SizedBox(
                                width: size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Row(
                                          children: [
                                            Icon(Icons.person_outline, color: Constants().primaryAppColor),
                                            SizedBox(width: size.width/41.1),
                                            Text(
                                              "${user.firstName!} ${user.lastName!}",
                                              style: GoogleFonts.amaranth(
                                                fontWeight: FontWeight.w500,
                                                fontSize: Constants()
                                                    .getFontSize(context, 'M'),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: size.height/86.6),
                                      InkWell(
                                        onTap: () {},
                                        child: Row(
                                          children: [
                                            Icon(Icons.person_pin_outlined,
                                                color: Constants().primaryAppColor),
                                            SizedBox(width: size.width/41.1),
                                            KText(
                                              text:user.profession!,
                                              style: GoogleFonts.amaranth(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: Constants()
                                                      .getFontSize(context, 'S')),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: size.height/86.6),
                                      SizedBox(
                                        width: size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Icon(Icons.phone, color: Constants().primaryAppColor),
                                                SizedBox(width: size.width/41.1),
                                                InkWell(
                                                  onTap: () async {
                                                    final Uri launchUri = Uri(
                                                      scheme: 'tel',
                                                      path:user.phone!,
                                                    );
                                                    await launchUrl(launchUri);
                                                  },
                                                  child: KText(
                                                    text: user.phone!,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: Constants()
                                                            .getFontSize(context, 'S')),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Expanded(child: Container()),
                                            InkWell(
                                              onTap: () async {
                                                final Uri launchUri = Uri.parse(
                                                  'https://api.whatsapp.com/send?phone=${user.phone!}&text=Hii%20${user.firstName!} ${user.lastName!},%20I%20got%20your%20contact%20on%20IKIA',
                                                );
                                                await launchUrl(launchUri);
                                              },
                                                child: Icon(Icons.chat,color: Constants().primaryAppColor)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
          },
        ),
      ),
      isLoading1
          ? Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(5),
        //color: Constants().primaryAppColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/load.json',
              fit: BoxFit.contain,
              height: size.height * 0.1,
            ),
          ],
        ),
      )
          : Container()
    ]);
  }

  buildMemberDataCardList(){
    Size size = MediaQuery.of(context).size;
    return Column(children: [
      Expanded(
        child: membersList.isEmpty
            ? Center(
          child: Lottie.asset(
            'assets/no_data.json',
            fit: BoxFit.contain,
            height: size.height * 0.4,
            width: size.width * 0.7,
          ),
        )
            : ListView.builder(
          controller: _scrollController1,
          itemCount: membersList.length,
          itemBuilder: (context, index) {
            var user = membersList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              child: Card(
                color: Colors.white,
                child: SizedBox(
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(Icons.person_outline, color: Constants().primaryAppColor),
                              SizedBox(width: size.width/41.1),
                              Text(
                                "${user.get("firstName")!} ${user.get("lastName")!}",
                                style: GoogleFonts.amaranth(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Constants()
                                      .getFontSize(context, 'M'),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: size.height/86.6),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(Icons.person_pin_outlined,
                                  color: Constants().primaryAppColor),
                              SizedBox(width: size.width/41.1),
                              KText(
                                text:user.get("position")!,
                                style: GoogleFonts.amaranth(
                                    fontWeight: FontWeight.w500,
                                    fontSize: Constants()
                                        .getFontSize(context, 'S')),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: size.height/86.6),
                        SizedBox(
                          width: size.width,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.phone, color: Constants().primaryAppColor),
                                  SizedBox(width: size.width/41.1),
                                  InkWell(
                                    onTap: () async {
                                      final Uri launchUri = Uri(
                                        scheme: 'tel',
                                        path:user.get("phone")!,
                                      );
                                      await launchUrl(launchUri);
                                    },
                                    child: KText(
                                      text: user.get("phone")!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: Constants()
                                              .getFontSize(context, 'S')),
                                    ),
                                  )
                                ],
                              ),
                              Expanded(child: Container()),
                              InkWell(
                                  onTap: () async {
                                    final Uri launchUri = Uri.parse(
                                      'https://api.whatsapp.com/send?phone=${user.get("phone")!}&text=Hii%20${user.get("firstName")!} ${user.get("lastName")!},%20I%20got%20your%20contact%20on%20IKIA',
                                    );
                                    await launchUrl(launchUri);
                                  },
                                  child: Icon(Icons.chat,color: Constants().primaryAppColor)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      isLoading2
          ? Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(5),
        //color: Constants().primaryAppColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/load.json',
              fit: BoxFit.contain,
              height: size.height * 0.1,
            ),
          ],
        ),
      )
          : Container()
    ]);
  }

  bool empty= false;
  getUsers() async {
 /*   if (!hasMore) {
      print('No More Users');
      return;
    }*/
    if (isLoading1) {
      return;
    }
    setState(() {
      isLoading1 = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where("isPrivacyEnabled",isEqualTo: false)
          .limit(documentLimit)
          .get();
    }
    else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where("isPrivacyEnabled",isEqualTo: false)
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
      print(1);
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    if(searchString=="") {
      if(empty==true){
        setState(() {
          usersList.clear();
          empty=false;
        });
      }
      print("Empty=====================");
      usersList.addAll(querySnapshot.docs);
    }
    else{
      setState(() {
        empty=true;
      });
      print("else=====================");
      usersList.clear();
      List<DocumentSnapshot> temp=[];
     var que= await FirebaseFirestore.instance
          .collection('Users')
         .where("isPrivacyEnabled",isEqualTo: false)
          .get();
      for(int i=0;i<que.docs.length;i++) {
        if (que.docs[i]["firstName"].toString().toLowerCase().startsWith(searchString.toLowerCase()) ||
        que.docs[i]["lastName"].toString().toLowerCase().startsWith(searchString.toLowerCase()) ||
    que.docs[i]["profession"].toString().toLowerCase().startsWith(searchString.toLowerCase())

        ) {
          temp.add(que.docs[i]);
          print(que.docs[i]["firstName"]);
        }
      }
      setState(() {
        usersList.addAll(temp);
      });
    }
    print(usersList[0]["firstName"]);
      isLoading1 = false;
    setState(() {
    });
  }

  getMembers() async {
    print("sxdsf");
    if (!hasMore1) {
      print('No More Users');
      return;
    }
    if (isLoading2) {
      return;
    }
    setState(() {
      isLoading2 = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument1 == null) {
      querySnapshot = await FirebaseFirestore.instance
          .collection('Members')
          .orderBy("timestamp", descending: true)
          .limit(documentLimit)
          .get();
    }
    else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('Members')
          .orderBy("timestamp", descending: true)
          .startAfterDocument(lastDocument1!)
          .limit(documentLimit)
          .get();
      print(1);
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore1 = false;
    }
    lastDocument1 = querySnapshot.docs[querySnapshot.docs.length - 1];
    print("----------------------------------------------------------------------------------");
    print(searchString);
    if(searchString=="") {
      if(empty==true){
        setState(() {
          membersList.clear();
          empty=false;
        });
      }
      print("Empty=====================");
      membersList.addAll(querySnapshot.docs);
    }
    else{
      setState(() {
        empty=true;
      });
      print("else=====================");
      membersList.clear();
      List<DocumentSnapshot> temp=[];
      var que= await FirebaseFirestore.instance
          .collection('Members')
          .orderBy("timestamp", descending: true)
          .get();
      for(int i=0;i<que.docs.length;i++) {
        if (
        que.docs[i]["firstName"].toString().toLowerCase().startsWith(searchString.toLowerCase()) ||
        que.docs[i]["lastName"].toString().toLowerCase().startsWith(searchString.toLowerCase()) ||
        que.docs[i]["position"].toString().toLowerCase().startsWith(searchString.toLowerCase())


        ) {
          temp.add(que.docs[i]);
          print(que.docs[i]["firstName"]);
        }
      }
      setState(() {
        membersList.addAll(temp);
      });
    }
    print(membersList[0]["firstName"]);

    isLoading2 = false;
    setState(() {
    });
  }



}
