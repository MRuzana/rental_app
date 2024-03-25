import 'package:flutter/material.dart';
import 'package:rental_app/main.dart';
import 'package:rental_app/screens/home_screen.dart';
import 'package:rental_app/widget/button_widget.dart';
import 'package:rental_app/widget/text_form_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _usernameController=TextEditingController();
  final _passwordController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    Widget divider=const SizedBox(height: 10);

    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 155, 154, 154),      
      appBar: AppBar(
        backgroundColor:  const Color.fromARGB(255, 155, 154, 154),            
      ),
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(           
                children: [
                  Image.asset('assets/images/logo.png',color: Colors.black,width: 300,height: 300,),
                  divider,
                  textField(
                    controller: _usernameController,
                    keyboardType: TextInputType.name,
                    hintText: 'Username',
                    validator: (value){
                      if(value==null||value.isEmpty){
                        return 'Username should not be empty';
                      }
                      else{
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.always,
                  ),
                  divider,
                  textField(
                    controller: _passwordController,
                    keyboardType: TextInputType.number,
                    hintText: 'Password',
                    validator: (value){
                      if(value==null||value.isEmpty){
                        return 'password should not be empty';
                      }
                      else{
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.always,
                  ),
                  divider,
                  button(
                    buttonText: 'LOGIN',
                    buttonPressed: (){
                      if(_formKey.currentState!.validate()){
                        checkLogin(context);
                      }
                    }),
                    const Text('usernama:ruzana,password:1234',style: TextStyle(fontSize: 10))          
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
void checkLogin(BuildContext ctx) async{
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    const uname='ruzana';
    const pword='1234';
    
    if(username == uname && password==pword){     
      //goto home
      final sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.setBool(saveKeyName, true);
      
      Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (ctx)=> const HomeScreen(),),);
    }
    else  {     
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        margin: EdgeInsets.all(10),
        content: Text('Username and Password does not match'),
      ));
    }
  }
}