
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ResourceManagementClient
## version: 2016-09-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Provides operations for working with resources and resource groups.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_567666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567666): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "resources"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DeploymentsCalculateTemplateHash_567888 = ref object of OpenApiRestCall_567666
proc url_DeploymentsCalculateTemplateHash_567890(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DeploymentsCalculateTemplateHash_567889(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Calculate the hash of the given template.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568049 = query.getOrDefault("api-version")
  valid_568049 = validateParameter(valid_568049, JString, required = true,
                                 default = nil)
  if valid_568049 != nil:
    section.add "api-version", valid_568049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   template: JObject (required)
  ##           : The template provided to calculate hash.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568073: Call_DeploymentsCalculateTemplateHash_567888;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Calculate the hash of the given template.
  ## 
  let valid = call_568073.validator(path, query, header, formData, body)
  let scheme = call_568073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568073.url(scheme.get, call_568073.host, call_568073.base,
                         call_568073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568073, url, valid)

proc call*(call_568144: Call_DeploymentsCalculateTemplateHash_567888;
          apiVersion: string; `template`: JsonNode): Recallable =
  ## deploymentsCalculateTemplateHash
  ## Calculate the hash of the given template.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   template: JObject (required)
  ##           : The template provided to calculate hash.
  var query_568145 = newJObject()
  var body_568147 = newJObject()
  add(query_568145, "api-version", newJString(apiVersion))
  if `template` != nil:
    body_568147 = `template`
  result = call_568144.call(nil, query_568145, nil, nil, body_568147)

var deploymentsCalculateTemplateHash* = Call_DeploymentsCalculateTemplateHash_567888(
    name: "deploymentsCalculateTemplateHash", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Resources/calculateTemplateHash",
    validator: validate_DeploymentsCalculateTemplateHash_567889, base: "",
    url: url_DeploymentsCalculateTemplateHash_567890, schemes: {Scheme.Https})
type
  Call_ProvidersList_568186 = ref object of OpenApiRestCall_567666
proc url_ProvidersList_568188(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersList_568187(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all resource providers for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568204 = path.getOrDefault("subscriptionId")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "subscriptionId", valid_568204
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The properties to include in the results. For example, use &$expand=metadata in the query string to retrieve resource provider metadata. To include property aliases in response, use $expand=resourceTypes/aliases.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed returns all deployments.
  section = newJObject()
  var valid_568205 = query.getOrDefault("$expand")
  valid_568205 = validateParameter(valid_568205, JString, required = false,
                                 default = nil)
  if valid_568205 != nil:
    section.add "$expand", valid_568205
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "api-version", valid_568206
  var valid_568207 = query.getOrDefault("$top")
  valid_568207 = validateParameter(valid_568207, JInt, required = false, default = nil)
  if valid_568207 != nil:
    section.add "$top", valid_568207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568208: Call_ProvidersList_568186; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all resource providers for a subscription.
  ## 
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_ProvidersList_568186; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0): Recallable =
  ## providersList
  ## Gets all resource providers for a subscription.
  ##   Expand: string
  ##         : The properties to include in the results. For example, use &$expand=metadata in the query string to retrieve resource provider metadata. To include property aliases in response, use $expand=resourceTypes/aliases.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return. If null is passed returns all deployments.
  var path_568210 = newJObject()
  var query_568211 = newJObject()
  add(query_568211, "$expand", newJString(Expand))
  add(query_568211, "api-version", newJString(apiVersion))
  add(path_568210, "subscriptionId", newJString(subscriptionId))
  add(query_568211, "$top", newJInt(Top))
  result = call_568209.call(path_568210, query_568211, nil, nil, nil)

var providersList* = Call_ProvidersList_568186(name: "providersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers",
    validator: validate_ProvidersList_568187, base: "", url: url_ProvidersList_568188,
    schemes: {Scheme.Https})
type
  Call_ProvidersGet_568212 = ref object of OpenApiRestCall_567666
proc url_ProvidersGet_568214(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersGet_568213(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568215 = path.getOrDefault("subscriptionId")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "subscriptionId", valid_568215
  var valid_568216 = path.getOrDefault("resourceProviderNamespace")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "resourceProviderNamespace", valid_568216
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand query parameter. For example, to include property aliases in response, use $expand=resourceTypes/aliases.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  var valid_568217 = query.getOrDefault("$expand")
  valid_568217 = validateParameter(valid_568217, JString, required = false,
                                 default = nil)
  if valid_568217 != nil:
    section.add "$expand", valid_568217
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568218 = query.getOrDefault("api-version")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "api-version", valid_568218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568219: Call_ProvidersGet_568212; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified resource provider.
  ## 
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_ProvidersGet_568212; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string;
          Expand: string = ""): Recallable =
  ## providersGet
  ## Gets the specified resource provider.
  ##   Expand: string
  ##         : The $expand query parameter. For example, to include property aliases in response, use $expand=resourceTypes/aliases.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  var path_568221 = newJObject()
  var query_568222 = newJObject()
  add(query_568222, "$expand", newJString(Expand))
  add(query_568222, "api-version", newJString(apiVersion))
  add(path_568221, "subscriptionId", newJString(subscriptionId))
  add(path_568221, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_568220.call(path_568221, query_568222, nil, nil, nil)

var providersGet* = Call_ProvidersGet_568212(name: "providersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}",
    validator: validate_ProvidersGet_568213, base: "", url: url_ProvidersGet_568214,
    schemes: {Scheme.Https})
type
  Call_ProvidersRegister_568223 = ref object of OpenApiRestCall_567666
proc url_ProvidersRegister_568225(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/register")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersRegister_568224(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Registers a subscription with a resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider to register.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568226 = path.getOrDefault("subscriptionId")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "subscriptionId", valid_568226
  var valid_568227 = path.getOrDefault("resourceProviderNamespace")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "resourceProviderNamespace", valid_568227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568228 = query.getOrDefault("api-version")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "api-version", valid_568228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568229: Call_ProvidersRegister_568223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a subscription with a resource provider.
  ## 
  let valid = call_568229.validator(path, query, header, formData, body)
  let scheme = call_568229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568229.url(scheme.get, call_568229.host, call_568229.base,
                         call_568229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568229, url, valid)

proc call*(call_568230: Call_ProvidersRegister_568223; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string): Recallable =
  ## providersRegister
  ## Registers a subscription with a resource provider.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider to register.
  var path_568231 = newJObject()
  var query_568232 = newJObject()
  add(query_568232, "api-version", newJString(apiVersion))
  add(path_568231, "subscriptionId", newJString(subscriptionId))
  add(path_568231, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_568230.call(path_568231, query_568232, nil, nil, nil)

var providersRegister* = Call_ProvidersRegister_568223(name: "providersRegister",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}/register",
    validator: validate_ProvidersRegister_568224, base: "",
    url: url_ProvidersRegister_568225, schemes: {Scheme.Https})
type
  Call_ProvidersUnregister_568233 = ref object of OpenApiRestCall_567666
proc url_ProvidersUnregister_568235(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/unregister")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersUnregister_568234(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Unregisters a subscription from a resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider to unregister.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568236 = path.getOrDefault("subscriptionId")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "subscriptionId", valid_568236
  var valid_568237 = path.getOrDefault("resourceProviderNamespace")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "resourceProviderNamespace", valid_568237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568238 = query.getOrDefault("api-version")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "api-version", valid_568238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568239: Call_ProvidersUnregister_568233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregisters a subscription from a resource provider.
  ## 
  let valid = call_568239.validator(path, query, header, formData, body)
  let scheme = call_568239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568239.url(scheme.get, call_568239.host, call_568239.base,
                         call_568239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568239, url, valid)

proc call*(call_568240: Call_ProvidersUnregister_568233; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string): Recallable =
  ## providersUnregister
  ## Unregisters a subscription from a resource provider.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider to unregister.
  var path_568241 = newJObject()
  var query_568242 = newJObject()
  add(query_568242, "api-version", newJString(apiVersion))
  add(path_568241, "subscriptionId", newJString(subscriptionId))
  add(path_568241, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_568240.call(path_568241, query_568242, nil, nil, nil)

var providersUnregister* = Call_ProvidersUnregister_568233(
    name: "providersUnregister", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}/unregister",
    validator: validate_ProvidersUnregister_568234, base: "",
    url: url_ProvidersUnregister_568235, schemes: {Scheme.Https})
type
  Call_ResourceGroupsListResources_568243 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsListResources_568245(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/resources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsListResources_568244(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the resources for a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group with the resources to get.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568246 = path.getOrDefault("resourceGroupName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "resourceGroupName", valid_568246
  var valid_568247 = path.getOrDefault("subscriptionId")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "subscriptionId", valid_568247
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand query parameter
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed, returns all resources.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_568248 = query.getOrDefault("$expand")
  valid_568248 = validateParameter(valid_568248, JString, required = false,
                                 default = nil)
  if valid_568248 != nil:
    section.add "$expand", valid_568248
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568249 = query.getOrDefault("api-version")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "api-version", valid_568249
  var valid_568250 = query.getOrDefault("$top")
  valid_568250 = validateParameter(valid_568250, JInt, required = false, default = nil)
  if valid_568250 != nil:
    section.add "$top", valid_568250
  var valid_568251 = query.getOrDefault("$filter")
  valid_568251 = validateParameter(valid_568251, JString, required = false,
                                 default = nil)
  if valid_568251 != nil:
    section.add "$filter", valid_568251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568252: Call_ResourceGroupsListResources_568243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the resources for a resource group.
  ## 
  let valid = call_568252.validator(path, query, header, formData, body)
  let scheme = call_568252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568252.url(scheme.get, call_568252.host, call_568252.base,
                         call_568252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568252, url, valid)

proc call*(call_568253: Call_ResourceGroupsListResources_568243;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Expand: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## resourceGroupsListResources
  ## Get all the resources for a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group with the resources to get.
  ##   Expand: string
  ##         : The $expand query parameter
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return. If null is passed, returns all resources.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568254 = newJObject()
  var query_568255 = newJObject()
  add(path_568254, "resourceGroupName", newJString(resourceGroupName))
  add(query_568255, "$expand", newJString(Expand))
  add(query_568255, "api-version", newJString(apiVersion))
  add(path_568254, "subscriptionId", newJString(subscriptionId))
  add(query_568255, "$top", newJInt(Top))
  add(query_568255, "$filter", newJString(Filter))
  result = call_568253.call(path_568254, query_568255, nil, nil, nil)

var resourceGroupsListResources* = Call_ResourceGroupsListResources_568243(
    name: "resourceGroupsListResources", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/resources",
    validator: validate_ResourceGroupsListResources_568244, base: "",
    url: url_ResourceGroupsListResources_568245, schemes: {Scheme.Https})
type
  Call_ResourcesMoveResources_568256 = ref object of OpenApiRestCall_567666
proc url_ResourcesMoveResources_568258(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "sourceResourceGroupName" in path,
        "`sourceResourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "sourceResourceGroupName"),
               (kind: ConstantSegment, value: "/moveResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesMoveResources_568257(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The resources to move must be in the same source resource group. The target resource group may be in a different subscription. When moving resources, both the source group and the target group are locked for the duration of the operation. Write and delete operations are blocked on the groups until the move completes. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sourceResourceGroupName: JString (required)
  ##                          : The name of the resource group containing the resources to move.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sourceResourceGroupName` field"
  var valid_568276 = path.getOrDefault("sourceResourceGroupName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "sourceResourceGroupName", valid_568276
  var valid_568277 = path.getOrDefault("subscriptionId")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "subscriptionId", valid_568277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568278 = query.getOrDefault("api-version")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "api-version", valid_568278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for moving resources.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568280: Call_ResourcesMoveResources_568256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The resources to move must be in the same source resource group. The target resource group may be in a different subscription. When moving resources, both the source group and the target group are locked for the duration of the operation. Write and delete operations are blocked on the groups until the move completes. 
  ## 
  let valid = call_568280.validator(path, query, header, formData, body)
  let scheme = call_568280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568280.url(scheme.get, call_568280.host, call_568280.base,
                         call_568280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568280, url, valid)

proc call*(call_568281: Call_ResourcesMoveResources_568256; apiVersion: string;
          sourceResourceGroupName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## resourcesMoveResources
  ## The resources to move must be in the same source resource group. The target resource group may be in a different subscription. When moving resources, both the source group and the target group are locked for the duration of the operation. Write and delete operations are blocked on the groups until the move completes. 
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   sourceResourceGroupName: string (required)
  ##                          : The name of the resource group containing the resources to move.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters for moving resources.
  var path_568282 = newJObject()
  var query_568283 = newJObject()
  var body_568284 = newJObject()
  add(query_568283, "api-version", newJString(apiVersion))
  add(path_568282, "sourceResourceGroupName", newJString(sourceResourceGroupName))
  add(path_568282, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568284 = parameters
  result = call_568281.call(path_568282, query_568283, nil, nil, body_568284)

var resourcesMoveResources* = Call_ResourcesMoveResources_568256(
    name: "resourcesMoveResources", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{sourceResourceGroupName}/moveResources",
    validator: validate_ResourcesMoveResources_568257, base: "",
    url: url_ResourcesMoveResources_568258, schemes: {Scheme.Https})
type
  Call_ResourceGroupsList_568285 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsList_568287(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsList_568286(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets all the resource groups for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568288 = path.getOrDefault("subscriptionId")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "subscriptionId", valid_568288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed, returns all resource groups.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568289 = query.getOrDefault("api-version")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "api-version", valid_568289
  var valid_568290 = query.getOrDefault("$top")
  valid_568290 = validateParameter(valid_568290, JInt, required = false, default = nil)
  if valid_568290 != nil:
    section.add "$top", valid_568290
  var valid_568291 = query.getOrDefault("$filter")
  valid_568291 = validateParameter(valid_568291, JString, required = false,
                                 default = nil)
  if valid_568291 != nil:
    section.add "$filter", valid_568291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568292: Call_ResourceGroupsList_568285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the resource groups for a subscription.
  ## 
  let valid = call_568292.validator(path, query, header, formData, body)
  let scheme = call_568292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568292.url(scheme.get, call_568292.host, call_568292.base,
                         call_568292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568292, url, valid)

proc call*(call_568293: Call_ResourceGroupsList_568285; apiVersion: string;
          subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## resourceGroupsList
  ## Gets all the resource groups for a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return. If null is passed, returns all resource groups.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568294 = newJObject()
  var query_568295 = newJObject()
  add(query_568295, "api-version", newJString(apiVersion))
  add(path_568294, "subscriptionId", newJString(subscriptionId))
  add(query_568295, "$top", newJInt(Top))
  add(query_568295, "$filter", newJString(Filter))
  result = call_568293.call(path_568294, query_568295, nil, nil, nil)

var resourceGroupsList* = Call_ResourceGroupsList_568285(
    name: "resourceGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/resourcegroups",
    validator: validate_ResourceGroupsList_568286, base: "",
    url: url_ResourceGroupsList_568287, schemes: {Scheme.Https})
type
  Call_ResourceGroupsCreateOrUpdate_568306 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsCreateOrUpdate_568308(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsCreateOrUpdate_568307(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to create or update.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568309 = path.getOrDefault("resourceGroupName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "resourceGroupName", valid_568309
  var valid_568310 = path.getOrDefault("subscriptionId")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "subscriptionId", valid_568310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568311 = query.getOrDefault("api-version")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "api-version", valid_568311
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update a resource group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568313: Call_ResourceGroupsCreateOrUpdate_568306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a resource group.
  ## 
  let valid = call_568313.validator(path, query, header, formData, body)
  let scheme = call_568313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568313.url(scheme.get, call_568313.host, call_568313.base,
                         call_568313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568313, url, valid)

proc call*(call_568314: Call_ResourceGroupsCreateOrUpdate_568306;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## resourceGroupsCreateOrUpdate
  ## Creates a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to create or update.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update a resource group.
  var path_568315 = newJObject()
  var query_568316 = newJObject()
  var body_568317 = newJObject()
  add(path_568315, "resourceGroupName", newJString(resourceGroupName))
  add(query_568316, "api-version", newJString(apiVersion))
  add(path_568315, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568317 = parameters
  result = call_568314.call(path_568315, query_568316, nil, nil, body_568317)

var resourceGroupsCreateOrUpdate* = Call_ResourceGroupsCreateOrUpdate_568306(
    name: "resourceGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsCreateOrUpdate_568307, base: "",
    url: url_ResourceGroupsCreateOrUpdate_568308, schemes: {Scheme.Https})
type
  Call_ResourceGroupsCheckExistence_568328 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsCheckExistence_568330(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsCheckExistence_568329(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether a resource group exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568331 = path.getOrDefault("resourceGroupName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "resourceGroupName", valid_568331
  var valid_568332 = path.getOrDefault("subscriptionId")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "subscriptionId", valid_568332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568333 = query.getOrDefault("api-version")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "api-version", valid_568333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568334: Call_ResourceGroupsCheckExistence_568328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a resource group exists.
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_ResourceGroupsCheckExistence_568328;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsCheckExistence
  ## Checks whether a resource group exists.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568336 = newJObject()
  var query_568337 = newJObject()
  add(path_568336, "resourceGroupName", newJString(resourceGroupName))
  add(query_568337, "api-version", newJString(apiVersion))
  add(path_568336, "subscriptionId", newJString(subscriptionId))
  result = call_568335.call(path_568336, query_568337, nil, nil, nil)

var resourceGroupsCheckExistence* = Call_ResourceGroupsCheckExistence_568328(
    name: "resourceGroupsCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsCheckExistence_568329, base: "",
    url: url_ResourceGroupsCheckExistence_568330, schemes: {Scheme.Https})
type
  Call_ResourceGroupsGet_568296 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsGet_568298(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsGet_568297(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568299 = path.getOrDefault("resourceGroupName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "resourceGroupName", valid_568299
  var valid_568300 = path.getOrDefault("subscriptionId")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "subscriptionId", valid_568300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568301 = query.getOrDefault("api-version")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "api-version", valid_568301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568302: Call_ResourceGroupsGet_568296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource group.
  ## 
  let valid = call_568302.validator(path, query, header, formData, body)
  let scheme = call_568302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568302.url(scheme.get, call_568302.host, call_568302.base,
                         call_568302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568302, url, valid)

proc call*(call_568303: Call_ResourceGroupsGet_568296; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsGet
  ## Gets a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568304 = newJObject()
  var query_568305 = newJObject()
  add(path_568304, "resourceGroupName", newJString(resourceGroupName))
  add(query_568305, "api-version", newJString(apiVersion))
  add(path_568304, "subscriptionId", newJString(subscriptionId))
  result = call_568303.call(path_568304, query_568305, nil, nil, nil)

var resourceGroupsGet* = Call_ResourceGroupsGet_568296(name: "resourceGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsGet_568297, base: "",
    url: url_ResourceGroupsGet_568298, schemes: {Scheme.Https})
type
  Call_ResourceGroupsPatch_568338 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsPatch_568340(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsPatch_568339(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource group. If a field is unspecified, the current value is retained.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to update. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568341 = path.getOrDefault("resourceGroupName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "resourceGroupName", valid_568341
  var valid_568342 = path.getOrDefault("subscriptionId")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "subscriptionId", valid_568342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568343 = query.getOrDefault("api-version")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "api-version", valid_568343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update a resource group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568345: Call_ResourceGroupsPatch_568338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource group. If a field is unspecified, the current value is retained.
  ## 
  let valid = call_568345.validator(path, query, header, formData, body)
  let scheme = call_568345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568345.url(scheme.get, call_568345.host, call_568345.base,
                         call_568345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568345, url, valid)

proc call*(call_568346: Call_ResourceGroupsPatch_568338; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## resourceGroupsPatch
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource group. If a field is unspecified, the current value is retained.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to update. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update a resource group.
  var path_568347 = newJObject()
  var query_568348 = newJObject()
  var body_568349 = newJObject()
  add(path_568347, "resourceGroupName", newJString(resourceGroupName))
  add(query_568348, "api-version", newJString(apiVersion))
  add(path_568347, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568349 = parameters
  result = call_568346.call(path_568347, query_568348, nil, nil, body_568349)

var resourceGroupsPatch* = Call_ResourceGroupsPatch_568338(
    name: "resourceGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsPatch_568339, base: "",
    url: url_ResourceGroupsPatch_568340, schemes: {Scheme.Https})
type
  Call_ResourceGroupsDelete_568318 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsDelete_568320(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsDelete_568319(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## When you delete a resource group, all of its resources are also deleted. Deleting a resource group deletes all of its template deployments and currently stored operations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to delete. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568321 = path.getOrDefault("resourceGroupName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "resourceGroupName", valid_568321
  var valid_568322 = path.getOrDefault("subscriptionId")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "subscriptionId", valid_568322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568323 = query.getOrDefault("api-version")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "api-version", valid_568323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568324: Call_ResourceGroupsDelete_568318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When you delete a resource group, all of its resources are also deleted. Deleting a resource group deletes all of its template deployments and currently stored operations.
  ## 
  let valid = call_568324.validator(path, query, header, formData, body)
  let scheme = call_568324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568324.url(scheme.get, call_568324.host, call_568324.base,
                         call_568324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568324, url, valid)

proc call*(call_568325: Call_ResourceGroupsDelete_568318;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsDelete
  ## When you delete a resource group, all of its resources are also deleted. Deleting a resource group deletes all of its template deployments and currently stored operations.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to delete. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568326 = newJObject()
  var query_568327 = newJObject()
  add(path_568326, "resourceGroupName", newJString(resourceGroupName))
  add(query_568327, "api-version", newJString(apiVersion))
  add(path_568326, "subscriptionId", newJString(subscriptionId))
  result = call_568325.call(path_568326, query_568327, nil, nil, nil)

var resourceGroupsDelete* = Call_ResourceGroupsDelete_568318(
    name: "resourceGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsDelete_568319, base: "",
    url: url_ResourceGroupsDelete_568320, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsList_568350 = ref object of OpenApiRestCall_567666
proc url_DeploymentOperationsList_568352(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsList_568351(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all deployments operations for a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment with the operation to get.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568353 = path.getOrDefault("resourceGroupName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "resourceGroupName", valid_568353
  var valid_568354 = path.getOrDefault("deploymentName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "deploymentName", valid_568354
  var valid_568355 = path.getOrDefault("subscriptionId")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "subscriptionId", valid_568355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568356 = query.getOrDefault("api-version")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "api-version", valid_568356
  var valid_568357 = query.getOrDefault("$top")
  valid_568357 = validateParameter(valid_568357, JInt, required = false, default = nil)
  if valid_568357 != nil:
    section.add "$top", valid_568357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568358: Call_DeploymentOperationsList_568350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all deployments operations for a deployment.
  ## 
  let valid = call_568358.validator(path, query, header, formData, body)
  let scheme = call_568358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568358.url(scheme.get, call_568358.host, call_568358.base,
                         call_568358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568358, url, valid)

proc call*(call_568359: Call_DeploymentOperationsList_568350;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## deploymentOperationsList
  ## Gets all deployments operations for a deployment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment with the operation to get.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return.
  var path_568360 = newJObject()
  var query_568361 = newJObject()
  add(path_568360, "resourceGroupName", newJString(resourceGroupName))
  add(query_568361, "api-version", newJString(apiVersion))
  add(path_568360, "deploymentName", newJString(deploymentName))
  add(path_568360, "subscriptionId", newJString(subscriptionId))
  add(query_568361, "$top", newJInt(Top))
  result = call_568359.call(path_568360, query_568361, nil, nil, nil)

var deploymentOperationsList* = Call_DeploymentOperationsList_568350(
    name: "deploymentOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/deployments/{deploymentName}/operations",
    validator: validate_DeploymentOperationsList_568351, base: "",
    url: url_DeploymentOperationsList_568352, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsGet_568362 = ref object of OpenApiRestCall_567666
proc url_DeploymentOperationsGet_568364(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsGet_568363(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployments operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   operationId: JString (required)
  ##              : The ID of the operation to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568365 = path.getOrDefault("resourceGroupName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "resourceGroupName", valid_568365
  var valid_568366 = path.getOrDefault("deploymentName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "deploymentName", valid_568366
  var valid_568367 = path.getOrDefault("subscriptionId")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "subscriptionId", valid_568367
  var valid_568368 = path.getOrDefault("operationId")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "operationId", valid_568368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568369 = query.getOrDefault("api-version")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "api-version", valid_568369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568370: Call_DeploymentOperationsGet_568362; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deployments operation.
  ## 
  let valid = call_568370.validator(path, query, header, formData, body)
  let scheme = call_568370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568370.url(scheme.get, call_568370.host, call_568370.base,
                         call_568370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568370, url, valid)

proc call*(call_568371: Call_DeploymentOperationsGet_568362;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string; operationId: string): Recallable =
  ## deploymentOperationsGet
  ## Gets a deployments operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   operationId: string (required)
  ##              : The ID of the operation to get.
  var path_568372 = newJObject()
  var query_568373 = newJObject()
  add(path_568372, "resourceGroupName", newJString(resourceGroupName))
  add(query_568373, "api-version", newJString(apiVersion))
  add(path_568372, "deploymentName", newJString(deploymentName))
  add(path_568372, "subscriptionId", newJString(subscriptionId))
  add(path_568372, "operationId", newJString(operationId))
  result = call_568371.call(path_568372, query_568373, nil, nil, nil)

var deploymentOperationsGet* = Call_DeploymentOperationsGet_568362(
    name: "deploymentOperationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/deployments/{deploymentName}/operations/{operationId}",
    validator: validate_DeploymentOperationsGet_568363, base: "",
    url: url_DeploymentOperationsGet_568364, schemes: {Scheme.Https})
type
  Call_ResourceGroupsExportTemplate_568374 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsExportTemplate_568376(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/exportTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsExportTemplate_568375(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Captures the specified resource group as a template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to export as a template.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568377 = path.getOrDefault("resourceGroupName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "resourceGroupName", valid_568377
  var valid_568378 = path.getOrDefault("subscriptionId")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "subscriptionId", valid_568378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568379 = query.getOrDefault("api-version")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "api-version", valid_568379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for exporting the template.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568381: Call_ResourceGroupsExportTemplate_568374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Captures the specified resource group as a template.
  ## 
  let valid = call_568381.validator(path, query, header, formData, body)
  let scheme = call_568381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568381.url(scheme.get, call_568381.host, call_568381.base,
                         call_568381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568381, url, valid)

proc call*(call_568382: Call_ResourceGroupsExportTemplate_568374;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## resourceGroupsExportTemplate
  ## Captures the specified resource group as a template.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to export as a template.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters for exporting the template.
  var path_568383 = newJObject()
  var query_568384 = newJObject()
  var body_568385 = newJObject()
  add(path_568383, "resourceGroupName", newJString(resourceGroupName))
  add(query_568384, "api-version", newJString(apiVersion))
  add(path_568383, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568385 = parameters
  result = call_568382.call(path_568383, query_568384, nil, nil, body_568385)

var resourceGroupsExportTemplate* = Call_ResourceGroupsExportTemplate_568374(
    name: "resourceGroupsExportTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/exportTemplate",
    validator: validate_ResourceGroupsExportTemplate_568375, base: "",
    url: url_ResourceGroupsExportTemplate_568376, schemes: {Scheme.Https})
type
  Call_DeploymentsList_568386 = ref object of OpenApiRestCall_567666
proc url_DeploymentsList_568388(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsList_568387(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get all the deployments for a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group with the deployments to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568389 = path.getOrDefault("resourceGroupName")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "resourceGroupName", valid_568389
  var valid_568390 = path.getOrDefault("subscriptionId")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "subscriptionId", valid_568390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to get. If null is passed, returns all deployments.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568391 = query.getOrDefault("api-version")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "api-version", valid_568391
  var valid_568392 = query.getOrDefault("$top")
  valid_568392 = validateParameter(valid_568392, JInt, required = false, default = nil)
  if valid_568392 != nil:
    section.add "$top", valid_568392
  var valid_568393 = query.getOrDefault("$filter")
  valid_568393 = validateParameter(valid_568393, JString, required = false,
                                 default = nil)
  if valid_568393 != nil:
    section.add "$filter", valid_568393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568394: Call_DeploymentsList_568386; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the deployments for a resource group.
  ## 
  let valid = call_568394.validator(path, query, header, formData, body)
  let scheme = call_568394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568394.url(scheme.get, call_568394.host, call_568394.base,
                         call_568394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568394, url, valid)

proc call*(call_568395: Call_DeploymentsList_568386; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## deploymentsList
  ## Get all the deployments for a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group with the deployments to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to get. If null is passed, returns all deployments.
  ##   Filter: string
  ##         : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  var path_568396 = newJObject()
  var query_568397 = newJObject()
  add(path_568396, "resourceGroupName", newJString(resourceGroupName))
  add(query_568397, "api-version", newJString(apiVersion))
  add(path_568396, "subscriptionId", newJString(subscriptionId))
  add(query_568397, "$top", newJInt(Top))
  add(query_568397, "$filter", newJString(Filter))
  result = call_568395.call(path_568396, query_568397, nil, nil, nil)

var deploymentsList* = Call_DeploymentsList_568386(name: "deploymentsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/",
    validator: validate_DeploymentsList_568387, base: "", url: url_DeploymentsList_568388,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCreateOrUpdate_568409 = ref object of OpenApiRestCall_567666
proc url_DeploymentsCreateOrUpdate_568411(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCreateOrUpdate_568410(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to deploy the resources to. The name is case insensitive. The resource group must already exist.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568412 = path.getOrDefault("resourceGroupName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "resourceGroupName", valid_568412
  var valid_568413 = path.getOrDefault("deploymentName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "deploymentName", valid_568413
  var valid_568414 = path.getOrDefault("subscriptionId")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "subscriptionId", valid_568414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568415 = query.getOrDefault("api-version")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "api-version", valid_568415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568417: Call_DeploymentsCreateOrUpdate_568409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  let valid = call_568417.validator(path, query, header, formData, body)
  let scheme = call_568417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568417.url(scheme.get, call_568417.host, call_568417.base,
                         call_568417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568417, url, valid)

proc call*(call_568418: Call_DeploymentsCreateOrUpdate_568409;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## deploymentsCreateOrUpdate
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to deploy the resources to. The name is case insensitive. The resource group must already exist.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  var path_568419 = newJObject()
  var query_568420 = newJObject()
  var body_568421 = newJObject()
  add(path_568419, "resourceGroupName", newJString(resourceGroupName))
  add(query_568420, "api-version", newJString(apiVersion))
  add(path_568419, "deploymentName", newJString(deploymentName))
  add(path_568419, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568421 = parameters
  result = call_568418.call(path_568419, query_568420, nil, nil, body_568421)

var deploymentsCreateOrUpdate* = Call_DeploymentsCreateOrUpdate_568409(
    name: "deploymentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCreateOrUpdate_568410, base: "",
    url: url_DeploymentsCreateOrUpdate_568411, schemes: {Scheme.Https})
type
  Call_DeploymentsCheckExistence_568433 = ref object of OpenApiRestCall_567666
proc url_DeploymentsCheckExistence_568435(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCheckExistence_568434(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the deployment exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group with the deployment to check. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment to check.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568436 = path.getOrDefault("resourceGroupName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "resourceGroupName", valid_568436
  var valid_568437 = path.getOrDefault("deploymentName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "deploymentName", valid_568437
  var valid_568438 = path.getOrDefault("subscriptionId")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "subscriptionId", valid_568438
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568439 = query.getOrDefault("api-version")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "api-version", valid_568439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568440: Call_DeploymentsCheckExistence_568433; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the deployment exists.
  ## 
  let valid = call_568440.validator(path, query, header, formData, body)
  let scheme = call_568440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568440.url(scheme.get, call_568440.host, call_568440.base,
                         call_568440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568440, url, valid)

proc call*(call_568441: Call_DeploymentsCheckExistence_568433;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string): Recallable =
  ## deploymentsCheckExistence
  ## Checks whether the deployment exists.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group with the deployment to check. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment to check.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568442 = newJObject()
  var query_568443 = newJObject()
  add(path_568442, "resourceGroupName", newJString(resourceGroupName))
  add(query_568443, "api-version", newJString(apiVersion))
  add(path_568442, "deploymentName", newJString(deploymentName))
  add(path_568442, "subscriptionId", newJString(subscriptionId))
  result = call_568441.call(path_568442, query_568443, nil, nil, nil)

var deploymentsCheckExistence* = Call_DeploymentsCheckExistence_568433(
    name: "deploymentsCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCheckExistence_568434, base: "",
    url: url_DeploymentsCheckExistence_568435, schemes: {Scheme.Https})
type
  Call_DeploymentsGet_568398 = ref object of OpenApiRestCall_567666
proc url_DeploymentsGet_568400(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsGet_568399(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment to get.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568401 = path.getOrDefault("resourceGroupName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "resourceGroupName", valid_568401
  var valid_568402 = path.getOrDefault("deploymentName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "deploymentName", valid_568402
  var valid_568403 = path.getOrDefault("subscriptionId")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "subscriptionId", valid_568403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568404 = query.getOrDefault("api-version")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "api-version", valid_568404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568405: Call_DeploymentsGet_568398; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deployment.
  ## 
  let valid = call_568405.validator(path, query, header, formData, body)
  let scheme = call_568405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568405.url(scheme.get, call_568405.host, call_568405.base,
                         call_568405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568405, url, valid)

proc call*(call_568406: Call_DeploymentsGet_568398; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsGet
  ## Gets a deployment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment to get.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568407 = newJObject()
  var query_568408 = newJObject()
  add(path_568407, "resourceGroupName", newJString(resourceGroupName))
  add(query_568408, "api-version", newJString(apiVersion))
  add(path_568407, "deploymentName", newJString(deploymentName))
  add(path_568407, "subscriptionId", newJString(subscriptionId))
  result = call_568406.call(path_568407, query_568408, nil, nil, nil)

var deploymentsGet* = Call_DeploymentsGet_568398(name: "deploymentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsGet_568399, base: "", url: url_DeploymentsGet_568400,
    schemes: {Scheme.Https})
type
  Call_DeploymentsDelete_568422 = ref object of OpenApiRestCall_567666
proc url_DeploymentsDelete_568424(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsDelete_568423(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. Deleting a template deployment does not affect the state of the resource group. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group with the deployment to delete. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment to delete.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568425 = path.getOrDefault("resourceGroupName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "resourceGroupName", valid_568425
  var valid_568426 = path.getOrDefault("deploymentName")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "deploymentName", valid_568426
  var valid_568427 = path.getOrDefault("subscriptionId")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "subscriptionId", valid_568427
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568428 = query.getOrDefault("api-version")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "api-version", valid_568428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568429: Call_DeploymentsDelete_568422; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. Deleting a template deployment does not affect the state of the resource group. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  let valid = call_568429.validator(path, query, header, formData, body)
  let scheme = call_568429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568429.url(scheme.get, call_568429.host, call_568429.base,
                         call_568429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568429, url, valid)

proc call*(call_568430: Call_DeploymentsDelete_568422; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsDelete
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. Deleting a template deployment does not affect the state of the resource group. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group with the deployment to delete. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment to delete.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568431 = newJObject()
  var query_568432 = newJObject()
  add(path_568431, "resourceGroupName", newJString(resourceGroupName))
  add(query_568432, "api-version", newJString(apiVersion))
  add(path_568431, "deploymentName", newJString(deploymentName))
  add(path_568431, "subscriptionId", newJString(subscriptionId))
  result = call_568430.call(path_568431, query_568432, nil, nil, nil)

var deploymentsDelete* = Call_DeploymentsDelete_568422(name: "deploymentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsDelete_568423, base: "",
    url: url_DeploymentsDelete_568424, schemes: {Scheme.Https})
type
  Call_DeploymentsCancel_568444 = ref object of OpenApiRestCall_567666
proc url_DeploymentsCancel_568446(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCancel_568445(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resource group partially deployed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment to cancel.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568447 = path.getOrDefault("resourceGroupName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "resourceGroupName", valid_568447
  var valid_568448 = path.getOrDefault("deploymentName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "deploymentName", valid_568448
  var valid_568449 = path.getOrDefault("subscriptionId")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "subscriptionId", valid_568449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568450 = query.getOrDefault("api-version")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "api-version", valid_568450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568451: Call_DeploymentsCancel_568444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resource group partially deployed.
  ## 
  let valid = call_568451.validator(path, query, header, formData, body)
  let scheme = call_568451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568451.url(scheme.get, call_568451.host, call_568451.base,
                         call_568451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568451, url, valid)

proc call*(call_568452: Call_DeploymentsCancel_568444; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsCancel
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resource group partially deployed.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment to cancel.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568453 = newJObject()
  var query_568454 = newJObject()
  add(path_568453, "resourceGroupName", newJString(resourceGroupName))
  add(query_568454, "api-version", newJString(apiVersion))
  add(path_568453, "deploymentName", newJString(deploymentName))
  add(path_568453, "subscriptionId", newJString(subscriptionId))
  result = call_568452.call(path_568453, query_568454, nil, nil, nil)

var deploymentsCancel* = Call_DeploymentsCancel_568444(name: "deploymentsCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/cancel",
    validator: validate_DeploymentsCancel_568445, base: "",
    url: url_DeploymentsCancel_568446, schemes: {Scheme.Https})
type
  Call_DeploymentsExportTemplate_568455 = ref object of OpenApiRestCall_567666
proc url_DeploymentsExportTemplate_568457(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/exportTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsExportTemplate_568456(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports the template used for specified deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment from which to get the template.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568458 = path.getOrDefault("resourceGroupName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "resourceGroupName", valid_568458
  var valid_568459 = path.getOrDefault("deploymentName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "deploymentName", valid_568459
  var valid_568460 = path.getOrDefault("subscriptionId")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "subscriptionId", valid_568460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568461 = query.getOrDefault("api-version")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "api-version", valid_568461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568462: Call_DeploymentsExportTemplate_568455; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the template used for specified deployment.
  ## 
  let valid = call_568462.validator(path, query, header, formData, body)
  let scheme = call_568462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568462.url(scheme.get, call_568462.host, call_568462.base,
                         call_568462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568462, url, valid)

proc call*(call_568463: Call_DeploymentsExportTemplate_568455;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string): Recallable =
  ## deploymentsExportTemplate
  ## Exports the template used for specified deployment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment from which to get the template.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568464 = newJObject()
  var query_568465 = newJObject()
  add(path_568464, "resourceGroupName", newJString(resourceGroupName))
  add(query_568465, "api-version", newJString(apiVersion))
  add(path_568464, "deploymentName", newJString(deploymentName))
  add(path_568464, "subscriptionId", newJString(subscriptionId))
  result = call_568463.call(path_568464, query_568465, nil, nil, nil)

var deploymentsExportTemplate* = Call_DeploymentsExportTemplate_568455(
    name: "deploymentsExportTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/exportTemplate",
    validator: validate_DeploymentsExportTemplate_568456, base: "",
    url: url_DeploymentsExportTemplate_568457, schemes: {Scheme.Https})
type
  Call_DeploymentsValidate_568466 = ref object of OpenApiRestCall_567666
proc url_DeploymentsValidate_568468(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsValidate_568467(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group the template will be deployed to. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568469 = path.getOrDefault("resourceGroupName")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "resourceGroupName", valid_568469
  var valid_568470 = path.getOrDefault("deploymentName")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "deploymentName", valid_568470
  var valid_568471 = path.getOrDefault("subscriptionId")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "subscriptionId", valid_568471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568472 = query.getOrDefault("api-version")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "api-version", valid_568472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568474: Call_DeploymentsValidate_568466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  let valid = call_568474.validator(path, query, header, formData, body)
  let scheme = call_568474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568474.url(scheme.get, call_568474.host, call_568474.base,
                         call_568474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568474, url, valid)

proc call*(call_568475: Call_DeploymentsValidate_568466; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## deploymentsValidate
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group the template will be deployed to. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  var path_568476 = newJObject()
  var query_568477 = newJObject()
  var body_568478 = newJObject()
  add(path_568476, "resourceGroupName", newJString(resourceGroupName))
  add(query_568477, "api-version", newJString(apiVersion))
  add(path_568476, "deploymentName", newJString(deploymentName))
  add(path_568476, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568478 = parameters
  result = call_568475.call(path_568476, query_568477, nil, nil, body_568478)

var deploymentsValidate* = Call_DeploymentsValidate_568466(
    name: "deploymentsValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/validate",
    validator: validate_DeploymentsValidate_568467, base: "",
    url: url_DeploymentsValidate_568468, schemes: {Scheme.Https})
type
  Call_ResourcesCreateOrUpdate_568493 = ref object of OpenApiRestCall_567666
proc url_ResourcesCreateOrUpdate_568495(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCreateOrUpdate_568494(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource to create.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to create.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568496 = path.getOrDefault("resourceType")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "resourceType", valid_568496
  var valid_568497 = path.getOrDefault("resourceGroupName")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "resourceGroupName", valid_568497
  var valid_568498 = path.getOrDefault("subscriptionId")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "subscriptionId", valid_568498
  var valid_568499 = path.getOrDefault("resourceName")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "resourceName", valid_568499
  var valid_568500 = path.getOrDefault("resourceProviderNamespace")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "resourceProviderNamespace", valid_568500
  var valid_568501 = path.getOrDefault("parentResourcePath")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "parentResourcePath", valid_568501
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568502 = query.getOrDefault("api-version")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "api-version", valid_568502
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for creating or updating the resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568504: Call_ResourcesCreateOrUpdate_568493; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a resource.
  ## 
  let valid = call_568504.validator(path, query, header, formData, body)
  let scheme = call_568504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568504.url(scheme.get, call_568504.host, call_568504.base,
                         call_568504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568504, url, valid)

proc call*(call_568505: Call_ResourcesCreateOrUpdate_568493; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode;
          resourceProviderNamespace: string; parentResourcePath: string): Recallable =
  ## resourcesCreateOrUpdate
  ## Creates a resource.
  ##   resourceType: string (required)
  ##               : The resource type of the resource to create.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to create.
  ##   parameters: JObject (required)
  ##             : Parameters for creating or updating the resource.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568506 = newJObject()
  var query_568507 = newJObject()
  var body_568508 = newJObject()
  add(path_568506, "resourceType", newJString(resourceType))
  add(path_568506, "resourceGroupName", newJString(resourceGroupName))
  add(query_568507, "api-version", newJString(apiVersion))
  add(path_568506, "subscriptionId", newJString(subscriptionId))
  add(path_568506, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_568508 = parameters
  add(path_568506, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568506, "parentResourcePath", newJString(parentResourcePath))
  result = call_568505.call(path_568506, query_568507, nil, nil, body_568508)

var resourcesCreateOrUpdate* = Call_ResourcesCreateOrUpdate_568493(
    name: "resourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesCreateOrUpdate_568494, base: "",
    url: url_ResourcesCreateOrUpdate_568495, schemes: {Scheme.Https})
type
  Call_ResourcesCheckExistence_568523 = ref object of OpenApiRestCall_567666
proc url_ResourcesCheckExistence_568525(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCheckExistence_568524(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether a resource exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the resource to check. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to check whether it exists.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The resource provider of the resource to check.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568526 = path.getOrDefault("resourceType")
  valid_568526 = validateParameter(valid_568526, JString, required = true,
                                 default = nil)
  if valid_568526 != nil:
    section.add "resourceType", valid_568526
  var valid_568527 = path.getOrDefault("resourceGroupName")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "resourceGroupName", valid_568527
  var valid_568528 = path.getOrDefault("subscriptionId")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "subscriptionId", valid_568528
  var valid_568529 = path.getOrDefault("resourceName")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "resourceName", valid_568529
  var valid_568530 = path.getOrDefault("resourceProviderNamespace")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "resourceProviderNamespace", valid_568530
  var valid_568531 = path.getOrDefault("parentResourcePath")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "parentResourcePath", valid_568531
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568532 = query.getOrDefault("api-version")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "api-version", valid_568532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568533: Call_ResourcesCheckExistence_568523; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a resource exists.
  ## 
  let valid = call_568533.validator(path, query, header, formData, body)
  let scheme = call_568533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568533.url(scheme.get, call_568533.host, call_568533.base,
                         call_568533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568533, url, valid)

proc call*(call_568534: Call_ResourcesCheckExistence_568523; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceProviderNamespace: string;
          parentResourcePath: string): Recallable =
  ## resourcesCheckExistence
  ## Checks whether a resource exists.
  ##   resourceType: string (required)
  ##               : The resource type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the resource to check. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to check whether it exists.
  ##   resourceProviderNamespace: string (required)
  ##                            : The resource provider of the resource to check.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568535 = newJObject()
  var query_568536 = newJObject()
  add(path_568535, "resourceType", newJString(resourceType))
  add(path_568535, "resourceGroupName", newJString(resourceGroupName))
  add(query_568536, "api-version", newJString(apiVersion))
  add(path_568535, "subscriptionId", newJString(subscriptionId))
  add(path_568535, "resourceName", newJString(resourceName))
  add(path_568535, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568535, "parentResourcePath", newJString(parentResourcePath))
  result = call_568534.call(path_568535, query_568536, nil, nil, nil)

var resourcesCheckExistence* = Call_ResourcesCheckExistence_568523(
    name: "resourcesCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesCheckExistence_568524, base: "",
    url: url_ResourcesCheckExistence_568525, schemes: {Scheme.Https})
type
  Call_ResourcesGet_568479 = ref object of OpenApiRestCall_567666
proc url_ResourcesGet_568481(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesGet_568480(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the resource to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to get.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568482 = path.getOrDefault("resourceType")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "resourceType", valid_568482
  var valid_568483 = path.getOrDefault("resourceGroupName")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "resourceGroupName", valid_568483
  var valid_568484 = path.getOrDefault("subscriptionId")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "subscriptionId", valid_568484
  var valid_568485 = path.getOrDefault("resourceName")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "resourceName", valid_568485
  var valid_568486 = path.getOrDefault("resourceProviderNamespace")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "resourceProviderNamespace", valid_568486
  var valid_568487 = path.getOrDefault("parentResourcePath")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "parentResourcePath", valid_568487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568488 = query.getOrDefault("api-version")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "api-version", valid_568488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568489: Call_ResourcesGet_568479; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource.
  ## 
  let valid = call_568489.validator(path, query, header, formData, body)
  let scheme = call_568489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568489.url(scheme.get, call_568489.host, call_568489.base,
                         call_568489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568489, url, valid)

proc call*(call_568490: Call_ResourcesGet_568479; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceProviderNamespace: string;
          parentResourcePath: string): Recallable =
  ## resourcesGet
  ## Gets a resource.
  ##   resourceType: string (required)
  ##               : The resource type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the resource to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to get.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568491 = newJObject()
  var query_568492 = newJObject()
  add(path_568491, "resourceType", newJString(resourceType))
  add(path_568491, "resourceGroupName", newJString(resourceGroupName))
  add(query_568492, "api-version", newJString(apiVersion))
  add(path_568491, "subscriptionId", newJString(subscriptionId))
  add(path_568491, "resourceName", newJString(resourceName))
  add(path_568491, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568491, "parentResourcePath", newJString(parentResourcePath))
  result = call_568490.call(path_568491, query_568492, nil, nil, nil)

var resourcesGet* = Call_ResourcesGet_568479(name: "resourcesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesGet_568480, base: "", url: url_ResourcesGet_568481,
    schemes: {Scheme.Https})
type
  Call_ResourcesUpdate_568537 = ref object of OpenApiRestCall_567666
proc url_ResourcesUpdate_568539(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesUpdate_568538(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource to update.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to update.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568540 = path.getOrDefault("resourceType")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "resourceType", valid_568540
  var valid_568541 = path.getOrDefault("resourceGroupName")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "resourceGroupName", valid_568541
  var valid_568542 = path.getOrDefault("subscriptionId")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "subscriptionId", valid_568542
  var valid_568543 = path.getOrDefault("resourceName")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "resourceName", valid_568543
  var valid_568544 = path.getOrDefault("resourceProviderNamespace")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "resourceProviderNamespace", valid_568544
  var valid_568545 = path.getOrDefault("parentResourcePath")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "parentResourcePath", valid_568545
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568546 = query.getOrDefault("api-version")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "api-version", valid_568546
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for updating the resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568548: Call_ResourcesUpdate_568537; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource.
  ## 
  let valid = call_568548.validator(path, query, header, formData, body)
  let scheme = call_568548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568548.url(scheme.get, call_568548.host, call_568548.base,
                         call_568548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568548, url, valid)

proc call*(call_568549: Call_ResourcesUpdate_568537; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode;
          resourceProviderNamespace: string; parentResourcePath: string): Recallable =
  ## resourcesUpdate
  ## Updates a resource.
  ##   resourceType: string (required)
  ##               : The resource type of the resource to update.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to update.
  ##   parameters: JObject (required)
  ##             : Parameters for updating the resource.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568550 = newJObject()
  var query_568551 = newJObject()
  var body_568552 = newJObject()
  add(path_568550, "resourceType", newJString(resourceType))
  add(path_568550, "resourceGroupName", newJString(resourceGroupName))
  add(query_568551, "api-version", newJString(apiVersion))
  add(path_568550, "subscriptionId", newJString(subscriptionId))
  add(path_568550, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_568552 = parameters
  add(path_568550, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568550, "parentResourcePath", newJString(parentResourcePath))
  result = call_568549.call(path_568550, query_568551, nil, nil, body_568552)

var resourcesUpdate* = Call_ResourcesUpdate_568537(name: "resourcesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesUpdate_568538, base: "", url: url_ResourcesUpdate_568539,
    schemes: {Scheme.Https})
type
  Call_ResourcesDelete_568509 = ref object of OpenApiRestCall_567666
proc url_ResourcesDelete_568511(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesDelete_568510(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource to delete. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to delete.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568512 = path.getOrDefault("resourceType")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "resourceType", valid_568512
  var valid_568513 = path.getOrDefault("resourceGroupName")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "resourceGroupName", valid_568513
  var valid_568514 = path.getOrDefault("subscriptionId")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "subscriptionId", valid_568514
  var valid_568515 = path.getOrDefault("resourceName")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "resourceName", valid_568515
  var valid_568516 = path.getOrDefault("resourceProviderNamespace")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "resourceProviderNamespace", valid_568516
  var valid_568517 = path.getOrDefault("parentResourcePath")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "parentResourcePath", valid_568517
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568518 = query.getOrDefault("api-version")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "api-version", valid_568518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568519: Call_ResourcesDelete_568509; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a resource.
  ## 
  let valid = call_568519.validator(path, query, header, formData, body)
  let scheme = call_568519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568519.url(scheme.get, call_568519.host, call_568519.base,
                         call_568519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568519, url, valid)

proc call*(call_568520: Call_ResourcesDelete_568509; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceProviderNamespace: string;
          parentResourcePath: string): Recallable =
  ## resourcesDelete
  ## Deletes a resource.
  ##   resourceType: string (required)
  ##               : The resource type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource to delete. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to delete.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568521 = newJObject()
  var query_568522 = newJObject()
  add(path_568521, "resourceType", newJString(resourceType))
  add(path_568521, "resourceGroupName", newJString(resourceGroupName))
  add(query_568522, "api-version", newJString(apiVersion))
  add(path_568521, "subscriptionId", newJString(subscriptionId))
  add(path_568521, "resourceName", newJString(resourceName))
  add(path_568521, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568521, "parentResourcePath", newJString(parentResourcePath))
  result = call_568520.call(path_568521, query_568522, nil, nil, nil)

var resourcesDelete* = Call_ResourcesDelete_568509(name: "resourcesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesDelete_568510, base: "", url: url_ResourcesDelete_568511,
    schemes: {Scheme.Https})
type
  Call_ResourcesList_568553 = ref object of OpenApiRestCall_567666
proc url_ResourcesList_568555(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesList_568554(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the resources in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568556 = path.getOrDefault("subscriptionId")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "subscriptionId", valid_568556
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand query parameter.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed, returns all resource groups.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_568557 = query.getOrDefault("$expand")
  valid_568557 = validateParameter(valid_568557, JString, required = false,
                                 default = nil)
  if valid_568557 != nil:
    section.add "$expand", valid_568557
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568558 = query.getOrDefault("api-version")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "api-version", valid_568558
  var valid_568559 = query.getOrDefault("$top")
  valid_568559 = validateParameter(valid_568559, JInt, required = false, default = nil)
  if valid_568559 != nil:
    section.add "$top", valid_568559
  var valid_568560 = query.getOrDefault("$filter")
  valid_568560 = validateParameter(valid_568560, JString, required = false,
                                 default = nil)
  if valid_568560 != nil:
    section.add "$filter", valid_568560
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568561: Call_ResourcesList_568553; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the resources in a subscription.
  ## 
  let valid = call_568561.validator(path, query, header, formData, body)
  let scheme = call_568561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568561.url(scheme.get, call_568561.host, call_568561.base,
                         call_568561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568561, url, valid)

proc call*(call_568562: Call_ResourcesList_568553; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## resourcesList
  ## Get all the resources in a subscription.
  ##   Expand: string
  ##         : The $expand query parameter.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return. If null is passed, returns all resource groups.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568563 = newJObject()
  var query_568564 = newJObject()
  add(query_568564, "$expand", newJString(Expand))
  add(query_568564, "api-version", newJString(apiVersion))
  add(path_568563, "subscriptionId", newJString(subscriptionId))
  add(query_568564, "$top", newJInt(Top))
  add(query_568564, "$filter", newJString(Filter))
  result = call_568562.call(path_568563, query_568564, nil, nil, nil)

var resourcesList* = Call_ResourcesList_568553(name: "resourcesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/resources",
    validator: validate_ResourcesList_568554, base: "", url: url_ResourcesList_568555,
    schemes: {Scheme.Https})
type
  Call_TagsList_568565 = ref object of OpenApiRestCall_567666
proc url_TagsList_568567(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsList_568566(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the names and values of all resource tags that are defined in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568568 = path.getOrDefault("subscriptionId")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "subscriptionId", valid_568568
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568569 = query.getOrDefault("api-version")
  valid_568569 = validateParameter(valid_568569, JString, required = true,
                                 default = nil)
  if valid_568569 != nil:
    section.add "api-version", valid_568569
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568570: Call_TagsList_568565; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the names and values of all resource tags that are defined in a subscription.
  ## 
  let valid = call_568570.validator(path, query, header, formData, body)
  let scheme = call_568570.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568570.url(scheme.get, call_568570.host, call_568570.base,
                         call_568570.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568570, url, valid)

proc call*(call_568571: Call_TagsList_568565; apiVersion: string;
          subscriptionId: string): Recallable =
  ## tagsList
  ## Gets the names and values of all resource tags that are defined in a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568572 = newJObject()
  var query_568573 = newJObject()
  add(query_568573, "api-version", newJString(apiVersion))
  add(path_568572, "subscriptionId", newJString(subscriptionId))
  result = call_568571.call(path_568572, query_568573, nil, nil, nil)

var tagsList* = Call_TagsList_568565(name: "tagsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames",
                                  validator: validate_TagsList_568566, base: "",
                                  url: url_TagsList_568567,
                                  schemes: {Scheme.Https})
type
  Call_TagsCreateOrUpdate_568574 = ref object of OpenApiRestCall_567666
proc url_TagsCreateOrUpdate_568576(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsCreateOrUpdate_568575(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The tag name can have a maximum of 512 characters and is case insensitive. Tag names created by Azure have prefixes of microsoft, azure, or windows. You cannot create tags with one of these prefixes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag to create.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_568577 = path.getOrDefault("tagName")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "tagName", valid_568577
  var valid_568578 = path.getOrDefault("subscriptionId")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "subscriptionId", valid_568578
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568579 = query.getOrDefault("api-version")
  valid_568579 = validateParameter(valid_568579, JString, required = true,
                                 default = nil)
  if valid_568579 != nil:
    section.add "api-version", valid_568579
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568580: Call_TagsCreateOrUpdate_568574; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tag name can have a maximum of 512 characters and is case insensitive. Tag names created by Azure have prefixes of microsoft, azure, or windows. You cannot create tags with one of these prefixes.
  ## 
  let valid = call_568580.validator(path, query, header, formData, body)
  let scheme = call_568580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568580.url(scheme.get, call_568580.host, call_568580.base,
                         call_568580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568580, url, valid)

proc call*(call_568581: Call_TagsCreateOrUpdate_568574; apiVersion: string;
          tagName: string; subscriptionId: string): Recallable =
  ## tagsCreateOrUpdate
  ## The tag name can have a maximum of 512 characters and is case insensitive. Tag names created by Azure have prefixes of microsoft, azure, or windows. You cannot create tags with one of these prefixes.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag to create.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568582 = newJObject()
  var query_568583 = newJObject()
  add(query_568583, "api-version", newJString(apiVersion))
  add(path_568582, "tagName", newJString(tagName))
  add(path_568582, "subscriptionId", newJString(subscriptionId))
  result = call_568581.call(path_568582, query_568583, nil, nil, nil)

var tagsCreateOrUpdate* = Call_TagsCreateOrUpdate_568574(
    name: "tagsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/tagNames/{tagName}",
    validator: validate_TagsCreateOrUpdate_568575, base: "",
    url: url_TagsCreateOrUpdate_568576, schemes: {Scheme.Https})
type
  Call_TagsDelete_568584 = ref object of OpenApiRestCall_567666
proc url_TagsDelete_568586(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsDelete_568585(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## You must remove all values from a resource tag before you can delete it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_568587 = path.getOrDefault("tagName")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "tagName", valid_568587
  var valid_568588 = path.getOrDefault("subscriptionId")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "subscriptionId", valid_568588
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568589 = query.getOrDefault("api-version")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "api-version", valid_568589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568590: Call_TagsDelete_568584; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You must remove all values from a resource tag before you can delete it.
  ## 
  let valid = call_568590.validator(path, query, header, formData, body)
  let scheme = call_568590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568590.url(scheme.get, call_568590.host, call_568590.base,
                         call_568590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568590, url, valid)

proc call*(call_568591: Call_TagsDelete_568584; apiVersion: string; tagName: string;
          subscriptionId: string): Recallable =
  ## tagsDelete
  ## You must remove all values from a resource tag before you can delete it.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568592 = newJObject()
  var query_568593 = newJObject()
  add(query_568593, "api-version", newJString(apiVersion))
  add(path_568592, "tagName", newJString(tagName))
  add(path_568592, "subscriptionId", newJString(subscriptionId))
  result = call_568591.call(path_568592, query_568593, nil, nil, nil)

var tagsDelete* = Call_TagsDelete_568584(name: "tagsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}",
                                      validator: validate_TagsDelete_568585,
                                      base: "", url: url_TagsDelete_568586,
                                      schemes: {Scheme.Https})
type
  Call_TagsCreateOrUpdateValue_568594 = ref object of OpenApiRestCall_567666
proc url_TagsCreateOrUpdateValue_568596(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  assert "tagValue" in path, "`tagValue` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName"),
               (kind: ConstantSegment, value: "/tagValues/"),
               (kind: VariableSegment, value: "tagValue")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsCreateOrUpdateValue_568595(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a tag value. The name of the tag must already exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   tagValue: JString (required)
  ##           : The value of the tag to create.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_568597 = path.getOrDefault("tagName")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "tagName", valid_568597
  var valid_568598 = path.getOrDefault("subscriptionId")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "subscriptionId", valid_568598
  var valid_568599 = path.getOrDefault("tagValue")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "tagValue", valid_568599
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568600 = query.getOrDefault("api-version")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "api-version", valid_568600
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568601: Call_TagsCreateOrUpdateValue_568594; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a tag value. The name of the tag must already exist.
  ## 
  let valid = call_568601.validator(path, query, header, formData, body)
  let scheme = call_568601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568601.url(scheme.get, call_568601.host, call_568601.base,
                         call_568601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568601, url, valid)

proc call*(call_568602: Call_TagsCreateOrUpdateValue_568594; apiVersion: string;
          tagName: string; subscriptionId: string; tagValue: string): Recallable =
  ## tagsCreateOrUpdateValue
  ## Creates a tag value. The name of the tag must already exist.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   tagValue: string (required)
  ##           : The value of the tag to create.
  var path_568603 = newJObject()
  var query_568604 = newJObject()
  add(query_568604, "api-version", newJString(apiVersion))
  add(path_568603, "tagName", newJString(tagName))
  add(path_568603, "subscriptionId", newJString(subscriptionId))
  add(path_568603, "tagValue", newJString(tagValue))
  result = call_568602.call(path_568603, query_568604, nil, nil, nil)

var tagsCreateOrUpdateValue* = Call_TagsCreateOrUpdateValue_568594(
    name: "tagsCreateOrUpdateValue", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}/tagValues/{tagValue}",
    validator: validate_TagsCreateOrUpdateValue_568595, base: "",
    url: url_TagsCreateOrUpdateValue_568596, schemes: {Scheme.Https})
type
  Call_TagsDeleteValue_568605 = ref object of OpenApiRestCall_567666
proc url_TagsDeleteValue_568607(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  assert "tagValue" in path, "`tagValue` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName"),
               (kind: ConstantSegment, value: "/tagValues/"),
               (kind: VariableSegment, value: "tagValue")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsDeleteValue_568606(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a tag value.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   tagValue: JString (required)
  ##           : The value of the tag to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_568608 = path.getOrDefault("tagName")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "tagName", valid_568608
  var valid_568609 = path.getOrDefault("subscriptionId")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "subscriptionId", valid_568609
  var valid_568610 = path.getOrDefault("tagValue")
  valid_568610 = validateParameter(valid_568610, JString, required = true,
                                 default = nil)
  if valid_568610 != nil:
    section.add "tagValue", valid_568610
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568611 = query.getOrDefault("api-version")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = nil)
  if valid_568611 != nil:
    section.add "api-version", valid_568611
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568612: Call_TagsDeleteValue_568605; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a tag value.
  ## 
  let valid = call_568612.validator(path, query, header, formData, body)
  let scheme = call_568612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568612.url(scheme.get, call_568612.host, call_568612.base,
                         call_568612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568612, url, valid)

proc call*(call_568613: Call_TagsDeleteValue_568605; apiVersion: string;
          tagName: string; subscriptionId: string; tagValue: string): Recallable =
  ## tagsDeleteValue
  ## Deletes a tag value.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   tagValue: string (required)
  ##           : The value of the tag to delete.
  var path_568614 = newJObject()
  var query_568615 = newJObject()
  add(query_568615, "api-version", newJString(apiVersion))
  add(path_568614, "tagName", newJString(tagName))
  add(path_568614, "subscriptionId", newJString(subscriptionId))
  add(path_568614, "tagValue", newJString(tagValue))
  result = call_568613.call(path_568614, query_568615, nil, nil, nil)

var tagsDeleteValue* = Call_TagsDeleteValue_568605(name: "tagsDeleteValue",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}/tagValues/{tagValue}",
    validator: validate_TagsDeleteValue_568606, base: "", url: url_TagsDeleteValue_568607,
    schemes: {Scheme.Https})
type
  Call_ResourcesCreateOrUpdateById_568625 = ref object of OpenApiRestCall_567666
proc url_ResourcesCreateOrUpdateById_568627(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCreateOrUpdateById_568626(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a resource by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568628 = path.getOrDefault("resourceId")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "resourceId", valid_568628
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568629 = query.getOrDefault("api-version")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "api-version", valid_568629
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create or update resource parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568631: Call_ResourcesCreateOrUpdateById_568625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource by ID.
  ## 
  let valid = call_568631.validator(path, query, header, formData, body)
  let scheme = call_568631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568631.url(scheme.get, call_568631.host, call_568631.base,
                         call_568631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568631, url, valid)

proc call*(call_568632: Call_ResourcesCreateOrUpdateById_568625;
          apiVersion: string; resourceId: string; parameters: JsonNode): Recallable =
  ## resourcesCreateOrUpdateById
  ## Create a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  ##   parameters: JObject (required)
  ##             : Create or update resource parameters.
  var path_568633 = newJObject()
  var query_568634 = newJObject()
  var body_568635 = newJObject()
  add(query_568634, "api-version", newJString(apiVersion))
  add(path_568633, "resourceId", newJString(resourceId))
  if parameters != nil:
    body_568635 = parameters
  result = call_568632.call(path_568633, query_568634, nil, nil, body_568635)

var resourcesCreateOrUpdateById* = Call_ResourcesCreateOrUpdateById_568625(
    name: "resourcesCreateOrUpdateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesCreateOrUpdateById_568626, base: "",
    url: url_ResourcesCreateOrUpdateById_568627, schemes: {Scheme.Https})
type
  Call_ResourcesCheckExistenceById_568645 = ref object of OpenApiRestCall_567666
proc url_ResourcesCheckExistenceById_568647(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCheckExistenceById_568646(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks by ID whether a resource exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568648 = path.getOrDefault("resourceId")
  valid_568648 = validateParameter(valid_568648, JString, required = true,
                                 default = nil)
  if valid_568648 != nil:
    section.add "resourceId", valid_568648
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568649 = query.getOrDefault("api-version")
  valid_568649 = validateParameter(valid_568649, JString, required = true,
                                 default = nil)
  if valid_568649 != nil:
    section.add "api-version", valid_568649
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568650: Call_ResourcesCheckExistenceById_568645; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks by ID whether a resource exists.
  ## 
  let valid = call_568650.validator(path, query, header, formData, body)
  let scheme = call_568650.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568650.url(scheme.get, call_568650.host, call_568650.base,
                         call_568650.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568650, url, valid)

proc call*(call_568651: Call_ResourcesCheckExistenceById_568645;
          apiVersion: string; resourceId: string): Recallable =
  ## resourcesCheckExistenceById
  ## Checks by ID whether a resource exists.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  var path_568652 = newJObject()
  var query_568653 = newJObject()
  add(query_568653, "api-version", newJString(apiVersion))
  add(path_568652, "resourceId", newJString(resourceId))
  result = call_568651.call(path_568652, query_568653, nil, nil, nil)

var resourcesCheckExistenceById* = Call_ResourcesCheckExistenceById_568645(
    name: "resourcesCheckExistenceById", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesCheckExistenceById_568646, base: "",
    url: url_ResourcesCheckExistenceById_568647, schemes: {Scheme.Https})
type
  Call_ResourcesGetById_568616 = ref object of OpenApiRestCall_567666
proc url_ResourcesGetById_568618(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesGetById_568617(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a resource by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568619 = path.getOrDefault("resourceId")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "resourceId", valid_568619
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568620 = query.getOrDefault("api-version")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = nil)
  if valid_568620 != nil:
    section.add "api-version", valid_568620
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568621: Call_ResourcesGetById_568616; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource by ID.
  ## 
  let valid = call_568621.validator(path, query, header, formData, body)
  let scheme = call_568621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568621.url(scheme.get, call_568621.host, call_568621.base,
                         call_568621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568621, url, valid)

proc call*(call_568622: Call_ResourcesGetById_568616; apiVersion: string;
          resourceId: string): Recallable =
  ## resourcesGetById
  ## Gets a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  var path_568623 = newJObject()
  var query_568624 = newJObject()
  add(query_568624, "api-version", newJString(apiVersion))
  add(path_568623, "resourceId", newJString(resourceId))
  result = call_568622.call(path_568623, query_568624, nil, nil, nil)

var resourcesGetById* = Call_ResourcesGetById_568616(name: "resourcesGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesGetById_568617, base: "",
    url: url_ResourcesGetById_568618, schemes: {Scheme.Https})
type
  Call_ResourcesUpdateById_568654 = ref object of OpenApiRestCall_567666
proc url_ResourcesUpdateById_568656(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesUpdateById_568655(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a resource by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568657 = path.getOrDefault("resourceId")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "resourceId", valid_568657
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568658 = query.getOrDefault("api-version")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "api-version", valid_568658
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update resource parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568660: Call_ResourcesUpdateById_568654; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource by ID.
  ## 
  let valid = call_568660.validator(path, query, header, formData, body)
  let scheme = call_568660.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568660.url(scheme.get, call_568660.host, call_568660.base,
                         call_568660.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568660, url, valid)

proc call*(call_568661: Call_ResourcesUpdateById_568654; apiVersion: string;
          resourceId: string; parameters: JsonNode): Recallable =
  ## resourcesUpdateById
  ## Updates a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  ##   parameters: JObject (required)
  ##             : Update resource parameters.
  var path_568662 = newJObject()
  var query_568663 = newJObject()
  var body_568664 = newJObject()
  add(query_568663, "api-version", newJString(apiVersion))
  add(path_568662, "resourceId", newJString(resourceId))
  if parameters != nil:
    body_568664 = parameters
  result = call_568661.call(path_568662, query_568663, nil, nil, body_568664)

var resourcesUpdateById* = Call_ResourcesUpdateById_568654(
    name: "resourcesUpdateById", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesUpdateById_568655, base: "",
    url: url_ResourcesUpdateById_568656, schemes: {Scheme.Https})
type
  Call_ResourcesDeleteById_568636 = ref object of OpenApiRestCall_567666
proc url_ResourcesDeleteById_568638(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesDeleteById_568637(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a resource by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568639 = path.getOrDefault("resourceId")
  valid_568639 = validateParameter(valid_568639, JString, required = true,
                                 default = nil)
  if valid_568639 != nil:
    section.add "resourceId", valid_568639
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568640 = query.getOrDefault("api-version")
  valid_568640 = validateParameter(valid_568640, JString, required = true,
                                 default = nil)
  if valid_568640 != nil:
    section.add "api-version", valid_568640
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568641: Call_ResourcesDeleteById_568636; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a resource by ID.
  ## 
  let valid = call_568641.validator(path, query, header, formData, body)
  let scheme = call_568641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568641.url(scheme.get, call_568641.host, call_568641.base,
                         call_568641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568641, url, valid)

proc call*(call_568642: Call_ResourcesDeleteById_568636; apiVersion: string;
          resourceId: string): Recallable =
  ## resourcesDeleteById
  ## Deletes a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  var path_568643 = newJObject()
  var query_568644 = newJObject()
  add(query_568644, "api-version", newJString(apiVersion))
  add(path_568643, "resourceId", newJString(resourceId))
  result = call_568642.call(path_568643, query_568644, nil, nil, nil)

var resourcesDeleteById* = Call_ResourcesDeleteById_568636(
    name: "resourcesDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesDeleteById_568637, base: "",
    url: url_ResourcesDeleteById_568638, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
