import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class GrxAnimatedLoadingButtonController
    extends RoundedLoadingButtonController {
  GrxAnimatedLoadingButtonController({
    this.resetStateDuration = const Duration(seconds: 3),
  });

  final Duration? resetStateDuration;

  @override
  void success() {
    super.success();

    _resetButtonState();
  }

  @override
  void error() {
    super.error();

    _resetButtonState();
  }

  void _resetButtonState() {
    if (resetStateDuration != null && resetStateDuration!.inMilliseconds > 0) {
      Future.delayed(resetStateDuration!, () {
        reset();
      });
    }
  }
}
