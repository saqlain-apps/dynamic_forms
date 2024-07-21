import '/utils/app_helpers/_app_helper_import.dart';
import '../separator_builder.dart';

class MultiSelection extends StatefulWidget {
  const MultiSelection({required this.selections, super.key});

  final ValueNotifier<Map<String, bool>> selections;

  @override
  State<MultiSelection> createState() => _MultiSelectionState();
}

class _MultiSelectionState extends State<MultiSelection> {
  final ScrollController _scroller = ScrollController();

  bool _isExpanded = false;
  void switchExpansion() {
    _isExpanded = !_isExpanded;
    setState(() {});
  }

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.selections,
      builder: (context, selections, child) {
        var selectionList = SeparatorBuilder<MapEntry<String, bool>, Widget>(
          originalList: selections.entries.toList(),
          separatorBuilder: (index) => const SizedBox(height: 16),
          itemBuilder: (index, itemData) {
            return IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      itemData.key,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.of(context).cBlack,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      itemData.value
                          ? selections[itemData.key] = false
                          : selections[itemData.key] = true;

                      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                      widget.selections.notifyListeners();
                    },
                    child: AnimatedContainer(
                      width: 20,
                      height: 20,
                      duration: const Duration(milliseconds: 500),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: itemData.value ? AppColors.red : AppColors.black,
                      ),
                      child: AnimatedRotation(
                        turns: itemData.value ? 0 : 17 / 8,
                        duration: const Duration(milliseconds: 500),
                        child: const Icon(
                          Icons.close,
                          size: 12,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            );
          },
        );

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
              width: 1,
              color: AppColors.of(context).divider,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: switchExpansion,
                child: Container(
                  color: AppColors.of(context).transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: selectedTitle(selections)),
                        Icon(
                          !_isExpanded
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.keyboard_arrow_up_rounded,
                          color: AppColors.black,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              if (_isExpanded) ...[
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 9),
                        Divider(
                          thickness: 1.2,
                          height: 1.2,
                          color: AppColors.of(context).divider,
                        ),
                        const SizedBox(height: 16),
                        Flexible(
                          fit: FlexFit.loose,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 190),
                            child: PrimaryScrollController(
                              controller: _scroller,
                              child: Scrollbar(
                                thumbVisibility: true,
                                thickness: 5,
                                child: CustomScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  primary: true,
                                  shrinkWrap: true,
                                  slivers: [
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) =>
                                            selectionList.itemBuilder(index),
                                        childCount: selectionList.length,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ],
          ),
        );
      },
    );
  }

  Widget selectedTitle(Map<String, bool> selections) {
    var selectedItems =
        selections.entries.where((element) => element.value).map((e) => e.key);

    var selectedText = selectedItems.isEmpty
        ? 'None Selected'
        : 'Selected: (${selectedItems.join(', ')})';

    return Text(
      selectedText,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppStyles.of(context),
    );
  }
}
