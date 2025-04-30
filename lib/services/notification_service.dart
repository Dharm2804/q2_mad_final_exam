// services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';
import '../models/loyalty_card.dart';
import 'database_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    
    await _notificationsPlugin.initialize(initializationSettings);
    
    // Schedule background task to check for expiring cards
    Workmanager().registerPeriodicTask(
      "expirationCheck",
      "checkExpiringCards",
      frequency: const Duration(hours: 12),
    );
  }

  Future<void> checkExpiringCards() async {
    // In a real app, you would fetch cards from local database
    // For this example, we'll just show a sample notification
    await _showNotification(
      title: 'Card Expiring Soon',
      body: 'Your Starbucks rewards card expires in 3 days',
    );
  }

  Future<void> _showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'card_expiry_channel',
      'Card Expiry Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    await _notificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> scheduleExpiryNotification(LoyaltyCard card) async {
  if (card.expiryDate == null) return;
  
  final expiryDate = card.expiryDate!;
  final notificationDate = expiryDate.subtract(const Duration(days: 3));
  
  await _notificationsPlugin.zonedSchedule(
    0,
    'Card Expiring Soon',
    'Your ${card.storeName} card expires on ${expiryDate.toLocal().toString().split(' ')[0]}',
    tz.TZDateTime.from(notificationDate, tz.local),
    const NotificationDetails(     
      android: AndroidNotificationDetails(
        'card_expiry_channel',     
        'Card Expiry Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}
}