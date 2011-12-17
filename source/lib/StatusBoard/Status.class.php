<?php

class StatusBoard_Status {
    
    const STATUS_Resolved    = 0;
    const STATUS_Maintenance = 1;
    const STATUS_Minor       = 2;
    const STATUS_Significant = 3;
    const STATUS_Major       = 4;
    
    protected static $names = array(
        self::STATUS_Resolved    => 'Resolved',
        self::STATUS_Maintenance => 'Planned Maintenance',
        self::STATUS_Minor       => 'Minor Incident',
        self::STATUS_Significant => 'Significant Incident',
        self::STATUS_Major       => 'Major Incident',
    );
    
    protected static $descriptions = array(
        self::STATUS_Resolved    => 'The service is operating normally.',
        self::STATUS_Maintenance => 'The service is undergoing scheduled maintenance.',
        self::STATUS_Minor       => 'The service is exeriencing minor issues affecting some customers.',
        self::STATUS_Significant => 'The service is exeriencing significant issues affecting many customers.',
        self::STATUS_Major       => 'The service is exeriencing a major outage affecting all customers.',
    );

    public static function name($status) {
        if ( ! StatusBoard_Main::isClassConstantValue(get_called_class(), 'STATUS_', $status)) {
            throw new StatusBoard_Exception_InvalidParameters($status);
        }
        
        return self::$names[$status];
    }
    
    public static function description($status) {
        if ( ! StatusBoard_Main::isClassConstantValue(get_called_class(), 'STATUS_', $status)) {
            throw new StatusBoard_Exception_InvalidParameters($status);
        }
        
        return self::$descriptions[$status];
    }
    
}

?>