import 'package:equatable/equatable.dart';

class CreditState extends Equatable {
  const CreditState({
    required this.loanAmount,
    required this.loanTermMonths,
    required this.interestRatePercent,
    required this.interestAmount,
    required this.repaymentAmount,
    required this.hasCalculated,
  });

  const CreditState.initial()
    : loanAmount = 0,
      loanTermMonths = 0,
      interestRatePercent = 0,
      interestAmount = 0,
      repaymentAmount = 0,
      hasCalculated = false;

  final double loanAmount;
  final int loanTermMonths;
  final double interestRatePercent;

  final double interestAmount;
  final double repaymentAmount;

  final bool hasCalculated;

  bool get canCalculate => loanAmount >= 100 && loanTermMonths >= 1;

  CreditState copyWith({
    double? loanAmount,
    int? loanTermMonths,
    double? interestRatePercent,
    double? interestAmount,
    double? repaymentAmount,
    bool? hasCalculated,
  }) {
    return CreditState(
      loanAmount: loanAmount ?? this.loanAmount,
      loanTermMonths: loanTermMonths ?? this.loanTermMonths,
      interestRatePercent: interestRatePercent ?? this.interestRatePercent,
      interestAmount: interestAmount ?? this.interestAmount,
      repaymentAmount: repaymentAmount ?? this.repaymentAmount,
      hasCalculated: hasCalculated ?? this.hasCalculated,
    );
  }

  @override
  List<Object?> get props => [
    loanAmount,
    loanTermMonths,
    interestRatePercent,
    interestAmount,
    repaymentAmount,
    hasCalculated,
  ];
}
