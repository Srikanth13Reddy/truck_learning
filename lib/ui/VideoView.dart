import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:truck_learning/models/chapterlistmodel.dart';
import 'package:truck_learning/services/save.dart';
import 'package:truck_learning/services/saveView.dart';
import 'package:truck_learning/ui/imageView.dart';
import 'package:truck_learning/ui/pdf_view.dart';
import 'package:truck_learning/utils/ChewieListItem.dart';
import 'package:truck_learning/utils/colors.dart';
import 'package:truck_learning/utils/customtextstyle.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  ChaptersListModel courseListModel;
  String courseDetailsId;
  List<ChaptersListModel> list;
  int index;

  VideoView(this.courseListModel,this.courseDetailsId,this.index,this.list);

  @override
  _VideoViewState createState() => _VideoViewState(courseListModel,courseDetailsId,index,list);
}

class _VideoViewState extends State<VideoView> implements SaveView
{
  List<ChaptersListModel> list;
  int index;
  ChaptersListModel courseListModel;
   String courseDetailsId;
   bool _isLoading=false;
  _VideoViewState(this.courseListModel,this.courseDetailsId,this.index,this.list);

  @override
  Widget build(BuildContext context)
  {
    print(courseListModel.contentURL);

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
          child: _getbottombar()
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              height: 300,
              child:  ChewieListItem(
                videoPlayerController: VideoPlayerController.network(courseListModel.contentURL,),
                looping: true,),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text("Description : ${courseListModel.contentDescription}",style: mediumTitleTextStyle,)
                ],
              ),
            )
          ],
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

  Widget _getbottombar()
  {
    return Padding(
      padding: const EdgeInsets.only(left: 12,right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: index==0?false:true,
            child: SizedBox(
              height: 100,
              child: Center(
                child: _getPreviousbtn(),
              ),
            ),
          ),
          Visibility(
            visible: true,
            child: SizedBox(
              height: 100,
              child: Center(
                child: _getNextbtn(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getPreviousbtn()
  {
    return SizedBox(
      width: 120,
      height: 42,
      child: RaisedButton(
        color: PrimaryButtonColor,
        child: Text('Previous',style: TextStyle(color: Colors.white),),
        onPressed: (){
          _saveCourseLog("Completed");
        },
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0)
        ),
      ),
    );
  }

  Widget _getNextbtn()
  {
    if(index==(list.length-1))
      {
        return SizedBox(
          width: 120,
          height: 42,
          child: RaisedButton(
            color: PrimaryButtonColor,
            child: Text('Finish',style: TextStyle(color: Colors.white),),
            onPressed: (){
              //_saveCourseLog("Completed");
            },
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)
            ),
          ),
        );
      }else{
      return SizedBox(
        width: 120,
        height: 42,
        child: RaisedButton(
          color: PrimaryButtonColor,
          child: Text('Next',style: TextStyle(color: Colors.white),),
          onPressed: (){
           // _saveCourseLog("Completed");
            _gotoViewPage();
          },
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)
          ),
        ),
      );
    }

  }


  void _gotoViewPage()
  {

    Widget icon_;
    String type=list[index+1].contentType;

    if(type=='txt')
    {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfView(list[index+1],courseDetailsId,index+1,list),
        ),
      ).then((value) {
        //_getLoginData();
      });


//      Navigator.push(context,
//          MaterialPageRoute(builder: (BuildContext ctx) => PdfView(arraylist[index],courseDetailId)));

    }
    else if(type=='mp4')
    {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoView(list[index+1],courseDetailsId,index+1,list),
        ),
      ).then((value) {
        //_getLoginData();
      }); }
    else if(type=='png'||type=='jpg'||type=='jpeg')
    {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageView(list[index+1],courseDetailsId,index+1,list),
        ),
      ).then((value) {
        // _getLoginData();
      });

    }
    else
    {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfView(list[index+1],courseDetailsId,index+1,list),
        ),
      ).then((value) {
        // _getLoginData();
      });
    }
  }

}
