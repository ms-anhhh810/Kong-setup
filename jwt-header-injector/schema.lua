local typedefs = require "kong.db.schema.typedefs"

return {
  name = "jwt-header-injector",
  fields = {
    { config = {
        type = "record",
        fields = {
          -- Configuration options for the plugin
          { inject_user_id = {
              type = "boolean",
              default = true,
              description = "Inject X-User-Id header from JWT sub claim"
            }
          },
          { inject_user_email = {
              type = "boolean", 
              default = true,
              description = "Inject X-User-Email header from JWT user.email claim"
            }
          },
          { inject_user_name = {
              type = "boolean",
              default = true, 
              description = "Inject X-User-Name header from JWT user.first_name + user.last_name"
            }
          },
          { inject_user_language = {
              type = "boolean",
              default = false,
              description = "Inject X-User-Language header from JWT user.language claim"
            }
          },
          { inject_jwt_issuer = {
              type = "boolean",
              default = false,
              description = "Inject X-JWT-Issuer header from JWT iss claim"
            }
          },
          { inject_app_name = {
              type = "boolean",
              default = false,
              description = "Inject X-App-Name header from JWT app claim"
            }
          }
        },
      },
    },
  },
}