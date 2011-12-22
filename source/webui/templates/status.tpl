<div class="container">
	<div class="row">
		<div class="span16" name="name"><!--name content container -->   
			<h1>Site Status History: {$service->name|escape:html} - {$site->name|escape:html}</h1>
			<p>This page details the incident history for a site</p>
			{foreach from=array(0,1,2,3,4,5,6) item=day}
		    	{if $day == 0}
		         	<div class="row" name="edit service">
		            	<div class="span4 column"><!--New description-->
		                	<h3 class="status">Today {mktime(0,0,0,date("n"),date("j"))|date_format:"d M Y"}</h3>
		                </div>
			            <div class="span12 column">
			            	{$start=mktime(0,0,0,date("n"),date("j")-$day)}
			                {$end=mktime(0,0,0,date("n"),date("j")-$day+1)}
			                {$incidentsDuring=$site->openIncidentsDuring($start, $end)}
							{if $incidentsDuring}
								<table class="bordered-table" name="sites_list_table"><!--Services table -->
									<thead>
									<th>Incident</th>
									<th>Description</th>
									<th>Time Opened</th>
									<th>Status</th>
									<th>Time Closed</th>
									</thead>
									<tbody>
									{foreach from=$incidentsDuring item=incident}
										<tr>
			                			<td>{$incident->reference|escape:html}</td>
			                			<td>{$incident->description|truncate|escape:html}</td>
			                			<td>{date('d-M H:i', $incident->start_time)}</td>
			                			<td>{StatusBoard_Status::name($incident->currentStatus())}</td>
			                			<td>{if $incident->actual_end_time}
			                			{date('d-M H:i', $incident->actual_end_time)}
			                			{else}
			                			Still Open
			                			{/if}
			                			</td>
			             				</tr>
			             			{/foreach}
			             	{else}
			             	<h4>There were no recorded incidents on this day</h4>
			             	{/if}
			             			</tbody>
			        			</table><!--/name table -->
			       		</div>
					</div>
  				{else}
  				    <div class="row" name="edit service">
  				    	<div class="span4 column"><!--New description-->
                        	<h3 class="status">{mktime(0,0,0,date("n"),date("j")-$day)|date_format:"d M Y"}</h3>
                        </div>
						<div class="span12 column">
            				{$start=mktime(0,0,0,date("n"),date("j")-$day)}
                			{$end=mktime(0,0,0,date("n"),date("j")-$day+1)}
                			{$incidentsDuring=$site->openIncidentsDuring($start, $end)}
							{if $incidentsDuring}
								<table class="bordered-table" name="sites_list_table"><!--Services table -->
									<thead>
									<th>Incident</th>
									<th>Description</th>
									<th>Time Opened</th>
									<th>Status</th>
									<th>Time Closed</th>
									</thead>
									<tbody>
									{foreach from=$incidentsDuring item=incident}
										<tr>
			                			<td>{$incident->reference|escape:html}</td>
			                			<td>{$incident->description|truncate|escape:html}</td>
			                			<td>{date('d-M H:i', $incident->start_time)}</td>
			                			<td>{StatusBoard_Status::name($incident->currentStatus())}</td>
			                			<td>{if $incident->actual_end_time}
			                			{date('d-M H:i', $incident->actual_end_time)}
			                			{else}
			                			Still Open
			                			{/if}
			             				</tr>	
             						{/foreach}
             				{else}
			             	<h4>There were no recorded incidents on this day</h4>
             				{/if}
        							</tbody>
        						</table><!--/name table -->
       					</div>
        			</div>
  				{/if}
			{/foreach}      	
		</div>
	</div>
</div>