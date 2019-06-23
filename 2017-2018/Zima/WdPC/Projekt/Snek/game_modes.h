//
// Created by Lukasz Deptuch on 06.01.2018.
//

#ifndef SNEK_GAME_MODES_H
#define SNEK_GAME_MODES_H

#include "common.h"
#include "draw.h"
#include "update.h"

void start_countdown(int game_mode); // a countdown to let the player get ready before the start of any game mode
void timefever_mode();
void endless_mode();
void wallattack_mode();
void draw_menu();
void draw_options();
void draw_highscores();

#endif //SNEK_GAME_MODES_H