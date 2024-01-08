// Target object to follow
target = Player; // Replace with your player object's name

// Set up the camera
camera = camera_create();
view_wview = 1280;
view_hview = 720;

// Assign the camera to view 0
view_camera[0] = camera;

// Set the camera properties
camera_set_view_size(camera, view_wview, view_hview);
camera_set_view_pos(camera, target.x - view_wview / 2, target.y - view_hview / 2);
