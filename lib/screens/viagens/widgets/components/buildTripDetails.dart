import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildTripDetails(
  Map<String, dynamic> veiculoData,
  Map<String, dynamic> viagemData,
  DateFormat dateTimeFormatter,
  DateTime dataInicio,
  DateTime dataFim,
) {
  return Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Origem: ${viagemData['cidadeOrigem']} - ${viagemData['estadoOrigem']}',
            ),
            Text(
              'Destino: ${viagemData['cidadeDestino']} - ${viagemData['estadoDestino']}',
            ),
            FutureBuilder<DocumentSnapshot>(
              future: viagemData['responsavel'].get(),
              builder: (context, responsavelSnapshot) {
                if (!responsavelSnapshot.hasData) {
                  return const Text('Responsável: N/A');
                }

                final responsavelData =
                    responsavelSnapshot.data?.data() as Map<String, dynamic>;
                final nome = responsavelData['nome'] as String? ?? 'N/A';

                return Text(
                  'Responsável: $nome',
                );
              },
            ),
            Text(
              'Data prevista de saída: ${dateTimeFormatter.format(dataInicio)}',
            ),
            Text(
              'Data prevista de retorno: ${dateTimeFormatter.format(dataFim)}',
            ),
            Text(
              'Participantes: ${viagemData['participantes'].length}',
            ),
          ],
        ),
      ),
    ],
  );
}
