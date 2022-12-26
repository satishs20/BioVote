

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
import '../home/home.dart';
import '../sign-in.dart';
import '../start/start.dart';

class editPhoneNumber extends StatefulWidget {
  const editPhoneNumber({Key? key}) : super(key: key);

  @override
  _editPhoneNumberScreenState createState() => _editPhoneNumberScreenState();
}


class _editPhoneNumberScreenState extends State<editPhoneNumber> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumber = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //phone text field
    final phoneField = TextFormField(
      key: _formKey,
      controller: phoneNumber,
      decoration: const InputDecoration(
          labelText: "Phone Number"
      ),
      validator: (value){
        if(value!.isEmpty){

          return("Phone Number is required");
        }
        if (!RegExp("^\\d+")
            .hasMatch(value)) {
          return ("Only number please");
        }
        return null;
      },
      onSaved: (value) {
        phoneNumber.text = value!;
      },

    );

    return Scaffold(
      body: Background(
        key: _formKey,
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
                  "New Phone Number",
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


                      phoneField,
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
                  onPressed: () => setState((){ Auth().updateUser(number: phoneNumber.text);
                  String phone = phoneNumber.text;
                  Fluttertoast.showToast(msg: "Your phone number has been reset to $phone");
                  Timer(Duration(milliseconds: 500), () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>HomeScreen()));
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
                      "Update",
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