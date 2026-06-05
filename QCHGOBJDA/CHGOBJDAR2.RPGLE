**free
//==============================================================*
//                                                              *
//  (c) 2006, Bill Reger                                        *
//                                                              *
//  Bereich  : CHGOBJDA                                         *
//  Modul    : CHGOBJDAR2                                       *
//  Typ      : RPGLE                                            *
//  Programm : CHGOBJDAPO                                       *
//                                                              *
//  erstellt : Bill Reger                                       *
//                                                              *
//==============================================================*
//                                                              *
//  Kurzdokumentation :                                         *
//                                                              *
//  Prompt Override Programm für Befehl CHGOBJDA                *
//                                                              *
// ============================================================ *
//  History:                                                    *
//                                                              *
//  Datum       Name          Änderung                          *
//  ----------  ------------  --------------------------------- *
//  23.06.2007  Th.Raddatz    Fixed error in f_getDate() and    *
//                            f_getTime() when objd0400.srcFDatTim
//                            is empty.                         *
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
//   >>CMD<<    CRTPGM       PGM(&LI/CHGOBJDAPO) +              *
//                           MODULE(&LI/&OB) +                  *
//                           DETAIL(*BASIC) +                   *
//                           ACTGRP(*NEW);                      *
//                                                              *
// >>END-PRE-COMPILER<<                                         *
//==============================================================*
ctl-opt debug option(*srcstmt: *nodebugio);
ctl-opt decedit('0,') datedit(*MDY.);
ctl-opt datfmt(*iso) timfmt(*iso);
ctl-opt expropts(*resdecpos);
ctl-opt extbinint(*yes);
/copy QCHGOBJDA,COPYRIGHT
//==============================================================*

//  Referenzfelder
/copy QCHGOBJDA,FDERRCODE
/copy QCHGOBJDA,FDMBRD0100
/copy QCHGOBJDA,FDOBJD0400

dcl-ds cymdhms_t qualified template;
  cymd char(7);
  hms  char(6);
end-ds;

//  Konstanten
dcl-c cQUOTE '''';

//  Prototype
dcl-pr CHGOBJDAP extpgm('CHGOBJDAP');
  gi_Cmd     char(20) const;
  gi_qObj    char(20) const;
  gi_objType char(10) const;
  gi_String  varchar(32767);
end-pr;

dcl-pr p_main;
  i_Cmd     like(gi_Cmd) value;
  i_qObj    like(gi_qObj) value;
  i_objType like(gi_objType) value;
  i_String  like(gi_String);
end-pr;

dcl-pr f_getDate varchar(16);
  i_cymdhms likeds(cymdhms_t) value;
end-pr;

dcl-pr f_getTime varchar(16);
  i_cymdhms likeds(cymdhms_t) value;
end-pr;

dcl-pr f_getLicPgm varchar(13);
  i_licPgm char(16) value;
end-pr;

dcl-pr f_addParameter like(gi_String);
  i_string  like(gi_String) value;
  i_keyword varchar(10) value;
  i_value   varchar(128) value;
end-pr;

dcl-pr p_sndEscMsg;
  i_msgID  char(7) value;
  i_msgDta char(128) value;
end-pr;

dcl-pr f_isApiError ind;
  i_errCode char(272) value;
end-pr;

dcl-pr f_newApiErrCode char(272);
  i_monmsg ind value;
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

//  Convert Date and Time Format (QWCCVTDT) API
dcl-pr QWCCVTDT extpgm('QWCCVTDT');
  i_inFormat  char(10) const;
  i_inVar     char(256) options(*varsize) const;
  i_outFormat char(10) const;
  o_outVar    char(256) options(*varsize);
  io_errCode  char(32767) options(*varsize: *nopass);
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

//  Glaobal Constants
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
dcl-pi CHGOBJDAP;
  gi_Cmd     char(20) const;
  gi_qObj    char(20) const;
  gi_objType char(10) const;
  gi_String  varchar(32767);
end-pi;

//-------------------------------------------------------------------

p_main(gi_Cmd       :
      gi_qObj      :
      gi_objType   :
      gi_String    );

*inlr = *on;

//==================================================================*
//  Housekeeping
//==================================================================*

dcl-proc p_main;
  dcl-pi *n;
    i_Cmd     like(gi_Cmd) value;
    i_qObj    like(gi_qObj) value;
    i_objType like(gi_objType) value;
    i_String  like(gi_String);
  end-pi;

  //  API error code
  dcl-ds errCode likeds(errCode_t) inz;

  //  Qualified object name
  dcl-ds qObj;
    qObj_name char(10) inz;
    qObj_lib  char(10) inz;
  end-ds;

  //  Object description OBJD0400
  dcl-ds OBJD0400 likeds(objd0400_t) inz;

  //  Member description MBRD0100
  dcl-ds MBRD0100 likeds(mbrd0100_t) inz;

  //  Declare Working Variables
  dcl-s chgObjInf char(1024) inz(*ALLx'00');
  dcl-s retLibNme char(10) inz;
  //  Is the member description available?
  dcl-s isMbrDscAvl ind inz(cFalse);

  //  Message Description structures
  dcl-ds COA0003;
    COA00031 char(010) inz(*blanks);
    COA00032 char(010) inz(*blanks);
    COA00033 char(010) inz(*blanks);
  end-ds;
  dcl-s COA0003# bindec(8) inz(0030);

  dcl-ds COA0004;
    COA00041 char(010) inz(*blanks);
    COA00042 char(010) inz(*blanks);
    COA00043 char(010) inz(*blanks);
  end-ds;
  dcl-s COA0004# bindec(8) inz(0030);
  //-------------------------------------------------------------------

  //  Get the current Object Description.
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

  //  Construct the POP Keyword String.

  i_string = f_addParameter(''         :
                           'SRCF'     :
               %trimR(objd0400.srcFile));
  i_string = f_addParameter(i_string   :
                           'SRCFLIB'  :
               %trimR(objd0400.srcLib ));
  i_string = f_addParameter(i_string   :
                           'SRCMBR'   :
               %trimR(objd0400.srcMbr ));
  i_string = f_addParameter(i_string   :
                           'SRCDATE'  :
               f_getDate(objd0400.srcFDatTim));
  i_string = f_addParameter(i_string   :
                           'SRCTIME'  :
               f_getTime(objd0400.srcFDatTim));
  i_string = f_addParameter(i_string   :
                           'OBJLVL'   :
               %TrimR(objd0400.objLvl   ));
  i_string = f_addParameter(i_string   :
                           'LICPGM'   :
               f_getLicPgm(objd0400.licPgm));
  i_string = f_addParameter(i_string   :
                           'PTF'      :
               %TrimR(objd0400.ptf      ));
  i_string = f_addParameter(i_string   :
                           'APAR'     :
               %TrimR(objd0400.apar     ));
  i_string = f_addParameter(i_string   :
                           'USRDFNATR':
               %TrimR(objd0400.usrDfnAtr));


  Return;

end-proc;

//==================================================================*
//  get date from cymd date
//==================================================================*

dcl-proc f_getDate;
  dcl-pi *n varchar(16);
    i_cymdhms likeds(cymdhms_t) value;
  end-pi;

  dcl-s rtnDate varchar(16) inz;

  dcl-s date date inz;
  //-------------------------------------------------------------------

  If i_cymdhms.hms <> '';
    date = %date(i_cymdhms.cymd: *CYMD0);
    rtnDate = %trimR(%char(date: *JOBRUN0));
  Else;
    rtnDate = '';
  Endif;

  Return rtnDate;

end-proc;

//==================================================================*
//  get time from cymd date
//==================================================================*

dcl-proc f_getTime;
  dcl-pi *n varchar(16);
    i_cymdhms likeds(cymdhms_t) value;
  end-pi;

  dcl-s rtnTime varchar(16) inz;

  dcl-s time time inz;
  //-------------------------------------------------------------------

  If i_cymdhms.hms <> '';
    time = %time(i_cymdhms.hms: *HMS0);
    rtnTime = %trimR(%char(time: *JOBRUN0));
  Else;
    rtnTime = '';
  Endif;

  Return rtnTime;

end-proc;

//==================================================================*
//  get/compress licensed program information
//==================================================================*
//  Switch prompt value to '*SAME' if the license program
//  information ecceeds 13 character.
//  Regarding to the description of the QLICOBJD API we
//  we can only change 13 characters of the license program
//  information, whereas IBM license programs show a
//  16-character license program information.
//==================================================================*

dcl-proc f_getLicPgm;
  dcl-pi *n varchar(13);
    i_licPgm char(16) value;
  end-pi;

  dcl-s rtnLicPgm varchar(13) inz;

  dcl-ds licPgm qualified;
    name      char(7);
    ibmLicInf char(3);
    vrm       char(6);
  end-ds;
  //-------------------------------------------------------------------

  licPgm = i_licPgm;

  If licPgm.ibmLicInf = '';
    rtnLicPgm = licPgm.name + licPgm.vrm;
  Else;
    rtnLicPgm = '*SAME';
  Endif;

  Return rtnLicPgm;

end-proc;

//==================================================================*
//  add parameter to string
//==================================================================*

dcl-proc f_addParameter;
  dcl-pi *n like(gi_String);
    i_string  like(gi_String) value;
    i_keyword varchar(10) value;
    i_value   varchar(128) value;
  end-pi;

  dcl-s rtnString like(gi_String) inz;
  dcl-s quote varchar(1) inz;
  //-------------------------------------------------------------------

  rtnString = i_string;
  If rtnString <> '';
    rtnString = rtnString + ' ';
  Endif;

  If %scan(' ': %trimR(i_value)) > 0;
    quote = cQuote;
  Else;
    quote = '';
  Endif;

  rtnString = rtnString + '?<'
                       + %trimR(i_keyword)
                       + '('
                       + quote
                       + i_value
                       + quote
                       + ')';

  Return rtnString;

end-proc;

//==================================================================*
//  send escape message
//==================================================================*

dcl-proc p_sndEscMsg;
  dcl-pi *n;
    i_msgID  char(7) value;
    i_msgDta char(128) value;
  end-pi;

  //  Declare variables
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
//  Is API Error?
// -----------------------------------------------------------------
//    cTrue  - error
//    cFalse - no error
//==================================================================*

dcl-proc f_isApiError;
  dcl-pi *n ind;
    i_errCode char(272) value;
  end-pi;

  //  Declare logical variable
  dcl-s o_isError ind inz(cFalse);

  //  Declare API error code
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
//  API error code data structure
//==================================================================*

dcl-proc f_newApiErrCode;
  dcl-pi *n char(272);
    i_monmsg ind value;
  end-pi;

  //  Declare working Function
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

