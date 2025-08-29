import "package:flutter/material.dart";


class CustomDropdown extends StatelessWidget {
  final String label;
  final TextEditingController? ddController;
  final List<DropdownMenuEntry> ddEntries;
  final Color? themeColor;
  final Color? textColor;
  final double? width;
  final FocusNode? focusNode;
  final Function(dynamic)? onSelected;


  const CustomDropdown({
    super.key,
    required this.label,
    this.ddController,
    required this.ddEntries,
    required this.onSelected,
    this.themeColor=Colors.orange,
    this.textColor=Colors.black,
    this.width=300,
    this.focusNode
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: width,
      focusNode: focusNode,
      label: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 13
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        suffixIconColor: themeColor,
        border: UnderlineInputBorder(),
        enabledBorder:UnderlineInputBorder(
          borderSide: BorderSide(color: themeColor!)
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: themeColor!)
        )
      ),
      textStyle: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      controller: ddController,
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(Colors.orange.shade100)
      ),
      dropdownMenuEntries: ddEntries,
      onSelected: onSelected,
    );
  }
}
