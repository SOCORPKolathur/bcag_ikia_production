import 'dart:io';
import 'dart:io' show Platform;
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/kText.dart';
import '../constants.dart';
import 'main_view.dart';
import 'package:geocoding/geocoding.dart' as gc;
import 'package:location/location.dart';

class OtpVerificationView extends StatefulWidget {
  String phone;

  OtpVerificationView({required this.phone});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  TextEditingController otp = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getUserLocation();
    gettoken();
    _verifyphone();
  }

  var _verificationCode;

  _verifyphone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91${widget.phone}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
            if (value.user != null) {
              var document = await FirebaseFirestore.instance.collection('Users').get();
              for (int i = 0; i < document.docs.length; i++) {
                if (document.docs[i]['phone'] == widget.phone) {
                  FirebaseFirestore.instance.collection('Users').doc(
                      document.docs[i].id).update({
                    "id": value.user!.uid,
                    "fcmToken": fcmToken
                  });
                  setState(() {
                    userId = document.docs[i].id;
                  });
                }
              }
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                          MainView(phone: value.user!.phoneNumber!,
                              uid: value.user!.uid,
                              userDocId: userId)),
                      (Route<dynamic> route) => false);
              Fluttertoast.showToast(
                  msg: "Logged In Successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  backgroundColor: Constants().primaryAppColor,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String? verificationid, int? resendtoken) {
          setState(() {
            _verificationCode = verificationid;
          });
        },
        codeAutoRetrievalTimeout: (String verificationid) {
          setState(() {
            _verificationCode = verificationid;
          });
        },
        timeout: Duration(seconds: 120));
  }

  bool ison = false;
  String userId = "";
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  var first;

  getUserLocation() async {//call this async method from whereever you need
    LocationData? myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    List<gc.Placemark> placemarks = await gc.placemarkFromCoordinates(myLocation!.latitude!, myLocation.longitude!);
    first = placemarks.first;
    print('${first.street},${first.subLocality}, ${first.locality},${first.administrativeArea}, ${first.postalCode}');
    return first;
  }

  reglog() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    FirebaseFirestore.instance.collection('LoginReports').doc().set({
    "deviceId": androidInfo.id,
    "deviceOs": Platform.isAndroid ? "Android" : Platform.isIOS ? "Ios" : "",
    "ip": (await NetworkInterface.list()).first.addresses.first.address,
    "location": '${first.street},${first.subLocality}, ${first.locality},${first.administrativeArea}, ${first.postalCode}',
    "date" : DateFormat('dd-MM-yyyy').format(DateTime.now()),
    "time" : DateFormat('hh:mm aa').format(DateTime.now()),
    "timestamp": DateTime.now().millisecondsSinceEpoch,
    });
  }

  String fcmToken="";
  gettoken() async {
    String? fcmTokenk = await FirebaseMessaging.instance.getToken();
    fcmToken=fcmTokenk!;
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/dolomite-alps-peaks-italy 1.png"),
            )),
          ),
          Container(
            height: size.height,
            width: size.width,
            color: Colors.white70,
          ),
          SizedBox(
            height: size.height,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: size.height * 0.3),
                    Column(
                      children: [
                        KText(
                          text: "Verify OTP",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: size.width/11.416666667,
                            color: const Color(0xff757879),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: size.height/173.2),
                        Text(
                          "Kindly enter your OTP below",
                          style: GoogleFonts.openSans(
                            fontSize: size.width/29.357142857,
                            color: const Color(0xff757879),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: size.height * 0.1),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height / 37.8,
                              horizontal: size.width / 18),
                          child: Container(
                            width: size.width / 1.028,
                            height: size.height / 12.6,
                            decoration: BoxDecoration(
                                color: const Color(0xff757879).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                                child: TextFormField(
                                  maxLength: 6,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                              controller: otp,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: "OTP",
                                counterText: "",
                                prefixIcon: const Icon(Icons.password),
                                labelText: "Code",
                                labelStyle: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.width / 26.84,
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.width / 26.84,
                                ),
                                border: InputBorder.none,
                              ),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: size.width / 22.84,
                              ),
                            )),
                          ),
                        ),
                        SizedBox(height: size.height/43.3),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(
                                          verificationId: _verificationCode,
                                          smsCode: otp.text,
                              )).then((value) async {
                                if (value.user != null) {
                                  var document = await FirebaseFirestore.instance.collection('Users').get();
                                  for (int i = 0; i < document.docs.length; i++) {
                                    if (document.docs[i]['phone'] == widget.phone) {
                                      FirebaseFirestore.instance.collection('Users').doc(document.docs[i].id).update({
                                        "id": value.user!.uid,
                                        "fcmToken" : fcmToken
                                      });
                                     setState(() {
                                       userId = document.docs[i].id;
                                     });
                                    }
                                  }
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MainView(phone: value.user!.phoneNumber!, uid: value.user!.uid,userDocId : userId)),
                                      (Route<dynamic> route) => false);
                                  Fluttertoast.showToast(
                                      msg: "Logged In Successfully",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.TOP,
                                      backgroundColor: Constants().primaryAppColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }
                              });
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height / 37.8,
                                horizontal: size.width / 18),
                            child: Container(
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Constants().primaryAppColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Verify OTP",
                                  style: GoogleFonts.openSans(
                                      fontSize: 17,
                                      color: const Color(0xffFFFFFF),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "",
                          style: GoogleFonts.openSans(
                              fontSize: 14, color: const Color(0xff757879)),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Edit Phone Number',
                              style: GoogleFonts.openSans(
                                color: Constants().primaryAppColor,
                                fontSize: size.width/29.357142857,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.height/173.2)
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: isLoading,
            child: Container(
              alignment: AlignmentDirectional.center,
              decoration: const BoxDecoration(
                color: Colors.white70,
              ),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                width: size.width/1.37,
                height: size.height/4.33,
                alignment: AlignmentDirectional.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        height: size.height/17.32,
                        width: size.height/17.32,
                        child: CircularProgressIndicator(
                          color: Constants().primaryAppColor,
                          value: null,
                          strokeWidth: 7.0,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 25.0),
                      child: Center(
                        child: Text(
                          "loading..Please wait...",
                          style: TextStyle(
                            color: Constants().primaryAppColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Constants().primaryAppColor, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              spreadRadius: 2.0,
              blurRadius: 8.0,
              offset: Offset(2, 4),
            )
          ],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.info_outline, color: Constants().primaryAppColor),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                "Invalid credentials",
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
            ),
          ],
        )),
  );

}
