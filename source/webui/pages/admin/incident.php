<?php

$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();

if ( ! $auth->isAuthenticated() || ! $auth->hasPermission(StatusBoard_Permission::PERM_UpdateIncidents)) {
    throw new StatusBoard_Exception_NotAuthorised();
}

$service_id = $request->get('service', 'Sihnon_Exception_InvalidParameters');
$site_id = $request->get('site', 'Sihnon_Exception_InvalidParameters'); 
$incident_id = $request->get('id', 'Sihnon_Exception_InvalidParameters');

$service = null;
$site = null;
$incident = null;

try {
    $service = StatusBoard_Service::fromId($service_id);
    $site = StatusBoard_Site::fromId($site_id);
    $incident = StatusBoard_Incident::fromId($incident_id);
} catch (Sihnon_Exception_ResultCountMismatch $e) {
    throw new StatusBoard_Exception_FileNotFound();
}

if ($request->exists('do')) {
    $activity = $request->get('do');
    switch ($activity) {

        case 'edit': {
            $reference = StatusBoard_Main::issetelse($_POST['reference'], 'Sihnon_Exception_InvalidParameters');
            $description = StatusBoard_Main::issetelse($_POST['description'], 'Sihnon_Exception_InvalidParameters');
            $estimated_end_time = StatusBoard_Main::issetelse($_POST['estimatedendtime'], 'Sihnon_Exception_InvalidParameters');
            
            $estimated_end_time = strtotime($estimated_end_time);

            if ($reference) {
                $incident->reference = $reference;
            }
            if ($description) {
                $incident->description = $description;
            }
            if ($estimated_end_time) {
                $incident->estimated_end_time = $estimated_end_time;
            }
            if ($reference || $description || $estimated_end_time) {
                $incident->save();
                $messages[] = array(
                    'severity' => 'success',
                    'content'  => 'The incident was updated succesfully.',
                );
            } else {
                $messages[] = 'No changes were necessary.';
            }

        } break;
        
        case 'change-status': {
            $status = StatusBoard_Main::issetelse($_POST['status'], 'Sihnon_Exception_InvalidParameters');
            $description = StatusBoard_Main::issetelse($_POST['description'], 'Sihnon_Exception_InvalidParameters');
            
            $incident->changeStatus($status, $description);
            $messages[] = array(
                'severity' => 'success',
                'content'  => 'The incident status was changed successfully.',
            );
        } break;

        default: {

        }
    }
}

$statuses = $incident->statusChanges();

$this->smarty->assign('service', $service);
$this->smarty->assign('site', $site);
$this->smarty->assign('incident', $incident);
$this->smarty->assign('statuses', $statuses);
$this->smarty->assign('messages', $messages);

?>