//
// Created by Lukasz Deptuch on 06.01.2018.
//

#include "game_modes.h"
void start_countdown(int game_mode) { //Countdown before the game starts

    int count = SPEED*4;
    while(wait) {

        ALLEGRO_EVENT ev;
        al_wait_for_event(event_queue, &ev);

        if (ev.type == ALLEGRO_EVENT_TIMER) {
            count--;
            if (count % SPEED == 0) {
                redraw = true;
            } else redraw = false;
        }

        if (redraw) {

            redraw = false;
            draw_apple();
            if (slowdown.powerup_draw) draw_slowdown();
            draw_snake();
            draw_borders();
            al_draw_textf(font, al_map_rgb(255, 255, 255), SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, ALLEGRO_ALIGN_CENTRE,
                          "%i", count / 15);
            al_draw_textf(font, al_map_rgb(255, 255, 255), scaled_size/2, scaled_size/2, ALLEGRO_ALIGN_LEFT, "SCORE: %i", points);
            if(game_mode == TIMEFEVER_MODE) al_draw_text(font, al_map_rgb(255, 255, 255), SCREEN_WIDTH - scaled_size/2, scaled_size/2,
                                                         ALLEGRO_ALIGN_RIGHT, "TIME LEFT: 20");
            al_flip_display();
            al_clear_to_color(al_map_rgb(3, 15, 0));

            if(count == 0) wait = false;
        }
    }
}
void endless_mode() {
    restart();
    al_stop_sample(&main_menu_id);
    if(options_music) al_play_sample(game,1,0,1,ALLEGRO_PLAYMODE_LOOP,&game_id);
    al_start_timer(timer);
    while(!done) {

        //Handle events ==================================================
        if(wait) {
            start_countdown(ENDLESS_MODE);
        }
        ALLEGRO_EVENT ev;
        al_wait_for_event(event_queue, &ev);

        if(ev.type == ALLEGRO_EVENT_TIMER) {

            // Powerups timers ============================

            if(slowdown.powerup_draw) {

                if(slowdown.countdown == 105) { // 7sec
                    slowdown.countdown = 0;
                    slowdown.powerup_draw = false;
                }
                else slowdown.countdown++;
            }
            if(slowdown.powerup_in_use) {

                if(slowdown.countdown == 52) { // 7sec still, since the timer is 2 times slower

                    slowdown.countdown = 0;
                    slowdown.powerup_in_use = false;
                    double s = al_get_timer_speed(timer);
                    al_set_timer_speed(timer, s/2);
                }
                else slowdown.countdown++;
            }
            if(flash.powerup_draw) {

                if(flash.countdown == 105) { // 7sec
                    flash.countdown = 0;
                    flash.powerup_draw = false;
                }
                else flash.countdown++;
            }
            if(flash.powerup_in_use) {

                if(flash.countdown == 310) { // 7sec still, since the timer is 2 times faster

                    flash.countdown = 0;
                    flash.powerup_in_use = false;
                    double s = al_get_timer_speed(timer);
                    al_set_timer_speed(timer, s*2);
                }
                else flash.countdown++;
            }
            if(pointsX.powerup_draw){
                if(pointsX.countdown == 105){ // time scales with other powerups - shorter with flash, longer with slowdown
                    pointsX.countdown = 0;
                    pointsX.powerup_draw = false;
                }
                else pointsX.countdown++;
            }
            if(pointsX.powerup_in_use){
                if(pointsX.countdown == 210){
                    pointsX.countdown = 0;
                    pointsX.powerup_in_use = false;
                }
                else pointsX.countdown++;
            }
            // =============================================
            redraw = true;
            move_snake();
            snake_moved = true; // it blocks the newly created snake parts from drawing until the snake moves
            event_passed = true; // it is a safe-check to not allow the snake to turn around

        }
        else if(ev.type == ALLEGRO_EVENT_DISPLAY_CLOSE) {

            done = true;
            quit = true;
        }
        else if(ev.type == ALLEGRO_EVENT_KEY_DOWN) {

            if( event_passed ) {

                switch(ev.keyboard.keycode) {

                    case ALLEGRO_KEY_ESCAPE:
                        done = true;
                        break;
                    case ALLEGRO_KEY_UP:
                        if(snake[0].dir != DOWN)
                            snake[0].dir = UP;
                        break;
                    case ALLEGRO_KEY_DOWN:
                        if(snake[0].dir != UP)
                            snake[0].dir = DOWN;
                        break;
                    case ALLEGRO_KEY_LEFT:
                        if(snake[0].dir != RIGHT)
                            snake[0].dir = LEFT;
                        break;
                    case ALLEGRO_KEY_RIGHT:
                        if(snake[0].dir != LEFT)
                            snake[0].dir = RIGHT;
                        break;
                    default:
                        break;
                }
            }
            event_passed = false;

        }
        else if(ev.type == ALLEGRO_EVENT_DISPLAY_RESIZE) { // handle manual resizing

            al_acknowledge_resize(display);
            SCREEN_HEIGHT = al_get_display_height(display);
            SCREEN_WIDTH = al_get_display_width(display);
            al_resize_display(display,SCREEN_WIDTH,SCREEN_HEIGHT);
            scale_UI();
            redraw = true;
        }

        // Check for when the game might end ============================================================
        if(snake[0].x < scaled_size || snake[0].x > SCREEN_WIDTH-scaled_size*2 || snake[0].y < scaled_size*5 || snake[0].y > SCREEN_HEIGHT-scaled_size*2) {

            game_over = true;
            done = true;
            redraw = false;
        }
        for(int i = 1; i<MAX_BODY; i++) {

            if(snake[0].x == snake[i].x && snake[0].y == snake[i].y) {

                game_over = true;
                done = true;
                redraw = false;
            }
        }
        // Check for apples =================================================
        if(snake[0].x == apple.x && snake[0].y == apple.y) {


            make_apple(); // Create another apple somewhere else
            for(int i = 1; i<MAX_BODY; i++) {

                if(snake[i].live == false)  { //Go to the end of the snake

                    snake[i].live = true; //Make new body part
                    snake_moved = false;
                    if(pointsX.powerup_in_use) points+=2;
                    else points++;

                    if(points % 5 == 0 && points!=0) {
                        slowdown.powerup_draw = true;
                        make_slowdown();
                    }
                    if(points % 15 == 0 && points !=0){
                        flash.powerup_draw = true;
                        make_flash();
                    }
                    if(points % 10 == 0 && points !=0){
                        pointsX.powerup_draw = true;
                        make_pointsx();
                    }

                    break;
                }

            }
            if(options_sound_effects) {
                al_stop_sample(&yee_id);
                al_play_sample(yee,1,0,1,ALLEGRO_PLAYMODE_ONCE,&yee_id);
            }

        }

        //PowerUps =====================================================================


        is_slowdown_eaten();
        is_flash_eaten();
        is_pointsX_eaten();

        //Draw ========================================================================
        if(redraw && al_is_event_queue_empty(event_queue)) {

            redraw = false;
            al_draw_textf(font,al_map_rgb(255,255,255),scaled_size/2,scaled_size/2,ALLEGRO_ALIGN_LEFT,"SCORE: %i",points);
            draw_apple();
            if(slowdown.powerup_draw) draw_slowdown();
            if(flash.powerup_draw) draw_flash();
            if(pointsX.powerup_draw) draw_pointsx();
            draw_snake();
            draw_borders();
            al_flip_display();
            al_clear_to_color(al_map_rgb(3,15,0));
        }

        // End Game ===================================================================
        int button = -1;
        if(game_over == true) {
            button = al_show_native_message_box(NULL, "OOPS", "You Lost", "Do you want to restart?", NULL,
                                                ALLEGRO_MESSAGEBOX_YES_NO);
            write_file(points,ENDLESS_MODE);
        }
        if(button == 1 && game_over == true) { // if yes - restart
            done = false;
            restart();
        }
        else if(button == 0 && game_over == true) { // else guit to main menu;
            done = true;
        }
    }
    restart(); // reset all the values for next game
    al_stop_sample(&game_id);
    if(options_music)al_play_sample(main_menu,1,0,1,ALLEGRO_PLAYMODE_ONCE,&main_menu_id);

}
void timefever_mode() {
    int clock = 20;
    int countdown = 0;
    al_stop_sample(&main_menu_id);
    if(options_music) al_play_sample(game,1,0,1,ALLEGRO_PLAYMODE_LOOP,&game_id);
    al_start_timer(timer);
    while(!done)
    {
        if(wait)
        {
            start_countdown(TIMEFEVER_MODE);
        }
        //Handle events ==================================================

        ALLEGRO_EVENT ev;
        al_wait_for_event(event_queue, &ev);

        if(ev.type == ALLEGRO_EVENT_TIMER) {
            // COUNTDOWN ==================================

            if(slowdown.powerup_in_use) {
                countdown+=2;
            }
            else countdown++;

            if(countdown >= SPEED) {
                countdown = 0;
                clock --;
            }

            // Powerups timers ============================
            if(slowdown.powerup_draw) {

                if(slowdown.countdown == 105) { // 7sec
                    slowdown.countdown = 0;
                    slowdown.powerup_draw = false;
                }
                else slowdown.countdown++;
            }
            if(slowdown.powerup_in_use) {

                if(slowdown.countdown == 52) { // 7sec still, since the timer is 2 times slower
                    slowdown.countdown = 0;
                    slowdown.powerup_in_use = false;
                    double s = al_get_timer_speed(timer);
                    al_set_timer_speed(timer, s/2);
                }
                else slowdown.countdown++;
            }
            if(pointsX.powerup_draw){
                if(pointsX.countdown == 105){
                    pointsX.countdown = 0;
                    pointsX.powerup_draw = false;
                }else pointsX.countdown++;
            }
            if(pointsX.powerup_in_use){
                if(pointsX.countdown == 210){
                    pointsX.countdown = 0;
                    pointsX.powerup_in_use = false;
                }else pointsX.countdown++;
            }
            // =============================================
            redraw = true;
            move_snake();
            snake_moved = true;
            event_passed = true;

        }
        else if(ev.type == ALLEGRO_EVENT_DISPLAY_CLOSE) {
            done = true;
            quit = true;
        }
        else if(ev.type == ALLEGRO_EVENT_KEY_DOWN) {

            if( event_passed ) {

                switch(ev.keyboard.keycode) {

                    case ALLEGRO_KEY_ESCAPE:
                        done = true;
                        break;
                    case ALLEGRO_KEY_UP:
                        if(snake[0].dir != DOWN)
                            snake[0].dir = UP;
                        break;
                    case ALLEGRO_KEY_DOWN:
                        if(snake[0].dir != UP)
                            snake[0].dir = DOWN;
                        break;
                    case ALLEGRO_KEY_LEFT:
                        if(snake[0].dir != RIGHT)
                            snake[0].dir = LEFT;
                        break;
                    case ALLEGRO_KEY_RIGHT:
                        if(snake[0].dir != LEFT)
                            snake[0].dir = RIGHT;
                        break;
                    default:
                        break;
                }
            }
            event_passed = false;
        }
        else if(ev.type == ALLEGRO_EVENT_DISPLAY_RESIZE) { // handle manual resizing

            al_acknowledge_resize(display);
            SCREEN_HEIGHT = al_get_display_height(display);
            SCREEN_WIDTH = al_get_display_width(display);
            al_resize_display(display,SCREEN_WIDTH,SCREEN_HEIGHT);
            scale_UI();
            redraw = true;
        }

        // Check for when the game might end ============================================================
        if(clock <= 0) { //ran out of time

            game_over = true;
            done = true;
        }
        if(snake[0].x < scaled_size || snake[0].x > SCREEN_WIDTH-scaled_size*2 || snake[0].y < scaled_size*5 || snake[0].y > SCREEN_HEIGHT-scaled_size*2) { //borders

            game_over = true;
            done = true;
            redraw = false;
        }
        for(int i = 1; i<MAX_BODY; i++) { //body

            if(snake[0].x == snake[i].x && snake[0].y == snake[i].y) {
                game_over = true;
                done = true;
                redraw = false;
            }
        }
        // Check for apples =================================================
        if(snake[0].x == apple.x && snake[0].y == apple.y) {

            clock += 3; // gain extra time
            make_apple(); // Create another apple somewhere else
            for(int i = 1; i<MAX_BODY; i++) {

                if(snake[i].live == false) { //Go to the end of the snake

                    snake[i].live = true; //Make new body part
                    snake_moved = false;
                    if(pointsX.powerup_in_use) points+=2;
                    else points++;

                    if(points % 5 == 0 && points!=0) {

                        slowdown.powerup_draw = true;
                        make_slowdown();
                    }
                    if(points % 10 == 0 && points!=0){

                        pointsX.powerup_draw = true;
                        make_pointsx();
                    }
                    if(points % 15 == 0 && points!=0){

                        flash.powerup_draw = true;
                        make_flash();
                    }
                    break;
                }
            }
        }

        //PowerUps =====================================================================

        is_slowdown_eaten();
        is_flash_eaten();
        is_pointsX_eaten();

        //Draw ========================================================================
        if(redraw && al_is_event_queue_empty(event_queue)) {

            redraw = false;
            al_draw_textf(font,al_map_rgb(255,255,255),5,5,ALLEGRO_ALIGN_LEFT,"SCORE: %i",points);
            al_draw_textf(font,al_map_rgb(255,255,255),SCREEN_WIDTH - 5, 5,ALLEGRO_ALIGN_RIGHT,"TIME LEFT: %i",clock);
            draw_apple();
            if(slowdown.powerup_draw) draw_slowdown();
            if(pointsX.powerup_draw) draw_pointsx();
            if(flash.powerup_draw) draw_flash();
            draw_snake();
            draw_borders();
            al_flip_display();
            al_clear_to_color(al_map_rgb(3,15,0));
        }

        // End Game ===================================================================
        int button = -1;
        if(game_over == true) {
            button = al_show_native_message_box(NULL, "OOPS", "You Lost", "Do you want to restart?", NULL,
                                                ALLEGRO_MESSAGEBOX_YES_NO);
            write_file(points,TIMEFEVER_MODE);
        }
        if(button == 1 && game_over == true) {
            done = false;
            restart();
        }
        else if(button == 0 && game_over == true) { // else guit to main menu;
            done = true;
        }
    }
    restart();
    al_stop_sample(&game_id);
    if(options_music)al_play_sample(main_menu,1,0,1,ALLEGRO_PLAYMODE_ONCE,&main_menu_id);
}
void wallattack_mode() {

    al_stop_sample(&main_menu_id);
    if(options_music) al_play_sample(game,1,0,1,ALLEGRO_PLAYMODE_LOOP,&game_id);
    al_start_timer(timer);
    while(!done) {

        //Handle events ==================================================
        if(wait) {

            start_countdown(ENDLESS_MODE);
        }

        ALLEGRO_EVENT ev;
        al_wait_for_event(event_queue, &ev);

        if(ev.type == ALLEGRO_EVENT_TIMER) {

            // Powerups timers ============================

            if(slowdown.powerup_draw) {

                if(slowdown.countdown == 105) { // 7sec
                    slowdown.countdown = 0;
                    slowdown.powerup_draw = false;
                }else slowdown.countdown++;
            }
            if(slowdown.powerup_in_use) {

                if(slowdown.countdown == 52) { // 7sec still, since the timer is 2 times slower

                    slowdown.countdown = 0;
                    slowdown.powerup_in_use = false;
                    double s = al_get_timer_speed(timer);
                    al_set_timer_speed(timer, s/2);
                }else slowdown.countdown++;
            }
            // =============================================
            redraw = true;
            move_snake();
            snake_moved = true;
            event_passed = true;

        }
        else if(ev.type == ALLEGRO_EVENT_DISPLAY_CLOSE) {

            done = true;
            quit = true;
        }
        else if(ev.type == ALLEGRO_EVENT_KEY_DOWN) {

            if( event_passed ) {

                switch(ev.keyboard.keycode) {

                    case ALLEGRO_KEY_ESCAPE:
                        done = true;
                        break;
                    case ALLEGRO_KEY_UP:
                        if(snake[0].dir != DOWN)
                            snake[0].dir = UP;
                        break;
                    case ALLEGRO_KEY_DOWN:
                        if(snake[0].dir != UP)
                            snake[0].dir = DOWN;
                        break;
                    case ALLEGRO_KEY_LEFT:
                        if(snake[0].dir != RIGHT)
                            snake[0].dir = LEFT;
                        break;
                    case ALLEGRO_KEY_RIGHT:
                        if(snake[0].dir != LEFT)
                            snake[0].dir = RIGHT;
                        break;
                    default:
                        break;
                }
            }
            event_passed = false;

        }
        else if(ev.type == ALLEGRO_EVENT_DISPLAY_RESIZE) { // handle manual resizing

            al_acknowledge_resize(display);
            SCREEN_HEIGHT = al_get_display_height(display);
            SCREEN_WIDTH = al_get_display_width(display);
            al_resize_display(display,SCREEN_WIDTH,SCREEN_HEIGHT);
            scale_UI();
            redraw = true;
        }

        // Check for when the game might end ============================================================
        if(snake[0].x < scaled_size || snake[0].x > SCREEN_WIDTH-scaled_size*2 || snake[0].y < scaled_size*5 || snake[0].y > SCREEN_HEIGHT-scaled_size*2) { //borders

            game_over = true;
            done = true;
            redraw = false;
        }
        for(int i = 0; i<MAX_BODY; i++){ // wall
            if(wall[i].live){
                if(snake[0].x == wall[i].x && snake[0].y == wall[i].y){
                    game_over = true;
                    done = true;
                    redraw = false;
                }
            }
            else break;
        }
        for(int i = 1; i<MAX_BODY; i++) { // body

            if(snake[i].live){
                if(snake[0].x == snake[i].x && snake[0].y == snake[i].y) {

                    game_over = true;
                    done = true;
                    redraw = false;
                }
            }
            else break;
        }
        // Check for apples =================================================
        if(snake[0].x == apple.x && snake[0].y == apple.y) {


            make_apple(); // Create another apple somewhere else
            for(int i = 1; i<MAX_BODY; i++) {

                if(snake[i].live == false)  { //Go to the end of the snake

                    snake[i].live = true; //Make new body part
                    snake_moved = false;
                    if(pointsX.powerup_in_use) points+=2;
                    else points++;

                    if(points >= level){
                        level*=2;
                        int pointsbp=points;
                        restart();
                        points = pointsbp;
                        make_walls(level/2);
                    }
                    if(points % 5 == 0 && points!=0) {
                        slowdown.powerup_draw = true;
                        make_slowdown();
                    }
                    if(points % 10 == 0 && points!=0){
                        pointsX.powerup_draw = true;
                        make_pointsx();
                    }
                    break;
                }
            }
            if(options_sound_effects == true){

                al_stop_sample(&yee_id);
                al_play_sample(yee,1,0,1,ALLEGRO_PLAYMODE_ONCE,&yee_id);
            }
        }

        //PowerUps =====================================================================

        is_slowdown_eaten();
        is_pointsX_eaten();

        //Draw ========================================================================
        if(redraw && al_is_event_queue_empty(event_queue)) {

            redraw = false;
            al_draw_textf(font,al_map_rgb(255,255,255),5,5,ALLEGRO_ALIGN_LEFT,"SCORE: %i",points);
            draw_walls();
            draw_apple();
            if(slowdown.powerup_draw) draw_slowdown();
            if(pointsX.powerup_draw) draw_pointsx();
            draw_snake();
            draw_borders();
            al_flip_display();
            al_clear_to_color(al_map_rgb(3,15,0));
        }

        // End Game ===================================================================
        int button = -1;
        if(game_over == true) {
            button = al_show_native_message_box(NULL, "OOPS", "You Lost", "Do you want to restart?", NULL,
                                                ALLEGRO_MESSAGEBOX_YES_NO);
            write_file(points,WALLATTACK_MODE);
            reset_walls();
        }
        if(button == 1 && game_over == true) {
            done = false;
            restart();
        }
        else if(button == 0 && game_over == true) { // else guit to main menu;
            done = true;
        }
    }
    restart();
    al_stop_sample(&game_id);
    if(options_music)al_play_sample(main_menu,1,0,1,ALLEGRO_PLAYMODE_ONCE,&main_menu_id);
    al_stop_timer(timer);
}
void draw_menu() {

    int count = 0;
    al_start_timer(timer);
    al_set_timer_speed(timer,1.0/21.0);

    while(!quit_menu) {

        ALLEGRO_EVENT menu_event;
        al_wait_for_event(event_queue, &menu_event);

        if (menu_event.type == ALLEGRO_EVENT_TIMER) {

            move_matrix(count);
            redraw = true;
            count++;
            if (count > 1) count = 0;
        } else if (menu_event.type == ALLEGRO_EVENT_DISPLAY_CLOSE) {

            quit_menu = true;
            selected_menu_element = QUIT_GAME;
        } else if (menu_event.type == ALLEGRO_EVENT_KEY_DOWN) {

            redraw = true;
            switch (menu_event.keyboard.keycode) {

                case ALLEGRO_KEY_UP:

                    if (selected_menu_element > 0) selected_menu_element--;
                    break;
                case ALLEGRO_KEY_DOWN:

                    if (selected_menu_element < 5) selected_menu_element++;
                    break;
                case ALLEGRO_KEY_ENTER:
                    quit_menu = true;
                    break;
                default:
                    break;
            }
        }
        else if(menu_event.type == ALLEGRO_EVENT_DISPLAY_RESIZE){


            al_acknowledge_resize(display);
            SCREEN_HEIGHT = al_get_display_height(display);
            SCREEN_WIDTH = al_get_display_width(display);
            al_resize_display(display,SCREEN_WIDTH,SCREEN_HEIGHT);
            scale_UI();
            redraw = true;
        }

        if (redraw == true && al_is_event_queue_empty(event_queue)) {

            draw_matrix();
            int font_size = scaled_size*2+(scaled_size/5)*2;

            if (selected_menu_element == ENDLESS_MODE)
                al_draw_text(font, al_map_rgb(0, 230, 0), SCREEN_WIDTH / 2, 125 , ALLEGRO_ALIGN_CENTRE,
                             "ENDLESS (Classic Snake)");
            else
                al_draw_text(font, al_map_rgb(220, 30, 0), SCREEN_WIDTH / 2, 125, ALLEGRO_ALIGN_CENTRE,
                             "ENDLESS (Classic Snake)");

            if (selected_menu_element == TIMEFEVER_MODE)
                al_draw_text(font, al_map_rgb(0, 230, 0), SCREEN_WIDTH / 2, 125 + font_size*2, ALLEGRO_ALIGN_CENTRE, "TIME FEVER");
            else al_draw_text(font, al_map_rgb(220, 30, 0), SCREEN_WIDTH / 2, 125 + font_size*2, ALLEGRO_ALIGN_CENTRE, "TIME FEVER");

            if (selected_menu_element == WALLATTACK_MODE)
                al_draw_textf(font, al_map_rgb(0, 230, 0), SCREEN_WIDTH / 2, 125 + font_size*4, ALLEGRO_ALIGN_CENTRE, "WALL ATTACK");
            else al_draw_text(font, al_map_rgb(220, 30, 0), SCREEN_WIDTH / 2, 125 + font_size*4, ALLEGRO_ALIGN_CENTRE, "WALL ATTACK");

            if (selected_menu_element == HIGH_SCORES)
                al_draw_text(font, al_map_rgb(0, 230, 0), SCREEN_WIDTH / 2, 125 + font_size*6, ALLEGRO_ALIGN_CENTRE, "HIGH SCORES");
            else al_draw_text(font, al_map_rgb(220, 30, 0), SCREEN_WIDTH / 2, 125 + font_size*6, ALLEGRO_ALIGN_CENTRE, "HIGH SCORES");

            if (selected_menu_element == OPTIONS)
                al_draw_text(font, al_map_rgb(0, 230, 0), SCREEN_WIDTH / 2, 125 + font_size*8, ALLEGRO_ALIGN_CENTRE, "OPTIONS");
            else al_draw_text(font, al_map_rgb(220, 30, 0), SCREEN_WIDTH / 2, 125 + font_size*8, ALLEGRO_ALIGN_CENTRE, "OPTIONS");

            if (selected_menu_element == QUIT_GAME)
                al_draw_text(font, al_map_rgb(0, 230, 0), SCREEN_WIDTH / 2, 125 + font_size*10, ALLEGRO_ALIGN_CENTRE, "QUIT");
            else al_draw_text(font, al_map_rgb(220, 30, 0), SCREEN_WIDTH / 2, 125 + font_size*10, ALLEGRO_ALIGN_CENTRE, "QUIT");

            redraw = false;
            al_flip_display();
            al_clear_to_color(al_map_rgb(3, 15, 0));

        }
    }
    al_set_timer_speed(timer,1.0/SPEED);
    al_stop_timer(timer);
}
void draw_options() {

    bool drawn = false;
    int option = 0;
    int resolution;
    switch (SCREEN_WIDTH){
        case 400:
            resolution = STANDARD;
            break;
        case 640:
            resolution = HD;
            break;
        case 800:
            resolution = FHD;
            break;
        default:
            resolution = CUSTOM;
            break;
    }
    int count = 0;
    al_start_timer(timer);
    al_set_timer_speed(timer,1.0/21.0);
    while(!drawn) {
        ALLEGRO_EVENT menu_event;
        al_wait_for_event(event_queue, &menu_event);

        if(menu_event.type == ALLEGRO_EVENT_TIMER) {

            redraw = true;
            move_matrix(count);
            if(count > 1) count = 0;
            else count++;

        }
        else if(menu_event.type == ALLEGRO_EVENT_DISPLAY_CLOSE) {

            quit = true;
            drawn = true;
        }
        else if(menu_event.type == ALLEGRO_EVENT_KEY_DOWN) {

            switch(menu_event.keyboard.keycode) {

                case ALLEGRO_KEY_UP:
                    redraw = true;
                    if(option > 0) option--;
                    break;
                case ALLEGRO_KEY_DOWN:
                    redraw = true;
                    if(option < 3) option++;
                    break;
                case ALLEGRO_KEY_LEFT:
                    if(option == OPTIONS_RESOLUTION){
                        redraw = true;
                        if(resolution > 0) resolution--;
                    }
                    break;
                case ALLEGRO_KEY_RIGHT:
                    if(option == OPTIONS_RESOLUTION){
                        redraw = true;
                        if(resolution < 2) resolution++;
                    }
                    break;
                case ALLEGRO_KEY_ENTER:
                    if(option == OPTIONS_SOUND_EFFECTS) {

                        if(options_sound_effects) options_sound_effects = false;
                        else options_sound_effects = true;
                        redraw = true;
                    }
                    else if(option == OPTIONS_MUSIC) {

                        if(options_music) {
                            options_music = false;
                            al_stop_sample(&main_menu_id);
                        }
                        else{
                            options_music = true;
                            al_play_sample(main_menu,1,0,1,ALLEGRO_PLAYMODE_ONCE,&main_menu_id);
                        }
                        redraw = true;

                    }
                    else if(option == OPTIONS_RESOLUTION){
                        switch(resolution){
                            case STANDARD:
                                SCREEN_HEIGHT = 500;
                                SCREEN_WIDTH = 400;
                                break;
                            case HD:
                                SCREEN_HEIGHT = 800;
                                SCREEN_WIDTH = 640;
                                break;
                            case FHD:
                                SCREEN_HEIGHT = 1000;
                                SCREEN_WIDTH = 800;
                                break;
                            default:
                                break;
                        }
                        scale_UI();
                        al_resize_display(display,SCREEN_WIDTH,SCREEN_HEIGHT);
                        redraw = true;

                    }
                    else if(option == OPTIONS_BACK) {
                        drawn = true;
                    }
                    break;
                case ALLEGRO_KEY_ESCAPE:
                    drawn = true;
                    break;
                default:
                    break;
            }


        }

        if(redraw == true && al_is_event_queue_empty(event_queue)) {

            draw_matrix();
            int font_size = scaled_size*2+(scaled_size/5)*2;

            if(option==OPTIONS_MUSIC)al_draw_text(font,al_map_rgb(0,230,0),SCREEN_WIDTH/2,150,ALLEGRO_ALIGN_CENTRE,"Music");
            else al_draw_text(font,al_map_rgb(220,30,0),SCREEN_WIDTH/2,150,ALLEGRO_ALIGN_CENTRE,"Music");

            if(options_music) al_draw_filled_rectangle(SCREEN_WIDTH -scaled_size-font_size, 150, SCREEN_WIDTH - scaled_size,150+font_size,al_map_rgb(255,255,255));
            else al_draw_rectangle(SCREEN_WIDTH -scaled_size-font_size, 150, SCREEN_WIDTH - scaled_size,150+font_size,al_map_rgb(255,255,255),2);

            if(option==OPTIONS_SOUND_EFFECTS)al_draw_text(font,al_map_rgb(0,230,0),SCREEN_WIDTH/2,150 + font_size*2,ALLEGRO_ALIGN_CENTRE,"Sound Effects");
            else    al_draw_text(font,al_map_rgb(220,30,0),SCREEN_WIDTH/2,150+font_size*2,ALLEGRO_ALIGN_CENTRE,"Sound Effects");

            if(options_sound_effects) al_draw_filled_rectangle(SCREEN_WIDTH -scaled_size-font_size, 150 + font_size*2, SCREEN_WIDTH - scaled_size,150+font_size*3,al_map_rgb(255,255,255));
            else al_draw_rectangle(SCREEN_WIDTH - scaled_size-font_size, 150+font_size*2, SCREEN_WIDTH - scaled_size,150+font_size*3,al_map_rgb(255,255,255),2);

            if(option==OPTIONS_RESOLUTION)al_draw_textf(font,al_map_rgb(0,230,0),SCREEN_WIDTH/2,150+font_size*4,ALLEGRO_ALIGN_CENTRE,"Resolution:");
            else al_draw_text(font,al_map_rgb(220,30,0),SCREEN_WIDTH/2,150+font_size*4,ALLEGRO_ALIGN_CENTRE,"Resolution:");
            switch (resolution){
                case STANDARD:
                    al_draw_text(font,al_map_rgb(0,230,0),SCREEN_WIDTH-scaled_size,150+font_size*4,ALLEGRO_ALIGN_RIGHT,"500x400");
                    break;
                case HD:
                    al_draw_text(font,al_map_rgb(0,230,0),SCREEN_WIDTH-scaled_size,150+font_size*4,ALLEGRO_ALIGN_RIGHT,"800x640");
                    break;
                case FHD:
                    al_draw_text(font,al_map_rgb(0,230,0),SCREEN_WIDTH-scaled_size,150+font_size*4,ALLEGRO_ALIGN_RIGHT,"1000x800");
                    break;
                default:
                    al_draw_text(font,al_map_rgb(0,230,0),SCREEN_WIDTH-scaled_size,150+font_size*4,ALLEGRO_ALIGN_RIGHT,"Custom");

            }

            if(option==OPTIONS_BACK)al_draw_textf(font,al_map_rgb(0,230,0),SCREEN_WIDTH/2,150+font_size*6,ALLEGRO_ALIGN_CENTRE,"back");
            else al_draw_text(font,al_map_rgb(220,30,0),SCREEN_WIDTH/2,150+font_size*6,ALLEGRO_ALIGN_CENTRE,"back");

            redraw = false;
            al_flip_display();
            al_clear_to_color(al_map_rgb(3,15,0));

        }
    }
    al_set_timer_speed(timer,1.0/SPEED);
    al_stop_timer(timer);
}
void draw_highscores() {
    int endless_score = 0;
    int timefever_score = 0;
    int wallattack_score = 0;
    int count = 0;
    read_file(&endless_score,&timefever_score,&wallattack_score);
    bool drawn = false;
    redraw = true;
    al_start_timer(timer);
    al_set_timer_speed(timer,1.0/21.0);

    while(!drawn) {

        if(redraw == true && al_is_event_queue_empty(event_queue)) {

            draw_matrix();

            al_draw_text(font, al_map_rgb(220,30,0), SCREEN_WIDTH / 2, 18, ALLEGRO_ALIGN_CENTRE, "HIGH SCORES");
            al_draw_text(font, al_map_rgb(220,30,0), 18, 150, ALLEGRO_ALIGN_LEFT, "Endless");
            al_draw_textf(font, al_map_rgb(0,230,0), SCREEN_WIDTH-18, 150, ALLEGRO_ALIGN_RIGHT,"%i", endless_score);
            al_draw_text(font, al_map_rgb(220,30,0), 18, 190, ALLEGRO_ALIGN_LEFT, "Time Fever");
            al_draw_textf(font, al_map_rgb(0,230,0), SCREEN_WIDTH-18, 190, ALLEGRO_ALIGN_RIGHT,"%i", timefever_score);
            al_draw_textf(font, al_map_rgb(220,30,0), 18, 230, ALLEGRO_ALIGN_LEFT, "Wall Attack");
            al_draw_textf(font, al_map_rgb(0,230,0), SCREEN_WIDTH-18, 230, ALLEGRO_ALIGN_RIGHT, "%i", wallattack_score);
            al_draw_text(font, al_map_rgb(220,30,0), SCREEN_WIDTH / 2, SCREEN_HEIGHT - 36, ALLEGRO_ALIGN_CENTRE,
                         "Press any key to go back");

            redraw = false;
            al_flip_display();
            al_clear_to_color(al_map_rgb(3, 15, 0));

        }
        ALLEGRO_EVENT ev;
        al_wait_for_event(event_queue, &ev);
        if (ev.type == ALLEGRO_EVENT_DISPLAY_CLOSE) {
            quit = true;
            drawn = true;
        }
        else if (ev.type == ALLEGRO_EVENT_KEY_DOWN) {

            drawn = true;
        }
        else if(ev.type == ALLEGRO_EVENT_TIMER)
        {
            redraw = true;
            move_matrix(count);
            if(count > 1) count = 0;
            else count++;
        }
    }

    al_set_timer_speed(timer,1.0/SPEED);
    al_stop_timer(timer);
}