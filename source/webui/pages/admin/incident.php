<?php

$main = StatusBoard_Main::instance();
$request = $main->request();

$service_id = $request->get('service', 'Sihnon_Exception_InvalidParameters');
$site_id = $request->get('site', 'Sihnon_Exception_InvalidParameters'); 
$incident_id = $request->get('id', 'Sihnon_Exception_InvalidParameters');

$service = null;
$site = null;
$incident = null;

try {
    $service = StatusBoard_Service::fromId($service_id);
    $site = StatusBoard_Site::fromId($site_id);
    $incident = StatusBoard_Incident::fromId($incident_id);
} catch (Sihnon_Exception_ResultCountMismatch $e) {
    StatusBoard_Page::redirect('errors/404');
}

$statuses = $incident->statusChanges();

$this->smarty->assign('service', $service);
$this->smarty->assign('site', $site);
$this->smarty->assign('incident', $incident);
$this->smarty->assign('statuses', $statuses);

?>