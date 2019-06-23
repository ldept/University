//
// Created by Lukasz Deptuch on 04.01.2018.
//

#ifndef SNEK_COMMON_H
#define SNEK_COMMON_H

#include <stdbool.h>
#include <allegro5/allegro5.h>
#include <allegro5/allegro_native_dialog.h>
#include <allegro5/allegro_primitives.h>
#include <allegro5/allegro_audio.h>
#include <allegro5/allegro_acodec.h>
#include <allegro5/allegro_font.h>
#include <allegro5/allegro_ttf.h>
#include <stdio.h>

extern int SCREEN_HEIGHT;
extern int SCREEN_WIDTH;
extern int scaled_size;
#define SNAKE_STARTX (SCREEN_WIDTH / 2 - (SCREEN_WIDTH/2 % scaled_size))
#define SNAKE_STARTY (SCREEN_HEIGHT / 2 - (SCREEN_HEIGHT/2 % scaled_size))

#define SPEED 15
#define MAX_BODY 1672 //a dynamically allocated array would be easier on memory,
//but since it is still a rather small value the program can be a bit faster and more simple / easier to read.


enum KEYS{UP, DOWN, LEFT, RIGHT};
enum MENU_ELEMENTS{ENDLESS_MODE, TIMEFEVER_MODE, WALLATTACK_MODE, HIGH_SCORES, OPTIONS, QUIT_GAME};
enum OPTIONS{OPTIONS_MUSIC,OPTIONS_SOUND_EFFECTS,OPTIONS_RESOLUTION,OPTIONS_BACK};
enum RES{STANDARD,HD,FHD,CUSTOM};


typedef struct Snake {
    int dir;
    int x;
    int y;
    bool live;

}Snake;

typedef struct Apple {
    int x;
    int y;
}Apple;

typedef struct Slowdown {
    int x;
    int y;
    int countdown;
    bool powerup_draw;
    bool powerup_in_use;
}Slowdown;

typedef struct Flash {
    int x;
    int y;
    int countdown;
    bool powerup_draw;
    bool powerup_in_use;
}Flash;

typedef struct PointsX{
    int x;
    int y;
    int countdown;
    bool powerup_draw;
    bool powerup_in_use;
}PointsX;

typedef struct Wall{
    int x;
    int y;
    bool live;
}Wall;

typedef struct Matrix {
    int x;
    int y;
    bool live;
}Matrix;

extern Matrix matrix[60];
extern Snake snake[MAX_BODY];
extern Wall wall[MAX_BODY];
extern Apple apple;
extern Slowdown slowdown;
extern Flash flash;
extern PointsX pointsX;

extern bool game_over;
extern bool done;
extern bool wait;
extern bool redraw;
extern bool event_passed;
extern bool snake_moved;
extern int points;
extern int level;

//=================================
extern bool quit;
extern bool quit_menu;
extern int selected_menu_element;
extern bool options_music;
extern bool options_sound_effects;
extern FILE *hs;

extern ALLEGRO_DISPLAY *display;
extern ALLEGRO_EVENT_QUEUE *event_queue;
extern ALLEGRO_TIMER *timer;
extern ALLEGRO_FONT *font;
extern ALLEGRO_SAMPLE *main_menu;
extern ALLEGRO_SAMPLE_ID main_menu_id;
extern ALLEGRO_SAMPLE *yee;
extern ALLEGRO_SAMPLE_ID yee_id;
extern ALLEGRO_SAMPLE *game;
extern ALLEGRO_SAMPLE_ID game_id;


#endif //SNEK_COMMON_H