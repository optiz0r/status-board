{switch $status}
    {case StatusBoard_Status::STATUS_Resolved}
        {assign var=img_src value="{$base_uri}images/Status_Icons/tick-circle.png"}
    {/case}
    {case StatusBoard_Status::STATUS_Maintenance}
        {assign var=img_src value="{$base_uri}images/Status_Icons/traffic-cone.png"}
    {/case}
    {case StatusBoard_Status::STATUS_Minor}
        {assign var=img_src value="{$base_uri}images/Status_Icons/exclamation.png"}
    {/case}
    {case StatusBoard_Status::STATUS_Significant}
        {assign var=img_src value="{$base_uri}images/Status_Icons/exclamation.png"}
    {/case}
    {case StatusBoard_Status::STATUS_Major}
        {assign var=img_src value="{$base_uri}images/Status_Icons/cross-circle.png"}
    {/case}
{/switch}
<img src="{$img_src}" alt="{StatusBoard_Status::name($status)}" />