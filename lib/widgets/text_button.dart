import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TextButtonMio extends StatelessWidget{
  final VoidCallback onPressed;
  final String label;


  const TextButtonMio({
    Key? key,
    required this.onPressed,
    required this.label
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(int.parse(dotenv.env['SECONDARY_COLOR'] ?? '0xFFFFA500')),
        shadowColor: Color(int.parse(dotenv.env['SHADOW_COLOR'] ?? '0xFFFFA500')),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Color(int.parse(dotenv.env['PRIMARY_COLOR'] ?? '0xFF888888')), width: 4),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        minimumSize: Size(250, 50),
      ),
      onPressed: onPressed,

      child: Text(
        label,
        style: TextStyle(
          color: Color(int.parse(dotenv.env['TEXT_COLOR'] ?? '0xFF000000')),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}