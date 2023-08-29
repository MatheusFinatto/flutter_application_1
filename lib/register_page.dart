import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/Input.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Bem vindo, user.name!')),
      body: Container(
        padding: const EdgeInsets.all(32),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.only(top: 100),
          child: Column(children: [
            Column(
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
            ),
            SizedBox(height: 30),
            Column(children: [
              Input(placeholder: "Informe seu nome completo"),
              Input(placeholder: "Informe seu email"),
              Input(placeholder: "Informe seu CPF"),
              Input(placeholder: "Crie uma senha"),
              Input(placeholder: "Digite novamente sua senha"),
            ]),
            SizedBox(height: 70),
            Column(children: [
              RegisterButton(),
              SizedBox(height: 20),
              Text(
                "Já possuo uma conta",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Color(0xFF0000EE),
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.underline,
                ),
              )
            ]),
          ]),
        ),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(Size(380, 50)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        ); // Navigate to HomePage
      },
      child: Text('Register', style: TextStyle(fontSize: 16)),
    );
  }
}
