<?php
$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();

$service_id = $request->get('service', null);
$site_id = $request->get('site', null);

$service = null;
$site = null;
$siteservice = null;

if ($service_id != null) {
	try {
	    $service = StatusBoard_Service::fromId($service_id);
	} catch (Sihnon_Exception_ResultCountMismatch $e) {
	    throw new StatusBoard_Exception_FileNotFound();
	}
}
if ($site_id != null){
	try {
	    $site = StatusBoard_Site::fromId($site_id);
		} 
	catch (Sihnon_Exception_ResultCountMismatch $e) {
	    throw new StatusBoard_Exception_FileNotFound();
	}
}
if ($site && $service) {
    try {
        $siteservice = StatusBoard_SiteService::fromSiteService($service, $site);
        } 
    catch (Sihnon_Exception_ResultCountMismatch $e) {
        throw new StatusBoard_Exception_FileNotFound();
    }
}

if ( ! $site && ! $service) {
    throw new StatusBoard_Exception_FileNotFound();
}


$this->smarty->assign('service', $service);
$this->smarty->assign('site', $site);
$this->smarty->assign('siteservice', $siteservice);

$this->smarty->assign('start', $request->get('start'));
$this->smarty->assign('end', $request->get('end'));

$display_admin_links = ($auth->isAuthenticated() && $auth->isAdministrator());
$this->smarty->assign('display_admin_links', $display_admin_links);

?>