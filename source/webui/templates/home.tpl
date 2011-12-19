<div id="statusboard">
    <table class="bordered-table">
        <thead>
            <tr>
                <th>Service</th>
                <th class="status">Current</th>
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
                {assign var=incidents value=$site->openIncidents()}
                    <tr class="site">
                        <td>
                            {$site->name}
                        </td>
                        <td>
                        <a href="#" class="" rel="popover" data-content="{StatusBoard_Status::name($site->status())}" data-original-title="No Issues"><img src={$base_uri}images/Status_Icons/tick-circle.png></img></a>
                        </td>                                        
                        <td>
                        <a href="#" class="" rel="popover" data-content="Brief disruption to service due to supplier fault" data-original-title="Incident:123456"><img src={$base_uri}images/Status_Icons/exclamation.png></img></a>
                        </td>
                        <td>
                            TODO
                        </td>
                        <td>
                            TODO
                        </td>
                        <td>
                            TODO
                        </td>
                        <td>
                            TODO
                        </td>
                        <td>
                            TODO
                        </td>
                    </tr>
                {/foreach}
            {/foreach}
        </tbody>
    </table>
</div>

<script type="text/javascript">
    $('tr.site').filter(':odd > td').addClass('odd_row');
</script>
