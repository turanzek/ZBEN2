*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBEN_DEFIN_BEN..................................*
DATA:  BEGIN OF STATUS_ZBEN_DEFIN_BEN                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBEN_DEFIN_BEN                .
CONTROLS: TCTRL_ZBEN_DEFIN_BEN
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBEN_DEFIN_BEN                .
TABLES: ZBEN_DEFIN_BEN                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
