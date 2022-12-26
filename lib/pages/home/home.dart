import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_net_authentication/pages/model/user_model.dart';
import 'package:face_net_authentication/components/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:face_net_authentication/pages/login/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../auth.dart';

import '../home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isButtonActive = true;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel(modelData: []);
  final TextEditingController phoneNumber = new TextEditingController();
  late TextEditingController phoneNumber1  = new TextEditingController();
  final _formKey = GlobalKey<FormState>();


  //UserModel(modelData: [])
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      final TextEditingController phoneNumber = new TextEditingController();


      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    //data from firebase
    final fullName = TextFormField(
        autofocus: false,
        controller: TextEditingController(text: "${loggedInUser.fullName}"),
        readOnly: true,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final icNumber = TextFormField(
        autofocus: false,
        controller: TextEditingController(text: "${loggedInUser.icNumber}"),
        readOnly: true,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.card_membership),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "IC Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final phoneNumber = TextFormField(
        autofocus: false,
        controller: TextEditingController(text: "${loggedInUser.phoneNumber}"),
        readOnly: true,
        onTap: () => _onCustomAnimationAlertPressed(context),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.phone),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final address = TextFormField(
        autofocus: false,
        controller: TextEditingController(text: "${loggedInUser.address}"),
        readOnly: true,
        textInputAction: TextInputAction.next,
        maxLines: null,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.map),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Address",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //label field
    final nameText = const Text(
      "Name",
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
          color: Colors.black),
    );

    final icText = const Text(
      "IC Number",
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
          color: Colors.black),
    );

    final phoneText = const Text(
      "Phone Number",
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
          color: Colors.black),
    );

    final addressText = const Text(
      "Address",
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
          color: Colors.black),
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
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: const Text(
                    "Voter Details",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2661FA),
                        fontSize: 36
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                //Name
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Form(

                    child: Column(
                      children: <Widget>[
                        nameText
                      ],
                    ),
                  ),
                ),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),

                  child: Form(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        fullName
                      ],
                    ),

                  ),
                ),
                SizedBox(height: size.height * 0.02),

                //IC Num
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Form(

                    child: Column(
                      children: <Widget>[
                        icText
                      ],
                    ),
                  ),
                ),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),

                  child: Form(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        icNumber
                      ],
                    ),

                  ),
                ),

                SizedBox(height: size.height * 0.02),

                //Phone Num
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Form(

                    child: Column(
                      children: <Widget>[
                        phoneText
                      ],
                    ),
                  ),
                ),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),

                  child: Form(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        phoneNumber
                      ],
                    ),

                  ),
                ),

                SizedBox(height: size.height * 0.02),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Form(

                    child: Column(
                      children: <Widget>[
                        addressText
                      ],
                    ),
                  ),
                ),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),

                  child: Form(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        address
                      ],
                    ),

                  ),
                ),


                SizedBox(height: size.height * 0.04),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () =>
                        setState(() {
                          logout(context);
                        }),
                    style: ElevatedButton.styleFrom(shape: StadiumBorder(),
                        padding: const EdgeInsets.all(0)),
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
                ),
              ]),

        ),
      ),
    );
  }


  _onCustomAnimationAlertPressed(context) {

    Alert(
        context: context,
        title: "Change Phone Number",
        alertAnimation: fadeAlertAnimation,
        content: Column(
          children: <Widget>[
            TextFormField(
              autofocus:true ,
              controller: phoneNumber1,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Phone Number"
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return ("Phone Number is required");
                }
                if (!RegExp("^\\d+")
                    .hasMatch(value)) {
                  return ("Only number please");
                }
                return null;
              },
              onSaved: (value) {
                phoneNumber1.text = value!;
              },

            ),

          ],
        ),

        buttons: [
          DialogButton(




            onPressed:  () =>

                setState(() {

                  if (phoneNumber1.text == "") {
                    Fluttertoast.showToast(msg: "Can't be null");
                    return null;
                  }
                  else if((int.tryParse(phoneNumber1.text) != null) == false){
                    Fluttertoast.showToast(msg: "Please enter only digits");
                    return null;
                  }
                  else {
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(user!.uid)
                        .update({'phoneNumber': phoneNumber1.text})
                        .then((value) => Fluttertoast.showToast(
                        msg: "Your phone number has been updated"))
                        .catchError((error) =>
                        Fluttertoast.showToast(
                            msg: "Fail too update phone number"));
                    Timer.periodic(Duration(seconds: 2), (timer) {
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    }
                    );
                  }
                }) ,
            child: Text(
              "UPDATE",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  Widget fadeAlertAnimation(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }


  // the logout function
  Future<void> logout(BuildContext context) async {
    await Auth().signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage()));
  }
}
