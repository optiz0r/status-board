<?php

$main = StatusBoard_Main::instance();
$auth = $main->auth();
$config = $main->config();
$request = $main->request();

if ( ! $auth->isAuthenticated() || ! $auth->hasPermission(StatusBoard_Permission::PERM_Administrator)) {
    throw new StatusBoard_Exception_NotAuthorised();
}

$activity = null;
$success = true;

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

        default: {
            $messages[] = array(
                'severity' => 'warning',
                'content'  => "The activity '{$activity}' is not supported.",
            );
        }
    }
}

$this->smarty->assign('tab', $request->get('tab', 'admin'));

$services = StatusBoard_Service::all();
$this->smarty->assign('services', $services);

$users = $auth->listUsers();
$this->smarty->assign('users', $users);

// Quick Settings
$this->smarty->assign('debug_displayexceptions', $config->get('debug.display_exceptions'));
$this->smarty->assign('cache_basedir', $config->get('cache.base_dir'));
$this->smarty->assign('templates_tmppath', $config->get('templates.tmp_path'));
$this->smarty->assign('messages', $messages);

?>