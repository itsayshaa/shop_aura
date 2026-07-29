import 'package:flutter/material.dart';

class BrandCard extends StatefulWidget {
  final String brandName;
  final String? logo;
  final VoidCallback? onTap;

  const BrandCard({
    Key? key,
    required this.brandName,
    this.logo,
    this.onTap,
  }) : super(key: key);

  @override
  State<BrandCard> createState() => _BrandCardState();
}

class _BrandCardState extends State<BrandCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _animation = Tween<double>(
      begin: 1,
      end: .95,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _press() {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _release() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _press(),
        onTapUp: (_) => _release(),
        onTapCancel: _release,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 110,
          margin: const EdgeInsets.only(right: 14),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  _isPressed ? .04 : .08,
                ),
                blurRadius: _isPressed ? 6 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey.shade100,
                backgroundImage: widget.logo != null
                    ? NetworkImage(widget.logo!)
                    : null,
                child: widget.logo == null
                    ? Text(
                        widget.brandName[0],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),

              const SizedBox(height: 12),

              Text(
                widget.brandName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Official Store",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}