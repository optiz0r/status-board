<?php

$main = StatusBoard_Main::instance();
$auth = $main->auth();
$config = $main->config();
$request = $main->request();
$session = $main->session();
$csrf = new StatusBoard_CSRF();

if ( ! $auth->isAuthenticated() || ! $auth->hasPermission(StatusBoard_Permission::PERM_Administrator)) {
    throw new StatusBoard_Exception_NotAuthorised();
}

$activity = null;
$success = true;
$messages = array();

$destination = $request->get('tab', 'summary');

if ($request->exists('do')) {
    $activity = $request->get('do');
    
    try {
        $csrf->validatePost();

        switch ($activity) {
    
            case 'add-service': {
                $name = StatusBoard_Main::issetelse($_POST['name'], 'Sihnon_Exception_InvalidParameters');
                $description = StatusBoard_Main::issetelse($_POST['description'], 'Sihnon_Exception_InvalidParameters');
                $site_ids = StatusBoard_Main::issetelse($_POST['sites'], array());
    
                try {
                    $sites = array();
                    foreach ($site_ids as $site_id) {
                        $sites[] = StatusBoard_Site::fromId($site_id);
                    }
                    
                    $service = StatusBoard_Service::newFor($sites, $name, $description);
                    
                    $messages[] = array(
                        'severity' => 'success',
                        'content'  => 'The service was created succesfully.',
                    );
                } catch (StatusBoard_Exception_InvalidContent $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The service was not added due to invalid parameters being passed.',
                    );
                }
                
            } break;
            
            case 'delete-service': {
                $service_id = $request->get('id', 'Sihnon_Exception_InvalidParameters');
                
                try {
                    $service = StatusBoard_Service::fromId($service_id);
                    $service->delete();
                    
                    $messages[] = array(
                        'severity' => 'success',
                        'content'  => 'The Service was deleted successfully.',
                    );
                } catch (Sihnon_Exception_ResultCountMismatch $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The Service was not deleted as the object requested could not be found.',
                    );
                }
                
            } break;
            
            case 'add-site': {
                $name = StatusBoard_Main::issetelse($_POST['name'], 'Sihnon_Exception_InvalidParameters');
                $description = StatusBoard_Main::issetelse($_POST['description'], 'Sihnon_Exception_InvalidParameters');
                $service_ids = StatusBoard_Main::issetelse($_POST['services'], array());
    
                try {
                    StatusBoard_Validation_Text::length($name, 1, 255);
                    
                    $services = array();
                    foreach ($service_ids as $service_id) {
                        $services[] = StatusBoard_Service::fromId($service_id);
                    }
                    
                    $site = StatusBoard_Site::newFor($services, $name, $description);
                    
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
                $site_id = $request->get('id', 'Sihnon_Exception_InvalidParameters');
                
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
            
            case 'delete-incident': {
                $incident_id = $request->get('id', 'Sihnon_Exception_InvalidParameters');
                
                try {
                    $incident = StatusBoard_Incident::fromId($incident_id);
                    $incident->delete();
                    
                    $messages[] = array(
                        'severity' => 'success',
                        'content'  => 'The incident was deleted successfully.',
                    );
                } catch (Sihnon_Exception_ResultCountMismatch $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The incident was not deleted as the object requested could not be found.',
                    );
                }
            } break;
    
            case 'save-settings': {
                $supported_settings = array(
                    'site_title' => 'site.title',
                    'debug_display_exceptions' => 'debug.display_exceptions',
                    'incident_reference_default' => 'incident.reference_default',
                    'cache_base_dir' => 'cache.base_dir',
                    'templates_tmp_path' => 'templates.tmp_path',
                    'overview_display_mode' => 'overview.display_mode',
                );
                
                $dirty = false;
                foreach ($supported_settings as $param => $setting) {
                    $value = StatusBoard_Main::issetelse($_POST[$param]);
                    if ($value && $value != $config->get($setting)) {
                        $config->set($setting, $value);
                        $dirty = true;
                    }   
                }
                
                if ($dirty) {
                    $messages[] = array(
                        'severity' => 'success',
                        'content'  => 'Settings were saved successfully.',
                    );
                } else {
                    $messages[] = array(
                        'severity' => 'warning',
                        'content'  => 'Settings were not saved as no changes were necessary.',
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
        
        $destination = "admin/tab/{$destination}/";
        
        $session->set('messages', $messages);
        StatusBoard_Page::redirect($destination);
    } catch (SihnonFramework_Exception_CSRFVerificationFailure $e) {
        $messages[] = array(
            'severity' => 'error',
            'content'  => 'The last action was not taken due to a problem with your session; please try again.',
        );
    }
}

$this->smarty->assign('tab', $destination);

// Summary
$this->smarty->assign('service_count', StatusBoard_Service::count());
$this->smarty->assign('site_count', StatusBoard_Site::count());
$this->smarty->assign('incident_counts', StatusBoard_Incident::counts());

$incidents_near_deadline = StatusBoard_Incident::allNearDeadline();
usort($incidents_near_deadline, array('StatusBoard_Incident', 'compareEstimatedEndTimes'));

$incidents_past_deadline = StatusBoard_Incident::allPastDeadline();
usort($incidents_past_deadline, array('StatusBoard_Incident', 'compareEstimatedEndTimes'));

$this->smarty->assign('incidents_near_deadline', $incidents_near_deadline);
$this->smarty->assign('incidents_past_deadline', $incidents_past_deadline);

// Service, Site and incident
$services = StatusBoard_Service::all();
$this->smarty->assign('services', $services);

$sites = StatusBoard_Site::all();
$this->smarty->assign('sites', $sites);

$open_incidents = StatusBoard_Incident::open();
$this->smarty->assign('open_incidents', $open_incidents);

// User Management
$users = $auth->listUsers();
$this->smarty->assign('users', $users);

// Quick Settings
$this->smarty->assign('debug_displayexceptions', $config->get('debug.display_exceptions'));
$this->smarty->assign('cache_basedir', $config->get('cache.base_dir'));
$this->smarty->assign('templates_tmppath', $config->get('templates.tmp_path'));
$this->smarty->assign('site_title', $config->get('site.title'));
$this->smarty->assign('overview_display_mode', $config->get('overview.display_mode'));
$this->smarty->assign('incident_reference_default', $config->get('incident.reference_default'));
$this->smarty->assign('messages', $messages);
$this->smarty->assign('csrftoken', $csrf->generate());

?>