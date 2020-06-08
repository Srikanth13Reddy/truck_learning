import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truck_learning/services/save.dart';
import 'package:truck_learning/services/saveView.dart';
import 'package:truck_learning/ui/home/home_page.dart';
import 'package:truck_learning/utils/colors.dart';
import 'package:truck_learning/utils/constants.dart';
import 'package:truck_learning/utils/customtextstyle.dart';
import 'package:truck_learning/utils/network_utils.dart';
import 'package:truck_learning/widgets/custom_progress_bar.dart';

class SignUpAditionalData extends StatefulWidget
{
  String uid;
  String name;
  String mailid;

  SignUpAditionalData(this.uid, this.name, this.mailid);

  @override
  _SignUpAditionalDataState createState() => _SignUpAditionalDataState(uid,name,mailid);
}

class _SignUpAditionalDataState extends State<SignUpAditionalData> implements SaveView
{
  String uid;
  String name;
  String mailid;
  final myController_email = TextEditingController();
  final myController_name = TextEditingController();
  final myController_mobile = TextEditingController();
  bool _isLoading=false;

  _SignUpAditionalDataState(this.uid, this.name, this.mailid);

  @override
  Widget build(BuildContext context)
  {

    final name_=TextFormField(
      controller: myController_name,
      keyboardType: TextInputType.text,
      autofocus: false,
      enabled: false,
      onSaved: (e) => this.name = e,
      decoration: InputDecoration(
          hintText: name,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          )
      ),
    );
    final email_=TextFormField(
      controller: myController_email,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      enabled: false,
      decoration: InputDecoration(
          hintText: mailid,
          prefixIcon: Icon(Icons.email),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          )
      ),
    );
    final mobile_=TextFormField(
      controller: myController_mobile,
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
          hintText: 'Mobile Number',
          prefixIcon: Icon(Icons.phone),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          )
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: PrimaryButtonColor,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text('Add Phone Number',style: TextStyle(color: Colors.white),),
        ),
        body: CustomProgressBar(
          isLoading: _isLoading,
          widget: Container(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: ListView(
                children: [
                  SizedBox(height: 42,),
                  name_,
                  SizedBox(height: 12,),
                  email_,
                  SizedBox(height: 12,),
                  mobile_,
                  SizedBox(height: 24,),
                  _saveInButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _saveInButton()
  {
    final button= SizedBox(
      width: 250,
      height: 50,
      child: RaisedButton(
        color: PrimaryButtonColor,
        child: Text('Save',style: buttonText,),
        onPressed: (){
          _saveData();
        },
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0)
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Align(
        alignment: Alignment.center,
        child: button,
      ),
    );
  }


  Future<void> _saveData()
  async {
    if(myController_mobile.text.toString().isEmpty)
    {
      Utility.showToast(context, Error_Mobile_Empty_Test);
    }

    else
    {

      bool connectionResult = await Utility.checkConnection();

      if(connectionResult)
      {
        setState(() {
          _isLoading=true;
        });

        var body = jsonEncode({
          "userId": uid,
          "firstName": name,
          "lastName": '',
          "phone": myController_mobile.text.toString(),
          "email": mailid,
          "profileImage": '',
          "role": 'End User',
          "password":'123',
        });
        SaveImpl(this,context).handleSaveView(body, 'User/user', 'PUT','');
      }else{
        Utility.showToast(context, Error_No_Internet_Test);
      }

    }
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
  void onSuccess(var res, String type,) {
    setState(() {
      _isLoading=false;
    });
    print(res);
    _assignData(res);

    // TODO: implement onSuccess
  }

  Future<void> _assignData(String res)
  async {
    var data=jsonDecode(res);
    if(data['message']=='Success')
      {
        final sharedPref = await SharedPreferences.getInstance();
        sharedPref.setString('userId', uid);
        sharedPref.setString('firstName', name);
        sharedPref.setString('phone', myController_mobile.text.toString());
        sharedPref.setString('email', mailid);
        sharedPref.setBool('isLoggedIn_t', true);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return HomePage();
            },
          ),
        );
      }
  }
}
