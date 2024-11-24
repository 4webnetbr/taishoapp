import 'dart:async';
import 'package:taishoapp/blocs/saldo_bloc.dart';
import 'package:taishoapp/entidades/produto.dart';
import 'package:taishoapp/services/simnao.dart';
import 'package:taishoapp/widget/appbar_widget.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:taishoapp/widget/selempresa_widget.dart';
import 'package:taishoapp/widget/thermometer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _bloc = SaldoBloc();

  late SharedPreferences _prefs;
  late bool isVisible;
  String? selectedEmpresaId;
  String? selectedDepositoId;

  /// Carrega o BD local
  @override
  initState() {
    super.initState();
    _initSharedPreferences();
    isVisible = true;
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    selectedEmpresaId = _prefs.getString('empresaId');
    selectedDepositoId = _prefs.getString('depositoId');

    if (selectedEmpresaId != null) {
      _bloc.loadSaldos(selectedEmpresaId, selectedDepositoId);
    }

    // setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? result) async {
            final bool shouldPop = await _onBackPressed();
            if (context.mounted && shouldPop) {
              Navigator.pop(context);
            }
          },
          child: Scaffold(
            backgroundColor: Colors.red.shade200,
            appBar: AppbarWidget(titulo: 'Estoque'),
            body: _body(),
            bottomNavigationBar: SelEmpresa(
              onDepositChange: () {
                setState(() {
                  _initSharedPreferences();
                  // Recarrega a tela ativa
                });
              },
            ),
          ),
        ),
        onRefresh: () {
          return Future.delayed(const Duration(milliseconds: 100), () {
            _initSharedPreferences();
          });
        });
  }

  _body() {
    return StreamBuilder(
      stream: _bloc.produtoSaldos,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Erro ao acessar os dados"));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        List<Produto> lstProds = snapshot.data as List<Produto>;
        return _listViewSaldo(lstProds);
      },
    );
  }

  _listViewSaldo(List<Produto> lstProds) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(10),
      // margin: const EdgeInsets.only(bottom: 80.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalhos da Tabela
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                // Expanded(
                //   flex: 1,
                //   child:
                //       Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
                // ),
                Expanded(
                  flex: 4,
                  child: Text('Produto',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 1,
                  child: Text('Saldo',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 1,
                  child: Text('Und',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1),
          // Listagem dos Produtos
          Expanded(
            child: ListView.builder(
              // ignore: unnecessary_null_comparison
              itemCount: lstProds != null ? lstProds.length : 0,
              itemBuilder: (context, index) {
                Produto prod = lstProds[index];
                return Column(
                  children: [
                    Row(
                      children: [
                        // Expanded(
                        //   flex: 1,
                        //   child: Text(prod.pro_id.toString()),
                        // ),
                        Expanded(
                          flex: 4,
                          child: Text(prod.pronome.toString()),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            prod.saldo.toString(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(" ${prod.undsigla}"),
                        ),
                        Thermometer(
                            min: double.parse(prod.minimo.toString()),
                            max: double.parse(prod.maximo.toString()),
                            value: double.parse(prod.saldo.toString())),
                      ],
                    ),
                    const Divider(thickness: 0.5),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    var simnao = await showAlertDialogSimNao(
        context, 'Fazer Logoff?', 'Deseja fechar o TaishoApp');
    if (simnao) {
      // ignore: use_build_context_synchronously
      var simnao = await showAlertDialogSimNao(
          // ignore: use_build_context_synchronously
          context,
          'Fazer Logoff?',
          'Deseja limpar suas Credenciais?');
      if (simnao) {
        _limpaUser();
        SystemNavigator.pop();
      } else {
        SystemNavigator.pop();
      }
    }
    return false;
  }

  _limpaUser() async {
    final loginsave = await SharedPreferences.getInstance();
    loginsave.setString('login', '');
    loginsave.setString('senha', '');
  }
}
