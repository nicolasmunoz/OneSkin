import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:one_skin/components/tutorial_view.dart';
import 'package:one_skin/services/http_service.dart';
import 'package:one_skin/views/results_view.dart';
import 'package:super_bullet_list/bullet_list.dart';

class PhotoReviewView extends StatefulWidget {
  final XFile image;
  const PhotoReviewView({super.key, required this.image});

  @override
  PhotoReviewViewState createState() => PhotoReviewViewState();
}

class PhotoReviewViewState extends State<PhotoReviewView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Photo'),
      ),
      body: SafeArea(
        child: _buildView(),
        minimum: EdgeInsets.all(20),
      ),
    );
  }

  Widget _buildView() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Review photo before submission',
                    textAlign: TextAlign.left,
                  )),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tips for best results:',
                    textAlign: TextAlign.left,
                  ),
                )),
            SizedBox(
              height: 30,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SuperBulletList(
                  items: [
                    Text('Is taken in a well-lit room'),
                    Text('Mole is fully visible in the frame'),
                    Text(
                        'No objects are obstructing the view (jewelry, hair, etc)'),
                  ],
                )),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Retake')),
                  FilledButton(
                      onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ResultsView(
                                image: widget.image,
                              ),
                            ),
                          ),
                      child: Text('Use Photo'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
