<div class="container">
<div class="row">
<div class="span16" name="name"><!--name content container -->   
        <h1>Site Status History {$service->name|escape:html}LDAP - External{$site->name|escape:html}</h1>
        <p>This page details the incident history for a Site related to a Service</p>
        <div class="row" name="edit service">
			<div class="span4 column"><!--New description-->
        	<h3>Today 21/12/11</h3>
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
<div class="row" name="edit service">
			<div class="span4 column"><!--New description-->
        	<h3>Yesterday 20/12/11</h3>
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
                <td>Resolved</td>
                <td>15:00</td>
                </tr>
        	</tbody>
        	</table><!--/name table -->
		</div>
</div>

</div>
</div>