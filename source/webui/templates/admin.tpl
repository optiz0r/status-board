<div class="row">
    <div class="span12">
        <h1>Admin Control Panel</h1>
        <ul class="nav nav-tabs">
            <li {if $tab == 'summary'}class="active"{/if}><a href="#tab_summary" data-toggle="tab">Summary</a></li>
            <li {if $tab == 'services'}class="active"{/if}><a href="#tab_services" data-toggle="tab">Services</a></li>
            <li {if $tab == 'settings'}class="active"{/if}><a href="#tab_settings" data-toggle="tab">Settings</a></li>
        </ul>
    </div><!-- /span12 -->
</div><!-- /row -->

<div id="admin-tab-content" class="tab-content"><!--tab-content(container for all main div content on page -->
    <div class="tab-pane {if $tab == 'summary'}active{/if}" id="tab_summary"><!--Toggled Div to hide admin content -->
        <div class="row">
            <div class="span3 column">
                <h3>Alerts</h3>
            </div>
            <div class="span9 column">
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
            <div class="span3">
                <h3>Statistics</h3>
            </div>
            <div class="span9">
                <table class="table table-bordered table-condensed" >
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
        </div><!--/Admin summary content container -->
    </div><!--/Toggled Div to hide admin content -->
    
    <div class="tab-pane {if $tab == 'services'}active{/if}" id="tab_services"><!--Toggled Div to hide services content -->
        <div class="row">
        	<div class="span3">
        		<h3>Current Services</h3>
        		<p>Click on a Service to edit its properties, or access any of the sites defined under it.</p>
        	</div>
            <div class="span9 column">
                {if $services}
                    <table class="table table-bordered table-striped"><!--Services table -->
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
                                    <button class="btn btn-primary" onclick="document.location.href='{$base_uri}admin/service/id/{$service->id}/';return false;">
                                        <i class="icon-edit icon-white"></i>
                                        Edit Service
                                    </button>
                                    <button class="btn btn-danger" onclick="sb.admin.deleteItem('{$base_uri}admin/tab/services/do/delete-service/id/{$service->id}/');">
                                        <i class="icon-trash icon-white"></i>
                                        Delete
                                    </button>
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
                    <button class="btn btn-danger" id="confirm_delete_do">
                        <i class="icon-trash icon-white"></i>
                        Delete
                    </button>              
                     <button class="btn btn-secondary" id="confirm_delete_cancel">
                        Cancel
                    </button>
               </div>
            </div>
        </div><!--/Row for Existing Service-->
        <div class="row"><!--Row for New Service-->
    		<div class="span3">
                <h3>New Service</h3>
                <p>Use this form to define a new service</p>
            </div>
    		<div class="span9"><!--Add New Service -->
                <form class="form-horizontal" id="admin_addservice" method="post" action="{$base_uri}admin/tab/services/do/add-service/">
                    <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
                    <fieldset>
                        <div class="control-group">
                            <label class="control-label" for="admin_service_add_name">Name</label>
                            <div class="controls">
                                <input id="admin_service_add_name" name="name" type="text" value="" />
                            </div>
                        </div><!-- /control-group -->
                        
                        <div class="control-group">
                            <label class="control-label" for="admin_service_add_description">Description</label>
                            <div class="controls">
                                <textarea class="" id="admin_service_add_description" rows="3"  name="description"></textarea>
                            </div>
                        </div><!-- /control-group -->
            
                        <div class="control-group">
                            <div class="controls">
                                <button class="btn btn-primary" name="addservice">
                                    <i class="icon-plus icon-white"></i>
                                    Add Service
                                </button>
                            </div>
                        </div><!-- /control-group -->
                    </fieldset>
                </form>
            </div><!--/Add New Service -->
        </div><!--/Row for New Service-->
    </div><!--/Toggled Div to hide services content -->
                
    <div class="tab-pane {if $tab == 'settings'}active{/if}" id="tab_settings">
        <div class="row">
            <div class="span12">
                <form class="form-horizontal" id="admin_quicksettings" method="post" action="{$base_uri}admin/tab/settings/do/save-settings/">
                    <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
                    <fieldset>
                        <legend>Quick Settings</legend>
                        
                        <div class="control-group">
                            <label class="control-label" for="admin_quicksettings_site_title">Site Title</label>
                            <div class="controls">
                                <input id="admin_quicksettings_site_title" name="site_title" type="text" value="{$site_title|escape:html}" />
                            </div>
                        </div><!-- /control-group -->
                        
                        <div class="control-group">
                            <label class="control-label" for="admin_quicksettings_debug_displayexceptions">Display Exceptions?</label>
                            <div class="controls">
                                <input id="admin_quicksettings_debug_displayexceptions" name="debug_displayexceptions" type="checkbox" value="1" {if $debug_displayexceptions}checked="checked" {/if}/>
                            </div>
                        </div><!-- /control-group -->
                        
                        <div class="control-group">
                            <label class="control-label" for="admin_quicksettings_cache_basedir">Cache Base Directory</label>
                            <div class="controls">
                                <input id="admin_quicksettings_cache_basedir" name="cache_base_dir" type="text" value="{$cache_basedir|escape:html}" />
                            </div>
                        </div><!-- /control-group -->
            
                        <div class="control-group">
                            <label class="control-label" for="admin_quicksettings_templates_tmppath">Templates Temporary Path</label>
                            <div class="controls">
                                <input id="admin_quicksettings_templates_tmppath" name="templates_tmp_path" type="text" value="{$templates_tmppath|escape:html}" />
                            </div>
                        </div><!-- /control-group -->
            
                        <div class="control-group">
                            <div class="controls">
                                <button class="btn btn-primary">
                                    <i class="icon-edit icon-white"></i>
                                    Save
                                </button>
                                <button type="reset" class="btn btn-secondary">
                                    <i class="icon-refresh"></i>
                                    Reset
                                </button>
                            </div>
                        </div><!-- /control-group -->
                    </fieldset>
                </form>
            </div><!-- /span12 -->
        </div><!--/row -->
    </div><!--/tab -->
</div><!--/tab-content(container for all main div content on page -->


<script type="text/javascript">
    sb.admin.init();
</script>