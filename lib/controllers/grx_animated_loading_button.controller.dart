import 'package:flutter/foundation.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class GrxAnimatedLoadingButtonController
    extends RoundedLoadingButtonController {
  GrxAnimatedLoadingButtonController({
    this.resetStateDuration = const Duration(seconds: 3),
  });

  final Duration? resetStateDuration;
  final hasStarted = ValueNotifier<bool>(false);

  @override
  void start() {
    super.start();

    _setHasStarted(true);
  }

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
        _setHasStarted(false);
      });
    }
  }

  void _setHasStarted(bool value) {
    Future.delayed(
      const Duration(milliseconds: 300),
      () => hasStarted.value = value,
    );
  }
}
