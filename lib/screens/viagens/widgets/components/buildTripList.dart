import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/viagens/widgets/components/buildTripCard.dart';

Widget buildTripsList(empresaId, currentUser, onPressedButton) {
  bool isLoading = false;
  return Expanded(
    child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('empresas')
          .doc(empresaId)
          .collection('viagens')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Nenhuma viagem cadastrada!"));
        }

        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            final viagemData =
                snapshot.data?.docs[index].data() as Map<String, dynamic>;

            final viagemId = snapshot.data?.docs[index].id;

            DocumentReference? veiculoReference =
                viagemData['veiculo'] as DocumentReference?;

            DocumentReference? responsavelReference =
                viagemData['responsavel'] as DocumentReference?;

            List<DocumentReference<Object?>>? participantesReference = [];

            if (viagemData['participantes'] != null) {
              final List<dynamic> dynamicList = viagemData['participantes'];
              participantesReference =
                  dynamicList.whereType<DocumentReference<Object?>>().toList();
            }

            bool containsGivenId = participantesReference.any((reference) {
              final String referenceId = reference.id;
              return referenceId == currentUser.id;
            });

            if (veiculoReference != null || responsavelReference != null) {
              return buildTripCard(
                veiculoReference,
                responsavelReference,
                viagemData,
                viagemId,
                participantesReference,
                containsGivenId,
                index,
                currentUser,
                onPressedButton,
                context,
                empresaId,
              );
            } else {
              return const Text("Há dados inconsistentes no banco de dados.");
            }
          },
        );
      },
    ),
  );
}
