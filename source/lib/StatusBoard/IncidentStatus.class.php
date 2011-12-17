<?php

class StatusBoard_IncidentStatus {

    protected $id;
    protected $incident;
    protected $status;
    protected $ctime;
    
    protected function __construct($id, $incident, $status, $ctime) {
        $this->id = $id;
        $this->incident = $incident;
        $this->status = $status;
        $this->ctime = $ctime;
    }
    
    /**
    * Load an Incident object given its ID
    *
    * @param int $id
    * @return StatusBoard_Incident
    */
    public static function fromId($id) {
        $database = StatusBoard_Main::instance()->database();
    
        $incident_status = self::fromDatabaseRow(
            $database->selectOne('SELECT * FROM `incidentstatus` WHERE id=:id', array(
                    array('name' => 'id', 'value' => $id, 'type' => PDO::PARAM_INT)
                )
            )
        );
    
        return $incident_status;
    }
    
    protected function create() {
        $database = StatusBoard_Main::instance()->database();
        $database->insert(
        	'INSERT INTO `incidentstatus` 
        	(`id`, `incident`, `status`, `ctime`)
        	VALUES(NULL, :incident, :status, :ctime)',
            array(
                array('name' => 'incident', 'value' => $this->incident, 'type' => PDO::PARAM_INT),
                array('name' => 'status',   'value' => $this->status,   'type' => PDO::PARAM_STR),
                array('name' => 'ctime', 	'value' => $this->ctime, 	'type' => PDO::PARAM_STR),
            )
        );
    
        $this->id = $database->lastInsertId();
    }
    
    public function delete() {
        $database = StatusBoard_Main::instance()->database();
        $database->update(
            'DELETE FROM `incidentstatus` WHERE `id`=:id LIMIT 1',
            array(
                array('name' => 'id', 'value' => $this->id, 'type' => PDO::PARAM_INT),
            )
        );
    
        $this->id = null;
    }
    
    public function id() {
        return $this->id;
    }
    
    public function incident() {
        return $this->incident;
    }
    
    public function status() {
        return $this->status;
    }
    
    public function ctime() {
        return $this->ctime;
    }

    
}

?>