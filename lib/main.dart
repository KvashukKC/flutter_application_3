import 'package:flutter/material.dart';
import 'dart:math';

//7 вариант задание 3
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Квадратные уравнения',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EquationInputScreen(),
    );
  }
}

class EquationInputScreen extends StatefulWidget {
  const EquationInputScreen({super.key});

  @override
  State<EquationInputScreen> createState() => _EquationInputScreenState();
}

class _EquationInputScreenState extends State<EquationInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final aController = TextEditingController();
  final bController = TextEditingController();
  final cController = TextEditingController();
  bool isAgreed = false;

  @override
  void dispose() {
    aController.dispose();
    bController.dispose();
    cController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Квашук К. С. - Квадратное уравнение'), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: aController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Коэффициент a',
                  hintText: 'Введите коэффициент a',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Поле не может быть пустым';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Введите число';
                  }
                  if (double.parse(value) == 0) {
                    return 'Коэффициент a не может быть 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: bController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Коэффициент b',
                  hintText: 'Введите коэффициент b',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Поле не может быть пустым';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Введите число';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Коэффициент c',
                  hintText: 'Введите коэффициент c',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Поле не может быть пустым';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Введите число';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Я согласен на обработку данных'),
                value: isAgreed,
                onChanged: (bool? value) {
                  setState(() {
                    isAgreed = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && isAgreed) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EquationResultScreen(
                            a: double.parse(aController.text),
                            b: double.parse(bController.text),
                            c: double.parse(cController.text),
                          ),
                        ),
                      );
                    } else if (!isAgreed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Необходимо согласие на обработку данных'),
                        ),
                      );
                    }
                  },
                  child: const Text('Решить уравнение'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EquationResultScreen extends StatelessWidget {
  final double a;
  final double b;
  final double c;

  const EquationResultScreen({
    super.key,
    required this.a,
    required this.b,
    required this.c,
  });

  String calculateEquation() {
    final discriminant = b * b - 4 * a * c;
    
    if (discriminant > 0) {
      final x1 = (-b + sqrt(discriminant)) / (2 * a);
      final x2 = (-b - sqrt(discriminant)) / (2 * a);
      return 'Два действительных корня:\n'
          'x₁ = ${x1.toStringAsFixed(2)}\n'
          'x₂ = ${x2.toStringAsFixed(2)}';
    } else if (discriminant == 0) {
      final x = -b / (2 * a);
      return 'Один действительный корень:\n'
          'x = ${x.toStringAsFixed(2)}';
    } else {
      final realPart = -b / (2 * a);
      final imaginaryPart = sqrt(-discriminant) / (2 * a);
      return 'Два комплексных корня:\n'
          'x₁ = ${realPart.toStringAsFixed(2)} + ${imaginaryPart.toStringAsFixed(2)}i\n'
          'x₂ = ${realPart.toStringAsFixed(2)} - ${imaginaryPart.toStringAsFixed(2)}i';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Результат решения'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Уравнение: ${a}x² + ${b}x + $c = 0',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              calculateEquation(),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Вернуться назад'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}