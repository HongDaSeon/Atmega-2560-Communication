// ATMEGA_2560_TWI.h


#include "TypeDef.h"

#define  CPU_freq          16000000
#define  SCL_freq          100000
#define  four_powered_TWPS 1          //4^TWPS
// Command
#define RESETCommand      0x1E
#define Conver_D1_2048    0x46
#define Conver_D2_2048    0x56
#define Command_ADC_READ     0x00
#define Command_PROM_READ   0xA0
// Conversion Time
#define OSR_4096     10
#define OSR_2048    5

Uint16 PROM_read(Uint8 PROM_Command);
void TWI_write(Uint8 Command);
void TWI_init(void);
void TWI_Make_thispoint_into_zero(void);
void TWI_read_command(Uint8 command, int Conver_TIME);
void MS5611(void);

Uint32 TWI_read_read(Uint8 command, int Conver_TIME);
