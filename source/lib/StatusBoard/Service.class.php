<?php

class StatusBoard_Service {
    
    protected $id;
    protected $name;
    protected $description;
    
    protected function __construct($id, $name, $description) {
        $this->id = $id;
        $this->name = $name;
        $this->description = $description;
    }
    
    public static function fromDatabaseRow($row) {
        return new self(
            $row['id'],
            $row['name'],
            $row['description']
        );
    }
    
	/**
     * Load a Service object given its ID
     *
     * @param int $id
     * @return StatusBoard_Service
     */
    public static function fromId($id) {
        $database = StatusBoard_Main::instance()->database();
    
        $service = self::fromDatabaseRow(
            $database->selectOne('SELECT * FROM `service` WHERE id=:id', array(
                    array('name' => 'id', 'value' => $id, 'type' => PDO::PARAM_INT)
                )
            )
        );
    
        return $service;
    }
    
    public static function all() {
        $services = array();
    
        $database = StatusBoard_Main::instance()->database();
        foreach ($database->selectList('SELECT * FROM `service` WHERE `id` > 0 ORDER BY `id` DESC') as $row) {
            $services[] = self::fromDatabaseRow($row);
        }
    
        return $services;
    }

    protected function create() {
        $database = StatusBoard_Main::instance()->database();
        $database->insert(
        	'INSERT INTO `service` 
        	(`id`, `name`, `description`)
        	VALUES(NULL, :name, :description)',
            array(
                array('name' => 'name',        'value' => $this->name,        'type' => PDO::PARAM_STR),
                array('name' => 'description', 'value' => $this->description, 'type' => PDO::PARAM_STR),
            )
        );
    
        $this->id = $database->lastInsertId();
    }
    
    public function delete() {
        $database = StatusBoard_Main::instance()->database();
        $database->update(
            'DELETE FROM `service` WHERE `id`=:id LIMIT 1',
            array(
                array('name' => 'id', 'value' => $this->id, 'type' => PDO::PARAM_INT),
            )
        );
    
        $this->id = null;
    }
    
    public function sites() {
        return StatusBoard_Site::all_for_service($this);
    }
    
    public function id() {
        return $this->id;
    }
    
    public function name() {
        return $this->name;
    }
    
    public function description() {
        return $this->description;
    }
    
    
}

?>