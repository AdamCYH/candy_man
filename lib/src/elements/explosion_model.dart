import 'package:candy_man/src/elements/explosion_component.dart';
import 'package:candy_man/src/elements/game_element.dart';
import 'package:candy_man/src/elements/player_model.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class ExplosionModel extends GameElement with ContactCallbacks {
  final ElementType elementType = ElementType.explosion;
  final bool collidable = true;

  final bool isVertical;
  final Vector2 position;

  ExplosionComponent? component;

  ExplosionModel({required this.position, required this.isVertical});

  @override
  Future<Component> create() async {
    component = ExplosionComponent(explosionModel: this);
    return component!;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is PlayerModel) {
      other.contactExplosion();
    }
  }

  @override
  void preSolve(Object other, Contact contact, Manifold oldManifold) {
    // Make player a sensor so other player can save dead player.
    if (other is PlayerModel) {
      other.component.body.fixtures[0].setSensor(true);
    }
  }
}
