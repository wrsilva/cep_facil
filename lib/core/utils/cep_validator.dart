class CepValidator {
  CepValidator._();

  static String? validate(String? value) {
    if (value == null || value.isEmpty) return 'Informe um CEP.';
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 8) return 'CEP deve ter 8 dígitos.';
    return null;
  }

  static String unmask(String cep) => cep.replaceAll(RegExp(r'\D'), '');
}
