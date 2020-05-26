import 'package:flutter/material.dart';

 class CourseModel
 {
   String _vehicleTypeId;
   String _vehicleType;
   String _description;
   String _vehicleImage;


   String get vehicleImage => _vehicleImage;

   set vehicleImage(String value) {
     _vehicleImage = value;
   }

   String get vehicleTypeId => _vehicleTypeId;

   set vehicleTypeId(String value) {
     _vehicleTypeId = value;
   }

   String get vehicleType => _vehicleType;

   set vehicleType(String value) {
     _vehicleType = value;
   }

   String get description => _description;

   set description(String value) {
     _description = value;
   }


 }