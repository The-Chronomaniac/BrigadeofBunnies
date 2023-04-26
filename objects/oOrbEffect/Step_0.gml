// oOrbEffect Step Event
if (Player != noone) {
    x = Player.x;
    y = Player.y;

    if (Player.reflect_state != prev_reflect_state) {
        if (Player.reflect_state == 0) {
            fadeIn = true;
            fade_out = false;
            alpha = 0;
        } else if (Player.reflect_state == 1) {
            fadeIn = true;
            fade_out = false;
            visible = true;
        } else if (Player.reflect_state == 3) {
            fadeIn = false;
            fade_out = true;
        }
        prev_reflect_state = Player.reflect_state;
    }

    if (fadeIn) {
        alpha += alpha_speed;
        if (alpha >= 0.75) {
            fadeIn = false;
        }
        image_xscale = lerp(1.75, 1.25, alpha / 0.75);
        image_yscale = lerp(1.75, 1.25, alpha / 0.75);
    } else if (fade_out) {
        alpha -= alpha_speed;
        if (alpha <= 0) {
            fade_out = false;
            visible = false;
        }
        image_xscale = 1.25;
        image_yscale = 1.25;
    } else {
        image_xscale = 1.25;
        image_yscale = 1.25;
    }

    if (sprite_index == spr_orbreflect) {
        visible = true;
        image_alpha = alpha;
    }

    if (sprite_index == spr_orbreflectexplode) {
        visible = true;
        image_alpha = explode_alpha;
    }

    if (!exploded) {
        image_speed = 0.5;
        if (image_index >= image_number - 1) {
            exploded = true;
            image_speed = 0;
            image_index = image_number - 1;
        }
    } else {
        visible = false;
    }
}
// Destroy the orb effect instance after the explode animation finishes
if (sprite_index == spr_orbreflectexplode && image_index >= image_number - 1) {
    instance_destroy();
    global.orb_effect = noone;
}
