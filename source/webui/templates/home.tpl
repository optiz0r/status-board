<div class="row">

	<div class='span10'>
	  <h1 class='lead'>
        <strong>{$site_title}</strong> 
      </h1>
      <p>Service Status Dashboard, detailing your current,past and future service status
      </p>
    </div>
        
    <div class="span2">
        {if $display_admin_links}<a href="{$base_uri}admin/add-incident/" class="btn"><i class="icon-plus"></i> Add Incident</a>{/if}
    </div>
</div>

<div class="row">
	<div class="span2">
	<h5>Upcoming maintenance:</h5>
	</div>
    <div class="span10">
                <ul id="ticker">
                    <li>
                        <a href="#">
                         Service X1    
                        </a>
                        <p>Description</p>
                    </li>
                     <li>
                        <a href="#">
                         Service X2    
                        </a>
                        <p>Description</p>
                    </li>
					<li>
                        <a href="#">
                         Service X3  
                        </a>
                        <p>Description</p>
                    </li>
                   <li>
                        <a href="#">
                         Service X4    
                        </a>
                        <p>Description</p>
                    </li>
                </ul>
            </div>
         <div class="span12">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Service / Site</th>
                    <th class="status">Now</th>
                    {foreach from=array(0,1,2,3,4,5,6) item=day}
                        {if $day == 0}
                            <th class="status">Today</th>
      				    {else}
                            <th class="status">{mktime(0,0,0,date("n"),date("j")-$day)|date_format:"M j"}</th>
      				    {/if}
    				{/foreach}
                </tr>
            </thead>
            <tbody>
                {foreach from=$services item=service}
                    <tr>
                        <th colspan="9" class="service">
                            {if $display_admin_links}
                                <a href="{$base_uri}admin/service/id/{$service->id}/" title="Edit {$service->name}">{$service->name}</a>
                            {else}
                                {$service->name}
                            {/if}
                        </th>
                    </tr>
                    {foreach from=$service->siteInstances() item=site_instance}
                        {$site=$site_instance->site()}
                        {$incidents=$site_instance->openIncidents()}
                        <tr class="site">
                            <td>
                                {if $display_admin_links}
                                    <a href="{$base_uri}admin/site/id/{$site->id}/" title="Edit {$site->name|escape:html}">{$site->name|escape:html}</a>
                                {else}
                                    {$site->name}
                                {/if}
                            </td>
                            <td class="status">
                                {$status=$site_instance->status()}
                                {include file="fragments/site-status.tpl" nocache date=null start=null end=null}
                            </td>
                            {foreach from=array(0,1,2,3,4,5,6) item=day}
                                {$start=mktime(0,0,0,date("n"),date("j")-$day)}
                                {$end=mktime(0,0,0,date("n"),date("j")-$day+1)}
                                {$date=mktime(0,0,0,date("n"),date("j")-$day)|date_format:"jM"}
                                {$incidentsDuring=$site_instance->openIncidentsDuring($start, $end)}
                                {$statusDuring=StatusBoard_Incident::highestSeverityStatusBetween($incidentsDuring, $start, $end)}
                                <td class="status">
                                    {include file="fragments/site-status.tpl" nocache start=$start end=$end status=$statusDuring incidents=$incidentsDuring}
                                </td>
                            {/foreach}
                        </tr>
                    {/foreach}
                {/foreach}
            </tbody>
        </table>
    </div>
</div><!-- row -->