import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:taishoapp/entidades/deposito.dart';
import 'package:taishoapp/entidades/empresa.dart';
import 'package:taishoapp/main.dart';
import 'package:taishoapp/services/alerta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ConfigApi {
  static Future<List<Empresa>> getEmpresas() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("msgerro", '');

    var url = Uri.parse("https://intranet.taisho.com.br/ApiConfig/getempresas");

    List<Empresa> lstEmpresas = <Empresa>[];

    var uuid = const Uuid().v4(); // Gera um UUID

    Map params = {'uuid': uuid};

    var token = prefs.getString("tokenjwt") ?? "";

    var xbody = json.encode(params);

    log("token : $token");
    log("params : $params");

    var header = {
      "Content-Type": "application/json",
      "Authorization": token,
      'Cache-Control': 'no-cache',
      'Pragma': 'no-cache',
    };

    try {
      var response = await http
          .post(url, headers: header, body: xbody)
          .timeout(const Duration(seconds: 60));

      log('GetEmpresas Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var listaResponse = json.decode(response.body);

        for (var mmap in listaResponse) {
          Empresa empr = Empresa.fromJson(mmap);
          lstEmpresas.add(empr);
        }
        return lstEmpresas;
      } else if (response.statusCode == 502) {
        alert(navigatorKey.currentContext!, 'Erro!!!',
            'Processo GetEmpresa, Tempo de Conexão excedido, o Servidor demorou mais que 60s para responder, tente novamente');
      } else {
        alert(navigatorKey.currentContext!, 'Erro!!!',
            'Processo GetEmpresa retornou erro ${response.statusCode.toString()}\n Entre em contato com o suporte');
      }
      return lstEmpresas;
    } on TimeoutException catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo GetEmpresa Tempo de Conexão excedido, tente novamente');
      return lstEmpresas;
    } on SocketException catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo GetEmpresa Falha de conexão, verifique sua conexão e tente novamente');
      return lstEmpresas;
    } on Error catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo GetEmpresa Erro Desconhecido');
      return lstEmpresas;
    }
  }

  static Future<List<Deposito>> getDepositos(String empresa) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("msgerro", '');

    var url =
        Uri.parse("https://intranet.taisho.com.br/ApiConfig/getdepositos");

    List<Deposito> lstDepositos = <Deposito>[];

    var uuid = const Uuid().v4(); // Gera um UUID

    Map params = {'uuid': uuid, "empresa": empresa};

    var token = prefs.getString("tokenjwt") ?? "";

    var xbody = json.encode(params);

    log("token : $token");
    log("params : $params");

    var header = {
      "Content-Type": "application/json",
      "Authorization": token,
      'Cache-Control': 'no-cache',
      'Pragma': 'no-cache',
    };

    try {
      var response = await http
          .post(url, headers: header, body: xbody)
          .timeout(const Duration(seconds: 60));

      log('getDepositos Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var listaResponse = json.decode(response.body);

        for (var mmap in listaResponse) {
          Deposito depo = Deposito.fromJson(mmap);
          lstDepositos.add(depo);
        }
        return lstDepositos;
      } else if (response.statusCode == 502) {
        alert(navigatorKey.currentContext!, 'Erro!!!',
            'Processo getDepositos, Tempo de Conexão excedido, o Servidor demorou mais que 60s para responder, tente novamente');
      } else {
        alert(navigatorKey.currentContext!, 'Erro!!!',
            'Processo getDepositos retornou erro ${response.statusCode.toString()}\n Entre em contato com o suporte');
      }
      return lstDepositos;
    } on TimeoutException catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo getDepositos Tempo de Conexão excedido, tente novamente');
      return lstDepositos;
    } on SocketException catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo getDepositos Falha de conexão, verifique sua conexão e tente novamente');
      return lstDepositos;
    } on Error catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo getDepositos Erro Desconhecido');
      return lstDepositos;
    }
  }
}
