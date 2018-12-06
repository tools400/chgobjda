      /IF NOT DEFINED(mbrd0100_t)                                                             RADDAT
      /DEFINE mbrd0100_t                                                                      RADDAT
      *===============================================================*                       RADDAT
      *  QUSRMBRD API - MBRD0100                                      *                       RADDAT
      *===============================================================*                       RADDAT
     D mbrd0100_t      DS                  qualified           based(pDummy)                  RADDAT
     D  bytePrv                      10I 0                                                    RADDAT
     D  byteAvl                      10I 0                                                    RADDAT
     D  filNme                       10A                                                      RADDAT
     D  filLib                       10A                                                      RADDAT
     D  mbr                          10A                                                      RADDAT
     D  attr                         10A                                                      RADDAT
     D  srcTyp                       10A                                                      RADDAT
     D  crtDatTim                    13A                                                      RADDAT
     D  chgDatTim                    13A                                                      RADDAT
     D  text                         50A                                                      RADDAT
     D  srcFile                      10A                                                      RADDAT
      *                                                                                       RADDAT
      /ENDIF                                                                                  RADDAT
