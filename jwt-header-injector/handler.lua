local jwt_decoder = require("kong.plugins.jwt.jwt_parser")

local JWTHeaderInjector = {
  VERSION = "1.0.0",
  PRIORITY = 1000,
}

function JWTHeaderInjector:access(conf)
  kong.log.info("JWT Header Injector: Starting plugin execution")
  
  -- Get JWT token from Authorization header
  local auth_header = kong.request.get_header("Authorization")
  if not auth_header then
    kong.log.info("JWT Header Injector: No Authorization header found")
    return
  end
  
  -- Extract token from "Bearer <token>"
  local token = auth_header:match("Bearer%s+(.+)")
  if not token then
    kong.log.info("JWT Header Injector: No Bearer token found in Authorization header")
    return
  end
  
  kong.log.info("JWT Header Injector: Found JWT token, attempting to decode")
  
  -- Decode JWT
  local jwt = jwt_decoder:new(token)
  if not jwt then
    kong.log.err("JWT Header Injector: Failed to decode JWT token")
    return
  end
  
  -- Extract claims
  local claims = jwt.claims
  if not claims then
    kong.log.err("JWT Header Injector: No claims found in JWT")
    return
  end
  
  kong.log.info("JWT Header Injector: JWT decoded successfully, claims found")
  
  if claims.user then
    -- User ID
    if conf.inject_user_id then
      if claims.user.id and claims.user.id ~= nil and type(claims.user.id) ~= "userdata" then
        kong.service.request.set_header("X-User-Id", tostring(claims.user.id))
        kong.log.info("JWT Header Injector: Injected X-User-Id: " .. tostring(claims.user.id))
      else
        kong.service.request.set_header("X-User-Id", "null")
        kong.log.info("JWT Header Injector: Injected X-User-Id: null")
      end
    end
    
    -- First Name
    if conf.inject_user_first_name then
      if claims.user.first_name and claims.user.first_name ~= nil and type(claims.user.first_name) ~= "userdata" then
        kong.service.request.set_header("X-User-First-Name", tostring(claims.user.first_name))
        kong.log.info("JWT Header Injector: Injected X-User-First-Name: " .. tostring(claims.user.first_name))
      else
        kong.service.request.set_header("X-User-First-Name", "null")
        kong.log.info("JWT Header Injector: Injected X-User-First-Name: null")
      end
    end
    -- Last Name
    if conf.inject_user_last_name then
      if claims.user.last_name and claims.user.last_name ~= nil and type(claims.user.last_name) ~= "userdata" then
        kong.service.request.set_header("X-User-Last-Name", tostring(claims.user.last_name))
        kong.log.info("JWT Header Injector: Injected X-User-Last-Name: " .. tostring(claims.user.last_name))
      else
        kong.service.request.set_header("X-User-Last-Name", "null")
        kong.log.info("JWT Header Injector: Injected X-User-Last-Name: null")
      end
    end
    
    -- Email
    if conf.inject_user_email then
      if claims.user.email and claims.user.email ~= nil and type(claims.user.email) ~= "userdata" then
        kong.service.request.set_header("X-User-Email", tostring(claims.user.email))
        kong.log.info("JWT Header Injector: Injected X-User-Email: " .. tostring(claims.user.email))
      else
        kong.service.request.set_header("X-User-Email", "null")
        kong.log.info("JWT Header Injector: Injected X-User-Email: null")
      end
    end
  end
  
  kong.log.info("JWT Header Injector: Plugin execution completed successfully")
end

return JWTHeaderInjector