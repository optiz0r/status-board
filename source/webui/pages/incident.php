<?php

$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();
$messages = array();

try {
    $incident_id = $request->get('id', 'Sihnon_Exception_InvalidParameters');
    $incident = StatusBoard_Incident::fromId($incident_id);
} catch (Sihnon_Exception_ResultCountMismatch $e) {
    throw new StatusBoard_Exception_FileNotFound();
}

$statuses = $incident->statusChanges();      
$siteserviceincidents = $incident->siteServiceIncidents();
$this->smarty->assign('incident', $incident);
$this->smarty->assign('statuses', $statuses);
$this->smarty->assign('siteserviceincidents', $siteserviceincidents);

$display_admin_links = ($auth->isAuthenticated() && $auth->isAdministrator());
$this->smarty->assign('display_admin_links', $display_admin_links);

?>