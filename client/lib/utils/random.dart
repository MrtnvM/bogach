import 'dart:math';

final _random = Random();

int randomInt(int min, int max) => min + _random.nextInt(max - min);
