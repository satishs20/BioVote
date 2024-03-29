
import 'package:face_net_authentication/locator.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../services/camera.service.dart';
import '../../locator.dart';
import '../../services/ml_service.dart';
//import '../home/home.dart';
import '../home/home.dart';
import '../model/user_model.dart';
import '../sign-in.dart';
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
    Size size = MediaQuery.of(context).size;
    final _cameraService = locator<CameraService>();

    return SimpleDialog( // <-- SEE HERE
      title: const Text('Do you want to continue with this image?'),
      children: <Widget>[
        Container(
          child: Image( fit: BoxFit.cover,image: FileImage(File( _cameraService.imagePath!)),
            width: MediaQuery.of(context).size.width * 0.5,alignment: Alignment.centerLeft,
          ),
          margin: EdgeInsets.all(20),
          width: 200,
          height: 200,
          alignment: Alignment.center,
        ),
        SimpleDialogOption(
          onPressed: ()  async {
            await _signIn(context);
          },
          child: const Text('Yes'),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('No'),
        ),

      ],
    );


  }

  Future _signIn(context) async {

    List predictedData = _mlService.predictedData;

     _mlService.comparision(predictedData, loggedInUser.modelData)  ;

     bool a = _mlService.faceMatch;
    if(a == true){

      Fluttertoast.showToast(msg: "Only the address and phone number can be changed. To edit, click it.",
          toastLength: Toast.LENGTH_LONG);
      CameraService().dispose();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));



    }
    else
      Fluttertoast.showToast(msg: "Your face does not match");
    Timer(Duration(seconds: 3), () {
    Navigator.push(context, MaterialPageRoute(builder: (context) =>SignIn()));
    });
  }


}


