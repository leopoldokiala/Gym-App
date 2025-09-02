import 'package:flutter/material.dart';
import 'package:gym_app/_comum/minhas_cores.dart';
import 'package:gym_app/componentes/decoracao_campo_autenticacao.dart';
import 'package:gym_app/modelos/exercicio_modelo.dart';
import 'package:gym_app/modelos/sentimento_modelo.dart';
import 'package:gym_app/servicos/exercicio_servico.dart';
import 'package:gym_app/servicos/sentimento_servico.dart';
import 'package:uuid/uuid.dart';

mostrarAdicionarEditarExercicioModal(
  BuildContext context, {
  ExercicioModelo? exercicio,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: MinhasCores.azulEscuro,
    isDismissible: false,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
    ),
    builder: (context) {
      return ExercicioModal(exercicioModelo: exercicio);
    },
  );
}

class ExercicioModal extends StatefulWidget {
  final ExercicioModelo? exercicioModelo;
  ExercicioModal({super.key, this.exercicioModelo});

  @override
  State<ExercicioModal> createState() => _ExercicioModalState();
}

class _ExercicioModalState extends State<ExercicioModal> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _treinoController = TextEditingController();
  TextEditingController _anotacoesController = TextEditingController();
  TextEditingController _sentindoController = TextEditingController();

  bool isCarregando = false;

  ExercicioServico _exercicioServico = ExercicioServico();

  @override
  void initState() {
    if (widget.exercicioModelo != null) {
      _nomeController.text = widget.exercicioModelo!.nome;
      _treinoController.text = widget.exercicioModelo!.treino;
      _anotacoesController.text = widget.exercicioModelo!.comoFazer;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.0),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (widget.exercicioModelo != null)
                          ? 'Editar ${widget.exercicioModelo!.nome}'
                          : 'Adicionar Exercício',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Divider(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _nomeController,
                      decoration: getAuthenticationInputDecoration(
                        'Qual é o nome do exercício?',
                        icon: Icon(Icons.abc, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _treinoController,
                      decoration: getAuthenticationInputDecoration(
                        'Qual é treino pertence?',
                        icon: Icon(Icons.list_alt_rounded, color: Colors.white),
                      ),
                    ),
                    Text(
                      'Use o mesmo nome para exercícios que pertencem ao mesmo treino.',
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _anotacoesController,
                      decoration: getAuthenticationInputDecoration(
                        'Quais anotações você tem',
                        icon: Icon(Icons.notes_rounded, color: Colors.white),
                      ),
                      maxLines: null,
                    ),
                    Visibility(
                      visible: (widget.exercicioModelo == null),
                      child: Column(
                        children: [
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _sentindoController,
                            decoration: getAuthenticationInputDecoration(
                              'Como está se sentindo?',
                              icon: Icon(
                                Icons.emoji_emotions_rounded,
                                color: Colors.white,
                              ),
                            ),
                            maxLines: null,
                          ),
                          Text(
                            'Você não precisa preencher isso agora.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            ElevatedButton(
              onPressed: () {
                enviarClicado();
              },
              child:
                  (isCarregando)
                      ? SizedBox(
                        width: 16.0,
                        height: 16.0,
                        child: CircularProgressIndicator(
                          color: MinhasCores.azulEscuro,
                        ),
                      )
                      : Text(
                        (widget.exercicioModelo == null)
                            ? 'Criar exercício'
                            : 'Atualizar exercício',
                        style: TextStyle(color: Colors.black),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  enviarClicado() {
    setState(() {
      isCarregando = true;
    });

    String nome = _nomeController.text;
    String treino = _treinoController.text;
    String anotacoes = _anotacoesController.text;
    String sentindo = _sentindoController.text;

    ExercicioModelo exercicio = ExercicioModelo(
      id: Uuid().v1(),
      nome: nome,
      treino: treino,
      comoFazer: anotacoes,
    );

    if (widget.exercicioModelo != null) {
      exercicio.id = widget.exercicioModelo!.id;
    }

    _exercicioServico.adicionarExercicio(exercicio).then((value) {
      if (sentindo != '') {
        SentimentoModelo sentimento = SentimentoModelo(
          id: Uuid().v1(),
          sentindo: sentindo,
          data: DateTime.now().toString(),
        );
        SentimentoServico()
            .adicionarSentimento(
              idExercicio: exercicio.id,
              sentimentoModelo: sentimento,
            )
            .then((value) {
              setState(() {
                isCarregando = false;
              });
              Navigator.pop(context);
            });
      } else {
        Navigator.pop(context);
      }
    });
  }
}
