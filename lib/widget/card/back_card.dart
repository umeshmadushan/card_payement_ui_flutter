import 'package:flutter/material.dart';

class BackCard extends StatelessWidget {
  final String cvvCode;
  final String cardLogo;

  const BackCard({
    required this.cvvCode,
    required this.cardLogo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[800],
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: 350,
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Container(
              color: Colors.black,
              height: 40,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      cvvCode.isNotEmpty ? cvvCode : 'XXX',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset(cardLogo, width: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
