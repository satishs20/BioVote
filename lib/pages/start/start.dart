import 'package:face_net_authentication/pages/home/home.dart';
import 'package:face_net_authentication/pages/reset/reset.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../auth.dart';
import '../../components/background.dart';
import '../home.dart';
import '../sign-in.dart';




class startScreen extends StatefulWidget {


  @override
  State <startScreen> createState() => _startScreenState();

}

class _startScreenState extends State<startScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Background(
          child: SingleChildScrollView(
            reverse: false,
            padding: const EdgeInsets.all(32),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "HOME PAGE",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA),
                          fontSize: 36
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  SizedBox(height: size.height * 0.02),

                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () => setState((){
                        setState(() {});
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>SignIn()));

                      }),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: StadiumBorder(), padding: const EdgeInsets.all(0)),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: size.width * 0.5,
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(80.0),

                        ),
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          "Scan",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.blue,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          FloatingActionButton(
                            child: Icon(Icons.import_export, size: 32),
                            onPressed: () async{
                              closeWebView();

                            },
                          );
                        });
                        final uri = 'https://mymp.org.my';
                        if(await canLaunch(uri)){
                          await launch(
                            uri,
                            forceSafariVC: true,
                            forceWebView: true,
                            enableJavaScript: true,
                            webOnlyWindowName:'_self',


                          );

                        }

                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: StadiumBorder(), padding: const EdgeInsets.all(0)),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: size.width * 0.5,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),

                        ),
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          "Check Your MP Details",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),


                  SizedBox(height: size.height * 0.02),

                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () => setState((){
                        setState(() {});
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>ResetScreen()));
                      }),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: StadiumBorder(), padding: const EdgeInsets.all(0)),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: size.width * 0.5,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),

                        ),
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          "Change Password",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () => setState(() { logout(context);}),
                      style: ElevatedButton.styleFrom(shape: StadiumBorder(), padding: const EdgeInsets.all(0)),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: size.width * 0.5,
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(80.0),
                            gradient: new LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 255, 136, 34),
                                  Color.fromARGB(255, 255, 177, 41)
                                ]
                            ),
                        ),
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          "Logout",
                          textAlign: TextAlign.center,

                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),]
            ),
          ),
        ));
  }



  Future<void> logout(BuildContext context) async {
    await Auth().signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage()));
  }
}
