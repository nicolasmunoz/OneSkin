import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

class TutorialView extends StatefulWidget {
  void Function() onPressed;
  TutorialView({super.key, required this.onPressed});

  @override
  State<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  int page = 0;

  List<Widget> tutorialPages = [
    Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 50),
              color: Colors.red,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: Text(
              'Take photo in well-lit room with mole fully visible in the photo',
              textAlign: TextAlign.center,
              softWrap: true,
            ))
          ],
        )),
    Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 50),
              color: Colors.red,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: Text(
              'Remove any objects covering the mole (hair, jewelry, etc)',
              textAlign: TextAlign.center,
              softWrap: true,
            ))
          ],
        )),
    Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 50),
            color: Colors.red,
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: Text(
            'Place mole in center of the square and take photo',
            textAlign: TextAlign.center,
            softWrap: true,
          ))
        ],
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: CloseButton(onPressed: () {
              widget.onPressed();
              Navigator.of(context, rootNavigator: true).pop();
            }),
          ),
          SizedBox(
              height: size.height * 0.5,
              width: size.width,
              child: PageView(
                onPageChanged: changePage,
                children: tutorialPages,
              )),
          Padding(
            padding: const EdgeInsets.all(20),
            child: PageViewDotIndicator(
              currentItem: page,
              count: 3,
              unselectedColor: const Color(0xFFD9D9D9),
              selectedColor: const Color(0xFF185A7F),
            ),
          )
        ],
      ),
    );
  }

  void changePage(int newPage) => setState(() => page = newPage);
}
