import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truck_learning/models/CoursesModel.dart';
import 'package:truck_learning/models/truck_list_model.dart';
import 'package:truck_learning/models/wish_list_model.dart';
import 'package:truck_learning/services/save.dart';
import 'package:truck_learning/services/saveView.dart';
import 'package:truck_learning/ui/VideoView.dart';
import 'package:truck_learning/ui/course_details.dart';
import 'package:truck_learning/utils/colors.dart';
import 'package:truck_learning/utils/constants.dart';
import 'package:truck_learning/utils/customtextstyle.dart';
import 'package:truck_learning/utils/network_utils.dart';
import 'package:truck_learning/widgets/custom_progress_bar.dart';

class Course extends StatefulWidget {
  @override
  _CourscState createState() => _CourscState();
}

class _CourscState extends State<Course> implements SaveView
{
  bool _isLoading = false;
  List<CoursesModel> arraylist=List();
  List<CoursesModel> filteredUser=List();
  List<CoursesModel> historylist=List();
  List<CoursesModel> filterehistory=List();

  List<WishListModel> list_wish=List();
  List<WishListModel> filteredwishlist=List();

  int index=0;
  String uid;
  var tv_all=Text('All course',style: mediumTitleTextStylePrimary,);
  var tv_his=Text('History',style: mediumTitleTextStyle,);
  var tv_wish=Text('Wishlist',style: mediumTitleTextStyle,);

  var names=['Dump Truck','Box Truck','Over The Road Cap'];

  var data=['https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRIF10pytlZ4So53XwyO-YN3ka-AvtqGT_RwVaC0_48wZ6mtwlx&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSi5U14-1_ikgXXCfKU7uZYLE2lj6JNKZWAeMkOMsCGjMswNGR0&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ6lcQlPt2V5TQ-_gUodTQX8L7dfenMDlVfqBXgjcQ_0sGfuZOc&usqp=CAU' ];


//    void _getData()
//    {
//      for(int i=0;i<names.length;i++)
//        {
//           CourseModel courseModel=CourseModel();
//           courseModel.name=names[i];
//           courseModel.img=data[i];
//           arraylist.add(courseModel);
//        }
//      filteredUser=arraylist;
//    }

  @override
  Widget build(BuildContext context)
  {


    return Scaffold(
        backgroundColor: BackgroundColor,
        appBar: AppBar(
          brightness: Brightness.dark,
          elevation: 0,
          centerTitle: true,
          backgroundColor: BackgroundColor,
          title: Text('Course'),
        ),
        body:  CustomProgressBar(
          isLoading: _isLoading,
          widget: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _searchBar(),
                SizedBox(height: 12,),
                Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 12,right: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            print("All");
                            index=0;
                             tv_all=Text('All course',style: mediumTitleTextStylePrimary,);
                             tv_his=Text('History',style: mediumTitleTextStyle,);
                             tv_wish=Text('Wishlist',style: mediumTitleTextStyle,);
                          });
                        },
                          child: tv_all),
                      VerticalDivider(color: Colors.grey,),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            index=1;
                            print("his");
                            tv_all=Text('All course',style: mediumTitleTextStyle,);
                            tv_his=Text('History',style: mediumTitleTextStylePrimary,);
                            tv_wish=Text('Wishlist',style: mediumTitleTextStyle,);
                          });
                        },
                          child: tv_his),
                      VerticalDivider(color: Colors.grey,),
                      GestureDetector(
                          onTap: (){
                            setState(() {
                              index=2;
                              print("wish");
                              tv_all=Text('All course',style: mediumTitleTextStyle,);
                              tv_his=Text('History',style: mediumTitleTextStyle,);
                              tv_wish=Text('Wishlist',style: mediumTitleTextStylePrimary,);
                            });
                          },
                          child: tv_wish),

                    ],
                  ),
                ),
                SizedBox(height: 12,),
                _showData()
              ],
            ),
          ),
        ),
      );
  }

  Widget _searchBar()
  {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 18),
          hintText: 'Search....',
          prefixIcon: Icon(Icons.search,color: PrimaryButtonColor,),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),

        onChanged: (string){
          setState(()
          {
            if(index==0)
              {
                filteredUser=arraylist.where((element) => (element.courseName.toLowerCase().contains(string.toLowerCase()))).toList();

              }else if(index==1)
            {
              filterehistory=historylist.where((element) => (element.courseName.toLowerCase().contains(string.toLowerCase()))).toList();

            }
            else if(index==2)
            {
              filteredwishlist=list_wish.where((element) => (element.courseName.toLowerCase().contains(string.toLowerCase()))).toList();

            }
          });
        },
      ),
    );
  }

  Widget _listView()
  {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
        ),
        margin: EdgeInsets.only(bottom: 6),
        child: ListView.builder(
            itemCount: filteredUser.length==null?0:filteredUser.length,
            itemBuilder: (context,index) {
              return Padding(
                padding: const EdgeInsets.only(left: 12,top: 12,right: 12),
                child: GestureDetector(
                  onTap: (){
                      },
                  child: Column(
                    children: [
                      ListTile(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext ctx) => CourseDetails(filteredUser[index].courseId.toString())));
                        },
                        title: Text(filteredUser[index].courseName,style: averageTitleTextStyleBlackBold,),
                        subtitle: Text("${filteredUser[index].totalChapter} chapter ,${filteredUser[index].totalLesson} lessons",style: mediumTitleTextStyle,),
                        leading: CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(filteredUser[index].courseURL.isEmpty?"https://img.etb2bimg.com/files/cp/upload-0.92099500%2015822828078880-heavy-truck.jpg":filteredUser[index].courseURL),
                        ),
                      ),
                      Divider()
                    ],
                  ),
                ),
              );
            }),
      ),
    );
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
      this.uid=sharedPref.getString('userId');
      print('userId');
    });

    _getData();

  }

  @override
  void onFailur(String error, String res, int code) {
    // TODO: implement onFailur
    print(res);
    setState(() {
      _isLoading=false;
    });
    var data= jsonDecode(res);
    Utility.showToast(context, data['errorMessage']);
  }

  @override
  void onSuccess(var res, String type,)
  {
    setState(() {
      _isLoading=false;
    });
    print(res);
    _assignData(res);
    // TODO: implement onSuccess
  }

  void _assignData(res)
  {
    var data_=jsonDecode(res);
    List listdata = data_['data'];
    List history = data_['history'];
    List wishList = data_['wishList'];
    for(int i=0;i<listdata.length;i++)
    {
      CoursesModel courseModel=CoursesModel();
      courseModel.courseId=listdata[i]['courseId'];
      courseModel.courseName=listdata[i]['courseName'];
      courseModel.courseDescription=listdata[i]['courseDescription'].toString();
      courseModel.courseURL=listdata[i]['courseURL'].toString();
      courseModel.createdDate=listdata[i]['createdDate'].toString();
      courseModel.totalChapter=listdata[i]['totalChapter'];
      courseModel.totalLesson=listdata[i]['totalLesson'];
      arraylist.add(courseModel);
    }
    filteredUser=arraylist;

    for(int i=0;i<history.length;i++)
    {
      CoursesModel courseModel=CoursesModel();
      courseModel.courseId=history[i]['courseId'];
      courseModel.courseName=history[i]['courseName'];
      courseModel.courseDescription=history[i]['courseDescription'].toString();
      courseModel.courseURL=history[i]['courseURL'].toString();
      courseModel.createdDate=history[i]['createdDate'].toString();
      courseModel.totalChapter=history[i]['totalChapter'];
      courseModel.totalLesson=history[i]['totalLesson'];
      historylist.add(courseModel);
    }

    filterehistory=historylist;


    for(int i=0;i<wishList.length;i++)
    {
      WishListModel courseModel=WishListModel();
      courseModel.courseId=wishList[i]['courseId'].toString();
      courseModel.courseName=wishList[i]['courseName'];
      courseModel.courseDescription=wishList[i]['courseDescription'].toString();
      courseModel.courseURL=wishList[i]['courseURL'].toString();
      courseModel.createdDate=wishList[i]['createdDate'].toString();
      courseModel.chapterDetails=wishList[i]['chapterDetails'];
      list_wish.add(courseModel);
    }
    filteredwishlist=list_wish;
    print(list_wish);
  }

  Widget _showData()
  {
    if(index==0)
      {
        return _listView();
      }
    else if(index==1)
    {
      return _historyList();
    }
    else if(index==2)
    {
      return _wishList();
    }


  }

  Widget _wishList()
  {
    return  Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: filteredwishlist.length,
        itemBuilder: (context, index) =>
            _gridView(index),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
        ),
      ),
    );
  }

  Widget _historyList()
  {
    return  Expanded(
      child: ListView.builder(
          itemCount: filterehistory==null?0:filterehistory.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context,index)
          {
            return Column(
              children: [
                GestureDetector(
                  onTap: (){
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (BuildContext ctx) => Chapters(courseId,index,uid)));
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                          image: NetworkImage(filterehistory[index].courseURL==null?plaseHolderImgUrl:filterehistory[index].courseURL),fit: BoxFit.fill
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
                          Text(filterehistory[index].courseName,style: mediumTitleTextStyleBlackBold,),
                          Icon(Icons.favorite_border,color: PrimaryButtonColor,)
                        ],
                      ),
                      SizedBox(height: 12,),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(filterehistory[index].totalLesson.toString(),style: mediumTitleTextStyle,),
                            //_getIndicator(index)
                          ],
                        ),
                      )

                    ],
                  ),
                ),SizedBox(height: 12,)
              ],
            );
          }),
    );
  }

  Future<void> _getData() async 
  {
    bool connectionResult = await Utility.checkConnection();

    if(connectionResult)
    {
      setState(() {
        _isLoading=true;
      });

      SaveImpl(this,context).handleSaveView('', 'TakeCourse/Courses?userId=$uid', 'GET','');
    }else{
      Utility.showToast(context, Error_No_Internet_Test);
    }
  }

  Widget _gridView(index)
  {


    return Container(
      height: 250,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
      ),
      margin: EdgeInsets.only(top: 12),
      child: Column(
        children: [
          Container(
            height: 100,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                  image: NetworkImage(filteredwishlist[index].courseURL.isEmpty?plaseHolderImgUrl:filteredwishlist[index].courseURL),fit: BoxFit.fill),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              ),
            ),
          ),
          Container(
            width: 200,
            padding: EdgeInsets.only(left: 10,right: 10),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12,),
                Text(filteredwishlist[index].courseName,style: mediumTitleTextStyleBlackBold,),
                SizedBox(height: 10,),
                Text("${jsonDecode(filteredwishlist[index].chapterDetails).length.toString()} lessons ",style: mediumTitleTextStyle,),

              ],
            ),
          )
        ],
      ),
    );
  }
}
