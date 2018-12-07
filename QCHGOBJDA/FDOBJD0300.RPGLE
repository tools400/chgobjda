      /IF NOT DEFINED(objd0300_t)
      /DEFINE objd0300_t
      *===============================================================*
      *  QUSROBJD API - OBJD0300                                      *
      *===============================================================*
      *
     D objd0300_t      DS                  qualified           based(pDummy)
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
      *
      /ENDIF
