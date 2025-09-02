import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/_comum/minhas_cores.dart';
import 'package:gym_app/telas/autenticacao_tela.dart';
import 'package:gym_app/telas/inicio_tela.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 🔹 Storage → Emulator
  final storage = FirebaseStorage.instance;
  storage.useStorageEmulator('localhost', 9199); // Porta do seu emulator

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        primarySwatch: MinhasCores.azulEscuro,
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: MinhasCores.azulEscuro,
          elevation: 0,
          toolbarHeight: 72.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.0)),
          ),
          centerTitle: true,
        ),
      ),
      home: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  MinhasCores.azulTopoGradiente,
                  MinhasCores.azulBaixoGradiente,
                ],
              ),
            ),
          ),

          RoteadorTela(),
        ],
      ),
    );
  }
}

class RoteadorTela extends StatelessWidget {
  const RoteadorTela({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return InicioTela(user: snapshot.data!);
        } else {
          return AutenticacaoTela();
        }
      },
    );
  }
}
