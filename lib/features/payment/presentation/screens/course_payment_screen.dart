import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../courses/presentation/providers/course_providers.dart';
import '../../../enrollment/presentation/providers/enrollment_providers.dart';
import '../../domain/entities/cambodia_payment_method.dart';
import '../widgets/card_payment_form.dart';
import '../widgets/khqr_card_widget.dart';
import '../widgets/payment_method_tile.dart';
import '../widgets/payment_success_dialog.dart';

class CoursePaymentScreen extends ConsumerStatefulWidget {
  final String courseId;

  const CoursePaymentScreen({super.key, required this.courseId});

  @override
  ConsumerState<CoursePaymentScreen> createState() => _CoursePaymentScreenState();
}

class _CoursePaymentScreenState extends ConsumerState<CoursePaymentScreen> {
  late CambodiaPaymentMethod _selectedMethod;
  String _currency = 'USD'; // 'USD' or 'KHR'
  bool _isProcessing = false;
  late String _billReference;

  // Card controllers
  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCvvController = TextEditingController();
  final _cardHolderController = TextEditingController();

  // Filter category
  CambodiaPaymentCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedMethod = CambodiaPaymentRegistry.allMethods.first; // Default to Bakong KHQR
    _generateReference();
  }

  void _generateReference() {
    final randomNum = 100000 + Random().nextInt(900000);
    _billReference = 'KHQR-EDL-$randomNum';
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  Future<void> _processPayment(String courseTitle, double priceUsd) async {
    setState(() => _isProcessing = true);

    // Simulate network handshake with Cambodia Bakong / Bank payment switch
    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;

    // Enroll student in the course
    final success = await ref.read(enrollmentNotifierProvider.notifier).enroll(widget.courseId);

    setState(() => _isProcessing = false);

    if (success && mounted) {
      final user = ref.read(currentUserProvider);
      final studentName = user?.fullName ?? 'Dara Somnang';

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => PaymentSuccessDialog(
          courseId: widget.courseId,
          courseTitle: courseTitle,
          studentName: studentName,
          amountUsd: priceUsd,
          currency: _currency,
          paymentMethod: _selectedMethod,
          transactionId: _billReference,
        ),
      );
    } else if (mounted) {
      AppSnackbar.showError(context, 'Payment verification failed. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final courseAsync = ref.watch(courseDetailProvider(widget.courseId));

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Checkout & Payment'),
            Text(
              'ការទូទាត់ប្រាក់នៅកម្ពុជា',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              borderRadius: AppRadius.fullRadius,
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_rounded, size: 12, color: AppColors.success),
                SizedBox(width: 4),
                Text(
                  'NBC KHQR Secure',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: courseAsync.when(
        data: (course) {
          final isEnrolled = ref.watch(isCourseEnrolledProvider(widget.courseId)).valueOrNull ?? false;

          if (isEnrolled) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 64),
                    const SizedBox(height: 16),
                    const Text('Already Enrolled!', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 8),
                    const Text('You have already enrolled in this course. Access all lessons now.'),
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Go to Lessons',
                      icon: Icons.play_arrow_rounded,
                      onPressed: () => context.pushReplacement('/learning/${course.id}'),
                    ),
                  ],
                ),
              ),
            );
          }

          final priceUsd = course.price > 0 ? course.price : 49.99;
          final khrFormatted = CambodiaPaymentRegistry.formatKhr(priceUsd);
          final usdFormatted = '\$${priceUsd.toStringAsFixed(2)}';

          // Filter payment methods based on selected category tab
          final displayedMethods = _selectedCategory == null
              ? CambodiaPaymentRegistry.allMethods
              : CambodiaPaymentRegistry.allMethods
                  .where((m) => m.category == _selectedCategory)
                  .toList();

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Course Summary Card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : Colors.white,
                          borderRadius: AppRadius.lgRadius,
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: AppRadius.mdRadius,
                              child: CachedNetworkImage(
                                imageUrl: course.imageUrl,
                                width: 84,
                                height: 84,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Container(
                                  width: 84,
                                  height: 84,
                                  color: AppColors.primaryLight,
                                  child: const Icon(Icons.school, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StatusBadge(text: course.categoryName, type: BadgeType.info),
                                  const SizedBox(height: 6),
                                  Text(
                                    course.title,
                                    style: AppTextStyles.titleMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Instructor: ${course.instructorName}',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 2. Price Breakdown & Currency Selector
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : Colors.white,
                          borderRadius: AppRadius.lgRadius,
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Payment Currency', style: AppTextStyles.titleSmall),
                                // Currency Switcher
                                Container(
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                                    borderRadius: AppRadius.fullRadius,
                                    border: Border.all(
                                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildCurrencyOption('USD', '\$ USD'),
                                      _buildCurrencyOption('KHR', '៛ KHR'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _buildPriceLine('Course Price', usdFormatted, isDark),
                            const SizedBox(height: 6),
                            _buildPriceLine('Platform Service Fee', 'Free', isDark, isHighlight: true),
                            const SizedBox(height: 6),
                            _buildPriceLine(
                              'Central Bank Exchange Rate',
                              '1 USD ≈ 4,100 KHR',
                              isDark,
                              isMuted: true,
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Total Amount', style: AppTextStyles.titleMedium),
                                    Text(
                                      _currency == 'KHR' ? '($usdFormatted USD)' : '($khrFormatted KHR)',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  _currency == 'KHR' ? khrFormatted : usdFormatted,
                                  style: AppTextStyles.headlineSmall.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 3. Cambodian Payment Methods Section Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Payment Method',
                                style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'ជម្រើសទូទាត់ប្រាក់នៅប្រទេសកម្ពុជា (KHQR / Banks)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Category Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('All Cambodian Payments (10)', null),
                            const SizedBox(width: 8),
                            _buildFilterChip('KHQR & Banks (7)', CambodiaPaymentCategory.mobileBanking),
                            const SizedBox(width: 8),
                            _buildFilterChip('E-Wallets (2)', CambodiaPaymentCategory.eWallet),
                            const SizedBox(width: 8),
                            _buildFilterChip('Cards (1)', CambodiaPaymentCategory.card),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Payment Method Tiles List
                      ...displayedMethods.map((method) => PaymentMethodTile(
                            method: method,
                            isSelected: _selectedMethod.id == method.id,
                            onTap: () {
                              setState(() {
                                _selectedMethod = method;
                                if (method.category != CambodiaPaymentCategory.card) {
                                  _generateReference();
                                }
                              });
                            },
                          )),

                      const SizedBox(height: 16),

                      // 4. If Card Selected -> Show Card Form; If QR/Bank -> Show KHQR preview card
                      if (_selectedMethod.category == CambodiaPaymentCategory.card) ...[
                        CardPaymentForm(
                          cardNumberController: _cardNumberController,
                          expiryController: _cardExpiryController,
                          cvvController: _cardCvvController,
                          nameController: _cardHolderController,
                        ),
                      ] else ...[
                        Text(
                          'Payment Details (${_selectedMethod.name})',
                          style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),
                        KhqrCardWidget(
                          method: _selectedMethod,
                          amountUsd: priceUsd,
                          billReference: _billReference,
                          currency: _currency,
                        ),
                      ],

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Bottom Pay Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total Payable',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                        Text(
                          _currency == 'KHR' ? khrFormatted : usdFormatted,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.w900,
                            color: _selectedMethod.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: AppButton(
                        text: _selectedMethod.category == CambodiaPaymentCategory.card
                            ? 'Pay with Card'
                            : 'Confirm & Verify Payment',
                        icon: _selectedMethod.category == CambodiaPaymentCategory.card
                            ? Icons.credit_card_rounded
                            : Icons.check_circle_outline_rounded,
                        isLoading: _isProcessing,
                        onPressed: _isProcessing
                            ? null
                            : () => _processPayment(course.title, priceUsd),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Scaffold(body: LoadingView(message: 'Preparing Cambodian payment checkout...')),
        error: (e, _) => Scaffold(
          body: ErrorView(
            message: e.toString(),
            onRetry: () => ref.invalidate(courseDetailProvider(widget.courseId)),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyOption(String code, String label) {
    final isSelected = _currency == code;
    return InkWell(
      onTap: () => setState(() => _currency = code),
      borderRadius: AppRadius.fullRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: AppRadius.fullRadius,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppColors.textSecondaryLight,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, CambodiaPaymentCategory? category) {
    final isSelected = _selectedCategory == category;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedCategory = category),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : Colors.black87),
      ),
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.fullRadius,
        side: BorderSide(
          color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
      ),
    );
  }

  Widget _buildPriceLine(String title, String value, bool isDark, {bool isHighlight = false, bool isMuted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: isMuted
                ? (isDark ? AppColors.textMutedDark : AppColors.textMutedLight)
                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
            color: isHighlight
                ? AppColors.success
                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
      ],
    );
  }
}
