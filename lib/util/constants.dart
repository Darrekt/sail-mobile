import 'package:email_validator/email_validator.dart';

const SHARED_PREFS_ONBOARDING_STATUS_KEY = "onboardingDone";

// Hero tags
const HERO_TAG_DRAWER_PROFILE = "DRAWER_PROFILE_AVATAR";

// Form validators

/// Checks that a given email string is not empty and well formed.
String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an email address';
  }
  if (!EmailValidator.validate(value)) return "Invalid email address";

  return null;
}
