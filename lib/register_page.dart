import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 100, 10, 50),
            child: Column(
              children: [
                _buildHeaderText(),
                const SizedBox(height: 30),
                _buildInputs(),
                const SizedBox(height: 70),
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
        const SizedBox(height: 2),
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
          padding: const EdgeInsets.all(8.0),
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
          padding: const EdgeInsets.all(8.0),
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
          padding: const EdgeInsets.all(8.0),
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
          padding: const EdgeInsets.all(8.0),
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
          padding: const EdgeInsets.all(8.0),
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
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Column(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(const Size(380, 50)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
          ),
          onPressed: _onRegisterPressed,
          child: const Text('Cadastrar', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 20),
        Text(
          "Já possuo uma conta",
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF0000EE),
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }

  void _onRegisterPressed() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform registration
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }
}
