// include party ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#include <mega2560.h>
#include "GlobalVariables.h"
#include <mega2560_bit.h>
#include "ATMEGA_2560_TWI.h"
#include "Atmega_2560_UART.h"
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "ATMEGA_2560_Melon.h"
// define the system parameters +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Command
#define Conver_D1_4096  0x48
#define Conver_D2_4096  0x58
#define Command_ADC_READ  0x00
#define Command_PROM_READ   0xA0
// Converersion Time
//#define OSR_4096     10

float32 Alti_bias = 0;
float32 P;
float32 T;
float32 dT;
float32 OFF;
float32 SENS;
float32 H_alt;
float32 H_temp;
bit authority_valid= 0;
// let's roll ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// TWI initiating function +++++++++++++++++++++++++++++++++++++
void TWI_init(void)
{
    TWBR = 12;     //  400kHz
    TWSR = 0x00;
}

void TWI_Make_thispoint_into_zero(void)
{
    float32 sample1 = 0;
    float32 sample2 = 0;
    float32 sample3 = 0;
    float32 sample4 = 0;


    while(authority_valid == 0)
    {
        TWI_read_command(Conver_D1_2048, OSR_2048);
        delay_ms(10);
        D1 = TWI_read_read(Conver_D1_2048, OSR_2048);
        TWI_read_command(Conver_D2_2048, OSR_2048);
        delay_ms(10);
        D2 = TWI_read_read(Conver_D2_2048, OSR_2048);
        MS5611();
        sample1 = Altitude;
        TWI_read_command(Conver_D1_2048, OSR_2048);
        delay_ms(10);
        D1 = TWI_read_read(Conver_D1_2048, OSR_2048);
        TWI_read_command(Conver_D2_2048, OSR_2048);
        delay_ms(10);
        D2 = TWI_read_read(Conver_D2_2048, OSR_2048);
        MS5611();
        sample2 = Altitude;
        TWI_read_command(Conver_D1_2048, OSR_2048);
        delay_ms(10);
        D1 = TWI_read_read(Conver_D1_2048, OSR_2048);
        TWI_read_command(Conver_D2_2048, OSR_2048);
        delay_ms(10);
        D2 = TWI_read_read(Conver_D2_2048, OSR_2048);
        MS5611();
        sample3 = Altitude;
        TWI_read_command(Conver_D1_2048, OSR_2048);
        delay_ms(10);
        D1 = TWI_read_read(Conver_D1_2048, OSR_2048);
        TWI_read_command(Conver_D2_2048, OSR_2048);
        delay_ms(10);
        D2 = TWI_read_read(Conver_D2_2048, OSR_2048);
        MS5611();
        sample4 = Altitude;

        if((abs(sample4 - sample3) < 1) && (abs(sample4 - sample2) < 1) &&(abs(sample4 - sample1) < 1))
        {
            if((abs(sample3 - sample4) < 1) && (abs(sample3 - sample2) < 1) &&(abs(sample3 - sample1) < 1))
            {
                if((abs(sample2 - sample4) < 1) && (abs(sample2 - sample3) < 1) &&(abs(sample2 - sample1) < 1))
                {
                    if((abs(sample1 - sample4) < 1) && (abs(sample1 - sample3) < 1) &&(abs(sample1 - sample2) < 1))
                    {
                        authority_valid = 1;
                        Alti_bias = 0.0 - ((sample1+sample2+sample3+sample4)/4.0);
                    }
                }
            }
        }
    }
}

//TWI command writing+++++++++++++++++++++++++++++++++++++
void TWI_write(Uint8 Command)
{
    TWCR = 0xA4; //0b10100100  // start

    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x08));

    TWDR = 0xEC; //0b11101100 //Adress +W
    TWCR = 0x84; //0b10000100
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x18));

    TWDR = Command;
    TWCR = 0x84; //0b10000100
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x28));

    TWCR = 0x94; //0b10010100   //stop
    delay_ms(10);
}

//Read the Coefficient +++++++++++++++++++++++++++++++++++++++
Uint16 PROM_read(Uint8 PROM_Command)
{
//Declare variables ++++++++++++++++++++++++++++++++++
    Uint16 PROM_dat1;
    Uint16 PROM_dat2;
    Uint16 data;
//TWI Control ++++++++++++++++++++++++++++++++++++++
    TWCR = 0xA4; //0b10100100 //start
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x08));

    TWDR = 0xEC; //0b11101100 //Adress + W
    TWCR = 0x84; //0b10000100 //
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x18));

    TWDR = PROM_Command;
    TWCR = 0x84; //0b10000100 //transmit command
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x28));

    //Restart
    TWCR = 0xA4; //0b10100100 //start
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x10));

    TWDR = 0xED; //0b11101101 //Adress + R
    TWCR = 0x84; //0b10000100
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x40));

    TWCR = 0xC4; //0b11000100 //ACK
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x50));
    PROM_dat1 = TWDR;
    TWCR = 0x84; //0b10000100 //interrupt clear
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x58));
    PROM_dat2 = TWDR;
    TWCR = 0x94; //0b10010100 //stop
//data fusion  ++++++++++++++++++++++++++++++++
    data = (Uint16)(((PROM_dat1<<8)&0xFF00) | PROM_dat2);

    return data;
}

//Read the data that correspond to a command ++++++++++++++++++++
void TWI_read_command(Uint8 command, int Conver_TIME)
{
    TWCR = 0xA4; //0b10100100 //start
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x08));

    TWDR = 0xEC; //0b11101100 //Adress + W
    TWCR = 0x84; //0b10000100 //transmit command
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x18));

    TWDR = command;
    TWCR = 0x84; //0b10000100 //transmit command
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x28));
    //delay_ms(Conver_TIME); //don't know why but delay should be

Uint32 TWI_read_read(Uint8 command, int Conver_TIME)
{
    Uint32 ADCff0000;
    Uint32 ADC00ff00;
    Uint32 ADC0000ff;
    Uint32 ADC = 0;
    // restart
    TWCR = 0xA4; //0b10100100 //start
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x10));

    TWDR = 0xEC; //0b11101100 //Adress + W
    TWCR = 0x84; //0b10000100 //transmit command
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x18));

    TWDR = Command_ADC_READ;
    TWCR = 0x84; //0b10000100 //transmit command
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x28));

    // restart
    TWCR = 0xA4; //0b10100100 //start
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x10));

    TWDR = 0xED; //0b11101101 //Adress + R
    TWCR = 0x84; //0b10000100 //transmit command
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x40));

    TWCR = 0xC4; //0b11000100 //ACK
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x50));
    ADCff0000 = TWDR;

    TWCR = 0xC4; //0b11000100 //ACK
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x50));
    ADC00ff00 = TWDR;

    TWCR = 0x84; //0b10000100 //transmit command
    while(((TWCR & 0x80) == 0x00) || ((TWSR & 0xf8) != 0x58));
    ADC0000ff = TWDR;

    // Stop
    TWCR = 0x94; //0b10010100 //stop
    //Data fusion  +++++++++++++++++++++++++++++++++
    ADC = ((ADCff0000 << 16)&0x00FF0000) | ((ADC00ff00<< 8)&0x0000FF00) | (ADC0000ff&0x000000FF);

    return ADC;
}

void MS5611(void)
{
    dT = D2 - PROM[5]*256.0;
    T = (float32)((2000 + (dT*PROM[6]) / 8388608.0) / 100);

    OFF = (float32)(PROM[2]*65536.0 + (dT*PROM[4])/128.0);
    SENS = (float32)(PROM[1]*32768.0 + dT*PROM[3]/256.0);
    P = (float32)((((D1*SENS)/2097152.0 - OFF)/32768.0)/100);

    H_temp = (float32)(P/1013.25);
    H_alt = (float32)((1-pow(H_temp,0.190284)) * 145366.45);
    Altitude = ((float32)(0.3048*H_alt) + Alti_bias);




    Alti_trans = (int16)(Altitude * 100);
}


















