<a class="brand" href="{$base_uri}home/">StatusBoard</a>

<ul class="nav">
    <li {if $requested_page == home}class="active"{/if}>
        <a href="{$base_uri}home/" title="Home">Home</a>
    </li>
    
    {if $authenticated}
        {if $auth->isAdministrator()}
			<li class="dropdown {if $requested_page == admin}active{/if}" data-dropdown="dropdown">
                <a href="{$base_uri}admin/" class="dropdown-toggle" title="Admin">Admin</a>
                <ul class="dropdown-menu">
                    <li><a href="{$base_uri}admin/tab/admin/" title="Admin">Admin</a></li>
                    <li><a href="{$base_uri}admin/tab/services/" title="Manage Services">Services</a></li>
                    <li><a href="{$base_uri}admin/tab/users/" title="Manage Users">Users</a></li>
                    <li><a href="{$base_uri}admin/tab/settings/" title="Manage Settings">Settings</a></li>
                </ul>
            </li>
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