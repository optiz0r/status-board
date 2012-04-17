<div class="row">
    <div class="span10">   
		<h1>Incident History: {$incident->reference|escape:html}</h1>
	    <p>
	        This page details the history of incident: {$incident->reference|escape:html}
	    </p>
	</div>
	<div class="span2 align-right">
	    {if $display_admin_links}
	        <button class='btn small primary' onclick="document.location.href='{$base_uri}admin/incident/id/{$incident->id}/';return false;">
	            <i class="icon-edit"></i>
	            Edit Incident
            </button>
	    {/if}
	</div>
</div>
<div class="row">
	<div class="span3 column">
        <h3>Incident Details</h3>
    </div>
    <div class="span9 column">
		<dl>
		    <dt>Affected Sites &amp; Services</dt>
		    <dd>
                <ul>
                    {foreach from=$incident->affectedSiteServices() item=site_service}
                        <li>{$site_service->service()->name|escape:html} - {$site_service->site()->name|escape:html}</li>
                    {/foreach}
                </ul>
		    </dd>
		    
		    <dt>Opened</dt>
		    <dd>{$incident->start_time|date_format:'H:i d-M-y'}</dd>
		    
		    <dt>Estimated End</dt>
		    <dd>{StatusBoard_DateTime::fuzzyTime($incident->estimated_end_time)|ucwords}</dd>
	    </dl>
	</div>
</div>
<div class="row">
	<div class="span3 column">
        <h3>Status Changes</h3>
        <p>
           The table display an audit log of changes to this incident.
        </p>
    </div>
    <div class="span9 column">
        <table class="table table-condensed table-striped">
		    <thead>
		        <th>Date/Time</th>
		        <th>Status</th>
		        <th>Description</th>
		    </thead>
		    <tbody>
		        {foreach from=$incident->statusChanges() item=status}
		            <tr>
		                <td>
		                    {StatusBoard_DateTime::fuzzyTime($status->ctime)|ucwords}<br />
		                    <em>{$status->ctime|date_format:'H:i d-M-y'}</em>
		                </td>
		                <td>{StatusBoard_Status::name($status->status)}</td>
		                <td>{$status->description|escape:html}</td>
		            </tr>
		        {/foreach}
		    </tbody>
		</table>
	</div>
</div>