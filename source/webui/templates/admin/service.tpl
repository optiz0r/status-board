<div class="row space-below">
    <div class="span12"><!--name content container -->   
        <ul class="breadcrumb">
          <li><a href="{$base_uri}admin/tab/services/">Admin</a> <span class="divider">|</span></li>
          <li class="active"><a href="#">Service {$service->name|escape:html}</a></li>
        </ul>

        <h1>Service {$service->name|escape:html}</h1>
    </div>
</div>
<div class="row space-below">
    <div class="span3">
        <h3>Edit Service</h3>
        <p>Use this form to update the Service.</p>
    </div>
    <div class="span9">
        <form class="form-horizontal" id="admin_service_edit" method="post" action="{$base_uri}admin/service/id/{$service->id}/do/edit/">
            <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
            <fieldset>
                <div class="control-group">
                    <label class="control-label" for="admin_service_edit_name">Name</label>
                    <div class="controls">
                        <input id="admin_service_edit_name" name="name" type="text" value="{$service->name|escape:html}" />
                    </div>
                </div><!-- /control-group -->
                
                <div class="control-group">
                    <label class="control-label" for="admin_service_edit_description">Description</label>
                    <div class="controls">
                    <textarea id="admin_service_add_description" rows="3"  name="description" >{$service->description|escape:html}</textarea>
                    </div>
                </div><!-- /control-group -->
    
                <div class="control-group">
                    <div class="controls">
                        <button class="btn btn-primary" value="Save Changes">
                            <i class="icon-edit icon-white"></i>
                            Save Changes
                        </button>
                        <button class="btn btn-secondary" type="reset">
                            <i class="icon-refresh"></i>
                            Reset
                        </button>
                    </div>
                </div><!-- /control-group -->
            </fieldset>
        </form>
    </div>
</div><!-- /row -->  

<div class="row space-below">
	<div class="span3">
		<h3>Associated Sites</h3>
		<p>These sites are currently associated with this service.</p>
	</div>
    <div class="span9">
        {if $sites}
			<table class="table table-bordered table-striped" name="sites_list_table">
			    <thead>
			        <th>Service</th>
				    <th>Description</th>
			        <th>Action</th>
		        </thead>
			    <tbody>
                    {foreach from=$service->sites() item=site}
                        <tr>
                            <td>
                                <a href="{$base_uri}admin/site/service/{$service->id}/id/{$site->id}/" title="Edit site {$site->name|escape:html}">{$site->name|escape:html}</a>
                            </td>
                            <td>
                                {$site->description|escape:html}
                            </td>
                            <td>
                                <button class='btn btn-primary' onclick="document.location.href='{$base_uri}admin/site/service/{$service->id}/id/{$site->id}/';return false;">
                                    <i class="icon-edit icon-white"></i>
                                    Edit Site
                                </button>
                                <button class='btn btn-danger' onclick="sb.admin.deleteItem('{$base_uri}admin/service/do/delete-site/id/{$service->id}/site/{$site->id}/', '{$csrftoken|escape:quotes}');">
                                    <i class="icon-minus icon-white"></i>
                                    Disassociate Site
                                </button>
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table><!--/name table -->
        {else}
            You haven't associated any sites with this service yet. Add some with the button below.
        {/if}
    </div>
</div>

<div class="row space-below">
	<div class="span3">
        <h3>Add Sites</h3>
        <p>Use this form to associate existing sites with this service.</p>
    </div>
    <div class="span9">
        <form class="form-horizontal" id="admin_addsite" method="post" action="{$base_uri}admin/service/id/{$service->id}/do/add-sites/">
            <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
            <fieldset>
                <div class="control-group">
                    <label class="control-label" for="admin_service_add_site">Name</label>
                    <div class="controls">
                        {foreach from=$service->unusedSites() item=site}
                            <label class="checkbox" id="admin_service_add_site_{$site->id}">
                                <input type="checkbox" id="admin_service_add_site_{$site->id}" name="sites[]" value="{$site->id}" />
                                {$site->name|escape:html}
                            </label>
                        {foreachelse}
                            <em>There are no other sites that can be associated with this service.</em>
                        {/foreach}
                    </div>
                </div><!-- /control-group -->
                
                <div class="control-group">
                    <div class="controls">
                        <button class="btn btn-primary">
                            <i class="icon-plus icon-white"></i>
                            Associate Sites
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
         
<div id="confirm_delete" class="modal hide fade">
    <div class="modal-header">
        Confirm deletion
    </div>
    <div class="modal-body">
        This action cannot be reversed and all dependent incidents will also be removed.
        Are you sure you wish to remove the association with this site?
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