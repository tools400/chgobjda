/* -------------------------------------------------------------------------- */
/* CHGOBJDA   - SCRIPT MEMBER (German)                                /* RADD */
/* Use commands  xmlgenINC (generate text for install pgm)                    */
/*               xmlgenMBR (to define source members                          */
/*               xmlgenCMD (execute qcmdexc at run time                       */
/* Put &TOLIB where you want user selected lib at run time.                   */
   DCL &TOLIB *CHAR 10
/* -------------------------------------------------------------------------- */
/* >>PRE-COMPILER<<                                                           */
/*   >>CRTCMD<<  XMLGEN  XMLSCRIPT(&SM) SCRIPTSRCF(&SL/&SF);                  */
/*   >>IMPORTANT<<                                                            */
/*     >>PARM<<  SRCTOFILE(&LI/QXML);                                         */
/*     >>PARM<<  XMLMBR(*SCRIPT);                                             */
/*     >>PARM<<  ENCODING('ISO-8859-1');                                      */
/*     >>PARM<<  AUTHOR('Thomas Raddatz');                                    */
/*   >>END-IMPORTANT<<                                                        */
/*   >>EXECUTE<<                                                              */
/* >>END-PRE-COMPILER<<                                                       */
/* -------------------------------------------------------------------------- */
             XMLGENINC  XINCLUDE(*YES)

             XMLGENVRS XSRCFILE(QCHGOBJDA) XSRCLIB(CHGOBJDAD) XSRCMBR(COPYRIGHT)

             XMLGENCND  XMSG('Select language (GER, ENG)') +
                          XVALUES(GER ENG) XVAR(&LANG)

             XMLGENSET  XVAR(&SRCFILE) XVALUE(QCHGOBJDA)

/* ---------------------------------- */
/*  Deploy source member              */
/* ---------------------------------- */
             XMLGENMBR  XMBR(A_INSTALL) XMBRATR(CLLE) +
                          XFROMSRCF(QCHGOBJDA ) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_MSG_ENG ) XMBRATR(CLP   ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*CMD) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_MSG_GER ) XMBRATR(CLP   ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*CMD) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_README  ) XMBRATR(TXT   ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*CMD) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CHGOBJDAE ) XMBRATR(CMD   ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*CMD) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CHGOBJDAG ) XMBRATR(CMD   ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*CMD) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CHGOBJDAPE) XMBRATR(PNLGRP) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PNLGRP) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CHGOBJDAPG) XMBRATR(PNLGRP) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PNLGRP) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CHGOBJDAR1) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CHGOBJDAR2) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COA0001   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COA0002   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COA0003   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COA0004   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COPYRIGHT ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDERRCODE ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDMBRD0100) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDOBJD0300) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDOBJD0400) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(CHGOBJDAD) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

/* ---------------------------------- */
/*  Create objects                    */
/* ---------------------------------- */
             XMLGENCMD  XCMD(CRTBNDCL PGM(&TOLIB/A_INSTALL) +
                          SRCFILE(&TOLIB/QCHGOBJDA ) SRCMBR(*PGM) +
                          DFTACTGRP(*NO) ACTGRP(*NEW) +
                          DBGVIEW(*LIST)) XDLTSPLF(A_INSTALL)

             XMLGENCMD  XCMD(CALL PGM(&TOLIB/A_INSTALL) +
                             PARM('&TGTRLS' '&SRCFILE' '&TOLIB' '&LANG'))
             XMLGENCMD  XCMD(DLTPGM PGM(&TOLIB/A_INSTALL))

