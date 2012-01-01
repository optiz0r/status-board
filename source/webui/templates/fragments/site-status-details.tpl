{StatusBoard_Status::description($status)|escape:html}

{if $incidents}
    <dl>
        {foreach from=$incidents item=incident}
            <dt>{$incident->reference|escape:html} <em>({StatusBoard_Status::name($incident->currentStatus())})</em></dt>
            <dd>{$incident->description|truncate|escape:html}</dd>
        {/foreach}
    </dl>
{/if}