class Diagnosis {
  String? diagnosis;
  double? confidence;
  String? risk;
  String? description;

  Diagnosis.fromJson(Map<String, dynamic> json)
      : diagnosis = json['diagnosis'],
        confidence = json['confidence'],
        risk = json['risk'],
        description = json['description'];
}
