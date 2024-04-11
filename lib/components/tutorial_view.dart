import 'package:flutter/material.dart';
import 'package:one_skin/constants/constants.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

class TutorialView extends StatefulWidget {
  final void Function() onPressed;
  const TutorialView({super.key, required this.onPressed});

  @override
  State<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  int page = 0;
  int maxPages = 2;

  List<Widget> tutorialPages = [
    Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Images.tutorial1,
            const SizedBox(
              height: 20,
            ),
            const Expanded(
                child: Text(
              'Take photo in well-lit room with mole fully visible in the photo',
              textAlign: TextAlign.center,
              softWrap: true,
            ))
          ],
        )),
    Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Images.tutorial2,
            const SizedBox(
              height: 20,
            ),
            const Expanded(
                child: Text(
              'Remove any objects covering the mole (hair, jewelry, etc)',
              textAlign: TextAlign.center,
              softWrap: true,
            ))
          ],
        )),
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: ThemeColors.darkBackground,
      surfaceTintColor: ThemeColors.darkBackground,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: CloseButton(onPressed: close),
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
            child: page == 1
                ? FilledButton(
                    onPressed: close,
                    child: const Text('Get Started'),
                  )
                : PageViewDotIndicator(
                    currentItem: page,
                    count: maxPages,
                    unselectedColor: const Color(0xFFD9D9D9),
                    selectedColor: Theme.of(context).colorScheme.primary,
                  ),
          )
        ],
      ),
    );
  }

  void close() {
    widget.onPressed();
    Navigator.of(context, rootNavigator: true).pop();
  }

  void changePage(int newPage) => setState(() => page = newPage);
}
