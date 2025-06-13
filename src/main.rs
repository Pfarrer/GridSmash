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

#[derive(Component)]
struct Ball {}

fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .add_plugins(RapierPhysicsPlugin::<NoUserData>::pixels_per_meter(100.0))
        // .add_plugins(RapierDebugRenderPlugin::default())
        .insert_resource(SpawnTimer {
            timer: Timer::new(Duration::from_secs(2), TimerMode::Repeating),
        })
        .add_systems(Startup, setup_graphics)
        .add_systems(Startup, setup_physics)
        .add_systems(Update, setup_curve)
        .add_systems(Update, spawner_system)
        .run();
}

fn setup_graphics(mut commands: Commands) {
    commands.spawn(Camera2d::default());
}

fn setup_physics(mut commands: Commands) {
    commands.spawn((
        Collider::cuboid(500.0, 50.0),
        Transform::from_xyz(0.0, -200.0, 0.0),
    ));
}

fn setup_curve(mut gizmos: Gizmos) {
    let points = vec![
        vec2(-500., -200.),
        vec2(-250., 250.),
        vec2(250., 250.),
        vec2(500., -200.),
    ];
    let curve = CubicCardinalSpline::new(0.3, points).to_curve().unwrap();

    let resolution = 100 * curve.segments().len();
    gizmos.linestrip(
        curve.iter_positions(resolution).map(|pt| pt.extend(0.0)),
        RED,
    );
}

fn spawner_system(
    mut commands: Commands,
    time: Res<Time>,
    mut spawn_timer: ResMut<SpawnTimer>,
    meshes: ResMut<Assets<Mesh>>,
    materials: ResMut<Assets<ColorMaterial>>,
) {
    spawn_timer.timer.tick(time.delta());

    if spawn_timer.timer.finished() {
        commands.spawn(ball(meshes, materials));
    }
}

fn ball(
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<ColorMaterial>>,
) -> impl Bundle {
    let mesh = meshes.add(Circle::new(20.0));
    let color = Color::hsl(360., 0.95, 0.7);
    let material = materials.add(color);

    let mut rng = rand::rng();
    let x_offset = rng.random_range(-0.01..0.01);

    (
        Mesh2d(mesh),
        MeshMaterial2d(material),
        Transform::from_xyz(x_offset, 0., 0.),
        RigidBody::Dynamic,
        Collider::ball(20.0),
        Restitution::coefficient(1.2),
    )
}
