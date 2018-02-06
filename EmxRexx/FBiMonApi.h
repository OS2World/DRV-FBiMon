/* FBiMonApi.h */
#ifndef FBIMONAPIH
#define FBIMONAPIH

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define INCL_BASE
#define INCL_DOSDEVIOCTL
#define INCL_REXXSAA
#include <os2.h>

/* Text Attributes constants */
#define Att_Nothing         0x00
#define Att_Underline       0x01
#define Att_Normal          0x07
#define Att_Inversed        0x70
#define Att_HighIntensity   0x08
#define Att_Blink           0x80

#define SetPixelCmd         0x0A
#define HoriLineCmd         0x0C
#define VertLineCmd         0x0D
#define ScreenModeCmd       0x01
#define ScreenAttributeCmd  0x02
#define SetCursorAspectCmd  0x04
#define ScreenPositionCmd   0x09
#define PrintCmd            0x07


typedef struct {
   USHORT Command;
   char Md;
} ScreenMode;

typedef struct {
   USHORT Command;
   char Att;
} ScreenAttribute;

typedef struct {
   USHORT Command;
   USHORT spx,spy;
} ScreenPosition;

typedef struct {
   USHORT Command;
   USHORT Length;
   char Msg[512];
} ScreenPrintIn;

typedef struct {
   USHORT Command;
   char first;
   char second;
   char options;
} SetCursorAspect;


int  FBiMonInit();
void FBiMonClose();

void FBiMonSetMode(int mode);
void FBiMonSetPos(int x,int y);
void FBiMonWriteString(char *buffer,int x,int y);
void FBiMonWriteTTY(char *buffer);
void FBiMonAttribute(char att);
void FBiMonSetCursorAspect(char first,char second,char options);

#endif
