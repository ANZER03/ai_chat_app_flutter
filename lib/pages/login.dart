import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for the text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to handle login
  void _handleLogin() {
    // TODO: Implement login functionality
    print('Username: ${_usernameController.text}');
    print('Password: ${_passwordController.text}');
  }

  // Function to handle skip login
  void _handleSkip() {
    // Navigate to chat page
    Navigator.pushReplacementNamed(context, '/chat');
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final horizontalPadding = screenSize.width * 0.08; // Responsive padding

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F5),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenSize.height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _handleSkip,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white.withOpacity(0.3),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Skip",
                              style: GoogleFonts.ubuntu(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF7d7c73),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Color(0xFF7d7c73),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.08),
                Center(
                  child: Image.asset(
                    "assets/images/logo-anzer.png",
                    width: 180,
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.03),
                Center(
                  child: Text(
                    "Build Your Dream with Anzer",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ubuntu(
                      fontSize: screenSize.width * 0.09,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF151514),
                      height: 1.1,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Experience the Future of AI Conversation",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF7d7c73),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.05),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _usernameController,
                    style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      color: const Color(0xFF333333),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Username, email or mobile number',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: 'Username, email or mobile number',
                      hintStyle: GoogleFonts.ubuntu(
                        fontSize: 16,
                        color: const Color(0xFFAAAAAA),
                        fontWeight: FontWeight.w300,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFE4E4E2),
                          width: 0.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFE4E4E2),
                          width: 0.8,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFE4E4E2),
                          width: 0.8,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFCFCFD),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      color: const Color(0xFF333333),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: 'Password',
                      hintStyle: GoogleFonts.ubuntu(
                        fontSize: 16,
                        color: const Color(0xFFAAAAAA),
                        fontWeight: FontWeight.w300,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFE4E4E2),
                          width: 0.8,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFE4E4E2),
                          width: 0.8,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFE4E4E2),
                          width: 0.8,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFCFCFD),
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF141313),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: Text(
                      'Log In',
                      style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Forgot password?",
                        style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF7d7c73),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Reset it",
                        style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF141313),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenSize.height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
