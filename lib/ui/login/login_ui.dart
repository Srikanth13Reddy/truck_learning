import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_learning/services/save.dart';
import 'package:truck_learning/services/saveView.dart';
import 'package:truck_learning/ui/home/home_page.dart';
import 'package:truck_learning/ui/signup/signup_page.dart';
import 'package:truck_learning/utils/colors.dart';
import 'package:truck_learning/utils/constants.dart';
import 'package:truck_learning/utils/customtextstyle.dart';
import 'package:truck_learning/utils/network_utils.dart';
import 'package:truck_learning/widgets/custom_progress_bar.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements SaveView
{
  bool _isLoading = false;
  final myController_email = TextEditingController();
  final myController_password = TextEditingController();
  bool _secureText = true;
  String email,password;


  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  Widget build(BuildContext context)
  {

      final email=TextFormField(
      controller: myController_email,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onSaved: (e) => this.email = e,
        validator: (String value) {
          if (value == "" || value == null) {
            return Error_Email_Empty_Test;
          } else {
            var isValid = validateEmail(value);
            if (isValid) {
              return Error_Invalid_Email_Format_Test;
            } else {
              return null;
            }
          }
        },
      decoration: InputDecoration(
          hintText: 'Email',
          filled: true,
          prefixIcon: Icon(Icons.email),
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

    return WillPopScope(
        onWillPop: ()async {
          exit(0);
        },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomProgressBar(
          isLoading: _isLoading,
          widget: ListView(
            padding: EdgeInsets.all(20),
            shrinkWrap: true,
           children: <Widget>[
             Center(child: _logo(),),
             _welcomeText(),
             _loginText(),
             SizedBox(height: 24,),
             email,
             SizedBox(height: 12,),
             pass,
             _signInButton(),
             _forgotPassword(),
             _connectwithText(),
             _googleSignInButton(),
             _createAnAccountButton()
           ],
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    AssetImage asset = AssetImage("images/login_logo.png");
    Image image = Image(
      alignment: Alignment.topLeft,
      image: asset,
      height: 250.0,
    );
    return image;

  }

  Widget _welcomeText()
  {

    final text_=Text(
        Welcome_Text,
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
      Sign_In_Continue_Text,
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

  Widget _signInButton()
  {
    final button= SizedBox(
      width: 250,
      height: 42,
      child: RaisedButton(
        color: PrimaryButtonColor,
        child: Text('Login',style: TextStyle(color: Colors.white),),
        onPressed: (){

          _login();

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

  Widget _forgotPassword() {
    var forgot = FlatButton(
      padding: EdgeInsets.only(right: 0, top: 12.0),
      onPressed: () {},
      child: Text(
        ForgotPassword_Btn,
        style: subHeaderTextStyle,
      ),
    );
    return Align(
      child: forgot,
      alignment: Alignment.center,
    );
  }


  Widget _connectwithText()
  {
    final text_=Text(
      Or_connect_with,
      style: subHeaderTextStyle,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Align(
        alignment: Alignment.center,
        child: text_,
      ),
    );

  }

  Widget _googleSignInButton() {
    return Padding(
        padding:
        EdgeInsets.only(top: 10.0, bottom: 15.0, left: 70.0, right: 70.0),
        child: SizedBox(
          height: 45.0,
          width: double.infinity,
          child: new RaisedButton.icon(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: BorderSide(color: Colors.grey[300], width: 0.5)),
            elevation: 2,
            icon: Image(
              image: AssetImage('images/google_logo.png'),
              height: 30,
            ),
            color: WhiteColor,
            textColor: WhiteColor,
            label: Text(
              Google_Btn,
              style: GoogleFonts.rubik(
                fontSize: 17,
                color: SubTitleColor,
                fontWeight: FontMedium,
              ),
            ),
            onPressed: () {

            },
          ),
        ));
  }

  Widget _createAnAccountButton() {
    var detector = GestureDetector(
      onTap: () {
        setState(() {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SignUp()));
        });
      },
      child: Align(
        child: Text.rich(
          TextSpan(
            text: CreateAnAccount_Text + ' ',
            style: subHeaderTextStyle,
            children: <TextSpan>[
              TextSpan(
                text: 'Sign Up' + "   " ,
                style: mediumTitleTextStyleGreen,
              ),
            ],
          ),
        ),
        alignment: Alignment.center,
      ),
    );
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5),
      child: detector,
    );
  }

  Future<void> _login()
  async {
     if(myController_email.text.toString().isEmpty)
       {
         Utility.showToast(context, Error_Email_Empty_Test);
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
             "email": myController_email.text.toString(),
             "password":myController_password.text.toString(),
           });
           SaveImpl(this,context).handleSaveView(body, 'Login/login', 'POST','');
         }else{
           Utility.showToast(context, Error_No_Internet_Test);
         }

       }
  }

  @override
  void onFailur(String error,String res,int code) {

    print(error);

    // TODO: implement onFailur
    setState(() {
      _isLoading=false;
    });
     var data= jsonDecode(res);
    Utility.showToast(context, data['errorMessage']);
  }

  @override
  void onSuccess(String res, String type) {
    // TODO: implement onSuccess
    print(res);
    setState(() {
      _isLoading=false;
    });
    _assigndata(res);
  }

  Future<void> _assigndata(String res) async {
    final data=jsonDecode(res);
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('userId', data['userId'].toString());
    sharedPref.setString('firstName', data['firstName']);
    sharedPref.setString('phone', data['phone']);
    sharedPref.setString('email', data['email']);
    sharedPref.setString('createdDate', data['createdDate']);
    sharedPref.setString('role', data['role']);
    sharedPref.setString('accessToken', data['accessToken']);
    sharedPref.setString('profileImage', data['profileImage']);
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
