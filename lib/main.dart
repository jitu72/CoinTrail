import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:cointrail/routes/app_pages.dart';
import 'package:cointrail/services/local_data_service.dart';

Future<void> main() async {
  // debugRepaintRainbowEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local data with sample data if needed
  await LocalDataService.initializeSampleData();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoinTrail',
      initialRoute: Routes.SPLASH, // Changed back to SPLASH so we see the splash animation
      getPages: AppPages.routes,
    );
  }
}
