<div class="rounded_content">
    <div class="container">
        <div class="row">
	        <div class="span3 column">
	            <h3>Add Incident</h3>
	            <p>Use this form to add a new incident</p>
	        </div>
	        
	        <div class="span9 column">
		        <form id="admin_addsite" class="form form-horizontal" method="post" action="{$base_uri}admin/add-incident/do/">
                    <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
		            <fieldset>
                        <div class="control-group">
                            <label class="control-label">Group sites &amp; services</label>
                            <div class="controls">
                                <label class="checkbox" for="siteservice_mode_service">
                                    <input type="radio" id="siteservice_mode_service" name="siteservice_mode" value="service" checked="checked">
                                    By Services
                                </label>
                                <label class="checkbox" for="siteservice_mode_site">
                                    <input type="radio" id="siteservice_mode_site" name="siteservice_mode" value="site">
                                    By Sites
                                </label>
                            </div>
                        </div>
		            
                        <div class="control-group">
                            <label class="control-label">Sites &amp; Services Affected</label>
                            <div class="controls">
                                <div class="siteservice_contents" id="siteservice_service">
                                    {foreach from=$services item=service}
                                        <label class="checkbox" for="service_{$service->id}">
                                            <input type="checkbox" id="service_{$service->id}" class="select_all" />
                                            {$service->name|escape:html}
                                        </label>
                                        <div class="nested-controls">
                                            {foreach from=$service->siteInstances() item=site_instance}
                                                {assign var=site value=$site_instance->site()}
                                                <label class="checkbox" for="siteservice_{$service_instance->id}">
                                                    <input type="checkbox" id="siteservice_{$service_instance->id}" name="siteservice[]" value="{$site_instance->id}" data-selectall="service_{$service->id}" />
                                                    {$site->name|escape:html}
                                                </label>
                                            {foreachelse}
                                                <em>No sites defined for this service.</em>
                                            {/foreach}
                                        </div><!-- /controls -->
                                    {foreachelse}
                                        <em>No sites or services defined.</em>
                                    {/foreach}
                                </div><!-- /siteservice_service -->
                                <div class="siteservice_contents" id="siteservice_site">
                                    {foreach from=$sites item=site}
                                        <label class="checkbox" for="site_{$site->id}">
                                            <input type="checkbox" id="site_{$site->id}" class="select_all" />
                                            {$site->name|escape:html}
                                        </label>
                                        <div class="nested-controls">
                                            {foreach from=$site->serviceInstances() item=service_instance}
                                                {assign var=service value=$service_instance->service()}
                                                <label class="checkbox" for="siteservice_{$service_instance->id}">
                                                    <input type="checkbox" id="siteservice_{$service_instance->id}" name="siteservice[]" value="{$service_instance->id}" data-selectall="site_{$site->id}" />
                                                    {$service->name|escape:html}
                                                </label>
                                            {foreachelse}
                                                <em>No services defined for this site.</em>
                                            {/foreach}
                                        </div><!-- /controls -->
                                    {foreachelse}
                                        <em>No sites or services defined.</em>
                                    {/foreach}
                                </div><!-- /siteservice_site -->          
                            </div><!-- /controls -->
                        </div><!-- /control-group -->
		                
		                <div class="control-group">
		                    <label class="control-label" for="admin_incident_add_reference">Reference</label>
		                    <div class="controls">
		                        <input class="xlarge span5" id="admin_incident_add_reference" name="reference" type="text" value="" />
		                    </div>
		                </div><!-- /control-group -->
		                
		                <div class="control-group">
		                    <label class="control-label" for="admin_incident_add_description">Description</label>
		                    <div class="controls">
		                        <textarea class="xlarge" id="admin_incident_add_description" name="description"></textarea>
		                    </div>
		                </div><!-- /control-group -->
		                
		                <div class="control-group">
		                    <label class="control-label" for="admin_incident_add_status">Initial Classification</label>
		                    <div class="select">
		                        <select class="xlarge span5" id="admin_incident_add_status" name="status">
		                            {foreach from=StatusBoard_Status::available() item=status}
		                                {if $status != StatusBoard_Status::STATUS_Resolved}
		                                    <option value="{$status}">{StatusBoard_Status::name($status)}</option>
		                                {/if}
		                            {/foreach}
		                        </select>
		                    </div>
		                </div><!-- /control-group -->
		                
		                <div class="control-group">
		                    <label class="control-label" for="admin_incident_add_starttime">Start Time</label>
		                    <div class="controls">
		                        <input class="xlarge span5" id="admin_incident_add_starttime" name="starttime" type="text" value="Now" />
		                    </div>
		                </div><!-- /control-group -->
		                
		                <div class="control-group">
		                    <label class="control-label" for="admin_incident_add_estimatedendtime">Estimated End Time</label>
		                    <div class="controls">
		                        <input class="xlarge span5" id="admin_incident_add_estimatedendtime" name="estimatedendtime" type="text" value="+4 hours" />
		                    </div>
		                </div><!-- /control-group -->
		                            
		                <div class="control-group">
		                    <div class="controls">
		                        <button class="btn btn-primary" name="addincident"><i class="icon-plus icon-white"></i> Add Incident</button>
		                    </div>
		                </div><!-- /control-group -->
		            </fieldset>
		        </form>
			</div>
		</div><!--/Row for New Service-->  
    </div>
</div><!-- /container -->

<script type="text/javascript">
    $('document').ready(function() {
        sb.admin.init();
    });
</script>