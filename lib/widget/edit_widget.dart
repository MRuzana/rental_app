import 'package:flutter/material.dart';

class EditAlert extends StatelessWidget {
  final void Function() onEdit;
  const EditAlert({super.key,required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Alert'),
      content: const Text('Do you want to edit?'),
      actions: [
         TextButton(
            onPressed: onEdit,
            child: const Text(('YES'))),

          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: const Text('NO'))  
      ],

    );
  }
}

