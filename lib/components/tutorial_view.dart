import 'package:flutter/material.dart';
import 'package:one_skin/constants/constants.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

class TutorialView extends StatefulWidget {
  final void Function() onPressed;
  final bool showDisclosure;
  const TutorialView(
      {super.key, required this.onPressed, required this.showDisclosure});

  @override
  State<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  int page = 0;
  int maxPages = 2;
  late bool showDisclosure;

  @override
  void initState() {
    showDisclosure = widget.showDisclosure;
    super.initState();
  }

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
        child: showDisclosure ? _buildDisclosure() : _buildTutorial());
  }

  Widget _buildDisclosure() {
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 40),
        SizedBox(
            height: size.height * 0.5,
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Disclosure',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Text(
                    'The advice provided by this app is not a substitute for professional medical guidance and should be used for informational purposes only.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            )),
        Padding(
          padding: const EdgeInsets.all(20),
          child: FilledButton(
            onPressed: () => setState(() {
              showDisclosure = false;
            }),
            child: const Text('I Understand'),
          ),
        )
      ],
    );
  }

  Widget _buildTutorial() {
    var size = MediaQuery.of(context).size;
    return Column(
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
    );
  }

  void close() {
    widget.onPressed();
    Navigator.of(context, rootNavigator: true).pop();
  }

  void changePage(int newPage) => setState(() => page = newPage);
}
