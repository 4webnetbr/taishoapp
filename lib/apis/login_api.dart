import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:taishoapp/entidades/usuario.dart';
import 'package:taishoapp/main.dart';
import 'package:taishoapp/services/alerta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginApi {
  static Future<Usuario> login(String user, String password) async {
    var url = Uri.parse("https://intranet.taisho.com.br/Auth/login");

    var header = {"Content-Type": "application/json"};

    Map params = {"username": user, "password": password};
    Usuario usuario = Usuario.nulo();

    var xbody = json.encode(params);

    log("json enviado : $xbody");

    try {
      var response = await http
          .post(url, headers: header, body: xbody)
          .timeout(const Duration(seconds: 60));
      // var response = await http.post(url, headers: header, body: xbody);

      log('Response status: ${response.statusCode}');
      var mapResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        if (mapResponse['authenticated']) {
          usuario = Usuario.fromJson(mapResponse);
          var prefs = await SharedPreferences.getInstance();
          prefs.setString("tokenjwt", mapResponse["token"]);
        } else {
          usuario.token = null;
        }
      } else if (response.statusCode == 502) {
        alert(navigatorKey.currentContext!, 'Erro!!!',
            'Processo login, Tempo de Conexão excedido, o Servidor demorou mais que 60s para responder, tente novamente');
      } else {
        alert(navigatorKey.currentContext!, 'Erro!!!',
            'Processo login retornou erro ${response.statusCode.toString()}\n Entre em contato com o suporte');
      }
      return usuario;
    } on TimeoutException catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo login Tempo de Conexão excedido, tente novamente');
      return usuario;
    } on SocketException catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo login Falha de conexão, verifique sua conexão e tente novamente');
      return usuario;
    } on Error catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo login Erro Desconhecido');
      return usuario;
    }
  }
}
