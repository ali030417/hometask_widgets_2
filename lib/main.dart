import 'dart:math';
import 'package:example_flutter/fight_club_colors.dart';
import 'package:example_flutter/fight_club_icons.dart';
import 'package:example_flutter/fight_club_images.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme:
            GoogleFonts.pressStart2pTextTheme(Theme.of(context).textTheme),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const maxLives = 5;

  BodyPart? deffendingBodyPart;
  BodyPart? attacingBodyPart;

  BodyPart whatEnemyAttacks = BodyPart.random();
  BodyPart whatEnemyDefends = BodyPart.random();

  int yourLives = maxLives;
  int enemysLives = maxLives;

  String centerText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(children: [
          const Padding(padding: EdgeInsets.only(top: 10)),
          FightersInfo(
            maxLivesCount: maxLives,
            yorLivesCount: yourLives,
            enemyLivesCount: enemysLives,
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ColoredBox(
                color: FightClubColors.blackFiolet,
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      centerText,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: const TextStyle(
                        color: FightClubColors.darkGreyText,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Controlls(
            deffendingBodyPart: deffendingBodyPart,
            attacingBodyPart: attacingBodyPart,
            selectDeffendingBodyPart: _selectDeffendingBodyPart,
            selecAttacingBodyPart: _selecAttacingBodyPart,
          ),
          const SizedBox(height: 14),
          GoButton(
            text: yourLives == 0 || enemysLives == 0 ? 'start new game' : 'go',
            onTap: _onGoButtonClicked,
            color: _getButtonColor(),
          ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  Color _getButtonColor() {
    if (yourLives == 0 || enemysLives == 0) {
      return FightClubColors.blackButton;
    } else if (attacingBodyPart == null || deffendingBodyPart == null) {
      return FightClubColors.greyButton;
    } else {
      return FightClubColors.blackButton;
    }
  }

  void _selectDeffendingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }
    setState(() {
      deffendingBodyPart = value;
    });
  }

  void _selecAttacingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }
    setState(() {
      attacingBodyPart = value;
    });
  }

  void _onGoButtonClicked() {
    if (yourLives == 0 || enemysLives == 0) {
      setState(() {
        yourLives = maxLives;
        enemysLives = maxLives;
      });
    } else if (attacingBodyPart != null && deffendingBodyPart != null) {
      setState(() {
        final bool enemyLoseLife = attacingBodyPart != whatEnemyDefends;
        final bool youLoseLife = deffendingBodyPart != whatEnemyAttacks;

        if (enemyLoseLife) {
          enemysLives -= 1;
        }
        if (youLoseLife) {
          yourLives -= 1;
        }

        if (yourLives == 0 && enemysLives == 0) {
          centerText = 'Draw';
        } else if (yourLives == 0) {
          centerText = 'You lost';
        } else if (enemysLives == 0) {
          centerText = 'You won';
        } else {
          String first = enemyLoseLife
              ? 'You hit enemy’s ${attacingBodyPart!.name.toLowerCase()}.'
              : 'Your attack was blocked.';

          String second = youLoseLife
              ? 'Enemy hit your ${deffendingBodyPart!.name.toLowerCase()}.'
              : 'Enemy’s attack was blocked.';

          centerText = '$first\n$second';
        }

        whatEnemyAttacks = BodyPart.random();
        whatEnemyDefends = BodyPart.random();

        attacingBodyPart = null;
        deffendingBodyPart = null;
      });
    }
  }
}

class FightersInfo extends StatelessWidget {
  final int maxLivesCount;
  final int yorLivesCount;
  final int enemyLivesCount;
  const FightersInfo({
    Key? key,
    required this.enemyLivesCount,
    required this.yorLivesCount,
    required this.maxLivesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: ColoredBox(
                color: Colors.white,
              )),
              Expanded(child: ColoredBox(color: FightClubColors.blackFiolet)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LivesWidget(
                currentLivesCount: yorLivesCount,
                overallLivesCount: maxLivesCount,
              ),
              Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'You',
                    style: TextStyle(
                      color: FightClubColors.darkGreyText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Image.asset(FightClubImages.youAvatar, height: 92, width: 92),
                ],
              ),
              const ColoredBox(
                color: Colors.green,
                child: SizedBox(height: 44, width: 44),
              ),
              Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Empty',
                    style: TextStyle(
                      color: FightClubColors.darkGreyText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Image.asset(FightClubImages.enemyAvatar,
                      height: 92, width: 92),
                ],
              ),
              LivesWidget(
                currentLivesCount: enemyLivesCount,
                overallLivesCount: maxLivesCount,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BodyPart {
  final String name;

  const BodyPart._(this.name);

  static const head = BodyPart._('Head');
  static const torso = BodyPart._('Torso');
  static const legs = BodyPart._('Legs');

  @override
  String toString() {
    return 'BodyPart{name: $name}';
  }

  static const List<BodyPart> _values = [head, torso, legs];

  static BodyPart random() {
    return _values[Random().nextInt(_values.length)];
  }
}

class BodyPatrButton extends StatelessWidget {
  final bool selected;
  final BodyPart bodyPart;
  final ValueSetter<BodyPart> BodyPartSetter;

  const BodyPatrButton({
    super.key,
    required this.selected,
    required this.bodyPart,
    required this.BodyPartSetter,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => BodyPartSetter(bodyPart),
      child: SizedBox(
        height: 40,
        child: ColoredBox(
          color: selected
              ? FightClubColors.blueButton
              : FightClubColors.greyButton,
          child: SizedBox(
            child: Center(
              child: Text(
                bodyPart.name.toUpperCase(),
                style: TextStyle(
                  color: selected
                      ? FightClubColors.whiteText
                      : FightClubColors.darkGreyText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LivesWidget extends StatelessWidget {
  final int overallLivesCount;
  final int currentLivesCount;

  const LivesWidget({
    Key? key,
    required this.currentLivesCount,
    required this.overallLivesCount,
  })  : assert(overallLivesCount >= 1),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(overallLivesCount, (index) {
        if (index < currentLivesCount) {
          return [
            Image.asset(FightClubIcons.heartFull, width: 18, height: 18),
            if (index < overallLivesCount - 1) const SizedBox(height: 4),
          ];
        } else {
          return [
            Image.asset(FightClubIcons.heartEmpty, width: 18, height: 18),
            if (index < overallLivesCount - 1) const SizedBox(height: 4),
          ];
        }
      }).expand((element) => element).toList(),
    );
  }
}

class Controlls extends StatelessWidget {
  final BodyPart? deffendingBodyPart;
  final BodyPart? attacingBodyPart;

  final ValueSetter<BodyPart> selectDeffendingBodyPart;
  final ValueSetter<BodyPart> selecAttacingBodyPart;

  const Controlls({
    super.key,
    this.deffendingBodyPart,
    this.attacingBodyPart,
    required this.selectDeffendingBodyPart,
    required this.selecAttacingBodyPart,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            children: [
              Text(
                'Deffend'.toUpperCase(),
                style: const TextStyle(
                  color: FightClubColors.darkGreyText,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 13),
              BodyPatrButton(
                bodyPart: BodyPart.head,
                selected: deffendingBodyPart == BodyPart.head,
                BodyPartSetter: selectDeffendingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPatrButton(
                bodyPart: BodyPart.torso,
                selected: deffendingBodyPart == BodyPart.torso,
                BodyPartSetter: selectDeffendingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPatrButton(
                bodyPart: BodyPart.legs,
                selected: deffendingBodyPart == BodyPart.legs,
                BodyPartSetter: selectDeffendingBodyPart,
              ),
            ],
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            children: [
              Text(
                'Attact'.toUpperCase(),
                style: const TextStyle(
                  color: FightClubColors.darkGreyText,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 13),
              BodyPatrButton(
                bodyPart: BodyPart.head,
                selected: attacingBodyPart == BodyPart.head,
                BodyPartSetter: selecAttacingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPatrButton(
                bodyPart: BodyPart.torso,
                selected: attacingBodyPart == BodyPart.torso,
                BodyPartSetter: selecAttacingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPatrButton(
                bodyPart: BodyPart.legs,
                selected: attacingBodyPart == BodyPart.legs,
                BodyPartSetter: selecAttacingBodyPart,
              ),
            ],
          ),
        ),
        const SizedBox(width: 13),
      ],
    );
  }
}

class GoButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;

  const GoButton(
      {super.key,
      required this.onTap,
      required this.color,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        child: ColoredBox(
          color: FightClubColors.blackButton,
          child: GestureDetector(
            onTap: onTap,
            child: SizedBox(
              height: 40,
              child: ColoredBox(
                color: color,
                child: Center(
                    child: Text(
                  text.toUpperCase(),
                  style: const TextStyle(
                    color: FightClubColors.whiteText,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
