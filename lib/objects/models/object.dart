class Object {
  final String address; /// Адрес объекта
  final String area; /// Площадь объекта
  final String owner; /// Собственник
  final String initialCost; /// Начальная стоимость
  final String? purchaseDate; /// Дата приобретения
  final String? name; /// Название объекта
  final int? powerElectricity; /// Выделенная мощность (электричество)
  final int? powerHeat; /// Выделенная мощность (электричество)
  final int? cadastralNumber; /// Кадастровый номер
  final String? cadastralPrice; /// Кадастровая стоимость
  final String? contract; /// Договор ХВС ГВС ВО
  final String? taxSystem; /// Система налогообложения (УСН,Патент)
  final String? taxBurden; /// Фактическая Налоговая нагрузка. Считается как сумма из эксплуатации по строке Налоги за последние 12 месяцев / на строку из эксплуатации «текущая арендная плата» за последние 12 месяцев;
  final String? rent; /// Арендная плата
  final double? capitalizationRatio; /// Коэффициент капитализации

  Object({
    required this.address,
    required this.area,
    required this.owner,
    required this.initialCost,
    this.purchaseDate,
    this.name,
    this.powerElectricity,
    this.powerHeat,
    this.cadastralNumber,
    this.cadastralPrice,
    this.contract,
    this.taxSystem,
    this.taxBurden,
    this.rent,
    this.capitalizationRatio,
  });
}
