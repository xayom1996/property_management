import 'package:property_management/characteristics/models/characteristics.dart';

class Place {
  final List<Characteristics> objectItems;
  List<Characteristics>? tenantItems;
  final String? ownerId;
  final String? createdDate;

  Place({
    required this.objectItems,
    this.tenantItems,
    this.ownerId,
    this.createdDate,
  });

  Map<String, dynamic> toJson() => {
    'objectItems': List.from(objectItems.map((item) => item.toJson())),
    'tenantItems': tenantItems != null
        ? List.from(tenantItems!.map((item) => item.toJson()))
        : [],
    'ownerId': ownerId,
    'createdDate': createdDate,
  };

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    objectItems: List<Characteristics>.from(json["objectItems"].map((item) => Characteristics.fromJson(item))),
    tenantItems: json["tenantItems"] != null
        ? List<Characteristics>.from(json["tenantItems"].map((item) => Characteristics.fromJson(item)))
        : json["tenantItems"],
    ownerId: json["ownerId"],
    createdDate: json["ownerId"],
  );
}

// class Object {
//   final List<Characteristics> characteristics;
//   final String address; /// Адрес объекта
//   final String area; /// Площадь объекта
//   final String owner; /// Собственник
//   final String initialCost; /// Начальная стоимость
//   final String? purchaseDate; /// Дата приобретения
//   final String? name; /// Название объекта
//   final int? powerElectricity; /// Выделенная мощность (электричество)
//   final int? powerHeat; /// Выделенная мощность (электричество)
//   final int? cadastralNumber; /// Кадастровый номер
//   final String? cadastralPrice; /// Кадастровая стоимость
//   final String? contract; /// Договор ХВС ГВС ВО
//   final String? taxSystem; /// Система налогообложения (УСН,Патент)
//   final String? taxBurden; /// Фактическая Налоговая нагрузка. Считается как сумма из эксплуатации по строке Налоги за последние 12 месяцев / на строку из эксплуатации «текущая арендная плата» за последние 12 месяцев;
//   final String? rent; /// Арендная плата
//   final double? capitalizationRatio; /// Коэффициент капитализации
//
//   Object({
//     required this.address,
//     required this.area,
//     required this.owner,
//     required this.initialCost,
//     this.purchaseDate,
//     this.name,
//     this.powerElectricity,
//     this.powerHeat,
//     this.cadastralNumber,
//     this.cadastralPrice,
//     this.contract,
//     this.taxSystem,
//     this.taxBurden,
//     this.rent,
//     this.capitalizationRatio,
//   });
// }
