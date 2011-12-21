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
        $new_service = new self();
        $new_service->service = $service->id;
        $new_service->name = $name;
        $new_service->description = $description;
        
        $new_service->create();
        
        return $new_service;
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
    
}

?>