import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truck_learning/models/FeaturedCourseModel.dart';
import 'package:truck_learning/models/LastSeenCourseListModel.dart';
import 'package:truck_learning/services/save.dart';
import 'package:truck_learning/services/saveView.dart';
import 'package:truck_learning/ui/course_.dart';
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
          break;
        case 1:
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext ctx) => Course()));

          break;
        case 2:
          break;
        case 3:
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
         backgroundColor:  Color(0xfff3f5f9),
          body: SafeArea(
            child: _featureList(),
          ),
        ),
      ),
    );
  }


  Widget _bottomNavBar()
  {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
     // unselectedItemColor: Colors.white,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          title: Text('Course'),),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border,),
          title: Text('Wishlist'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings,),
          title: Text('Settings'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: PrimaryButtonColor,
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





  @override
  void onFailur(String error, String res, int code)
  {
    print("Data"+res);
    setState(() {
      _isLoading=false;
    });

  }

  @override
  void onSuccess(String res, String type,)
  {
    print("Data"+res);
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
         lslist[i]['courseCategory'],lslist[i]['courseDescription'],lslist[i]['courseStartDate'],lslist[i]['courseEndDate'],lslist[i]['courseURL'],);
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
        _searchBar(),
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
//            GestureDetector(
//              onTap: (){
//                Navigator.push(context,
//                    MaterialPageRoute(builder: (BuildContext ctx) => LastSeenList(lastseen_list)));
//              },
//              child: Text(
//                ' View all',
//                style: TextStyle(color: PrimaryButtonColor,fontWeight: FontWeight.bold),
//              ),
//            ),
          ],
        ),

        SizedBox(height: 18,),
        _lastSeen()

      ],
    );
  }

  Widget _lastSeen()
  {
    return Container(
      height: 210,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lastseen_list==null?0:lastseen_list.length,
          itemBuilder: (context,index)
          {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              margin: EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    height: 140,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                          image: NetworkImage(lastseen_list[index].courseURL),fit: BoxFit.fill
                      ),
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
                        Text('CDL Class A',style: mediumTitleTextStyleBlackBold,),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Srikanth',style: mediumTitleTextStyle,),
                            LinearPercentIndicator(
                              width: 70.0,
                              lineHeight: 6.0,
                              percent: 0.7,
                              progressColor: Colors.orange,
                            ),
                          ],
                        )

                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget _featured_()
  {
    return Container(
      height: 210,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 20,
          itemBuilder: (context,index)
          {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              margin: EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    height: 140,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                          image: AssetImage('images/mainpage_2.jpg'),fit: BoxFit.fill
                      ),
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
                        Text('CDL Class A',style: mediumTitleTextStyleBlackBold,),
                        SizedBox(height: 10,),
                        Text('Srikanth',style: mediumTitleTextStyle,),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
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
          setState(() {
            // filteredUser=arraylist.where((element) => (element.vehicleType.toLowerCase().contains(string.toLowerCase()))).toList();
          });
        },
      ),
    );
  }

}
