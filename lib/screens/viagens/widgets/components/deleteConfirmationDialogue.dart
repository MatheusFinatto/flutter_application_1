import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showDeleteConfirmationDialog(BuildContext context, viagemId, empresaId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Excluir viagem'),
        content: const Text('Tem certeza que deseja excluir esta viagem?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Excluir viagem from firebase
              FirebaseFirestore.instance
                  .collection('empresas')
                  .doc(empresaId)
                  .collection('viagens')
                  .doc(viagemId)
                  .delete();
              Navigator.of(context).pop();
              SnackBar snackBar = const SnackBar(
                content: Text("Viagem excluída com sucesso!"),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Text('Excluir'),
          ),
        ],
      );
    },
  );
}
