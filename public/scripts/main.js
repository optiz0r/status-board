/**
 * StatusBoard main script file
 *
 * 
 */

var sb = {
    
    init: function() {
        $('.alert-data').alert();
    }
        
};

$('document').ready(sb.init);

            $(function () {
              $("a[rel=popover]")
                .popover({
                  offset: 10
                })
                .click(function(e) {
                  e.preventDefault()
                })
            })