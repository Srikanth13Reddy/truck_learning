import 'dart:convert';

import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:truck_learning/models/chapterlistmodel.dart';
import 'package:truck_learning/services/save.dart';
import 'package:truck_learning/services/saveView.dart';
import 'package:truck_learning/ui/VideoView.dart';
import 'package:truck_learning/ui/pdf_view.dart';
import 'package:truck_learning/utils/colors.dart';
import 'package:truck_learning/utils/customtextstyle.dart';
import 'package:truck_learning/widgets/custom_progress_bar.dart';

class ImageView extends StatefulWidget
{
  ChaptersListModel courseListModel;
  String courseDetailId;
  List<ChaptersListModel> list;
  int index;

  ImageView(this.courseListModel,this.courseDetailId,this.index,this.list);

  @override
  _ImageViewState createState() => _ImageViewState(courseListModel,courseDetailId,index,list);
}

class _ImageViewState extends State<ImageView> implements SaveView
{
  ChaptersListModel courseListModel;
  String courseDetailId;
  bool _isLoading=false;
  List<ChaptersListModel> list;
  int index;
  _ImageViewState(this.courseListModel,this.courseDetailId,this.index,this.list);

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: (){Navigator.pop(context);},
      child: CustomProgressBar(
        isLoading: _isLoading,
        widget: Scaffold(
          bottomNavigationBar: _getbottombar(),
          appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: PrimaryButtonColor,
            iconTheme: IconThemeData(
                color: Colors.white
            ),
            title:  Text(courseListModel.contentTitle==null?'':courseListModel.contentTitle,style: TextStyle(color: Colors.white),),
          ),
          body: Column(
            children: [
              Container(
                height: 300,
                  child: PhotoView(
                    imageProvider: NetworkImage(courseListModel.contentURL),
                  )
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: 12,),
                    Text("Description : ${courseListModel.contentDescription}",style: mediumTitleTextStyle,)
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
  Widget _getFinishButton() {
    return BottomAppBar(
      child: Container(
        height: 60,
        child: Center(
          child: FlatButton(
            onPressed: (){
              _saveCourseLog();
            },
            child: Text('Finish',style: cardTextStyleWhite,),
          ),
        ),
      ),
      color: PrimaryButtonColor,
    );
  }

  void _saveCourseLog()
  {
    print(courseDetailId);
    var body = jsonEncode({
      "courseDetailId": courseDetailId,
      "mediaContentId": courseListModel.mediaContentId,
      "contentStatus": "Completed",
      "progressDetails": "Completed"
    });
    setState(() {
      _isLoading=true;
    });

    SaveImpl(this,context).handleSaveView(body, 'TakeCourse/saveCourseLog', 'POST', 'saveCourseLog');

  }

  @override
  void onFailur(String error, String res, int code) {
    print(res);
    setState(() {
      _isLoading=false;
    });
  }

  @override
  void onSuccess(String res, String type,) {
    print(res);
    setState(() {
      _isLoading=false;
    });
    var data=jsonDecode(res);
    if(data['message']=='Success')
      {
        Navigator.pop(context);
      }
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
          builder: (context) => PdfView(list[index+1],courseDetailId,index+1,list),
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
          builder: (context) => VideoView(list[index+1],courseDetailId,index+1,list),
        ),
      ).then((value) {
        //_getLoginData();
      }); }
    else if(type=='png'||type=='jpg'||type=='jpeg')
    {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageView(list[index+1],courseDetailId,index+1,list),
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
          builder: (context) => PdfView(list[index+1],courseDetailId,index+1,list),
        ),
      ).then((value) {
        // _getLoginData();
      });
    }
  }
}
