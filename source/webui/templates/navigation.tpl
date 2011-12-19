<a class="brand" href="{$base_uri}home/">StatusBoard</a>

<ul class="nav">
{if $requested_page == home}
<li class="active">
{else}
<li>
{/if}
<a href="{$base_uri}home/" title="Home">Home</a></li>
    
    {if $authenticated}
        {if $auth->isAdministrator()}
        {if $requested_page == admin}
			<li class="active">
			{else}
			<li>
			{/if}
            <a href="{$base_uri}admin/" title="Admin">Admin</a></li>
        {/if}
        <li><a href="{$base_uri}logout/" title="Logout">Logout</a></li>
    {else}
        <li><a href="{$base_uri}login/" title="Login">Login</a></li>
    {/if}
</ul>

{if $authenticated}
    <p class="pull-right">
        Logged in as <a href="{$base_uri}usercp/">{$user->username}</a>
    </p>
{/if}