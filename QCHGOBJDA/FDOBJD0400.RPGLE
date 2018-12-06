      /IF NOT DEFINED(objd0400_t)                                                             RADDAT
      /DEFINE objd0400_t                                                                      RADDAT
      *===============================================================*                       RADDAT
      *  QUSROBJD API - OBJD0400                                      *                       RADDAT
      *===============================================================*                       RADDAT
      *                                                                                       RADDAT
     D objd0400_t      DS                  qualified           based(pDummy)                  RADDAT
      *    OBJD0100 ...                                                                       RADDAT
     D  bytRet                       10I 0                                                    RADDAT
     D  bytAvl                       10I 0                                                    RADDAT
     D  name                         10A                                                      RADDAT
     D  lib                          10A                                                      RADDAT
     D  type                         10A                                                      RADDAT
     D  rtnLib                       10A                                                      RADDAT
     D  auxStgP                      10I 0                                                    RADDAT
     D  owner                        10A                                                      RADDAT
     D  domain                        2A                                                      RADDAT
     D  crtDatTim                    13A                                                      RADDAT
     D  chgDatTim                    13A                                                      RADDAT
      *    OBJD0200 ...                                                                       RADDAT
     D  extObjAtr                    10A                                                      RADDAT
     D  text                         50A                                                      RADDAT
     D  srcFile                      10A                                                      RADDAT
     D  srcLib                       10A                                                      RADDAT
     D  srcMbr                       10A                                                      RADDAT
      *    OBJD0300 ...                                                                       RADDAT
     D  srcFDatTim                   13A                                                      RADDAT
     D  savDatTim                    13A                                                      RADDAT
     D  rstDatTim                    13A                                                      RADDAT
     D  crtUsrPrf                    10A                                                      RADDAT
     D  crtSys                        8A                                                      RADDAT
     D  resDat                        7A                                                      RADDAT
     D  savSize                      10I 0                                                    RADDAT
     D  savSeqNbr                    10I 0                                                    RADDAT
     D  stg                          10A                                                      RADDAT
     D  savCmd                       10A                                                      RADDAT
     D  savVolID                     71A                                                      RADDAT
     D  savDev                       10A                                                      RADDAT
     D  savFName                     10A                                                      RADDAT
     D  savFLibName                  10A                                                      RADDAT
     D  savLbl                       17A                                                      RADDAT
     D  sysLvl                        9A                                                      RADDAT
     D  compiler                     16A                                                      RADDAT
     D  objLvl                        8A                                                      RADDAT
     D  usrChg                        1A                                                      RADDAT
     D  licPgm                       16A                                                      RADDAT
     D  ptf                          10A                                                      RADDAT
     D  apar                         10A                                                      RADDAT
      *    OBJD0400 ...                                                                       RADDAT
     D  lastUseDat                    7A                                                      RADDAT
     D  useInfUpd                     1A                                                      RADDAT
     D  daysUseCnt                   10I 0                                                    RADDAT
     D  objSize                      10I 0                                                    RADDAT
     D  objSizeMlt                   10I 0                                                    RADDAT
     D  objCmpSts                     1A                                                      RADDAT
     D  alwChgPgm                     1A                                                      RADDAT
     D  chgByPgm                      1A                                                      RADDAT
     D  usrDfnAtr                    10A                                                      RADDAT
     D  aspOflw                       1A                                                      RADDAT
     D  savActDatTim                 13A                                                      RADDAT
     D  objAudVal                    10A                                                      RADDAT
     D  priGrp                       10A                                                      RADDAT
      *                                                                                       RADDAT
      /ENDIF                                                                                  RADDAT
