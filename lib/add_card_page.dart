import 'package:flutter/material.dart';
import 'package:final_exam/models/loyalty_card.dart';
import 'package:final_exam/services/hive_service.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _issuerController = TextEditingController();
  DateTime? _expiryDate;
  final HiveService _hiveService = HiveService();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _issuerController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _expiryDate) {
      setState(() {
        _expiryDate = picked;
/*************  ✨ Windsurf Command ⭐  *************/
  /// Uploads the currently selected image to Firebase Storage, and
  /// returns a download URL for the uploaded image, or null if no image
  /// has been selected.
/*******  a9c311d5-d9e0-4324-9500-13276543fb50  *******/      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Loyalty Card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _issuerController,
                decoration: const InputDecoration(
                  labelText: 'Issuer (e.g., Starbucks)',
                  hintText: 'Enter card issuer',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the issuer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  hintText: 'Enter card number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the card number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Expiry Date',
                  hintText: _expiryDate == null
                      ? 'Select expiry date'
                      : DateFormat.yMMMd().format(_expiryDate!),
                ),
                onTap: () => _selectExpiryDate(context),
                validator: (value) {
                  if (_expiryDate == null) {
                    return 'Please select an expiry date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final card = LoyaltyCard(
                      id: const Uuid().v4(),
                      cardNumber: _cardNumberController.text,
                      issuer: _issuerController.text,
                      expiryDate: _expiryDate!, storeName: '', barcodeType: '',
                    );
                    await _hiveService.addCard(card);
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Add Card'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}