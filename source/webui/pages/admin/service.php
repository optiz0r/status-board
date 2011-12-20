<?php

$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();

if ( ! $auth->isAuthenticated() || ! $auth->hasPermission(StatusBoard_Permission::PERM_UpdateStatusBoards)) {
    throw new StatusBoard_Exception_NotAuthorised();
}

$service_id = $request->get('id', 'Sihnon_Exception_InvalidParameters');
$service = null;
try {
    $service = StatusBoard_Service::fromId($service_id);
} catch (Sihnon_Exception_ResultCountMismatch $e) {
    throw new StatusBoard_Exception_FileNotFound();
}

$sites = $service->sites();

$this->smarty->assign('service', $service);
$this->smarty->assign('sites', $sites);

?>