<?php

class StatusBoard_SiteServiceIncident extends StatusBoard_DatabaseObject {
    
    protected static $table = 'siteserviceincident';
    
    protected $_db_id;
    protected $_db_siteservice;
    protected $_db_incident;
    protected $_db_description;
    protected $_db_ctime;
    
    public static function newFor(StatusBoard_SiteService $siteservice, StatusBoard_Incident $incident, $description, $ctime) {
        $new_ssi = new self();
        $new_ssi->siteservice = $siteservice->id;
        $new_ssi->incident    = $incident->id;
        $new_ssi->description = $description;
        $new_ssi->ctime       = $ctime;
        
        $new_ssi->create();
        
        return $new_ssi;
    }
    
    /**
     * Returns a list of all site-service-incident mappings for the given site-service
     * 
     * @param StatusBoard_SiteService $siteservice
     */
    public static function allForSiteService(StatusBoard_SiteService $siteservice) {
        return static::allFor('siteservice', $siteservice->id);
    }
    
    /**
     * Returns a list of all site-service-incident mappings for the given Incident
     * 
     * @param StatusBoard_Incident $incident
     */
    public static function allForIncident(StatusBoard_Incident $incident) {
        return static::allFor('incident', $incident->id);
    }
    
    
    /**
     * Returns the SiteService object associated with this mapping
     * 
     * @return StatusBoard_SiteService
     */
    public function siteService() {
        return StatusBoard_SiteService::fromId($this->siteservice);
    }
    
    /**
     * Returns the Incident object associated with this mapping
     * 
     * @return StatusBoard_Incident
     */
    public function incident() {
        return StatusBoard_Incident::fromId($this->incident);
    }
    
};

?>