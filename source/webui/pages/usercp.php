<?php

$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();
$session = $main->session();
$csrf = new StatusBoard_CSRF();

if ($request->exists('do')) {
    $activity = $request->get('do');
    
    try {
        $csrf->validatePost();
        switch ($activity) {
            
            case 'change-password': {
                $current_password = StatusBoard_Main::issetelse($_POST['currentpassword'], 'Sihnon_Exception_InvalidParameters');
                $new_password = StatusBoard_Main::issetelse($_POST['newpassword'], 'Sihnon_Exception_InvalidParameters');
                $confirm_password = StatusBoard_Main::issetelse($_POST['confirmpassword'], 'Sihnon_Exception_InvalidParameters');
                
                $user = $auth->authenticatedUser();
                if ($user->checkPassword($current_password)) {
                    if ($new_password == $confirm_password) {
                        $auth->changePassword($new_password);
                        $messages[] = array(
                        	'severity' => 'success',
                        	'content'  => 'The password has been changed successfully.',
                        );
                    } else {
                        $messages[] = array(
                        	'severity' => 'error',
                        	'content'  => 'The passwords did not match.',
                        );
                    }                
                } else {
                    $messages[] = array(
                    	'severity' => 'error',
                    	'content'  => 'The current password was incorrect.',
                    );
                }
            } break;
            
            default: {
                $messages[] = array(
                	'severity' => 'error',
                	'content'  => "The activity '{$activity}' was not recognised.",
                );
            } break;
        }
    
        $session->set('messages', $messages);
        StatusBoard_Page::redirect("usercp/");
    } catch (SihnonFramework_Exception_CSRFVerificationFailure $e) {
        $messages[] = array(
            'severity' => 'error',
            'content'  => 'The incident was not created due to a problem with your session; please try again.',
        );
    }
}

$this->smarty->assign('messages', $messages);
$this->smarty->assign('csrftoken', $csrf->generate());

?>