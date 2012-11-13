# coding: utf-8

前提 /^トップページを表示している$/ do
  visit "/"
  find("body").should have_content("自販機")
end
