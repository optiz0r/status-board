
<div class="container">
	<div class="row">
		<div class="span16"><!--name content container -->   
			<h1>Incident History: {$incident->reference|escape:html}</h1>
			<div class="rounded_content">
			<div class="row">
				<div class="span13 column">
				<p>This page details the history of incident: {$incident->reference|escape:html}</p>
				</div>
				<div class="span2 column">
				{if $display_admin_links}<button class='btn small primary' onclick="document.location.href='{$base_uri}admin/incident/service/{$service->id}/site/{$site->id}/id/{$incident->id}/';return false;">Edit Incident</button>{/if}
				</div>
			</div>	
			<div class="row">
				<div class="span4 column">
		            <h3>Incident Details</h3>
		            <p></p>
		        </div>
	        <div class="span11 column">
				<p style="padding-top:10px;"><b>Service:</b> {$service->name|escape:html}</p>
				<p><b>Site:</b> {$site->name|escape:html}</p>
				<p><b>Opened:</b> {$incident->start_time|date_format:'h:i d-M-y'}</p>
				<p><b>Estimated End:</b> {ucwords(StatusBoard_DateTime::fuzzyTime($incident->estimated_end_time))}</p>

			</div>
</div>
			<div class="row">
			<div class="span4 column">
	            <h3>Status Changes</h3>
	            <p>The table display an audit log of changes to this incident</p>
	        </div><!--/New Service description-->
	        <div class="span11 column">
				<table class="bordered-table">
				    <thead>
				        <th>Date/Time</th>
				        <th>Status</th>
				        <th>Description</th>
				    </thead>
				    <tbody>
				        {foreach from=$statuses item=status}
				            <tr>
				                <td>
				                    {ucwords(StatusBoard_DateTime::fuzzyTime($status->ctime))}<br />
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
	</div>
</div>