import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RetrainPage extends StatefulWidget {
  static const String id = "_Retrain";
  const RetrainPage({super.key});

  @override
  State<RetrainPage> createState() => _RetrainState();
}

class _RetrainState extends State<RetrainPage> {
  final _formKey = GlobalKey<FormState>();
  String _respuesta = '';
  TextEditingController _urlController = TextEditingController();
  TextEditingController _shaController = TextEditingController();

  Future<void> _consultarModelo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Aquí podrías agregar cualquier lógica adicional antes del llamado a la API
      // Por ejemplo, validaciones o configuraciones previas

      await _llamadoAPI();
    }
  }

  Future<void> _llamadoAPI() async {
    final url = Uri.parse('https://api.github.com/repos/AldoTR/Diabetes-ML-AI/dispatches');

    final body = json.encode({
      "event_type": "ml_ci_cd",
      "client_payload": {
        "dataseturl": _urlController.text,
        "sha": _shaController.text,
      }
    });

    // Asegúrate de almacenar y cargar tu token de GitHub de manera segura
    final token = "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";

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/vnd.github.v3+json',
      'Content-type': 'application/json',
    };

    try {
      final response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 204) {
        setState(() {
          _respuesta = 'Llamado a API exitoso';
        });
      } else {
        setState(() {
          _respuesta = 'Error al hacer el llamado a la API: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _respuesta = 'Excepción al hacer llamado a la API: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Aquí va el resto de tu código para construir la interfaz de usuario (UI)
    // Si necesitas ayuda con eso también, házmelo saber.
    return Scaffold(
      appBar: AppBar(
        title: Text('Retrain Model'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _urlController,
              decoration: InputDecoration(labelText: 'Dataset URL'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la URL del dataset';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _shaController,
              decoration: InputDecoration(labelText: 'Commit SHA'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el SHA del commit';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _consultarModelo,
              child: Text('Iniciar Retrain'),
            ),
            SizedBox(height: 20),
            Text(_respuesta),
          ],
        ),
      ),
    );
  }
}
