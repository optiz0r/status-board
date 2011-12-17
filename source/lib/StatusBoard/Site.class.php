<?php

class StatusBoard_Site {
    
    protected $id;
    protected $service;
    protected $name;
    protected $description;
    
    protected function __construct($id, $service, $name, $description) {
        $this->id = $id;
        $this->service = $service;
        $this->name = $name;
        $this->description = $description;
    }
    
    public static function fromDatabaseRow($row) {
        return new self(
            $row['id'],
            $row['service'],
            $row['name'],
            $row['description']
        );
    }
    
    /**
     * Load a Site object given its ID
     *
     * @param int $id
     * @return StatusBoard_Site
     */
    public static function fromId($id) {
        $database = StatusBoard_Main::instance()->database();
    
        $site = self::fromDatabaseRow(
            $database->selectOne('SELECT * FROM `site` WHERE id=:id', array(
                    array('name' => 'id', 'value' => $id, 'type' => PDO::PARAM_INT)
                )
            )
        );
    
        return $site;
    }
    
    public static function all() {
        $sites = array();
    
        $database = StatusBoard_Main::instance()->database();
        foreach ($database->selectList('SELECT * FROM `site` WHERE `id` > 0 ORDER BY `id` DESC') as $row) {
            $sites[] = self::fromDatabaseRow($row);
        }
    
        return $sites;
    }
    
    public function all_for_service(StatusBoard_Service $service) {
        $sites = array();
        
        $database = StatusBoard_Main::instance()->database();
        foreach ($database->selectList('SELECT * FROM `site` WHERE `service`=:service ORDER BY `id` DESC', array(
                array('name' => 'service', 'value' => $service->id(), 'type' => PDO::PARAM_INT),
            )) as $row) {
            $sites[] = self::fromDatabaseRow($row);    
        }
        
        return $sites;
    }
    
    protected function create() {
        $database = StatusBoard_Main::instance()->database();
        $database->insert(
        	'INSERT INTO `service` 
        	(`id`, `service`, `name`, `description`)
        	VALUES(NULL, :service, :name, :description)',
            array(
                array('name' => 'service',     'value' => $this->service,     'type' => PDO::PARAM_INT),
                array('name' => 'name',        'value' => $this->name,        'type' => PDO::PARAM_STR),
                array('name' => 'description', 'value' => $this->description, 'type' => PDO::PARAM_STR),
            )
        );
    
        $this->id = $database->lastInsertId();
    }
    
    public function delete() {
        $database = StatusBoard_Main::instance()->database();
        $database->update(
            'DELETE FROM `site` WHERE `id`=:id LIMIT 1',
            array(
                array('name' => 'id', 'value' => $this->id, 'type' => PDO::PARAM_INT),
            )
        );
    
        $this->id = null;
    }
    
    public function incidents_open() {
        return StatusBoard_Incident::open_for_site($this);
    }
        
    public function id() {
        return $this->id;
    }
    
    public function service() {
        return $this->service;
    }
    
    public function name() {
        return $this->name;
    }
    
    public function description() {
        return $this->description;
    }
    
    
}

?>