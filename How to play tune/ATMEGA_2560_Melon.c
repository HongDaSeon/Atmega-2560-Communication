#include <mega2560.h>
#include <mega2560_bit.h>
#include "GlobalVariables.h"
#include "ATMEGA_2560_Melon.h"
#include <delay.h>

//                                                           C                C#             D                 D#            E                   F                 F#               G                 G#             A               A#                 B
//const float32 Melon_4[12] = {261.6256, 277.1826, 293.6648, 311.1270, 329.6276, 349.2282, 369.9944, 391.9954, 415.3047, 440.0000, 466.1638, 493.8833};
//                                                            0                 1                2                 3               4                   5                  6                  7                 8                    9              10                11
const float32 Melon_5[12] = {523.2511, 554.3653, 587.3295, 622.2540, 659.2551, 698.4565, 739.9888, 783.9909, 830.6094, 880.0000, 932.3275, 987.7666};
//                                USE FROM HERE
const float32 Melon_6[12] = {1046.502, 1108.731, 1174.659, 1244.508, 1318.510, 1396.913, 1479.978, 1567.982, 1661.219, 1760.0000,1864.655, 1975.533};

const float32 Melon_7[1] = {2093.005};

Uint16 Count_Melon_1 = 0;  //Motor locked
Uint16 Count_Melon_0 = 0;  //Motor unlocked
Uint16 Count_Melon_2 = 0; //GPS engaged


// Melon initializing
void init_Melon(void)
{
    Uint16 digit = 0;
    DDRB |= 0b10000000;

 //CTC toggle mode

    TCCR0A=0b01011010;
    TCCR0B=0b00011011; //  0 0 0 11 011

    TCNT0=0x00;

    play_Melon(Melon_5[4]);
    delay_ms(300);
    play_Melon(Melon_5[2]);
    delay_ms(100);
    play_Melon(Melon_5[0]);
    delay_ms(200);   
    play_Melon(Melon_5[2]);
    delay_ms(200);
    play_Melon(Melon_5[4]);
    delay_ms(150);
    halt_Melon(); 
    delay_ms(50);
    play_Melon(Melon_5[4]);
    delay_ms(150);
    halt_Melon(); 
    delay_ms(50);
    play_Melon(Melon_5[4]);
    delay_ms(300);
   
   

    halt_Melon();
}


// Setting Duty[msec] Value
void play_Melon(float MelonCode)
{
    float32 pre_digit = 0;
    Uint8 digit = 0;
    DDRB |= 0b10000000;
    pre_digit = (16000000/(64*2*MelonCode))-1;

    digit = (Uint8)pre_digit&0xFF;
    OCR0A = (digit)&0xff;
}

void halt_Melon(void)
{
    DDRB &= 0b01111111;
}

void BUZZ_Motor_locked(void)
{
    Count_Melon_1++;
//5�� �׹�
    if(Count_Melon_1 >= 250 && Count_Melon_1 <260) play_Melon(Melon_5[4]);
    else if(Count_Melon_1 >= 260 && Count_Melon_1 <265) halt_Melon();
    else if(Count_Melon_1 >= 265 && Count_Melon_1 <275) play_Melon(Melon_5[4]);
    else if(Count_Melon_1 >= 275 && Count_Melon_1 <280) halt_Melon();
    else if(Count_Melon_1 >= 280 && Count_Melon_1 <290) play_Melon(Melon_5[4]);
    else if(Count_Melon_1 >= 290 && Count_Melon_1 <295) halt_Melon();
    else if(Count_Melon_1 >= 295 && Count_Melon_1 <305) play_Melon(Melon_5[4]);             //change
    else if(Count_Melon_1 >= 305 && Count_Melon_1 <310) halt_Melon();
    else if(Count_Melon_1 >= 310)
    {
        Count_Melon_1 = 0;
    }
    else ;
}

void BUZZ_init_comple(void)
{
//5�� 6��
    play_Melon(Melon_5[0]);
    delay_ms(100);
    play_Melon(Melon_6[0]);
    delay_ms(100);
    halt_Melon();
}

void BUZZ_Motor_Unlocked(void)
{

    Count_Melon_0++;

    if(Count_Melon_0 >= 0 && Count_Melon_0 <20) play_Melon(Melon_6[4]);
    else if(Count_Melon_0 >= 20 && Count_Melon_0 <40) play_Melon(Melon_6[7]);
    else if(Count_Melon_0 >= 40 && Count_Melon_0 <80) play_Melon(Melon_7[0]);
    else if(Count_Melon_0 >= 80 && Count_Melon_0 <90) halt_Melon();
    else if(Count_Melon_0 >= 90)
    {
        Arduino_Stat_Code |= 0b00010000; //Unlock 
        DDRC|= 0x80;
    }
    else ;
}

void BUZZ_approching_while(void)
{
    play_Melon(Melon_5[0]);
    delay_ms(100);
    play_Melon(Melon_5[2]);
    delay_ms(100);
    play_Melon(Melon_5[4]);
    delay_ms(100);
    play_Melon(Melon_5[5]);
    delay_ms(100);
    play_Melon(Melon_5[7]);
    delay_ms(100);
    play_Melon(Melon_5[9]);
    delay_ms(100);
    play_Melon(Melon_5[11]);
    delay_ms(100);
    play_Melon(Melon_6[0]);
    delay_ms(100);

    halt_Melon();
  }

void BUZZ_end_flight(void)
{
    play_Melon(Melon_5[7]);
    delay_ms(100);
    play_Melon(Melon_5[7]);
    delay_ms(100);
    play_Melon(Melon_5[9]);
    delay_ms(100);
    play_Melon(Melon_5[9]);
    delay_ms(100);
    play_Melon(Melon_5[7]);
    delay_ms(100);
    play_Melon(Melon_5[7]);
    delay_ms(100);
    play_Melon(Melon_5[4]);
    delay_ms(200);
    play_Melon(Melon_6[7]);
    delay_ms(100);
    play_Melon(Melon_6[7]);
    delay_ms(100);
    play_Melon(Melon_6[4]);
    delay_ms(100);
    play_Melon(Melon_6[4]);
    delay_ms(100);
    play_Melon(Melon_6[2]);
    delay_ms(200);
    play_Melon(Melon_6[7]);
    delay_ms(100);
    play_Melon(Melon_6[7]);
    delay_ms(100);
    play_Melon(Melon_6[9]);
    delay_ms(100);
    play_Melon(Melon_6[9]);
    delay_ms(100);
    play_Melon(Melon_6[7]);
    delay_ms(100);
    play_Melon(Melon_6[7]);
    delay_ms(100);
    play_Melon(Melon_6[4]);
    delay_ms(200);
    play_Melon(Melon_6[7]);
    delay_ms(100);
    play_Melon(Melon_6[4]);
    delay_ms(100);
    play_Melon(Melon_6[2]);
    delay_ms(100);
    play_Melon(Melon_6[4]);
    delay_ms(100);
    play_Melon(Melon_6[0]);
    delay_ms(300);

    halt_Melon();
}

void BUZZ_GPS_caught(void)
{
    Count_Melon_2++;
    if(Count_Melon_2 >= 0 && Count_Melon_2 <20) play_Melon(Melon_5[7]);
    else if(Count_Melon_2 >= 20 && Count_Melon_2 <40) play_Melon(Melon_6[0]);              // change if condition has changed
    else if(Count_Melon_2 >= 40 && Count_Melon_2 <50) halt_Melon();
    else if(Count_Melon_2 >= 50)
    {   
        Arduino_Stat_Code |= 1 << haveGPScaught; 
        Arduino_Stat_Code |= 0b01000000;
        Count_Melon_2 = 0;
    }
    else ;                                                  
}





