import 'package:flutter/material.dart';

class AutocompletePrediction {
  late final String? description;

  late final StructuredFormatting? structuredFormatting;

  late final String? placeID;

  late final String? reference;

  AutocompletePrediction({
    this.description,
    this.structuredFormatting,
    this.placeID,
    this.reference


});

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json){
    return AutocompletePrediction(
      description: json['description'] as String?,
      placeID: json['place_id'] as String?,
      reference: json['reference'] as String?,
      structuredFormatting: json['structured_formatting']!= null
        ? StructuredFormatting.fromJson(json['structured_formatting']):null
    );


  }


}

class StructuredFormatting {
  late final String? mainText;
  late final String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String,dynamic> json){
    return StructuredFormatting(
      mainText: json['main_text'] as String?,
      secondaryText: json['secondary_text'] as String?,
    );
  }



}