
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

String validateEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty || !regex.hasMatch(value))
    return 'Enter a valid email address';
  else
    return '';
}

double horizontalPadding(BuildContext context, double landscapePadding, {double portraitPadding = 24}) {
  if (MediaQuery.of(context).orientation == Orientation.portrait) {
    return portraitPadding;
  }
  return landscapePadding;

  // if (ScreenUtil().orientation == Orientation.portrait){
  //   return portraitPadding;
  // }
  // return landscapePadding;
}

List<Map> characteristicItems = [
  {'title': 'Название характеристики', 'placeholder': 'Введите название характеристике'},
  {'title': 'Дополнительная информация', 'placeholder': 'Введите дополнительную информацию'},
  {'title': 'Тип характеристики', 'placeholder': 'Выберите тип характеристики', 'items': ['Число', 'Текст']},
  {'title': 'Единицы измерения', 'placeholder': 'Выберите единицы измерения', 'items': ['Рубли - ₽', 'Метры квадратные - Кв.м', 'Процент - %', 'Штука - Шт.', 'Киловатт - кВт']},
];

List<Map> objectItems = [
  {'title': 'Название объекта', 'placeholder': 'Введите название объекта', 'type': 'Текст', 'unit': ''},
  {'title': 'Адрес объекта', 'placeholder': 'Введите адрес объекта', 'type': 'Текст', 'unit': ''},
  {'title': 'Площадь объекта', 'placeholder': 'Введите площадь объекта', 'type': 'Число', 'unit': 'кв.м'},
  {'title': 'Собственник', 'placeholder': 'Введите собственника', 'type': 'Текст', 'unit': ''},
  {'title': 'Выделенная мощность (электричество)', 'placeholder': 'Введите выделенную мощность', 'type': 'Число', 'unit': 'кВт'},
  {'title': 'Выделенная мощность (тепло) ', 'placeholder': 'Введите выделенную мощность', 'type': 'Число', 'unit': 'кВт'},
  {'title': 'Начальная стоимость', 'placeholder': 'Введите начальную стоимость', 'type': 'Число', 'unit': '₽'},
  {'title': 'Дата приобретения', 'placeholder': 'Введите дату приобретения', 'type': 'Текст', 'unit': ''},
  {'title': 'Кадастровый номер', 'placeholder': 'Введите кадастровый номер', 'type': 'Число', 'unit': ''},
  {'title': 'Кадастровая стоимость', 'placeholder': 'Введите кадастровую стоимость', 'type': 'Число', 'unit': '₽'},
  {'title': 'Договор водоснабжения', 'placeholder': 'Введите договор водоснабжения', 'type': 'Текст', 'unit': ''},
  {'title': 'Система налогообложения', 'placeholder': 'Введите систему налогообложения', 'type': 'Текст', 'unit': ''},
  {'title': 'Фактическая Налоговая нагрузка', 'placeholder': 'Введите налоговую нагрузку', 'type': 'Число', 'unit': '₽'},
  {'title': 'Арендная плата', 'placeholder': 'Введите арендную плата', 'type': 'Число', 'unit': '₽'},
  {'title': 'Коэффициент капитализации', 'placeholder': 'Введите коэффициент капитализации', 'type': 'Число', 'unit': ''},
];

List<Map> objectItemsFilled = [
  {'title': 'Название объекта', 'placeholder': 'Введите название объекта', 'value': 'ЖК Акваленд, 3-к'},
  {'title': 'Адрес объекта', 'placeholder': 'Введите адрес объекта', 'value': 'г. Новосибирск, Ленинградский пр-т, 124'},
  {'title': 'Площадь объекта', 'placeholder': 'Введите площадь объекта', 'value': '96'},
  {'title': 'Собственник', 'placeholder': 'Введите собственника', 'value': 'УК Смарт'},
  {'title': 'Выделенная мощность (электричество)', 'placeholder': 'Введите выделенную мощность', 'value': '2'},
  {'title': 'Выделенная мощность (тепло) ', 'placeholder': 'Введите выделенную мощность', 'value': '2'},
  {'title': 'Начальная стоимость', 'placeholder': 'Введите начальную стоимость', 'value': '1000000'},
  {'title': 'Дата приобретения', 'placeholder': 'Введите дату приобретения', 'value': '07.05.2021'},
  {'title': 'Кадастровый номер', 'placeholder': 'Введите кадастровый номер', 'value': ''},
  {'title': 'Кадастровая стоимость', 'placeholder': 'Введите кадастровую стоимость', 'value': '900000'},
  {'title': 'Договор водоснабжения', 'placeholder': 'Введите договор водоснабжения', 'value': 'Договор от 12.04.14'},
  {'title': 'Система налогообложения', 'placeholder': 'Введите систему налогообложения', 'value': 'Патент'},
  {'title': 'Фактическая Налоговая нагрузка', 'placeholder': 'Введите налоговую нагрузку', 'value': '10000'},
  {'title': 'Арендная плата', 'placeholder': 'Введите арендную плата', 'value': '30000'},
  {'title': 'Коэффициент капитализации', 'placeholder': 'Введите коэффициент капитализации', 'value': '1.2'},
];

List objects = [
  {'name': 'ЖК Акваленд, 3-к', 'address': 'г. Новосибирск, Ленинградский пр-т, 124', 'area': '96 кв.м.'},
  {'name': 'ЖК Акваленд, 3-к', 'address': 'г. Новосибирск, Ленинградский пр-т, 124', 'area': '96 кв.м.', 'color': 0xffFF0000},
  {'name': 'ЖК Акваленд, 3-к', 'address': 'г. Новосибирск, Ленинградский пр-т, 124', 'area': '96 кв.м.'},
  {'name': 'ЖК Акваленд, 3-к', 'address': 'г. Новосибирск, Ленинградский пр-т, 124', 'area': '96 кв.м.', 'color': 0xff40CD0F},
  {'name': 'ЖК Акваленд, 3-к', 'address': 'г. Новосибирск, Ленинградский пр-т, 124', 'area': '96 кв.м.'},
  {'name': 'ЖК Акваленд, 3-к', 'address': 'г. Новосибирск, Ленинградский пр-т, 124', 'area': '96 кв.м.'},
  {'name': 'ЖК Акваленд, 3-к', 'address': 'г. Новосибирск, Ленинградский пр-т, 124', 'area': '96 кв.м.'},
  {'name': 'ЖК Акваленд, 3-к', 'address': 'г. Новосибирск, Ленинградский пр-т, 124', 'area': '96 кв.м.', 'color': 0xFF0739C9},
  {'name': 'ЖК Акваленд, 3-к', 'address': 'г. Новосибирск, Ленинградский пр-т, 124', 'area': '96 кв.м.'},
  {'name': 'ЖК Акваленд, 3-к', 'address': 'г. Новосибирск, Ленинградский пр-т, 124', 'area': '96 кв.м.'},
  {'name': 'ЖК Акваленд, 3-к', 'address': 'г. Новосибирск, Ленинградский пр-т, 124', 'area': '96 кв.м.'},
  {'name': 'ЖК Акваленд, 3-к', 'address': 'г. Новосибирск, Ленинградский пр-т, 124', 'area': '96 кв.м.'},
  {'name': 'ЖК Акваленд, 3-к', 'address': 'г. Новосибирск, Ленинградский пр-т, 124', 'area': '96 кв.м.'},
];

// {'title': 'Собственник', 'value': 'УК Смарт'},
// {'title': 'Выделенная мощность (электричество)', 'value': '2'},
// {'title': 'Выделенная мощность (тепло)', 'value': '2'},
// {'title': 'Начальная стоимость', 'value': '1 000 000 ₽'},
// {'title': 'Дата приобретения', 'value': '07.05.2021'},
// {'title': 'Рыночная стоимость помещения', 'value': '900 000 ₽'},
// {'title': 'Кадастровый номер', 'value': ''},
// {'title': 'Кадастровая стоимость', 'value': '900 000 ₽'},
// {'title': 'Договор водоснабжения', 'value': 'Договор от 12.04.14'},
// {'title': 'Система налогообложения', 'value': 'Патент'},
// {'title': 'Фактическая Налоговая нагрузка', 'value': '10 000 ₽'},
// {'title': 'Арендная плата', 'value': '30 000 ₽'},
// {'title': 'Коэффициент капитализации', 'value': '1,2'},

List<Map> tenantItems = [
  {'title': 'Наименование организации', 'placeholder': 'Введите наименование организации', 'type': 'Текст', 'unit': ''},
  {'title': 'Срок действия договора', 'placeholder': 'Введите срок действия договора', 'type': 'Текст', 'unit': ''},
  {'title': 'Текущая аренда', 'placeholder': 'Введите текущая аренда', 'type': 'Число', 'unit': '₽'},
  {'title': 'Контактное лицо арендатора', 'placeholder': 'Введите контактное лицо Арендатора', 'type': 'Текст', 'unit': ''},
  {'title': 'Номер телефона', 'placeholder': 'Введите номер телефона', 'type': 'Текст', 'unit': ''},
  {'title': 'E-mail арендатора', 'placeholder': 'Введите E-mail Арендатора', 'type': 'Текст', 'unit': ''},
  {'title': 'Обеспечительный платеж', 'placeholder': 'Введите обеспечительный платеж', 'type': 'Число', 'unit': '₽'},
  {'title': 'Индексация по договору', 'placeholder': 'Введите индексацию по договору', 'type': 'Число', 'unit': '₽'},
  {'title': 'Реквизиты арендатора', 'placeholder': 'Введите реквизиты Арендатора', 'type': 'Текст', 'unit': ''},
  {'title': 'Товарооборот', 'placeholder': 'Введите товарооборот', 'type': 'Число', 'unit': '₽'},
  {'title': 'Процент от товарооборота', 'placeholder': 'Введите процент от товарооборота', 'type': 'Число', 'unit': '%'},
  {'title': 'Комментарий', 'placeholder': 'комментарий к подразделу Арендатор', 'type': 'Текст', 'unit': ''},
  // {'title': 'Отмеченный клиент', 'placeholder': ''},
];

List<Map> detailsTenantItems = [
  {'title': 'Получатель', 'placeholder': 'Введите получателя', 'value': 'Пехотова Наталья'},
  {'title': 'Счет получателя', 'placeholder': 'Введите счет получателя', 'value': '12213434343434'},
  {'title': 'БИК банка получателя', 'placeholder': 'Введите БИК банка получателя', 'value': '044525225'},
  {'title': 'ИНН получателя', 'placeholder': '92323223', 'value': ''},
];

List<Map> tenantItemsFilled = [
  {'title': 'Наименование организации', 'placeholder': 'Введите наименование организации', 'value': 'УК Смарт'},
  {'title': 'Срок действия договора', 'placeholder': 'Введите срок действия договора', 'value': '16.09.2022'},
  {'title': 'Текущая аренда', 'placeholder': 'Введите текущая аренда', 'value': '30 000 ₽'},
  {'title': 'Контактное лицо арендатора', 'placeholder': 'Введите контактное лицо Арендатора', 'value': 'Пехотова Наталья Ивановно'},
  {'title': 'Номер телефона', 'placeholder': 'Введите номер телефона', 'value': '8 (945) 353-23-23'},
  {'title': 'E-mail арендатора', 'placeholder': 'Введите E-mail Арендатора', 'value': 'n.pehotova@mail.com'},
  {'title': 'Обеспечительный платеж', 'placeholder': 'Введите обеспечительный платеж', 'value': '30 000 ₽'},
  {'title': 'Индексация по договору', 'placeholder': 'Введите индексацию по договору', 'value': '30 000 ₽'},
  {'title': 'Товарооборот', 'placeholder': 'Введите товарооборот', 'value': '20 000 ₽'},
  {'title': 'Реквизиты арендатора', 'placeholder': 'Введите реквизиты Арендатора', 'value': 'Пехотова Наталья\n12213434343434\nСбербанк ПАО г. Москва\n92323223'},
  {'title': '% от товарооборота', 'placeholder': 'Введите процент от товарооборота', 'value': '5%'},
  {'title': 'Комментарий', 'placeholder': 'комментарий к подразделу Арендатор', 'value': 'Арендодатель иногода бывает в неадеквате'},
  // {'title': 'Отмеченный клиент', 'placeholder': ''},
];

List markedColors = [
  Color(0xffFF0000),
  Color(0xffFFA700),
  Color(0xff8F00FF),
  Color(0xff00C2FF),
  Color(0xffFFD600),
  Color(0xff40CD0F),
  Color(0xff929CA3),
];

List<Map> expensesItems = [
  {'title': 'Текущая арендная плата', 'placeholder':'Введите текущую арендную плату', 'expense': ['20 000 ₽', '125 000 000 ₽', '25 000 ₽']},
  {'title': 'Обеспечительный платёж', 'placeholder':'Введите обеспечительный платеж', 'expense': ['10 000 ₽', '12 000 000 ₽', '13 000 ₽']},
  {'title': 'Налоги', 'placeholder':'Введите налоги',  'expense': ['2 300 ₽', '2 000 ₽', '25 00 ₽']},
  {'title': 'Сумма Аренды от товарооборота', 'placeholder':'Введите сумму аренды от товарооборота',  'expense': ['20 000 ₽', '20 000 ₽', '20 000 ₽']},
  {'title': 'Фактический товарооборот', 'placeholder':'Введите фактический товарооборот',  'expense': ['20 000 ₽', '20 000 ₽', '20 000 ₽']},
  {'title': 'Дополнительные доходы', 'placeholder':'Введите допонительные доходы',  'expense': ['20 000 ₽', '20 000 ₽', '20 000 ₽']},
  {'title': 'Расходы на управление', 'placeholder':'Введите расходы на управления',  'expense': ['20 000 ₽', '20 000 ₽', '20 000 ₽']},
  {'title': 'Ремонтные и другие затраты', 'placeholder':'Введите ремонтные и другие затраты',  'expense': ['20 000 ₽', '20 000 ₽', '20 000 ₽']},
  {'title': 'Комментарий к «Ремонтные и другие затраты»', 'placeholder':'Комментарий',  'expense': [
    'Ремонт кухни и коридора. Покраска стен, замена напольного покрытия. Натяжной потолок.',
    'Ремонт кухни и коридора. Покраска стен, замена напольного покрытия. Натяжной потолок.',
    'Ремонт кухни и коридора. Покраска стен, замена напольного покрытия. Натяжной потолок.',
  ]},
  {'title': 'Банковское обслуживание', 'placeholder':'Введите банковское обслуживание',  'expense': ['20 000 ₽', '20 000 ₽', '20 000 ₽']},
  {'title': 'Счет за электроэнергию', 'placeholder':'Введите счет за электроэнергию',  'expense': ['20 000 ₽', '20 000 ₽', '20 000 ₽']},
  {'title': 'Счет за эксплуатацию (от УК МКД)', 'placeholder':'Введите счет за эксплуатацию',  'expense': ['20 000 ₽', '20 000 ₽', '20 000 ₽']},
  {'title': 'Счет за водоснабжение и водоотведение', 'placeholder':'Введите счет за водоснабжение и водоотведение',  'expense': ['20 000 ₽', '20 000 ₽', '20 000 ₽']},
  {'title': 'Показания по электричеству', 'placeholder':'Введите показания по электричеству',  'expense': ['12', '23', '232']},
  {'title': 'Счет за отопление', 'placeholder':'Введите счет за отопление',  'expense': ['20 000 ₽', '20 000 ₽', '20 000 ₽']},
  {'title': 'Вывоз мусора', 'placeholder':'Введите вывоз мусора',  'expense': ['20 000 ₽', '20 000 ₽', '20 000 ₽']},
  {'title': 'Услуги связи', 'placeholder':'Введите услуги связи',  'expense': ['20 000 ₽', '20 000 ₽', '20 000 ₽']},
  {'title': 'Показания по ХВС', 'placeholder':'Введите показанию по ХВС',  'expense': ['12', '232', '232']},
  {'title': 'Показания по ГВС', 'placeholder':'Введите показанию по ГВС',  'expense': ['122', '133', '323']},
  {'title': 'Показания по отоплению', 'placeholder':'Введите показания по отоплению',  'expense': ['133', '123', '322']},
  {'title': 'Пени Арендатору за просрочку оплаты КУ', 'placeholder':'Введите пени Арендатору за просрочку оплаты КУ',  'expense': ['200 ₽', '200 ₽', '200 ₽']},
  {'title': 'Пени Арендатору за просрочку оплаты аренды', 'placeholder':'Введите пени Арендатору за просрочку оплаты аренды',  'expense': ['200 ₽', '200 ₽', '100 ₽']},
];

List<Map> expensesArticleItems = [
  {'title': 'Рыночная ставка аренды (в месяц)', 'placeholder':'Введите рыночную ставку аренды', 'value': '1 200 ₽/кв.м'},
  {'title': 'Расходы на управление (% от реального дохода)', 'placeholder':'Введите расходы на управление','value': '3 %'},
  {'title': 'Патент на сдачу в аренду нежилых помещений для ИП', 'placeholder':'Введите стоимость патента','value': '40 000 ₽/год'},
  {'title': 'Банковское обслуживание', 'placeholder':'Введите стоимость банковского обслуживания', 'value': '17 000 ₽'},
  {'title': 'Индексация рыночной ставки аренды', 'placeholder':'Введите индексацию рыночной ставки аренды', 'value': '12%'},
  {'title': 'Потери от недогрузки (смена арендатора)', 'placeholder':'Введите потери от недогрузки', 'value': '15%'},
  {'title': 'Денежный поток', 'placeholder':'Введите денежный поток', 'value': '130 000 ₽'},
  {'title': 'Начало даты расчета', 'placeholder':'Введите начало даты расчета', 'value': '01.06.2020'},
  {'title': 'Конец даты расчета', 'placeholder':'Введите конец даты расчета', 'value': '01.06.2020'},
];

List<Map> planItems = [
  {'title': 'Название плана', 'placeholder': 'Введите название плана', 'value': 'Мой план1'},
  {'title': 'Площадь объекта', 'placeholder': 'Введите площадь объекта', 'value': '302,1'},
  {'title': 'Начальная стоимость', 'placeholder': 'Введите начальную стоимость', 'value': '57 399 000 ₽'},
  {'title': 'Дата начала расчета', 'placeholder': 'Введите дату начала расчета', 'value': '12.09.2021'},
  {'title': 'Дата окончания расчета', 'placeholder': 'Введите дату окончания расчета', 'value': '12.09.2022'},
  {'title': 'Арендная ставка', 'placeholder': 'Введите арендную ставку', 'value': 'В 10 000 ₽'},
  {'title': 'Изменение арендной ставки в год', 'placeholder': 'Введите изменение арендной ставки', 'value': '10%'},
  {'title': 'Коэффициент капитализации', 'placeholder': 'Введите коэффициент капитализации', 'value': '2'},
  {'title': 'Недозагрузка', 'placeholder': 'Введите недогруз', 'value': '10'},
];

List<Map> planTableItems = [
  {'title': 'Рыночная ставка аренды, руб/кв.м*мес', 'objects': ['', '100', '200', '200', '200', '200']},
  {'title': 'Потенциальный валовый доход, руб/год', 'objects': ['', '100 000 000', '100 000 000', '100 000 000', '100 000 000', '100 000 000']},
  {'title': 'Потери от недозагрузки (смена арендатора), %', 'objects': ['', '10', '10', '10', '10', '10']},
  {'title': 'Расходы на управление, % от реального дохода', 'objects': ['', '5', '5', '5', '5', '5']},
  {'title': 'Патент на сдачу в аренду нежилых помещний для ИП, руб/год', 'objects': ['', '100 000', '100 000', '100 000', '100 000', '100 000']},
  {'title': 'Чистый арендный доход, руб', 'objects': ['', '100 000 000', '100 000 000', '100 000 000', '100 000 000', '100 000 000']},
  {'title': 'Площадь помещения', 'objects': ['100',]},
  {'title': 'Начальная стоимость, руб', 'objects': ['100 000 000',]},
  {'title': 'Услуги по приобретению, %', 'objects': ['3']},
  {'title': 'Рыночная стоимость помещения, руб', 'objects': ['100 000 000', '100 000 000', '100 000 000', '100 000 000', '100 000 000', '100 000 000']},
  {'title': 'Прибавка в стоимости, руб', 'objects': ['0', '100', '200', '200', '200', '200']},
  {'title': 'Денежный поток', 'objects': ['120 000 000', '23 9449 44', '23 9449 44', '23 9449 44', '23 9449 44', '23 9449 44', ]},
  {'title': 'Чистый арендный доход, руб', 'objects': ['34 124 452', '85%']},
  {'title': 'Прибавка в стоимости, руб', 'objects': ['34 124 452', '85%']},
  {'title': 'Чистая прибыль за 6 лет, руб', 'objects': ['34 124 452', '85%']},
  {'title': 'Внутренняя норма доходности', 'objects': ['24 %']},
];

List<Map> totalTableItems = [
  {'title': 'Площадь, кв.м', 'objects': ['100', '100', '200', '100', '100', '200', '100', '100', '200']},
  {'title': 'Время покупки', 'objects': ['12.03.2019', '12.03.2019', '', '12.03.2019', '12.03.2019', '', '12.03.2019', '12.03.2019', '']},
  {'title': 'Цена покупки, тыс. руб.', 'objects': ['1 121', '1 121', '2 121', '1 121', '1 121', '2 121', '1 121', '1 121', '2 121']},
  {'title': 'Цена покупки, тыс. руб./кв.м', 'objects': ['23', '13', '54', '23', '13', '54', '23', '13', '54']},
  {'title': 'Стоимость на 07.2018, тыс. руб.', 'objects': ['1 344', '1 483', '2 340', '1 344', '1 483', '2 340', '1 344', '1 483', '2 340']},
  {'title': 'Стоимость на 12.2020, тыс. руб. (или момент продажи)', 'objects': ['1 344', '1 483', '2 342', '1 344', '1 483', '2 342', '1 344', '1 483', '2 342']},
  {'title': 'Cтоимость на 07.2018, тыс. руб./кв.м', 'objects': ['24', '23', '32', '24', '23', '32', '24', '23', '32']},
  {'title': 'Cтоимость на 12.2020, тыс. руб./кв.м (или момент продажи)', 'objects': ['100', '100', '200', '100', '100', '200', '100', '100', '200']},
  {'title': 'Изменение стоимости 2018/2020', 'objects': ['10%', '10%', '10%', '10%', '10%', '10%', '10%', '10%', '10%']},
  {'title': 'Доход на лето 2018, тыс. руб./год', 'objects': ['1 000', '1 000', '2 000 000 000', '1 000', '1 000', '2 000 000 000', '1 000', '1 000', '2 000 000 000']},
  {'title': 'Доход на лето 12.2020, тыс. руб./год', 'objects': ['2 494', '2 343', '223 030', '2 494', '2 343', '223 030', '2 494', '2 343', '223 030']},
  {'title': 'Рост дохода, %, 2018-2020', 'objects': ['10%', '10%', '10%', '10%', '10%', '10%', '10%', '10%', '10%']},
  {'title': '«Доходность» отношение ГАП/ рыночная стоимость, % 2020', 'objects': ['10%', '10%', '10%', '10%', '10%', '10%', '10%', '10%', '10%']},
  {'title': 'Средний прирост стоимости в год, % ', 'objects': ['10%', '10%', '10%', '10%', '10%', '10%', '10%', '10%', '10%']},
  {'title': 'Доли', 'objects': ['100', '100', '2', '100', '100', '2', '100', '100', '2']},
];


String formatNumber(String value, String? symbol) {
  return NumberFormat.currency(locale: 'ru', symbol: symbol ?? '', decimalDigits: 0).format(double.parse(value));
}