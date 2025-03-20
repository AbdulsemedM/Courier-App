part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginFetched extends LoginEvent {
  final String email;
  final String password;

  LoginFetched({required this.email, required this.password});
}
