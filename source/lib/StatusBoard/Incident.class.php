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
    
    public static function newForSite(StatusBoard_Site $site, $reference, $description, $status, $start_time, $estimated_end_time) {
        $new_incident = new self();
        $new_incident->site = $site->id;
        $new_incident->reference = $reference;
        $new_incident->description = $description;
        $new_incident->start_time = $start_time;
        $new_incident->estimated_end_time = $estimated_end_time;
        $new_incident->actual_end_time = null;
        
        $new_incident->create();
        $new_incident->changeStatus($status, 'Initial Classification', $start_time);
        
        return $new_incident;
    }

    public static function openForSite(StatusBoard_Site $site) {
        return static::allFor('site', $site->id, 'incident_open');
    }
    
    public static function openForSiteDuring(StatusBoard_Site $site, $start, $end) {
        $params = array(
            array('name' => 'start', 'value' => $start, 'type' => PDO::PARAM_INT),
            array('name' => 'end',   'value' => $end,   'type' => PDO::PARAM_INT),
        );
        
        return static::allFor('site', $site->id, 'incident_opentimes', '`start_time` < :end AND `ctime` > :start', $params);
    }
    
    public static function allNearDeadline() {
        return static::all('incident_open', "estimated_end_time>=:threshold AND estimated_end_time>=:now", array(
            array('name' => 'threshold', 'value' => time() - StatusBoard_DateTime::HOUR, 'type' => PDO::PARAM_INT),
            array('name' => 'now', 'value' => time(), 'type' => PDO::PARAM_INT),
        ));
    }
    
    public static function allPastDeadline() {
        return static::all('incident_open', "estimated_end_time<=:threshold", array(
            array('name' => 'threshold', 'value' => time(), 'type' => PDO::PARAM_INT),
        ));
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
    
    public function statusAt($time) {
        $database = StatusBoard_Main::instance()->database();
        $row = $database->selectOne('SELECT `status` FROM `incidentstatus` WHERE `incident`=:incident AND `ctime` < :time ORDER BY `ctime` DESC LIMIT 1', array(
                array('name' => 'incident', 'value' => $this->id, 'type' => PDO::PARAM_INT),
                array('name' => 'time',     'value' => $time,     'type' => PDO::PARAM_INT),
            )
        );
        
        return $row['status'];
    }
    
    protected function statusesBetween($start, $end) {
        $database = StatusBoard_Main::instance()->database();
        
        $row = $database->selectList('SELECT `status` FROM `incidentstatus` WHERE `incident`=:incident AND `ctime` >= :start AND `ctime` < :end', array(
                array('name' => 'incident', 'value' => $this->id, 'type' => PDO::PARAM_INT),
                array('name' => 'start',    'value' => $start,    'type' => PDO::PARAM_INT),
                array('name' => 'end',      'value' => $end,      'type' => PDO::PARAM_INT),
            )
        );
        
        return array_map(function($a) {
            return $a['status'];
        }, $row);
    }
    
    /**
     * Returns the status of the most severe incident in the given set
     * 
     * @param array(StatusBoard_Incident) $incidents
     */
    public static function highestSeverityStatus(array $incidents, $time = null) {
        // Check for the highest severity incident.
        $status = StatusBoard_Status::STATUS_Resolved;
        foreach ($incidents as $incident) {
            $incident_status = null;
            if ($time) {
                $incident_status = $incident->statusAt($time);    
            } else {
                $incident_status = $incident->currentStatus();
            }
            
            if (StatusBoard_Status::isMoreSevere($status, $incident_status)) {
                $status = $incident_status;
            }
        }
        
        return $status;
    }
    
    /**
     * Returns the status of the most severe incident in the given set
     * 
     * @param array(StatusBoard_Incident) $incidents
     */
    public static function highestSeverityStatusBetween(array $incidents, $start, $end) {
        // Check for the highest severity incident.
        $most_severe_status = StatusBoard_Status::STATUS_Resolved;
        foreach ($incidents as $incident) {
            $most_severe_incident_status = StatusBoard_Status::STATUS_Resolved;
            
            $statuses_between = $incident->statusesBetween($start, $end);
            foreach ($statuses_between as $status) {
                $most_severe_incident_status = StatusBoard_Status::mostSevere($most_severe_incident_status, $status);
            }
            
            $incident_status_before = StatusBoard_Status::STATUS_Resolved;
            try {
                $incident_status_before = $incident->statusAt($start);
            } catch (SihnonFramework_Exception_ResultCountMismatch $e) {
                // Incident was opened after $start, ignore
            }
            
            $most_severe_incident_status = StatusBoard_Status::mostSevere($incident_status_before, $most_severe_incident_status);
            
            $most_severe_status = StatusBoard_Status::mostSevere($most_severe_status, $most_severe_incident_status);
        }
        
        return $most_severe_status;
    }

    public function statusChanges($ignore_cache = false) {
        if ($this->statuses === null || $ignore_cache) {
            $this->statuses = StatusBoard_IncidentStatus::allFor('incident', $this->id);
        }
        
        return $this->statuses;
    }
    
    public function changeStatus($status, $description, $start_time = null) {
        if ($this->statuses === null) {
            $this->statuses = StatusBoard_IncidentStatus::allFor('incident', $this->id);
        }
        
        $new_status = StatusBoard_IncidentStatus::newForIncident($this, $status, $description, $start_time);
        $this->statuses[] = $new_status;
        
        return $new_status;
    }
    
    public static function counts() {
        $database = StatusBoard_Main::instance()->database();
        $rows = $database->selectList('SELECT `status`, COUNT(*) AS `incident_count` FROM `incidentstatus_current` GROUP BY `status`');
        
        $counts = array();
        foreach (StatusBoard_Status::available() as $status) {
            $counts[$status] = 0;
        }
        foreach ($rows as $row) {
            $counts[$row['status']] = $row['incident_count'];
        }
        
        return $counts;
    }
    
    public static function compareEstimatedEndTimes(StatusBoard_Incident $first, StatusBoard_Incident $second) {
        return $first->estimated_end_time < $second->estimated_end_time;
    }
    
    
}

?>