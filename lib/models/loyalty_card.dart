import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'loyalty_card.g.dart';

@HiveType(typeId: 0)
class LoyaltyCard extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String storeName;

  @HiveField(2)
  String cardNumber;

  @HiveField(3)
  String barcodeType;

  @HiveField(4)
  DateTime? expiryDate;

  @HiveField(5)
  String? notes;

  LoyaltyCard({
    String? id,
    required this.storeName,
    required this.cardNumber,
    required this.barcodeType,
    this.expiryDate,
    this.notes, required String issuer,
  }) : id = id ?? const Uuid().v4();

  // Add toMap method for serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'storeName': storeName,
      'cardNumber': cardNumber,
      'barcodeType': barcodeType,
      'expiryDate': expiryDate?.toIso8601String(),
      'notes': notes,
    };
  }

  // Add fromMap factory for deserialization
  factory LoyaltyCard.fromMap(Map<String, dynamic> map, Map<String, dynamic> data) {
    return LoyaltyCard(
      id: map['id'] ?? const Uuid().v4(),
      storeName: map['storeName'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      barcodeType: map['barcodeType'] ?? 'CODE_128',
      expiryDate: map['expiryDate'] != null
          ? DateTime.parse(map['expiryDate'])
          : null,
      notes: map['notes'], issuer: '',
    );
  }

  get barcodeData => null;

  get logoUrl => null;

  String? get issuer => null;
}