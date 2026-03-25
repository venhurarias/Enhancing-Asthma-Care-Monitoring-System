class HistoryFinance {
  final String type, title, date;
  final double amount;

  HistoryFinance({required this.type,required this.title,required this.date, required this.amount});
}

List demoHistoryFinance = [
  HistoryFinance(
    type: "WITHDRAW",
    title: "Buy Drill Press",
    date: "01-03-2021",
    amount: 100.01
  ),
  HistoryFinance(
    type: "WITHDRAW",
    title: "Buy materials for Fire Extinguisher",
    date: "27-02-2021",
      amount: 100.01
  ),
  HistoryFinance(
    type: "DEPOSIT",
    title: "Earnings in Shopee",
    date: "23-02-2021",
      amount: 100.01
  ),
  HistoryFinance(
    type: "DEPOSIT",
    title: "Earnings in Youtube",
    date: "21-02-2021",
      amount: 100.01
  ),
  HistoryFinance(
    type: "WITHDRAW",
    title: "Hospital Bill",
    date: "23-02-2021",
      amount: 100.01
  ),
  HistoryFinance(
    type: "DEPOSIT",
    title: "Additional Charity",
    date: "25-02-2021",
      amount: 100.01
  ),
];
