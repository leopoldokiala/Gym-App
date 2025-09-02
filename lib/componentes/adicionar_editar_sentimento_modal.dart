import 'package:flutter/material.dart';
import 'package:gym_app/modelos/sentimento_modelo.dart';
import 'package:gym_app/servicos/sentimento_servico.dart';
import 'package:uuid/uuid.dart';

Future<dynamic> mostrarAdicionarEditarSentimentoDialog(
  BuildContext context, {
  required String idExercicio,
  SentimentoModelo? sentimentoModelo,
}) {
  TextEditingController sentimentoController = TextEditingController();
  if (sentimentoModelo != null) {
    sentimentoController.text = sentimentoModelo.sentindo;
  }

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Como você está se sentindo?'),
        content: TextFormField(
          controller: sentimentoController,
          decoration: InputDecoration(label: Text('Diga aí o que tu sentes')),
        ),
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.purple.shade200),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Colors.purple.shade200,
                  ),
                ),
                onPressed: () {
                  SentimentoModelo sentimento = SentimentoModelo(
                    id: Uuid().v1(),
                    sentindo: sentimentoController.text,
                    data: DateTime.now().toString(),
                  );
                  if (sentimentoModelo != null) {
                    sentimento.id = sentimentoModelo.id;
                  }

                  SentimentoServico().adicionarSentimento(
                    idExercicio: idExercicio,
                    sentimentoModelo: sentimento,
                  );

                  Navigator.pop(context);
                },
                child: Text(
                  sentimentoModelo != null
                      ? 'Editar sentimento'
                      : 'Criar sentimento',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
