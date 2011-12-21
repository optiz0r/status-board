<?php

$services = StatusBoard_Service::all();
$this->smarty->assign('services', $services);

?>