package.path = "./?.lua;" .. package.path
package.path = "./src/?.lua;" .. package.path
package.path = "./lib/?.lua;" .. package.path

Utils = require("utils")
Config = require("config")
