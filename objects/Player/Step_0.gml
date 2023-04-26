// Declarations of left, right, jump, and reflect
key_left = keyboard_check(vk_left) || (gamepad_axis_value(global.gamepad, gp_axislh) < -0.5) || gamepad_button_check(global.gamepad, gp_padl);
key_right = keyboard_check(vk_right) || (gamepad_axis_value(global.gamepad, gp_axislh) > 0.5) || gamepad_button_check(global.gamepad, gp_padr);
key_down = keyboard_check(vk_down) ||  (gamepad_axis_value(global.gamepad, gp_axislv) < -0.5) || gamepad_button_check(global.gamepad, gp_padd);
key_jump = keyboard_check(ord("Z")) || gamepad_button_check(global.gamepad, gp_face1);
key_jump_pressed = keyboard_check_pressed(ord("Z")) || gamepad_button_check_pressed(global.gamepad, gp_face1);
key_jump_released = keyboard_check_released(ord("Z")) || gamepad_button_check_released(global.gamepad, gp_face1);
key_reflect = keyboard_check_pressed(ord("X")) || gamepad_button_check_pressed(global.gamepad, gp_face2);

// Reflect state input
if (key_reflect && reflect_state == 0) {
    reflect_state = 1;
}

// Jump logic
if (key_jump_pressed && place_meeting(x, y + 1, oWall)) {
    jump_animation_timer = 15;
}

// Movement calculations
var move = key_right - key_left;
var control = place_meeting(x, y + 1, oWall) ? 1 : air_control;

// Acceleration, deceleration, and friction
hsp += move * acceleration * control;
hsp = clamp(hsp, -max_walk_speed, max_walk_speed);
if (move == 0 && place_meeting(x, y + 1, oWall)) {
    hsp = lerp(hsp, 0, ground_friction);
}



// Apply gravity
if (vsp < 10) {
    vsp += grv;
}

// Fast fall when pressing down key
if (key_down && !place_meeting(x, y + 1, oWall)) { 
	//lowl
    vsp = max(vsp, fast_fall_speed);
}

// Coyote Time and Jump Buffering
coyote_counter = place_meeting(x, y + 1, oWall) ? coyote_time : coyote_counter - 1;
jump_buffer_counter = key_jump_pressed ? jump_buffer : jump_buffer_counter - 1;

if (jump_buffer_counter > 0 && coyote_counter > 0) {
    vsp = -15;
    jump_buffer_counter = 0;
    coyote_counter = 0;
}

if (place_meeting(x, y + 1, oWall)) {
    bounce_height = -10;
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

// Reflect state and timer
if (reflect_state > 0) {
    reflect_timer += 1;
    if (reflect_timer >= 22) { 
        reflect_state = 0;
        reflect_timer = 0;
    } else if (reflect_timer >= 18) { 
        reflect_state = 3;
    } else if (reflect_timer >= 4) {
        reflect_state = 2;
    }
}

// Reflect logic
if (reflect_state == 1) {
    if (global.orb_effect == noone) {
        global.orb_effect = instance_create_layer(x, y, "Orb", oOrbEffect);
        global.orb_effect.sprite_index = spr_orbreflect;
    }
} else if (reflect_state == 0 && global.orb_effect != noone && global.orb_effect.sprite_index != spr_orbreflectexplode) {
    instance_destroy(global.orb_effect);
    global.orb_effect = noone;
}

if (reflect_state == 2) {
    var enemy = instance_place(x, y, oEnemyTest); // Replace 'oEnemyTest' with your enemy object's name/parent
    if (enemy != noone) {
        // Bounce the player upward
        vsp = bounce_height;
        bounce_height -= 2; // Increment the bounce height for the next bounce
        reflected = true;

        // Update orb effect sprite on successful reflection
        if (global.orb_effect != noone) {
    global.orb_effect.sprite_index = spr_orbreflectexplode;
    global.orb_effect.image_index = 0;
    global.orb_effect.exploded = false; // Reset the exploded state after reflecting off an enemy
}

        // Reflect the enemy
        with (enemy) {
            // Add your enemy reflecting logic here
        }

        // Reset the reflect state and timer
        reflect_state = 0;
        reflect_timer = 0;
    }
}

// Update animations
if (place_meeting(x, y + 1, oWall)) {
    // Grounded
    sprite_index = hsp == 0 ? spr_idle : spr_run;
    image_speed = hsp == 0 ? 1 : 2;
    reflected = false;
} else {
    // In air
    if (jump_animation_timer > 0 && vsp < 0) {
        sprite_index = spr_jump;
    } else {
        sprite_index = vsp < 0 ? (reflected ? reflect_sprite : spr_rising) : (reflected ? reflect_sprite : spr_falling);
        image_speed = 1;
    }
}

// Jump animation check
if (!place_meeting(x, y + 1, oWall) && jump_animation_timer > 0) {
    sprite_index = spr_jump;
    image_speed = vsp < 0 ? 0.5 : 0.25;
    jump_animation_timer -= 1;
}

// Variable jump height
if (key_jump_released && vsp < 0) {
    vsp *= 0.5;
}

// Flip the sprite based on movement direction
if (key_left) {
    image_xscale = -1;
} else if (key_right) {
    image_xscale = 1;
}