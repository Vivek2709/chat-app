import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/componenets/my_button.dart';
import 'package:chatapp/componenets/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirPasswordController = TextEditingController();

  // ap to go  to loginPage
  final void Function()? onTap;

  RegisterPage({super.key,required this.onTap});
  
  //register method
  void register(BuildContext context) {
    //* get auth service
    final _auth = AuthService();

    //* passwords match  => create user
    if(_passwordController.text == _confirPasswordController.text){
      try{
    _auth.signUpWithEMailPassword(_emailController.text, _passwordController.text);
    } catch (e) {
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text(e.toString()),
      ));
    }
    }
    //* password dont match => show error to user
    else{
      showDialog(context: context, builder: (context) => const AlertDialog(
        title: Text("Passwords don't match!"),
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
          Text("Let's create an account for you!",
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

          MyTextField(
            hintText: "Confirm password",
            obscureText: true,
            controller: _confirPasswordController,
          ),

          const SizedBox(height: 15),
        //login button
          MyButton(
            text: 'Register',
            onTap: () => register(context),
          ),

          const SizedBox(height: 25,),
          //registration link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Already have an account? ",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text("Login now", style: TextStyle(
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