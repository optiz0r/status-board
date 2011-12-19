<?php

$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();

$activity = null;
$success = true;
$errors = array();
$successes = array();

if ($request->exists('do')) {
    $activity = $request->get('do');
    switch ($activity) {
        
        case 'change-password': {
            $current_password = StatusBoard_Main::issetelse($_POST['currentpassword'], 'Sihnon_Exception_InvalidParameters');
            $new_password = StatusBoard_Main::issetelse($_POST['newpassword'], 'Sihnon_Exception_InvalidParameters');
            $confirm_password = StatusBoard_Main::issetelse($_POST['confirmpassword'], 'Sihnon_Exception_InvalidParameters');
            
            $user = $auth->authenticatedUser();
            if ($user->checkPassword($current_password)) {
                if ($new_password == $confirm_password) {
                    $auth->changePassword($new_password);
                    $successes[] = 'The password has been changed successfully.';
                } else {
                    $success = false;
                    $errors[] = 'The passwords did not match.';
                }                
            } else {
                $success = false;
                $errors[] = 'The current password was incorrect.';
            }
        } break;
        
        default: {
            $success = false;
            $errors[] = "The activity '{$activity}' was not recognised.";
        } break;
    }
}

$this->smarty->assign('activity', $activity);
$this->smarty->assign('successes', $successes);
$this->smarty->assign('errors', $errors);
$this->smarty->assign('requested_page', $this->page);

?>