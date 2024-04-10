import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:one_skin/models/diagnosis_model.dart';
import 'package:one_skin/services/http_service.dart';

class ResultsView extends StatefulWidget {
  final XFile image;
  const ResultsView({super.key, required this.image});

  @override
  State<ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends State<ResultsView> {
  bool _loading = true;
  Diagnosis? diagnosis;

  @override
  void initState() {
    processImage();
    super.initState();
  }

  Future<void> processImage() async {
    setState(() {
      _loading = true;
    });

    Response response = await HttpService.postImage(widget.image);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      setState(() {
        diagnosis = Diagnosis.fromJson(body);
      });
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _loading ? _buildLoading() : _buildResults(),
    );
  }

  Widget _buildLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.5,
            child: CircularProgressIndicator(),
          ),
        ),
        Text(
          'Analyzing image...',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        )
      ],
    );
  }

  Widget _buildResults() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: AspectRatio(
              aspectRatio: 1, // Set aspect ratio to 1:1 for a square
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.hardEdge,
                child: Image.file(
                  File(widget.image.path),
                  fit: BoxFit.cover,
                ),
              )),
        ),
        Container(
          child: Text(diagnosis?.diagnosis ?? 'No Diagnosis Available'),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
