import 'package:bingo_app/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:bingo_app/app/app.dialogs.dart';
import 'package:stacked_services/stacked_services.dart';

class OnboardingViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Select type of card',
      description: '',
    );
  }
}
