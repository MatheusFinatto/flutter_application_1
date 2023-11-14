import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/viagens/widgets/components/buildActionButtons.dart';
import 'package:flutter_application_1/screens/viagens/widgets/components/buildTripDetails.dart';
import 'package:intl/intl.dart';

Widget buildTripCard(
    DocumentReference? veiculoReference,
    DocumentReference? responsavelReference,
    Map<String, dynamic> viagemData,
    String? viagemId,
    List<DocumentReference<Object?>>? participantesReference,
    bool containsGivenId,
    int index,
    currentUser,
    onPressedButton,
    showDeleteConfirmationDialog,
    context,
    empresaId) {
  return FutureBuilder<DocumentSnapshot>(
    future: veiculoReference?.get(),
    builder: (context, veiculoSnapshot) {
      Map<String, dynamic> veiculoData;
      if (!veiculoSnapshot.hasData || !veiculoSnapshot.data!.exists) {
        veiculoData = {'imageUrl': 'https://i.imgur.com/BVD0UE8.png'};
      } else {
        veiculoData = veiculoSnapshot.data!.data() as Map<String, dynamic>;
      }
      return FutureBuilder<DocumentSnapshot>(
        future: responsavelReference?.get(),
        builder: (context, responsavelSnapshot) {
          if (responsavelSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!responsavelSnapshot.hasData ||
              !responsavelSnapshot.data!.exists) {
            return const Text("No responsavel found.");
          }

          final DateTime dataInicio = viagemData['dataInicio'] != null
              ? viagemData['dataInicio'].toDate()
              : DateTime.now();

          final DateTime dataFim = viagemData['dataFim'] != null
              ? viagemData['dataFim'].toDate()
              : DateTime.now();

          final DateFormat dateTimeFormatter = DateFormat('dd/MM/yyyy HH:mm');

          return ListTile(
            subtitle: Column(
              children: [
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.network(
                          veiculoData['imageUrl'] as String? ??
                              'https://i.imgur.com/BVD0UE8.png',
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                        ),
                        const SizedBox(height: 16),
                        buildTripDetails(
                          veiculoData,
                          viagemData,
                          dateTimeFormatter,
                          dataInicio,
                          dataFim,
                        ),
                        const SizedBox(height: 10),
                        buildActionButtons(
                            veiculoData,
                            viagemData,
                            responsavelSnapshot,
                            participantesReference,
                            viagemId,
                            containsGivenId,
                            index,
                            currentUser,
                            onPressedButton,
                            showDeleteConfirmationDialog,
                            context,
                            empresaId),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
