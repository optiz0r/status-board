<div class="row space-below">
    <div class="span10">   
        <h1>Incident History</h1>
    </div>
    <div class="span2 align-right">
        {if $display_admin_links}
            <button class='btn btn-primary' onclick="document.location.href='{$base_uri}admin/incident/id/{$incident->id}/';return false;">
                <i class="icon-edit icon-white"></i>
                Edit Incident
            </button>
        {/if}
    </div>
</div>
<div class="row space-below">
    <div class="span3">
        <h3>Incident Details</h3>
    </div>
    <div class="span9">
        <div class="row">
            <div class="span3">
                <div class="block_info">
                    <div class="block_info_title">
                        <h4>Reference</h4>
                    </div>
                    <div class="block_info_content">
                        {$incident->reference|ucwords|escape:html}
                    </div>
                </div>
            </div>
            <div class="span6">
                <div class="block_info">
                        <div class="block_info_title">
                            <h4>Description</h4>
                        </div>
                        <div class="block_info_content">
                            {$incident->description|ucfirst|escape:html}
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
            <div class="span3">
                <div class="block_info">
                    <div class="block_info_title">
                        <h4>Opened</h4>
                    </div>
                    <div class="block_info_content">
                        {StatusBoard_DateTime::fuzzyTime($incident->start_time)|ucwords|escape:html}<br />
                        <em>{$incident->start_time|date_format:'d-M-y H:i'}</em>
                    </div>
                </div>
            </div>
            <div class="span3">
                <div class="block_info">
                    <div class="block_info_title">
                        <h4>Estimated End</h4>
                    </div>
                    <div class="block_info_content">
                        {StatusBoard_DateTime::fuzzyTime($incident->estimated_end_time)|ucfirst|escape:html}<br />
                        <em>{$incident->estimated_end_time|date_format:'d-M-y H:i'}</em>
                    </div>
                </div>
            </div>
            <div class="span3">
                <div class="block_info">
                    <div class="block_info_title">
                        <h4>Actual End</h4>
                    </div>
                    <div class="block_info_content">
                        {if ($incident->actual_end_time!=null)}
                            {StatusBoard_DateTime::fuzzyTime($incident->actual_end_time)|ucwords|escape:html}<br />
                            <em>{$incident->actual_end_time|date_format:'d-M-y H:i'}</em>
                        {else}
                            Incident is still open
                        {/if}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="row space-below">
    <div class="span3">
        <h3>Affected Sites/Services</h3>
        <p>List of sites and services affected by this incident.</p>
    </div>
    <div class="span9">
        {if $siteserviceincidents}
        <table class="table table-bordered table-striped">
            <thead>
                <th>Time Added</th>
                <th>Service</th>
                <th>Site</th>
                <th>Description</th>
            </thead>
            <tbody>
                {foreach from=$siteserviceincidents item=siteserviceincident}
                    {$siteservice=$siteserviceincident->siteService()}
                    {$site=$siteservice->site()}
                    {$service=$siteservice->service()}
                    <tr>
                        <td>
                            {$siteserviceincident->ctime|fuzzyTime|ucfirst}<br />
                            <em>{$siteserviceincident->ctime|date_format:'d-M-y H:i'}</em>
                        </td>
                        <td>
                            <a href="{$base_uri}admin/service/id/{$service->id}/" title="Edit site {$service->name|escape:html}">{$service->name|escape:html}</a>
                        </td>
                        <td>
                            <a href="{$base_uri}admin/site/id/{$site->id}/" title="Edit site {$site->name|escape:html}">{$site->name|escape:html}</a>
                        </td>
                        <td>{$siteserviceincident->description|escape:html}
                        </td>
                    </tr>                    
                {/foreach}
            </tbody>
        </table>
        {else}
            <em>
                There are no sites or services currently impacted by this incident, so it will not be visible directly to any users.
                Use the form below to associate this incident with any impacted sites and services.
            </em>
        {/if}
    </div>
</div>
<div class="row space-below">
    <div class="span3">
        <h3>Status Changes</h3>
        <p>The table display an audit log of changes to this incident</p>
    </div>
    <div class="span9">
        <table class="table table-bordered table-striped">
            <thead>
                <th>Date/Time</th>
                <th>Status</th>
                <th>Description</th>
            </thead>
            <tbody>
                {foreach from=$statuses item=status}
                    <tr>
                        <td>
                            {$status->ctime|fuzzyTime|ucfirst}<br />
                            <em>{$status->ctime|date_format:'y-m-d H:i:s'}</em>
                        </td>
                        <td>
                            {include file="fragments/image-status-icon.tpl" status=$incident->currentStatus()}
                            {StatusBoard_Status::name($status->status)}
                        </td>
                        <td>
                            {$status->description|escape:html}
                        </td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>

