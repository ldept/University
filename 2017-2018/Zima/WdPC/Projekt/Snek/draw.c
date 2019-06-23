//
// Created by Lukasz Deptuch on 04.01.2018.
//

#include "draw.h"
#include "update.h"
void draw_matrix(){
    for (int i = 0; i < 60; i++) {
        if (matrix[i].live) {
            al_draw_filled_rectangle(matrix[i].x, matrix[i].y, matrix[i].x + scaled_size, matrix[i].y + scaled_size,
                                     al_map_rgb(0, 180, 0));
            al_draw_filled_rectangle(matrix[i].x, matrix[i].y - scaled_size, matrix[i].x + scaled_size, matrix[i].y,
                                     al_map_rgb(0, 100, 0));
            al_draw_filled_rectangle(matrix[i].x, matrix[i].y - 20, matrix[i].x + scaled_size, matrix[i].y - scaled_size,
                                     al_map_rgb(0, 64, 0));
            al_draw_filled_rectangle(matrix[i].x, matrix[i].y - 30, matrix[i].x + scaled_size, matrix[i].y - 20,
                                     al_map_rgb(0, 22, 0));
            al_draw_filled_rectangle(matrix[i].x, matrix[i].y - 40, matrix[i].x + scaled_size, matrix[i].y - 30,
                                     al_map_rgb(0, 21, 0));
            al_draw_filled_rectangle(matrix[i].x, matrix[i].y - 50, matrix[i].x + scaled_size, matrix[i].y - 40,
                                     al_map_rgb(0, 20, 0));
        } else break;
    }
}
void draw_apple() {
    al_draw_filled_rectangle(apple.x,apple.y,apple.x + scaled_size,apple.y + scaled_size,al_map_rgb(0,0,255));
}
void draw_slowdown() {
    al_draw_filled_rectangle(slowdown.x,slowdown.y,slowdown.x+scaled_size,slowdown.y+scaled_size,al_map_rgb(255,0,255));
}
void draw_flash(){
    al_draw_filled_rectangle(flash.x,flash.y,flash.x+scaled_size,flash.y+scaled_size,al_map_rgb(255,0,0));
}
void draw_pointsx(){
    al_draw_filled_rectangle(pointsX.x,pointsX.y,pointsX.x+scaled_size,pointsX.y+scaled_size,al_map_rgb(150,50,50));
}
void draw_borders() {
    al_draw_rectangle(scaled_size/2,scaled_size*4+scaled_size/2,SCREEN_WIDTH-scaled_size/2,SCREEN_HEIGHT-scaled_size/2,al_map_rgb(255,255,255),scaled_size);
}
void draw_walls(){

    for(int i = 0; i<MAX_BODY; i++){
        if(wall[i].live == true){
            al_draw_filled_rectangle(wall[i].x,wall[i].y,wall[i].x+scaled_size,wall[i].y+scaled_size,al_map_rgb(255,255,255));
        }
    }

}
void draw_snake() {
    int r = 0;
    int b = 0;
    for(int i = 0; i<MAX_BODY; i++)
    {
        r = (r + 10) % 255 ;
        b = (b + 5) % 220;
        if(snake[i].live == true)
        {
            if(i!=0) // to color the head differently
            {
                if(i < MAX_BODY - 2) // to not go out of the scope with i+1; the snake would never be that long anyway, this is just in case;
                {
                    if (snake[i + 1].live == false && snake_moved == false) {
                        continue;   // to not draw the newly added body part since it doesn't have specified "x" and "y" yet
                    } else
                        al_draw_filled_rectangle(snake[i].x, snake[i].y, snake[i].x + scaled_size, snake[i].y + scaled_size,
                                                 al_map_rgb(0, 220, r));   //draw rest of the body parts;
                }

            } else    al_draw_filled_rectangle(snake[i].x,snake[i].y,snake[i].x + scaled_size, snake[i].y + scaled_size,al_map_rgb(24,130,0));
        }else break;

    }
}