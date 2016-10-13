
local template = require("resty.template")

ngx.log(ngx.WARN,"html....")
template.render("view.html", {message = "hello world"})