     *==============================================================*
     *                                                              *
     *  (c) 2000, Thomas Raddatz                                    *
     *                                                              *
     *  Bereich  : CHGOBJDA                                         *
     *  Modul    : CHGOBJDAR1                                       *                        RADDAT
     *  Typ      : RPGLE                                            *
     *  Programm : CHGOBJDA                                         *
     *                                                              *
     *  erstellt : 26.05.2000  Thomas Raddatz                       *
     *                                                              *
     *==============================================================*
     *                                                              *
     *  Kurzdokumentation :                                         *
     *                                                              *
     *  Befehlsausführungsprogramm für Befehl CHGOBJDA              *                        RADDAT
     *                                                              *
     *==============================================================*
     * >>PRE-COMPILER<<                                             *
     *                                                              *
     *   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                  *                        RADDAT
     *                           SRCFILE(&SL/&SF) +                 *
     *                           SRCMBR(&SM);                       *
     *                                                              *
     *   >>COMPILE<<                                                *
     *     >>PARM<< TRUNCNBR(*NO);                                  *
     *     >>PARM<< DBGVIEW(*LIST);                                 *                        RADDAT
     *   >>END-COMPILE<<                                            *
     *                                                              *
     *   >>EXECUTE<<                                                *
     *                                                              *                        RADDAT
     *   >>CMD<<    CRTPGM       PGM(&LI/CHGOBJDA) +                *                        RADDAT
     *                           MODULE(&LI/&OB) +                  *                        RADDAT
     *                           DETAIL(*BASIC) +                   *                        RADDAT
     *                           ACTGRP(*NEW);                      *                        RADDAT
     *                                                              *
     * >>END-PRE-COMPILER<<                                         *
     *==============================================================*
     H DEBUG                                                                                  RADDAT
     H OPTION(*SRCSTMT : *NODEBUGIO)                                                          RADDAT
     H DECEDIT('0,') DATEDIT(*DMY.)                                                           RADDAT
     H DATFMT(*ISO )  TIMFMT(*ISO )                                                           RADDAT
     H EXPROPTS(*RESDECPOS)                                                                   RADDAT
     H EXTBININT(*YES)                                                                        RADDAT
     H COPYRIGHT('V1.1   - 23.06.2007 - mailto: thomas.raddatz@tools400.de')                  RADDAT
     *==============================================================*                        RADDAT
     *                                                                                       RADDAT
     *  Referenzfelder                                                                       RADDAT
CPY  /COPY QCHGOBJDA,FDERRCODE                                                              RADDAT
CPY  /COPY QCHGOBJDA,FDMBRD0100                                                             RADDAT
CPY  /COPY QCHGOBJDA,FDOBJD0400                                                             RADDAT
     *
     *  Interne Prototypen
     D CHGOBJDAR...                                                                           RADDAT
     D                 PR                  EXTPGM('CHGOBJDAR')
     D  gi_qObj                      20A                                                      RADDAT
     D  gi_objType                   10A                                                      RADDAT
     D  gi_srcFile                   10A                                                      RADDAT
     D  gi_srcLib                    10A                                                      RADDAT
     D  gi_srcMbr                    10A                                                      RADDAT
     D  gi_srcDate                    7A                                                      RADDAT
     D  gi_srcTime                    6A                                                      RADDAT
     D  gi_objLvl                     8A                                                      RADDAT
     D  gi_licPgm                    13A                                                      RADDAT
     D  gi_ptf                        7A                                                      RADDAT
     D  gi_apar                       6A                                                      RADDAT
     D  gi_usrDfnAtr                 10A                                                      RADDAT
     *
     D p_main...                                                                              RADDAT
     D                 PR                                                                     RADDAT
     D  i_qObj                             value like(gi_qObj     )                           RADDAT
     D  i_objType                          value like(gi_objType  )                           RADDAT
     D  i_srcFile                          value like(gi_srcFile  )                           RADDAT
     D  i_srcLib                           value like(gi_srcLib   )                           RADDAT
     D  i_srcMbr                           value like(gi_srcMbr   )                           RADDAT
     D  i_srcDate                          value like(gi_srcDate  )                           RADDAT
     D  i_srcTime                          value like(gi_srcTime  )                           RADDAT
     D  i_objLvl                           value like(gi_objLvl   )                           RADDAT
     D  i_licPgm                           value like(gi_licPgm   )                           RADDAT
     D  i_ptf                              value like(gi_ptf      )                           RADDAT
     D  i_apar                             value like(gi_apar     )                           RADDAT
     D  i_usrDfnAtr                        value like(gi_usrDfnAtr)                           RADDAT
     *                                                                                       RADDAT
     D f_addKeyE...
     D                 PR              N   opdesc
     D  io_chgObjInf               1024A
     D  i_key                        10I 0 value
     D  i_value                     128A   const
     D                                     options(*varsize)
     *
     D p_sndEscMsg...
     D                 PR
     D  i_msgID                       7A   value                                              RADDAT
     D  i_msgDta                    128A   value                                              RADDAT
     *
     D f_getDate...
     D                 PR             7A
     D  i_cymd                       13A   value
     *
     D f_getTime...
     D                 PR             6A
     D  i_cymd                       13A   value
     *                                                                                       RADDAT
     D f_isApiError...                                                                        RADDAT
     D                 PR              N                                                      RADDAT
     D  i_errCode                   272A   value                                              RADDAT
     *                                                                                       RADDAT
     D f_newApiErrCode...                                                                     RADDAT
     D                 PR           272A                                                      RADDAT
     D  i_monmsg                       N   value                                              RADDAT
     *
     D cee_rtvOpDesc...
     D                 PR                  extproc('CEEDOD')
     D  i_posn                       10I 0 const
     D  o_descType                   10I 0
     D  o_dataType                   10I 0
     D  o_descInf1                   10I 0
     D  o_descInf2                   10I 0
     D  o_dataLen                    10I 0
     D  o_fc                         12A   options(*omit)
     *
     *  Retrieve Object Description
     d qusrobjd...                                                                            RADDAT
     D                 PR                  extpgm('QUSROBJD')
     D  rcvVar                    32767A         options(*varsize)
     D  rcvVarLen                    10I 0 const
     D  format                        8A   const
     D  qObj                         20A   const
     D  objType                      10A   const
     D  errCode                   32767A         options(*varsize: *nopass)                   RADDAT
     *
     *  Retrieve Member Description
     d qusrmbrd...                                                                            RADDAT
     D                 PR                  extpgm('QUSRMBRD')
     D  rcvVar                    32767A         options(*varsize)
     D  rcvVarLen                    10I 0 const
     D  format                        8A   const
     D  qFile                        20A   const
     D  mbr                          10A   const
     D  override                      1A   const
     D  errCode                   32767A         options(*varsize: *nopass)                   RADDAT
     *
     *  Globale Konstanten
     D cTrue           C                   const(*on)                                         RADDAT
     D cFalse          C                   const(*off)                                        RADDAT
     *
     D cSame           C                   const('*SAME')                                     RADDAT
     D cSameDate       C                   const('0000000')                                   RADDAT
     D cSameTime       C                   const('000000')                                    RADDAT
     D cSrcMbrDate     C                   const('0000001')                                   RADDAT
     D cSrcMbrTime     C                   const('000001')                                    RADDAT
     *
     D cSrcFile        C                   const(1)                                           RADDAT
     D cSrcFDatTim     C                   const(2)                                           RADDAT
     D cObjLvl         C                   const(4)                                           RADDAT
     D cLicPgm         C                   const(5)                                           RADDAT
     D cPTF            C                   const(6)                                           RADDAT
     D cAPAR           C                   const(7)                                           RADDAT
     D cUsrDfnAtr      C                   const(9)                                           RADDAT
     *                                                                                       RADDAT
     *==================================================================*                    RADDAT
     *  Program entry point                                                                  RADDAT
     *==================================================================*                    RADDAT
     *                                                                                       RADDAT
     D CHGOBJDAR...                                                                           RADDAT
     D                 PI                                                                     RADDAT
     D  gi_qObj                      20A                                                      RADDAT
     D  gi_objType                   10A                                                      RADDAT
     D  gi_srcFile                   10A                                                      RADDAT
     D  gi_srcLib                    10A                                                      RADDAT
     D  gi_srcMbr                    10A                                                      RADDAT
     D  gi_srcDate                    7A                                                      RADDAT
     D  gi_srcTime                    6A                                                      RADDAT
     D  gi_objLvl                     8A                                                      RADDAT
     D  gi_licPgm                    13A                                                      RADDAT
     D  gi_ptf                        7A                                                      RADDAT
     D  gi_apar                       6A                                                      RADDAT
     D  gi_usrDfnAtr                 10A                                                      RADDAT
     *-------------------------------------------------------------------                    RADDAT
     *                                                                                       RADDAT
     C                   Callp     p_main(gi_qObj      :                                      RADDAT
     C                                    gi_objType   :                                      RADDAT
     C                                    gi_srcFile   :                                      RADDAT
     C                                    gi_srcLib    :                                      RADDAT
     C                                    gi_srcMbr    :                                      RADDAT
     C                                    gi_srcDate   :                                      RADDAT
     C                                    gi_srcTime   :                                      RADDAT
     C                                    gi_objLvl    :                                      RADDAT
     C                                    gi_licPgm    :                                      RADDAT
     C                                    gi_ptf       :                                      RADDAT
     C                                    gi_apar      :                                      RADDAT
     C                                    gi_usrDfnAtr )                                      RADDAT
     *                                                                                       RADDAT
     C                   Eval      *inlr = *on                                                RADDAT
     *
     *==================================================================*
     *  Haupsteurung
     *==================================================================*
     *                                                                                       RADDAT
    P p_main...                                                                              RADDAT
    P                 B                                                                      RADDAT
     *
     D p_main...
     D                 PI
     D  i_qObj                             value like(gi_qObj     )                           RADDAT
     D  i_objType                          value like(gi_objType  )                           RADDAT
     D  i_srcFile                          value like(gi_srcFile  )                           RADDAT
     D  i_srcLib                           value like(gi_srcLib   )                           RADDAT
     D  i_srcMbr                           value like(gi_srcMbr   )                           RADDAT
     D  i_srcDate                          value like(gi_srcDate  )                           RADDAT
     D  i_srcTime                          value like(gi_srcTime  )                           RADDAT
     D  i_objLvl                           value like(gi_objLvl   )                           RADDAT
     D  i_licPgm                           value like(gi_licPgm   )                           RADDAT
     D  i_ptf                              value like(gi_ptf      )                           RADDAT
     D  i_apar                             value like(gi_apar     )                           RADDAT
     D  i_usrDfnAtr                        value like(gi_usrDfnAtr)                           RADDAT
     *
     *  API error code
     D errCode         DS                  likeds(errCode_t   ) inz                           RADDAT
     *                                                                                       RADDAT
     *  Qualified object name                                                                RADDAT
     D qObj            DS                                                                     RADDAT
     D  qObj_name                    10A   inz                                                RADDAT
     D  qObj_lib                     10A   inz                                                RADDAT
     *
     *  Objektbeschreibung OBJD0400
     D OBJD0400        DS                  likeds(objd0400_t  ) inz                           RADDAT
     *
     *  Teildateibeschreibung MBRD0100
     D MBRD0100        DS                  likeds(mbrd0100_t  ) inz                           RADDAT
     *
     *  Deklarieren Arbeitsfelder
     D chgObjInf       S           1024A   inz(*ALLx'00')
     D retLibNme       S             10A   inz
     *  source file
     D srcFile         S                   like(i_srcFile  ) inz
     D srcLib          S                   like(i_srcLib   ) inz
     D srcMbr          S                   like(i_srcMbr   ) inz
     *  object level
     D objLvl          S                   like(i_objLvl   ) inz
     *  licensed program
     D licPgm          S                   like(i_licPgm   ) inz
     *  ptf
     D ptf             S                   like(i_ptf      ) inz
     *  apar
     D apar            S                   like(i_apar     ) inz
     *  source file last changed date and time
     D srcFDatTim      DS
     D  srcDate                       7A   inz
     D  srcTime                       6A   inz
     *  user defined attribute
     D usrDfnAtr       S                   like(i_usrDfnAtr) inz                              RADDAT
     *  is member description available                                                      RADDAT
     D isMbrDscAvl     S               N   inz(cFalse)                                        RADDAT
     *                                                                                       RADDAT
     *  Nachrichtendatenstrukturen                                                           RADDAT
CPY  /COPY QCHGOBJDA,COA0003                                                                RADDAT
CPY  /COPY QCHGOBJDA,COA0004                                                                RADDAT
     *-------------------------------------------------------------------
     *
 B01 C                   If        (i_srcFile   <> cSame    ) or                              RADDAT
     C                             (i_srcLib    <> cSame    ) or                              RADDAT
     C                             (i_srcMbr    <> cSame    ) or                              RADDAT
     C                             (i_srcDate   <> cSameDate) or                              RADDAT
     C                             (i_srcTime   <> cSameTime) or                              RADDAT
     C                             (i_objLvl    <> cSame    ) or                              RADDAT
     C                             (i_licPgm    <> cSame    ) or                              RADDAT
     C                             (i_ptf       <> cSame    ) or                              RADDAT
     C                             (i_apar      <> cSame    ) or                              RADDAT
     C                             (i_usrDfnAtr <> cSame    )                                 RADDAT
     *
     *  Abrufen Objektbeschreibung
     C                   Eval      errCode    = f_newApiErrCode(cTrue)                        RADDAT
     C                   Callp     qusrobjd(OBJD0400        :                                 RADDAT
     C                                      %size(OBJD0400) :                                 RADDAT
     C                                      'OBJD0400'      :                                 RADDAT
     C                                      i_qObj          :                                 RADDAT
     C                                      i_objType       :                                 RADDAT
     C                                      errCode         )                                 RADDAT
     *                                                                                       RADDAT
 B02 C                   If        f_isApiError(errCode)                                      RADDAT
     C                   Eval      qObj = i_qObj                                              RADDAT
     C                   Clear                   COA0004                                      RADDAT
     C                   Eval      COA00041 = qObj_name                                       RADDAT
     C                   Eval      COA00042 = qObj_lib                                        RADDAT
     C                   Eval      COA00043 = i_objType                                       RADDAT
     C                   Callp     p_sndEscMsg('COA0004': COA0004)                            RADDAT
 E02 C                   Endif                                                                RADDAT
     *
     *  Abgleichen neue Werte ...
     *
     *  ... srcF
 B02 C                   If        i_srcFile <> cSame                                         RADDAT
     C                   Eval      srcFile = i_srcFile
 X02 C                   Else
     C                   Eval      srcFile = objd0400.srcFile                                 RADDAT
 E02 C                   Endif
     *  ... srcL
 B02 C                   If        i_srcLib <> cSame                                          RADDAT
     C                   Eval      srcLib = i_srcLib
 X02 C                   Else
     C                   Eval      srcLib = objd0400.srcLib                                   RADDAT
 E02 C                   Endif
     *  ... srcMbr
 B02 C                   If        i_srcMbr <> cSame                                          RADDAT
     C                   Eval      srcMbr = i_srcMbr
 X02 C                   Else
     C                   Eval      srcMbr = objd0400.srcMbr                                   RADDAT
 E02 C                   Endif
     *
     *      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
 B02 C                   If        not f_addKeyE(chgObjInf: cSrcFile:                         RADDAT
     C                                           srcFile + srcLib + srcMbr)
     C                   Callp     p_sndEscMsg('COA0002': ' ')                                RADDAT
     C                   Return
 E02 C                   Endif
     *
     *  Abrufen Quellenteildateiattribute
 B02 C                   If        (i_srcDate = cSrcMbrDate ) or                              RADDAT
     C                             (i_srcTime = cSrcMbrTime )                                 RADDAT
     C                   Eval      errCode    = f_newApiErrCode(cTrue)                        RADDAT
     C                   Callp     qusrmbrd(MBRD0100         :                                RADDAT
     C                                      %size(MBRD0100)  :                                RADDAT
     C                                      'MBRD0100'       :                                RADDAT
     C                                      srcFile + srcLib :                                RADDAT
     C                                      srcMbr           :                                RADDAT
     C                                      '0'              :                                RADDAT
     C                                       errCode         )                                RADDAT
 B03 C                   If        f_isApiError(errCode)                                      RADDAT
     C                   Eval      isMbrDscAvl = cFalse                                       RADDAT
     C                   Clear                   COA0003                                      RADDAT
     C                   Eval      COA00031 = srcFile                                         RADDAT
     C                   Eval      COA00032 = srcLib                                          RADDAT
     C                   Eval      COA00033 = srcMbr                                          RADDAT
     C                   Callp     p_sndEscMsg('COA0003': COA0003)                            RADDAT
 X03 C                   Else                                                                 RADDAT
     C                   Eval      isMbrDscAvl = cTrue                                        RADDAT
 E03 C                   Endif                                                                RADDAT
 X02 C                   Else                                                                 RADDAT
     C                   Eval      isMbrDscAvl = cFalse                                       RADDAT
 E02 C                   Endif
     *
     *  ... srcDate
 B02 C                   Select
     C                   When      i_srcDate = cSameDate                                      RADDAT
     C                   Eval      srcDate = f_getDate(objd0400.srcFDatTim)                   RADDAT
     C                   When      i_srcDate = cSrcMbrDate                                    RADDAT
 B03 C                   If        isMbrDscAvl                                                RADDAT
     C                   Eval      srcDate = f_getDate(mbrd0100.chgDatTim )                   RADDAT
 E03 C                   Endif                                                                RADDAT
 X02 C                   Other
     C                   Eval      srcDate = i_srcDate
 E02 C                   Endsl
     *
     *  ... srcTime
 B02 C                   Select
     C                   When      i_srcTime = cSameTime                                      RADDAT
     C                   Eval      srcTime = f_getTime(objd0400.srcFDatTim)                   RADDAT
     C                   When      i_srcTime = cSrcMbrTime                                    RADDAT
 B03 C                   If        isMbrDscAvl                                                RADDAT
     C                   Eval      srcTime = f_getTime(mbrd0100.chgDatTim )                   RADDAT
 E03 C                   Endif                                                                RADDAT
 X02 C                   Other
     C                   Eval      srcTime = i_srcTime
 E02 C                   Endsl
     *
     *      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
 B02 C                   If        not f_addKeyE(chgObjInf: cSrcFDatTim:                      RADDAT
     C                                           srcFDatTim            )
     C                   Callp     p_sndEscMsg('COA0002': ' ')                                RADDAT
     C                   Return
 E02 C                   Endif
     *
     *  ... object level
 B02 C                   If        i_objLvl    <> cSame                                       RADDAT
     C                   Eval      objLvl    = i_objLvl
 X02 C                   Else
     C                   Eval      objLvl    = objd0400.objLvl                                RADDAT
 E02 C                   Endif
     *
     *      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
 B02 C                   If        not f_addKeyE(chgObjInf: cObjLvl   :                       RADDAT
     C                                           objLvl               )
     C                   Callp     p_sndEscMsg('COA0002': ' ')                                RADDAT
     C                   Return
 E02 C                   Endif
     *
     *  ... licensed program
 B02 C                   If        i_licPgm    <> cSame                                       RADDAT
     C                   Eval      licPgm    = i_licPgm
 X02 C                   Else
     C                   Eval      licPgm    = objd0400.licPgm                                RADDAT
 E02 C                   Endif
     *
     *      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
 B02 C                   If        not f_addKeyE(chgObjInf: cLicPgm   :                       RADDAT
     C                                           licPgm               )
     C                   Callp     p_sndEscMsg('COA0002': ' ')                                RADDAT
     C                   Return
 E02 C                   Endif
     *
     *  ... ptf
 B02 C                   If        i_ptf       <> cSame                                       RADDAT
     C                   Eval      ptf       = i_ptf
 X02 C                   Else
     C                   Eval      ptf       = objd0400.ptf                                   RADDAT
 E02 C                   Endif
     *
     *      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
 B02 C                   If        not f_addKeyE(chgObjInf: cPTF      :                       RADDAT
     C                                           ptf                  )
     C                   Callp     p_sndEscMsg('COA0002': ' ')                                RADDAT
     C                   Return
 E02 C                   Endif
     *
     *  ... apar
 B02 C                   If        i_apar      <> cSame                                       RADDAT
     C                   Eval      apar      = i_apar
 X02 C                   Else
     C                   Eval      apar      = objd0400.apar                                  RADDAT
 E02 C                   Endif
     *
     *      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
 B02 C                   If        not f_addKeyE(chgObjInf: cAPAR     :                       RADDAT
     C                                           apar                 )
     C                   Callp     p_sndEscMsg('COA0002': ' ')                                RADDAT
     C                   Return
 E02 C                   Endif
     *
     *  ... user defined attribute
 B02 C                   If        i_usrDfnAtr <> cSame                                       RADDAT
     C                   Eval      usrDfnAtr = i_usrDfnAtr                                    RADDAT
 X02 C                   Else
     C                   Eval      usrDfnAtr = objd0400.usrDfnAtr                             RADDAT
 E02 C                   Endif
     *
     *      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
 B02 C                   If        not f_addKeyE(chgObjInf: cUsrDfnAtr:                       RADDAT
     C                                           usrDfnAtr            )
     C                   Callp     p_sndEscMsg('COA0002': ' ')                                RADDAT
     C                   Return
 E02 C                   Endif
     *
     *  Ändern der Objektbeschreibung
     C                   Call      'QLICOBJD'
     C                   Parm                    retLibNme
     C                   Parm                    i_qObj
     C                   Parm                    i_objType
     C                   Parm                    chgObjInf
     C                   Parm                    errCode                                      RADDAT
 E01 C                   Endif
     *
     C                   Return
     *                                                                                       RADDAT
    P p_main...                                                                              RADDAT
    P                 E                                                                      RADDAT
     *
     *==================================================================*
     *  add Key to changed object informationen
     *==================================================================*
     *
    P f_addKeyE...
    P                 B
     *
     D f_addKeyE...
     D                 PI              N   opdesc
     D  io_chgObjInf               1024A
     D  i_key                        10I 0 value
     D  i_value                     128A   const
     D                                     options(*varsize)
     *
     *  Deklarieren Arbeitsfelder
     D  chgObjInf      S           1024A   inz
     *
     D  descType       S             10I 0 inz
     D  dataType       S             10I 0 inz
     D  descInf1       S             10I 0 inz
     D  descInf2       S             10I 0 inz
     D  currLen        S             10I 0 inz
     *
     D  pos            S             10I 0 inz
     D  nbrOfKey       S             10I 0 based(pNbrOfKey)
     D  key            S             10I 0 based(pKey     )
     D  keyLen         S             10I 0 based(pKeyLen  )
     *-------------------------------------------------------------------
     *
     C                   Callp     cee_rtvOpDesc(3       : descType:
     C                                           dataType: descInf1:
     C                                           descInf2: currLen :
     C                                           *omit             )
     *
     C                   Eval      pNbrOfKey = %addr(io_chgObjInf)
     C                   Eval      pKey      = pNbrOfKey + 4
     C                   Eval      pos       = 5
     *
     *  Suchen nach dem Ende der Objektinformationen
 B01 C     1             Do        nbrOfKey
     C                   Eval      pKeyLen = pKey + 4
     C                   Eval      pKey    = pKey + 8 + KeyLen
     C                   Eval      pos     = pos  + 8 + keyLen
 E01 C                   Enddo
     *
     *  Anfügen der neuen Informationen
 B01 C                   If        pos >= %size(io_chgObjInf) - 4 - 4 - currLen
     C                   Return    cFalse                                                     RADDAT
 X01 C                   Else
     C                   Eval      pKey     = %addr(io_chgObjInf) + pos - 1
     C                   Eval      pos      = pos + 4
     C                   Eval      pKeyLen  = %addr(io_chgObjInf) + pos - 1
     C                   Eval      pos      = pos + 4
     *
     C                   Eval      nbrOfKey = nbrOfKey + 1
     C                   Eval      key      = i_key
     C                   Eval      keyLen   = currLen
     C                   Eval      %subst(io_chgObjInf: pos: currLen) =
     C                                   %subst(i_value: 1: currLen)
     C                   Return    cTrue                                                      RADDAT
 E01 C                   Endif
     *
    P f_addKeyE...
    P                 E
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
     D  i_msgID                       7A   value                                              RADDAT
     D  i_msgDta                    128A   value                                              RADDAT
     *
     *  Deklarieren Arbeitsfelder
     D qMsgF           DS
     D  msgF                         10A   inz('CHGOBJDA')                                    RADDAT
     D  msgL                         10A   inz('*LIBL  ')
     D msgDtaLen       S             10I 0 inz(%size(i_msgDta))                               RADDAT
     D msgType         S             10A   inz('*ESCAPE')
     D callStckE       S             10A   inz('*CTLBDY')
     D callStckC       S             10I 0 inz(1)
     D msgKey          S              4A   inz
     D errCode         DS                  likeds(errCode_t ) inz                             RADDAT
     *-------------------------------------------------------------------
     *                                                                                       RADDAT
     C                   Eval      errCode    = f_newApiErrCode(cFalse)                       RADDAT
     *
     C                   Call      'QMHSNDPM'
     C                   Parm                    i_msgID                                      RADDAT
     C                   Parm                    qMsgF
     C                   Parm                    i_msgDta                                     RADDAT
     C                   Parm                    msgDtaLen
     C                   Parm                    msgType
     C                   Parm                    callStckE
     C                   Parm                    callStckC
     C                   Parm                    msgKey
     C                   Parm                    errCode                                      RADDAT
     *
    P p_sndEscMsg...
    P                 E
     *
     *==================================================================*
     *  get date from cymd date
     *==================================================================*
     *
    P f_getDate...
    P                 B
     *
     D f_getDate...
     D                 PI             7A
     D  i_cymd                       13A   value
     *-------------------------------------------------------------------
     *
     C                   Return    %subst(i_cymd: 1: 7)
     *
    P f_getDate...
    P                 E
     *
     *==================================================================*
     *  get time from cymd date
     *==================================================================*
     *
    P f_getTime...
    P                 B
     *
     D f_getTime...
     D                 PI             6A
     D  i_cymd                       13A   value
     *-------------------------------------------------------------------
     *
     C                   Return    %subst(i_cymd: 8: 6)
     *
    P f_getTime...
    P                 E
     *                                                                                       RADDAT
     *==================================================================*                    RADDAT
     *  Is API Error?                                                                        RADDAT
     * -----------------------------------------------------------------                     RADDAT
     *    cTrue  - error                                                                     RADDAT
     *    cFalse - no error                                                                  RADDAT
     *==================================================================*                    RADDAT
     *                                                                                       RADDAT
    P f_isApiError...                                                                        RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D f_isApiError...                                                                        RADDAT
     D                 PI              N                                                      RADDAT
     D  i_errCode                   272A   value                                              RADDAT
     *                                                                                       RADDAT
     *  Deklarieren Funktionswert                                                            RADDAT
     D o_isError       S               N   inz(cFalse)                                        RADDAT
     *                                                                                       RADDAT
     *  Deklarieren API Fehlercode                                                           RADDAT
     D errCode         DS                  likeds(errCode_t )                                 RADDAT
     D                                     based(pErrCode   )                                 RADDAT
     *-------------------------------------------------------------------                    RADDAT
     *                                                                                       RADDAT
     C                   Eval      pErrCode = %addr(i_errCode)                                RADDAT
     *                                                                                       RADDAT
 B01 C                   If        errCode.bytAvl = 0                                         RADDAT
     C                   Eval      o_isError = cFalse                                         RADDAT
 X01 C                   Else                                                                 RADDAT
     C                   Eval      o_isError = cTrue                                          RADDAT
 E01 C                   Endif                                                                RADDAT
     *                                                                                       RADDAT
     C                   Return    o_isError                                                  RADDAT
     *                                                                                       RADDAT
    P f_isApiError...                                                                        RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *==================================================================*                    RADDAT
     *  Erstellen leere API error code Datenstruktur                                         RADDAT
     *==================================================================*                    RADDAT
     *                                                                                       RADDAT
    P f_newApiErrCode...                                                                     RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D f_newApiErrCode...                                                                     RADDAT
     D                 PI           272A                                                      RADDAT
     D  i_monmsg                       N   value                                              RADDAT
     *                                                                                       RADDAT
     *  Deklarieren Funktionswert                                                            RADDAT
     D errCode         DS                  likeds(errCode_t ) inz                             RADDAT
     *-------------------------------------------------------------------                    RADDAT
     *                                                                                       RADDAT
     C                   Clear                   errCode                                      RADDAT
     *                                                                                       RADDAT
 B01 C                   If        i_monMsg = cTrue                                           RADDAT
     C                   Eval      errCode.bytPrv = %size(errCode)                            RADDAT
 X01 C                   Else                                                                 RADDAT
     C                   Eval      errCode.bytPrv = 0                                         RADDAT
 E01 C                   Endif                                                                RADDAT
     *                                                                                       RADDAT
     C                   Return    errCode                                                    RADDAT
     *                                                                                       RADDAT
    P f_newApiErrCode...                                                                     RADDAT
    P                 E                                                                      RADDAT
     *
