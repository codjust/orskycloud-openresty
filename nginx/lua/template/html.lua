
local template = require("resty.template")

-- local view = template.new()
-- ngx.log(ngx.WARN,"html....")
-- template.render("view.html", {message = "hello world"})

ngx.log(ngx.WARN,"html....")
-- local view = template.new "view.html"
-- view.message = "Hello, World!"
-- view:render()
template.render("view.html", {message = "world"})

ngx.log(ngx.WARN,"html....end")