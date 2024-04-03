*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBEN_PERIOD.....................................*
DATA:  BEGIN OF STATUS_ZBEN_PERIOD                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBEN_PERIOD                   .
CONTROLS: TCTRL_ZBEN_PERIOD
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBEN_PERIOD                   .
TABLES: ZBEN_PERIOD                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
