<?php

class StatusBoard_IncidentStatus extends StatusBoard_DatabaseObject {
    
    protected static $table = 'incidentstatus';

    protected $_db_id;
    protected $_db_incident;
    protected $_db_status;
    protected $_db_description;
    protected $_db_ctime;
        
    protected function all_for_incident(StatusBoard_Incident $incident) {
        return static::all_for('incident', $incident->id);
    }
}

?>