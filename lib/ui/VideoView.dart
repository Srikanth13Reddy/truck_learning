import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:truck_learning/models/sub_course_list_model.dart';
import 'package:truck_learning/services/save.dart';
import 'package:truck_learning/services/saveView.dart';
import 'package:truck_learning/utils/ChewieListItem.dart';
import 'package:truck_learning/utils/colors.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  CourseListModel courseListModel;
  String courseDetailsId;

  VideoView(this.courseListModel,this.courseDetailsId);

  @override
  _VideoViewState createState() => _VideoViewState(courseListModel,courseDetailsId);
}

class _VideoViewState extends State<VideoView> implements SaveView
{

   CourseListModel courseListModel;
   String courseDetailsId;
   bool _isLoading=false;
  _VideoViewState(this.courseListModel,this.courseDetailsId);

  @override
  Widget build(BuildContext context)
  {
    print(courseListModel.contentURL);
    final button= SizedBox(
      width: 120,
      height: 42,
      child: RaisedButton(
        color: PrimaryButtonColor,
        child: Text('Finish',style: TextStyle(color: Colors.white),),
        onPressed: (){
          _saveCourseLog("Completed");
        },
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0)
        ),
      ),
    );
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
        _onBackpress();
      },
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: PrimaryButtonColor,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text(courseListModel.contentTitle,style: TextStyle(color: Colors.white),),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: SizedBox(
            height: 100,
            child: Center(
              child: button,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          color: Color.fromRGBO(102, 102, 102, 1),
          height: 300,
          child:  ChewieListItem(
            videoPlayerController: VideoPlayerController.network(courseListModel.contentURL,),
            looping: true,
            courseListModel: courseListModel,
            courseDetailsId: courseDetailsId,
          ),
        ),
      ),
    );
  }

  void _saveCourseLog(type)
  {
    var body = jsonEncode({
      "courseDetailId": courseDetailsId,
      "mediaContentId": courseListModel.mediaContentId,
      "contentStatus": type,
      "progressDetails": ""
    });
    setState(() {
      _isLoading=true;
    });

    SaveImpl(this,context).handleSaveView(body, 'TakeCourse/saveCourseLog', 'POST', 'saveCourseLog');

  }

  @override
  void onFailur(String error, String res, int code) {
    // TODO: implement onFailur
  }

  @override
  void onSuccess(String err, String res,)
  {
    Navigator.pop(context);
    // TODO: implement onSuccess
  }

  void _onBackpress()
  {
     _saveCourseLog('Progress');
  }
}
