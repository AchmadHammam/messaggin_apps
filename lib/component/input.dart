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
  bool password = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      password =
          widget.label == "Password" || widget.label == "Confirm Password";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * .02,
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: password,
        keyboardType: widget.keyboardType,

        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: widget.label,
          suffixIcon:
              ((widget.label == "Password" ||
                      widget.label == "Confirm Password") &&
                  !password)
              ? IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    setState(() {
                      password = !password;
                    });
                  },
                )
              : ((widget.label == "Password" ||
                        widget.label == "Confirm Password") &&
                    password)
              ? IconButton(
                  icon: Icon(Icons.remove_red_eye_outlined),
                  onPressed: () {
                    setState(() {
                      password = !password;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
