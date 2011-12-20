<h1>Service {$service->name|escape:html}</h1>

<div class="container">
    <div class="row">
        <div class="span16">
            <form id="admin_service_edit" method="post" action="{$base_uri}admin/services/id/{$service->id}/do/edit/">
                <fieldset>
                    <legend>Edit Service</legend>
                    
                    <div class="clearfix">
                        <label for="admin_service_edit_name">Name</label>
                        <div class="text">
                            <input class="xlarge span5" id="admin_service_edit_name" name="name" type="text" value="{$service->name|escape:html}" />
                        </div>
                    </div><!-- /clearfix -->
                    
                    <div class="clearfix">
                        <label for="admin_service_edit_description">Description</label>
                        <div class="text">
                            <textarea class="span12" id="admin_service_edit_description" name="description">{$service->description|escape:html}</textarea>
                        </div>
                    </div><!-- /clearfix -->

                    <div class="input">
                        <div class="clearfix">
                            <input type="submit" class="btn primary" value="Edit Service">&nbsp;<button type="reset" class="btn">Cancel</button>
                        </div>
                    </div>
                </fieldset>
            </form>
        </div><!-- /span16 -->   
    </div><!-- /row -->
</div><!-- /container -->

<h1>Sites</h1>

{if $sites}
	<dl>
	    {foreach from=$sites item=site}
        	<dt><a href="{$base_uri}admin/site/service/{$service->id}/id/{$site->id}/" title="Edit site {$site->name|escape:html}">{$site->name|escape:html}</a></dt>
			<dd>{$site->description|escape:html}</dd>
    	{/foreach}
	</dl>
{else}
	You haven't created any sites for this service yet. Create some with the button below.
{/if}

<form id="admin_addsite" method="post" action="{$base_uri}admin/add-site/service/{$service->id}/">
    <input type="button" class="btn success" name="addsite" value="Add Site" />
</form>