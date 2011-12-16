<?php

if (isset($_SERVER['STATUSBOARD_CONFIG']) && 
    file_exists($_SERVER['STATUSBOARD_CONFIG']) &&
    is_readable($_SERVER['STATUSBOARD_CONFIG'])) {
    require_once($_SERVER['STATUSBOARD_CONFIG']);
} else {
    require_once '/etc/status-board/config.php';
}

require_once SihnonFramework_Lib . 'SihnonFramework/Main.class.php';

SihnonFramework_Main::registerAutoloadClasses('SihnonFramework', SihnonFramework_Lib,
												'StatusBoard', StatusBoard_Lib);

?>
