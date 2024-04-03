*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBEN_CATALOG....................................*
DATA:  BEGIN OF STATUS_ZBEN_CATALOG                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBEN_CATALOG                  .
CONTROLS: TCTRL_ZBEN_CATALOG
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBEN_CATALOG                  .
TABLES: ZBEN_CATALOG                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
