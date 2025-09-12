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
  
  -- Inject headers based on JWT claims
  if claims.sub then
    kong.service.request.set_header("X-User-Id", claims.sub)
    kong.log.info("JWT Header Injector: Injected X-User-Id: " .. claims.sub)
  end
  
  if claims.user then
    if claims.user.id then
      kong.service.request.set_header("X-User-DB-Id", tostring(claims.user.id))
      kong.log.info("JWT Header Injector: Injected X-User-DB-Id: " .. tostring(claims.user.id))
    end
    
    if claims.user.email then
      kong.service.request.set_header("X-User-Email", claims.user.email)
      kong.log.info("JWT Header Injector: Injected X-User-Email: " .. claims.user.email)
    end
    
    if claims.user.first_name then
      local full_name = claims.user.first_name
      if claims.user.last_name and type(claims.user.last_name) == "string" and claims.user.last_name ~= "" then
        full_name = full_name .. " " .. claims.user.last_name
      end
      kong.service.request.set_header("X-User-Name", full_name)
      kong.log.info("JWT Header Injector: Injected X-User-Name: " .. full_name)
    end
    
    if claims.user.language then
      kong.service.request.set_header("X-User-Language", claims.user.language)
      kong.log.info("JWT Header Injector: Injected X-User-Language: " .. claims.user.language)
    end
  end
  
  -- Inject additional useful headers
  if claims.iss then
    kong.service.request.set_header("X-JWT-Issuer", claims.iss)
    kong.log.info("JWT Header Injector: Injected X-JWT-Issuer: " .. claims.iss)
  end
  
  if claims.app then
    kong.service.request.set_header("X-App-Name", claims.app)
    kong.log.info("JWT Header Injector: Injected X-App-Name: " .. claims.app)
  end
  
  kong.log.info("JWT Header Injector: Plugin execution completed successfully")
end

return JWTHeaderInjector