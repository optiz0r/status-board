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

$groupname = $request->get('name', 'Sihnon_Exception_InvalidParameters');
$group = null;
try {
    $group = $auth->group($groupname);
} catch (Sihnon_Exception_ResultCountMismatch $e) {
    throw new StatusBoard_Exception_FileNotFound();
}

if ($request->exists('do')) {
    $activity = $request->get('do');
    
    try {
        $csrf->validatePost();

        switch ($activity) {
    
            case 'edit': {
                $description = StatusBoard_Main::issetelse($_POST['description'], 'Sihnon_Exception_InvalidParameters');
                
                try {
                    StatusBoard_Validation_Text::length($description, 1, 255);
                    
                    $group->setDescription($description);
                    $group->save();
                    $messages[] = array(
                        'severity' => 'success',
                        'content'  => 'The group was updated succesfully.',
                    );
                } catch (StatusBoard_Exception_InvalidContent $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The group was not modified due to invalid parameters being passed.',
                    );
                }
            } break;
    
            case 'add-permissions': {
                $permission_ids = StatusBoard_Main::issetelse($_POST['permissions'], 'Sihnon_Exception_InvalidParameters');
                
                foreach ($permission_ids as $permission_id) {
                    try {
                        $permission = $auth->permission($permission_id);
                        $group->addPermission($permission);
                    } catch (StatusBoard_Exception_InvalidContent $e) {
                        $messages[] = array(
                            'severity' => 'warning',
                            'content'  => 'A permission was not added to the group because a requested object was not found.',
                        );
                    }
                }
                
                $messages[] = array(
                    'severity' => 'success',
                    'content'  => 'The group was updated succesfully.',
                );
            } break;
            
            case 'delete-permission': {
                $permission_id = $request->get('id', 'Sihnon_Exception_InvalidParameters');
                
                try {
                    $permission = $auth->permission($permission_id);
                    $group->removePermission($permission);
                    
                    $messages[] = array(
                        'severity' => 'success',
                        'content'  => 'The group was updated succesfully.',
                    );
                } catch (StatusBoard_Exception_InvalidContent $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The group was not modified due to invalid parameters being passed.',
                    );
                }
            } break;
                        
            case 'delete-group': {
                try {
                    $group->delete();
                    
                    $messages[] = array(
                        'severity' => 'success',
                        'content'  => 'The group was deleted successfully.',
                    );
                } catch (StatusBoard_Exception_ResultCountMismatch $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The group was not deleted as the object requested could not be found.',
                    );
                }
                
                $session->set('messages', $messages);
                StatusBoard_Page::redirect("admin/tab/groups/");
            } break;
            
            default: {
                $messages[] = array(
                    'severity' => 'warning',
                    'content'  => "The activity '{$activity}' is not supported.",
                );
            }
        }
    
        $session->set('messages', $messages);
        $groupname_safe = urlencode($group->name());
        StatusBoard_Page::redirect("admin/group/name/{$groupname_safe}/");
    } catch (SihnonFramework_Exception_CSRFVerificationFailure $e) {
        $messages[] = array(
            'severity' => 'error',
            'content'  => 'The group was not modified due to a problem with your session; please try again.',
        );
    }
}
    

$this->smarty->assign('group', $group);
$this->smarty->assign('permissions', $group->permissions());
$this->smarty->assign('messages', $messages);
$this->smarty->assign('csrftoken', $csrf->generate());

?>