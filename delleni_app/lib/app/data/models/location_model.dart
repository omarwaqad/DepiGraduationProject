class LocationModel {
  final String id;
  final String serviceId;
  final String name;
  final String address;
  final double? lat;
  final double? lng;

  LocationModel({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.address,
    this.lat,
    this.lng,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id']?.toString() ?? '',
      serviceId: map['service_id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      lat: (map['lat'] as num?)?.toDouble(),
      lng: (map['lng'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'service_id': serviceId,
      'name': name,
      'address': address,
      'lat': lat,
      'lng': lng,
    };
  }

  bool get hasCoordinates => lat != null && lng != null;

  LocationModel copyWith({
    String? id,
    String? serviceId,
    String? name,
    String? address,
    double? lat,
    double? lng,
  }) {
    return LocationModel(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      name: name ?? this.name,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}
