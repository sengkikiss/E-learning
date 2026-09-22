import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/certificate_card.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import 'package:e_learning/features/progress/presentation/providers/progress_providers.dart';

class CertificatesScreen extends ConsumerWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final certsAsync = ref.watch(certificatesProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(title: const Text('My Certificates')),
      body: SafeArea(
        child: certsAsync.when(
          data: (certificates) {
            if (certificates.isEmpty) {
              return const EmptyView(
                title: 'No certificates yet',
                message: 'Complete 100% of a course, its quizzes, and assignments to earn your verified credentials.',
                icon: Icons.workspace_premium_outlined,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: certificates.length,
              itemBuilder: (context, index) {
                final cert = certificates[index];
                return CertificateCard(
                  certificate: cert,
                  onTap: () => context.push('/certificates/${cert.id}'),
                );
              },
            );
          },
          loading: () => const LoadingView(message: 'Loading certificates...'),
          error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(certificatesProvider)),
        ),
      ),
    );
  }
}
