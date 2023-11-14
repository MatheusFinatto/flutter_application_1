import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/viagens/widgets/buttons/delete_trip_button.dart';
import 'package:flutter_application_1/screens/viagens/widgets/buttons/edit_trip_button.dart';

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

Widget buildActionButtons(
  Map<String, dynamic> veiculoData,
  Map<String, dynamic> viagemData,
  AsyncSnapshot<DocumentSnapshot> responsavelSnapshot,
  List<DocumentReference<Object?>>? participantesReference,
  String? viagemId,
  bool containsGivenId,
  int index,
  currentUser,
  onPressedButton,
  context,
  empresaId,
) {
  if (!responsavelSnapshot.hasData) {
    return const Text('Responsável: N/A');
  }

  final responsavelData =
      responsavelSnapshot.data?.data() as Map<String, dynamic>;
  final email = responsavelData['email'] as String? ?? 'N/A';

  final capacidade = veiculoData['capacidade'] as int?;
  final participantesLength = viagemData['participantes'].length as int;

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (currentUser.email != email)
        ElevatedButton(
          onPressed: () {
            if (capacidade != null && capacidade - participantesLength > 0 ||
                containsGivenId) {
              onPressedButton(participantesReference, viagemId);
            }
          },
          style: containsGivenId
              ? ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                )
              : (capacidade != null)
                  ? (capacidade - participantesLength <= 0)
                      ? ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[400],
                        )
                      : null
                  : null,
          child: Text(
            (capacidade != null)
                ? containsGivenId
                    ? 'Desistir'
                    : (capacidade - participantesLength <= 0)
                        ? 'Veículo lotado'
                        : 'Participar'
                : 'Erro',
          ),
        ),
      if (currentUser.email == email)
        EditTripButton(
          trip: viagemData,
        ),
      if (currentUser.email == email)
        DeleteTripButton(
          index: index,
          onDelete: () =>
              showDeleteConfirmationDialog(context, viagemId, empresaId),
        ),
    ],
  );
}
