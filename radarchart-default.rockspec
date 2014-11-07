package="RadarChart"
version="%TAG%-1"
source = {
   url = "http://50.116.63.25/public/rocks/radarchart-%TAG%-1.zip",
   dir = "RadarChart-%TAG%"
}
description = {
   summary = "RadarChart is a radar/spider chart generator module for LÖVE.",
   detailed = [[
      RadarChart is a radar/spider chart generator module for LÖVE.
   ]],
   homepage = "https://github.com/josefnpat/RadarChart/",
   license = "zlib/libpng"
}
dependencies = {
   "lua >= 5.1",
}

build = {
   type = "module",
   modules = {
      radarchart = "radarchart.lua"
   }
}
