<?php

class StatusBoard_Service extends StatusBoard_DatabaseObject {
    
    protected static $table = 'service';
    
    protected $_db_id;
    protected $_db_name;
    protected $_db_description;
    
    protected $sites = null;
    
    public static function newService($name, $description) {
        $new_service = new self();
        $new_service->name = $name;
        $new_service->description = $description;
        
        $new_service->create();
        
        return $new_service;
    }
    
    public function newSite($name, $description) {
        return StatusBoard_Site::newSiteForService($this, $name, $description);
    }
       
    public function sites($ignore_cache = false) {
        if ($this->sites === null || $ignore_cache) {
            $this->sites = StatusBoard_Site::allForService($this);
        }
        
        return $this->sites;
    }

    
}

?>