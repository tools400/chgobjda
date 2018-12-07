/* =================================================================== */
/*                                                                     */
/*  Kurzdokumentation :                                                */
/*                                                                     */
/*  Bereich . . . : CHGOBJDA                                           */
/*  Objekt  . . . : CHGOBJDAE                                          */
/*  Beschreibung  : Tool: CHGOBJDA   (Change object dsc. attr.  ) Eng  */
/*  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      */
/*  Datum . . . . : 26.05.2001                                         */
/*                                                                     */
/* =================================================================== */
/*                                                                     */
/*  This software is free software, you can redistribute it and/or     */
/*  modify it under the terms of the GNU General Public License (GPL)  */
/*  as published by the Free Software Foundation.                      */
/*                                                                     */
/*  See GNU General Public License for details.                        */
/*          http://www.opensource.org                                  */
/*          http://www.opensource.org/licenses/gpl-license.html        */
/*                                                                     */
/* =================================================================== */
/*  History:                                                           */
/*                                                                     */
/*  Datum       Name          Änderung                                 */
/*  ----------  ------------  ---------------------------------------  */
/*  02.02.2006  Th.Raddatz    Adopted the prompt override enhancement  */
/*                            contributed by Bill Reger. Thanks Bill!  */
/*                                                                     */
/* =================================================================== */
/* >>PRE-COMPILER<<                                                    */
/*                                                                     */
/*   >>CRTCMD<< CRTCMD       CMD(&LI/&OB) +                            */
/*                           SRCFILE(&SL/&SF) +                        */
/*                           SRCMBR(&SM);                              */
/*                                                                     */
/*   >>COMPILE<<                                                       */
/*     >>PARM<< PGM(*LIBL/CHGOBJDA);                                   */
/*     >>PARM<< HLPPNLGRP(*LIBL/CHGOBJDAPE);                           */
/*     >>PARM<< HLPID(CHGOBJDA);                                       */
/*     >>PARM<< PRDLIB(&LI);                                           */
/*     >>PARM<< PMTOVRPGM(*LIBL/CHGOBJDAPO);                           */
/*   >>END-COMPILE<<                                                   */
/*                                                                     */
/*   >>EXECUTE<<                                                       */
/*                                                                     */
/* >>END-PRE-COMPILER<<                                                */
/* =================================================================== */

             CMD        PROMPT('Change Object Description Attr')

             PARM       KWD(OBJ)                +
                        TYPE(QUAL1)             +
                        MIN(1)                  +
                        CHOICE(*NONE)           +
                        KEYPARM(*YES)           +
                        PROMPT('Object')

             PARM       KWD(OBJTYPE)            +
                        TYPE(*CHAR)             +
                        LEN(10)                 +
                        MIN(1)                  +
                        RSTD(*YES)              +
                        VALUES(                 +
                          '*ALRTBL'             +
                          '*AUTL'               +
                          '*BNDDIR'             +
                          '*CFGL'               +
                          '*CHTFMT'             +
                          '*CLD'                +
                          '*CLS'                +
                          '*CMD'                +
                          '*CNNL'               +
                          '*COSD'               +
                          '*CSI'                +
                          '*CSPMAP'             +
                          '*CSPTBL'             +
                          '*CTLD'               +
                          '*DEVD'               +
                          '*DTAARA'             +
                          '*DTADCT'             +
                          '*DTAQ'               +
                          '*EDTD'               +
                          '*FCT'                +
                          '*FILE'               +
                          '*FLR'                +
                          '*FNTRSC'             +
                          '*FORMDF'             +
                          '*FTR'                +
                          '*GSS'                +
                          '*JOBD'               +
                          '*JOBQ'               +
                          '*JOBSCD'             +
                          '*JRN'                +
                          '*JRNRCV'             +
                          '*LIB'                +
                          '*LIND'               +
                          '*MENU'               +
                          '*MODD'               +
                          '*MODULE'             +
                          '*MSGF'               +
                          '*MSGQ'               +
                          '*NODL'               +
                          '*NWID'               +
                          '*OUTQ'               +
                          '*OVL'                +
                          '*PAGDFN'             +
                          '*PAGSEQ'             +
                          '*PDG'                +
                          '*PGM'                +
                          '*PNLGRP'             +
                          '*PRDDFN'             +
                          '*PRDLOD'             +
                          '*QMFORM'             +
                          '*QMQRY'              +
                          '*QRYDFN'             +
                          '*RCT'                +
                          '*SBSD'               +
                          '*SCHIDX'             +
                          '*SPADCT'             +
                          '*SQLPKG'             +
                          '*SRC'                +
                          '*SRVPGM'             +
                          '*SSND'               +
                          '*S36'                +
                          '*TBL'                +
                          '*USRIDX'             +
                          '*USRPRF'             +
                          '*USRQ'               +
                          '*USRSPC'             +
                          '*WSCST')             +
                        KEYPARM(*YES)           +
                        PROMPT('Object type')

             PARM       KWD(SRCF)               +
                        TYPE(*NAME)             +
                        LEN(10)                 +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME      )         +
                          (*BLANK ' ' ))        +
                        PROMPT('Source file')

             PARM       KWD(SRCFLIB)            +
                        TYPE(*NAME)             +
                        LEN(10)                 +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME      )         +
                          (*BLANK ' ' ))        +
                        PROMPT('Source file library')

             PARM       KWD(SRCMBR)             +
                        TYPE(*NAME)             +
                        LEN(10)                 +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME      )         +
                          (*BLANK ' ' ))        +
                        PROMPT('Source member')

             PARM       KWD(SRCDATE)            +
                        TYPE(*DATE)             +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME   0000000)     +
                          (*SRCMBR 0000001))    +
                        PROMPT('Source member change date')

             PARM       KWD(SRCTIME)            +
                        TYPE(*TIME)             +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME   000000)      +
                          (*SRCMBR 000001))     +
                        PROMPT('Source member change time')

             PARM       KWD(OBJLVL   )          +
                        TYPE(*CHAR)             +
                        LEN( 8)                 +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME      )         +
                          (*BLANK ' ' ))        +
                        PROMPT('Object control level')

             PARM       KWD(LICPGM   )          +
                        TYPE(*CHAR)             +
                        LEN(13)                 +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME      )         +
                          (*BLANK ' ' ))        +
                        PROMPT('Licensed program')

             PARM       KWD(PTF      )          +
                        TYPE(*CHAR)             +
                        LEN( 7)                 +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME      )         +
                          (*BLANK ' ' ))        +
                        PROMPT('PTF number')

             PARM       KWD(APAR     )          +
                        TYPE(*CHAR)             +
                        LEN( 6)                 +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME      )         +
                          (*BLANK ' ' ))        +
                        PROMPT('APAR ID')

             PARM       KWD(USRDFNATR)          +
                        TYPE(*CHAR)             +
                        LEN(10)                 +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME      )         +
                          (*BLANK ' ' ))        +
                        PROMPT('User-defined attribute')

QUAL1:       QUAL       TYPE(*NAME)             +
                        LEN(10)                 +
                        MIN(1)
             QUAL       TYPE(*NAME)             +
                        LEN(10)                 +
                        DFT(*LIBL)              +
                        SPCVAL(                 +
                          (*LIBL )              +
                          (*CURLIB ))           +
                        PROMPT('Library')

 /* ... SRCDATE keyword dependencies.   */
             DEP        CTL(&SRCDATE *EQ 0000001)   +
                        PARM((&SRCF    *NE ' ')     +
                             (&SRCFLIB *NE ' ')     +
                             (&SRCMBR  *NE ' '))    +
                        NBRTRUE(*ALL )              +
                        MSGID(COA0001)

 /* ... SRCTIME keyword dependencies.   */
             DEP        CTL(&SRCTIME *EQ 000001)    +
                        PARM((&SRCF    *NE ' ')     +
                             (&SRCFLIB *NE ' ')     +
                             (&SRCMBR  *NE ' '))    +
                        NBRTRUE(*ALL )              +
                        MSGID(COA0001)

