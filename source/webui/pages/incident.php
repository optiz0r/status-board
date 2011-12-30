
<?php
$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();

$incident_id = $request->get('id', 'Sihnon_Exception_InvalidParameters');

try 
	{
    $incident = StatusBoard_Incident::fromId($incident_id);
    $site_id = $incident->site;
    $site = StatusBoard_Site::fromId($site_id);
    $service_id = $site->service;
    $service = StatusBoard_Service::fromId($service_id);
	}
catch (Sihnon_Exception_ResultCountMismatch $e) 
	{
    throw new StatusBoard_Exception_FileNotFound();

	}



$statuses = $incident->statusChanges();


$this->smarty->assign('service', $service);
$this->smarty->assign('site', $site);
$this->smarty->assign('incident', $incident);
$this->smarty->assign('statuses', $statuses);
$this->smarty->assign('messages', $messages);

$display_admin_links = ($auth->isAuthenticated() && $auth->isAdministrator());
$this->smarty->assign('display_admin_links', $display_admin_links);



?>