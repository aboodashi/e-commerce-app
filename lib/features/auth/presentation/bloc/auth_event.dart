part of 'auth_bloc.dart';

sealed class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;

  RegisterEvent({required this.email, required this.password});
}

class GuestLoginEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class SendEmailVerificationEvent extends AuthEvent {}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  ResetPasswordEvent({required this.email});
}

class GoogleLoginEvent extends AuthEvent {}

