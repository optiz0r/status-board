<ul class="breadcrumb">
  <li><a href="{$base_uri}admin/">Admin</a> <span class="divider">|</span></li>
  <li class="active"><a href="#">Service {$service->name|escape:html}</a></li>
</ul>



<div class="container">
<div class="row">
<div class="span16" name="name"><!--name content container -->   
        <h1>Service {$service->name|escape:html}</h1>
        <div class="row" name="edit service">
		<div class="span4 column"><!--New description-->
        <h3>Edit Service</h3>
        <p>Use this form to define a new service</p>
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
      
        <div class="row" name="Sites_existing">
        	<div class="span4 column">
        		<h3>Existing Sites</h3>
        		<p>Description</p>
        	</div>
        <div class="span12 column">
			<table class="bordered-table" name="sites_list_table"><!--Services table -->
				<thead>
				<th>Sites</th>
				<th>Description</th>
				<th>Action</th>
				</thead>
				<tbody>
    	    {if $sites}
           {foreach from=$sites item=site}
             <tr>
             	<td>
             	<a href="{$base_uri}admin/site/service/{$service->id}/id/{$site->id}/" title="Edit site {$site->name|escape:html}">{$site->name|escape:html}</a>
             	</td>
                <td>
                {$site->description|escape:html}
                </td>
                <td>
                <button class='btn info' onclick="document.location.href='{$base_uri}admin/site/service/{$service->id}/id/{$site->id}/';return false;">Edit</button>
                <button style="margin-left:10px" class='btn danger'>Delete</button></td>
                </tr>
            {/foreach}
        	</tbody>
        	</table><!--/name table -->
        {else}
            You haven't created any sites for this service yet. Create some with the button below.
        {/if}
        </div>
        </div><!--/Row for Existing Service-->
        
        <div class="row" name="edit service">
		<div class="span4 column"><!--New description-->
        <h3>Add Site</h3>
        <p>Use this form to define a new site</p>
        </div><!--/New Service description-->
		<div class="span12 column"><!--Add New Service -->
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
                    <textarea class="xxlarge" name="textarea" id="admin_site_add_description" rows="3"  name="description" ></textarea>
                    </div><!-- /text -->
                </div><!-- /clearfix -->
    
                <div class="clearfix">
                    <div class="input">
                        <input type="submit" class="btn success" value="Add Site"> &nbsp;<button type="reset" class="btn">Cancel</button>
                    </div><!-- /text -->
                </div><!-- /clearfix -->
            </fieldset>
        </form>
        
                </div><!--/Add New Service -->
      </div><!--/Row for New Service-->  

</div><!-- /container -->
