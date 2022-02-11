import 'package:property_management/app/utils/utils.dart';

class Characteristics {
  final int id;
  final String title;
  final String? placeholder;
  final String? additionalInfo;
  final String type;
  final String? unit;
  final List<String>? choices;
  String? value;
  String? documentUrl;
  List<String>? details;

  Characteristics({
    required this.id,
    required this.title,
    this.placeholder,
    this.additionalInfo,
    required this.type,
    this.unit,
    this.value,
    this.documentUrl,
    this.choices,
    this.details,
  });

  factory Characteristics.fromJson(Map<String, dynamic> json) => Characteristics(
    id: json["id"],
    title: json["title"],
    placeholder: json["placeholder"],
    additionalInfo: json["additionalInfo"],
    type: json["type"],
    unit: json["unit"],
    value: json["value"],
    documentUrl: json["documentUrl"] ?? '',
    choices: json["choices"] != null
        ? List.from(json["choices"].map((choice) => choice))
        : [],
    details: json["details"] != null
        ? List.from(json["details"].map((detail) => detail))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "placeholder": placeholder,
    "additionalInfo": additionalInfo,
    "type": type,
    "unit": unit,
    "value": value,
    "documentUrl": documentUrl ?? '',
    "choices": choices ?? [],
    "details": details ?? [],
  };

  @override
  String toString() {
    return '$id $title $value';
  }

  String getFullValue () {
    if (details != null && details!.isNotEmpty) {
      String requisites = '';
      for (var i = 0; i < details!.length; i++) {
        if (details![i].isNotEmpty) {
          requisites += details![i];
          if (i != details!.length - 1){
            requisites += '\n';
          }
        }
      }
      return requisites.isEmpty ? '' : requisites;
    }
    if (value == null || value!.isEmpty) return '';
    if (type != 'Число' || title.contains('Коэффициент')) return '$value';
    return formatNumber(value ?? '0', unit);
  }

  bool isDate() {
    return title == 'Дата приобретения' || title == 'Срок действия договора';
  }

  bool showInCreating() {
    return title != 'Рыночная стоимость помещения' &&
        title != 'Фактическая Налоговая нагрузка' && title != 'Арендная плата' && title != 'Текущая аренда';
  }
}