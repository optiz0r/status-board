<div id="statusboard">
    <table class="bordered-table zebra-striped">
        <thead>
            <tr>
                <th>Service</th>
                <th>Sites</th>
                <th class="status">Current</th>
                {foreach from=$days key="ind" item="day"}
  				<th class="status">{$day}</th>
				{/foreach}
              
            </tr>
        </thead>
        <tbody>
            {foreach from=$services item=service}
                <tr colspan="8" class="service">
                    <th >
                        {$service->name}
                    </th>
                {foreach from=$service->sites() item=site}
                    {assign var=incidents value=$site->openIncidents()}
                        <td>
                            {$site->name}
                        </td>
                        <td>
                            {StatusBoard_Status::name($site->status())}
                        </td>                                        
                {foreachelse}
                </tr>
                
                {/foreach}    
            {/foreach}
        </tbody>
    </table>
</div>
