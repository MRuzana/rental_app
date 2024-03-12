import 'package:flutter/material.dart';

Widget textFormCalender({
  required TextEditingController controller,
  required void Function()? onTapCaleneder,
  required String hinttext,
  required String? Function(String?)? validator
  }) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
    child: TextFormField(
      readOnly: true,
      cursorColor: Colors.black,
      controller: controller,
      keyboardType: TextInputType.none,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide.none),
          suffixIcon: GestureDetector(
              onTap: onTapCaleneder,
              child: const Icon(Icons.calendar_month)),
          filled: true,
          fillColor: const  Color.fromARGB(255, 206, 242, 242),   
          hintText: hinttext),
      validator: validator,
    ),
  );
}
