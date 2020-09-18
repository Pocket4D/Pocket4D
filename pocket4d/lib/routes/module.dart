import 'package:thrio/thrio.dart';

import 'p4dModule/module.dart' as module1;

class Module with ThrioModule {
  @override
  void onModuleRegister() {
    registerModule(module1.Module());
  }
}
