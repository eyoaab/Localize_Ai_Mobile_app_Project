import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loclaize_ai/core/commonFunctions/commonFunction.dart';
import 'package:loclaize_ai/core/commonWidgets/password_text_field.dart';
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

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? _emailError;
  Color _borderColorForEmail = Colors.grey;

  String? PasswordError;
  Color _borderColorForPassword = Colors.grey;

  

  void clearFields() {
    _usernameController.clear();
    _confirmPasswordController.clear();
    _passwordController.clear();
    _nameController.clear();
  }

  void signUpUser() async {
    if(_emailError != null){return;}
    final name = _nameController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showMessage(
        context,
        const Icon(Icons.info, size: 50, color: Colors.red),
        'Please enter all fields',
      );
      return;
    } else if (password != confirmPassword) {
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
      FocusScope.of(context).unfocus();
    }
  }
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }
  void goToSignInPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserErrorState) {
              showMessage(
                context,
                const Icon(Icons.error, size: 50, color: Colors.red),
                state.errorMessage,
              );
            } else if (state is UserSignUpState) {
              String message = state.message;
              final bool isSuccess = message == "User registered successfully";
              if (isSuccess) {
                clearFields();
                goToSignInPage();
                showMessage(
                  context,
                  const Icon(Icons.check, size: 50, color: Colors.green),
                  message,
                );
              } else {
                showMessage(
                  context,
                  const Icon(Icons.error, size: 50, color: Colors.red),
                  message,
                );
              }
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                   ClipRRect(
                      borderRadius: BorderRadius.circular(20.0), 
                      child: Image.asset(
                      'assets/logo1.jpg',
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover, 
                      ),
                      ),

                    Center(
                      child: Text(
                        'Sign up',
                        style: GoogleFonts.balthazar(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextField(
                      controller: _nameController,
                      decoration: customInputDecoration(
                        labelText: 'Name',
                        prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email, color: Colors.blueAccent),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _borderColorForEmail),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _borderColorForEmail), 
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      
                    ),
                     keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          _emailError = 'Please enter your email';
                          _borderColorForEmail  = Colors.red; 
                        });
                      } else if (!isValidEmail(value)) {
                        setState(() {
                          _emailError = 'Please enter a valid email address';
                         _borderColorForEmail  = Colors.red; 
                        });
                      } else {
                        setState(() {
                          _emailError = null;
                          _borderColorForEmail  = Colors.green; 
                        });
                      }
                    },

                    ),
                    const SizedBox(height: 10),
                      if (_emailError != null)
                        Text(
                        _emailError!,
                        style: const TextStyle(color: Colors.red),
                        ),
                    const SizedBox(height: 20),

                    TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible, 
                    decoration: passwordInputDecoration(
                      labelText: 'Password',
                      isPasswordVisible: _isPasswordVisible,
                      togglePasswordVisibility: _togglePasswordVisibility,
                    ),
                  ),
                    const SizedBox(height: 20),

                      TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible, 
                    decoration: passwordInputDecoration(
                      labelText: 'Confirm Password',
                      isPasswordVisible: _isConfirmPasswordVisible,
                      togglePasswordVisibility: _toggleConfirmPasswordVisibility,
                    ),
                  ),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: signUpUser,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: state is UserLoadingState
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    TextButton(
                      onPressed: goToSignInPage,
                      child: RichText(
                        text: const TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign in',
                              style: TextStyle(
                                color: Colors.blueAccent,
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
            );
          },
        ),
      ),
    );
  }
}
