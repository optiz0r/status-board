<?php

class StatusBoard_Incident {

    protected $id;
    protected $site;
    protected $reference;
    protected $description;
    protected $start_time;
    protected $estimated_end_time;
    protected $actual_end_time;

    protected function __construct($id, $site, $reference, $description, $start_time, $estimated_end_time, $actual_end_time) {
        $this->id = $id;
        $this->site = $site;
        $this->reference = $reference;
        $this->description = $description;
        $this->start_time = $start_time;
        $this->estimated_end_time = $estimated_end_time;
        $this->actual_end_time = $actual_end_time;
    }
    
    public static function fromDatabaseRow($row) {
        return new self(
            $row['id'],
            $row['site'],
            $row['reference'],
            $row['description'],
            $row['start_time'],
            $row['estimated_end_time'],
            $row['actual_end_time']
        );
    }
    
    /**
     * Load an Incident object given its ID
     *
     * @param int $id
     * @return StatusBoard_Incident
     */
    public static function fromId($id) {
        $database = StatusBoard_Main::instance()->database();
    
        $incident = self::fromDatabaseRow(
            $database->selectOne('SELECT * FROM `incident` WHERE id=:id', array(
                    array('name' => 'id', 'value' => $id, 'type' => PDO::PARAM_INT)
                )
            )
        );
    
        return $incident;
    }
    
    public static function all() {
        $incidents = array();
    
        $database = StatusBoard_Main::instance()->database();
        foreach ($database->selectList('SELECT * FROM `incident` WHERE `id` > 0 ORDER BY `id` DESC') as $row) {
            $incidents[] = self::fromDatabaseRow($row);
        }
    
        return $incidents;
    }
    
    public static function open_for_site(StatusBoard_Site $site) {
        $incidents = array();
        
        $database = StatusBoard_Main::instance()->database();
        foreach ($database->selectList('SELECT * FROM `incident_open` WHERE `site`=:site ORDER BY `id` DESC', array(
                array('name' => 'site', 'value' => $site->id(), 'type' => PDO::PARAM_INT),
            )) as $row) {
            $incidents[] = self::fromDatabaseRow($row);
        }
        
        return $incidents;        
    }
    
    public function status() {
        $database = StatusBoard_Main::instance()->database();
        $row = $database->selectOne('SELECT `status` FROM `incidentstatus_current` WHERE `incident`=:incident', array(
                array('name' => 'incident', 'value' => $this->id(), 'type' => PDO::PARAM_INT),
            )
        );
        
        return $row['status'];
    }
    
    protected function create() {
        $database = StatusBoard_Main::instance()->database();
        $database->insert(
        	'INSERT INTO `service` 
        	(`id`, `site`, `reference`, `description`, `start_time`, `estimated_end_time`, `actual_end_time`)
        	VALUES(NULL, :site, :reference, :description, :start_time, :estimated_end_time, :actual_end_time)',
            array(
                array('name' => 'site',        		  'value' => $this->site,        		'type' => PDO::PARAM_INT),
                array('name' => 'reference',   		  'value' => $this->reference,   		'type' => PDO::PARAM_STR),
                array('name' => 'description', 		  'value' => $this->description, 		'type' => PDO::PARAM_STR),
                array('name' => 'start_time',         'value' => $this->start_time, 		'type' => PDO::PARAM_INT),
                array('name' => 'estimated_end_time', 'value' => $this->estimated_end_time, 'type' => PDO::PARAM_INT),
                array('name' => 'actual_end_time', 	  'value' => $this->actual_end_time, 	'type' => PDO::PARAM_INT),
        )
        );
    
        $this->id = $database->lastInsertId();
    }
    
    public function delete() {
        $database = StatusBoard_Main::instance()->database();
        $database->update(
            'DELETE FROM `incident` WHERE `id`=:id LIMIT 1',
            array(
                array('name' => 'id', 'value' => $this->id, 'type' => PDO::PARAM_INT),
            )
        );
    
        $this->id = null;
    }
    
    public function id() {
        return $this->id;
    }
    
    public function site() {
        return $this->site;
    }
    
    public function reference() {
        return $this->reference;
    }
    
    public function description() {
        return $this->description;
    }
    
    public function start_time() {
        return $this->start_time;
    }
    
    public function estimated_end_time() {
        return $this->estimated_end_time;
    }
    
    public function actual_end_time() {
        return $this->actual_end_time;
    }
    
}

?>
