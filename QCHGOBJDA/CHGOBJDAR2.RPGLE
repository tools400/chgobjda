     *==============================================================*                        RADDAT
     *                                                              *                        RADDAT
     *  (c) 2006, Bill Reger                                        *                        RADDAT
     *                                                              *                        RADDAT
     *  Bereich  : CHGOBJDA                                         *                        RADDAT
     *  Modul    : CHGOBJDAR2                                       *                        RADDAT
     *  Typ      : RPGLE                                            *                        RADDAT
     *  Programm : CHGOBJDAPO                                       *                        RADDAT
     *                                                              *                        RADDAT
     *  erstellt : Bill Reger                                       *                        RADDAT
     *                                                              *                        RADDAT
     *==============================================================*                        RADDAT
     *                                                              *                        RADDAT
     *  Kurzdokumentation :                                         *                        RADDAT
     *                                                              *                        RADDAT
     *  Prompt Override Programm für Befehl CHGOBJDA                *                        RADDAT
     *                                                              *                        RADDAT
     * ============================================================ *                        RADDAT
     *  History:                                                    *                        RADDAT
     *                                                              *                        RADDAT
     *  Datum       Name          Änderung                          *                        RADDAT
     *  ----------  ------------  --------------------------------- *                        RADDAT
     *  23.06.2007  Th.Raddatz    Fixed error in f_getDate() and    *                        RADDAT
     *                            f_getTime() when objd0400.srcFDatTim                       RADDAT
     *                            is empty.                         *                        RADDAT
     *                                                              *                        RADDAT
     *==============================================================*                        RADDAT
     * >>PRE-COMPILER<<                                             *                        RADDAT
     *                                                              *                        RADDAT
     *   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                  *                        RADDAT
     *                           SRCFILE(&SL/&SF) +                 *                        RADDAT
     *                           SRCMBR(&SM);                       *                        RADDAT
     *                                                              *                        RADDAT
     *   >>COMPILE<<                                                *                        RADDAT
     *     >>PARM<< TRUNCNBR(*NO);                                  *                        RADDAT
     *     >>PARM<< DBGVIEW(*LIST);                                 *                        RADDAT
     *   >>END-COMPILE<<                                            *                        RADDAT
     *                                                              *                        RADDAT
     *   >>EXECUTE<<                                                *                        RADDAT
     *                                                              *                        RADDAT
     *   >>CMD<<    CRTPGM       PGM(&LI/CHGOBJDAPO) +              *                        RADDAT
     *                           MODULE(&LI/&OB) +                  *                        RADDAT
     *                           DETAIL(*BASIC) +                   *                        RADDAT
     *                           ACTGRP(*NEW);                      *                        RADDAT
     *                                                              *                        RADDAT
     * >>END-PRE-COMPILER<<                                         *                        RADDAT
     *==============================================================*                        RADDAT
     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*MDY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )                                                           RADDAT
     H EXPROPTS(*RESDECPOS)
     H EXTBININT(*YES)
     *==============================================================*
     *                                                                                       RADDAT
     *  Referenzfelder                                                                       RADDAT
CPY  /COPY QCHGOBJDA,FDERRCODE                                                              RADDAT
CPY  /COPY QCHGOBJDA,FDMBRD0100                                                             RADDAT
CPY  /COPY QCHGOBJDA,FDOBJD0400                                                             RADDAT
     *                                                                                       RADDAT
     D cymdhms_t       DS                  qualified  based(pDummy)                           RADDAT
     D  cymd                          7A                                                      RADDAT
     D  hms                           6A                                                      RADDAT
     *                                                                                       RADDAT
     *  Konstanten                                                                           RADDAT
     D cQUOTE          C                   const('''')                                        RADDAT
     *
     *  Prototype
     D CHGOBJDAP...
     D                 PR                  EXTPGM('CHGOBJDAP')
     D  gi_Cmd                       20A   const
     D  gi_qObj                      20A   const
     D  gi_objType                   10A   const
     D  gi_String                 32767A   varying
     *
     D p_main...
     D                 PR
     D  i_Cmd                              value like(gi_Cmd      )
     D  i_qObj                             value like(gi_qObj     )
     D  i_objType                          value like(gi_objType  )
     D  i_String                                 like(gi_String   )
     *                                                                                       RADDAT
     D f_getDate...                                                                           RADDAT
     D                 PR            16A   varying                                            RADDAT
     D  i_cymdhms                          value  likeds(cymdhms_t)                           RADDAT
     *                                                                                       RADDAT
     D f_getTime...                                                                           RADDAT
     D                 PR            16A   varying                                            RADDAT
     D  i_cymdhms                          value  likeds(cymdhms_t)                           RADDAT
     *                                                                                       RADDAT
     D f_getLicPgm...                                                                         RADDAT
     D                 PR            13A   varying                                            RADDAT
     D  i_licPgm                     16A   value                                              RADDAT
     *                                                                                       RADDAT
     D f_addParameter...                                                                      RADDAT
     D                 PR                         like(gi_String  )                           RADDAT
     D  i_string                           value  like(gi_String  )                           RADDAT
     D  i_keyword                    10A   value  varying                                     RADDAT
     D  i_value                     128A   value  varying                                     RADDAT
     *
     D p_sndEscMsg...
     D                 PR
     D  i_msgID                       7A   value
     D  i_msgDta                    128A   value
     *
     D f_isApiError...
     D                 PR              N
     D  i_errCode                   272A   value
     *
     D f_newApiErrCode...
     D                 PR           272A
     D  i_monmsg                       N   value
     *
     *  Retrieve Object Description
     d qusrobjd...
     D                 PR                  extpgm('QUSROBJD')
     D  rcvVar                    32767A         options(*varsize)
     D  rcvVarLen                    10I 0 const
     D  format                        8A   const
     D  qObj                         20A   const
     D  objType                      10A   const
     D  errCode                   32767A         options(*varsize: *nopass)
     *
     *  Retrieve Member Description
     d qusrmbrd...
     D                 PR                  extpgm('QUSRMBRD')
     D  rcvVar                    32767A         options(*varsize)
     D  rcvVarLen                    10I 0 const
     D  format                        8A   const
     D  qFile                        20A   const
     D  mbr                          10A   const
     D  override                      1A   const
     D  errCode                   32767A         options(*varsize: *nopass)
     *                                                                                       RADDAT
     *  Convert Date and Time Format (QWCCVTDT) API                                          RADDAT
     D QWCCVTDT...                                                                            RADDAT
     D                 PR                  EXTPGM('QWCCVTDT')                                 RADDAT
     D  i_inFormat                   10A   const                                              RADDAT
     D  i_inVar                     256A   const options(*varsize)                            RADDAT
     D  i_outFormat                  10A   const                                              RADDAT
     D  o_outVar                    256A         options(*varsize)                            RADDAT
     D  io_errCode                32767A         options(*varsize: *nopass)                   RADDAT
     *
     *  Glaobal Constants
     D cTrue           C                   const(*on)
     D cFalse          C                   const(*off)
     *
     D cSame           C                   const('*SAME')
     D cSameDate       C                   const('0000000')
     D cSameTime       C                   const('000000')
     D cSrcMbrDate     C                   const('0000001')
     D cSrcMbrTime     C                   const('000001')
     *
     D cSrcFile        C                   const(1)
     D cSrcFDatTim     C                   const(2)
     D cObjLvl         C                   const(4)
     D cLicPgm         C                   const(5)
     D cPTF            C                   const(6)
     D cAPAR           C                   const(7)
     D cUsrDfnAtr      C                   const(9)
     *
     *==================================================================*
     *  Program entry point
     *==================================================================*
     *
     D CHGOBJDAP...
     D                 PI
     D  gi_Cmd                       20A   const
     D  gi_qObj                      20A   const
     D  gi_objType                   10A   const
     D  gi_String                 32767A   varying
     *-------------------------------------------------------------------
     *
     C                   Callp     p_main(gi_Cmd       :
     C                                    gi_qObj      :
     C                                    gi_objType   :
     C                                    gi_String    )
     *
     C                   Eval      *inlr = *on
     *
     *==================================================================*
     *  Housekeeping
     *==================================================================*
     *
    P p_main...
    P                 B
     *
     D p_main...
     D                 PI
     D  i_Cmd                              value like(gi_Cmd      )
     D  i_qObj                             value like(gi_qObj     )
     D  i_objType                          value like(gi_objType  )
     D  i_String                                 like(gi_String   )
     *
     *  API error code
     D errCode         DS                  likeds(errCode_t   ) inz                           RADDAT
     *
     *  Qualified object name
     D qObj            DS
     D  qObj_name                    10A   inz
     D  qObj_lib                     10A   inz
     *
     *  Object description OBJD0400
     D OBJD0400        DS                  likeds(objd0400_t  ) inz                           RADDAT
     *
     *  Member description MBRD0100
     D MBRD0100        DS                  likeds(mbrd0100_t  ) inz                           RADDAT
     *
     *  Declare Working Variables
     D chgObjInf       S           1024A   inz(*ALLx'00')
     D retLibNme       S             10A   inz
     *  Is the member description available?
     D isMbrDscAvl     S               N   inz(cFalse)
     *
     *  Message Description structures
     D COA0003         DS
     D  COA00031                    010A   INZ(*BLANKS)
     D  COA00032                    010A   INZ(*BLANKS)
     D  COA00033                    010A   INZ(*BLANKS)
     D COA0003#        S              8B 0 INZ(0030)
     *
     D COA0004         DS
     D  COA00041                    010A   INZ(*BLANKS)
     D  COA00042                    010A   INZ(*BLANKS)
     D  COA00043                    010A   INZ(*BLANKS)
     D COA0004#        S              8B 0 INZ(0030)
     *-------------------------------------------------------------------
     *
     *  Get the current Object Description.
     C                   Eval      errCode    = f_newApiErrCode(cTrue)
     C                   Callp     qusrobjd(OBJD0400        :
     C                                      %size(OBJD0400) :
     C                                      'OBJD0400'      :
     C                                      i_qObj          :
     C                                      i_objType       :
     C                                      errCode         )
     *
 B01 C                   If        f_isApiError(errCode)
     C                   Eval      qObj = i_qObj
     C                   Clear                   COA0004
     C                   Eval      COA00041 = qObj_name
     C                   Eval      COA00042 = qObj_lib
     C                   Eval      COA00043 = i_objType
     C                   Callp     p_sndEscMsg('COA0004': COA0004)
 E01 C                   Endif
     *
     *  Construct the POP Keyword String.
     *                                                                                       RADDAT
     C                   Eval      i_string = f_addParameter(''         :                     RADDAT
     C                                                       'SRCF'     :                     RADDAT
     C                                           %trimR(objd0400.srcFile))                    RADDAT
     C                   Eval      i_string = f_addParameter(i_string   :                     RADDAT
     C                                                       'SRCFLIB'  :                     RADDAT
     C                                           %trimR(objd0400.srcLib ))                    RADDAT
     C                   Eval      i_string = f_addParameter(i_string   :                     RADDAT
     C                                                       'SRCMBR'   :                     RADDAT
     C                                           %trimR(objd0400.srcMbr ))                    RADDAT
     C                   Eval      i_string = f_addParameter(i_string   :                     RADDAT
     C                                                       'SRCDATE'  :                     RADDAT
     C                                           f_getDate(objd0400.srcFDatTim))              RADDAT
     C                   Eval      i_string = f_addParameter(i_string   :                     RADDAT
     C                                                       'SRCTIME'  :                     RADDAT
     C                                           f_getTime(objd0400.srcFDatTim))              RADDAT
     C                   Eval      i_string = f_addParameter(i_string   :                     RADDAT
     C                                                       'OBJLVL'   :                     RADDAT
     C                                           %TrimR(objd0400.objLvl   ))                  RADDAT
     C                   Eval      i_string = f_addParameter(i_string   :                     RADDAT
     C                                                       'LICPGM'   :                     RADDAT
     C                                           f_getLicPgm(objd0400.licPgm))                RADDAT
     C                   Eval      i_string = f_addParameter(i_string   :                     RADDAT
     C                                                       'PTF'      :                     RADDAT
     C                                           %TrimR(objd0400.ptf      ))                  RADDAT
     C                   Eval      i_string = f_addParameter(i_string   :                     RADDAT
     C                                                       'APAR'     :                     RADDAT
     C                                           %TrimR(objd0400.apar     ))                  RADDAT
     C                   Eval      i_string = f_addParameter(i_string   :                     RADDAT
     C                                                       'USRDFNATR':                     RADDAT
     C                                           %TrimR(objd0400.usrDfnAtr))                  RADDAT
     *
     *
     C                   Return
     *
    P p_main...
    P                 E
     *                                                                                       RADDAT
     *==================================================================*                    RADDAT
     *  get date from cymd date                                                              RADDAT
     *==================================================================*                    RADDAT
     *                                                                                       RADDAT
    P f_getDate...                                                                           RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D f_getDate...                                                                           RADDAT
     D                 PI            16A   varying                                            RADDAT
     D  i_cymdhms                          value  likeds(cymdhms_t)                           RADDAT
     *                                                                                       RADDAT
     D rtnDate         S             16A   varying   inz                                      RADDAT
     *                                                                                       RADDAT
     D date            S               D   inz                                                RADDAT
     *-------------------------------------------------------------------                    RADDAT
     *                                                                                       RADDAT
 B01 C                   If        i_cymdhms.hms <> ''                                        RADDAT
     C                   Eval      date = %date(i_cymdhms.cymd: *CYMD0)                       RADDAT
     C                   Eval      rtnDate = %trimR(%char(date: *JOBRUN0))                    RADDAT
 X01 C                   Else                                                                 RADDAT
     C                   Eval      rtnDate = ''                                               RADDAT
 E01 C                   Endif                                                                RADDAT
     *                                                                                       RADDAT
     C                   Return    rtnDate                                                    RADDAT
     *                                                                                       RADDAT
    P f_getDate...                                                                           RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *==================================================================*                    RADDAT
     *  get time from cymd date                                                              RADDAT
     *==================================================================*                    RADDAT
     *                                                                                       RADDAT
    P f_getTime...                                                                           RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D f_getTime...                                                                           RADDAT
     D                 PI            16A   varying                                            RADDAT
     D  i_cymdhms                          value  likeds(cymdhms_t)                           RADDAT
     *                                                                                       RADDAT
     D rtnTime         S             16A   varying   inz                                      RADDAT
     *                                                                                       RADDAT
     D time            S               T   inz                                                RADDAT
     *-------------------------------------------------------------------                    RADDAT
     *                                                                                       RADDAT
 B01 C                   If        i_cymdhms.hms <> ''                                        RADDAT
     C                   Eval      time = %time(i_cymdhms.hms: *HMS0)                         RADDAT
     C                   Eval      rtnTime = %trimR(%char(time: *JOBRUN0))                    RADDAT
 X01 C                   Else                                                                 RADDAT
     C                   Eval      rtnTime = ''                                               RADDAT
 E01 C                   Endif                                                                RADDAT
     *                                                                                       RADDAT
     C                   Return    rtnTime                                                    RADDAT
     *                                                                                       RADDAT
    P f_getTime...                                                                           RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *==================================================================*                    RADDAT
     *  get/compress licensed program information                                            RADDAT
     *==================================================================*                    RADDAT
     *  Switch prompt value to '*SAME' if the license program                                RADDAT
     *  information ecceeds 13 character.                                                    RADDAT
     *  Regarding to the description of the QLICOBJD API we                                  RADDAT
     *  we can only change 13 characters of the license program                              RADDAT
     *  information, whereas IBM license programs show a
     *  16-character license program information.
     *==================================================================*                    RADDAT
     *                                                                                       RADDAT
    P f_getLicPgm...                                                                         RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D f_getLicPgm...                                                                         RADDAT
     D                 PI            13A   varying                                            RADDAT
     D  i_licPgm                     16A   value                                              RADDAT
     *                                                                                       RADDAT
     D rtnLicPgm       S             13A   varying inz                                        RADDAT
     *                                                                                       RADDAT
     D licPgm          DS                  qualified                                          RADDAT
     D  name                   1      7A                                                      RADDAT
     D  ibmLicInf              8     10A                                                      RADDAT
     D  vrm                   11     16A                                                      RADDAT
     *-------------------------------------------------------------------                    RADDAT
     *                                                                                       RADDAT
     C                   Eval      licPgm = i_licPgm                                          RADDAT
     *                                                                                       RADDAT
 B01 C                   If        licPgm.ibmLicInf = ''                                      RADDAT
     C                   Eval      rtnLicPgm = licPgm.name + licPgm.vrm                       RADDAT
 X01 C                   Else                                                                 RADDAT
     C                   Eval      rtnLicPgm = '*SAME'                                        RADDAT
 E01 C                   Endif                                                                RADDAT
     *                                                                                       RADDAT
     C                   Return    rtnLicPgm                                                  RADDAT
     *                                                                                       RADDAT
    P f_getLicPgm...                                                                         RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *==================================================================*                    RADDAT
     *  add parameter to string                                                              RADDAT
     *==================================================================*                    RADDAT
     *                                                                                       RADDAT
    P f_addParameter...                                                                      RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D f_addParameter...                                                                      RADDAT
     D                 PI                         like(gi_String  )                           RADDAT
     D  i_string                           value  like(gi_String  )                           RADDAT
     D  i_keyword                    10A   value  varying                                     RADDAT
     D  i_value                     128A   value  varying                                     RADDAT
     *                                                                                       RADDAT
     D rtnString       S                   like(gi_String  ) inz                              RADDAT
     D quote           S              1A   varying           inz                              RADDAT
     *-------------------------------------------------------------------                    RADDAT
     *                                                                                       RADDAT
     C                   Eval      rtnString = i_string                                       RADDAT
 B01 C                   If        rtnString <> ''                                            RADDAT
     C                   Eval      rtnString = rtnString + ' '                                RADDAT
 E01 C                   Endif                                                                RADDAT
     *                                                                                       RADDAT
 B01 C                   If        %scan(' ': %trimR(i_value)) > 0                            RADDAT
     C                   Eval      quote = cQuote                                             RADDAT
 X01 C                   Else                                                                 RADDAT
     C                   Eval      quote = ''                                                 RADDAT
 E01 C                   Endif                                                                RADDAT
     *                                                                                       RADDAT
     C                   Eval      rtnString = rtnString + '?<'                               RADDAT
     C                                                   + %trimR(i_keyword)                  RADDAT
     C                                                   + '('                                RADDAT
     C                                                   + quote                              RADDAT
     C                                                   + i_value                            RADDAT
     C                                                   + quote                              RADDAT
     C                                                   + ')'                                RADDAT
     *                                                                                       RADDAT
     C                   Return    rtnString                                                  RADDAT
     *                                                                                       RADDAT
    P f_addParameter...                                                                      RADDAT
    P                 E                                                                      RADDAT
     *
     *==================================================================*
     *  send escape message
     *==================================================================*
     *
    P p_sndEscMsg...
    P                 B
     *
     D p_sndEscMsg...
     D                 PI
     D  i_msgID                       7A   value
     D  i_msgDta                    128A   value
     *
     *  Declare variables
     D qMsgF           DS
     D  msgF                         10A   inz('CHGOBJDA')
     D  msgL                         10A   inz('*LIBL  ')
     D msgDtaLen       S             10I 0 inz(%size(i_msgDta))
     D msgType         S             10A   inz('*ESCAPE')
     D callStckE       S             10A   inz('*CTLBDY')
     D callStckC       S             10I 0 inz(1)
     D msgKey          S              4A   inz
     D errCode         DS                  likeds(errCode_t ) inz                             RADDAT
     *-------------------------------------------------------------------
     *
     C                   Eval      errCode    = f_newApiErrCode(cFalse)
     *
     C                   Call      'QMHSNDPM'
     C                   Parm                    i_msgID
     C                   Parm                    qMsgF
     C                   Parm                    i_msgDta
     C                   Parm                    msgDtaLen
     C                   Parm                    msgType
     C                   Parm                    callStckE
     C                   Parm                    callStckC
     C                   Parm                    msgKey
     C                   Parm                    errCode
     *
    P p_sndEscMsg...
    P                 E
     *
     *==================================================================*
     *  Is API Error?
     * -----------------------------------------------------------------
     *    cTrue  - error
     *    cFalse - no error
     *==================================================================*
     *
    P f_isApiError...
    P                 B
     *
     D f_isApiError...
     D                 PI              N
     D  i_errCode                   272A   value
     *
     *  Declare logical variable
     D o_isError       S               N   inz(cFalse)
     *
     *  Declare API error code
     D errCode         DS                  likeds(errCode_t )                                 RADDAT
     D                                     based(pErrCode   )
     *-------------------------------------------------------------------
     *
     C                   Eval      pErrCode = %addr(i_errCode)
     *
 B01 C                   If        errCode.bytAvl = 0                                         RADDAT
     C                   Eval      o_isError = cFalse
 X01 C                   Else
     C                   Eval      o_isError = cTrue
 E01 C                   Endif
     *
     C                   Return    o_isError
     *
    P f_isApiError...
    P                 E
     *
     *==================================================================*
     *  API error code data structure
     *==================================================================*
     *
    P f_newApiErrCode...
    P                 B
     *
     D f_newApiErrCode...
     D                 PI           272A
     D  i_monmsg                       N   value
     *
     *  Declare working Function
     D errCode         DS                  likeds(errCode_t ) inz                             RADDAT
     *-------------------------------------------------------------------
     *
     C                   Clear                   errCode
     *
 B01 C                   If        i_monMsg = cTrue
     C                   Eval      errCode.bytPrv = %size(errCode)                            RADDAT
 X01 C                   Else
     C                   Eval      errCode.bytPrv = 0                                         RADDAT
 E01 C                   Endif
     *
     C                   Return    errCode
     *
    P f_newApiErrCode...
    P                 E
     *
