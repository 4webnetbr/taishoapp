// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class FieldShowWidget extends StatelessWidget {
  final String label;
  final bool obrigatorio;
  final TextEditingController controller;

  const FieldShowWidget(
    this.label, {
    this.obrigatorio = true,
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
          child: TextFormField(
            controller: controller,
            readOnly: true,
            enabled: false,
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              errorStyle: const TextStyle(color: Color.fromRGBO(255, 251, 0, 1)),
              labelText: label,
              // labelStyle: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
              enabled: false,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(0),
            ),
            validator: (String? value) {
              if (obrigatorio) {
                if (value == null || value.isEmpty) {
                  return '$label é Obrigatório!';
                }
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
