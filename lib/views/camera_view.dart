import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:one_skin/components/tutorial_view.dart';
import 'package:one_skin/services/http_service.dart';
import 'package:one_skin/views/photo_review_view.dart';
import 'package:one_skin/views/results_view.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  CameraViewState createState() => CameraViewState();
}

class CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  late final List<CameraDescription> _cameras;

  bool _showTutorial = false;

  double _currentScale = 1.0;
  double _baseScale = 1.0;
  double _maxScale = 10;

  @override
  void initState() {
    initCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCameraInitialized) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  _toggleTutorial();
                  showDialog(
                      context: context,
                      builder: (_) => TutorialView(
                            onPressed: _toggleTutorial,
                          ));
                },
                icon: Icon(Icons.question_mark))
          ],
        ),
        body: SafeArea(child: _buildView()),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  void _toggleTutorial() => setState(() {
        _showTutorial = !_showTutorial;
      });

  Widget _buildView() {
    return Column(children: [
      SizedBox(
        height: 50,
      ),
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              child: ModalRoute.of(context)?.isCurrent ?? false
                  ? _buildCameraView()
                  : Container())),
      Spacer(),
      _buildButton(),
      SizedBox(
        height: 50,
      ),
      Text('Tap camera button when ready')
    ]);
  }

  Widget _buildCameraView() {
    return Stack(
      children: [
        GestureDetector(
            onScaleStart: _handleScaleStart,
            onScaleUpdate: _handleScaleUpdate,
            child: AspectRatio(
              aspectRatio: 1, // Set aspect ratio to 1:1 for a square
              child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                      width: _controller!.value.previewSize?.height,
                      height: _controller!.value.previewSize?.width,
                      child: CameraPreview(
                        _controller!,
                      ))),
            )),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RotatedBox(
                  quarterTurns: -1,
                  child: Slider(
                    min: 1,
                    max: _maxScale,
                    onChanged: _handleSliderUpdate,
                    value: _currentScale,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleSliderUpdate(double value) async {
    setState(() {
      _currentScale = value;
    });

    await _controller!.setZoomLevel(_currentScale);
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    _currentScale = (_baseScale * details.scale).clamp(1, _maxScale);

    await _controller!.setZoomLevel(_currentScale);
  }

  Widget _buildButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          height: 80,
          width: 80,
          child: FittedBox(
              child: FloatingActionButton(
            onPressed: _showTutorial ? null : _onTakePhotoPressed,
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          ))),
    );
  }

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    // Initialize the camera with the first camera in the list
    await onNewCameraSelected(_cameras.first);
  }

  Future<void> onNewCameraSelected(CameraDescription description) async {
    final previousCameraController = _controller;

    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      description,
      ResolutionPreset.ultraHigh,
      imageFormatGroup: ImageFormatGroup.jpeg,
    )..setFocusMode(FocusMode.auto);

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      debugPrint('Error initializing camera: $e');
    }
    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Get max zoom level
    double maxZoom = await cameraController.getMaxZoomLevel();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        _controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = _controller!.value.isInitialized;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  Future<XFile?> capturePhoto() async {
    final CameraController? cameraController = _controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      await cameraController.setFlashMode(FlashMode.torch); //optional
      XFile file = await cameraController.takePicture();
      await cameraController.setFlashMode(FlashMode.off); //optional
      return file;
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  void _onTakePhotoPressed() async {
    final navigator = Navigator.of(context);
    final image = await capturePhoto();
    if (image != null) {
      navigator.push(
        MaterialPageRoute(
          builder: (context) => PhotoReviewView(
            image: image,
          ),
        ),
      );
    }
  }
}
