import 'package:flutter/material.dart';
import 'package:one_skin/views/camera_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FilledButton(
              onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      settings: const RouteSettings(name: 'cameraView'),
                      builder: (context) => const CameraView(),
                    ),
                  ),
              child: const Text('Get Started'))
        ],
      ),
    );
  }
}
