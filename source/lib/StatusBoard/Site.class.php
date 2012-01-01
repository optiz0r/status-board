<?php

class StatusBoard_Site extends StatusBoard_DatabaseObject {
    
    protected static $table = 'site';
    
    protected $_db_id;
    protected $_db_service;
    protected $_db_name;
    protected $_db_description;
    
    protected $incidents = null;
    protected $incidents_open = null;
    
    public static function allForService(StatusBoard_Service $service) {
        return static::allFor('service', $service->id);
    } 
    
    public static function newSiteForService(StatusBoard_Service $service, $name, $description) {
        $new_site = new self();
        $new_site->service = $service->id;
        $new_site->name = $name;
        $new_site->description = $description;
        
        $new_site->create();
        
        return $new_site;
    }
    
    public function newIncident($reference, $description, $status, $start_time, $estimated_end_time) {
        return StatusBoard_Incident::newForSite($this, $reference, $description, $status, $start_time, $estimated_end_time);
    }
    
    public function openIncidents($ignore_cache = false) {
        if ($this->incidents_open === null || $ignore_cache) {
            $this->incidents_open = StatusBoard_Incident::openForSite($this);
        }
        
        return $this->incidents_open;
    }
    
    public function openIncidentsDuring($start, $end) {
        return StatusBoard_Incident::openForSiteDuring($this, $start, $end);
    }
    
    public function status() {
        return StatusBoard_Incident::highestSeverityStatus($this->openIncidents());
    }
    
    public static function count() {
        $database = StatusBoard_Main::instance()->database();
        $row = $database->selectOne('SELECT COUNT(*) AS `site_count` FROM `site`');
        return $row['site_count'];
    }

}

?>