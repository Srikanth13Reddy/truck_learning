import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:truck_learning/models/sub_course_list_model.dart';
import 'package:truck_learning/services/save.dart';
import 'package:truck_learning/services/saveView.dart';
import 'package:video_player/video_player.dart';

class ChewieListItem extends StatefulWidget {
  // This will contain the URL/asset path which we want to play
  int sec,min;
  final VideoPlayerController videoPlayerController;
  final bool looping;
  String courseDetailsId;
  CourseListModel courseListModel;
  ChewieListItem({
    @required this.videoPlayerController,
    this.looping,
    Key key,
    this.courseListModel,
    this.courseDetailsId
  }) : super(key: key);

  @override
  _ChewieListItemState createState() => _ChewieListItemState(courseListModel,courseDetailsId);
}

class _ChewieListItemState extends State<ChewieListItem> implements SaveView
{
  String pos;
  int sec;
  ChewieController _chewieController;
  String courseDetailsId;
  CourseListModel courseListModel;
  _ChewieListItemState(this.courseListModel,this.courseDetailsId);

  @override
  void initState() {
    super.initState();
    

    widget.videoPlayerController.addListener(checkVideo);
    // Wrapper on top of the videoPlayerController
    _chewieController = ChewieController
      (
      startAt: Duration(seconds: 0),
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 9,
      // Prepare the video to be played and display the first frame
      autoInitialize: true,
      looping: widget.looping,
      // Errors can occur for example when trying to play a video
      // from a non-existent URL
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },



    );

  }

  @override
  Widget build(BuildContext context)
  {
    setState(() {
      String details=courseListModel.progressDetails;
      sec=int.parse(details.substring(5).substring(0,2));
      print(sec);
    });
    print('Title'+courseListModel.progressDetails);
    
    return WillPopScope(
      onWillPop: (){
        _onBackPressed();
      },
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }

  void checkVideo()
  {
      setState(() {
        Duration duration=widget.videoPlayerController.value.position;
        this.pos=duration.toString();
        print(widget.videoPlayerController.value.position);
      });

    //print(widget.videoPlayerController.value.position);

    // Implement your calls inside these conditions' bodies :
    if(widget.videoPlayerController.value.position == Duration(seconds: 0, minutes: 0, hours: 0)) {
     // print('video Started');
    }

    if(widget.videoPlayerController.value.position == widget.videoPlayerController.value.duration) {
      //print('video Ended');
    }

    //print(widget.videoPlayerController.value.duration);

  }

  @override
  void dispose() {
    super.dispose();
    // IMPORTANT to dispose of all the used resources

     widget.videoPlayerController.dispose();
    _chewieController.dispose();

  }

  void _saveCourseLog(type)
  {

    var body = jsonEncode({
      "courseDetailId": courseDetailsId,
      "mediaContentId": courseListModel.mediaContentId,
      "contentStatus": type,
      "progressDetails": pos
    });

    SaveImpl(this,context).handleSaveView(body, 'TakeCourse/saveCourseLog', 'POST', 'saveCourseLog');

  }

  @override
  void onFailur(String error, String res, int code) {
    // TODO: implement onFailur
    print(res);
  }

  @override
  void onSuccess(String res, String type,)
  {

    print(res);
    // TODO: implement onSuccess
  }

   void _onBackPressed()
   {
     _saveCourseLog('Progress');
       Navigator.pop(context);
   }
}
