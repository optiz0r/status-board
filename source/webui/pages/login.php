<?php

$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();
$log = $main->log();
$csrf = new StatusBoard_CSRF();

$messages = array();

if ($request->exists('do')) {
    $username = StatusBoard_Main::issetelse($_POST['username'], 'Sihnon_Exception_InvalidParameters');
    $password = StatusBoard_Main::issetelse($_POST['password'], 'Sihnon_Exception_InvalidParameters');
    
    try {
        $csrf->validatePost();
        
        $auth->authenticate($username, $password);
        StatusBoard_Page::redirect('home');
        
    } catch (SihnonFramework_Exception_AuthException $e) {
        $messages[] = array(
            'severity' => 'error',
            'content'  => 'The username or password was not recognised.',
        );
    } catch (SihnonFramework_Exception_CSRFVerificationFailure $e) {
        $messages[] = array(
            'severity' => 'error',
            'content'  => 'You could not be logged in due to a problem with your session; please try again.',
        );
    }
}

$this->smarty->assign('messages', $messages);
$this->smarty->assign('csrftoken', $csrf->generate());

?>