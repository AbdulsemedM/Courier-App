import 'package:courier_app/features/teller_accounts/data/model/teller_account_model.dart';
import 'package:courier_app/features/teller_accounts/data/repository/teller_account_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'teller_account_event.dart';
part 'teller_account_state.dart';

class TellerAccountBloc extends Bloc<TellerAccountEvent, TellerAccountState> {
  final TellerAccountRepository tellerAccountRepository;
  TellerAccountBloc(this.tellerAccountRepository) : super(TellerAccountInitial()) {
    on<FetchTellerAccounts>(_fetchTellerAccounts);
  }

  void _fetchTellerAccounts(FetchTellerAccounts event, Emitter<TellerAccountState> emit) async {
    emit(FetchTellerAccountsLoading());
    try {
      final accounts = await tellerAccountRepository.fetchTellerAccounts(event.accountType);
      emit(FetchTellerAccountsSuccess(accounts: accounts));
    } catch (e) {
      emit(FetchTellerAccountsError(message: e.toString()));
    }
  }
}

