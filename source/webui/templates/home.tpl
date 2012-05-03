
<div class="row">
    <div class='span10'>
        <h1 class='lead'><strong>{$site_title}</strong></h1>

        <p>Service Status Dashboard, detailing your current,past and future service status</p>
    </div>

    <div class="span2 align-right">
        {if $display_admin_links}<a href="{$base_uri}admin/add-incident/" class="btn"> Add Incident</a>{/if}
    </div>
</div>{if $upcoming_maintenance}

<div class="row">
    <div class="span2">
        <h5>Upcoming maintenance:</h5>
    </div>

    <div class="span10">
        <ul id="maintenance-list">
            <li style="list-style: none">{foreach from=$upcoming_maintenance item=incident}</li>

            <li>
                <a href="{$base_uri}incident/id/{$incident-id}/" title="View Maintenance">{$incident->reference|escape:html}</a>

                <p>{$incident->description|escape:html}</p>
            </li>

            <li style="list-style: none">{/foreach}</li>
        </ul>
    </div>
</div>{/if}

<div class="row">
    <div class="span12">
        {switch $home_mode} {case 'site'} {$page->include_template('fragments/home-site')} {/case} {default} {$page->include_template('fragments/home-service')} {/switch}
    </div>
</div><!-- row -->
<script type="text/javascript">
sb.home.init();
</script>

