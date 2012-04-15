<?php

class StatusBoard_Service extends StatusBoard_DatabaseObject {
    
    protected static $table = 'service';
    
    protected $_db_id;
    protected $_db_name;
    protected $_db_description;
    
    protected $siteservices = null;
    protected $sites = null;
    protected $incidents_open = null;
    
    public static function allForSite(StatusBoard_Site $site) {
        $site_services = StatusBoard_SiteService::allForSite($site);
        
        $services = array();
        foreach ($site_services as $site_service) {
            $services[] = $site_service->service();
        } 
        
        return $services;
    } 
    
    public function unusedSites() {
        return StatusBoard_Site::unusedBy($this);
    }
    
    public static function unusedBy(StatusBoard_Site $site) {
        return static::allFor('site', $site->id, 'service_unmatchedsites');
    }
    
    public static function newFor(array $sites, $name, $description) {
        $new_service = new self();
        $new_service->name = $name;
        $new_service->description = $description;
        
        $new_service->create();
        
        $new_service->siteservices = array();
        foreach ($sites as $site) {
            $new_service->siteservices[] = StatusBoard_SiteService::newFor($new_service, $site);
        }
        
        return $new_service;
    }
    
    /**
     * Returns the list of SiteService mappings for this service
     * 
     * @return array(StatusBoard_SiteService)
     */
    public function siteInstances() {
        return StatusBoard_SiteService::allForService($this);    
    }
    
    public function siteInstance(StatusBoard_Site $site) {
        return StatusBoard_SiteService::fromSiteService($this, $site);
    }
       
    public function sites($ignore_cache = false) {
        if ($this->sites === null || $ignore_cache) {
            $this->sites = StatusBoard_Site::allForService($this);
        }
        
        return $this->sites;
    }
    
    public static function count() {
        $database = StatusBoard_Main::instance()->database();
        $row = $database->selectOne('SELECT COUNT(*) AS `service_count` FROM `service`');
        return $row['service_count'];
    }

    public function openIncidents($ignore_cache = false) {
        if ($this->incidents_open === null || $ignore_cache) {
            $this->incidents_open = StatusBoard_Incident::openForService($this);
        }
    
        return $this->incidents_open;
    }
    
    public function openIncidentsDuring($start, $end) {
        return StatusBoard_Incident::openForServiceDuring($this, $start, $end);
    }
    
    public function status() {
        return StatusBoard_Incident::highestSeverityStatus($this->openIncidents());
    }
    
}

?>