import 'package:flutter/material.dart';
import 'package:one_skin/constants/constants.dart';
import 'package:one_skin/models/diagnosis_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ResultsWidget extends StatefulWidget {
  final Diagnosis? diagnosis;
  const ResultsWidget({super.key, required this.diagnosis});

  @override
  State<ResultsWidget> createState() => _ResultsWidgetState();
}

class _ResultsWidgetState extends State<ResultsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          direction: Axis.horizontal,
          children: [
            Flexible(
                fit: FlexFit.tight,
                child: _buildContainer('Assessment', _buildDiagnosisResult(),
                    height: 150)),
            SizedBox(width: 10),
            Flexible(
                fit: FlexFit.tight,
                child: _buildContainer('Confidence', _buildConfidenceResult(),
                    height: 150)),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
                fit: FlexFit.tight,
                child: _buildContainer(
                    'Risk Interpretation', _buildDiagnosisDescription())),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
                fit: FlexFit.tight,
                child: _buildContainer(
                    'Recommendation', _buildDiagnosisRecommendation())),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        _buildProviderButton(),
        SizedBox(height: 80)
      ],
    );
  }

  // Build the standard container with padding and correct color for consistency
  Widget _buildContainer(String title, Widget content, {double? height}) {
    return Container(
        padding: EdgeInsets.all(20),
        height: height,
        decoration: BoxDecoration(
            color: Color(4279967779), borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(
              height: 10,
            ),
            content,
          ],
        ));
  }

  // Build the diagnosis result block
  Widget _buildDiagnosisDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          widget.diagnosis?.risk ?? 'Retake Photo',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(widget.diagnosis?.description ??
            'The image couldn\'t be analyzed appropriately. Please retake the image with better lighting, and make sure the image is focused.')
      ],
    );
  }

  // Build the diagnosis result block
  Widget _buildDiagnosisRecommendation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Images.recommendationImage,
            const SizedBox(width: 5),
            const Text(
              'Continue to Monitor',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        const Text(
            'We recommend to continue to monitor for changes in size, texture, color and bleeding. Consult your healthcare provider if any of these changes occur. Repeat scan monthly.')
      ],
    );
  }

  // Build the testing reminder
  Widget _buildDiagnosisResult() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Images.diagnosisImage,
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  widget.diagnosis?.risk ?? 'Uncertain Risk',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                  softWrap: true,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Build the confidence result block
  Widget _buildConfidenceResult() {
    return Center(
      child: CircularPercentIndicator(
        arcType: ArcType.FULL,
        arcBackgroundColor: ThemeColors.darkBackground,
        progressColor: Theme.of(context).colorScheme.primary,
        radius: 40,
        lineWidth: 2,
        percent: widget.diagnosis?.confidence ?? 0,
        center: Text(
          '${((widget.diagnosis?.confidence ?? 0) * 100).round()}%',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildProviderButton() {
    return FilledButton(
        onPressed: () => null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Images.doubleArrow,
            const SizedBox(width: 5),
            const Text('Share Results with Healthcare Provider')
          ],
        ));
  }
}
