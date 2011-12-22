<?php

$config = StatusBoard_Main::instance()->config();

$services = StatusBoard_Service::all();
$this->smarty->assign('services', $services);

$this->smarty->assign('site_title', $config->get('site.title', 'Status Board'));

?>