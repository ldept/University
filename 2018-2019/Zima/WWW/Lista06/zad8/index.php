<?php
setcookie("name","value");
setcookie("name2","value2",NULL,NULL,NULL,NULL,True);
?>
<html>
 <head>
  <title>PHP Test</title>
 </head>
 <body>
 <?php
     print_r($_COOKIE);?> 

 <br>
 <span id="id" style="color:red"></span>
 <script type="text/javascript">
    var x = document.cookie;
    document.getElementById("id").innerHTML=x;
 </script>

 </body>
</html>
