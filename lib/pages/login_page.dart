import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/componenets/my_button.dart';
import 'package:chatapp/componenets/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Tap to go to register page
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  void login(BuildContext context) async {
    //*auth service
    final authService = AuthService();
    //*try login
    try{
      await authService.signInWithEmailPassword(_emailController.text, _passwordController.text);
    }
    //* catch any errors
    catch(e){
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text(e.toString()),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          //logo
          Icon(
            Icons.message,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 50,
            ),
          //welcome back message
          Text("Welcome Back Youve've been missed!",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16
          ),
          ),
          const SizedBox(
            height: 20,
          ),

          //email text filed
          MyTextField(
            hintText: "Email",
            obscureText: false,
            controller: _emailController,
            
            ),
          
          const SizedBox(height: 10,),
          //pw textfield
          MyTextField(
            hintText: "password",
            obscureText: true,
            controller: _passwordController,
            ),

            const SizedBox(height: 15),
        //login button
          MyButton(
            text: 'Login',
            onTap: () => login(context),
          ),

          const SizedBox(height: 25,),
          //registration link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Not a member? ",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text("Register now", style: TextStyle(
                  fontWeight: FontWeight.bold 
                ),),
              )
              
              ]
            )
          ]
        ),
      ),
    );
  }
}