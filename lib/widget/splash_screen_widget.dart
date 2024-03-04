import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rental_app/screens/home_screen.dart';
import 'package:rental_app/screens/login_screen.dart';
import 'package:rental_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({super.key});

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  void initState() {  
    
    checkUserLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: Image.asset('assets/images/logo.png',color: Colors.black),
        
        backgroundColor: const Color(0xffC8B6B6),
        splashIconSize: 200 ,
        duration: 3000,
        splashTransition: SplashTransition.sizeTransition,
        nextScreen:const HomeScreen(),
        pageTransitionType: PageTransitionType.theme,
        ),
    );
  }
 Future<void>gotoLogin() async{
    await Future.delayed(const Duration(seconds: 3));
    if(mounted){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (ctx)=> LoginScreen(),),);
    }
    
  }

  Future<void>checkUserLoggedIn() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    final userLoggedIn = sharedPrefs.getBool(saveKeyName);
    if(userLoggedIn== null || userLoggedIn==false){
      gotoLogin();
    }
    else{
      if(mounted){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=> const HomeScreen()));
      }
     

    }
  }



}