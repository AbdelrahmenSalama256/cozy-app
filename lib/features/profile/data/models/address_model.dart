class AddressModel {
  final String id;
  final String title;
  final String name;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  bool isDefault;

  AddressModel({
    required this.id,
    required this.title,
    required this.name,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
  });

  AddressModel copyWith({
    String? id,
    String? title,
    String? name,
    String? phone,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      title: title ?? this.title,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  String get fullAddress => '$street, $city, $state $zipCode, $country';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'name': name,
      'phone': phone,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      title: json['title'],
      name: json['name'],
      phone: json['phone'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      country: json['country'],
      isDefault: json['isDefault'] ?? false,
    );
  }
}
