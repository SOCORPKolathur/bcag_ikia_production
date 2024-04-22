import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Widgets/kText.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../models/user_model.dart';
import '../../services/messages_firecrud.dart';
import '../about_church_view.dart';
import '../intro_view.dart';
import '../languages_view.dart';
import '../notifications_view.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key, required this.user, required this.userDocId});

  final UserModel user;
  final String userDocId;

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {

  TextEditingController descriptionController = TextEditingController();

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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.28,
      width: size.width,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: [
                Container(
                  height: size.height * 0.07,
                  width: size.height * 0.07,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: (widget.user.imgUrl !=
                          null)
                          ? CachedNetworkImageProvider(
                        widget.user.imgUrl!,
                      )
                          : const CachedNetworkImageProvider(
                          "https://firebasestorage.googleapis.com/v0/b/church-management-cbf7d.appspot.com/o/dailyupdates%2Fblank-profile-picture-973460_1280.png?alt=media&token=a9cde0ad-6cac-49d3-ae62-851a174e44b4"),
                    ),
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => NotificationsView(userDocId: widget.userDocId)));
                      },
                      child: const Icon(
                        CupertinoIcons
                            .bell_solid,
                      ),
                    ),
                    const SizedBox(width: 10),
                    PopupMenuButton(
                      itemBuilder: (context) =>
                      [
                        PopupMenuItem(
                          value: 'Languages',
                          child: const KText(
                            text: 'Languages',
                            style: TextStyle(),
                          ),
                          onTap: () {},
                        ),
                        PopupMenuItem(
                          value: 'About Church',
                          child: const KText(
                            text:
                            'About Church',
                            style: TextStyle(),
                          ),
                          onTap: () {},
                        ),
                        PopupMenuItem(
                          value:
                          'Contact Admin',
                          child: const KText(
                            text:
                            'Contact Admin',
                            style: TextStyle(),
                          ),
                          onTap: () {},
                        ),
                        PopupMenuItem(
                          value: 'Edit Profile',
                          child: const KText(
                            text:
                            'Edit Profile',
                            style: TextStyle(),
                          ),
                          onTap: () {},
                        ),
                        PopupMenuItem(
                          value: 'Log out',
                          child: const KText(
                            text: 'Log out',
                            style: TextStyle(),
                          ),
                          onTap: () {},
                        )
                      ],
                      position:
                      PopupMenuPosition
                          .over,
                      offset:
                      const Offset(0, 30),
                      color: const Color(0xffFFFFFF),
                      elevation: 2,
                      onSelected: (val) async {
                        switch (val) {
                          case "Languages":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) =>
                                        LanguagesView(
                                          phone: widget.user.phone!,
                                            uid:
                                            widget.user.id!,userDocId: widget.userDocId)));
                            break;
                          case "About Church":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder:
                                        (ctx) =>
                                    const AboutChurchView()));
                            break;
                          case "Contact Admin":
                            _showContactAdminPopUp(context, widget.user);
                            break;
                          case "Edit Profile":
                            showEditProfilePopUp(context, widget.user);
                            break;
                          case "Log out":
                            CoolAlert.show(
                                context: context,
                                type: CoolAlertType.warning,
                                text: "Are you sure want to Logout",
                                onConfirmBtnTap: () async {
                                  await FirebaseAuth
                                      .instance
                                      .signOut();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder:
                                              (ctx) =>
                                          const IntroView()));
                                },
                                confirmBtnText: 'Log Out',
                                cancelBtnText: 'Cancel',
                                showCancelBtn: true,
                                width: size.width * 0.4,
                                backgroundColor:
                                Constants().primaryAppColor.withOpacity(0.8));
                            break;
                        }
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      child: const Icon(
                          Icons.settings),
                    ),
                    const SizedBox(width: 15),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(
                  text: greeting(),
                  style: TextStyle(
                      fontSize: Constants().getFontSize(context, "L"),
                      fontFamily: "ArgentumSans",
                  ),
                ),
                Text(
                  "${widget.user.firstName!} ${widget.user.lastName!}",
                  style: GoogleFonts.amaranth(
                    fontSize: Constants().getFontSize(context, "XL"),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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
}
