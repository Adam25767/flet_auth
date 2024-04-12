import 'package:flet/flet.dart';

import 'auth.dart';

CreateControlFactory createControl = (CreateControlArgs args) {
  switch (args.control.type) {
    case "bio_auth":
      return AuthControl(
          parent: args.parent,
          control: args.control,
          nextChild: args.nextChild,
          backend: args.backend);
    default:
      return null;
  }
};

void ensureInitialized() {
  // nothing to initialize
}
