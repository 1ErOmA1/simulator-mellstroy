import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'widgets/header_card.dart';
import 'widgets/level_card.dart';
import 'widgets/stream_image.dart';
import 'widgets/bottom_tabs.dart';
import 'theme.dart';
import '../utils/audio_manager.dart'; // 🔊 Добавлено

class MellHome extends StatefulWidget {
  const MellHome({super.key});

  @override
  State<MellHome> createState() => _MellHomeState();
}

class _MellHomeState extends State<MellHome>
    with SingleTickerProviderStateMixin {
  double views = 0; // 🪙 серебро
  double silver = 1; // 💰 золото
  int subs = 0;

  double income = 0; // пассивный доход
  double clickIncome = 0; // доход за клик

  int xp = 0;
  int level = 1;

  int _currentLevelXp = 0; // Текущий XP для уровня
  final int _xpForNextLevel = 1000; // XP для перехода на следующий уровень

  int _clickCount = 0;

  bool _showLevelCard = false;
  bool _showLevelGlow = false; // ✨ Эффект свечения при апгрейде

  Timer? _timer;

  late AnimationController _cardController;
  late Animation<double> _scaleAnimation;

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

  final AudioManager _audio =
      AudioManager(); // 🎧 Экземпляр звукового менеджера

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

  void _onStreamTap() {
    setState(() {
      views += clickIncome;
      xp += 1;
      _currentLevelXp += 1;
      _clickCount++;

      // 🔊 Звук клика
      _audio.play('sounds/click_sound.mp3');

      if (_clickCount % 1000 == 0) {
        silver += 1;
        // 🔊 Звук монеты
        // _audio.play('sounds/coin_sound.mp3');
      }

      if (_clickCount % 10 == 0) {
        subs += 1;
      }

      int xpToNextLevel = 100 * level;
      // if (_currentLevelXp >= _xpForNextLevel) {
      //   // ← Изменено
      //   _currentLevelXp = 0; // ← Добавлено
      //   level++;

      //   // Увеличиваем XP для следующего уровня на 25%
      //   _xpForNextLevel = (_xpForNextLevel * 1.25).round(); // ← Добавлено

      //   _cardController.forward(from: 0);

      //   // 🌟 Эффект свечения при повышении уровня
      //   setState(() => _showLevelGlow = true);
      //   Future.delayed(const Duration(seconds: 1), () {
      //     if (mounted) setState(() => _showLevelGlow = false);
      //   });
      // }
      if (xp >= xpToNextLevel) {
        xp -= xpToNextLevel;
        level++;
        _cardController.forward(from: 0);

        // 🌟 Эффект свечения при повышении уровня
        setState(() => _showLevelGlow = true);
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) setState(() => _showLevelGlow = false);
        });
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
        top: MediaQuery.of(context).padding.top + 30, // чуть выше
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

    // 🔹 здесь мы используем замыкание, чтобы linter не ругался
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
        // upgradesData[index]['price'] *= 1.35;
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
              // 🌟 Эффект мягкого свечения при апгрейде уровня
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

                  // 🎯 Нижние вкладки
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

              // 🎥 Центральная зона стрима
              Positioned(
                bottom: screenHeight * 0.06,
                left: 0,
                right: 0,
                child: Center(
                  child: StreamImage(onTap: _onStreamTap),
                ),
              ),

              // 🌟 Анимация карточки уровня
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
