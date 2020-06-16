//Base URL


const String Welcome_Text = 'Welcome back!';
const String Welcome_Text_SignUp = "Let's Get Started !" ;
const String Sign_In_Continue_Text = 'Log in to continue';
const String ForgotPassword_Btn = 'Forgot Password ?';
const String Or_connect_with = 'Or connect with';
const String Google_Btn = 'Google';
const String CreateAnAccount_Text = 'Create an account ? ';
const String CreateAccount='Create an account ';
const String Error_Email_Empty_Test = 'Please enter the mail Id';
const String Error_Name_Empty_Test = 'Please enter the name';
const String Error_Mobile_Empty_Test = 'Please enter the phone number';
const String Error_Invalid_Email_Format_Test = 'Not a valid email format';
const String Error_Password_Empty_Test = 'Please enter the password';
const String plaseHolderImgUrl='https://img.etb2bimg.com/files/cp/upload-0.92099500%2015822828078880-heavy-truck.jpg';

const String Base_Url='https://devnationaltraining.azurewebsites.net/api/';
const String Error_No_Internet_Test =
    'Unable to connect, Please Check Internet Connection';

bool validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);
  if (!regExp.hasMatch(value)) {
    return true;
  } else {
    return false;
  }
}