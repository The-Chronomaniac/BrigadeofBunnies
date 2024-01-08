// Initialize the first gamepad
global.gamepad = 0;

// Check if there's any gamepad connected
if (gamepad_is_connected(global.gamepad)) {
    gamepad_set_axis_deadzone(global.gamepad, 0.2);
}

// Movement and physics
walksp = 4;
grv = 0.5;
vsp = 0;
hsp = 0;
reflect_window = 0;

// Acceleration, deceleration, and friction
acceleration = 0.5;
deceleration = 0.5;
max_walk_speed = 7;
ground_friction = 0.8;
air_control = 0.5;
bounce_height = -10; // Initial bounce height
sprint_ready = false;
// Coyote Time
coyote_time = 10;
 
fast_fall_speed = 8; // Modify this value to set the desired fast fall speed
is_fast_falling = false;

reflecting = false;
reflect_timer = 0;
max_reflect_duration = 5; // The number of frames the reflect action lasts

// sprint variables
sprint = false;
doubleTapDelay = 0;
lastKeyPressed = "";

// Animation sprites
jump_animation_timer = -1;
spr_idle = FinnactiveIdles;
spr_run = FinnRunNormal;
spr_jump = FinnJumpinit; 
spr_rising = FinnJumpRise;
spr_falling = FinnJumpFall;
spr_spinball = FinnSpinball;
spr_spinhori = FinnSpinHorizontal;
spr_sprint = FinSprint;
reflected = false; 
reflect_sprite = spr_spinball;
spr_orbreflect = Reflectorsphere;
spr_orbreflectexplode = Reflectorsphereexplode;
spr_crouch = FinnCrouch;
global.orb_effect = noone;

reflect_state = 0; // 0: Idle, 1: Startup, 2: Active, 3: Fading