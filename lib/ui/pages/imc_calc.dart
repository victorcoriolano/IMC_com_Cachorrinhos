import 'package:flutter/material.dart';
import 'package:imc_calc/ui/widgets/custom_input_field.dart';
import 'package:imc_calc/ui/widgets/form_validator.dart';
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

  Future<void> _calcularIMC() async {
    late double? peso = double.tryParse(_pesoController.text);
    late double? altura = double.tryParse(_alturaController.text);

    Map<String?, double?> imcValues = FormValidator.validateForm(
        peso, altura, _alturaController, _pesoController, context);

    if (imcValues['peso'] == null || imcValues['altura'] == null) {
      setState(() {
        _resultadoIMC = 'Insira valores para conferir seu IMC!';
      });
      return;
    }
    if (imcValues['peso'] != null && imcValues['altura'] != null) {
      if (imcValues['peso']! < 2.5 ||
          imcValues['altura']! < 40 ||
          imcValues['peso']! > 600 ||
          imcValues['altura']! > 300 ||
          imcValues['altura']! == 0) {
        SnackBar snackBar = const SnackBar(
          content: Text(
            'Os valores parecem inválidos. Tente colocar seu peso em quilos e sua altura em centímetros (Ex: 70, 180).',
          ),
          duration: Duration(seconds: 7),
          elevation: 1,
          padding: EdgeInsets.all(10),
          showCloseIcon: false,
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      peso = imcValues['peso'];
      altura = imcValues['altura'];
    }

    final double imc = peso! / ((altura! / 100) * (altura / 100));

    String estadoSaude;

    if (imc < 16) {
      estadoSaude = 'Magreza Grau II';
      _fotoCachorro =
          'https://cdn.leroymerlin.com.br/products/escultura_madeira_cachorro_baleia_em_pe_olhando_baixo_mar_1571790414_dd86_600x600.png';
    } else if (imc < 17) {
      estadoSaude = 'Magreza Grau II';
      _fotoCachorro =
          'https://i1.sndcdn.com/artworks-000249285635-edgnte-t500x500.jpg';
    } else if (imc < 18.5) {
      estadoSaude = 'Magreza Grau I';
      _fotoCachorro =
          'https://blog-static.petlove.com.br/wp-content/uploads/2020/06/galgo-petlove.jpg';
    } else if (imc < 25) {
      estadoSaude = 'Saudável';
      _fotoCachorro =
          'https://t1.uc.ltmcdn.com/pt/posts/7/0/1/por_que_os_cachorros_gostam_de_carinho_na_barriga_25107_600.jpg';
    } else if (imc < 30) {
      estadoSaude = 'Sobrepeso';
      _fotoCachorro =
          'https://media.istockphoto.com/id/803485968/pt/foto/fat-beagle.jpg?s=612x612&w=0&k=20&c=FIC4cUwk_wjVoozRdWAOswhJqixIWoGNxvICAtJQqbk=';
    } else if (imc < 35) {
      estadoSaude = 'Obesidade Moderada (grau I)';
      _fotoCachorro =
          'https://blog-static.petlove.com.br/wp-content/uploads/2024/05/10144002/cachorro-gordo-Petlove.jpg';
    } else if (imc < 40) {
      estadoSaude = 'Obesidade Severa (grau II)';
      _fotoCachorro =
          'https://ogimg.infoglobo.com.br/in/13168881-e59-b8a/FT1086A/obie.jpg';
    } else {
      estadoSaude = 'Obesidade Muito Severa (grau III)';
      _fotoCachorro =
          'https://s2.glbimg.com/wFqgUL8IGb4N_U2470KOgVaeXms=/620x465/top/s.glbimg.com/jo/g1/f/original/2016/12/16/bolinha_1700_agora.jpg';
    }
    setState(() {
      _resultadoIMC = 'Seu IMC é: ${imc.toStringAsFixed(1)}\n$estadoSaude';
    });
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
