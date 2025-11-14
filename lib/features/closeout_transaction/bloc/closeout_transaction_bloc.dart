import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:courier_app/features/closeout_transaction/data/repository/closeout_transaction_repository.dart';
import 'package:courier_app/features/closeout_transaction/data/model/closeout_transaction_model.dart';

part 'closeout_transaction_event.dart';
part 'closeout_transaction_state.dart';

class CloseoutTransactionBloc extends Bloc<CloseoutTransactionEvent, CloseoutTransactionState> {
  final CloseoutTransactionRepository repository;

  CloseoutTransactionBloc({required this.repository}) : super(CloseoutTransactionInitial()) {
    on<FetchCloseoutTransactions>(_onFetchCloseoutTransactions);
  }

  Future<void> _onFetchCloseoutTransactions(
    FetchCloseoutTransactions event,
    Emitter<CloseoutTransactionState> emit,
  ) async {
    emit(CloseoutTransactionLoading());
    try {
      final transactions = await repository.fetchCloseoutTransactions(
        tellerId: event.tellerId,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(CloseoutTransactionLoaded(transactions: transactions));
    } catch (e) {
      emit(CloseoutTransactionError(message: e.toString()));
    }
  }
}

