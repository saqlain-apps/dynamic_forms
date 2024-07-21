import '/utils/app_helpers/_app_helper_import.dart';

void printCustom(dynamic object, [Logger logger = Logger.blue]) {
  var data = const AppMethods().prettifyMap(object);
  logger.log(data);
}

void printMessages(dynamic object) {
  printCustom(object, Logger.white);
}

void printError(dynamic object) {
  printCustom(object, Logger.magenta);
}

void printRemote(dynamic object) {
  printCustom(object, Logger.yellow);
}

void printLocal(dynamic object) {
  printCustom(object, Logger.green);
}

void printImportant(dynamic object) {
  printCustom(object, Logger.red);
}

void printPersistent(dynamic object) {
  // printCustom(object, Logger.cyan);
}
