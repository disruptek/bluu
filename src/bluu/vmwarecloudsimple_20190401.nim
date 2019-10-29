
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563566 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563566](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563566): Option[Scheme] {.used.} =
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
  macServiceName = "vmwarecloudsimple"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AvailableOperationsList_563788 = ref object of OpenApiRestCall_563566
proc url_AvailableOperationsList_563790(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AvailableOperationsList_563789(path: JsonNode; query: JsonNode;
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
  var valid_563951 = query.getOrDefault("api-version")
  valid_563951 = validateParameter(valid_563951, JString, required = true,
                                 default = nil)
  if valid_563951 != nil:
    section.add "api-version", valid_563951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563974: Call_AvailableOperationsList_563788; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return list of operations
  ## 
  let valid = call_563974.validator(path, query, header, formData, body)
  let scheme = call_563974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563974.url(scheme.get, call_563974.host, call_563974.base,
                         call_563974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563974, url, valid)

proc call*(call_564045: Call_AvailableOperationsList_563788; apiVersion: string): Recallable =
  ## availableOperationsList
  ## Return list of operations
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_564046 = newJObject()
  add(query_564046, "api-version", newJString(apiVersion))
  result = call_564045.call(nil, query_564046, nil, nil, nil)

var availableOperationsList* = Call_AvailableOperationsList_563788(
    name: "availableOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.VMwareCloudSimple/operations",
    validator: validate_AvailableOperationsList_563789, base: "",
    url: url_AvailableOperationsList_563790, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeListBySubscription_564086 = ref object of OpenApiRestCall_563566
proc url_DedicatedCloudNodeListBySubscription_564088(protocol: Scheme;
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

proc validate_DedicatedCloudNodeListBySubscription_564087(path: JsonNode;
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
  var valid_564104 = path.getOrDefault("subscriptionId")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "subscriptionId", valid_564104
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : to be used by nextLink implementation
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of record sets to return
  ##   $filter: JString
  ##          : The filter to apply on the list operation
  section = newJObject()
  var valid_564105 = query.getOrDefault("$skipToken")
  valid_564105 = validateParameter(valid_564105, JString, required = false,
                                 default = nil)
  if valid_564105 != nil:
    section.add "$skipToken", valid_564105
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564106 = query.getOrDefault("api-version")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "api-version", valid_564106
  var valid_564107 = query.getOrDefault("$top")
  valid_564107 = validateParameter(valid_564107, JInt, required = false, default = nil)
  if valid_564107 != nil:
    section.add "$top", valid_564107
  var valid_564108 = query.getOrDefault("$filter")
  valid_564108 = validateParameter(valid_564108, JString, required = false,
                                 default = nil)
  if valid_564108 != nil:
    section.add "$filter", valid_564108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564109: Call_DedicatedCloudNodeListBySubscription_564086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of dedicate cloud nodes within subscription
  ## 
  let valid = call_564109.validator(path, query, header, formData, body)
  let scheme = call_564109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564109.url(scheme.get, call_564109.host, call_564109.base,
                         call_564109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564109, url, valid)

proc call*(call_564110: Call_DedicatedCloudNodeListBySubscription_564086;
          apiVersion: string; subscriptionId: string; SkipToken: string = "";
          Top: int = 0; Filter: string = ""): Recallable =
  ## dedicatedCloudNodeListBySubscription
  ## Returns list of dedicate cloud nodes within subscription
  ##   SkipToken: string
  ##            : to be used by nextLink implementation
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Top: int
  ##      : The maximum number of record sets to return
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Filter: string
  ##         : The filter to apply on the list operation
  var path_564111 = newJObject()
  var query_564112 = newJObject()
  add(query_564112, "$skipToken", newJString(SkipToken))
  add(query_564112, "api-version", newJString(apiVersion))
  add(query_564112, "$top", newJInt(Top))
  add(path_564111, "subscriptionId", newJString(subscriptionId))
  add(query_564112, "$filter", newJString(Filter))
  result = call_564110.call(path_564111, query_564112, nil, nil, nil)

var dedicatedCloudNodeListBySubscription* = Call_DedicatedCloudNodeListBySubscription_564086(
    name: "dedicatedCloudNodeListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes",
    validator: validate_DedicatedCloudNodeListBySubscription_564087, base: "",
    url: url_DedicatedCloudNodeListBySubscription_564088, schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceListBySubscription_564113 = ref object of OpenApiRestCall_563566
proc url_DedicatedCloudServiceListBySubscription_564115(protocol: Scheme;
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

proc validate_DedicatedCloudServiceListBySubscription_564114(path: JsonNode;
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
  var valid_564116 = path.getOrDefault("subscriptionId")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "subscriptionId", valid_564116
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : to be used by nextLink implementation
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of record sets to return
  ##   $filter: JString
  ##          : The filter to apply on the list operation
  section = newJObject()
  var valid_564117 = query.getOrDefault("$skipToken")
  valid_564117 = validateParameter(valid_564117, JString, required = false,
                                 default = nil)
  if valid_564117 != nil:
    section.add "$skipToken", valid_564117
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564118 = query.getOrDefault("api-version")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "api-version", valid_564118
  var valid_564119 = query.getOrDefault("$top")
  valid_564119 = validateParameter(valid_564119, JInt, required = false, default = nil)
  if valid_564119 != nil:
    section.add "$top", valid_564119
  var valid_564120 = query.getOrDefault("$filter")
  valid_564120 = validateParameter(valid_564120, JString, required = false,
                                 default = nil)
  if valid_564120 != nil:
    section.add "$filter", valid_564120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564121: Call_DedicatedCloudServiceListBySubscription_564113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of dedicated cloud services within a subscription
  ## 
  let valid = call_564121.validator(path, query, header, formData, body)
  let scheme = call_564121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564121.url(scheme.get, call_564121.host, call_564121.base,
                         call_564121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564121, url, valid)

proc call*(call_564122: Call_DedicatedCloudServiceListBySubscription_564113;
          apiVersion: string; subscriptionId: string; SkipToken: string = "";
          Top: int = 0; Filter: string = ""): Recallable =
  ## dedicatedCloudServiceListBySubscription
  ## Returns list of dedicated cloud services within a subscription
  ##   SkipToken: string
  ##            : to be used by nextLink implementation
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Top: int
  ##      : The maximum number of record sets to return
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Filter: string
  ##         : The filter to apply on the list operation
  var path_564123 = newJObject()
  var query_564124 = newJObject()
  add(query_564124, "$skipToken", newJString(SkipToken))
  add(query_564124, "api-version", newJString(apiVersion))
  add(query_564124, "$top", newJInt(Top))
  add(path_564123, "subscriptionId", newJString(subscriptionId))
  add(query_564124, "$filter", newJString(Filter))
  result = call_564122.call(path_564123, query_564124, nil, nil, nil)

var dedicatedCloudServiceListBySubscription* = Call_DedicatedCloudServiceListBySubscription_564113(
    name: "dedicatedCloudServiceListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices",
    validator: validate_DedicatedCloudServiceListBySubscription_564114, base: "",
    url: url_DedicatedCloudServiceListBySubscription_564115,
    schemes: {Scheme.Https})
type
  Call_SkusAvailabilityWithinRegionList_564125 = ref object of OpenApiRestCall_563566
proc url_SkusAvailabilityWithinRegionList_564127(protocol: Scheme; host: string;
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

proc validate_SkusAvailabilityWithinRegionList_564126(path: JsonNode;
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
  var valid_564128 = path.getOrDefault("subscriptionId")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "subscriptionId", valid_564128
  var valid_564129 = path.getOrDefault("regionId")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "regionId", valid_564129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   skuId: JString
  ##        : sku id, if no sku is passed availability for all skus will be returned
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564130 = query.getOrDefault("api-version")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "api-version", valid_564130
  var valid_564131 = query.getOrDefault("skuId")
  valid_564131 = validateParameter(valid_564131, JString, required = false,
                                 default = nil)
  if valid_564131 != nil:
    section.add "skuId", valid_564131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564132: Call_SkusAvailabilityWithinRegionList_564125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of available resources in region
  ## 
  let valid = call_564132.validator(path, query, header, formData, body)
  let scheme = call_564132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564132.url(scheme.get, call_564132.host, call_564132.base,
                         call_564132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564132, url, valid)

proc call*(call_564133: Call_SkusAvailabilityWithinRegionList_564125;
          apiVersion: string; subscriptionId: string; regionId: string;
          skuId: string = ""): Recallable =
  ## skusAvailabilityWithinRegionList
  ## Returns list of available resources in region
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   skuId: string
  ##        : sku id, if no sku is passed availability for all skus will be returned
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_564134 = newJObject()
  var query_564135 = newJObject()
  add(query_564135, "api-version", newJString(apiVersion))
  add(query_564135, "skuId", newJString(skuId))
  add(path_564134, "subscriptionId", newJString(subscriptionId))
  add(path_564134, "regionId", newJString(regionId))
  result = call_564133.call(path_564134, query_564135, nil, nil, nil)

var skusAvailabilityWithinRegionList* = Call_SkusAvailabilityWithinRegionList_564125(
    name: "skusAvailabilityWithinRegionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/availabilities",
    validator: validate_SkusAvailabilityWithinRegionList_564126, base: "",
    url: url_SkusAvailabilityWithinRegionList_564127, schemes: {Scheme.Https})
type
  Call_GetOperationResultByRegion_564136 = ref object of OpenApiRestCall_563566
proc url_GetOperationResultByRegion_564138(protocol: Scheme; host: string;
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

proc validate_GetOperationResultByRegion_564137(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return an async operation
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : operation id
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_564139 = path.getOrDefault("operationId")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "operationId", valid_564139
  var valid_564140 = path.getOrDefault("subscriptionId")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "subscriptionId", valid_564140
  var valid_564141 = path.getOrDefault("regionId")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "regionId", valid_564141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564142 = query.getOrDefault("api-version")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "api-version", valid_564142
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_564143 = header.getOrDefault("Referer")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "Referer", valid_564143
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_GetOperationResultByRegion_564136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return an async operation
  ## 
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_GetOperationResultByRegion_564136; apiVersion: string;
          operationId: string; subscriptionId: string; regionId: string): Recallable =
  ## getOperationResultByRegion
  ## Return an async operation
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   operationId: string (required)
  ##              : operation id
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  add(query_564147, "api-version", newJString(apiVersion))
  add(path_564146, "operationId", newJString(operationId))
  add(path_564146, "subscriptionId", newJString(subscriptionId))
  add(path_564146, "regionId", newJString(regionId))
  result = call_564145.call(path_564146, query_564147, nil, nil, nil)

var getOperationResultByRegion* = Call_GetOperationResultByRegion_564136(
    name: "getOperationResultByRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/operationResults/{operationId}",
    validator: validate_GetOperationResultByRegion_564137, base: "",
    url: url_GetOperationResultByRegion_564138, schemes: {Scheme.Https})
type
  Call_PrivateCloudByRegionList_564148 = ref object of OpenApiRestCall_563566
proc url_PrivateCloudByRegionList_564150(protocol: Scheme; host: string;
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

proc validate_PrivateCloudByRegionList_564149(path: JsonNode; query: JsonNode;
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
  var valid_564151 = path.getOrDefault("subscriptionId")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "subscriptionId", valid_564151
  var valid_564152 = path.getOrDefault("regionId")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "regionId", valid_564152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564153 = query.getOrDefault("api-version")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "api-version", valid_564153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564154: Call_PrivateCloudByRegionList_564148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns list of private clouds in particular region
  ## 
  let valid = call_564154.validator(path, query, header, formData, body)
  let scheme = call_564154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564154.url(scheme.get, call_564154.host, call_564154.base,
                         call_564154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564154, url, valid)

proc call*(call_564155: Call_PrivateCloudByRegionList_564148; apiVersion: string;
          subscriptionId: string; regionId: string): Recallable =
  ## privateCloudByRegionList
  ## Returns list of private clouds in particular region
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_564156 = newJObject()
  var query_564157 = newJObject()
  add(query_564157, "api-version", newJString(apiVersion))
  add(path_564156, "subscriptionId", newJString(subscriptionId))
  add(path_564156, "regionId", newJString(regionId))
  result = call_564155.call(path_564156, query_564157, nil, nil, nil)

var privateCloudByRegionList* = Call_PrivateCloudByRegionList_564148(
    name: "privateCloudByRegionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds",
    validator: validate_PrivateCloudByRegionList_564149, base: "",
    url: url_PrivateCloudByRegionList_564150, schemes: {Scheme.Https})
type
  Call_GetPrivateCloud_564158 = ref object of OpenApiRestCall_563566
proc url_GetPrivateCloud_564160(protocol: Scheme; host: string; base: string;
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

proc validate_GetPrivateCloud_564159(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns private cloud by its name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pcName: JString (required)
  ##         : The private cloud name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `pcName` field"
  var valid_564161 = path.getOrDefault("pcName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "pcName", valid_564161
  var valid_564162 = path.getOrDefault("subscriptionId")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "subscriptionId", valid_564162
  var valid_564163 = path.getOrDefault("regionId")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "regionId", valid_564163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564164 = query.getOrDefault("api-version")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "api-version", valid_564164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564165: Call_GetPrivateCloud_564158; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns private cloud by its name
  ## 
  let valid = call_564165.validator(path, query, header, formData, body)
  let scheme = call_564165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564165.url(scheme.get, call_564165.host, call_564165.base,
                         call_564165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564165, url, valid)

proc call*(call_564166: Call_GetPrivateCloud_564158; pcName: string;
          apiVersion: string; subscriptionId: string; regionId: string): Recallable =
  ## getPrivateCloud
  ## Returns private cloud by its name
  ##   pcName: string (required)
  ##         : The private cloud name
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_564167 = newJObject()
  var query_564168 = newJObject()
  add(path_564167, "pcName", newJString(pcName))
  add(query_564168, "api-version", newJString(apiVersion))
  add(path_564167, "subscriptionId", newJString(subscriptionId))
  add(path_564167, "regionId", newJString(regionId))
  result = call_564166.call(path_564167, query_564168, nil, nil, nil)

var getPrivateCloud* = Call_GetPrivateCloud_564158(name: "getPrivateCloud",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}",
    validator: validate_GetPrivateCloud_564159, base: "", url: url_GetPrivateCloud_564160,
    schemes: {Scheme.Https})
type
  Call_ResourcePoolsByPCList_564169 = ref object of OpenApiRestCall_563566
proc url_ResourcePoolsByPCList_564171(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcePoolsByPCList_564170(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of resource pools in region for private cloud
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pcName: JString (required)
  ##         : The private cloud name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `pcName` field"
  var valid_564172 = path.getOrDefault("pcName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "pcName", valid_564172
  var valid_564173 = path.getOrDefault("subscriptionId")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "subscriptionId", valid_564173
  var valid_564174 = path.getOrDefault("regionId")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "regionId", valid_564174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564175 = query.getOrDefault("api-version")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "api-version", valid_564175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564176: Call_ResourcePoolsByPCList_564169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns list of resource pools in region for private cloud
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_ResourcePoolsByPCList_564169; pcName: string;
          apiVersion: string; subscriptionId: string; regionId: string): Recallable =
  ## resourcePoolsByPCList
  ## Returns list of resource pools in region for private cloud
  ##   pcName: string (required)
  ##         : The private cloud name
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_564178 = newJObject()
  var query_564179 = newJObject()
  add(path_564178, "pcName", newJString(pcName))
  add(query_564179, "api-version", newJString(apiVersion))
  add(path_564178, "subscriptionId", newJString(subscriptionId))
  add(path_564178, "regionId", newJString(regionId))
  result = call_564177.call(path_564178, query_564179, nil, nil, nil)

var resourcePoolsByPCList* = Call_ResourcePoolsByPCList_564169(
    name: "resourcePoolsByPCList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/resourcePools",
    validator: validate_ResourcePoolsByPCList_564170, base: "",
    url: url_ResourcePoolsByPCList_564171, schemes: {Scheme.Https})
type
  Call_ResourcePoolByPCGet_564180 = ref object of OpenApiRestCall_563566
proc url_ResourcePoolByPCGet_564182(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcePoolByPCGet_564181(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns resource pool templates by its name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourcePoolName: JString (required)
  ##                   : resource pool id (vsphereId)
  ##   pcName: JString (required)
  ##         : The private cloud name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourcePoolName` field"
  var valid_564183 = path.getOrDefault("resourcePoolName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "resourcePoolName", valid_564183
  var valid_564184 = path.getOrDefault("pcName")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "pcName", valid_564184
  var valid_564185 = path.getOrDefault("subscriptionId")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "subscriptionId", valid_564185
  var valid_564186 = path.getOrDefault("regionId")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "regionId", valid_564186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564187 = query.getOrDefault("api-version")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "api-version", valid_564187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564188: Call_ResourcePoolByPCGet_564180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns resource pool templates by its name
  ## 
  let valid = call_564188.validator(path, query, header, formData, body)
  let scheme = call_564188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564188.url(scheme.get, call_564188.host, call_564188.base,
                         call_564188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564188, url, valid)

proc call*(call_564189: Call_ResourcePoolByPCGet_564180; resourcePoolName: string;
          pcName: string; apiVersion: string; subscriptionId: string; regionId: string): Recallable =
  ## resourcePoolByPCGet
  ## Returns resource pool templates by its name
  ##   resourcePoolName: string (required)
  ##                   : resource pool id (vsphereId)
  ##   pcName: string (required)
  ##         : The private cloud name
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_564190 = newJObject()
  var query_564191 = newJObject()
  add(path_564190, "resourcePoolName", newJString(resourcePoolName))
  add(path_564190, "pcName", newJString(pcName))
  add(query_564191, "api-version", newJString(apiVersion))
  add(path_564190, "subscriptionId", newJString(subscriptionId))
  add(path_564190, "regionId", newJString(regionId))
  result = call_564189.call(path_564190, query_564191, nil, nil, nil)

var resourcePoolByPCGet* = Call_ResourcePoolByPCGet_564180(
    name: "resourcePoolByPCGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/resourcePools/{resourcePoolName}",
    validator: validate_ResourcePoolByPCGet_564181, base: "",
    url: url_ResourcePoolByPCGet_564182, schemes: {Scheme.Https})
type
  Call_VirtualMachineTemplatesByPCList_564192 = ref object of OpenApiRestCall_563566
proc url_VirtualMachineTemplatesByPCList_564194(protocol: Scheme; host: string;
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

proc validate_VirtualMachineTemplatesByPCList_564193(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of virtual machine templates in region for private cloud
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pcName: JString (required)
  ##         : The private cloud name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `pcName` field"
  var valid_564195 = path.getOrDefault("pcName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "pcName", valid_564195
  var valid_564196 = path.getOrDefault("subscriptionId")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "subscriptionId", valid_564196
  var valid_564197 = path.getOrDefault("regionId")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "regionId", valid_564197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   resourcePoolName: JString (required)
  ##                   : Resource pool used to derive vSphere cluster which contains VM templates
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564198 = query.getOrDefault("api-version")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "api-version", valid_564198
  var valid_564199 = query.getOrDefault("resourcePoolName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "resourcePoolName", valid_564199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564200: Call_VirtualMachineTemplatesByPCList_564192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of virtual machine templates in region for private cloud
  ## 
  let valid = call_564200.validator(path, query, header, formData, body)
  let scheme = call_564200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564200.url(scheme.get, call_564200.host, call_564200.base,
                         call_564200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564200, url, valid)

proc call*(call_564201: Call_VirtualMachineTemplatesByPCList_564192;
          pcName: string; apiVersion: string; subscriptionId: string;
          resourcePoolName: string; regionId: string): Recallable =
  ## virtualMachineTemplatesByPCList
  ## Returns list of virtual machine templates in region for private cloud
  ##   pcName: string (required)
  ##         : The private cloud name
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourcePoolName: string (required)
  ##                   : Resource pool used to derive vSphere cluster which contains VM templates
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_564202 = newJObject()
  var query_564203 = newJObject()
  add(path_564202, "pcName", newJString(pcName))
  add(query_564203, "api-version", newJString(apiVersion))
  add(path_564202, "subscriptionId", newJString(subscriptionId))
  add(query_564203, "resourcePoolName", newJString(resourcePoolName))
  add(path_564202, "regionId", newJString(regionId))
  result = call_564201.call(path_564202, query_564203, nil, nil, nil)

var virtualMachineTemplatesByPCList* = Call_VirtualMachineTemplatesByPCList_564192(
    name: "virtualMachineTemplatesByPCList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/virtualMachineTemplates",
    validator: validate_VirtualMachineTemplatesByPCList_564193, base: "",
    url: url_VirtualMachineTemplatesByPCList_564194, schemes: {Scheme.Https})
type
  Call_VirtualMachineTemplateByPCGet_564204 = ref object of OpenApiRestCall_563566
proc url_VirtualMachineTemplateByPCGet_564206(protocol: Scheme; host: string;
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

proc validate_VirtualMachineTemplateByPCGet_564205(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns virtual machine templates by its name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pcName: JString (required)
  ##         : The private cloud name
  ##   virtualMachineTemplateName: JString (required)
  ##                             : virtual machine template id (vsphereId)
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `pcName` field"
  var valid_564207 = path.getOrDefault("pcName")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "pcName", valid_564207
  var valid_564208 = path.getOrDefault("virtualMachineTemplateName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "virtualMachineTemplateName", valid_564208
  var valid_564209 = path.getOrDefault("subscriptionId")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "subscriptionId", valid_564209
  var valid_564210 = path.getOrDefault("regionId")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "regionId", valid_564210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564211 = query.getOrDefault("api-version")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "api-version", valid_564211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564212: Call_VirtualMachineTemplateByPCGet_564204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns virtual machine templates by its name
  ## 
  let valid = call_564212.validator(path, query, header, formData, body)
  let scheme = call_564212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564212.url(scheme.get, call_564212.host, call_564212.base,
                         call_564212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564212, url, valid)

proc call*(call_564213: Call_VirtualMachineTemplateByPCGet_564204; pcName: string;
          virtualMachineTemplateName: string; apiVersion: string;
          subscriptionId: string; regionId: string): Recallable =
  ## virtualMachineTemplateByPCGet
  ## Returns virtual machine templates by its name
  ##   pcName: string (required)
  ##         : The private cloud name
  ##   virtualMachineTemplateName: string (required)
  ##                             : virtual machine template id (vsphereId)
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_564214 = newJObject()
  var query_564215 = newJObject()
  add(path_564214, "pcName", newJString(pcName))
  add(path_564214, "virtualMachineTemplateName",
      newJString(virtualMachineTemplateName))
  add(query_564215, "api-version", newJString(apiVersion))
  add(path_564214, "subscriptionId", newJString(subscriptionId))
  add(path_564214, "regionId", newJString(regionId))
  result = call_564213.call(path_564214, query_564215, nil, nil, nil)

var virtualMachineTemplateByPCGet* = Call_VirtualMachineTemplateByPCGet_564204(
    name: "virtualMachineTemplateByPCGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/virtualMachineTemplates/{virtualMachineTemplateName}",
    validator: validate_VirtualMachineTemplateByPCGet_564205, base: "",
    url: url_VirtualMachineTemplateByPCGet_564206, schemes: {Scheme.Https})
type
  Call_VirtualNetworksByPCList_564216 = ref object of OpenApiRestCall_563566
proc url_VirtualNetworksByPCList_564218(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksByPCList_564217(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return list of virtual networks in location for private cloud
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pcName: JString (required)
  ##         : The private cloud name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `pcName` field"
  var valid_564219 = path.getOrDefault("pcName")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "pcName", valid_564219
  var valid_564220 = path.getOrDefault("subscriptionId")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "subscriptionId", valid_564220
  var valid_564221 = path.getOrDefault("regionId")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "regionId", valid_564221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   resourcePoolName: JString (required)
  ##                   : Resource pool used to derive vSphere cluster which contains virtual networks
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564222 = query.getOrDefault("api-version")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "api-version", valid_564222
  var valid_564223 = query.getOrDefault("resourcePoolName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "resourcePoolName", valid_564223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564224: Call_VirtualNetworksByPCList_564216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return list of virtual networks in location for private cloud
  ## 
  let valid = call_564224.validator(path, query, header, formData, body)
  let scheme = call_564224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564224.url(scheme.get, call_564224.host, call_564224.base,
                         call_564224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564224, url, valid)

proc call*(call_564225: Call_VirtualNetworksByPCList_564216; pcName: string;
          apiVersion: string; subscriptionId: string; resourcePoolName: string;
          regionId: string): Recallable =
  ## virtualNetworksByPCList
  ## Return list of virtual networks in location for private cloud
  ##   pcName: string (required)
  ##         : The private cloud name
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourcePoolName: string (required)
  ##                   : Resource pool used to derive vSphere cluster which contains virtual networks
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_564226 = newJObject()
  var query_564227 = newJObject()
  add(path_564226, "pcName", newJString(pcName))
  add(query_564227, "api-version", newJString(apiVersion))
  add(path_564226, "subscriptionId", newJString(subscriptionId))
  add(query_564227, "resourcePoolName", newJString(resourcePoolName))
  add(path_564226, "regionId", newJString(regionId))
  result = call_564225.call(path_564226, query_564227, nil, nil, nil)

var virtualNetworksByPCList* = Call_VirtualNetworksByPCList_564216(
    name: "virtualNetworksByPCList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/virtualNetworks",
    validator: validate_VirtualNetworksByPCList_564217, base: "",
    url: url_VirtualNetworksByPCList_564218, schemes: {Scheme.Https})
type
  Call_VirtualNetworkByPCGet_564228 = ref object of OpenApiRestCall_563566
proc url_VirtualNetworkByPCGet_564230(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworkByPCGet_564229(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return virtual network by its name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pcName: JString (required)
  ##         : The private cloud name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   virtualNetworkName: JString (required)
  ##                     : virtual network id (vsphereId)
  ##   regionId: JString (required)
  ##           : The region Id (westus, eastus)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `pcName` field"
  var valid_564231 = path.getOrDefault("pcName")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "pcName", valid_564231
  var valid_564232 = path.getOrDefault("subscriptionId")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "subscriptionId", valid_564232
  var valid_564233 = path.getOrDefault("virtualNetworkName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "virtualNetworkName", valid_564233
  var valid_564234 = path.getOrDefault("regionId")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "regionId", valid_564234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564235 = query.getOrDefault("api-version")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "api-version", valid_564235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564236: Call_VirtualNetworkByPCGet_564228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return virtual network by its name
  ## 
  let valid = call_564236.validator(path, query, header, formData, body)
  let scheme = call_564236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564236.url(scheme.get, call_564236.host, call_564236.base,
                         call_564236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564236, url, valid)

proc call*(call_564237: Call_VirtualNetworkByPCGet_564228; pcName: string;
          apiVersion: string; subscriptionId: string; virtualNetworkName: string;
          regionId: string): Recallable =
  ## virtualNetworkByPCGet
  ## Return virtual network by its name
  ##   pcName: string (required)
  ##         : The private cloud name
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   virtualNetworkName: string (required)
  ##                     : virtual network id (vsphereId)
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_564238 = newJObject()
  var query_564239 = newJObject()
  add(path_564238, "pcName", newJString(pcName))
  add(query_564239, "api-version", newJString(apiVersion))
  add(path_564238, "subscriptionId", newJString(subscriptionId))
  add(path_564238, "virtualNetworkName", newJString(virtualNetworkName))
  add(path_564238, "regionId", newJString(regionId))
  result = call_564237.call(path_564238, query_564239, nil, nil, nil)

var virtualNetworkByPCGet* = Call_VirtualNetworkByPCGet_564228(
    name: "virtualNetworkByPCGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworkByPCGet_564229, base: "",
    url: url_VirtualNetworkByPCGet_564230, schemes: {Scheme.Https})
type
  Call_UsagesWithinRegionList_564240 = ref object of OpenApiRestCall_563566
proc url_UsagesWithinRegionList_564242(protocol: Scheme; host: string; base: string;
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

proc validate_UsagesWithinRegionList_564241(path: JsonNode; query: JsonNode;
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
  var valid_564243 = path.getOrDefault("subscriptionId")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "subscriptionId", valid_564243
  var valid_564244 = path.getOrDefault("regionId")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "regionId", valid_564244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The filter to apply on the list operation. only name.value is allowed here as a filter e.g. $filter=name.value eq 'xxxx'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564245 = query.getOrDefault("api-version")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "api-version", valid_564245
  var valid_564246 = query.getOrDefault("$filter")
  valid_564246 = validateParameter(valid_564246, JString, required = false,
                                 default = nil)
  if valid_564246 != nil:
    section.add "$filter", valid_564246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564247: Call_UsagesWithinRegionList_564240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns list of usage in region
  ## 
  let valid = call_564247.validator(path, query, header, formData, body)
  let scheme = call_564247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564247.url(scheme.get, call_564247.host, call_564247.base,
                         call_564247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564247, url, valid)

proc call*(call_564248: Call_UsagesWithinRegionList_564240; apiVersion: string;
          subscriptionId: string; regionId: string; Filter: string = ""): Recallable =
  ## usagesWithinRegionList
  ## Returns list of usage in region
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Filter: string
  ##         : The filter to apply on the list operation. only name.value is allowed here as a filter e.g. $filter=name.value eq 'xxxx'
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_564249 = newJObject()
  var query_564250 = newJObject()
  add(query_564250, "api-version", newJString(apiVersion))
  add(path_564249, "subscriptionId", newJString(subscriptionId))
  add(query_564250, "$filter", newJString(Filter))
  add(path_564249, "regionId", newJString(regionId))
  result = call_564248.call(path_564249, query_564250, nil, nil, nil)

var usagesWithinRegionList* = Call_UsagesWithinRegionList_564240(
    name: "usagesWithinRegionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/usages",
    validator: validate_UsagesWithinRegionList_564241, base: "",
    url: url_UsagesWithinRegionList_564242, schemes: {Scheme.Https})
type
  Call_VirtualMachineListBySubscription_564251 = ref object of OpenApiRestCall_563566
proc url_VirtualMachineListBySubscription_564253(protocol: Scheme; host: string;
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

proc validate_VirtualMachineListBySubscription_564252(path: JsonNode;
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
  var valid_564254 = path.getOrDefault("subscriptionId")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "subscriptionId", valid_564254
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : to be used by nextLink implementation
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of record sets to return
  ##   $filter: JString
  ##          : The filter to apply on the list operation
  section = newJObject()
  var valid_564255 = query.getOrDefault("$skipToken")
  valid_564255 = validateParameter(valid_564255, JString, required = false,
                                 default = nil)
  if valid_564255 != nil:
    section.add "$skipToken", valid_564255
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564256 = query.getOrDefault("api-version")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "api-version", valid_564256
  var valid_564257 = query.getOrDefault("$top")
  valid_564257 = validateParameter(valid_564257, JInt, required = false, default = nil)
  if valid_564257 != nil:
    section.add "$top", valid_564257
  var valid_564258 = query.getOrDefault("$filter")
  valid_564258 = validateParameter(valid_564258, JString, required = false,
                                 default = nil)
  if valid_564258 != nil:
    section.add "$filter", valid_564258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564259: Call_VirtualMachineListBySubscription_564251;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list virtual machine within subscription
  ## 
  let valid = call_564259.validator(path, query, header, formData, body)
  let scheme = call_564259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564259.url(scheme.get, call_564259.host, call_564259.base,
                         call_564259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564259, url, valid)

proc call*(call_564260: Call_VirtualMachineListBySubscription_564251;
          apiVersion: string; subscriptionId: string; SkipToken: string = "";
          Top: int = 0; Filter: string = ""): Recallable =
  ## virtualMachineListBySubscription
  ## Returns list virtual machine within subscription
  ##   SkipToken: string
  ##            : to be used by nextLink implementation
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Top: int
  ##      : The maximum number of record sets to return
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Filter: string
  ##         : The filter to apply on the list operation
  var path_564261 = newJObject()
  var query_564262 = newJObject()
  add(query_564262, "$skipToken", newJString(SkipToken))
  add(query_564262, "api-version", newJString(apiVersion))
  add(query_564262, "$top", newJInt(Top))
  add(path_564261, "subscriptionId", newJString(subscriptionId))
  add(query_564262, "$filter", newJString(Filter))
  result = call_564260.call(path_564261, query_564262, nil, nil, nil)

var virtualMachineListBySubscription* = Call_VirtualMachineListBySubscription_564251(
    name: "virtualMachineListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/virtualMachines",
    validator: validate_VirtualMachineListBySubscription_564252, base: "",
    url: url_VirtualMachineListBySubscription_564253, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeListByResourceGroup_564263 = ref object of OpenApiRestCall_563566
proc url_DedicatedCloudNodeListByResourceGroup_564265(protocol: Scheme;
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

proc validate_DedicatedCloudNodeListByResourceGroup_564264(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of dedicate cloud nodes within resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564266 = path.getOrDefault("subscriptionId")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "subscriptionId", valid_564266
  var valid_564267 = path.getOrDefault("resourceGroupName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "resourceGroupName", valid_564267
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : to be used by nextLink implementation
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of record sets to return
  ##   $filter: JString
  ##          : The filter to apply on the list operation
  section = newJObject()
  var valid_564268 = query.getOrDefault("$skipToken")
  valid_564268 = validateParameter(valid_564268, JString, required = false,
                                 default = nil)
  if valid_564268 != nil:
    section.add "$skipToken", valid_564268
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564269 = query.getOrDefault("api-version")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "api-version", valid_564269
  var valid_564270 = query.getOrDefault("$top")
  valid_564270 = validateParameter(valid_564270, JInt, required = false, default = nil)
  if valid_564270 != nil:
    section.add "$top", valid_564270
  var valid_564271 = query.getOrDefault("$filter")
  valid_564271 = validateParameter(valid_564271, JString, required = false,
                                 default = nil)
  if valid_564271 != nil:
    section.add "$filter", valid_564271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564272: Call_DedicatedCloudNodeListByResourceGroup_564263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of dedicate cloud nodes within resource group
  ## 
  let valid = call_564272.validator(path, query, header, formData, body)
  let scheme = call_564272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564272.url(scheme.get, call_564272.host, call_564272.base,
                         call_564272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564272, url, valid)

proc call*(call_564273: Call_DedicatedCloudNodeListByResourceGroup_564263;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          SkipToken: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## dedicatedCloudNodeListByResourceGroup
  ## Returns list of dedicate cloud nodes within resource group
  ##   SkipToken: string
  ##            : to be used by nextLink implementation
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Top: int
  ##      : The maximum number of record sets to return
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   Filter: string
  ##         : The filter to apply on the list operation
  var path_564274 = newJObject()
  var query_564275 = newJObject()
  add(query_564275, "$skipToken", newJString(SkipToken))
  add(query_564275, "api-version", newJString(apiVersion))
  add(query_564275, "$top", newJInt(Top))
  add(path_564274, "subscriptionId", newJString(subscriptionId))
  add(path_564274, "resourceGroupName", newJString(resourceGroupName))
  add(query_564275, "$filter", newJString(Filter))
  result = call_564273.call(path_564274, query_564275, nil, nil, nil)

var dedicatedCloudNodeListByResourceGroup* = Call_DedicatedCloudNodeListByResourceGroup_564263(
    name: "dedicatedCloudNodeListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes",
    validator: validate_DedicatedCloudNodeListByResourceGroup_564264, base: "",
    url: url_DedicatedCloudNodeListByResourceGroup_564265, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeCreateOrUpdate_564285 = ref object of OpenApiRestCall_563566
proc url_DedicatedCloudNodeCreateOrUpdate_564287(protocol: Scheme; host: string;
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

proc validate_DedicatedCloudNodeCreateOrUpdate_564286(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns dedicated cloud node by its name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   dedicatedCloudNodeName: JString (required)
  ##                         : dedicated cloud node name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564305 = path.getOrDefault("subscriptionId")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "subscriptionId", valid_564305
  var valid_564306 = path.getOrDefault("resourceGroupName")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "resourceGroupName", valid_564306
  var valid_564307 = path.getOrDefault("dedicatedCloudNodeName")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "dedicatedCloudNodeName", valid_564307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564308 = query.getOrDefault("api-version")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "api-version", valid_564308
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_564309 = header.getOrDefault("Referer")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "Referer", valid_564309
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

proc call*(call_564311: Call_DedicatedCloudNodeCreateOrUpdate_564285;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns dedicated cloud node by its name
  ## 
  let valid = call_564311.validator(path, query, header, formData, body)
  let scheme = call_564311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564311.url(scheme.get, call_564311.host, call_564311.base,
                         call_564311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564311, url, valid)

proc call*(call_564312: Call_DedicatedCloudNodeCreateOrUpdate_564285;
          dedicatedCloudNodeRequest: JsonNode; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          dedicatedCloudNodeName: string): Recallable =
  ## dedicatedCloudNodeCreateOrUpdate
  ## Returns dedicated cloud node by its name
  ##   dedicatedCloudNodeRequest: JObject (required)
  ##                            : Create Dedicated Cloud Node request
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   dedicatedCloudNodeName: string (required)
  ##                         : dedicated cloud node name
  var path_564313 = newJObject()
  var query_564314 = newJObject()
  var body_564315 = newJObject()
  if dedicatedCloudNodeRequest != nil:
    body_564315 = dedicatedCloudNodeRequest
  add(query_564314, "api-version", newJString(apiVersion))
  add(path_564313, "subscriptionId", newJString(subscriptionId))
  add(path_564313, "resourceGroupName", newJString(resourceGroupName))
  add(path_564313, "dedicatedCloudNodeName", newJString(dedicatedCloudNodeName))
  result = call_564312.call(path_564313, query_564314, nil, nil, body_564315)

var dedicatedCloudNodeCreateOrUpdate* = Call_DedicatedCloudNodeCreateOrUpdate_564285(
    name: "dedicatedCloudNodeCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes/{dedicatedCloudNodeName}",
    validator: validate_DedicatedCloudNodeCreateOrUpdate_564286, base: "",
    url: url_DedicatedCloudNodeCreateOrUpdate_564287, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeGet_564276 = ref object of OpenApiRestCall_563566
proc url_DedicatedCloudNodeGet_564278(protocol: Scheme; host: string; base: string;
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

proc validate_DedicatedCloudNodeGet_564277(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns dedicated cloud node
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   dedicatedCloudNodeName: JString (required)
  ##                         : dedicated cloud node name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564279 = path.getOrDefault("subscriptionId")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "subscriptionId", valid_564279
  var valid_564280 = path.getOrDefault("resourceGroupName")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "resourceGroupName", valid_564280
  var valid_564281 = path.getOrDefault("dedicatedCloudNodeName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "dedicatedCloudNodeName", valid_564281
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564282: Call_DedicatedCloudNodeGet_564276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns dedicated cloud node
  ## 
  let valid = call_564282.validator(path, query, header, formData, body)
  let scheme = call_564282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564282.url(scheme.get, call_564282.host, call_564282.base,
                         call_564282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564282, url, valid)

proc call*(call_564283: Call_DedicatedCloudNodeGet_564276; subscriptionId: string;
          resourceGroupName: string; dedicatedCloudNodeName: string): Recallable =
  ## dedicatedCloudNodeGet
  ## Returns dedicated cloud node
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   dedicatedCloudNodeName: string (required)
  ##                         : dedicated cloud node name
  var path_564284 = newJObject()
  add(path_564284, "subscriptionId", newJString(subscriptionId))
  add(path_564284, "resourceGroupName", newJString(resourceGroupName))
  add(path_564284, "dedicatedCloudNodeName", newJString(dedicatedCloudNodeName))
  result = call_564283.call(path_564284, nil, nil, nil, nil)

var dedicatedCloudNodeGet* = Call_DedicatedCloudNodeGet_564276(
    name: "dedicatedCloudNodeGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes/{dedicatedCloudNodeName}",
    validator: validate_DedicatedCloudNodeGet_564277, base: "",
    url: url_DedicatedCloudNodeGet_564278, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeUpdate_564327 = ref object of OpenApiRestCall_563566
proc url_DedicatedCloudNodeUpdate_564329(protocol: Scheme; host: string;
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

proc validate_DedicatedCloudNodeUpdate_564328(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches dedicated node properties
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   dedicatedCloudNodeName: JString (required)
  ##                         : dedicated cloud node name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564330 = path.getOrDefault("subscriptionId")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "subscriptionId", valid_564330
  var valid_564331 = path.getOrDefault("resourceGroupName")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "resourceGroupName", valid_564331
  var valid_564332 = path.getOrDefault("dedicatedCloudNodeName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "dedicatedCloudNodeName", valid_564332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564333 = query.getOrDefault("api-version")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "api-version", valid_564333
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

proc call*(call_564335: Call_DedicatedCloudNodeUpdate_564327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches dedicated node properties
  ## 
  let valid = call_564335.validator(path, query, header, formData, body)
  let scheme = call_564335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564335.url(scheme.get, call_564335.host, call_564335.base,
                         call_564335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564335, url, valid)

proc call*(call_564336: Call_DedicatedCloudNodeUpdate_564327;
          dedicatedCloudNodeRequest: JsonNode; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          dedicatedCloudNodeName: string): Recallable =
  ## dedicatedCloudNodeUpdate
  ## Patches dedicated node properties
  ##   dedicatedCloudNodeRequest: JObject (required)
  ##                            : Patch Dedicated Cloud Node request
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   dedicatedCloudNodeName: string (required)
  ##                         : dedicated cloud node name
  var path_564337 = newJObject()
  var query_564338 = newJObject()
  var body_564339 = newJObject()
  if dedicatedCloudNodeRequest != nil:
    body_564339 = dedicatedCloudNodeRequest
  add(query_564338, "api-version", newJString(apiVersion))
  add(path_564337, "subscriptionId", newJString(subscriptionId))
  add(path_564337, "resourceGroupName", newJString(resourceGroupName))
  add(path_564337, "dedicatedCloudNodeName", newJString(dedicatedCloudNodeName))
  result = call_564336.call(path_564337, query_564338, nil, nil, body_564339)

var dedicatedCloudNodeUpdate* = Call_DedicatedCloudNodeUpdate_564327(
    name: "dedicatedCloudNodeUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes/{dedicatedCloudNodeName}",
    validator: validate_DedicatedCloudNodeUpdate_564328, base: "",
    url: url_DedicatedCloudNodeUpdate_564329, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeDelete_564316 = ref object of OpenApiRestCall_563566
proc url_DedicatedCloudNodeDelete_564318(protocol: Scheme; host: string;
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

proc validate_DedicatedCloudNodeDelete_564317(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete dedicated cloud node
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  ##   dedicatedCloudNodeName: JString (required)
  ##                         : dedicated cloud node name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564319 = path.getOrDefault("subscriptionId")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "subscriptionId", valid_564319
  var valid_564320 = path.getOrDefault("resourceGroupName")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "resourceGroupName", valid_564320
  var valid_564321 = path.getOrDefault("dedicatedCloudNodeName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "dedicatedCloudNodeName", valid_564321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564322 = query.getOrDefault("api-version")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "api-version", valid_564322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564323: Call_DedicatedCloudNodeDelete_564316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete dedicated cloud node
  ## 
  let valid = call_564323.validator(path, query, header, formData, body)
  let scheme = call_564323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564323.url(scheme.get, call_564323.host, call_564323.base,
                         call_564323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564323, url, valid)

proc call*(call_564324: Call_DedicatedCloudNodeDelete_564316; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          dedicatedCloudNodeName: string): Recallable =
  ## dedicatedCloudNodeDelete
  ## Delete dedicated cloud node
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   dedicatedCloudNodeName: string (required)
  ##                         : dedicated cloud node name
  var path_564325 = newJObject()
  var query_564326 = newJObject()
  add(query_564326, "api-version", newJString(apiVersion))
  add(path_564325, "subscriptionId", newJString(subscriptionId))
  add(path_564325, "resourceGroupName", newJString(resourceGroupName))
  add(path_564325, "dedicatedCloudNodeName", newJString(dedicatedCloudNodeName))
  result = call_564324.call(path_564325, query_564326, nil, nil, nil)

var dedicatedCloudNodeDelete* = Call_DedicatedCloudNodeDelete_564316(
    name: "dedicatedCloudNodeDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes/{dedicatedCloudNodeName}",
    validator: validate_DedicatedCloudNodeDelete_564317, base: "",
    url: url_DedicatedCloudNodeDelete_564318, schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceListByResourceGroup_564340 = ref object of OpenApiRestCall_563566
proc url_DedicatedCloudServiceListByResourceGroup_564342(protocol: Scheme;
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

proc validate_DedicatedCloudServiceListByResourceGroup_564341(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of dedicated cloud service within resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564343 = path.getOrDefault("subscriptionId")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "subscriptionId", valid_564343
  var valid_564344 = path.getOrDefault("resourceGroupName")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "resourceGroupName", valid_564344
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : to be used by nextLink implementation
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of record sets to return
  ##   $filter: JString
  ##          : The filter to apply on the list operation
  section = newJObject()
  var valid_564345 = query.getOrDefault("$skipToken")
  valid_564345 = validateParameter(valid_564345, JString, required = false,
                                 default = nil)
  if valid_564345 != nil:
    section.add "$skipToken", valid_564345
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564346 = query.getOrDefault("api-version")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "api-version", valid_564346
  var valid_564347 = query.getOrDefault("$top")
  valid_564347 = validateParameter(valid_564347, JInt, required = false, default = nil)
  if valid_564347 != nil:
    section.add "$top", valid_564347
  var valid_564348 = query.getOrDefault("$filter")
  valid_564348 = validateParameter(valid_564348, JString, required = false,
                                 default = nil)
  if valid_564348 != nil:
    section.add "$filter", valid_564348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564349: Call_DedicatedCloudServiceListByResourceGroup_564340;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of dedicated cloud service within resource group
  ## 
  let valid = call_564349.validator(path, query, header, formData, body)
  let scheme = call_564349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564349.url(scheme.get, call_564349.host, call_564349.base,
                         call_564349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564349, url, valid)

proc call*(call_564350: Call_DedicatedCloudServiceListByResourceGroup_564340;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          SkipToken: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## dedicatedCloudServiceListByResourceGroup
  ## Returns list of dedicated cloud service within resource group
  ##   SkipToken: string
  ##            : to be used by nextLink implementation
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Top: int
  ##      : The maximum number of record sets to return
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   Filter: string
  ##         : The filter to apply on the list operation
  var path_564351 = newJObject()
  var query_564352 = newJObject()
  add(query_564352, "$skipToken", newJString(SkipToken))
  add(query_564352, "api-version", newJString(apiVersion))
  add(query_564352, "$top", newJInt(Top))
  add(path_564351, "subscriptionId", newJString(subscriptionId))
  add(path_564351, "resourceGroupName", newJString(resourceGroupName))
  add(query_564352, "$filter", newJString(Filter))
  result = call_564350.call(path_564351, query_564352, nil, nil, nil)

var dedicatedCloudServiceListByResourceGroup* = Call_DedicatedCloudServiceListByResourceGroup_564340(
    name: "dedicatedCloudServiceListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices",
    validator: validate_DedicatedCloudServiceListByResourceGroup_564341, base: "",
    url: url_DedicatedCloudServiceListByResourceGroup_564342,
    schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceCreateOrUpdate_564364 = ref object of OpenApiRestCall_563566
proc url_DedicatedCloudServiceCreateOrUpdate_564366(protocol: Scheme; host: string;
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

proc validate_DedicatedCloudServiceCreateOrUpdate_564365(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create dedicate cloud service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dedicatedCloudServiceName: JString (required)
  ##                            : dedicated cloud Service name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `dedicatedCloudServiceName` field"
  var valid_564367 = path.getOrDefault("dedicatedCloudServiceName")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "dedicatedCloudServiceName", valid_564367
  var valid_564368 = path.getOrDefault("subscriptionId")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "subscriptionId", valid_564368
  var valid_564369 = path.getOrDefault("resourceGroupName")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "resourceGroupName", valid_564369
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564370 = query.getOrDefault("api-version")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "api-version", valid_564370
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

proc call*(call_564372: Call_DedicatedCloudServiceCreateOrUpdate_564364;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create dedicate cloud service
  ## 
  let valid = call_564372.validator(path, query, header, formData, body)
  let scheme = call_564372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564372.url(scheme.get, call_564372.host, call_564372.base,
                         call_564372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564372, url, valid)

proc call*(call_564373: Call_DedicatedCloudServiceCreateOrUpdate_564364;
          apiVersion: string; dedicatedCloudServiceName: string;
          subscriptionId: string; resourceGroupName: string;
          dedicatedCloudServiceRequest: JsonNode): Recallable =
  ## dedicatedCloudServiceCreateOrUpdate
  ## Create dedicate cloud service
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   dedicatedCloudServiceName: string (required)
  ##                            : dedicated cloud Service name
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   dedicatedCloudServiceRequest: JObject (required)
  ##                               : Create Dedicated Cloud Service request
  var path_564374 = newJObject()
  var query_564375 = newJObject()
  var body_564376 = newJObject()
  add(query_564375, "api-version", newJString(apiVersion))
  add(path_564374, "dedicatedCloudServiceName",
      newJString(dedicatedCloudServiceName))
  add(path_564374, "subscriptionId", newJString(subscriptionId))
  add(path_564374, "resourceGroupName", newJString(resourceGroupName))
  if dedicatedCloudServiceRequest != nil:
    body_564376 = dedicatedCloudServiceRequest
  result = call_564373.call(path_564374, query_564375, nil, nil, body_564376)

var dedicatedCloudServiceCreateOrUpdate* = Call_DedicatedCloudServiceCreateOrUpdate_564364(
    name: "dedicatedCloudServiceCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices/{dedicatedCloudServiceName}",
    validator: validate_DedicatedCloudServiceCreateOrUpdate_564365, base: "",
    url: url_DedicatedCloudServiceCreateOrUpdate_564366, schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceGet_564353 = ref object of OpenApiRestCall_563566
proc url_DedicatedCloudServiceGet_564355(protocol: Scheme; host: string;
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

proc validate_DedicatedCloudServiceGet_564354(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns Dedicate Cloud Service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dedicatedCloudServiceName: JString (required)
  ##                            : dedicated cloud Service name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `dedicatedCloudServiceName` field"
  var valid_564356 = path.getOrDefault("dedicatedCloudServiceName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "dedicatedCloudServiceName", valid_564356
  var valid_564357 = path.getOrDefault("subscriptionId")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "subscriptionId", valid_564357
  var valid_564358 = path.getOrDefault("resourceGroupName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "resourceGroupName", valid_564358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564359 = query.getOrDefault("api-version")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "api-version", valid_564359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564360: Call_DedicatedCloudServiceGet_564353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Dedicate Cloud Service
  ## 
  let valid = call_564360.validator(path, query, header, formData, body)
  let scheme = call_564360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564360.url(scheme.get, call_564360.host, call_564360.base,
                         call_564360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564360, url, valid)

proc call*(call_564361: Call_DedicatedCloudServiceGet_564353; apiVersion: string;
          dedicatedCloudServiceName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## dedicatedCloudServiceGet
  ## Returns Dedicate Cloud Service
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   dedicatedCloudServiceName: string (required)
  ##                            : dedicated cloud Service name
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  var path_564362 = newJObject()
  var query_564363 = newJObject()
  add(query_564363, "api-version", newJString(apiVersion))
  add(path_564362, "dedicatedCloudServiceName",
      newJString(dedicatedCloudServiceName))
  add(path_564362, "subscriptionId", newJString(subscriptionId))
  add(path_564362, "resourceGroupName", newJString(resourceGroupName))
  result = call_564361.call(path_564362, query_564363, nil, nil, nil)

var dedicatedCloudServiceGet* = Call_DedicatedCloudServiceGet_564353(
    name: "dedicatedCloudServiceGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices/{dedicatedCloudServiceName}",
    validator: validate_DedicatedCloudServiceGet_564354, base: "",
    url: url_DedicatedCloudServiceGet_564355, schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceUpdate_564388 = ref object of OpenApiRestCall_563566
proc url_DedicatedCloudServiceUpdate_564390(protocol: Scheme; host: string;
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

proc validate_DedicatedCloudServiceUpdate_564389(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch dedicated cloud service's properties
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dedicatedCloudServiceName: JString (required)
  ##                            : dedicated cloud service name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `dedicatedCloudServiceName` field"
  var valid_564391 = path.getOrDefault("dedicatedCloudServiceName")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "dedicatedCloudServiceName", valid_564391
  var valid_564392 = path.getOrDefault("subscriptionId")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "subscriptionId", valid_564392
  var valid_564393 = path.getOrDefault("resourceGroupName")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "resourceGroupName", valid_564393
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564394 = query.getOrDefault("api-version")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "api-version", valid_564394
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

proc call*(call_564396: Call_DedicatedCloudServiceUpdate_564388; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch dedicated cloud service's properties
  ## 
  let valid = call_564396.validator(path, query, header, formData, body)
  let scheme = call_564396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564396.url(scheme.get, call_564396.host, call_564396.base,
                         call_564396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564396, url, valid)

proc call*(call_564397: Call_DedicatedCloudServiceUpdate_564388;
          apiVersion: string; dedicatedCloudServiceName: string;
          subscriptionId: string; resourceGroupName: string;
          dedicatedCloudServiceRequest: JsonNode): Recallable =
  ## dedicatedCloudServiceUpdate
  ## Patch dedicated cloud service's properties
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   dedicatedCloudServiceName: string (required)
  ##                            : dedicated cloud service name
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   dedicatedCloudServiceRequest: JObject (required)
  ##                               : Patch Dedicated Cloud Service request
  var path_564398 = newJObject()
  var query_564399 = newJObject()
  var body_564400 = newJObject()
  add(query_564399, "api-version", newJString(apiVersion))
  add(path_564398, "dedicatedCloudServiceName",
      newJString(dedicatedCloudServiceName))
  add(path_564398, "subscriptionId", newJString(subscriptionId))
  add(path_564398, "resourceGroupName", newJString(resourceGroupName))
  if dedicatedCloudServiceRequest != nil:
    body_564400 = dedicatedCloudServiceRequest
  result = call_564397.call(path_564398, query_564399, nil, nil, body_564400)

var dedicatedCloudServiceUpdate* = Call_DedicatedCloudServiceUpdate_564388(
    name: "dedicatedCloudServiceUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices/{dedicatedCloudServiceName}",
    validator: validate_DedicatedCloudServiceUpdate_564389, base: "",
    url: url_DedicatedCloudServiceUpdate_564390, schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceDelete_564377 = ref object of OpenApiRestCall_563566
proc url_DedicatedCloudServiceDelete_564379(protocol: Scheme; host: string;
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

proc validate_DedicatedCloudServiceDelete_564378(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete dedicate cloud service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dedicatedCloudServiceName: JString (required)
  ##                            : dedicated cloud service name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `dedicatedCloudServiceName` field"
  var valid_564380 = path.getOrDefault("dedicatedCloudServiceName")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "dedicatedCloudServiceName", valid_564380
  var valid_564381 = path.getOrDefault("subscriptionId")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "subscriptionId", valid_564381
  var valid_564382 = path.getOrDefault("resourceGroupName")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "resourceGroupName", valid_564382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564383 = query.getOrDefault("api-version")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "api-version", valid_564383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564384: Call_DedicatedCloudServiceDelete_564377; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete dedicate cloud service
  ## 
  let valid = call_564384.validator(path, query, header, formData, body)
  let scheme = call_564384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564384.url(scheme.get, call_564384.host, call_564384.base,
                         call_564384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564384, url, valid)

proc call*(call_564385: Call_DedicatedCloudServiceDelete_564377;
          apiVersion: string; dedicatedCloudServiceName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## dedicatedCloudServiceDelete
  ## Delete dedicate cloud service
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   dedicatedCloudServiceName: string (required)
  ##                            : dedicated cloud service name
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  var path_564386 = newJObject()
  var query_564387 = newJObject()
  add(query_564387, "api-version", newJString(apiVersion))
  add(path_564386, "dedicatedCloudServiceName",
      newJString(dedicatedCloudServiceName))
  add(path_564386, "subscriptionId", newJString(subscriptionId))
  add(path_564386, "resourceGroupName", newJString(resourceGroupName))
  result = call_564385.call(path_564386, query_564387, nil, nil, nil)

var dedicatedCloudServiceDelete* = Call_DedicatedCloudServiceDelete_564377(
    name: "dedicatedCloudServiceDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices/{dedicatedCloudServiceName}",
    validator: validate_DedicatedCloudServiceDelete_564378, base: "",
    url: url_DedicatedCloudServiceDelete_564379, schemes: {Scheme.Https})
type
  Call_VirtualMachineListByResourceGroup_564401 = ref object of OpenApiRestCall_563566
proc url_VirtualMachineListByResourceGroup_564403(protocol: Scheme; host: string;
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

proc validate_VirtualMachineListByResourceGroup_564402(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of virtual machine within resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564404 = path.getOrDefault("subscriptionId")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "subscriptionId", valid_564404
  var valid_564405 = path.getOrDefault("resourceGroupName")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "resourceGroupName", valid_564405
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : to be used by nextLink implementation
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of record sets to return
  ##   $filter: JString
  ##          : The filter to apply on the list operation
  section = newJObject()
  var valid_564406 = query.getOrDefault("$skipToken")
  valid_564406 = validateParameter(valid_564406, JString, required = false,
                                 default = nil)
  if valid_564406 != nil:
    section.add "$skipToken", valid_564406
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564407 = query.getOrDefault("api-version")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "api-version", valid_564407
  var valid_564408 = query.getOrDefault("$top")
  valid_564408 = validateParameter(valid_564408, JInt, required = false, default = nil)
  if valid_564408 != nil:
    section.add "$top", valid_564408
  var valid_564409 = query.getOrDefault("$filter")
  valid_564409 = validateParameter(valid_564409, JString, required = false,
                                 default = nil)
  if valid_564409 != nil:
    section.add "$filter", valid_564409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564410: Call_VirtualMachineListByResourceGroup_564401;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of virtual machine within resource group
  ## 
  let valid = call_564410.validator(path, query, header, formData, body)
  let scheme = call_564410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564410.url(scheme.get, call_564410.host, call_564410.base,
                         call_564410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564410, url, valid)

proc call*(call_564411: Call_VirtualMachineListByResourceGroup_564401;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          SkipToken: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## virtualMachineListByResourceGroup
  ## Returns list of virtual machine within resource group
  ##   SkipToken: string
  ##            : to be used by nextLink implementation
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Top: int
  ##      : The maximum number of record sets to return
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   Filter: string
  ##         : The filter to apply on the list operation
  var path_564412 = newJObject()
  var query_564413 = newJObject()
  add(query_564413, "$skipToken", newJString(SkipToken))
  add(query_564413, "api-version", newJString(apiVersion))
  add(query_564413, "$top", newJInt(Top))
  add(path_564412, "subscriptionId", newJString(subscriptionId))
  add(path_564412, "resourceGroupName", newJString(resourceGroupName))
  add(query_564413, "$filter", newJString(Filter))
  result = call_564411.call(path_564412, query_564413, nil, nil, nil)

var virtualMachineListByResourceGroup* = Call_VirtualMachineListByResourceGroup_564401(
    name: "virtualMachineListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines",
    validator: validate_VirtualMachineListByResourceGroup_564402, base: "",
    url: url_VirtualMachineListByResourceGroup_564403, schemes: {Scheme.Https})
type
  Call_VirtualMachineCreateOrUpdate_564425 = ref object of OpenApiRestCall_563566
proc url_VirtualMachineCreateOrUpdate_564427(protocol: Scheme; host: string;
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

proc validate_VirtualMachineCreateOrUpdate_564426(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create Or Update Virtual Machine
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   virtualMachineName: JString (required)
  ##                     : virtual machine name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `virtualMachineName` field"
  var valid_564428 = path.getOrDefault("virtualMachineName")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "virtualMachineName", valid_564428
  var valid_564429 = path.getOrDefault("subscriptionId")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "subscriptionId", valid_564429
  var valid_564430 = path.getOrDefault("resourceGroupName")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "resourceGroupName", valid_564430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564431 = query.getOrDefault("api-version")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "api-version", valid_564431
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_564432 = header.getOrDefault("Referer")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "Referer", valid_564432
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

proc call*(call_564434: Call_VirtualMachineCreateOrUpdate_564425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create Or Update Virtual Machine
  ## 
  let valid = call_564434.validator(path, query, header, formData, body)
  let scheme = call_564434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564434.url(scheme.get, call_564434.host, call_564434.base,
                         call_564434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564434, url, valid)

proc call*(call_564435: Call_VirtualMachineCreateOrUpdate_564425;
          apiVersion: string; virtualMachineName: string; subscriptionId: string;
          resourceGroupName: string; virtualMachineRequest: JsonNode): Recallable =
  ## virtualMachineCreateOrUpdate
  ## Create Or Update Virtual Machine
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : virtual machine name
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   virtualMachineRequest: JObject (required)
  ##                        : Create or Update Virtual Machine request
  var path_564436 = newJObject()
  var query_564437 = newJObject()
  var body_564438 = newJObject()
  add(query_564437, "api-version", newJString(apiVersion))
  add(path_564436, "virtualMachineName", newJString(virtualMachineName))
  add(path_564436, "subscriptionId", newJString(subscriptionId))
  add(path_564436, "resourceGroupName", newJString(resourceGroupName))
  if virtualMachineRequest != nil:
    body_564438 = virtualMachineRequest
  result = call_564435.call(path_564436, query_564437, nil, nil, body_564438)

var virtualMachineCreateOrUpdate* = Call_VirtualMachineCreateOrUpdate_564425(
    name: "virtualMachineCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}",
    validator: validate_VirtualMachineCreateOrUpdate_564426, base: "",
    url: url_VirtualMachineCreateOrUpdate_564427, schemes: {Scheme.Https})
type
  Call_VirtualMachineGet_564414 = ref object of OpenApiRestCall_563566
proc url_VirtualMachineGet_564416(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineGet_564415(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get virtual machine
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   virtualMachineName: JString (required)
  ##                     : virtual machine name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `virtualMachineName` field"
  var valid_564417 = path.getOrDefault("virtualMachineName")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "virtualMachineName", valid_564417
  var valid_564418 = path.getOrDefault("subscriptionId")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "subscriptionId", valid_564418
  var valid_564419 = path.getOrDefault("resourceGroupName")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "resourceGroupName", valid_564419
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564420 = query.getOrDefault("api-version")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "api-version", valid_564420
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564421: Call_VirtualMachineGet_564414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual machine
  ## 
  let valid = call_564421.validator(path, query, header, formData, body)
  let scheme = call_564421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564421.url(scheme.get, call_564421.host, call_564421.base,
                         call_564421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564421, url, valid)

proc call*(call_564422: Call_VirtualMachineGet_564414; apiVersion: string;
          virtualMachineName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## virtualMachineGet
  ## Get virtual machine
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : virtual machine name
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  var path_564423 = newJObject()
  var query_564424 = newJObject()
  add(query_564424, "api-version", newJString(apiVersion))
  add(path_564423, "virtualMachineName", newJString(virtualMachineName))
  add(path_564423, "subscriptionId", newJString(subscriptionId))
  add(path_564423, "resourceGroupName", newJString(resourceGroupName))
  result = call_564422.call(path_564423, query_564424, nil, nil, nil)

var virtualMachineGet* = Call_VirtualMachineGet_564414(name: "virtualMachineGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}",
    validator: validate_VirtualMachineGet_564415, base: "",
    url: url_VirtualMachineGet_564416, schemes: {Scheme.Https})
type
  Call_VirtualMachineUpdate_564451 = ref object of OpenApiRestCall_563566
proc url_VirtualMachineUpdate_564453(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineUpdate_564452(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch virtual machine properties
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   virtualMachineName: JString (required)
  ##                     : virtual machine name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `virtualMachineName` field"
  var valid_564454 = path.getOrDefault("virtualMachineName")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "virtualMachineName", valid_564454
  var valid_564455 = path.getOrDefault("subscriptionId")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "subscriptionId", valid_564455
  var valid_564456 = path.getOrDefault("resourceGroupName")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "resourceGroupName", valid_564456
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564457 = query.getOrDefault("api-version")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "api-version", valid_564457
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

proc call*(call_564459: Call_VirtualMachineUpdate_564451; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch virtual machine properties
  ## 
  let valid = call_564459.validator(path, query, header, formData, body)
  let scheme = call_564459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564459.url(scheme.get, call_564459.host, call_564459.base,
                         call_564459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564459, url, valid)

proc call*(call_564460: Call_VirtualMachineUpdate_564451; apiVersion: string;
          virtualMachineName: string; subscriptionId: string;
          resourceGroupName: string; virtualMachineRequest: JsonNode): Recallable =
  ## virtualMachineUpdate
  ## Patch virtual machine properties
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : virtual machine name
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   virtualMachineRequest: JObject (required)
  ##                        : Patch virtual machine request
  var path_564461 = newJObject()
  var query_564462 = newJObject()
  var body_564463 = newJObject()
  add(query_564462, "api-version", newJString(apiVersion))
  add(path_564461, "virtualMachineName", newJString(virtualMachineName))
  add(path_564461, "subscriptionId", newJString(subscriptionId))
  add(path_564461, "resourceGroupName", newJString(resourceGroupName))
  if virtualMachineRequest != nil:
    body_564463 = virtualMachineRequest
  result = call_564460.call(path_564461, query_564462, nil, nil, body_564463)

var virtualMachineUpdate* = Call_VirtualMachineUpdate_564451(
    name: "virtualMachineUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}",
    validator: validate_VirtualMachineUpdate_564452, base: "",
    url: url_VirtualMachineUpdate_564453, schemes: {Scheme.Https})
type
  Call_VirtualMachineDelete_564439 = ref object of OpenApiRestCall_563566
proc url_VirtualMachineDelete_564441(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineDelete_564440(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete virtual machine
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   virtualMachineName: JString (required)
  ##                     : virtual machine name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `virtualMachineName` field"
  var valid_564442 = path.getOrDefault("virtualMachineName")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "virtualMachineName", valid_564442
  var valid_564443 = path.getOrDefault("subscriptionId")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "subscriptionId", valid_564443
  var valid_564444 = path.getOrDefault("resourceGroupName")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "resourceGroupName", valid_564444
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564445 = query.getOrDefault("api-version")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "api-version", valid_564445
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_564446 = header.getOrDefault("Referer")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "Referer", valid_564446
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564447: Call_VirtualMachineDelete_564439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual machine
  ## 
  let valid = call_564447.validator(path, query, header, formData, body)
  let scheme = call_564447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564447.url(scheme.get, call_564447.host, call_564447.base,
                         call_564447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564447, url, valid)

proc call*(call_564448: Call_VirtualMachineDelete_564439; apiVersion: string;
          virtualMachineName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## virtualMachineDelete
  ## Delete virtual machine
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : virtual machine name
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  var path_564449 = newJObject()
  var query_564450 = newJObject()
  add(query_564450, "api-version", newJString(apiVersion))
  add(path_564449, "virtualMachineName", newJString(virtualMachineName))
  add(path_564449, "subscriptionId", newJString(subscriptionId))
  add(path_564449, "resourceGroupName", newJString(resourceGroupName))
  result = call_564448.call(path_564449, query_564450, nil, nil, nil)

var virtualMachineDelete* = Call_VirtualMachineDelete_564439(
    name: "virtualMachineDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}",
    validator: validate_VirtualMachineDelete_564440, base: "",
    url: url_VirtualMachineDelete_564441, schemes: {Scheme.Https})
type
  Call_VirtualMachineStart_564464 = ref object of OpenApiRestCall_563566
proc url_VirtualMachineStart_564466(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineStart_564465(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Power on virtual machine
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   virtualMachineName: JString (required)
  ##                     : virtual machine name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `virtualMachineName` field"
  var valid_564467 = path.getOrDefault("virtualMachineName")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "virtualMachineName", valid_564467
  var valid_564468 = path.getOrDefault("subscriptionId")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "subscriptionId", valid_564468
  var valid_564469 = path.getOrDefault("resourceGroupName")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "resourceGroupName", valid_564469
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564470 = query.getOrDefault("api-version")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "api-version", valid_564470
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_564471 = header.getOrDefault("Referer")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "Referer", valid_564471
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564472: Call_VirtualMachineStart_564464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Power on virtual machine
  ## 
  let valid = call_564472.validator(path, query, header, formData, body)
  let scheme = call_564472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564472.url(scheme.get, call_564472.host, call_564472.base,
                         call_564472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564472, url, valid)

proc call*(call_564473: Call_VirtualMachineStart_564464; apiVersion: string;
          virtualMachineName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## virtualMachineStart
  ## Power on virtual machine
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : virtual machine name
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  var path_564474 = newJObject()
  var query_564475 = newJObject()
  add(query_564475, "api-version", newJString(apiVersion))
  add(path_564474, "virtualMachineName", newJString(virtualMachineName))
  add(path_564474, "subscriptionId", newJString(subscriptionId))
  add(path_564474, "resourceGroupName", newJString(resourceGroupName))
  result = call_564473.call(path_564474, query_564475, nil, nil, nil)

var virtualMachineStart* = Call_VirtualMachineStart_564464(
    name: "virtualMachineStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}/start",
    validator: validate_VirtualMachineStart_564465, base: "",
    url: url_VirtualMachineStart_564466, schemes: {Scheme.Https})
type
  Call_VirtualMachineStop_564476 = ref object of OpenApiRestCall_563566
proc url_VirtualMachineStop_564478(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineStop_564477(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Power off virtual machine, options: shutdown, poweroff, and suspend
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   virtualMachineName: JString (required)
  ##                     : virtual machine name
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `virtualMachineName` field"
  var valid_564479 = path.getOrDefault("virtualMachineName")
  valid_564479 = validateParameter(valid_564479, JString, required = true,
                                 default = nil)
  if valid_564479 != nil:
    section.add "virtualMachineName", valid_564479
  var valid_564480 = path.getOrDefault("subscriptionId")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "subscriptionId", valid_564480
  var valid_564481 = path.getOrDefault("resourceGroupName")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "resourceGroupName", valid_564481
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   mode: JString
  ##       : query stop mode parameter (reboot, shutdown, etc...)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564482 = query.getOrDefault("api-version")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "api-version", valid_564482
  var valid_564496 = query.getOrDefault("mode")
  valid_564496 = validateParameter(valid_564496, JString, required = false,
                                 default = newJString("reboot"))
  if valid_564496 != nil:
    section.add "mode", valid_564496
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_564497 = header.getOrDefault("Referer")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "Referer", valid_564497
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   m: JObject
  ##    : body stop mode parameter (reboot, shutdown, etc...)
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564499: Call_VirtualMachineStop_564476; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Power off virtual machine, options: shutdown, poweroff, and suspend
  ## 
  let valid = call_564499.validator(path, query, header, formData, body)
  let scheme = call_564499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564499.url(scheme.get, call_564499.host, call_564499.base,
                         call_564499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564499, url, valid)

proc call*(call_564500: Call_VirtualMachineStop_564476; apiVersion: string;
          virtualMachineName: string; subscriptionId: string;
          resourceGroupName: string; mode: string = "reboot"; m: JsonNode = nil): Recallable =
  ## virtualMachineStop
  ## Power off virtual machine, options: shutdown, poweroff, and suspend
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   mode: string
  ##       : query stop mode parameter (reboot, shutdown, etc...)
  ##   virtualMachineName: string (required)
  ##                     : virtual machine name
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group
  ##   m: JObject
  ##    : body stop mode parameter (reboot, shutdown, etc...)
  var path_564501 = newJObject()
  var query_564502 = newJObject()
  var body_564503 = newJObject()
  add(query_564502, "api-version", newJString(apiVersion))
  add(query_564502, "mode", newJString(mode))
  add(path_564501, "virtualMachineName", newJString(virtualMachineName))
  add(path_564501, "subscriptionId", newJString(subscriptionId))
  add(path_564501, "resourceGroupName", newJString(resourceGroupName))
  if m != nil:
    body_564503 = m
  result = call_564500.call(path_564501, query_564502, nil, nil, body_564503)

var virtualMachineStop* = Call_VirtualMachineStop_564476(
    name: "virtualMachineStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}/stop",
    validator: validate_VirtualMachineStop_564477, base: "",
    url: url_VirtualMachineStop_564478, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
