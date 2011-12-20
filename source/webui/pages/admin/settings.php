<?php 

$main = StatusBoard_Main::instance();
$auth = $main->auth();
$config = $main->config();

if ( ! $auth->isAuthenticated() || ! $auth->hasPermission(StatusBoard_Permission::PERM_Administrator)) {
    throw new StatusBoard_Exception_NotAuthorised();
}


?>