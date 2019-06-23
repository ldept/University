//
// Created by Lukasz Deptuch on 04.01.2018.
//

#ifndef SNEK_UPDATE_H
#define SNEK_UPDATE_H

#include "common.h"
void scale_UI();
void initialize_structs();
void move_snake();
void move_matrix(int count);
void make_apple(); // create an apple somewhere in the grid where it doesn't collide with any other struct
void make_slowdown(); // same description applies to any make* function
void make_flash();
void make_pointsx();
void make_walls(int level);
void reset_walls(); // destroy the not needed walls
void is_slowdown_eaten(); // check if a slowdown PowerUp was "eaten"
void is_pointsX_eaten(); // same ^
void is_flash_eaten(); // same ^
void restart(); // reset everything (so that all structs etc. are ready for next game)
void read_file(int *endless_score,int *timefever_score,int *wallattack_score); // read the high scores
void write_file(int score, int game_mode); // write the high score to the file (if scored enough points)

#endif //SNEK_UPDATE_H