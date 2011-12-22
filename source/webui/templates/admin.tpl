<div class="page-header"><!-- page-header (Header containing navigation menu and title) -->
    <h1>Admin Control Panel</h1>
    <ul class="tabs" data-tabs="tabs">
        <li {if $tab == 'admin'}class="active"{/if}><a href="#tab_admin">Admin</a></li>
        <li {if $tab == 'services'}class="active"{/if}><a href="#tab_services">Services</a></li>
        <li {if $tab == 'users'}class="active"{/if}><a href="#tab_users">User Management</a></li>
        <li {if $tab == 'settings'}class="active"{/if}><a href="#tab_settings">Settings</a></li>
    </ul>
</div><!-- /page-header -->

<div id="my-tab-content" class="tab-content"><!--tab-content(container for all main div content on page -->
<div class="tab-pane {if $tab == 'admin'}active{/if}" id="tab_admin"><!--Toggled Div to hide admin content -->
    <div class="span11"><!--Admin home content container -->
        <p>TODO</p>
    </div><!--/Admin home content container -->
</div><!--/Toggled Div to hide admin content -->

<div class="tab-pane {if $tab == 'services'}active{/if}" id="tab_services"><!--Toggled Div to hide services content -->
    <div class="span16"><!--Services content container -->   
        <h1>Services</h1>
        <div class="row">
        	<div class="span4 column">
        		<h3>Current Services</h3>
        		<p>Click on a Service to edit its properties, or access any of the sites defined under it.</p>
        	</div>
            <div class="span12 column">
                {if $services}
                    <table class="bordered-table"><!--Services table -->
                        <thead>
    				    <th>Service</th>
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
                                    <button class='btn info' onclick="document.location.href='{$base_uri}admin/service/id/{$service->id}/';return false;">Edit</button>
                                    <button class='btn danger' onclick="sb.admin.deleteItem('{$base_uri}admin/tab/services/do/delete-service/id/{$service->id}/');">Delete</button>
                                </td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table><!--/Services table -->
            {else}
                You haven't created any services yet. Create some with the button below.
            {/if}
            </div>
            <div id="confirm_delete" class="modal hide fade">
                <div class="modal-header">
                    Confirm deletion
                </div>
                <div class="modal-body">
                    This action cannot be reversed and all dependent sites and incidents will also be removed.
                    Are you sure you wish to delete this Service?                
                </div>
                <div class="modal-footer">
                    <button class="btn secondary" id="confirm_delete_cancel">Cancel</button>
                    <button class="btn danger" id="confirm_delete_do">Delete</button>              
                </div>
            </div>
    </div><!--/Row for Existing Service-->
    <div class="row"><!--Row for New Service-->
		<div class="span4 column"><!--New Service description-->
            <h3>Add New Service</h3>
            <p>Use this form to define a new service</p>
        </div><!--/New Service description-->
		<div class="span12 column"><!--Add New Service -->
        <form id="admin_addservice" method="post" action="{$base_uri}admin/tab/services/do/add-service/">
            <fieldset>
                <div class="clearfix">
                    <label for="admin_service_add_name" style="width:87px">Name</label>
                    <div class="text">
                        <input class="xlarge span5" id="admin_service_add_name" name="name" type="text" value="" />
                    </div><!-- /text -->
                </div><!-- /clearfix -->
                
                <div class="clearfix">
                    <label for="admin_service_add_description" style="width:87px">Description</label>
                    <div class="text">
                    <textarea class="xxlarge" id="admin_service_add_description" rows="3"  name="description"></textarea>
                    </div><!-- /text -->
                </div><!-- /clearfix -->
    
                <div class="clearfix">
                    <div class="input">
                        <input type="submit" class="btn success" name="addservice" value="Add Service" />
                    </div><!-- /text -->
                </div><!-- /clearfix -->
            </fieldset>
        </form>
        </div><!--/Add New Service -->
      </div><!--/Row for New Service-->
      </div><!--Toggled Div to hide services content -->
</div><!--/Toggled Div to hide services content -->
            
<div class="tab-pane {if $tab == 'users'}active{/if}" id="tab_users">
<div class="span11"><!--Users content container -->  
        <h1>Users and Permissions</h1>
        <p>
            Click on a User to edit its properties.
        </p>

        <ul>
            {foreach from=$users item=user}
                <li><a href="{$base_uri}admin/user/id/{$user->id}/" title="Edit user {$user->username|escape:html}">{$user->username|escape:html}</a></li>
            {/foreach}
        </ul>

        <form id="admin_adduser" method="post" action="{$base_uri}admin/add-user/">
            <input type="button" class="btn success" name="adduser" value="Add User" />
        </form>
    </div>
    </div>
    
    <div class="tab-pane {if $tab == 'settings'}active{/if}" id="tab_settings">
    <div class="span11"><!--Settings content container --> 
        <h1>Settings<h1>
        <p>
            Quick access to important settings. Please use the <a href="{$base_uri}admin/settings/" title="Full settings">full settings</a>
            page to configure more advanced settings.
        </p>
    
        <form id="admin_quicksettings" method="post" action="{$base_uri}admin/settings/do/">
            <fieldset>
                <legend>Quick Settings</legend>
                
                <div class="clearfix">
                    <label for="admin_quicksettings_debug_displayexceptions">Display Exceptions?</label>
                    <div class="checkbox">
                        <input class="" id="admin_quicksettings_debug_displayexceptions" name="debug.displayexceptions" type="checkbox" value="1" {if $debug_displayexceptions}checked="checked" {/if}/>
                    </div><!-- /text -->
                </div><!-- /clearfix -->
                
                <div class="clearfix">
                    <label for="admin_quicksettings_cache_basedir">Cache Base Directory</label>
                    <div class="text">
                        <input class="xlarge span5" id="admin_quicksettings_cache_basedir" name="cache.base_dir" type="text" value="{$cache_basedir|escape:html}" />
                    </div><!-- /text -->
                </div><!-- /clearfix -->
    
                <div class="clearfix">
                    <label for="admin_quicksettings_templates_tmppath">Cache Base Directory</label>
                    <div class="text">
                        <input class="xlarge span5" id="admin_quicksettings_templates_tmppath" name="templates.tmp_path" type="text" value="{$templates_tmppath|escape:html}" />
                    </div><!-- /text -->
                </div><!-- /clearfix -->
    
                <div class="input">
                    <div class="clearfix">
                        <input type="submit" class="btn primary" value="Save">&nbsp;<button type="reset" class="btn">Cancel</button>
                    </div><!-- /clearfix -->
                </div><!-- /input -->
            </fieldset>
        </form>
    </div><!--/span11 -->
</div><!--/tab -->
</div><!--/tab-content(container for all main div content on page -->
          
<script type="text/javascript">
    sb.admin.init();
</script>