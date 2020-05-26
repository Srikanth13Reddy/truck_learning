import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:truck_learning/ui/coursc_ui.dart';
import 'package:truck_learning/utils/colors.dart';
import 'package:truck_learning/utils/customtextstyle.dart';
import 'package:truck_learning/widgets/custom_toast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{

  int _selectedIndex = 0;

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
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavBar(),
     backgroundColor: Colors.white,
      body: SafeArea(
        child: Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(12),
            children: <Widget>[
              Row(
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
                        'Srikanth',
                        style: subHeaderTextStyleBlack,
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQsgNl3WI0v1197ifiFN3c41xo2MrROkZEA00zi9JaTcxk1czS5&usqp=CAU'),
                  )

                ],
              ),
              SizedBox(height: 24,),
              Container(
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
              ),
              SizedBox(height: 12,),
              Text(
                ' Featured',
                style: subHeaderTextStyleBlack,
              ),
              SizedBox(height: 12,),
              Container(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
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
                          child: Text('Steps To Buying a Semi Truck\n'
                              'and Booking Flight',
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold,fontSize: 18),),
                        ),
                      ),
                      margin: EdgeInsets.only(right: 12),
                      width: 300.0),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                                image: AssetImage('images/mainpage_3.jpg'),fit: BoxFit.fill
                            ),
                            borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text('Steps To Buying a Semi Truck\n'
                                'and Booking Flight',
                              style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold,fontSize: 18),),
                          ),
                        ),
                        margin: EdgeInsets.only(right: 12),
                        width: 300.0),
                  ],
                ),
              ),
              SizedBox(height: 12,),
              Text(
                ' Last seen courses',
                style: subHeaderTextStyleBlack,
              ),
              SizedBox(height: 12,),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children:  <Widget>[
                    Card(
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
                        title: Text('Key Points For Section 1',style: TextStyle(fontWeight: FontWeight.bold),),
                         subtitle: Text('1 hour,20 min'),)),
                    Card(
                        color: Color.fromRGBO(252, 242, 242, 1),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 26,
                            backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQmrk0yixCU_8a_Szp3UdBblF1BM7XzPYJpli1LXx7aU1EtNNvE&usqp=CAU'),
                          ),
                          trailing:  CircularPercentIndicator(
                            radius: 40.0,
                            lineWidth: 2.0,
                            percent: 0.7,
                            center:Icon(
                              Icons.play_arrow,
                              size: 24.0,
                              color: Colors.orange,
                            ),
                            backgroundColor: Colors.grey,
                            progressColor: Colors.orange,
                          ),
                          title: Text('Key Points For Section 1',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('1 hour,20 min'),)),
                    Card(
                        color: Color.fromRGBO(242, 248, 252, 1),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 26,
                            backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQmrk0yixCU_8a_Szp3UdBblF1BM7XzPYJpli1LXx7aU1EtNNvE&usqp=CAU'),
                          ),
                          trailing:  CircularPercentIndicator(
                            radius: 40.0,
                            lineWidth: 2.0,
                            percent: 0.4,
                            center:Icon(
                              Icons.play_arrow,
                              size: 24.0,
                              color: Colors.orange,
                            ),
                            backgroundColor: Colors.grey,
                            progressColor: Colors.orange,
                          ),
                          title: Text('Key Points For Section 1',style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text('1 hour,20 min'),)),
                    Card(
                        color: Color.fromRGBO(252, 242, 242, 1),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 26,
                            backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQmrk0yixCU_8a_Szp3UdBblF1BM7XzPYJpli1LXx7aU1EtNNvE&usqp=CAU'),
                          ),
                          trailing:  CircularPercentIndicator(
                            radius: 40.0,
                            lineWidth: 2.0,
                            percent: 0.9,
                            center:Icon(
                              Icons.play_arrow,
                              size: 24.0,
                              color: Colors.orange,
                            ),
                            backgroundColor: Colors.grey,
                            progressColor: Colors.orange,
                          ),
                          title: Text('Key Points For Section 1',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('1 hour,20 min'),)),

                  ],
                ),
              )

            ],
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


}
