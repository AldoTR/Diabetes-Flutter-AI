import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ModelPage extends StatefulWidget {
  static const String id = "Model_Page";
  const ModelPage({super.key});

  @override
  State<ModelPage> createState() => _ModelPageState();
}

class _ModelPageState extends State<ModelPage> {
  final _formKey = GlobalKey<FormState>();
  String _respuesta = '';
  double? age, bmi, HbA1c_level, blood_glucose_level;
  bool gender = false, hypertension = false, heart_disease = false, smoking_history = false;

  TextEditingController _ageController = TextEditingController();
  TextEditingController _bmiController = TextEditingController();
  TextEditingController _HbA1c_levelController = TextEditingController();
  TextEditingController _blood_glucose_levelController = TextEditingController();


  @override
  void dispose() {
    _ageController.dispose();
    _bmiController.dispose();
    _HbA1c_levelController.dispose();
    _blood_glucose_levelController.dispose();
    super.dispose();
  }

  Future<void> _consultarModelo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.parse('https://diabetes-model-service-aldotr.cloud.okteto.net/predict');
      final response = await http.post(
        url,
        body: json.encode({
          "Gender": gender ? 1 : 0,
          "Age": age,
          "Hypertension": hypertension ? 1 : 0,
          "Heart disease": heart_disease ? 1 : 0,
          "smoking_history": smoking_history ? 1 : 0,  
          "bmi": bmi,
          "HbA1c": HbA1c_level,
          "blood_glucose_level": blood_glucose_level
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final result = jsonResponse['probability'];
        setState(() {
          _respuesta = 'Resultado: $result';
        });
      } else {
        setState(() {
          _respuesta = 'Error al obtener respuesta: ${response.statusCode}';
        });
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de Modelo'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onSaved: (value) => age = double.tryParse(value ?? ''),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the age';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _HbA1c_levelController,
                decoration: const InputDecoration(labelText: 'HbA1c'),
                keyboardType: TextInputType.number,
                onSaved: (value) => HbA1c_level= double.tryParse(value ?? ''),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the HbA1c level value';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _blood_glucose_levelController,
                decoration: const InputDecoration(labelText: 'Blood Glucose Level'),
                keyboardType: TextInputType.number,
                onSaved: (value) => blood_glucose_level = double.tryParse(value ?? ''),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the blood glucose level';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bmiController,
                decoration: const InputDecoration(labelText: 'BMI Level'),
                keyboardType: TextInputType.number,
                onSaved: (value) => bmi = double.tryParse(value ?? ''),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the bmi level';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Gender'),
                value: gender,
                onChanged: (bool value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Hypertension history'),
                value: hypertension,
                onChanged: (bool value) {
                  setState(() {
                    hypertension = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Heart disease history'),
                value: heart_disease,
                onChanged: (bool value) {
                  setState(() {
                    heart_disease = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Smoking history'),
                value: smoking_history,
                onChanged: (bool value) {
                  setState(() {
                    smoking_history = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _consultarModelo,
                child: const Text('Consultar modelo'),
              ),
              Text(_respuesta), // Mostrar la respuesta de la API aquí
            ],
          ),
        ),
      ),
    );
  }

}
