/* -------------------------------------------------------------------------- */
/* CHGOBJDA   - SCRIPT MEMBER (German)                                /* RADD */
/* Use commands  xmlgenINC (generate text for install pgm)                    */
/*               xmlgenMBR (to define source members                          */
/*               xmlgenCMD (execute qcmdexc at run time                       */
/* Put &TOLIB where you want user selected lib at run time.                   */
   DCL &TOLIB *CHAR 10
/* -------------------------------------------------------------------------- */
             XMLGENINC  XINCLUDE(*YES)

             XMLGENVRS XSRCFILE(QCHGOBJDA) XSRCLIB(TOOLS400) XSRCMBR(COPYRIGHT)

             XMLGENCND  XMSG('Select language (GER, ENG)') +
                          XVALUES(GER ENG) XVAR(&LANG)

             XMLGENSET  XVAR(&SRCFILE) XVALUE(QCHGOBJDA)

/* ---------------------------------- */
/*  Deploy source member              */
/* ---------------------------------- */
             XMLGENMBR  XMBR(CHGOBJDAG ) XMBRATR(CMD   ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*CMD) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CHGOBJDAE ) XMBRATR(CMD   ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*CMD) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CHGOBJDAPG) XMBRATR(PNLGRP) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PNLGRP) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CHGOBJDAPE) XMBRATR(PNLGRP) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PNLGRP) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CHGOBJDAR1) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CHGOBJDAR2) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*MODULE) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COA0001   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COA0002   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COA0003   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COA0004   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COPYRIGHT ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDERRCODE ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDMBRD0100) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDOBJD0300) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCHGOBJDA) XOBJTYPE(*PGM) +
                          XGENCRT(*NO) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDOBJD0400) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCHGOBJDA) XFROMSRCL(TOOLS400) +
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

