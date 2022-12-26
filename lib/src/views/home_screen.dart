import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/views/cloud_screen.dart';
import 'package:flutter_chat_app/src/views/realtime_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home Screen"),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const CloudStorageScreen()));
                  },
                  child: const Center(
                    child: Text("Cloud Storage"),
                  )),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const RealTimeStorageScreen()));
                  },
                  child: const Center(
                    child: Text("Realtime Database Storage"),
                  )),
            ],
          ),
        )),
      ),
    );
  }
}
