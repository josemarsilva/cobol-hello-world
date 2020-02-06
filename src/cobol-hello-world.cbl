       IDENTIFICATION  DIVISION.
       PROGRAM-ID.    FERRCNTX.
       AUTHOR.        ANDRE.
       ENVIRONMENT  DIVISION.
       INPUT-OUTPUT  SECTION.
       FILE-CONTROL.
           SELECT COUNTDAT ASSIGN  TO  DISK.
           SELECT LOGDAT   ASSIGN  TO  DISK.
       DATA  DIVISION.
       FILE  SECTION.
       FD  COUNTDAT
           LABEL RECORD STANDARD VALUE OF FILE-ID IS "count.dat".
       01  REG-COUNTDAT.
           03  CONTADOR              PIC 9(05).
           03  FILLER                PIC X(75).
       FD  LOGDAT
           LABEL RECORD STANDARD VALUE OF FILE-ID IS "log.dat".
       01  REG-LOGDAT.
           03  DATADAT               PIC 9(08).
           03  HORADAT               PIC 9(06).
           03  FILLER                PIC X(66).
       WORKING-STORAGE  SECTION.
       77  IND                       PIC 9(05)  VALUE  0.
       77  WAC-CONTADOR              PIC 9(05)  VALUE  0.
       77  WRK-LIDOS                 PIC 9(05)  VALUE  0.
       77  WRK-RC                    PIC X(02)  VALUE  '00'.
       77  WRK-TIME                  PIC X(08)  VALUE  SPACES.
       01  WRK-CURRENT-DATE.
           03  WRK-SEC               PIC X(02)  VALUE  '20'.
           03  WRK-DATE.
               05  WRK-DATE-AA       PIC X(02).
               05  WRK-DATE-MM       PIC X(02).
               05  WRK-DATE-DD       PIC X(02).
       01  TAB-GUARDA-LOG.
           03  TAB-OCC  OCCURS  1000.
               05  TAB-DATA          PIC X(08).
               05  TAB-HORA          PIC X(06).
       PROCEDURE  DIVISION.
       XXX-00-PRINCIPAL  SECTION.

           DISPLAY 'Hello Cobol World (with count)!'.
           PERFORM  VARYING  IND  FROM  1  BY  1
                      UNTIL  IND  GREATER  1000
                MOVE  ZEROS  TO  TAB-OCC(IND)
           END-PERFORM.

           MOVE  ZEROS  TO  IND.

           ACCEPT  WRK-DATE  FROM  DATE.
           ACCEPT  WRK-TIME  FROM  TIME.

           OPEN  INPUT  COUNTDAT  LOGDAT.

           PERFORM  XXX-00-LER-COUNTDAT
                    UNTIL  REG-COUNTDAT  EQUAL  HIGH-VALUES.

           PERFORM  XXX-00-LER-LOGDAT
                    UNTIL  REG-LOGDAT  EQUAL  HIGH-VALUES.

           CLOSE  COUNTDAT  LOGDAT.

           OPEN  OUTPUT  COUNTDAT  LOGDAT.

           ADD  1              TO  WAC-CONTADOR
           MOVE  SPACES        TO  REG-COUNTDAT
           MOVE  WAC-CONTADOR  TO  CONTADOR
           WRITE  REG-COUNTDAT.

           ADD  1  TO  IND
           IF  IND  GREATER  1000
               DISPLAY  '2-ESTOURO TABELA LOGDAT(MAIS DE 1000)'
               MOVE  '08'  TO  WRK-RC
               PERFORM  XXX-00-FINALIZAR
           ELSE
               MOVE  WRK-CURRENT-DATE  TO  TAB-DATA(IND)
               MOVE  WRK-TIME          TO  TAB-HORA(IND)
           END-IF.

           PERFORM  VARYING  IND  FROM  1  BY  1
                      UNTIL  (IND  GREATER  1000)  OR
                             (TAB-DATA(IND)  EQUAL  ZEROS)
              MOVE  TAB-OCC(IND)  TO  REG-LOGDAT
              WRITE  REG-LOGDAT
           END-PERFORM.

           PERFORM  XXX-00-FINALIZAR.

       XXX-99-PRINCIPAL.  EXIT.

       XXX-00-LER-COUNTDAT  SECTION.

           READ  COUNTDAT  AT  END
                 MOVE  HIGH-VALUES  TO  REG-COUNTDAT.

           IF  REG-COUNTDAT  NOT  EQUAL  HIGH-VALUES
               MOVE  CONTADOR  TO  WAC-CONTADOR
           END-IF.

       XXX-99-LER-COUNTDAT.  EXIT.

       XXX-00-LER-LOGDAT  SECTION.

           READ  LOGDAT  AT  END
                 MOVE  HIGH-VALUES  TO  REG-LOGDAT.

           IF  REG-LOGDAT  NOT  EQUAL  HIGH-VALUES
               ADD  1  TO  IND
               IF  IND  GREATER  1000
                   DISPLAY  '1-ESTOURO TABELA LOGDAT(MAIS DE 1000)'
                   MOVE  '08'  TO  WRK-RC
                   PERFORM  XXX-00-FINALIZAR
               ELSE
                   MOVE  DATADAT  TO  TAB-DATA(IND)
                   MOVE  HORADAT  TO  TAB-HORA(IND)
               END-IF
           END-IF.

       XXX-99-LER-LOGDAT.  EXIT.

       XXX-00-FINALIZAR  SECTION.

           CLOSE  COUNTDAT  LOGDAT.

           MOVE  WRK-RC  TO  RETURN-CODE.

           STOP  RUN.

       XXX-99-FINALIZAR.  EXIT.
