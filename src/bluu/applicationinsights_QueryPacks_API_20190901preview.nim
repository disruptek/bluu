
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Log Analytics Query Packs
## version: 2019-09-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Log Analytics API reference for Query Packs management.
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

  OpenApiRestCall_573658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573658): Option[Scheme] {.used.} =
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
  macServiceName = "applicationinsights-QueryPacks_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_QueryPacksList_573880 = ref object of OpenApiRestCall_573658
proc url_QueryPacksList_573882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/queryPacks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryPacksList_573881(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a list of all Log Analytics QueryPacks within a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574042 = path.getOrDefault("subscriptionId")
  valid_574042 = validateParameter(valid_574042, JString, required = true,
                                 default = nil)
  if valid_574042 != nil:
    section.add "subscriptionId", valid_574042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574043 = query.getOrDefault("api-version")
  valid_574043 = validateParameter(valid_574043, JString, required = true,
                                 default = nil)
  if valid_574043 != nil:
    section.add "api-version", valid_574043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574070: Call_QueryPacksList_573880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all Log Analytics QueryPacks within a subscription.
  ## 
  let valid = call_574070.validator(path, query, header, formData, body)
  let scheme = call_574070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574070.url(scheme.get, call_574070.host, call_574070.base,
                         call_574070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574070, url, valid)

proc call*(call_574141: Call_QueryPacksList_573880; apiVersion: string;
          subscriptionId: string): Recallable =
  ## queryPacksList
  ## Gets a list of all Log Analytics QueryPacks within a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574142 = newJObject()
  var query_574144 = newJObject()
  add(query_574144, "api-version", newJString(apiVersion))
  add(path_574142, "subscriptionId", newJString(subscriptionId))
  result = call_574141.call(path_574142, query_574144, nil, nil, nil)

var queryPacksList* = Call_QueryPacksList_573880(name: "queryPacksList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/microsoft.insights/queryPacks",
    validator: validate_QueryPacksList_573881, base: "", url: url_QueryPacksList_573882,
    schemes: {Scheme.Https})
type
  Call_QueryPacksListByResourceGroup_574183 = ref object of OpenApiRestCall_573658
proc url_QueryPacksListByResourceGroup_574185(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/queryPacks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryPacksListByResourceGroup_574184(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of Log Analytics QueryPacks within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574186 = path.getOrDefault("resourceGroupName")
  valid_574186 = validateParameter(valid_574186, JString, required = true,
                                 default = nil)
  if valid_574186 != nil:
    section.add "resourceGroupName", valid_574186
  var valid_574187 = path.getOrDefault("subscriptionId")
  valid_574187 = validateParameter(valid_574187, JString, required = true,
                                 default = nil)
  if valid_574187 != nil:
    section.add "subscriptionId", valid_574187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574188 = query.getOrDefault("api-version")
  valid_574188 = validateParameter(valid_574188, JString, required = true,
                                 default = nil)
  if valid_574188 != nil:
    section.add "api-version", valid_574188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574189: Call_QueryPacksListByResourceGroup_574183; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of Log Analytics QueryPacks within a resource group.
  ## 
  let valid = call_574189.validator(path, query, header, formData, body)
  let scheme = call_574189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574189.url(scheme.get, call_574189.host, call_574189.base,
                         call_574189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574189, url, valid)

proc call*(call_574190: Call_QueryPacksListByResourceGroup_574183;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## queryPacksListByResourceGroup
  ## Gets a list of Log Analytics QueryPacks within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574191 = newJObject()
  var query_574192 = newJObject()
  add(path_574191, "resourceGroupName", newJString(resourceGroupName))
  add(query_574192, "api-version", newJString(apiVersion))
  add(path_574191, "subscriptionId", newJString(subscriptionId))
  result = call_574190.call(path_574191, query_574192, nil, nil, nil)

var queryPacksListByResourceGroup* = Call_QueryPacksListByResourceGroup_574183(
    name: "queryPacksListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/queryPacks",
    validator: validate_QueryPacksListByResourceGroup_574184, base: "",
    url: url_QueryPacksListByResourceGroup_574185, schemes: {Scheme.Https})
type
  Call_QueryPacksCreateOrUpdate_574213 = ref object of OpenApiRestCall_573658
proc url_QueryPacksCreateOrUpdate_574215(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "queryPackName" in path, "`queryPackName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/queryPacks/"),
               (kind: VariableSegment, value: "queryPackName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryPacksCreateOrUpdate_574214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates (or updates) a Log Analytics QueryPack. Note: You cannot specify a different value for InstrumentationKey nor AppId in the Put operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   queryPackName: JString (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574233 = path.getOrDefault("resourceGroupName")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "resourceGroupName", valid_574233
  var valid_574234 = path.getOrDefault("queryPackName")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "queryPackName", valid_574234
  var valid_574235 = path.getOrDefault("subscriptionId")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "subscriptionId", valid_574235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574236 = query.getOrDefault("api-version")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "api-version", valid_574236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   LogAnalyticsQueryPackPayload: JObject (required)
  ##                               : Properties that need to be specified to create or update a Log Analytics QueryPack.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574238: Call_QueryPacksCreateOrUpdate_574213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates (or updates) a Log Analytics QueryPack. Note: You cannot specify a different value for InstrumentationKey nor AppId in the Put operation.
  ## 
  let valid = call_574238.validator(path, query, header, formData, body)
  let scheme = call_574238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574238.url(scheme.get, call_574238.host, call_574238.base,
                         call_574238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574238, url, valid)

proc call*(call_574239: Call_QueryPacksCreateOrUpdate_574213;
          resourceGroupName: string; apiVersion: string; queryPackName: string;
          subscriptionId: string; LogAnalyticsQueryPackPayload: JsonNode): Recallable =
  ## queryPacksCreateOrUpdate
  ## Creates (or updates) a Log Analytics QueryPack. Note: You cannot specify a different value for InstrumentationKey nor AppId in the Put operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   queryPackName: string (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   LogAnalyticsQueryPackPayload: JObject (required)
  ##                               : Properties that need to be specified to create or update a Log Analytics QueryPack.
  var path_574240 = newJObject()
  var query_574241 = newJObject()
  var body_574242 = newJObject()
  add(path_574240, "resourceGroupName", newJString(resourceGroupName))
  add(query_574241, "api-version", newJString(apiVersion))
  add(path_574240, "queryPackName", newJString(queryPackName))
  add(path_574240, "subscriptionId", newJString(subscriptionId))
  if LogAnalyticsQueryPackPayload != nil:
    body_574242 = LogAnalyticsQueryPackPayload
  result = call_574239.call(path_574240, query_574241, nil, nil, body_574242)

var queryPacksCreateOrUpdate* = Call_QueryPacksCreateOrUpdate_574213(
    name: "queryPacksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/queryPacks/{queryPackName}",
    validator: validate_QueryPacksCreateOrUpdate_574214, base: "",
    url: url_QueryPacksCreateOrUpdate_574215, schemes: {Scheme.Https})
type
  Call_QueryPacksGet_574193 = ref object of OpenApiRestCall_573658
proc url_QueryPacksGet_574195(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "queryPackName" in path, "`queryPackName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/queryPacks/"),
               (kind: VariableSegment, value: "queryPackName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryPacksGet_574194(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a Log Analytics QueryPack.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   queryPackName: JString (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574205 = path.getOrDefault("resourceGroupName")
  valid_574205 = validateParameter(valid_574205, JString, required = true,
                                 default = nil)
  if valid_574205 != nil:
    section.add "resourceGroupName", valid_574205
  var valid_574206 = path.getOrDefault("queryPackName")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = nil)
  if valid_574206 != nil:
    section.add "queryPackName", valid_574206
  var valid_574207 = path.getOrDefault("subscriptionId")
  valid_574207 = validateParameter(valid_574207, JString, required = true,
                                 default = nil)
  if valid_574207 != nil:
    section.add "subscriptionId", valid_574207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574208 = query.getOrDefault("api-version")
  valid_574208 = validateParameter(valid_574208, JString, required = true,
                                 default = nil)
  if valid_574208 != nil:
    section.add "api-version", valid_574208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574209: Call_QueryPacksGet_574193; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a Log Analytics QueryPack.
  ## 
  let valid = call_574209.validator(path, query, header, formData, body)
  let scheme = call_574209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574209.url(scheme.get, call_574209.host, call_574209.base,
                         call_574209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574209, url, valid)

proc call*(call_574210: Call_QueryPacksGet_574193; resourceGroupName: string;
          apiVersion: string; queryPackName: string; subscriptionId: string): Recallable =
  ## queryPacksGet
  ## Returns a Log Analytics QueryPack.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   queryPackName: string (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574211 = newJObject()
  var query_574212 = newJObject()
  add(path_574211, "resourceGroupName", newJString(resourceGroupName))
  add(query_574212, "api-version", newJString(apiVersion))
  add(path_574211, "queryPackName", newJString(queryPackName))
  add(path_574211, "subscriptionId", newJString(subscriptionId))
  result = call_574210.call(path_574211, query_574212, nil, nil, nil)

var queryPacksGet* = Call_QueryPacksGet_574193(name: "queryPacksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/queryPacks/{queryPackName}",
    validator: validate_QueryPacksGet_574194, base: "", url: url_QueryPacksGet_574195,
    schemes: {Scheme.Https})
type
  Call_QueryPacksUpdateTags_574254 = ref object of OpenApiRestCall_573658
proc url_QueryPacksUpdateTags_574256(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "queryPackName" in path, "`queryPackName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/queryPacks/"),
               (kind: VariableSegment, value: "queryPackName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryPacksUpdateTags_574255(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing QueryPack's tags. To update other fields use the CreateOrUpdate method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   queryPackName: JString (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574257 = path.getOrDefault("resourceGroupName")
  valid_574257 = validateParameter(valid_574257, JString, required = true,
                                 default = nil)
  if valid_574257 != nil:
    section.add "resourceGroupName", valid_574257
  var valid_574258 = path.getOrDefault("queryPackName")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "queryPackName", valid_574258
  var valid_574259 = path.getOrDefault("subscriptionId")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "subscriptionId", valid_574259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574260 = query.getOrDefault("api-version")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "api-version", valid_574260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   QueryPackTags: JObject (required)
  ##                : Updated tag information to set into the QueryPack instance.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574262: Call_QueryPacksUpdateTags_574254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing QueryPack's tags. To update other fields use the CreateOrUpdate method.
  ## 
  let valid = call_574262.validator(path, query, header, formData, body)
  let scheme = call_574262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574262.url(scheme.get, call_574262.host, call_574262.base,
                         call_574262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574262, url, valid)

proc call*(call_574263: Call_QueryPacksUpdateTags_574254;
          resourceGroupName: string; apiVersion: string; QueryPackTags: JsonNode;
          queryPackName: string; subscriptionId: string): Recallable =
  ## queryPacksUpdateTags
  ## Updates an existing QueryPack's tags. To update other fields use the CreateOrUpdate method.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   QueryPackTags: JObject (required)
  ##                : Updated tag information to set into the QueryPack instance.
  ##   queryPackName: string (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574264 = newJObject()
  var query_574265 = newJObject()
  var body_574266 = newJObject()
  add(path_574264, "resourceGroupName", newJString(resourceGroupName))
  add(query_574265, "api-version", newJString(apiVersion))
  if QueryPackTags != nil:
    body_574266 = QueryPackTags
  add(path_574264, "queryPackName", newJString(queryPackName))
  add(path_574264, "subscriptionId", newJString(subscriptionId))
  result = call_574263.call(path_574264, query_574265, nil, nil, body_574266)

var queryPacksUpdateTags* = Call_QueryPacksUpdateTags_574254(
    name: "queryPacksUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/queryPacks/{queryPackName}",
    validator: validate_QueryPacksUpdateTags_574255, base: "",
    url: url_QueryPacksUpdateTags_574256, schemes: {Scheme.Https})
type
  Call_QueryPacksDelete_574243 = ref object of OpenApiRestCall_573658
proc url_QueryPacksDelete_574245(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "queryPackName" in path, "`queryPackName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/queryPacks/"),
               (kind: VariableSegment, value: "queryPackName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryPacksDelete_574244(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a Log Analytics QueryPack.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   queryPackName: JString (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574246 = path.getOrDefault("resourceGroupName")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "resourceGroupName", valid_574246
  var valid_574247 = path.getOrDefault("queryPackName")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "queryPackName", valid_574247
  var valid_574248 = path.getOrDefault("subscriptionId")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "subscriptionId", valid_574248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574249 = query.getOrDefault("api-version")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "api-version", valid_574249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574250: Call_QueryPacksDelete_574243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Log Analytics QueryPack.
  ## 
  let valid = call_574250.validator(path, query, header, formData, body)
  let scheme = call_574250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574250.url(scheme.get, call_574250.host, call_574250.base,
                         call_574250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574250, url, valid)

proc call*(call_574251: Call_QueryPacksDelete_574243; resourceGroupName: string;
          apiVersion: string; queryPackName: string; subscriptionId: string): Recallable =
  ## queryPacksDelete
  ## Deletes a Log Analytics QueryPack.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   queryPackName: string (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574252 = newJObject()
  var query_574253 = newJObject()
  add(path_574252, "resourceGroupName", newJString(resourceGroupName))
  add(query_574253, "api-version", newJString(apiVersion))
  add(path_574252, "queryPackName", newJString(queryPackName))
  add(path_574252, "subscriptionId", newJString(subscriptionId))
  result = call_574251.call(path_574252, query_574253, nil, nil, nil)

var queryPacksDelete* = Call_QueryPacksDelete_574243(name: "queryPacksDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/queryPacks/{queryPackName}",
    validator: validate_QueryPacksDelete_574244, base: "",
    url: url_QueryPacksDelete_574245, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
