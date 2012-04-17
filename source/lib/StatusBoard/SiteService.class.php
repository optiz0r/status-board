<?php

class StatusBoard_SiteService extends StatusBoard_DatabaseObject {
    
    protected static $table = 'siteservice';
    
    protected $_db_id;
    protected $_db_service;
    protected $_db_site;
    
    protected $incidents_open = null;
    
    public static function newFor(StatusBoard_Service $service, StatusBoard_Site $site) {
        $new_ss = new self();
        $new_ss->service = $service->id;
        $new_ss->site    = $site->id;
        
        $new_ss->create();
        
        return $new_ss;
    }
    
    /**
     * Returns a list of all site-service mappings for the given Site
     * 
     * @param StatusBoard_Site $site
     */
    public static function allForSite(StatusBoard_Site $site) {
        return static::allFor('site', $site->id);
    }
    
    /**
     * Returns a list of all site-service mappings for the given Site
     * 
     * @param StatusBoard_Service $service
     */
    public static function allForService(StatusBoard_Service $service) {
        return static::allFor('service', $service->id);
    }
    
    /**
     * Returns a list of all site-service mappings affected by the given Incident
     * 
     * @param StatusBoard_Incident $incident)
     * @return array(StatusBoard_SiteService
     */
    public static function allForIncident(StatusBoard_Incident $incident) {
        return static::allFor('incident', $incident->id, 'siteservice_incident');
    }
    
    /**
     * Returns the Site object associated with this mapping
     * 
	 * @return StatusBoard_Site
     */
    public function site() {
        return StatusBoard_Site::fromId($this->site);
    }
    
    /**
     * Returns a site-service mapping given the Site and Service objects
     *
     * @param StatusBoard_Service $service
     * @param StatusBoard_Site $site
     * @return StatusBoard_SiteService
    */
    public static function fromSiteService(StatusBoard_Service $service, StatusBoard_Site $site) {
        return static::from(array('site', 'service'), array($site->id, $service->id));
    }
    
    /**
     * Returns the Service object associated with this mapping
     * 
     * @return StatusBoard_Service
     */
    public function service() {
        return StatusBoard_Service::fromId($this->service);
    }
    
    public function openIncidents($ignore_cache = false) {
        if ($this->incidents_open === null || $ignore_cache) {
            $this->incidents_open = StatusBoard_Incident::openForSiteService($this);
        }
    
        return $this->incidents_open;
    }
    
    public function openIncidentsDuring($start, $end) {
        return StatusBoard_Incident::openForSiteServiceDuring($this, $start, $end);
    }
    
    public function status() {
        return StatusBoard_Incident::highestSeverityStatus($this->openIncidents());
    }
    
};

?>