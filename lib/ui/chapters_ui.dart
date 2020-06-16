import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truck_learning/models/chapterlistmodel.dart';
import 'package:truck_learning/models/course_details_model.dart';
import 'package:truck_learning/services/save.dart';
import 'package:truck_learning/services/saveView.dart';
import 'package:truck_learning/ui/VideoView.dart';
import 'package:truck_learning/ui/imageView.dart';
import 'package:truck_learning/ui/pdf_view.dart';
import 'package:truck_learning/utils/colors.dart';
import 'package:truck_learning/utils/constants.dart';
import 'package:truck_learning/utils/customtextstyle.dart';
import 'package:truck_learning/utils/network_utils.dart';
import 'package:truck_learning/widgets/custom_progress_bar.dart';

import '../main.dart';
import 'package:flutter/material.dart';
class Chapters extends StatefulWidget
{
  String courseID;
  int index;
  String uid;
  CourseDetailsModel courseDetailsModel;

  Chapters(this.courseID, this.index, this.uid,this.courseDetailsModel);

  @override
  _ChaptersState createState() => _ChaptersState(courseID,index,uid,courseDetailsModel);
}

class _ChaptersState extends State<Chapters> with WidgetsBindingObserver implements SaveView
{
  List<ChaptersListModel> arraylist=List();
  List<ChaptersListModel> filteredUser=List();
  String courseID;
  int index;
  String uid;
  bool _isLoading = false;
  CourseDetailsModel courseDetailsModel;
  _ChaptersState(this.courseID, this.index, this.uid,this.courseDetailsModel);

  @override
  Widget build(BuildContext context)
  {
    print(uid);
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0,
        title: Text(courseDetailsModel.chapterName),
          backgroundColor: BackgroundColor,
      ),

      body: CustomProgressBar(
        isLoading: _isLoading,
        widget: Padding(
          padding: const EdgeInsets.only(left: 12,right: 12),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    Center(
                      child: Text("Approach",style: subHeaderTextStyleBlack,),
                    ),
                    SizedBox(height: 6,),
                    Center(
                      child: Text("${courseDetailsModel.totalLesson} Lessons",style: smallTitleTextStylePrimary,),
                    ),
                    SizedBox(height: 24,),
                    Text(courseDetailsModel.chapterDescription==null?"":courseDetailsModel.chapterDescription,style: mediumTitleTextStyle,),
                  ],
                ),
              ),
              SizedBox(height: 24,),

              _listView()
            ],
          ),
        ),
      ),
    );
  }

  Widget _listView()
  {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight:  Radius.circular(20)),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: arraylist==null?0:arraylist.length,
        itemBuilder: (context, index) =>
            _gridView(index),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
        ),
      ),

//      ListView.builder(
//          itemCount: arraylist==null?0:arraylist.length,
//          itemBuilder: (context,index) {
//            return Container(
//              padding: const EdgeInsets.only(left: 12,top: 12,right: 12),
//              child:_getList(filteredUser[index].contentType,index)
//            );
//          }),
    );
  }

  Widget _gridView(index)
  {
    String status=arraylist[index].contentStatus;
    String contentType=arraylist[index].contentType;
    Widget _icon;

    if(status=='Completed')
    {
      _icon=Icon(Icons.play_circle_filled,color: PrimaryButtonColor,size: 30,);
    }
    else if(status=='Pending')
    {
      _icon=Icon(Icons.lock,color: PrimaryButtonColor,size: 30,);
    }else
    {
      _icon=Icon(Icons.pause_circle_filled,color: PrimaryButtonColor,size: 30,);
    }

    return GestureDetector(
      onTap: (){
        _gotoViewPage(index,arraylist[index].contentType);

      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
                image: NetworkImage(plaseHolderImgUrl),fit: BoxFit.fill
            ),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Center(child: _icon),
              SizedBox(height: 12,),
              Text(arraylist[index].contentTitle,style: cardTextStyleWhiteSmall,),
              SizedBox(height: 12,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(contentType=='mp4'?arraylist[index].duration:'',style: mediumTitleTextStyle,),
                  _getType(contentType)
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
  Future<void> _getLoginData()
  async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      this.uid=sharedPref.getString('userId');
      print("User"+uid);
    });
    _getCourseData();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _getLoginData();
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getLoginData();
      //do your stuff
    }
  }

  Future<void> _getCourseData()
  async {
    bool connectionResult = await Utility.checkConnection();

    if(connectionResult)
    {
      setState(() {
        _isLoading=true;
      });

      SaveImpl(this,context).handleSaveView('', 'TakeCourse/takenLesson?userId=$uid&courseId=$courseID', 'GET','');
    }else{
      Utility.showToast(context, Error_No_Internet_Test);
    }
  }

  @override
  void onFailur(String error, String res, int code)
  {
    setState(() {
      _isLoading=false;
    });
   // print("Error"+res);
    // TODO: implement onFailur
  }

  @override
  void onSuccess(var res, String type,)
  {
    setState(() {
      _isLoading=false;
    });
   // print("Success"+res);
    // TODO: implement onSuccess
    _assignData(res);
  }

  void _assignData(String res)
  {
   // print(res);
    arraylist.clear();
    var data_= jsonDecode(res);
    List data = data_['chapterDetails'];
    List mediaContent=jsonDecode(data[index]['mediaContent']);
    print("$courseID"+mediaContent.toString());


    for(int i=0;i<mediaContent.length;i++)
    {
      ChaptersListModel courseListModel=ChaptersListModel();
      courseListModel.mediaContentId=mediaContent[i]['mediaContentId'].toString();
      courseListModel.contentDescription=mediaContent[i]['contentDescription'].toString();
      courseListModel.contentURL=mediaContent[i]['contentURL'].toString();
      courseListModel.contentType=mediaContent[i]['contentType'].toString();
      courseListModel.contentOrder=mediaContent[i]['contentOrder'].toString();
      courseListModel.contentTitle=mediaContent[i]['contentTitle'].toString();
      courseListModel.contentStatus=mediaContent[i]['contentStatus'].toString();
      courseListModel.courseLogDetailId=mediaContent[i]['courseLogDetailId'].toString();
      courseListModel.progressDetails=mediaContent[i]['progressDetails'].toString();
      courseListModel.duration=mediaContent[i]['duration'].toString();
     //
      // print(mediaContent[i]['progressDetails'].toString());
      arraylist.add(courseListModel);
    }
    filteredUser=arraylist;
  }

  Widget _getType(type)
  {
    Widget icon_;

    if(type=='txt')
    {
      icon_=Icon(Icons.text_format,color: Colors.white,);
    }
    else if(type=='mp4')
    {
      icon_=Icon(Icons.videocam,color: Colors.white,);
    }
    else if(type=='png')
    {
      icon_=Icon(Icons.image,color: Colors.white,);
    }
    else
    {
      icon_=Icon(Icons.picture_as_pdf,color: Colors.white,);
    }

    return icon_;

  }

  void _gotoViewPage(index,type)
  {

    Widget icon_;

    if(type=='txt')
    {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfView(arraylist[index],courseID,index,arraylist),
        ),
      ).then((value) {
        _getLoginData();
      });


//      Navigator.push(context,
//          MaterialPageRoute(builder: (BuildContext ctx) => PdfView(arraylist[index],courseDetailId)));

    }
    else if(type=='mp4')
    {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoView(arraylist[index],courseID,index,arraylist),
        ),
      ).then((value) {
        _getLoginData();
      }); }
    else if(type=='png'||type=='jpg'||type=='jpeg')
    {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageView(arraylist[index],courseID,index,arraylist),
        ),
      ).then((value) {
        _getLoginData();
      });
    }
    else
    {
      Navigator.push(context,
       MaterialPageRoute(builder: (context) => PdfView(arraylist[index],courseID,index,arraylist),),
      ).then((value) {
        _getLoginData();
      });
    }
  }
}
