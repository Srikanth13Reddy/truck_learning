import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:truck_learning/models/truck_list_model.dart';
import 'package:truck_learning/services/save.dart';
import 'package:truck_learning/services/saveView.dart';
import 'package:truck_learning/ui/VideoView.dart';
import 'package:truck_learning/ui/course_list_main.dart';
import 'package:truck_learning/ui/sub_course_list.dart';
import 'package:truck_learning/utils/colors.dart';
import 'package:truck_learning/utils/constants.dart';
import 'package:truck_learning/utils/customtextstyle.dart';
import 'package:truck_learning/utils/network_utils.dart';
import 'package:truck_learning/widgets/custom_progress_bar.dart';

class Coursc extends StatefulWidget {
  @override
  _CourscState createState() => _CourscState();
}

class _CourscState extends State<Coursc> implements SaveView
{
  bool _isLoading = false;
  List<CourseModel> arraylist=List();
  List<CourseModel> filteredUser=List();

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
    return CustomProgressBar(
      isLoading: _isLoading,
      widget: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.dark,
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text('Course'),
        ),
        body:  Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _searchBar(),
                SizedBox(height: 12,),
                Text('Choose truck type',style: subHeaderTextStyleBlack,),
                SizedBox(height: 12,),
                _listView()
              ],
            ),
          ),
        ),

    );
  }

  Widget _searchBar()
  {
    return Container(
      decoration: BoxDecoration(
        color: BackgroundColor,
        borderRadius:  BorderRadius.circular(16),
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
            filteredUser=arraylist.where((element) => (element.vehicleType.toLowerCase().contains(string.toLowerCase()))).toList();
          });
        },
      ),
    );
  }

  Widget _listView()
  {
    return Expanded(
      child: ListView.builder(
          itemCount: filteredUser==null ? 0: filteredUser.length,
          itemBuilder: (context,index) {
            return Padding(
              padding: const EdgeInsets.only(left: 12,top: 12,right: 12),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext ctx) => MainCourseList(filteredUser[index].vehicleTypeId,filteredUser[index].vehicleImage,filteredUser[index].vehicleType)));
                },
                child: Container(
                  height: 200,
                  margin: EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                      color: const Color(0xff585858),
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter:
                        ColorFilter.mode(Colors.black.withOpacity(0.2),
                            BlendMode.dstATop),
                        image: new NetworkImage(filteredUser[index].vehicleImage,),
                      ),

                    border: Border.all(
                      color: BackgroundColor, //                   <--- border color
                      width: 1,
                    ),
                       borderRadius: BorderRadius.circular(10),
//                       gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomLeft,
//                           colors: [Colors.white,Colors.grey]
//                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Align(
                      child: Text(filteredUser[index].vehicleType,style: truckTextStyle,),
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getData();
    _getLoginData();
  }

  Future<void> _getLoginData() async {
    bool connectionResult = await Utility.checkConnection();

    if(connectionResult)
    {
      setState(() {
        _isLoading=true;
      });
      
      SaveImpl(this,context).handleSaveView('', 'VehicleType/VehicleTypes?count=25&offset=0', 'GET','');
    }else{
      Utility.showToast(context, Error_No_Internet_Test);
    }
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
    for(int i=0;i<listdata.length;i++)
    {
      CourseModel courseModel=CourseModel();
      courseModel.description=listdata[i]['description'];
      courseModel.vehicleType=listdata[i]['vehicleType'];
      courseModel.vehicleTypeId=listdata[i]['vehicleTypeId'].toString();
      courseModel.vehicleImage=listdata[i]['vehicleImage'].toString();
      arraylist.add(courseModel);
    }
    filteredUser=arraylist;
  }
}
