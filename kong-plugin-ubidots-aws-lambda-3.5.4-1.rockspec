package = "kong-plugin-ubidots-aws-lambda"
version = "3.5.4-1"

supported_platforms = {"linux", "macosx"}
source = {
  url = "git://github.com/kong/kong-plugin-ubidots-aws-lambda",
  tag = "3.5.4",
}

description = {
  summary = "Kong plugin to invoke AWS Lambda functions",
  homepage = "http://konghq.com",
  license = "Apache 2.0"
}

dependencies = {
  "lua-resty-openssl",
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins.ubidots-aws-lambda.aws-serializer"]       = "kong/plugins/ubidots-aws-lambda/aws-serializer.lua",
    ["kong.plugins.ubidots-aws-lambda.handler"]              = "kong/plugins/ubidots-aws-lambda/handler.lua",
    ["kong.plugins.ubidots-aws-lambda.iam-ec2-credentials"]  = "kong/plugins/ubidots-aws-lambda/iam-ec2-credentials.lua",
    ["kong.plugins.ubidots-aws-lambda.iam-ecs-credentials"]  = "kong/plugins/ubidots-aws-lambda/iam-ecs-credentials.lua",
    ["kong.plugins.ubidots-aws-lambda.schema"]               = "kong/plugins/ubidots-aws-lambda/schema.lua",
    ["kong.plugins.ubidots-aws-lambda.v4"]                   = "kong/plugins/ubidots-aws-lambda/v4.lua",
    ["kong.plugins.ubidots-aws-lambda.request-util"]         = "kong/plugins/ubidots-aws-lambda/request-util.lua",
  }
}
