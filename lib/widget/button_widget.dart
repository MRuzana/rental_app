import 'package:flutter/material.dart';

Widget button({
  required String buttonText,
  required void Function() buttonPressed,
  
}){
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 195, 247, 247),     
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            )
        
          ),
          onPressed: buttonPressed,
          child: Text(buttonText,style: const TextStyle(
            color: Colors.black
          ),)),
      ],
    ),
  );
}

                 