<?php

$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();
$session = $main->session();
$csrf = new StatusBoard_CSRF();

if ( ! $auth->isAuthenticated() || ! $auth->hasPermission(StatusBoard_Permission::PERM_ManageUsers)) {
    throw new StatusBoard_Exception_NotAuthorised();
}

$activity = null;
$messages = array();

$username = $request->get('username', 'Sihnon_Exception_InvalidParameters');
$user = null;
try {
    $user = $auth->user($username);
} catch (Sihnon_Exception_ResultCountMismatch $e) {
    throw new StatusBoard_Exception_FileNotFound();
}

if ($request->exists('do')) {
    $activity = $request->get('do');
    
    try {
        $csrf->validatePost();

        switch ($activity) {
    
            case 'edit': {
                $fullname = StatusBoard_Main::issetelse($_POST['name'], 'Sihnon_Exception_InvalidParameters');
                $email = StatusBoard_Main::issetelse($_POST['email'], 'Sihnon_Exception_InvalidParameters');
                
                try {
                    StatusBoard_Validation_Text::length($fullname, 1, 255);
                    if ($email) {
                        StatusBoard_Validation_Text::email($email);
                    } else {
                        $email = null;
                    }
                    
                    $user->setRealName($fullname);
                    $user->setEmailAddress($email);
                    $user->save();
                    $messages[] = array(
                        'severity' => 'success',
                        'content'  => 'The user was updated succesfully.',
                    );
                } catch (StatusBoard_Exception_InvalidContent $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The service was not modified due to invalid parameters being passed.',
                    );
                }            
            } break;
            
            case 'password-reset':{
                $password = StatusBoard_Main::issetelse($_POST['password'], 'SihnonFramework_Exception_InvalidParameters');
                $confirm = StatusBoard_Main::issetelse($_POST['confirm'], 'SihnonFramework_Exception_InvalidParameters');
                
                if ($password == $confirm) {
                    $user->changePassword($password);
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
            } break;

            case 'delete-user': {
                try {
                    $user->delete();
                    
                    $messages[] = array(
                        'severity' => 'success',
                        'content'  => 'The user was updated succesfully.',
                    );
                } catch (StatusBoard_Exception_ResultCountMismatch $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The user was not removed as the object requested could not be found.',
                    );
                }
            } break;
            
            default: {
                $messages[] = array(
                    'severity' => 'warning',
                    'content'  => "The activity '{$activity}' is not supported.",
                );
            }
        }
    
        $session->set('messages', $messages);
        $username_safe = urlencode($user->username());
        StatusBoard_Page::redirect("admin/user/username/{$username_safe}/");
    } catch (SihnonFramework_Exception_CSRFVerificationFailure $e) {
        $messages[] = array(
            'severity' => 'error',
            'content'  => 'The service was not modified due to a problem with your session; please try again.',
        );
    }
}
    

$this->smarty->assign('user', $user);
$this->smarty->assign('messages', $messages);
$this->smarty->assign('csrftoken', $csrf->generate());

?>