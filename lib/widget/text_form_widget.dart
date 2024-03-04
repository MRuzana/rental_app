
import 'package:flutter/material.dart';

Widget textField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String hintText,
  required String? Function(String?)? validator,
}){
  return Padding(
    padding: const EdgeInsets.only(left: 20,right: 20 ),
    child: TextFormField(
      cursorColor: Colors.black,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xff8ECFCB),
        hintText: hintText,      
      ),
      validator: validator,
    ),
  );
}
