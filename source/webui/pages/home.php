<?php

$main = StatusBoard_Main::instance();
$config = $main->config();
$auth = $main->auth();


$services = StatusBoard_Service::all();
$this->smarty->assign('services', $services);

$this->smarty->assign('site_title', $config->get('site.title', 'Status Board'));

$display_admin_links = ($auth->isAuthenticated() && $auth->isAdministrator());
$this->smarty->assign('display_admin_links', $display_admin_links);

?>