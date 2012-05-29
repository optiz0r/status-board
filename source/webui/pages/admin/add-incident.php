<?php

$main = StatusBoard_Main::instance();
$config = $main->config();
$request = $main->request();
$auth = $main->auth();
$session = $main->session();
$csrf = new StatusBoard_CSRF();

if ( ! $auth->isAuthenticated() || ! $auth->hasPermission(StatusBoard_Permission::PERM_UpdateIncidents)) {
    throw new StatusBoard_Exception_NotAuthorised();
}

$messages = array();

try{
if ($request->exists('do')) {
    
    $siteservice_ids = StatusBoard_Main::issetelse($_POST['siteservice'], 'Sihnon_Exception_InvalidParameters');
    $reference = StatusBoard_Main::issetelse($_POST['reference'], 'Sihnon_Exception_InvalidParameters');
    $description = StatusBoard_Main::issetelse($_POST['description'], 'Sihnon_Exception_InvalidParameters');
    $status = StatusBoard_Main::issetelse($_POST['status'], 'Sihnon_Exception_InvalidParameters');
    $start_time = StatusBoard_Main::issetelse($_POST['starttime'], 'Sihnon_Exception_InvalidParameters');
    $estimated_end_time = StatusBoard_Main::issetelse($_POST['estimatedendtime'], 'Sihnon_Exception_InvalidParameters');
    
    $incident = null;
    
    try {
        $csrf->validatePost();
        
        $siteservices = array();
        foreach ($siteservice_ids as $siteservice_id) {
            $siteservices[] = StatusBoard_SiteService::fromId($siteservice_id);
        }
        
        StatusBoard_Validation_Text::content(array($service_id, $site_id), StatusBoard_Validation_Text::Digit);
        StatusBoard_Validation_Text::length($reference, 1, 32);
        StatusBoard_Validation_Enum::validate($status, 'StatusBoard_Status', 'STATUS_');
                
        $start_time = strtotime($start_time);
        if ($start_time === null) {
            throw new StatusBoard_Exception_InvalidParameters('starttime');
        }
        $estimated_end_time = strtotime($estimated_end_time, $start_time);
        if ($estimated_end_time === null) {
            throw new StatusBoard_Exception_InvalidParameters('estimatedendtime');
        }
    
        $incident = StatusBoard_Incident::newFor($siteservices, $reference, $description, $status, $start_time, $estimated_end_time);
        
        $messages[] = array(
            'severity' => 'success',
            'content'  => 'The incident was created succesfully.',
        );
        
        $session->set('messages', $messages);
        StatusBoard_Page::redirect("admin/incident/id/{$incident->id}/");
    } catch (SihnonFramework_Exception_CSRFVerificationFailure $e) {
        $messages[] = array(
            'severity' => 'error',
            'content'  => 'The incident was not created due to a problem with your session; please try again.',
        );
    } catch (StatusBoard_Exception_ResultCountMismatch $e) {
        $messages[] = array(
            'severity' => 'error',
            'content'  => 'The incident was not created because one of the Services or Sites could not be found.',
        );
    }
    
    $session->set('messages', $messages);
    StatusBoard_Page::redirect("admin/add-incident/");
}
}
   catch (Sihnon_Exception_InvalidParameters $e) {
        $messages[] = array(
            'severity' => 'error',
            'content'  => 'The incident was not created because no Services or Sites are defined.',
        );
    }
    

$service_id = $request->get('service');
$site_id = $request->get('site'); 

$site_services = null;
$service = null;
$site = null;

$services = StatusBoard_Service::all();
$sites = StatusBoard_Site::all();

$this->smarty->assign('csrftoken', $csrf->generate());
$this->smarty->assign('services', $services);
$this->smarty->assign('sites', $sites);
$this->smarty->assign('incident_reference_default', $config->get('incident.reference_default'));
$this->smarty->assign('messages', $messages);

?>