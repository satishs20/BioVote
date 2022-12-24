import 'dart:convert';

import 'package:flutter/material.dart';
import 'autocomplete_prediction.dart';

class PlaceAutocompleteResponse{
late   final String? status;
late final  List<AutocompletePrediction> predictions;

PlaceAutocompleteResponse({this.status, required this.predictions});

factory PlaceAutocompleteResponse.fromJson(Map <String, dynamic>json ){
  return PlaceAutocompleteResponse(
      status: json['status'] as String?,
      predictions: json['predictions'] != null
        ? json['predictions'].map<AutocompletePrediction>(
           (json) => AutocompletePrediction.fromJson(json)).toList()
           :null,

  );



}

static PlaceAutocompleteResponse parseAutoCompleteResult( String responseBody){
  final parsed = jsonDecode(responseBody).cast<String, dynamic>();
  return PlaceAutocompleteResponse.fromJson(parsed);
  }

}