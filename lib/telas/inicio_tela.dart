import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/_comum/clique_dot_code.dart';
import 'package:gym_app/componentes/adicionar_editar_exercicio.dart';
import 'package:gym_app/_comum/minhas_cores.dart';
import 'package:gym_app/componentes/inicio_lista_widget.dart';
import 'package:gym_app/modelos/exercicio_modelo.dart';
import 'package:gym_app/servicos/autenticacao_servico.dart';
import 'package:gym_app/servicos/exercicio_servico.dart';

class InicioTela extends StatefulWidget {
  final User user;
  InicioTela({super.key, required this.user});

  @override
  State<InicioTela> createState() => _InicioTelaState();
}

class _InicioTelaState extends State<InicioTela> {
  final ExercicioServico servico = ExercicioServico();
  bool isDecrescente = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus exercícios'),
        backgroundColor: MinhasCores.azulEscuro,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isDecrescente = !isDecrescente;
              });
            },
            icon: Icon(Icons.sort_by_alpha_rounded),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: MinhasCores.azulEscuro),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('images/usuario.png'),
              ),
              accountName: Text(
                widget.user.displayName != null ? widget.user.displayName! : '',
              ),
              accountEmail: Text(widget.user.email!),
            ),
            ListTile(
              title: Text('Como o este App foi feito?'),
              leading: Icon(Icons.menu_book_rounded),
              dense: true,
              onTap: () {
                cliqueDotCode();
              },
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.logout),
              title: Text('Deslogar'),
              onTap: () {
                AutenticacaoServico().deslogar();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: StreamBuilder(
          stream: servico.conectarStreamExercicios(isDecrescente),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: MinhasCores.azulEscuro),
              );
            } else {
              if (snapshot.hasData &&
                  snapshot.data != snapshot.data!.docs.isNotEmpty) {
                List<ExercicioModelo> listaExercicios = [];

                for (var doc in snapshot.data!.docs) {
                  listaExercicios.add(ExercicioModelo.fromMap(doc.data()));
                }
                return ListView(
                  children: List.generate(listaExercicios.length, (index) {
                    ExercicioModelo exercicioModelo = listaExercicios[index];
                    return InicioItemLista(
                      exercicioModelo: exercicioModelo,
                      servico: servico,
                    );
                  }),
                );
              } else {
                return Center(
                  child: Text('Ainda nenhum exercício 🥵. \n Vamos adicionar?'),
                );
              }
            }
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: MinhasCores.azulEscuro,
        foregroundColor: Colors.white,
        onPressed: () {
          mostrarAdicionarEditarExercicioModal(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
