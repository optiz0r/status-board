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
                            {include nocache file="fragments/site-status.tpl" start=null end=null}
                        </td>
                        {foreach from=array(1,2,3,4,5,6) item=day}
                            {$start=mktime(0,0,0,date("n"),date("j")-$day-1)}
                            {$end=mktime(0,0,0,date("n"),date("j")-$day)}
                            {$incidents=$site->openIncidentsDuring($start, $end)}
                            {$status=StatusBoard_Incident::highestSeverityStatus($incidents)}
                            <td>
                                {include nocache file="fragments/site-status.tpl" start=$start end=$end status=$status incidents=$incidents}
                            </td>
                        {/foreach}
                    </tr>
                {/foreach}
            {/foreach}
        </tbody>
    </table>
</div>

<script type="text/javascript">
    $('tr.site').filter(':odd > td').addClass('odd_row');
</script>
