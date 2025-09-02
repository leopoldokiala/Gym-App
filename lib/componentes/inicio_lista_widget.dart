import 'package:flutter/material.dart';
import 'package:gym_app/componentes/adicionar_editar_exercicio.dart';
import 'package:gym_app/_comum/minhas_cores.dart';
import 'package:gym_app/modelos/exercicio_modelo.dart';
import 'package:gym_app/servicos/exercicio_servico.dart';

import '../telas/exercicio_tela.dart';

class InicioItemLista extends StatelessWidget {
  final ExercicioModelo exercicioModelo;
  final ExercicioServico servico;
  const InicioItemLista({
    super.key,
    required this.exercicioModelo,
    required this.servico,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ExercicioTela(exercicioModelo: exercicioModelo);
            },
          ),
        );
      },

      child: Container(
        height: 100.0,
        margin: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Colors.black.withAlpha(125),
              spreadRadius: 1,
              offset: Offset(2, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 150.0,
                height: 30.0,
                decoration: BoxDecoration(
                  color: MinhasCores.azulEscuro,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
                child: Text(
                  exercicioModelo.treino,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200.0,
                        child: Text(
                          exercicioModelo.nome,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MinhasCores.azulEscuro,
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                          ),
                        ),
                      ),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              mostrarAdicionarEditarExercicioModal(
                                context,
                                exercicio: exercicioModelo,
                              );
                            },
                            icon: Icon(Icons.edit, color: Colors.yellow),
                          ),
                          IconButton(
                            onPressed: () {
                              SnackBar snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  'Deseja remover ${exercicioModelo.nome}?',
                                ),
                                action: SnackBarAction(
                                  label: 'REMOVER',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    servico.removerExercicio(
                                      exercicioModelo: exercicioModelo,
                                    );
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(snackBar);
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 150.0,
                        child: Text(
                          exercicioModelo.comoFazer,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
