<?php

$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();
$session = $main->session();
$csrf = new StatusBoard_CSRF();

if ( ! $auth->isAuthenticated() || ! $auth->hasPermission(StatusBoard_Permission::PERM_UpdateStatusBoards)) {
    throw new StatusBoard_Exception_NotAuthorised();
}

$messages = array();

$site_id = $request->get('id', 'Sihnon_Exception_InvalidParameters'); 

$site = null;
try {
    $site = StatusBoard_Site::fromId($site_id);
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
                    
                    $site->name = $name;
                    $site->description = $description;
                    $site->save();
                    
                    $messages[] = array(
                        'severity' => 'success',
                        'content'  => 'The site was updated succesfully.',
                    );
                } catch (StatusBoard_Exception_InvalidContent $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The site was not modified due to invalid parameters being passed.',
                    );
                }
    
            } break;
    
            case 'add-services': {
                $service_ids = StatusBoard_Main::issetelse($_POST['services'], 'Sihnon_Exception_InvalidParameters');
                
                try {
                    foreach ($service_ids as $service_id) {
                        try {
                            $service = StatusBoard_Service::fromId($service_id);
                            
                            $new_ss = StatusBoard_SiteService::newFor($service, $site);
                        } catch (StatusBoard_Exception_ResultCountMismatch $e) {
                            $messages[] = array(
                                'severity' => 'warning',
                                'content'  => 'A service was not added as the object requested could not be found.',
                            );
                        }
                    }
                    
                    $messages[] = array(
                        'severity' => 'success',
                        'content'  => 'The site was updated succesfully.',
                    );
                } catch (StatusBoard_Exception_ResultCountMismatch $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The service was not added as the object requested could not be found.',
                    );
                }
            } break;
            
            case 'delete-service': {
                $service_id = $request->get('service', 'Sihnon_Exception_InvalidParameters');
                
                try {
                    $service = StatusBoard_Service::fromId($service_id);
                    $ss = StatusBoard_SiteService::fromSiteService($service, $site);

                    $ss->delete();
                    
                    $messages[] = array(
                                            'severity' => 'success',
                                            'content'  => 'The site was updated succesfully.',
                    );
                } catch (StatusBoard_Exception_ResultCountMismatch $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The service was not removed as the object requested could not be found.',
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
        StatusBoard_Page::redirect("admin/site/id/{$site->id}/");
    } catch (SihnonFramework_Exception_CSRFVerificationFailure $e) {
        $messages[] = array(
            'severity' => 'error',
            'content'  => 'The incident was not created due to a problem with your session; please try again.',
        );
    }
}

$services = $site->services();
$open_incidents = $site->openIncidents();

$this->smarty->assign('site', $site);
$this->smarty->assign('services', $services);
$this->smarty->assign('open_incidents', $open_incidents);
$this->smarty->assign('messages', $messages);
$this->smarty->assign('csrftoken', $csrf->generate());

?>