<?php

class StatusBoard_IncidentStatus extends StatusBoard_DatabaseObject {
    
    protected static $table = 'incidentstatus';

    protected $_db_id;
    protected $_db_incident;
    protected $_db_status;
    protected $_db_ctime;
        
}

?>