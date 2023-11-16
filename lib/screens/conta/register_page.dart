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

  _createAccount() {
    String email = _emailController.text;
    String password = _passwordController.text;
    String nome = _nameController.text;
    String cpf = _cpfController.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty && password.length >= 6) {
        if (cpf.length >= 11) {
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
                SizedBox(height: 70),
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
          padding: EdgeInsets.only(top: 12.0),
          child: Text(_msgErro),
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
            //Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text(
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

  // void _onRegisterPressed() {
  //   if (_formKey.currentState!.validate()) {
  //     // Form is valid, perform registration
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) =>  HomePage(),
  //       ),
  //     );
  //   }
  // }
}
