import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:truck_learning/sharedprf/auth_services.dart';
import 'package:truck_learning/ui/home/home_page.dart';
import 'package:truck_learning/ui/login/login_ui.dart';
import 'package:truck_learning/utils/colors.dart';

//check user login status
AuthService appAuth = new AuthService();
bool result;

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: PrimaryButtonColor,
    statusBarBrightness: Brightness.dark,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  result = await appAuth.checkAlreadyLogin();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AHC',
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginPage(),
        '/home': (BuildContext context) => HomePage(),
      },
      theme: ThemeData(
        primaryColor: Color(0xffff8435),
      ),
      home: result ? HomePage() : LoginPage(),
    );
  }
}
