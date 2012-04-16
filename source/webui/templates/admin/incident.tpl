<div class="row space-below">
    <div class="span12"><!--name content container -->   
        <ul class="breadcrumb">
          <li><a href="{$base_uri}admin/">Admin</a> <span class="divider">|</span></li>
          <li class="active"><a href="#">Incident {$incident->reference|escape:html}</a></li>
        </ul>

    	<h2>Incident {$incident->reference|escape:html}</h2>
    </div>
</div>

<div class="row space-below">
    <div class="span3">
		<h3>Edit Incident</h3>
        <p>Use this form to update the existing Incident</p>
    </div>
    
    <div class="span9">
        <form class="form-horizontal" id="admin_incident_edit" method="post" action="{$base_uri}admin/incident/id/{$incident->id}/do/edit/">
            <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
            <fieldset>
                <div class="control-group">
                    <label class="control-label" for="admin_incident_edit_name">Reference</label>
                    <div class="controls">
                        <input id="admin_incident_edit_name" name="reference" type="text" value="{$incident->reference|escape:html}" />
                    </div>
                </div><!-- /control-group -->
                
                <div class="control-group">
                    <label class="control-label" for="admin_incident_edit_description">Description</label>
                    <div class="controls">
                        <textarea id="admin_incident_edit_description" name="description">{$incident->description|escape:html}</textarea>
                    </div>
                </div><!-- /control-group -->

                <div class="control-group">
                    <label class="control-label" for="admin_incident_edit_estimatedendtime">Estimated End Time</label>
                    <div class="controls">
                        <input id="admin_incident_edit_estimatedendtime" name="estimatedendtime" type="text" value="{$incident->estimated_end_time|date_format:"r"}" />
                    </div>
                </div><!-- /control-group -->
                
                <div class="control-group">
                    <div class="controls">
                        <button class="btn btn-primary">
                            <i class="icon-edit icon-white"></i>
                            Edit Incident
                        </button>
                        <button type="reset" class="btn btn-secondary">
                            <i class="icon-refresh"></i>
                            Reset
                        </button>
                    </div>
                </div>
            </fieldset>
        </form>
    </div>  
</div>
	    
<div class="row space-below">
    <div class="span3">
		<h3>Change Status</h3>
		<p>Use this form to update the current status of an incident</p>
	</div>
	
    <div class="span9">
        <form class="form-horizontal" id="admin_incident_changestatus" method="post" action="{$base_uri}admin/incident/id/{$incident->id}/do/change-status/">
            <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
            <fieldset>
                <div class="control-group">
                    <label class="control-label" for="admin_incident_changestatus_status">New Status</label>
                    <div class="controls">
                        <select id="admin_incident_changestatus_status" name="status">
                            {foreach from=StatusBoard_Status::available() item=status}
                                <option value="{$status}">{StatusBoard_Status::name($status)|escape:html}</option>
                            {/foreach}
                        </select>
                    </div>
                </div><!-- /control-group -->
                
                <div class="control-group">
                    <label class="control-label" for="admin_incident_changestatus_description">Description</label>
                    <div class="controls">
                        <textarea id="admin_incident_changestatus_description" name="description"></textarea>
                    </div>
                </div><!-- /control-group -->

                <div class="control-group">
                    <div class="controls">
                        <button class="btn btn-primary">
                            <i class="icon-edit icon-white"></i>
                            Update Status
                        </button>
                        <button type="reset" class="btn btn-secondary">
                            <i class="icon-reset"></i>
                            Reset
                        </button>
                    </div>
                </div>
            </fieldset>
        </form>
    </div>  
</div>

<div class="row">
	<div class="span3">
        <h3>Status Changes</h3>
        <p>The table display an audit log of changes to this incident</p>
    </div>
    <div class="span9">
		<table class="table table-bordered table-striped">
		    <thead>
		        <th>Date/Time</th>
		        <th>Status</th>
		        <th>Description</th>
		    </thead>
		    <tbody>
		        {foreach from=$statuses item=status}
		            <tr>
		                <td>
		                    {StatusBoard_DateTime::fuzzyTime($status->ctime)}<br />
		                    <em>{$status->ctime|date_format:'y-m-d H:i:s'}</em>
		                </td>
		                <td>{StatusBoard_Status::name($status->status)}</td>
		                <td>{$status->description|escape:html}</td>
		            </tr>
		        {/foreach}
		    </tbody>
		</table>
	</div>
</div>