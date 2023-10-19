import 'package:flutter/material.dart';

class DeleteTripButton extends StatelessWidget {
  final int index;
  final VoidCallback onDelete;

  const DeleteTripButton(
      {super.key, required this.index, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onDelete();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // Change the button's background color
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              'Excluir'), // Change the text to "Excluir" (Delete in Portuguese)
          SizedBox(width: 2),
          Icon(Icons.delete, size: 14),
        ],
      ),
    );
  }
}
