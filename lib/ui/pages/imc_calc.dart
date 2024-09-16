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
    late double imc;
    String estadoSaude;
    //Valida o formulário
    Map<String?, double?> imcValues = FormValidator.validateForm(
        peso, altura, _alturaController, _pesoController, context);
    //Verifica valores nulos devolvidos pelo validator
    if (imcValues['peso'] == null || imcValues['altura'] == null) {
      setState(() {
        _resultadoIMC = 'Insira valores para conferir seu IMC!';
      });
      return;
    }
    //Acata valores devolvidos pelo validator
    if (imcValues['peso'] != null && imcValues['altura'] != null) {
      peso = imcValues['peso'];
      altura = imcValues['altura'];
    }
    //Verifica valores exorbitantes
    if (imcValues['peso']! < 2 ||
        imcValues['altura']! < 40 ||
        imcValues['peso']! > 600 ||
        imcValues['altura']! > 300 ||
        imcValues['altura']! == 0) {
      SnackBar snackBar = const SnackBar(
        content: Text(
          'Os valores parecem inválidos. Tente colocar seu peso em quilos e sua altura em centímetros (Ex: 70, 180).',
        ),
        duration: Duration(seconds: 4),
        elevation: 1,
        padding: EdgeInsets.all(10),
        showCloseIcon: false,
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
      // Valores inválidos acima
      //Cálculo e estado de saúde/foto abaixo
    } else {
      imc = peso! / ((altura! / 100) * (altura / 100));
      if (imc < 16) {
        estadoSaude = 'Magreza Grau III';
        _fotoCachorro =
            'https://dcdn.mitiendanube.com/stores/002/234/113/products/img_65051-74bb310bbddda32c9116764061136419-240-0.jpg';
      } else if (imc < 17) {
        estadoSaude = 'Magreza Grau II';
        _fotoCachorro =
            'https://i1.sndcdn.com/artworks-000249285635-edgnte-t500x500.jpg';
      } else if (imc < 18.5) {
        estadoSaude = 'Magreza Grau I';
        _fotoCachorro =
            'https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2023/09/05/1922043128-greyhound.jpg';
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
            'https://static.wixstatic.com/media/69f465_7c003c94721e4008a84805cb55271247~mv2.jpg/v1/fill/w_600,h_398,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/69f465_7c003c94721e4008a84805cb55271247~mv2.jpg';
      } else if (imc < 40) {
        estadoSaude = 'Obesidade Severa (grau II)';
        _fotoCachorro =
            'https://ogimg.infoglobo.com.br/in/13168881-e59-b8a/FT1086A/obie.jpg';
      } else {
        estadoSaude = 'Obesidade Muito Severa (grau III)';
        _fotoCachorro =
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQekQ4Dy1bjCvs5lLsiUg-ORFViMexSAXBWGCxfcSujoPSeyGNnLqhmCTFhyLOcQkMvqx8&usqp=CAU';
      }
      setState(() {
        //Caso o usuário escreva "1.70", ele vai ser considerado como 170
        if (_alturaController.text.substring(1, 2) == '.') {
          SnackBar snackBar = SnackBar(
            content: Text(
              'A altura foi considerada como $altura por conter ponto flutuante após uma casa (Ex: 1.7). Insira valores extensos para uma avaliação precisa (Ex: 174 ou 174.5)!',
            ),
            duration: const Duration(seconds: 2),
            elevation: 1,
            padding: const EdgeInsets.all(10),
            showCloseIcon: false,
            behavior: SnackBarBehavior.floating,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        _resultadoIMC = 'Seu IMC é: ${imc.toStringAsFixed(1)}\n$estadoSaude';
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
    ScaffoldMessenger.of(context).clearSnackBars();
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
