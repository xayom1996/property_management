// Наименование организации !
// Текущая аренда текущая - заполняется из эксплуатации!
// Срок действия договора!
// Контактное лицо Арендатора - ФИО и номер телефона!
// E-mail Арендатора
// Обеспечительный платеж!
// Индексация по договору!
// Реквизиты Арендатора!
// Товарооборот!
// % от товарооборота!
// Комментарий к подразделу Арендатор!
// Пометка «Отмеченный клиент» - арендатор с какими либо "проблемами/требованиями", требующий усиленного контроля. При активации этой отметки, данный Объект в списке объектов должен визуально выделяться. Можно выбрать один из семи предустановленных цветов. По умолчанию выбран красный;
// Редактировать данные

class Tenant {
  final String? nameCompany; /// Наименование организации
  final String? currentRent; /// Текущая аренда
  final String? contactPerson; /// Контактное лицо Арендатора
  final String? phoneNumber; /// Номер телефона
  final String? email; /// E-mail Арендатора!
  final String? securityPayment; /// Обеспечительный платеж
  final String? indexingContract; /// Индексация по договору
  final String? requisites; /// Реквизиты Арендатора
  final String? turnover; /// Товарооборот
  final String? percentageTurnover; /// % от товарооборота
  final String? comment; /// Комментарий к подразделу Арендатор
  final bool? markedClient; /// Отмеченный клиент

  Tenant({
    required this.nameCompany,
    required this.currentRent,
    required this.contactPerson,
    required this.phoneNumber,
    this.securityPayment,
    this.indexingContract,
    this.email,
    this.requisites,
    this.turnover,
    this.percentageTurnover,
    this.comment, this.markedClient,
  });
}
