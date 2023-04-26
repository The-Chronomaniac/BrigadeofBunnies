if (instance_exists(target)) {
    var cam_x = lerp(camera_get_view_x(camera), target.x - view_wview / 2, 0.1);
    var cam_y = lerp(camera_get_view_y(camera), target.y - view_hview / 2, 0.1);

    camera_set_view_pos(camera, cam_x, cam_y);
}
