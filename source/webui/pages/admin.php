<?php

$main = StatusBoard_Main::instance();
$auth = $main->auth();
$config = $main->config();
$request = $main->request();
$session = $main->session();

if ( ! $auth->isAuthenticated() || ! $auth->hasPermission(StatusBoard_Permission::PERM_Administrator)) {
    throw new StatusBoard_Exception_NotAuthorised();
}

$activity = null;
$success = true;

$destination = $request->get('tab', 'summary');

if ($request->exists('do')) {
    $activity = $request->get('do');
    switch ($activity) {

        case 'add-service': {
            $name = StatusBoard_Main::issetelse($_POST['name'], 'Sihnon_Exception_InvalidParameters');
            $description = StatusBoard_Main::issetelse($_POST['description'], 'Sihnon_Exception_InvalidParameters');

            $service = StatusBoard_Service::newService($name, $description);
            
            $messages[] = array(
                'severity' => 'success',
                'content'  => 'The service was created succesfully.',
            );
            
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
        
        case 'save-settings': {
            $supported_settings = array(
                'site_title' => 'site.title',
                'debug_display_exceptions' => 'debug.display_exceptions',
                'cache_base_dir' => 'cache.base_dir',
                'templates_tmp_path' => 'templates.tmp_path',
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
}

$this->smarty->assign('tab', $destination);
if ($destination == 'summary') {
    $this->smarty->assign('service_count', StatusBoard_Service::count());
    $this->smarty->assign('site_count', StatusBoard_Site::count());
    $this->smarty->assign('incident_counts', StatusBoard_Incident::counts());
    
    $incidents_near_deadline = StatusBoard_Incident::allNearDeadline();
    usort($incidents_near_deadline, array('StatusBoard_Incident', 'compareEstimatedEndTimes'));
    
    $incidents_past_deadline = StatusBoard_Incident::allPastDeadline();
    usort($incidents_past_deadline, array('StatusBoard_Incident', 'compareEstimatedEndTimes'));
    
    $this->smarty->assign('incidents_near_deadline', $incidents_near_deadline);
    $this->smarty->assign('incidents_past_deadline', $incidents_past_deadline);
}


$services = StatusBoard_Service::all();
$this->smarty->assign('services', $services);

$users = $auth->listUsers();
$this->smarty->assign('users', $users);

// Quick Settings
$this->smarty->assign('debug_displayexceptions', $config->get('debug.display_exceptions'));
$this->smarty->assign('cache_basedir', $config->get('cache.base_dir'));
$this->smarty->assign('templates_tmppath', $config->get('templates.tmp_path'));
$this->smarty->assign('site_title', $config->get('site.title'));
$this->smarty->assign('messages', $messages);

?>