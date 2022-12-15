import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                      "Home Page",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA),
                          fontSize: 36
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),

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
                  SizedBox(height: size.height * 0.04),

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
                            )
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
