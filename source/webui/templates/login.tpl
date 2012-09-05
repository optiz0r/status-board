<div class="container">
    <div class="row">
        <div class="span12">
            <form class="form-horizontal" id="page_login" method="post" action="{$base_uri}login/do/">
                <input type="hidden" name="csrftoken" value="{$csrftoken|escape:html}">

                <fieldset>
                    <legend>Administrator Login</legend>

                    <div class="control-group">
                        <label class="control-label" for="page_username">Username:</label>

                        <div class="controls">
                            <input id="page_username" name="username" type="text">
                        </div>
                    </div><!-- /control-group -->

                    <div class="control-group">
                        <label class="control-label" for="page_password">Password:</label>

                        <div class="controls">
                            <input id="page_password" name="password" type="password">
                        </div>
                    </div><!-- /control-group -->

                    <div class="controls">
                        <button class="btn btn-primary" type="submit" value="Submit">Login</button> <button class="btn btn-secondary" type="reset">Reset</button>
                    </div>
                </fieldset>
            </form>
        </div><!-- /span16 -->
    </div><!-- /row -->
</div><!-- /container -->

