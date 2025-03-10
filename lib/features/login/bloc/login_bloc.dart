import 'package:courier_app/configuration/phone_number_manager.dart';
import 'package:courier_app/features/login/data/repository/login_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;
  PhoneNumberManager phoneManager = PhoneNumberManager();
  LoginBloc(this.loginRepository) : super(LoginInitial()) {
    on<LoginFetched>(_userLogin);
  }
  void _userLogin(LoginFetched event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    // print("loading...");
    try {
      // final login =
      await loginRepository.sendLogin(event.phoneNumber, event.password);
      phoneManager.setPhoneNumber(event.phoneNumber);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
