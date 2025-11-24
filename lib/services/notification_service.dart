import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Servicio para notificaciones locales
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: android,
    );

    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  // mostrar notificacion cuando el stock este bajo
  Future<void> showLowStockNotification(String productName, int qty) async {
    const androidDetails = AndroidNotificationDetails(
      'low_stock_channel',
      'Low Stock Notifications',
      channelDescription: 'Alerts when a product is running low',
      importance: Importance.max,
      priority: Priority.high,
    );

    const general = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Low stock',
      'Only $qty units of $productName are available.',
      general,
    );
  }
}