<?php
$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();

$service_id = $request->get('service', 'Sihnon_Exception_InvalidParameters');
$site_id = $request->get('id', 'Sihnon_Exception_InvalidParameters');

$start = $request->get('start');
$end = $request->get('end');

$service = null;
$site = null;

try {
    $service = StatusBoard_Service::fromId($service_id);
    $site = StatusBoard_Site::fromId($site_id);
} catch (Sihnon_Exception_ResultCountMismatch $e) {
    throw new StatusBoard_Exception_FileNotFound();
}

$services = StatusBoard_Service::all();

$this->smarty->assign('service', $service);
$this->smarty->assign('site', $site);
$this->smarty->assign('start', $start);
$this->smarty->assign('end', $end);

$display_admin_links = ($auth->isAuthenticated() && $auth->isAdministrator());
$this->smarty->assign('display_admin_links', $display_admin_links);

?>