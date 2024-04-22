import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_management_client/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import '../Widgets/kText.dart';
import '../models/video_gallery_model.dart';

class AudioPodcastsView extends StatefulWidget {
  const AudioPodcastsView({super.key,required this.scrollController});

  final ScrollController scrollController;

  @override
  State<AudioPodcastsView> createState() => _AudioPodcastsViewState();
}

class _AudioPodcastsViewState extends State<AudioPodcastsView> {

  late VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("AudioPodcasts").orderBy("timestamp",descending: true).snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> podcasts = snapshot.data!.docs;
              return ListView.builder(
                controller: widget.scrollController,
                itemCount: podcasts.length,
                itemBuilder: (ctx, i) {
                  return InkWell(
                    onTap: (){
                      // _controller = VideoPlayerController.networkUrl(Uri.parse( podcasts[i].get("audioUrl")))
                      //   ..initialize().then((_) {
                      //     _controller.play();
                      //     showVideoModel(context);
                      //   });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        width: size.width,
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 3),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: (){
                                //showImageModel(context, blogs[i].imgUrl!);
                              },
                              child: Container(
                                height: size.height * 0.18,
                                width: size.width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: CachedNetworkImageProvider(
                                      podcasts[i].get("thumbUrl"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.4,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: size.height * 0.03,
                                      child: Text(
                                        podcasts[i].get("title"),
                                        maxLines: null,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.openSans(
                                          fontSize: Constants().getFontSize(context, 'M'),
                                          color: const Color(0xff000850),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size.height/173.2),
                                    Container(
                                      height: size.height * 0.05,
                                      width: size.width * 0.5,
                                      child: KText(
                                        text: podcasts[i].get("description"),
                                        style: GoogleFonts.openSans(
                                          fontSize: Constants().getFontSize(context, 'S'),
                                          color: const Color(0xff454545),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size.height/173.2),
                                    InkWell(
                                      onTap: () {
                                        _controller = VideoPlayerController.networkUrl(Uri.parse(
                                            podcasts[i].get("audioUrl")))
                                          ..initialize().then((_) {
                                            playPodCast(context,podcasts[i]);
                                          });
                                      },
                                      child: Container(
                                        height: size.height/21.65,
                                        width: size.width * 0.38,
                                        decoration: BoxDecoration(
                                          color: Constants().primaryAppColor,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: KText(
                                            text: "Play",
                                            style: TextStyle(
                                                fontSize: Constants().getFontSize(context, 'S'),
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
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
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }


  playPodCast(context,DocumentSnapshot snap) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setStat) {
            return Dialog(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              insetPadding: EdgeInsets.all(12),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height/217,
                          horizontal: width/455.33
                      ),
                      child: Container(
                        height: size.height * 0.54,
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Constants().primaryAppColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(
                                height: size.height * 0.25,
                                width: size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(snap.get("thumbUrl"))
                                  )
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                snap.get("title"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Vocal : " +snap.get("vocal"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Volume / Episode : " +snap.get("volume")+"/"+snap.get("episode"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: InkWell(
                                  onTap: (){
                                    if(_controller.value.isPlaying){
                                      setStat(() {
                                        _controller.pause();
                                      });
                                    }else{
                                      setStat(() {
                                        _controller.play();
                                      });
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 30,
                                    child: Center(
                                      child: Icon(
                                        _controller.value.isPlaying ? Icons.pause : Icons.play_arrow_sharp,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        // child: _controller.value.isInitialized
                        //     ? Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: AspectRatio(
                        //     aspectRatio: _controller.value.aspectRatio,
                        //     child: VideoPlayer(
                        //       _controller,
                        //     ),
                        //   ),
                        // ) : Container(child: Center(child: CircularProgressIndicator(),),),
                      )
                  ),
                  InkWell(
                    onTap: () {
                      _controller.pause();
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.cancel_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

}
