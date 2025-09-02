import 'package:flutter/material.dart';
import 'package:gym_app/_comum/clique_dot_code.dart';
import 'package:gym_app/_comum/meu_snackbar.dart';
import 'package:gym_app/componentes/decoracao_campo_autenticacao.dart';
import 'package:gym_app/servicos/autenticacao_servico.dart';

class AutenticacaoTela extends StatefulWidget {
  const AutenticacaoTela({super.key});

  @override
  State<AutenticacaoTela> createState() => _AutenticacaoTelaState();
}

class _AutenticacaoTelaState extends State<AutenticacaoTela> {
  bool queroEntrar = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _nomeController = TextEditingController();
  AutenticacaoServico _autenServico = AutenticacaoServico();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset('images/logo.png', height: 128),
                    Text(
                      'GymApp',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 48.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: getAuthenticationInputDecoration('E-mail'),
                      validator: (String? value) {
                        if (value == null) {
                          return 'O e-mail não pode ser vazio';
                        }
                        if (value.length < 6) {
                          return 'O e-mail é muito curto';
                        }
                        if (!value.contains('@')) {
                          return 'O email não é válido';
                        }
                        if (!RegExp(
                          r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'E-mail inválido';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: getAuthenticationInputDecoration('Senha'),
                      validator: (String? value) {
                        if (value == null) {
                          return 'A senha não deve estar vazia';
                        }
                        if (value.length < 5) {
                          return 'A senha é muito curta';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 8.0),
                    Visibility(
                      visible: !queroEntrar,
                      child: Column(
                        children: [
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _nomeController,
                            decoration: getAuthenticationInputDecoration(
                              'Nome',
                            ),
                            validator: (String? value) {
                              if (value == null) {
                                return 'O nome não pode ser vazio';
                              }
                              if (value.length < 5) {
                                return 'O nome é muito curto';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue),
                      ),
                      onPressed: () {
                        setState(() {
                          botaoPrincipalClicado();
                        });
                      },
                      child: Text(
                        (queroEntrar) ? 'Entrar' : 'Cadastrar',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                    Divider(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          queroEntrar = !queroEntrar;
                        });
                      },
                      child: Text(
                        (queroEntrar)
                            ? 'Ainda não tem uma conta? Cadastre-se!'
                            : 'Já tem uma conta? Entre!',
                        style: TextStyle(color: Colors.blue, fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom <= 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('images/logo_dotcode.jpg', width: 24.0),
                    SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: () {
                        cliqueDotCode();
                      },
                      child: Text(
                        'Feito com 💙 e Flutter por @DotcodeEdu.\n e veja como foi feito!',
                        style: TextStyle(fontSize: 12.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  botaoPrincipalClicado() {
    String nome = _nomeController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;
    if (_formKey.currentState!.validate()) {
      if (queroEntrar) {
        print('Entrada Validada.');
        _autenServico.logarUsuarios(email: email, senha: senha).then((
          String? erro,
        ) {
          if (erro != null) {
            mostrarSnackBar(context: context, texto: erro);
          } else {}
        });
      } else {
        print('Cadastro Validado.');
        print(
          '${_emailController.text}, ${_senhaController}, ${_nomeController}',
        );
        _autenServico
            .cadastrarUsuario(nome: nome, senha: senha, email: email)
            .then((String? erro) {
              if (erro != null) {
                //Voltou com erro
                mostrarSnackBar(context: context, texto: erro);
              }
            });
      }
    } else {
      print('Form inválido!');
    }
  }
}
