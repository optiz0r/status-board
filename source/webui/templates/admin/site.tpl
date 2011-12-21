<ul class="breadcrumb">
  <li><a href="{$base_uri}admin/">Admin</a> <span class="divider">|</span></li>
  <li><a href="{$base_uri}admin/service/id/{$service->id}/">Service {$service->name|escape:html}</a></li> <span class="divider">|</span></li>
  <li class="active"><a href="#">Site {$site->name|escape:html}</a></li>
</ul>

<h1>Site {$site->name|escape:html}</h1>

<div class="container">
    <div class="row">
        <div class="span16">
            <form id="admin_site_edit" method="post" action="{$base_uri}admin/site/service/{$service->id}/id/{$site->id}/do/edit/">
                <fieldset>
                    <legend>Edit Site</legend>
                    
                    <div class="clearfix">
                        <label for="admin_site_edit_name">Name</label>
                        <div class="text">
                            <input class="xlarge span5" id="admin_site_edit_name" name="name" type="text" value="{$site->name|escape:html}" />
                        </div>
                    </div><!-- /clearfix -->
                    
                    <div class="clearfix">
                        <label for="admin_site_edit_description">Description</label>
                        <div class="text">
                            <textarea class="span12" id="admin_site_edit_description" name="description">{$site->description|escape:html}</textarea>
                        </div>
                    </div><!-- /clearfix -->

                    <div class="input">
                        <div class="clearfix">
                            <input type="submit" class="btn primary" value="Edit Site">&nbsp;<button type="reset" class="btn">Cancel</button>
                        </div>
                    </div>
                </fieldset>
            </form>
        </div><!-- /span16 -->   
    </div><!-- /row -->
</div><!-- /container -->

<h1>Open Incidents</h1>

{if $open_incidents}
    <dl>
        {foreach from=$open_incidents item=incident}
            <dt>
                <a href="{$base_uri}admin/incident/service/{$service->id}/site/{$site->id}/id/{$incident->id}/" title="Edit Incident {$incident->reference|escape:html}">{$incident->reference|escape:html}</a>
                ({StatusBoard_Status::name($incident->currentStatus())})
            </dt>
            <dd>
               {$incident->description|truncate|escape:html}
            </dd> 
        {/foreach}
    </dl>
{else}
    There are no open incidents for this site . If you need to open one, use the form below.
{/if}

<form id="admin_addsite" method="post" action="{$base_uri}admin/site/service/{$service->id}/id/{$site->id}/do/add-incident/">
    <fieldset>
        <legend>Add Incident</legend>
            
        <div class="clearfix">
            <label for="admin_incident_add_reference">Reference</label>
            <div class="text">
                <input class="xlarge span5" id="admin_incident_add_reference" name="reference" type="text" value="" />
            </div>
        </div><!-- /clearfix -->
        
        <div class="clearfix">
            <label for="admin_incident_add_description">Description</label>
            <div class="text">
                <textarea class="span12" id="admin_incident_add_description" name="description"></textarea>
            </div>
        </div><!-- /clearfix -->
        
        <div class="clearfix">
            <label for="admin_incident_add_status">Initial Classification</label>
            <div class="select">
                <select class="xlarge span5" id="admin_incident_add_status" name="status">
                    {foreach from=StatusBoard_Status::available() item=status}
                        {if $status != StatusBoard_Status::STATUS_Resolved}
                            <option value="{$status}">{StatusBoard_Status::name($status)}</option>
                        {/if}
                    {/foreach}
                </select>
            </div>
        </div><!-- /clearfix -->
        
        <div class="clearfix">
            <label for="admin_incident_add_starttime">Start Time</label>
            <div class="text">
                <input class="xlarge span5" id="admin_incident_add_starttime" name="starttime" type="text" value="Now" />
            </div>
        </div><!-- /clearfix -->
        
        <div class="clearfix">
            <label for="admin_incident_add_estimatedendtime">Estimated End Time</label>
            <div class="text">
                <input class="xlarge span5" id="admin_incident_add_estimatedendtime" name="estimatedendtime" type="text" value="+4 hours" />
            </div>
        </div><!-- /clearfix -->
                    
        <div class="clearfix">
            <div class="input">
                <input type="submit" class="btn primary" name="addincident" value="Add Incident" />
            </div>
        </div>
    </fieldset>
</form>
