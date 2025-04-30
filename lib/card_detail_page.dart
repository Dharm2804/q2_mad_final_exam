// card_detail_page.dart
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'models/loyalty_card.dart';

class CardDetailPage extends StatelessWidget {
  final LoyaltyCard card;
  
  const CardDetailPage({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(card.storeName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (card.logoUrl != null)
              Image.network(card.logoUrl!, height: 100),
            const SizedBox(height: 20),
            Text(
              card.storeName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              card.cardNumber,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            if (card.barcodeData != null && card.barcodeType != null)
              BarcodeWidget(
                barcode: _getBarcodeType(card.barcodeType!),
                data: card.barcodeData!,
                width: double.infinity,
                height: 100,
              ),
            const SizedBox(height: 20),
            if (card.expiryDate != null)
              Text(
                'Expires: ${card.expiryDate!.toLocal().toString().split(' ')[0]}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
          ],
        ),
      ),
    );
  }

  Barcode _getBarcodeType(String type) {
    switch (type.toLowerCase()) {
      case 'qr':
        return Barcode.qrCode();
      case 'code128':
        return Barcode.code128();
      case 'ean13':
        return Barcode.ean13();
      case 'upca':
        return Barcode.upcA();
      default:
        return Barcode.code128();
    }
  }
}