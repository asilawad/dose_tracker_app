import 'dart:async';

import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:get/get.dart';

/// State of the Home tab: the live list of the account's profiles, the
/// loading flag and the error flag.
///
/// The list updates by itself when a profile is added, because it listens
/// to the repository stream. [retry] listens again after an error. Only the
/// route name is used to open Add Profile; nothing is passed along.
class HomeController extends GetxController {
  HomeController(this._profiles);

  final ProfilesRepository _profiles;

  final RxList<Profile> profiles = <Profile>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  StreamSubscription<List<Profile>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _listen();
  }

  void retry() {
    hasError.value = false;
    isLoading.value = true;
    _listen();
  }

  void openAddProfile() {
    Get.toNamed<void>(AppRoutes.addProfile);
  }

  void _listen() {
    _subscription?.cancel();
    _subscription = _profiles.watchProfiles().listen(
      (List<Profile> list) {
        profiles.assignAll(list);
        hasError.value = false;
        isLoading.value = false;
      },
      onError: (Object _) {
        hasError.value = true;
        isLoading.value = false;
      },
    );
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
