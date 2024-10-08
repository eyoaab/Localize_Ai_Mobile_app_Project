
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
import 'package:loclaize_ai/feutures/authetication/presentation/pages/signup_page.dart';
import 'package:loclaize_ai/feutures/chat/presentation/pages/chat_page.dart';

  

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  String? _emailError;
  Color _borderColor = Colors.grey;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }
  void SignInUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if(_emailError != null){return;}
    if (username.isEmpty || password.isEmpty) {
      showMessage(
        context,
        const Icon(Icons.info, size: 50, color: Colors.red),
        'እባክዎ ሁሉንም መስኮች ያስገቡ',
      );
      return;
    } else {
      UserEntity user = UserEntity(
        name: '',
        username: username,
        password: password,
      );
      context.read<UserBloc>().add(SignInEvent(user: user));
      FocusScope.of(context).unfocus();

    }
  }
  void goToSignUpPage() {
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),
      );
  }
  void goToChatPage(String name, String email) {
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChatPage(name: name,email:email,)),
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
              _usernameController.clear();
              _passwordController.clear();
            } else if (state is UserLoggedInState) {
              final userData = state.userData;
              if (userData.isError){
                showMessage(
                context,
                const Icon(Icons.error, size: 50, color: Colors.red),
                userData.message,
              );      
              }else{
              goToChatPage(userData.name,userData.username);  
      
              }
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                      borderRadius: BorderRadius.circular(20.0), 
                      child: Image.asset(
                      'assets/logo1.jpg',
          
                      fit: BoxFit.cover, 
                      ),
                      )
,
                      // Image.asset('logo.png'),
      
                       Center(
                        child: Text(
                          'ወደ መለያዎ ይግቡ',
                          style: GoogleFonts.balthazar(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color:const  Color.fromARGB(255, 0, 0, 0),
                        ),
                        ),
                      ),
                      const SizedBox(height: 30),
                       TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                      labelText: 'ኢሜይል',
                      prefixIcon: const Icon(Icons.email, color: Colors.blueAccent),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _borderColor), 
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
                          _emailError = 'እባክህ ኢሜል አስገባ';
                          _borderColor = Colors.red; 
                        });
                      } else if (!isValidEmail(value)) {
                        setState(() {
                          _emailError = 'እባክህን ትክክለኛ ኢሜል አስገባ';
                          _borderColor = Colors.red; 
                        });
                      } else {
                        setState(() {
                          _emailError = null;
                          _borderColor = Colors.green; 
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
                        labelText: 'የይለፍ ቃል',
                        isPasswordVisible: _isPasswordVisible,
                        togglePasswordVisibility: _togglePasswordVisibility,),
                      ),

                    const SizedBox(height: 40),
                    SizedBox(
                    width: double.infinity, 
                    child: ElevatedButton(    
                    onPressed: SignInUser,
                    style: ElevatedButton.styleFrom(       
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: state is UserLoadingState
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          :
                   const Text(
                    'ይግቡ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                    ),
                  ),
                ),
              )
              ,
              const SizedBox(height: 20,),
                      TextButton(
                  onPressed: goToSignUpPage,
                  child: RichText(
                    text:const  TextSpan(
                      text: "መለያ የለህም? ",
                      style:  TextStyle(
                        color: Colors.black, 
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: 'ይመዝገቡ',
                          style:  TextStyle(
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
              ),
            );
          },
        ),
      ),
    );
  }
}