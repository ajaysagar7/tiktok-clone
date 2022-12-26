// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_chat_app/src/models/user_model.dart';
import 'package:flutter_chat_app/src/provider/auth_provider.dart';
import 'package:flutter_chat_app/src/provider/notification_provider.dart';
import 'package:flutter_chat_app/src/provider/validation_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_chat_app/constants/app_colors.dart';
import 'package:flutter_chat_app/src/views/auth/signin_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../constants/app_routes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false, title: const Text("Sign up")),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                SizedBox(
                  height: ScreenUtil().statusBarHeight,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextWidget(
                    title: "Welcome to Firebase Chat App",
                    color: AppColors.primaryColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextWidget(
                    title: "Sign up ",
                    color: AppColors.primaryColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 0.01.sh,
                ),
                //* image widget
                Center(
                  child: Bounce(
                    duration: const Duration(milliseconds: 100),
                    onPressed: () {
                      context.read<ValidationProvider>().pickImage();
                    },
                    child: context.watch<ValidationProvider>().isImageSelected
                        ? CircleAvatar(
                            radius: 60.r,
                            backgroundColor: Colors.grey,
                            backgroundImage: FileImage(
                                context.read<ValidationProvider>().imageFile!),
                          )
                        : CircleAvatar(
                            radius: 60.r,
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                const AssetImage("assets/images/default.png"),
                          ),
                  ),
                ),
                SizedBox(
                  height: 0.01.sh,
                ),
                Bounce(
                  duration: const Duration(milliseconds: 100),
                  onPressed: () {
                    context.read<ValidationProvider>().pickImage();
                  },
                  child: TextButton(
                      onPressed: null,
                      child: Text(
                        context.watch<ValidationProvider>().isImageSelected
                            ? "Change Profile"
                            : "Select Profile",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500),
                      )),
                ),
                SizedBox(
                  height: 0.01.sh,
                ),
                //* username widget
                CustomTextFiled(
                    errorText: null,
                    textEditingController: usernameController,
                    inputType: TextInputType.name,
                    inputAction: TextInputAction.next,
                    hintDescription: "Enter the username",
                    hintTitle: "Username"),

                //* email widget
                CustomTextFiled(
                    textEditingController: emailController,
                    inputType: TextInputType.emailAddress,
                    inputAction: TextInputAction.next,
                    hintDescription: "Enter the email",
                    hintTitle: "Email"),
                //* phone widget
                CustomTextFiled(
                    textEditingController: phoneController,
                    inputType: TextInputType.phone,
                    inputAction: TextInputAction.next,
                    hintDescription: "Enter the phone",
                    hintTitle: "Phone"),
                //* pass widget
                CustomTextFiled(
                    textEditingController: passController,
                    inputType: TextInputType.visiblePassword,
                    inputAction: TextInputAction.next,
                    hintDescription: "Enter the password",
                    hintTitle: "Password"),
                //* confirm pass widget
                CustomTextFiled(
                    textEditingController: confirmPassController,
                    inputType: TextInputType.visiblePassword,
                    inputAction: TextInputAction.next,
                    hintDescription: "Re-enter the password",
                    hintTitle: "Confrim Password"),
                SizedBox(
                  height: 0.02.sh,
                ),

                Builder(builder: (context) {
                  return CustomButton(
                    buttonTitle: 'Sign Up',
                    callback: () async {
                      String id = Uuid().v4();
                      Future<String> getDeviceToken() async {
                        final FirebaseMessaging messaging =
                            FirebaseMessaging.instance;
                        final String? token = await messaging.getToken();
                        return token!;
                      }

                      String token = await getDeviceToken();

                      UserModel userModel = UserModel(
                          userId: id,
                          deviceToken: token,
                          imageUrl: "",
                          email: emailController.text.trim(),
                          username: usernameController.text.trim(),
                          password: passController.text.trim(),
                          phone: phoneController.text.trim(),
                          createdOn:
                              DateTime.now().microsecondsSinceEpoch.toString());
                      await context
                          .read<AuthProvider>()
                          .signupFunction(
                              email: emailController.text.trim(),
                              pass: passController.text.trim(),
                              userModel: userModel)
                          .then((value) => [
                                // context.read<NotificationProvider>().sendNotification(token: value!.user["token"], title: title, body: body)
                                Navigator.pushReplacementNamed(
                                    context, Routes.signInScreen)
                              ]);
                    },
                  );
                }),
                SizedBox(),

                const CustomOrWidget(),
                CustomSizedBox(
                  size: 10.h,
                ),
                CustomBottomRow(
                  firstTitle: "Already have an account ?",
                  secondTitle: "Login",
                  callback: () {
                    Navigator.pushReplacementNamed(
                        context, Routes.signInScreen);
                  },
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}

class CustomSizedBox extends StatelessWidget {
  final double size;
  const CustomSizedBox({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
    );
  }
}

class CustomOrWidget extends StatelessWidget {
  const CustomOrWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ignore: prefer_const_constructors
        Expanded(
          child: const Divider(
            color: Colors.grey,
            height: 2,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: CustomTextWidget(title: "or"),
        ),
        Expanded(
          child: const Divider(
            color: Colors.grey,
            height: 2,
          ),
        ),
      ],
    );
  }
}

class CustomBottomRow extends StatelessWidget {
  final String firstTitle;
  final String secondTitle;
  final VoidCallback callback;
  const CustomBottomRow({
    Key? key,
    required this.firstTitle,
    required this.secondTitle,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          firstTitle,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp),
        ),
        SizedBox(
          width: 0.01.sw,
        ),
        Bounce(
          duration: const Duration(milliseconds: 120),
          onPressed: callback,
          child: Text(
            secondTitle,
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp),
          ),
        )
      ],
    );
  }
}

class CustomTextWidget extends StatelessWidget {
  final String title;
  Color? color;
  double? fontSize;
  FontWeight? fontWeight;

  CustomTextWidget({
    Key? key,
    required this.title,
    this.color,
    this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          fontSize: fontSize ?? 16.sp,
          color: color ?? Colors.black,
          fontWeight: fontWeight ?? FontWeight.w400),
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback callback;
  final String buttonTitle;
  const CustomButton({
    Key? key,
    required this.callback,
    required this.buttonTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 80),
      onPressed: callback,
      child: Container(
        alignment: Alignment.center,
        height: 0.06.sh,
        width: 0.8.sw,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: Colors.blueAccent,
        ),
        child: Text(
          buttonTitle,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class CustomTextFiled extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function(String?)? onChanged;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final String hintDescription;
  final String hintTitle;
  String? errorText;

  CustomTextFiled({
    Key? key,
    required this.textEditingController,
    this.onChanged,
    this.inputType,
    this.inputAction,
    required this.hintDescription,
    required this.hintTitle,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(hintTitle,
            style: TextStyle(fontSize: 18.sp, color: Colors.black87)),
        SizedBox(
          height: 0.01.sh,
        ),
        TextFormField(
          controller: textEditingController,
          keyboardType: inputType ?? TextInputType.text,
          textInputAction: inputAction ?? TextInputAction.next,
          decoration: InputDecoration(
              fillColor: Colors.grey.shade200,
              errorStyle: TextStyle(color: Colors.red),
              filled: true,
              // errorText: errorText ?? "",
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.r),
                  borderSide: const BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.r)),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.r)),
              hintText: hintDescription),
        ),
        SizedBox(
          height: 0.01.sh,
        )
      ],
    );
  }
}
