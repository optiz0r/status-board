<div class="row"><!-- Row for Board title and header -->
    <div class='span10'>
        <h1 class='lead'><strong>{$site_title}</strong></h1>

        <p>Service Status Dashboard, detailing your current,past and future service status</p>
    </div>

    <div class="span2 align-right">
        {if $display_admin_links}<a href="{$base_uri}admin/add-incident/" class="btn"> Add Incident</a>{/if}
    </div>
</div><!--/Row for Board title and header -->
{if $upcoming_maintenance}
<div class="row"> <!--Row for Upcoming maintenance if it exists -->
    <div class="span12"><!-- List all upcoming maintenance -->
        <p style="float: left;">Scheduled Maintenance:</p> 
        <ul id="maintenance-list">
            {foreach from=$upcoming_maintenance item=incident}</li>
            <li>
                <a href="{$base_uri}incident/id/{$incident->id}/" title="View Maintenance">{$incident->reference|escape:html}</a>
                <p>{$incident->description|escape:html}</p>
			</li>
			{/foreach}
        </ul>
    </div> <!-- /List all upcoming maintenance -->
</div> <!--/Row For upcoming maintenance -->
{/if}

<div class="row"><!--Row for Board status matrix -->
    <div class="span12"><!--Board status matrix -->
        {switch $home_mode} {case 'site'} {$page->include_template('fragments/home-site')} {/case} {default} {$page->include_template('fragments/home-service')} {/switch}
    </div><!--/Board status matrix -->
</div><!--/Row for Board status matrix -->
<!--Load homepage JS at end to speed up page load-->
<script type="text/javascript">
sb.home.init();
</script>

