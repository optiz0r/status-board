<ul class="breadcrumb">
  <li><a href="{$base_uri}admin/">Admin</a> <span class="divider">|</span></li>
  <li><a href="{$base_uri}admin/service/id/{$service->id}/">Service {$service->name|escape:html}</a></li> <span class="divider">|</span></li>
  <li class="active"><a href="#">Site {$site->name|escape:html}</a></li>
</ul>

<div class="container">
    <div class="row">
        <div class="span16">
        	<h2>Site: {$site->name|escape:html} - Service: {$service->name|escape:html}</h2>
        </div>
    </div>
	<div class="rounded_content">
    <div class="row">
        <div class="span4 column"><!--New description-->
            <h3>Edit Service</h3>
            <p>Use this form to update the existing Service</p>
        </div>
        <div class="span11 column">
            <form id="admin_site_edit" method="post" action="{$base_uri}admin/site/service/{$service->id}/id/{$site->id}/do/edit/">
                <fieldset>
                    <div class="clearfix">
                        <label for="admin_site_edit_name">Name</label>
                        <div class="text">
                            <input class="xlarge span5" id="admin_site_edit_name" name="name" type="text" value="{$site->name|escape:html}" />
                        </div>
                    </div><!-- /clearfix -->
                    
                    <div class="clearfix">
                        <label for="admin_site_edit_description">Description</label>
                        <div class="text">
                            <textarea class="xlarge" id="admin_site_edit_description" name="description">{$site->description|escape:html}</textarea>
                        </div>
                    </div><!-- /clearfix -->

                    <div class="input">
                        <div class="clearfix">
                            <input type="submit" class="btn small primary" value="Save Changes">&nbsp;<button type="reset" class="btn small">Cancel</button>
                        </div>
                    </div>
                </fieldset>
            </form>
        </div>
    </div> 
  
    <div class="row">
    	<div class="span4 column">
			<h3>Open Incidents</h3>
		</div><!--/New Service description-->
        <div class="span11 column">
		{if $open_incidents}
		<table class="bordered-table" name="sites_list_table"><!--Services table -->
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
                                    <button class='btn small primary' onclick="document.location.href='{$base_uri}admin/incident/service/{$service->id}/site/{$site->id}/id/{$incident->id}/';return false;">Edit</button>
                                    <button style="margin-left:10px" class='btn small danger' onclick="sb.admin.deleteItem('{$base_uri}admin/service/do/delete-site/id/{$service->id}/site/{$site->id}/');">Delete</button>
                                </td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table><!--/name table -->
		{else}
             <p style="padding-top:10px;">There are no open incidents for this site . If you need to open one, use the form below.</p>
        {/if}
        </div>
    </div><!--/Row for Existing Service-->

    <div class="row">
		<div class="span4 column">
            <h3>Add Incident</h3>
            <p>
                Click the button to open the Add Incident page.
            </p>
        </div><!--/New Service description-->
        
        <div class="span11 column">
            <button class="btn small primary" onclick="location.href='{$base_uri}admin/add-incident/service/{$service->id}/site/{$site->id}/'">Add Incident</button>
        </div>          
	</div>
</div><!-- /container -->