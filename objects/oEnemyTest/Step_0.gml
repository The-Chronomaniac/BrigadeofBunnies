// Calculate the remaining distance to the target position
var remaining_distance = abs(target_x - x);

// Slow down the enemy when it's close to the target position
if (remaining_distance < slow_down_distance) {
    hsp = lerp(hsp, 0, 0.1);
} else {
    hsp = move_speed * dir;
}

// Update the enemy's position
x += hsp;

// Check if the enemy has reached the target position and change its direction
if (sign(target_x - x) != dir) {
    dir = -dir;
    target_x = x + slow_down_distance * dir;
}

// Flip the sprite based on the enemy's direction
image_xscale = dir;
