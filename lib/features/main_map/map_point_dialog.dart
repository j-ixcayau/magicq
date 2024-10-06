import 'package:flutter/material.dart';

void showCustomDialog(
  BuildContext context,
  String title,
  String? description,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (description != null) ...[
                Text(description),
                const SizedBox(height: 8.0),
              ],
              const SizedBox(height: 8.0),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}
