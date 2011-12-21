<div id="statusboard">
    <table class="bordered-table">
        <thead>
            <tr>
                <th>Service</th>
                <th class="status">Now</th>
                {foreach from=$days key="ind" item="day"}
  				    <th class="status">{$day}</th>
				{/foreach}
            </tr>
        </thead>
        <tbody>
            {foreach from=$services item=service}
                <tr>
                    <th colspan="8" class="service">
                        {$service->name}
                    </th>
                </tr>
                {foreach from=$service->sites() item=site}
                {$incidents=$site->openIncidents()}
                    <tr class="site">
                        <td>
                            {$site->name}
                        </td>
                        <td>
                            {$status=$site->status()}
                            {include file="fragments/site-status.tpl" nocache start=null end=null}
                        </td>
                        {foreach from=array(1,2,3,4,5,6) item=day}
                            {$start=mktime(0,0,0,date("n"),date("j")-$day-1)}
                            {$end=mktime(0,0,0,date("n"),date("j")-$day)}
                            {$incidentsDuring=$site->openIncidentsDuring($start, $end)}
                            {$statusDuring=StatusBoard_Incident::highestSeverityStatus($incidentsDuring, $end)}
                            <td>
                                {include file="fragments/site-status.tpl" nocache start=$start end=$end status=$statusDuring incidents=$incidentsDuring}
                            </td>
                        {/foreach}
                    </tr>
                {/foreach}
            {/foreach}
        </tbody>
    </table>
</div>


