// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taishoapp/apis/estoque_api.dart';
import 'package:taishoapp/blocs/marca_bloc.dart';
import 'package:taishoapp/entidades/marca.dart';
import 'package:taishoapp/services/alerta.dart';
import 'package:taishoapp/services/scancodemob.dart';
import 'package:taishoapp/services/simnao.dart';
import 'package:taishoapp/widget/appbar_widget.dart';
import 'package:taishoapp/widget/button_widget.dart';
import 'package:taishoapp/widget/formfield_widget.dart';
import 'package:taishoapp/widget/selempresa_widget.dart';

class SaidasPage extends StatefulWidget {
  const SaidasPage({Key? key}) : super(key: key);

  @override
  SaidasPageState createState() => SaidasPageState();
}

class SaidasPageState extends State<SaidasPage> {
  final _bloc = MarcaBloc();

  late SharedPreferences _prefs;
  late bool isVisible;
  String? selectedEmpresaId;
  String? selectedDepositoId;
  String? produtoId;
  String? undId;
  String? codigodebarras;

  final _ctrlCodBa = TextEditingController();
  final _ctrlSaldo = TextEditingController();
  final _ctrlProdu = TextEditingController();
  final _ctrlUndPr = TextEditingController();
  final _ctrlMarca = TextEditingController();
  final _ctrlUndMa = TextEditingController();
  final _ctrlFator = TextEditingController();
  final _ctrlQuant = TextEditingController();
  final _ctrlDesti = TextEditingController();

  final _focusCodBa = FocusNode();
  final _focusQuant = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isVisible = true;
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    selectedEmpresaId = _prefs.getString('empresaId');
    selectedDepositoId = _prefs.getString('depositoId');
  }

  @override
  void dispose() {
    _bloc.dispose();
    _ctrlCodBa.dispose();
    _ctrlSaldo.dispose();
    _ctrlProdu.dispose();
    _ctrlUndPr.dispose();
    _ctrlMarca.dispose();
    _ctrlUndMa.dispose();
    _ctrlFator.dispose();
    _ctrlQuant.dispose();
    _ctrlDesti.dispose();

    _focusCodBa.dispose();
    _focusQuant.dispose();

    super.dispose();
  }

  Future<void> _initScanCode() async {
    final codigo = await ScanCodeMob.scanCode(context);
    if (codigo != null && codigo.isNotEmpty) {
      codigodebarras = codigo;
      _ctrlCodBa.text = codigodebarras!;
      _buscaCodbar();
    } else {
      bool simnao = await showAlertDialogSimNao(
        context,
        'Encerrar',
        'Deseja encerrar as Saídas?',
      );

      if (simnao) {
        Navigator.pushNamed(context, '/principal');
      } else {
        _limpaCampos();
        _moveFocusTo(_focusCodBa);
      }
    }
  }

  _buscaCodbarDigitado() {
    codigodebarras = _ctrlCodBa.text.toString();
    _buscaCodbar();
  }

  Future<void> _buscaCodbar() async {
    if (!mounted) return;

    EasyLoading.show(status: 'Validando Código...');
    try {
      var codbar = codigodebarras ?? '';
      Marca marcaret = await EstoqueApi.getMarcaCodbar(
        selectedEmpresaId ?? '',
        selectedDepositoId ?? '',
        codbar,
      );

      if (!mounted) {
        EasyLoading.dismiss();
        return;
      }

      if (marcaret.proid != null && marcaret.proid != "-1") {
        produtoId = marcaret.proid;
        undId = marcaret.undid;
        _ctrlProdu.text = marcaret.pronome ?? '';
        _ctrlUndPr.text = marcaret.undprod ?? '';
        _ctrlMarca.text = marcaret.promarca ?? '';
        _ctrlUndMa.text = marcaret.undmarca ?? '';
        _ctrlFator.text = marcaret.fatorconv ?? '';
        _ctrlSaldo.text = marcaret.saldo ?? '';
        _moveFocusTo(_focusQuant);
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        alert(context, 'Atenção', 'Código não Cadastrado');
        _limpaCampos();
        _moveFocusTo(_focusCodBa);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _showError('Erro', 'Ocorreu um erro ao validar o código: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _gravaSaida() async {
    if (!mounted) return;

    EasyLoading.show(status: 'Gravando Saída..');
    try {
      var codbar = _ctrlCodBa.text.toString();
      var produto = produtoId.toString();
      var quantia = _ctrlQuant.text.toString();
      var destino = _ctrlDesti.text.toString();
      var unidade = undId.toString();
      var convers = _ctrlFator.text.toString();
      var empresa = selectedEmpresaId.toString();
      var deposito = selectedDepositoId.toString();
      var grava = await EstoqueApi.gravaSaida(codbar, produto, quantia, destino,
          unidade, convers, empresa, deposito);

      if (!mounted) return;

      if (grava) {
        EasyLoading.dismiss();
        bool simnao = await showAlertDialogSimNao(
          context,
          'Saída Gravada',
          'Deseja encerrar as Saídas?',
        );

        if (simnao) {
          Navigator.pushNamed(context, '/principal');
        } else {
          _limpaCampos();
          _getCodBar();
        }
      }
    } catch (e) {
      _showError('Erro', 'Ocorreu um erro ao gravar a Saída: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void _moveFocusTo(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  void _getCodBar() {
    _limpaCampos();
    _initScanCode();
  }

  void _limpaCampos() {
    _ctrlCodBa.clear();
    _ctrlSaldo.clear();
    _ctrlProdu.clear();
    _ctrlUndPr.clear();
    _ctrlMarca.clear();
    _ctrlUndMa.clear();
    _ctrlFator.clear();
    _ctrlQuant.clear();
    _ctrlDesti.clear();
    codigodebarras = '';
    produtoId = '';
    undId = '';
  }

  void _showError(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 249, 249),
      appBar: AppbarWidget(titulo: 'Saídas'),
      body: _body(),
      bottomNavigationBar: SelEmpresa(
        onDepositChange: () {
          setState(() {
            _initSharedPreferences();
          });
        },
      ),
    );
  }

  Widget _body() {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.all(5),
        child: ListView(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 240,
                  child: FormFieldWidget(
                    "Código",
                    hint: 'Código de Barras',
                    controller: _ctrlCodBa,
                    numerico: true,
                    focusNode: _focusCodBa,
                    onFieldBlur: _buscaCodbarDigitado,
                  ),
                ),
                Container(
                  width: 80,
                  height: 70,
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    onPressed: _getCodBar,
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      backgroundColor: Colors.red.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    ),
                    child: Icon(
                      Icons.view_week,
                      color: Colors.red.shade600,
                      size: 24.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FormFieldWidget(
              "Produto",
              hint: 'Produto',
              controller: _ctrlProdu,
              somenteLeitura: true,
            ),
            Row(
              children: [
                SizedBox(
                  width: 165,
                  child: FormFieldWidget(
                    "Und",
                    hint: 'Und do Produto',
                    controller: _ctrlUndPr,
                    somenteLeitura: true,
                  ),
                ),
                SizedBox(
                  width: 165,
                  child: FormFieldWidget(
                    "Saldo",
                    hint: 'Saldo Atual',
                    controller: _ctrlSaldo,
                    somenteLeitura: true,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 165,
              child: FormFieldWidget(
                "Marca",
                hint: 'Marca',
                controller: _ctrlMarca,
                somenteLeitura: true,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 165,
                  child: FormFieldWidget(
                    "Und Marca",
                    hint: 'Unidade Marca',
                    controller: _ctrlUndMa,
                    somenteLeitura: true,
                  ),
                ),
                SizedBox(
                  width: 165,
                  child: FormFieldWidget(
                    "FCV",
                    hint: 'Fator de Conversão',
                    controller: _ctrlFator,
                    somenteLeitura: true,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 165,
                  child: FormFieldWidget(
                    "Quantia",
                    hint: 'Informe a Quantia',
                    controller: _ctrlQuant,
                    numerico: true,
                    focusNode: _focusQuant,
                  ),
                ),
                SizedBox(
                  width: 165,
                  child: FormFieldWidget(
                    "Destino",
                    hint: 'Informe o Destino',
                    controller: _ctrlDesti,
                  ),
                ),
              ],
            ),
            ButtonWidget("Confirma Saída?",
                onClicked: () => _gravaSaida(),
                icone: Icons.check_circle_outline_rounded),
          ],
        ),
      ),
    );
  }
}
