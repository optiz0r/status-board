{if $authentication_failed}

<div class="data-alert">
    Incorrect username/password combination entered.
</div>

{/if}

<form id="page_login" method="post" action="{$base_uri}login/do/">
    <label for="page_username">Username</label>
    <input id="page_username" type="text" name="username" />
    
    <label for="page_password">Password</label>
    <input id="page_password" type="password" name="password" />
    
    <input id="page_login" type="submit" class="success" />
</form>