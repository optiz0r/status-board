{if $incidents}
    <table class="table table-bordered table-striped">
        <thead>
            <th>Reference</th>
            <th>Description</th>
            <th>Status</th>
            <th>Opened</th>
            <th>Closed</th>
            {if $display_admin_links}<th>Actions</th>{/if}
        </thead>
        <tbody>
            {foreach from=$incidents item=incident}
                <tr>
                    <td style="width:100px;">
                        <a href="{$base_uri}incident/id/{$incident->id}/" title="Indident History">{$incident->reference|escape:html}</a>
                    </td>
                    <td style="width:200px;">{$incident->description|truncate|escape:html}</td>
                    <td style="width:100px;">{StatusBoard_Status::name($incident->currentStatus())}</td>
                    <td style="width:60px;">{date('d-M-y H:i', $incident->start_time)}</td>
                    <td style="width:60px;">
                        {if $incident->actual_end_time}
                            {date('d-M-y H:i', $incident->actual_end_time)}
                        {else}
                            Still Open
                        {/if}
                    </td>
                    {if $display_admin_links}
                        <td style="width:60px;">
                            <button class='btn btn-primary' onclick="document.location.href='{$base_uri}admin/incident/id/{$incident->id}/';return false;">
                                <i class="icon-edit icon-white"></i>
                                Edit
                            </button>
                        </td>
                    {/if}
                </tr>
            {/foreach}
        </tbody>
    </table>
{else}
    <p>There were no recorded incidents during this time.</p>
{/if}