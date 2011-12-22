<div id="statusboard">
<div class="row">
<div class="span14">
<h2>Atos UK Networks Shared Services Status</h2>
</div>
<div class="span2">
<a href="#" class="btn small">Add Incident</a>
</div>
</div>
    <table class="bordered-table">
        <thead>
            <tr>
                <th>Service</th>
                <th class="status">Now</th>
                {foreach from=array(0,1,2,3,4,5,6) item=day}
                    {if $day == 0}
                        <th class="status">Today</th>
  				    {else}
                        <th class="status">{mktime(0,0,0,date("n"),date("j")-$day)|date_format:"M j"}</th>
  				    {/if}
				{/foreach}
            </tr>
        </thead>
        <tbody>
            {foreach from=$services item=service}
                <tr>
                    <th colspan="9" class="service">
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
                        {foreach from=array(0,1,2,3,4,5,6) item=day}
                            {$start=mktime(0,0,0,date("n"),date("j")-$day)}
                            {$end=mktime(0,0,0,date("n"),date("j")-$day+1)}
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


