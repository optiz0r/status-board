<div id="statusboard">
    {foreach from=$services item=service}
        <div class="service">
            {$service->name()}
            {foreach from=$service->sites() item=site}
                {assign var=incidents value=$site->incidents_open()}
                <div class="site">
                    {$site->name()} ({$incidents|count})
                    {foreach from=$incidents item=incident}
                        <div class="incident">
                            {$incident->description()}
                        </div>
                    {/foreach}
                </div>            
            {foreachelse}
            
            {/foreach}
        </div>
    {/foreach}
</div>
