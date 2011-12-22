<ul class="breadcrumb">
  <li><a href="{$base_uri}admin/">Admin</a> <span class="divider">|</span></li>
  <li class="active"><a href="#">Service {$service->name|escape:html}</a></li>
</ul>

<div class="container">
    <div class="row">
        <div class="span16"><!--name content container -->   
            <h1>Service {$service->name|escape:html}</h1>
        </div>
    </div>
    <div class="row">
        <div class="span4 column"><!--New description-->
            <h3>Edit Service</h3>
            <p>Use this form to update the existing Service</p>
        </div><!--/New Service description-->
        <div class="span12 column"><!--Add New Service -->
            <form id="admin_service_edit" method="post" action="{$base_uri}admin/service/id/{$service->id}/do/edit/">
                <fieldset>
                    <div class="clearfix">
                        <label for="admin_service_edit_name" style="width:87px">Name</label>
                        <div class="text">
                            <input class="xlarge span5" id="admin_service_edit_name" name="name" type="text" value="{$service->name|escape:html}" />
                        </div><!-- /text -->
                    </div><!-- /clearfix -->
                    
                    <div class="clearfix">
                        <label for="admin_service_edit_description" style="width:87px">Description</label>
                        <div class="text">
                        <textarea class="xxlarge" name="textarea" id="admin_service_add_description" rows="3"  name="description" >{$service->description|escape:html}</textarea>
                        </div><!-- /text -->
                    </div><!-- /clearfix -->
        
                    <div class="clearfix">
                        <div class="input">
                            <input type="submit" class="btn primary" value="Edit Service">&nbsp;<button type="reset" class="btn">Cancel</button>
                        </div><!-- /text -->
                    </div><!-- /clearfix -->
                </fieldset>
            </form>
        </div><!--/Add New Service -->
    </div><!--/Row for New Service-->  
  
    <div class="row">
    	<div class="span4 column">
    		<h3>Existing Sites</h3>
    		<p>Currently the following sites that are defined for the service {$service->name|escape:html}, Edit the site or delete it from the service here, to add a new one use the form below</p>
    	</div>
        <div class="span12 column">
            {if $sites}
    			<table class="bordered-table" name="sites_list_table"><!--Services table -->
				    <thead>
				        <th>Sites</th>
    				    <th>Description</th>
				        <th>Action</th>
			        </thead>
				    <tbody>
                        {foreach from=$sites item=site}
                            <tr>
                                <td>
                                    <a href="{$base_uri}admin/site/service/{$service->id}/id/{$site->id}/" title="Edit site {$site->name|escape:html}">{$site->name|escape:html}</a>
                                </td>
                                <td>
                                    {$site->description|escape:html}
                                </td>
                                <td>
                                    <button class='btn primary' onclick="document.location.href='{$base_uri}admin/site/service/{$service->id}/id/{$site->id}/';return false;">Edit Site</button>
                                    <button style="margin-left:10px" class='btn danger' onclick="sb.admin.deleteItem('{$base_uri}admin/service/do/delete-site/id/{$service->id}/site/{$site->id}/');">Delete Site</button>
                                </td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table><!--/name table -->
            {else}
                You haven't created any sites for this service yet. Create some with the button below.
            {/if}
            <div id="confirm_delete" class="modal hide fade">
                <div class="modal-header">
                    Confirm deletion
                </div>
                <div class="modal-body">
                    This action cannot be reversed and all dependent incidents will also be removed.
                    Are you sure you wish to delete this Site?
                </div>
                <div class="modal-footer">
                    <button class="btn secondary" id="confirm_delete_cancel">Cancel</button>
                    <button class="btn danger" id="confirm_delete_do">Delete</button>              
                </div>
            </div>
        </div>
    </div><!--/Row for Existing Service-->
    
    <div class="row">
		<div class="span4 column">
            <h3>Add Site</h3>
            <p>Use this form to define a new site to the service {$service->name|escape:html}</p>
        </div><!--/New Service description-->
        <div class="span12 column">
            <form id="admin_addsite" method="post" action="{$base_uri}admin/service/id/{$service->id}/do/add-site/">
                <fieldset>
                    <div class="clearfix">
                        <label for="admin_site_add_name" style="width:87px">Name</label>
                        <div class="text">
                            <input class="xlarge span5" id="admin_site_add_name" name="name" type="text" />
                        </div><!-- /text -->
                    </div><!-- /clearfix -->
                    
                    <div class="clearfix">
                        <label for="admin_site_edit_description" style="width:87px">Description</label>
                        <div class="text">
                            <textarea class="xxlarge" id="admin_site_add_description" rows="3"  name="description" ></textarea>
                        </div><!-- /text -->
                    </div><!-- /clearfix -->
        
                    <div class="clearfix">
                        <div class="input">
                            <input type="submit" class="btn success" value="Add Site"> &nbsp;<button type="reset" class="btn">Cancel</button>
                        </div><!-- /text -->
                    </div><!-- /clearfix -->
                </fieldset>
            </form>
        </div>
    </div><!--/Row for New Service-->  
</div><!-- /container -->
          
<script type="text/javascript">
    sb.admin.init();
</script>