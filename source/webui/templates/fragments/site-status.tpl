<a href="{$base_uri}status/service/{$service->id}/id/{$site->id}/{if $date}#{$date}{/if}" class="" rel="popover" data-content="{include file="fragments/site-status-details.tpl"}" data-original-title="{StatusBoard_Status::name($status)|escape:html}">
    {include file="fragments/image-status-icon.tpl"}
</a>