import 'package:courier_app/features/transaction_branch_to_hq/data/model/transaction_branch_to_hq_model.dart';
import 'package:courier_app/features/transaction_branch_to_hq/data/repository/transaction_branch_to_hq_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'transaction_branch_to_hq_event.dart';
part 'transaction_branch_to_hq_state.dart';

class TransactionBranchToHqBloc
    extends Bloc<TransactionBranchToHqEvent, TransactionBranchToHqState> {
  final TransactionBranchToHqRepository repository;

  TransactionBranchToHqBloc(this.repository)
      : super(TransactionBranchToHqInitial()) {
    on<FetchTransactions>(_fetchTransactions);
  }

  void _fetchTransactions(FetchTransactions event,
      Emitter<TransactionBranchToHqState> emit) async {
    emit(FetchTransactionsLoading());
    try {
      final transactions = await repository.fetchTransactions(
        event.branchId,
        event.startDate,
        event.endDate,
      );
      emit(FetchTransactionsSuccess(transactions: transactions));
    } catch (e) {
      emit(FetchTransactionsError(message: e.toString()));
    }
  }
}

