import 'package:flutter/material.dart';

 Widget textfield({required String text,
  required Color color,
  required double size,
  required FontWeight weight,
  TextOverflow? overflow}){
    return Text(text,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: weight,
      overflow: overflow,   
    ),);

  }