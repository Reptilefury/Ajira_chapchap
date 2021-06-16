import 'package:ajira_chapchap/AllScreens/registrationScreen.dart';
import 'package:ajira_chapchap/AllWidgets/progressDialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ajira_chapchap/AllScreens/loginScreen.dart';
import 'package:ajira_chapchap/AllScreens/mainscreen.dart';
import 'package:ajira_chapchap/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';

import '../main.dart';
import 'mainscreen.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  //const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 35.0,
            ),
            Image(
              image: AssetImage('images/istockphoto-1081790368-612x612.jpg'),
              width: 390.0,
              height: 350.0,
              alignment: Alignment.bottomCenter,
            ),
            SizedBox(
              height: 1.0,
            ),
            Text(
              "Login as an Employer ",
              style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 1.0,
                  ),
                  TextField(
                    controller: passwordTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 17.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        )),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 1.0,
                  ),
                  TextField(
                    obscureText: true,
                    //keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "password",
                        labelStyle: TextStyle(
                          fontSize: 17.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        )),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  RaisedButton(
                    color: Colors.indigo,
                    textColor: Colors.white,
                    child: Container(
                      height: 50.0,
                      child: Center(
                        child: Text(
                          "login",
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand Bold"),
                        ),
                      ),
                    ),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0)),
                    onPressed: () {
                      if(!emailTextEditingController.text.contains("@")){
                        displayToastMessage("Email address is not Valid", context);
                      }
                      else if (passwordTextEditingController.text.isEmpty)
                        {
                          displayToastMessage("password must be included", context);
                        }
                      else {
                        loginAndAuthenticateUser(context);
                      }
                      loginAndAuthenticateUser(context);
                    },
                  )
                ],
              ),
            ),
            FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RegistrationScreen.idScreen, (route) => false);
                },
                child: Text("Don't have an account? register here"))
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(context: context,
    barrierDismissible: false,
    builder: (BuildContext context){
     return ProgressDialog(
     message: "Signing you in, might take a while...",
      );
    }
    );
    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    ).catchError((errMsg) {
      Navigator.pop(context);

      displayToastMessage("Error:" + errMsg.toString(), context);
    })).user;
    if ( firebaseUser != null) {

      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
        if (snap.value != null){
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayToastMessage("you're currently  logged in", context);

        }
        else{
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("No records for this user Exists. Please create a new account", context);
        }
      });

    } else {
      Navigator.pop(context);
      displayToastMessage(" Error occurred cannot log  in ", context);
      //error
    }

  }

  void displayToastMessage(String message, BuildContext context) {}
}
