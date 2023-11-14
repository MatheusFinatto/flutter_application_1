import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/pessoas.dart';
import 'package:flutter_application_1/screens/viagens/add_trip_form.dart';
import 'package:flutter_application_1/screens/viagens/widgets/components/buildTripList.dart';

class ViagensScreen extends StatefulWidget {
  const ViagensScreen({Key? key}) : super(key: key);

  @override
  ViagensScreenState createState() => ViagensScreenState();
}

class ViagensScreenState extends State<ViagensScreen> {
  final TextEditingController _searchController = TextEditingController();
  final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
  late Pessoa currentUser = Pessoa();

  String empresaId = 'UywGfjmMyYNRHFyx5hUN';

  @override
  void initState() {
    super.initState();
    getDados();
  }

  void getDados() async {
    Pessoa user = Pessoa();
    Pessoa pessoa = await user.getUserSession() as Pessoa;
    setState(() {
      currentUser = pessoa;
    });
  }

  void onPressedButton(participantesReference, viagemId) {
    FirebaseFirestore.instance
        .collection('empresas')
        .doc(empresaId)
        .collection('viagens')
        .doc(viagemId) // Specify the document ID for the viagem
        .get()
        .then((viagemSnapshot) {
      if (viagemSnapshot.exists) {
        // Retrieve the current document data
        var viagemData = viagemSnapshot.data() as Map<String, dynamic>;

        bool containsGivenId = participantesReference.any((reference) {
          final String referenceId = reference.id;
          return referenceId == currentUser.id;
        });

        // Modify the participantes array
        List<DocumentReference> participantes =
            (viagemData['participantes'] as List<dynamic> ?? [])
                .map((participant) {
                  if (participant is DocumentReference) {
                    return participant;
                  } else if (participant is String) {
                    // Assuming the format is 'pessoas/userId'
                    return FirebaseFirestore.instance.doc(participant);
                  }
                  return null;
                })
                .whereType<DocumentReference>()
                .toList();

        if (containsGivenId) {
          participantes.remove(
              FirebaseFirestore.instance.doc('pessoas/${currentUser.id}'));
        } else {
          participantes
              .add(FirebaseFirestore.instance.doc('pessoas/${currentUser.id}'));
        }

        // Update the document with the modified data
        viagemSnapshot.reference.update({'participantes': participantes});

        SnackBar snackBar = SnackBar(
          content: Text(!containsGivenId
              ? "Pedido para participação enviado com sucesso!"
              : "Pedido de participação cancelado!"),
          duration: const Duration(seconds: 2),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print('Document with ID $viagemId does not exist.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viagens'),
      ),
      body: Column(
        children: [
          buildTripsList(empresaId, currentUser),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTripScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
