<a class="brand" href="{$base_uri}home/">StatusBoard</a>

<ul class="nav"><!--Navigation list container -->
    <li {if $requested_page == home}class="active"{/if}>
        <a href="{$base_uri}home/" title="Home">Home</a>
    </li>
    
    {if $authenticated}
        {if $auth->isAdministrator()}
			<li class="dropdown {if $requested_page == admin}active{/if}" data-dropdown="dropdown">
                <a href="{$base_uri}admin/" class="dropdown-toggle" title="Admin">Admin</a>
                <ul class="dropdown-menu">
                    <li><a href="{$base_uri}admin/tab/summary/" title="Summary">Summary</a></li>
                    <li><a href="{$base_uri}admin/tab/services/" title="Manage Services">Services</a></li>
                    <li><a href="{$base_uri}admin/tab/settings/" title="Manage Settings">Settings</a></li>
                </ul>
            </li>
        {/if}
        <li><a href="{$base_uri}logout/" title="Logout">Logout</a></li>
    {else}
        <li><a href="{$base_uri}login/" title="Login">Login</a></li>
    {/if}
    {if $requested_page == home}
    <!--display help link with popover-->
    <li><a href='#' data-placement='bottom' rel='popover' data-content='{include file="fragments/icon-help.tpl"}' data-original-title='What do the status icons mean?'>Help</a></li>
    <!--/display help link with popover-->
    {/if}
</ul><!--/Navigation list container -->
{if $authenticated}
    <ul class="nav pull-right" ><!--Logged in user container-->
       <li style="padding: 10px 10px 11px; line-height: 19px;">Logged in as:</li> 
       <li><a href="{$base_uri}usercp/" style="color: #FFF;">{$user->username}</a></li>
    </ul><!--/Logged in user container-->
{/if}