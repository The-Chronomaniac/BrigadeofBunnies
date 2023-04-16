// Declarations of left, right, jump, and reflect
key_left = keyboard_check(vk_left) || (gamepad_axis_value(global.gamepad, gp_axislh) < -0.5) || gamepad_button_check(global.gamepad, gp_padl);
key_right = keyboard_check(vk_right) || (gamepad_axis_value(global.gamepad, gp_axislh) > 0.5) || gamepad_button_check(global.gamepad, gp_padr);
key_jump = keyboard_check(ord("Z")) || gamepad_button_check(global.gamepad, gp_face1);
key_jump_pressed = keyboard_check_pressed(ord("Z")) || gamepad_button_check_pressed(global.gamepad, gp_face1);
key_jump_released = keyboard_check_released(ord("Z")) || gamepad_button_check_released(global.gamepad, gp_face1);
key_reflect = keyboard_check_pressed(ord("X")) || gamepad_button_check_pressed(global.gamepad, gp_face2);

// Movement calculations
var move = key_right - key_left;
var control = place_meeting(x, y + 1, oWall) ? 1 : air_control;
if (!variable_instance_exists(id, "random_falling_sprite")) {
    random_falling_sprite = spr_falling; // Set it to your default falling sprite
}
// Acceleration, deceleration, and friction
hsp += move * acceleration * control;
hsp = clamp(hsp, -max_walk_speed, max_walk_speed);
if (move == 0 && place_meeting(x, y + 1, oWall)) {
    hsp = lerp(hsp, 0, ground_friction);
}

vsp += grv;

// Coyote Time and Jump Buffering
coyote_counter = place_meeting(x, y + 1, oWall) ? coyote_time : coyote_counter - 1;
jump_buffer_counter = key_jump_pressed ? jump_buffer : jump_buffer_counter - 1;

if (key_jump_pressed && place_meeting(x, y + 1, oWall)) {
    jump_animation_timer = 3; // Set the delay before actually jumping
}

if (jump_buffer_counter > 0 && coyote_counter > 0 && jump_animation_timer <= 0) {
    vsp = -15; // Setting jump height
    jump_buffer_counter = 0;
    coyote_counter = 0;
}

if (place_meeting(x, y + 1, oWall)) {
    bounce_height = -10; // Reset the bounce height when touching the ground
}

// Decrease jump animation timer
if (jump_animation_timer > 0) {
    jump_animation_timer -= 1;
}

// Variable jump height
if (key_jump_released && vsp < 0) {
    vsp *= 0.5;
}

// Collisions
for (var i = 0; i < abs(hsp); i++) {
    if (!place_meeting(x + sign(hsp), y, oWall)) {
        x += sign(hsp);
    } else {
        hsp = 0;
        break;
    }
}

for (var i = 0; i < abs(vsp); i++) {
    if (!place_meeting(x, y + sign(vsp), oWall)) {
        y += sign(vsp);
    } else {
        vsp = 0;
        break;
    }
}

// Update reflecting state
if (key_reflect && !reflecting) {
    reflecting = true;
    reflect_duration = max_reflect_duration;
    reflect_window = 10; // Set the window for successful reflection
}

if (reflecting) {
    reflect_duration -= 1;
    if (reflect_duration <= 0) {
        reflecting = false;
    }
    if (reflect_window > 0) {
        reflect_window -= 1;
        // Check for enemy collision
        var enemy = instance_place(x, y, oEnemyTest); // Replace 'oEnemyTest' with your enemy object's name/parent
        if (enemy != noone) {
            // Bounce the player upward
            vsp = bounce_height;
            bounce_height -= 2; // Increment the bounce height for the next bounce
            reflected = true; 
            // Reflect the enemy
            with (enemy) {
                // Add your enemy reflecting logic here
            }
            // Reset the reflect window counter
            reflect_window = 0;
        }
    }
}

// Update animations
if (place_meeting(x, y + 1, oWall)) {
    // Grounded
    if (hsp == 0) {
        sprite_index = spr_idle;
        image_speed = 1; // Adjust this value based on your desired animation speed for the idle animation
    } else {
        sprite_index = spr_run;
        image_speed = 1.5; // Increase this value for faster walking animation
    }
    jump_animation_timer = -1; // Reset jump animation timer when grounded
    reflected = false;
} else {
    // In air
    if (vsp < 0) {
        if (jump_animation_timer > 0) {
            sprite_index = spr_jump;
            image_speed = 1;
            jump_animation_timer -= 1;
        } else {
            if (reflected) {
                sprite_index = choose(spr_spinball, spr_spinhori);
            } else {
                sprite_index = spr_rising;
            }
        }
    } else {
        if (reflected) {
            sprite_index = choose(spr_spinball, spr_spinhori);
        } else {
            sprite_index = spr_falling;
        }
    }
}

// Check for successful reflect
if (reflected) {
    // Choose a random falling sprite
    if (irandom(1) == 0) {
        random_falling_sprite = spr_spinball;
    } else {
        random_falling_sprite = spr_spinhori;
    }
}

// Flip the sprite based on movement direction
if (key_left) {
    image_xscale = -1;
} else if (key_right) {
    image_xscale = 1;
}