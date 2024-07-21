import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/controllers/<name>/<name>_provider.dart';

class <Name>Screen extends StatelessWidget {
  static Widget get provider {
    return ChangeNotifierProvider(
      create: (context) => <Name>Provider(),
      child: const <Name>Screen(),
    );
  }

  const <Name>Screen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<<Name>Provider>(context, listen: false);
    return const Placeholder();
  }
}
