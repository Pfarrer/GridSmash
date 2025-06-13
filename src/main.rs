use bevy::color::palettes::css::RED;
use bevy::prelude::*;
use bevy_rapier2d::prelude::*;
use rand;
use rand::Rng;
use std::time::Duration;

#[derive(Resource)]
struct SpawnTimer {
    timer: Timer,
}

#[derive(Resource)]
struct Map {
    curve: CubicCurve<Vec2>,
}

impl Default for Map {
    fn default() -> Self {
        let positions = vec![
            vec2(-500., -200.),
            vec2(-250., 250.),
            vec2(250., 250.),
            vec2(500., -200.),
        ];
        let curve = CubicCardinalSpline::new(0.25, positions)
            .to_curve()
            .unwrap();

        Self {
            curve,
        }
    }
}

#[derive(Component)]
struct Creep {
    speed: f32,
}

#[derive(Component)]
struct PathFollow {
    progress: f32,
}

impl Default for PathFollow {
    fn default() -> Self {
        Self { progress: 0. }
    }
}

fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .insert_resource(SpawnTimer {
            timer: Timer::new(Duration::from_secs(2), TimerMode::Repeating),
        })
        .init_resource::<Map>()
        .add_systems(Startup, setup_graphics)
        .add_systems(Update, setup_curve)
        .add_systems(Update, spawn_system)
        .add_systems(Update, move_system)
        .run();
}

fn setup_graphics(mut commands: Commands) {
    commands.spawn(Camera2d::default());
}

fn setup_curve(map: Res<Map>, mut gizmos: Gizmos) {
    gizmos.linestrip(
        map.curve.iter_positions(50).map(|pt| pt.extend(0.0)),
        RED,
    );
}

fn spawn_system(
    time: Res<Time>,
    mut commands: Commands,
    mut spawn_timer: ResMut<SpawnTimer>,
    meshes: ResMut<Assets<Mesh>>,
    materials: ResMut<Assets<ColorMaterial>>,
    map: Res<Map>,
) {
    spawn_timer.timer.tick(time.delta());

    if spawn_timer.timer.finished() {
        let initial_position = map.curve.position(0.);
        commands.spawn(creep_bundle(meshes, materials, initial_position));
    }
}

fn move_system(
    time: Res<Time>,
    map: Res<Map>,
    mut creep_query: Query<(&mut Transform, &mut PathFollow, &Creep)>,
) {
    for (mut transform, mut path_follow, creep) in creep_query.iter_mut() {
        let velocity = creep.speed / map.curve.velocity(path_follow.progress).length();
        path_follow.progress += velocity * time.delta_secs();
        transform.translation = map.curve.position(path_follow.progress).extend(0.0);
    }
}

fn creep_bundle(
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<ColorMaterial>>,
    initial_position: Vec2,
) -> impl Bundle {
    let mesh = meshes.add(Circle::new(20.0));
    let color = Color::hsl(360., 0.95, 0.7);
    let material = materials.add(color);

    let mut rng = rand::rng();

    (
        Creep { speed: rng.random_range(200. .. 400.) },
        PathFollow::default(),
        Mesh2d(mesh),
        MeshMaterial2d(material),
        Transform::from_translation(initial_position.extend(0.0)),
    )
}
