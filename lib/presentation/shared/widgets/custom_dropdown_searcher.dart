import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

typedef SingleSelectCallbackDropdown = void Function(String selectedItem);

class CustomDropdownSearcher extends StatefulWidget {
  final SingleSelectCallbackDropdown? action;
  final String hintText;
  final List<String> optionList;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? textColor;
  final double width;
  final bool? hasTrailing;
  final double marginLeft;
  final double marginTop;
  final double marginRight;
  final double marginBottom;
  final double contentPadding; // vertical padding
  final String? initialValue;
  final double? borderRadius;
  final bool isRequired;
  final Color? borderColor;

  const CustomDropdownSearcher({
    super.key,
    required this.hintText,
    required this.optionList,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.textColor,
    required this.action,
    required this.width,
    this.hasTrailing = false,
    this.borderRadius = 8,
    this.marginLeft = 4,
    this.marginTop = 4,
    this.marginRight = 4,
    this.marginBottom = 8,
    this.contentPadding = 8,
    this.isRequired = true,
    this.initialValue,
    this.borderColor,
  });

  @override
  State<CustomDropdownSearcher> createState() => _CustomDropdownSearcherState();
}

class _CustomDropdownSearcherState extends State<CustomDropdownSearcher> {
  late String selectedItem;
  late List<String> filteredOptions;
  late TextEditingController _searchController;
  bool _isDialogOpen = false;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.initialValue ?? '';
    filteredOptions = widget.optionList;
    _searchController = TextEditingController();
  }

  @override
  void didUpdateWidget(CustomDropdownSearcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        selectedItem = widget.initialValue ?? '';
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void filterOptions(String query) {
    setState(() {
      filteredOptions = widget.optionList
          .where(
            (option) => option.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  OutlineInputBorder getOutlineBorder(
          {required Color borderColor, required double borderWidth}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius!),
        borderSide: BorderSide(color: borderColor, width: borderWidth),
      );

  void _showSelectionDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    Color getBackgroundColor() => widget.backgroundColor ?? colorScheme.surface;
    Color getBorderColor() => widget.borderColor ?? colorScheme.primary;
    Color getFontColor() => colorScheme.onSurface;

    setState(() {
      _isDialogOpen = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: getBackgroundColor(),
              title: Text(widget.hintText,
                  style:
                      textTheme.titleMedium?.copyWith(color: getFontColor())),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                width: widget.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: context.tr('custom_dropdown_searcher.search'),
                          hintStyle: textTheme.bodySmall?.copyWith(
                              color: getFontColor().withValues(alpha: 0.6)),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 8,
                          ),
                          border: getOutlineBorder(
                              borderColor: getBorderColor().withValues(alpha: 0.4),
                              borderWidth: 1.0),
                          focusedBorder: getOutlineBorder(
                              borderColor: getBorderColor().withValues(alpha: 0.8),
                              borderWidth: 1.5),
                          enabledBorder: getOutlineBorder(
                              borderColor: getBorderColor().withValues(alpha: 0.4),
                              borderWidth: 1.0),
                        ),
                        style: textTheme.bodyMedium
                            ?.copyWith(color: getFontColor()),
                        onChanged: (query) {
                          setStateDialog(() {
                            filterOptions(query);
                          });
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: Divider(thickness: 0.5),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredOptions.length,
                        itemBuilder: (context, index) {
                          final String option = filteredOptions[index];
                          final isSelected = selectedItem == option;
                          return RadioListTile<String>(
                            title: Text(
                              option,
                              style: textTheme.bodySmall
                                  ?.copyWith(color: getFontColor()),
                            ),
                            value: option,
                            groupValue: selectedItem,
                            onChanged: (String? value) {
                              setStateDialog(() {
                                if (value != null) {
                                  setState(() => selectedItem = value);
                                }
                              });
                            },
                            dense: true,
                            selected: isSelected,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _clearSearchAndResetOptions();
                    Navigator.of(context).pop();
                    setState(() {
                      _isDialogOpen = false;
                    });
                  },
                  child: Text(context.tr('custom_dropdown_searcher.cancel'),
                      style: TextStyle(color: getBorderColor())),
                ),
                TextButton(
                  onPressed: () {
                    _clearSearchAndResetOptions();
                    if (widget.action != null && selectedItem.isNotEmpty) {
                      // Ensure an item is selected
                      widget.action!(selectedItem);
                    }
                    Navigator.of(context).pop();
                    setState(() {
                      _isDialogOpen = false;
                    });
                  },
                  child: Text(context.tr('custom_dropdown_searcher.accept'),
                      style: TextStyle(color: getBorderColor())),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _clearSearchAndResetOptions() {
    setState(() {
      _searchController.clear();
      filteredOptions = widget.optionList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color getBackgroundColor() => widget.backgroundColor ?? colorScheme.surface;
    Color getBorderColor() => widget.borderColor ?? colorScheme.primary;
    Color getFontColor() => widget.textColor ?? colorScheme.onSurface;
    Color getIconColor() => widget.iconColor ?? getBorderColor();

    final bool isEmpty = selectedItem.isEmpty;
    return Container(
      width: widget.width,
      margin: EdgeInsets.only(
        left: widget.marginLeft,
        top: widget.marginTop,
        right: widget.marginRight,
        bottom: widget.marginBottom,
      ),
      child: InkWell(
        onTap: () => _showSelectionDialog(context),
        borderRadius: BorderRadius.circular(widget.borderRadius!),
        child: InputDecorator(
          isEmpty: isEmpty && !_isDialogOpen, // Controls label position
          decoration: InputDecoration(
            labelText:
                widget.isRequired ? '${widget.hintText} *' : widget.hintText,
            isDense: true,
            labelStyle: textTheme.bodySmall?.copyWith(
              color: getFontColor().withValues(alpha: 0.6),
            ),
            floatingLabelStyle: TextStyle(color: getBorderColor()),
            prefixIcon: widget.icon != null
                ? Icon(widget.icon, color: getIconColor(), size: 20)
                : null,
            suffixIcon: const Icon(Icons.arrow_drop_down, size: 18),
            contentPadding: EdgeInsets.symmetric(
              vertical: widget.contentPadding,
              horizontal: 12,
            ),
            filled: true,
            fillColor: getBackgroundColor(),
            border: getOutlineBorder(
              borderColor: getBorderColor().withValues(alpha: 0.4),
              borderWidth: 1.0,
            ),
            enabledBorder: getOutlineBorder(
              borderColor: getBorderColor().withValues(alpha: 0.4),
              borderWidth: 1.0,
            ),
            focusedBorder: getOutlineBorder(
              borderColor: getBorderColor().withValues(alpha: 0.8),
              borderWidth: 1.5,
            ),
            errorBorder: getOutlineBorder(
              borderColor: colorScheme.error,
              borderWidth: 1.2,
            ),
            focusedErrorBorder: getOutlineBorder(
              borderColor: colorScheme.error,
              borderWidth: 1.5,
            ),
          ),
          child: Text(
            selectedItem.isEmpty ? '' : selectedItem,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: textTheme.bodyMedium?.copyWith(
              color: getFontColor(),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),

      // The InputDecorator now handles the label, so this Positioned widget is no longer needed.
      // Positioned(
      //   left: widget.marginLeft + 12,
      //   top: widget.marginTop - 8,
      //   child: Container(
      //     color: getBackgroundColor(), // Use theme color
      //     padding: const EdgeInsets.symmetric(horizontal: 4),
      //     child: Text(
      //       widget.hintText,
      //       style: textTheme.bodySmall?.copyWith(
      //             color: getFontColor().withOpacity(0.6), // Use theme color
      //             fontSize: 11,
      //           ),
      //     ),
      //   ),
      // ),
    );
  }
}
