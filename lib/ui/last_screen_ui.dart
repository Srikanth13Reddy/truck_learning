import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:truck_learning/models/LastSeenCourseListModel.dart';
import 'package:truck_learning/utils/colors.dart';
class LastSeenList extends StatefulWidget
{
  List<LastSeenCourseListModel> lastseen_list;

  LastSeenList(this.lastseen_list);

  @override
  _LastSeenListState createState() => _LastSeenListState(lastseen_list);
}

class _LastSeenListState extends State<LastSeenList>
{
  List<LastSeenCourseListModel> lastseen_list;

  _LastSeenListState(this.lastseen_list);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: PrimaryButtonColor,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text('History',style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _lastseenList(),
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
}
