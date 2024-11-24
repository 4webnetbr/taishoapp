import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';
import 'package:taishoapp/services/alerta.dart';

class ScanCodeMob {
  static Future<String?> scanCode(BuildContext context) async {
    String? barcode = await _startScanner(context);
    return barcode;
  }

  static Future<void> scanCodeMulti(
      BuildContext context, int paramPage, int rota) async {
    List<String> codebars = await _startMultiScanner(context);
    if (codebars.isNotEmpty) {
    } else {
      alert(context, 'Nenhum Código Lido',
          'Não foram lidos códigos. Tente novamente.');
    }
  }

  static Future<String?> scanEntrega(BuildContext context) async {
    String? barcode = await _startScanner(context);
    if (barcode != null && context.mounted) {
      String ini = barcode.substring(0, 1);
      if (ini == "9") {
        barcode = barcode.substring(1);
      }
      if (barcode != '-1' &&
          int.parse(barcode) < 1000000 &&
          int.parse(barcode) >= 100000) {
        return barcode;
      } else {
        await alert(context, 'Erro de Leitura',
            'ERRO DE LEITURA DO SCANNER \n Código lido $barcode');
        return '';
      }
    }
    return null;
  }

  static Future<String> compararCodebar(BuildContext context,
      [int caixa = 0]) async {
    String? barcode = await _startScanner(context);
    if (barcode != null && context.mounted) {
      String ini = barcode.substring(0, 1);
      if (ini == "9") {
        barcode = barcode.substring(1);
      }
      if (barcode != '-1') {
        return caixa == int.parse(barcode) ? barcode : '0';
      }
    }
    return '';
  }

  static Future<String> compararCodebarMulti(BuildContext context) async {
    List<String> codebars = await _startMultiScanner(context);

    if (codebars.isNotEmpty) {
      String caixas = codebars.join(', ');
      return caixas;
    }
    return '';
  }

  static Future<String?> scaneiaCod(BuildContext context) async {
    return await _startScanner(context);
  }

  static Future<List<String>> _startMultiScanner(BuildContext context) async {
    List<String> codebars = [];

    return await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(1),
              content: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 500, // Largura da janela de leitura
                    height: 300, // Altura da janela de leitura
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white,
                          width: 2), // Opcional: borda para visualizar a janela
                    ),
                    child: ClipRect(
                      child: MobileScanner(
                        onDetect: (capture) async {
                          String barcode =
                              capture.barcodes[0].displayValue.toString();
                          String ini = barcode.substring(0, 1);
                          if (ini == "9") {
                            barcode = barcode.substring(1);
                          }

                          if (barcode != '-1' &&
                              int.parse(barcode) < 1000000 &&
                              int.parse(barcode) >= 100000) {
                            if (!codebars.contains(barcode)) {
                              setState(() {
                                codebars.add(barcode);
                              });
                              await Vibration.vibrate(duration: 500);
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Parar'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(2, 2),
                          ),
                        ],
                        border: Border.all(
                            color: Colors.white,
                            width:
                                1), // Opcional: borda para visualizar a janela
                      ),
                      child: Text('  ${codebars.length} lidos  '),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) => codebars);
  }

  static Future<String?> _startScanner(context) async {
    String? barcode;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(1),
          content: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 500, // Largura da janela de leitura
                height: 300, // Altura da janela de leitura
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white, width: 2), // Borda opcional
                ),
                child: ClipRect(
                  child: MobileScanner(
                    onDetect: (capture) async {
                      if (capture.barcodes.isNotEmpty) {
                        barcode = capture.barcodes[0].displayValue;

                        // Vibra por 500 milissegundos
                        await Vibration.vibrate(duration: 300);

                        // Fecha o diálogo após a leitura
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    // Retorna o código escaneado
    return barcode;
  }
}
