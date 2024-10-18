class Laporan {
  String? id;
  String? month;
  var income;
  var expenses;

  // Constructor
  Laporan({
    this.id,
    this.month,
    this.income,
    this.expenses,
  });

  // Factory constructor untuk membuat object dari JSON
  factory Laporan.fromJson(Map<String, dynamic> obj) {
    return Laporan(
      id: obj['id'],
      month: obj['month'],
      income: obj['income'],
      expenses: obj['expenses'],
    );
  }
}
