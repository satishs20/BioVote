import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../locator.dart';
import '../../services/ml_service.dart';
//import '../home/home.dart';
import '../home/home.dart';
import '../model/user_model.dart';
import 'app_button.dart';
import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthButton extends StatefulWidget {
  const AuthButton({Key? key, required this.onPressed, required this.reload}) : super(key: key);

  final Function onPressed;

  final Function reload;

  @override
  _AuthButtonState createState() => _AuthButtonState();

}


class _AuthButtonState extends State<AuthButton> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel(modelData: []);
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
      setState(() {});

    });
  }
  final MLService _mlService = locator<MLService>();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFF0F0BDB),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CAPTURE',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.camera_alt, color: Colors.white)
          ],
        ),
      ),
    );


  }
  Future onTap() async {
    try {
      bool faceDetected = await widget.onPressed();
      if (faceDetected) {

        PersistentBottomSheetController bottomSheetController =
        Scaffold.of(context)
            .showBottomSheet((context) => signSheet(context));
        bottomSheetController.closed.whenComplete(() => widget.reload());
      }
    } catch (e) {
      print(e);
    }
  }


  signSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Container(
            child: Column(
              children: [
                AppButton(
                  text: 'Continue',
                  onPressed: () async {
                   await _signIn(context);
                  },
                  icon: Icon(
                    Icons.person_add,
                    color: Colors.white,
                  ),
                )


              ],
            ),
          ),
        ],
      ),
    );
  }

  Future _signIn(context) async {

    List predictedData = _mlService.predictedData;

     _mlService.comparision(predictedData, loggedInUser.modelData)  ;
    Fluttertoast.showToast(msg:"$loggedInUser.modelData");
     bool a = _mlService.faceMatch;
    if(a == true){
      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
      Fluttertoast.showToast(msg: "Your face match and the app works yayayayayyayyayay");

    }
    else
      Fluttertoast.showToast(msg: "Your face does not match");

  }


}


