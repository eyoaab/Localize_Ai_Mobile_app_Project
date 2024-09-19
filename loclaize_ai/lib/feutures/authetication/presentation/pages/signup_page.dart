import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loclaize_ai/core/commonWidgets/store.dart';
import 'package:loclaize_ai/feutures/authetication/domain/entity/user_entity.dart';
import 'package:loclaize_ai/feutures/authetication/presentation/bloc/user_bloc.dart';
import 'package:loclaize_ai/feutures/authetication/presentation/bloc/user_event.dart';
import 'package:loclaize_ai/feutures/authetication/presentation/bloc/user_state.dart';
import 'package:loclaize_ai/feutures/authetication/presentation/pages/signin_page.dart';

 

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void clearFields(){
    _usernameController.clear();
    _confirmPasswordController.clear();
    _passwordController.clear();
    _nameController.clear();
  }

  void SignUpUser() async {
    final name = _nameController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty || password.isEmpty)  {
      showMessage(
        context,
        const Icon(Icons.info, size: 50, color: Colors.red),
        'Please enter all fields',
      );
      return;
    }
    else if(password != confirmPassword){
      showMessage(
        context,
        const Icon(Icons.info, size: 50, color: Colors.red),
        'Passwords do not match',
      );
      return;


    } else {
      UserEntity user = UserEntity(
        name: name,
        username: username,
        password: password,
      );
      context.read<UserBloc>().add(SignUpEvent(user: user));
      log('SignUpUser request sent from the page');
    }
  }

  void goToSignInPage() {
        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInPage()),
            );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserErrorState) {
            showMessage(
              context,
              const Icon(Icons.error, size: 50, color: Colors.red),
              state.errorMessage,
            );
            clearFields();
          } else if (state is UserSignUpState) {
            final bool isSuccess = state.successful;
            if (isSuccess) {
              showMessage(
                context,
                const Icon(Icons.check, size: 50, color: Colors.green),
                'User signed up successfully',
              );
              clearFields();
              goToSignInPage();
            }
            else{
              showMessage(
                context,
                const Icon(Icons.error, size: 50, color: Colors.red),
                'Failed to sign up please try again',
              );
            }


            
          }
        },
        builder: (context, state) {
         

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 80.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 130,
                      decoration:  BoxDecoration(
                        boxShadow:  [ BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2.0,
                              blurRadius: 5.0,
                              offset: const Offset(0.0, 4.0),
                            ),],
                          border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          width: 1.0,     
                        ),
                    color: Colors.white, 
                    borderRadius: const  BorderRadius.all(Radius.circular(10),),
                      ),
                  ),
                    const SizedBox(height: 40),
                     Center(
                      child: Text(
                        'Sign up',
                        style: GoogleFonts.caveatBrush(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color:const  Color.fromARGB(255, 0, 0, 0),
                      ),
                      ),
                    ),
                    const SizedBox(height: 30),
                     TextField(
                      controller: _usernameController,
                      decoration: 
                      customInputDecoration(labelText: 'Name',prefixIcon:  const Icon(Icons.person,color:Color.fromARGB(255, 63, 81, 243)))
                    ),
                    const SizedBox(height: 20),
                     TextField(
                      controller: _nameController,
                      decoration: 
                      customInputDecoration(labelText: 'Username',prefixIcon:  const Icon(Icons.person,color:Color.fromARGB(255, 63, 81, 243)))
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: 

                      customInputDecoration(labelText: 'Password',prefixIcon:  const Icon(Icons.lock,color:Color.fromARGB(255, 63, 81, 243)))
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: 

                      customInputDecoration(labelText: 'Confirm Password',prefixIcon:  const Icon(Icons.lock,color:Color.fromARGB(255, 63, 81, 243)))
                    ),
                  const SizedBox(height: 40),
                  SizedBox(
                  width: double.infinity, 
                  child: ElevatedButton(    
                  onPressed: SignUpUser,
                  style: ElevatedButton.styleFrom(       
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: const  Color.fromRGBO(63, 81, 243, 1),
                    ),
                child: state is UserLoadingState
        ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        :
                 const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
            ,
            const SizedBox(height: 40,),
                    TextButton(
                onPressed: goToSignInPage,
                child: RichText(
                  text:const  TextSpan(
                    text: "If already  have an account? ",
                    style:  TextStyle(
                      color: Colors.black, 
                      fontSize: 16,
                    ),
                    children: [
                      
                      TextSpan(
                        
                        text: 'Sign in',
                        style:  TextStyle(
                          color:  Color.fromRGBO(63, 81, 243, 1), 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),


                    
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}