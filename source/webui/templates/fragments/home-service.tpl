<table class="table table-bordered table-condensed">
    <thead>
        <tr>
            <th>
                <div class="btn-group">
                    <button class="btn btn-mini dropdown-toggle" data-toggle="dropdown" href="#">
                        <a href="#">Display by: Service</a>
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu">
                        <li>
                            <a href="{$base_uri}home/by/site/">Site</a>
                        </li>
                    </ul>
                </div>
            </th>
            <th class="status">Now</th>
            <th class="status">Today</th>
            {foreach from=array(1,2,3,4,5,6) item=day}
                <th class="status">{mktime(0,0,0,date("n"),date("j")-$day)|date_format:"M j"}</th>
            {/foreach}
        </tr>
    </thead>
    <tbody>
        {foreach $incidents["service"] as $service_id=>$service_details}
            {$service=$incidents["services"][$service_id]}
            <tr>
                <th class="service">
                    <a id="toggle_service_{$service->id}" class="image" data-toggle="collapse" data-target="tr.service_{$service->id}">
                        <i class="icon-chevron-right"></i>
                    </a>
                    <a href="{$base_uri}status/service/{$service->id}/" title="View Status for Service {$service->name}">{$service->name}</a>
                    <td class="status header">
                        {include file="fragments/service-status.tpl" nocache date=null start=null end=null incidents=$service_details["now"] status=$service->status()}
                    </td>
                    {foreach $service_details['open'] as $day}
                        <td class="status header">
                            {include file="fragments/service-status.tpl" nocache start=$day["start"] end=$day["end"] incidents=$day["incidents"] status=StatusBoard_Incident::highestSeverityStatusBetween($day["incidents"], $day["start"], $day["end"])}
                        </td>
                    {/foreach}
                </th>
            </tr>
            {foreach $service_details['site'] as $siteservice_id=>$siteservice_details}
                {$siteservice=$incidents['siteservices'][$siteservice_id]}
                {$site=$incidents['sites'][$siteservice->site]}
                <tr class="collapse site service_{$service->id}">
                    <td>
                        <a href="{$base_uri}status/site/{$site->id}/" title="View Status for Site {$site->name|escape:html}">{$site->name|escape:html}</a>
                    </td>
                    <td class="status">
                        {$status=$siteservice->status()}
                        {include file="fragments/site-status.tpl" nocache date=null start=null end=null incidents=$siteservice_details['now']}
                    </td>
                    {foreach $siteservice_details['open'] as $day}
                        <td class="status">
                            {include file="fragments/site-status.tpl" nocache start=$day["start"] end=$day["end"] incidents=$day["incidents"] status=StatusBoard_Incident::highestSeverityStatusBetween($day["incidents"], $day["start"], $day["end"])}
                        </td>
                    {/foreach}
                </tr>
            {/foreach}
        {/foreach}
    </tbody>
</table>
