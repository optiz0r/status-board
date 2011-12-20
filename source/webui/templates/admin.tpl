<h1>Services</h1>

<p>
    Click on a Service to edit its properties, or access any of the sites defined under it.
</p>

{if $services}
    <dl>
        {foreach from=$services item=service}
            <dt><a href="{$base_uri}admin/service/id/{$service->id}/" title="Edit site {$service->name|escape:html}">{$service->name|escape:html}</a></dt>
            <dd>{$service->description|escape:html}</dd>
        {/foreach}
    </dl>
{else}
    You haven't created any services yet. Create some with the button below.
{/if}

<form id="admin_addservice" method="post" action="{$base_uri}admin/add-service/">
    <input type="button" class="btn success" name="addservice" value="Add Service" />
</form>


<h1>Users and Permissions</h1>

<p>
    Click on a User to edit its properties.
</p>

<ul>
    {foreach from=$users item=user}
        <li><a href="{$base_uri}admin/user/id/{$user->id}/" title="Edit user {$user->username|escape:html}">{$user->username|escape:html}</a></li>
    {/foreach}
</ul>

<form id="admin_adduser" method="post" action="{$base_uri}admin/add-user/">
    <input type="button" class="btn success" name="adduser" value="Add User" />
</form>