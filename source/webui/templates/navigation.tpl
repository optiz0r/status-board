<a class="brand" href="{$base_uri}home/">StatusBoard</a>

<ul class="nav">
    <li class="active"><a href="{$base_uri}home/" title="Home">Home</a></li>
    
    {if $display_admin}
        <li><a href="{$base_uri}admin/" title="Admin">Admin</a></li>
    {/if}

    {if $display_login}
        <li><a href="{$base_uri}login/" title="Login">Login</a></li>
    {else}
        <li><a href="{$base_uri}logout/" title="Logout">Logout</a></li>
    {/if}
</ul>

<p class="pull-right">
    Logged in as <a href="#">username</a>
</p>