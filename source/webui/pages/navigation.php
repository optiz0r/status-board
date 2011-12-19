<?php

$display_login = true;
$display_admin = false;

$auth = StatusBoard_Main::instance()->auth();
if ($auth->isAuthenticated()) {
    $display_login = false;
}

if ($auth->isAdministrator()) {
    $display_admin = true;
}

$this->smarty->assign('display_login', $display_login);
$this->smarty->assign('display_admin', $display_admin);

?>