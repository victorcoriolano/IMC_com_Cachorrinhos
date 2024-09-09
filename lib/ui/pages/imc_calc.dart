import 'package:flutter/material.dart';
import 'package:imc_calc/ui/widgets/custom_input_field.dart';
import 'package:imc_calc/ui/widgets/image.dart';
import 'package:imc_calc/ui/widgets/imc_container.dart';
import 'package:imc_calc/ui/widgets/keypad.dart';

class IMCCalculator extends StatefulWidget {
  const IMCCalculator({super.key});

  @override
  State<IMCCalculator> createState() => _IMCCalculatorState();
}

class _IMCCalculatorState extends State<IMCCalculator> {
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  late FocusNode _pesoFocusNode;
  late FocusNode _alturaFocusNode;
  String _resultadoIMC = 'Seu IMC irá aparecer aqui!';
  String _campoSelecionado = 'peso';
  String _fotoCachorro =
      'https://media.istockphoto.com/id/803485968/pt/foto/fat-beagle.jpg?s=612x612&w=0&k=20&c=FIC4cUwk_wjVoozRdWAOswhJqixIWoGNxvICAtJQqbk=';

  @override
  void initState() {
    super.initState();
    _pesoFocusNode = FocusNode();
    _alturaFocusNode = FocusNode();

    _pesoFocusNode.addListener(() {
      if (_pesoFocusNode.hasFocus) {
        setState(() {
          _campoSelecionado = 'peso';
        });
      }
    });

    _alturaFocusNode.addListener(() {
      if (_alturaFocusNode.hasFocus) {
        setState(() {
          _campoSelecionado = 'altura';
        });
      }
    });
  }

  @override
  void dispose() {
    _pesoController.dispose();
    _alturaController.dispose();
    _pesoFocusNode.dispose();
    _alturaFocusNode.dispose();
    super.dispose();
  }

  void _calcularIMC() {
    final double? peso = double.tryParse(_pesoController.text);
    late double? altura = double.tryParse(_alturaController.text);

    if (peso != null && altura != null && altura > 0 && peso > 0) {
      if (_alturaController.text.substring(1, 2) == '.') {
        altura *= 100;
      }
      final double imc = peso / ((altura / 100) * (altura / 100));
      String estadoSaude;

      if (imc < 18.5) {
        estadoSaude = 'Abaixo do peso';
        _fotoCachorro =
            'https://i1.sndcdn.com/artworks-000249285635-edgnte-t500x500.jpg';
      } else if (imc < 25) {
        estadoSaude = 'Saudável';
        _fotoCachorro =
            'https://t1.uc.ltmcdn.com/pt/posts/7/0/1/por_que_os_cachorros_gostam_de_carinho_na_barriga_25107_600.jpg';
      } else if (imc < 30) {
        estadoSaude = 'Sobrepeso';
        _fotoCachorro =
            'https://media.istockphoto.com/id/803485968/pt/foto/fat-beagle.jpg?s=612x612&w=0&k=20&c=FIC4cUwk_wjVoozRdWAOswhJqixIWoGNxvICAtJQqbk=';
      } else {
        estadoSaude = 'Obesidade';
        _fotoCachorro =
            'https://ogimg.infoglobo.com.br/in/13168881-e59-b8a/FT1086A/obie.jpg';
      }

      setState(() {
        _resultadoIMC = 'Seu IMC é: ${imc.toStringAsFixed(1)}\n$estadoSaude';
      });
    } else {
      setState(() {
        _resultadoIMC = 'Insira valores para conferir seu IMC!';
      });
    }
  }

  void _insertText(String text) {
    setState(() {
      if (_campoSelecionado == 'peso') {
        _pesoController.text += text;
      } else if (_campoSelecionado == 'altura') {
        _alturaController.text += text;
      }
    });
    _calcularIMC();
  }

  void _deleteText() {
    setState(() {
      if (_campoSelecionado == 'peso' && _pesoController.text.isNotEmpty) {
        _pesoController.text =
            _pesoController.text.substring(0, _pesoController.text.length - 1);
      } else if (_campoSelecionado == 'altura' &&
          _alturaController.text.isNotEmpty) {
        _alturaController.text = _alturaController.text
            .substring(0, _alturaController.text.length - 1);
      }
    });
    _calcularIMC();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Flex(
              direction: Axis.vertical,
              children: [
                const Text(
                  'Calculadora IMC',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'De acordo com sua saúde',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                DogImage(url: _fotoCachorro),
                const SizedBox(height: 20),
                CustomInputField(
                  label: 'Peso:',
                  controller: _pesoController,
                  focusNode: _pesoFocusNode,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Altura:',
                  controller: _alturaController,
                  focusNode: _alturaFocusNode,
                ),
                const SizedBox(height: 20),
                ImcContainer(result: _resultadoIMC),
                const SizedBox(height: 20),
                Keypad(onKeyPressed: _insertText, onDeletePressed: _deleteText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
