<?php

$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();

if ( ! $auth->isAuthenticated() || ! $auth->hasPermission(StatusBoard_Permission::PERM_UpdateStatusBoards)) {
    throw new StatusBoard_Exception_NotAuthorised();
}

$service_id = $request->get('service', 'Sihnon_Exception_InvalidParameters');
$site_id = $request->get('id', 'Sihnon_Exception_InvalidParameters'); 

$service = null;
$site = null;

try {
    $service = StatusBoard_Service::fromId($service_id);
    $site = StatusBoard_Site::fromId($site_id);
} catch (Sihnon_Exception_ResultCountMismatch $e) {
    throw new StatusBoard_Exception_FileNotFound();
}

$open_incidents = $site->openIncidents();

$this->smarty->assign('service', $service);
$this->smarty->assign('site', $site);
$this->smarty->assign('open_incidents', $open_incidents);

?>