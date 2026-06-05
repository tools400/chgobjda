     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD für Message-ID :   COA0001                    */
     /* Die Angaben zur Quellenteildatei sind unvollständig.        */
     /* ----------------------------------------------------------- */

             PGM        PARM(&LI)

             DCL        VAR(&LI) TYPE(*CHAR) LEN(10)

             RMVMSGD MSGID(COA0001) MSGF(&LI/CHGOBJDA)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(COA0001) +
                MSGF(&LI/CHGOBJDA) +
                MSG(+
'Die Angaben zur Quellenteildatei sind unvollständig.'                +
                ) +
                SECLVL(+
'Ursache . . . . :   Der Sonderwert *SRCMBR kann nur dann verwendet we-
rden, wenn die Quellenteildatei vollständig qualifiziert worden ist. &-
N Fehlerbehebung  :   Tragen Sie die Informationen Quellendatei, Quell-
enbibliothek und Quellenteildatei ein und führen Sie den Befehl erneut-
 aus.'                                                                +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD für Message-ID :   COA0002                    */
     /* Zu viele Werte angegeben.                                   */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(COA0002) MSGF(&LI/CHGOBJDA)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(COA0002) +
                MSGF(&LI/CHGOBJDA) +
                MSG(+
'Zu viele Werte angegeben.'                                           +
                ) +
                SECLVL(+
'Ursache . . . . :   Es wurden zu viele Werte angegeben. Ein internes -
Arbeitsfeld ist nicht gross genug, um alle Werte verarbeiten zu können-
. &N Fehlerbehebung  :   Melden sie das Problem an den Entwickler.'   +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD für Message-ID :   COA0003                    */
     /* Teildatei &3 in Datei &2/&1 nicht gefunden.                 */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(COA0003) MSGF(&LI/CHGOBJDA)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(COA0003) +
                MSGF(&LI/CHGOBJDA) +
                MSG(+
'Teildatei &3 in Datei &2/&1 nicht gefunden.'                         +
                ) +
                SECLVL(+
'Ursache . . . . :   Die Teildatei &3 konnte in der Datei &2/&1 nicht -
gefunden werden. &N Fehlerbehebung  :   Geben Sie den richtigen Stando-
rt der Teildatei &3 an und führen Sie den Befehl erneut aus.'         +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 010) +
                    (*CHAR 010) +
                    (*CHAR 010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD für Message-ID :   COA0004                    */
     /* Objekt &1 in Bibliothek &2 Art &3 nicht gefunden.           */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(COA0004) MSGF(&LI/CHGOBJDA)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(COA0004) +
                MSGF(&LI/CHGOBJDA) +
                MSG(+
'Objekt &1 in Bibliothek &2 Art &3 nicht gefunden.'                   +
                ) +
                SECLVL(+
'Ursache . . . . :   Das Objekt &1 in Bibliothek &2 Art *&3 wurde nich-
t gefunden. Der Objektname, der Bibliotheksname oder die Objektart ist-
 nicht korrekt. Wurde der Bibliotheksname nicht angegeben, befindet si-
ch das Objekt möglicherweise in einer Bibliothek, die nicht in der Bib-
liotheksliste enthalten ist.'                                         +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 010) +
                    (*CHAR 010) +
                    (*CHAR 010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

             ENDPGM     /* RADD */
