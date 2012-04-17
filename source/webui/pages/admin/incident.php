<?php

$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();
$session = $main->session();
$csrf = new StatusBoard_CSRF();

if ( ! $auth->isAuthenticated() || ! $auth->hasPermission(StatusBoard_Permission::PERM_UpdateIncidents)) {
    throw new StatusBoard_Exception_NotAuthorised();
}

$messages = array();

$incident_id = $request->get('id', 'Sihnon_Exception_InvalidParameters');

$incident = null;

try {
    $incident = StatusBoard_Incident::fromId($incident_id);
} catch (Sihnon_Exception_ResultCountMismatch $e) {
    throw new StatusBoard_Exception_FileNotFound();
}

if ($request->exists('do')) {
    $activity = $request->get('do');
    
    try {
        $csrf->validatePost();
    
        switch ($activity) {
    
            case 'edit': {
                $reference = StatusBoard_Main::issetelse($_POST['reference'], 'Sihnon_Exception_InvalidParameters');
                $description = StatusBoard_Main::issetelse($_POST['description'], 'Sihnon_Exception_InvalidParameters');
                $estimated_end_time = StatusBoard_Main::issetelse($_POST['estimatedendtime'], 'Sihnon_Exception_InvalidParameters');
    
                try {
                    StatusBoard_Validation_Text::length($reference, 1, 32);
                    
                    $estimated_end_time = strtotime($estimated_end_time);
                    if ($estimated_end_time) {
                        $incident->reference = $reference;
                        $incident->description = $description;
                        $incident->estimated_end_time = $estimated_end_time;
                        $incident->save();
                        $messages[] = array(
                            'severity' => 'success',
                            'content'  => 'The incident was updated succesfully.',
                        );
                    } else {
                        $messages[] = array(
                            'severity' => 'error',
                            'content'  => 'The incident was not modified because the value entered for estimated end time was not understood.',
                        );
                    }                    
                } catch (StatusBoard_Exception_InvalidContent $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The incident was not modified due to invalid parameters being passed.',
                    );
                }
    
            } break;
            
            case 'change-status': {
                $status = StatusBoard_Main::issetelse($_POST['status'], 'Sihnon_Exception_InvalidParameters');
                $description = StatusBoard_Main::issetelse($_POST['description'], 'Sihnon_Exception_InvalidParameters');
                
                try {
                    StatusBoard_Validation_Enum::validate($status, 'StatusBoard_Status', 'STATUS_');
                    
                    $incident->changeStatus($status, $description);
                    
                    if ($status == StatusBoard_Status::STATUS_Resolved) {
                        $incident->actual_end_time = time();
                        $incident->save();
                    }
                    
                    $messages[] = array(
                        'severity' => 'success',
                        'content'  => 'The incident status was changed successfully.',
                    );
                } catch (StatusBoard_Exception_InvalidContent $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The status was not modified due to invalid parameters being passed.',
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
        StatusBoard_Page::redirect("admin/incident/service/{$service->id}/site/{$site->id}/id/{$incident->id}/");
    } catch (SihnonFramework_Exception_CSRFVerificationFailure $e) {
        $messages[] = array(
            'severity' => 'error',
            'content'  => 'The incident was not created due to a problem with your session; please try again.',
        );
    }
}

$statuses = $incident->statusChanges();

$this->smarty->assign('incident', $incident);
$this->smarty->assign('statuses', $statuses);
$this->smarty->assign('messages', $messages);
$this->smarty->assign('csrftoken', $csrf->generate());

?>