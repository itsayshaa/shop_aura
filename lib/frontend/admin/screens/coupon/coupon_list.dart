import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/admin/screens/coupon/coupon.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/frontend/admin/service/couponService.dart';
import 'package:shop_aura/backend/models/client/coupon/CouponModel.dart';

class _Breakpoints {
  static const double tablet = 640;
  static const double desktop = 1024;
  static const double wide = 1440;
  static const double maxContentWidth = 1280;
}

int _gridColumnsFor(double width) {
  if (width >= _Breakpoints.wide) return 4;
  if (width >= _Breakpoints.desktop) return 3;
  if (width >= _Breakpoints.tablet) return 2;
  return 1;
}

bool _isCompact(double width) => width < _Breakpoints.tablet;

class CouponListScreen extends StatefulWidget {
  const CouponListScreen({super.key});

  @override
  State<CouponListScreen> createState() => _CouponListScreenState();
}

enum _StatusFilter { all, active, inactive, expired }

extension on _StatusFilter {
  String get label {
    switch (this) {
      case _StatusFilter.all:
        return 'All';
      case _StatusFilter.active:
        return 'Active';
      case _StatusFilter.inactive:
        return 'Inactive';
      case _StatusFilter.expired:
        return 'Expired';
    }
  }
}

class _CouponListScreenState extends State<CouponListScreen> {
  final _searchCtrl = TextEditingController();
  late Future<List<CouponModel>> _future;
  List<CouponModel> _all = [];
  String _query = '';
  _StatusFilter _filter = _StatusFilter.all;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<List<CouponModel>> _load() async {
    final coupons = await CouponService.instance.getCoupons();
    _all = coupons;
    return coupons;
  }

  Future<void> _refresh() async {
    final data = await _load();
    setState(() => _future = Future.value(data));
  }

  bool _isExpired(CouponModel c) => c.expiryDate.isBefore(DateTime.now());

  List<CouponModel> _applyFilters(List<CouponModel> source) {
    Iterable<CouponModel> result = source;

    switch (_filter) {
      case _StatusFilter.all:
        break;
      case _StatusFilter.active:
        result = result.where(
          (c) => c.status.toLowerCase() == 'active' && !_isExpired(c),
        );
        break;
      case _StatusFilter.inactive:
        result = result.where((c) => c.status.toLowerCase() == 'inactive');
        break;
      case _StatusFilter.expired:
        result = result.where(_isExpired);
        break;
    }

    if (_query.trim().isNotEmpty) {
      final q = _query.trim().toLowerCase();
      result = result.where(
        (c) =>
            c.code.toLowerCase().contains(q) ||
            c.name.toLowerCase().contains(q),
      );
    }

    return result.toList();
  }

  Future<void> _confirmDelete(CouponModel coupon) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text(
          'Delete coupon?',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'This will permanently remove "${coupon.code}". This action cannot be undone.',
          style: const TextStyle(color: AppColors.textGrey, fontSize: 13.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textGrey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      if (coupon.id != null) {
       final message = await CouponService.instance.deleteCoupon(coupon.id!);
      
      setState(() => _all.removeWhere((c) => c.id == coupon.id));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          content: Text(message),
        ),
      );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.danger,
          content: Text('Failed to delete: $e'),
        ),
      );
    }
  }

  Future<void> _toggleStatus(CouponModel coupon) async {
    final newStatus = coupon.status.toLowerCase() == 'active'
        ? 'Inactive'
        : 'Active';
    try {
      final message = await CouponService.instance.changeCouponStatus(coupon.id, newStatus);
      setState(() {
        final index = _all.indexWhere((c) => c.id == coupon.id);
        if (index != -1) _all[index] = coupon.copyWith(status: newStatus);
      });
      if(!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          content: Text(message),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.danger,
          content: Text('Failed to update status: $e'),
        ),
      );
    }
  }

  void _openDetails(CouponModel coupon) {
    final compact = _isCompact(MediaQuery.of(context).size.width);
    final sheet = _CouponDetailsSheet(
      coupon: coupon,
      onDelete: () {
        Navigator.pop(context);
        _confirmDelete(coupon);
      },
      onToggleStatus: () {
        Navigator.pop(context);
        _toggleStatus(coupon);
      },
      onEdit: ()async{
        Navigator.pop(context);
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CouponFormScreen(
            coupon: coupon,
          ))
        );
        if(result == true){
          _refresh();
        }
      }
    );

    if (compact) {
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.transparent,
        isScrollControlled: true,
        builder: (context) => sheet,
      );
    } else {
      showDialog(
        context: context,
        barrierColor: AppColors.black.withOpacity(0.35),
        builder: (context) => sheet,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final compact = _isCompact(width);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            centerTitle: false,
            iconTheme: const IconThemeData(color: AppColors.textDark),
            title: const Text(
              'Coupons',
              style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            actions: compact
                ? null
                : [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _NewCouponButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: AppColors.border),
            ),
          ),
          floatingActionButton: compact
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: AppColors.primary,
                  icon: const Icon(Icons.add_rounded, color: AppColors.white),
                  label: const Text(
                    'New Coupon',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : null,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: _Breakpoints.maxContentWidth,
              ),
              child: Column(
                children: [
                  _FilterBar(
                    compact: compact,
                    searchCtrl: _searchCtrl,
                    query: _query,
                    filter: _filter,
                    onQueryChanged: (v) => setState(() => _query = v),
                    onQueryCleared: () {
                      _searchCtrl.clear();
                      setState(() => _query = '');
                    },
                    onFilterChanged: (f) => setState(() => _filter = f),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: _refresh,
                      child: FutureBuilder<List<CouponModel>>(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return _ErrorState(
                              message: '${snapshot.error}',
                              onRetry: _refresh,
                            );
                          }

                          final filtered = _applyFilters(_all);
                          if (filtered.isEmpty) {
                            return _EmptyState(
                              onCreate: () {
                                Navigator.pop(context);
                              },
                            );
                          }

                          final columns = _gridColumnsFor(width);

                          if (columns == 1) {
                            return ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                4,
                                16,
                                100,
                              ),
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final coupon = filtered[index];
                                return Dismissible(
                                  key: ValueKey(coupon.id),
                                  direction: DismissDirection.endToStart,
                                  confirmDismiss: (_) async {
                                    await _confirmDelete(coupon);
                                    return false;
                                  },
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                      color: AppColors.dangerBackground,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: AppColors.danger,
                                    ),
                                  ),
                                  child: _CouponListTile(
                                    coupon: coupon,
                                    expired: _isExpired(coupon),
                                    onTap: () => _openDetails(coupon),
                                    onToggleStatus: () => _toggleStatus(coupon),
                                    onDelete: () => _confirmDelete(coupon),
                                  ),
                                );
                              },
                            );
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                  childAspectRatio: 2.05,
                                ),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final coupon = filtered[index];
                              return _CouponListTile(
                                coupon: coupon,
                                expired: _isExpired(coupon),
                                onTap: () => _openDetails(coupon),
                                onToggleStatus: () => _toggleStatus(coupon),
                                onDelete: () => _confirmDelete(coupon),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// SEARCH + FILTER BAR (stacks on mobile, single row from tablet up)
// ============================================================

class _FilterBar extends StatelessWidget {
  final bool compact;
  final TextEditingController searchCtrl;
  final String query;
  final _StatusFilter filter;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onQueryCleared;
  final ValueChanged<_StatusFilter> onFilterChanged;

  const _FilterBar({
    required this.compact,
    required this.searchCtrl,
    required this.query,
    required this.filter,
    required this.onQueryChanged,
    required this.onQueryCleared,
    required this.onFilterChanged,
  });

  Widget _searchField() {
    return TextField(
      controller: searchCtrl,
      onChanged: onQueryChanged,
      style: const TextStyle(color: AppColors.textDark, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Search by code or title',
        hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13.5),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.textGrey,
          size: 20,
        ),
        suffixIcon: query.isEmpty
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColors.textGrey,
                  size: 18,
                ),
                onPressed: onQueryCleared,
              ),
        filled: true,
        fillColor: AppColors.surface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
    );
  }

  Widget _filterChips({bool scrollable = true}) {
    final chips = _StatusFilter.values.map((f) {
      final selected = f == filter;
      return ChoiceChip(
        label: Text(f.label),
        selected: selected,
        onSelected: (_) => onFilterChanged(f),
        labelStyle: TextStyle(
          color: selected ? AppColors.white : AppColors.textDark,
          fontWeight: FontWeight.w700,
          fontSize: 12.5,
        ),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.border,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      );
    }).toList();

    if (!scrollable) {
      return Wrap(spacing: 8, runSpacing: 8, children: chips);
    }

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) => chips[i],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: _searchField(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _filterChips(),
          ),
        ],
      );
    }

    // Tablet / desktop: search and filters share one row.
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 320, child: _searchField()),
          const SizedBox(width: 16),
          Expanded(child: _filterChips(scrollable: false)),
        ],
      ),
    );
  }
}

class _NewCouponButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _NewCouponButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, size: 18, color: AppColors.white),
              SizedBox(width: 6),
              Text(
                'New Coupon',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// LIST / GRID TILE — same card works in both layouts
// ============================================================

class _CouponListTile extends StatelessWidget {
  final CouponModel coupon;
  final bool expired;
  final VoidCallback onTap;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;

  const _CouponListTile({
    required this.coupon,
    required this.expired,
    required this.onTap,
    required this.onToggleStatus,
    required this.onDelete,
  });

  bool get _isActive => coupon.status.toLowerCase() == 'active' && !expired;

  IconData get _icon {
    final t = coupon.type.toLowerCase();
    if (t.contains('%')) return Icons.percent_rounded;
    if (t.contains('flat')) return Icons.sell_rounded;
    if (t.contains('balance') || t.contains('cashback')) {
      return Icons.account_balance_wallet_rounded;
    }
    if (t.contains('shipping')) return Icons.local_shipping_rounded;
    if (t.contains('buy')) return Icons.redeem_rounded;
    return Icons.local_offer_rounded;
  }

  String get _valueLabel {
    final t = coupon.type.toLowerCase();
    if (t.contains('%')) return '${coupon.discount.toStringAsFixed(0)}%';
    if (t.contains('shipping')) return 'FREE';
    if (t.contains('buy')) return '1+1';
    return '₹${coupon.discount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_icon, color: AppColors.white, size: 16),
                    const SizedBox(height: 2),
                    Text(
                      _valueLabel,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            coupon.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _StatusPill(active: _isActive, expired: expired),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.confirmation_number_outlined,
                          size: 12,
                          color: AppColors.textGrey,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            coupon.code,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.schedule_rounded,
                          size: 12,
                          color: AppColors.textGrey,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            _formatDate(coupon.expiryDate),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Switch(
                value: coupon.status.toLowerCase() == 'active',
                onChanged: expired ? null : (_) => onToggleStatus(),
                activeThumbColor: AppColors.white,
                activeTrackColor: AppColors.primary,
                inactiveThumbColor: AppColors.white,
                inactiveTrackColor: AppColors.border,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool active;
  final bool expired;
  const _StatusPill({required this.active, required this.expired});

  @override
  Widget build(BuildContext context) {
    final String label = expired ? 'Expired' : (active ? 'Active' : 'Inactive');
    final Color fg = expired
        ? AppColors.danger
        : (active ? AppColors.success : AppColors.textGrey);
    final Color bg = expired
        ? AppColors.dangerBackground
        : (active ? AppColors.successBackground : const Color(0xFFF1F1F4));

    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ============================================================
// DETAILS SHEET / DIALOG — bottom sheet on mobile, centered dialog on desktop
// ============================================================

class _CouponDetailsSheet extends StatelessWidget {
  final CouponModel coupon;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;
  final VoidCallback onEdit;
  const _CouponDetailsSheet({
    required this.coupon,
    required this.onDelete,
    required this.onToggleStatus,
    required this.onEdit
  });

  @override
  Widget build(BuildContext context) {
    final isActive = coupon.status.toLowerCase() == 'active';
    final width = MediaQuery.of(context).size.width;
    final compact = _isCompact(width);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (compact)
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: Text(
                coupon.name,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            _StatusPill(
              active: isActive,
              expired: coupon.expiryDate.isBefore(DateTime.now()),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          coupon.description,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _DetailRow(label: 'Code', value: coupon.code),
              _DetailRow(label: 'Type', value: coupon.type),
              _DetailRow(
                label: 'Discount',
                value: coupon.discount.toStringAsFixed(0),
              ),
              _DetailRow(
                label: 'Max discount',
                value: coupon.maximumDiscount > 0
                    ? '₹${coupon.maximumDiscount.toStringAsFixed(0)}'
                    : '—',
              ),
              _DetailRow(
                label: 'Min purchase',
                value: '₹${coupon.minimumOrderAmount.toStringAsFixed(0)}',
              ),
              _DetailRow(
                label: 'Usage limit',
                value: coupon.usageLimit > 0
                    ? '${coupon.usageLimit}'
                    : 'Unlimited',
              ),
              _DetailRow(
                label: 'Expires',
                value: _formatDate(coupon.expiryDate),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
       Row(
 children: [
    Expanded(
      child: SecondaryButtonSmall(
        label: isActive ? "Deactivate" : "Activate",
        icon: isActive
            ? Icons.pause_circle_outline
            : Icons.play_circle_outline,
        onPressed: onToggleStatus,
      ),
    ),

    const SizedBox(width: 10),

    Expanded(
      child: PrimaryButton(
        label: "Edit",
        icon: Icons.edit,
        onPressed: () async {
          print("Selected coupon ID: ${coupon.id?.toHexString()}");
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CouponFormScreen(
                coupon: coupon,
              ),
            ),
          );

          if (result == true) {
            Navigator.pop(context, true);
          }
        },
      ),
    ),

    const SizedBox(width: 10),

    Expanded(
      child: DangerButtonSmall(
        label: "Delete",
        icon: Icons.delete,
        onPressed: onDelete,
      ),
    ),
  ],
)

      ],
    );

    if (compact) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: content,
        ),
      );
    }

    // Wide screens: render as a centered, fixed-width dialog card instead of
    // a full-bleed bottom sheet.
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: AppColors.transparent,
        child: Container(
          width: 420,
          margin: const EdgeInsets.symmetric(vertical: 40),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.18),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: content,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 12.5),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class SecondaryButtonSmall extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const SecondaryButtonSmall({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary, width: 1.2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DangerButtonSmall extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const DangerButtonSmall({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.dangerBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppColors.danger),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// EMPTY / ERROR STATES
// ============================================================

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreate;
  const _EmptyState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.local_offer_outlined,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No coupons found',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try a different search or filter, or create a new coupon.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
            const SizedBox(height: 18),
            SecondaryButtonSmall(
              label: 'Create Coupon',
              icon: Icons.add_rounded,
              onPressed: onCreate,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.danger,
              size: 36,
            ),
            const SizedBox(height: 12),
            const Text(
              'Couldn\'t load coupons',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12.5),
            ),
            const SizedBox(height: 16),
            SecondaryButtonSmall(
              label: 'Retry',
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HELPERS
// ============================================================

String _formatDate(DateTime d) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
}
