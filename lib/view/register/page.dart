import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_application/component/button.dart';
import 'package:messaging_application/component/input.dart';
import 'package:messaging_application/view/register/controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerConfirmPassword = TextEditingController();
  TextEditingController controllerNama = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .05,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Register",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              InputCostumComponent(
                controller: controllerNama,
                label: 'Nama',
                keyboardType: TextInputType.text,
              ),
              InputCostumComponent(
                controller: controllerEmail,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              InputCostumComponent(
                controller: controllerPassword,
                label: 'Password',
                keyboardType: TextInputType.text,
              ),
              InputCostumComponent(
                controller: controllerConfirmPassword,
                label: 'Confirm Password',
                keyboardType: TextInputType.text,
              ),
              CostumButtonComponent(
                margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * .02,
                ),
                onTap: () {
                  RegisterController()
                      .register(
                        email: controllerEmail.text,
                        password: controllerPassword.text,
                        name: controllerNama.text,
                        confirmPassword: controllerConfirmPassword.text,
                      )
                      .then((value) {
                        if (value) {
                          Get.back();
                        }
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
