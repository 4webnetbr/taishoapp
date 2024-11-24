// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class FormFieldWidget extends StatelessWidget {
  final String label;
  final String hint;
  final String htexto;
  final int caracteres;
  final bool senha;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator; // Agora é opcional
  final bool numerico;
  final bool decimal;
  final bool isdata;
  final bool somenteLeitura; // Novo parâmetro
  final VoidCallback? onFieldEntered; // Novo parâmetro: função opcional
  final VoidCallback? onFieldBlur; // Novo parâmetro: função opcional
  final FocusNode? focusNode; // Novo parâmetro: função opcional
  var keyboard = TextInputType.text;
  var formatText = <TextInputFormatter>[];

  // Adicionando valores padrões aos parâmetros
  FormFieldWidget(
    this.label, {
    Key? key,
    required this.controller,
    this.hint = '',
    this.htexto = '',
    this.caracteres = 30,
    this.senha = false,
    this.numerico = false,
    this.decimal = false,
    this.isdata = false,
    this.somenteLeitura = false, // Default: false
    this.validator, // Agora é opcional
    this.onFieldEntered, // Função opcional
    this.onFieldBlur, // Função opcional
    this.focusNode, // Função opcional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (numerico || isdata) {
      keyboard = TextInputType.number;
      formatText = <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ];
    }
    if (decimal) {
      keyboard = TextInputType.numberWithOptions(decimal: true);
    }

    // Lógica para campo de data
    if (isdata) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: TextFormField(
              keyboardType: keyboard,
              inputFormatters: formatText,
              textInputAction: TextInputAction.next,
              controller: controller,
              validator: validator,
              autofocus: true,
              focusNode: focusNode,
              style: TextStyle(color: Colors.red),
              showCursor: true,
              maxLength: caracteres,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20, 1, 10, 1),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide:
                      BorderSide(color: Colors.red.shade200, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide:
                      BorderSide(color: Colors.red.shade600, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide:
                      BorderSide(color: Colors.red.shade900, width: 2.0),
                ),
                labelText: label,
                hintText: hint,
                helperText: htexto,
                labelStyle: TextStyle(color: Colors.red),
                hintStyle: TextStyle(color: Colors.red.shade300),
                helperStyle: TextStyle(color: Colors.red.shade300),
                icon:
                    const Icon(Icons.calendar_today), // Ícone do campo de texto
              ),
              readOnly:
                  somenteLeitura, // Quando verdadeiro, o campo será somente leitura
              enabled: !somenteLeitura,
              onEditingComplete: !somenteLeitura
                  ? () async {
                      // Se a função onFieldEntered for fornecida, execute-a
                      onFieldBlur?.call();
                    }
                  : null,
              onTap: !somenteLeitura
                  ? () async {
                      // Se a função onFieldEntered for fornecida, execute-a
                      onFieldEntered?.call();

                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                        controller.text = formattedDate.toString();
                      }
                    }
                  : null,
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: TextFormField(
              keyboardType: keyboard,
              inputFormatters: formatText,
              controller: controller,
              validator: validator,
              focusNode: focusNode,
              autofocus: true,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.red.shade900),
              obscureText: senha,
              showCursor: true,
              maxLength: caracteres,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20, 1, 10, 1),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide:
                      BorderSide(color: Colors.red.shade200, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide:
                      BorderSide(color: Colors.red.shade600, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide:
                      BorderSide(color: Colors.red.shade900, width: 2.0),
                ),
                labelText: label,
                hintText: hint,
                helperText: htexto,
                labelStyle: TextStyle(color: Colors.red),
                hintStyle: TextStyle(
                    color: Colors.red.shade200,
                    fontSize: 10,
                    fontStyle: FontStyle.italic),
                helperStyle: TextStyle(
                    color: Colors.red.shade300,
                    fontSize: 10,
                    fontStyle: FontStyle.italic),
              ),
              readOnly:
                  somenteLeitura, // Quando verdadeiro, o campo será somente leitura
              enabled:
                  !somenteLeitura, // Quando verdadeiro, o campo será desabilitado
              onEditingComplete: () {
                // Se a função onFieldEntered for fornecida, execute-
                onFieldBlur?.call();
              },
              onTap: () {
                // Se a função onFieldEntered for fornecida, execute-a
                onFieldEntered?.call();
              },
            ),
          ),
        ],
      );
    }
  }
}
