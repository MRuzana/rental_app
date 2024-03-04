import 'package:flutter/material.dart';

class DeleteAlert extends StatelessWidget {
  final void Function() onDelete;
  const DeleteAlert({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Alert'),
      content: const Text('Do you want to delete?'),
      actions: [
        TextButton(onPressed: onDelete, child: const Text(('YES'))),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('NO'))
      ],
    );
  }
}


