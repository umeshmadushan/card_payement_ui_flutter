import 'package:card_payement_ui_flutter/widget/snackBar.dart';
import 'package:card_payement_ui_flutter/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flip_card/flip_card.dart';
import 'package:card_payement_ui_flutter/widget/card/back_card.dart';
import 'package:card_payement_ui_flutter/widget/card/front_card.dart';
import 'package:card_payement_ui_flutter/widget/button.dart';
import 'package:lottie/lottie.dart';

class Mycard extends StatefulWidget {
  const Mycard({Key? key}) : super(key: key);

  @override
  State<Mycard> createState() => _MycardState();
}

class _MycardState extends State<Mycard> {
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();
  final FocusNode _cvvFocusNode = FocusNode();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  String _displayCardNumber = '1234 5678 9876 5432';
  String _displayExpiryDate = '12/25';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _cvvFocusNode.addListener(() {
      if (_cvvFocusNode.hasFocus) {
        _cardKey.currentState?.toggleCard();
      } else {
        _cardKey.currentState?.toggleCard();
      }
    });
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderNameController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cvvFocusNode.dispose();
    super.dispose();
  }

  void _formatCardNumber(String value) {
    value = value.replaceAll(' ', '');
    if (value.length > 16) {
      value = value.substring(0, 16);
    }
    final newValue = value.replaceAllMapped(
      RegExp(r'.{4}'),
      (match) => '${match.group(0)} ',
    );
    _cardNumberController.value = TextEditingValue(
      text: newValue.trim(),
      selection: TextSelection.collapsed(offset: newValue.trim().length),
    );
    setState(() {
      _displayCardNumber = newValue.trim().padRight(19, '*');
    });
  }

  void _formatExpiryDate(String value) {
    value = value.replaceAll('/', '');
    if (value.length > 4) {
      value = value.substring(0, 4);
    }
    if (value.length > 2) {
      value = '${value.substring(0, 2)}/${value.substring(2)}';
    }
    _expiryDateController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    setState(() {
      _displayExpiryDate = value.padRight(5, '*');
    });
  }

  void _submitPayment() {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.network(
                    'https://assets10.lottiefiles.com/packages/lf20_s2lryxtd.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.fill,
                    repeat: false,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Payment Successful!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      showSnackBar(context: context, text: "Payment failed!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay Now'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            FlipCard(
              key: _cardKey,
              flipOnTouch: false,
              front: FrontCard(
                cardNumber: _displayCardNumber,
                cardHolderName: _cardHolderNameController.text.isEmpty
                    ? 'Umesh Madushan'
                    : _cardHolderNameController.text,
                expiryDate: _displayExpiryDate,
                cardLogo: 'assets/visa_logo.png',
              ),
              back: BackCard(
                cvvCode:
                    _cvvController.text.isEmpty ? '123' : _cvvController.text,
                cardLogo: 'assets/visa_logo.png',
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    MyTextField(
                      controller: _cardNumberController,
                      labelText: 'Card Number',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: _formatCardNumber,
                      validator: (value) {
                        if (value == null ||
                            value.replaceAll(' ', '').length != 16) {
                          return 'Please enter a valid 16-digit card number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _cardHolderNameController,
                      labelText: 'Card Holder Name',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please fill card holder name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: MyTextField(
                            controller: _expiryDateController,
                            labelText: 'Expiry Date',
                            hintText: 'MM/YY',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please fill expiry date';
                              }
                              return null;
                            },
                            onChanged: _formatExpiryDate,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: MyTextField(
                            controller: _cvvController,
                            focusNode: _cvvFocusNode,
                            labelText: 'CVV',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please fill cvv';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                      onTap: _submitPayment,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
