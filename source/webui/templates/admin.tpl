<div class="page-header"><!-- page-header (Header containing navigation menu and title) -->
    <h1>Admin Control Panel</h1>
    <ul class="tabs" data-tabs="tabs">
        <li {if $tab == 'summary'}class="active"{/if}><a href="#tab_summary">Summary</a></li>
        <li {if $tab == 'services'}class="active"{/if}><a href="#tab_services">Services</a></li>
        <li {if $tab == 'settings'}class="active"{/if}><a href="#tab_settings">Settings</a></li>
    </ul>
</div><!-- /page-header -->

<div id="my-tab-content" class="tab-content"><!--tab-content(container for all main div content on page -->
    <div class="tab-pane {if $tab == 'summary'}active{/if}" id="tab_summary"><!--Toggled Div to hide admin content -->
        <div class="span16"><!--Admin summary content container -->
            <div class="row">
                <div class="span4 column">
                    <h3>Alerts</h3>
                </div>
                <div class="span11 column">
                    <p style="padding-top:10px">
                        There {StatusBoard_Formatting::pluralise(count($incidents_near_deadline), 'is', 'are')} {$incidents_near_deadline|count} {StatusBoard_Formatting::pluralise(count($incidents_near_deadline), 'incident', 'incidents')}
                        within 1 hour of the current estimated end time.
                    </p>
                    {if $incidents_near_deadline}
                        <ol>
                            {foreach from=$incidents_near_deadline item=incident}
                                <li>{$incident->reference|escape:html}</li>
                            {/foreach}
                        </ol>
                    {/if}
                    <p>
                        There {StatusBoard_Formatting::pluralise(count($incidents_near_deadline), 'is', 'are')} {$incidents_past_deadline|count} {StatusBoard_Formatting::pluralise(count($incidents_past_deadline), 'incident', 'incidents')}
                        already past the set estimated end time.
                    </p>
                    {if $incidents_past_deadline}
                        <ol>
                            {foreach from=$incidents_past_deadline item=incident}
                                <li>{$incident->reference|escape:html}</li>
                            {/foreach}
                        </ol>
                    {/if}
                </div>
            </div>
            <div class="row">
                <div class="span4 column">
                    <h3>Statistics</h3>
                </div>
                <div class="span11 column" style="padding-top:10px">
                    <table class="bordered-table condensed-table" >
                        <thead>
                            <tr>
                                <th>Statistic</th>
                                <th>Count</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Services</td>
                                <td>{$service_count}</td>
                            </tr>
                            <tr>
                                <td>Sites</td>
                                <td>{$site_count}</td>
                            </tr>
                            <tr>
                                <td>Incidents</td>
                                <td>{array_sum(array_values($incident_counts))}</td>
                            </tr>

                            <tr>
                                <th>Incident Statistics</th>
                                <th>Count</th>
                            </tr>
                            <td>Major</td>
                                <td>{$incident_counts[StatusBoard_Status::STATUS_Major]}</td>
                            </tr>
                            <tr>
                                <td>Significant</td>
                                <td>{$incident_counts[StatusBoard_Status::STATUS_Significant]}</td>
                            </tr>
                            <tr>
                                <td>Minor</td>
                                <td>{$incident_counts[StatusBoard_Status::STATUS_Minor]}</td>
                            </tr>
                                                    <tr>
                                <td>Planned Maintenance</td>
                                <td>{$incident_counts[StatusBoard_Status::STATUS_Maintenance]}</td>
                            </tr>
                            <tr>
                                <td>Resolved</td>
                                <td>{$incident_counts[StatusBoard_Status::STATUS_Resolved]}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div><!--/Admin summary content container -->
    </div><!--/Toggled Div to hide admin content -->
    
    <div class="tab-pane {if $tab == 'services'}active{/if}" id="tab_services"><!--Toggled Div to hide services content -->
        <div class="span16"><!--Services content container -->   
            <h1>Services</h1>
            <div class="row">
            	<div class="span4 column">
            		<h3>Current Services</h3>
            		<p>Click on a Service to edit its properties, or access any of the sites defined under it.</p>
            	</div>
                <div class="span11 column">
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
                                        <button class='btn small primary' onclick="document.location.href='{$base_uri}admin/service/id/{$service->id}/';return false;">Edit Service</button>
                                        <button class='btn small danger' onclick="sb.admin.deleteItem('{$base_uri}admin/tab/services/do/delete-service/id/{$service->id}/');">Delete</button>
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
                <h3> New Service</h3>
                <p>Use this form to define a new service</p>
            </div><!--/New Service description-->
    		<div class="span11 column"><!--Add New Service -->
            <form id="admin_addservice" method="post" action="{$base_uri}admin/tab/services/do/add-service/">
                <fieldset>
                    <div class="clearfix">
                        <label for="admin_service_add_name" style="width:85px">Name</label>
                        <div class="text">
                            <input class="xlarge span5" id="admin_service_add_name" name="name" type="text" value="" />
                        </div><!-- /text -->
                    </div><!-- /clearfix -->
                    
                    <div class="clearfix">
                        <label for="admin_service_add_description" style="width:85px">Description</label>
                        <div class="text">
                        <textarea class="xlarge" id="admin_service_add_description" rows="3"  name="description"></textarea>
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
                
    <div class="tab-pane {if $tab == 'settings'}active{/if}" id="tab_settings">
        <div class="span11"><!--Settings content container --> 
            <h1>Settings<h1>
        
            <form id="admin_quicksettings" method="post" action="{$base_uri}admin/tab/settings/do/save-settings/">
                <fieldset>
                    <legend>Quick Settings</legend>
                    
                    <div class="clearfix">
                        <label for="admin_quicksettings_site_title">Site Title</label>
                        <div class="checkbox">
                            <input class="xlarge span5" id="admin_quicksettings_site_title" name="site_title" type="text" value="{$site_title|escape:html}" />
                        </div><!-- /text -->
                    </div><!-- /clearfix -->
                    
                    <div class="clearfix">
                        <label for="admin_quicksettings_debug_displayexceptions">Display Exceptions?</label>
                        <div class="checkbox">
                            <input class="" id="admin_quicksettings_debug_displayexceptions" name="debug_displayexceptions" type="checkbox" value="1" {if $debug_displayexceptions}checked="checked" {/if}/>
                        </div><!-- /text -->
                    </div><!-- /clearfix -->
                    
                    <div class="clearfix">
                        <label for="admin_quicksettings_cache_basedir">Cache Base Directory</label>
                        <div class="text">
                            <input class="xlarge span5" id="admin_quicksettings_cache_basedir" name="cache_base_dir" type="text" value="{$cache_basedir|escape:html}" />
                        </div><!-- /text -->
                    </div><!-- /clearfix -->
        
                    <div class="clearfix">
                        <label for="admin_quicksettings_templates_tmppath">Templates Temporary Path</label>
                        <div class="text">
                            <input class="xlarge span5" id="admin_quicksettings_templates_tmppath" name="templates_tmp_path" type="text" value="{$templates_tmppath|escape:html}" />
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