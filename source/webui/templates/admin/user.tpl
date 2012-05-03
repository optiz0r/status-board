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
