<?php

class StatusBoard_Service extends StatusBoard_DatabaseObject {
    
    protected static $table = 'service';
    
    protected $_db_id;
    protected $_db_name;
    protected $_db_description;
    
    protected $sites = null;
       
    public function sites($ignore_cache = false) {
        if ($this->sites === null || $ignore_cache) {
            $this->sites = StatusBoard_Site::all_for_service($this);
        }
        
        return $this->sites;
    }

    
}

?>