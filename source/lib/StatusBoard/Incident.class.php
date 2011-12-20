<?php

class StatusBoard_Incident extends StatusBoard_DatabaseObject {
    
    protected static $table = 'incident';

    protected $_db_id;
    protected $_db_site;
    protected $_db_reference;
    protected $_db_description;
    protected $_db_start_time;
    protected $_db_estimated_end_time;
    protected $_db_actual_end_time;
    
    protected $current_status = null;
    protected $statuses = null;

    public static function open_for_site(StatusBoard_Site $site) {
        return static::all_for('site', $site->id, 'incident_open');
    }
    
    public function currentStatus($ignore_cache = false) {
        if ($this->current_status === null || $ignore_cache) {
            $database = StatusBoard_Main::instance()->database();
            $row = $database->selectOne('SELECT `status` FROM `incidentstatus_current` WHERE `incident`=:incident', array(
                    array('name' => 'incident', 'value' => $this->id, 'type' => PDO::PARAM_INT),
                )
            );
        
            $this->current_status = $row['status'];
        }
        
        return $this->current_status;
    }
    
    /**
     * Returns the status of the most severe incident in the given set
     * 
     * @param array(StatusBoard_Incident) $incidents
     */
    public static function highestSeverityStatus(array $incidents) {
        if ( ! $incidents) {
            return StatusBoard_Status::STATUS_Resolved;
        }
        
        // Check for the highest severity incident.
        $status = StatusBoard_Status::STATUS_Maintenance;
        foreach ($incidents as $incident) {
            $incident_status = $incident->currentStatus();
            if (StatusBoard_Status::isMoreSevere($status, $incident_status)) {
                $status = $incident_status;
            }
        }
        
        return $status;
    }
    
    public function statusChanges($ignore_cache = false) {
        if ($this->statuses === null || $ignore_cache) {
            $this->statuses = StatusBoard_IncidentStatus::all_for('incident', $this->id);
        }
        
        return $this->statuses;
    }
    
}

?>