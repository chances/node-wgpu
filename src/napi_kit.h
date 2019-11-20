#include <node_api.h>

inline napi_property_descriptor napi_method_property_descriptor(char* name, void* callbackMethod) {
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

inline void napi_define_method_property(napi_env env, napi_value object, char* name, void* callbackMethod) {
  napi_property_descriptor desc = napi_method_property_descriptor(name, callbackMethod);
  napi_status status = napi_define_properties(env, object, 1, &desc);
  if (status != napi_ok) {
    napi_throw_error(env, "", "Could not define property on object");
  }
}

inline napi_property_descriptor napi_object_property_descriptor(char* name, napi_value value) {
  napi_property_descriptor desc = {
    .utf8name = name,
    .name = NULL,
    .method = NULL,
    .getter = NULL,
    .setter = NULL,
    .value = value,
    .attributes = napi_default,
    .data = NULL
  };
  return desc;
}

inline napi_value napi_create_string(napi_env env, char* value) {
  napi_status status;
  napi_value string;
  status = napi_create_string_utf8(env, value, NAPI_AUTO_LENGTH, &string);
  if (status != napi_ok) {
    napi_throw_error(env, "", "Could not construct string");
    return NULL;
  }
  return string;
}

inline napi_value napi_object_create(napi_env env) {
  napi_status status;
  napi_value object;
  status = napi_create_object(env, &object);
  if (status != napi_ok) {
    napi_throw_error(env, "", "Could not construct object");
    return NULL;
  }
  return object;
}

inline napi_value napi_create_deferred_promise(napi_env env, napi_deferred deferred) {
  napi_value promise;
  napi_status status = napi_create_promise(env, &deferred, &promise);
  if (status != napi_ok) {
    napi_throw_error(env, "", "Could not construct promise");
    return NULL;
  }
  return promise;
}
