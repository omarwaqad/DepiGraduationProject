class ServiceModel {
  final String id;
  final String serviceName;
  final List<String> requiredPapers;
  final List<String> steps;
  final DateTime? createdAt;

  ServiceModel({
    required this.id,
    required this.serviceName,
    required this.requiredPapers,
    required this.steps,
    this.createdAt,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    List<String> toStrList(dynamic value) {
      if (value == null) return [];
      if (value is List) return value.map((e) => e.toString()).toList();
      if (value is String) {
        final cleaned = value.replaceAll('{', '').replaceAll('}', '');
        if (cleaned.trim().isEmpty) return [];
        return cleaned
            .split(',')
            .map((x) => x.trim().replaceAll('"', ''))
            .toList();
      }
      return [value.toString()];
    }

    return ServiceModel(
      id: map['id']?.toString() ?? '',
      serviceName: map['service_name']?.toString() ?? '',
      requiredPapers: toStrList(map['required_papers']),
      steps: toStrList(map['steps']),
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'service_name': serviceName,
      'required_papers': requiredPapers,
      'steps': steps,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  int get totalSteps => steps.length;
  bool get hasSteps => steps.isNotEmpty;
  bool get hasRequiredPapers => requiredPapers.isNotEmpty;

  ServiceModel copyWith({
    String? id,
    String? serviceName,
    List<String>? requiredPapers,
    List<String>? steps,
    DateTime? createdAt,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      requiredPapers: requiredPapers ?? this.requiredPapers,
      steps: steps ?? this.steps,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
