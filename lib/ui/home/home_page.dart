import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truck_learning/models/FeaturedCourseModel.dart';
import 'package:truck_learning/models/LastSeenCourseListModel.dart';
import 'package:truck_learning/services/save.dart';
import 'package:truck_learning/services/saveView.dart';
import 'package:truck_learning/ui/last_screen_ui.dart';
import 'package:truck_learning/ui/truck_types.dart';
import 'package:truck_learning/utils/colors.dart';
import 'package:truck_learning/utils/customtextstyle.dart';
import 'package:truck_learning/utils/network_utils.dart';
import 'package:truck_learning/widgets/custom_progress_bar.dart';
import 'package:truck_learning/widgets/custom_toast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements SaveView
{

  String name,uid;
  bool _isLoading=true;
  int _selectedIndex = 0;
  List<FeaturedCourseModel> feature_list=List();
  List<LastSeenCourseListModel> lastseen_list=List();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch(_selectedIndex)
      {
        case 0:
          CustomToast.show('WishList',context);
          print('WishList');
          break;
        case 1:
          CustomToast.show('Search',context);
          print('Search');
          break;
        case 2:
          CustomToast.show('My Courses',context);
          print('My Courses');
          break;
        case 3:
          CustomToast.show('Account',context);
          print('Account');
          break;

      }
    });
  }
  
  @override
  Widget build(BuildContext context)
  {
    return WillPopScope(
      onWillPop: () => _onCloseApp(),
      child: CustomProgressBar(
        isLoading: _isLoading,
        widget: Scaffold(
          bottomNavigationBar: _bottomNavBar(),
         backgroundColor: Colors.white,
          body: SafeArea(
            child: _featureList(),
          ),
        ),
      ),
    );
  }

  Widget _getStarted()
  {
    final button= SizedBox(
      width: 120,
      height: 42,
      child: RaisedButton(
        color: PrimaryButtonColor,
        child: Text('Get Started',style: TextStyle(color: Colors.white),),
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext ctx) => Coursc()));
        },
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0)
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Align(
        alignment: Alignment.topLeft,
        child: button,
      ),
    );
  }

  Widget _bottomNavBar()
  {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.white,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.star_border),
          title: Text('Wishlist'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text('Search'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_library,),
          title: Text('My Courses'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle,),
          title: Text('Account'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      onTap: _onItemTapped,
    );
  }

  Future<bool> _onCloseApp() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        contentPadding:
        EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 20),
        title: new Text('Are you sure ?',style: subHeaderTextStyleBlack,),
        content: new Text('Do you want to close the app.',),
        // actionsPadding: EdgeInsets.only(top: 5, bottom: 10, right: 10),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: roundedButton(
                "No", PrimaryButtonColor, const Color(0xFFFFFFFF)),
          ),
          new GestureDetector(
            onTap: () {
              exit(0);
            },
            child: roundedButton(" Yes ", Color.fromRGBO(108, 148, 53, 1),
                const Color(0xFFFFFFFF)),
          ),
        ],
      ),
    ) ??
        false;
  }

  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      margin: EdgeInsets.only(right: 5, bottom: 15),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(6.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: GoogleFonts.rubik(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.w500),
      ),
    );
    return loginBtn;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLogindata();
  }

  Future<void> _getLogindata() async
  {

    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      this.name=sharedPref.getString('firstName');
      this.uid=sharedPref.getString('userId');
    });
    _getMainData();


  }

  Widget _profile()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Hello,',
              style: subHeaderTextStyle,
            ),
            Text(
               name==null ? '' :name,
              style: subHeaderTextStyleBlack,
            ),
          ],
        ),
        CircleAvatar(
          radius: 26,
          backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQsgNl3WI0v1197ifiFN3c41xo2MrROkZEA00zi9JaTcxk1czS5&usqp=CAU'),
        )

      ],
    );
  }

   Widget _getStartCard()
   {
     return Container(
       width: double.infinity,
       height: 220,
       decoration: BoxDecoration(
           color: Colors.transparent,
           image: DecorationImage(
               image: AssetImage('images/mainpage_1.png'),fit: BoxFit.fill
           ),
           borderRadius: BorderRadius.circular(10)
       ),
       child: Padding(
         padding: const EdgeInsets.all(20.0),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             Text(' What do you \n Want to learn \n today ?',
               style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
             _getStarted()
           ],
         ),
       ),
     );
   }

  Widget _featured_()
  {
    return Container(
      height: 180,
      child: ListView.builder(
        itemCount: feature_list==null?0:feature_list.length,
          scrollDirection: Axis.horizontal,
          itemBuilder:(context,index)
          {

             return  Container(
                 decoration: BoxDecoration(
                     color: Colors.transparent,
                     image: DecorationImage(
                         image: AssetImage('images/mainpage_2.jpg'),fit: BoxFit.fill
                     ),
                     borderRadius: BorderRadius.circular(10)
                 ),
                 child: Padding(
                   padding: const EdgeInsets.only(bottom: 12),
                   child: Align(
                     alignment: Alignment.bottomCenter,
                     child: Text(feature_list[index].courseName,
                       style: TextStyle(color: Colors.white,
                           fontWeight: FontWeight.bold,fontSize: 18),),
                   ),
                 ),
                 margin: EdgeInsets.only(right: 12),
                 width: 300.0);
          }
      ),
    );
  }



   Widget _lastseenList()
   {
     return ListView.builder(
       shrinkWrap: true,
         itemCount: lastseen_list==null?0:lastseen_list.length,
         itemBuilder: (context,index)
             {
               return Card(
                   color: Color.fromRGBO(242, 248, 252, 1),
                   child: ListTile(
                     leading: CircleAvatar(
                       radius: 26,
                       backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQmrk0yixCU_8a_Szp3UdBblF1BM7XzPYJpli1LXx7aU1EtNNvE&usqp=CAU'),
                     ),
                     trailing:  CircularPercentIndicator(
                       radius: 40.0,
                       lineWidth: 2.0,
                       percent: 0.8,
                       center:Icon(
                         Icons.play_arrow,
                         size: 24.0,
                         color: Colors.orange,
                       ),
                       backgroundColor: Colors.grey,
                       progressColor: Colors.orange,
                     ),
                     title: Text(lastseen_list[index].courseName,style: TextStyle(fontWeight: FontWeight.bold),),
                     subtitle: Text(lastseen_list[index].courseDescription),));
             }
     );
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
    print(res);
    setState(() {
      _isLoading=false;
    });
      var data=jsonDecode(res);
      String status=data['status'];
      if(status=='Success')
        {
          _assignData(res);
        }
      else
        {
          Utility.showToast(context, data['message']);
        }

  }

  void _getMainData()
  {
      setState(() {
        _isLoading=true;
      });
      SaveImpl(this,context).handleSaveView('', "DashBoard/getUserDashboard?userId=$uid", 'GET', "");
  }

  void _assignData(String res)
  {
     var data=jsonDecode(res);
     List flist=data['featureCourse'] as List;
     List lslist=data['lastSeenCourse'] as List;
     for(int i=0;i<flist.length;i++)
       {
          FeaturedCourseModel featuredCourseModel=FeaturedCourseModel(flist[i]['courseId'].toString(),flist[i]['courseName'],flist[i]['courseCategory'],flist[i]['courseDescription'],flist[i]['mediaContentDetails'],);
          feature_list.add(featuredCourseModel);
       }

     for(int i=0;i<lslist.length;i++)
     {
       LastSeenCourseListModel featuredCourseModel=LastSeenCourseListModel(lslist[i]['courseDetailId'].toString(),lslist[i]['userId'].toString(),lslist[i]['courseId'].toString(),lslist[i]['courseName'],
         lslist[i]['courseCategory'],lslist[i]['courseDescription'],lslist[i]['courseStartDate'],lslist[i]['courseEndDate'],);
       lastseen_list.add(featuredCourseModel);
     }
  }

  Widget _featureList()
  {
    return ListView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(12),
      children: <Widget>[
        _profile(),
        SizedBox(height: 24,),
        _getStartCard(),
        SizedBox(height: 12,),
        Text(
          ' Featured',
          style: subHeaderTextStyleBlack,
        ),
        SizedBox(height: 12,),
        _featured_(),
        SizedBox(height: 24,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ' Last seen courses',
              style: subHeaderTextStyleBlack,
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext ctx) => LastSeenList(lastseen_list)));
              },
              child: Text(
                ' View all',
                style: TextStyle(color: PrimaryButtonColor,fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),

        SizedBox(height: 18,),
        _lastseenList()

      ],
    );
  }


}
