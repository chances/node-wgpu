#include <node_api.h>

napi_property_descriptor napi_method_property_descriptor(char* name, void* callbackMethod) {
  napi_property_descriptor desc = {
    .utf8name = name,
    .name = NULL,
    .method = callbackMethod,
    .getter = NULL,
    .setter = NULL,
    .value = NULL,
    .attributes = napi_default,
    .data = NULL
  };
  return desc;
}
