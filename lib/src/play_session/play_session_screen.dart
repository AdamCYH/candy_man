// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class PlaySessionScreen extends StatelessWidget {
  static final _log = Logger('PlaySessionScreen');

  const PlaySessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: CandyManGame());
  }
}
