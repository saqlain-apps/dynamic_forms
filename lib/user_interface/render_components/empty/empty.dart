import 'package:flutter/widgets.dart';

const nothing = Empty();

class Empty extends Widget {
  const Empty({super.key});

  @override
  Element createElement() => _EmptyElement(this);
}

class _EmptyElement extends Element {
  _EmptyElement(super.widget);

  @override
  void mount(Element? parent, dynamic newSlot) {
    assert(parent is! MultiChildRenderObjectElement, """
        You are using Empty under a MultiChildRenderObjectElement.
        This suggests a possibility that the Empty is not needed or is being used improperly.
        Make sure it can't be replaced with an inline conditional or
        omission of the target widget from a list.
        """);

    super.mount(parent, newSlot);
  }

  @override
  bool get debugDoingBuild => false;

  @override
  // ignore: must_call_super
  void performRebuild() {}
}
