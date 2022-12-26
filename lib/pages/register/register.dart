import 'package:face_net_authentication/autocomplete_prediction.dart';
import 'package:face_net_authentication/network_utility.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:face_net_authentication/components/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:face_net_authentication/pages/model/user_model.dart';
import 'package:face_net_authentication/pages/home.dart';
import 'package:face_net_authentication/services/ml_service.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:intl/intl.dart';
import 'package:places_service/places_service.dart';
import 'package:search_map_location/search_map_location.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:uuid/uuid.dart';
import "package:http/http.dart" as http;
import 'package:face_net_authentication/place_auto_complete_response.dart';

import '../location_list_tile.dart';
import '../login/login.dart';


class RegistrationScreen extends StatefulWidget {

  const RegistrationScreen(
      {required Key key, required this.passedList}): super(key: key);


  final List passedList;
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();

}

class _RegistrationScreenState extends State<RegistrationScreen> {
  List<AutocompletePrediction> placePredictions = [];

  // string for displaying the error Message
  String? errorMessage;
  final MLService _mlService = locator<MLService>();

  // our form key
  final _formKey = GlobalKey<FormState>();

  // editing Controller
  final fullNameEditingController = new TextEditingController();
  final icNumberEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final phoneNumberEditingController = new TextEditingController();
  final addressEditingController = new TextEditingController();
  final _auth = FirebaseAuth.instance;


  List<dynamic> _placesList = [];
  var uuid = Uuid();
  String _sessionToken = "123333";
  double listHeight = 0;

  void placeAutoComplete(String input) async{
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "maps/api/place/autocomplete/json",
        {
          "country":'MY',
          "input":input,
          "key":'Your Api Key',

        }
    );
    String? response = await NetworkUtility.fetchUrl(uri);

    if(response != null){
      PlaceAutocompleteResponse result= PlaceAutocompleteResponse.parseAutoCompleteResult(response);
      if(result.predictions != null){
        setState(() {
          placePredictions = result.predictions;
        });
      }

    }

  }


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;


    final addDetails =  ListView.builder(

      itemCount: placePredictions.length,
      itemBuilder: (context,index) => LocationListTile(
        press:(){addressEditingController.text = placePredictions[index].description!;},
        location: placePredictions[index].description!,
      ),
    );


    final addressField = TextFormField(

        autofocus: false,
        controller: addressEditingController,
        onChanged: (value) async {
          if(addressEditingController.text != ""){
            setState(() {
              listHeight = 300;
            }
            );}
          placeAutoComplete(value);
        },

        keyboardType: TextInputType.multiline,
        maxLines: null,

        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Address Cannot Be Empty");
          }
          return null;
        },

        onSaved: (value) {
          addressEditingController.text = value!;
        },

        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.map),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Address",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //first name field

    final firstNameField = TextFormField(
        autofocus: false,
        controller: fullNameEditingController,
        keyboardType: TextInputType.name,
        onTap: () => {
          setState(() { listHeight = 0;


          })

        },
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Name Cannot Be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          fullNameEditingController.text = value!;
        },

        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //second name field
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy');
    String formattedDate = formatter.format(now);

    //second name field
    //second name field
    final icNumberField = TextFormField(
        autofocus: false,
        controller: icNumberEditingController,
        keyboardType: TextInputType.number,
        onTap: () => {
          setState(() { listHeight = 0;
          })
        },
        validator: (value) {

          if (value!.isEmpty) {
            return ("IC Cannot Be Empty");
          }
          if (!RegExp("^\\d{6}\\-\\d{2}\\-\\d{4}")
              .hasMatch(value)) {

            return ("xxxxxx-xx-xxxx Format");
          }
          var a = value.substring(0,2); // Hexadecimal value for 30
          var b = int.parse(a);
          var c = int.parse(formattedDate.substring(2,4));
          int age = c-b;
          if( (age < 18 && age > 0)){
            return ("You need to be 18 years old to register");
          }

          return null;
        },
        onSaved: (value) {
          icNumberEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.card_membership),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "IC Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        onTap: () => {
          setState(() { listHeight = 0;
          })
        },
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          fullNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        onTap: () => {
          setState(() { listHeight = 0;
          })
        },
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required ");
          }
          if (!regex.hasMatch(value)) {
            return ("Min. 6 Character");
          }
          return null;
        },
        onSaved: (value) {
          fullNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //confirm password field
    final phoneNumberField = TextFormField(
        autofocus: false,
        controller: phoneNumberEditingController,
        obscureText: false,
        onTap: () => {
          setState(() { listHeight = 0;
          })
        },
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Phone Number ");
          }
          if (!RegExp("^\\d+")
              .hasMatch(value)) {
            return ("Only number please");
          }
          return null;
        },
        onSaved: (value) {
          fullNameEditingController.text = value!;
        },
        onChanged: (value) async { listHeight = 0;},
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(

          prefixIcon: Icon(Icons.phone),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));



    //signup button


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
                      "REGISTER",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA),
                          fontSize: 36
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),


                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 40),

                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[


                          SizedBox(height: size.height * 0.03),
                          firstNameField,
                          SizedBox(height: 20),
                          addressField,
                          SizedBox(height: 20),
                          Container(

                            height: listHeight,


                            child: addDetails,
                          ),

                          icNumberField,
                          SizedBox(height: 20),
                          emailField,
                          SizedBox(height: 20),
                          passwordField,
                          SizedBox(height: 20),
                          phoneNumberField,
                          SizedBox(height: 20),

                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () =>
                          setState(() {
                            signUp(emailEditingController.text,
                                passwordEditingController.text);
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
                          "REGISTER",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: GestureDetector(
                      onTap: () =>
                      {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => MyHomePage()))
                      },
                      child: Text(
                        "Already Have an Account? Sign in",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2661FA)
                        ),
                      ),
                    ),
                  )
                ]
            ),
          ),
        ));
  }


  Future<bool> ICCheck(String icNumber) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('icNumber', isEqualTo: icNumber)
        .get();
    return result.docs.isEmpty;
  }

  void signUp(String email, String password) async {
    final valid = await ICCheck(icNumberEditingController.text);
    if (!valid) {
      // username exists
      Fluttertoast.showToast(msg: "IC number already exist");
    }
    else if  (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel(modelData:[]);


    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.fullName = fullNameEditingController.text;
    userModel.icNumber = icNumberEditingController.text;
    userModel.phoneNumber = phoneNumberEditingController.text;
    userModel.address = addressEditingController.text;
    userModel.modelData = widget.passedList;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => MyHomePage()),
            (route) => false);
  }




}