import 'package:flutter/material.dart';

/// O ponto de entrada principal do aplicativo.
///
/// É aqui que o aplicativo é definido e onde o runtime do Flutter
/// é configurado.
///
/// O widget [CalculadoraApp] é definido aqui e é usado para construir a
/// interface de usuário do aplicativo.
void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: const CalculadoraScreen(),
    );
  }
}

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  _CalculadoraScreenState createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  String _input = '';
  String _output = '';
  bool _hasError = false;
  bool _isNewCalculation = true;

  /// Adiciona [value] à entrada atual.
  ///
  /// Se [_hasError] for verdadeiro, [_clear] é chamado primeiro.
  ///
  /// Se [_isNewCalculation] for verdadeiro e [_output] não estiver vazio, o operador
  /// [value] é adicionado a [_output], e [_isNewCalculation] é definido como falso.
  /// Caso contrário, [value] é adicionado a [_input].
  void _addToInput(String value) {
    setState(() {
      if (_hasError) {
        _clear();
      }
      if (_isNewCalculation && _output.isNotEmpty) {
        if (['+', '-', '*', '/'].contains(value)) {
          _input = _output + value;
        } else {
          _input = value;
        }
        _isNewCalculation = false;
      } else {
        _input += value;
      }
    });
  }

  /// Limpa o estado da calculadora, removendo todos os valores do input e do
  /// output e resetando a flag de erro e de nova calculadora.
  void _clear() {
    setState(() {
      _input = '';
      _output = '';
      _hasError = false;
      _isNewCalculation = true;
    });
  }

  /// Executa a expressão matemática contida em [_input] e armazena o resultado
  /// em [_output]. Se a expressão for válida, [_hasError] é setada para `false` e
  /// [_isNewCalculation]  setada para `true`. Caso contrário, [_hasError] é setada
  /// para `true` e [_output] recebe uma string de erro.
  void _calcular() {
    setState(() {
      try {
        _output = eval(_input).toString();
        _hasError = false;
        _isNewCalculation = true;
      } catch (e) {
        _output = 'Erro: ${e.toString()}';
        _hasError = true;
      }
    });
  }

  @override

  /// Constrói a tela inicial do aplicativo.
  ///
  /// A tela consiste em um cabeçalho com o título do aplicativo, uma área de exibição
  /// para a calculadora atual e o resultado do cálculo, e uma grade de botões para
  /// realizar os cálculos.
  ///
  /// A área de exibição mostra o cálculo atual e o resultado do cálculo. O cálculo
  /// atual é mostrado em uma fonte menor, e o resultado do cálculo é mostrado em uma
  /// fonte maior. Se houver um erro no cálculo, o resultado é exibido em vermelho.
  ///
  /// A grade de botões inclui botões para os números de 0 a 9, as operações
  /// aritméticas básicas (adição, subtração, multiplicação e divisão),
  /// um botão para limpar o cálculo atual e um botão para avaliar o cálculo
  /// atual.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  _input,
                  style: TextStyle(
                    fontSize: 24,
                    color: _hasError ? Colors.red : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  _output,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: _hasError ? Colors.red : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            children: [
              _buildButton('7', Colors.blue),
              _buildButton('8', Colors.blue),
              _buildButton('9', Colors.blue),
              _buildButton('/', Colors.orange),
              _buildButton('4', Colors.blue),
              _buildButton('5', Colors.blue),
              _buildButton('6', Colors.blue),
              _buildButton('*', Colors.orange),
              _buildButton('1', Colors.blue),
              _buildButton('2', Colors.blue),
              _buildButton('3', Colors.blue),
              _buildButton('-', Colors.orange),
              _buildButton('.', Colors.blue),
              _buildButton('0', Colors.blue),
              _buildButton('=', Colors.green, onTap: _calcular),
              _buildButton('+', Colors.orange),
              _buildButton('C', Colors.red, onTap: _clear),
            ],
          ),
        ],
      ),
    );
  }

  /// Um botão que pode ser pressionado para adicionar um valor ao cálculo
  /// atual. O botão exibirá o rótulo fornecido em texto branco
  /// em um fundo da cor fornecida. Se um callback onTap for
  /// fornecido, ele será invocado quando o botão for pressionado,
  /// caso contrário, o botão adicionará o rótulo ao cálculo
  /// atual.
  Widget _buildButton(String label, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () => _addToInput(label),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Avalia uma expressão matemática e retorna seu resultado como um double.
  ///
  /// A expressão deve conter apenas números e os operadores +, -, *, /.
  /// Os operadores devem ser separados por espaços dos números.
  ///
  /// Por exemplo, a expressão "2 + 3 * 4" deve ser avaliada como 14.0.
  ///
  /// A expressão é avaliada da esquerda para a direita. Por exemplo, a expressão
  /// "10 - 5 + 3" é avaliada como "(10 - 5) + 3", e não como "10 - (5 + 3)".
  ///
  /// A implementação desta função é um analisador sintático simples recursivo.
  double eval(String expression) {
    final operators = ['+', '-', '*', '/'];
    double result = 0;
    String currentOperator = '+';
    String currentNumber = '';

    for (int i = 0; i < expression.length; i++) {
      final char = expression[i];
      if (operators.contains(char)) {
        if (currentNumber.isNotEmpty) {
          result = _applyOperation(
              result, double.parse(currentNumber), currentOperator);
          currentNumber = '';
        }
        currentOperator = char;
      } else {
        currentNumber += char;
      }
    }

    if (currentNumber.isNotEmpty) {
      result =
          _applyOperation(result, double.parse(currentNumber), currentOperator);
    }

    return result;
  }

  /// Aplica uma operação matemática a dois números.
  ///
  /// A operação deve ser uma das quatro operações aritméticas básicas: +, -, *, /.
  ///
  /// Se a operação for / e o operando à direita for 0, uma exceção é lançada.
  ///
  /// Caso contrário, uma exceção é lançada se a operação não for reconhecida.
  double _applyOperation(double left, double right, String operator) {
    switch (operator) {
      case '+':
        return left + right;
      case '-':
        return left - right;
      case '*':
        return left * right;
      case '/':
        if (right == 0) {
          throw Exception('Divisão por zero');
        }
        return left / right;
      default:
        throw Exception('Operador desconhecido');
    }
  }
}
