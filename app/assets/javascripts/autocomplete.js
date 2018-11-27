
       $(document).ready(function(){
        $("#keyup").on('keyup', function(e){
            // console.log("hello");

            $.ajax({
                url:"/projects",
                method:"GET",
                data: $("#keyup").serialize(),
                dataType:"json",
                success: function(data){

                    // console.log(data);
                    var box = document.getElementById("titles")
                    box.innerHTML = ""
                    data.forEach(function(project){
                        var item = document.createElement("option")
                        item.value = project.title
                        box.append(item)
                    })

                    // body...
                }
        })

    })



})


       $(document).ready(function(){
        $("#keyupz").on('keyup', function(e){
            // console.log("hello");

            $.ajax({
                url:"/projects",
                method:"GET",
                data: $("#keyupz").serialize(),
                dataType:"json",
                success: function(data){

                    // console.log(data);
                    var box = document.getElementById("titles")
                    box.innerHTML = ""
                    data.forEach(function(project){
                        var item = document.createElement("option")
                        item.value = project.title
                        box.append(item)
                    })

                    // body...
                }
        })

    })



})

