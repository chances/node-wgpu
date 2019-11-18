#include <napi_kit.h>
#include <wgpu.h>

// #[extern]
napi_value Init(napi_env env, napi_value exports) {
  napi_property_descriptor desc =
    {"hello", NULL, Method, NULL, NULL, NULL, napi_default, NULL};
  napi_status status = napi_define_properties(env, exports, 1, &desc);
  if (status != napi_ok) return NULL;
  return exports;
}
