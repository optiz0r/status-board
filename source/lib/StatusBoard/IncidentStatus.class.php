<?php

class StatusBoard_IncidentStatus extends StatusBoard_DatabaseObject {
    
    protected static $table = 'incidentstatus';

    protected $_db_id;
    protected $_db_incident;
    protected $_db_status;
    protected $_db_description;
    protected $_db_ctime;
        
    public function allForIncident(StatusBoard_Incident $incident) {
        return static::all_for('incident', $incident->id);
    }
    
    public function newForIncident(StatusBoard_Incident $incident, $status, $description) {
        $new_status = new self();
        $new_status->incident = $incident->id;
        $new_status->status = $status;
        $new_status->description = $description;
        $new_status->ctime = time();
        
        $new_status->create();
        
        return $new_status;
    }
}

?>