import 'package:property_management/app/utils/utils.dart';

class Characteristics {
  final int id;
  final String title;
  final String? placeholder;
  final String? additionalInfo;
  final String type;
  final String? unit;
  String? value;
  String? documentUrl;

  Characteristics({
    required this.id,
    required this.title,
    this.placeholder,
    this.additionalInfo,
    required this.type,
    this.unit,
    this.value,
    this.documentUrl,
  });

  factory Characteristics.fromJson(Map<String, dynamic> json) => Characteristics(
    id: json["id"],
    title: json["title"],
    placeholder: json["placeholder"],
    additionalInfo: json["additionalInfo"],
    type: json["type"],
    unit: json["unit"],
    value: json["value"],
    documentUrl: json["documentUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "placeholder": placeholder,
    "additionalInfo": additionalInfo,
    "type": type,
    "unit": unit,
    "value": value,
    "documentUrl": documentUrl,
  };

  @override
  String toString() {
    return '$id $title $value';
  }

  String getFullValue () {
    if (value == null || value!.isEmpty) return '';
    if (type == 'Текст' || title.contains('Коэффициент')) return '$value';
    return formatNumber(value ?? '0', unit);
  }
}