import 'package:ajira_chapchap/AllScreens/loginScreen.dart';
import 'package:ajira_chapchap/AllScreens/mainscreen.dart';
import 'package:ajira_chapchap/AllScreens/registrationScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ajira_chapchap/DataHandler/appData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
 DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Ajira chap chap',
        theme: ThemeData(
         // fontFamily: "Brand Bold",
          primarySwatch: Colors.indigo,
        ),

       initialRoute: FirebaseAuth.instance.currentUser == null ? LoginScreen.idScreen: MainScreen.idScreen,
        //initialRoute: MainScreen.idScreen,
        routes: {
          RegistrationScreen.idScreen: (context) => RegistrationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),


        },
        debugShowCheckedModeBanner: false,
        home: RegistrationScreen(),
      ),
    );
  }
}
