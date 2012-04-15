<div class="row space-below">
    <div class="span12"><!--name content container -->   
        <ul class="breadcrumb">
          <li><a href="{$base_uri}admin/tab/sites/">Admin</a> <span class="divider">|</span></li>
          <li class="active"><a href="#">Site {$site->name|escape:html}</a></li>
        </ul>

        <h2>Site: {$site->name|escape:html}</h2>
    </div>
</div>

<div class="row space-below">
    <div class="span3">
        <h3>Edit Service</h3>
        <p>Use this form to update the Site.</p>
    </div>
    <div class="span9">
        <form class="form-horizontal" id="admin_site_edit" method="post" action="{$base_uri}admin/site/id/{$site->id}/do/edit/">
            <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
            <fieldset>
                <div class="control-group">
                    <label class="control-label" for="admin_site_edit_name">Name</label>
                    <div class="controls">
                        <input id="admin_site_edit_name" name="name" type="text" value="{$site->name|escape:html}" />
                    </div>
                </div><!-- /control-group -->
                
                <div class="control-group">
                    <label class="control-label" for="admin_site_edit_description">Description</label>
                    <div class="controls">
                        <textarea id="admin_site_edit_description" name="description">{$site->description|escape:html}</textarea>
                    </div>
                </div><!-- /control-group -->

                <div class="control-group">
                    <div class="controls">
                        <button class="btn btn-primary">
                            <i class="icon-edit icon-white"></i>
                            Save Changes
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
        <h3>Associated Services</h3>
        <p>These services are currently associated with this site.</p>
    </div>
    <div class="span9">
        {if $services}
            <table class="table table-bordered table-striped" name="sites_list_table">
                <thead>
                    <th>Site</th>
                    <th>Description</th>
                    <th>Action</th>
                </thead>
                <tbody>
                    {foreach from=$services item=service}
                        <tr>
                            <td>
                                <a href="{$base_uri}admin/service/id/{$service->id}/" title="Edit site {$service->name|escape:html}">{$service->name|escape:html}</a>
                            </td>
                            <td>
                                {$service->description|escape:html}
                            </td>
                            <td>
                                <button class='btn btn-primary' onclick="document.location.href='{$base_uri}admin/service/id/{$service->id}/';return false;">
                                    <i class="icon-edit icon-white"></i>
                                    Edit Service
                                </button>
                                <button class='btn btn-danger' onclick="sb.admin.deleteItem('{$base_uri}admin/site/do/delete-service/id/{$site->id}/service/{$service->id}/', '{$csrftoken|escape:quotes}');">
                                    <i class="icon-minus icon-white"></i>
                                    Disassociate Service
                                </button>
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table><!--/name table -->
        {else}
            You haven't associated any services with this site yet. Add some with the button below.
        {/if}
    </div>
</div>

<div class="row space-below">
    <div class="span3">
        <h3>Add Services</h3>
        <p>Use this form to associate existing services with this site.</p>
    </div>
    <div class="span9">
        <form class="form-horizontal" id="admin_addservice" method="post" action="{$base_uri}admin/site/id/{$site->id}/do/add-services/">
            <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
            <fieldset>
                <div class="control-group">
                    <label class="control-label" for="admin_site_add_service">Name</label>
                    <div class="controls">
                        {foreach from=$site->unusedServices() item=service}
                            <label class="checkbox" id="admin_site_add_service_{$service->id}">
                                <input type="checkbox" id="admin_site_add_service_{$service->id}" name="services[]" value="{$service->id}" />
                                {$service->name|escape:html}
                            </label>
                        {foreachelse}
                            <em>There are no other services that can be associated with this site.</em>
                        {/foreach}
                    </div>
                </div><!-- /control-group -->
                
                <div class="control-group">
                    <div class="controls">
                        <button class="btn btn-primary">
                            <i class="icon-plus icon-white"></i>
                            Associate Services
                        </button>
                        <button type="reset" class="btn btn-secondary">
                            <i class="icon-refresh"></i>
                            Reset
                        </button>
                    </div>
                </div><!-- /control-group -->
            </fieldset>
        </form>
    </div>
</div>

<div class="row space-below">
	<div class="span3">
		<h3>Open Incidents</h3>
	</div>
    <div class="span9">
        {if $open_incidents}
            <table class="table table-bordered table-striped" name="sites_list_table">
			    <thead>
			        <th>Reference</th>
				    <th>Description</th>
			        <th>Status</th>
			        <th>Action</th>
		        </thead>
			    <tbody>
                    {foreach from=$open_incidents item=incident}
                        <tr>
                            <td>
                                <a href="{$base_uri}admin/incident/service/{$service->id}/site/{$site->id}/id/{$incident->id}/" title="Edit Incident {$incident->reference|escape:htmll}">{$incident->reference|escape:html}</a>
                            </td>
                            <td>
                                {$site->description|escape:html}
                            </td>
                            <td>
                            {StatusBoard_Status::name($incident->currentStatus())}
                            </td>
                            <td>
                                <button class='btn btn-primary' onclick="document.location.href='{$base_uri}admin/incident/service/{$service->id}/site/{$site->id}/id/{$incident->id}/';return false;">
                                    <i class="icon-edit icon-white"></i>
                                    Edit
                                </button>
                                <button class='btn btn-danger' onclick="sb.admin.deleteItem('{$base_uri}admin/incident/service/{$service->id}/site/{$site->id}/id/{$incident->id}/', '{$csrftoken|escape:quotes}');">
                                    <i class="icon-trash icon-white"></i>
                                    Delete
                                </button>
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        {else}
            <em>There are no open incidents for this site.</em>
        {/if}
    </div>
</div><!--/Row for Existing Service-->

<div class="row">
	<div class="span3">
        <h3>Add Incident</h3>
        <p>
            Click the button to open the Add Incident page.
        </p>
    </div><!--/New Service description-->
    
    <div class="span9">
        <form class="form-horizontal" method="get" action="{$base_uri}admin/add-incident/service/{$service->id}/site/{$site->id}/">
            <div class="control-group">
                <div class="controls">
                    <button class="btn btn-primary">
                        <i class="icon-plus icon-white"></i>
                        Add Incident
                    </button>
                </div>
            </div>
        </form>
    </div>          
</div>

<div id="confirm_delete" class="modal hide fade">
    <div class="modal-header">
        Confirm deletion
    </div>
    <div class="modal-body">
        This action cannot be reversed and all dependent incidents will also be removed.
        Are you sure you wish to remove the association with this service?
    </div>
    <div class="modal-footer">
        <button class="btn btn-danger" id="confirm_delete_do">
            <i class="icon-trash icon-white"></i>
            Delete
        </button>              
        <button class="btn btn-secondary" id="confirm_delete_cancel">
            Cancel
        </button>
    </div>
</div>
 
<script type="text/javascript">
    sb.admin.init();
</script>