import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // import needed for SystemChrome
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'flash_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

int steps=0;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future<void> main() async {
  getPreviousValue().then((value) {

    steps =  value;
    print("storeddddddddddddd value : $value");
    print("now vsteeeeeepppppppps : $steps");// Update the steps with the stored value

  });
  await Supabase.initialize(
      url: 'https://wmrygvcmvcgtqkkedhfv.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtcnlndmNtdmNndHFra2VkaGZ2Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY5MDk5NTE4NCwiZXhwIjoyMDA2NTcxMTg0fQ.v4z_QXdMKNyq1AG7muGioKm1nxk0sQnaME66XnsPD5E'
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await initializeService();

  runApp(arogya_sahayak());
  _initializeTimezone();
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();


  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground',
    'MY FOREGROUND SERVICE',
    description: 'This channel is used for important notifications.',
    importance: Importance.low,
  );


  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
    ),
  );
}

void onStart(ServiceInstance service) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  double previousDistance = 0.0;


  accelerometerEvents.listen((event) {
    final double x = event.x;
    final double y = event.y;
    final double z = event.z;
    final double exactDistance = sqrt(x * x + y * y + z * z);
    final double mode = exactDistance - previousDistance;
    previousDistance = exactDistance;

    if (mode > 6) {
      steps++;
      setPrefData(steps); // Store steps to shared preferences
    }
  });
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    flutterLocalNotificationsPlugin.show(
      888,
      'Step counter',
      'Steps taken: $steps',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'my_foreground',
          'MY FOREGROUND SERVICE',
          icon: 'ic_bg_service_small',
          ongoing: true,
        ),
      ),
    );




    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}
Future<void> setPrefData(int steps) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  _pref.setInt("steps", steps);
}
Future<int> getPreviousValue() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  return _pref.getInt("steps") ?? 0;
}
void _initializeTimezone() async {
  tz.initializeTimeZones();
}

final supabase = Supabase.instance.client;

class arogya_sahayak extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arogya Sahayak',
      theme: ThemeData(
        primaryColor: Color(0xFF1877F2),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FlashScreen(),
    );
  }
}
