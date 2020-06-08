import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truck_learning/models/main_course_list_model.dart';
import 'package:truck_learning/models/sub_course_list_model.dart';
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
class ListCourse extends StatefulWidget
{
  String courseimg,courseDetailId;
  MainCourseListModel courseListModel;
  int index;



  ListCourse(this.courseimg, this.courseListModel, this.index,this.courseDetailId,);

  @override
  _ListCourseState createState() => _ListCourseState(courseimg,courseListModel,index,courseDetailId);
}

class _ListCourseState extends State<ListCourse> with WidgetsBindingObserver implements SaveView
{
  bool _isLoading = false;
  String courseimg,courseDetailId;
  MainCourseListModel courseListModel;
  int index;
  String uid;
  List<CourseListModel> arraylist=List();
  List<CourseListModel> filteredUser=List();


  _ListCourseState(this.courseimg, this.courseListModel, this.index,this.courseDetailId,);

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

  @override
  Widget build(BuildContext context)
  {
    return
       Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white
          ),
          backgroundColor:  PrimaryButtonColor,
          title: Text(courseListModel.courseName==null?'':courseListModel.courseName,style: TextStyle(color: Colors.white),),
        ),
        body: CustomProgressBar(
          isLoading: _isLoading,
          widget: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 220,
//                decoration: BoxDecoration(
//                    gradient: LinearGradient(
//                        begin: Alignment.topLeft,
//                        end: Alignment.topCenter,
//                        colors: [Colors.grey,Colors.black]
//                    )
////                  borderRadius: BorderRadius.circular(10)
//                ),
                child: Stack(
                   children: [
                     Container(
                       decoration:
                       BoxDecoration(
                         color: const Color(0xff585858),
                         image: new DecorationImage(
                           fit: BoxFit.cover,
                           colorFilter:
                           ColorFilter.mode(Colors.black.withOpacity(0.2),
                               BlendMode.dstATop),
                           image: new NetworkImage(
                             courseimg,
                           ),
                         ),
                       ),
                     ),

                   ],
                ),
              ),
              _listView()
            ],

          ),
        ),

    );
  }

  @override
  void onFailur(String error, String res, int code)
  {
    setState(() {
      _isLoading=false;
    });
    print(res);
    // TODO: implement onFailur
  }

  @override
  void onSuccess(var res, String type,)
  {
    setState(() {
      _isLoading=false;
    });
    print(res);
    // TODO: implement onSuccess
    _assignData(res);
  }

  Future<void> _getLoginData()
  async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      this.uid=sharedPref.getString('userId');
      print('userId');
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
        "password":courseListModel.vehicleTypeId==null?"0":courseListModel.vehicleTypeId,
      });
      SaveImpl(this,context).handleSaveView('', 'TakeCourse/takeCourse?userId=$uid&vehicleTypeId=${courseListModel.vehicleTypeId==null?"0":courseListModel.vehicleTypeId}', 'GET','');
    }else{
      Utility.showToast(context, Error_No_Internet_Test);
    }
  }

  void _assignData(String res)
  {
      print(res);
      arraylist.clear();
      var data_= jsonDecode(res);
      List data = data_['data'];
      List mediaContent=jsonDecode(data[index]['mediaContent']);
     // print(jsonDecode(mediaContent[2]));

      for(int i=0;i<mediaContent.length;i++)
        {
           CourseListModel courseListModel=CourseListModel();
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
           print(mediaContent[i]['progressDetails'].toString());
           arraylist.add(courseListModel);
        }
      filteredUser=arraylist;
  }

  Widget _listView()
  {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight:  Radius.circular(20)),
      ),
      margin: EdgeInsets.only(top: 150),
      child: GridView.builder(
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
                 image: AssetImage('images/mainpage_1.png'),fit: BoxFit.fill
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

  void _gotoViewPage(index,type)
  {

    Widget icon_;

    if(type=='txt')
    {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfView(arraylist[index],courseDetailId),
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
          builder: (context) => VideoView(arraylist[index],courseDetailId),
        ),
      ).then((value) {
        _getLoginData();
      }); }
    else if(type=='png')
    {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageView(arraylist[index],courseDetailId),
        ),
      ).then((value) {
        _getLoginData();
      });

    }
    else
    {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfView(arraylist[index],courseDetailId),
        ),
      ).then((value) {
        _getLoginData();
      });
    }
  }


}
