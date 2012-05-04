<div class="row space-below">
    <div class="span12"> 
        <ul class="breadcrumb">
          <li><a href="{$base_uri}admin/tab/users/">Admin</a> <span class="divider">|</span></li>
          <li class="active"><a href="#">User {$user->username()|escape:html}</a></li>
        </ul>

        <h2>User: {$user->username()|escape:html}</h2>
    </div>
</div>

<div class="row space-below">
    <div class="span3">
        <h3>Login Details</h3>
    </div>
    <div class="span9">
        <div class="row">
            <div class="span2">
                <div class="block_info">
                    <div class="block_info_title">
                        <h4>Last Login</h4>
                    </div>
                    <div class="block_info_content">
                        {$user->lastLoginTime()|fuzzyTime|ucfirst}
                    </div>
                </div>
            </div>
            <div class="span3">
                <div class="block_info">
                    <div class="block_info_title">
                        <h4>Last Password Change</h4>
                    </div>
                    <div class="block_info_content">
                        {$user->lastPasswordChangeTime()|fuzzyTime|ucfirst}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row space-below">
    <div class="span3">
        <h3>Edit Details</h3>
        <p>Use this form to edit this User's information.</p>
    </div>
    <div class="span9">
        <form class="form-horizontal" id="admin_user_edit" method="post" action="{$base_uri}admin/user/username/{$user->username()|escape:url}/do/edit/">
            <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
            <fieldset>
                <div class="control-group">
                    <label class="control-label" for="admin_user_edit_name">Name</label>
                    <div class="controls">
                        <input id="admin_user_edit_name" name="name" type="text" value="{$user->realName()|escape:html}" />
                    </div>
                </div><!-- /control-group -->
                
                <div class="control-group">
                    <label class="control-label" for="admin_user_edit_email">Email Address</label>
                    <div class="controls">
                        <input id="admin_user_edit_email" name="email" type="text" value="{$user->emailAddress()|escape:html}" />
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
        <h3>Reset Password</h3>
        <p>Use this form to reset this user's password.</p>
    </div>
    <div class="span9">
        <form class="form-horizontal" id="admin_user_passwd" method="post" action="{$base_uri}admin/user/username/{$user->username()|escape:url}/do/password-reset/">
            <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
            <fieldset>
                <div class="control-group">
                    <label class="control-label" for="admin_user_passwd_new">New Password</label>
                    <div class="controls">
                        <input id="admin_user_passwd_new" name="password" type="password" value="" />
                    </div>
                </div><!-- /control-group -->
                
                <div class="control-group">
                    <label class="control-label" for="admin_user_passwd_confirm">Confirm Password</label>
                    <div class="controls">
                        <input id="admin_user_passwd_confirm" name="confirm" type="password" value="" />
                        <span class="help-inline" style="display: none" id="admin_user_passwd_confirmpassword_help">The passwords do not match.</span>
                    </div>
                </div><!-- /control-group -->

                <div class="control-group">
                    <div class="controls">
                        <button class="btn btn-primary">
                            <i class="icon-edit icon-white"></i>
                            Reset Password
                        </button>
                        <button type="reset" class="btn btn-secondary">
                            <i class="icon-refresh"></i>
                            Cancel
                        </button>
                    </div>
                </div>
            </fieldset>
        </form>
    </div>
</div>

<div class="row space-below">
    <div class="span3">
        <h3>Groups</h3>
        <p>Groups the user is a member of.</p>
    </div>
    <div class="span9">
        {if $groups}
            <table class="table table-bordered table-striped" id="group_list_table">
                <thead>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Action</th>
                </thead>
                <tbody>
                    {foreach from=$groups item=group}
                        <tr>
                            <td>
                                {$group->name()|escape:html}
                            </td>
                            <td>{$group->description()|escape:html}</td>
                            <td>
                                <button class='btn btn-danger' onclick="sb.admin.deleteItem('{$base_uri}admin/user/username/{$user->username()|escape:url}/do/delete-group/name/{$group->name()|escape:url}/', '{$csrftoken|escape:quotes}');">
                                    <i class="icon-minus icon-white"></i>
                                    Remove
                                </button>
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        {else}
            You haven't added this user to any groups yet. Add some with the button below.
        {/if}
    </div>
</div>

<div class="row space-below">
    <div class="span3">
        <h3>Add to Groups</h3>
        <p>Add this user to additional groups.</p>
    </div>
    <div class="span9">
        <form class="form-horizontal" id="admin_addgroup" method="post" action="{$base_uri}admin/user/username/{$user->username()|escape:url}/do/add-groups/">
            <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
            <fieldset>
                <div class="control-group">
                    <label class="control-label" for="admin_user_add_group">Groups</label>
                    <div class="controls">
                        {foreach from=$user->unusedGroups() item=group}
                            <label class="checkbox" id="admin_user_add_group_{$group->name()|escape:html}">
                                <input type="checkbox" id="admin_user_add_group_{$group->name()}" name="groups[]" value="{$group->name()|escape:html}" />
                                {$group->name()|escape:html}
                            </label>
                        {foreachelse}
                            <em>There are no other groups that this user can be added to.</em>
                        {/foreach}
                    </div>
                </div><!-- /control-group -->
                
                <div class="control-group">
                    <div class="controls">
                        <button class="btn btn-primary">
                            <i class="icon-plus icon-white"></i>
                            Add to Groups
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
