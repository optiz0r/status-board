<div class="container">
<div class="row">
<div class="span16" name="name"><!--name content container -->   
        <h1>Site Status History {$service->name|escape:html}-{$site->name|escape:html}</h1>
        <p>This page details the incident history for a Site related to a Service</p>
			{foreach from=array(0,1,2,3,4,5,6) item=day}
                    {if $day == 0}
         			<div class="row" name="edit service">
                    <div class="span4 column"><!--New description-->
                        <h3 class="status">Today {mktime(0,0,0,date("n"),date("j"))|date_format:"d M Y"}</h3>
                        <p>x incidents</p>
                        </div>
                        
         <div class="span12 column">
			<table class="bordered-table" name="sites_list_table"><!--Services table -->
				<thead>
				<th>Incident</th>
				<th>Description</th>
				<th>Time Opened</th>
				<th>Status</th>
				<th>Time Closed</th>
				</thead>
				<tbody>
             <tr>
             	<td>123456</td>
                <td>Loss of power on remote site</td>
                <td>14:00</td>
                <td>Major Incident</td>
                <td>-</td>
             </tr><tr>
                <td>123457</td>
                <td>Loss of power on remote site</td>
                <td>14:00</td>
                <td>Major Incident</td>
                <td>-</td>
                </tr>
        	</tbody>
        	</table><!--/name table -->
       	</div>
       	</div>
  				    {else}
  				    <div class="row" name="edit service">
  				    <div class="span4 column"><!--New description-->
                        <h3 class="status">{mktime(0,0,0,date("n"),date("j")-$day)|date_format:"d M Y"}</h3>
                        <p>x incidents</p>
                        </div>
                        
                        <div class="span12 column">
			<table class="bordered-table" name="sites_list_table"><!--Services table -->
				<thead>
				<th>Incident</th>
				<th>Description</th>
				<th>Time Opened</th>
				<th>Status</th>
				<th>Time Closed</th>
				</thead>
				<tbody>
             <tr>
             	<td>123456</td>
                <td>Loss of power on remote site</td>
                <td>14:00</td>
                <td>Major Incident</td>
                <td>-</td>
             </tr><tr>
                <td>123457</td>
                <td>Loss of power on remote site</td>
                <td>14:00</td>
                <td>Major Incident</td>
                <td>-</td>
                </tr>
        	</tbody>
        	</table><!--/name table -->
        	</div>
        	</div>
  				    {/if}
				{/foreach}
        	
</div>
</div>