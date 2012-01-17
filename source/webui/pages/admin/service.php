<?php

$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();
$session = $main->session();
$csrf = new StatusBoard_CSRF();

if ( ! $auth->isAuthenticated() || ! $auth->hasPermission(StatusBoard_Permission::PERM_UpdateStatusBoards)) {
    throw new StatusBoard_Exception_NotAuthorised();
}

$activity = null;
$messages = array();

$service_id = $request->get('id', 'Sihnon_Exception_InvalidParameters');
$service = null;
try {
    $service = StatusBoard_Service::fromId($service_id);
} catch (Sihnon_Exception_ResultCountMismatch $e) {
    throw new StatusBoard_Exception_FileNotFound();
}

if ($request->exists('do')) {
    $activity = $request->get('do');
    
    try {
        $csrf->validatePost();

        switch ($activity) {
    
            case 'edit': {
                $name = StatusBoard_Main::issetelse($_POST['name'], 'Sihnon_Exception_InvalidParameters');
                $description = StatusBoard_Main::issetelse($_POST['description'], 'Sihnon_Exception_InvalidParameters');
                
                try {
                    StatusBoard_Validation_Text::length($name, 1, 255);
                    
                    $service->name = $name;
                    $service->description = $description;
                    $service->save();
                    $messages[] = array(
                        'severity' => 'success',
                        'content'  => 'The service was updated succesfully.',
                    );
                } catch (StatusBoard_Exception_InvalidContent $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The service was not modified due to invalid parameters being passed.',
                    );
                }            
            } break;        
            
            case 'add-site': {
                $name = StatusBoard_Main::issetelse($_POST['name'], 'Sihnon_Exception_InvalidParameters');
                $description = StatusBoard_Main::issetelse($_POST['description'], 'Sihnon_Exception_InvalidParameters');
    
                try {
                    StatusBoard_Validation_Text::length($name, 1, 255);
                    
                    $site = $service->newSite($name, $description);
                    
                    $messages[] = array(
                        'severity' => 'success',
                        'content'  => 'The site was created succesfully.',
                    );
                } catch (StatusBoard_Exception_InvalidContent $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The site was not added due to invalid parameters being passed.',
                    );
                }
           
            } break;
    
            case 'delete-site': {
                $site_id = $request->get('site', 'Sihnon_Exception_InvalidParameters');
                
                try {
                    $site = StatusBoard_Site::fromId($site_id);
                    $site->delete();
                    
                    $messages[] = array(
                        'severity' => 'success',
                        'content'  => 'The Site was deleted successfully.',
                    );
                } catch (Sihnon_Exception_ResultCountMismatch $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The Site was not deleted as the object requested could not be found.',
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
        StatusBoard_Page::redirect("admin/service/id/{$service->id}/");
    } catch (SihnonFramework_Exception_CSRFVerificationFailure $e) {
        $messages[] = array(
            'severity' => 'error',
            'content'  => 'The incident was not created due to a problem with your session; please try again.',
        );
    }
}
    

$sites = $service->sites();

$this->smarty->assign('service', $service);
$this->smarty->assign('sites', $sites);
$this->smarty->assign('messages', $messages);
$this->smarty->assign('csrftoken', $csrf->generate());

?>