<?php

$services = StatusBoard_Service::all();

for ($i = 1; $i <= 6; ++$i){
    $day = 'day'.$i;
    $date = date("M. d", strtotime("-{$i}day"));
    
    $this->smarty->assign($day, $date);
}

$this->smarty->assign('services', $services);

?>