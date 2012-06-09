
<div class="row space-below">
     <div class="span8">
         <h1>Scheduled Maintenance</h1>
     </div>
</div>
        
<div class="row space-below">
    <div class="span12">
        {if $future_maintenance}
            <table class="table table-bordered table-striped" name="sites_list_table">
                <thead>
                    <tr>
                        <th>Reference</th>
                        <th>Description</th>
                        <th style="width: 100px;">Scheduled Start</th>
                        <th style="width: 100px;">Scheduled End</th>
                        {if $display_admin_links}
                        <th style="width: 120px;">Action</th>
                        {/if}
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$future_maintenance item=incident}
                        <tr>
                            <td><a href="{$base_uri}admin/incident/id/{$incident->id}/" title="Edit Incident {$incident->reference|escape:htmll}">{$incident->reference|escape:html}</a></td>
                            <td>{$incident->description|escape:html}</td>
                            <td>{date('d-M-y H:i', $incident->start_time|escape:html)}</td>
                            <td>{date('d-M-y H:i', $incident->estimated_end_time|escape:html)}</td>
                            {if $display_admin_links}
                            <td><button class='btn btn-primary' onclick="document.location.href='{$base_uri}admin/incident/service/{$service->id}/site/{$site->id}/id/{$incident->id}/';return false;">Edit</button> <button class='btn btn-danger' onclick="sb.admin.deleteItem('{$base_uri}admin/tab/incidents/do/delete-incident/id/{$incident->id}/', '{$csrftoken|escape:quotes}');">Delete</button></td>
                            {/if}
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        {else}
            <em>There is no upcoming maintenance planned at this time.</em>
        {/if}
    </div>
</div><!--/Row for Future Maintenance-->
