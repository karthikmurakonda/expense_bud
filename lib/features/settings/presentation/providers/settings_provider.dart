import 'package:expense_bud/core/utils/currencies.dart';
import 'package:expense_bud/core/utils/money.dart';
import 'package:expense_bud/features/settings/domain/entities/user_preference.dart';
import 'package:expense_bud/features/settings/domain/usecases/get_user_preference_usecase.dart';
import 'package:expense_bud/features/settings/domain/usecases/update_user_preference_usecase.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  SettingsProvider({
    required GetUserPreferenceUsecase getUserPreferenceUsecase,
    required UpdateUserPreferenceUsecase updateUserPreferenceUsecase,
  })  : _getUserPreferenceUsecase = getUserPreferenceUsecase,
        _updateUserPreferenceUsecase = updateUserPreferenceUsecase;

  final GetUserPreferenceUsecase _getUserPreferenceUsecase;
  final UpdateUserPreferenceUsecase _updateUserPreferenceUsecase;

  UserPreferenceEntity _preference = UserPreferenceEntity(
    inboxAmount: InboxAmount.week,
    showEntryDate: false,
    onboardingComplete: false,
    currency: ngn,
  );

  late Money _money;
  Money get money => _money;
  set money(Money value) {
    _money = value;
    notifyListeners();
  }

  UserPreferenceEntity get preference => _preference;
  set __preference(UserPreferenceEntity pref) {
    _preference = pref;
    notifyListeners();
  }

  Future<void> updateUserPref(UserPreferenceEntity pref) async {
    final failureOrSuccess = await _updateUserPreferenceUsecase(pref);
    failureOrSuccess.fold((failure) {}, (_) => __preference = pref);
  }

  Future<void> getUserPref() async {
    final failureOrSuccess = await _getUserPreferenceUsecase();
    failureOrSuccess.fold((failure) {}, (pref) {
      if (pref != null) __preference = pref;
    });
    _money = Money(preference.currency);
  }
}

extension SettingsProviderExtension on SettingsProvider {
  String getInboxAmountTitle(InboxAmount inboxAmount) {
    switch (inboxAmount) {
      case InboxAmount.today:
        return "spent today";
      case InboxAmount.month:
        return "spent this month";
      default:
        return "spent this week";
    }
  }
}
