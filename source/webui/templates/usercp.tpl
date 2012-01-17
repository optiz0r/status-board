<div class="container">
    <div class="row">
        <div class="span16">
            <form id="usercp_pwchange" method="post" action="{$base_uri}usercp/do/change-password/">
                <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
                <fieldset>
                    <legend>Change Password</legend>
                    
                    <div class="clearfix">
                        <label for="usercp_currentpassword">Current Password</label>
                        <div class="password">
                            <input class="xlarge span5" id="usercp_currentpassword" name="currentpassword" type="password"/>
                        </div>
                    </div><!-- /clearfix -->
                    
                    <div class="clearfix">
                        <label for="usercp_newpassword">New Password</label>
                        <div class="password">
                            <input class="xlarge span5" id="usercp_newpassword" name="newpassword" type="password"/>
                        </div>
                    </div><!-- /clearfix -->
                    
                    <div class="clearfix">
                        <label for="usercp_confirmpassword">Confirm Password</label>
                        <div class="password">
                            <input class="xlarge span5" id="usercp_confirmpassword" name="confirmpassword" type="password"/>
                            <span class="help-inline" style="display: none" id="usercp_confirmpassword_help">The passwords do not match.</span>
                        </div>
                    </div><!-- /clearfix -->
                    
                    <div class="input">
                        <div class="clearfix">
                            <input type="submit" class="btn primary" value="Change Password">&nbsp;<button type="reset" class="btn">Cancel</button>
                        </div>
                    </div>
                </fieldset>
            </form>
        </div><!-- /span16 -->   
    </div><!-- /row -->
</div><!-- /container -->

<script type="text/javascript">
    $('document').ready(sb.usercp.init);
</script>