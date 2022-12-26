import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_net_authentication/pages/model/user_model.dart';
import 'package:face_net_authentication/components/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:face_net_authentication/pages/login/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';

import '../../auth.dart';

import '../../autocomplete_prediction.dart';
import '../../network_utility.dart';
import '../../place_auto_complete_response.dart';
import '../home.dart';
import '../location_list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AutocompletePrediction> placePredictions = [];
  bool isButtonActive = true;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel(modelData: []);
  final TextEditingController phoneNumber = new TextEditingController();
  late TextEditingController phoneNumber1  = new TextEditingController();
  late TextEditingController address  = new TextEditingController();
  late TextEditingController votingDistrict  = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String votePlace = "0";


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
          "key":'AIzaSyBOrgaBu1i1yhWgUkZ7d9itueVzb5MnJzE',

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
      late TextEditingController address  = new TextEditingController();

      setState(() {
      });





    });
  }




  @override
  Widget build(BuildContext context) {
    //voting district
    final split = loggedInUser.address?.split(',');
    int? length = split?.length;

for(int i = 0; i < length!;i++) {
  if (split![i] == ' Penang') {
    int? length = split[i-1].length;
    votePlace = "07" + "/" + split[i - 1].substring(1, 3) + "/" +
        split[i - 1].substring(length - 2, length);
    break;
  }
  else if (split[i] == ' Johor') {
    int? length = split[i-1].length;
    votePlace = "01" + "/" + split[i - 1].substring(1, 3) + "/" +
        split[i - 1].substring(length - 2, length);
    break;
  }
  else if (split[i] == ' Kedah') {
    int? length = split[i-1].length;
    votePlace = "02" + "/" + split[i - 1].substring(1, 3) + "/" +
        split[i - 1].substring(length - 2, length);
    break;
  }
  else if (split[i] == ' Kelantan') {
    int? length = split[i-1].length;
    votePlace = "03" + "/" + split[i - 1].substring(1, 3) + "/" +
        split[i - 1].substring(length - 2, length);
    break;
  }
  else if (split[i] == ' Melaka') {
    int? length = split[i-1].length;
    votePlace = "04" + "/" + split[i - 1].substring(1, 3) + "/" +
        split[i - 1].substring(length - 2, length);
    break;
  }
  else if (split[i] == ' Negeri Sembilan') {
    int? length = split[i-1].length;
    votePlace = "05" + "/" + split[i - 1].substring(1, 3) + "/" +
        split[i - 1].substring(length - 2, length);
    break;
  }
  else if (split[i] == ' Perak') {
    int? length = split[i-1].length;
    votePlace = "08" + "/" + split[i - 1].substring(1, 3) + "/" +
        split[i - 1].substring(length - 2, length);
    break;
  }
  else if (split[i] == ' Pahang') {
    int? length = split[i-1].length;
    votePlace = "06" + "/" + split[i - 1].substring(1, 3) + "/" +
        split[i - 1].substring(length - 2, length);
    break;
  }
  else if (split[i] == ' Perlis') {
    int? length = split[i-1].length;
    votePlace = "09" + "/" + split[i - 1].substring(1, 3) + "/" +
        split[i - 1].substring(length - 2, length);
    break;
  }
  else if (split[i] == ' Selangor') {
    int? length = split[i-1].length;
    votePlace = "10" + "/" + split[i - 1].substring(1, 3) + "/" +
        split[i - 1].substring(length - 2, length);
    break;
  }
  else if (split[i] == ' Terengganu') {
    int? length = split[i-1].length;
    votePlace = "11" + "/" + split[i - 1].substring(1, 3) + "/" +
        split[i - 1].substring(length - 2, length);
    break;
  }
  else if (split[i] == ' Sabah') {
    int? length = split[i-1].length;
    votePlace = "12" + "/" + split[i - 1].substring(1, 3) + "/" +
        split[i - 1].substring(length - 2, length);
    break;
  }
  else if (split[i] == ' Sarawak') {
    int? length = split[i-1].length;
    votePlace = "13" + "/" + split[i - 1].substring(1, 3) + "/" +
        split[i - 1].substring(length - 2, length);
    break;
  }
  else{
    votePlace = "Valid Address is not entered";
  }
}



    Size size = MediaQuery
        .of(context)
        .size;
    //data from firebase
    final fullName = TextFormField(
        autofocus: false,
        controller: TextEditingController(text: "${loggedInUser.fullName}"),
        readOnly: true,
        textInputAction: TextInputAction.next,
        onTap: ()=> {
          setState((){


          })
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    String ans = votePlace;
    final voting = TextFormField(
        autofocus: false,
        maxLines: null,
        controller: TextEditingController(text: "$ans"),
        readOnly: true,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.where_to_vote),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Voting District",
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
        onTap: () => changePhoneNumber(context),
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
        onTap: () => changeAddress(context),
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

    final voteText = const Text(
      "Voting District",
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

                SizedBox(height: size.height * 0.02),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Form(

                    child: Column(
                      children: <Widget>[
                        voteText
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
                        voting
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

//for phone number
  changePhoneNumber(context) {

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

  //for address

  Widget setupAlertDialoadContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(

        itemCount: placePredictions.length,
        itemBuilder: (context,index) => LocationListTile(
          press:() async{address.text = placePredictions[index].description!;
          setState(() {
           listHeight = 0;
          });
            },
          location: placePredictions[index].description!,
        ),
      ),
    );
  }

  changeAddress(context) {
    showDialog(

      context: context,
      builder: (context) {

        listHeight = 0;
        address.text = loggedInUser.address!;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: Text("Change Address"),

              actions: <Widget>[
                SingleChildScrollView(
                 child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                    Container(




                       child: TextFormField(
                  autofocus:true ,
                  controller: address,
                  onChanged: (value) async {
                    if(address.text != ""){
                      setState(() {

                        listHeight = 270;
                      }
                      );}
                    placeAutoComplete(value);
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                      labelText: "Address"
                  ),
                  onSaved: (value) {
                    address.text = value!;
                  },

                ),
            ),
                 Container(

                  height: listHeight,


                  child: setupAlertDialoadContainer(),
                ),



                   DialogButton(

                    onPressed:  () =>

                        setState(() {
                          listHeight = 0;
                          if (address.text == "") {
                            Fluttertoast.showToast(msg: "Can't be null");
                            return null;
                          }
                          else {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(user!.uid)
                                .update({'address': address.text})
                                .then((value) => Fluttertoast.showToast(
                                msg: "Your address has been updated"))
                                .catchError((error) =>
                                Fluttertoast.showToast(
                                    msg: "Fail too update address"));
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
                  ),
            ],
                 ),
                ),
                ],
            );
          },
        );
      },
    );


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
