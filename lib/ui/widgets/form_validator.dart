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
      }
      return {'peso': peso, 'altura': altura};
    } else {
      return {'peso': null, 'altura': null};
    }
  }
}
