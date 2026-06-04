**free
/if NOT defined(objd0300_t)
/define objd0300_t
//===============================================================*
//  QUSROBJD API - OBJD0300                                      *
//===============================================================*

dcl-ds objd0300_t qualified template;
  //    OBJD0100 ...
  bytRet      int(10);
  bytAvl      int(10);
  name        char(10);
  lib         char(10);
  type        char(10);
  rtnLib      char(10);
  auxStgP     int(10);
  owner       char(10);
  domain      char(2);
  crtDatTim   char(13);
  chgDatTim   char(13);
  //    OBJD0200 ...
  extObjAtr   char(10);
  text        char(50);
  srcFile     char(10);
  srcLib      char(10);
  srcMbr      char(10);
  //    OBJD0300 ...
  srcFDatTim  char(13);
  savDatTim   char(13);
  rstDatTim   char(13);
  crtUsrPrf   char(10);
  crtSys      char(8);
  resDat      char(7);
  savSize     int(10);
  savSeqNbr   int(10);
  stg         char(10);
  savCmd      char(10);
  savVolID    char(71);
  savDev      char(10);
  savFName    char(10);
  savFLibName char(10);
  savLbl      char(17);
  sysLvl      char(9);
  compiler    char(16);
  objLvl      char(8);
  usrChg      char(1);
  licPgm      char(16);
  ptf         char(10);
  apar        char(10);
end-ds;

/endif
