import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback function;
  const CustomButton({super.key, required this.text, required this.function});

  @override
  Widget build(BuildContext context) {
    print('CustomButton build');
    print(function);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: function,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.blue,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
