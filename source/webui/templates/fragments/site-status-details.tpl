{StatusBoard_Status::description($status)|escape:html}

{if $incidents}
    <dl>
        {foreach from=$incidents item=incident}
            <dt>
                <h4>
                {include file="fragments/image-status-icon.tpl" assign=image status=$incident->currentStatus()}{$image|escape:html}
                {$incident->reference|escape:html}
               	</h4>
            </dt>
            <dd>
                <p>
                {$incident->description|truncate|escape:html}
                </p>
            </dd>
        {/foreach}
    </dl>
{/if}