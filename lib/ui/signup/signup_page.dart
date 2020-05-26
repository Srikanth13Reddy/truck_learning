import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:truck_learning/services/save.dart';
import 'package:truck_learning/services/saveView.dart';
import 'package:truck_learning/ui/login/login_ui.dart';
import 'package:truck_learning/utils/colors.dart';
import 'package:truck_learning/utils/constants.dart';
import 'package:truck_learning/utils/customtextstyle.dart';
import 'package:truck_learning/utils/network_utils.dart';
import 'package:truck_learning/widgets/custom_progress_bar.dart';
class SignUp extends StatefulWidget
{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SignUp> implements SaveView
{
  final myController_email = TextEditingController();
  final myController_password = TextEditingController();
  final myController_name = TextEditingController();
  final myController_mobile = TextEditingController();
  bool _secureText = true;
  String email,password;
  bool _isLoading=false;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: PrimaryButtonColor, //or set color with: Color(0xFF0000FF)
    ));
  }
  @override
  Widget build(BuildContext context)
  {
    final name=TextFormField(
      controller: myController_name,
      keyboardType: TextInputType.text,
      autofocus: false,
      onSaved: (e) => this.email = e,
      decoration: InputDecoration(
          hintText: 'Name',
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          )
      ),
    );
    final email=TextFormField(
      controller: myController_email,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onSaved: (e) => this.email = e,
      decoration: InputDecoration(
          hintText: 'Email',
          prefixIcon: Icon(Icons.email),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          )
      ),
    );
    final mobile=TextFormField(
      controller: myController_mobile,
      keyboardType: TextInputType.number,
      autofocus: false,
      onSaved: (e) => this.email = e,
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

    final pass=TextFormField(
      controller: myController_password,
      keyboardType: TextInputType.visiblePassword,
      autofocus: false,

      obscureText: _secureText,
      onSaved: (e) => password = e,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Password',
          prefixIcon: Icon(Icons.vpn_key),
          suffixIcon: IconButton(
            onPressed: showHide,
            icon: Icon(_secureText
                ? Icons.visibility_off
                : Icons.visibility),
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20)
          )
      ),
    );
    final button= SizedBox(
      width: 120,
      height: 42,
      child: RaisedButton(
        color: PrimaryButtonColor,
        child: Text('SignUp',style: TextStyle(color: Colors.white),),
        onPressed: (){
          _signUp();
        },
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0)
        ),
      ),
    );
    final text=Text('SIGNUP',
      style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),);
    return CustomProgressBar(
      isLoading: _isLoading,
      widget: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomAppBar
          (
          color: Colors.transparent,
          child: _alereadyAnAccountButton(),
          elevation: 0,
        ),
        body:Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  _backArrow(),
                  _welcomeText(),
                  _loginText(),
                  SizedBox(height: 45,),
                  name,
                  SizedBox(height: 12,),
                  email,
                  SizedBox(height: 12,),
                  mobile,
                  SizedBox(height: 12,),
                  pass,
                  SizedBox(height: 42,),
                  button,
                ],
              ),
            ),
          ),
        ),
    );
  }

  Widget _welcomeText()
  {

    final text_=Text(
      Welcome_Text_SignUp,
      style: headerTitleTextStyle,
    );
    return Align(
      alignment: Alignment.center,
      child: text_,
    );

  }

  Widget _loginText()
  {

    final text_=Text(
      CreateAccount,
      style: subHeaderTextStyle,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.center,
        child: text_,
      ),
    );

  }

  Widget _backArrow()
  {

    final text_=Icon(
       Icons.arrow_back,
      color: Colors.black,
      size: 30,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Align(
        alignment: Alignment.topLeft,
        child: text_,
      ),
    );

  }

  Widget _alereadyAnAccountButton() {
    return Container(
      height: 60,
      color: Colors.white,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Already have an account ? ",style: subHeaderTextStyle,),
          GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return LoginPage();
                }));
              },
              child: Text("Sign In",style: TextStyle(fontWeight: FontWeight.bold,color:PrimaryButtonColor,fontSize: 18),))
        ],
      ),
    );
  }

  Future<void> _signUp()
  async {
    if(myController_name.text.toString().isEmpty)
    {
      Utility.showToast(context, Error_Name_Empty_Test);
    }
    else  if(myController_email.text.toString().isEmpty)
    {
      Utility.showToast(context, Error_Email_Empty_Test);
    }
    else  if(validateEmail(myController_email.text.toString()))
    {
      Utility.showToast(context, Error_Invalid_Email_Format_Test);
    }
    else  if(myController_mobile.text.toString().isEmpty)
    {
      Utility.showToast(context, Error_Mobile_Empty_Test);
    }
    else  if(myController_password.text.toString().isEmpty)
    {
      Utility.showToast(context, Error_Password_Empty_Test);
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
          "firstName": myController_name.text.toString(),
          "lastName": '',
          "phone": myController_mobile.text.toString(),
          "email": myController_email.text.toString(),
          "profileImage": '',
          "role": 'End User',
          "password":myController_password.text.toString(),
        });
        SaveImpl(this,context).handleSaveView(body, 'User/user', 'POST','');
      }else{
        Utility.showToast(context, Error_No_Internet_Test);
      }

    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onFailur(String error, String res, int code)
  {
    // TODO: implement onFailur
    print(error);

    // TODO: implement onFailur
    setState(() {
      _isLoading=false;
    });
    var data= jsonDecode(res);
    Utility.showToast(context, data['errorMessage']);
  }

  @override
  void onSuccess(String res, String type,)
  {
    // TODO: implement onSuccess
    setState(() {
      _isLoading=false;
    });
    var data= jsonDecode(res);
    Utility.showToast(context, data['message']);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return LoginPage();
        },
      ),
    );
  }
}
