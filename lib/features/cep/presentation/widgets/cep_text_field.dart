import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cep_facil/core/utils/cep_validator.dart';

class CepTextField extends StatelessWidget {
  const CepTextField({super.key, required this.controller, this.onSubmitted});

  final TextEditingController controller;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [_CepMaskFormatter()],
      decoration: const InputDecoration(
        labelText: 'CEP',
        hintText: '00000-000',
        prefixIcon: Icon(Icons.location_on_outlined),
      ),
      validator: CepValidator.validate,
      onFieldSubmitted: (_) => onSubmitted?.call(),
    );
  }
}

class _CepMaskFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return newValue.copyWith(text: '');

    final limited = digits.length > 8 ? digits.substring(0, 8) : digits;

    final buffer = StringBuffer();
    for (var i = 0; i < limited.length; i++) {
      if (i == 5) buffer.write('-');
      buffer.write(limited[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
