part of 'console_manager.dart';

class ConsoleData {
  const ConsoleData(this.data);
  final dynamic data;

  String get log => _converter(data);
  String _converter(dynamic data) {
    try {
      var encoder = JsonEncoder.withIndent('  ', (obj) => obj.toString());
      var prettyprint = encoder.convert(data);
      return prettyprint;
    } catch (e) {
      return data.toString();
    }
  }

  Widget get view {
    return Text(log, style: const TextStyle(color: Colors.white));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConsoleData && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => log;
}

class ConsoleColoredData extends ConsoleData {
  const ConsoleColoredData(super.data, {this.color});
  final Color? color;

  @override
  Widget get view {
    return Text(log, style: TextStyle(color: color ?? Colors.white));
  }
}
