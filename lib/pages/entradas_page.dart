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

class EntradasPage extends StatefulWidget {
  const EntradasPage({Key? key}) : super(key: key);

  @override
  EntradasPageState createState() => EntradasPageState();
}

class EntradasPageState extends State<EntradasPage> {
  final _bloc = MarcaBloc();

  late SharedPreferences _prefs;
  late bool isVisible;
  String? selectedEmpresaId;
  String? selectedDepositoId;
  String? produtoId;
  String? undId;
  String? codigodebarras;
  String? selectedFornecedorId;

  double preco = 0.0;
  double total = 0.0;

  final _ctrlCodBa = TextEditingController();
  final _ctrlSaldo = TextEditingController();
  final _ctrlProdu = TextEditingController();
  final _ctrlUndPr = TextEditingController();
  final _ctrlMarca = TextEditingController();
  final _ctrlUndMa = TextEditingController();
  final _ctrlFator = TextEditingController();
  final _ctrlQuant = TextEditingController();
  final _ctrlPreco = TextEditingController();
  final _ctrlTotal = TextEditingController();

  final _focusCodBa = FocusNode();
  final _focusQuant = FocusNode();

  final _formKey = GlobalKey<FormState>();

  // Lista de fornecedores
  List<dynamic> fornecedores = [];

  @override
  void initState() {
    super.initState();
    isVisible = true;
    _initSharedPreferences();
    _loadFornecedores(); // Carregar fornecedores na inicialização
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    selectedEmpresaId = _prefs.getString('empresaId');
    selectedDepositoId = _prefs.getString('depositoId');
  }

  Future<void> _loadFornecedores() async {
    try {
      var fornecedoresData = await EstoqueApi.getFornecedor();
      if (fornecedoresData.isNotEmpty) {
        setState(() {
          fornecedores = fornecedoresData;
        });
      }
    } catch (e) {
      _showError('Erro', 'Falha ao carregar fornecedores: $e');
    }
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
    _ctrlPreco.dispose();
    _ctrlTotal.dispose();

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
        'Deseja encerrar as Entradas?',
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

      if (!mounted) return;

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
      } else {
        EasyLoading.dismiss();
        alert(context, 'Atenção', 'Código não Cadastrado');
        _limpaCampos();
        _moveFocusTo(_focusCodBa);
      }
    } catch (e) {
      _showError('Erro', 'Ocorreu um erro ao validar o código: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _gravaEntrada() async {
    if (!mounted) return;

    EasyLoading.show(status: 'Gravando Entrada...');
    try {
      var codbar = _ctrlCodBa.text.toString();
      var produto = produtoId.toString();
      var quantia = _ctrlQuant.text.toString();
      var preco = _ctrlPreco.text.toString();
      var total = _ctrlTotal.text.toString();
      var unidade = undId.toString();
      var convers = _ctrlFator.text.toString();
      var empresa = selectedEmpresaId.toString();
      var deposito = selectedDepositoId.toString();
      var fornecedor = selectedFornecedorId.toString();

      var grava = await EstoqueApi.gravaEntrada(codbar, produto, quantia, preco,
          total, unidade, convers, empresa, deposito, fornecedor);

      if (!mounted) return;

      if (grava) {
        EasyLoading.dismiss();
        bool simnao = await showAlertDialogSimNao(
          context,
          'Entrada Gravada',
          'Deseja encerrar as Entradas?',
        );

        if (simnao) {
          Navigator.pushNamed(context, '/principal');
        } else {
          _limpaCampos();
          _getCodBar();
        }
      }
    } catch (e) {
      _showError('Erro', 'Ocorreu um erro ao gravar a Entrada: $e');
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
    _ctrlPreco.clear();
    _ctrlTotal.clear();
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

  void _calcularTotal() {
    final quantia = double.tryParse(_ctrlQuant.text) ?? 0.0;
    final preco = double.tryParse(
            _ctrlPreco.text.replaceAll('R\$', '').replaceAll(',', '.')) ??
        0.0;
    setState(() {
      total = quantia * preco;
      _ctrlTotal.text = 'R\$ ${total.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 249, 249),
      appBar: AppbarWidget(titulo: 'Entradas'),
      body: _body(),
      bottomNavigationBar: SelEmpresa(
        onDepositChange: () {
          setState(() {
            _initSharedPreferences();
            // Recarrega a tela ativa
          });
        },
      ),
    );
  }

  _body() {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(15),
        child: ListView(
          children: [
            // Dropdown para fornecedores
            SizedBox(
              height: 48,
              width: MediaQuery.of(context).size.width,
              child: fornecedores.isEmpty
                  ? const CircularProgressIndicator() // Enquanto a lista carrega
                  : _buildDropdown(
                      value: selectedFornecedorId,
                      items: fornecedores.map((fornecedor) {
                        return DropdownMenuItem<String>(
                          value: fornecedor.forid.toString(),
                          alignment: Alignment.centerLeft,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 40,
                            width: MediaQuery.of(context).size.width - 20,
                            padding: const EdgeInsets.fromLTRB(15, 1, 10, 1),
                            decoration: BoxDecoration(
                              color: (selectedFornecedorId ==
                                      fornecedor.forid.toString())
                                  ? Colors
                                      .red // Fundo vermelho quando selecionado
                                  : Colors
                                      .white, // Fundo branco quando não selecionado
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Text(
                              fornecedor.fornome,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                color: (selectedFornecedorId ==
                                        fornecedor.forid.toString())
                                    ? Colors
                                        .white // Texto branco quando selecionado
                                    : Colors
                                        .red, // Texto vermelho quando não selecionado
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      hint: "Selecione Fornecedor",
                      onChanged: (newFornecedorId) {
                        setState(() {
                          selectedFornecedorId = newFornecedorId;
                        });
                      },
                    ),
            ),
            SizedBox(height: 15),
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
                    onFieldBlur: _calcularTotal,
                  ),
                ),
                SizedBox(
                  width: 165,
                  child: FormFieldWidget(
                    'Preço (R\$)',
                    controller: _ctrlPreco,
                    decimal: true,
                    onFieldBlur: _calcularTotal,
                  ),
                ),
              ],
            ),
            FormFieldWidget(
              'Total',
              controller: _ctrlTotal,
              somenteLeitura: true,
            ),
            ButtonWidget("Confirma Entrada?",
                onClicked: () => _gravaEntrada(),
                icone: Icons.check_circle_outline_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      margin: EdgeInsets.fromLTRB(15, 0, 15, 5),
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white, // Cor do fundo do botão fechado
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.red), // Borda vermelha
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        items: items,
        onChanged: onChanged,
        underline: const Divider(color: Colors.transparent),
        hint: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.fromLTRB(15, 1, 10, 1),
          child: Text(
            hint,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.red, fontSize: 10), // Cor do texto do hint
          ),
        ),
      ),
    );
  }
}
