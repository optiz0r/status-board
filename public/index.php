<?php

define('StatusBoard_File', 'index');

require '_inc.php';

try {
    $main = StatusBoard_Main::instance();
    StatusBoard_LogEntry::setLocalProgname('webui');        	
    $smarty = $main->smarty();
    
    $page = new StatusBoard_Page($smarty, $main->request());
    if ($page->evaluate()) {
        $smarty->display('index.tpl');
    }
    
} catch (StatusBoard_Exception $e) {
    die("Uncaught Exception: " . $e->getMessage());
}

?>