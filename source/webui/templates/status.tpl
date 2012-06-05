<div class="row space-below">
    <div class="span8">
        {if $site && $service}
            <h1>Site &amp; Service History</h1>
        {elseif $service}
            <h1>Service History</h1>
        {else}
            <h1>Site History</h1>
        {/if}
    </div>
    <div class="span4 align-right">
        {if $display_admin_links}
            {if $site && $service}
                <button class='btn btn-primary' onclick="document.location.href='{$base_uri}admin/site/id/{$site->id}/';return false;">
                    <i class="icon-edit icon-white"></i>
                    Edit Site
                </button>
                <button class='btn btn-primary' onclick="document.location.href='{$base_uri}admin/service/id/{$service->id}/';return false;">
                    <i class="icon-edit icon-white"></i>
                    Edit Service
                </button>
            {elseif $service}
                <button class='btn btn-primary' onclick="document.location.href='{$base_uri}admin/service/id/{$service->id}/';return false;">
                    <i class="icon-edit icon-white"></i>
                    Edit Service
                </button>
            {else}
                <button class='btn btn-primary' onclick="document.location.href='{$base_uri}admin/site/id/{$site->id}/';return false;">
                    <i class="icon-edit icon-white"></i>
                    Edit Site
                </button>
            {/if}
        {/if}
    </div>
</div>

<div class="row space-below">
    <div class="span3">
        <h3>Service Details</h3>
    </div>
    <div class="span9">
        {if $service}
            <div class="row">
                <div class="span2">
                    <div class="block_info">
                        <div class="block_info_title">
                            <h4>Service Name</h4>
                        </div>
                        <div class="block_info_content">
                            {$service->name|ucwords|escape:html}
                        </div>
                    </div>
                </div>
                <div class="span7">
                    <div class="block_info">
                        <div class="block_info_title">
                            <h4>Service Description</h4>
                        </div>
                        <div class="block_info_content">
                            {$service->description|ucfirst|escape:html}
                        </div>
                    </div>
                </div>
            </div>
        {/if}
    </div>
</div>
<div class="row space-below">
    <div class="span3">
        <h3>Site Details</h3>
    </div>
    <div class="span9">
        {if $site}
            <div class="row">
                <div class="span2">
                    <div class="block_info">
                        <div class="block_info_title">
                            <h4>Site Name</h4>
                        </div>
                        <div class="block_info_content">
                            {$site->name|ucwords|escape:html}
                        </div>
                    </div>
                </div>
                <div class="span7">
                    <div class="block_info">
                        <div class="block_info_title">
                            <h4>Site Description</h4>
                        </div>
                        <div class="block_info_content">
                            {$site->description|ucfirst|escape:html}
                        </div>
                    </div>
                </div>
            </div>
        {/if}
    </div>
</div>

{if $start && $end}
        {if $siteservice}
            {$incidentsDuring=$siteservice->openIncidentsDuring($start, $end)}
        {elseif $service}
            {$incidentsDuring=$service->openIncidentsDuring($start, $end)}
        {else}
            {$incidentsDuring=$site->openIncidentsDuring($start, $end)}
        {/if}
        {$incidentCount=count($incidentsDuring)}
        
        <div class="row">
            <div class="span3">
                <h3 class="status">{$start|date_format:"d M Y"} - {$end|date_format:"d M Y"}</h3><a name="{$start|date_format:"dM"}"></a>
                <p>{$incidentCount} {StatusBoard_Formatting::pluralise($incidentCount,'incident','incidents')}</p>
                {if $incidentsDuring}<p style="font-size:small"> Note: Click on incident number to see incident history</p>{/if}
            </div>
            <div class="span9">
                {include file="fragments/incidents-list.tpl" incidents=$incidentsDuring}
            </div>
        </div>
{else}
    {foreach from=array(0,1,2,3,4,5,6) item=day}
        {$start=mktime(0,0,0,date("n"),date("j")-$day)}
        {$end=mktime(0,0,0,date("n"),date("j")-$day+1)}
        {if $siteservice}
            {$incidentsDuring=$siteservice->openIncidentsDuring($start, $end)}
        {elseif $service}
            {$incidentsDuring=$service->openIncidentsDuring($start, $end)}
        {else}
            {$incidentsDuring=$site->openIncidentsDuring($start, $end)}
        {/if}
        {$incidentCount=count($incidentsDuring)}
        
        <div class="row">
            <div class="span3">
                <h3 class="status">{$start|date_format:"d M Y"}</h3><a name="{$start|date_format:"dM"}"></a>
                <p>{$incidentCount} {StatusBoard_Formatting::pluralise($incidentCount,'incident','incidents')}</p>
                {if $incidentsDuring}<p style="font-size:small"> Note: Click on incident number to see incident history</p>{/if}
            </div>
            <div class="span9">
                {include file="fragments/incidents-list.tpl" incidents=$incidentsDuring}
            </div>
        </div>
    {/foreach}
{/if}