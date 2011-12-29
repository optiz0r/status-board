<?php

$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();
$session = $main->session();
$messages = array();

if ( ! $auth->isAuthenticated() || ! $auth->hasPermission(StatusBoard_Permission::PERM_UpdateIncidents)) {
    throw new StatusBoard_Exception_NotAuthorised();
}

if ($request->exists('do')) {
    
    $service_id = StatusBoard_Main::issetelse($_POST['service'], 'Sihnon_Exception_InvalidParameters');
    $site_id = StatusBoard_Main::issetelse($_POST['site'], 'Sihnon_Exception_InvalidParameters');
    $reference = StatusBoard_Main::issetelse($_POST['reference'], 'Sihnon_Exception_InvalidParameters');
    $description = StatusBoard_Main::issetelse($_POST['description'], 'Sihnon_Exception_InvalidParameters');
    $status = StatusBoard_Main::issetelse($_POST['status'], 'Sihnon_Exception_InvalidParameters');
    $start_time = StatusBoard_Main::issetelse($_POST['starttime'], 'Sihnon_Exception_InvalidParameters');
    $estimated_end_time = StatusBoard_Main::issetelse($_POST['estimatedendtime'], 'Sihnon_Exception_InvalidParameters');
    
    $incident = null;
    
    try {
        StatusBoard_Validation_Text::content(array($service_id, $site_id), StatusBoard_Validation_Text::Digit);
        StatusBoard_Validation_Text::length($reference, 1, 32);
        StatusBoard_Validation_Enum::validate($status, 'StatusBoard_Status', 'STATUS_');
        
        $service = StatusBoard_Service::fromId($service_id);
        $site = StatusBoard_Site::fromId($site_id);
        
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
    } catch (StatusBoard_Exception_ResultCountMismatch $e) {
        $messages[] = array(
            'severity' => 'error',
            'content'  => 'The incident was not created because the Service or Site could not be found.',
        );
    }
    
    $session->set('messages', $messages);
    StatusBoard_Page::redirect("admin/incident/service/{$service->id}/site/{$site->id}/id/{$incident->id}/");
}

$service_id = $request->get('service');
$site_id = $request->get('site'); 

$service = null;
$site = null;

$services = StatusBoard_Service::all();
try {
    if ($service_id) {
        $service = StatusBoard_Service::fromId($service_id);
    }
    if ($site_id) {
        $site = StatusBoard_Site::fromId($site_id);
    }
} catch (Sihnon_Exception_ResultCountMismatch $e) {
    throw new StatusBoard_Exception_FileNotFound();
}

$all_sites = array();
if ($service) {
    $all_sites[$service->id] = $service->sites();
} else {
    foreach ($services as $all_service) {
        $all_sites[$all_service->id] = $all_service->sites();
    }
}



$this->smarty->assign('services', $services);
$this->smarty->assign('service', $service);
$this->smarty->assign('all_sites', $all_sites);
$this->smarty->assign('site', $site);
$this->smarty->assign('messages', $messages);

?>