<?php

$services = StatusBoard_Service::all();

for ($i = 1; $i <= 6; ++$i){
    $tbl_header_date[] = date("M. d", strtotime("-{$i}day"));   
}
$this->smarty->assign('days', $tbl_header_date);
$this->smarty->assign('services', $services);
$this->smarty->assign('requested_page', $this->page);

?>