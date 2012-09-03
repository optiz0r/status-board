<?php

$main = StatusBoard_Main::instance();
$config = $main->config();
$request = $main->request();
$auth = $main->auth();
$cache = $main->cache();
$home_output = null;

$services = StatusBoard_Service::all(null, null, null, 'name', StatusBoard_Service::ORDER_ASC);
$this->smarty->assign('services', $services);
$this->smarty->assign('site_title', $config->get('site.title', 'Status Board'));

$sites = StatusBoard_Site::all(null, null, null, 'name', StatusBoard_Site::ORDER_ASC);
$this->smarty->assign('sites', $sites);

$upcoming_maintenance = StatusBoard_Incident::futureMaintenance();
$this->smarty->assign('upcoming_maintenance', $upcoming_maintenance);

$home_mode = $request->get('by', $config->get('overview.display_mode', 'service'));

$display_admin_links = ($auth->isAuthenticated() && $auth->isAdministrator());

// Dashboard output
$incidents = array();
if ($cache->exists('dashboard')) {
    $incidents = $cache->fetch('dashboard');
} else {
    $incidents['siteservices'] = array();
    $incidents['sites'] = array();
    $incidents['site'] = array();
    foreach ($sites as $site) {
        $incidents['sites'][$site->id] = $site;

        $incidents['site'][$site->id] = array();
        $incidents['site'][$site->id]['open'] = array();
        $incidents['site'][$site->id]['now'] = $site->openIncidents();
        foreach (array(0,1,2,3,4,5,6) as $day) {
            $start = mktime(0, 0, 0, date("n"), date("j") - $day);
            $end   = mktime(0, 0, 0, date("n"), date("j") - $day + 1);
            $date  = date('jM', mktime(0, 0, 0, date("n"), date("j") - $day));
            $incidents['site'][$site->id]['open'][] = array(
                'start'     => $start,
                'end'       => $end,
                'date'      => $date,
                'incidents' => $site->openIncidentsDuring($start, $end)
            );
        }

        $incidents['site'][$site->id]['service'] = array();
        foreach ($site->serviceInstances() as $service) {
            $incidents['siteservices'][$service->id] = $service;
            $incidents['site'][$site->id]['service'][$service->id]['open'] = array();
            $incidents['site'][$site->id]['service'][$service->id]['now'] = $service->openIncidents();
            foreach (array(0,1,2,3,4,5,6) as $day) {
                $start = mktime(0, 0, 0, date("n"), date("j") - $day);
                $end   = mktime(0, 0, 0, date("n"), date("j") - $day + 1);
                $date  = date('jM', mktime(0, 0, 0, date("n"), date("j") - $day));
                $incidents['site'][$site->id]['service'][$service->id]['open'][] = array(
                    'start'     => $start,
                    'end'       => $end,
                    'date'      => $date,
                    'incidents' => $service->openIncidentsDuring($start, $end)
                );
            }
        }
    }

    $incidents['services'] = array();
    $incidents['service'] = array();
    foreach ($services as $service) {
        $incidents['services'][$service->id] = $service;

        $incidents['service'][$service->id] = array();
        $incidents['service'][$service->id]['open'] = array();
        $incidents['service'][$service->id]['now'] = $service->openIncidents();
        foreach (array(0,1,2,3,4,5,6) as $day) {
            $start = mktime(0, 0, 0, date("n"), date("j") - $day);
            $end   = mktime(0, 0, 0, date("n"), date("j") - $day + 1);
            $date  = date('jM', mktime(0, 0, 0, date("n"), date("j") - $day));
            $incidents['service'][$service->id]['open'][] = array(
                'start'     => $start,
                'end'       => $end,
                'date'      => $date,
                'incidents' => $site->openIncidentsDuring($start, $end)
            );
        }

        $incidents['service'][$service->id]['site'] = array();
        foreach ($service->siteInstances() as $site) {
            $incidents['siteservices'][$site->id] = $site;
            $incidents['service'][$service->id]['site'][$site->id]['open'] = array();
            $incidents['service'][$service->id]['site'][$site->id]['now'] = $site->openIncidents();
            foreach (array(0,1,2,3,4,5,6) as $day) {
                $start = mktime(0, 0, 0, date("n"), date("j") - $day);
                $end   = mktime(0, 0, 0, date("n"), date("j") - $day + 1);
                $date  = date('jM', mktime(0, 0, 0, date("n"), date("j") - $day));
                $incidents['service'][$service->id]['site'][$site->id]['open'][] = array(
                    'start'     => $start,
                    'end'       => $end,
                    'date'      => $date,
                    'incidents' => $site->openIncidentsDuring($start, $end)
                );
            }
        }

    }

    $cache->store('dashboard', $incidents);
}

$this->smarty->assign('display_admin_links', $display_admin_links);
$this->smarty->assign('home_mode', $home_mode);
$this->smarty->assign('incidents', $incidents);
?>
