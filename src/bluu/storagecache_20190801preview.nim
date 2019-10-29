
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Storage Cache Mgmt Client
## version: 2019-08-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## A Storage Cache provides scalable caching service for NAS clients, serving data from either NFSv3 or Blob at-rest storage (referred to as "Storage Targets"). These operations allow you to manage caches.
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "storagecache"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563777 = ref object of OpenApiRestCall_563555
proc url_OperationsList_563779(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563778(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available RP operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563940 = query.getOrDefault("api-version")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "api-version", valid_563940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563963: Call_OperationsList_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available RP operations.
  ## 
  let valid = call_563963.validator(path, query, header, formData, body)
  let scheme = call_563963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563963.url(scheme.get, call_563963.host, call_563963.base,
                         call_563963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563963, url, valid)

proc call*(call_564034: Call_OperationsList_563777; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available RP operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564035 = newJObject()
  add(query_564035, "api-version", newJString(apiVersion))
  result = call_564034.call(nil, query_564035, nil, nil, nil)

var operationsList* = Call_OperationsList_563777(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.StorageCache/operations",
    validator: validate_OperationsList_563778, base: "/", url: url_OperationsList_563779,
    schemes: {Scheme.Https})
type
  Call_CachesList_564075 = ref object of OpenApiRestCall_563555
proc url_CachesList_564077(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorageCache/caches")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CachesList_564076(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all Caches the user has access to under a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564092 = path.getOrDefault("subscriptionId")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = nil)
  if valid_564092 != nil:
    section.add "subscriptionId", valid_564092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564093 = query.getOrDefault("api-version")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "api-version", valid_564093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564094: Call_CachesList_564075; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all Caches the user has access to under a subscription.
  ## 
  let valid = call_564094.validator(path, query, header, formData, body)
  let scheme = call_564094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564094.url(scheme.get, call_564094.host, call_564094.base,
                         call_564094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564094, url, valid)

proc call*(call_564095: Call_CachesList_564075; apiVersion: string;
          subscriptionId: string): Recallable =
  ## cachesList
  ## Returns all Caches the user has access to under a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564096 = newJObject()
  var query_564097 = newJObject()
  add(query_564097, "api-version", newJString(apiVersion))
  add(path_564096, "subscriptionId", newJString(subscriptionId))
  result = call_564095.call(path_564096, query_564097, nil, nil, nil)

var cachesList* = Call_CachesList_564075(name: "cachesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.StorageCache/caches",
                                      validator: validate_CachesList_564076,
                                      base: "/", url: url_CachesList_564077,
                                      schemes: {Scheme.Https})
type
  Call_SkusList_564098 = ref object of OpenApiRestCall_563555
proc url_SkusList_564100(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorageCache/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SkusList_564099(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of StorageCache.Cache SKUs available to this subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564101 = path.getOrDefault("subscriptionId")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "subscriptionId", valid_564101
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564102 = query.getOrDefault("api-version")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "api-version", valid_564102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564103: Call_SkusList_564098; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of StorageCache.Cache SKUs available to this subscription.
  ## 
  let valid = call_564103.validator(path, query, header, formData, body)
  let scheme = call_564103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564103.url(scheme.get, call_564103.host, call_564103.base,
                         call_564103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564103, url, valid)

proc call*(call_564104: Call_SkusList_564098; apiVersion: string;
          subscriptionId: string): Recallable =
  ## skusList
  ## Get the list of StorageCache.Cache SKUs available to this subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564105 = newJObject()
  var query_564106 = newJObject()
  add(query_564106, "api-version", newJString(apiVersion))
  add(path_564105, "subscriptionId", newJString(subscriptionId))
  result = call_564104.call(path_564105, query_564106, nil, nil, nil)

var skusList* = Call_SkusList_564098(name: "skusList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.StorageCache/skus",
                                  validator: validate_SkusList_564099, base: "/",
                                  url: url_SkusList_564100,
                                  schemes: {Scheme.Https})
type
  Call_UsageModelsList_564107 = ref object of OpenApiRestCall_563555
proc url_UsageModelsList_564109(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageCache/usageModels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageModelsList_564108(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get the list of cache Usage Models available to this subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564110 = path.getOrDefault("subscriptionId")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "subscriptionId", valid_564110
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564111 = query.getOrDefault("api-version")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "api-version", valid_564111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564112: Call_UsageModelsList_564107; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of cache Usage Models available to this subscription.
  ## 
  let valid = call_564112.validator(path, query, header, formData, body)
  let scheme = call_564112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564112.url(scheme.get, call_564112.host, call_564112.base,
                         call_564112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564112, url, valid)

proc call*(call_564113: Call_UsageModelsList_564107; apiVersion: string;
          subscriptionId: string): Recallable =
  ## usageModelsList
  ## Get the list of cache Usage Models available to this subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564114 = newJObject()
  var query_564115 = newJObject()
  add(query_564115, "api-version", newJString(apiVersion))
  add(path_564114, "subscriptionId", newJString(subscriptionId))
  result = call_564113.call(path_564114, query_564115, nil, nil, nil)

var usageModelsList* = Call_UsageModelsList_564107(name: "usageModelsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.StorageCache/usageModels",
    validator: validate_UsageModelsList_564108, base: "/", url: url_UsageModelsList_564109,
    schemes: {Scheme.Https})
type
  Call_CachesListByResourceGroup_564116 = ref object of OpenApiRestCall_563555
proc url_CachesListByResourceGroup_564118(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorageCache/caches")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CachesListByResourceGroup_564117(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all Caches the user has access to under a resource group and subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Target resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564119 = path.getOrDefault("subscriptionId")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "subscriptionId", valid_564119
  var valid_564120 = path.getOrDefault("resourceGroupName")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "resourceGroupName", valid_564120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564121 = query.getOrDefault("api-version")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "api-version", valid_564121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564122: Call_CachesListByResourceGroup_564116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all Caches the user has access to under a resource group and subscription.
  ## 
  let valid = call_564122.validator(path, query, header, formData, body)
  let scheme = call_564122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564122.url(scheme.get, call_564122.host, call_564122.base,
                         call_564122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564122, url, valid)

proc call*(call_564123: Call_CachesListByResourceGroup_564116; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## cachesListByResourceGroup
  ## Returns all Caches the user has access to under a resource group and subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Target resource group.
  var path_564124 = newJObject()
  var query_564125 = newJObject()
  add(query_564125, "api-version", newJString(apiVersion))
  add(path_564124, "subscriptionId", newJString(subscriptionId))
  add(path_564124, "resourceGroupName", newJString(resourceGroupName))
  result = call_564123.call(path_564124, query_564125, nil, nil, nil)

var cachesListByResourceGroup* = Call_CachesListByResourceGroup_564116(
    name: "cachesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StorageCache/caches",
    validator: validate_CachesListByResourceGroup_564117, base: "/",
    url: url_CachesListByResourceGroup_564118, schemes: {Scheme.Https})
type
  Call_CachesCreate_564137 = ref object of OpenApiRestCall_563555
proc url_CachesCreate_564139(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "cacheName" in path, "`cacheName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorageCache/caches/"),
               (kind: VariableSegment, value: "cacheName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CachesCreate_564138(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Create/update a Cache instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: JString (required)
  ##            : Name of cache.
  ##   resourceGroupName: JString (required)
  ##                    : Target resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564140 = path.getOrDefault("subscriptionId")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "subscriptionId", valid_564140
  var valid_564141 = path.getOrDefault("cacheName")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "cacheName", valid_564141
  var valid_564142 = path.getOrDefault("resourceGroupName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "resourceGroupName", valid_564142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "api-version", valid_564143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   cache: JObject
  ##        : Object containing the user selectable properties of the new cache.  If read-only properties are included, they must match the existing values of those properties.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564145: Call_CachesCreate_564137; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create/update a Cache instance.
  ## 
  let valid = call_564145.validator(path, query, header, formData, body)
  let scheme = call_564145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564145.url(scheme.get, call_564145.host, call_564145.base,
                         call_564145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564145, url, valid)

proc call*(call_564146: Call_CachesCreate_564137; apiVersion: string;
          subscriptionId: string; cacheName: string; resourceGroupName: string;
          cache: JsonNode = nil): Recallable =
  ## cachesCreate
  ## Create/update a Cache instance.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   cache: JObject
  ##        : Object containing the user selectable properties of the new cache.  If read-only properties are included, they must match the existing values of those properties.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: string (required)
  ##            : Name of cache.
  ##   resourceGroupName: string (required)
  ##                    : Target resource group.
  var path_564147 = newJObject()
  var query_564148 = newJObject()
  var body_564149 = newJObject()
  add(query_564148, "api-version", newJString(apiVersion))
  if cache != nil:
    body_564149 = cache
  add(path_564147, "subscriptionId", newJString(subscriptionId))
  add(path_564147, "cacheName", newJString(cacheName))
  add(path_564147, "resourceGroupName", newJString(resourceGroupName))
  result = call_564146.call(path_564147, query_564148, nil, nil, body_564149)

var cachesCreate* = Call_CachesCreate_564137(name: "cachesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StorageCache/caches/{cacheName}",
    validator: validate_CachesCreate_564138, base: "/", url: url_CachesCreate_564139,
    schemes: {Scheme.Https})
type
  Call_CachesGet_564126 = ref object of OpenApiRestCall_563555
proc url_CachesGet_564128(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "cacheName" in path, "`cacheName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorageCache/caches/"),
               (kind: VariableSegment, value: "cacheName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CachesGet_564127(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a Cache.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: JString (required)
  ##            : Name of cache.
  ##   resourceGroupName: JString (required)
  ##                    : Target resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564129 = path.getOrDefault("subscriptionId")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "subscriptionId", valid_564129
  var valid_564130 = path.getOrDefault("cacheName")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "cacheName", valid_564130
  var valid_564131 = path.getOrDefault("resourceGroupName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "resourceGroupName", valid_564131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564132 = query.getOrDefault("api-version")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "api-version", valid_564132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564133: Call_CachesGet_564126; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a Cache.
  ## 
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_CachesGet_564126; apiVersion: string;
          subscriptionId: string; cacheName: string; resourceGroupName: string): Recallable =
  ## cachesGet
  ## Returns a Cache.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: string (required)
  ##            : Name of cache.
  ##   resourceGroupName: string (required)
  ##                    : Target resource group.
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  add(query_564136, "api-version", newJString(apiVersion))
  add(path_564135, "subscriptionId", newJString(subscriptionId))
  add(path_564135, "cacheName", newJString(cacheName))
  add(path_564135, "resourceGroupName", newJString(resourceGroupName))
  result = call_564134.call(path_564135, query_564136, nil, nil, nil)

var cachesGet* = Call_CachesGet_564126(name: "cachesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StorageCache/caches/{cacheName}",
                                    validator: validate_CachesGet_564127,
                                    base: "/", url: url_CachesGet_564128,
                                    schemes: {Scheme.Https})
type
  Call_CachesUpdate_564161 = ref object of OpenApiRestCall_563555
proc url_CachesUpdate_564163(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "cacheName" in path, "`cacheName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorageCache/caches/"),
               (kind: VariableSegment, value: "cacheName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CachesUpdate_564162(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a Cache instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: JString (required)
  ##            : Name of cache.
  ##   resourceGroupName: JString (required)
  ##                    : Target resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564164 = path.getOrDefault("subscriptionId")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "subscriptionId", valid_564164
  var valid_564165 = path.getOrDefault("cacheName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "cacheName", valid_564165
  var valid_564166 = path.getOrDefault("resourceGroupName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "resourceGroupName", valid_564166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564167 = query.getOrDefault("api-version")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "api-version", valid_564167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   cache: JObject
  ##        : Object containing the user selectable properties of the new cache.  If read-only properties are included, they must match the existing values of those properties.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564169: Call_CachesUpdate_564161; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a Cache instance.
  ## 
  let valid = call_564169.validator(path, query, header, formData, body)
  let scheme = call_564169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564169.url(scheme.get, call_564169.host, call_564169.base,
                         call_564169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564169, url, valid)

proc call*(call_564170: Call_CachesUpdate_564161; apiVersion: string;
          subscriptionId: string; cacheName: string; resourceGroupName: string;
          cache: JsonNode = nil): Recallable =
  ## cachesUpdate
  ## Update a Cache instance.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   cache: JObject
  ##        : Object containing the user selectable properties of the new cache.  If read-only properties are included, they must match the existing values of those properties.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: string (required)
  ##            : Name of cache.
  ##   resourceGroupName: string (required)
  ##                    : Target resource group.
  var path_564171 = newJObject()
  var query_564172 = newJObject()
  var body_564173 = newJObject()
  add(query_564172, "api-version", newJString(apiVersion))
  if cache != nil:
    body_564173 = cache
  add(path_564171, "subscriptionId", newJString(subscriptionId))
  add(path_564171, "cacheName", newJString(cacheName))
  add(path_564171, "resourceGroupName", newJString(resourceGroupName))
  result = call_564170.call(path_564171, query_564172, nil, nil, body_564173)

var cachesUpdate* = Call_CachesUpdate_564161(name: "cachesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StorageCache/caches/{cacheName}",
    validator: validate_CachesUpdate_564162, base: "/", url: url_CachesUpdate_564163,
    schemes: {Scheme.Https})
type
  Call_CachesDelete_564150 = ref object of OpenApiRestCall_563555
proc url_CachesDelete_564152(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "cacheName" in path, "`cacheName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorageCache/caches/"),
               (kind: VariableSegment, value: "cacheName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CachesDelete_564151(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Schedules a Cache for deletion.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: JString (required)
  ##            : Name of cache.
  ##   resourceGroupName: JString (required)
  ##                    : Target resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564153 = path.getOrDefault("subscriptionId")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "subscriptionId", valid_564153
  var valid_564154 = path.getOrDefault("cacheName")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "cacheName", valid_564154
  var valid_564155 = path.getOrDefault("resourceGroupName")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "resourceGroupName", valid_564155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564156 = query.getOrDefault("api-version")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "api-version", valid_564156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564157: Call_CachesDelete_564150; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Schedules a Cache for deletion.
  ## 
  let valid = call_564157.validator(path, query, header, formData, body)
  let scheme = call_564157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564157.url(scheme.get, call_564157.host, call_564157.base,
                         call_564157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564157, url, valid)

proc call*(call_564158: Call_CachesDelete_564150; apiVersion: string;
          subscriptionId: string; cacheName: string; resourceGroupName: string): Recallable =
  ## cachesDelete
  ## Schedules a Cache for deletion.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: string (required)
  ##            : Name of cache.
  ##   resourceGroupName: string (required)
  ##                    : Target resource group.
  var path_564159 = newJObject()
  var query_564160 = newJObject()
  add(query_564160, "api-version", newJString(apiVersion))
  add(path_564159, "subscriptionId", newJString(subscriptionId))
  add(path_564159, "cacheName", newJString(cacheName))
  add(path_564159, "resourceGroupName", newJString(resourceGroupName))
  result = call_564158.call(path_564159, query_564160, nil, nil, nil)

var cachesDelete* = Call_CachesDelete_564150(name: "cachesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StorageCache/caches/{cacheName}",
    validator: validate_CachesDelete_564151, base: "/", url: url_CachesDelete_564152,
    schemes: {Scheme.Https})
type
  Call_CachesFlush_564174 = ref object of OpenApiRestCall_563555
proc url_CachesFlush_564176(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "cacheName" in path, "`cacheName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorageCache/caches/"),
               (kind: VariableSegment, value: "cacheName"),
               (kind: ConstantSegment, value: "/flush")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CachesFlush_564175(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Tells a cache to write all dirty data to the StorageTarget(s).  During the flush, clients will see errors returned until the flush is complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: JString (required)
  ##            : Name of cache.
  ##   resourceGroupName: JString (required)
  ##                    : Target resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564177 = path.getOrDefault("subscriptionId")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "subscriptionId", valid_564177
  var valid_564178 = path.getOrDefault("cacheName")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "cacheName", valid_564178
  var valid_564179 = path.getOrDefault("resourceGroupName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "resourceGroupName", valid_564179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564180 = query.getOrDefault("api-version")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "api-version", valid_564180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564181: Call_CachesFlush_564174; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Tells a cache to write all dirty data to the StorageTarget(s).  During the flush, clients will see errors returned until the flush is complete.
  ## 
  let valid = call_564181.validator(path, query, header, formData, body)
  let scheme = call_564181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564181.url(scheme.get, call_564181.host, call_564181.base,
                         call_564181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564181, url, valid)

proc call*(call_564182: Call_CachesFlush_564174; apiVersion: string;
          subscriptionId: string; cacheName: string; resourceGroupName: string): Recallable =
  ## cachesFlush
  ## Tells a cache to write all dirty data to the StorageTarget(s).  During the flush, clients will see errors returned until the flush is complete.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: string (required)
  ##            : Name of cache.
  ##   resourceGroupName: string (required)
  ##                    : Target resource group.
  var path_564183 = newJObject()
  var query_564184 = newJObject()
  add(query_564184, "api-version", newJString(apiVersion))
  add(path_564183, "subscriptionId", newJString(subscriptionId))
  add(path_564183, "cacheName", newJString(cacheName))
  add(path_564183, "resourceGroupName", newJString(resourceGroupName))
  result = call_564182.call(path_564183, query_564184, nil, nil, nil)

var cachesFlush* = Call_CachesFlush_564174(name: "cachesFlush",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StorageCache/caches/{cacheName}/flush",
                                        validator: validate_CachesFlush_564175,
                                        base: "/", url: url_CachesFlush_564176,
                                        schemes: {Scheme.Https})
type
  Call_CachesStart_564185 = ref object of OpenApiRestCall_563555
proc url_CachesStart_564187(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "cacheName" in path, "`cacheName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorageCache/caches/"),
               (kind: VariableSegment, value: "cacheName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CachesStart_564186(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Tells a Stopped state cache to transition to Active state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: JString (required)
  ##            : Name of cache.
  ##   resourceGroupName: JString (required)
  ##                    : Target resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564188 = path.getOrDefault("subscriptionId")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "subscriptionId", valid_564188
  var valid_564189 = path.getOrDefault("cacheName")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "cacheName", valid_564189
  var valid_564190 = path.getOrDefault("resourceGroupName")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "resourceGroupName", valid_564190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564191 = query.getOrDefault("api-version")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "api-version", valid_564191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564192: Call_CachesStart_564185; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Tells a Stopped state cache to transition to Active state.
  ## 
  let valid = call_564192.validator(path, query, header, formData, body)
  let scheme = call_564192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564192.url(scheme.get, call_564192.host, call_564192.base,
                         call_564192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564192, url, valid)

proc call*(call_564193: Call_CachesStart_564185; apiVersion: string;
          subscriptionId: string; cacheName: string; resourceGroupName: string): Recallable =
  ## cachesStart
  ## Tells a Stopped state cache to transition to Active state.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: string (required)
  ##            : Name of cache.
  ##   resourceGroupName: string (required)
  ##                    : Target resource group.
  var path_564194 = newJObject()
  var query_564195 = newJObject()
  add(query_564195, "api-version", newJString(apiVersion))
  add(path_564194, "subscriptionId", newJString(subscriptionId))
  add(path_564194, "cacheName", newJString(cacheName))
  add(path_564194, "resourceGroupName", newJString(resourceGroupName))
  result = call_564193.call(path_564194, query_564195, nil, nil, nil)

var cachesStart* = Call_CachesStart_564185(name: "cachesStart",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StorageCache/caches/{cacheName}/start",
                                        validator: validate_CachesStart_564186,
                                        base: "/", url: url_CachesStart_564187,
                                        schemes: {Scheme.Https})
type
  Call_CachesStop_564196 = ref object of OpenApiRestCall_563555
proc url_CachesStop_564198(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "cacheName" in path, "`cacheName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorageCache/caches/"),
               (kind: VariableSegment, value: "cacheName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CachesStop_564197(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Tells an Active cache to transition to Stopped state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: JString (required)
  ##            : Name of cache.
  ##   resourceGroupName: JString (required)
  ##                    : Target resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564199 = path.getOrDefault("subscriptionId")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "subscriptionId", valid_564199
  var valid_564200 = path.getOrDefault("cacheName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "cacheName", valid_564200
  var valid_564201 = path.getOrDefault("resourceGroupName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "resourceGroupName", valid_564201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564202 = query.getOrDefault("api-version")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "api-version", valid_564202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564203: Call_CachesStop_564196; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Tells an Active cache to transition to Stopped state.
  ## 
  let valid = call_564203.validator(path, query, header, formData, body)
  let scheme = call_564203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564203.url(scheme.get, call_564203.host, call_564203.base,
                         call_564203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564203, url, valid)

proc call*(call_564204: Call_CachesStop_564196; apiVersion: string;
          subscriptionId: string; cacheName: string; resourceGroupName: string): Recallable =
  ## cachesStop
  ## Tells an Active cache to transition to Stopped state.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: string (required)
  ##            : Name of cache.
  ##   resourceGroupName: string (required)
  ##                    : Target resource group.
  var path_564205 = newJObject()
  var query_564206 = newJObject()
  add(query_564206, "api-version", newJString(apiVersion))
  add(path_564205, "subscriptionId", newJString(subscriptionId))
  add(path_564205, "cacheName", newJString(cacheName))
  add(path_564205, "resourceGroupName", newJString(resourceGroupName))
  result = call_564204.call(path_564205, query_564206, nil, nil, nil)

var cachesStop* = Call_CachesStop_564196(name: "cachesStop",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StorageCache/caches/{cacheName}/stop",
                                      validator: validate_CachesStop_564197,
                                      base: "/", url: url_CachesStop_564198,
                                      schemes: {Scheme.Https})
type
  Call_StorageTargetsListByCache_564207 = ref object of OpenApiRestCall_563555
proc url_StorageTargetsListByCache_564209(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "cacheName" in path, "`cacheName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorageCache/caches/"),
               (kind: VariableSegment, value: "cacheName"),
               (kind: ConstantSegment, value: "/storageTargets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageTargetsListByCache_564208(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the StorageTargets for this cache in the subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: JString (required)
  ##            : Name of cache.
  ##   resourceGroupName: JString (required)
  ##                    : Target resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564210 = path.getOrDefault("subscriptionId")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "subscriptionId", valid_564210
  var valid_564211 = path.getOrDefault("cacheName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "cacheName", valid_564211
  var valid_564212 = path.getOrDefault("resourceGroupName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "resourceGroupName", valid_564212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564213 = query.getOrDefault("api-version")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "api-version", valid_564213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564214: Call_StorageTargetsListByCache_564207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the StorageTargets for this cache in the subscription and resource group.
  ## 
  let valid = call_564214.validator(path, query, header, formData, body)
  let scheme = call_564214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564214.url(scheme.get, call_564214.host, call_564214.base,
                         call_564214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564214, url, valid)

proc call*(call_564215: Call_StorageTargetsListByCache_564207; apiVersion: string;
          subscriptionId: string; cacheName: string; resourceGroupName: string): Recallable =
  ## storageTargetsListByCache
  ## Returns the StorageTargets for this cache in the subscription and resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: string (required)
  ##            : Name of cache.
  ##   resourceGroupName: string (required)
  ##                    : Target resource group.
  var path_564216 = newJObject()
  var query_564217 = newJObject()
  add(query_564217, "api-version", newJString(apiVersion))
  add(path_564216, "subscriptionId", newJString(subscriptionId))
  add(path_564216, "cacheName", newJString(cacheName))
  add(path_564216, "resourceGroupName", newJString(resourceGroupName))
  result = call_564215.call(path_564216, query_564217, nil, nil, nil)

var storageTargetsListByCache* = Call_StorageTargetsListByCache_564207(
    name: "storageTargetsListByCache", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StorageCache/caches/{cacheName}/storageTargets",
    validator: validate_StorageTargetsListByCache_564208, base: "/",
    url: url_StorageTargetsListByCache_564209, schemes: {Scheme.Https})
type
  Call_StorageTargetsCreate_564230 = ref object of OpenApiRestCall_563555
proc url_StorageTargetsCreate_564232(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "cacheName" in path, "`cacheName` is a required path parameter"
  assert "storageTargetName" in path,
        "`storageTargetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorageCache/caches/"),
               (kind: VariableSegment, value: "cacheName"),
               (kind: ConstantSegment, value: "/storageTargets/"),
               (kind: VariableSegment, value: "storageTargetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageTargetsCreate_564231(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create/update a storage target.  This operation is allowed at any time, but if the cache is down or unhealthy, the actual creation/modification of the storage target may be delayed until the cache is healthy again.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storageTargetName: JString (required)
  ##                    : Name of storage target.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: JString (required)
  ##            : Name of cache.
  ##   resourceGroupName: JString (required)
  ##                    : Target resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `storageTargetName` field"
  var valid_564233 = path.getOrDefault("storageTargetName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "storageTargetName", valid_564233
  var valid_564234 = path.getOrDefault("subscriptionId")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "subscriptionId", valid_564234
  var valid_564235 = path.getOrDefault("cacheName")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "cacheName", valid_564235
  var valid_564236 = path.getOrDefault("resourceGroupName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "resourceGroupName", valid_564236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564237 = query.getOrDefault("api-version")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "api-version", valid_564237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   storagetarget: JObject
  ##                : Object containing the definition of a storage target.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564239: Call_StorageTargetsCreate_564230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create/update a storage target.  This operation is allowed at any time, but if the cache is down or unhealthy, the actual creation/modification of the storage target may be delayed until the cache is healthy again.
  ## 
  let valid = call_564239.validator(path, query, header, formData, body)
  let scheme = call_564239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564239.url(scheme.get, call_564239.host, call_564239.base,
                         call_564239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564239, url, valid)

proc call*(call_564240: Call_StorageTargetsCreate_564230;
          storageTargetName: string; apiVersion: string; subscriptionId: string;
          cacheName: string; resourceGroupName: string;
          storagetarget: JsonNode = nil): Recallable =
  ## storageTargetsCreate
  ## Create/update a storage target.  This operation is allowed at any time, but if the cache is down or unhealthy, the actual creation/modification of the storage target may be delayed until the cache is healthy again.
  ##   storagetarget: JObject
  ##                : Object containing the definition of a storage target.
  ##   storageTargetName: string (required)
  ##                    : Name of storage target.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: string (required)
  ##            : Name of cache.
  ##   resourceGroupName: string (required)
  ##                    : Target resource group.
  var path_564241 = newJObject()
  var query_564242 = newJObject()
  var body_564243 = newJObject()
  if storagetarget != nil:
    body_564243 = storagetarget
  add(path_564241, "storageTargetName", newJString(storageTargetName))
  add(query_564242, "api-version", newJString(apiVersion))
  add(path_564241, "subscriptionId", newJString(subscriptionId))
  add(path_564241, "cacheName", newJString(cacheName))
  add(path_564241, "resourceGroupName", newJString(resourceGroupName))
  result = call_564240.call(path_564241, query_564242, nil, nil, body_564243)

var storageTargetsCreate* = Call_StorageTargetsCreate_564230(
    name: "storageTargetsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StorageCache/caches/{cacheName}/storageTargets/{storageTargetName}",
    validator: validate_StorageTargetsCreate_564231, base: "/",
    url: url_StorageTargetsCreate_564232, schemes: {Scheme.Https})
type
  Call_StorageTargetsGet_564218 = ref object of OpenApiRestCall_563555
proc url_StorageTargetsGet_564220(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "cacheName" in path, "`cacheName` is a required path parameter"
  assert "storageTargetName" in path,
        "`storageTargetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorageCache/caches/"),
               (kind: VariableSegment, value: "cacheName"),
               (kind: ConstantSegment, value: "/storageTargets/"),
               (kind: VariableSegment, value: "storageTargetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageTargetsGet_564219(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns a storage target from a cache.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storageTargetName: JString (required)
  ##                    : Name of storage target.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: JString (required)
  ##            : Name of cache.
  ##   resourceGroupName: JString (required)
  ##                    : Target resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `storageTargetName` field"
  var valid_564221 = path.getOrDefault("storageTargetName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "storageTargetName", valid_564221
  var valid_564222 = path.getOrDefault("subscriptionId")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "subscriptionId", valid_564222
  var valid_564223 = path.getOrDefault("cacheName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "cacheName", valid_564223
  var valid_564224 = path.getOrDefault("resourceGroupName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "resourceGroupName", valid_564224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564225 = query.getOrDefault("api-version")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "api-version", valid_564225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564226: Call_StorageTargetsGet_564218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a storage target from a cache.
  ## 
  let valid = call_564226.validator(path, query, header, formData, body)
  let scheme = call_564226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564226.url(scheme.get, call_564226.host, call_564226.base,
                         call_564226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564226, url, valid)

proc call*(call_564227: Call_StorageTargetsGet_564218; storageTargetName: string;
          apiVersion: string; subscriptionId: string; cacheName: string;
          resourceGroupName: string): Recallable =
  ## storageTargetsGet
  ## Returns a storage target from a cache.
  ##   storageTargetName: string (required)
  ##                    : Name of storage target.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: string (required)
  ##            : Name of cache.
  ##   resourceGroupName: string (required)
  ##                    : Target resource group.
  var path_564228 = newJObject()
  var query_564229 = newJObject()
  add(path_564228, "storageTargetName", newJString(storageTargetName))
  add(query_564229, "api-version", newJString(apiVersion))
  add(path_564228, "subscriptionId", newJString(subscriptionId))
  add(path_564228, "cacheName", newJString(cacheName))
  add(path_564228, "resourceGroupName", newJString(resourceGroupName))
  result = call_564227.call(path_564228, query_564229, nil, nil, nil)

var storageTargetsGet* = Call_StorageTargetsGet_564218(name: "storageTargetsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StorageCache/caches/{cacheName}/storageTargets/{storageTargetName}",
    validator: validate_StorageTargetsGet_564219, base: "/",
    url: url_StorageTargetsGet_564220, schemes: {Scheme.Https})
type
  Call_StorageTargetsUpdate_564256 = ref object of OpenApiRestCall_563555
proc url_StorageTargetsUpdate_564258(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "cacheName" in path, "`cacheName` is a required path parameter"
  assert "storageTargetName" in path,
        "`storageTargetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorageCache/caches/"),
               (kind: VariableSegment, value: "cacheName"),
               (kind: ConstantSegment, value: "/storageTargets/"),
               (kind: VariableSegment, value: "storageTargetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageTargetsUpdate_564257(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a storage target.  This operation is allowed at any time, but if the cache is down or unhealthy, the actual creation/modification of the storage target may be delayed until the cache is healthy again.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storageTargetName: JString (required)
  ##                    : Name of storage target.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: JString (required)
  ##            : Name of cache.
  ##   resourceGroupName: JString (required)
  ##                    : Target resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `storageTargetName` field"
  var valid_564259 = path.getOrDefault("storageTargetName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "storageTargetName", valid_564259
  var valid_564260 = path.getOrDefault("subscriptionId")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "subscriptionId", valid_564260
  var valid_564261 = path.getOrDefault("cacheName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "cacheName", valid_564261
  var valid_564262 = path.getOrDefault("resourceGroupName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "resourceGroupName", valid_564262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564263 = query.getOrDefault("api-version")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "api-version", valid_564263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   storagetarget: JObject
  ##                : Object containing the definition of a storage target.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564265: Call_StorageTargetsUpdate_564256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a storage target.  This operation is allowed at any time, but if the cache is down or unhealthy, the actual creation/modification of the storage target may be delayed until the cache is healthy again.
  ## 
  let valid = call_564265.validator(path, query, header, formData, body)
  let scheme = call_564265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564265.url(scheme.get, call_564265.host, call_564265.base,
                         call_564265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564265, url, valid)

proc call*(call_564266: Call_StorageTargetsUpdate_564256;
          storageTargetName: string; apiVersion: string; subscriptionId: string;
          cacheName: string; resourceGroupName: string;
          storagetarget: JsonNode = nil): Recallable =
  ## storageTargetsUpdate
  ## Update a storage target.  This operation is allowed at any time, but if the cache is down or unhealthy, the actual creation/modification of the storage target may be delayed until the cache is healthy again.
  ##   storagetarget: JObject
  ##                : Object containing the definition of a storage target.
  ##   storageTargetName: string (required)
  ##                    : Name of storage target.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: string (required)
  ##            : Name of cache.
  ##   resourceGroupName: string (required)
  ##                    : Target resource group.
  var path_564267 = newJObject()
  var query_564268 = newJObject()
  var body_564269 = newJObject()
  if storagetarget != nil:
    body_564269 = storagetarget
  add(path_564267, "storageTargetName", newJString(storageTargetName))
  add(query_564268, "api-version", newJString(apiVersion))
  add(path_564267, "subscriptionId", newJString(subscriptionId))
  add(path_564267, "cacheName", newJString(cacheName))
  add(path_564267, "resourceGroupName", newJString(resourceGroupName))
  result = call_564266.call(path_564267, query_564268, nil, nil, body_564269)

var storageTargetsUpdate* = Call_StorageTargetsUpdate_564256(
    name: "storageTargetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StorageCache/caches/{cacheName}/storageTargets/{storageTargetName}",
    validator: validate_StorageTargetsUpdate_564257, base: "/",
    url: url_StorageTargetsUpdate_564258, schemes: {Scheme.Https})
type
  Call_StorageTargetsDelete_564244 = ref object of OpenApiRestCall_563555
proc url_StorageTargetsDelete_564246(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "cacheName" in path, "`cacheName` is a required path parameter"
  assert "storageTargetName" in path,
        "`storageTargetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorageCache/caches/"),
               (kind: VariableSegment, value: "cacheName"),
               (kind: ConstantSegment, value: "/storageTargets/"),
               (kind: VariableSegment, value: "storageTargetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageTargetsDelete_564245(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a storage target from a cache.  This operation is allowed at any time, but if the cache is down or unhealthy, the actual removal of the storage target may be delayed until the cache is healthy again.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storageTargetName: JString (required)
  ##                    : Name of storage target.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: JString (required)
  ##            : Name of cache.
  ##   resourceGroupName: JString (required)
  ##                    : Target resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `storageTargetName` field"
  var valid_564247 = path.getOrDefault("storageTargetName")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "storageTargetName", valid_564247
  var valid_564248 = path.getOrDefault("subscriptionId")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "subscriptionId", valid_564248
  var valid_564249 = path.getOrDefault("cacheName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "cacheName", valid_564249
  var valid_564250 = path.getOrDefault("resourceGroupName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "resourceGroupName", valid_564250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564251 = query.getOrDefault("api-version")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "api-version", valid_564251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564252: Call_StorageTargetsDelete_564244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a storage target from a cache.  This operation is allowed at any time, but if the cache is down or unhealthy, the actual removal of the storage target may be delayed until the cache is healthy again.
  ## 
  let valid = call_564252.validator(path, query, header, formData, body)
  let scheme = call_564252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564252.url(scheme.get, call_564252.host, call_564252.base,
                         call_564252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564252, url, valid)

proc call*(call_564253: Call_StorageTargetsDelete_564244;
          storageTargetName: string; apiVersion: string; subscriptionId: string;
          cacheName: string; resourceGroupName: string): Recallable =
  ## storageTargetsDelete
  ## Removes a storage target from a cache.  This operation is allowed at any time, but if the cache is down or unhealthy, the actual removal of the storage target may be delayed until the cache is healthy again.
  ##   storageTargetName: string (required)
  ##                    : Name of storage target.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: string (required)
  ##            : Name of cache.
  ##   resourceGroupName: string (required)
  ##                    : Target resource group.
  var path_564254 = newJObject()
  var query_564255 = newJObject()
  add(path_564254, "storageTargetName", newJString(storageTargetName))
  add(query_564255, "api-version", newJString(apiVersion))
  add(path_564254, "subscriptionId", newJString(subscriptionId))
  add(path_564254, "cacheName", newJString(cacheName))
  add(path_564254, "resourceGroupName", newJString(resourceGroupName))
  result = call_564253.call(path_564254, query_564255, nil, nil, nil)

var storageTargetsDelete* = Call_StorageTargetsDelete_564244(
    name: "storageTargetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StorageCache/caches/{cacheName}/storageTargets/{storageTargetName}",
    validator: validate_StorageTargetsDelete_564245, base: "/",
    url: url_StorageTargetsDelete_564246, schemes: {Scheme.Https})
type
  Call_CachesUpgradeFirmware_564270 = ref object of OpenApiRestCall_563555
proc url_CachesUpgradeFirmware_564272(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "cacheName" in path, "`cacheName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorageCache/caches/"),
               (kind: VariableSegment, value: "cacheName"),
               (kind: ConstantSegment, value: "/upgrade")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CachesUpgradeFirmware_564271(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Tells a cache to upgrade its firmware.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: JString (required)
  ##            : Name of cache.
  ##   resourceGroupName: JString (required)
  ##                    : Target resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564273 = path.getOrDefault("subscriptionId")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "subscriptionId", valid_564273
  var valid_564274 = path.getOrDefault("cacheName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "cacheName", valid_564274
  var valid_564275 = path.getOrDefault("resourceGroupName")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "resourceGroupName", valid_564275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564276 = query.getOrDefault("api-version")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "api-version", valid_564276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564277: Call_CachesUpgradeFirmware_564270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Tells a cache to upgrade its firmware.
  ## 
  let valid = call_564277.validator(path, query, header, formData, body)
  let scheme = call_564277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564277.url(scheme.get, call_564277.host, call_564277.base,
                         call_564277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564277, url, valid)

proc call*(call_564278: Call_CachesUpgradeFirmware_564270; apiVersion: string;
          subscriptionId: string; cacheName: string; resourceGroupName: string): Recallable =
  ## cachesUpgradeFirmware
  ## Tells a cache to upgrade its firmware.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   cacheName: string (required)
  ##            : Name of cache.
  ##   resourceGroupName: string (required)
  ##                    : Target resource group.
  var path_564279 = newJObject()
  var query_564280 = newJObject()
  add(query_564280, "api-version", newJString(apiVersion))
  add(path_564279, "subscriptionId", newJString(subscriptionId))
  add(path_564279, "cacheName", newJString(cacheName))
  add(path_564279, "resourceGroupName", newJString(resourceGroupName))
  result = call_564278.call(path_564279, query_564280, nil, nil, nil)

var cachesUpgradeFirmware* = Call_CachesUpgradeFirmware_564270(
    name: "cachesUpgradeFirmware", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StorageCache/caches/{cacheName}/upgrade",
    validator: validate_CachesUpgradeFirmware_564271, base: "/",
    url: url_CachesUpgradeFirmware_564272, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
