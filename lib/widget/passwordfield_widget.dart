// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class PasswordfieldWidget extends StatefulWidget {
  final String label;
  final String hint;
  final int caracteres;
  final bool obrigatorio;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;

  const PasswordfieldWidget(
    this.label, {
    Key? key,
    required this.controller,
    this.hint = '',
    this.caracteres = 10,
    this.obrigatorio = true,
    required this.validator,
  }) : super(key: key);

  @override
  _PasswordfieldWidget createState() => _PasswordfieldWidget();
}

class _PasswordfieldWidget extends State<PasswordfieldWidget> {
  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 0.0),
          child: TextFormField(
              keyboardType: TextInputType.text,
              controller: widget.controller,
              obscureText: _showPassword,
              showCursor: true,
              style: TextStyle(color: Colors.red.shade900),
              maxLength: widget.caracteres,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.red.shade900, width: 1.0),
                ),
                // Borda quando o campo está ativo (focado)
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.red.shade900, width: 2.0),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  child: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                    color: const Color.fromRGBO(224, 2, 2, 1),
                  ),
                ),
                labelText: widget.label,
                labelStyle: TextStyle(color: Colors.red),
                hintText: widget.hint,
                hintStyle: TextStyle(
                    color: Colors.red.shade200,
                    fontSize: 10,
                    fontStyle: FontStyle.italic),
                helperStyle: TextStyle(
                    color: Colors.red.shade300,
                    fontSize: 10,
                    fontStyle: FontStyle.italic),
              ),
              validator: widget.validator),
        )
      ],
    );
  }
}
