<?php

$main   = StatusBoard_Main::instance();
$config = $main->config();

$this->smarty->assign('display_exceptions', $config->get('debug.display_exceptions'));
$this->smarty->assign('exception', $exception);
$this->smarty->assign('exception_type', get_class($exception));

?>