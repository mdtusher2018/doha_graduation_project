import 'dart:convert';

import 'package:doha_graduation_project/core/di/core_providers.dart';
import 'package:doha_graduation_project/core/utils/extensions/context_ext.dart';
import 'package:doha_graduation_project/core/utils/helper.dart';
import 'package:doha_graduation_project/scr/controllers/dash_board_notifier.dart';
import 'package:doha_graduation_project/scr/models/dashboard_model.dart';
import 'package:doha_graduation_project/scr/views/screens/splash/role_selection_screen.dart';
import 'package:doha_graduation_project/scr/views/shared/widgets/app_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:doha_graduation_project/scr/views/shared/designs/background_design.dart';
import 'package:doha_graduation_project/scr/views/shared/widgets/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/extensions/num_ext.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_text.dart';
import '../../shared/widgets/app_avatar.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(dashboardNotifierProvider.notifier).fetchDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(dashboardNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: (dashboard == null || dashboard.user == null)
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                _SliverHeader(user: dashboard.user!),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _SeatCard(seat: dashboard.user?.seat ?? "N/A"),
                      16.verticalSpace,
                      _QrCard(user: dashboard.user!),
                      16.verticalSpace,
                      if (dashboard.event != null)
                        _EventDetailsCard(event: dashboard.event!),
                      16.verticalSpace,
                      _AnnouncementsCard(
                        announcements: dashboard.announcements,
                      ),
                      16.verticalSpace,
                      if (dashboard.event != null)
                        _WhatsIncludedCard(included: dashboard.event!.included),
                      16.verticalSpace,
                      if (dashboard.event != null)
                        _InstructionsCard(
                          instructions: dashboard.event!.instructions,
                        ),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }
}

class _SliverHeader extends ConsumerWidget {
  final User user;
  const _SliverHeader({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,

      backgroundColor: AppColors.black,
      automaticallyImplyLeading: false,

      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final double maxHeight = 250;
          final double minHeight = 120;
          final double currentHeight = constraints.biggest.height;

          // collapse progress (0 = expanded, 1 = collapsed)
          final double t =
              ((maxHeight - currentHeight) / (maxHeight - minHeight)).clamp(
                0.0,
                1.0,
              );

          return ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                /// 🌈 Background
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF9B1A2E), AppColors.primaryDark],
                    ),
                  ),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          // less visible (left)
                          Colors.white.withOpacity(0.1), // less visible (left)
                          Colors.white.withOpacity(0.2), // less visible (left)
                          Colors.white, // fully visible (right)
                        ],
                      ).createShader(bounds);
                    },

                    child: CustomPaint(painter: SymbolPatternPainter()),
                  ),
                ),

                /// 👤 BIG HEADER (fade out + slight move up)
                Positioned.fill(
                  child: Opacity(
                    opacity: 1 - t,
                    child: Transform.translate(
                      offset: Offset(0, -20 * t), // 👈 smooth upward motion
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown, // 👈 prevents overflow
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppAvatar(
                                imageUrl: user.image,
                                name: user.name,
                                customSize: 80,
                                backgroundColor: AppColors.white.withOpacity(
                                  0.3,
                                ),
                              ),
                              8.verticalSpace,
                              AppText.bodyLg(
                                'Welcome ${user.name}',
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              AppText.bodySm(user.email, color: Colors.white),
                              AppText.labelMd(
                                user.section,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                height: 30,
                                width: 140,
                                child: AppButton.outline(
                                  label: "Logout",
                                  onPressed: () async {
                                    await ref
                                        .read(localStorageProvider)
                                        .clearAll();
                                    context.navigateTo(
                                      RoleSelectionScreen(),
                                      clearStack: true,
                                    );
                                  },
                                  borderRadius: 8.circular,
                                  textColor: AppColors.white,
                                  suffixIcon: Icon(
                                    Icons.logout,
                                    color: AppColors.white,
                                  ),
                                  borderColor: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// 👤 SMALL HEADER (fade in + slide from bottom)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - t)), // 👈 slide up
                      child: Row(
                        children: [
                          AppAvatar(
                            imageUrl: user.image,
                            name: user.name,
                            customSize: 36,
                            backgroundColor: AppColors.white.withOpacity(0.3),
                          ),
                          8.horizontalSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText.labelSm(
                                  'Welcome ${user.name.split(' ').first}',
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                AppText.labelSm(
                                  user.email,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Seat card ────────────────────────────────────────────────────────────────

class _SeatCard extends StatelessWidget {
  final String seat;

  const _SeatCard({required this.seat});
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText.labelLg(
            'Your Seat Assignment',

            fontWeight: FontWeight.w500,
          ),
          16.verticalSpace,
          Center(
            child: AppText(
              seat,
              style: AppTextStyles.display.copyWith(
                fontSize: 48,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
              ),
            ),
          ),
          12.verticalSpace,
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: 20.circular,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.done, color: AppColors.white, size: 16),
                  6.horizontalSpace,
                  const AppText.bodySm(
                    'Confirmed',
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── QR card ─────────────────────────────────────────────────────────────────

class _QrCard extends StatelessWidget {
  final User user;

  const _QrCard({required this.user});

  String generateQrData() {
    final data = {
      "name": user.name,
      "email": user.email,
      "section": user.section,
      "role": user.role,
      'seat': user.seat,
    };

    return jsonEncode(data);
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE7F6),
                  borderRadius: 10.circular,
                ),
                child: const Icon(
                  Icons.qr_code_2_rounded,
                  color: Color(0xFF6A1B9A),
                  size: 20,
                ),
              ),
              12.horizontalSpace,
              const AppText.h4('Your QR Code'),
            ],
          ),
          20.verticalSpace,

          Center(
            child: QrImageView(
              data: generateQrData(), // 🔥 HERE
              version: QrVersions.auto,
              size: 180,
            ),
          ),

          16.verticalSpace,
          const Center(
            child: AppText.bodySm(
              'Show this QR code at the venue entrance for instant check-in',
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Event details card ──────────────────────────────────────────────────────

class _EventDetailsCard extends StatelessWidget {
  final Event event;

  const _EventDetailsCard({required this.event});

  Future<void> launchMap(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return "N/A";
    return DateFormat('EEEE, MMM d, yyyy').format(date);
  }

  String formatTimeRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return "N/A";

    final startFormatted = DateFormat('hh:mm a').format(start);
    final endFormatted = DateFormat('hh:mm a').format(end);

    return "$startFormatted – $endFormatted";
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ─────────────────────────
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.info,
                ),
              ),
              12.horizontalSpace,
              const AppText.h4('Event Details'),
            ],
          ),

          20.verticalSpace,

          // ─── Location ───────────────────────
          _DetailRow(
            icon: Icons.event,
            iconColor: AppColors.divider,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.h4(event.name, fontWeight: FontWeight.w600),
                AppText.bodySm(
                  event.location?.venue ?? "N/A",
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),

          AppDivider(color: AppColors.border, height: 14),

          // ─── Location ───────────────────────
          _DetailRow(
            icon: Icons.location_on_outlined,
            iconColor: AppColors.divider,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.bodyMd(
                  event.location?.address ?? "N/A",
                  fontWeight: FontWeight.w500,
                ),

                GestureDetector(
                  onTap: () {
                    final mapLink = event.location?.mapLink ?? '';
                    if (mapLink.isNotEmpty) {
                      launchMap(mapLink);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText.bodySm(
                        'Open in Maps',
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      4.horizontalSpace,
                      const Icon(
                        Icons.open_in_new_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          AppDivider(color: AppColors.border, height: 14),

          // ─── Time ───────────────────────────
          _DetailRow(
            icon: Icons.access_time_outlined,
            iconColor: AppColors.divider,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.labelMd(
                  formatDate(event.date),
                  fontWeight: FontWeight.w600,
                ),
                AppText.labelMd(
                  formatTimeRange(event.startTime, event.endTime),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Widget child;

  const _DetailRow({
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            borderRadius: 8.circular,
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        12.horizontalSpace,
        Expanded(child: child),
      ],
    );
  }
}

// ─── Announcements card ──────────────────────────────────────────────────────

class _AnnouncementsCard extends StatelessWidget {
  final List<Announcement> announcements;

  const _AnnouncementsCard({required this.announcements});
  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.warning,
                  ),
                ),
                12.horizontalSpace,
                const AppText.h4('Announcements'),
              ],
            ),
          ),

          ...announcements.map((a) => _AnnouncementTile(item: a)),
          8.verticalSpace,
        ],
      ),
    );
  }
}

class _AnnouncementTile extends StatelessWidget {
  final Announcement item;
  const _AnnouncementTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.labelMd(item.title, fontWeight: FontWeight.w600),
                  4.verticalSpace,
                  AppText.bodySm(
                    item.description,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            8.horizontalSpace,
            AppText.bodyXs(
              timeAgo(item.createdAt),
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── What's included card ─────────────────────────────────────────────────────

class _WhatsIncludedCard extends StatelessWidget {
  final List<Included> included;

  const _WhatsIncludedCard({required this.included});
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: 10.circular,
                ),
                child: const Icon(
                  Icons.card_giftcard_outlined,
                  color: AppColors.success,
                  size: 20,
                ),
              ),
              12.horizontalSpace,
              const AppText.h4("What's Included"),
            ],
          ),
          20.verticalSpace,
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: included.map((i) => _IncludedTile(item: i)).toList(),
          ),
        ],
      ),
    );
  }
}

class _IncludedTile extends StatelessWidget {
  final Included item;
  const _IncludedTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.07),
        borderRadius: 12.circular,
        border: Border.all(color: AppColors.success),
      ),
      child: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: 12.paddingAll,
                  child: Image.network(
                    getFullImagePath(item.image),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        color: AppColors.divider,
                      );
                    },
                  ),
                ),
              ),
              AppText.bodyXs(
                item.title,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Icon(
              Icons.check_circle_outline_outlined,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Instructions card ────────────────────────────────────────────────────────

class _InstructionsCard extends StatelessWidget {
  final List<String> instructions;

  const _InstructionsCard({required this.instructions});
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.success,
                  size: 20,
                ),
              ),
              12.horizontalSpace,
              const AppText.h4('Important Instructions'),
            ],
          ),
          20.verticalSpace,
          ...instructions.asMap().entries.map(
            (e) => _InstructionRow(number: e.key + 1, text: e.value),
          ),
        ],
      ),
    );
  }
}

class _InstructionRow extends StatelessWidget {
  final int number;
  final String text;

  const _InstructionRow({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: 6.circular,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: AppText(
                '$number',
                style: AppTextStyles.bodyXs.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            12.horizontalSpace,
            Expanded(child: AppText.bodyMd(text, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
