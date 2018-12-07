      /IF NOT DEFINED(mbrd0100_t)
      /DEFINE mbrd0100_t
      *===============================================================*
      *  QUSRMBRD API - MBRD0100                                      *
      *===============================================================*
     D mbrd0100_t      DS                  qualified           based(pDummy)
     D  bytePrv                      10I 0
     D  byteAvl                      10I 0
     D  filNme                       10A
     D  filLib                       10A
     D  mbr                          10A
     D  attr                         10A
     D  srcTyp                       10A
     D  crtDatTim                    13A
     D  chgDatTim                    13A
     D  text                         50A
     D  srcFile                      10A
      *
      /ENDIF
