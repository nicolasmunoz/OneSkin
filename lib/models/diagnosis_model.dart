class Diagnosis {
  String? diagnosis;
  double? confidence;

  Diagnosis.fromJson(Map<String, dynamic> json)
      : diagnosis = json['diagnosis'],
        confidence = json['confidence'];
}
