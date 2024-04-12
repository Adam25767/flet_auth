import 'package:flet/flet.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AuthControl extends StatefulWidget {
  final Control? parent;
  final Control control;
  final Widget? nextChild;
  final FletControlBackend backend;

  const AuthControl(
      {super.key,
      required this.parent,
      required this.control,
      required this.nextChild,
      required this.backend});

  @override
  State<AuthControl> createState() => _AuthControlState();
}

enum SupportState {
  unknown,
  supported,
  unSupported,
}

class _AuthControlState extends State<AuthControl> with FletStoreMixin {
  final LocalAuthentication auth = LocalAuthentication();
  SupportState supportState = SupportState.unknown;
  List<BiometricType>? availableBiometrics;

  @override
  void initState() {
    auth.isDeviceSupported().then((bool isSupported) => setState(() =>
        supportState =
            isSupported ? SupportState.supported : SupportState.unSupported));
    super.initState();
  }

  Future checkBiometric() async {
    late bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
      return canCheckBiometric;
    } on PlatformException catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "BiometricAuthentication build: ${widget.control.id} (${widget.control.hashCode})");

    return withPageArgs((context, pageArgs) {
      () async {
        widget.backend.subscribeMethods(widget.control.id,
            (methodName, args) async {
          switch (methodName) {
            case "check_biometric":
              return (await checkBiometric()).toString();
            case "get_biometric":
              return null;
          }
          return null;
        });
      }();
      return widget.nextChild ?? const SizedBox.shrink();
    });
  }
}
