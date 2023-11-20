import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screens/conta/login_page.dart';
import 'package:flutter_application_1/screens/home/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _empresaIdController = TextEditingController();

  bool state = false;

  String _msgErro = "";

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool validateCPF(String cpf) {
    String cleanedCPF = cpf.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanedCPF.length != 11) {
      return false;
    }

    if (RegExp(r'^(\d)\1*$').hasMatch(cleanedCPF)) {
      return false;
    }

    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cleanedCPF[i]) * (10 - i);
    }

    int firstDigit = (sum * 10) % 11;
    if (firstDigit == 10) {
      firstDigit = 0;
    }

    if (firstDigit != int.parse(cleanedCPF[9])) {
      return false;
    }

    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cleanedCPF[i]) * (11 - i);
    }
    int secondDigit = (sum * 10) % 11;
    if (secondDigit == 10) {
      secondDigit = 0;
    }
    if (secondDigit != int.parse(cleanedCPF[10])) {
      return false;
    }

    return true;
  }

  _createAccount() {
    String email = _emailController.text;
    String password = _passwordController.text;
    String nome = _nameController.text;
    String cpf = _cpfController.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty && password.length >= 6) {
        if (validateCPF(cpf)) {
          if (nome.isNotEmpty) {
            _msgErro = "";
            //instancia do auth
            FirebaseAuth auth = FirebaseAuth.instance;
            //instancia do bd
            FirebaseFirestore db = FirebaseFirestore.instance;

            //gravar no banco
            Map<String, dynamic> dadosUser = {
              'nome': nome,
              'email': email,
              'cpf': cpf
            };

            auth
                .createUserWithEmailAndPassword(
                    email: email, password: password)
                .then((firebaseUser) => {
                      //gravar no banco usando o UID
                      db
                          .collection('pessoas')
                          .doc(firebaseUser.user!.uid)
                          .set(dadosUser),
                      _msgErro = "Sucesso ao logar",
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false)
                    })
                .onError((error, stackTrace) => {_msgErro = error.toString()});
          } else {
            setState(() {
              _msgErro = "Nome não pode ser vazio";
            });
          }
        } else {
          setState(() {
            _msgErro = "CPF Invalido";
          });
        }
      } else {
        setState(() {
          _msgErro = "A senha deve ter pelo menos 6 caracteres";
        });
      }
    } else {
      setState(() {
        _msgErro = "Email invalido";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 100, 10, 50),
            child: Column(
              children: [
                _buildHeaderText(),
                SizedBox(height: 30),
                _buildInputs(),
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Column(
      children: <Widget>[
        Text(
          "Bem vindo ao Taix!",
          style: GoogleFonts.inter(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.none,
          ),
        ),
        SizedBox(height: 2),
        Text(
          "Vamos começar nos conhecendo :)",
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }

  Widget _buildInputs() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Nome Completo",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Insira seu nome completo';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(50.0), // Adjust the radius as needed
              ),
            ),
            validator: (value) {
              if (value!.isEmpty || !value.contains('@')) {
                return 'Insira um email válido';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _cpfController,
            decoration: InputDecoration(
              labelText: "CPF",
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(50.0), // Adjust the radius as needed
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Insira seu CPF';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Senha",
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(50.0), // Adjust the radius as needed
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Digite sua senha';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Digite novamente sua senha",
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(50.0), // Adjust the radius as needed
              ),
            ),
            validator: (value) {
              if (value != _passwordController.text) {
                return 'As senhas não correspondem';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _imageUrlController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Insira a URL da sua foto (opcional)",
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(50.0), // Adjust the radius as needed
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _empresaIdController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Código da empresa (opcional)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child:
              Text(_msgErro, style: TextStyle(color: Colors.red, fontSize: 16)),
        )
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Column(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(Size(380, 50)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
          ),
          onPressed: _createAccount,
          child: Text('Cadastrar', style: TextStyle(fontSize: 16)),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
          child: const Text(
            "Já possuo uma conta",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF0000EE),
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
