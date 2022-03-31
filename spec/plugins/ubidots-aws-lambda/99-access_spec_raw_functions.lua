local cjson   = require "cjson"
local helpers = require "spec.helpers"
local meta    = require "kong.meta"
local pl_file = require "pl.file"
local fixtures = require "spec.fixtures.ubidots-aws-lambda-raw"

local TEST_CONF = helpers.test_conf
local server_tokens = meta._SERVER_TOKENS
local null = ngx.null



for _, strategy in helpers.each_strategy() do
  describe("Plugin: AWS Lambda (access) [#" .. strategy .. "]", function()
    local proxy_client
    local admin_client

    lazy_setup(function()
      local bp = helpers.get_db_utils(strategy, {
        "routes",
        "services",
        "plugins",
      }, { "ubidots-aws-lambda" })

      local route1 = bp.routes:insert {
        hosts = { "lambda.com" },
      }

      local route1_1 = bp.routes:insert {
        hosts = { "lambda_ignore_service.com" },
        service    = bp.services:insert({
          protocol = "http",
          host     = "httpbin.org",
          port     = 80,
        })
      }

      local route2 = bp.routes:insert {
        hosts = { "lambda2.com" },
      }

      local route3 = bp.routes:insert {
        hosts = { "lambda3.com" },
      }

      local route4 = bp.routes:insert {
        hosts = { "lambda4.com" },
      }

      local route5 = bp.routes:insert {
        hosts = { "lambda5.com" },
      }

      local route6 = bp.routes:insert {
        hosts = { "lambda6.com" },
      }

      local route7 = bp.routes:insert {
        hosts = { "lambda7.com" },
      }

      local route8 = bp.routes:insert {
        hosts = { "lambda8.com" },
      }

      local route9 = bp.routes:insert {
        hosts      = { "lambda9.com" },
        protocols  = { "http", "https" },
        service    = null,
      }

      local route10 = bp.routes:insert {
        hosts       = { "lambda10.com" },
        protocols   = { "http", "https" },
        service     = null,
      }

      local route11 = bp.routes:insert {
        hosts       = { "lambda11.com" },
        protocols   = { "http", "https" },
        service     = null,
      }

      local route12 = bp.routes:insert {
        hosts       = { "lambda12.com" },
        protocols   = { "http", "https" },
        service     = null,
      }

      local route13 = bp.routes:insert {
        hosts       = { "lambda13.com" },
        protocols   = { "http", "https" },
        service     = null,
      }

      local route14 = bp.routes:insert {
        hosts       = { "lambda14.com" },
        protocols   = { "http", "https" },
        service     = null,
      }

      local route15 = bp.routes:insert {
        hosts       = { "lambda15.com" },
        protocols   = { "http", "https" },
        service     = null,
      }

      local route16 = bp.routes:insert {
        hosts       = { "lambda16.com" },
        protocols   = { "http", "https" },
        service     = null,
      }

      local route17 = bp.routes:insert {
        hosts       = { "lambda17.com" },
        protocols   = { "http", "https" },
        service     = null,
      }

      local route18 = bp.routes:insert {
        hosts       = { "lambda18.test" },
        protocols   = { "http", "https" },
        service     = null,
      }

      local route19 = bp.routes:insert {
        hosts       = { "lambda19.test" },
        protocols   = { "http", "https" },
        service     = null,
      }

      local route20 = bp.routes:insert {
        hosts       = { "lambda20.test" },
        protocols   = { "http", "https" },
        service     = null,
      }


      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route1.id },
        config   = {
          port          = 10001,
          aws_key       = "mock-key",
          aws_secret    = "mock-secret",
          aws_region    = "us-east-1",
          function_name = "kongLambdaTest",
          raw_function  = true,
        },
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route1_1.id },
        config   = {
          port          = 10001,
          aws_key       = "mock-key",
          aws_secret    = "mock-secret",
          aws_region    = "us-east-1",
          function_name = "kongLambdaTest",
          raw_function  = true,
        },
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route2.id },
        config   = {
          port            = 10001,
          aws_key         = "mock-key",
          aws_secret      = "mock-secret",
          aws_region      = "us-east-1",
          function_name   = "kongLambdaTest",
          invocation_type = "Event",
          raw_function    = true,
        },
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route3.id },
        config   = {
          port            = 10001,
          aws_key         = "mock-key",
          aws_secret      = "mock-secret",
          aws_region      = "us-east-1",
          function_name   = "kongLambdaTest",
          invocation_type = "DryRun",
          raw_function    = true,
        },
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route4.id },
        config   = {
          port          = 10001,
          aws_key       = "mock-key",
          aws_secret    = "mock-secret",
          aws_region    = "us-east-1",
          function_name = "kongLambdaTest",
          timeout       = 100,
          raw_function  = true,
        },
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route5.id },
        config   = {
          port          = 10001,
          aws_key       = "mock-key",
          aws_secret    = "mock-secret",
          aws_region    = "us-east-1",
          function_name = "functionWithUnhandledError",
          raw_function  = true,
        },
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route6.id },
        config   = {
          port            = 10001,
          aws_key         = "mock-key",
          aws_secret      = "mock-secret",
          aws_region      = "us-east-1",
          function_name   = "functionWithUnhandledError",
          invocation_type = "Event",
          raw_function    = true,
        },
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route7.id },
        config   = {
          port            = 10001,
          aws_key         = "mock-key",
          aws_secret      = "mock-secret",
          aws_region      = "us-east-1",
          function_name   = "functionWithUnhandledError",
          invocation_type = "DryRun",
          raw_function    = true,
        },
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route8.id },
        config   = {
          port             = 10001,
          aws_key          = "mock-key",
          aws_secret       = "mock-secret",
          aws_region       = "us-east-1",
          function_name    = "functionWithUnhandledError",
          unhandled_status = 412,
          raw_function     = true,
        },
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route9.id },
        config   = {
          port                    = 10001,
          aws_key                 = "mock-key",
          aws_secret              = "mock-secret",
          aws_region              = "us-east-1",
          function_name           = "kongLambdaTest",
          forward_request_method  = true,
          forward_request_uri     = true,
          forward_request_headers = true,
          forward_request_body    = true,
          raw_function            = true,
        }
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route10.id },
        config                    = {
          port                    = 10001,
          aws_key                 = "mock-key",
          aws_secret              = "mock-secret",
          aws_region              = "us-east-1",
          function_name           = "kongLambdaTest",
          forward_request_method  = true,
          forward_request_uri     = false,
          forward_request_headers = true,
          forward_request_body    = true,
          raw_function            = true,
        }
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route11.id },
        config                 = {
          port                 = 10001,
          aws_key              = "mock-key",
          aws_secret           = "mock-secret",
          aws_region           = "us-east-1",
          function_name        = "kongLambdaTest",
          is_proxy_integration = true,
        }
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route12.id },
        config                 = {
          port                 = 10001,
          aws_key              = "mock-key",
          aws_secret           = "mock-secret",
          aws_region           = "us-east-1",
          function_name        = "functionWithBadJSON",
          is_proxy_integration = true,
        }
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route13.id },
        config                 = {
          port                 = 10001,
          aws_key              = "mock-key",
          aws_secret           = "mock-secret",
          aws_region           = "us-east-1",
          function_name        = "functionWithNoResponse",
          is_proxy_integration = true,
        }
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route = { id = route14.id },
        config   = {
          port          = 10001,
          aws_key       = "mock-key",
          aws_secret    = "mock-secret",
          aws_region    = "us-east-1",
          function_name = "kongLambdaTest",
        },
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route = { id = route15.id },
        config   = {
          port          = 10001,
          aws_key       = "mock-key",
          aws_secret    = "mock-secret",
          aws_region    = "ab-cdef-1",
          function_name = "kongLambdaTest",
          raw_function  = true,
        },
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route16.id },
        config                 = {
          port                 = 10001,
          aws_key              = "mock-key",
          aws_secret           = "mock-secret",
          aws_region           = "us-east-1",
          function_name        = "functionWithBase64EncodedResponse",
          is_proxy_integration = true,
        }
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route17.id },
        config                 = {
          port                 = 10001,
          aws_key              = "mock-key",
          aws_secret           = "mock-secret",
          aws_region           = "us-east-1",
          function_name        = "functionWithMultiValueHeadersResponse",
          is_proxy_integration = true,
        }
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route18.id },
        config                 = {
          port                 = 10001,
          aws_key              = "mock-key",
          aws_secret           = "mock-secret",
          function_name        = "functionWithMultiValueHeadersResponse",
          host                 = "lambda18.test",
          is_proxy_integration = true,
        }
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route19.id },
        config                 = {
          port                 = 10001,
          aws_key              = "mock-key",
          aws_secret           = "mock-secret",
          function_name        = "functionWithMultiValueHeadersResponse",
          is_proxy_integration = true,
        }
      }

      bp.plugins:insert {
        name     = "ubidots-aws-lambda",
        route    = { id = route20.id },
        config                 = {
          port                 = 10001,
          aws_key              = "mock-key",
          aws_secret           = "mock-secret",
          function_name        = "functionEcho",
          proxy_url            = "http://127.0.0.1:13128",
          keepalive            = 1,
        }
      }


      fixtures.dns_mock:A({
        name = "lambda18.test",
        address = helpers.mock_upstream_host,
      })

      helpers.setenv("AWS_REGION", "us-east-1")

      assert(helpers.start_kong({
        database   = strategy,
        plugins = "ubidots-aws-lambda",
        nginx_conf = "spec/fixtures/custom_nginx.template",

        -- we don't actually use any stream proxy features in this test suite,
        -- but this is needed in order to load our forward-proxy stream_mock fixture
        stream_listen = helpers.get_proxy_ip(false) .. ":19000",
      }, nil, nil, fixtures))
    end)

    before_each(function()
      proxy_client = helpers.proxy_client()
      admin_client = helpers.admin_client()
    end)

    after_each(function ()
      proxy_client:close()
      admin_client:close()
    end)

    lazy_teardown(function()
      helpers.stop_kong()
      helpers.unsetenv("AWS_REGION", "us-east-1")
    end)

    it("invokes a Lambda function with GET", function()
      local res = assert(proxy_client:send {
        method  = "GET",
        path    = "/get?key1=some_value1&key2=some_value2&key3=some_value3",
        headers = {
          ["Host"] = "lambda.com"
        }
      })
      assert.res_status(201, res)
      local body = assert.response(res).has.jsonbody()
      assert.equal("x", res.headers["test"])
      assert.equal("value", body.test)
      assert.equal("/get?key1=some_value1&key2=some_value2&key3=some_value3", body.path)
      assert.equal(nil, body.body)
      assert.equal("lambda.com", body.headers.host)
      assert.equal("lua-resty-http/0.16.1 (Lua) ngx_lua/10020", body.headers["user-agent"])
      assert.equal(173, tonumber(res.headers["Content-Length"]))
      assert.equal("application/json", res.headers["Content-Type"])
      assert.equal("kong/2.8.0", res.headers["Server"])
      assert.equal("keep-alive", res.headers["Connection"])
      assert.is_string(res.headers["X-Kong-Response-Latency"])
      assert.is_string(res.headers["Date"])
    end)

    it("invokes a Lambda function with GET, ignores route's service", function()
      local res = assert(proxy_client:send {
        method  = "GET",
        path    = "/get?key1=some_value1&key2=some_value2&key3=some_value3",
        headers = {
          ["Host"] = "lambda_ignore_service.com"
        }
      })
      assert.res_status(201, res)
      local body = assert.response(res).has.jsonbody()
      assert.equal("x", res.headers["test"])
      assert.equal("value", body.test)
      assert.equal("/get?key1=some_value1&key2=some_value2&key3=some_value3", body.path)
      assert.equal(nil, body.body)
      assert.equal("lambda_ignore_service.com", body.headers.host)
      assert.equal("lua-resty-http/0.16.1 (Lua) ngx_lua/10020", body.headers["user-agent"])
      assert.equal(188, tonumber(res.headers["Content-Length"]))
      assert.equal("application/json", res.headers["Content-Type"])
      assert.equal("kong/2.8.0", res.headers["Server"])
      assert.equal("keep-alive", res.headers["Connection"])
      assert.is_string(res.headers["X-Kong-Response-Latency"])
      assert.is_string(res.headers["Date"])
    end)
    it("invokes a Lambda function with POST params", function()
      local res = assert(proxy_client:send {
        method  = "POST",
        path    = "/post",
        headers = {
          ["Host"]         = "lambda.com",
          ["Content-Type"] = "application/x-www-form-urlencoded"
        },
        body = {
          key1 = "some_value_post1",
          key2 = "some_value_post2",
          key3 = "some_value_post3"
        }
      })
      assert.res_status(201, res)
      local body = assert.response(res).has.jsonbody()
      assert.equal("x", res.headers["test"])
      assert.equal("value", body.test)
      assert.equal("/post", body.path)
      assert.equal("key1=some_value_post1&key2=some_value_post2&key3=some_value_post3", body.body)
      assert.equal("lambda.com", body.headers.host)
      assert.equal("application/x-www-form-urlencoded", body.headers["content-type"])
      assert.equal("lua-resty-http/0.16.1 (Lua) ngx_lua/10020", body.headers["user-agent"])
      assert.equal(272, tonumber(res.headers["Content-Length"]))
      assert.equal("application/json", res.headers["Content-Type"])
      assert.equal("kong/2.8.0", res.headers["Server"])
      assert.equal("keep-alive", res.headers["Connection"])
      assert.is_string(res.headers["X-Kong-Response-Latency"])
      assert.is_string(res.headers["Date"])
    end)
    
    it("invokes a Lambda function with POST json body", function()
      local expected_body = {
        key1 = "some_value_json1",
        key2 = "some_value_json2",
        key3 = "some_value_json3"
      }
      local res = assert(proxy_client:send {
        method  = "POST",
        path    = "/post",
        headers = {
          ["Host"]         = "lambda.com",
          ["Content-Type"] = "application/json"
        },
        body = expected_body
      })
      assert.res_status(201, res)
      local body = assert.response(res).has.jsonbody()
      assert.equal("x", res.headers["test"])
      assert.equal("value", body.test)
      assert.equal("/post", body.path)
      local decoded_body = cjson.decode(body.body)
      assert.equal(expected_body.key1, decoded_body.key1)
      assert.equal(expected_body.key2, decoded_body.key2)
      assert.equal(expected_body.key3, decoded_body.key3)
      assert.equal("lambda.com", body.headers.host)
      assert.equal("application/json", body.headers["content-type"])
      assert.equal("lua-resty-http/0.16.1 (Lua) ngx_lua/10020", body.headers["user-agent"])
      assert.equal(281, tonumber(res.headers["Content-Length"]))
      assert.equal("application/json", res.headers["Content-Type"])
      assert.equal("kong/2.8.0", res.headers["Server"])
      assert.equal("keep-alive", res.headers["Connection"])
      assert.is_string(res.headers["X-Kong-Response-Latency"])
      assert.is_string(res.headers["Date"])
    end)
    it("passes empty json arrays unmodified", function()
      local expected_body = '[{}, []]'
      local res = assert(proxy_client:send {
        method  = "POST",
        path    = "/post",
        headers = {
          ["Host"]         = "lambda.com",
          ["Content-Type"] = "application/json"
        },
        body = expected_body
      })
      assert.res_status(201, res)
      local body = assert.response(res).has.jsonbody()
      assert.equal("x", res.headers["test"])
      assert.equal("value", body.test)
      assert.equal("/post", body.path)
      assert.equal(expected_body, body.body)
      assert.equal("lambda.com", body.headers.host)
      assert.equal("application/json", body.headers["content-type"])
      assert.equal("lua-resty-http/0.16.1 (Lua) ngx_lua/10020", body.headers["user-agent"])
      assert.equal(197, tonumber(res.headers["Content-Length"]))
      assert.equal("application/json", res.headers["Content-Type"])
      assert.equal("kong/2.8.0", res.headers["Server"])
      assert.equal("keep-alive", res.headers["Connection"])
      assert.is_string(res.headers["X-Kong-Response-Latency"])
      assert.is_string(res.headers["Date"])
    end)
    
    it("invokes a Lambda function with POST and both querystring and body params", function()
      local res = assert(proxy_client:send {
        method  = "POST",
        path    = "/post?key1=from_querystring",
        headers = {
          ["Host"]         = "lambda.com",
          ["Content-Type"] = "application/x-www-form-urlencoded"
        },
        body = {
          key2 = "some_value_post2",
          key3 = "some_value_post3"
        }
      })
      assert.res_status(201, res)
      local body = assert.response(res).has.jsonbody()
      assert.equal("x", res.headers["test"])
      assert.equal("value", body.test)
      assert.equal("/post?key1=from_querystring", body.path)
      assert.equal("key2=some_value_post2&key3=some_value_post3", body.body)
      assert.equal("lambda.com", body.headers.host)
      assert.equal("application/x-www-form-urlencoded", body.headers["content-type"])
      assert.equal("lua-resty-http/0.16.1 (Lua) ngx_lua/10020", body.headers["user-agent"])
      assert.equal(272, tonumber(res.headers["Content-Length"]))
      assert.equal("application/json", res.headers["Content-Type"])
      assert.equal("kong/2.8.0", res.headers["Server"])
      assert.equal("keep-alive", res.headers["Connection"])
      assert.is_string(res.headers["X-Kong-Response-Latency"])
      assert.is_string(res.headers["Date"])
    end)
  
    it("invokes a Lambda function with POST and xml payload, custom header and query parameter", function()
      local res = assert(proxy_client:send {
        method  = "POST",
        path    = "/post?key1=from_querystring",
        headers = {
          ["Host"]          = "lambda9.com",
          ["Content-Type"]  = "application/xml",
          ["custom-header"] = "someheader"
        },
        body = "<xml/>"
      })
      assert.res_status(201, res)
      local body = assert.response(res).has.jsonbody()

      assert.equal("x", res.headers["test"])
      assert.equal("value", body.test)
      assert.equal("/post?key1=from_querystring", body.path)
      assert.equal("<xml/>", body.body)
      assert.equal("lambda9.com", body.headers.host)
      assert.equal("someheader", body.headers["custom-header"])
      assert.equal("6", body.headers["content-length"])
      assert.equal("application/xml", body.headers["content-type"])
      assert.equal("lua-resty-http/0.16.1 (Lua) ngx_lua/10020", body.headers["user-agent"])
      assert.equal(247, tonumber(res.headers["Content-Length"]))
      assert.equal("application/json", res.headers["Content-Type"])
      assert.equal("kong/2.8.0", res.headers["Server"])
      assert.equal("keep-alive", res.headers["Connection"])
      assert.is_string(res.headers["X-Kong-Response-Latency"])
      assert.is_string(res.headers["Date"])
    end)
    
    it("invokes a Lambda function with POST and json payload, custom header and query parameter", function()
      local res = assert(proxy_client:send {
        method  = "POST",
        path    = "/post?key1=from_querystring",
        headers = {
          ["Host"]          = "lambda10.com",
          ["Content-Type"]  = "application/json",
          ["custom-header"] = "someheader"
        },
        body = { key2 = "some_value" }
      })
      assert.res_status(201, res)
      local body = assert.response(res).has.jsonbody()
      assert.equal("x", res.headers["test"])
      assert.equal("value", body.test)
      assert.equal("/post?key1=from_querystring", body.path)
      assert.equal('{"key2":"some_value"}', body.body)
      assert.equal("lambda10.com", body.headers.host)
      assert.equal("application/json", body.headers["content-type"])
      assert.equal("lua-resty-http/0.16.1 (Lua) ngx_lua/10020", body.headers["user-agent"])
      assert.equal(268, tonumber(res.headers["Content-Length"]))
      assert.equal("application/json", res.headers["Content-Type"])
      assert.equal("kong/2.8.0", res.headers["Server"])
      assert.equal("keep-alive", res.headers["Connection"])
      assert.is_string(res.headers["X-Kong-Response-Latency"])
      assert.is_string(res.headers["Date"])
    end)
    
    it("invokes a Lambda function with POST and txt payload, custom header and query parameter", function()
      local res = assert(proxy_client:send {
        method  = "POST",
        path    = "/post?key1=from_querystring",
        headers = {
          ["Host"]          = "lambda9.com",
          ["Content-Type"]  = "text/plain",
          ["custom-header"] = "someheader"
        },
        body = "some text"
      })
      assert.res_status(201, res)
      local body = assert.response(res).has.jsonbody()
      assert.equal("x", res.headers["test"])
      assert.equal("value", body.test)
      assert.equal("/post?key1=from_querystring", body.path)
      assert.equal('some text', body.body)
      assert.equal("lambda9.com", body.headers.host)
      assert.equal("someheader", body.headers["custom-header"])
      assert.equal("text/plain", body.headers["content-type"])
      assert.equal("lua-resty-http/0.16.1 (Lua) ngx_lua/10020", body.headers["user-agent"])
      assert.equal(244, tonumber(res.headers["Content-Length"]))
      assert.equal("application/json", res.headers["Content-Type"])
      assert.equal("kong/2.8.0", res.headers["Server"])
      assert.equal("keep-alive", res.headers["Connection"])
      assert.is_string(res.headers["X-Kong-Response-Latency"])
      assert.is_string(res.headers["Date"])
    end)
    it("invokes a Lambda function with POST and binary payload and custom header", function()
      local res = assert(proxy_client:send {
        method  = "POST",
        path    = "/post?key1=from_querystring",
        headers = {
          ["Host"]          = "lambda9.com",
          ["Content-Type"]  = "application/octet-stream",
          ["custom-header"] = "someheader"
        },
        body = "01234"
      })
      assert.res_status(201, res)
      local body = assert.response(res).has.jsonbody()
      assert.equal("x", res.headers["test"])
      assert.equal("value", body.test)
      assert.equal("/post?key1=from_querystring", body.path)
      assert.equal('01234', body.body)
      assert.equal("lambda9.com", body.headers.host)
      assert.equal("someheader", body.headers["custom-header"])
      assert.equal("application/octet-stream", body.headers["content-type"])
      assert.equal("lua-resty-http/0.16.1 (Lua) ngx_lua/10020", body.headers["user-agent"])
      assert.equal(254, tonumber(res.headers["Content-Length"]))
      assert.equal("application/json", res.headers["Content-Type"])
      assert.equal("kong/2.8.0", res.headers["Server"])
      assert.equal("keep-alive", res.headers["Connection"])
      assert.is_string(res.headers["X-Kong-Response-Latency"])
      assert.is_string(res.headers["Date"])
    end)
    it("invokes a Lambda function with POST params and Event invocation_type", function()
      local res = assert(proxy_client:send {
        method  = "POST",
        path    = "/post",
        headers = {
          ["Host"]         = "lambda2.com",
          ["Content-Type"] = "application/x-www-form-urlencoded"
        },
        body = {
          key1 = "some_value_post1",
          key2 = "some_value_post2",
          key3 = "some_value_post3"
        }
      })
      assert.res_status(202, res)
    end)
    
    it("invokes a Lambda function with POST params and DryRun invocation_type", function()
      local res = assert(proxy_client:send {
        method  = "POST",
        path    = "/post",
        headers = {
          ["Host"]         = "lambda3.com",
          ["Content-Type"] = "application/x-www-form-urlencoded"
        },
        body = {
          key1 = "some_value_post1",
          key2 = "some_value_post2",
          key3 = "some_value_post3"
        }
      })
      assert.res_status(204, res)
    end)
    
    it("errors on connection timeout", function()
      local res = assert(proxy_client:send {
        method  = "GET",
        path    = "/get?key1=some_value1&key2=some_value2&key3=some_value3",
        headers = {
          ["Host"] = "lambda4.com",
        }
      })
      assert.res_status(500, res)
    end)
    it("invokes a Lambda function with an unhandled function error (and no unhandled_status set)", function()
      local res = assert(proxy_client:send {
        method  = "GET",
        path    = "/get?key1=some_value1&key2=some_value2&key3=some_value3",
        headers = {
          ["Host"] = "lambda5.com"
        }
      })
      assert.res_status(201, res)
      local body = assert.response(res).has.jsonbody()
      assert.equal("x", res.headers["test"])
      assert.equal("value", body.test)
      assert.equal("/get?key1=some_value1&key2=some_value2&key3=some_value3", body.path)
      assert.equal(nil, body.body)
      assert.equal("lambda5.com", body.headers.host)
      assert.equal("lua-resty-http/0.16.1 (Lua) ngx_lua/10020", body.headers["user-agent"])
      assert.equal(174, tonumber(res.headers["Content-Length"]))
      assert.equal("application/json", res.headers["Content-Type"])
      assert.equal("kong/2.8.0", res.headers["Server"])
      assert.equal("keep-alive", res.headers["Connection"])
      assert.is_string(res.headers["X-Kong-Response-Latency"])
      assert.is_string(res.headers["Date"])
    end)
    
    it("invokes a Lambda function with an unhandled function error with Event invocation type", function()
      local res = assert(proxy_client:send {
        method  = "GET",
        path    = "/get?key1=some_value1&key2=some_value2&key3=some_value3",
        headers = {
          ["Host"] = "lambda6.com"
        }
      })
      assert.res_status(202, res)
    end)
    
    it("invokes a Lambda function with an unhandled function error with DryRun invocation type", function()
      local res = assert(proxy_client:send {
        method  = "GET",
        path    = "/get?key1=some_value1&key2=some_value2&key3=some_value3",
        headers = {
          ["Host"] = "lambda7.com"
        }
      })
      assert.res_status(204, res)
    end)
    
    it("invokes a Lambda function with an unhandled function error", function()
      local res = assert(proxy_client:send {
        method  = "GET",
        path    = "/get?key1=some_value1&key2=some_value2&key3=some_value3",
        headers = {
          ["Host"] = "lambda8.com"
        }
      })
      assert.res_status(201, res)
      local body = assert.response(res).has.jsonbody()
      assert.equal("x", res.headers["test"])
      assert.equal("value", body.test)
      assert.equal("/get?key1=some_value1&key2=some_value2&key3=some_value3", body.path)
      assert.equal(nil, body.body)
      assert.equal("lambda8.com", body.headers.host)
      assert.equal("lua-resty-http/0.16.1 (Lua) ngx_lua/10020", body.headers["user-agent"])
      assert.equal(174, tonumber(res.headers["Content-Length"]))
      assert.equal("application/json", res.headers["Content-Type"])
      assert.equal("kong/2.8.0", res.headers["Server"])
      assert.equal("keep-alive", res.headers["Connection"])
      assert.is_string(res.headers["X-Kong-Response-Latency"])
      assert.is_string(res.headers["Date"])
    end)
    
    it("returns server tokens with Via header", function()
      local res = assert(proxy_client:send {
        method  = "GET",
        path    = "/get?key1=some_value1&key2=some_value2&key3=some_value3",
        headers = {
          ["Host"] = "lambda.com"
        }
      })
      assert.res_status(201, res)
    end)
    
    it("returns Content-Length header", function()
      local res = assert(proxy_client:send {
        method  = "GET",
        path    = "/get?key1=some_value1&key2=some_value2&key3=some_value3",
        headers = {
          ["Host"] = "lambda.com"
        }
      })

      assert.equal(173, tonumber(res.headers["Content-Length"]))
    end)
    
    it("errors on bad region name (DNS resolution)", function()
      local res = assert(proxy_client:send {
        method  = "GET",
        path    = "/get?key1=some_value1",
        headers = {
          ["Host"] = "lambda15.com"
        }
      })
      assert.res_status(500, res)

      helpers.wait_until(function()
        local logs = pl_file.read(TEST_CONF.prefix .. "/" .. TEST_CONF.proxy_error_log)
        local _, count = logs:gsub([[%[ubidots%-aws%-lambda%].+lambda%.ab%-cdef%-1%.amazonaws%.com.+name error"]], "")
        return count >= 1
      end, 10)
    end)
  end)
end