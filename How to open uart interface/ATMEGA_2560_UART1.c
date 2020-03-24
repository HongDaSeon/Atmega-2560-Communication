#include <mega2560.h>
#include "GlobalVariables.h"
#include "ATMEGA_2560_UART1.h"
#include <math.h>
#include <stdlib.h>

Uint8 rx_data1[RX_QTT1] ;
Uint16 rx_store1[RX_QTT1];  //16bit rx storage
Uint32 rx_32store1[RX_QTT1];  //32bit rx storage
Uint8 rx_storage1[RX_QTT1];
Uint8 tx_data1[TX_QTT1];
Uint16 tx_store1[TX_QTT1];
/*
float32 Drone_Alti;
float32 Drone_Angle[6];
float32 First_Drone_Angle[6];
float32 Second_Drone_NED[6];
*/
//Uint16 Alti_trans;
int8 ForCount;
float32 Drone_NED[6];
float32 First_Drone_NED[6];
float32 Drone_Lati;
float32 Drone_Longi;
float32 Ground_speed=0;
Uint32 GPS_Time;
Uint8 rx_flag1 = 0;          // RX Packet Complete Flag ,0(Not Yet) or 1(Complete)
Uint8 rx_count1  = 0;          // RX Packet Counting Value,From 0 to Packet Length
int tx_count1;
float32 GPS_Heading;
 float32 Control_Roll_CMD;
 float32 Control_Pitch_CMD;
 Uint8 PRN[10];
 Uint8 rx_forbipass1[RX_QTT1];


void init_UART1(void) // UART1 is being initialized +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{
    //UCSR1A = 0x02 ;  //0000 0010 // Asynchronous, Full Duplex mode
    UCSR1A = 0x00 ;  //0000 0000 // Asynchronous, Half Duplex mode
    UCSR1B = 0x98 ;  //1001 1000 // RX ISR Enable, Rx/Tx enable, 8 data
    UCSR1C = 0x06 ;  //0000 0110 // no parity, 1 stop, 8 data

  // 57600 bps = 34 (Full Duplex) 115200 = 16
  // 57600 bps = 16 (HALF Duplex) 115200 = 8
    UBRR1L = 8;
    UBRR1H = 0;
}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void substitute_DSP(void)
{
    int16 T_AX = 0;
    int16 T_AY = 0;
    int16 T_AZ = 0;
    int16 T_Phi = 0;
    int16 T_Theta = 0;
    int16 T_Psi = 0;
    int16 T_TH = 0;
    Uint8 T_XPG = 0;
    Uint8 T_XdotPG = 0;
    Uint8 T_XdotIG = 0;
    Uint8 T_XdotDG = 0;
    Uint8 T_YPG = 0;
    Uint8 T_YdotPG = 0;
    Uint8 T_YdotIG = 0;
    Uint8 T_YdotDG = 0;
    Uint32 T_Lati_CMD = 0;
    Uint32 T_Longi_CMD = 0;
    Uint16 T_SUM = 0;
    Uint16 subofsub[TX_QTT1];
    Uint32 T_LATI_CMD = 0;
    Uint32 T_LONGI_CMD = 0;


    T_AX = ((int16)(Second_Drone_NED[0]*1000))&0xFFFF;
    T_AY = ((int16)(Second_Drone_NED[1]*1000))&0xFFFF;
    T_AZ = ((int16)(Second_Drone_NED[2]*1000))&0xFFFF;
    T_Phi = ((int16)(Drone_Angle[0]*1000))&0xFFFF;
    T_Theta = ((int16)(Drone_Angle[1]*1000))&0xFFFF;
    T_Psi = ((int16)(Drone_Angle[2]*1000))&0xFFFF;
    T_TH = ((int16)(TRUE_heading*1000))&0xFFFF;
    //T_XPG = ((Uint8)(X_P_gain*10))&0xFF;
    //T_XIG = ((Uint16)(X_I_gain*1000))&0xFFFF;
    //T_XDG = ((Uint16)(X_D_gain*100000))&0xFFFF;
    //T_YPG = ((Uint8)(Y_P_gain*10))&0xFF;
    //T_YIG = ((Uint16)(Y_I_gain*1000))&0xFFFF;
    //T_YDG = ((Uint16)(Y_D_gain*100000))&0xFFFF;
    //T_X_c = ((Uint16)(GCS_get_Y*10))&0xFFFF;
    //T_Y_c = ((Uint16)(GCS_get_X*10))&0xFFFF;



    tx_data1[0] = 0x5B;
    //FIGHT DATA
    tx_data1[1] = (Uint8)((T_AX >> 8)&0x00FF);
    tx_data1[2] = (Uint8)((T_AX)&0x00FF);
    tx_data1[3] = (Uint8)((T_AY >> 8)&0x00FF);
    tx_data1[4] = (Uint8)((T_AY)&0x00FF);
    tx_data1[5] = (Uint8)((T_AZ >> 8)&0x00FF);
    tx_data1[6] = (Uint8)((T_AZ)&0x00FF);
    tx_data1[7] = (Uint8)((T_Phi >> 8)&0x00FF);
    tx_data1[8] = (Uint8)((T_Phi)&0x00FF);
    tx_data1[9] = (Uint8)((T_Theta >> 8)&0x00FF);
    tx_data1[10] = (Uint8)((T_Theta)&0x00FF);
    tx_data1[11] = (Uint8)((T_Psi >> 8)&0x00FF);
    tx_data1[12] = (Uint8)((T_Psi)&0x00FF);
    tx_data1[13] = (Uint8)((Alti_trans >> 8)&0x00FF);
    tx_data1[14] = (Uint8)((Alti_trans)&0x00FF);
    tx_data1[15] = (Uint8)((T_TH >> 8)&0x00FF);
    tx_data1[16] = (Uint8)((T_TH)&0x00FF);
///////////////BIPASS/////////////////
    //GAIN
    tx_data1[17] = (Uint8)rx_forbipass2[5];
    tx_data1[18] = (Uint8)rx_forbipass2[6];
    tx_data1[19] = (Uint8)rx_forbipass2[7];
    tx_data1[20] = (Uint8)rx_forbipass2[8];
    tx_data1[21] = (Uint8)rx_forbipass2[9];
    tx_data1[22] = (Uint8)rx_forbipass2[10];
    tx_data1[23] = (Uint8)rx_forbipass2[11];
    tx_data1[24] = (Uint8)rx_forbipass2[12];
    //LATI LONGI CMD
    tx_data1[25] = (Uint8)rx_forbipass2[13];
    tx_data1[26] = (Uint8)rx_forbipass2[14];
    tx_data1[27] = (Uint8)rx_forbipass2[15];
    tx_data1[28] = (Uint8)rx_forbipass2[16];
    tx_data1[29] = (Uint8)rx_forbipass2[17];
    tx_data1[30] = (Uint8)rx_forbipass2[18];
    tx_data1[31] = (Uint8)rx_forbipass2[19];
    tx_data1[32] = (Uint8)rx_forbipass2[20];
///////////////////////////////////////
    /*
    tx_data1[0] = 0x5B;
    tx_data1[1] = (Uint8)((T_AX >> 8)&0x00FF);
    tx_data1[2] = (Uint8)((T_AX)&0x00FF);
    tx_data1[3] = (Uint8)((T_AY >> 8)&0x00FF);
    tx_data1[4] = (Uint8)((T_AY)&0x00FF);
    tx_data1[5] = (Uint8)((T_AZ >> 8)&0x00FF);
    tx_data1[6] = (Uint8)((T_AZ)&0x00FF);
    tx_data1[7] = (Uint8)((T_Phi >> 8)&0x00FF);
    tx_data1[8] = (Uint8)((T_Phi)&0x00FF);
    tx_data1[9] = (Uint8)((T_Theta >> 8)&0x00FF);
    tx_data1[10] = (Uint8)((T_Theta)&0x00FF);
    tx_data1[11] = (Uint8)((T_Psi >> 8)&0x00FF);
    tx_data1[12] = (Uint8)((T_Psi)&0x00FF);
    tx_data1[13] = (Uint8)((Alti_trans >> 8)&0x00FF);
    tx_data1[14] = (Uint8)((Alti_trans)&0x00FF);
    tx_data1[15] = (Uint8)((T_TH >> 8)&0x00FF);
    tx_data1[16] = (Uint8)((T_TH)&0x00FF);
///////////////BIPASS/////////////////
    //GAIN
    tx_data1[17] = (Uint8)230;
    tx_data1[18] = (Uint8)456;
    tx_data1[19] = (Uint8)212;
    tx_data1[20] = (Uint8)123;
    tx_data1[21] = (Uint8)674;
    tx_data1[22] = (Uint8)234;
    tx_data1[23] = (Uint8)345;
    tx_data1[24] = (Uint8)212;
    //LATI LONGI CMD
    tx_data1[25] = (Uint8)0x02;
    tx_data1[26] = (Uint8)0x43;
    tx_data1[27] = (Uint8)0x0A;
    tx_data1[28] = (Uint8)0x60;
    tx_data1[29] = (Uint8)0x07;
    tx_data1[30] = (Uint8)0x97;
    tx_data1[31] = (Uint8)0xF8;
    tx_data1[32] = (Uint8)0x40;
     */

    for(ForCount = 1;ForCount <= TX_QTT1-4;ForCount++)
    {
        subofsub[ForCount] = tx_data1[ForCount];
    }

    for(ForCount=1;ForCount<=TX_QTT1-4;ForCount++)
    {
        T_SUM = T_SUM + subofsub[ForCount];
    }

    tx_data1[33] = (Uint8)((T_SUM >> 8)&0x00FF);
    tx_data1[34] = (Uint8)((T_SUM)&0x00FF);
    tx_data1[35] = 0xA3;
}

void Get_DSP_value(void)
{
//substitute for 2byte+++++++++++++++++++++++++++++++
    for(ForCount = 1; ForCount<=4;ForCount++)
    {
        rx_store1[ForCount]=rx_storage1[ForCount];
    }
//+++++++++++++++++++++++++++++++++++++++++++++
//substitute for 2byte+++++++++++++++++++++++++++++++
    for(ForCount = 5; ForCount<=18;ForCount++)
    {
        rx_store1[ForCount]=rx_storage1[ForCount];
    }
//+++++++++++++++++++++++++++++++++++++++++++++
//substitute for 4byte++++++++++time+++++++++++++++
    for(ForCount = 5; ForCount<=8;ForCount++)
    {
        rx_32store1[ForCount]=rx_storage1[ForCount];
    }

//substitute for 4byte++++++latilongi+++++++++++++++++++
    for(ForCount = 13; ForCount<=20;ForCount++)
    {
        rx_32store1[ForCount]=rx_storage1[ForCount];
    }

//++++++++++++++++++++++++++++++++++++++++++++++

    //Kalman_NED[0] = ((float32)((int16)(((rx_store1[13] << 8)&0xFF00) | ((rx_store1[14])&0x00FF))))/10;
    //Kalman_NED[1] = ((float32)((int16)(((rx_store1[15] << 8)&0xFF00) | ((rx_store1[16])&0x00FF))))/10;
    //Kalman_NED[2] = ((float32)((int16)(((rx_store1[17] << 8)&0xFF00) | ((rx_store1[18])&0x00FF))))/10;
    //Kalman_NEU_V[0] = ((float32)((int16)(((rx_store1[19] << 8)&0xFF00) | ((rx_store1[20])&0x00FF))))/100;
    Control_Roll_CMD = ((float32)((int16)(((rx_store1[9] << 8)&0xFF00) | ((rx_store1[10])&0x00FF))))/1000;
    Control_Pitch_CMD = ((float32)((int16)(((rx_store1[11] << 8)&0xFF00) | ((rx_store1[12])&0x00FF))))/1000;
    Drone_NED[0] = ((float32)((int16)(((rx_store1[1] << 8)&0xFF00) | ((rx_store1[2])&0x00FF))))/10;
    Drone_NED[1] = ((float32)((int16)(((rx_store1[3] << 8)&0xFF00) | ((rx_store1[4])&0x00FF))))/10;
    //Drone_NED[2] = ((float32)((int16)(((rx_store1[17] << 8)&0xFF00) | ((rx_store1[18])&0x00FF))))/10;
    //First_Drone_NED[0] = ((float32)((int16)(((rx_store1[13] << 8)&0xFF00) | ((rx_store1[14])&0x00FF))))/100;
    //First_Drone_NED[1] = ((float32)((int16)(((rx_store1[15] << 8)&0xFF00) | ((rx_store1[16])&0x00FF))))/100;
    //First_Drone_NED[2] = ((float32)((int16)(((rx_store1[17] << 8)&0xFF00) | ((rx_store1[18])&0x00FF))))/100;
    Ground_speed = ((float32)((int8)(rx_store1[19])))/10;

    Drone_Lati = ((float32)((int32)(((rx_32store1[13] << 24)&0xFF000000) |
                                    ((rx_32store1[14] << 16)&0x00FF0000)|
                                    ((rx_32store1[15] << 8)&0x0000FF00)|
                                    ((rx_32store1[16])&0x000000FF))))/1000000;
    Drone_Longi = ((float32)((int32)(((rx_32store1[17] << 24)&0xFF000000) |
                                    ((rx_32store1[18] << 16)&0x00FF0000)|
                                    ((rx_32store1[19] << 8)&0x0000FF00)|
                                    ((rx_32store1[20])&0x000000FF))))/1000000;
    GPS_Time = (((rx_32store1[5] << 24)&0xFF000000) |
                            ((rx_32store1[6] << 16)&0x00FF0000)|
                            ((rx_32store1[7] << 8)&0x0000FF00)|
                            ((rx_32store1[8])&0x000000FF));

    PRN[0] = rx_storage1[21];
    PRN[1] = rx_storage1[22];
    PRN[2] = rx_storage1[23];
    PRN[3] = rx_storage1[24];
    PRN[4] = rx_storage1[25];
    PRN[5] = rx_storage1[26];
    PRN[6] = rx_storage1[27];
    PRN[7] = rx_storage1[28];
    PRN[8] = rx_storage1[29];
    PRN[9] = rx_storage1[30];
   // GPS_Heading = ((float32)((Uint16)(( ((rx_32store1[23] << 8)&0xFF00)|((rx_32store1[24])&0x00FF)))))/10;
}

Uint16 Make_SUM_happen(void) //Make SUM ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{
    int SumCount = 0;
    Uint16 CalcSUM_DSP = 0;

    for(SumCount = 1;SumCount <= RX_QTT1 - 4;SumCount++)
    {
        rx_store1[SumCount] = rx_storage1[SumCount];
    }
    for(SumCount = 1;SumCount <= RX_QTT1 - 4;SumCount++)
    {
        CalcSUM_DSP = CalcSUM_DSP + rx_store1[SumCount];
    }
    return CalcSUM_DSP;
}

Uint16 SUMtoUint16(void) //Converse the data to readable SUM value +++++++++++++++++++++++++++++++++++++++++++++
{
    Uint16  WholeSUM = 0;
    rx_store1[RX_QTT1 - 3] = rx_storage1[RX_QTT1 - 3];
    rx_store1[RX_QTT1 - 2] = rx_storage1[RX_QTT1 - 2];
    WholeSUM = (Uint16)((rx_store1[RX_QTT1 - 3] << 8)&0xFF00 | (rx_store1[RX_QTT1 - 2])&0x00FF);

    return WholeSUM;
}

void TX1_char(Uint8 data)  // UART1 Sending 1 Byte +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{
  while((UCSR1A & 0x20) == 0x00);
  UDR1 = data;
}

void ThistoDSP(void) //Transmmit to DSP++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{

    // Sending TX Buffer +++++++++++++++++++++++++++++++++++++++
    for(tx_count1=0;tx_count1<TX_QTT1;tx_count1++)
    {
        TX1_char(tx_data1[tx_count1]);
    }
}

interrupt [USART1_RXC] void RX1_INT(void) // RX Complete Interrupt ++++++++++++++++++++++++++++++++++++++++++++++++++
{
    rx_data1[rx_count1] = UDR1; // Substitute UDR1 Value
    rx_count1++;               // RX Buffer Count

    if( rx_count1 == RX_QTT1 )
    {
        rx_count1 = 0;         // RX Count Initialization
        rx_flag1 = 1;    // RX Packet Complet Flag
    }
}

