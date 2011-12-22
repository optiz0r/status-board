<div class="container">
    <div class="row">
        <div class="span4 column">
            <h3>Add Incident</h3>
            <p>Use this form to add a new incident</p>
        </div><!--/New Service description-->
        <div class="span11 column">
        
        <form id="admin_addsite" method="post" action="{$base_uri}admin/add-incident/do/">
            <fieldset>
                <div class="clearfix">
                    <label for="admin_incident_add_service">Service</label>
                    <div class="text">
                        {if $service}
                            <input type="hidden" name="service" value="{$service->id}" />
                            {$service->name|escape:html}
                        {else}
                            <select class="xlarge span5" id="admin_incident_add_service" name="service">
                                {foreach from=$services item=form_service}
                                    <option value="{$form_service->id}">{$form_service->name|escape:html}</option>
                                {/foreach}
                            </select>
                        {/if}
                    </div>
                </div><!-- /clearfix -->

                <div class="clearfix">
                    <label for="admin_incident_add_site">Site</label>
                    <div class="text">
                        {if $service && $site}
                            <input type="hidden" name="site" value="{$site->id}" />
                            {$site->name|escape:html}
                        {else}
                            <select class="xlarge span5" id="admin_incident_add_site" name="site">
                                {if $service}
                                    {foreach from=$all_sites[$service->id] item=form_site}
                                        <option value="{$form_site->id}">{$form_site->name|escape:html}</option>
                                    {/foreach}
                                {else}
                                    {foreach from=$services item=all_service}
                                        {foreach from=$all_sites[$all_service->id] item=form_site}
                                            <option class="{$all_service->id}" value="{$form_site->id}">{$form_site->name|escape:html}</option>
                                        {/foreach}
                                    {/foreach}
                                {/if}
                            </select>
                        {/if}
                    </div>
                </div><!-- /clearfix -->

                <div class="clearfix">
                    <label for="admin_incident_add_reference">Reference</label>
                    <div class="text">
                        <input class="xlarge span5" id="admin_incident_add_reference" name="reference" type="text" value="" />
                    </div>
                </div><!-- /clearfix -->
                
                <div class="clearfix">
                    <label for="admin_incident_add_description">Description</label>
                    <div class="text">
                        <textarea class="xlarge" id="admin_incident_add_description" name="description"></textarea>
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
                        <input type="submit" class="btn small primary" name="addincident" value="Add Incident" />
                    </div>
                </div>
            </fieldset>
        </form>

        </div><!--/Row for New Service-->  
    </div>
</div><!-- /container -->

<script type="text/javascript">
    $('#admin_incident_add_site').chainedTo('#admin_incident_add_service');
</script>