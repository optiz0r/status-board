<?php

class StatusBoard_Site extends StatusBoard_DatabaseObject {
    
    protected static $table = 'site';
    
    protected $_db_id;
    protected $_db_name;
    protected $_db_description;
    
    protected $siteservices = null;
    protected $services = null;
    protected $incidents = null;
    protected $incidents_open = null;
    
    public static function allForService(StatusBoard_Service $service) {
        $site_services = StatusBoard_SiteService::allForService($service);
        
        $sites = array();
        foreach ($site_services as $site_service) {
            $sites[] = $site_service->site();
        } 
        
        return $sites;
    }
    
    public function unusedServices() {
        return StatusBoard_Service::unusedBy($this);
    }
    
    public static function unusedBy(StatusBoard_Service $service) {
        return static::allFor('service', $service->id, 'site_unmatchedservices', null, null, 'name', static::ORDER_ASC);
    }
    
    public static function unusedByIncident(StatusBoard_Incident $incident) {
        return static::allFor('incident', $incident->id, 'site_unmatchedincidents', null, null, 'name', static::ORDER_ASC);
    }
    
    public static function unusedByServiceIncident(StatusBoard_Service $service, StatusBoard_Incident $incident) {
        return static::allFor(array('service', 'incident'), array($service->id, $incident->id), 'site_unmatchedserviceincidents', null, null, 'name', static::ORDER_ASC);
    }
    
    public static function newFor(array $services, $name, $description) {
        $new_site = new self();
        $new_site->name = $name;
        $new_site->description = $description;
        
        $new_site->create();
        
        $new_site->siteservices = array();
        foreach ($services as $service) {
            $new_site->siteservices[] = StatusBoard_SiteService::newFor($service, $new_site);
        }
        
        return $new_site;
    }
    
    public function newIncident($reference, $description, $status, $start_time, $estimated_end_time) {
        return StatusBoard_Incident::newForSite($this, $reference, $description, $status, $start_time, $estimated_end_time);
    }
    
    /**
     * Returns the list of SiteService mappings for this site
     * 
     * @return array(StatusBoard_SiteService)
     */
    public function serviceInstances() {
        return StatusBoard_SiteService::allForSite($this);    
    }
       
    /**
     * Returns a list of all Services associated with this Site
     * 
     * @param bool $ignore_cache
     */
    public function services($ignore_cache = false) {
        if ($this->services === null || $ignore_cache) {
            $this->services = StatusBoard_Service::allForSite($this);
        }
        
        return $this->services;
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