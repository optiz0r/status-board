<div class="page-header">
    <h1>Admin Control Panel</h1>
    <ul class="tabs" data-tabs="tabs">
        <li class="active"><a href="#Admin">Admin</a></li>
        <li><a href="#Services">Services</a></li>
        <li><a href="#UserManagement">User Management</a></li>
        <li><a href="#Settings">Settings</a></li>
    </ul>
</div>

<div id="my-tab-content" class="tab-content">
    <div class="tab-pane active" id="Admin">
        <p>TODO</p>
    </div>
            
    <div class="tab-pane" id="Services">
        <h1>Services</h1>
        <p>Click on a Service to edit its properties, or access any of the sites defined under it.</p>

        {if $services}
            <dl>
                {foreach from=$services item=service}
                    <dt><a href="{$base_uri}admin/service/id/{$service->id}/" title="Edit site {$service->name|escape:html}">{$service->name|escape:html}</a></dt>
                    <dd>{$service->description|escape:html}</dd>
                {/foreach}
            </dl>
        {else}
            You haven't created any services yet. Create some with the button below.
        {/if}

        <form id="admin_addservice" method="post" action="{$base_uri}admin/add-service/">
            <input type="button" class="btn success" name="addservice" value="Add Service" />
        </form>
    </div>
            
    <div class="tab-pane" id="UserManagement">
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
    
    <div class="tab-pane" id="Settings">
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
                    </div>
                </div><!-- /clearfix -->
                
                <div class="clearfix">
                    <label for="admin_quicksettings_cache_basedir">Cache Base Directory</label>
                    <div class="text">
                        <input class="xlarge span5" id="admin_quicksettings_cache_basedir" name="cache.base_dir" type="text" value="{$cache_basedir|escape:html}" />
                    </div>
                </div><!-- /clearfix -->
    
                <div class="clearfix">
                    <label for="admin_quicksettings_templates_tmppath">Cache Base Directory</label>
                    <div class="text">
                        <input class="xlarge span5" id="admin_quicksettings_templates_tmppath" name="templates.tmp_path" type="text" value="{$templates_tmppath|escape:html}" />
                    </div>
                </div><!-- /clearfix -->
    
                <div class="input">
                    <div class="clearfix">
                        <input type="submit" class="btn primary" value="Save">&nbsp;<button type="reset" class="btn">Cancel</button>
                    </div>
                </div>
            </fieldset>
        </form>
    </div>
</div>
          
          
        


