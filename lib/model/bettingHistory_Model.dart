// ignore_for_file: non_constant_identifier_names

class BettingHistoryModel {
  final String? gamesno;
  final String? number;
  final String? win;
  final String? result;
  final String? amount;

  BettingHistoryModel({
    required this.gamesno,
    required this.number,
    required this.win,
    required this.result,
    required this.amount,
  });
  factory BettingHistoryModel.fromJson(Map<String, dynamic> json) {
    return BettingHistoryModel(
      gamesno: json['gamesno'],
      number: json['number'],
      win: json['win'],
      result: json['result'],
      amount: json['amount'].toString(),
    );
  }
}
