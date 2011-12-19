<?php

$auth = StatusBoard_Main::instance()->auth();
$auth->deauthenticate();

StatusBoard_Page::redirect('home');

?>