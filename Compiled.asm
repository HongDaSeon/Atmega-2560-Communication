; Do not put this on your board. I cannot garantee what happens next

	#pragma AVRPART ADMIN PART_NAME ATmega2560
	#pragma AVRPART MEMORY PROG_FLASH 262144
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 8703
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x200

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU RAMPZ=0x3B
	.EQU EIND=0x3C
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x74
	.EQU XMCRB=0x75
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0200
	.EQU __SRAM_END=0x21FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _tx_count=R4
	.DEF _delay_err=R7
	.DEF _control_flag=R6
	.DEF _altcontrol_flag=R9
	.DEF _lat_log_c_flag=R8
	.DEF _rx1_error_count=R10
	.DEF _altcontrol_count=R13
	.DEF _control_count=R12

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _RX0_INT
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer5_comp
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _RX2_INT
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x60003:
	.DB  0x0,0x0,0xC8,0x42
_0x60004:
	.DB  0x0,0x0,0x80,0x3F,0x0,0x0,0x80,0x3F
	.DB  0x0,0x0,0x0,0x0
_0x6000F:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x06
	.DW  _0x6000F*2

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRA,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

	OUT  EIND,R24

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x600

	.CSEG
;#include <mega2560.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <mega2560_bit.h>
;#include "GlobalVariables.h"
;#include "ATMEGA_2560_Timer1_PWM.h"
;
;// Timer1(PWM) Register �ʱ�ȭ
;
;void init_PWM1(float init_msec_A , float init_msec_B , float init_msec_C, float init_msec_D)
; 0000 0009 {

	.CSEG
_init_PWM1:
; 0000 000A    Uint16 digit = 0;
; 0000 000B 
; 0000 000C     OC1A_OUT;          // OC1A Output Setting
	CALL __PUTPARD2
	ST   -Y,R17
	ST   -Y,R16
;	init_msec_A -> Y+14
;	init_msec_B -> Y+10
;	init_msec_C -> Y+6
;	init_msec_D -> Y+2
;	digit -> R16,R17
	__GETWRN 16,17,0
	SBI  0x4,5
; 0000 000D     OC1B_OUT;          // OC1B Output Setting
	SBI  0x4,6
; 0000 000E     OC3A_OUT;          // OC3A Output Setting
	SBI  0xD,3
; 0000 000F     OC3B_OUT;          // OC3B Output Setting
	SBI  0xD,4
; 0000 0010 
; 0000 0011     // Timer/Counter 1 initialization
; 0000 0012     // Clock source: System Clock (16MHz)
; 0000 0013     // Prescaler 64
; 0000 0014     // Clock value: 500hz
; 0000 0015     // Mode: Fast PWM(mode 14 : WGM 1110)
; 0000 0016     // TOP=499=0x01F3 , BOTTOM=0x00
; 0000 0017     // ( Approximately 9 bit Resolution : 1digit = 0.004msec )
; 0000 0018     // OC1A,B,C output: Non-Inv.
; 0000 0019     // Noise Canceler: Off
; 0000 001A     // Input Capture on Falling Edge
; 0000 001B 
; 0000 001C     TCCR1A=0xA2; //  1010 00 10
	LDI  R30,LOW(162)
	STS  128,R30
; 0000 001D     TCCR1B=0x1B; //  0 0 0 11 011
	LDI  R30,LOW(27)
	STS  129,R30
; 0000 001E     TCCR1C=0x00; //  0000 0000
	LDI  R30,LOW(0)
	STS  130,R30
; 0000 001F     TCCR3A=0xAA; //  1010 10 10
	LDI  R30,LOW(170)
	STS  144,R30
; 0000 0020     TCCR3B=0x1B; //  0 0 0 11 011
	LDI  R30,LOW(27)
	STS  145,R30
; 0000 0021     TCCR3C=0x00; //  0000 0000
	LDI  R30,LOW(0)
	STS  146,R30
; 0000 0022 
; 0000 0023     TCNT1H=0x00;
	STS  133,R30
; 0000 0024     TCNT1L=0x00; // TCNT1 = 0
	STS  132,R30
; 0000 0025     TCNT3H=0x00;
	STS  149,R30
; 0000 0026     TCNT3L=0x00; // TCNT1 = 0
	STS  148,R30
; 0000 0027 
; 0000 0028     // TOP = 0x01F3 = 499
; 0000 0029     // 16,000,000 / ((1+499)*64) = 500 --> PWM Freq.
; 0000 002A     ICR1H=0x01;
	LDI  R30,LOW(1)
	STS  135,R30
; 0000 002B     ICR1L=0xF3;
	LDI  R30,LOW(243)
	STS  134,R30
; 0000 002C     ICR3H=0x01;
	LDI  R30,LOW(1)
	STS  151,R30
; 0000 002D     ICR3L=0xF3;
	LDI  R30,LOW(243)
	STS  150,R30
; 0000 002E 
; 0000 002F 
; 0000 0030     digit = (Uint16)(init_msec_A*msec2digit);
	RJMP _0x20A0001
; 0000 0031     OCR1AH = (digit>>8)&0xff;
; 0000 0032     OCR1AL = digit&0xff;
; 0000 0033     digit = (Uint16)(init_msec_B*msec2digit);
; 0000 0034     OCR1BH = (digit>>8)&0xff;
; 0000 0035     OCR1BL = digit&0xff;
; 0000 0036     digit = (Uint16)(init_msec_C*msec2digit);
; 0000 0037     OCR3AH = (digit>>8)&0xff;
; 0000 0038     OCR3AL = digit&0xff;
; 0000 0039     digit = (Uint16)(init_msec_D*msec2digit);
; 0000 003A     OCR3BH = (digit>>8)&0xff;
; 0000 003B     OCR3BL = digit&0xff;
; 0000 003C     }
;
;
;// Setting Duty[msec] Value
;void Set_PWM1(float msec_A ,float msec_B ,float msec_C, float msec_D)
; 0000 0041 {
_Set_PWM1:
; 0000 0042     Uint16 digit = 0;
; 0000 0043     digit = (Uint16)(msec_A*msec2digit);
	CALL __PUTPARD2
	ST   -Y,R17
	ST   -Y,R16
;	msec_A -> Y+14
;	msec_B -> Y+10
;	msec_C -> Y+6
;	msec_D -> Y+2
;	digit -> R16,R17
	__GETWRN 16,17,0
_0x20A0001:
	__GETD2S 14
	__GETD1N 0x43798000
	CALL __MULF12
	CALL __CFD1U
	MOVW R16,R30
; 0000 0044     OCR1AH = (digit>>8)&0xff;
	STS  137,R17
; 0000 0045     OCR1AL = digit&0xff;
	MOV  R30,R16
	STS  136,R30
; 0000 0046     digit = (Uint16)(msec_B*msec2digit);
	__GETD2S 10
	__GETD1N 0x43798000
	CALL __MULF12
	CALL __CFD1U
	MOVW R16,R30
; 0000 0047     OCR1BH = (digit>>8)&0xff;
	STS  139,R17
; 0000 0048     OCR1BL = digit&0xff;
	MOV  R30,R16
	STS  138,R30
; 0000 0049     digit = (Uint16)(msec_C*msec2digit);
	__GETD2S 6
	__GETD1N 0x43798000
	CALL __MULF12
	CALL __CFD1U
	MOVW R16,R30
; 0000 004A     OCR3AH = (digit>>8)&0xff;
	STS  153,R17
; 0000 004B     OCR3AL = digit&0xff;
	MOV  R30,R16
	STS  152,R30
; 0000 004C     digit = (Uint16)(msec_D*msec2digit);
	__GETD2S 2
	__GETD1N 0x43798000
	CALL __MULF12
	CALL __CFD1U
	MOVW R16,R30
; 0000 004D     OCR3BH = (digit>>8)&0xff;
	STS  155,R17
; 0000 004E     OCR3BL = digit&0xff;
	MOV  R30,R16
	STS  154,R30
; 0000 004F }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,18
	RET
;#include <mega2560.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <mega2560_bit.h>
;#include "ATMEGA_2560_Timer5.h"
;#include "ATMEGA_2560_Timer1_PWM.h"
;#include "ATMEGA_2560_ADC.h"
;#include "GlobalVariables.h"
;#include "ATMEGA_2560_UART3.h"
;#include <stdio.h>
;#include <delay.h>
;
;Uint8 timer5_flag = 0; // Timer/Count5 Complete Flat
;
;void init_Timer5(void)
; 0001 000E {

	.CSEG
_init_Timer5:
; 0001 000F 
; 0001 0010      //  Timer interrupt5A comp setting
; 0001 0011      //  Clear OCR5A on Compare Match
; 0001 0012      //  Mode 2 : WGM02:00 ( 010 ) CTC Mode
; 0001 0013      //  fosc / (( 1+TOP )*Scaler) = fd
; 0001 0014      //  16,000,000 / ((1+2499)*64) =  100Hz (10msec)
; 0001 0015      //  N =1024 , OCRnA =2499
; 0001 0016      //  Timer Compare A Interrupt Enable
; 0001 0017 
; 0001 0018     TIMSK5  = 0x02; //  0000 0010
	LDI  R30,LOW(2)
	STS  115,R30
; 0001 0019     TCCR5A  = 0x80; // 1000 0000
	LDI  R30,LOW(128)
	STS  288,R30
; 0001 001A     TCCR5B  = 0x0B; // 0000 1011
	LDI  R30,LOW(11)
	STS  289,R30
; 0001 001B     TCCR5C  = 0x00;
	LDI  R30,LOW(0)
	STS  290,R30
; 0001 001C     TCNT5H  = 0x00;
	STS  293,R30
; 0001 001D     TCNT5L  = 0x00; //initial value
	STS  292,R30
; 0001 001E     OCR5AH  = 0x09;
	LDI  R30,LOW(9)
	STS  297,R30
; 0001 001F     OCR5AL  = 0xC3; //comparing value
	LDI  R30,LOW(195)
	STS  296,R30
; 0001 0020 
; 0001 0021     //09C3 for 100Hz 1387 for 50Hz
; 0001 0022 
; 0001 0023     DDRC&= 0xDF;
	CBI  0x7,5
; 0001 0024 
; 0001 0025 }
	RET
;
;// Timer5 CTC Interrupt ( Period : 10msec )
;interrupt [TIM5_COMPA] void timer5_comp(void)
; 0001 0029 {
_timer5_comp:
	ST   -Y,R30
; 0001 002A     timer5_flag = 1;
	LDI  R30,LOW(1)
	STS  _timer5_flag,R30
; 0001 002B 
; 0001 002C 
; 0001 002D }
	LD   R30,Y+
	RETI
;#include <mega2560.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include "GlobalVariables.h"
;#include "ATMEGA_2560_UART.h"
;
;Uint8 rx_data[RX_QTT0];     // Ender
;Uint8 tx_data[TX_QTT0];
;Uint8 rx_flag = 0;          // RX Packet Complete Flag ,0(Not Yet) or 1(Complete)
;Uint8 rx_count  = 0;          // RX Packet Counting Value,From 0 to Packet Length
;Uint8 AorMan = 0;
;int16 tx_count;
;
;
;void init_UART(void) //��Ÿ �̴Ͻ� ++�ο͹ڰ� �����ֽ� �ʸ� ����++++++++++++++++++++++++++++++++++++++++++++++
; 0002 000E {

	.CSEG
_init_UART:
; 0002 000F     UCSR0A = 0x02 ;  //0000 0010 // Asynchronous, Full Duplex mode ,float speed
	LDI  R30,LOW(2)
	STS  192,R30
; 0002 0010     UCSR0B = 0x98 ;  //1001 1000 // RX ISR Enable, Rx/Tx enable, 8 data
	LDI  R30,LOW(152)
	STS  193,R30
; 0002 0011     UCSR0C = 0x06 ;  //0000 0110 // no parity, 1 stop, 8 data
	LDI  R30,LOW(6)
	STS  194,R30
; 0002 0012 
; 0002 0013 
; 0002 0014     UBRR0L = 16;
	LDI  R30,LOW(16)
	STS  196,R30
; 0002 0015     UBRR0H = 0;
	LDI  R30,LOW(0)
	STS  197,R30
; 0002 0016 }
	RET
;
;void TX0_char(Uint8 data)// UART0 Sending 1 Byte (polling)++++++++++++++++++++++++++++++++++++++++++++++
; 0002 0019 {
; 0002 001A     while((UCSR0A & 0x20) == 0x00);
;	data -> Y+0
; 0002 001B     UDR0 = data;
; 0002 001C }
;
;Uint8 Make_SUM_happen_0(void) //Make SUM ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; 0002 001F {
; 0002 0020     int SumCount = 0;
; 0002 0021 }
;	SumCount -> R16,R17
;
;// Goes FCC to GCS
;void ThistoCOM(void)//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; 0002 0025 {
; 0002 0026     int SUMcount = 0;
; 0002 0027     Uint16 SUM=0;
; 0002 0028     Uint8  tx_count;
; 0002 0029     //Show time
; 0002 002A     /*
; 0002 002B     //CALCULATE SUM SORCE ++++++++++++++++++++++
; 0002 002C     for(SUMcount =1;SUMcount <TX_QTT0-4 ;SUMcount++)
; 0002 002D     {
; 0002 002E     SUM = SUM + tx_data[SUMcount];
; 0002 002F     }
; 0002 0030     */
; 0002 0031 
; 0002 0032     // Sending TX Buffer
; 0002 0033     for(tx_count=0;tx_count<TX_QTT0;tx_count++)
;	SUMcount -> R16,R17
;	SUM -> R18,R19
;	tx_count -> R21
; 0002 0034     {
; 0002 0035         TX0_char(tx_data[tx_count]);
; 0002 0036     }
; 0002 0037 }
;
;interrupt [USART0_RXC] void RX0_INT(void) // RX Complete Interrupt ++++++++++++++++++++++++++++++++++++++++++
; 0002 003A {
_RX0_INT:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0002 003B     rx_data[rx_count] = UDR0; // Copying UDR0 Value
	LDS  R26,_rx_count
	LDI  R27,0
	SUBI R26,LOW(-_rx_data)
	SBCI R27,HIGH(-_rx_data)
	LDS  R30,198
	ST   X,R30
; 0002 003C     rx_count++;               // RX Buffer Count
	LDS  R30,_rx_count
	SUBI R30,-LOW(1)
	STS  _rx_count,R30
; 0002 003D 
; 0002 003E     if( rx_count == RX_QTT0 )       // Checking Packet Length
	LDS  R26,_rx_count
	CPI  R26,LOW(0x1)
	BRNE _0x40009
; 0002 003F     {
; 0002 0040         rx_count = 0;         // RX Count Initialization '0'
	LDI  R30,LOW(0)
	STS  _rx_count,R30
; 0002 0041         rx_flag = 1;    // RX Packet Complet Flag
	LDI  R30,LOW(1)
	STS  _rx_flag,R30
; 0002 0042     }
; 0002 0043 }
_0x40009:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;#include <delay.h>
;#include <stdio.h>
;#include <math.h>
;#include "ATMEGA_2560_Timer1_PWM.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include "ATMEGA_2560_Timer5.h"
;#include "ATMEGA_2560_UART.h"
;#include "ATMEGA_2560_UART2.h"
;#include "GlobalVariables.h"
;
;
;unsigned char delay_err = 0;
;
;float dTs = 100;

	.DSEG
;//insert Attitude variables
;float Roll_c;
;float Pitch_c;
;float r_c;
;
;unsigned char control_flag=0;
;unsigned char altcontrol_flag=0;
;
;/// waypoint navigation
;
;Uint8 lat_log_c_flag = 0;
;float distance = 0;
;
;
;////////////////////////////
;int16 Alti_trans =0;
;float32 Altitude = 0;
;Uint16 rx1_error_count=0;
;Uint8 altcontrol_count=0;
;Uint8 control_count=0;
;Uint8 DSPACE_ERROR=0;
;//int8 ForCount;
;Uint16 checkka =0;
;Uint8  Trigger=0;
;Uint8  Sensor_E_Code=0b00000000; //Gyro
;Uint8 GCS_timer_count=0;
;Uint8 Count_sensor_Connection = 0;
;Uint8 Count_DSP_Connection = 0;
;Uint16 j_count = 0;
;Uint16 sensorget = 0;
;Uint16 sensorlose = 0;
;Uint16 dspget = 0;
;Uint16 dsplose = 0;
;bit Sensor_just_once_count=0;
;Uint8 button_cnt = 0; // safety switch cnt
;unsigned char On=0;
;Uint8 flag_non = 0;
;Uint8 MODE =0;
;
;Uint8 Arduino_Stat_Code = 0b00000000;
; //                                   7                        6                             5                                       4                                               3
;//1���϶� >>> |dspGOOD|haveGPScaught|GPSGOOD|MotorLocked0,MotorUnlocked1|sensorGOOD
;
;void main(void)
; 0003 003A {

	.CSEG
_main:
; 0003 003B     Uint8 Sequent_Command = 0;
; 0003 003C     bit motor_lock = 1;
; 0003 003D     bit GPS_Firstly_engaged = 0;
; 0003 003E     Uint8 time = 0;
; 0003 003F     bit GCS_turn=1;
; 0003 0040     Uint8 DSP_period_Count = 0;
; 0003 0041     Uint16 in_while_count_sensor = 0;
; 0003 0042     float GCS_get_Heading_cont=0;
; 0003 0043     float32 leftPWM = 1.0;
; 0003 0044     float32 rightPWM = 1.0;
; 0003 0045     //dTs = (1/Ts);
; 0003 0046 
; 0003 0047     Arduino_Stat_Code &= 0b11101111; //lock ���·�  ;
	SBIW R28,12
	LDI  R24,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x60004*2)
	LDI  R31,HIGH(_0x60004*2)
	CALL __INITLOCB
;	Sequent_Command -> R17
;	motor_lock -> R15.0
;	GPS_Firstly_engaged -> R15.1
;	time -> R16
;	GCS_turn -> R15.2
;	DSP_period_Count -> R19
;	in_while_count_sensor -> R20,R21
;	GCS_get_Heading_cont -> Y+8
;	leftPWM -> Y+4
;	rightPWM -> Y+0
	LDI  R30,LOW(5)
	MOV  R15,R30
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	__GETWRN 20,21,0
	LDS  R30,_Arduino_Stat_Code
	ANDI R30,0xEF
	STS  _Arduino_Stat_Code,R30
; 0003 0048     PORTC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x8,R30
; 0003 0049 
; 0003 004A     //period check init
; 0003 004B 
; 0003 004C     DDRC |= 0b01000000;
	SBI  0x7,6
; 0003 004D 
; 0003 004E 
; 0003 004F 
; 0003 0050     // PROM coefficient Read & Fill the buffer
; 0003 0051 
; 0003 0052 
; 0003 0053     //UART Initializing
; 0003 0054     init_UART();
	RCALL _init_UART
; 0003 0055     init_UART2();
	RCALL _init_UART2
; 0003 0056 
; 0003 0057 
; 0003 0058     init_Timer5();
	CALL _init_Timer5
; 0003 0059 
; 0003 005A 
; 0003 005B 
; 0003 005C     // PWM initializing
; 0003 005D     delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0003 005E     init_PWM1(1,1,1,1);
	__GETD1N 0x3F800000
	CALL __PUTPARD1
	CALL __PUTPARD1
	CALL __PUTPARD1
	__GETD2N 0x3F800000
	CALL _init_PWM1
; 0003 005F     delay_ms(4000);
	LDI  R26,LOW(4000)
	LDI  R27,HIGH(4000)
	CALL _delay_ms
; 0003 0060 
; 0003 0061 
; 0003 0062     GLOBAL_INT_EN;
	BSET 7
; 0003 0063 
; 0003 0064     while(1) //loop ����
_0x60005:
; 0003 0065     {
; 0003 0066 
; 0003 0067 
; 0003 0068         //one by one for sensor
; 0003 0069 
; 0003 006A 
; 0003 006B         if(timer5_flag == 1) // �� �������� �ֱ⿡���� Ÿ�̸� ���� (100Hz)
	LDS  R26,_timer5_flag
	CPI  R26,LOW(0x1)
	BRNE _0x60008
; 0003 006C         {
; 0003 006D 
; 0003 006E          Set_PWM1(leftPWM,rightPWM,1.0,1.0);
	__GETD1S 4
	CALL __PUTPARD1
	__GETD1S 4
	CALL __PUTPARD1
	__GETD1N 0x3F800000
	CALL __PUTPARD1
	__GETD2N 0x3F800000
	CALL _Set_PWM1
; 0003 006F 
; 0003 0070         }//Timer intterupt
; 0003 0071 
; 0003 0072 
; 0003 0073 
; 0003 0074    //communication++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; 0003 0075 
; 0003 0076    //+++++++++++++++++++++++++++++++++++++++++Wireless communication++++++++++++++++++++++++
; 0003 0077         if(rx_flag2 == 1)
_0x60008:
	LDS  R26,_rx_flag2
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x60009
; 0003 0078         {
; 0003 0079             rx_flag2 = 0;
	LDI  R30,LOW(0)
	STS  _rx_flag2,R30
; 0003 007A             //substitute_TX2_47();
; 0003 007B 
; 0003 007C 
; 0003 007D             if((rx_storage2[0] == 0x5B)&&(rx_storage2[5] == 0xA3))
	LDS  R26,_rx_storage2
	CPI  R26,LOW(0x5B)
	BRNE _0x6000B
	__GETB2MN _rx_storage2,5
	CPI  R26,LOW(0xA3)
	BREQ _0x6000C
_0x6000B:
	RJMP _0x6000A
_0x6000C:
; 0003 007E             {
; 0003 007F              leftPWM = ((float32)((Uint16)(((rx_storage2[1]<<8)&0xFF00)|((rx_storage2[2])&0x00FF))))/32768.0;
	__GETB2MN _rx_storage2,1
	LDI  R30,LOW(8)
	CALL __LSLB12
	LDI  R31,0
	ANDI R30,LOW(0xFF00)
	MOVW R26,R30
	__GETB1MN _rx_storage2,2
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x47000000
	CALL __DIVF21
	__PUTD1S 4
; 0003 0080              rightPWM = ((float32)((Uint16)(((rx_storage2[3]<<8)&0xFF00)|((rx_storage2[4])&0x00FF))))/32768.0;
	__GETB2MN _rx_storage2,3
	LDI  R30,LOW(8)
	CALL __LSLB12
	LDI  R31,0
	ANDI R30,LOW(0xFF00)
	MOVW R26,R30
	__GETB1MN _rx_storage2,4
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x47000000
	CALL __DIVF21
	CALL __PUTD1S0
; 0003 0081             }
; 0003 0082             else
	RJMP _0x6000D
_0x6000A:
; 0003 0083             {
; 0003 0084                 rx_count2 = 0;
	LDI  R30,LOW(0)
	STS  _rx_count2,R30
; 0003 0085             }
_0x6000D:
; 0003 0086 
; 0003 0087         }//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; 0003 0088 
; 0003 0089 
; 0003 008A 
; 0003 008B 
; 0003 008C       }//While
_0x60009:
	RJMP _0x60005
; 0003 008D 
; 0003 008E }//Main
_0x6000E:
	RJMP _0x6000E
;#include <mega2560.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include "GlobalVariables.h"
;#include "ATMEGA_2560_UART2.h"
;
;Uint8 rx_data2[RX_QTT2];     // Ender
;Uint8 tx_data2[TX_QTT2];
;Uint8 rx_flag2 = 0;          // RX Packet Complete Flag ,0(Not Yet) or 1(Complete)
;Uint8 rx_storage2[RX_QTT2];
;Uint16 rx_store2[RX_QTT2];
;Uint8 rx_count2  = 0;        // RX Packet Counting Value,From 0 to Packet Length
;Uint8  tx_count2;
;float32 GCS_get_Altitude;
;float32 GCS_get_Heading;
;float32 GCS_get_X;
;float32 GCS_get_Y;
;Uint8 Trigger_GCS;
;float32 X_P_gain;
;float32 X_I_gain;
;float32 X_D_gain;
;float32 Y_P_gain;
;float32 Y_I_gain;
;float32 Y_D_gain;
;Uint8 rx_forbipass2[RX_QTT2];
;
;
;void init_UART2(void) //��Ÿ �̴Ͻ� ++�ο͹ڰ� �����ֽ� �ʸ� ����++++++++++++++++++++++++++++++++++++++++++++++
; 0004 001B {

	.CSEG
_init_UART2:
; 0004 001C     //UCSR2A = 0x02 ;  //0000 0010 // Asynchronous, Full Duplex mode ,float speed
; 0004 001D     UCSR2A = 0x00 ;  //0000 0010 // Asynchronous, HALF Duplex mode ,float speed
	LDI  R30,LOW(0)
	STS  208,R30
; 0004 001E     UCSR2B = 0x98 ;  //1001 1000 // RX ISR Enable, Rx/Tx enable, 8 data
	LDI  R30,LOW(152)
	STS  209,R30
; 0004 001F     UCSR2C = 0x06 ;  //0000 0110 // no parity, 1 stop, 8 data
	LDI  R30,LOW(6)
	STS  210,R30
; 0004 0020 
; 0004 0021   // 57600 bps = 34 (Full Duplex) 115200 = 16
; 0004 0022   // 57600 bps = 16 (HALF Duplex) 115200 = 8
; 0004 0023     UBRR2L = 16;
	LDI  R30,LOW(16)
	STS  212,R30
; 0004 0024     UBRR2H = 0;
	LDI  R30,LOW(0)
	STS  213,R30
; 0004 0025 } //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	RET
;
;
;void TX2_char(Uint8 data)// UART0 Sending 1 Byte (polling)++++++++++++++++++++++++++++++++++++++++++++++
; 0004 0029 {
; 0004 002A     while((UCSR2A & 0x20) == 0x00);
;	data -> Y+0
; 0004 002B     UDR2 = data;
; 0004 002C } //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
;
;
;
;Uint8 Make_SUM_happen_2(void) //Make SUM ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; 0004 0032 {
; 0004 0033     Uint8 SumCount = 0;
; 0004 0034     Uint16 CalcSUM_PILS = 0;
; 0004 0035 
; 0004 0036 
; 0004 0037     for(SumCount = 0;SumCount < RX_QTT2 - 1;SumCount++)
;	SumCount -> R17
;	CalcSUM_PILS -> R18,R19
; 0004 0038     {
; 0004 0039         rx_store2[SumCount] = rx_storage2[SumCount];
; 0004 003A     }
; 0004 003B 
; 0004 003C     for(SumCount = 1;SumCount < RX_QTT2 - 1;SumCount++)
; 0004 003D     {
; 0004 003E         CalcSUM_PILS = CalcSUM_PILS + rx_store2[SumCount];
; 0004 003F     }
; 0004 0040 
; 0004 0041 
; 0004 0042     CalcSUM_PILS = (Uint8)CalcSUM_PILS;
; 0004 0043 
; 0004 0044     return (CalcSUM_PILS);
; 0004 0045     /*
; 0004 0046     int storeCount = 0;
; 0004 0047     int SumCount = 0;
; 0004 0048     Uint16 CalcSUM_DSP = 0;
; 0004 0049 
; 0004 004A     for(SumCount = 0;SumCount < RX_QTT3 - 2;SumCount++)
; 0004 004B     {
; 0004 004C         CalcSUM_DSP += (rx_storage3[SumCount]&0x00ff);
; 0004 004D     }
; 0004 004E 
; 0004 004F     return CalcSUM_DSP;
; 0004 0050     */
; 0004 0051 
; 0004 0052 }//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
;// Goes FCC to GCS
;void ThistoGCS(void)//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; 0004 0056 {
; 0004 0057     // Sending TX Buffer
; 0004 0058     for(tx_count2=0;tx_count2<TX_QTT2;tx_count2++)
; 0004 0059     {
; 0004 005A         TX2_char(tx_data2[tx_count2]);
; 0004 005B     }
; 0004 005C }//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
;
;interrupt [USART2_RXC] void RX2_INT(void) // RX Complete Interrupt ++++++++++++++++++++++++++++++++++++++++++
; 0004 0060 {
_RX2_INT:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0004 0061     rx_data2[rx_count2] = UDR2;     // Copying UDR0 Value
	LDS  R26,_rx_count2
	LDI  R27,0
	SUBI R26,LOW(-_rx_data2)
	SBCI R27,HIGH(-_rx_data2)
	LDS  R30,214
	ST   X,R30
; 0004 0062     rx_count2++;                    // RX Buffer Count
	LDS  R30,_rx_count2
	SUBI R30,-LOW(1)
	STS  _rx_count2,R30
; 0004 0063 
; 0004 0064     if( rx_count2 == RX_QTT2 )      // Checking Packet Length
	LDS  R26,_rx_count2
	CPI  R26,LOW(0x6)
	BRNE _0x8000F
; 0004 0065     {
; 0004 0066         rx_count2 = 0;              // RX Count Initialization '0'
	LDI  R30,LOW(0)
	STS  _rx_count2,R30
; 0004 0067         rx_flag2 = 1;               // RX Packet Complet Flag
	LDI  R30,LOW(1)
	STS  _rx_flag2,R30
; 0004 0068     }
; 0004 0069 } //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
_0x8000F:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_Arduino_Stat_Code:
	.BYTE 0x1
_timer5_flag:
	.BYTE 0x1
_rx_count:
	.BYTE 0x1
_rx_flag:
	.BYTE 0x1
_rx_data:
	.BYTE 0x1
_tx_data:
	.BYTE 0x1
_rx_count2:
	.BYTE 0x1
_rx_flag2:
	.BYTE 0x1
_rx_data2:
	.BYTE 0x6
_tx_data2:
	.BYTE 0x1
_rx_storage2:
	.BYTE 0x6
_rx_store2:
	.BYTE 0xC
_tx_count2:
	.BYTE 0x1
__seed_G104:
	.BYTE 0x4

	.CSEG

	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
