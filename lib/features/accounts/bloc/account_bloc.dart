import 'package:courier_app/features/accounts/data/model/account_model.dart';
import 'package:courier_app/features/accounts/data/repository/account_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository accountRepository;

  AccountBloc(this.accountRepository) : super(AccountInitial()) {
    on<FetchAccounts>(_fetchAccounts);
  }

  void _fetchAccounts(FetchAccounts event, Emitter<AccountState> emit) async {
    emit(FetchAccountsLoading());
    try {
      final accounts = await accountRepository.fetchAccounts();
      emit(FetchAccountsSuccess(accounts: accounts));
    } catch (e) {
      emit(FetchAccountsError(message: e.toString()));
    }
  }
}
