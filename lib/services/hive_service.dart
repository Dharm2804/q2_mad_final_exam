import 'package:hive/hive.dart';
import 'package:final_exam/models/loyalty_card.dart';

class HiveService {
  static const String boxName = 'loyaltyCards';

  Future<Box<LoyaltyCard>> _openBox() async {
    return await Hive.openBox<LoyaltyCard>(boxName);
  }

  Future<void> addCard(LoyaltyCard card) async {
    final box = await _openBox();
    await box.put(card.id, card);
  }

  Future<List<LoyaltyCard>> getAllCards() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> deleteCard(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }
}