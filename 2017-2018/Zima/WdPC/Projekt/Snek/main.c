#include "common.h"
#include "draw.h"
#include "game_modes.h"

// Declare global variables -> they later get "externed" in common.h for use in other files =====
int SCREEN_HEIGHT = 500;
int SCREEN_WIDTH = 400;
int scaled_size = 10;

bool game_over = false;
bool done = false;
bool wait = true;
bool redraw = true;
bool event_passed = false;
bool snake_moved = false;
int points = 0;
int level = 5;
bool quit = false;
bool quit_menu = false;
int selected_menu_element = 0;
bool options_music = true;
bool options_sound_effects = true;
FILE *hs;

Matrix matrix[60];
Snake snake [MAX_BODY];
Wall wall[MAX_BODY];
Apple apple;
Slowdown slowdown;
Flash flash;
PointsX pointsX;

ALLEGRO_DISPLAY *display;
ALLEGRO_EVENT_QUEUE *event_queue;
ALLEGRO_TIMER *timer;
ALLEGRO_FONT *font;
ALLEGRO_SAMPLE *game;
ALLEGRO_SAMPLE *main_menu;
ALLEGRO_SAMPLE *yee;
ALLEGRO_SAMPLE_ID yee_id;
ALLEGRO_SAMPLE_ID game_id;
ALLEGRO_SAMPLE_ID main_menu_id;
// ===============================================================================================

int main() {

    initialize_structs(); // initialize all the starting values for snake / apple / powerups etc.
    srand(time(NULL));

    // ===============================================================================================

    if(!al_init())  return -1;  //initialize allegro

    al_set_new_display_flags(ALLEGRO_RESIZABLE);
    display = al_create_display(SCREEN_WIDTH,SCREEN_HEIGHT);

    if(!display)    return -2;

    al_install_keyboard();
    al_init_native_dialog_addon();
    al_init_font_addon();
    al_init_ttf_addon();
    al_init_primitives_addon();
    al_install_audio();
    al_init_acodec_addon();

    al_reserve_samples(3);
    game = al_load_sample("res/game_mode.ogg");
    main_menu = al_load_sample("res/main_menu.ogg");
    yee = al_load_sample("res/yee.ogg");

    event_queue = al_create_event_queue();
    timer = al_create_timer( 1.0 / SPEED );
    font = al_load_font("res/font.ttf",24,0);

    al_register_event_source(event_queue, al_get_keyboard_event_source());
    al_register_event_source(event_queue, al_get_timer_event_source(timer));
    al_register_event_source(event_queue, al_get_display_event_source(display));

    // ===============================================================================================

    al_play_sample(main_menu,1,0,1,ALLEGRO_PLAYMODE_ONCE,&main_menu_id);

    // START THE GAME UP
    while(!quit)
    {
        draw_menu();

        switch(selected_menu_element)
        {
            case ENDLESS_MODE:
                endless_mode();
                break;

            case TIMEFEVER_MODE:
                timefever_mode();
                break;

            case WALLATTACK_MODE:
                wallattack_mode();
                break;
            case HIGH_SCORES:
                draw_highscores();
                break;
            case OPTIONS:
                draw_options();
                break;

            default: // (QUIT_GAME)
                al_stop_sample(&main_menu_id);
                quit = true;
                break;

        }
        quit_menu = false;
        done = false;
        game_over = false;
        redraw = true;

    }
    al_destroy_display(display);
    al_destroy_event_queue(event_queue);
    al_destroy_timer(timer);
    al_destroy_font(font);
    al_destroy_sample(game);
    al_destroy_sample(yee);
    al_destroy_sample(main_menu);

}