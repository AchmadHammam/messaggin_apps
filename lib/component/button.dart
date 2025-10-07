import 'package:flutter/material.dart';

class CostumButtonComponent extends StatefulWidget {
  final void Function() onTap;
  final EdgeInsets margin;
  const CostumButtonComponent({
    super.key,
    required this.onTap,
    required this.margin,
  });

  @override
  State<CostumButtonComponent> createState() => _CostumButtonComponentState();
}

class _CostumButtonComponentState extends State<CostumButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: widget.margin,
      child: ElevatedButton(
        onPressed: widget.onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        child: Text(
          "Login",
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
