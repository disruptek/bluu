
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: VMwareCloudSimple
## version: 2019-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Description of the new service
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

  OpenApiRestCall_567668 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567668](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567668): Option[Scheme] {.used.} =
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
  macServiceName = "vmwarecloudsimple"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AvailableOperationsList_567890 = ref object of OpenApiRestCall_567668
proc url_AvailableOperationsList_567892(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AvailableOperationsList_567891(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return list of operations
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568051 = query.getOrDefault("api-version")
  valid_568051 = validateParameter(valid_568051, JString, required = true,
                                 default = nil)
  if valid_568051 != nil:
    section.add "api-version", valid_568051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568074: Call_AvailableOperationsList_567890; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return list of operations
  ## 
  let valid = call_568074.validator(path, query, header, formData, body)
  let scheme = call_568074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568074.url(scheme.get, call_568074.host, call_568074.base,
                         call_568074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568074, url, valid)

proc call*(call_568145: Call_AvailableOperationsList_567890; apiVersion: string): Recallable =
  ## availableOperationsList
  ## Return list of operations
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_568146 = newJObject()
  add(query_568146, "api-version", newJString(apiVersion))
  result = call_568145.call(nil, query_568146, nil, nil, nil)

var availableOperationsList* = Call_AvailableOperationsList_567890(
    name: "availableOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.VMwareCloudSimple/operations",
    validator: validate_AvailableOperationsList_567891, base: "",
    url: url_AvailableOperationsList_567892, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeListBySubscription_568186 = ref object of OpenApiRestCall_567668
proc url_DedicatedCloudNodeListBySubscription_568188(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedCloudNodeListBySubscription_568187(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of dedicate cloud nodes within subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
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
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of record sets to return
  ##   $skipToken: JString
  ##             : to be used by nextLink implementation
  ##   $filter: JString
  ##          : The filter to apply on the list operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568205 = query.getOrDefault("api-version")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "api-version", valid_568205
  var valid_568206 = query.getOrDefault("$top")
  valid_568206 = validateParameter(valid_568206, JInt, required = false, default = nil)
  if valid_568206 != nil:
    section.add "$top", valid_568206
  var valid_568207 = query.getOrDefault("$skipToken")
  valid_568207 = validateParameter(valid_568207, JString, required = false,
                                 default = nil)
  if valid_568207 != nil:
    section.add "$skipToken", valid_568207
  var valid_568208 = query.getOrDefault("$filter")
  valid_568208 = validateParameter(valid_568208, JString, required = false,
                                 default = nil)
  if valid_568208 != nil:
    section.add "$filter", valid_568208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568209: Call_DedicatedCloudNodeListBySubscription_568186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of dedicate cloud nodes within subscription
  ## 
  let valid = call_568209.validator(path, query, header, formData, body)
  let scheme = call_568209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568209.url(scheme.get, call_568209.host, call_568209.base,
                         call_568209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568209, url, valid)

proc call*(call_568210: Call_DedicatedCloudNodeListBySubscription_568186;
          apiVersion: string; subscriptionId: string; Top: int = 0;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## dedicatedCloudNodeListBySubscription
  ## Returns list of dedicate cloud nodes within subscription
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of record sets to return
  ##   SkipToken: string
  ##            : to be used by nextLink implementation
  ##   Filter: string
  ##         : The filter to apply on the list operation
  var path_568211 = newJObject()
  var query_568212 = newJObject()
  add(query_568212, "api-version", newJString(apiVersion))
  add(path_568211, "subscriptionId", newJString(subscriptionId))
  add(query_568212, "$top", newJInt(Top))
  add(query_568212, "$skipToken", newJString(SkipToken))
  add(query_568212, "$filter", newJString(Filter))
  result = call_568210.call(path_568211, query_568212, nil, nil, nil)

var dedicatedCloudNodeListBySubscription* = Call_DedicatedCloudNodeListBySubscription_568186(
    name: "dedicatedCloudNodeListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes",
    validator: validate_DedicatedCloudNodeListBySubscription_568187, base: "",
    url: url_DedicatedCloudNodeListBySubscription_568188, schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceListBySubscription_568213 = ref object of OpenApiRestCall_567668
proc url_DedicatedCloudServiceListBySubscription_568215(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedCloudServiceListBySubscription_568214(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of dedicated cloud services within a subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568216 = path.getOrDefault("subscriptionId")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "subscriptionId", valid_568216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of record sets to return
  ##   $skipToken: JString
  ##             : to be used by nextLink implementation
  ##   $filter: JString
  ##          : The filter to apply on the list operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568217 = query.getOrDefault("api-version")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "api-version", valid_568217
  var valid_568218 = query.getOrDefault("$top")
  valid_568218 = validateParameter(valid_568218, JInt, required = false, default = nil)
  if valid_568218 != nil:
    section.add "$top", valid_568218
  var valid_568219 = query.getOrDefault("$skipToken")
  valid_568219 = validateParameter(valid_568219, JString, required = false,
                                 default = nil)
  if valid_568219 != nil:
    section.add "$skipToken", valid_568219
  var valid_568220 = query.getOrDefault("$filter")
  valid_568220 = validateParameter(valid_568220, JString, required = false,
                                 default = nil)
  if valid_568220 != nil:
    section.add "$filter", valid_568220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568221: Call_DedicatedCloudServiceListBySubscription_568213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of dedicated cloud services within a subscription
  ## 
  let valid = call_568221.validator(path, query, header, formData, body)
  let scheme = call_568221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568221.url(scheme.get, call_568221.host, call_568221.base,
                         call_568221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568221, url, valid)

proc call*(call_568222: Call_DedicatedCloudServiceListBySubscription_568213;
          apiVersion: string; subscriptionId: string; Top: int = 0;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## dedicatedCloudServiceListBySubscription
  ## Returns list of dedicated cloud services within a subscription
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of record sets to return
  ##   SkipToken: string
  ##            : to be used by nextLink implementation
  ##   Filter: string
  ##         : The filter to apply on the list operation
  var path_568223 = newJObject()
  var query_568224 = newJObject()
  add(query_568224, "api-version", newJString(apiVersion))
  add(path_568223, "subscriptionId", newJString(subscriptionId))
  add(query_568224, "$top", newJInt(Top))
  add(query_568224, "$skipToken", newJString(SkipToken))
  add(query_568224, "$filter", newJString(Filter))
  result = call_568222.call(path_568223, query_568224, nil, nil, nil)

var dedicatedCloudServiceListBySubscription* = Call_DedicatedCloudServiceListBySubscription_568213(
    name: "dedicatedCloudServiceListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices",
    validator: validate_DedicatedCloudServiceListBySubscription_568214, base: "",
    url: url_DedicatedCloudServiceListBySubscription_568215,
    schemes: {Scheme.Https})
type
  Call_SkusAvailabilityWithinRegionList_568225 = ref object of OpenApiRestCall_567668
proc url_SkusAvailabilityWithinRegionList_568227(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "regionId" in path, "`regionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/locations/"),
               (kind: VariableSegment, value: "regionId"),
               (kind: ConstantSegment, value: "/availabilities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SkusAvailabilityWithinRegionList_568226(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of available resources in region
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568228 = path.getOrDefault("subscriptionId")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "subscriptionId", valid_568228
  var valid_568229 = path.getOrDefault("regionId")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "regionId", valid_568229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   skuId: JString
  ##        : sku id, if no sku is passed availability for all skus will be returned
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568230 = query.getOrDefault("api-version")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "api-version", valid_568230
  var valid_568231 = query.getOrDefault("skuId")
  valid_568231 = validateParameter(valid_568231, JString, required = false,
                                 default = nil)
  if valid_568231 != nil:
    section.add "skuId", valid_568231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568232: Call_SkusAvailabilityWithinRegionList_568225;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of available resources in region
  ## 
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_SkusAvailabilityWithinRegionList_568225;
          apiVersion: string; subscriptionId: string; regionId: string;
          skuId: string = ""): Recallable =
  ## skusAvailabilityWithinRegionList
  ## Returns list of available resources in region
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   skuId: string
  ##        : sku id, if no sku is passed availability for all skus will be returned
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  add(query_568235, "api-version", newJString(apiVersion))
  add(path_568234, "subscriptionId", newJString(subscriptionId))
  add(query_568235, "skuId", newJString(skuId))
  add(path_568234, "regionId", newJString(regionId))
  result = call_568233.call(path_568234, query_568235, nil, nil, nil)

var skusAvailabilityWithinRegionList* = Call_SkusAvailabilityWithinRegionList_568225(
    name: "skusAvailabilityWithinRegionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/availabilities",
    validator: validate_SkusAvailabilityWithinRegionList_568226, base: "",
    url: url_SkusAvailabilityWithinRegionList_568227, schemes: {Scheme.Https})
type
  Call_GetOperationResultByRegion_568236 = ref object of OpenApiRestCall_567668
proc url_GetOperationResultByRegion_568238(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "regionId" in path, "`regionId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/locations/"),
               (kind: VariableSegment, value: "regionId"),
               (kind: ConstantSegment, value: "/operationResults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetOperationResultByRegion_568237(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return an async operation
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   operationId: JString (required)
  ##              : operation id
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568239 = path.getOrDefault("subscriptionId")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "subscriptionId", valid_568239
  var valid_568240 = path.getOrDefault("operationId")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "operationId", valid_568240
  var valid_568241 = path.getOrDefault("regionId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "regionId", valid_568241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568242 = query.getOrDefault("api-version")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "api-version", valid_568242
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_568243 = header.getOrDefault("Referer")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "Referer", valid_568243
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568244: Call_GetOperationResultByRegion_568236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return an async operation
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_GetOperationResultByRegion_568236; apiVersion: string;
          subscriptionId: string; operationId: string; regionId: string): Recallable =
  ## getOperationResultByRegion
  ## Return an async operation
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   operationId: string (required)
  ##              : operation id
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  add(path_568246, "operationId", newJString(operationId))
  add(path_568246, "regionId", newJString(regionId))
  result = call_568245.call(path_568246, query_568247, nil, nil, nil)

var getOperationResultByRegion* = Call_GetOperationResultByRegion_568236(
    name: "getOperationResultByRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/operationResults/{operationId}",
    validator: validate_GetOperationResultByRegion_568237, base: "",
    url: url_GetOperationResultByRegion_568238, schemes: {Scheme.Https})
type
  Call_PrivateCloudByRegionList_568248 = ref object of OpenApiRestCall_567668
proc url_PrivateCloudByRegionList_568250(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "regionId" in path, "`regionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/locations/"),
               (kind: VariableSegment, value: "regionId"),
               (kind: ConstantSegment, value: "/privateClouds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateCloudByRegionList_568249(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of private clouds in particular region
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568251 = path.getOrDefault("subscriptionId")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "subscriptionId", valid_568251
  var valid_568252 = path.getOrDefault("regionId")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "regionId", valid_568252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568253 = query.getOrDefault("api-version")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "api-version", valid_568253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568254: Call_PrivateCloudByRegionList_568248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns list of private clouds in particular region
  ## 
  let valid = call_568254.validator(path, query, header, formData, body)
  let scheme = call_568254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568254.url(scheme.get, call_568254.host, call_568254.base,
                         call_568254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568254, url, valid)

proc call*(call_568255: Call_PrivateCloudByRegionList_568248; apiVersion: string;
          subscriptionId: string; regionId: string): Recallable =
  ## privateCloudByRegionList
  ## Returns list of private clouds in particular region
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_568256 = newJObject()
  var query_568257 = newJObject()
  add(query_568257, "api-version", newJString(apiVersion))
  add(path_568256, "subscriptionId", newJString(subscriptionId))
  add(path_568256, "regionId", newJString(regionId))
  result = call_568255.call(path_568256, query_568257, nil, nil, nil)

var privateCloudByRegionList* = Call_PrivateCloudByRegionList_568248(
    name: "privateCloudByRegionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds",
    validator: validate_PrivateCloudByRegionList_568249, base: "",
    url: url_PrivateCloudByRegionList_568250, schemes: {Scheme.Https})
type
  Call_GetPrivateCloud_568258 = ref object of OpenApiRestCall_567668
proc url_GetPrivateCloud_568260(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "regionId" in path, "`regionId` is a required path parameter"
  assert "pcName" in path, "`pcName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/locations/"),
               (kind: VariableSegment, value: "regionId"),
               (kind: ConstantSegment, value: "/privateClouds/"),
               (kind: VariableSegment, value: "pcName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetPrivateCloud_568259(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns private cloud by its name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   pcName: JString (required)
  ##         : The private cloud name
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568261 = path.getOrDefault("subscriptionId")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "subscriptionId", valid_568261
  var valid_568262 = path.getOrDefault("pcName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "pcName", valid_568262
  var valid_568263 = path.getOrDefault("regionId")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "regionId", valid_568263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568264 = query.getOrDefault("api-version")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "api-version", valid_568264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568265: Call_GetPrivateCloud_568258; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns private cloud by its name
  ## 
  let valid = call_568265.validator(path, query, header, formData, body)
  let scheme = call_568265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568265.url(scheme.get, call_568265.host, call_568265.base,
                         call_568265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568265, url, valid)

proc call*(call_568266: Call_GetPrivateCloud_568258; apiVersion: string;
          subscriptionId: string; pcName: string; regionId: string): Recallable =
  ## getPrivateCloud
  ## Returns private cloud by its name
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   pcName: string (required)
  ##         : The private cloud name
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_568267 = newJObject()
  var query_568268 = newJObject()
  add(query_568268, "api-version", newJString(apiVersion))
  add(path_568267, "subscriptionId", newJString(subscriptionId))
  add(path_568267, "pcName", newJString(pcName))
  add(path_568267, "regionId", newJString(regionId))
  result = call_568266.call(path_568267, query_568268, nil, nil, nil)

var getPrivateCloud* = Call_GetPrivateCloud_568258(name: "getPrivateCloud",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}",
    validator: validate_GetPrivateCloud_568259, base: "", url: url_GetPrivateCloud_568260,
    schemes: {Scheme.Https})
type
  Call_ResourcePoolsByPCList_568269 = ref object of OpenApiRestCall_567668
proc url_ResourcePoolsByPCList_568271(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "regionId" in path, "`regionId` is a required path parameter"
  assert "pcName" in path, "`pcName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/locations/"),
               (kind: VariableSegment, value: "regionId"),
               (kind: ConstantSegment, value: "/privateClouds/"),
               (kind: VariableSegment, value: "pcName"),
               (kind: ConstantSegment, value: "/resourcePools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcePoolsByPCList_568270(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of resource pools in region for private cloud
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   pcName: JString (required)
  ##         : The private cloud name
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568272 = path.getOrDefault("subscriptionId")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "subscriptionId", valid_568272
  var valid_568273 = path.getOrDefault("pcName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "pcName", valid_568273
  var valid_568274 = path.getOrDefault("regionId")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "regionId", valid_568274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568275 = query.getOrDefault("api-version")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "api-version", valid_568275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568276: Call_ResourcePoolsByPCList_568269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns list of resource pools in region for private cloud
  ## 
  let valid = call_568276.validator(path, query, header, formData, body)
  let scheme = call_568276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568276.url(scheme.get, call_568276.host, call_568276.base,
                         call_568276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568276, url, valid)

proc call*(call_568277: Call_ResourcePoolsByPCList_568269; apiVersion: string;
          subscriptionId: string; pcName: string; regionId: string): Recallable =
  ## resourcePoolsByPCList
  ## Returns list of resource pools in region for private cloud
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   pcName: string (required)
  ##         : The private cloud name
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_568278 = newJObject()
  var query_568279 = newJObject()
  add(query_568279, "api-version", newJString(apiVersion))
  add(path_568278, "subscriptionId", newJString(subscriptionId))
  add(path_568278, "pcName", newJString(pcName))
  add(path_568278, "regionId", newJString(regionId))
  result = call_568277.call(path_568278, query_568279, nil, nil, nil)

var resourcePoolsByPCList* = Call_ResourcePoolsByPCList_568269(
    name: "resourcePoolsByPCList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/resourcePools",
    validator: validate_ResourcePoolsByPCList_568270, base: "",
    url: url_ResourcePoolsByPCList_568271, schemes: {Scheme.Https})
type
  Call_ResourcePoolByPCGet_568280 = ref object of OpenApiRestCall_567668
proc url_ResourcePoolByPCGet_568282(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "regionId" in path, "`regionId` is a required path parameter"
  assert "pcName" in path, "`pcName` is a required path parameter"
  assert "resourcePoolName" in path,
        "`resourcePoolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/locations/"),
               (kind: VariableSegment, value: "regionId"),
               (kind: ConstantSegment, value: "/privateClouds/"),
               (kind: VariableSegment, value: "pcName"),
               (kind: ConstantSegment, value: "/resourcePools/"),
               (kind: VariableSegment, value: "resourcePoolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcePoolByPCGet_568281(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns resource pool templates by its name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourcePoolName: JString (required)
  ##                   : resource pool id (vsphereId)
  ##   pcName: JString (required)
  ##         : The private cloud name
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568283 = path.getOrDefault("subscriptionId")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "subscriptionId", valid_568283
  var valid_568284 = path.getOrDefault("resourcePoolName")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "resourcePoolName", valid_568284
  var valid_568285 = path.getOrDefault("pcName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "pcName", valid_568285
  var valid_568286 = path.getOrDefault("regionId")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "regionId", valid_568286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568287 = query.getOrDefault("api-version")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "api-version", valid_568287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568288: Call_ResourcePoolByPCGet_568280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns resource pool templates by its name
  ## 
  let valid = call_568288.validator(path, query, header, formData, body)
  let scheme = call_568288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568288.url(scheme.get, call_568288.host, call_568288.base,
                         call_568288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568288, url, valid)

proc call*(call_568289: Call_ResourcePoolByPCGet_568280; apiVersion: string;
          subscriptionId: string; resourcePoolName: string; pcName: string;
          regionId: string): Recallable =
  ## resourcePoolByPCGet
  ## Returns resource pool templates by its name
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourcePoolName: string (required)
  ##                   : resource pool id (vsphereId)
  ##   pcName: string (required)
  ##         : The private cloud name
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_568290 = newJObject()
  var query_568291 = newJObject()
  add(query_568291, "api-version", newJString(apiVersion))
  add(path_568290, "subscriptionId", newJString(subscriptionId))
  add(path_568290, "resourcePoolName", newJString(resourcePoolName))
  add(path_568290, "pcName", newJString(pcName))
  add(path_568290, "regionId", newJString(regionId))
  result = call_568289.call(path_568290, query_568291, nil, nil, nil)

var resourcePoolByPCGet* = Call_ResourcePoolByPCGet_568280(
    name: "resourcePoolByPCGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/resourcePools/{resourcePoolName}",
    validator: validate_ResourcePoolByPCGet_568281, base: "",
    url: url_ResourcePoolByPCGet_568282, schemes: {Scheme.Https})
type
  Call_VirtualMachineTemplatesByPCList_568292 = ref object of OpenApiRestCall_567668
proc url_VirtualMachineTemplatesByPCList_568294(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "regionId" in path, "`regionId` is a required path parameter"
  assert "pcName" in path, "`pcName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/locations/"),
               (kind: VariableSegment, value: "regionId"),
               (kind: ConstantSegment, value: "/privateClouds/"),
               (kind: VariableSegment, value: "pcName"),
               (kind: ConstantSegment, value: "/virtualMachineTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineTemplatesByPCList_568293(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of virtual machine templates in region for private cloud
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   pcName: JString (required)
  ##         : The private cloud name
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568295 = path.getOrDefault("subscriptionId")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "subscriptionId", valid_568295
  var valid_568296 = path.getOrDefault("pcName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "pcName", valid_568296
  var valid_568297 = path.getOrDefault("regionId")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "regionId", valid_568297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   resourcePoolName: JString (required)
  ##                   : Resource pool used to derive vSphere cluster which contains VM templates
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568298 = query.getOrDefault("api-version")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "api-version", valid_568298
  var valid_568299 = query.getOrDefault("resourcePoolName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "resourcePoolName", valid_568299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568300: Call_VirtualMachineTemplatesByPCList_568292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of virtual machine templates in region for private cloud
  ## 
  let valid = call_568300.validator(path, query, header, formData, body)
  let scheme = call_568300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568300.url(scheme.get, call_568300.host, call_568300.base,
                         call_568300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568300, url, valid)

proc call*(call_568301: Call_VirtualMachineTemplatesByPCList_568292;
          apiVersion: string; subscriptionId: string; resourcePoolName: string;
          pcName: string; regionId: string): Recallable =
  ## virtualMachineTemplatesByPCList
  ## Returns list of virtual machine templates in region for private cloud
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourcePoolName: string (required)
  ##                   : Resource pool used to derive vSphere cluster which contains VM templates
  ##   pcName: string (required)
  ##         : The private cloud name
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_568302 = newJObject()
  var query_568303 = newJObject()
  add(query_568303, "api-version", newJString(apiVersion))
  add(path_568302, "subscriptionId", newJString(subscriptionId))
  add(query_568303, "resourcePoolName", newJString(resourcePoolName))
  add(path_568302, "pcName", newJString(pcName))
  add(path_568302, "regionId", newJString(regionId))
  result = call_568301.call(path_568302, query_568303, nil, nil, nil)

var virtualMachineTemplatesByPCList* = Call_VirtualMachineTemplatesByPCList_568292(
    name: "virtualMachineTemplatesByPCList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/virtualMachineTemplates",
    validator: validate_VirtualMachineTemplatesByPCList_568293, base: "",
    url: url_VirtualMachineTemplatesByPCList_568294, schemes: {Scheme.Https})
type
  Call_VirtualMachineTemplateByPCGet_568304 = ref object of OpenApiRestCall_567668
proc url_VirtualMachineTemplateByPCGet_568306(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "regionId" in path, "`regionId` is a required path parameter"
  assert "pcName" in path, "`pcName` is a required path parameter"
  assert "virtualMachineTemplateName" in path,
        "`virtualMachineTemplateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/locations/"),
               (kind: VariableSegment, value: "regionId"),
               (kind: ConstantSegment, value: "/privateClouds/"),
               (kind: VariableSegment, value: "pcName"),
               (kind: ConstantSegment, value: "/virtualMachineTemplates/"),
               (kind: VariableSegment, value: "virtualMachineTemplateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineTemplateByPCGet_568305(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns virtual machine templates by its name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   virtualMachineTemplateName: JString (required)
  ##                             : virtual machine template id (vsphereId)
  ##   pcName: JString (required)
  ##         : The private cloud name
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568307 = path.getOrDefault("subscriptionId")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "subscriptionId", valid_568307
  var valid_568308 = path.getOrDefault("virtualMachineTemplateName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "virtualMachineTemplateName", valid_568308
  var valid_568309 = path.getOrDefault("pcName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "pcName", valid_568309
  var valid_568310 = path.getOrDefault("regionId")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "regionId", valid_568310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_568312: Call_VirtualMachineTemplateByPCGet_568304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns virtual machine templates by its name
  ## 
  let valid = call_568312.validator(path, query, header, formData, body)
  let scheme = call_568312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568312.url(scheme.get, call_568312.host, call_568312.base,
                         call_568312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568312, url, valid)

proc call*(call_568313: Call_VirtualMachineTemplateByPCGet_568304;
          apiVersion: string; subscriptionId: string;
          virtualMachineTemplateName: string; pcName: string; regionId: string): Recallable =
  ## virtualMachineTemplateByPCGet
  ## Returns virtual machine templates by its name
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   virtualMachineTemplateName: string (required)
  ##                             : virtual machine template id (vsphereId)
  ##   pcName: string (required)
  ##         : The private cloud name
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_568314 = newJObject()
  var query_568315 = newJObject()
  add(query_568315, "api-version", newJString(apiVersion))
  add(path_568314, "subscriptionId", newJString(subscriptionId))
  add(path_568314, "virtualMachineTemplateName",
      newJString(virtualMachineTemplateName))
  add(path_568314, "pcName", newJString(pcName))
  add(path_568314, "regionId", newJString(regionId))
  result = call_568313.call(path_568314, query_568315, nil, nil, nil)

var virtualMachineTemplateByPCGet* = Call_VirtualMachineTemplateByPCGet_568304(
    name: "virtualMachineTemplateByPCGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/virtualMachineTemplates/{virtualMachineTemplateName}",
    validator: validate_VirtualMachineTemplateByPCGet_568305, base: "",
    url: url_VirtualMachineTemplateByPCGet_568306, schemes: {Scheme.Https})
type
  Call_VirtualNetworksByPCList_568316 = ref object of OpenApiRestCall_567668
proc url_VirtualNetworksByPCList_568318(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "regionId" in path, "`regionId` is a required path parameter"
  assert "pcName" in path, "`pcName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/locations/"),
               (kind: VariableSegment, value: "regionId"),
               (kind: ConstantSegment, value: "/privateClouds/"),
               (kind: VariableSegment, value: "pcName"),
               (kind: ConstantSegment, value: "/virtualNetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksByPCList_568317(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return list of virtual networks in location for private cloud
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   pcName: JString (required)
  ##         : The private cloud name
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568319 = path.getOrDefault("subscriptionId")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "subscriptionId", valid_568319
  var valid_568320 = path.getOrDefault("pcName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "pcName", valid_568320
  var valid_568321 = path.getOrDefault("regionId")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "regionId", valid_568321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   resourcePoolName: JString (required)
  ##                   : Resource pool used to derive vSphere cluster which contains virtual networks
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568322 = query.getOrDefault("api-version")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "api-version", valid_568322
  var valid_568323 = query.getOrDefault("resourcePoolName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "resourcePoolName", valid_568323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568324: Call_VirtualNetworksByPCList_568316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return list of virtual networks in location for private cloud
  ## 
  let valid = call_568324.validator(path, query, header, formData, body)
  let scheme = call_568324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568324.url(scheme.get, call_568324.host, call_568324.base,
                         call_568324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568324, url, valid)

proc call*(call_568325: Call_VirtualNetworksByPCList_568316; apiVersion: string;
          subscriptionId: string; resourcePoolName: string; pcName: string;
          regionId: string): Recallable =
  ## virtualNetworksByPCList
  ## Return list of virtual networks in location for private cloud
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourcePoolName: string (required)
  ##                   : Resource pool used to derive vSphere cluster which contains virtual networks
  ##   pcName: string (required)
  ##         : The private cloud name
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_568326 = newJObject()
  var query_568327 = newJObject()
  add(query_568327, "api-version", newJString(apiVersion))
  add(path_568326, "subscriptionId", newJString(subscriptionId))
  add(query_568327, "resourcePoolName", newJString(resourcePoolName))
  add(path_568326, "pcName", newJString(pcName))
  add(path_568326, "regionId", newJString(regionId))
  result = call_568325.call(path_568326, query_568327, nil, nil, nil)

var virtualNetworksByPCList* = Call_VirtualNetworksByPCList_568316(
    name: "virtualNetworksByPCList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/virtualNetworks",
    validator: validate_VirtualNetworksByPCList_568317, base: "",
    url: url_VirtualNetworksByPCList_568318, schemes: {Scheme.Https})
type
  Call_VirtualNetworkByPCGet_568328 = ref object of OpenApiRestCall_567668
proc url_VirtualNetworkByPCGet_568330(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "regionId" in path, "`regionId` is a required path parameter"
  assert "pcName" in path, "`pcName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/locations/"),
               (kind: VariableSegment, value: "regionId"),
               (kind: ConstantSegment, value: "/privateClouds/"),
               (kind: VariableSegment, value: "pcName"),
               (kind: ConstantSegment, value: "/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkByPCGet_568329(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return virtual network by its name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   virtualNetworkName: JString (required)
  ##                     : virtual network id (vsphereId)
  ##   pcName: JString (required)
  ##         : The private cloud name
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568331 = path.getOrDefault("subscriptionId")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "subscriptionId", valid_568331
  var valid_568332 = path.getOrDefault("virtualNetworkName")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "virtualNetworkName", valid_568332
  var valid_568333 = path.getOrDefault("pcName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "pcName", valid_568333
  var valid_568334 = path.getOrDefault("regionId")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "regionId", valid_568334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568335 = query.getOrDefault("api-version")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "api-version", valid_568335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568336: Call_VirtualNetworkByPCGet_568328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return virtual network by its name
  ## 
  let valid = call_568336.validator(path, query, header, formData, body)
  let scheme = call_568336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568336.url(scheme.get, call_568336.host, call_568336.base,
                         call_568336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568336, url, valid)

proc call*(call_568337: Call_VirtualNetworkByPCGet_568328; apiVersion: string;
          subscriptionId: string; virtualNetworkName: string; pcName: string;
          regionId: string): Recallable =
  ## virtualNetworkByPCGet
  ## Return virtual network by its name
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   virtualNetworkName: string (required)
  ##                     : virtual network id (vsphereId)
  ##   pcName: string (required)
  ##         : The private cloud name
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_568338 = newJObject()
  var query_568339 = newJObject()
  add(query_568339, "api-version", newJString(apiVersion))
  add(path_568338, "subscriptionId", newJString(subscriptionId))
  add(path_568338, "virtualNetworkName", newJString(virtualNetworkName))
  add(path_568338, "pcName", newJString(pcName))
  add(path_568338, "regionId", newJString(regionId))
  result = call_568337.call(path_568338, query_568339, nil, nil, nil)

var virtualNetworkByPCGet* = Call_VirtualNetworkByPCGet_568328(
    name: "virtualNetworkByPCGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworkByPCGet_568329, base: "",
    url: url_VirtualNetworkByPCGet_568330, schemes: {Scheme.Https})
type
  Call_UsagesWithinRegionList_568340 = ref object of OpenApiRestCall_567668
proc url_UsagesWithinRegionList_568342(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "regionId" in path, "`regionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/locations/"),
               (kind: VariableSegment, value: "regionId"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsagesWithinRegionList_568341(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of usage in region
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568343 = path.getOrDefault("subscriptionId")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "subscriptionId", valid_568343
  var valid_568344 = path.getOrDefault("regionId")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "regionId", valid_568344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The filter to apply on the list operation. only name.value is allowed here as a filter e.g. $filter=name.value eq 'xxxx'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568345 = query.getOrDefault("api-version")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "api-version", valid_568345
  var valid_568346 = query.getOrDefault("$filter")
  valid_568346 = validateParameter(valid_568346, JString, required = false,
                                 default = nil)
  if valid_568346 != nil:
    section.add "$filter", valid_568346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568347: Call_UsagesWithinRegionList_568340; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns list of usage in region
  ## 
  let valid = call_568347.validator(path, query, header, formData, body)
  let scheme = call_568347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568347.url(scheme.get, call_568347.host, call_568347.base,
                         call_568347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568347, url, valid)

proc call*(call_568348: Call_UsagesWithinRegionList_568340; apiVersion: string;
          subscriptionId: string; regionId: string; Filter: string = ""): Recallable =
  ## usagesWithinRegionList
  ## Returns list of usage in region
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  ##   Filter: string
  ##         : The filter to apply on the list operation. only name.value is allowed here as a filter e.g. $filter=name.value eq 'xxxx'
  var path_568349 = newJObject()
  var query_568350 = newJObject()
  add(query_568350, "api-version", newJString(apiVersion))
  add(path_568349, "subscriptionId", newJString(subscriptionId))
  add(path_568349, "regionId", newJString(regionId))
  add(query_568350, "$filter", newJString(Filter))
  result = call_568348.call(path_568349, query_568350, nil, nil, nil)

var usagesWithinRegionList* = Call_UsagesWithinRegionList_568340(
    name: "usagesWithinRegionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/usages",
    validator: validate_UsagesWithinRegionList_568341, base: "",
    url: url_UsagesWithinRegionList_568342, schemes: {Scheme.Https})
type
  Call_VirtualMachineListBySubscription_568351 = ref object of OpenApiRestCall_567668
proc url_VirtualMachineListBySubscription_568353(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/virtualMachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineListBySubscription_568352(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list virtual machine within subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568354 = path.getOrDefault("subscriptionId")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "subscriptionId", valid_568354
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of record sets to return
  ##   $skipToken: JString
  ##             : to be used by nextLink implementation
  ##   $filter: JString
  ##          : The filter to apply on the list operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568355 = query.getOrDefault("api-version")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "api-version", valid_568355
  var valid_568356 = query.getOrDefault("$top")
  valid_568356 = validateParameter(valid_568356, JInt, required = false, default = nil)
  if valid_568356 != nil:
    section.add "$top", valid_568356
  var valid_568357 = query.getOrDefault("$skipToken")
  valid_568357 = validateParameter(valid_568357, JString, required = false,
                                 default = nil)
  if valid_568357 != nil:
    section.add "$skipToken", valid_568357
  var valid_568358 = query.getOrDefault("$filter")
  valid_568358 = validateParameter(valid_568358, JString, required = false,
                                 default = nil)
  if valid_568358 != nil:
    section.add "$filter", valid_568358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568359: Call_VirtualMachineListBySubscription_568351;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list virtual machine within subscription
  ## 
  let valid = call_568359.validator(path, query, header, formData, body)
  let scheme = call_568359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568359.url(scheme.get, call_568359.host, call_568359.base,
                         call_568359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568359, url, valid)

proc call*(call_568360: Call_VirtualMachineListBySubscription_568351;
          apiVersion: string; subscriptionId: string; Top: int = 0;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## virtualMachineListBySubscription
  ## Returns list virtual machine within subscription
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of record sets to return
  ##   SkipToken: string
  ##            : to be used by nextLink implementation
  ##   Filter: string
  ##         : The filter to apply on the list operation
  var path_568361 = newJObject()
  var query_568362 = newJObject()
  add(query_568362, "api-version", newJString(apiVersion))
  add(path_568361, "subscriptionId", newJString(subscriptionId))
  add(query_568362, "$top", newJInt(Top))
  add(query_568362, "$skipToken", newJString(SkipToken))
  add(query_568362, "$filter", newJString(Filter))
  result = call_568360.call(path_568361, query_568362, nil, nil, nil)

var virtualMachineListBySubscription* = Call_VirtualMachineListBySubscription_568351(
    name: "virtualMachineListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/virtualMachines",
    validator: validate_VirtualMachineListBySubscription_568352, base: "",
    url: url_VirtualMachineListBySubscription_568353, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeListByResourceGroup_568363 = ref object of OpenApiRestCall_567668
proc url_DedicatedCloudNodeListByResourceGroup_568365(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedCloudNodeListByResourceGroup_568364(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of dedicate cloud nodes within resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568366 = path.getOrDefault("resourceGroupName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "resourceGroupName", valid_568366
  var valid_568367 = path.getOrDefault("subscriptionId")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "subscriptionId", valid_568367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of record sets to return
  ##   $skipToken: JString
  ##             : to be used by nextLink implementation
  ##   $filter: JString
  ##          : The filter to apply on the list operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568368 = query.getOrDefault("api-version")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "api-version", valid_568368
  var valid_568369 = query.getOrDefault("$top")
  valid_568369 = validateParameter(valid_568369, JInt, required = false, default = nil)
  if valid_568369 != nil:
    section.add "$top", valid_568369
  var valid_568370 = query.getOrDefault("$skipToken")
  valid_568370 = validateParameter(valid_568370, JString, required = false,
                                 default = nil)
  if valid_568370 != nil:
    section.add "$skipToken", valid_568370
  var valid_568371 = query.getOrDefault("$filter")
  valid_568371 = validateParameter(valid_568371, JString, required = false,
                                 default = nil)
  if valid_568371 != nil:
    section.add "$filter", valid_568371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568372: Call_DedicatedCloudNodeListByResourceGroup_568363;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of dedicate cloud nodes within resource group
  ## 
  let valid = call_568372.validator(path, query, header, formData, body)
  let scheme = call_568372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568372.url(scheme.get, call_568372.host, call_568372.base,
                         call_568372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568372, url, valid)

proc call*(call_568373: Call_DedicatedCloudNodeListByResourceGroup_568363;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; SkipToken: string = ""; Filter: string = ""): Recallable =
  ## dedicatedCloudNodeListByResourceGroup
  ## Returns list of dedicate cloud nodes within resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of record sets to return
  ##   SkipToken: string
  ##            : to be used by nextLink implementation
  ##   Filter: string
  ##         : The filter to apply on the list operation
  var path_568374 = newJObject()
  var query_568375 = newJObject()
  add(path_568374, "resourceGroupName", newJString(resourceGroupName))
  add(query_568375, "api-version", newJString(apiVersion))
  add(path_568374, "subscriptionId", newJString(subscriptionId))
  add(query_568375, "$top", newJInt(Top))
  add(query_568375, "$skipToken", newJString(SkipToken))
  add(query_568375, "$filter", newJString(Filter))
  result = call_568373.call(path_568374, query_568375, nil, nil, nil)

var dedicatedCloudNodeListByResourceGroup* = Call_DedicatedCloudNodeListByResourceGroup_568363(
    name: "dedicatedCloudNodeListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes",
    validator: validate_DedicatedCloudNodeListByResourceGroup_568364, base: "",
    url: url_DedicatedCloudNodeListByResourceGroup_568365, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeCreateOrUpdate_568385 = ref object of OpenApiRestCall_567668
proc url_DedicatedCloudNodeCreateOrUpdate_568387(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dedicatedCloudNodeName" in path,
        "`dedicatedCloudNodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes/"),
               (kind: VariableSegment, value: "dedicatedCloudNodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedCloudNodeCreateOrUpdate_568386(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns dedicated cloud node by its name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   dedicatedCloudNodeName: JString (required)
  ##                         : dedicated cloud node name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568405 = path.getOrDefault("resourceGroupName")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "resourceGroupName", valid_568405
  var valid_568406 = path.getOrDefault("subscriptionId")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "subscriptionId", valid_568406
  var valid_568407 = path.getOrDefault("dedicatedCloudNodeName")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "dedicatedCloudNodeName", valid_568407
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568408 = query.getOrDefault("api-version")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "api-version", valid_568408
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_568409 = header.getOrDefault("Referer")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "Referer", valid_568409
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dedicatedCloudNodeRequest: JObject (required)
  ##                            : Create Dedicated Cloud Node request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568411: Call_DedicatedCloudNodeCreateOrUpdate_568385;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns dedicated cloud node by its name
  ## 
  let valid = call_568411.validator(path, query, header, formData, body)
  let scheme = call_568411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568411.url(scheme.get, call_568411.host, call_568411.base,
                         call_568411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568411, url, valid)

proc call*(call_568412: Call_DedicatedCloudNodeCreateOrUpdate_568385;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dedicatedCloudNodeRequest: JsonNode; dedicatedCloudNodeName: string): Recallable =
  ## dedicatedCloudNodeCreateOrUpdate
  ## Returns dedicated cloud node by its name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   dedicatedCloudNodeRequest: JObject (required)
  ##                            : Create Dedicated Cloud Node request
  ##   dedicatedCloudNodeName: string (required)
  ##                         : dedicated cloud node name
  var path_568413 = newJObject()
  var query_568414 = newJObject()
  var body_568415 = newJObject()
  add(path_568413, "resourceGroupName", newJString(resourceGroupName))
  add(query_568414, "api-version", newJString(apiVersion))
  add(path_568413, "subscriptionId", newJString(subscriptionId))
  if dedicatedCloudNodeRequest != nil:
    body_568415 = dedicatedCloudNodeRequest
  add(path_568413, "dedicatedCloudNodeName", newJString(dedicatedCloudNodeName))
  result = call_568412.call(path_568413, query_568414, nil, nil, body_568415)

var dedicatedCloudNodeCreateOrUpdate* = Call_DedicatedCloudNodeCreateOrUpdate_568385(
    name: "dedicatedCloudNodeCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes/{dedicatedCloudNodeName}",
    validator: validate_DedicatedCloudNodeCreateOrUpdate_568386, base: "",
    url: url_DedicatedCloudNodeCreateOrUpdate_568387, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeGet_568376 = ref object of OpenApiRestCall_567668
proc url_DedicatedCloudNodeGet_568378(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dedicatedCloudNodeName" in path,
        "`dedicatedCloudNodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes/"),
               (kind: VariableSegment, value: "dedicatedCloudNodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedCloudNodeGet_568377(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns dedicated cloud node
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   dedicatedCloudNodeName: JString (required)
  ##                         : dedicated cloud node name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568379 = path.getOrDefault("resourceGroupName")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "resourceGroupName", valid_568379
  var valid_568380 = path.getOrDefault("subscriptionId")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "subscriptionId", valid_568380
  var valid_568381 = path.getOrDefault("dedicatedCloudNodeName")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "dedicatedCloudNodeName", valid_568381
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568382: Call_DedicatedCloudNodeGet_568376; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns dedicated cloud node
  ## 
  let valid = call_568382.validator(path, query, header, formData, body)
  let scheme = call_568382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568382.url(scheme.get, call_568382.host, call_568382.base,
                         call_568382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568382, url, valid)

proc call*(call_568383: Call_DedicatedCloudNodeGet_568376;
          resourceGroupName: string; subscriptionId: string;
          dedicatedCloudNodeName: string): Recallable =
  ## dedicatedCloudNodeGet
  ## Returns dedicated cloud node
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   dedicatedCloudNodeName: string (required)
  ##                         : dedicated cloud node name
  var path_568384 = newJObject()
  add(path_568384, "resourceGroupName", newJString(resourceGroupName))
  add(path_568384, "subscriptionId", newJString(subscriptionId))
  add(path_568384, "dedicatedCloudNodeName", newJString(dedicatedCloudNodeName))
  result = call_568383.call(path_568384, nil, nil, nil, nil)

var dedicatedCloudNodeGet* = Call_DedicatedCloudNodeGet_568376(
    name: "dedicatedCloudNodeGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes/{dedicatedCloudNodeName}",
    validator: validate_DedicatedCloudNodeGet_568377, base: "",
    url: url_DedicatedCloudNodeGet_568378, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeUpdate_568427 = ref object of OpenApiRestCall_567668
proc url_DedicatedCloudNodeUpdate_568429(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dedicatedCloudNodeName" in path,
        "`dedicatedCloudNodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes/"),
               (kind: VariableSegment, value: "dedicatedCloudNodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedCloudNodeUpdate_568428(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches dedicated node properties
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   dedicatedCloudNodeName: JString (required)
  ##                         : dedicated cloud node name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568430 = path.getOrDefault("resourceGroupName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "resourceGroupName", valid_568430
  var valid_568431 = path.getOrDefault("subscriptionId")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "subscriptionId", valid_568431
  var valid_568432 = path.getOrDefault("dedicatedCloudNodeName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "dedicatedCloudNodeName", valid_568432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568433 = query.getOrDefault("api-version")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "api-version", valid_568433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dedicatedCloudNodeRequest: JObject (required)
  ##                            : Patch Dedicated Cloud Node request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568435: Call_DedicatedCloudNodeUpdate_568427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches dedicated node properties
  ## 
  let valid = call_568435.validator(path, query, header, formData, body)
  let scheme = call_568435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568435.url(scheme.get, call_568435.host, call_568435.base,
                         call_568435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568435, url, valid)

proc call*(call_568436: Call_DedicatedCloudNodeUpdate_568427;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dedicatedCloudNodeRequest: JsonNode; dedicatedCloudNodeName: string): Recallable =
  ## dedicatedCloudNodeUpdate
  ## Patches dedicated node properties
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   dedicatedCloudNodeRequest: JObject (required)
  ##                            : Patch Dedicated Cloud Node request
  ##   dedicatedCloudNodeName: string (required)
  ##                         : dedicated cloud node name
  var path_568437 = newJObject()
  var query_568438 = newJObject()
  var body_568439 = newJObject()
  add(path_568437, "resourceGroupName", newJString(resourceGroupName))
  add(query_568438, "api-version", newJString(apiVersion))
  add(path_568437, "subscriptionId", newJString(subscriptionId))
  if dedicatedCloudNodeRequest != nil:
    body_568439 = dedicatedCloudNodeRequest
  add(path_568437, "dedicatedCloudNodeName", newJString(dedicatedCloudNodeName))
  result = call_568436.call(path_568437, query_568438, nil, nil, body_568439)

var dedicatedCloudNodeUpdate* = Call_DedicatedCloudNodeUpdate_568427(
    name: "dedicatedCloudNodeUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes/{dedicatedCloudNodeName}",
    validator: validate_DedicatedCloudNodeUpdate_568428, base: "",
    url: url_DedicatedCloudNodeUpdate_568429, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeDelete_568416 = ref object of OpenApiRestCall_567668
proc url_DedicatedCloudNodeDelete_568418(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dedicatedCloudNodeName" in path,
        "`dedicatedCloudNodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes/"),
               (kind: VariableSegment, value: "dedicatedCloudNodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedCloudNodeDelete_568417(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete dedicated cloud node
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   dedicatedCloudNodeName: JString (required)
  ##                         : dedicated cloud node name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568419 = path.getOrDefault("resourceGroupName")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "resourceGroupName", valid_568419
  var valid_568420 = path.getOrDefault("subscriptionId")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "subscriptionId", valid_568420
  var valid_568421 = path.getOrDefault("dedicatedCloudNodeName")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "dedicatedCloudNodeName", valid_568421
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568422 = query.getOrDefault("api-version")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "api-version", valid_568422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568423: Call_DedicatedCloudNodeDelete_568416; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete dedicated cloud node
  ## 
  let valid = call_568423.validator(path, query, header, formData, body)
  let scheme = call_568423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568423.url(scheme.get, call_568423.host, call_568423.base,
                         call_568423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568423, url, valid)

proc call*(call_568424: Call_DedicatedCloudNodeDelete_568416;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dedicatedCloudNodeName: string): Recallable =
  ## dedicatedCloudNodeDelete
  ## Delete dedicated cloud node
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   dedicatedCloudNodeName: string (required)
  ##                         : dedicated cloud node name
  var path_568425 = newJObject()
  var query_568426 = newJObject()
  add(path_568425, "resourceGroupName", newJString(resourceGroupName))
  add(query_568426, "api-version", newJString(apiVersion))
  add(path_568425, "subscriptionId", newJString(subscriptionId))
  add(path_568425, "dedicatedCloudNodeName", newJString(dedicatedCloudNodeName))
  result = call_568424.call(path_568425, query_568426, nil, nil, nil)

var dedicatedCloudNodeDelete* = Call_DedicatedCloudNodeDelete_568416(
    name: "dedicatedCloudNodeDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes/{dedicatedCloudNodeName}",
    validator: validate_DedicatedCloudNodeDelete_568417, base: "",
    url: url_DedicatedCloudNodeDelete_568418, schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceListByResourceGroup_568440 = ref object of OpenApiRestCall_567668
proc url_DedicatedCloudServiceListByResourceGroup_568442(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedCloudServiceListByResourceGroup_568441(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of dedicated cloud service within resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568443 = path.getOrDefault("resourceGroupName")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "resourceGroupName", valid_568443
  var valid_568444 = path.getOrDefault("subscriptionId")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "subscriptionId", valid_568444
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of record sets to return
  ##   $skipToken: JString
  ##             : to be used by nextLink implementation
  ##   $filter: JString
  ##          : The filter to apply on the list operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568445 = query.getOrDefault("api-version")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "api-version", valid_568445
  var valid_568446 = query.getOrDefault("$top")
  valid_568446 = validateParameter(valid_568446, JInt, required = false, default = nil)
  if valid_568446 != nil:
    section.add "$top", valid_568446
  var valid_568447 = query.getOrDefault("$skipToken")
  valid_568447 = validateParameter(valid_568447, JString, required = false,
                                 default = nil)
  if valid_568447 != nil:
    section.add "$skipToken", valid_568447
  var valid_568448 = query.getOrDefault("$filter")
  valid_568448 = validateParameter(valid_568448, JString, required = false,
                                 default = nil)
  if valid_568448 != nil:
    section.add "$filter", valid_568448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568449: Call_DedicatedCloudServiceListByResourceGroup_568440;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of dedicated cloud service within resource group
  ## 
  let valid = call_568449.validator(path, query, header, formData, body)
  let scheme = call_568449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568449.url(scheme.get, call_568449.host, call_568449.base,
                         call_568449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568449, url, valid)

proc call*(call_568450: Call_DedicatedCloudServiceListByResourceGroup_568440;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; SkipToken: string = ""; Filter: string = ""): Recallable =
  ## dedicatedCloudServiceListByResourceGroup
  ## Returns list of dedicated cloud service within resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of record sets to return
  ##   SkipToken: string
  ##            : to be used by nextLink implementation
  ##   Filter: string
  ##         : The filter to apply on the list operation
  var path_568451 = newJObject()
  var query_568452 = newJObject()
  add(path_568451, "resourceGroupName", newJString(resourceGroupName))
  add(query_568452, "api-version", newJString(apiVersion))
  add(path_568451, "subscriptionId", newJString(subscriptionId))
  add(query_568452, "$top", newJInt(Top))
  add(query_568452, "$skipToken", newJString(SkipToken))
  add(query_568452, "$filter", newJString(Filter))
  result = call_568450.call(path_568451, query_568452, nil, nil, nil)

var dedicatedCloudServiceListByResourceGroup* = Call_DedicatedCloudServiceListByResourceGroup_568440(
    name: "dedicatedCloudServiceListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices",
    validator: validate_DedicatedCloudServiceListByResourceGroup_568441, base: "",
    url: url_DedicatedCloudServiceListByResourceGroup_568442,
    schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceCreateOrUpdate_568464 = ref object of OpenApiRestCall_567668
proc url_DedicatedCloudServiceCreateOrUpdate_568466(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dedicatedCloudServiceName" in path,
        "`dedicatedCloudServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices/"),
               (kind: VariableSegment, value: "dedicatedCloudServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedCloudServiceCreateOrUpdate_568465(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create dedicate cloud service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   dedicatedCloudServiceName: JString (required)
  ##                            : dedicated cloud Service name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568467 = path.getOrDefault("resourceGroupName")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "resourceGroupName", valid_568467
  var valid_568468 = path.getOrDefault("subscriptionId")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "subscriptionId", valid_568468
  var valid_568469 = path.getOrDefault("dedicatedCloudServiceName")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "dedicatedCloudServiceName", valid_568469
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568470 = query.getOrDefault("api-version")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "api-version", valid_568470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dedicatedCloudServiceRequest: JObject (required)
  ##                               : Create Dedicated Cloud Service request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568472: Call_DedicatedCloudServiceCreateOrUpdate_568464;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create dedicate cloud service
  ## 
  let valid = call_568472.validator(path, query, header, formData, body)
  let scheme = call_568472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568472.url(scheme.get, call_568472.host, call_568472.base,
                         call_568472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568472, url, valid)

proc call*(call_568473: Call_DedicatedCloudServiceCreateOrUpdate_568464;
          resourceGroupName: string; apiVersion: string;
          dedicatedCloudServiceRequest: JsonNode; subscriptionId: string;
          dedicatedCloudServiceName: string): Recallable =
  ## dedicatedCloudServiceCreateOrUpdate
  ## Create dedicate cloud service
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   dedicatedCloudServiceRequest: JObject (required)
  ##                               : Create Dedicated Cloud Service request
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   dedicatedCloudServiceName: string (required)
  ##                            : dedicated cloud Service name
  var path_568474 = newJObject()
  var query_568475 = newJObject()
  var body_568476 = newJObject()
  add(path_568474, "resourceGroupName", newJString(resourceGroupName))
  add(query_568475, "api-version", newJString(apiVersion))
  if dedicatedCloudServiceRequest != nil:
    body_568476 = dedicatedCloudServiceRequest
  add(path_568474, "subscriptionId", newJString(subscriptionId))
  add(path_568474, "dedicatedCloudServiceName",
      newJString(dedicatedCloudServiceName))
  result = call_568473.call(path_568474, query_568475, nil, nil, body_568476)

var dedicatedCloudServiceCreateOrUpdate* = Call_DedicatedCloudServiceCreateOrUpdate_568464(
    name: "dedicatedCloudServiceCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices/{dedicatedCloudServiceName}",
    validator: validate_DedicatedCloudServiceCreateOrUpdate_568465, base: "",
    url: url_DedicatedCloudServiceCreateOrUpdate_568466, schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceGet_568453 = ref object of OpenApiRestCall_567668
proc url_DedicatedCloudServiceGet_568455(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dedicatedCloudServiceName" in path,
        "`dedicatedCloudServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices/"),
               (kind: VariableSegment, value: "dedicatedCloudServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedCloudServiceGet_568454(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns Dedicate Cloud Service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   dedicatedCloudServiceName: JString (required)
  ##                            : dedicated cloud Service name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568456 = path.getOrDefault("resourceGroupName")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "resourceGroupName", valid_568456
  var valid_568457 = path.getOrDefault("subscriptionId")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "subscriptionId", valid_568457
  var valid_568458 = path.getOrDefault("dedicatedCloudServiceName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "dedicatedCloudServiceName", valid_568458
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568459 = query.getOrDefault("api-version")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "api-version", valid_568459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568460: Call_DedicatedCloudServiceGet_568453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Dedicate Cloud Service
  ## 
  let valid = call_568460.validator(path, query, header, formData, body)
  let scheme = call_568460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568460.url(scheme.get, call_568460.host, call_568460.base,
                         call_568460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568460, url, valid)

proc call*(call_568461: Call_DedicatedCloudServiceGet_568453;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dedicatedCloudServiceName: string): Recallable =
  ## dedicatedCloudServiceGet
  ## Returns Dedicate Cloud Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   dedicatedCloudServiceName: string (required)
  ##                            : dedicated cloud Service name
  var path_568462 = newJObject()
  var query_568463 = newJObject()
  add(path_568462, "resourceGroupName", newJString(resourceGroupName))
  add(query_568463, "api-version", newJString(apiVersion))
  add(path_568462, "subscriptionId", newJString(subscriptionId))
  add(path_568462, "dedicatedCloudServiceName",
      newJString(dedicatedCloudServiceName))
  result = call_568461.call(path_568462, query_568463, nil, nil, nil)

var dedicatedCloudServiceGet* = Call_DedicatedCloudServiceGet_568453(
    name: "dedicatedCloudServiceGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices/{dedicatedCloudServiceName}",
    validator: validate_DedicatedCloudServiceGet_568454, base: "",
    url: url_DedicatedCloudServiceGet_568455, schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceUpdate_568488 = ref object of OpenApiRestCall_567668
proc url_DedicatedCloudServiceUpdate_568490(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dedicatedCloudServiceName" in path,
        "`dedicatedCloudServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices/"),
               (kind: VariableSegment, value: "dedicatedCloudServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedCloudServiceUpdate_568489(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch dedicated cloud service's properties
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   dedicatedCloudServiceName: JString (required)
  ##                            : dedicated cloud service name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568491 = path.getOrDefault("resourceGroupName")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "resourceGroupName", valid_568491
  var valid_568492 = path.getOrDefault("subscriptionId")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "subscriptionId", valid_568492
  var valid_568493 = path.getOrDefault("dedicatedCloudServiceName")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "dedicatedCloudServiceName", valid_568493
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568494 = query.getOrDefault("api-version")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "api-version", valid_568494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dedicatedCloudServiceRequest: JObject (required)
  ##                               : Patch Dedicated Cloud Service request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568496: Call_DedicatedCloudServiceUpdate_568488; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch dedicated cloud service's properties
  ## 
  let valid = call_568496.validator(path, query, header, formData, body)
  let scheme = call_568496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568496.url(scheme.get, call_568496.host, call_568496.base,
                         call_568496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568496, url, valid)

proc call*(call_568497: Call_DedicatedCloudServiceUpdate_568488;
          resourceGroupName: string; apiVersion: string;
          dedicatedCloudServiceRequest: JsonNode; subscriptionId: string;
          dedicatedCloudServiceName: string): Recallable =
  ## dedicatedCloudServiceUpdate
  ## Patch dedicated cloud service's properties
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   dedicatedCloudServiceRequest: JObject (required)
  ##                               : Patch Dedicated Cloud Service request
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   dedicatedCloudServiceName: string (required)
  ##                            : dedicated cloud service name
  var path_568498 = newJObject()
  var query_568499 = newJObject()
  var body_568500 = newJObject()
  add(path_568498, "resourceGroupName", newJString(resourceGroupName))
  add(query_568499, "api-version", newJString(apiVersion))
  if dedicatedCloudServiceRequest != nil:
    body_568500 = dedicatedCloudServiceRequest
  add(path_568498, "subscriptionId", newJString(subscriptionId))
  add(path_568498, "dedicatedCloudServiceName",
      newJString(dedicatedCloudServiceName))
  result = call_568497.call(path_568498, query_568499, nil, nil, body_568500)

var dedicatedCloudServiceUpdate* = Call_DedicatedCloudServiceUpdate_568488(
    name: "dedicatedCloudServiceUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices/{dedicatedCloudServiceName}",
    validator: validate_DedicatedCloudServiceUpdate_568489, base: "",
    url: url_DedicatedCloudServiceUpdate_568490, schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceDelete_568477 = ref object of OpenApiRestCall_567668
proc url_DedicatedCloudServiceDelete_568479(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dedicatedCloudServiceName" in path,
        "`dedicatedCloudServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices/"),
               (kind: VariableSegment, value: "dedicatedCloudServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedCloudServiceDelete_568478(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete dedicate cloud service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   dedicatedCloudServiceName: JString (required)
  ##                            : dedicated cloud service name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568480 = path.getOrDefault("resourceGroupName")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "resourceGroupName", valid_568480
  var valid_568481 = path.getOrDefault("subscriptionId")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "subscriptionId", valid_568481
  var valid_568482 = path.getOrDefault("dedicatedCloudServiceName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "dedicatedCloudServiceName", valid_568482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568483 = query.getOrDefault("api-version")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "api-version", valid_568483
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568484: Call_DedicatedCloudServiceDelete_568477; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete dedicate cloud service
  ## 
  let valid = call_568484.validator(path, query, header, formData, body)
  let scheme = call_568484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568484.url(scheme.get, call_568484.host, call_568484.base,
                         call_568484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568484, url, valid)

proc call*(call_568485: Call_DedicatedCloudServiceDelete_568477;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dedicatedCloudServiceName: string): Recallable =
  ## dedicatedCloudServiceDelete
  ## Delete dedicate cloud service
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   dedicatedCloudServiceName: string (required)
  ##                            : dedicated cloud service name
  var path_568486 = newJObject()
  var query_568487 = newJObject()
  add(path_568486, "resourceGroupName", newJString(resourceGroupName))
  add(query_568487, "api-version", newJString(apiVersion))
  add(path_568486, "subscriptionId", newJString(subscriptionId))
  add(path_568486, "dedicatedCloudServiceName",
      newJString(dedicatedCloudServiceName))
  result = call_568485.call(path_568486, query_568487, nil, nil, nil)

var dedicatedCloudServiceDelete* = Call_DedicatedCloudServiceDelete_568477(
    name: "dedicatedCloudServiceDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices/{dedicatedCloudServiceName}",
    validator: validate_DedicatedCloudServiceDelete_568478, base: "",
    url: url_DedicatedCloudServiceDelete_568479, schemes: {Scheme.Https})
type
  Call_VirtualMachineListByResourceGroup_568501 = ref object of OpenApiRestCall_567668
proc url_VirtualMachineListByResourceGroup_568503(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/virtualMachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineListByResourceGroup_568502(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of virtual machine within resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568504 = path.getOrDefault("resourceGroupName")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "resourceGroupName", valid_568504
  var valid_568505 = path.getOrDefault("subscriptionId")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "subscriptionId", valid_568505
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of record sets to return
  ##   $skipToken: JString
  ##             : to be used by nextLink implementation
  ##   $filter: JString
  ##          : The filter to apply on the list operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568506 = query.getOrDefault("api-version")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "api-version", valid_568506
  var valid_568507 = query.getOrDefault("$top")
  valid_568507 = validateParameter(valid_568507, JInt, required = false, default = nil)
  if valid_568507 != nil:
    section.add "$top", valid_568507
  var valid_568508 = query.getOrDefault("$skipToken")
  valid_568508 = validateParameter(valid_568508, JString, required = false,
                                 default = nil)
  if valid_568508 != nil:
    section.add "$skipToken", valid_568508
  var valid_568509 = query.getOrDefault("$filter")
  valid_568509 = validateParameter(valid_568509, JString, required = false,
                                 default = nil)
  if valid_568509 != nil:
    section.add "$filter", valid_568509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568510: Call_VirtualMachineListByResourceGroup_568501;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of virtual machine within resource group
  ## 
  let valid = call_568510.validator(path, query, header, formData, body)
  let scheme = call_568510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568510.url(scheme.get, call_568510.host, call_568510.base,
                         call_568510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568510, url, valid)

proc call*(call_568511: Call_VirtualMachineListByResourceGroup_568501;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; SkipToken: string = ""; Filter: string = ""): Recallable =
  ## virtualMachineListByResourceGroup
  ## Returns list of virtual machine within resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of record sets to return
  ##   SkipToken: string
  ##            : to be used by nextLink implementation
  ##   Filter: string
  ##         : The filter to apply on the list operation
  var path_568512 = newJObject()
  var query_568513 = newJObject()
  add(path_568512, "resourceGroupName", newJString(resourceGroupName))
  add(query_568513, "api-version", newJString(apiVersion))
  add(path_568512, "subscriptionId", newJString(subscriptionId))
  add(query_568513, "$top", newJInt(Top))
  add(query_568513, "$skipToken", newJString(SkipToken))
  add(query_568513, "$filter", newJString(Filter))
  result = call_568511.call(path_568512, query_568513, nil, nil, nil)

var virtualMachineListByResourceGroup* = Call_VirtualMachineListByResourceGroup_568501(
    name: "virtualMachineListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines",
    validator: validate_VirtualMachineListByResourceGroup_568502, base: "",
    url: url_VirtualMachineListByResourceGroup_568503, schemes: {Scheme.Https})
type
  Call_VirtualMachineCreateOrUpdate_568525 = ref object of OpenApiRestCall_567668
proc url_VirtualMachineCreateOrUpdate_568527(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/virtualMachines/"),
               (kind: VariableSegment, value: "virtualMachineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineCreateOrUpdate_568526(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create Or Update Virtual Machine
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   virtualMachineName: JString (required)
  ##                     : virtual machine name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568528 = path.getOrDefault("resourceGroupName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "resourceGroupName", valid_568528
  var valid_568529 = path.getOrDefault("virtualMachineName")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "virtualMachineName", valid_568529
  var valid_568530 = path.getOrDefault("subscriptionId")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "subscriptionId", valid_568530
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568531 = query.getOrDefault("api-version")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "api-version", valid_568531
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_568532 = header.getOrDefault("Referer")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "Referer", valid_568532
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   virtualMachineRequest: JObject (required)
  ##                        : Create or Update Virtual Machine request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568534: Call_VirtualMachineCreateOrUpdate_568525; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create Or Update Virtual Machine
  ## 
  let valid = call_568534.validator(path, query, header, formData, body)
  let scheme = call_568534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568534.url(scheme.get, call_568534.host, call_568534.base,
                         call_568534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568534, url, valid)

proc call*(call_568535: Call_VirtualMachineCreateOrUpdate_568525;
          resourceGroupName: string; apiVersion: string; virtualMachineName: string;
          subscriptionId: string; virtualMachineRequest: JsonNode): Recallable =
  ## virtualMachineCreateOrUpdate
  ## Create Or Update Virtual Machine
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : virtual machine name
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   virtualMachineRequest: JObject (required)
  ##                        : Create or Update Virtual Machine request
  var path_568536 = newJObject()
  var query_568537 = newJObject()
  var body_568538 = newJObject()
  add(path_568536, "resourceGroupName", newJString(resourceGroupName))
  add(query_568537, "api-version", newJString(apiVersion))
  add(path_568536, "virtualMachineName", newJString(virtualMachineName))
  add(path_568536, "subscriptionId", newJString(subscriptionId))
  if virtualMachineRequest != nil:
    body_568538 = virtualMachineRequest
  result = call_568535.call(path_568536, query_568537, nil, nil, body_568538)

var virtualMachineCreateOrUpdate* = Call_VirtualMachineCreateOrUpdate_568525(
    name: "virtualMachineCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}",
    validator: validate_VirtualMachineCreateOrUpdate_568526, base: "",
    url: url_VirtualMachineCreateOrUpdate_568527, schemes: {Scheme.Https})
type
  Call_VirtualMachineGet_568514 = ref object of OpenApiRestCall_567668
proc url_VirtualMachineGet_568516(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/virtualMachines/"),
               (kind: VariableSegment, value: "virtualMachineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineGet_568515(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get virtual machine
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   virtualMachineName: JString (required)
  ##                     : virtual machine name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568517 = path.getOrDefault("resourceGroupName")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "resourceGroupName", valid_568517
  var valid_568518 = path.getOrDefault("virtualMachineName")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "virtualMachineName", valid_568518
  var valid_568519 = path.getOrDefault("subscriptionId")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "subscriptionId", valid_568519
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568520 = query.getOrDefault("api-version")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "api-version", valid_568520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568521: Call_VirtualMachineGet_568514; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual machine
  ## 
  let valid = call_568521.validator(path, query, header, formData, body)
  let scheme = call_568521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568521.url(scheme.get, call_568521.host, call_568521.base,
                         call_568521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568521, url, valid)

proc call*(call_568522: Call_VirtualMachineGet_568514; resourceGroupName: string;
          apiVersion: string; virtualMachineName: string; subscriptionId: string): Recallable =
  ## virtualMachineGet
  ## Get virtual machine
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : virtual machine name
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_568523 = newJObject()
  var query_568524 = newJObject()
  add(path_568523, "resourceGroupName", newJString(resourceGroupName))
  add(query_568524, "api-version", newJString(apiVersion))
  add(path_568523, "virtualMachineName", newJString(virtualMachineName))
  add(path_568523, "subscriptionId", newJString(subscriptionId))
  result = call_568522.call(path_568523, query_568524, nil, nil, nil)

var virtualMachineGet* = Call_VirtualMachineGet_568514(name: "virtualMachineGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}",
    validator: validate_VirtualMachineGet_568515, base: "",
    url: url_VirtualMachineGet_568516, schemes: {Scheme.Https})
type
  Call_VirtualMachineUpdate_568551 = ref object of OpenApiRestCall_567668
proc url_VirtualMachineUpdate_568553(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/virtualMachines/"),
               (kind: VariableSegment, value: "virtualMachineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineUpdate_568552(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch virtual machine properties
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   virtualMachineName: JString (required)
  ##                     : virtual machine name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568554 = path.getOrDefault("resourceGroupName")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "resourceGroupName", valid_568554
  var valid_568555 = path.getOrDefault("virtualMachineName")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "virtualMachineName", valid_568555
  var valid_568556 = path.getOrDefault("subscriptionId")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "subscriptionId", valid_568556
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568557 = query.getOrDefault("api-version")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "api-version", valid_568557
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   virtualMachineRequest: JObject (required)
  ##                        : Patch virtual machine request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568559: Call_VirtualMachineUpdate_568551; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch virtual machine properties
  ## 
  let valid = call_568559.validator(path, query, header, formData, body)
  let scheme = call_568559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568559.url(scheme.get, call_568559.host, call_568559.base,
                         call_568559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568559, url, valid)

proc call*(call_568560: Call_VirtualMachineUpdate_568551;
          resourceGroupName: string; apiVersion: string; virtualMachineName: string;
          subscriptionId: string; virtualMachineRequest: JsonNode): Recallable =
  ## virtualMachineUpdate
  ## Patch virtual machine properties
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : virtual machine name
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   virtualMachineRequest: JObject (required)
  ##                        : Patch virtual machine request
  var path_568561 = newJObject()
  var query_568562 = newJObject()
  var body_568563 = newJObject()
  add(path_568561, "resourceGroupName", newJString(resourceGroupName))
  add(query_568562, "api-version", newJString(apiVersion))
  add(path_568561, "virtualMachineName", newJString(virtualMachineName))
  add(path_568561, "subscriptionId", newJString(subscriptionId))
  if virtualMachineRequest != nil:
    body_568563 = virtualMachineRequest
  result = call_568560.call(path_568561, query_568562, nil, nil, body_568563)

var virtualMachineUpdate* = Call_VirtualMachineUpdate_568551(
    name: "virtualMachineUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}",
    validator: validate_VirtualMachineUpdate_568552, base: "",
    url: url_VirtualMachineUpdate_568553, schemes: {Scheme.Https})
type
  Call_VirtualMachineDelete_568539 = ref object of OpenApiRestCall_567668
proc url_VirtualMachineDelete_568541(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/virtualMachines/"),
               (kind: VariableSegment, value: "virtualMachineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineDelete_568540(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete virtual machine
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   virtualMachineName: JString (required)
  ##                     : virtual machine name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568542 = path.getOrDefault("resourceGroupName")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "resourceGroupName", valid_568542
  var valid_568543 = path.getOrDefault("virtualMachineName")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "virtualMachineName", valid_568543
  var valid_568544 = path.getOrDefault("subscriptionId")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "subscriptionId", valid_568544
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568545 = query.getOrDefault("api-version")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "api-version", valid_568545
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_568546 = header.getOrDefault("Referer")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "Referer", valid_568546
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568547: Call_VirtualMachineDelete_568539; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual machine
  ## 
  let valid = call_568547.validator(path, query, header, formData, body)
  let scheme = call_568547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568547.url(scheme.get, call_568547.host, call_568547.base,
                         call_568547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568547, url, valid)

proc call*(call_568548: Call_VirtualMachineDelete_568539;
          resourceGroupName: string; apiVersion: string; virtualMachineName: string;
          subscriptionId: string): Recallable =
  ## virtualMachineDelete
  ## Delete virtual machine
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : virtual machine name
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_568549 = newJObject()
  var query_568550 = newJObject()
  add(path_568549, "resourceGroupName", newJString(resourceGroupName))
  add(query_568550, "api-version", newJString(apiVersion))
  add(path_568549, "virtualMachineName", newJString(virtualMachineName))
  add(path_568549, "subscriptionId", newJString(subscriptionId))
  result = call_568548.call(path_568549, query_568550, nil, nil, nil)

var virtualMachineDelete* = Call_VirtualMachineDelete_568539(
    name: "virtualMachineDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}",
    validator: validate_VirtualMachineDelete_568540, base: "",
    url: url_VirtualMachineDelete_568541, schemes: {Scheme.Https})
type
  Call_VirtualMachineStart_568564 = ref object of OpenApiRestCall_567668
proc url_VirtualMachineStart_568566(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/virtualMachines/"),
               (kind: VariableSegment, value: "virtualMachineName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineStart_568565(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Power on virtual machine
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   virtualMachineName: JString (required)
  ##                     : virtual machine name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568567 = path.getOrDefault("resourceGroupName")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "resourceGroupName", valid_568567
  var valid_568568 = path.getOrDefault("virtualMachineName")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "virtualMachineName", valid_568568
  var valid_568569 = path.getOrDefault("subscriptionId")
  valid_568569 = validateParameter(valid_568569, JString, required = true,
                                 default = nil)
  if valid_568569 != nil:
    section.add "subscriptionId", valid_568569
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568570 = query.getOrDefault("api-version")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "api-version", valid_568570
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_568571 = header.getOrDefault("Referer")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "Referer", valid_568571
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568572: Call_VirtualMachineStart_568564; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Power on virtual machine
  ## 
  let valid = call_568572.validator(path, query, header, formData, body)
  let scheme = call_568572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568572.url(scheme.get, call_568572.host, call_568572.base,
                         call_568572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568572, url, valid)

proc call*(call_568573: Call_VirtualMachineStart_568564; resourceGroupName: string;
          apiVersion: string; virtualMachineName: string; subscriptionId: string): Recallable =
  ## virtualMachineStart
  ## Power on virtual machine
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : virtual machine name
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_568574 = newJObject()
  var query_568575 = newJObject()
  add(path_568574, "resourceGroupName", newJString(resourceGroupName))
  add(query_568575, "api-version", newJString(apiVersion))
  add(path_568574, "virtualMachineName", newJString(virtualMachineName))
  add(path_568574, "subscriptionId", newJString(subscriptionId))
  result = call_568573.call(path_568574, query_568575, nil, nil, nil)

var virtualMachineStart* = Call_VirtualMachineStart_568564(
    name: "virtualMachineStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}/start",
    validator: validate_VirtualMachineStart_568565, base: "",
    url: url_VirtualMachineStart_568566, schemes: {Scheme.Https})
type
  Call_VirtualMachineStop_568576 = ref object of OpenApiRestCall_567668
proc url_VirtualMachineStop_568578(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.VMwareCloudSimple/virtualMachines/"),
               (kind: VariableSegment, value: "virtualMachineName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineStop_568577(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Power off virtual machine, options: shutdown, poweroff, and suspend
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   virtualMachineName: JString (required)
  ##                     : virtual machine name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568579 = path.getOrDefault("resourceGroupName")
  valid_568579 = validateParameter(valid_568579, JString, required = true,
                                 default = nil)
  if valid_568579 != nil:
    section.add "resourceGroupName", valid_568579
  var valid_568580 = path.getOrDefault("virtualMachineName")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "virtualMachineName", valid_568580
  var valid_568581 = path.getOrDefault("subscriptionId")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "subscriptionId", valid_568581
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   mode: JString
  ##       : query stop mode parameter (reboot, shutdown, etc...)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568582 = query.getOrDefault("api-version")
  valid_568582 = validateParameter(valid_568582, JString, required = true,
                                 default = nil)
  if valid_568582 != nil:
    section.add "api-version", valid_568582
  var valid_568596 = query.getOrDefault("mode")
  valid_568596 = validateParameter(valid_568596, JString, required = false,
                                 default = newJString("reboot"))
  if valid_568596 != nil:
    section.add "mode", valid_568596
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_568597 = header.getOrDefault("Referer")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "Referer", valid_568597
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   m: JObject
  ##    : body stop mode parameter (reboot, shutdown, etc...)
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568599: Call_VirtualMachineStop_568576; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Power off virtual machine, options: shutdown, poweroff, and suspend
  ## 
  let valid = call_568599.validator(path, query, header, formData, body)
  let scheme = call_568599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568599.url(scheme.get, call_568599.host, call_568599.base,
                         call_568599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568599, url, valid)

proc call*(call_568600: Call_VirtualMachineStop_568576; resourceGroupName: string;
          apiVersion: string; virtualMachineName: string; subscriptionId: string;
          m: JsonNode = nil; mode: string = "reboot"): Recallable =
  ## virtualMachineStop
  ## Power off virtual machine, options: shutdown, poweroff, and suspend
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : virtual machine name
  ##   m: JObject
  ##    : body stop mode parameter (reboot, shutdown, etc...)
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   mode: string
  ##       : query stop mode parameter (reboot, shutdown, etc...)
  var path_568601 = newJObject()
  var query_568602 = newJObject()
  var body_568603 = newJObject()
  add(path_568601, "resourceGroupName", newJString(resourceGroupName))
  add(query_568602, "api-version", newJString(apiVersion))
  add(path_568601, "virtualMachineName", newJString(virtualMachineName))
  if m != nil:
    body_568603 = m
  add(path_568601, "subscriptionId", newJString(subscriptionId))
  add(query_568602, "mode", newJString(mode))
  result = call_568600.call(path_568601, query_568602, nil, nil, body_568603)

var virtualMachineStop* = Call_VirtualMachineStop_568576(
    name: "virtualMachineStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}/stop",
    validator: validate_VirtualMachineStop_568577, base: "",
    url: url_VirtualMachineStop_568578, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
