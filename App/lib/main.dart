import 'dart:io';

import 'package:catcher/catcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:githubit/routes.dart';
import 'package:githubit/src/controllers/about_controller.dart';
import 'package:githubit/src/controllers/address_controller.dart';
import 'package:githubit/src/controllers/banner_controller.dart';
import 'package:githubit/src/controllers/brands_controller.dart';
import 'package:githubit/src/controllers/category_controller.dart';
import 'package:githubit/src/controllers/chat_controller.dart';
import 'package:githubit/src/controllers/currency_controller.dart';
import 'package:githubit/src/controllers/faq_controller.dart';
import 'package:githubit/src/controllers/language_controller.dart';
import 'package:githubit/src/controllers/notification_controller.dart';
import 'package:githubit/src/controllers/order_controller.dart';
import 'package:githubit/src/controllers/product_controller.dart';
import 'package:githubit/src/controllers/savings_controller.dart';
import 'package:githubit/src/controllers/settings_controller.dart';
import 'package:githubit/src/controllers/sign_in_controller.dart';
import 'package:githubit/src/controllers/auth_controller.dart';
import 'package:githubit/src/controllers/sign_up_controller.dart';
import 'package:githubit/src/controllers/shop_controller.dart';
import 'package:githubit/src/themes/dark_theme.dart';
import 'package:githubit/src/themes/light_theme.dart';
import 'package:githubit/translations.dart';
// import 'package:laravel_echo/laravel_echo.dart';
// import 'package:pusher_client/pusher_client.dart';

void initialize() {
  Get.put<AuthController>(AuthController());
  Get.put<SignInController>(SignInController());
  Get.put<SignUpController>(SignUpController());
  Get.put<ShopController>(ShopController());
  Get.put<AddressController>(AddressController());
  Get.put<BannerController>(BannerController());
  Get.put<BrandsController>(BrandsController());
  Get.put<CategoryController>(CategoryController());
  Get.put<ProductController>(ProductController());
  Get.put<SavingsController>(SavingsController());
  Get.put<AboutControler>(AboutControler());
  Get.put<FaqController>(FaqController());
  Get.put<SettingsController>(SettingsController());
  Get.put<CurrencyController>(CurrencyController());
  Get.put<ChatController>(ChatController());
  Get.put<OrderController>(OrderController());
  Get.put<NotificationController>(NotificationController());
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final LanguageController controller =
      Get.put<LanguageController>(LanguageController());
  Map<String, Map<String, String>> translations =
      await controller.getMessages();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await GetStorage.init();
  initialize();

  CatcherOptions debugOptions =
      CatcherOptions(DialogReportMode(), [ConsoleHandler()]);

  CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(["azimbekmakhmudov@gmail.com"])
  ]);

  Catcher(
      rootWidget: MyApp(
        translations: Messages(data: translations),
      ),
      debugConfig: debugOptions,
      releaseConfig: releaseOptions);
  // runApp(MyApp(
  //   translations: Messages(data: translations),
  // ));

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark);

    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}

class MyApp extends StatefulWidget {
  final Messages translations;

  const MyApp({Key? key, required this.translations}) : super(key: key);

  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // PusherClient? pusherClient;
  // Echo? echo;

  @override
  void initState() {
    super.initState();
  }

  void initSocket() async {
    print('initiating Socket....');
    // try {
    //   PusherOptions options = PusherOptions(
    //       host: 'sundaymart.net',
    //       wsPort: 8443,
    //       wssPort: 8443,
    //       encrypted: true,
    //       cluster: 'mt1');

    //   pusherClient = PusherClient(
    //     "PCOJ9JMa9F0PkiLOsRrvXK5YcceB",
    //     options,
    //     enableLogging: true,
    //   );

    //   echo = new Echo(
    //     broadcaster: EchoBroadcasterType.Pusher,
    //     client: pusherClient,
    //   );

    //   echo!.channel('dialog').listen('dialog.message', (e) {
    //     print(e.message);
    //   });

    //   // echo!.connector.pusher.onConnectionStateChange((state) {
    //   //   print('pusher ' + state!.currentState.toString());
    //   // });
    // } catch (e) {
    //   print("socket exception");
    //   print(e);
    // }
  }

  @override
  void dispose() {
    //echo!.disconnect();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(builder: (languageController) {
      return ScreenUtilInit(
        designSize: Size(414, 902),
        builder: () => GetMaterialApp(
            navigatorKey: Catcher.navigatorKey,
            translations: widget.translations,
            title: 'Githubit Market',
            debugShowCheckedModeBanner: false,
            theme: lightTheme(),
            darkTheme: darkTheme(),
            initialRoute: "/",
            getPages: AppRoutes.routes),
      );
    });
  }
}
