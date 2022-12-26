import 'package:flutter/material.dart';
import 'package:flutter_chat_app/constants/app_colors.dart';
import 'package:flutter_chat_app/src/services/cloud_functions.dart';
import 'package:flutter_chat_app/src/services/realtime_functions.dart';
import 'package:flutter_chat_app/src/views/auth/signup_screen.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController controller = TextEditingController();
  bool isRealTimeDatabase = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create post"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.done,
                  maxLines: 4,
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "What's on your mind................",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Switch(
                    value: isRealTimeDatabase,
                    onChanged: (bool value) {
                      setState(() {
                        isRealTimeDatabase = value;
                      });
                    }),
                const SizedBox(
                  height: 10,
                ),
                Text(isRealTimeDatabase ? "RealTime Databse" : "Cloud Storage"),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    isRealTimeDatabase
                        ? await RealTimeFunctions
                            .createPostFromRealTimeServices(
                                value: controller.text.trim(), context: context)
                        : CloudFunctions.createPostFromCloudServices(
                            value: controller.text.toString(),
                            context: context);
                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.primaryColor),
                    child: Center(
                        child: CustomTextWidget(
                      title: "Post",
                      color: Colors.white,
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
