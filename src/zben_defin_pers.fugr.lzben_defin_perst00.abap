*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBEN_DEFIN_PERS.................................*
DATA:  BEGIN OF STATUS_ZBEN_DEFIN_PERS               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBEN_DEFIN_PERS               .
CONTROLS: TCTRL_ZBEN_DEFIN_PERS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBEN_DEFIN_PERS               .
TABLES: ZBEN_DEFIN_PERS                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
