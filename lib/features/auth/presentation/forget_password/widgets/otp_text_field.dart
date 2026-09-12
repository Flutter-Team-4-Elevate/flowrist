import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInputField extends StatefulWidget {
  final int length;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const OtpInputField({
    super.key,
    this.length = 6,
    this.initialValue = '',
    required this.onChanged,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );

    _focusNodes = List.generate(widget.length, (index) => FocusNode());

    _setInitialValue();
  }

  void _setInitialValue() {
    final otp = widget.initialValue;

    for (int i = 0; i < otp.length && i < widget.length; i++) {
      _controllers[i].text = otp[i];
    }
  }

  void _onChanged(String value, int index) {
    if (value.length > 1) {
      _handlePaste(value);
      return;
    }

    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    _sendOtp();
  }

  void _handlePaste(String value) {
    final otp = value.replaceAll(RegExp(r'\D'), '');

    for (int i = 0; i < widget.length; i++) {
      _controllers[i].text = i < otp.length ? otp[i] : '';
    }

    _sendOtp();

    if (otp.length >= widget.length) {
      _focusNodes.last.unfocus();
    }
  }

  void _sendOtp() {
    final otp = _controllers.map((controller) {
      return controller.text;
    }).join();

    widget.onChanged(otp);
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      _sendOtp();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 48,
          height: 56,
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => _onKeyEvent(event, index),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(width: 2),
                ),
              ),
              onChanged: (value) {
                _onChanged(value, index);
              },
            ),
          ),
        );
      }),
    );
  }
}
