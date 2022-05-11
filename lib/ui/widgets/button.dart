import 'package:flutter/material.dart';
import 'package:todo/ui/theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.labl, required this.onTap})
      : super(key: key);

  final String labl;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primaryClr,
          borderRadius: BorderRadius.circular(10),
        ),
        width: 100,
        height: 45,
        child: Text(
          labl,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
