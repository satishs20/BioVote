

import 'dart:async';

import 'package:face_net_authentication/Pages/model/user_model.dart';
import 'package:face_net_authentication/pages/login/login.dart';
import 'package:flutter/material.dart';

import 'package:face_net_authentication/components/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:face_net_authentication/auth.dart';

import '../home.dart';
import '../sign-in.dart';
import '../start/start.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  _ResetScreenState createState() => _ResetScreenState();
}


class _ResetScreenState extends State<ResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //email text field
    final emailField = TextFormField(

      controller: emailController,
      decoration: const InputDecoration(
          labelText: "Email"
      ),
      validator: (value){
        if(value!.isEmpty){

          return("Email is required to login");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
            .hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },

    );

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
                  "Reset Password",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2661FA),
                      fontSize: 36
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: size.height * 0.03),


              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),

                child:Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[


                      emailField,
                      SizedBox(height: 20),


                    ],
                  ),
                ),
              ),




              SizedBox(height: size.height * 0.05),

              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                  onPressed: () => setState((){ Auth().sendPasswordResetEmail(email: emailController.text);
                    String email = emailController.text;
                  Fluttertoast.showToast(msg: "A reset link has been sent to $email");
                  Timer(Duration(seconds: 1), () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>LoginScreen()));
                  });
                  }),
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
                      "Reset Password",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),);

  }
}