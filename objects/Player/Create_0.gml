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
// Coyote Time
coyote_time = 10;
coyote_counter = 0;

// Jump Buffering
jump_buffer = 5;
jump_buffer_counter = 0;

reflecting = false;
reflect_duration = 0;
max_reflect_duration = 5; // The number of frames the reflect action lasts

// Animation sprites
jump_animation_timer = -1;
spr_idle = FinnactiveIdles;
spr_run = FinnRunNormal;
spr_jump = FinnJumpinit; 
spr_rising = FinnJumpRise;
spr_falling = FinnJumpFall;
spr_spinball = FinnSpinball;
spr_spinhori = FinnSpinHorizontal;
reflected = false; 