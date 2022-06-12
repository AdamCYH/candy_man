// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:candy_man/src/style/palette.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  static final _log = Logger('PlaySessionScreen');

  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return GameWidget(
        game: CandyManGame(
            color: Provider.of<Palette>(context), debugMode: false));
  }
}
