import 'dart:convert';

import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:truck_learning/models/sub_course_list_model.dart';
import 'package:truck_learning/services/save.dart';
import 'package:truck_learning/services/saveView.dart';
import 'package:truck_learning/utils/colors.dart';
import 'package:truck_learning/utils/customtextstyle.dart';
import 'package:truck_learning/widgets/custom_progress_bar.dart';

class ImageView extends StatefulWidget
{
  CourseListModel courseListModel;
  String courseDetailId;

  ImageView(this.courseListModel,this.courseDetailId);

  @override
  _ImageViewState createState() => _ImageViewState(courseListModel,courseDetailId);
}

class _ImageViewState extends State<ImageView> implements SaveView
{
  CourseListModel courseListModel;
  String courseDetailId;
  bool _isLoading=false;

  _ImageViewState(this.courseListModel,this.courseDetailId);

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: (){Navigator.pop(context);},
      child: CustomProgressBar(
        isLoading: _isLoading,
        widget: Scaffold(
          bottomNavigationBar: _getFinishButton(),
          appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: PrimaryButtonColor,
            iconTheme: IconThemeData(
                color: Colors.white
            ),
            title:  Text(courseListModel.contentTitle==null?'':courseListModel.contentTitle,style: TextStyle(color: Colors.white),),
          ),
          body: Container(
              child: PhotoView(
                imageProvider: NetworkImage(courseListModel.contentURL),
              )
          ),
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
}
