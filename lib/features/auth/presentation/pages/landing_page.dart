// lib/presentation/pages/landing_page.dart

import 'package:flutter/material.dart';
import 'sign_up_page.dart';
import 'sign_in_page.dart';

class LandingPage extends StatelessWidget {
  static const String id = "landing_page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Cambia el color de fondo aquí
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final textScaleFactor = (constraints.maxWidth < 600)
                ? 0.8
                : 1.0; // Ajusta según tus necesidades

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo de tu app
                Image.asset(
                  'assets/images/Logo.jpg', // Reemplaza con la ruta de tu logo
                  width: 250,
                  height: 250,
                ),
                const SizedBox(height: 70),
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                        Colors.grey,
                        Colors.white
                      ], // Cambia los colores según tus necesidades
                    ).createShader(bounds);
                  },
                  child: Text(
                    "Bienvenido a la aplicación de Flutter",
                    style: TextStyle(
                      fontSize: 18 * textScaleFactor,
                      color: Colors
                          .white, // Color del texto, puedes cambiarlo si lo deseas
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Botón para crear una cuenta
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignUpPage.id);
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        Color.fromARGB(255, 117, 116, 116), // Color del botón
                  ),
                  child: Text(
                    'Crear una nueva cuenta',
                    style: TextStyle(
                      fontSize: 18 * textScaleFactor,
                    ),
                  ),
                ),
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                        Colors.grey,
                        Colors.white
                      ], // Cambia los colores según tus necesidades
                    ).createShader(bounds);
                  },
                  child: SizedBox(height: 20),
                ),
                // Texto para iniciar sesión
                // Texto para iniciar sesión
GestureDetector(
  onTap: () {
    Navigator.pushNamed(context, SignInPage.id);
  },
  child: ShaderMask(
    shaderCallback: (Rect bounds) {
      return LinearGradient(
        colors: [
          Colors.grey,
          Colors.white,
        ], // Cambia los colores según tus necesidades
      ).createShader(bounds);
    },
    child: Text(
      'Inicia sesión aquí si ya tienes cuenta',
      style: TextStyle(
        color: Colors.white, // Color del texto
        fontSize: 16 * textScaleFactor,
      ),
    ),
  ),
),

              ],
            );
          },
        ),
      ),
    );
  }
}
