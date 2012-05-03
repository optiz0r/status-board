<a class="brand" href="{$base_uri}home/">StatusBoard</a>

<ul class="nav">
    <li><a href="{$base_uri}home/" title="Home">Home</a></li>

    <li style="list-style: none">{if $authenticated} {if $auth->isAdministrator()}</li>

    <li class="dropdown {if $requested_page == admin}active{/if}" data-dropdown="dropdown">
        <a href="{$base_uri}admin/" class="dropdown-toggle" title="Admin">Admin</a>

        <ul class="dropdown-menu">
            <li><a href="{$base_uri}admin/tab/summary/" title="Summary">Summary</a></li>

            <li><a href="{$base_uri}admin/tab/services/" title="Manage Services">Services</a></li>

            <li><a href="{$base_uri}admin/tab/settings/" title="Manage Settings">Settings</a></li>
        </ul>
    </li>

    <li style="list-style: none">{/if}</li>

    <li><a href="{$base_uri}logout/" title="Logout">Logout</a></li>

    <li style="list-style: none">{else}</li>

    <li><a href="{$base_uri}login/" title="Login">Login</a></li>

    <li style="list-style: none">{/if} {if $requested_page == home}</li>

    <li><a href='#' data-placement='bottom' rel='popover' data-content='{include file="fragments/icon-help.tpl"}' data-original-title='What do the status icons mean?'>Help</a></li>

    <li style="list-style: none">{/if}</li>
</ul>{if $authenticated}

<ul class="nav pull-right">
    <li style="padding: 10px 10px 11px; line-height: 19px;">Logged in as:</li>

    <li><a href="{$base_uri}usercp/" style="color: #FFF;">{$user->username}</a></li>
</ul>{/if}

