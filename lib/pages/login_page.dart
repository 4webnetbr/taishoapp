import 'dart:async';
import 'package:taishoapp/blocs/login_bloc.dart';
import 'package:taishoapp/entidades/usuario.dart';
import 'package:taishoapp/services/alerta.dart';
import 'package:taishoapp/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taishoapp/widget/formfield_widget.dart';
import 'package:taishoapp/widget/passwordfield_widget.dart';

class LoginPage extends StatelessWidget {
  final _ctrlLogin = TextEditingController();
  final _ctrlSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _bloc = LoginBloc();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Center(child: CircularProgressIndicator());

    _verLogin(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Identificação",
          style: TextStyle(fontSize: 16, color: Colors.white),
          textAlign: TextAlign.start,
        ),
        centerTitle: true,
      ),
      body: _body(context),
    );
  }

  _verLogin(context) async {
    final Future<SharedPreferences> saves = SharedPreferences.getInstance();
    final SharedPreferences saveLogin = await saves;
    var savelog = saveLogin.getString("login") ?? "";
    var savesen = saveLogin.getString("senha") ?? "";
    saveLogin.setString('rotaatual', '');

    if (savelog.toString() != '') {
      _ctrlLogin.text = savelog.toString();
      _ctrlSenha.text = savesen.toString();
      _clickButton(context);
    }
  }

  _body(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.all(5),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 5),
            FormFieldWidget("Login",
                hint: 'Informe o seu Usuário',
                controller: _ctrlLogin,
                validator: _validaLogin),
            const SizedBox(height: 5),
            PasswordfieldWidget("Senha",
                hint: 'Informe sua Senha',
                controller: _ctrlSenha,
                validator: _validaSenha),
            const SizedBox(height: 10),
            ButtonWidget("Acessar",
                onClicked: () => _clickButton(context),
                icone: Icons.login_rounded),
            SizedBox(
              height: 180.0,
              child: Image.asset("imagens/logotaisho.png", fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _textFormField(
  //   String label,
  //   String hint, {
  //   bool senha = false,
  //   required TextEditingController controller,
  //   required FormFieldValidator<String> validator,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: StatefulBuilder(
  //       builder: (context, setState) {
  //         bool obscureText = senha;

  //         return TextFormField(
  //           controller: controller,
  //           validator: validator,
  //           autocorrect: false,
  //           obscureText: obscureText,
  //           decoration: InputDecoration(
  //             labelText: label,
  //             contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
  //             hintText: hint,
  //             border:
  //                 OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
  //             suffixIcon: senha
  //                 ? IconButton(
  //                     icon: Icon(
  //                       obscureText ? Icons.visibility : Icons.visibility_off,
  //                     ),
  //                     onPressed: () {
  //                       setState(() {
  //                         obscureText = !obscureText;
  //                       });
  //                     },
  //                   )
  //                 : null,
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  String _validaLogin(texto) {
    if (texto.isEmpty) {
      return "Digite o Login";
    } else if (texto.length < 3) {
      return "O campo precisa ter mais de 3 caracteres";
    } else {
      return '';
    }
  }

  String _validaSenha(texto) {
    if (texto.isEmpty) {
      return "Digite a Senha";
    } else {
      return '';
    }
  }

  _clickButton(BuildContext context) async {
    EasyLoading.show(status: 'Validando Credenciais...');
    String login = _ctrlLogin.text;
    String senha = _ctrlSenha.text;

    // log("login : $login senha: $senha");

    var usuario = await _bloc.login(login, senha);

    // log("==> $usuario");
    if (usuario == Usuario.nulo()) {
      EasyLoading.dismiss();
    } else {
      if (usuario.token != null) {
        final loginsave = await SharedPreferences.getInstance();
        loginsave.setString('login', login);
        loginsave.setString('senha', senha);
        loginsave.setString('prfid', usuario.prfid.toString());
        EasyLoading.dismiss();
        Navigator.pushNamed(context, '/principal');
      } else {
        _ctrlLogin.clear();
        _ctrlSenha.clear();
        EasyLoading.dismiss();
        final loginsave = await SharedPreferences.getInstance();
        loginsave.setString('login', '');
        loginsave.setString('senha', '');
        alert(context, "Atenção", "Login Inválido");
      }
    }
  }
}
