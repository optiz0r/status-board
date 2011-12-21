<?php

$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();

if ( ! $auth->isAuthenticated() || ! $auth->hasPermission(StatusBoard_Permission::PERM_UpdateStatusBoards)) {
    throw new StatusBoard_Exception_NotAuthorised();
}

$activity = null;
$success = true;

$service_id = $request->get('id', 'Sihnon_Exception_InvalidParameters');
$service = null;
try {
    $service = StatusBoard_Service::fromId($service_id);
} catch (Sihnon_Exception_ResultCountMismatch $e) {
    throw new StatusBoard_Exception_FileNotFound();
}

if ($request->exists('do')) {
    $activity = $request->get('do');
    switch ($activity) {

        case 'edit': {
            $name = StatusBoard_Main::issetelse($_POST['name'], 'Sihnon_Exception_InvalidParameters');
            $description = StatusBoard_Main::issetelse($_POST['description'], 'Sihnon_Exception_InvalidParameters');
            
            if ($name) {
                $service->name = $name;
            }
            if ($description) {
                $service->description = $description;
            }
            if ($name || $description) {
                $service->save();
                $messages[] = array(
                    'severity' => 'success',
                    'content'  => 'The service was updated succesfully.',
                );
            } else {
                $messages[] = 'No changes were necessary.';
            }
            
        } break;
        
        default: {
            
        }
    }
}
    

$sites = $service->sites();

$this->smarty->assign('service', $service);
$this->smarty->assign('sites', $sites);
$this->smarty->assign('messages', $messages);

?>