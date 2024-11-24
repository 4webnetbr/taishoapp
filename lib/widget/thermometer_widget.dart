import 'package:flutter/material.dart';

class Thermometer extends StatelessWidget {
  final double min; // Valor mínimo
  final double max; // Valor máximo
  final double value; // Valor atual

  const Thermometer({
    Key? key,
    required this.min,
    required this.max,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Se o mínimo e máximo forem iguais, o termômetro deve ser branco
    if (min == max) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Termômetro com formato de pílula e preenchimento branco
          Container(
            width: 12, // Largura do termômetro
            height: 30, // Altura do termômetro
            decoration: BoxDecoration(
              color: Colors.white, // Cor branca para o termômetro
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(30), // Bordas arredondadas
            ),
          ),
        ],
      );
    }

    // Normalizar o valor para estar entre 0 e 1
    final normalizedValue = ((value - min) / (max - min)).clamp(0.0, 1.0);

    // Determinar a cor dinamicamente (gradiente com 3 etapas: vermelho, amarelo, verde)
    Color interpolatedColor;
    if (normalizedValue < 0.5) {
      // Interpolar entre vermelho e amarelo
      interpolatedColor =
          Color.lerp(Colors.red, Colors.yellow, normalizedValue * 2)!;
    } else {
      // Interpolar entre amarelo e verde
      interpolatedColor =
          Color.lerp(Colors.yellow, Colors.green, (normalizedValue - 0.5) * 2)!;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Termômetro com formato de pílula
        Container(
          width: 12, // Largura do termômetro
          height: 30, // Altura do termômetro
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(30), // Bordas arredondadas
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 12, // Largura do preenchimento total
              height: 30, // Altura do termômetro
              decoration: BoxDecoration(
                color: interpolatedColor, // Cor do preenchimento
                borderRadius:
                    BorderRadius.circular(30), // Manter bordas arredondadas
              ),
            ),
          ),
        ),
      ],
    );
  }
}
