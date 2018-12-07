      *==============================================================*
      *                                                              *
      *  (c) 2006, Bill Reger                                        *
      *                                                              *
      *  Bereich  : CHGOBJDA                                         *
      *  Modul    : CHGOBJDAR2                                       *
      *  Typ      : RPGLE                                            *
      *  Programm : CHGOBJDAPO                                       *
      *                                                              *
      *  erstellt : Bill Reger                                       *
      *                                                              *
      *==============================================================*
      *                                                              *
      *  Kurzdokumentation :                                         *
      *                                                              *
      *  Prompt Override Programm für Befehl CHGOBJDA                *
      *                                                              *
      * ============================================================ *
      *  History:                                                    *
      *                                                              *
      *  Datum       Name          Änderung                          *
      *  ----------  ------------  --------------------------------- *
      *  23.06.2007  Th.Raddatz    Fixed error in f_getDate() and    *
      *                            f_getTime() when objd0400.srcFDatTim
      *                            is empty.                         *
      *                                                              *
      *==============================================================*
      * >>PRE-COMPILER<<                                             *
      *                                                              *
      *   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                  *
      *                           SRCFILE(&SL/&SF) +                 *
      *                           SRCMBR(&SM);                       *
      *                                                              *
      *   >>COMPILE<<                                                *
      *     >>PARM<< TRUNCNBR(*NO);                                  *
      *     >>PARM<< DBGVIEW(*LIST);                                 *
      *   >>END-COMPILE<<                                            *
      *                                                              *
      *   >>EXECUTE<<                                                *
      *                                                              *
      *   >>CMD<<    CRTPGM       PGM(&LI/CHGOBJDAPO) +              *
      *                           MODULE(&LI/&OB) +                  *
      *                           DETAIL(*BASIC) +                   *
      *                           ACTGRP(*NEW);                      *
      *                                                              *
      * >>END-PRE-COMPILER<<                                         *
      *==============================================================*
     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*MDY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
     H EXTBININT(*YES)
      /COPY QCHGOBJDA,COPYRIGHT
      *==============================================================*
      *
      *  Referenzfelder
      /COPY QCHGOBJDA,FDERRCODE
      /COPY QCHGOBJDA,FDMBRD0100
      /COPY QCHGOBJDA,FDOBJD0400
      *
     D cymdhms_t       DS                  qualified  based(pDummy)
     D  cymd                          7A
     D  hms                           6A
      *
      *  Konstanten
     D cQUOTE          C                   const('''')
      *
      *  Prototype
     D CHGOBJDAP...
     D                 PR                  EXTPGM('CHGOBJDAP')
     D  gi_Cmd                       20A   const
     D  gi_qObj                      20A   const
     D  gi_objType                   10A   const
     D  gi_String                 32767A   varying
      *
     D p_main...
     D                 PR
     D  i_Cmd                              value like(gi_Cmd      )
     D  i_qObj                             value like(gi_qObj     )
     D  i_objType                          value like(gi_objType  )
     D  i_String                                 like(gi_String   )
      *
     D f_getDate...
     D                 PR            16A   varying
     D  i_cymdhms                          value  likeds(cymdhms_t)
      *
     D f_getTime...
     D                 PR            16A   varying
     D  i_cymdhms                          value  likeds(cymdhms_t)
      *
     D f_getLicPgm...
     D                 PR            13A   varying
     D  i_licPgm                     16A   value
      *
     D f_addParameter...
     D                 PR                         like(gi_String  )
     D  i_string                           value  like(gi_String  )
     D  i_keyword                    10A   value  varying
     D  i_value                     128A   value  varying
      *
     D p_sndEscMsg...
     D                 PR
     D  i_msgID                       7A   value
     D  i_msgDta                    128A   value
      *
     D f_isApiError...
     D                 PR              N
     D  i_errCode                   272A   value
      *
     D f_newApiErrCode...
     D                 PR           272A
     D  i_monmsg                       N   value
      *
      *  Retrieve Object Description
     d qusrobjd...
     D                 PR                  extpgm('QUSROBJD')
     D  rcvVar                    32767A         options(*varsize)
     D  rcvVarLen                    10I 0 const
     D  format                        8A   const
     D  qObj                         20A   const
     D  objType                      10A   const
     D  errCode                   32767A         options(*varsize: *nopass)
      *
      *  Retrieve Member Description
     d qusrmbrd...
     D                 PR                  extpgm('QUSRMBRD')
     D  rcvVar                    32767A         options(*varsize)
     D  rcvVarLen                    10I 0 const
     D  format                        8A   const
     D  qFile                        20A   const
     D  mbr                          10A   const
     D  override                      1A   const
     D  errCode                   32767A         options(*varsize: *nopass)
      *
      *  Convert Date and Time Format (QWCCVTDT) API
     D QWCCVTDT...
     D                 PR                  EXTPGM('QWCCVTDT')
     D  i_inFormat                   10A   const
     D  i_inVar                     256A   const options(*varsize)
     D  i_outFormat                  10A   const
     D  o_outVar                    256A         options(*varsize)
     D  io_errCode                32767A         options(*varsize: *nopass)
      *
      *  Glaobal Constants
     D cTrue           C                   const(*on)
     D cFalse          C                   const(*off)
      *
     D cSame           C                   const('*SAME')
     D cSameDate       C                   const('0000000')
     D cSameTime       C                   const('000000')
     D cSrcMbrDate     C                   const('0000001')
     D cSrcMbrTime     C                   const('000001')
      *
     D cSrcFile        C                   const(1)
     D cSrcFDatTim     C                   const(2)
     D cObjLvl         C                   const(4)
     D cLicPgm         C                   const(5)
     D cPTF            C                   const(6)
     D cAPAR           C                   const(7)
     D cUsrDfnAtr      C                   const(9)
      *
      *==================================================================*
      *  Program entry point
      *==================================================================*
      *
     D CHGOBJDAP...
     D                 PI
     D  gi_Cmd                       20A   const
     D  gi_qObj                      20A   const
     D  gi_objType                   10A   const
     D  gi_String                 32767A   varying
      *-------------------------------------------------------------------
      *
     C                   Callp     p_main(gi_Cmd       :
     C                                    gi_qObj      :
     C                                    gi_objType   :
     C                                    gi_String    )
      *
     C                   Eval      *inlr = *on
      *
      *==================================================================*
      *  Housekeeping
      *==================================================================*
      *
     P p_main...
     P                 B
      *
     D p_main...
     D                 PI
     D  i_Cmd                              value like(gi_Cmd      )
     D  i_qObj                             value like(gi_qObj     )
     D  i_objType                          value like(gi_objType  )
     D  i_String                                 like(gi_String   )
      *
      *  API error code
     D errCode         DS                  likeds(errCode_t   ) inz
      *
      *  Qualified object name
     D qObj            DS
     D  qObj_name                    10A   inz
     D  qObj_lib                     10A   inz
      *
      *  Object description OBJD0400
     D OBJD0400        DS                  likeds(objd0400_t  ) inz
      *
      *  Member description MBRD0100
     D MBRD0100        DS                  likeds(mbrd0100_t  ) inz
      *
      *  Declare Working Variables
     D chgObjInf       S           1024A   inz(*ALLx'00')
     D retLibNme       S             10A   inz
      *  Is the member description available?
     D isMbrDscAvl     S               N   inz(cFalse)
      *
      *  Message Description structures
     D COA0003         DS
     D  COA00031                    010A   INZ(*BLANKS)
     D  COA00032                    010A   INZ(*BLANKS)
     D  COA00033                    010A   INZ(*BLANKS)
     D COA0003#        S              8B 0 INZ(0030)
      *
     D COA0004         DS
     D  COA00041                    010A   INZ(*BLANKS)
     D  COA00042                    010A   INZ(*BLANKS)
     D  COA00043                    010A   INZ(*BLANKS)
     D COA0004#        S              8B 0 INZ(0030)
      *-------------------------------------------------------------------
      *
      *  Get the current Object Description.
     C                   Eval      errCode    = f_newApiErrCode(cTrue)
     C                   Callp     qusrobjd(OBJD0400        :
     C                                      %size(OBJD0400) :
     C                                      'OBJD0400'      :
     C                                      i_qObj          :
     C                                      i_objType       :
     C                                      errCode         )
      *
     C                   If        f_isApiError(errCode)
     C                   Eval      qObj = i_qObj
     C                   Clear                   COA0004
     C                   Eval      COA00041 = qObj_name
     C                   Eval      COA00042 = qObj_lib
     C                   Eval      COA00043 = i_objType
     C                   Callp     p_sndEscMsg('COA0004': COA0004)
     C                   Endif
      *
      *  Construct the POP Keyword String.
      *
     C                   Eval      i_string = f_addParameter(''         :
     C                                                       'SRCF'     :
     C                                           %trimR(objd0400.srcFile))
     C                   Eval      i_string = f_addParameter(i_string   :
     C                                                       'SRCFLIB'  :
     C                                           %trimR(objd0400.srcLib ))
     C                   Eval      i_string = f_addParameter(i_string   :
     C                                                       'SRCMBR'   :
     C                                           %trimR(objd0400.srcMbr ))
     C                   Eval      i_string = f_addParameter(i_string   :
     C                                                       'SRCDATE'  :
     C                                           f_getDate(objd0400.srcFDatTim))
     C                   Eval      i_string = f_addParameter(i_string   :
     C                                                       'SRCTIME'  :
     C                                           f_getTime(objd0400.srcFDatTim))
     C                   Eval      i_string = f_addParameter(i_string   :
     C                                                       'OBJLVL'   :
     C                                           %TrimR(objd0400.objLvl   ))
     C                   Eval      i_string = f_addParameter(i_string   :
     C                                                       'LICPGM'   :
     C                                           f_getLicPgm(objd0400.licPgm))
     C                   Eval      i_string = f_addParameter(i_string   :
     C                                                       'PTF'      :
     C                                           %TrimR(objd0400.ptf      ))
     C                   Eval      i_string = f_addParameter(i_string   :
     C                                                       'APAR'     :
     C                                           %TrimR(objd0400.apar     ))
     C                   Eval      i_string = f_addParameter(i_string   :
     C                                                       'USRDFNATR':
     C                                           %TrimR(objd0400.usrDfnAtr))
      *
      *
     C                   Return
      *
     P p_main...
     P                 E
      *
      *==================================================================*
      *  get date from cymd date
      *==================================================================*
      *
     P f_getDate...
     P                 B
      *
     D f_getDate...
     D                 PI            16A   varying
     D  i_cymdhms                          value  likeds(cymdhms_t)
      *
     D rtnDate         S             16A   varying   inz
      *
     D date            S               D   inz
      *-------------------------------------------------------------------
      *
     C                   If        i_cymdhms.hms <> ''
     C                   Eval      date = %date(i_cymdhms.cymd: *CYMD0)
     C                   Eval      rtnDate = %trimR(%char(date: *JOBRUN0))
     C                   Else
     C                   Eval      rtnDate = ''
     C                   Endif
      *
     C                   Return    rtnDate
      *
     P f_getDate...
     P                 E
      *
      *==================================================================*
      *  get time from cymd date
      *==================================================================*
      *
     P f_getTime...
     P                 B
      *
     D f_getTime...
     D                 PI            16A   varying
     D  i_cymdhms                          value  likeds(cymdhms_t)
      *
     D rtnTime         S             16A   varying   inz
      *
     D time            S               T   inz
      *-------------------------------------------------------------------
      *
     C                   If        i_cymdhms.hms <> ''
     C                   Eval      time = %time(i_cymdhms.hms: *HMS0)
     C                   Eval      rtnTime = %trimR(%char(time: *JOBRUN0))
     C                   Else
     C                   Eval      rtnTime = ''
     C                   Endif
      *
     C                   Return    rtnTime
      *
     P f_getTime...
     P                 E
      *
      *==================================================================*
      *  get/compress licensed program information
      *==================================================================*
      *  Switch prompt value to '*SAME' if the license program
      *  information ecceeds 13 character.
      *  Regarding to the description of the QLICOBJD API we
      *  we can only change 13 characters of the license program
      *  information, whereas IBM license programs show a
      *  16-character license program information.
      *==================================================================*
      *
     P f_getLicPgm...
     P                 B
      *
     D f_getLicPgm...
     D                 PI            13A   varying
     D  i_licPgm                     16A   value
      *
     D rtnLicPgm       S             13A   varying inz
      *
     D licPgm          DS                  qualified
     D  name                   1      7A
     D  ibmLicInf              8     10A
     D  vrm                   11     16A
      *-------------------------------------------------------------------
      *
     C                   Eval      licPgm = i_licPgm
      *
     C                   If        licPgm.ibmLicInf = ''
     C                   Eval      rtnLicPgm = licPgm.name + licPgm.vrm
     C                   Else
     C                   Eval      rtnLicPgm = '*SAME'
     C                   Endif
      *
     C                   Return    rtnLicPgm
      *
     P f_getLicPgm...
     P                 E
      *
      *==================================================================*
      *  add parameter to string
      *==================================================================*
      *
     P f_addParameter...
     P                 B
      *
     D f_addParameter...
     D                 PI                         like(gi_String  )
     D  i_string                           value  like(gi_String  )
     D  i_keyword                    10A   value  varying
     D  i_value                     128A   value  varying
      *
     D rtnString       S                   like(gi_String  ) inz
     D quote           S              1A   varying           inz
      *-------------------------------------------------------------------
      *
     C                   Eval      rtnString = i_string
     C                   If        rtnString <> ''
     C                   Eval      rtnString = rtnString + ' '
     C                   Endif
      *
     C                   If        %scan(' ': %trimR(i_value)) > 0
     C                   Eval      quote = cQuote
     C                   Else
     C                   Eval      quote = ''
     C                   Endif
      *
     C                   Eval      rtnString = rtnString + '?<'
     C                                                   + %trimR(i_keyword)
     C                                                   + '('
     C                                                   + quote
     C                                                   + i_value
     C                                                   + quote
     C                                                   + ')'
      *
     C                   Return    rtnString
      *
     P f_addParameter...
     P                 E
      *
      *==================================================================*
      *  send escape message
      *==================================================================*
      *
     P p_sndEscMsg...
     P                 B
      *
     D p_sndEscMsg...
     D                 PI
     D  i_msgID                       7A   value
     D  i_msgDta                    128A   value
      *
      *  Declare variables
     D qMsgF           DS
     D  msgF                         10A   inz('CHGOBJDA')
     D  msgL                         10A   inz('*LIBL  ')
     D msgDtaLen       S             10I 0 inz(%size(i_msgDta))
     D msgType         S             10A   inz('*ESCAPE')
     D callStckE       S             10A   inz('*CTLBDY')
     D callStckC       S             10I 0 inz(1)
     D msgKey          S              4A   inz
     D errCode         DS                  likeds(errCode_t ) inz
      *-------------------------------------------------------------------
      *
     C                   Eval      errCode    = f_newApiErrCode(cFalse)
      *
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
      *
     P p_sndEscMsg...
     P                 E
      *
      *==================================================================*
      *  Is API Error?
      * -----------------------------------------------------------------
      *    cTrue  - error
      *    cFalse - no error
      *==================================================================*
      *
     P f_isApiError...
     P                 B
      *
     D f_isApiError...
     D                 PI              N
     D  i_errCode                   272A   value
      *
      *  Declare logical variable
     D o_isError       S               N   inz(cFalse)
      *
      *  Declare API error code
     D errCode         DS                  likeds(errCode_t )
     D                                     based(pErrCode   )
      *-------------------------------------------------------------------
      *
     C                   Eval      pErrCode = %addr(i_errCode)
      *
     C                   If        errCode.bytAvl = 0
     C                   Eval      o_isError = cFalse
     C                   Else
     C                   Eval      o_isError = cTrue
     C                   Endif
      *
     C                   Return    o_isError
      *
     P f_isApiError...
     P                 E
      *
      *==================================================================*
      *  API error code data structure
      *==================================================================*
      *
     P f_newApiErrCode...
     P                 B
      *
     D f_newApiErrCode...
     D                 PI           272A
     D  i_monmsg                       N   value
      *
      *  Declare working Function
     D errCode         DS                  likeds(errCode_t ) inz
      *-------------------------------------------------------------------
      *
     C                   Clear                   errCode
      *
     C                   If        i_monMsg = cTrue
     C                   Eval      errCode.bytPrv = %size(errCode)
     C                   Else
     C                   Eval      errCode.bytPrv = 0
     C                   Endif
      *
     C                   Return    errCode
      *
     P f_newApiErrCode...
     P                 E
      *
