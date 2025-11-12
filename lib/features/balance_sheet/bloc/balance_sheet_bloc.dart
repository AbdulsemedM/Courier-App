import 'package:courier_app/features/balance_sheet/data/model/balance_sheet_model.dart';
import 'package:courier_app/features/balance_sheet/data/repository/balance_sheet_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'balance_sheet_event.dart';
part 'balance_sheet_state.dart';

class BalanceSheetBloc extends Bloc<BalanceSheetEvent, BalanceSheetState> {
  final BalanceSheetRepository balanceSheetRepository;

  BalanceSheetBloc(this.balanceSheetRepository) : super(BalanceSheetInitial()) {
    on<FetchBalanceSheet>(_fetchBalanceSheet);
  }

  void _fetchBalanceSheet(
      FetchBalanceSheet event, Emitter<BalanceSheetState> emit) async {
    emit(FetchBalanceSheetLoading());
    try {
      final balanceSheet = await balanceSheetRepository.fetchBalanceSheet(
        event.branchId,
        event.asOfDate,
      );
      emit(FetchBalanceSheetSuccess(balanceSheet: balanceSheet));
    } catch (e) {
      emit(FetchBalanceSheetError(message: e.toString()));
    }
  }
}

