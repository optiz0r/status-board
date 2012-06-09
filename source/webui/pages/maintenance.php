<?php

$main = StatusBoard_Main::instance();
$auth = $main->auth();
$config = $main->config();
$session = $main->session();
$csrf = new StatusBoard_CSRF();

$display_admin_links = ($auth->isAuthenticated() && $auth->isAdministrator());
$this->smarty->assign('display_admin_links', $display_admin_links);
$this->smarty->assign('future_maintenance', StatusBoard_Incident::futureMaintenance());