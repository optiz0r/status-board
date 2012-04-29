<div class="row space-below">
    <div class="span10">
        {if $service}
            <h1>Service History</h1>
        {else}
            <h1>Site History</h1>
        {/if}
    </div>
    <div class="span2 align-right">
        {if $display_admin_links}
            {if $service}
                <button class='btn btn-primary' onclick="document.location.href='{$base_uri}admin/service/id/{$service->id}/';return false;">
                    <i class="icon-edit icon-white"></i>
                    Edit Service
                </button>
            {else}
                <button class='btn btn-primary' onclick="document.location.href='{$base_uri}admin/site/id/{$site->id}/';return false;">
                    <i class="icon-edit icon-white"></i>
                    Edit Site
                </button>
            {/if}
        {/if}
    </div>
</div>

<div class="row space-below">
    {if $service}
        <div class="span3">
            <h3>Service Details</h3>
        </div>
        <div class="span9">
            <div class="row">
                <div class="span2">
                    <div class="block_info">
                        <div class="block_info_title">
                            <h4>Name</h4>
                        </div>
                        <div class="block_info_content">
                            {$service->name|ucwords|escape:html}
                        </div>
                    </div>
                </div>
                <div class="span7">
                    <div class="block_info">
                        <div class="block_info_title">
                            <h4>Description</h4>
                        </div>
                        <div class="block_info_content">
                            {$service->description|ucfirst|escape:html}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    {else}
        <div class="span3">
            <h3>Site Details</h3>
        </div>
        <div class="span9">
            <div class="row">
                <div class="span2">
                    <div class="block_info">
                        <div class="block_info_title">
                            <h4>Name</h4>
                        </div>
                        <div class="block_info_content">
                            {$site->name|ucwords|escape:html}
                        </div>
                    </div>
                </div>
                <div class="span7">
                    <div class="block_info">
                        <div class="block_info_title">
                            <h4>Description</h4>
                        </div>
                        <div class="block_info_content">
                            {$site->description|ucfirst|escape:html}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    {/if}
</div>

{foreach from=array(0,1,2,3,4,5,6) item=day}
    {$start=mktime(0,0,0,date("n"),date("j")-$day)}
    {$end=mktime(0,0,0,date("n"),date("j")-$day+1)}
    {if $service != null}
        {$incidentsDuring=$service->openIncidentsDuring($start, $end)}
    {else}
        {$incidentsDuring=$site->openIncidentsDuring($start, $end)}
    {/if}
    {$incidentCount=count($incidentsDuring)}
    
    <div class="row">
        <div class="span3">
            <h3 class="status">{$start|date_format:"d M Y"}</h3>
            <p>{$incidentCount} {StatusBoard_Formatting::pluralise($incidentCount,'incident','incidents')}</p>
            {if $incidentsDuring}<p style="font-size:small"> Note: Click on incident number to see incident history</p>{/if}
        </div>
        <div class="span9">
            {if $incidentsDuring}
                <table class="table table-bordered table-striped"><!--Services table -->
                    <thead>
                        <th>Reference</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th>Opened</th>
                        <th>Closed</th>
                        {if $display_admin_links}<th>Actions</th>{/if}
                    </thead>
                    <tbody>
                        {foreach from=$incidentsDuring item=incident}
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
                <p>There were no recorded incidents on this day</p>
            {/if}
        </div>
    </div>
{/foreach}