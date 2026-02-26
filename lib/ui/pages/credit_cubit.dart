import 'package:bloc/bloc.dart';

import 'credit_state.dart';

class CreditCubit extends Cubit<CreditState> {
  CreditCubit() : super(const CreditState.initial());

  void setLoanAmount(double value) {
    emit(
      state.copyWith(
        loanAmount: value,
        interestAmount: 0,
        repaymentAmount: 0,
        hasCalculated: false,
      ),
    );
  }

  void setLoanTermMonths(int value) {
    emit(
      state.copyWith(
        loanTermMonths: value,
        interestAmount: 0,
        repaymentAmount: 0,
        hasCalculated: false,
      ),
    );
  }

  void setInterestRatePercent(double value) {
    emit(
      state.copyWith(
        interestRatePercent: value,
        interestAmount: 0,
        repaymentAmount: 0,
        hasCalculated: false,
      ),
    );
  }

  void calculate() {
    if (!state.canCalculate) return;

    final interest = _round2(
      state.loanAmount *
          (state.interestRatePercent / 100) *
          (state.loanTermMonths / 12),
    );
    final repayment = _round2(state.loanAmount + interest);

    emit(
      state.copyWith(
        interestAmount: interest,
        repaymentAmount: repayment,
        hasCalculated: true,
      ),
    );
  }
}

double _round2(double value) => (value * 100).round() / 100;
