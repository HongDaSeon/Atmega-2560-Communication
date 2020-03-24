// ATMEGA_2560_UART1.h

#include "TypeDef.h"

void TX1_char(Uint8 data);
void ThistoDSP(void);
void init_UART1(void);
void substitute_DSP(void);
Uint16 Make_SUM_happen(void);
Uint16 SUMtoUint16(void);
void Get_DSP_value(void);


//int16 PorN16(Uint16 victim);
//int32 PorN32(Uint32 victim);