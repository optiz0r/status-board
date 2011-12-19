<div id="statusboard">
    <table class="bordered-table zebra-striped">
        <thead>
            <tr>
                <th>Service</th>
                <th class="status">Current</th>
                <th class="status">{$day1}</th>
                <th class="status">{$day2}</th>
                <th class="status">{$day3}</th>
                <th class="status">{$day4}</th>
                <th class="status">{$day5}</th>
                <th class="status">{$day6}</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$services item=service}
                <tr colspan="8" class="service">
                    <th>
                        {$service->name}
                    </th>
                </tr>
                {foreach from=$service->sites() item=site}
                    {assign var=incidents value=$site->openIncidents()}
                    <tr>
                        <td>
                            {$site->name}
                        </td>
                        <td>
                            {StatusBoard_Status::name($site->status())}
                        </td>
                        <td>good</td>
                        <td>good</td>
                        <td>good</td>
                        <td>good</td>
                        <td>good</td>
                        <td>good</td>                            
                    </tr>            
                {foreachelse}
                
                
                {/foreach}    
            {/foreach}
        </tbody>
    </table>
</div>
