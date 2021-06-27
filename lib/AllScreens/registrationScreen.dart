import 'package:ajira_chapchap/AllScreens/loginScreen.dart';
import 'package:ajira_chapchap/AllScreens/mainscreen.dart';
import 'package:ajira_chapchap/AllWidgets/progressDialog.dart';
import 'package:ajira_chapchap/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
class RegistrationScreen extends StatelessWidget {
  //const RegistrationScreen({Key key}) : super(key: key);
  static const String idScreen = "register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Image(
              image: AssetImage(
                  'images/93-930840_industrial-worker-clipart-blue-collar-job-cartoon.png'),
              width: 390.0,
              height: 350.0,
              alignment: Alignment.bottomCenter,
            ),
            SizedBox(
              height: 1.0,
            ),
            Text(
              "Register  as an employer ",
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
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        labelText: "Name",
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
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        labelText: "email",
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
                    controller: phoneTextEditingController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        labelText: "Phone",
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
                    controller: passwordTextEditingController,
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
                          "Create Account",
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand Bold"),
                        ),
                      ),
                    ),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0)),
                    onPressed: () {
                      if (nameTextEditingController.text.length > 3) {
                        //Fluttertoast.showToast(msg:"Name must be at least 3 characters");
                        displayToastMessage(
                            "name must be at least 3 characters", context);
                      } else if (!emailTextEditingController.text
                          .contains("@")) {
                        displayToastMessage(
                            "Email address is invalid", context);
                      }
                      else if (phoneTextEditingController.text.isEmpty) {
                        displayToastMessage("Phone number is empty", context);
                      }
                      else if (passwordTextEditingController.text.length < 6) {
                        displayToastMessage(
                            "Password must be at least 6 charcters", context);
                      }
                      else
                        {
                          registerNewUser(context);
                        }


                    },
                  )
                ],
              ),
            ),
            FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: Text("Already have an account? login here"))
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  registerNewUser(BuildContext context) async {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(
            message: "Registering you in, might take a while...",
          );
        }
    );
    final User firebaseUser = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text).catchError((errMsg){
          Navigator.pop(context);
    displayToastMessage  ("Error:" + errMsg.toString(), context);
    }))
        .user;
    if (User != null) {
      usersRef.child(firebaseUser.uid);
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };
       usersRef.child(firebaseUser.uid).set(userDataMap);
       displayToastMessage("Account successfully created", context);
       Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
    } else {
      Navigator.pop(context);
      displayToastMessage(" New user account has not been created", context);
      //error
    }
  }
  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }

}
