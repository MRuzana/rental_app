import 'package:flutter/material.dart';

Widget noProduct({required String message}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(255, 206, 242, 242),
        ),          
        child:  Center(             
          child: Text(message,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 19.0),),
        )
      )
    ),
  );
}
