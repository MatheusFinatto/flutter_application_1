import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/conta/register_page.dart';
import 'package:flutter_application_1/screens/home/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool state = false;
  bool desenv = false;
  bool desenv2 = false;
  bool desenv3 = false;

  String _msgErro = "";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  _validaCampos() {
    String email = '';
    String password = '';

    if (desenv) {
      email = 'desenv@email.com';
      password = '123456';
    } else if (desenv2) {
      email = 'desenv2@email.com';
      password = '123456';
    } else if (desenv3) {
      email = 'desenv3@email.com';
      password = '123456';
    } else {
      email = _emailController.text;
      password = _passwordController.text;
    }

    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty && password.length >= 6) {
        FirebaseAuth auth = FirebaseAuth.instance;
        auth.signInWithEmailAndPassword(email: email, password: password).then(
          (value) {
            // Sucesso
            _msgErro = "Sucesso ao logar";

            // Navegar para a tela inicial e remover esta página para não poder voltar
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
            );
          },
          onError: (error, stackTrace) {
            // Se houver um erro
            _msgErro = 'Usuário ou senha incorretos';
          },
        );
      } else {
        setState(() {
          _msgErro = 'Usuario ou senha incorreto';
        });
      }
    } else {
      setState(() {
        _msgErro = 'Usuario ou senha incorreto';
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
          "Faça o seu login",
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
          onPressed: _validaCampos,
          child: Text('Entrar', style: TextStyle(fontSize: 16)),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RegisterPage(),
              ),
            );
            //Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text(
            "Não possuo uma conta",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF0000EE),
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        SizedBox(height: 120),
        ElevatedButton(
          onPressed: () {
            desenv = true;
            _validaCampos();
          },
          child: Text(
            "Login como Ednaldo Pereira",
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            desenv2 = true;
            _validaCampos();
          },
          child: Text(
            "Login como Vin Diesel Brasileiro",
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            desenv3 = true;
            _validaCampos();
          },
          child: Text(
            "Login como Michael Scott",
          ),
        ),
      ],
    );
  }
}
