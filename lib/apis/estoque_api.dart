import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:taishoapp/entidades/fornecedor.dart';
import 'package:taishoapp/entidades/marca.dart';
import 'package:taishoapp/entidades/produto.dart';
import 'package:taishoapp/main.dart';
import 'package:taishoapp/services/alerta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class EstoqueApi {
  static Future<List<Produto>> getSaldos(
      String empresa, String deposito) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("msgerro", '');

    var url = Uri.parse("https://intranet.taisho.com.br/ApiEstoque/getsaldo");

    List<Produto> lstProdutos = <Produto>[];

    var uuid = const Uuid().v4(); // Gera um UUID

    Map params = {'uuid': uuid, "empresa": empresa, "deposito": deposito};

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

      log('Saldo Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var listaResponse = json.decode(response.body);

        for (var mmap in listaResponse) {
          Produto prod = Produto.fromJson(mmap);
          lstProdutos.add(prod);
        }
        return lstProdutos;
      } else if (response.statusCode == 502) {
        alert(navigatorKey.currentContext!, 'Erro!!!',
            'Processo Saldo, Tempo de Conexão excedido, o Servidor demorou mais que 60s para responder, tente novamente');
      } else {
        alert(navigatorKey.currentContext!, 'Erro!!!',
            'Processo Saldo retornou erro ${response.statusCode.toString()}\n Entre em contato com o suporte');
      }
      return lstProdutos;
    } on TimeoutException catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo Saldo Tempo de Conexão excedido, tente novamente');
      return lstProdutos;
    } on SocketException catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo Saldo Falha de conexão, verifique sua conexão e tente novamente');
      return lstProdutos;
    } on Error catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo Saldo Erro Desconhecido');
      return lstProdutos;
    }
  }

  static Future<bool> gravaSaida(codbar, produto, quantia, destino, unidade,
      convers, empresa, deposito) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("msgerro", '');

    var url = Uri.parse("https://intranet.taisho.com.br/ApiEstoque/gravasaida");

    var uuid = const Uuid().v4(); // Gera um UUID

    Map params = {
      'uuid': uuid,
      "empresa": empresa,
      "deposito": deposito,
      "codbar": codbar,
      "produto": produto,
      "quantia": quantia,
      "destino": destino,
      "unidade": unidade,
      "convers": convers
    };

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

    bool retorno = false;

    try {
      var response = await http
          .post(url, headers: header, body: xbody)
          .timeout(const Duration(seconds: 60));

      log('gravaSaida Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        retorno = true;
      } else if (response.statusCode == 502) {
        alert(navigatorKey.currentContext!, 'Erro!!!',
            'Processo getMarcaCodbar, Tempo de Conexão excedido, o Servidor demorou mais que 60s para responder, tente novamente');
      } else {
        alert(navigatorKey.currentContext!, 'Erro!!!',
            'Processo getMarcaCodbar retornou erro ${response.statusCode.toString()}\n Entre em contato com o suporte');
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo getMarcaCodbar Tempo de Conexão excedido, tente novamente');
    } on SocketException catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo getMarcaCodbar Falha de conexão, verifique sua conexão e tente novamente');
    } on Error catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo getMarcaCodbar Erro Desconhecido');
    }
    return retorno;
  }

  static Future<Marca> getMarcaCodbar(
      String empresa, String deposito, String codbar) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("msgerro", '');

    var url =
        Uri.parse("https://intranet.taisho.com.br/ApiEstoque/getmarcacodbar");

    Marca marcacod = Marca.nulo();

    var uuid = const Uuid().v4(); // Gera um UUID

    Map params = {
      'uuid': uuid,
      "empresa": empresa,
      "deposito": deposito,
      "codbar": codbar
    };

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

      log('getMarcaCodbar Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var mapResponse = json.decode(response.body);
        for (var mmap in mapResponse) {
          marcacod = Marca.fromJson(mmap);
        }
      } else if (response.statusCode == 502) {
        alert(navigatorKey.currentContext!, 'Erro!!!',
            'Processo getMarcaCodbar, Tempo de Conexão excedido, o Servidor demorou mais que 60s para responder, tente novamente');
      } else {
        alert(navigatorKey.currentContext!, 'Erro!!!',
            'Processo getMarcaCodbar retornou erro ${response.statusCode.toString()}\n Entre em contato com o suporte');
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo getMarcaCodbar Tempo de Conexão excedido, tente novamente');
    } on SocketException catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo getMarcaCodbar Falha de conexão, verifique sua conexão e tente novamente');
    } on Error catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo getMarcaCodbar Erro Desconhecido');
    }
    return marcacod;
  }

  static Future<List<Fornecedor>> getFornecedor() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("msgerro", '');

    var url =
        Uri.parse("https://intranet.taisho.com.br/ApiEstoque/getfornecedor");

    List<Fornecedor> lstFornecedor = <Fornecedor>[];

    var uuid = const Uuid().v4(); // Gera um UUID

    Map params = {
      'uuid': uuid,
    };

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

      log('Saldo Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var listaResponse = json.decode(response.body);

        for (var mmap in listaResponse) {
          Fornecedor forn = Fornecedor.fromJson(mmap);
          lstFornecedor.add(forn);
        }
        return lstFornecedor;
      } else if (response.statusCode == 502) {
        alert(navigatorKey.currentContext!, 'Erro!!!',
            'Processo Saldo, Tempo de Conexão excedido, o Servidor demorou mais que 60s para responder, tente novamente');
      } else {
        alert(navigatorKey.currentContext!, 'Erro!!!',
            'Processo Saldo retornou erro ${response.statusCode.toString()}\n Entre em contato com o suporte');
      }
      return lstFornecedor;
    } on TimeoutException catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo Saldo Tempo de Conexão excedido, tente novamente');
      return lstFornecedor;
    } on SocketException catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo Saldo Falha de conexão, verifique sua conexão e tente novamente');
      return lstFornecedor;
    } on Error catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo Saldo Erro Desconhecido');
      return lstFornecedor;
    }
  }

  static Future<bool> gravaEntrada(codbar, produto, quantia, preco, total,
      unidade, convers, empresa, deposito, fornecedor) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("msgerro", '');

    var url =
        Uri.parse("https://intranet.taisho.com.br/ApiEstoque/gravaentrada");

    var uuid = const Uuid().v4(); // Gera um UUID

    Map params = {
      'uuid': uuid,
      "empresa": empresa,
      "deposito": deposito,
      "codbar": codbar,
      "produto": produto,
      "quantia": quantia,
      "preco": preco,
      "total": total,
      "unidade": unidade,
      "convers": convers,
      "fornecedor": fornecedor
    };

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

    bool retorno = false;

    try {
      var response = await http
          .post(url, headers: header, body: xbody)
          .timeout(const Duration(seconds: 60));

      log('gravaEntrada Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        retorno = true;
      } else if (response.statusCode == 502) {
        alert(navigatorKey.currentContext!, 'Erro!!!',
            'Processo gravaEntrada, Tempo de Conexão excedido, o Servidor demorou mais que 60s para responder, tente novamente');
      } else {
        alert(navigatorKey.currentContext!, 'Erro!!!',
            'Processo gravaEntrada retornou erro ${response.statusCode.toString()}\n Entre em contato com o suporte');
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo gravaEntrada Tempo de Conexão excedido, tente novamente');
    } on SocketException catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo gravaEntrada Falha de conexão, verifique sua conexão e tente novamente');
    } on Error catch (e) {
      log(e.toString());
      alert(navigatorKey.currentContext!, 'Erro!!!',
          'Processo gravaEntrada Erro Desconhecido');
    }
    return retorno;
  }
}
