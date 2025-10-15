import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_application/component/button.dart';
import 'package:messaging_application/component/input.dart';
import 'package:messaging_application/view/login/controller.dart';
import 'package:messaging_application/view/menu/page.dart';
import 'package:messaging_application/view/register/page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  LoginController loginController = LoginController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Login", style: Theme.of(context).textTheme.headlineLarge),
            InputCostumComponent(
              keyboardType: TextInputType.emailAddress,
              controller: controllerEmail,
              label: "Email",
            ),
            InputCostumComponent(
              keyboardType: TextInputType.text,
              controller: controllerPassword,
              label: "Password",
            ),
            CostumButtonComponent(
              margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * .02,
              ),
              onTap: () {
                loginController
                    .login(
                      email: controllerEmail.text,
                      password: controllerPassword.text,
                    )
                    .then((v) {
                      Get.to(MenuPage());
                      if (v == true) {}
                    });
              },
            ),
            Text.rich(
              TextSpan(
                text: "Don't have an account? ",
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.to(RegisterPage());
                      },
                    text: "Register",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
