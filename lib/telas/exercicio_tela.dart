import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/_comum/minhas_cores.dart';
import 'package:gym_app/componentes/adicionar_editar_sentimento_modal.dart';
import 'package:gym_app/modelos/exercicio_modelo.dart';
import 'package:gym_app/modelos/sentimento_modelo.dart';
import 'package:gym_app/servicos/exercicio_servico.dart';
import 'package:gym_app/servicos/sentimento_servico.dart';
import 'package:image_picker/image_picker.dart';

class ExercicioTela extends StatefulWidget {
  final ExercicioModelo exercicioModelo;
  ExercicioTela({super.key, required this.exercicioModelo});

  @override
  State<ExercicioTela> createState() => _ExercicioTelaState();
}

class _ExercicioTelaState extends State<ExercicioTela> {
  SentimentoServico _sentimentoServico = SentimentoServico();
  bool isUploadingImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MinhasCores.azulBaixoGradiente,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              widget.exercicioModelo.nome,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
            Text(
              widget.exercicioModelo.treino,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: MinhasCores.azulEscuro,
        foregroundColor: Colors.white,
        onPressed: () {
          mostrarAdicionarEditarSentimentoDialog(
            context,
            idExercicio: widget.exercicioModelo.id,
          );
        },
        child: Icon(Icons.add),
      ),

      body: Container(
        margin: EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 250.0,
              child:
                  (isUploadingImage)
                      ? Center(
                        child: LinearProgressIndicator(
                          color: MinhasCores.azulEscuro,
                        ),
                      )
                      : (widget.exercicioModelo.urlImagem != null)
                      ? Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: FutureBuilder(
                              future:
                                  FirebaseStorage.instance
                                      .ref(widget.exercicioModelo.urlImagem!)
                                      .getDownloadURL(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: MinhasCores.azulEscuro,
                                    ),
                                  );
                                }

                                return Image.network(
                                  snapshot.data!,
                                  alignment: Alignment.center,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    //Se já terminou de carregar
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    //Se tá carregando e eu sei o total do tamanho da imagem
                                    if (loadingProgress.expectedTotalBytes !=
                                        null) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: CircularProgressIndicator(
                                              color: MinhasCores.azulEscuro,
                                              value:
                                                  (loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!),
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${((loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!) * 100).toStringAsFixed(2)}',
                                            ),
                                          ),
                                        ],
                                      );
                                    }

                                    //Se tá carregando e eu não sei o total
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: MinhasCores.azulEscuro,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                ExercicioServico().removerImagem(
                                  widget.exercicioModelo,
                                );
                              },
                              icon: Icon(Icons.delete, color: Colors.orange),
                            ),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Colors.purple.shade200,
                              ),
                            ),
                            onPressed: () {
                              _uploadImage(context, false);
                            },
                            child: Text(
                              'Enviar foto',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Colors.purple.shade200,
                              ),
                            ),
                            onPressed: () {
                              _uploadImage(context, true);
                            },
                            child: Text(
                              'Tirar foto',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Como fazer?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              widget.exercicioModelo.comoFazer,
              style: TextStyle(fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(color: Colors.black),
            ),
            Text(
              'Como estou me sentindo?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8.0),

            StreamBuilder(
              stream: _sentimentoServico.conectarStream(
                idExercicio: widget.exercicioModelo.id,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: MinhasCores.azulEscuro,
                    ),
                  );
                } else {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.docs.isNotEmpty) {
                    final List<SentimentoModelo> listaSentimentos = [];

                    for (var doc in snapshot.data!.docs) {
                      listaSentimentos.add(
                        SentimentoModelo.fromMap(doc.data()),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(listaSentimentos.length, (index) {
                        SentimentoModelo sentimentoAgora =
                            listaSentimentos[index];
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(sentimentoAgora.sentindo),
                          subtitle: Text(sentimentoAgora.data),
                          leading: Icon(Icons.double_arrow),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  mostrarAdicionarEditarSentimentoDialog(
                                    context,
                                    idExercicio: widget.exercicioModelo.id,
                                    sentimentoModelo: sentimentoAgora,
                                  );
                                },
                                icon: Icon(Icons.edit, color: Colors.yellow),
                              ),
                              IconButton(
                                onPressed: () {
                                  _sentimentoServico.removerSentimento(
                                    exercicioId: widget.exercicioModelo.id,
                                    sentimentoId: sentimentoAgora.id,
                                  );
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  } else {
                    return Text('Nenhuma anotação ainda');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _uploadImage(BuildContext context, bool isCamera) async {
    setState(() {
      isUploadingImage = true;
    });
    ImagePicker imagePicker = ImagePicker();

    XFile? image = await imagePicker.pickImage(
      source: (isCamera) ? ImageSource.camera : ImageSource.gallery,
      maxHeight: 2000.0,
      maxWidth: 2000.0,
    );

    if (image != null) {
      File file = File(image.path);

      await FirebaseStorage.instance
          .ref(widget.exercicioModelo.id + image.name)
          .putFile(file);
      String url = widget.exercicioModelo.id + image.name;
      // await result.ref.getDownloadURL();

      setState(() {
        widget.exercicioModelo.urlImagem = url;
        ExercicioServico().adicionarExercicio(widget.exercicioModelo);
      });
    } else {
      mostrarAnackBarNenhumaImagem();
    }
    setState(() {
      isUploadingImage = false;
    });
  }

  mostrarAnackBarNenhumaImagem() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text('Nenhuma imagem foi selecionada'),
      ),
    );
  }
}
