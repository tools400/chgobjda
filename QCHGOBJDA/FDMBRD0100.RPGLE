**free
/if NOT defined(mbrd0100_t)
/define mbrd0100_t
//===============================================================*
//  QUSRMBRD API - MBRD0100                                      *
//===============================================================*
dcl-ds mbrd0100_t qualified template;
  bytePrv   int(10);
  byteAvl   int(10);
  filNme    char(10);
  filLib    char(10);
  mbr       char(10);
  attr      char(10);
  srcTyp    char(10);
  crtDatTim char(13);
  chgDatTim char(13);
  text      char(50);
  srcFile   char(10);
end-ds;

/endif
