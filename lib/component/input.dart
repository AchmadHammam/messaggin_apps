import 'package:flutter/material.dart';

class InputCostumComponent extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  const InputCostumComponent({
    super.key,
    required this.controller,
    required this.label,
    required this.keyboardType,
  });

  @override
  State<InputCostumComponent> createState() => _InputCostumComponentState();
}

class _InputCostumComponentState extends State<InputCostumComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * .02,
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.label == "Password" ? true : false,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: widget.label,
        ),
      ),
    );
  }
}
