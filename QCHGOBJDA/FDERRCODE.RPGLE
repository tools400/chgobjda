      /IF NOT DEFINED(errCode_t )                                                             RADDAT
      /DEFINE errCode_t                                                                       RADDAT
      *===============================================================*                       RADDAT
      *  API error code                                               *                       RADDAT
      *===============================================================*                       RADDAT
     D errCode_t       DS                  qualified           based(pDummy)                  RADDAT
     D  bytPrv                       10I 0                                                    RADDAT
     D  bytAvl                       10I 0                                                    RADDAT
     D  excID                         7A                                                      RADDAT
     D  reserved_1                    1A                                                      RADDAT
     D  excDta                      256A                                                      RADDAT
      *                                                                                       RADDAT
      /ENDIF                                                                                  RADDAT
