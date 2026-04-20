import 'package:doha_graduation_project/shared/widgets/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions/num_ext.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text.dart';
import '../../../shared/widgets/app_avatar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── Crimson header ─────────────────────────────
          _SliverHeader(),

          // ─── Body ────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SeatCard(),
                16.verticalSpace,
                _QrCard(),
                16.verticalSpace,
                _EventDetailsCard(),
                16.verticalSpace,
                _AnnouncementsCard(),
                16.verticalSpace,
                _WhatsIncludedCard(),
                16.verticalSpace,
                _InstructionsCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sliver header ────────────────────────────────────────────────────────────
class _SliverHeader extends StatelessWidget {
  const _SliverHeader();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
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

          return Stack(
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
                child: CustomPaint(painter: _HeaderPatternPainter()),
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
                              imageUrl: null,
                              name: 'Ahmed Mohamed',
                              customSize: 80,
                              backgroundColor: AppColors.white.withOpacity(0.3),
                            ),
                            8.verticalSpace,
                            const AppText.bodyLg(
                              'Welcome Ahmed',
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            const AppText.bodySm(
                              'ahmed@university.edu',
                              color: Colors.white,
                            ),
                            const AppText.labelMd(
                              'Engineering',
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
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
                          imageUrl: null,
                          name: 'Ahmed Mohamed',
                          customSize: 36,
                          backgroundColor: AppColors.white.withOpacity(0.3),
                        ),
                        8.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              AppText.labelSm(
                                'Welcome Ahmed',
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              AppText.labelSm(
                                'ahmed@university.edu',
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
          );
        },
      ),
    );
  }
}

// ─── Seat card ────────────────────────────────────────────────────────────────

class _SeatCard extends StatelessWidget {
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
              'A-101',
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
              data: 'DOHA_INST_GRAD_2026_AHMED_A101',
              version: QrVersions.auto,
              size: 180,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: AppColors.textPrimary,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: AppColors.textPrimary,
              ),
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
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          _DetailRow(
            icon: Icons.location_on_outlined,
            iconColor: AppColors.divider,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText.labelMd(
                  'University Grand Auditorium',
                  fontWeight: FontWeight.w600,
                ),

                const AppText.bodySm(
                  '123 Campus Drive, University City',
                  color: AppColors.textSecondary,
                ),

                GestureDetector(
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
          _DetailRow(
            icon: Icons.perm_contact_calendar_outlined,
            iconColor: AppColors.divider,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText.labelMd(
                  'Saturday, May 15, 2026',
                  fontWeight: FontWeight.w600,
                ),
                const AppText.bodySm(
                  '123 Campus Drive, University City',
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          AppDivider(color: AppColors.border, height: 14),
          _DetailRow(
            icon: Icons.access_time_outlined,
            iconColor: AppColors.divider,
            child: const AppText.labelMd(
              '10:00 AM – 2:00 PM',
              fontWeight: FontWeight.w600,
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
  static const _items = [
    _Announcement(
      title: 'Dress Code Reminder',
      body: 'Formal attire required. Gowns will be provided at the venue.',
      timeAgo: '2 hours ago',
    ),
    _Announcement(
      title: 'Arrive Early',
      body: 'Please arrive 1 hour before the ceremony starts for check-in.',
      timeAgo: '1 day ago',
    ),
    _Announcement(
      title: 'Photography Session',
      body: 'Professional photography will be available after the ceremony.',
      timeAgo: '2 days ago',
    ),
  ];

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

          ..._items.map((a) => _AnnouncementTile(item: a)),
          8.verticalSpace,
        ],
      ),
    );
  }
}

class _Announcement {
  final String title;
  final String body;
  final String timeAgo;
  const _Announcement({
    required this.title,
    required this.body,
    required this.timeAgo,
  });
}

class _AnnouncementTile extends StatelessWidget {
  final _Announcement item;
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
                  AppText.bodySm(item.body, color: AppColors.textSecondary),
                ],
              ),
            ),
            8.horizontalSpace,
            AppText.bodyXs(
              item.timeAgo,
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
  static const _items = [
    _IncludedItem(
      icon: "assets/images/graduations.png",
      label: 'Graduation Gown & Cap',
    ),
    _IncludedItem(
      icon: "assets/images/refreshments.png",
      label: 'Refreshments',
    ),
    _IncludedItem(icon: "assets/images/cirtificates.png", label: 'Certificate'),
    _IncludedItem(icon: "assets/images/souvenir.png", label: 'Souvenir Photo'),
  ];

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
            children: _items.map((i) => _IncludedTile(item: i)).toList(),
          ),
        ],
      ),
    );
  }
}

class _IncludedItem {
  final String icon;
  final String label;
  const _IncludedItem({required this.icon, required this.label});
}

class _IncludedTile extends StatelessWidget {
  final _IncludedItem item;
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
              Expanded(child: Image.asset(item.icon, height: 60)),
              AppText.bodyXs(
                item.label,
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
  static const _instructions = [
    'Arrive at least 1 hour before ceremony',
    'Bring a valid ID for verification',
    'Mobile phones must be on silent mode',
    'Follow the dress code guidelines',
    'Guests must have separate registration',
  ];

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
          ..._instructions.asMap().entries.map(
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

// ─── Header background painter ────────────────────────────────────────────────

class _HeaderPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const step = 50.0;
    final cols = (size.width / step).ceil() + 2;
    final rows = (size.height / step).ceil() + 2;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final cx = c * step - 10;
        final cy = r * step - 10;
        const half = step * 0.35;
        final path = Path()
          ..moveTo(cx, cy - half)
          ..lineTo(cx + half, cy)
          ..lineTo(cx, cy + half)
          ..lineTo(cx - half, cy)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
