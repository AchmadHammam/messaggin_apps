import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_application/component/button.dart';
import 'package:messaging_application/component/input.dart';
import 'package:messaging_application/view/login/controller.dart';
import 'package:messaging_application/view/menu/page.dart';

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
              onTap: () {
                loginController
                    .login(
                      email: controllerEmail.text,
                      password: controllerPassword.text,
                    )
                    .then((v) {
                      if (v == true) {
                        Get.to(MenuPage());
                      }
                    });
              },
              margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * .02,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
