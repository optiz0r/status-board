/**
 * StatusBoard main script file
 *
 * 
 */

 
var sb = {
     
    init: function() {
        // Properly format any alert boxes
        $('.alert-data').alert();
        
        // Properly format any tab widgets
        $('.tabs').tabs();
        
        // Display popovers on all configured items
        $("a[rel=popover]").popover({
          offset: 10,
          html: true,
        });
    },
     
    usercp: {
 
        init: function() {
            $('#usercp_newpassword,#usercp_confirmpassword').bind('keyup', sb.usercp.checkPassword);
             
        },
         
        checkPassword: function() {
            password = $('#usercp_newpassword');
            confirm = $('#usercp_confirmpassword');
             
            confirm_container = confirm.parent().parent();
             
            if (password.val() == confirm.val()) {
                console.log("passwords match");
                confirm_container.removeClass('error').addClass('success');
                $('#usercp_confirmpassword_help').hide();
            } else {
                console.log("passwords do not match");
                confirm_container.addClass('error').removeClass('success');
                $('#usercp_confirmpassword_help').show();
            }
        }
         
    }
         
};
 
$('document').ready(sb.init);
