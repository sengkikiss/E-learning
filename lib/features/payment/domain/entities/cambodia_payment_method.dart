import 'package:flutter/material.dart';

enum CambodiaPaymentCategory {
  khqr,
  mobileBanking,
  eWallet,
  card,
}

class CambodiaPaymentMethod {
  final String id;
  final String name;
  final String nameKhmer;
  final String subtitle;
  final CambodiaPaymentCategory category;
  final Color primaryColor;
  final Color accentColor;
  final IconData icon;
  final String badgeText;
  final bool isPopular;
  final String bankCode;
  final String appScheme;

  const CambodiaPaymentMethod({
    required this.id,
    required this.name,
    required this.nameKhmer,
    required this.subtitle,
    required this.category,
    required this.primaryColor,
    required this.accentColor,
    required this.icon,
    this.badgeText = '',
    this.isPopular = false,
    this.bankCode = '',
    this.appScheme = '',
  });
}

class CambodiaPaymentRegistry {
  CambodiaPaymentRegistry._();

  /// Approximate Central Bank exchange rate: 1 USD = 4,100 KHR
  static const int khrExchangeRate = 4100;

  static String formatKhr(double usdAmount) {
    final khr = (usdAmount * khrExchangeRate).round();
    final parts = khr.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '៛$parts';
  }

  static const List<CambodiaPaymentMethod> allMethods = [
    // 1. Bakong KHQR (NBC Unified QR Standard)
    CambodiaPaymentMethod(
      id: 'khqr',
      name: 'Bakong KHQR',
      nameKhmer: 'បាគង KHQR (គ្រប់ធនាគារ)',
      subtitle: 'Scan & pay with any Cambodian banking app',
      category: CambodiaPaymentCategory.khqr,
      primaryColor: Color(0xFFE11938),
      accentColor: Color(0xFFFF4D6D),
      icon: Icons.qr_code_2_rounded,
      badgeText: 'NBC Unified',
      isPopular: true,
      bankCode: 'BAKONG',
      appScheme: 'bakong://',
    ),

    // 2. ABA PAY (Advanced Bank of Asia)
    CambodiaPaymentMethod(
      id: 'aba_pay',
      name: 'ABA PAY',
      nameKhmer: 'ABA ផេ (ABA Mobile)',
      subtitle: 'Instant checkout via ABA Mobile app',
      category: CambodiaPaymentCategory.mobileBanking,
      primaryColor: Color(0xFF004165),
      accentColor: Color(0xFF00A3C4),
      icon: Icons.account_balance_rounded,
      badgeText: 'Most Popular',
      isPopular: true,
      bankCode: 'ABA',
      appScheme: 'abamobile://',
    ),

    // 3. Wing Bank (WingPay)
    CambodiaPaymentMethod(
      id: 'wing_pay',
      name: 'Wing Bank (WingPay)',
      nameKhmer: 'ធនាគារ វីង (WingPay)',
      subtitle: 'Pay with Wing App or Wing Account',
      category: CambodiaPaymentCategory.mobileBanking,
      primaryColor: Color(0xFF7CB342),
      accentColor: Color(0xFFAED581),
      icon: Icons.account_balance_wallet_rounded,
      badgeText: 'Fast & Secure',
      isPopular: true,
      bankCode: 'WING',
      appScheme: 'wingpay://',
    ),

    // 4. ACLEDA mobile
    CambodiaPaymentMethod(
      id: 'acleda_mobile',
      name: 'ACLEDA mobile',
      nameKhmer: 'អេស៊ីលីដា ម៉ូបាល',
      subtitle: 'ACLEDA Bank Mobile Banking & KHQR',
      category: CambodiaPaymentCategory.mobileBanking,
      primaryColor: Color(0xFF0B2545),
      accentColor: Color(0xFFF4A261),
      icon: Icons.assured_workload_rounded,
      badgeText: 'Nationwide',
      isPopular: true,
      bankCode: 'ACLEDA',
      appScheme: 'acledamobile://',
    ),

    // 5. Canadia Bank (Canadia Pay)
    CambodiaPaymentMethod(
      id: 'canadia_pay',
      name: 'Canadia Bank',
      nameKhmer: 'ធនាគារ កាណាឌីយ៉ា',
      subtitle: 'Canadia Mobile & Smart KHQR',
      category: CambodiaPaymentCategory.mobileBanking,
      primaryColor: Color(0xFFC8102E),
      accentColor: Color(0xFFFF6F7D),
      icon: Icons.account_balance_rounded,
      bankCode: 'CANADIA',
      appScheme: 'canadiamobile://',
    ),

    // 6. Pi Pay
    CambodiaPaymentMethod(
      id: 'pi_pay',
      name: 'Pi Pay',
      nameKhmer: 'ផាយ ផេ (Pi Pay)',
      subtitle: 'Cambodia’s premier lifestyle e-wallet',
      category: CambodiaPaymentCategory.eWallet,
      primaryColor: Color(0xFFEC008C),
      accentColor: Color(0xFFFF66B3),
      icon: Icons.wallet_rounded,
      bankCode: 'PIPAY',
      appScheme: 'pipay://',
    ),

    // 7. TrueMoney Cambodia
    CambodiaPaymentMethod(
      id: 'truemoney',
      name: 'TrueMoney Cambodia',
      nameKhmer: 'ទ្រូម៉ាន់នី (TrueMoney)',
      subtitle: 'Pay with TrueMoney wallet or agents',
      category: CambodiaPaymentCategory.eWallet,
      primaryColor: Color(0xFFFF6F00),
      accentColor: Color(0xFFFFB74D),
      icon: Icons.payments_rounded,
      bankCode: 'TRUEMONEY',
      appScheme: 'truemoney://',
    ),

    // 8. Prince Bank
    CambodiaPaymentMethod(
      id: 'prince_bank',
      name: 'Prince Bank',
      nameKhmer: 'ធនាគារ ព្រីនស៍',
      subtitle: 'Prince Mobile Banking & Prince Pay',
      category: CambodiaPaymentCategory.mobileBanking,
      primaryColor: Color(0xFF1B2A4A),
      accentColor: Color(0xFF4A6999),
      icon: Icons.account_balance_rounded,
      bankCode: 'PRINCE',
      appScheme: 'princemobile://',
    ),

    // 9. Chip Mong Bank
    CambodiaPaymentMethod(
      id: 'chip_mong',
      name: 'Chip Mong Bank',
      nameKhmer: 'ធនាគារ ជីប ម៉ុង',
      subtitle: 'Chip Mong Mobile Banking & KHQR',
      category: CambodiaPaymentCategory.mobileBanking,
      primaryColor: Color(0xFF00A3E0),
      accentColor: Color(0xFF80D6FF),
      icon: Icons.account_balance_rounded,
      bankCode: 'CHIPMONG',
      appScheme: 'chipmong://',
    ),

    // 10. Credit / Debit Card (Visa, Mastercard, UnionPay, JCB)
    CambodiaPaymentMethod(
      id: 'card',
      name: 'Credit / Debit Card',
      nameKhmer: 'កាតឥណទាន / ឥណពន្ធ',
      subtitle: 'Visa, Mastercard, JCB, UnionPay (Local & Int’l)',
      category: CambodiaPaymentCategory.card,
      primaryColor: Color(0xFF334155),
      accentColor: Color(0xFF64748B),
      icon: Icons.credit_card_rounded,
      badgeText: 'Int’l & Local',
      bankCode: 'CARD',
      appScheme: '',
    ),
  ];
}
