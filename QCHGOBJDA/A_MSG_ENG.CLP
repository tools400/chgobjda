     /* ----------------------------------------------------------- */                    /* RADD */
     /*   Cmd-ADDMSGD für Message-ID :   COA0001                    */                    /* RADD */
     /* Source member parameters are incomplete.                    */                    /* RADD */
     /* ----------------------------------------------------------- */                    /* RADD */
                                                                                          /* RADD */
             PGM        PARM(&LI)                                                         /* RADD */
                                                                                          /* RADD */
             DCL        VAR(&LI) TYPE(*CHAR) LEN(10)                                      /* RADD */
                                                                                          /* RADD */
             RMVMSGD MSGID(COA0001) MSGF(&LI/CHGOBJDA)                                    /* RADD */
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */                        /* RADD */
                                                                                          /* RADD */
             ADDMSGD +
                MSGID(COA0001) +
                MSGF(&LI/CHGOBJDA) +
                MSG(+
'Source member parameters are incomplete.'                       +
                ) +
                SECLVL(+
'Cause . . . . . :   The special value *SRCMBR can only be used, when -
all parameters of the source member are specified. &N Recovery  . . . -
:   Specifify all parameters of the source member such as source file,-
 source library and source member and try the request again.'         +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */                                                             /* RADD */
                                                                                          /* RADD */
     /* ----------------------------------------------------------- */                    /* RADD */
     /*   Cmd-ADDMSGD für Message-ID :   COA0002                    */                    /* RADD */
     /* Too many values specified.                                  */                    /* RADD */
     /* ----------------------------------------------------------- */                    /* RADD */
                                                                                          /* RADD */
             RMVMSGD MSGID(COA0002) MSGF(&LI/CHGOBJDA)                                    /* RADD */
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */                        /* RADD */
                                                                                          /* RADD */
             ADDMSGD +
                MSGID(COA0002) +
                MSGF(&LI/CHGOBJDA) +
                MSG(+
'Too many values specified.'                                          +
                ) +
                SECLVL(+
'Cause . . . . . :   Too many values specified. An internal used field-
 is too small to hold all values. &N Recovery  . . . :   Contact the d-
eveloper of the utility and report the problem.'                      +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */                                                             /* RADD */
                                                                                          /* RADD */
     /* ----------------------------------------------------------- */                    /* RADD */
     /*   Cmd-ADDMSGD für Message-ID :   COA0003                    */                    /* RADD */
     /* Teildatei &3 in Datei &2/&1 nicht gefunden.                 */                    /* RADD */
     /* ----------------------------------------------------------- */                    /* RADD */
                                                                                          /* RADD */
             RMVMSGD MSGID(COA0003) MSGF(&LI/CHGOBJDA)                                    /* RADD */
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */                        /* RADD */
                                                                                          /* RADD */
             ADDMSGD +
                MSGID(COA0003) +
                MSGF(&LI/CHGOBJDA) +
                MSG(+
'Member &3 in file &2/&1 not found.'                              +
                ) +
                SECLVL(+
'Cause . . . . . :   The member &3 in file &2/&1 was not found. The me-
mber specified in the command was not found. &N Recovery  . . . :   Sp-
ecify the correct member and try the request again.'                  +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 010) +
                    (*CHAR 010) +
                    (*CHAR 010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */                                                             /* RADD */
                                                                                          /* RADD */
     /* ----------------------------------------------------------- */                    /* RADD */
     /*   Cmd-ADDMSGD für Message-ID :   COA0004                    */                    /* RADD */
     /* Objekt &1 in Bibliothek &2 Art &3 nicht gefunden.           */                    /* RADD */
     /* ----------------------------------------------------------- */                    /* RADD */
                                                                                          /* RADD */
             RMVMSGD MSGID(COA0004) MSGF(&LI/CHGOBJDA)                                    /* RADD */
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */                        /* RADD */
                                                                                          /* RADD */
             ADDMSGD +
                MSGID(COA0004) +
                MSGF(&LI/CHGOBJDA) +
                MSG(+
'Object &1 in Library &2 type &3 not found.'                          +
                ) +
                SECLVL(+
'Cause . . . . . :   The Object &1 in library &2 Type &3 was not found-
. The object name, object library or object type is not correct. If th-
e library is not specified, the object may be in a library that is not-
 contained in the library list.'                                      +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 010) +
                    (*CHAR 010) +
                    (*CHAR 010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */                                                             /* RADD */
                                                                                          /* RADD */
             ENDPGM                                                                       /* RADD */
