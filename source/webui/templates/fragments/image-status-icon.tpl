{switch $status}
    {case StatusBoard_Status::STATUS_Resolved}
        {assign var=img_src value="{$base_uri}img/status/tick-circle.png"}
    {/case}
    {case StatusBoard_Status::STATUS_Maintenance}
        {assign var=img_src value="{$base_uri}img/status/traffic-cone.png"}
    {/case}
    {case StatusBoard_Status::STATUS_Minor}
        {assign var=img_src value="{$base_uri}img/status/exclamation.png"}
    {/case}
    {case StatusBoard_Status::STATUS_Significant}
        {assign var=img_src value="{$base_uri}img/status/exclamation.png"}
    {/case}
    {case StatusBoard_Status::STATUS_Major}
        {assign var=img_src value="{$base_uri}img/status/cross-circle.png"}
    {/case}
{/switch}
<img src="{$img_src}" alt="{StatusBoard_Status::name($status)}" />