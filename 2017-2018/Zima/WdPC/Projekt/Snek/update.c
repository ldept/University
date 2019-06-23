//
// Created by Lukasz Deptuch on 04.01.2018.
//

#include "update.h"

void scale_UI() {
    scaled_size = SCREEN_WIDTH/40;
    font = al_load_font("res/font.ttf",scaled_size*2+(scaled_size/5)*2,0);
    for(int i = 0;i<60;i++){
        matrix[i].x =  rand() % (SCREEN_WIDTH - scaled_size*2) +scaled_size;
        matrix[i].y = rand() % (SCREEN_HEIGHT - scaled_size*2) +scaled_size;
    }
    
}
void initialize_structs() {
    snake[0].dir = rand() % 4; snake[0].x = SNAKE_STARTX; snake[0].y = SNAKE_STARTY; snake[0].live = true;
    wall[0].live =false;
    make_apple();
    for(int i = 1;i<MAX_BODY;i++)
    {
        snake[i].live = false;
        wall[i].live = false;
    }
    slowdown.powerup_draw = false;
    slowdown.powerup_in_use = false;
    slowdown.countdown = 0;
    flash.powerup_draw = false;
    flash.powerup_in_use = false;
    flash.countdown = 0;
    pointsX.powerup_draw = false;
    pointsX.powerup_in_use = false;
    pointsX.countdown = 0;
    for(int i = 0; i<scaled_size*6;i++)
    {
        matrix[i].live = false;
        matrix[i].y = - scaled_size;
        matrix[i].x = rand() % (SCREEN_WIDTH - scaled_size*2) +scaled_size;
    }

}
void make_apple() {
    bool isClear = false;
    int rx, ry;
    while(!isClear)
    {
        rx = rand() % (SCREEN_WIDTH - scaled_size*2) + scaled_size;   //Create random x and y
        ry = rand() % (SCREEN_HEIGHT - scaled_size*6) + scaled_size*5;
        rx = rx - (rx % scaled_size);
        ry = ry - (ry % scaled_size);
        for(int i = 0;i<MAX_BODY; i++)
        {
            if(snake[i].live == true)
            {
                if( (snake[i].x == rx  && snake[i].y == ry ) || (slowdown.x == rx && slowdown.y == ry) || (flash.x == rx && flash.y == ry) || (pointsX.x == rx && pointsX.y == ry) ) //Check if they don't collide with already created structs
                {
                    rx = rand() % (SCREEN_WIDTH - scaled_size*2) + scaled_size;   //Create random x and y
                    ry = rand() % (SCREEN_HEIGHT - scaled_size*6) + scaled_size*5;
                    rx = rx - (rx % scaled_size);
                    ry = ry - (ry % scaled_size);
                    i = 0;
                }
            }
            else
            {
                isClear = true;
                break;
            }
        }
        for(int i = 0;i<MAX_BODY; i++){
            if(wall[i].live){
                if( (wall[i].x == rx  && wall[i].y == ry ) || (slowdown.x == rx && slowdown.y == ry) || (flash.x == rx && flash.y == ry) || (pointsX.x == rx && pointsX.y == ry) ) {
                    rx = rand() % (SCREEN_WIDTH - scaled_size*2) + scaled_size;   //Create random x and y
                    ry = rand() % (SCREEN_HEIGHT - scaled_size*6) + scaled_size*5;
                    rx = rx - (rx % scaled_size);
                    ry = ry - (ry % scaled_size);
                    i = 0;
                    isClear = false;
                }
            } else break;
        }
    }

    apple.x = rx;  //Pass x and y which are multiples of scaled_size (because of our grid)
    apple.y = ry;

}
void make_slowdown() {

    int rx, ry;
    bool isClear = false;
    while(!isClear) // Check if rx and ry don't point at occupied
    {
        rx = rand() % (SCREEN_WIDTH - scaled_size*2) + scaled_size;   //Create random x and y
        ry = rand() % (SCREEN_HEIGHT - scaled_size*6) + scaled_size*5;
        rx = rx - (rx % scaled_size);
        ry = ry - (ry % scaled_size);
        for(int i = 0;i<MAX_BODY; i++)
        {
            if(snake[i].live == true)
            {
                if((snake[i].x == rx  && snake[i].y == ry) || (apple.x == rx && apple.y == ry) || (flash.x == rx && flash.y == ry) || (pointsX.x == rx && pointsX.y == ry))
                {
                    rx = rand() % (SCREEN_WIDTH - scaled_size*2) + scaled_size;   //Create random x and y
                    ry = rand() % (SCREEN_HEIGHT - scaled_size*6) + scaled_size*5;
                    rx = rx - (rx % scaled_size);
                    ry = ry - (ry % scaled_size);
                    i = 0;
                }
            }
            else
            {
                isClear = true;
            }
        }
        for(int i = 0;i<MAX_BODY; i++){
            if(wall[i].live){
                if( (wall[i].x == rx  && wall[i].y == ry ) || (apple.x == rx && apple.y == ry) || (flash.x == rx && flash.y == ry) || (pointsX.x == rx && pointsX.y == ry) ) {
                    rx = rand() % (SCREEN_WIDTH - scaled_size*2) + scaled_size;   //Create random x and y
                    ry = rand() % (SCREEN_HEIGHT - scaled_size*6) + scaled_size*5;
                    rx = rx - (rx % scaled_size);
                    ry = ry - (ry % scaled_size);
                    i = 0;
                    isClear = false;
                }
            } else break;
        }
    }

    slowdown.x = rx;  //Pass x and y which are multiples of scaled_size (because of our grid)
    slowdown.y = ry;
}
void make_flash() {

    int rx, ry;
    bool isClear = false;
    while(!isClear) // Check if rx and ry don't point at occupied
    {
        rx = rand() % (SCREEN_WIDTH - scaled_size*2) + scaled_size;   //Create random x and y
        ry = rand() % (SCREEN_HEIGHT - scaled_size*6) + scaled_size*5;
        rx = rx - (rx % scaled_size);
        ry = ry - (ry % scaled_size);
        for(int i = 0;i<MAX_BODY; i++)
        {
            if(snake[i].live == true)
            {
                if((snake[i].x == rx  && snake[i].y == ry) || (apple.x == rx && apple.y == ry) || (slowdown.x == rx && slowdown.y == ry) || (pointsX.x == rx && pointsX.y == ry))
                {
                    rx = rand() % (SCREEN_WIDTH - scaled_size*2) + scaled_size;   //Create random x and y
                    ry = rand() % (SCREEN_HEIGHT - scaled_size*6) + scaled_size*5;
                    rx = rx - (rx % scaled_size);
                    ry = ry - (ry % scaled_size);
                    i = 0;
                }
            }
            else
            {
                isClear = true;
            }
        }
        for(int i = 0;i<MAX_BODY; i++){
            if(wall[i].live){
                if( (wall[i].x == rx  && wall[i].y == ry ) || (slowdown.x == rx && slowdown.y == ry) || (apple.x == rx && apple.y == ry) || (pointsX.x == rx && pointsX.y == ry) ) {
                    rx = rand() % (SCREEN_WIDTH - scaled_size*2) + scaled_size;   //Create random x and y
                    ry = rand() % (SCREEN_HEIGHT - scaled_size*6) + scaled_size*5;
                    rx = rx - (rx % scaled_size);
                    ry = ry - (ry % scaled_size);
                    i = 0;
                    isClear = false;
                }
            } else break;
        }
    }

    flash.x = rx;  //Pass x and y which are multiples of scaled_size (because of our grid)
    flash.y = ry;
}
void make_pointsx() {

    int rx, ry;
    bool isClear = false;
    while(!isClear) // Check if rx and ry don't point at occupied
    {
        rx = rand() % (SCREEN_WIDTH - scaled_size*2) + scaled_size;   //Create random x and y
        ry = rand() % (SCREEN_HEIGHT - scaled_size*6) + scaled_size*5;
        rx = rx - (rx % scaled_size);
        ry = ry - (ry % scaled_size);
        for(int i = 0;i<MAX_BODY; i++)
        {
            if(snake[i].live == true)
            {
                if((snake[i].x == rx  && snake[i].y == ry) || (apple.x == rx && apple.y == ry) || (slowdown.x == rx && slowdown.y ==ry) || (flash.x == rx && flash.y == ry))
                {
                    rx = rand() % (SCREEN_WIDTH - scaled_size*2) + scaled_size;   //Create random x and y
                    ry = rand() % (SCREEN_HEIGHT - scaled_size*6) + scaled_size*5;
                    rx = rx - (rx % scaled_size);
                    ry = ry - (ry % scaled_size);
                    i = 0;
                }
            }
            else
            {
                isClear = true;
            }
        }
        for(int i = 0;i<MAX_BODY; i++){
            if(wall[i].live){
                if( (wall[i].x == rx  && wall[i].y == ry ) || (slowdown.x == rx && slowdown.y == ry) || (flash.x == rx && flash.y == ry) || (apple.x == rx && apple.y == ry) ) {
                    rx = rand() % (SCREEN_WIDTH - scaled_size*2) + scaled_size;   //Create random x and y
                    ry = rand() % (SCREEN_HEIGHT - scaled_size*6) + scaled_size*5;
                    rx = rx - (rx % scaled_size);
                    ry = ry - (ry % scaled_size);
                    i = 0;
                    isClear = false;
                }
            } else break;
        }
    }

    pointsX.x = rx;  //Pass x and y which are multiples of scaled_size (because of our grid)
    pointsX.y = ry;
}
void is_slowdown_eaten(){

    if(snake[0].x == slowdown.x && snake[0].y == slowdown.y && slowdown.powerup_draw == true) { //Apply Slowdown PowerUp

        slowdown.powerup_draw = false;
        slowdown.countdown = 0;
        double s = al_get_timer_speed(timer);
        al_set_timer_speed(timer, s*2);
        slowdown.powerup_in_use = true;
        if(options_sound_effects){
            al_stop_sample(&yee_id);
            al_play_sample(yee,1,0,1,ALLEGRO_PLAYMODE_ONCE,&yee_id);
        }
    }
}
void is_flash_eaten(){

    if(snake[0].x == flash.x && snake[0].y == flash.y && flash.powerup_draw == true) { //Apply flash PowerUp

        flash.powerup_draw = false;
        flash.countdown = 0;
        double s = al_get_timer_speed(timer);
        al_set_timer_speed(timer, s/2);
        flash.powerup_in_use = true;
        if(options_sound_effects){
            al_stop_sample(&yee_id);
            al_play_sample(yee,1,0,1,ALLEGRO_PLAYMODE_ONCE,&yee_id);
        }
    }

}
void is_pointsX_eaten(){

    if(snake[0].x == pointsX.x && snake[0].y == pointsX.y && pointsX.powerup_draw == true) { //Apply pointsX PowerUp

        pointsX.powerup_draw = false;
        pointsX.countdown = 0;
        pointsX.powerup_in_use = true;
        if(options_sound_effects){
            al_stop_sample(&yee_id);
            al_play_sample(yee,1,0,1,ALLEGRO_PLAYMODE_ONCE,&yee_id);
        }
    }
}
void move_snake() {
    int helpx1 = snake[0].x, helpy1 = snake[0].y;
    int helpx2, helpy2;
    for(int i = 1; i<MAX_BODY; i++)
    {

        if(snake[i].live == true)
        {
            helpx2 = snake[i].x;
            helpy2 = snake[i].y;

            snake[i].x = helpx1;
            snake[i].y = helpy1;
        }
        else break;

        helpx1 = helpx2;
        helpy1 = helpy2;
    }
    if(snake[0].dir == UP)     snake[0].y -= scaled_size;
    if(snake[0].dir == DOWN)   snake[0].y += scaled_size;
    if(snake[0].dir == LEFT)   snake[0].x -= scaled_size;
    if(snake[0].dir == RIGHT)  snake[0].x += scaled_size;


}
void move_matrix(int count){
    for(int i = 0; i<60;i++) {
        if(matrix[i].live == true) {
            if(matrix[i].y > SCREEN_HEIGHT) {

                matrix[i].y = -scaled_size*8;
            }
            matrix[i].y += scaled_size/2;
        }
        else {
            if((count)%2 == 0)matrix[i].live = true;
            break;
        }
    }
}
void make_walls(int level){
    int rx,ry;
    bool isClear;

    for(int i = 0; i<level; i++){
        isClear = true;
        while(isClear){
            rx = rand() % (SCREEN_WIDTH - scaled_size*2) + scaled_size;   //Create random x and y
            ry = rand() % (SCREEN_HEIGHT - scaled_size*6) + scaled_size*5;
            rx = rx - (rx % scaled_size);
            ry = ry - (ry % scaled_size);
            if(!(snake[0].x == rx && snake[0].y == ry) && !(apple.x == rx && apple.y == ry)){
                isClear = false;
            }
        }
        wall[i].live = true;
        wall[i].x = rx;
        wall[i].y = ry;

    }


}
void reset_walls(){
    level = 5;
    for(int i = 0;i<MAX_BODY;i++){
        if(wall[i].live){
            wall[i].live = false;
        }else break;
    }
}
void restart() {
    wait = true;
    game_over = false;
    redraw = true;
    event_passed = false;
    points = 0;
    snake[0].x = SNAKE_STARTX;
    snake[0].y = SNAKE_STARTY;
    snake[0].dir = rand() % 4;
    make_apple();
    slowdown.countdown = 0;
    slowdown.powerup_draw = false;
    slowdown.powerup_in_use = false;
    flash.powerup_draw = false;
    flash.powerup_in_use = false;
    flash.countdown = 0;
    pointsX.powerup_draw = false;
    pointsX.powerup_in_use = false;
    pointsX.countdown = 0;
    for(int i = 1; i<MAX_BODY; i++)
    {
        if(snake[i].live == true)
        {
            snake[i].live = false;
            snake[i].x = 0;
            snake[i].y = 0;

        }else break;
    }

    al_flush_event_queue(event_queue);
}
void read_file(int *endless_score, int *timefever_score,int *wallattack_score ){

    hs = fopen("res/high_scores.txt", "r+");
    int next = 0;

    while (!feof(hs)) {
        switch (next) {
            case 0:
                fscanf(hs, "%i", endless_score);
                break;
            case 1:
                fscanf(hs, "%i", timefever_score);
                break;
            default:
                fscanf(hs, "%i", wallattack_score);
                break;

        }
        next++;
    }
    fclose(hs);
}
void write_file(int score,int game_mode){

    int endless_score = 0 ,timefever_score = 0,wallattack_score = 0;
    read_file(&endless_score,&timefever_score,&wallattack_score);

    switch (game_mode){
        case ENDLESS_MODE:
            if(endless_score < score) {
                hs = fopen("res/high_scores.txt","w");
                endless_score = score;
                fprintf(hs,"%i\n",endless_score);
                fprintf(hs,"%i\n",timefever_score);
                fprintf(hs,"%i",wallattack_score);
                fclose(hs);
            }
            break;
        case TIMEFEVER_MODE:
            if(timefever_score < score){
                hs = fopen("res/high_scores.txt","w");
                timefever_score = score;
                fprintf(hs,"%i\n",endless_score);
                fprintf(hs,"%i\n",timefever_score);
                fprintf(hs,"%i",wallattack_score);
                fclose(hs);
            }
            break;
        case WALLATTACK_MODE:
            if(wallattack_score < score){
                hs = fopen("res/high_scores.txt","w");
                wallattack_score = score;
                fprintf(hs,"%i\n",endless_score);
                fprintf(hs,"%i\n",timefever_score);
                fprintf(hs,"%i",wallattack_score);
                fclose(hs);
                //clear the file
                //wallattack_score = score;
                //write to file
            }
        default:
            break;
    }
}
