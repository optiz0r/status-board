<?php

$main = StatusBoard_Main::instance();
$config = $main->config();
$request = $main->request();
$auth = $main->auth();
$home_output = null;

$services = StatusBoard_Service::all();
$this->smarty->assign('services', $services);
$this->smarty->assign('site_title', $config->get('site.title', 'Status Board'));

$sites = StatusBoard_Site::all();
$this->smarty->assign('sites', $sites);

$upcoming_maintenance = StatusBoard_Incident::futureMaintenance();
$this->smarty->assign('upcoming_maintenance', $upcoming_maintenance);

$home_mode = $request->get('by', $config->get('overview.display_mode', 'service'));

$display_admin_links = ($auth->isAuthenticated() && $auth->isAdministrator());

$this->smarty->assign('display_admin_links', $display_admin_links);
$this->smarty->assign('home_mode', $home_mode);
?>
