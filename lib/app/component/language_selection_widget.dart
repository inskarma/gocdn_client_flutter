import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageSelectionOverlay extends StatefulWidget {
  final Function(String) onLanguageSelected;

  const LanguageSelectionOverlay({
    required this.onLanguageSelected,
  });

  @override
  _LanguageSelectionOverlayState createState() =>
      _LanguageSelectionOverlayState();
}

class _LanguageSelectionOverlayState extends State<LanguageSelectionOverlay> {
  String _selectedLanguage = 'Chinese';
  final List<String> languages = ['English', 'Russian', 'Chinese'];
  late OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOverlay();
    });
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry);
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "language_selection".tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    InkWell(
                      child: Icon(Icons.close, color: Colors.white),
                      onTap: _closeOverlay,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: Text(
                            "language_select".tr,
                            style: TextStyle(color: Colors.white),
                          ),
                          items: languages
                              .map((String language) => DropdownMenuItem<String>(
                            value: language,
                            child: Text(
                              language,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ))
                              .toList(),
                          value: _selectedLanguage,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedLanguage = newValue!;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[900],
                            ),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[700],
                            ),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        widget.onLanguageSelected(_selectedLanguage);
                        _closeOverlay();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      child: Text(
                        "language_change_button".tr,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _closeOverlay() {
    _overlayEntry.remove();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // Пустой виджет, так как Overlay работает отдельно
  }
}