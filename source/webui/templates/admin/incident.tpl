<ul class="breadcrumb">
  <li><a href="{$base_uri}admin/">Admin</a> <span class="divider">|</span></li>
  <li><a href="{$base_uri}admin/service/id/{$service->id}/">Service {$service->name|escape:html}</a></li> <span class="divider">|</span></li>
  <li><a href="{$base_uri}admin/site/service/{$service->id}/id/{$site->id}/">Site {$site->name|escape:html}</a></li> <span class="divider">|</span></li>
  <li class="active"><a href="#">Incident {$incident->reference|escape:html}</a></li>
</ul>

<div class="container">
    <div class="row">
        <div class="span16">
        	<h2>Incident {$incident->reference|escape:html}</h2>
        </div>
    </div>
	<div class="rounded_content">
	    <div class="row">
	        <div class="span4 column"><!--New description-->
				<h3>Edit Incident</h3>
	            <p>Use this form to update the existing Service</p>
	        </div>
	        <div class="span11 column">
	            <form id="admin_incident_edit" method="post" action="{$base_uri}admin/incident/service/{$service->id}/site/{$site->id}/id/{$incident->id}/do/edit/">
	                <fieldset>
	                    <div class="clearfix">
	                        <label for="admin_incident_edit_name">Reference</label>
	                        <div class="text">
	                            <input class="xlarge span5" id="admin_incident_edit_name" name="reference" type="text" value="{$incident->reference|escape:html}" />
	                        </div>
	                    </div><!-- /clearfix -->
	                    
	                    <div class="clearfix">
	                        <label for="admin_incident_edit_description">Description</label>
	                        <div class="text">
	                            <textarea class="xlarge" id="admin_incident_edit_description" name="description">{$incident->description|escape:html}</textarea>
	                        </div>
	                    </div><!-- /clearfix -->
	
	                    <div class="clearfix">
	                        <label for="admin_incident_edit_estimatedendtime">Estimated End Time</label>
	                        <div class="text">
	                            <input class="xlarge span5" id="admin_incident_edit_estimatedendtime" name="estimatedendtime" type="text" value="{$incident->estimated_end_time|date_format:"r"}" />
	                        </div>
	                    </div><!-- /clearfix -->
	                    
	                    <div class="input">
	                        <div class="clearfix">
	                            <input type="submit" class="btn primary" value="Edit Incident">&nbsp;<button type="reset" class="btn">Cancel</button>
	                        </div>
	                    </div>
	                </fieldset>
	            </form>
	        </div>  
	    </div>
	    
	    <div class="row">
	        <div class="span4 column">
				<h3>Change Status</h3>
				<p>Use this form to update the current status of an incident</p>
			</div><!--/New Service description-->
	        <div class="span11 column">
	            <form id="admin_incident_changestatus" method="post" action="{$base_uri}admin/incident/service/{$service->id}/site/{$site->id}/id/{$incident->id}/do/change-status/">
	                <fieldset>
	                    <p>Use this form to update the current status of an incident</p>
	                    <div class="clearfix">
	                        <label for="admin_incident_changestatus_status">New Status</label>
	                        <div class="select">
	                            <select class="xlarge span5" id="admin_incident_changestatus_status" name="status">
	                                {foreach from=StatusBoard_Status::available() item=status}
	                                    <option value="{$status}">{StatusBoard_Status::name($status)}</option>
	                                {/foreach}
	                            </select>
	                        </div>
	                    </div><!-- /clearfix -->
	                    
	                    <div class="clearfix">
	                        <label for="admin_incident_changestatus_description">Description</label>
	                        <div class="text">
	                            <textarea class="xlarge" id="admin_incident_changestatus_description" name="description"></textarea>
	                        </div>
	                    </div><!-- /clearfix -->
	
	                    <div class="input">
	                        <div class="clearfix">
	                            <input type="submit" class="btn primary" value="Change Status">&nbsp;<button type="reset" class="btn">Cancel</button>
	                        </div>
	                    </div>
	                </fieldset>
	            </form>
	        </div><!-- /span16 -->   
	    </div><!-- /row -->
		<div class="row">
			<div class="span4 column">
	            <h3>Status Changes</h3>
	            <p>The table display an audit log of changes to this incident</p>
	        </div><!--/New Service description-->
	        <div class="span11 column">
				<table>
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