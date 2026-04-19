part of 'auth_bloc.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);
}

class AuthenticatedButNotVerified extends AuthState {
  final User user;
  AuthenticatedButNotVerified(this.user);
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String errorMessage;
  AuthError(this.errorMessage);
}
