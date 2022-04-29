import 'package:intl/intl.dart';
import 'package:property_management/characteristics/models/characteristics.dart';

class Place {
  final String id;
  final List<Characteristics> objectItems;
  List<Characteristics>? tenantItems;
  List<Characteristics>? expensesArticleItems;
  List<List<Characteristics>>? expensesItems;
  List<List<Characteristics>>? plansItems;
  final String? createdDate;

  Place({
    required this.id,
    required this.objectItems,
    this.tenantItems,
    this.expensesArticleItems,
    this.expensesItems,
    this.plansItems,
    this.createdDate,
  });

  Map<String, dynamic> toJson() => {
    // 'objectItems': List.from(objectItems.map((item) => item.toJson())),
    // 'tenantItems': tenantItems != null
    //     ? List.from(tenantItems!.map((item) => item.toJson()))
    //     : [],
    'createdDate': createdDate,
  };

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    id: json['id'] ?? '',
    objectItems: List<Characteristics>.from(json["objectItems"].map((item) => Characteristics.fromJson(item))),
    tenantItems: json["tenantItems"] != null
        ? List<Characteristics>.from(json["tenantItems"].map((item) => Characteristics.fromJson(item)))
        : json["tenantItems"],
    expensesArticleItems: json["expensesArticleItems"] != null
        ? List<Characteristics>.from(json["expensesArticleItems"].map((item) => Characteristics.fromJson(item)))
        : json["expensesArticleItems"],
    expensesItems: json["expensesItems"] != null
        ? List<List<Characteristics>>.from(json["expensesItems"].map((expense) =>
          List<Characteristics>.from(expense.map((item) => Characteristics.fromJson(item)))))
        : json["expensesItems"],
    plansItems: json["plansItems"] != null
        ? List<List<Characteristics>>.from(json["plansItems"].map((expense) =>
          List<Characteristics>.from(expense.map((item) => Characteristics.fromJson(item)))))
        : json["plansItems"],
    createdDate: json["ownerId"],
  );

  bool isContains(String value) {
    String _value = value.toLowerCase();
    return objectItems[0].getFullValue().toLowerCase().contains(_value) ||
        objectItems[1].getFullValue().toLowerCase().contains(_value) ||
        objectItems[2].getFullValue().toLowerCase().contains(_value);
  }

  void getQuarters() {
    List<List<Characteristics>> items = expensesItems ?? [];
    items.sort((a, b) {
      DateTime dateA = DateFormat('MM.yyyy').parse(a[0].getFullValue());
      DateTime dateB = DateFormat('MM.yyyy').parse(b[0].getFullValue());
      return dateA.compareTo(dateB);
    });
  }

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
