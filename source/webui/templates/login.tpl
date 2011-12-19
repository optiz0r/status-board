{if $authentication_failed}

<div class="alert-message error">
    Incorrect username/password combination entered.
</div>

{/if}

<div class="container">
    <div class="row">
        <div class="span16">
        	<form id="page_login" method="post" action="{$base_uri}login/do/">
                <fieldset>
                    <legend>Administrator Login</legend>
                    <div class="clearfix">
                        <label for="xlInput">Username</label>
                        <div class="input">
                            <input class="xlarge" id="page_username" name="username" size="30" type="text"/>
                        </div>
                    </div><!-- /clearfix -->
        			<div class="clearfix">
                        <label for="input">Password</label>
                        <div class="password">
                            <input class="xlarge" id="page_password" name="password" size="30" type="password"/>
                        </div>
                    </div><!-- /clearfix -->
                    <div class="input">
                        <div class="clearfix">
                            <input type="submit" class="btn primary" value="Login">&nbsp;<button type="reset" class="btn">Cancel</button>
                        </div>
                    </div>
                </fieldset>
            </form>
        </div><!-- /span16 -->   
    </div><!-- /row -->
</div><!-- /container -->