import 'package:ChatApp/providers/chat_rooms_provider.dart';
import 'package:ChatApp/providers/edit_profile_provider.dart';
import 'package:ChatApp/providers/home_layout_provider.dart';
import 'package:ChatApp/providers/messages_provider.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:ChatApp/view/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return UserProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return ChatRoomsProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return EditProfileProvider(
                Provider.of<UserProvider>(context, listen: false).myUser!);
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return HomeLayoutProvider();
          },
        ),
      ],
      child: Sizer(builder: (context, orientation, type) {
        return MaterialApp(
          theme: ThemeData(scaffoldBackgroundColor: Colors.white),
          debugShowCheckedModeBanner: false,
          builder: DevicePreview.appBuilder,
          home: SplashScreen(),
        );
      }),
    );
  }
}
