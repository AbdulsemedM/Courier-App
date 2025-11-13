import 'package:courier_app/features/transaction_hq_to_branch/data/model/transaction_hq_to_branch_model.dart';
import 'package:courier_app/features/transaction_hq_to_branch/data/repository/transaction_hq_to_branch_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'transaction_hq_to_branch_event.dart';
part 'transaction_hq_to_branch_state.dart';

class TransactionHqToBranchBloc
    extends Bloc<TransactionHqToBranchEvent, TransactionHqToBranchState> {
  final TransactionHqToBranchRepository repository;

  TransactionHqToBranchBloc(this.repository)
      : super(TransactionHqToBranchInitial()) {
    on<FetchTransactions>(_fetchTransactions);
  }

  void _fetchTransactions(FetchTransactions event,
      Emitter<TransactionHqToBranchState> emit) async {
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

