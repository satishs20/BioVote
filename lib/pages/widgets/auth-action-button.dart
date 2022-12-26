
import 'package:face_net_authentication/locator.dart';
import 'dart:async';
import 'dart:io';

import 'package:face_net_authentication/services/ml_service.dart';
import 'package:flutter/material.dart';
import '../../services/camera.service.dart';

import 'package:firebase_auth/firebase_auth.dart' as eos;
import 'package:face_net_authentication/pages/register/register.dart';

class AuthActionButton extends StatefulWidget {
  AuthActionButton(
      {Key? key,
        required this.onPressed,

        required this.reload});
  final Function onPressed;

  final Function reload;
  @override
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  final MLService _mlService = locator<MLService>();

  final _formKey = GlobalKey<FormState>();




  Future _signUp(context) async {

    List predictedData = _mlService.predictedData;


    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrationScreen(
          passedList:predictedData, key: _formKey,

        ),),);


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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue[200],
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
            CameraService().dispose();
            await _signUp(context);
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

  @override
  void dispose() {
    super.dispose();
  }
}