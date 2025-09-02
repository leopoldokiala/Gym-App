import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gym_app/modelos/exercicio_modelo.dart';

class ExercicioServico {
  String userId;
  ExercicioServico() : userId = FirebaseAuth.instance.currentUser!.uid;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarExercicio(ExercicioModelo exercicioModelo) async {
    return await _firestore
        .collection(userId)
        .doc(exercicioModelo.id)
        .set(exercicioModelo.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStreamExercicios(
    bool isDecrescente,
  ) {
    return _firestore
        .collection(userId)
        .orderBy('treino', descending: isDecrescente)
        .snapshots();
  }

  Future<void> removerExercicio({
    required ExercicioModelo exercicioModelo,
  }) async {
    await removerImagem(exercicioModelo);
    return _firestore.collection(userId).doc(exercicioModelo.id).delete();
  }

  Future<void> removerImagem(ExercicioModelo exercicioModelo) async {
    if (exercicioModelo.urlImagem != null) {
      await FirebaseStorage.instance.ref(exercicioModelo.urlImagem).delete();
    }

    exercicioModelo.urlImagem = null;
    ExercicioServico().adicionarExercicio(exercicioModelo);
  }
}
