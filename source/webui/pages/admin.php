<?php

$main = StatusBoard_Main::instance();
$auth = $main->auth();

$services = StatusBoard_Service::all();
$this->smarty->assign('services', $services);

$users = $auth->listUsers();
$this->smarty->assign('users', $users);
?>