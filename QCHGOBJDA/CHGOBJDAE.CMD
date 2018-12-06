/* =================================================================== */                 /* RADD */
/*                                                                     */                 /* RADD */
/*  Kurzdokumentation :                                                */                 /* RADD */
/*                                                                     */                 /* RADD */
/*  Bereich . . . : CHGOBJDA                                           */                 /* RADD */
/*  Objekt  . . . : CHGOBJDAE                                          */                 /* RADD */
/*  Beschreibung  : Tool: CHGOBJDA   (Change object dsc. attr.  ) Eng  */                 /* RADD */
/*  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      */                 /* RADD */
/*  Datum . . . . : 26.05.2001                                         */                 /* RADD */
/*                                                                     */                 /* RADD */
/* =================================================================== */                 /* RADD */
/*                                                                     */                 /* RADD */
/*  This software is free software, you can redistribute it and/or     */                 /* RADD */
/*  modify it under the terms of the GNU General Public License (GPL)  */                 /* RADD */
/*  as published by the Free Software Foundation.                      */                 /* RADD */
/*                                                                     */                 /* RADD */
/*  See GNU General Public License for details.                        */                 /* RADD */
/*          http://www.opensource.org                                  */                 /* RADD */
/*          http://www.opensource.org/licenses/gpl-license.html        */                 /* RADD */
/*                                                                     */                 /* RADD */
/* =================================================================== */                 /* RADD */
/*  History:                                                           */                 /* RADD */
/*                                                                     */                 /* RADD */
/*  Datum       Name          Änderung                                 */                 /* RADD */
/*  ----------  ------------  ---------------------------------------  */                 /* RADD */
/*  02.02.2006  Th.Raddatz    Adopted the prompt override enhancement  */                 /* RADD */
/*                            contributed by Bill Reger. Thanks Bill!  */                 /* RADD */
/*                                                                     */                 /* RADD */
/* =================================================================== */                 /* RADD */
/* >>PRE-COMPILER<<                                                    */                 /* RADD */
/*                                                                     */                 /* RADD */
/*   >>CRTCMD<< CRTCMD       CMD(&LI/&OB) +                            */                 /* RADD */
/*                           SRCFILE(&SL/&SF) +                        */                 /* RADD */
/*                           SRCMBR(&SM);                              */                 /* RADD */
/*                                                                     */                 /* RADD */
/*   >>COMPILE<<                                                       */                 /* RADD */
/*     >>PARM<< PGM(*LIBL/CHGOBJDA);                                   */                 /* RADD */
/*     >>PARM<< HLPPNLGRP(*LIBL/CHGOBJDAPE);                           */                 /* RADD */
/*     >>PARM<< HLPID(CHGOBJDA);                                       */                 /* RADD */
/*     >>PARM<< PRDLIB(&LI);                                           */                 /* RADD */
/*     >>PARM<< PMTOVRPGM(*LIBL/CHGOBJDAPO);                           */                 /* RADD */
/*   >>END-COMPILE<<                                                   */                 /* RADD */
/*                                                                     */                 /* RADD */
/*   >>EXECUTE<<                                                       */                 /* RADD */
/*                                                                     */                 /* RADD */
/* >>END-PRE-COMPILER<<                                                */                 /* RADD */
/* =================================================================== */                 /* RADD */

             CMD        PROMPT('Change Object Description Attr')                          /* RADD */

             PARM       KWD(OBJ)                +
                        TYPE(QUAL1)             +
                        MIN(1)                  +
                        CHOICE(*NONE)           +
                        KEYPARM(*YES)           +
                        PROMPT('Object')                                                  /* RADD */

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
                        PROMPT('Object type')                                             /* RADD */

             PARM       KWD(SRCF)               +
                        TYPE(*NAME)             +
                        LEN(10)                 +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME      )         +
                          (*BLANK ' ' ))        +
                        PROMPT('Source file')                                             /* RADD */

             PARM       KWD(SRCFLIB)            +
                        TYPE(*NAME)             +
                        LEN(10)                 +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME      )         +
                          (*BLANK ' ' ))        +
                        PROMPT('Source file library')                                     /* RADD */

             PARM       KWD(SRCMBR)             +
                        TYPE(*NAME)             +
                        LEN(10)                 +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME      )         +
                          (*BLANK ' ' ))        +
                        PROMPT('Source member')                                           /* RADD */
                                                                                          /* RADD */
             PARM       KWD(SRCDATE)            +
                        TYPE(*DATE)             +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME   0000000)     +
                          (*SRCMBR 0000001))    +
                        PROMPT('Source member change date')                               /* RADD */
                                                                                          /* RADD */
             PARM       KWD(SRCTIME)            +
                        TYPE(*TIME)             +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME   000000)      +
                          (*SRCMBR 000001))     +
                        PROMPT('Source member change time')                               /* RADD */
                                                                                          /* RADD */
             PARM       KWD(OBJLVL   )          +
                        TYPE(*CHAR)             +
                        LEN( 8)                 +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME      )         +
                          (*BLANK ' ' ))        +
                        PROMPT('Object control level')                                    /* RADD */
                                                                                          /* RADD */
             PARM       KWD(LICPGM   )          +
                        TYPE(*CHAR)             +
                        LEN(13)                 +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME      )         +
                          (*BLANK ' ' ))        +
                        PROMPT('Licensed program')                                        /* RADD */
                                                                                          /* RADD */
             PARM       KWD(PTF      )          +
                        TYPE(*CHAR)             +
                        LEN( 7)                 +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME      )         +
                          (*BLANK ' ' ))        +
                        PROMPT('PTF number')                                              /* RADD */
                                                                                          /* RADD */
             PARM       KWD(APAR     )          +
                        TYPE(*CHAR)             +
                        LEN( 6)                 +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME      )         +
                          (*BLANK ' ' ))        +
                        PROMPT('APAR ID')                                                 /* RADD */

             PARM       KWD(USRDFNATR)          +
                        TYPE(*CHAR)             +
                        LEN(10)                 +
                        MIN(0)                  +
                        DFT(*SAME)              +
                        SPCVAL(                 +
                          (*SAME      )         +
                          (*BLANK ' ' ))        +
                        PROMPT('User-defined attribute')                                  /* RADD */

QUAL1:       QUAL       TYPE(*NAME)             +
                        LEN(10)                 +
                        MIN(1)
             QUAL       TYPE(*NAME)             +
                        LEN(10)                 +
                        DFT(*LIBL)              +
                        SPCVAL(                 +
                          (*LIBL )              +
                          (*CURLIB ))           +
                        PROMPT('Library')                                                 /* RADD */
                                                                                          /* RADD */
 /* ... SRCDATE keyword dependencies.   */                                                /* RADD */
             DEP        CTL(&SRCDATE *EQ 0000001)   +
                        PARM((&SRCF    *NE ' ')     +
                             (&SRCFLIB *NE ' ')     +
                             (&SRCMBR  *NE ' '))    +
                        NBRTRUE(*ALL )              +
                        MSGID(COA0001)                                                    /* RADD */

 /* ... SRCTIME keyword dependencies.   */                                                /* RADD */
             DEP        CTL(&SRCTIME *EQ 000001)    +
                        PARM((&SRCF    *NE ' ')     +
                             (&SRCFLIB *NE ' ')     +
                             (&SRCMBR  *NE ' '))    +
                        NBRTRUE(*ALL )              +
                        MSGID(COA0001)                                                    /* RADD */
                                                                                          /* RADD */
