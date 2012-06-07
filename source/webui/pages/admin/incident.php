<?php

$main = StatusBoard_Main::instance();
$request = $main->request();
$auth = $main->auth();
$session = $main->session();
$csrf = new StatusBoard_CSRF();

if ( ! $auth->isAuthenticated() || ! $auth->hasPermission(StatusBoard_Permission::PERM_UpdateIncidents)) {
    throw new Sihnon_Exception_NotAuthorised();
}

$messages = array();

$incident_id = $request->get('id', 'Sihnon_Exception_InvalidParameters');
$incident = null;

try {
    $incident = StatusBoard_Incident::fromId($incident_id);
} catch (Sihnon_Exception_ResultCountMismatch $e) {
    throw new Sihnon_Exception_FileNotFound();
}

if ($request->exists('do')) {
    $activity = $request->get('do');

    try {
        $csrf->validatePost();

        switch ($activity) {

            case 'edit': {
                $reference = StatusBoard_Main::issetelse($_POST['reference'], 'Sihnon_Exception_InvalidParameters');
                $description = StatusBoard_Main::issetelse($_POST['description'], 'Sihnon_Exception_InvalidParameters');
                $start_time = StatusBoard_Main::issetelse($_POST['starttime'], 'Sihnon_Exception_InvalidParameters');
                $estimated_end_time = StatusBoard_Main::issetelse($_POST['estimatedendtime'], 'Sihnon_Exception_InvalidParameters');

                try {
                    StatusBoard_Validation_Text::length($reference, 1, 32);

                    $start_time = strtotime($start_time);
                    if ($start_time) {
                        $estimated_end_time = strtotime($estimated_end_time);
                        if ($estimated_end_time) {
                            $incident->reference = $reference;
                            $incident->description = $description;
                            
                            if ($incident->start_time != $start_time) {
                                $incident->start_time = $start_time;
                                
                                // Also update the timestamp of the first status change (in reverse chronological order)
                                $statuses = array_reverse($incident->statusChanges());
                                $statuses[0]->resetCreationTime($start_time);
                            }
                            
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
                    } else {
                        $messages[] = array(
                            'severity' => 'error',
                            'content'  => 'The incident was not modified because the value entered for start time was not understood.',
                        );
                    }
                } catch (Sihnon_Exception_InvalidContent $e) {
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
                } catch (Sihnon_Exception_InvalidContent $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The status was not modified due to invalid parameters being passed.',
                    );
                }
            } break;

            case 'add-siteservices':{
                $siteservice_ids = StatusBoard_Main::issetelse($_POST['siteservices'], 'Sihnon_Exception_InvalidParameters');
                $description = StatusBoard_Main::issetelse($_POST['description'], 'Sihnon_Exception_InvalidParameters');

                foreach ($siteservice_ids as $siteservice_id) {
                    try {
                        $siteservice = StatusBoard_SiteService::fromId($siteservice_id);
                        $new_ssi = StatusBoard_SiteServiceIncident::newFor($siteservice, $incident, $description, time());
                    } catch (Sihnon_Exception_ResultCountMismatch $e) {
                        $messages[] = array(
                            'severity' => 'warning',
                            'content'  => 'A Site/Service was not added as the object requested could not be found.',
                        );
                    }
                }
                $messages[] = array(
                    'severity' => 'success',
                    'content'  => 'The service was updated succesfully.',
                );
            } break;

            case 'delete-siteserviceincident': {
                $ssi_id = $request->get('siteserviceincident', 'Sihnon_Exception_InvalidParameters');

                try {
                    $ssi = StatusBoard_SiteServiceIncident::fromId($ssi_id);
                    $ssi->delete();

                    $messages[] = array(
                        'severity' => 'success',
                        'content'  => 'The incident was updated succesfully.',
                    );
                } catch (Sihnon_Exception_ResultCountMismatch $e) {
                    $messages[] = array(
                        'severity' => 'error',
                        'content'  => 'The site/service was not removed as the object requested could not be found.',
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
        StatusBoard_Page::redirect("admin/incident/id/{$incident->id}/");
    } catch (SihnonFramework_Exception_CSRFVerificationFailure $e) {
        $messages[] = array(
            'severity' => 'error',
            'content'  => 'The incident was not created due to a problem with your session; please try again.',
        );
    }
}

$statuses = $incident->statusChanges();
$siteserviceincidents = $incident->siteServiceIncidents();

$this->smarty->assign('incident', $incident);
$this->smarty->assign('statuses', $statuses);
$this->smarty->assign('siteserviceincidents', $siteserviceincidents);
$this->smarty->assign('messages', $messages);
$this->smarty->assign('csrftoken', $csrf->generate());

?>