<div class="row space-below">
    <div class="span12"><!--name content container -->   
        <ul class="breadcrumb">
          <li><a href="{$base_uri}admin/">Admin</a> <span class="divider">|</span></li>
          <li class="active"><a href="#">Incident {$incident->reference|escape:html}</a></li>
        </ul>

    	<h2>Incident {$incident->reference|escape:html}</h2>
    </div>
</div>

<div class="row space-below">
    <div class="span3">
		<h3>Edit Incident</h3>
        <p>Use this form to update the existing Incident</p>
    </div>
    
    <div class="span9">
        <form class="form-horizontal" id="admin_incident_edit" method="post" action="{$base_uri}admin/incident/id/{$incident->id}/do/edit/">
            <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
            <fieldset>
                <div class="control-group">
                    <label class="control-label" for="admin_incident_edit_name">Reference</label>
                    <div class="controls">
                        <input id="admin_incident_edit_name" name="reference" type="text" value="{$incident->reference|escape:html}" />
                    </div>
                </div><!-- /control-group -->
                
                <div class="control-group">
                    <label class="control-label" for="admin_incident_edit_description">Description</label>
                    <div class="controls">
                        <textarea id="admin_incident_edit_description" name="description">{$incident->description|escape:html}</textarea>
                    </div>
                </div><!-- /control-group -->

                <div class="control-group">
                    <label class="control-label" for="admin_incident_edit_starttime">Start Time</label>
                    <div class="controls">
                        <input id="admin_incident_edit_starttime" name="starttime" type="text" value="{$incident->start_time|date_format:"r"}" />
                    </div>
                </div><!-- /control-group -->
                
                <div class="control-group">
                    <label class="control-label" for="admin_incident_edit_estimatedendtime">Estimated End Time</label>
                    <div class="controls">
                        <input id="admin_incident_edit_estimatedendtime" name="estimatedendtime" type="text" value="{$incident->estimated_end_time|date_format:"r"}" />
                    </div>
                </div><!-- /control-group -->
                
                <div class="control-group">
                    <div class="controls">
                        <button class="btn btn-primary" type="submit">
                            <i class="icon-edit icon-white"></i>
                            Edit Incident
                        </button>
                        <button type="reset" class="btn btn-secondary">
                            <i class="icon-refresh"></i>
                            Reset
                        </button>
                    </div>
                </div>
            </fieldset>
        </form>
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
		                    {$status->ctime|timeago}<br />
		                </td>
		                <td>
                            {include file="fragments/image-status-icon.tpl" status=$status->status}
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

<div class="row space-below">
    <div class="span3">
        <h3>Change Status</h3>
        <p>Use this form to update the current status of an incident</p>
    </div>
    
    <div class="span9">
        <form class="form-horizontal" id="admin_incident_changestatus" method="post" action="{$base_uri}admin/incident/id/{$incident->id}/do/change-status/">
            <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
            <fieldset>
                <div class="control-group">
                    <label class="control-label" for="admin_incident_changestatus_status">New Status</label>
                    <div class="controls">
                        <select id="admin_incident_changestatus_status" name="status">
                            {foreach from=StatusBoard_Status::available() item=status}
                                <option value="{$status}">{StatusBoard_Status::name($status)|escape:html}</option>
                            {/foreach}
                        </select>
                    </div>
                </div><!-- /control-group -->
                
                <div class="control-group">
                    <label class="control-label" for="admin_incident_changestatus_description">Description</label>
                    <div class="controls">
                        <textarea id="admin_incident_changestatus_description" name="description"></textarea>
                    </div>
                </div><!-- /control-group -->

                <div class="control-group">
                    <div class="controls">
                        <button class="btn btn-primary" type="submit">
                            <i class="icon-edit icon-white"></i>
                            Update Status
                        </button>
                        <button type="reset" class="btn btn-secondary">
                            <i class="icon-refresh"></i>
                            Reset
                        </button>
                    </div>
                </div>
            </fieldset>
        </form>
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
                    <th>Action</th>
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
                            <td>{$siteserviceincident->description|escape:html}</td>
                            <td>
                                <button class="btn btn-danger" onclick="sb.admin.deleteItem('{$base_uri}admin/incident/id/{$incident->id}/do/delete-siteserviceincident/siteserviceincident/{$siteserviceincident->id}/', '{$csrftoken|escape:html}');">
                                    <i class="icon-trash icon-white"></i>
                                    Disassociate
                                </button>
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

<div class="row">
    <div class="span3">
        <h3>Update Sites/Services</h3>
        <p>Add additional sites/services impacted by this incident.</p>
    </div>
    
    <div class="span9">
        <form id="admin_incident_siteservice" class="form form-horizontal" method="post" action="{$base_uri}admin/incident/id/{$incident->id}/do/add-siteservices/">
            <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
            <fieldset>
                <div class="control-group">
                    <label class="control-label">Group sites &amp; services</label>
                    <div class="controls">
                        <label class="checkbox" for="siteservice_mode_service">
                            <input type="radio" id="siteservice_mode_service" name="siteservice_mode" value="service" checked="checked">
                            By Services
                        </label>
                        <label class="checkbox" for="siteservice_mode_site">
                            <input type="radio" id="siteservice_mode_site" name="siteservice_mode" value="site">
                            By Sites
                        </label>
                    </div>
                </div>
                    
                <div class="control-group">
                    <label class="control-label">Sites &amp; Services Affected</label>
                    <div class="controls">
                        <div class="collapseable-controls">
                            <div class="siteservice_contents" id="siteservice_service">
                                {foreach from=$incident->unusedServices() item=service}
                                    <a id="toggle_service_{$service->id}" class="image" data-toggle="collapse" data-target="#toggle_service_{$service->id}_group">
                                        <i class="icon-chevron-right"></i>
                                    </a>
                                    <label class="checkbox" for="service_{$service->id}">
                                        <input type="checkbox" id="service_{$service->id}" class="select-all" />
                                        {$service->name|escape:html}
                                    </label>
                                    <div class="nested-controls collapse in" id="toggle_service_{$service->id}_group">
                                        {foreach from=$incident->unusedSites($service) item=site}
                                            {assign var=siteservice value=StatusBoard_SiteService::fromSiteService($service, $site)}
                                            <label class="checkbox" for="siteservice_{$siteservice->id}">
                                                <input type="checkbox" id="siteservice_{$siteservice->id}" name="siteservices[]" value="{$siteservice->id}" data-select-all="service_{$service->id}" />
                                                {$site->name|escape:html}
                                            </label>
                                        {foreachelse}
                                            <em>No sites defined for this service.</em>
                                        {/foreach}
                                    </div><!-- /controls -->
                                {foreachelse}
                                    <em>No sites or services defined.</em>
                                {/foreach}
                            </div><!-- /siteservice_service -->
                            <div class="siteservice_contents" id="siteservice_site">
                                {foreach from=$incident->unusedSites() item=site}
                                    <a id="toggle_site_{$site->id}" class="image" data-toggle="collapse" data-target="#toggle_site_{$site->id}_group">
                                        <i class="icon-chevron-right"></i>
                                    </a>
                                    <label class="checkbox" for="site_{$site->id}">
                                        <input type="checkbox" id="site_{$site->id}" class="select-all" />
                                        {$site->name|escape:html}
                                    </label>
                                    <div class="nested-controls collapse in" id="toggle_site_{$site->id}_group">
                                        {foreach from=$incident->unusedServices($site) item=service}
                                            {assign var=siteservice value=StatusBoard_SiteService::fromSiteService($service, $site)}
                                            <label class="checkbox" for="siteservice_{$siteservice->id}">
                                                <input type="checkbox" id="siteservice_{$siteservice->id}" name="siteservices[]" value="{$siteservice->id}" data-select-all="site_{$site->id}" />
                                                {$service->name|escape:html}
                                            </label>
                                        {foreachelse}
                                            <em>No services defined for this site.</em>
                                        {/foreach}
                                    </div><!-- /controls -->
                                {foreachelse}
                                    <em>No sites or services defined.</em>
                                {/foreach}
                            </div><!-- /siteservice_site -->
                        </div><!-- /collapseable-controls -->
                    </div><!-- /controls -->
                </div><!-- /control-group -->

                <div class="control-group">
                    <label class="control-label" for="admin_incident_siteservice_description">Description</label>
                    <div class="controls">
                        <textarea id="admin_incident_siteservice_description" name="description"></textarea>
                    </div>
                </div><!-- /control-group -->

                <div class="control-group">
                    <div class="controls">
                        <button class="btn btn-primary" type="submit">
                            <i class="icon-plus icon-white"></i>
                            Update Incident
                        </button>
                    </div>
                </div><!-- /control-group -->
            </fieldset>
        </form>
    </div>
</div>

<div id="confirm_delete" class="modal hide fade">
    <div class="modal-header">
        Confirm disassociation
    </div>
    <div class="modal-body">
        <p>
            This action will disassociate the incident from this site/service combination. The incident itself will not be deleted.
            If this is the only site/service combination, the incident will no longer be visible from any of the status pages, 
            but will still exist in the database and can be reattached to another site/service combination in the future. 
            This action cannot be undone, but the association can be recreated again afterwards.
        </p>
        <p>
            Do you wish to continue?
        </p>
    </div>
    <div class="modal-footer">
        <button class="btn btn-danger" id="confirm_delete_do">
            <i class="icon-trash icon-white"></i>
            Disassociate
        </button>              
         <button class="btn btn-secondary" id="confirm_delete_cancel">
            Cancel
        </button>
   </div>
</div>

<script type="text/javascript">
    $('document').ready(function() {
        sb.admin.init();
    });
</script>
