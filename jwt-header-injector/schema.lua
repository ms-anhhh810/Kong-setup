local typedefs = require "kong.db.schema.typedefs"

return {
  name = "jwt-header-injector",
  fields = {
    { config = {
        type = "record",
        fields = {
          { inject_user_id = {
              type = "boolean",
              default = true,
              description = "Inject X-User-Id header from JWT user.id claim"
            }
          },
          { inject_user_first_name = {
              type = "boolean",
              default = true,
              description = "Inject X-User-First-Name header from JWT user.first_name claim"
            }
          },
          { inject_user_last_name = {
              type = "boolean",
              default = true,
              description = "Inject X-User-Last-Name header from JWT user.last_name claim"
            }
          },
          { inject_user_email = {
              type = "boolean", 
              default = true,
              description = "Inject X-User-Email header from JWT user.email claim"
            }
          }
        },
      },
    },
  },
}