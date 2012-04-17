<div class="row">
	<div class="span12"><!--name content container -->   
		<h1>Site Status History: {$service->name|escape:html} - {$site->name|escape:html}</h1>
		<p>This page details the incident history for a site:</p>
	</div>
</div>
{if $start && $end}
    {$incidentsDuring=$site->openIncidentsDuring($start, $end)}
    {$incidentCount=count($incidentsDuring)}
    <h2>{$start|date_format:'d-M H:i'} to {$end|date_format:'d-M H:i'}</h2>
    {foreach from=$incidentsDuring item=incident}
        {$statuses=$incident->statusChanges()}
        <div class="row">
            <div class="span3 column">
                <h3 class="status">
                    {if $display_admin_links && $incident->currentStatus() != StatusBoard_Status::STATUS_Resolved}
                        <a href="{$base_uri}admin/incident/service/{$service->id}/site/{$site->id}/id/{$incident->id}/" title="Edit {$incident->reference|escape:html}">{$incident->reference|escape:html}</a>
                    {else}
                        {$incident->reference|escape:html}
                    {/if}
                </h3>
                <p>Opened: {$incident->start_time|date:"r"}<p>
                {if $incident->estimated_end_time}
                    {$time_difference=time()-$incident->estimated_end_time}
                    <p>Estimated End Time: {$time_difference|fuzzyTime}</p>
                {/if}
            </div>
            <div class="span9 column">
                <table class="table table-bordered table-striped">
                    <thead>
                        <th>Status</th>
                        <th>Time</th>
                        <th>Description</th>
                    </thead>
                    <tbody>
                        {foreach from=$statuses item=status}
                            <tr>
                                <td>{$status->status|escape:html}</td>
                                <td>{$status->ctime|date_format:'d-M H:i'}</td>
                                <td>{$status->description|escape:html}</td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    {foreachelse}
        <p>There were no recorded incidents during this time period.</p>
    {/foreach}
{else}
	{foreach from=array(0,1,2,3,4,5,6) item=day}
        {$start=mktime(0,0,0,date("n"),date("j")-$day)}
        {$end=mktime(0,0,0,date("n"),date("j")-$day+1)}
        {$incidentsDuring=$site->openIncidentsDuring($start, $end)}
        {$incidentCount=count($incidentsDuring)}
	 	<div class="row" id="{$start|date_format:"dM"}" style="padding-top:40px">
        	<div class="span3">
            	<h3 class="status">{$start|date_format:"d M Y"}</h3>
                <p>{$incidentCount} {StatusBoard_Formatting::pluralise($incidentCount,'incident','incidents')}</p>
                {if $incidentsDuring}<p style="font-size:small"> Note: Click on incident number to see incident audit trail</p>{/if}
            </div>
            <div class="span9" style="margin-bottom:-40px">
            	{if $incidentsDuring}
					<table class="table table-bordered table-striped"><!--Services table -->
						<thead>
							<th>Incident</th>
							<th>Description</th>
							<th>Time Opened</th>
							<th>Status</th>
							<th>Time Closed</th>
							{if $display_admin_links}<th>Actions</th>{/if}
						</thead>
						<tbody>
						{foreach from=$incidentsDuring item=incident}
							<tr>
	                			<td>
                                        <a href="{$base_uri}incident/id/{$incident->id}/" title="Indident History">{$incident->reference|escape:html}</a>
	                			</td>
	                			<td>{$incident->description|truncate|escape:html}</td>
	                			<td>{date('d-M H:i', $incident->start_time)}</td>
	                			<td>{StatusBoard_Status::name($incident->currentStatus())}</td>
	                			<td>
                                    {if $incident->actual_end_time}
                                        {date('d-M H:i', $incident->actual_end_time)}
                                    {else}
                                        Still Open
                                    {/if}
	                			</td>
	                			{if $display_admin_links}
	                			    <td>
	                			        <button class='btn btn-primary' onclick="document.location.href='{$base_uri}admin/incident/service/{$service->id}/site/{$site->id}/id/{$incident->id}/';return false;">
	                			            <i class="icon-edit icon-white"></i>
	                			            Edit
                                        </button>
                                    </td>
                                {/if}
             				</tr>
             			{/foreach}
                        </tbody>
                    </table><!--/name table -->
             	{else}
             	    <p>There were no recorded incidents on this day</p>
             	{/if}
       		</div>
       		</div>
	{/foreach}
{/if}