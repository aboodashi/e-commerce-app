import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<GuestLoginEvent>(_onGuestLogin);
    on<LogoutEvent>(_onLogout);
    on<SendEmailVerificationEvent>(_onSendEmailVerification);
    on<ResetPasswordEvent>(_onResetPassword);
    on<GoogleLoginEvent>(_onGoogleLogin);
  }

  Future<void> _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    final user = authRepository.currentUser;
    if (user != null) {
      // Reload user to get latest verification status
      await user.reload();
      final updatedUser = authRepository.currentUser!;
      if (updatedUser.isAnonymous) {
        emit(Authenticated(updatedUser));
      } else if (!updatedUser.emailVerified) {
        emit(AuthenticatedButNotVerified(updatedUser));
      } else {
        emit(Authenticated(updatedUser));
      }
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = await authRepository.signIn(email: event.email, password: event.password);
      final user = credential?.user;
      if (user != null) {
        if (!user.emailVerified) {
          emit(AuthenticatedButNotVerified(user));
        } else {
          emit(Authenticated(user));
        }
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = await authRepository.signUp(email: event.email, password: event.password);
      final user = credential?.user;
      if (user != null) {
        await authRepository.sendEmailVerification();
        emit(AuthenticatedButNotVerified(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onGuestLogin(GuestLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = await authRepository.signInAnonymously();
      final user = credential?.user;
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.signOut();
    emit(Unauthenticated());
  }

  Future<void> _onSendEmailVerification(SendEmailVerificationEvent event, Emitter<AuthState> emit) async {
    try {
      await authRepository.sendEmailVerification();
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onResetPassword(ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.sendPasswordResetEmail(email: event.email);
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onGoogleLogin(GoogleLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = await authRepository.signInWithGoogle();
      final user = credential?.user;
      if (user != null) {
        if (!user.emailVerified) {
           emit(AuthenticatedButNotVerified(user));
        } else {
           emit(Authenticated(user));
        }
      } else {
        emit(Unauthenticated()); // Can mean user cancelled sign in.
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
