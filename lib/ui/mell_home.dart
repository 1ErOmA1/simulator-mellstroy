import 'dart:async';
import 'dart:ui';
import 'dart:math'; // для pow()
import 'package:flutter/material.dart';
import 'widgets/header_card.dart';
import 'widgets/level_card.dart';
import 'widgets/stream_image.dart';
import 'widgets/bottom_tabs.dart';
import 'theme.dart';
import '../utils/audio_manager.dart'; // 🔊 звуки

class MellHome extends StatefulWidget {
  const MellHome({super.key});

  @override
  State<MellHome> createState() => _MellHomeState();
}

class _MellHomeState extends State<MellHome>
    with SingleTickerProviderStateMixin {
  double views = 0; // серебро
  double silver = 0; // золото
  int subs = 0;

  double income = 0; // пассивный доход
  double clickIncome = 1; // доход за клик

  int xp = 0; // текущий XP для этого уровня
  int level = 1;

  int _clickCount = 0;

  bool _showLevelCard = false;
  bool _showLevelGlow = false;

  Timer? _timer;

  late AnimationController _cardController;
  late Animation<double> _scaleAnimation;

  final AudioManager _audio = AudioManager();

  List<Map<String, dynamic>> upgradesData = [
    {
      'name': 'Камера',
      'click': 0.05,
      'passive': 0.025,
      'price': 100.0,
      'level': 0
    },
    {
      'name': 'Подставка под камеру',
      'click': 0.03,
      'passive': 0.01,
      'price': 50.0,
      'level': 0
    },
    {
      'name': 'Микрофон',
      'click': 0.04,
      'passive': 0.015,
      'price': 80.0,
      'level': 0
    },
    {
      'name': 'Источник света',
      'click': 0.06,
      'passive': 0.02,
      'price': 120.0,
      'level': 0
    },
    {
      'name': 'Одежда',
      'click': 0.02,
      'passive': 0.01,
      'price': 40.0,
      'level': 0
    },
    {
      'name': 'Причёска и внешность',
      'click': 0.03,
      'passive': 0.015,
      'price': 70.0,
      'level': 0
    },
    {
      'name': 'Часы',
      'click': 0.01,
      'passive': 0.005,
      'price': 30.0,
      'level': 0
    },
    {
      'name': 'Харизма',
      'click': 0.04,
      'passive': 0.03,
      'price': 150.0,
      'level': 0
    },
    {
      'name': 'Импровизация',
      'click': 0.03,
      'passive': 0.02,
      'price': 130.0,
      'level': 0
    },
    {
      'name': 'Эрудиция',
      'click': 0.02,
      'passive': 0.02,
      'price': 110.0,
      'level': 0
    },
    {
      'name': 'Остроумие',
      'click': 0.04,
      'passive': 0.02,
      'price': 100.0,
      'level': 0
    },
    {
      'name': 'Эмоциональность',
      'click': 0.05,
      'passive': 0.03,
      'price': 160.0,
      'level': 0
    },
  ];

  @override
  void initState() {
    super.initState();
    _startIncomeTimer();

    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutBack,
    );
  }

  void _startIncomeTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        views += income;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cardController.dispose();
    super.dispose();
  }

  /// Требуемый XP для перехода с текущего уровня на следующий.
  /// Правила:
  /// - Для level == 1 (отображение у LevelCard) можно оставить 100, но
  ///   реальное требование для перехода 1->2 = 1000.
  /// - Для перехода на уровень 2 требуется 1000 XP.
  /// - Каждый следующий уровень умножаем на 1.25.
  int requiredXpForLevel(int currentLevel) {
    if (currentLevel <= 1) return 100; // отображение/вместимость UI
    final double base = 1000.0; // требование для перехода 1 -> 2
    final double value = base * pow(1.05, (currentLevel - 2));
    return value.round();
  }

  // Обновлённая логика нажатия на стрим — даёт XP и может повысить уровень.
  void _onStreamTap() {
    setState(() {
      views += clickIncome;
      xp += 1; // накопление XP для текущего уровня
      _clickCount++;

      // звук клика (если есть)
      _audio.play('sounds/click_sound.mp3');

      if (_clickCount % 1000 == 0) {
        silver += 1;
        // _audio.play('sounds/coin_sound.mp3');
      }

      if (_clickCount % 10 == 0) {
        subs += 1;
      }

      // цикл повышения уровней (поддерживает множественные повышения)
      int xpToNextLevel = requiredXpForLevel(level);
      while (xp >= xpToNextLevel) {
        xp -= xpToNextLevel;
        level++;
        _cardController.forward(from: 0);

        // эффект свечения
        setState(() => _showLevelGlow = true);
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) setState(() => _showLevelGlow = false);
        });

        // пересчитать требование для следующего уровня
        xpToNextLevel = requiredXpForLevel(level);
      }
    });
  }

  void _toggleLevelCard() {
    setState(() {
      _showLevelCard = !_showLevelCard;
    });
    if (_showLevelCard) _cardController.forward(from: 0);
  }

  void _changeViews(double delta) {
    setState(() {
      views += delta;
      if (views < 0) views = 0;
    });
  }

  void _applyUpgrade(double click, double passive) {
    setState(() {
      clickIncome += click;
      income += passive;
    });
  }

  void _showPurchaseNotification(String upgradeName) {
    final overlayState = Overlay.maybeOf(context);
    if (overlayState == null) return;

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 30,
        left: 0,
        right: 0,
        child: Center(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 400),
            tween: Tween(begin: 0, end: 1),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(opacity: value, child: child);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade400.withOpacity(0.95),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Text(
                '✅ $upgradeName улучшено!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);
    Future.delayed(const Duration(milliseconds: 1500), () {
      overlayEntry.remove();
    });
  }

  void _buyUpgrade(int index) {
    var upgrade = upgradesData[index];
    double price = upgrade['price'];

    if (views >= price) {
      setState(() {
        upgradesData[index]['level']++;
        upgradesData[index]['price'] = price * (1.2 + level * 0.05);
        views -= price;
        clickIncome += upgrade['click'];
        income += upgrade['passive'];
      });
      _showPurchaseNotification(upgrade['name']);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("❌ Недостаточно серебра!"),
          backgroundColor: Colors.redAccent.shade200,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: getBackgroundForLevel(level),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_showLevelGlow)
                AnimatedOpacity(
                  opacity: _showLevelGlow ? 1 : 0,
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Color(0x80FFFFFF),
                          Colors.transparent,
                        ],
                        radius: 0.8,
                      ),
                    ),
                  ),
                ),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    child: HeaderCard(
                      views: views,
                      subs: subs,
                      money: silver,
                      income: income,
                      xp: xp,
                      level: level,
                      onAvatarTap: _toggleLevelCard,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: BottomTabs(
                      silver: views,
                      onSilverChange: _changeViews,
                      onUpgrade: _applyUpgrade,
                      upgrades: upgradesData,
                      onBuyUpgrade: _buyUpgrade,
                    ),
                  ),
                ],
              ),

              Positioned(
                bottom: screenHeight * 0.06,
                left: 0,
                right: 0,
                child: Center(
                  child: StreamImage(onTap: _onStreamTap),
                ),
              ),

              if (_showLevelCard)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Stack(
                    key: const ValueKey('overlay'),
                    children: [
                      GestureDetector(
                        onTap: _toggleLevelCard,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _showLevelCard ? 1 : 0,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: LevelCard(level: level, xp: xp),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
