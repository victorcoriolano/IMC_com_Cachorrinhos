import 'package:flutter/material.dart';

class FormValidator {
  static Map<String?, double?> validateForm(
      double? peso,
      double? altura,
      TextEditingController alturaController,
      TextEditingController pesoController,
      BuildContext context) {
    if (peso != null && altura != null && altura > 0 && peso > 0) {
      if (alturaController.text.substring(1, 2) == '.') {
        altura *= 100;
        SnackBar snackBar = SnackBar(
          content: Text(
            'A altura foi considerada como $altura por conter ponto flutuante após uma casa (Ex: 1.7). Insira valores extensos para uma avaliação precisa (Ex: 174 ou 174.5)!',
          ),
          duration: const Duration(seconds: 7),
          elevation: 1,
          padding: const EdgeInsets.all(10),
          showCloseIcon: false,
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      if (peso < 2.5 && altura < 40) {
        SnackBar snackBar = const SnackBar(
          content: Text(
            'O IMC foi calculado, mas os valores parecem inválidos. Tente colocar seu peso em quilos e sua altura em centímetros (Ex: 70, 180).',
          ),
          duration: Duration(seconds: 7),
          elevation: 1,
          padding: EdgeInsets.all(10),
          showCloseIcon: false,
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return {'peso': null, 'altura': null};
      } else {
        return {'peso': peso, 'altura': altura};
      }
    } else {
      return {'peso': null, 'altura': null};
    }
  }
}
