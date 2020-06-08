import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truck_learning/models/main_course_list_model.dart';
import 'package:truck_learning/services/save.dart';
import 'package:truck_learning/services/saveView.dart';
import 'package:truck_learning/ui/sub_course_list.dart';
import 'package:truck_learning/utils/colors.dart';
import 'package:truck_learning/utils/constants.dart';
import 'package:truck_learning/utils/customtextstyle.dart';
import 'package:truck_learning/utils/network_utils.dart';
import 'package:truck_learning/widgets/custom_progress_bar.dart';

class MainCourseList extends StatefulWidget
{
  String vehicleTypeId,vehicleImage,vehicleType;


  MainCourseList(this.vehicleTypeId, this.vehicleImage, this.vehicleType);

  @override
  _MainCourseListState createState() => _MainCourseListState(vehicleTypeId,vehicleImage,vehicleType);
}

class _MainCourseListState extends State<MainCourseList> implements SaveView
{
  bool _isLoading = false;
  String vehicleTypeId,vehicleImage,vehicleType;
  String uid;
  List<MainCourseListModel> course_list=List();
  List<MainCourseListModel> course_filter_list=List();
  _MainCourseListState(this.vehicleTypeId, this.vehicleImage, this.vehicleType);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: PrimaryButtonColor,
        title: Text(vehicleType,style: TextStyle(color: Colors.white),),
      ),
      body: CustomProgressBar(
        isLoading: _isLoading,
        widget: ListView.builder(
          itemCount: course_list==null?0:course_list.length,
            itemBuilder: (context,index)
                {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8,top: 8),
                    child: Card(
                      child: _getCourseStyle(index),
                    ),
                  );
                }
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLoginData();
  }

  Future<void> _getLoginData()
  async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      this.uid=sharedPref.getString('userId');
      print('userId'+vehicleTypeId);
    });
    _getCourseData();
  }

  Future<void> _getCourseData()
  async {
    bool connectionResult = await Utility.checkConnection();

    if(connectionResult)
    {
      setState(() {
        _isLoading=true;
      });

      var body = jsonEncode({
        "email": uid==null?"0":uid,
        "password":vehicleTypeId==null?"0":vehicleTypeId,
      });
      SaveImpl(this,context).handleSaveView('', 'TakeCourse/takeCourse?userId=1&vehicleTypeId=${vehicleTypeId==null?"0":vehicleTypeId}', 'GET','Get');
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

  @override
  void onSuccess(String res, String type,)
  {

    setState(() {
      _isLoading=false;
    });
    print(res);

    if(type!='Get')
      {
         var data=jsonDecode(res);
        int index=int.parse(type);
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext ctx) => ListCourse(vehicleImage,course_list[index],index,data['courseDetailId'].toString())));

      }else{
      _assignData(res);
    }


  }

  void _assignData(String res)
  {
    var data_= jsonDecode(res);
    List data = data_['data'];
    for(int i=0;i<data.length;i++)
      {
         MainCourseListModel model=MainCourseListModel(data[i]['courseId'].toString(),data[i]['courseName'].toString(),
         data[i]["courseCategory"].toString(),data[i]['courseDescription'].toString(),
             data[i]['vehicleTypeId'].toString(),data[i]['courseSortOrder'].toString(),
             data[i]['createdDate'].toString(),data[i]['vehicleType'].toString(),
             data[i]['userId'].toString(),data[i]['courseStartDate'].toString(),
             data[i]['courseEndDate'].toString(),data[i]['courseStatus'].toString(),
             data[i]['mediaContent'].toString());
         course_list.add(model);

      }
  }

   Widget _getCourseStyle(index)
   {
      Widget _icon;
      if(course_list[index].courseStatus=='Progressing')
        {
          _icon=Icon(Icons.pause_circle_filled,color: PrimaryButtonColor,size: 40,);
        }
      else if(course_list[index].courseStatus=='Completed')
      {
        _icon=Icon(Icons.play_circle_filled,color: PrimaryButtonColor,size: 30,);
      }
      else
      {
        _icon=Icon(Icons.lock,color: PrimaryButtonColor,size: 30,);
      }

      return ListTile(
        onTap: ()
        {
          _startCourse(index);
        },
        trailing: _icon,
        isThreeLine: false,
        title: Text(course_list[index].courseName==null?'':course_list[index].courseName,
        style: subHeaderTextStyleBlack,),
        subtitle: Padding(
          padding: const EdgeInsets.only(top:3.0),
          child: Text(course_list[index].courseDescription==null?'':course_list[index].courseDescription,
          style: mediumTitleTextStyleBlack,maxLines: 2,),
        ),
      );
   }

  void _startCourse(index)
  {

    var body = jsonEncode(
        {
          "courseId": course_list[index].courseId,
          "userId": uid
        }
    );
    setState(() {
      _isLoading=true;
    });

    SaveImpl(this,context).handleSaveView(body, 'TakeCourse/startCourse', 'POST', index.toString());

  }

}
