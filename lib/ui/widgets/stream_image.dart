import 'dart:math';
import 'package:flutter/material.dart';

class StreamImage extends StatefulWidget {
  final VoidCallback onTap;

  const StreamImage({super.key, required this.onTap});

  @override
  State<StreamImage> createState() => _StreamImageState();
}

class _StreamImageState extends State<StreamImage> {
  final List<_CoinAnimation> _coins = [];

  void _spawnCoin() {
    final id = UniqueKey();
    final random = Random();
    final dx = random.nextDouble() * 100 - 50; // небольшое случайное смещение
    final coin = _CoinAnimation(id: id, offsetX: dx);

    setState(() => _coins.add(coin));

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() => _coins.removeWhere((c) => c.id == id));
    });
  }

  void _onTap() {
    widget.onTap();
    _spawnCoin();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        height: 420,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withOpacity(0.04),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  'assets/images/streamer.png',
                  fit: BoxFit.cover,
                ),
              ),
              ..._coins.map((coin) => coin),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoinAnimation extends StatefulWidget {
  final Key id;
  final double offsetX;

  const _CoinAnimation({required this.id, required this.offsetX})
      : super(key: id);

  @override
  State<_CoinAnimation> createState() => _CoinAnimationState();
}

class _CoinAnimationState extends State<_CoinAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _moveUp;
  late Animation<double> _fadeOut;
  late Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _moveUp = Tween<double>(begin: 0, end: -120).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );
    _fadeOut = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _rotate = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Positioned(
          bottom: 20 - _moveUp.value,
          left: MediaQuery.of(context).size.width / 2 + widget.offsetX,
          child: Opacity(
            opacity: _fadeOut.value,
            child: Transform.rotate(
              angle: _rotate.value,
              child: Image.asset(
                'assets/images/silver_coin.png', //
                width: 30,
                height: 30,
              ),
            ),
          ),
        );
      },
    );
  }
}
