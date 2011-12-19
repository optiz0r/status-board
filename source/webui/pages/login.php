<?php

$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();

$authenticated = false;
$authentication_failed = false;

if ($request->exists('do')) {
    $username = StatusBoard_Main::issetelse($_POST['username'], Sihnon_Exception_InvalidParameters);
    $password = StatusBoard_Main::issetelse($_POST['username'], Sihnon_Exception_InvalidParameters);
    
    try {
        $auth->authenticate($username, $password);
        $authenticated = true;
        
        StatusBoard_Page::redirect('home');
        
    } catch (Sihnon_Exception_UnknownUser $e) {
        $authentication_failed = true;
    } catch (Sihnon_Exception_IncorrectPassword $e) {
        $authentication_failed = true;
    }
}

$this->smarty->assign('authentication', $authenticated);
$this->smarty->assign('authentication_failed', $authentication_failed);

?>