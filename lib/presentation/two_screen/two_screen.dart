import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../presentation/one_screen/one_screen.dart';
import '../../presentation/three_screen/three_screen.dart';
import '../loading_screen/loading_screen.dart';

class TwoScreen extends StatelessWidget {
  TwoScreen({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<void> signUpUser(BuildContext context) async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String phone = phoneNumberController.text.trim();

    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const LoadingScreen(),
    );

    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Store user information in Firestore
        await _database.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'phone': phone,
        });

        Navigator.pop(context); // Close loading dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ThreeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Sign Up Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: SizeUtils.width,
          height: SizeUtils.height,
          decoration: BoxDecoration(
            color: appTheme.pink5001,
            image: DecorationImage(
              image: AssetImage(ImageConstant.imgOne),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 59.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildHeader(),
                      _buildNameSection(context),
                      _buildEmailSection(context),
                      _buildPasswordSection(context),
                      _buildPhoneNumberSection(context),
                      SizedBox(height: 34.v),
                      CustomOutlinedButton(
                        width: 215.h,
                        text: "Sign Up",
                        buttonStyle: CustomButtonStyles.outlineBlueGray,
                        alignment: Alignment.center,
                        onPressed: () => signUpUser(context),
                      ),
                      _buildSignInLink(context),
                      _buildTermsText(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 209.h,
          height: 80.v,
          margin: EdgeInsets.only(left: 1.h),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Get started\n",
                  style: theme.textTheme.displaySmall?.copyWith(fontSize: 26.0),
                ),
                TextSpan(
                  text: " ",
                  style: CustomTextStyles.headlineMediumSemiBold,
                )
              ],
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 220.h,
            height: 50.v,
            child: Text(
              "Create a new account\n ",
              maxLines: null,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium!,
            ),
          ),
        ),
        SizedBox(height: 22.v),
      ],
    );
  }

  Widget _buildNameSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Your Name", style: theme.textTheme.bodyMedium),
          SizedBox(height: 8.v),
          CustomTextFormField(
            controller: nameController,
            hintText: "Your name",
          ),
          SizedBox(height: 11.v),
        ],
      ),
    );
  }

  Widget _buildEmailSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Email", style: theme.textTheme.bodyMedium),
          SizedBox(height: 8.v),
          CustomTextFormField(
            controller: emailController,
            hintText: "you@example.com",
            textInputType: TextInputType.emailAddress,
          ),
          SizedBox(height: 11.v),
        ],
      ),
    );
  }

  Widget _buildPasswordSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Password", style: theme.textTheme.bodyMedium),
          SizedBox(height: 7.v),
          CustomTextFormField(
            controller: passwordController,
            obscureText: true,
          ),
          SizedBox(height: 12.v),
        ],
      ),
    );
  }

  Widget _buildPhoneNumberSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Phone Number", style: theme.textTheme.bodyMedium),
          SizedBox(height: 8.v),
          CustomTextFormField(
            controller: phoneNumberController,
            hintText: "+8801XXXXXXXXX",
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  Widget _buildSignInLink(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OneScreen()),
          );
        },
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: "Have an account? ", style: theme.textTheme.bodyMedium),
              TextSpan(
                text: "Sign In Now",
                style: theme.textTheme.bodyMedium!.copyWith(decoration: TextDecoration.underline),
              ),
            ],
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _buildTermsText() {
    return Padding(
      padding: EdgeInsets.only(top: 90.v),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 290.h,
          margin: EdgeInsets.symmetric(horizontal: 10.h),
          child: Text(
            "By continuing, you agree to Health Nourish's Terms of Service and Privacy Policy, and to receive periodic emails with updates.",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
