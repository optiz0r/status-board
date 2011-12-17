<div id="statusboard">
    {foreach from=$services item=service}
        <div class="service">
            {$service->name()}
            {foreach from=$service->sites() item=site}
                {assign var=incidents value=$site->openIncidents()}
                <div class="site">
                    {$site->name()} ({StatusBoard_Status::name($site->status())})
                    {foreach from=$incidents item=incident}
                        <div class="incident">
                            {StatusBoard_Status::name($incident->currentStatus())}: {$incident->description()}
                        </div>
                    {/foreach}
                </div>            
            {foreachelse}
            
            {/foreach}
        </div>
    {/foreach}
</div>
