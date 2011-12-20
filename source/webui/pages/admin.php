<?php

$main = StatusBoard_Main::instance();
$auth = $main->auth();
$config = $main->config();

if ( ! $auth->isAuthenticated() || ! $auth->hasPermission(StatusBoard_Permission::PERM_Administrator)) {
    throw new StatusBoard_Exception_NotAuthorised();
}

$services = StatusBoard_Service::all();
$this->smarty->assign('services', $services);

$users = $auth->listUsers();
$this->smarty->assign('users', $users);

// Quick Settings
$this->smarty->assign('debug_displayexceptions', $config->get('debug.display_exceptions'));
$this->smarty->assign('cache_basedir', $config->get('cache.base_dir'));
$this->smarty->assign('templates_tmppath', $config->get('templates.tmp_path'));

?>