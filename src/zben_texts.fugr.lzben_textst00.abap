*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBEN_TEXTS......................................*
DATA:  BEGIN OF STATUS_ZBEN_TEXTS                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBEN_TEXTS                    .
CONTROLS: TCTRL_ZBEN_TEXTS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBEN_TEXTS                    .
TABLES: ZBEN_TEXTS                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
