{$statuses=StatusBoard_Status::available()}
<dl class="help">
    {foreach from=$statuses item=status}
        <dt>
            {include file="fragments/image-status-icon.tpl"}
            <strong>{StatusBoard_Status::name($status)}</strong>
        </dt>
        <dd>
            {StatusBoard_Status::description($status)}
        </dd>
    {/foreach}
</dl>