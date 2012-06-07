<?php

class StatusBoard_IncidentStatus extends StatusBoard_DatabaseObject {
    
    protected static $table = 'incidentstatus';

    protected $_db_id;
    protected $_db_incident;
    protected $_db_status;
    protected $_db_description;
    protected $_db_ctime;
        
    public function allForIncident(StatusBoard_Incident $incident) {
        return static::allFor('incident', $incident->id);
    }
    
    public function newForIncident(StatusBoard_Incident $incident, $status, $description, $ctime = null) {
        if ($ctime === null) {
            $ctime = time();
        }
        
        $new_status = new self();
        $new_status->incident = $incident->id;
        $new_status->status = $status;
        $new_status->description = $description;
        $new_status->ctime = $ctime;
        
        $new_status->create();
        
        return $new_status;
    }
    
    /**
     * Resets the ctime to the given value or the current time if not specified
     *
     * @param int $ctime Timestamp to be set. if null, the current time is used.
     */
    public function resetCreationTime($ctime=null) {
        if (! $ctime) {
            $ctime = time();
        }
        
        $this->ctime = $ctime;
        $this->save();
    }
}

?>