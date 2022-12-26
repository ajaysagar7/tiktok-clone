import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/provider/auth_provider.dart';
import 'package:flutter_chat_app/src/provider/validation_provider.dart';
import 'package:flutter_chat_app/src/views/auth/signup_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_routes.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Signin Screen"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child:
                  Consumer<ValidationProvider>(builder: (context, provider, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* logo
                    Center(
                      child: FlutterLogo(
                        size: 0.2.h,
                      ),
                    ),
                    //* email widget
                    CustomTextFiled(
                        // errorText: provider.emailModel.error,
                        errorText: "",
                        onChanged: (val) {
                          // provider.emailValidation(value: val!);
                        },
                        textEditingController: emailController,
                        hintDescription: "Enter your email address",
                        hintTitle: "Email"),

                    SizedBox(
                      height: 0.02.sh,
                    ),
                    //* password widget
                    CustomTextFiled(
                      onChanged: (String? val) {},
                      // errorText: provider.passModel.error,
                      errorText: null,
                      textEditingController: passwordController,
                      hintDescription: "Enter your password",
                      hintTitle: "Password",
                      inputType: TextInputType.visiblePassword,
                      inputAction: TextInputAction.done,
                    ),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    Center(
                        child: CustomButton(
                            callback: () async {
                              await context
                                  .read<AuthProvider>()
                                  .loginFunction(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim())
                                  .then((value) =>
                                      Navigator.pushReplacementNamed(
                                          context, Routes.homeScreen));
                            },
                            buttonTitle:
                                context.read<AuthProvider>().isSignInLoadig
                                    ? "Loading"
                                    : "Sign In")),

                    CustomSizedBox(size: 10.h),
                    const CustomOrWidget(),
                    CustomSizedBox(size: 10.h),
                    CustomBottomRow(
                        firstTitle: "Don't have an account?",
                        secondTitle: "Sign up",
                        callback: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (c) {
                            return SignupScreen();
                          }));
                        })
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
