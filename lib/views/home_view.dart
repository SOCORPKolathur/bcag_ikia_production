import 'dart:math';
import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:church_management_client/views/edit_profile_view.dart';
import 'package:church_management_client/views/video_ceremonies_view.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:church_management_client/models/event_model.dart';
import 'package:church_management_client/services/events_firecrud.dart';
import 'package:church_management_client/views/events_list_view.dart';
import 'package:church_management_client/views/pastors_list_view.dart';
import 'package:church_management_client/views/social_media_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import '../Widgets/kText.dart';
import '../Widgets/slider_widget.dart';
import '../constants.dart';
import '../models/notice_model.dart';
import '../models/response.dart';
import '../models/user_model.dart';
import '../services/messages_firecrud.dart';
import '../services/user_firecrud.dart';
import 'about_church_view.dart';
import 'audio_podcasts_view.dart';
import 'blogs_list_view.dart';
import 'intro_view.dart';
import 'languages_view.dart';
import 'notices_list_view.dart';
import 'notifications_view.dart';

class HomeView extends StatefulWidget {
  const HomeView(
      {super.key,
      required this.userDocId,
      required this.uid,
      required this.phone});

  final String uid;
  final String phone;
  final String userDocId;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  TextEditingController descriptionController = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;
  int sliderImageIndex = 0;
  ScrollController scrollController = ScrollController();
  ScrollController tabScrollController = ScrollController();
  TabController? tabController;
  bool tabIsScrollable = true;

  bool isNotificationEnable = true;

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour > 17) {
      return "Good Evening,";
    } else if (hour > 12) {
      return "Good Afternoon,";
    } else {
      return "Good Morning,";
    }
  }

  @override
  void initState() {
    tabController = TabController(length: 5, vsync: this);
    setNotificationStop();
    setChurchDetails();
    super.initState();
  }

  setChurchDetails() async {
    var doc = await FirebaseFirestore.instance.collection('ChurchDetails').get();
    setState(() {
      churchName = doc.docs.first.get("name");
      churchImgUrl = doc.docs.first.get("logo");
    });
  }

  setNotificationStop() async {
    await Future.delayed(const Duration(seconds: 7));
    setState(() {
      isNotificationEnable = false;
    });
  }

  Future<CountsModel> setCounts() async {
    int noticesCount = 0;
    int eventsCount = 0;
    int blogsCount = 0;

    var noticesDocument =
        await FirebaseFirestore.instance.collection('Notices').get();
    var eventsDocument =
        await FirebaseFirestore.instance.collection('Events').get();
    var blogsDocument =
        await FirebaseFirestore.instance.collection('Blogs').get();

    noticesCount = noticesDocument.docs.length;
    noticesDocument.docs.forEach((element) {
      if (element.get("views").contains(widget.phone)) {
        setState(() {
          noticesCount--;
        });
      }
    });
    eventsCount = eventsDocument.docs.length;
    eventsDocument.docs.forEach((element) {
      if (element.get("views").contains(widget.phone)) {
        setState(() {
          eventsCount--;
        });
      }
    });
    blogsCount = blogsDocument.docs.length;
    blogsDocument.docs.forEach((element) {
      if (element.get("views").contains(widget.phone)) {
        setState(() {
          blogsCount--;
        });
      }
    });
    CountsModel counts = CountsModel(
        blogCount: blogsCount,
        eventCount: eventsCount,
        noticeCount: noticesCount);
    return counts;
  }

  bool? isPrivacyEnabled;

  setUserPrivacy(bool privacy) async {
    var document = await FirebaseFirestore.instance.collection('Users').doc(widget.userDocId).update({
      "isPrivacyEnabled": privacy
    });
  }

  String churchName = '';
  String churchImgUrl = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        leading: SizedBox(
          height: size.height / 43.3,
          width: size.width / 20.55,
          child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      showImageModel(context,(churchImgUrl == "") ? "https://firebasestorage.googleapis.com/v0/b/church-management-cbf7d.appspot.com/o/dailyupdates%2Fblank-profile-picture-973460_1280.png?alt=media&token=a9cde0ad-6cac-49d3-ae62-851a174e44b4" : churchImgUrl);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: (churchImgUrl != "")
                              ? CachedNetworkImageProvider(
                                  churchImgUrl,
                                )
                              : const CachedNetworkImageProvider(
                                  "https://firebasestorage.googleapis.com/v0/b/church-management-cbf7d.appspot.com/o/dailyupdates%2Fblank-profile-picture-973460_1280.png?alt=media&token=a9cde0ad-6cac-49d3-ae62-851a174e44b4"),
                        ),
                      ),
                    ),
                  ),
                )

          ),

        title: Text(
          churchName,
          style: GoogleFonts.amaranth(
            color: Colors.white,
            fontSize: Constants().getFontSize(context, "L"),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          StreamBuilder(
            stream: UserFireCrud.fetchUsersWithId(widget.uid),
            builder: (ctx, snaps) {
              if (snaps.hasData) {
                UserModel user = snaps.data!;
                isPrivacyEnabled = user.isPrivacyEnabled!;
                return Row(
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(widget.userDocId)
                          .collection("Notifications")
                          .snapshots(),
                      builder: (ctx, snapshots) {
                        if (snapshots.hasData) {
                          int count = 0;
                          snapshots.data!.docs.forEach((element) {
                            if (element.get("isViewed") == false) {
                              count++;
                            }
                          });
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => NotificationsView(
                                          userDocId: widget.userDocId)));
                            },
                            child: count == 0
                                ? ShakeAnimatedWidget(
                                    enabled: isNotificationEnable,
                                    duration: const Duration(milliseconds: 900),
                                    shakeAngle: Rotation.deg(z: 40),
                                    curve: Curves.linear,
                                    child: const Icon(
                                      CupertinoIcons.bell_solid,
                                      size: 28,
                                      color: Colors.white,
                                    ))
                                : Badge(
                                    label: Text(count.toString()),
                                    child: ShakeAnimatedWidget(
                                        enabled: isNotificationEnable,
                                        duration:
                                            const Duration(milliseconds: 900),
                                        shakeAngle: Rotation.deg(z: 40),
                                        curve: Curves.linear,
                                        child: const Icon(
                                          CupertinoIcons.bell_solid,
                                          size: 28,
                                          color: Colors.white,
                                        ))),
                          );
                        }
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => NotificationsView(
                                          userDocId: widget.userDocId)));
                            },
                            child: ShakeAnimatedWidget(
                                enabled: isNotificationEnable,
                                duration: const Duration(milliseconds: 900),
                                shakeAngle: Rotation.deg(z: 40),
                                curve: Curves.linear,
                                child: const Icon(
                                  CupertinoIcons.bell_solid,
                                  size: 28,
                                  color: Colors.white,
                                )));
                      },
                    ),
                    SizedBox(width: size.width / 41.1),
                    StatefulBuilder(
                      builder: (context,setState) {
                        return PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'Languages',
                              child: Text(
                                'Languages',
                                style: TextStyle(
                                    fontSize: Constants().getFontSize(context, "S")),
                              ),
                              onTap: () {},
                            ),
                            PopupMenuItem(
                              value: 'About Church',
                              child: KText(
                                text: 'About Church',
                                style: TextStyle(
                                    fontSize:
                                        Constants().getFontSize(context, "S")),
                              ),
                              onTap: () {},
                            ),
                            PopupMenuItem(
                              value: 'Church Pastors',
                              child: KText(
                                text: 'Church Pastors',
                                style: TextStyle(
                                    fontSize:
                                        Constants().getFontSize(context, "S")),
                              ),
                              onTap: () {},
                            ),
                            PopupMenuItem(
                              value: 'Social Media',
                              child: KText(
                                text: 'Social Media',
                                style: TextStyle(
                                    fontSize:
                                        Constants().getFontSize(context, "S")),
                              ),
                              onTap: () {},
                            ),
                            PopupMenuItem(
                              value: 'Contact Admin',
                              child: KText(
                                text: 'Contact Admin',
                                style: TextStyle(
                                    fontSize:
                                        Constants().getFontSize(context, "S")),
                              ),
                              onTap: () {},
                            ),
                            PopupMenuItem(
                              value: 'Edit Profile',
                              child: KText(
                                text: 'Edit Profile',
                                style: TextStyle(
                                    fontSize:
                                        Constants().getFontSize(context, "S")),
                              ),
                              onTap: () {},
                            ),
                            PopupMenuItem(
                              value: 'Privacy',
                              child: Row(
                                children: [
                                  KText(
                                    text: 'Privacy',
                                    style: TextStyle(
                                        fontSize:
                                        Constants().getFontSize(context, "S")),
                                  ),
                                  SizedBox(width: size.width/18),
                                  Switch(
                                    value: isPrivacyEnabled!,
                                    onChanged: (val) async {
                                      setUserPrivacy(val);
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                              onTap: () {},
                            ),
                            PopupMenuItem(
                              value: 'Log out',
                              child: KText(
                                text: 'Log out',
                                style: TextStyle(
                                    fontSize:
                                        Constants().getFontSize(context, "S")),
                              ),
                              onTap: () {},
                            )
                          ],
                          position: PopupMenuPosition.over,
                          offset: const Offset(0, 30),
                          color: const Color(0xffFFFFFF),
                          elevation: 2,
                          onSelected: (val) async {
                            switch (val) {
                              case "Languages":
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => LanguagesView(
                                            phone: user.phone!,
                                            uid: user.id!,
                                            userDocId: widget.userDocId)));
                                break;
                              case "Church Pastors":
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => const PastorsListView()));
                                break;
                              case "Social Media":
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => const SocialMediaView()));
                                break;
                              case "About Church":
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => const AboutChurchView()));
                                break;
                              case "Contact Admin":
                                _showContactAdminPopUp(context, user);
                                break;
                              case "Edit Profile":
                                // showEditProfilePopUp(context, user);
                                Navigator.push(context, MaterialPageRoute(builder: (ctx)=> EditProfileView(userDocId: widget.userDocId)));
                                break;
                              case "Log out":
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.warning,
                                    text: "Are you sure want to Logout",
                                    onConfirmBtnTap: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) => const IntroView()));
                                    },
                                    confirmBtnText: 'Log Out',
                                    cancelBtnText: 'Cancel',
                                    showCancelBtn: true,
                                    width: size.width * 0.4,
                                    backgroundColor: Constants()
                                        .primaryAppColor
                                        .withOpacity(0.8));
                                break;
                            }
                          },
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                          child: const Icon(Icons.settings,
                              size: 28, color: Colors.white)
                        );
                      }
                    ),
                    SizedBox(width: size.width / 27.4),
                  ],
                );
              }
              return Container();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width / 34.25, vertical: size.height / 173.2),
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollUpdateNotification) {
              if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                debugPrint('Reached the bottom');
                scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeIn);
              } else if (notification.metrics.pixels ==
                  notification.metrics.minScrollExtent) {
                debugPrint('Reached the top');
                scrollController.animateTo(
                    scrollController.position.minScrollExtent,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeIn);
              }
            }
            return true;
          },
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.01),
                StreamBuilder(
                  stream: UserFireCrud.fetchUsersWithId(widget.uid),
                  builder: (ctx, snaps) {
                    if (snaps.hasData) {
                      UserModel user = snaps.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: KText(
                              text: greeting(),
                              style: GoogleFonts.amaranth(
                                color: Colors.black,
                                fontSize: Constants().getFontSize(context, "L"),
                                fontWeight: FontWeight.w500,
                                textBaseline: TextBaseline.alphabetic,
                              ),
                            ),
                          ),
                          Text(
                            "${user.firstName!} ${user.lastName!}",
                            style: GoogleFonts.amaranth(
                                color: Constants().primaryAppColor,
                                fontSize:
                                    Constants().getFontSize(context, "XL"),
                                fontWeight: FontWeight.w600,
                                shadows: const [
                                  Shadow(
                                    color: Colors.white,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ]),
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
                SizedBox(height: size.height * 0.04),
                SizedBox(
                  child: BannerSlider(),
                ),
                // StreamBuilder(
                //   stream: FirebaseFirestore.instance.collection('SliderImages').snapshots(),
                //   builder: (ctx, snapshot) {
                //     if (snapshot.hasData) {
                //       return Column(
                //         children: [
                //           SizedBox(
                //             height: size.height * 0.22,
                //             width: double.infinity,
                //             child: CarouselSlider.builder(
                //                 itemCount: snapshot.data!.docs.length,
                //                 options: CarouselOptions(
                //                   viewportFraction: 1,
                //                   autoPlay: true,
                //                   autoPlayInterval: const Duration(seconds: 4),
                //                   autoPlayAnimationDuration: const Duration(seconds: 3),
                //                   initialPage: 0,
                //                   scrollPhysics: const NeverScrollableScrollPhysics(),
                //                   onPageChanged: ((index,reason){
                //                     setState(() {
                //                       sliderImageIndex = index;
                //                     });
                //                   }),
                //                 ),
                //                 itemBuilder: ( context,int index,options) {
                //                   return Padding(
                //                     padding: const EdgeInsets.symmetric(horizontal: 8),
                //                     child: SizedBox(
                //                         height:size.height * 0.22,
                //                         width: double.infinity,
                //                         child: ClipRRect(
                //                           borderRadius: BorderRadius.circular(10),
                //                           child: CachedNetworkImage(
                //                               width: double.infinity,
                //                               fit: BoxFit.fill,
                //                               fadeInDuration: const Duration(seconds: 1),
                //                               imageUrl: snapshot.data!.docs[index]['imgUrl']
                //                           ),
                //                         )
                //                     ),
                //                   );
                //                 },
                //             ),
                //           ),
                //           Center(
                //             child: DotsIndicator(
                //               dotsCount: snapshot.data!.docs.length,
                //               position: sliderImageIndex,
                //               decorator: DotsDecorator(
                //                 size: const Size.square(8.0),
                //                 activeSize: const Size(19.0, 8.0),
                //                 activeShape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(5.0),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ],
                //       );
                //     }
                //     return Container();
                //   },
                // ),
                SizedBox(height: size.height / 57.733333333),
                FutureBuilder(
                  future: setCounts(),
                  builder: (ctx, snap) {
                    if (snap.hasData) {
                      return SizedBox(
                        height: size.height * 0.8,
                        width: size.width,
                        child: Column(
                          children: [
                            Container(
                              height: size.height * 0.08,
                              width: size.width,
                              color: Colors.transparent,
                              child: TabBar(
                                tabAlignment: TabAlignment.start,
                                isScrollable: true,
                                indicatorPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                labelPadding: const EdgeInsets.all(10),
                                splashBorderRadius: BorderRadius.zero,
                                padding: EdgeInsets.symmetric(horizontal: 13),
                                splashFactory: NoSplash.splashFactory,
                                labelStyle: GoogleFonts.openSans(
                                  fontSize: size.width / 20,
                                  fontWeight: FontWeight.w800,
                                ),
                                unselectedLabelStyle: GoogleFonts.openSans(
                                  fontSize: size.width / 24,
                                  fontWeight: FontWeight.w600,
                                ),
                                controller: tabController,
                                tabs: [
                                  Tab(
                                    height: size.height / 17,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text('Notices'),
                                        Visibility(
                                            visible:
                                                snap.data!.noticeCount != 0,
                                            child: SizedBox(
                                                width: size.width * 0.01)),
                                        Visibility(
                                          visible: snap.data!.noticeCount != 0,
                                          child: Badge(
                                            backgroundColor:
                                                Constants().primaryAppColor,
                                            label: Text(
                                              snap.data!.noticeCount.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    height: size.height / 17,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('Events'),
                                        Visibility(
                                            visible: snap.data!.eventCount != 0,
                                            child: SizedBox(
                                                width: size.width * 0.01)),
                                        Visibility(
                                          visible: snap.data!.eventCount != 0,
                                          child: Badge(
                                            backgroundColor:
                                                Constants().primaryAppColor,
                                            label: Text(
                                              snap.data!.eventCount.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    height: size.height / 17,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('Blogs'),
                                        Visibility(
                                            visible: snap.data!.blogCount != 0,
                                            child: SizedBox(
                                                width: size.width * 0.01)),
                                        Visibility(
                                          visible: snap.data!.blogCount != 0,
                                          child: Badge(
                                            backgroundColor:
                                                Constants().primaryAppColor,
                                            label: Text(
                                              snap.data!.blogCount.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    height: size.height / 17,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text('Audio Podcasts'),
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    height: size.height / 17,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text('Video Ceremonies'),
                                      ],
                                    ),
                                  ),
                                ],
                                labelColor: Constants().primaryAppColor,
                                dividerColor: Colors.transparent,
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorColor: Constants().primaryAppColor,
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: size.width,
                                child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    NoticesListView(
                                        phone: widget.phone,
                                        scrollController: tabScrollController,
                                        hasScroll: tabIsScrollable),
                                    EventsListView(userId: widget.userDocId,phone: widget.phone,scrollController: tabScrollController,),
                                    BlogsListView(phone: widget.phone,scrollController: tabScrollController,),
                                    AudioPodcastsView(scrollController: tabScrollController,),
                                    VideoCeremoniesView(scrollController: tabScrollController,),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                )
                // Row(
                //   children: [
                //     KText(
                //       text: "Notices by Church",
                //       style: GoogleFonts.openSans(
                //         fontSize: Constants().getFontSize(context, 'M'),
                //         fontWeight: FontWeight.w700,
                //       ),
                //     ),
                //     Expanded(child: Container()),
                //     InkWell(
                //       onTap: () {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (ctx) => const NoticesListView()));
                //       },
                //       child: Icon(
                //         Icons.chevron_right_sharp,
                //         size: size.width/13.7,
                //       ),
                //     )
                //   ],
                // ),
                // SizedBox(height: size.height * 0.04),
                // SizedBox(
                //   height: size.height * 0.16,
                //   width: size.width,
                //   child: StreamBuilder(
                //     stream: NoticeFireCrud.fetchNotice(),
                //     builder: (ctx, snapshot) {
                //       if (snapshot.hasData) {
                //         List<NoticeModel> notices = snapshot.data!;
                //         return ListView.builder(
                //             scrollDirection: Axis.horizontal,
                //             itemCount: notices.length >= 3 ? 3 : notices.length,
                //             itemBuilder: (context, i) {
                //               return Padding(
                //                 padding: const EdgeInsets.only(right: 10),
                //                 child: InkWell(
                //                   onTap: () {
                //                     showNoticesPopUp(context, notices[i]);
                //                   },
                //                   child: SizedBox(
                //                     height: size.height * 0.07,
                //                     width: size.width * 0.9,
                //                     child: Card(
                //                       color: Colors.white,
                //                       child: Padding(
                //                         padding: const EdgeInsets.all(8.0),
                //                         child: Column(
                //                           crossAxisAlignment:CrossAxisAlignment.start,
                //                           mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                //                           children: [
                //                             Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment.spaceBetween,
                //                               children: [
                //                                 Text(
                //                                   notices[i].date!,
                //                                   style: GoogleFonts.openSans(
                //                                     color: Colors.grey,
                //                                     fontSize: Constants()
                //                                         .getFontSize(context, "S"),
                //                                     fontWeight: FontWeight.w600,
                //                                   ),
                //                                 ),
                //                                 Text(
                //                                   notices[i].time!,
                //                                   style: GoogleFonts.openSans(
                //                                     color: Colors.grey,
                //                                     fontSize: Constants()
                //                                         .getFontSize(context, "S"),
                //                                     fontWeight: FontWeight.w600,
                //                                   ),
                //                                 ),
                //                               ],
                //                             ),
                //                             SizedBox(height: size.height/86.6),
                //                             KText(
                //                               text: notices[i].title!,
                //                               style: GoogleFonts.openSans(
                //                                 fontSize: Constants()
                //                                     .getFontSize(context, 'SM'),
                //                                 color: Constants().primaryAppColor,
                //                                 fontWeight: FontWeight.bold,
                //                               ),
                //                             ),
                //                             SizedBox(height: size.height/86.6),
                //                             Expanded(
                //                               child: SizedBox(
                //                                 width: double.infinity,
                //                                 child: KText(
                //                                   text: notices[i].description!,
                //                                   style: GoogleFonts.openSans(
                //                                     fontSize: Constants().getFontSize(context, 'S'),
                //                                     color: const Color(0xff454545),
                //                                     fontWeight: FontWeight.w600,
                //                                   ),
                //                                 ),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               );
                //             });
                //       }
                //       return Container();
                //     },
                //   ),
                // ),
                // SizedBox(height: size.height/57.733333333),
                // Row(
                //   children: [
                //     KText(
                //       text: "Events",
                //       style: GoogleFonts.openSans(
                //         fontSize: Constants().getFontSize(context, 'M'),
                //         fontWeight: FontWeight.w700,
                //       ),
                //     ),
                //     Expanded(child: Container()),
                //     InkWell(
                //       onTap: () {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (ctx) =>
                //                     EventsListView(phone: widget.phone)));
                //       },
                //       child: Icon(
                //         Icons.chevron_right_sharp,
                //         size: size.width/13.7,
                //       ),
                //     )
                //   ],
                // ),
                // SizedBox(height: size.height/57.733333333),
                // SizedBox(
                //   height: size.height * 0.22,
                //   width: size.width,
                //   child: StreamBuilder(
                //     stream: EventsFireCrud.fetchEvents(),
                //     builder: (ctx, snapshot) {
                //       if (snapshot.hasData) {
                //         List<EventsModel> events = snapshot.data!;
                //         return ListView.builder(
                //             scrollDirection: Axis.horizontal,
                //             itemCount: events.length >= 3 ? 3 : events.length,
                //             itemBuilder: (context, j) {
                //               return Padding(
                //                 padding: const EdgeInsets.only(right: 10),
                //                 child: VisibilityDetector(
                //                   key: Key('my-widget-key $j'),
                //                   onVisibilityChanged:
                //                       (VisibilityInfo visibilityInfo) {
                //                     var visiblePercentage =
                //                         visibilityInfo.visibleFraction;
                //                       updateEventViewCount(events[j], widget.phone);
                //                   },
                //                   child: SizedBox(
                //                     width: size.width * 0.9,
                //                     child: Card(
                //                       color: Colors.white,
                //                       child: Container(
                //                         padding: const EdgeInsets.all(8.0),
                //                         margin: const EdgeInsets.all(1.0),
                //                         child: Row(
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.spaceEvenly,
                //                           children: [
                //                             InkWell(
                //                               onTap: () {
                //                                 showImageModel(
                //                                     context, events[j].imgUrl!);
                //                               },
                //                               child: Container(
                //                                 height: size.height * 0.16,
                //                                 width: size.width * 0.37,
                //                                 decoration: BoxDecoration(
                //                                   borderRadius: BorderRadius.circular(10),
                //                                   image: DecorationImage(
                //                                     fit: BoxFit.fill,
                //                                     image: CachedNetworkImageProvider(
                //                                       events[j].imgUrl!,
                //                                     ),
                //                                   ),
                //                                 ),
                //                               ),
                //                             ),
                //                             Center(
                //                               child: SizedBox(
                //                                 width: size.width * 0.43,
                //                                 child: Column(
                //                                   crossAxisAlignment: CrossAxisAlignment.start,
                //                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //                                   children: [
                //                                     SizedBox(
                //                                       child: Padding(
                //                                         padding: const EdgeInsets.symmetric(horizontal: 8),
                //                                         child: KText(
                //                                           text: events[j].title!,
                //                                           style: GoogleFonts.openSans(
                //                                             fontSize: Constants()
                //                                                 .getFontSize(context, 'M'),
                //                                             color: const Color(0xff000850),
                //                                             fontWeight: FontWeight.bold,
                //                                           ),
                //                                         ),
                //                                       ),
                //                                     ),
                //                                     Padding(
                //                                       padding: const EdgeInsets.symmetric(horizontal: 8),
                //                                       child: SizedBox(
                //                                         width: size.width * 0.5,
                //                                         child: Row(
                //                                           children: [
                //                                             Icon(Icons.date_range,
                //                                                 color: Constants()
                //                                                     .primaryAppColor),
                //                                             SizedBox(width: size.width/82.2),
                //                                             KText(
                //                                               text: events[j].date!,
                //                                               style: GoogleFonts.openSans(
                //                                                 fontSize: Constants()
                //                                                     .getFontSize(
                //                                                         context, 'S'),
                //                                                 color:
                //                                                     const Color(0xff454545),
                //                                                 fontWeight: FontWeight.w600,
                //                                               ),
                //                                             ),
                //                                           ],
                //                                         ),
                //                                       ),
                //                                     ),
                //                                     SizedBox(height: size.height/173.2),
                //                                     Padding(
                //                                       padding: const EdgeInsets.symmetric(horizontal: 8),
                //                                       child: SizedBox(
                //                                         width: size.width * 0.5,
                //                                         child: Row(
                //                                           children: [
                //                                             Icon(Icons.timelapse,
                //                                                 color: Constants()
                //                                                     .primaryAppColor),
                //                                             SizedBox(width: size.width/82.2),
                //                                             KText(
                //                                               text: events[j].time!,
                //                                               style: GoogleFonts.openSans(
                //                                                 fontSize: Constants()
                //                                                     .getFontSize(
                //                                                         context, 'S'),
                //                                                 color:
                //                                                     const Color(0xff454545),
                //                                                 fontWeight: FontWeight.w600,
                //                                               ),
                //                                             ),
                //                                           ],
                //                                         ),
                //                                       ),
                //                                     ),
                //                                     SizedBox(height: size.height/173.2),
                //                                     Padding(
                //                                       padding: const EdgeInsets.symmetric(horizontal: 8),
                //                                       child: SizedBox(
                //                                         width: size.width * 0.5,
                //                                         child: Row(
                //                                           children: [
                //                                             Icon(Icons.location_pin,
                //                                                 color: Constants()
                //                                                     .primaryAppColor),
                //                                             SizedBox(width: size.width/82.2),
                //                                             KText(
                //                                               text: events[j].location!,
                //                                               style: GoogleFonts.openSans(
                //                                                 fontSize: Constants()
                //                                                     .getFontSize(
                //                                                         context, 'S'),
                //                                                 color:
                //                                                     const Color(0xff454545),
                //                                                 fontWeight: FontWeight.w600,
                //                                               ),
                //                                             ),
                //                                           ],
                //                                         ),
                //                                       ),
                //                                     ),
                //                                     SizedBox(height: size.height/173.2),
                //                                     Padding(
                //                                       padding: const EdgeInsets.symmetric(horizontal: 8),
                //                                       child: SizedBox(
                //                                         width: size.width * 0.5,
                //                                         child: Row(
                //                                           children: [
                //                                             Icon(Icons.message_outlined,
                //                                                 color: Constants()
                //                                                     .primaryAppColor),
                //                                             SizedBox(width: size.width/82.2),
                //                                             SizedBox(
                //                                               width: size.width * 0.3,
                //                                               child: KText(
                //                                                 text: events[j].description!,
                //                                                 textOverflow: TextOverflow.ellipsis,
                //                                                 style: GoogleFonts.openSans(
                //                                                   fontSize: Constants().getFontSize(context, 'S'),
                //                                                   color:
                //                                                       const Color(0xff454545),
                //                                                   fontWeight: FontWeight.w600,
                //                                                 ),
                //                                               ),
                //                                             ),
                //                                           ],
                //                                         ),
                //                                       ),
                //                                     ),
                //                                   ],
                //                                 ),
                //                               ),
                //                             )
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               );
                //             });
                //       }
                //       return Container();
                //     },
                //   ),
                // ),
                // SizedBox(height: size.height/57.733333333),
                // Row(
                //   children: [
                //     KText(
                //       text: "Blogs",
                //       style: GoogleFonts.openSans(
                //         fontSize: Constants().getFontSize(context, 'M'),
                //         fontWeight: FontWeight.w700,
                //       ),
                //     ),
                //     Expanded(child: Container()),
                //     InkWell(
                //       onTap: () {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (ctx) => const BlogsListView()));
                //       },
                //       child: const Icon(
                //         Icons.chevron_right_sharp,
                //         size: 30,
                //       ),
                //     )
                //   ],
                // ),
                // SizedBox(height: size.height/57.733333333),
                // SizedBox(
                //   height: size.height * 0.22,
                //   width: size.width,
                //   child: StreamBuilder(
                //     stream: BlogFireCrud.fetchBlogs(),
                //     builder: (ctx, snapshot) {
                //       if (snapshot.hasData) {
                //         List<BlogModel> blogs = snapshot.data!;
                //         return ListView.builder(
                //             scrollDirection: Axis.horizontal,
                //             itemCount: blogs.length >= 3 ? 3 : blogs.length,
                //             itemBuilder: (context, j) {
                //               return Padding(
                //                 padding: const EdgeInsets.only(right: 10),
                //                 child: Card(
                //                   color: Colors.white,
                //                   child: SizedBox(
                //                     width: size.width * 0.88,
                //                     child: Row(
                //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //                       children: [
                //                         InkWell(
                //                           onTap: () {
                //                             showImageModel(context, blogs[j].imgUrl!);
                //                           },
                //                           child: Container(
                //                             height: size.height * 0.16,
                //                             width: size.width * 0.37,
                //                             decoration: BoxDecoration(
                //                               borderRadius: BorderRadius.circular(10),
                //                               image: DecorationImage(
                //                                 fit: BoxFit.fill,
                //                                 image: CachedNetworkImageProvider(
                //                                   blogs[j].imgUrl!,
                //                                 ),
                //                               ),
                //                             ),
                //                           ),
                //                         ),
                //                         Center(
                //                           child: SizedBox(
                //                             height: size.height * 0.18,
                //                             width: size.width * 0.43,
                //                             child: Column(
                //                               crossAxisAlignment:
                //                                   CrossAxisAlignment.start,
                //                               children: [
                //                                 SizedBox(
                //                                   child: Padding(
                //                                     padding: const EdgeInsets.symmetric(horizontal: 8),
                //                                     child: KText(
                //                                       text: blogs[j].title!,
                //                                       style: GoogleFonts.openSans(
                //                                         fontSize: Constants()
                //                                             .getFontSize(context, 'M'),
                //                                         color: const Color(0xff000850),
                //                                         fontWeight: FontWeight.bold,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 SizedBox(height: size.height/173.2),
                //                                 Padding(
                //                                   padding: const EdgeInsets.symmetric(horizontal: 8),
                //                                   child: SizedBox(
                //                                     height: size.height * 0.07,
                //                                     width: size.width * 0.5,
                //                                     child: KText(
                //                                       text: blogs[j].description!,
                //                                       style: GoogleFonts.openSans(
                //                                         fontSize: Constants()
                //                                             .getFontSize(context, 'S'),
                //                                         color: const Color(0xff454545),
                //                                         fontWeight: FontWeight.w600,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 SizedBox(height: size.height/173.2),
                //                                 Center(
                //                                   child: InkWell(
                //                                     onTap: () {
                //                                       Navigator.push(
                //                                           context,
                //                                           MaterialPageRoute(
                //                                               builder: (ctx) =>
                //                                                   BlogDetailsView(
                //                                                       id: blogs[j].id!)));
                //                                     },
                //                                     child: Container(
                //                                       height: 40,
                //                                       width: size.width * 0.38,
                //                                       decoration: BoxDecoration(
                //                                         color:
                //                                             Constants().primaryAppColor,
                //                                         borderRadius:
                //                                             BorderRadius.circular(10),
                //                                       ),
                //                                       child: Center(
                //                                         child: KText(
                //                                           text: "View Blog",
                //                                           style: TextStyle(
                //                                             fontSize: Constants()
                //                                                 .getFontSize(
                //                                                     context, 'S'),
                //                                             color: Colors.white,
                //                                             fontWeight: FontWeight.w600,
                //                                           ),
                //                                         ),
                //                                       ),
                //                                     ),
                //                                   ),
                //                                 )
                //                               ],
                //                             ),
                //                           ),
                //                         )
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               );
                //             });
                //       }
                //       return Container();
                //     },
                //   ),
                // ),
                // SizedBox(height: size.height/43.3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showNoticesPopUp(context, NoticeModel notice) async {
    Size size = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: size.height * 0.4,
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
                          text: notice.title!,
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
                Expanded(
                  child: Container(
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
                                  notice.date!,
                                  style: GoogleFonts.openSans(
                                    color: Colors.grey,
                                    fontSize:
                                        Constants().getFontSize(context, "S"),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  notice.time!,
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: size.height * 0.14,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: KText(
                                      text: notice.description!,
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
                          ],
                        )
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

  showImageModel(context, String imgUrl) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return PhotoView(
          imageProvider: CachedNetworkImageProvider(
            imgUrl,
          ),
        );
      },
    );
  }

  showEditProfilePopUp(context, UserModel user) async {
    Size size = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: size.height * 0.4,
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
                          text: "EDIT PROFILE",
                          style: GoogleFonts.openSans(
                            fontSize: Constants().getFontSize(context, 'M'),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              descriptionController.text = "";
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
                                      controller: descriptionController,
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
                                if (descriptionController.text != "") {
                                  Response response =
                                      await MessagesFireCrud.addMessage(
                                    content: descriptionController.text,
                                    userId: user.firstName!,
                                          phone: user.phone!
                                  );
                                  if (response.code == 200) {
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
                                  } else {
                                    await CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: "Failed to send Request!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    Navigator.pop(context);
                                  }
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

  Future<dynamic> _showContactAdminPopUp(
      BuildContext context, UserModel user) async {
    Size size = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: size.height * 0.4,
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
                          text: "Contact Admin",
                          style: GoogleFonts.openSans(
                            fontSize: Constants().getFontSize(context, 'M'),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              descriptionController.text = "";
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
                                  text: "Message",
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
                                      controller: descriptionController,
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
                                if (descriptionController.text != "") {
                                  Response response =
                                      await MessagesFireCrud.addMessage(
                                    content: descriptionController.text,
                                    userId: user.firstName!,
                                          phone: user.phone!
                                  );
                                  if (response.code == 200) {
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
                                  } else {
                                    await CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: "Failed to send Request!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    Navigator.pop(context);
                                  }
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

  updateEventViewCount(EventsModel event, String phone) async {
    List<String> views = [];
    event.views!.forEach((element) {
      views.add(element);
    });
    if (!views.contains(phone)) {
      views.add(phone);
    }
    var document = await FirebaseFirestore.instance
        .collection('Events')
        .doc(event.id)
        .update({"views": views});
  }
}

class CountsModel {
  CountsModel(
      {required this.noticeCount,
      required this.eventCount,
      required this.blogCount});

  int noticeCount;
  int eventCount;
  int blogCount;
}
