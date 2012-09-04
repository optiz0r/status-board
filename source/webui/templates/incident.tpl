<div class="row space-below"> <!-- Row for page header and title -->
    <div class="span10">   
        <h1>Incident History</h1>
    </div>
    <div class="span2 align-right">
        {if $display_admin_links}
        <!-- Edit site/service if logged in -->
            <button class='btn btn-primary' onclick="document.location.href='{$base_uri}admin/incident/id/{$incident->id}/';return false;">
                <i class="icon-edit icon-white"></i>
                Edit Incident
            </button>
        {/if}
    </div>
</div><!-- /Row for page header and title -->
<div class="row space-below"><!-- Row for incident details -->
    <div class="span3">
        <h3>Incident Details</h3>
    </div>
    <div class="span9"><!-- Indicent details container -->
        <div class="row"><!-- First row of details -->
            <div class="span3"><!-- Reference -->
                <div class="block_info">
                    <div class="block_info_title">
                        <h4>Reference</h4>
                    </div>
                    <div class="block_info_content">
                        {$incident->reference|escape:html}
                    </div>
                </div>
            </div><!-- /Reference -->
            <div class="span6"><!-- Description -->
                <div class="block_info">
	                <div class="block_info_title">
	                    <h4>Description</h4>
	                </div>
	                <div class="block_info_content">
	                    {$incident->description|ucfirst|escape:html}
	                </div>
                </div>
            </div><!-- /Description -->
        </div><!-- /First row of details -->
        <div class="row"><!-- Second row of details -->
            <div class="span3"><!-- Opened -->
                <div class="block_info">
                    <div class="block_info_title">
                        <h4>Opened</h4>
                    </div>
                    <div class="block_info_content">
                        {$incident->start_time|timeago}<br />
                    </div>
                </div>
            </div><!-- /Opened -->
            <div class="span3"><!-- Estimated End -->
                <div class="block_info">
                    <div class="block_info_title">
                        <h4>Estimated End</h4>
                    </div>
                    <div class="block_info_content">
                        {$incident->estimated_end_time|timeago}<br />
                    </div>
                </div>
            </div><!-- /Estimated End -->
            <div class="span3"><!-- Actual End -->
                <div class="block_info">
                    <div class="block_info_title">
                        <h4>Actual End</h4>
                    </div>
                    <div class="block_info_content">
                        {if ($incident->actual_end_time!=null)}
                            {$incident->actual_end_time|timeago}<br />
                        {else}
                            Incident is still open
                        {/if}
                    </div>
                </div>
            </div><!-- /Actual End -->
        </div><!-- /Second row of details -->
    </div><!-- /Indicent details container -->
</div><!-- /Row for incident details -->
<div class="row space-below"><!-- Row for Affected site/service-->
    <div class="span3"><!-- side heading-->
        <h3>Affected Sites/Services</h3>
        <p>List of sites and services affected by this incident.</p>
    </div><!-- /side heading-->
    <div class="span9">
        {if $siteserviceincidents}
        <table class="table table-bordered table-striped"><!-- Affected sites table-->
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
                            {$siteserviceincident->ctime|timeago}<br />
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
        </table><!-- /Affected sites table-->
        {else}
            <em>
                There are no sites or services currently impacted by this incident, so it will not be visible directly to any users.
                Use the form below to associate this incident with any impacted sites and services.
            </em>
        {/if}
    </div>
</div><!-- /Row for Affected site/service-->
<div class="row space-below"><!-- Row for Status Changes-->
    <div class="span3"><!-- side heading-->
        <h3>Status Changes</h3>
        <p>The table display an audit log of changes to this incident</p>
    </div><!-- /side heading-->
    <div class="span9"><!-- Status changes-->
        <table class="table table-bordered table-striped"><!-- Status changes table-->
            <thead>
                <th>Date/Time</th>
                <th>Status</th>
                <th>Description</th>
            </thead>
            <tbody>
                {foreach from=$statuses item=status}
                    <tr>
                        <td>
                            {$status->ctime|timeago}<br />
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
        </table><!-- /Status changes table-->
    </div><!-- /Status Changes-->
</div><!-- Row for Status Changes-->

