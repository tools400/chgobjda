      *==============================================================*
      *                                                              *
      *  (c) 2000, Thomas Raddatz                                    *
      *                                                              *
      *  Bereich  : CHGOBJDA                                         *
      *  Modul    : CHGOBJDAR1                                       *
      *  Typ      : RPGLE                                            *
      *  Programm : CHGOBJDA                                         *
      *                                                              *
      *  erstellt : 26.05.2000  Thomas Raddatz                       *
      *                                                              *
      *==============================================================*
      *                                                              *
      *  Kurzdokumentation :                                         *
      *                                                              *
      *  Befehlsausführungsprogramm für Befehl CHGOBJDA              *
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
      *   >>CMD<<    CRTPGM       PGM(&LI/CHGOBJDA) +                *
      *                           MODULE(&LI/&OB) +                  *
      *                           DETAIL(*BASIC) +                   *
      *                           ACTGRP(*NEW);                      *
      *                                                              *
      * >>END-PRE-COMPILER<<                                         *
      *==============================================================*
     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
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
      *  Interne Prototypen
     D CHGOBJDAR...
     D                 PR                  EXTPGM('CHGOBJDAR')
     D  gi_qObj                      20A
     D  gi_objType                   10A
     D  gi_srcFile                   10A
     D  gi_srcLib                    10A
     D  gi_srcMbr                    10A
     D  gi_srcDate                    7A
     D  gi_srcTime                    6A
     D  gi_objLvl                     8A
     D  gi_licPgm                    13A
     D  gi_ptf                        7A
     D  gi_apar                       6A
     D  gi_usrDfnAtr                 10A
      *
     D p_main...
     D                 PR
     D  i_qObj                             value like(gi_qObj     )
     D  i_objType                          value like(gi_objType  )
     D  i_srcFile                          value like(gi_srcFile  )
     D  i_srcLib                           value like(gi_srcLib   )
     D  i_srcMbr                           value like(gi_srcMbr   )
     D  i_srcDate                          value like(gi_srcDate  )
     D  i_srcTime                          value like(gi_srcTime  )
     D  i_objLvl                           value like(gi_objLvl   )
     D  i_licPgm                           value like(gi_licPgm   )
     D  i_ptf                              value like(gi_ptf      )
     D  i_apar                             value like(gi_apar     )
     D  i_usrDfnAtr                        value like(gi_usrDfnAtr)
      *
     D f_addKeyE...
     D                 PR              N   opdesc
     D  io_chgObjInf               1024A
     D  i_key                        10I 0 value
     D  i_value                     128A   const
     D                                     options(*varsize)
      *
     D p_sndEscMsg...
     D                 PR
     D  i_msgID                       7A   value
     D  i_msgDta                    128A   value
      *
     D f_getDate...
     D                 PR             7A
     D  i_cymd                       13A   value
      *
     D f_getTime...
     D                 PR             6A
     D  i_cymd                       13A   value
      *
     D f_isApiError...
     D                 PR              N
     D  i_errCode                   272A   value
      *
     D f_newApiErrCode...
     D                 PR           272A
     D  i_monmsg                       N   value
      *
     D cee_rtvOpDesc...
     D                 PR                  extproc('CEEDOD')
     D  i_posn                       10I 0 const
     D  o_descType                   10I 0
     D  o_dataType                   10I 0
     D  o_descInf1                   10I 0
     D  o_descInf2                   10I 0
     D  o_dataLen                    10I 0
     D  o_fc                         12A   options(*omit)
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
      *  Globale Konstanten
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
     D CHGOBJDAR...
     D                 PI
     D  gi_qObj                      20A
     D  gi_objType                   10A
     D  gi_srcFile                   10A
     D  gi_srcLib                    10A
     D  gi_srcMbr                    10A
     D  gi_srcDate                    7A
     D  gi_srcTime                    6A
     D  gi_objLvl                     8A
     D  gi_licPgm                    13A
     D  gi_ptf                        7A
     D  gi_apar                       6A
     D  gi_usrDfnAtr                 10A
      *-------------------------------------------------------------------
      *
     C                   Callp     p_main(gi_qObj      :
     C                                    gi_objType   :
     C                                    gi_srcFile   :
     C                                    gi_srcLib    :
     C                                    gi_srcMbr    :
     C                                    gi_srcDate   :
     C                                    gi_srcTime   :
     C                                    gi_objLvl    :
     C                                    gi_licPgm    :
     C                                    gi_ptf       :
     C                                    gi_apar      :
     C                                    gi_usrDfnAtr )
      *
     C                   Eval      *inlr = *on
      *
      *==================================================================*
      *  Haupsteurung
      *==================================================================*
      *
     P p_main...
     P                 B
      *
     D p_main...
     D                 PI
     D  i_qObj                             value like(gi_qObj     )
     D  i_objType                          value like(gi_objType  )
     D  i_srcFile                          value like(gi_srcFile  )
     D  i_srcLib                           value like(gi_srcLib   )
     D  i_srcMbr                           value like(gi_srcMbr   )
     D  i_srcDate                          value like(gi_srcDate  )
     D  i_srcTime                          value like(gi_srcTime  )
     D  i_objLvl                           value like(gi_objLvl   )
     D  i_licPgm                           value like(gi_licPgm   )
     D  i_ptf                              value like(gi_ptf      )
     D  i_apar                             value like(gi_apar     )
     D  i_usrDfnAtr                        value like(gi_usrDfnAtr)
      *
      *  API error code
     D errCode         DS                  likeds(errCode_t   ) inz
      *
      *  Qualified object name
     D qObj            DS
     D  qObj_name                    10A   inz
     D  qObj_lib                     10A   inz
      *
      *  Objektbeschreibung OBJD0400
     D OBJD0400        DS                  likeds(objd0400_t  ) inz
      *
      *  Teildateibeschreibung MBRD0100
     D MBRD0100        DS                  likeds(mbrd0100_t  ) inz
      *
      *  Deklarieren Arbeitsfelder
     D chgObjInf       S           1024A   inz(*ALLx'00')
     D retLibNme       S             10A   inz
      *  source file
     D srcFile         S                   like(i_srcFile  ) inz
     D srcLib          S                   like(i_srcLib   ) inz
     D srcMbr          S                   like(i_srcMbr   ) inz
      *  object level
     D objLvl          S                   like(i_objLvl   ) inz
      *  licensed program
     D licPgm          S                   like(i_licPgm   ) inz
      *  ptf
     D ptf             S                   like(i_ptf      ) inz
      *  apar
     D apar            S                   like(i_apar     ) inz
      *  source file last changed date and time
     D srcFDatTim      DS
     D  srcDate                       7A   inz
     D  srcTime                       6A   inz
      *  user defined attribute
     D usrDfnAtr       S                   like(i_usrDfnAtr) inz
      *  is member description available
     D isMbrDscAvl     S               N   inz(cFalse)
      *
      *  Nachrichtendatenstrukturen
      /COPY QCHGOBJDA,COA0003
      /COPY QCHGOBJDA,COA0004
      *-------------------------------------------------------------------
      *
     C                   If        (i_srcFile   <> cSame    ) or
     C                             (i_srcLib    <> cSame    ) or
     C                             (i_srcMbr    <> cSame    ) or
     C                             (i_srcDate   <> cSameDate) or
     C                             (i_srcTime   <> cSameTime) or
     C                             (i_objLvl    <> cSame    ) or
     C                             (i_licPgm    <> cSame    ) or
     C                             (i_ptf       <> cSame    ) or
     C                             (i_apar      <> cSame    ) or
     C                             (i_usrDfnAtr <> cSame    )
      *
      *  Abrufen Objektbeschreibung
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
      *  Abgleichen neue Werte ...
      *
      *  ... srcF
     C                   If        i_srcFile <> cSame
     C                   Eval      srcFile = i_srcFile
     C                   Else
     C                   Eval      srcFile = objd0400.srcFile
     C                   Endif
      *  ... srcL
     C                   If        i_srcLib <> cSame
     C                   Eval      srcLib = i_srcLib
     C                   Else
     C                   Eval      srcLib = objd0400.srcLib
     C                   Endif
      *  ... srcMbr
     C                   If        i_srcMbr <> cSame
     C                   Eval      srcMbr = i_srcMbr
     C                   Else
     C                   Eval      srcMbr = objd0400.srcMbr
     C                   Endif
      *
      *      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
     C                   If        not f_addKeyE(chgObjInf: cSrcFile:
     C                                           srcFile + srcLib + srcMbr)
     C                   Callp     p_sndEscMsg('COA0002': ' ')
     C                   Return
     C                   Endif
      *
      *  Abrufen Quellenteildateiattribute
     C                   If        (i_srcDate = cSrcMbrDate ) or
     C                             (i_srcTime = cSrcMbrTime )
     C                   Eval      errCode    = f_newApiErrCode(cTrue)
     C                   Callp     qusrmbrd(MBRD0100         :
     C                                      %size(MBRD0100)  :
     C                                      'MBRD0100'       :
     C                                      srcFile + srcLib :
     C                                      srcMbr           :
     C                                      '0'              :
     C                                       errCode         )
     C                   If        f_isApiError(errCode)
     C                   Eval      isMbrDscAvl = cFalse
     C                   Clear                   COA0003
     C                   Eval      COA00031 = srcFile
     C                   Eval      COA00032 = srcLib
     C                   Eval      COA00033 = srcMbr
     C                   Callp     p_sndEscMsg('COA0003': COA0003)
     C                   Else
     C                   Eval      isMbrDscAvl = cTrue
     C                   Endif
     C                   Else
     C                   Eval      isMbrDscAvl = cFalse
     C                   Endif
      *
      *  ... srcDate
     C                   Select
     C                   When      i_srcDate = cSameDate
     C                   Eval      srcDate = f_getDate(objd0400.srcFDatTim)
     C                   When      i_srcDate = cSrcMbrDate
     C                   If        isMbrDscAvl
     C                   Eval      srcDate = f_getDate(mbrd0100.chgDatTim )
     C                   Endif
     C                   Other
     C                   Eval      srcDate = i_srcDate
     C                   Endsl
      *
      *  ... srcTime
     C                   Select
     C                   When      i_srcTime = cSameTime
     C                   Eval      srcTime = f_getTime(objd0400.srcFDatTim)
     C                   When      i_srcTime = cSrcMbrTime
     C                   If        isMbrDscAvl
     C                   Eval      srcTime = f_getTime(mbrd0100.chgDatTim )
     C                   Endif
     C                   Other
     C                   Eval      srcTime = i_srcTime
     C                   Endsl
      *
      *      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
     C                   If        not f_addKeyE(chgObjInf: cSrcFDatTim:
     C                                           srcFDatTim            )
     C                   Callp     p_sndEscMsg('COA0002': ' ')
     C                   Return
     C                   Endif
      *
      *  ... object level
     C                   If        i_objLvl    <> cSame
     C                   Eval      objLvl    = i_objLvl
     C                   Else
     C                   Eval      objLvl    = objd0400.objLvl
     C                   Endif
      *
      *      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
     C                   If        not f_addKeyE(chgObjInf: cObjLvl   :
     C                                           objLvl               )
     C                   Callp     p_sndEscMsg('COA0002': ' ')
     C                   Return
     C                   Endif
      *
      *  ... licensed program
     C                   If        i_licPgm    <> cSame
     C                   Eval      licPgm    = i_licPgm
     C                   Else
     C                   Eval      licPgm    = objd0400.licPgm
     C                   Endif
      *
      *      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
     C                   If        not f_addKeyE(chgObjInf: cLicPgm   :
     C                                           licPgm               )
     C                   Callp     p_sndEscMsg('COA0002': ' ')
     C                   Return
     C                   Endif
      *
      *  ... ptf
     C                   If        i_ptf       <> cSame
     C                   Eval      ptf       = i_ptf
     C                   Else
     C                   Eval      ptf       = objd0400.ptf
     C                   Endif
      *
      *      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
     C                   If        not f_addKeyE(chgObjInf: cPTF      :
     C                                           ptf                  )
     C                   Callp     p_sndEscMsg('COA0002': ' ')
     C                   Return
     C                   Endif
      *
      *  ... apar
     C                   If        i_apar      <> cSame
     C                   Eval      apar      = i_apar
     C                   Else
     C                   Eval      apar      = objd0400.apar
     C                   Endif
      *
      *      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
     C                   If        not f_addKeyE(chgObjInf: cAPAR     :
     C                                           apar                 )
     C                   Callp     p_sndEscMsg('COA0002': ' ')
     C                   Return
     C                   Endif
      *
      *  ... user defined attribute
     C                   If        i_usrDfnAtr <> cSame
     C                   Eval      usrDfnAtr = i_usrDfnAtr
     C                   Else
     C                   Eval      usrDfnAtr = objd0400.usrDfnAtr
     C                   Endif
      *
      *      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
     C                   If        not f_addKeyE(chgObjInf: cUsrDfnAtr:
     C                                           usrDfnAtr            )
     C                   Callp     p_sndEscMsg('COA0002': ' ')
     C                   Return
     C                   Endif
      *
      *  Ändern der Objektbeschreibung
     C                   Call      'QLICOBJD'
     C                   Parm                    retLibNme
     C                   Parm                    i_qObj
     C                   Parm                    i_objType
     C                   Parm                    chgObjInf
     C                   Parm                    errCode
     C                   Endif
      *
     C                   Return
      *
     P p_main...
     P                 E
      *
      *==================================================================*
      *  add Key to changed object informationen
      *==================================================================*
      *
     P f_addKeyE...
     P                 B
      *
     D f_addKeyE...
     D                 PI              N   opdesc
     D  io_chgObjInf               1024A
     D  i_key                        10I 0 value
     D  i_value                     128A   const
     D                                     options(*varsize)
      *
      *  Deklarieren Arbeitsfelder
     D  chgObjInf      S           1024A   inz
      *
     D  descType       S             10I 0 inz
     D  dataType       S             10I 0 inz
     D  descInf1       S             10I 0 inz
     D  descInf2       S             10I 0 inz
     D  currLen        S             10I 0 inz
      *
     D  pos            S             10I 0 inz
     D  nbrOfKey       S             10I 0 based(pNbrOfKey)
     D  key            S             10I 0 based(pKey     )
     D  keyLen         S             10I 0 based(pKeyLen  )
      *-------------------------------------------------------------------
      *
     C                   Callp     cee_rtvOpDesc(3       : descType:
     C                                           dataType: descInf1:
     C                                           descInf2: currLen :
     C                                           *omit             )
      *
     C                   Eval      pNbrOfKey = %addr(io_chgObjInf)
     C                   Eval      pKey      = pNbrOfKey + 4
     C                   Eval      pos       = 5
      *
      *  Suchen nach dem Ende der Objektinformationen
     C     1             Do        nbrOfKey
     C                   Eval      pKeyLen = pKey + 4
     C                   Eval      pKey    = pKey + 8 + KeyLen
     C                   Eval      pos     = pos  + 8 + keyLen
     C                   Enddo
      *
      *  Anfügen der neuen Informationen
     C                   If        pos >= %size(io_chgObjInf) - 4 - 4 - currLen
     C                   Return    cFalse
     C                   Else
     C                   Eval      pKey     = %addr(io_chgObjInf) + pos - 1
     C                   Eval      pos      = pos + 4
     C                   Eval      pKeyLen  = %addr(io_chgObjInf) + pos - 1
     C                   Eval      pos      = pos + 4
      *
     C                   Eval      nbrOfKey = nbrOfKey + 1
     C                   Eval      key      = i_key
     C                   Eval      keyLen   = currLen
     C                   Eval      %subst(io_chgObjInf: pos: currLen) =
     C                                   %subst(i_value: 1: currLen)
     C                   Return    cTrue
     C                   Endif
      *
     P f_addKeyE...
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
      *  Deklarieren Arbeitsfelder
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
      *  get date from cymd date
      *==================================================================*
      *
     P f_getDate...
     P                 B
      *
     D f_getDate...
     D                 PI             7A
     D  i_cymd                       13A   value
      *-------------------------------------------------------------------
      *
     C                   Return    %subst(i_cymd: 1: 7)
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
     D                 PI             6A
     D  i_cymd                       13A   value
      *-------------------------------------------------------------------
      *
     C                   Return    %subst(i_cymd: 8: 6)
      *
     P f_getTime...
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
      *  Deklarieren Funktionswert
     D o_isError       S               N   inz(cFalse)
      *
      *  Deklarieren API Fehlercode
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
      *  Erstellen leere API error code Datenstruktur
      *==================================================================*
      *
     P f_newApiErrCode...
     P                 B
      *
     D f_newApiErrCode...
     D                 PI           272A
     D  i_monmsg                       N   value
      *
      *  Deklarieren Funktionswert
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
