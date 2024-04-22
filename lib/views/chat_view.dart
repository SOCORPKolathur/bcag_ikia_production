import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:church_management_client/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../services/user_firecrud.dart';

class ChatView extends StatefulWidget {
  ChatView({required this.userDocId, required this.uid, required this.collection, required this.title, required this.isClan,required this.clanId, required this.isCommittee,required this.committeeId});
  final String userDocId;
  final String uid;
  final String collection;
  final String title;
  final String clanId;
  final bool isClan;
  final String committeeId;
  final bool isCommittee;
  @override
  ChatViewState createState() => ChatViewState();
}

class ChatViewState extends State<ChatView> {
  ScrollController _scrollController = new ScrollController();

  TextEditingController chatMessage = new TextEditingController();

  UserModel currentUser = UserModel();

  setCurrentUser(UserModel user){
      currentUser = user;
  }

  List<UserModel> usersForNotify = [];


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Constants().primaryAppColor,
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                  widget.title == "Church"
                      ? Icons.church
                      : widget.title == "Members"
                      ? Icons.groups
                      : widget.title == "Blood Requirement"
                      ? Icons.bloodtype
                      : widget.isCommittee
                      ? Icons.groups
                      : widget.isClan
                      ? Icons.bookmark_add
                      : Icons.music_video_outlined,
                  size: width/13, color: Constants().primaryAppColor,
              ),
            ),
            SizedBox(width: width/41.1),
            Text(
              widget.title,
              style: GoogleFonts.amaranth(
                color: Colors.white,
                fontSize: Constants().getFontSize(context, "L"),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        elevation: 0,
        leadingWidth: width/13.7,
        leading: SizedBox(
          width: width/20.55,
          child: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.only(left: width/41.1,right: width/41.1),
                child: const Icon(Icons.arrow_back,color: Colors.white),
              )
          )
        ),
      ),
      body: StreamBuilder(
        stream: UserFireCrud.fetchUsersWithId(widget.uid),
        builder: (ctx, snaps){
          if(snaps.hasData){
            UserModel user = snaps.data!;
            setCurrentUser(user);
            return OfflineBuilder(
              connectivityBuilder: (
                  BuildContext context,
                  ConnectivityResult connectivity,
                  Widget child,
                  ) {
                if (connectivity == ConnectivityResult.none) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        vertical: height / 15.18, horizontal: width / 7.84),
                    child: Center(
                      child: Text(
                        "Oops,\nYou're offline",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: width / 7.84,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                } else {
                  return child;
                }
              },
              builder: (BuildContext context) {
                return
                  StreamBuilder<QuerySnapshot>(
                    stream: widget.isCommittee
                        ? FirebaseFirestore.instance
                        .collection('CommitteeChat').doc(widget.committeeId).collection('Chat')
                        .orderBy("time")
                        .snapshots()
                        : widget.isClan
                        ? FirebaseFirestore.instance
                        .collection('ClansChat').doc(widget.clanId).collection('Chat')
                        .orderBy("time")
                        .snapshots()
                        : FirebaseFirestore.instance
                        .collection(widget.collection)
                        .orderBy("time")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: height / 37.95, horizontal: width / 19.6),
                          child: SingleChildScrollView(
                            reverse: true,
                            child: Column(
                              children: <Widget>[
                                SingleChildScrollView(
                                  reverse: true,
                                  child: ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      scrollDirection: Axis.vertical,
                                      controller: _scrollController,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Column(
                                          crossAxisAlignment: snapshot.data!.docs[index]["sender"]=="${user.firstName!} ${user.lastName!}" ?CrossAxisAlignment.end: CrossAxisAlignment.start,
                                          children: [
                                            messageTile(Size(width, height), snapshot.data!.docs[index].data(),
                                                context,
                                                snapshot.data!.docs[index].id,user),
                                            snapshot.data!.docs[index]["submitdate"] == "${DateTime.now().year}-${ DateTime.now().month}-${ DateTime.now().day}" ?
                                            Text(
                                              'Today  ${snapshot
                                                  .data!
                                                  .docs[index]["submittime"]}',
                                              style: TextStyle(
                                                  fontSize: width /
                                                      40,
                                                  color: Colors
                                                      .grey,
                                                  fontWeight: FontWeight
                                                      .w700),)
                                                :
                                            snapshot
                                                .data!
                                                .docs[index]["submitdate"] ==
                                                "${DateTime
                                                    .now()
                                                    .year}-${ DateTime
                                                    .now()
                                                    .month}-${ DateTime
                                                    .now()
                                                    .day -
                                                    1}"
                                                ?
                                            Text(
                                              'Yesterday  ${snapshot
                                                  .data!
                                                  .docs[index]["submittime"]}',
                                              style: TextStyle(
                                                  fontSize: width /
                                                      40,
                                                  color: Colors
                                                      .grey,
                                                  fontWeight: FontWeight
                                                      .w700),)
                                                :
                                            Text(
                                              "${snapshot
                                                  .data!
                                                  .docs[index]["submitdate"]}  ${snapshot
                                                  .data!
                                                  .docs[index]["submittime"]}",
                                              style: TextStyle(
                                                  fontSize: width /
                                                      40,
                                                  color: Colors
                                                      .grey,
                                                  fontWeight: FontWeight
                                                      .w700),),
                                            Text(
                                              '${snapshot
                                                  .data!
                                                  .docs[index]["sender"]}',
                                              style: TextStyle(
                                                  fontSize: width /
                                                      40,
                                                  color: Colors
                                                      .grey,
                                                  fontWeight: FontWeight
                                                      .w700),),
                                            SizedBox(
                                              height: height /
                                                  80,)
                                          ],
                                        );
                                      }),
                                ),
                                SizedBox(
                                  height: height / 10.18,
                                )
                              ],
                            ),
                          ),
                        );
                      }return Container();
                    },
                  );
              },
            );
          }return Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: height / 15,
        width: double.infinity,
        child: SizedBox(
          height: height / 18,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                height: height / 18,
                width: width * 0.8,
                child: TextField(
                  controller: chatMessage,
                  onEditingComplete: onSendMessag,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      hintText: "Type here",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      )
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.send,color: Constants().primaryAppColor),
                  onPressed: onSendMessag
              ),
            ],
          ),
        ),

      ),
    );
  }

  Widget messageTile(Size size, chatMap,BuildContext context, id,UserModel user) {
    double width = MediaQuery.of(context).size.width;
    return Builder(builder: (_) {
      if (chatMap['type'] == "text") {
        return
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
                width: size.width,
                alignment:  chatMap['sender']== "${user.firstName!} ${user.lastName!}"? Alignment.centerRight: Alignment.centerLeft,
                child:
                GestureDetector(
                  onLongPress: () {
                    showDialog(context: context, builder: (ctx) =>
                        AlertDialog(
                          title: const Text('Are you sure delete this message'),
                          actions: [
                            TextButton(onPressed: () {
                              if(chatMap['sender']== "${user.firstName!} ${user.lastName!}"){
                                if(widget.isClan) {
                                  FirebaseFirestore.instance.collection("ClansChat").doc(widget.clanId).collection('Chat').doc(id).delete();
                                }else if(widget.isCommittee){
                                  FirebaseFirestore.instance.collection("CommitteeChat").doc(widget.committeeId).collection('Chat').doc(id).delete();
                                }else{
                                  FirebaseFirestore.instance.collection(widget.collection).doc(id).delete();
                                }
                              }
                              Navigator.pop(context);
                            }, child: const Text('Delete'))
                          ],
                        ));
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 8, horizontal: 14),
                      margin: EdgeInsets.symmetric(
                          vertical: 5, horizontal: 0),
                      decoration: BoxDecoration(
                        color:  chatMap['sender']=="${user.firstName!} ${user.lastName!}"? Colors.white: Constants().primaryAppColor,
                        border: Border.all(color: chatMap['sender']=="${user.firstName!} ${user.lastName!}"? Constants().primaryAppColor
                            .withOpacity(0.65) : Constants().primaryAppColor),
                        borderRadius: BorderRadius.only(topLeft: Radius
                            .circular(15),
                          bottomLeft: chatMap['sender']=="${user.firstName!} ${user.lastName!}"? Radius.circular(15) : Radius.circular(0),
                          bottomRight: chatMap['sender']=="${user.firstName!} ${user.lastName!}"? Radius.circular(0) : Radius.circular(15),
                          topRight: Radius.circular(15),),
                      ),
                      child: Column(
                        children: [
                          Text(
                            chatMap['message'],
                            style: GoogleFonts.montserrat(
                              fontSize: width/30.15384615,
                              fontWeight: FontWeight.w500,
                              color: chatMap['sender']=="${user.firstName!} ${user.lastName!}"? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      )),
                )
            ),
          );
      }
      else {
        return SizedBox();
      }
    });
  }

  void onSendMessag() async {
    String messageText = '';
    messageText = chatMessage.text;
    if (chatMessage.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "message": chatMessage.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
        "submittime":"${DateFormat('hh:mm a').format(DateTime.now())}",
        "sender": "${currentUser.firstName!} ${currentUser.lastName!}",
        "submitdate":"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
      };
      chatMessage.clear();
      if(widget.isClan){
        await FirebaseFirestore.instance.collection("ClansChat").doc(widget.clanId).collection('Chat').add(messages);
      }else if(widget.isCommittee){
        await FirebaseFirestore.instance.collection("CommitteeChat").doc(widget.committeeId).collection('Chat').add(messages);
      }else{
        await FirebaseFirestore.instance.collection(widget.collection).add(messages);
      }
      await sendNotification(messageText);
      messageText = '';
    }
    else {
      print("Enter Some Text");
    }
  }

  sendNotification(String message) async {
    var users = await FirebaseFirestore.instance.collection('Users').get();
    var members = await FirebaseFirestore.instance.collection('Members').get();
    var choruses = await FirebaseFirestore.instance.collection('Chorus').get();
    var clans = await FirebaseFirestore.instance.collection('Clans').get();

    switch(widget.title){
      case "Church":
        for (var element in users.docs) {
          if(element['fcmToken'] != null && element['fcmToken'] != ""){
            usersForNotify.add(UserModel.fromJson(element.data()));
          }
        }
        break;
      case "Members":
        for (var element in users.docs) {
          for(var member in members.docs){
            if(element['phone'] == member['phone'] && (element['fcmToken'] != null && element['fcmToken'] != "")){
              for (var element in users.docs) {
                usersForNotify.add(UserModel.fromJson(element.data()));
              }
            }
          }
        }
        break;
      case "Blood Requirement":
        for (var element in users.docs) {
          if(element['fcmToken'] != null && element['fcmToken'] != ""){
            usersForNotify.add(UserModel.fromJson(element.data()));
          }
        }
        break;
      // case "Clans":
      //   for (var element in users.docs) {
      //     for(var clan in clans.docs){
      //       if(element['phone'] == clan['phone'] && (element['fcmToken'] != null && element['fcmToken'] != "")){
      //         for (var element in users.docs) {
      //           usersForNotify.add(UserModel.fromJson(element.data()));
      //         }
      //       }
      //     }
      //   }
      //   break;
      case "Choir":
        for (var element in users.docs) {
          for(var chorus in choruses.docs){
            if(element['phone'] == chorus['phone'] && (element['fcmToken'] != null && element['fcmToken'] != "")){
              for (var element in users.docs) {
                usersForNotify.add(UserModel.fromJson(element.data()));
              }
            }
          }
        }
        break;
    }

    usersForNotify.removeWhere((element) => element.id == widget.uid);
    usersForNotify.forEach((element) {
      sendPushMessage(element.fcmToken!);
    });
  }



  Future<bool> sendPushMessage(String token) async {
    bool isSended = false;
    try {
      var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
          'key=${Constants.apiKeyForNotification}',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': chatMessage.text, 'title': "New Message from ${widget.title}"},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        isSended = true;
      } else {
        isSended = false;
      }
    } catch (e) {
      print("error push notification");
    }
    return isSended;
  }


}
