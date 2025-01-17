import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState(false));

  void login() {
    state = state.copyWith(isLoggedIn: true);
  }

  void logout() {
    state = state.copyWith(isLoggedIn: false);
  }
}

class UserState {
  final bool isLoggedIn;

  UserState(this.isLoggedIn);

  UserState copyWith({bool? isLoggedIn}) {
    return UserState(isLoggedIn ?? this.isLoggedIn);
  }
}
