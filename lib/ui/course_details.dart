import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'file:///D:/ApptomateProjects/___national_training/truck_learning/lib/ui/chapters_ui.dart';
import 'package:truck_learning/models/course_details_model.dart';
import 'package:truck_learning/services/save.dart';
import 'package:truck_learning/services/saveView.dart';
import 'package:truck_learning/utils/colors.dart';
import 'package:truck_learning/utils/constants.dart';
import 'package:truck_learning/utils/customtextstyle.dart';
import 'package:truck_learning/utils/network_utils.dart';
import 'package:truck_learning/widgets/custom_progress_bar.dart';
class CourseDetails extends StatefulWidget
{
  String courseId;

  CourseDetails(this.courseId);


  @override
  _CourseDetailsState createState() => _CourseDetailsState(courseId);
}

class _CourseDetailsState extends State<CourseDetails> implements SaveView
{
  bool _isLoading = false;
  String name,uid,courseId;
  var courseDetails;
  List<CourseDetailsModel> arraylist=List();
  List<CourseDetailsModel> filteredUser=List();

  _CourseDetailsState(this.courseId);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        brightness: Brightness.dark,
        title: Text("Courses Details"),
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
                      child: Text(courseDetails==null?"":courseDetails['courseName'],style: subHeaderTextStyleBlack,),
                    ),
                    SizedBox(height: 6,),
                    Center(
                      child: Text(courseDetails==null?"":"${courseDetails['totalChapter']} Chapters ,${courseDetails['totalLesson']} Lessons",style: smallTitleTextStylePrimary,),
                    ),
                    SizedBox(height: 24,),
                    Text(courseDetails==null?"":courseDetails['courseDescription'],style: mediumTitleTextStyle,),
                  ],
                ),
              ),
              SizedBox(height: 24,),
              _list(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _list()
  {
     return ListView.builder(
         itemCount: arraylist==null?0:arraylist.length,
         shrinkWrap: true,
         physics: ClampingScrollPhysics(),
         itemBuilder: (context,index)
         {
           return Column(
             children: [
               GestureDetector(
                 onTap: (){
                   Navigator.push(context,
                       MaterialPageRoute(builder: (BuildContext ctx) => Chapters(courseId,index,uid,arraylist[index])));
                 },
                 child: Container(
                   height: 200,
                   decoration: BoxDecoration(
                     color: Colors.transparent,
                     image: DecorationImage(
                         image: NetworkImage(courseDetails==null?plaseHolderImgUrl:courseDetails['courseURL']),fit: BoxFit.fill
                     ),
                     borderRadius: BorderRadius.only(
                       topLeft: Radius.circular(10.0),
                       topRight: Radius.circular(10.0),
                       bottomLeft: Radius.zero,
                       bottomRight: Radius.zero,
                     ),
                   ),
                 ),
               ),
               Container(
                 padding: EdgeInsets.only(left: 10,right: 10),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.only(
                     topLeft: Radius.zero,
                     topRight: Radius.zero,
                     bottomLeft: Radius.circular(10.0),
                     bottomRight: Radius.circular(10.0),
                   ),
                 ),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     SizedBox(height: 12,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(arraylist[index].chapterName,style: mediumTitleTextStyleBlackBold,),
                         Icon(Icons.favorite_border,color: PrimaryButtonColor,)
                       ],
                     ),
                     SizedBox(height: 12,),
                     Padding(
                       padding: const EdgeInsets.only(bottom: 12),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text(arraylist[index].countWiseStatus,style: mediumTitleTextStyle,),
                           _getIndicator(index)
                         ],
                       ),
                     )

                   ],
                 ),
               ),SizedBox(height: 12,)
             ],
           );
         });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getData();
    _getLoginData();
  }
  Future<void> _getLoginData() async
  {
    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      this.name=sharedPref.getString('firstName');
      this.uid=sharedPref.getString('userId');
    });
    bool connectionResult = await Utility.checkConnection();

    if(connectionResult)
    {
      _getCourseDetails();
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
    print(res);

  }

  void _getCourseDetails()
  {
    setState(() {
      _isLoading=true;
    });
    SaveImpl(this,context).handleSaveView('', 'TakeCourse/takenLesson?userId=$uid&courseId=$courseId', 'GET','');
  }

  @override
  void onSuccess(String res, String type,)
  {
    setState(() {
      _isLoading=false;
    });
    print(res);
    _assignData(res);
  }

  void _assignData(res)
  {
    var data=jsonDecode(res);
     courseDetails=data['courseDetails'];
    List flist=data['chapterDetails'] as List;
    print(flist);
    for(int i=0;i<flist.length;i++)
      {
        CourseDetailsModel courseDetails=CourseDetailsModel();
        courseDetails.chapterId=flist[i]['chapterId'].toString();
        courseDetails.chapterName=flist[i]['chapterName'].toString();
        courseDetails.chapterDescription=flist[i]['chapterDescription'].toString();
        courseDetails.chapterOrder=flist[i]['chapterOrder'].toString();
        courseDetails.totalLesson=flist[i]['totalLesson'].toString();
        courseDetails.completedLesson=flist[i]['completedLesson'].toString();
        courseDetails.mediaContent=flist[i]['mediaContent'].toString();
        courseDetails.countWiseStatus=flist[i]['countWiseStatus'].toString();
        courseDetails.status=flist[i]['status'].toString();
        arraylist.add(courseDetails);

      }


  }

  Widget _getIndicator(int index)
  {

    double total= double.parse(arraylist[index].totalLesson);
    double completed= double.parse(arraylist[index].completedLesson);
    double percent=completed/total;

    return LinearPercentIndicator(
      width: 70.0,
      lineHeight: 6.0,
      percent: percent,
      progressColor: Colors.orange,
    );
  }
}
