<?php

$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();
$session = $main->session();

if ( ! $auth->isAuthenticated() || ! $auth->hasPermission(StatusBoard_Permission::PERM_UpdateStatusBoards)) {
    throw new StatusBoard_Exception_NotAuthorised();
}

$service_id = $request->get('service', 'Sihnon_Exception_InvalidParameters');
$site_id = $request->get('id', 'Sihnon_Exception_InvalidParameters'); 

$service = null;
$site = null;

try {
    $service = StatusBoard_Service::fromId($service_id);
    $site = StatusBoard_Site::fromId($site_id);
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
                $site->name = $name;
            }
            if ($description) {
                $site->description = $description;
            }
            if ($name || $description) {
                $site->save();
                $messages[] = array(
                    'severity' => 'success',
                    'content'  => 'The site was updated succesfully.',
                );
            } else {
                $messages[] = 'No changes were necessary.';
            }

        } break;

        case 'add-incident': {
            $reference = StatusBoard_Main::issetelse($_POST['reference'], 'Sihnon_Exception_InvalidParameters');
            $description = StatusBoard_Main::issetelse($_POST['description'], 'Sihnon_Exception_InvalidParameters');
            $status = StatusBoard_Main::issetelse($_POST['status'], 'Sihnon_Exception_InvalidParameters');
            $start_time = StatusBoard_Main::issetelse($_POST['starttime'], 'Sihnon_Exception_InvalidParameters');
            $estimated_end_time = StatusBoard_Main::issetelse($_POST['estimatedendtime'], 'Sihnon_Exception_InvalidParameters');
            
            $start_time = strtotime($start_time);
            if ($start_time === null) {
                throw new StatusBoard_Exception_InvalidParameters('starttime');
            }
            $estimated_end_time = strtotime($estimated_end_time);
            if ($estimated_end_time === null) {
                throw new StatusBoard_Exception_InvalidParameters('estimatedendtime');
            }

            $incident = $site->newIncident($reference, $description, $status, $start_time, $estimated_end_time);
            
            $messages[] = array(
                'severity' => 'success',
                'content'  => 'The incident was created succesfully.',
            );
       
        } break;

        default: {
            $messages[] = array(
                'severity' => 'warning',
                'content'  => "The activity '{$activity}' is not supported.",
            );
        }
        
    }

    $session->set('messages', $messages);
    StatusBoard_Page::redirect("admin/site/service/{$service->id}/id/{$site->id}/");
}



$open_incidents = $site->openIncidents();

$this->smarty->assign('service', $service);
$this->smarty->assign('site', $site);
$this->smarty->assign('open_incidents', $open_incidents);
$this->smarty->assign('messages', $messages);

?>