<div class="row space-below">
    <div class="span12"> 
        <ul class="breadcrumb">
          <li><a href="{$base_uri}admin/tab/groups/">Admin</a> <span class="divider">|</span></li>
          <li class="active"><a href="#">Group {$group->name()|escape:html}</a></li>
        </ul>

        <h2>Group: {$group->name()|escape:html}</h2>
    </div>
</div>

<div class="row space-below">
    <div class="span3">
        <h3>Edit Details</h3>
        <p>Use this form to edit this Group's information.</p>
    </div>
    <div class="span9">
        <form class="form-horizontal" id="admin_group_edit" method="post" action="{$base_uri}admin/group/name/{$group->name()|escape:url}/do/edit/">
            <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
            <fieldset>
                <div class="control-group">
                    <label class="control-label" for="admin_group_edit_name">Name</label>
                    <div class="controls">
                        <input id="admin_group_edit_name" name="name" type="text" value="{$group->name()|escape:html}" />
                    </div>
                </div><!-- /control-group -->
                
                <div class="control-group">
                    <label class="control-label" for="admin_group_edit_description">Description</label>
                    <div class="controls">
                        <textarea id="admin_group_edit_description" name="description" rows="3">{$group->description()|escape:html}</textarea>
                    </div>
                </div><!-- /control-group -->

                <div class="control-group">
                    <div class="controls">
                        <button class="btn btn-primary">
                            <i class="icon-edit icon-white"></i>
                            Save Changes
                        </button>
                        <button type="reset" class="btn btn-secondary">
                            <i class="icon-refresh"></i>
                            Reset
                        </button>
                    </div>
                </div>
            </fieldset>
        </form>
    </div>
</div>

<div class="row space-below">
    <div class="span3">
        <h3>Permissions</h3>
        <p>Permissions associated with this group.</p>
    </div>
    <div class="span9">
        {if $permissions}
            <table class="table table-bordered table-striped" name="permission_list_table">
                <thead>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Action</th>
                </thead>
                <tbody>
                    {foreach from=$permissions item=permission}
                        <tr>
                            <td>
                                {$permission->name()|escape:html}
                            </td>
                            <td>
                                {$permission->description()|escape:html}
                            </td>
                            <td>
                                <button class='btn btn-danger' onclick="sb.admin.deleteItem('{$base_uri}admin/group/name/{$group->name|escape:url}/do/delete-permission/id/{$permission->id}/', '{$csrftoken|escape:quotes}');">
                                    <i class="icon-minus icon-white"></i>
                                    Remove
                                </button>
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table><!--/name table -->
        {else}
            You haven't associated any permissions with this group yet. Add some with the button below.
        {/if}
    </div>
</div>

<div class="row space-below">
    <div class="span3">
        <h3>Add Permissions</h3>
        <p>Use this form to associate existing permissions with this group.</p>
    </div>
    <div class="span9">
        <form class="form-horizontal" id="admin_addpermission" method="post" action="{$base_uri}admin/group/name/{$group->name()|escape:html}/do/add-permissions/">
            <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
            <fieldset>
                <div class="control-group">
                    <label class="control-label" for="admin_group_add_permission">Permissions</label>
                    <div class="controls">
                        {foreach from=$group->unusedPermissions() item=permission}
                            <label class="checkbox" id="admin_group_add_permission_{$permission->id()}">
                                <input type="checkbox" id="admin_group_add_permission_{$permission->id()}" name="permissions[]" value="{$permission->id()}" />
                                {$permission->name()|escape:html}
                            </label>
                        {foreachelse}
                            <em>There are no other permissions that can be associated with this group.</em>
                        {/foreach}
                    </div>
                </div><!-- /control-group -->
                
                <div class="control-group">
                    <div class="controls">
                        <button class="btn btn-primary">
                            <i class="icon-plus icon-white"></i>
                            Associate Permissions
                        </button>
                        <button type="reset" class="btn btn-secondary">
                            <i class="icon-refresh"></i>
                            Reset
                        </button>
                    </div>
                </div><!-- /control-group -->
            </fieldset>
        </form>
    </div>
</div>

<div id="confirm_delete" class="modal hide fade">
    <div class="modal-header">
        Confirm deletion
    </div>
    <div class="modal-body">
        Deleting this object is final and cannot be reversed.                
    </div>
    <div class="modal-footer">
        <button class="btn btn-danger" id="confirm_delete_do">
            <i class="icon-trash icon-white"></i>
            Delete
        </button>              
        <button class="btn btn-secondary" id="confirm_delete_cancel">
            Cancel
        </button>
    </div>
</div>

