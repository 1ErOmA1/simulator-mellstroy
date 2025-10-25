import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:html' as html;

class StreamImage extends StatefulWidget {
  final VoidCallback onTap;

  const StreamImage({super.key, required this.onTap});

  @override
  State<StreamImage> createState() => _StreamImageState();
}

class _StreamImageState extends State<StreamImage>
    with SingleTickerProviderStateMixin {
  final List<_CoinAnimation> _coins = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    _pulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.reverse();
      }
    });

    // Предзагрузка для нативных платформ
    if (!kIsWeb) {
      // _audioPlayer.setSource(AssetSource('sounds/click_sound.mp3'));
      // _audioPlayer.setSource(AssetSource('sounds/coin_sound.mp3'));
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _playSound(String file) async {
    if (kIsWeb) {
      html.AudioElement('assets/sounds/$file').play();
    } else {
      await _audioPlayer.play(AssetSource('sounds/$file'));
    }
  }

  void _spawnCoin(Offset position) {
    final id = UniqueKey();
    final coin = _CoinAnimation(id: id, position: position);

    setState(() => _coins.add(coin));

    // 🎵 20% шанс проиграть звук монеты
    // if (Random().nextDouble() < 0.2) {
    //   _playSound('coin_sound.mp3');
    // }

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _coins.removeWhere((c) => c.id == id));
      }
    });
  }

  void _onTapDown(TapDownDetails details) {
    widget.onTap();
    _spawnCoin(details.localPosition);
    _pulseController.forward(from: 0);
    // _playSound('click_sound.mp3');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = max(300, screenHeight * 0.45).toDouble();

    return SizedBox(
      width: screenWidth * 0.8,
      height: imageHeight + 240,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: _onTapDown,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        'assets/images/streamer.png',
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                  );
                },
              ),
            ),
            ..._coins.map((coin) => coin),
          ],
        ),
      ),
    );
  }
}

class _CoinAnimation extends StatefulWidget {
  final Key id;
  final Offset position;

  const _CoinAnimation({required this.id, required this.position})
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
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

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
          left: widget.position.dx - 15,
          top: widget.position.dy - 15 + _moveUp.value,
          child: Opacity(
            opacity: _fadeOut.value,
            child: Transform.rotate(
              angle: _rotate.value,
              child: Image.asset(
                'assets/images/silver_coin.png',
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
