import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/viagens.dart';
import 'package:flutter_application_1/screens/viagens/add_trip_form.dart';

class EditTripButton extends StatelessWidget {
  final Map<String, dynamic> trip;

  const EditTripButton({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddTripScreen(isEdit: true),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 60, 141, 130),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Editar'),
            SizedBox(width: 2),
            Icon(Icons.edit, size: 14),
          ],
        ),
      ),
    );
  }
}
