import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/Providers/user_provider.dart';
import 'package:social_media/responsive/mobile_Screen_Layout.dart';
import 'package:social_media/responsive/responsive_layout_screen.dart';
import 'package:social_media/responsive/web_Screen_Layout.dart';
import 'package:social_media/screen/login_screen.dart';
import 'package:social_media/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBW5srNuj1IdugDBC1CbstlgcYg-RjO9GU',
          appId: '1:875932600291:web:fa50506947ecc83ab382d6',
          messagingSenderId: '875932600291',
          projectId: 'social-media-6b7f9',
          storageBucket: 'social-media-6b7f9.appspot.com',
      )
    );
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyD0GP0gTrlcaNtXqgjSVCblNhf3A2y1BWU',
          appId: '1:875932600291:android:e6b0e06cce149ae8b382d6',
          messagingSenderId: '875932600291',
          projectId: 'social-media-6b7f9',
        storageBucket: 'social-media-6b7f9.appspot.com',
      )
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Social_media',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        //home: const Responsive(webScreenLayout: WebScreenLayout(), mobileScreenLayout: MobileScreenLayout() ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.active) {
             if (snapshot.hasData) {
               return const Responsive(webScreenLayout: WebScreenLayout(), mobileScreenLayout: MobileScreenLayout(),);
             } else if (snapshot.hasError){
               return Center(
                 child: Text('${snapshot.error}'),
               );
             }
           }
           if(snapshot.connectionState == ConnectionState.waiting) {
             return const Center(
               child: CircularProgressIndicator(
                 color: primaryColor,
               )
             );
           }
           return const LoginScreen();
          },
        ),
      ),
    );
  }
}
