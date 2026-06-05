**free
//==============================================================*
//                                                              *
//  (c) 2000, Thomas Raddatz                                    *
//                                                              *
//  Bereich  : CHGOBJDA                                         *
//  Modul    : CHGOBJDAR1                                       *
//  Typ      : RPGLE                                            *
//  Programm : CHGOBJDA                                         *
//                                                              *
//  erstellt : 26.05.2000  Thomas Raddatz                       *
//                                                              *
//==============================================================*
//                                                              *
//  Kurzdokumentation :                                         *
//                                                              *
//  Befehlsausführungsprogramm für Befehl CHGOBJDA              *
//                                                              *
//==============================================================*
// >>PRE-COMPILER<<                                             *
//                                                              *
//   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                  *
//                           SRCFILE(&SL/&SF) +                 *
//                           SRCMBR(&SM);                       *
//                                                              *
//   >>COMPILE<<                                                *
//     >>PARM<< TRUNCNBR(*NO);                                  *
//     >>PARM<< DBGVIEW(*LIST);                                 *
//   >>END-COMPILE<<                                            *
//                                                              *
//   >>EXECUTE<<                                                *
//                                                              *
//   >>CMD<<    CRTPGM       PGM(&LI/CHGOBJDA) +                *
//                           MODULE(&LI/&OB) +                  *
//                           DETAIL(*BASIC) +                   *
//                           ACTGRP(*NEW);                      *
//                                                              *
// >>END-PRE-COMPILER<<                                         *
//==============================================================*
ctl-opt debug option(*srcstmt: *nodebugio);
ctl-opt decedit('0,') datedit(*DMY.);
ctl-opt datfmt(*iso) timfmt(*iso);
ctl-opt expropts(*resdecpos);
ctl-opt extbinint(*yes);
/copy QCHGOBJDA,COPYRIGHT
//==============================================================*

//  Referenzfelder
/copy QCHGOBJDA,FDERRCODE
/copy QCHGOBJDA,FDMBRD0100
/copy QCHGOBJDA,FDOBJD0400

//  Interne Prototypen
dcl-pr CHGOBJDAR extpgm('CHGOBJDAR');
  gi_qObj      char(20);
  gi_objType   char(10);
  gi_srcFile   char(10);
  gi_srcLib    char(10);
  gi_srcMbr    char(10);
  gi_srcDate   char(7);
  gi_srcTime   char(6);
  gi_objLvl    char(8);
  gi_licPgm    char(13);
  gi_ptf       char(7);
  gi_apar      char(6);
  gi_usrDfnAtr char(10);
end-pr;

dcl-pr p_main;
  i_qObj      like(gi_qObj) value;
  i_objType   like(gi_objType) value;
  i_srcFile   like(gi_srcFile) value;
  i_srcLib    like(gi_srcLib) value;
  i_srcMbr    like(gi_srcMbr) value;
  i_srcDate   like(gi_srcDate) value;
  i_srcTime   like(gi_srcTime) value;
  i_objLvl    like(gi_objLvl) value;
  i_licPgm    like(gi_licPgm) value;
  i_ptf       like(gi_ptf) value;
  i_apar      like(gi_apar) value;
  i_usrDfnAtr like(gi_usrDfnAtr) value;
end-pr;

dcl-pr f_addKeyE ind opdesc;
  io_chgObjInf char(1024);
  i_key        int(10) value;
  i_value      char(128) options(*varsize) const;
end-pr;

dcl-pr p_sndEscMsg;
  i_msgID  char(7) value;
  i_msgDta char(128) value;
end-pr;

dcl-pr f_getDate char(7);
  i_cymd char(13) value;
end-pr;

dcl-pr f_getTime char(6);
  i_cymd char(13) value;
end-pr;

dcl-pr f_isApiError ind;
  i_errCode char(272) value;
end-pr;

dcl-pr f_newApiErrCode char(272);
  i_monmsg ind value;
end-pr;

dcl-pr cee_rtvOpDesc extproc('CEEDOD');
  i_posn     int(10) const;
  o_descType int(10);
  o_dataType int(10);
  o_descInf1 int(10);
  o_descInf2 int(10);
  o_dataLen  int(10);
  o_fc       char(12) options(*omit);
end-pr;

//  Retrieve Object Description
dcl-pr qusrobjd extpgm('QUSROBJD');
  rcvVar    char(32767) options(*varsize);
  rcvVarLen int(10) const;
  format    char(8) const;
  qObj      char(20) const;
  objType   char(10) const;
  errCode   char(32767) options(*varsize: *nopass);
end-pr;

//  Retrieve Member Description
dcl-pr qusrmbrd extpgm('QUSRMBRD');
  rcvVar    char(32767) options(*varsize);
  rcvVarLen int(10) const;
  format    char(8) const;
  qFile     char(20) const;
  mbr       char(10) const;
  override  char(1) const;
  errCode   char(32767) options(*varsize: *nopass);
end-pr;

//  Send Program Message (QMHSNDPM) API
dcl-pr qmhsndpm extpgm('QMHSNDPM');
  i_msgid      char(7) const;
  i_qmsgf      char(20) const;
  i_msgdata    char(32767) options(*varsize) const;
  i_length     int(10) const;
  i_msgtype    char(10) const;
  i_callstke   char(256) const;
  i_callstkc   int(10) const;
  o_msgkey     char(4);
  io_errcode   char(32767) options(*varsize);
  i_lenstke    int(10) options(*nopass) const; // optGrp 1
  i_callstkeq  char(20) options(*nopass) const;
  i_wait       int(10) options(*nopass) const;
  i_callstkedt char(10) options(*nopass) const; // optGrp 2
  i_ccsid      int(10) options(*nopass) const;
end-pr;

//  Change Object Description (QLICOBJD) API
dcl-pr QLICOBJD extpgm('QLICOBJD');
  o_rtnLib   char(10);
  i_qObj     char(20) const;
  i_objType  char(10) const;
  i_chgObjI  char(65535) options(*varsize) const;
  io_errCode char(65535) options(*varsize);
end-pr;

//  Globale Konstanten
dcl-c cTrue *on;
dcl-c cFalse *off;

dcl-c cSame '*SAME';
dcl-c cSameDate '0000000';
dcl-c cSameTime '000000';
dcl-c cSrcMbrDate '0000001';
dcl-c cSrcMbrTime '000001';

dcl-c cSrcFile 1;
dcl-c cSrcFDatTim 2;
dcl-c cObjLvl 4;
dcl-c cLicPgm 5;
dcl-c cPTF 6;
dcl-c cAPAR 7;
dcl-c cUsrDfnAtr 9;

//==================================================================*
//  Program entry point
//==================================================================*
dcl-pi CHGOBJDAR;
  gi_qObj      char(20);
  gi_objType   char(10);
  gi_srcFile   char(10);
  gi_srcLib    char(10);
  gi_srcMbr    char(10);
  gi_srcDate   char(7);
  gi_srcTime   char(6);
  gi_objLvl    char(8);
  gi_licPgm    char(13);
  gi_ptf       char(7);
  gi_apar      char(6);
  gi_usrDfnAtr char(10);
end-pi;

// --------------------------------------------------------------------
// Stand Alone Fields - TOP
// --------------------------------------------------------------------
dcl-s do_x1 packed(7);
// --------------------------------------------------------------------
// Stand Alone Fields - BOTTOM
// --------------------------------------------------------------------
//-------------------------------------------------------------------

p_main(gi_qObj      :
gi_objType   :
gi_srcFile   :
gi_srcLib    :
gi_srcMbr    :
gi_srcDate   :
gi_srcTime   :
gi_objLvl    :
gi_licPgm    :
gi_ptf       :
gi_apar      :
gi_usrDfnAtr );

*inlr = *on;

//==================================================================*
//  Haupsteurung
//==================================================================*

dcl-proc p_main;
  dcl-pi *n;
    i_qObj      like(gi_qObj) value;
    i_objType   like(gi_objType) value;
    i_srcFile   like(gi_srcFile) value;
    i_srcLib    like(gi_srcLib) value;
    i_srcMbr    like(gi_srcMbr) value;
    i_srcDate   like(gi_srcDate) value;
    i_srcTime   like(gi_srcTime) value;
    i_objLvl    like(gi_objLvl) value;
    i_licPgm    like(gi_licPgm) value;
    i_ptf       like(gi_ptf) value;
    i_apar      like(gi_apar) value;
    i_usrDfnAtr like(gi_usrDfnAtr) value;
  end-pi;

  //  API error code
  dcl-ds errCode likeds(errCode_t) inz;

  //  Qualified object name
  dcl-ds qObj;
    qObj_name char(10) inz;
    qObj_lib  char(10) inz;
  end-ds;

  //  Objektbeschreibung OBJD0400
  dcl-ds OBJD0400 likeds(objd0400_t) inz;

  //  Teildateibeschreibung MBRD0100
  dcl-ds MBRD0100 likeds(mbrd0100_t) inz;

  //  Deklarieren Arbeitsfelder
  dcl-s chgObjInf char(1024) inz(*ALLx'00');
  dcl-s retLibNme char(10) inz;
  //  source file
  dcl-s srcFile like(i_srcFile) inz;
  dcl-s srcLib like(i_srcLib) inz;
  dcl-s srcMbr like(i_srcMbr) inz;
  //  object level
  dcl-s objLvl like(i_objLvl) inz;
  //  licensed program
  dcl-s licPgm like(i_licPgm) inz;
  //  ptf
  dcl-s ptf like(i_ptf) inz;
  //  apar
  dcl-s apar like(i_apar) inz;
  //  source file last changed date and time
  dcl-ds srcFDatTim;
    srcDate char(7) inz;
    srcTime char(6) inz;
  end-ds;
  //  user defined attribute
  dcl-s usrDfnAtr like(i_usrDfnAtr) inz;
  //  is member description available
  dcl-s isMbrDscAvl ind inz(cFalse);

  //  Nachrichtendatenstrukturen
/copy QCHGOBJDA,COA0003
/copy QCHGOBJDA,COA0004
  //-------------------------------------------------------------------

  If (i_srcFile   <> cSame    ) or
  (i_srcLib    <> cSame    ) or
  (i_srcMbr    <> cSame    ) or
  (i_srcDate   <> cSameDate) or
  (i_srcTime   <> cSameTime) or
  (i_objLvl    <> cSame    ) or
  (i_licPgm    <> cSame    ) or
  (i_ptf       <> cSame    ) or
  (i_apar      <> cSame    ) or
  (i_usrDfnAtr <> cSame    );

    //  Abrufen Objektbeschreibung
    errCode    = f_newApiErrCode(cTrue);
    qusrobjd(OBJD0400        :
    %size(OBJD0400) :
    'OBJD0400'      :
    i_qObj          :
    i_objType       :
    errCode         );

    If f_isApiError(errCode);
      qObj = i_qObj;
      Clear COA0004;
      COA00041 = qObj_name;
      COA00042 = qObj_lib;
      COA00043 = i_objType;
      p_sndEscMsg('COA0004': COA0004);
    Endif;

    //  Abgleichen neue Werte ...

    //  ... srcF
    If i_srcFile <> cSame;
      srcFile = i_srcFile;
    Else;
      srcFile = objd0400.srcFile;
    Endif;
    //  ... srcL
    If i_srcLib <> cSame;
      srcLib = i_srcLib;
    Else;
      srcLib = objd0400.srcLib;
    Endif;
    //  ... srcMbr
    If i_srcMbr <> cSame;
      srcMbr = i_srcMbr;
    Else;
      srcMbr = objd0400.srcMbr;
    Endif;

    //      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
    If not f_addKeyE(chgObjInf: cSrcFile:
    srcFile + srcLib + srcMbr);
      p_sndEscMsg('COA0002': ' ');
      Return;
    Endif;

    //  Abrufen Quellenteildateiattribute
    If (i_srcDate = cSrcMbrDate ) or
    (i_srcTime = cSrcMbrTime );
      errCode    = f_newApiErrCode(cTrue);
      qusrmbrd(MBRD0100         :
      %size(MBRD0100)  :
      'MBRD0100'       :
      srcFile + srcLib :
      srcMbr           :
      '0'              :
       errCode         );
      If f_isApiError(errCode);
        isMbrDscAvl = cFalse;
        Clear COA0003;
        COA00031 = srcFile;
        COA00032 = srcLib;
        COA00033 = srcMbr;
        p_sndEscMsg('COA0003': COA0003);
      Else;
        isMbrDscAvl = cTrue;
      Endif;
    Else;
      isMbrDscAvl = cFalse;
    Endif;

    //  ... srcDate
    Select;
    When i_srcDate = cSameDate;
      srcDate = f_getDate(objd0400.srcFDatTim);
    When i_srcDate = cSrcMbrDate;
      If isMbrDscAvl;
        srcDate = f_getDate(mbrd0100.chgDatTim );
      Endif;
    Other;
      srcDate = i_srcDate;
    Endsl;

    //  ... srcTime
    Select;
    When i_srcTime = cSameTime;
      srcTime = f_getTime(objd0400.srcFDatTim);
    When i_srcTime = cSrcMbrTime;
      If isMbrDscAvl;
        srcTime = f_getTime(mbrd0100.chgDatTim );
      Endif;
    Other;
      srcTime = i_srcTime;
    Endsl;

    //      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
    If not f_addKeyE(chgObjInf: cSrcFDatTim:
    srcFDatTim            );
      p_sndEscMsg('COA0002': ' ');
      Return;
    Endif;

    //  ... object level
    If i_objLvl    <> cSame;
      objLvl    = i_objLvl;
    Else;
      objLvl    = objd0400.objLvl;
    Endif;

    //      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
    If not f_addKeyE(chgObjInf: cObjLvl   :
    objLvl               );
      p_sndEscMsg('COA0002': ' ');
      Return;
    Endif;

    //  ... licensed program
    If i_licPgm    <> cSame;
      licPgm    = i_licPgm;
    Else;
      licPgm    = objd0400.licPgm;
    Endif;

    //      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
    If not f_addKeyE(chgObjInf: cLicPgm   :
    licPgm               );
      p_sndEscMsg('COA0002': ' ');
      Return;
    Endif;

    //  ... ptf
    If i_ptf       <> cSame;
      ptf       = i_ptf;
    Else;
      ptf       = objd0400.ptf;
    Endif;

    //      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
    If not f_addKeyE(chgObjInf: cPTF      :
    ptf                  );
      p_sndEscMsg('COA0002': ' ');
      Return;
    Endif;

    //  ... apar
    If i_apar      <> cSame;
      apar      = i_apar;
    Else;
      apar      = objd0400.apar;
    Endif;

    //      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
    If not f_addKeyE(chgObjInf: cAPAR     :
    apar                 );
      p_sndEscMsg('COA0002': ' ');
      Return;
    Endif;

    //  ... user defined attribute
    If i_usrDfnAtr <> cSame;
      usrDfnAtr = i_usrDfnAtr;
    Else;
      usrDfnAtr = objd0400.usrDfnAtr;
    Endif;

    //      ... Eintragen neuen Schlüssel in neue Objektbeschreibung
    If not f_addKeyE(chgObjInf: cUsrDfnAtr:
    usrDfnAtr            );
      p_sndEscMsg('COA0002': ' ');
      Return;
    Endif;

    //  Ändern der Objektbeschreibung
    QLICOBJD ( retLibNme : i_qObj :
    i_objType : chgObjInf : errCode );
  Endif;

  Return;

end-proc;

//==================================================================*
//  add Key to changed object informationen
//==================================================================*

dcl-proc f_addKeyE;
  dcl-pi *n ind opdesc;
    io_chgObjInf char(1024);
    i_key        int(10) value;
    i_value      char(128) options(*varsize) const;
  end-pi;

  //  Deklarieren Arbeitsfelder
  dcl-s chgObjInf char(1024) inz;

  dcl-s descType int(10) inz;
  dcl-s dataType int(10) inz;
  dcl-s descInf1 int(10) inz;
  dcl-s descInf2 int(10) inz;
  dcl-s currLen int(10) inz;

  dcl-s pos int(10) inz;
  dcl-s nbrOfKey int(10) based(pNbrOfKey);
  dcl-s key int(10) based(pKey);
  dcl-s keyLen int(10) based(pKeyLen);
  //-------------------------------------------------------------------

  cee_rtvOpDesc(3       : descType:
  dataType: descInf1:
  descInf2: currLen :
  *omit             );

  pNbrOfKey = %addr(io_chgObjInf);
  pKey      = pNbrOfKey + 4;
  pos       = 5;

  //  Suchen nach dem Ende der Objektinformationen
  for do_x1 = 1 to nbrOfKey;
    pKeyLen = pKey + 4;
    pKey    = pKey + 8 + KeyLen;
    pos     = pos  + 8 + keyLen;
  endfor;

  //  Anfügen der neuen Informationen
  If pos >= %size(io_chgObjInf) - 4 - 4 - currLen;
    Return cFalse;
  Else;
    pKey     = %addr(io_chgObjInf) + pos - 1;
    pos      = pos + 4;
    pKeyLen  = %addr(io_chgObjInf) + pos - 1;
    pos      = pos + 4;

    nbrOfKey = nbrOfKey + 1;
    key      = i_key;
    keyLen   = currLen;
    %subst(io_chgObjInf: pos: currLen) =
    %subst(i_value: 1: currLen);
    Return cTrue;
  Endif;

end-proc;

//==================================================================*
//  send escape message
//==================================================================*

dcl-proc p_sndEscMsg;
  dcl-pi *n;
    i_msgID  char(7) value;
    i_msgDta char(128) value;
  end-pi;

  //  Deklarieren Arbeitsfelder
  dcl-ds qMsgF;
    msgF char(10) inz('CHGOBJDA');
    msgL char(10) inz('*LIBL  ');
  end-ds;
  dcl-s msgDtaLen int(10) inz(%size(i_msgDta));
  dcl-s msgType char(10) inz('*ESCAPE');
  dcl-s callStckE char(10) inz('*CTLBDY');
  dcl-s callStckC int(10) inz(1);
  dcl-s msgKey char(4) inz;
  dcl-ds errCode likeds(errCode_t) inz;
  //-------------------------------------------------------------------

  errCode    = f_newApiErrCode(cFalse);

  QMHSNDPM ( i_msgID : qMsgF : i_msgDta :
  msgDtaLen : msgType : callStckE :
  callStckC : msgKey : errCode );

end-proc;

//==================================================================*
//  get date from cymd date
//==================================================================*

dcl-proc f_getDate;
  dcl-pi *n char(7);
    i_cymd char(13) value;
  end-pi;
  //-------------------------------------------------------------------

  Return %subst(i_cymd: 1: 7);

end-proc;

//==================================================================*
//  get time from cymd date
//==================================================================*

dcl-proc f_getTime;
  dcl-pi *n char(6);
    i_cymd char(13) value;
  end-pi;
  //-------------------------------------------------------------------

  Return %subst(i_cymd: 8: 6);

end-proc;

//==================================================================*
//  Is API Error?
// -----------------------------------------------------------------
//    cTrue  - error
//    cFalse - no error
//==================================================================*

dcl-proc f_isApiError;
  dcl-pi *n ind;
    i_errCode char(272) value;
  end-pi;

  //  Deklarieren Funktionswert
  dcl-s o_isError ind inz(cFalse);

  //  Deklarieren API Fehlercode
  dcl-ds errCode likeds(errCode_t) based(pErrCode);
  //-------------------------------------------------------------------

  pErrCode = %addr(i_errCode);

  If errCode.bytAvl = 0;
    o_isError = cFalse;
  Else;
    o_isError = cTrue;
  Endif;

  Return o_isError;

end-proc;

//==================================================================*
//  Erstellen leere API error code Datenstruktur
//==================================================================*

dcl-proc f_newApiErrCode;
  dcl-pi *n char(272);
    i_monmsg ind value;
  end-pi;

  //  Deklarieren Funktionswert
  dcl-ds errCode likeds(errCode_t) inz;
  //-------------------------------------------------------------------

  Clear errCode;

  If i_monMsg = cTrue;
    errCode.bytPrv = %size(errCode);
  Else;
    errCode.bytPrv = 0;
  Endif;

  Return errCode;

end-proc;

