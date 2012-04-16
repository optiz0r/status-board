<?php

$main = StatusBoard_Main::instance();
$config = $main->config();
$request = $main->request();
$auth = $main->auth();

$services = StatusBoard_Service::all();
$this->smarty->assign('services', $services);

$sites = StatusBoard_Site::all();
$this->smarty->assign('sites', $sites);

$home_output = $request->get('by');

$display_admin_links = ($auth->isAuthenticated() && $auth->isAdministrator());

$this->smarty->assign('display_admin_links', $display_admin_links);
$this->smarty->assign('home_output', $home_output);
?>
