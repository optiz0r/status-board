<div class="container">
    <div class="row">
        <div class="span12">
            <form class="form-horizontal" id="usercp_pwchange" method="post" action="{$base_uri}usercp/do/change-password/">
                <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}" />
                <fieldset>
                    <legend>Change Password</legend>
					 <div class="control-group">
	                    <label class="control-label" for="usercp_currentpassword">Current Password:</label>
	                    <div class="controls">
	                        <input id="usercp_currentpassword" name="currentpassword" type="password"/>
	                    </div>
	                </div><!-- /control-group -->
                     <div class="control-group">
	                    <label class="control-label" for="usercp_newpassword">New Password:</label>
	                    <div class="controls">
	                        <input id="usercp_newpassword" name="newpassword" type="password"/>
	                    </div>
	                </div><!-- /control-group -->
	                <div class="control-group">
	                    <label class="control-label" for="usercp_confirmpassword">Confirm Password:</label>
		                <div class="controls">
	                        <input id="usercp_confirmpassword" name="confirmpassword" type="password"/>
	                        <span class="help-inline" style="display: none" id="usercp_confirmpassword_help">The passwords do not match.</span>
	                    </div>
	                </div><!-- /control-group -->
		                  <div class="controls">
		                       <button class="btn btn-primary" value="Change Password">
		                           <i class="icon-ok icon-white"></i>
		                           Change Password
		                       </button>
		                       <button class="btn btn-secondary" type="reset">
		                           <i class="icon-refresh"></i>
		                           Reset
		                       </button>
	                    </div>
	                </fieldset>
	            </form>
	        </div><!-- /span16 -->   
	    </div><!-- /row -->
	</div><!-- /container -->

<script type="text/javascript">
    $('document').ready(sb.usercp.init);
</script>