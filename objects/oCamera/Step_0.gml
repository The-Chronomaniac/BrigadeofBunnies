// Step Event
var camSpeed = 0.1;  // Adjust this value to change camera speed
var camX = camera_get_view_x(camera);
var camY = camera_get_view_y(camera);
// Define the size of the deadzone
var deadzoneWidth = view_wview / 2;
var deadzoneHeight = view_hview / 2;

// Define the camera's target position
var targetX = target.x - view_wview / 2;
var targetY = target.y - view_hview / 2;

// Check if the target is outside the deadzone
if(abs(target.x - camX - view_wview / 2) > deadzoneWidth)
{
    targetX = target.x - sign(target.x - camX - view_wview / 2) * deadzoneWidth;
}
if(abs(target.y - camY - view_hview / 2) > deadzoneHeight)
{
    targetY = target.y - sign(target.y - camY - view_hview / 2) * deadzoneHeight;
}

camX += (targetX - camX) * camSpeed;
camY += (targetY - camY) * camSpeed;

camera_set_view_pos(camera, camX, camY);

