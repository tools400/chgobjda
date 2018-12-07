      /IF NOT DEFINED(objd0400_t)
      /DEFINE objd0400_t
      *===============================================================*
      *  QUSROBJD API - OBJD0400                                      *
      *===============================================================*
      *
     D objd0400_t      DS                  qualified           based(pDummy)
      *    OBJD0100 ...
     D  bytRet                       10I 0
     D  bytAvl                       10I 0
     D  name                         10A
     D  lib                          10A
     D  type                         10A
     D  rtnLib                       10A
     D  auxStgP                      10I 0
     D  owner                        10A
     D  domain                        2A
     D  crtDatTim                    13A
     D  chgDatTim                    13A
      *    OBJD0200 ...
     D  extObjAtr                    10A
     D  text                         50A
     D  srcFile                      10A
     D  srcLib                       10A
     D  srcMbr                       10A
      *    OBJD0300 ...
     D  srcFDatTim                   13A
     D  savDatTim                    13A
     D  rstDatTim                    13A
     D  crtUsrPrf                    10A
     D  crtSys                        8A
     D  resDat                        7A
     D  savSize                      10I 0
     D  savSeqNbr                    10I 0
     D  stg                          10A
     D  savCmd                       10A
     D  savVolID                     71A
     D  savDev                       10A
     D  savFName                     10A
     D  savFLibName                  10A
     D  savLbl                       17A
     D  sysLvl                        9A
     D  compiler                     16A
     D  objLvl                        8A
     D  usrChg                        1A
     D  licPgm                       16A
     D  ptf                          10A
     D  apar                         10A
      *    OBJD0400 ...
     D  lastUseDat                    7A
     D  useInfUpd                     1A
     D  daysUseCnt                   10I 0
     D  objSize                      10I 0
     D  objSizeMlt                   10I 0
     D  objCmpSts                     1A
     D  alwChgPgm                     1A
     D  chgByPgm                      1A
     D  usrDfnAtr                    10A
     D  aspOflw                       1A
     D  savActDatTim                 13A
     D  objAudVal                    10A
     D  priGrp                       10A
      *
      /ENDIF
