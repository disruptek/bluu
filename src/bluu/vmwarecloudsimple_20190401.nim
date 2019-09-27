
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593439 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593439](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593439): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_AvailableOperationsList_593661 = ref object of OpenApiRestCall_593439
proc url_AvailableOperationsList_593663(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AvailableOperationsList_593662(path: JsonNode; query: JsonNode;
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
  var valid_593822 = query.getOrDefault("api-version")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "api-version", valid_593822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_AvailableOperationsList_593661; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return list of operations
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_AvailableOperationsList_593661; apiVersion: string): Recallable =
  ## availableOperationsList
  ## Return list of operations
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_593917 = newJObject()
  add(query_593917, "api-version", newJString(apiVersion))
  result = call_593916.call(nil, query_593917, nil, nil, nil)

var availableOperationsList* = Call_AvailableOperationsList_593661(
    name: "availableOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.VMwareCloudSimple/operations",
    validator: validate_AvailableOperationsList_593662, base: "",
    url: url_AvailableOperationsList_593663, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeListBySubscription_593957 = ref object of OpenApiRestCall_593439
proc url_DedicatedCloudNodeListBySubscription_593959(protocol: Scheme;
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

proc validate_DedicatedCloudNodeListBySubscription_593958(path: JsonNode;
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
  var valid_593975 = path.getOrDefault("subscriptionId")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "subscriptionId", valid_593975
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
  var valid_593976 = query.getOrDefault("api-version")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "api-version", valid_593976
  var valid_593977 = query.getOrDefault("$top")
  valid_593977 = validateParameter(valid_593977, JInt, required = false, default = nil)
  if valid_593977 != nil:
    section.add "$top", valid_593977
  var valid_593978 = query.getOrDefault("$skipToken")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "$skipToken", valid_593978
  var valid_593979 = query.getOrDefault("$filter")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "$filter", valid_593979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593980: Call_DedicatedCloudNodeListBySubscription_593957;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of dedicate cloud nodes within subscription
  ## 
  let valid = call_593980.validator(path, query, header, formData, body)
  let scheme = call_593980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593980.url(scheme.get, call_593980.host, call_593980.base,
                         call_593980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593980, url, valid)

proc call*(call_593981: Call_DedicatedCloudNodeListBySubscription_593957;
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
  var path_593982 = newJObject()
  var query_593983 = newJObject()
  add(query_593983, "api-version", newJString(apiVersion))
  add(path_593982, "subscriptionId", newJString(subscriptionId))
  add(query_593983, "$top", newJInt(Top))
  add(query_593983, "$skipToken", newJString(SkipToken))
  add(query_593983, "$filter", newJString(Filter))
  result = call_593981.call(path_593982, query_593983, nil, nil, nil)

var dedicatedCloudNodeListBySubscription* = Call_DedicatedCloudNodeListBySubscription_593957(
    name: "dedicatedCloudNodeListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes",
    validator: validate_DedicatedCloudNodeListBySubscription_593958, base: "",
    url: url_DedicatedCloudNodeListBySubscription_593959, schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceListBySubscription_593984 = ref object of OpenApiRestCall_593439
proc url_DedicatedCloudServiceListBySubscription_593986(protocol: Scheme;
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

proc validate_DedicatedCloudServiceListBySubscription_593985(path: JsonNode;
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
  var valid_593987 = path.getOrDefault("subscriptionId")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "subscriptionId", valid_593987
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
  var valid_593988 = query.getOrDefault("api-version")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "api-version", valid_593988
  var valid_593989 = query.getOrDefault("$top")
  valid_593989 = validateParameter(valid_593989, JInt, required = false, default = nil)
  if valid_593989 != nil:
    section.add "$top", valid_593989
  var valid_593990 = query.getOrDefault("$skipToken")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "$skipToken", valid_593990
  var valid_593991 = query.getOrDefault("$filter")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "$filter", valid_593991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593992: Call_DedicatedCloudServiceListBySubscription_593984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of dedicated cloud services within a subscription
  ## 
  let valid = call_593992.validator(path, query, header, formData, body)
  let scheme = call_593992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593992.url(scheme.get, call_593992.host, call_593992.base,
                         call_593992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593992, url, valid)

proc call*(call_593993: Call_DedicatedCloudServiceListBySubscription_593984;
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
  var path_593994 = newJObject()
  var query_593995 = newJObject()
  add(query_593995, "api-version", newJString(apiVersion))
  add(path_593994, "subscriptionId", newJString(subscriptionId))
  add(query_593995, "$top", newJInt(Top))
  add(query_593995, "$skipToken", newJString(SkipToken))
  add(query_593995, "$filter", newJString(Filter))
  result = call_593993.call(path_593994, query_593995, nil, nil, nil)

var dedicatedCloudServiceListBySubscription* = Call_DedicatedCloudServiceListBySubscription_593984(
    name: "dedicatedCloudServiceListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices",
    validator: validate_DedicatedCloudServiceListBySubscription_593985, base: "",
    url: url_DedicatedCloudServiceListBySubscription_593986,
    schemes: {Scheme.Https})
type
  Call_SkusAvailabilityWithinRegionList_593996 = ref object of OpenApiRestCall_593439
proc url_SkusAvailabilityWithinRegionList_593998(protocol: Scheme; host: string;
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

proc validate_SkusAvailabilityWithinRegionList_593997(path: JsonNode;
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
  var valid_593999 = path.getOrDefault("subscriptionId")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "subscriptionId", valid_593999
  var valid_594000 = path.getOrDefault("regionId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "regionId", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   skuId: JString
  ##        : sku id, if no sku is passed availability for all skus will be returned
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
  var valid_594002 = query.getOrDefault("skuId")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "skuId", valid_594002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594003: Call_SkusAvailabilityWithinRegionList_593996;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of available resources in region
  ## 
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_SkusAvailabilityWithinRegionList_593996;
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
  var path_594005 = newJObject()
  var query_594006 = newJObject()
  add(query_594006, "api-version", newJString(apiVersion))
  add(path_594005, "subscriptionId", newJString(subscriptionId))
  add(query_594006, "skuId", newJString(skuId))
  add(path_594005, "regionId", newJString(regionId))
  result = call_594004.call(path_594005, query_594006, nil, nil, nil)

var skusAvailabilityWithinRegionList* = Call_SkusAvailabilityWithinRegionList_593996(
    name: "skusAvailabilityWithinRegionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/availabilities",
    validator: validate_SkusAvailabilityWithinRegionList_593997, base: "",
    url: url_SkusAvailabilityWithinRegionList_593998, schemes: {Scheme.Https})
type
  Call_GetOperationResultByRegion_594007 = ref object of OpenApiRestCall_593439
proc url_GetOperationResultByRegion_594009(protocol: Scheme; host: string;
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

proc validate_GetOperationResultByRegion_594008(path: JsonNode; query: JsonNode;
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
  var valid_594010 = path.getOrDefault("subscriptionId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "subscriptionId", valid_594010
  var valid_594011 = path.getOrDefault("operationId")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "operationId", valid_594011
  var valid_594012 = path.getOrDefault("regionId")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "regionId", valid_594012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594013 = query.getOrDefault("api-version")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "api-version", valid_594013
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_594014 = header.getOrDefault("Referer")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "Referer", valid_594014
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_GetOperationResultByRegion_594007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return an async operation
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_GetOperationResultByRegion_594007; apiVersion: string;
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
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  add(query_594018, "api-version", newJString(apiVersion))
  add(path_594017, "subscriptionId", newJString(subscriptionId))
  add(path_594017, "operationId", newJString(operationId))
  add(path_594017, "regionId", newJString(regionId))
  result = call_594016.call(path_594017, query_594018, nil, nil, nil)

var getOperationResultByRegion* = Call_GetOperationResultByRegion_594007(
    name: "getOperationResultByRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/operationResults/{operationId}",
    validator: validate_GetOperationResultByRegion_594008, base: "",
    url: url_GetOperationResultByRegion_594009, schemes: {Scheme.Https})
type
  Call_PrivateCloudByRegionList_594019 = ref object of OpenApiRestCall_593439
proc url_PrivateCloudByRegionList_594021(protocol: Scheme; host: string;
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

proc validate_PrivateCloudByRegionList_594020(path: JsonNode; query: JsonNode;
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
  var valid_594022 = path.getOrDefault("subscriptionId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "subscriptionId", valid_594022
  var valid_594023 = path.getOrDefault("regionId")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "regionId", valid_594023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594024 = query.getOrDefault("api-version")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "api-version", valid_594024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594025: Call_PrivateCloudByRegionList_594019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns list of private clouds in particular region
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_PrivateCloudByRegionList_594019; apiVersion: string;
          subscriptionId: string; regionId: string): Recallable =
  ## privateCloudByRegionList
  ## Returns list of private clouds in particular region
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   regionId: string (required)
  ##           : The region Id (westus, eastus)
  var path_594027 = newJObject()
  var query_594028 = newJObject()
  add(query_594028, "api-version", newJString(apiVersion))
  add(path_594027, "subscriptionId", newJString(subscriptionId))
  add(path_594027, "regionId", newJString(regionId))
  result = call_594026.call(path_594027, query_594028, nil, nil, nil)

var privateCloudByRegionList* = Call_PrivateCloudByRegionList_594019(
    name: "privateCloudByRegionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds",
    validator: validate_PrivateCloudByRegionList_594020, base: "",
    url: url_PrivateCloudByRegionList_594021, schemes: {Scheme.Https})
type
  Call_GetPrivateCloud_594029 = ref object of OpenApiRestCall_593439
proc url_GetPrivateCloud_594031(protocol: Scheme; host: string; base: string;
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

proc validate_GetPrivateCloud_594030(path: JsonNode; query: JsonNode;
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
  var valid_594032 = path.getOrDefault("subscriptionId")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "subscriptionId", valid_594032
  var valid_594033 = path.getOrDefault("pcName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "pcName", valid_594033
  var valid_594034 = path.getOrDefault("regionId")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "regionId", valid_594034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594035 = query.getOrDefault("api-version")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "api-version", valid_594035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594036: Call_GetPrivateCloud_594029; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns private cloud by its name
  ## 
  let valid = call_594036.validator(path, query, header, formData, body)
  let scheme = call_594036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594036.url(scheme.get, call_594036.host, call_594036.base,
                         call_594036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594036, url, valid)

proc call*(call_594037: Call_GetPrivateCloud_594029; apiVersion: string;
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
  var path_594038 = newJObject()
  var query_594039 = newJObject()
  add(query_594039, "api-version", newJString(apiVersion))
  add(path_594038, "subscriptionId", newJString(subscriptionId))
  add(path_594038, "pcName", newJString(pcName))
  add(path_594038, "regionId", newJString(regionId))
  result = call_594037.call(path_594038, query_594039, nil, nil, nil)

var getPrivateCloud* = Call_GetPrivateCloud_594029(name: "getPrivateCloud",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}",
    validator: validate_GetPrivateCloud_594030, base: "", url: url_GetPrivateCloud_594031,
    schemes: {Scheme.Https})
type
  Call_ResourcePoolsByPCList_594040 = ref object of OpenApiRestCall_593439
proc url_ResourcePoolsByPCList_594042(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcePoolsByPCList_594041(path: JsonNode; query: JsonNode;
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
  var valid_594043 = path.getOrDefault("subscriptionId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "subscriptionId", valid_594043
  var valid_594044 = path.getOrDefault("pcName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "pcName", valid_594044
  var valid_594045 = path.getOrDefault("regionId")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "regionId", valid_594045
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594046 = query.getOrDefault("api-version")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "api-version", valid_594046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594047: Call_ResourcePoolsByPCList_594040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns list of resource pools in region for private cloud
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_ResourcePoolsByPCList_594040; apiVersion: string;
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
  var path_594049 = newJObject()
  var query_594050 = newJObject()
  add(query_594050, "api-version", newJString(apiVersion))
  add(path_594049, "subscriptionId", newJString(subscriptionId))
  add(path_594049, "pcName", newJString(pcName))
  add(path_594049, "regionId", newJString(regionId))
  result = call_594048.call(path_594049, query_594050, nil, nil, nil)

var resourcePoolsByPCList* = Call_ResourcePoolsByPCList_594040(
    name: "resourcePoolsByPCList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/resourcePools",
    validator: validate_ResourcePoolsByPCList_594041, base: "",
    url: url_ResourcePoolsByPCList_594042, schemes: {Scheme.Https})
type
  Call_ResourcePoolByPCGet_594051 = ref object of OpenApiRestCall_593439
proc url_ResourcePoolByPCGet_594053(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcePoolByPCGet_594052(path: JsonNode; query: JsonNode;
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
  var valid_594054 = path.getOrDefault("subscriptionId")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "subscriptionId", valid_594054
  var valid_594055 = path.getOrDefault("resourcePoolName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "resourcePoolName", valid_594055
  var valid_594056 = path.getOrDefault("pcName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "pcName", valid_594056
  var valid_594057 = path.getOrDefault("regionId")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "regionId", valid_594057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594058 = query.getOrDefault("api-version")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "api-version", valid_594058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594059: Call_ResourcePoolByPCGet_594051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns resource pool templates by its name
  ## 
  let valid = call_594059.validator(path, query, header, formData, body)
  let scheme = call_594059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594059.url(scheme.get, call_594059.host, call_594059.base,
                         call_594059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594059, url, valid)

proc call*(call_594060: Call_ResourcePoolByPCGet_594051; apiVersion: string;
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
  var path_594061 = newJObject()
  var query_594062 = newJObject()
  add(query_594062, "api-version", newJString(apiVersion))
  add(path_594061, "subscriptionId", newJString(subscriptionId))
  add(path_594061, "resourcePoolName", newJString(resourcePoolName))
  add(path_594061, "pcName", newJString(pcName))
  add(path_594061, "regionId", newJString(regionId))
  result = call_594060.call(path_594061, query_594062, nil, nil, nil)

var resourcePoolByPCGet* = Call_ResourcePoolByPCGet_594051(
    name: "resourcePoolByPCGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/resourcePools/{resourcePoolName}",
    validator: validate_ResourcePoolByPCGet_594052, base: "",
    url: url_ResourcePoolByPCGet_594053, schemes: {Scheme.Https})
type
  Call_VirtualMachineTemplatesByPCList_594063 = ref object of OpenApiRestCall_593439
proc url_VirtualMachineTemplatesByPCList_594065(protocol: Scheme; host: string;
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

proc validate_VirtualMachineTemplatesByPCList_594064(path: JsonNode;
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
  var valid_594066 = path.getOrDefault("subscriptionId")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "subscriptionId", valid_594066
  var valid_594067 = path.getOrDefault("pcName")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "pcName", valid_594067
  var valid_594068 = path.getOrDefault("regionId")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "regionId", valid_594068
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   resourcePoolName: JString (required)
  ##                   : Resource pool used to derive vSphere cluster which contains VM templates
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594069 = query.getOrDefault("api-version")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "api-version", valid_594069
  var valid_594070 = query.getOrDefault("resourcePoolName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "resourcePoolName", valid_594070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594071: Call_VirtualMachineTemplatesByPCList_594063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of virtual machine templates in region for private cloud
  ## 
  let valid = call_594071.validator(path, query, header, formData, body)
  let scheme = call_594071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594071.url(scheme.get, call_594071.host, call_594071.base,
                         call_594071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594071, url, valid)

proc call*(call_594072: Call_VirtualMachineTemplatesByPCList_594063;
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
  var path_594073 = newJObject()
  var query_594074 = newJObject()
  add(query_594074, "api-version", newJString(apiVersion))
  add(path_594073, "subscriptionId", newJString(subscriptionId))
  add(query_594074, "resourcePoolName", newJString(resourcePoolName))
  add(path_594073, "pcName", newJString(pcName))
  add(path_594073, "regionId", newJString(regionId))
  result = call_594072.call(path_594073, query_594074, nil, nil, nil)

var virtualMachineTemplatesByPCList* = Call_VirtualMachineTemplatesByPCList_594063(
    name: "virtualMachineTemplatesByPCList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/virtualMachineTemplates",
    validator: validate_VirtualMachineTemplatesByPCList_594064, base: "",
    url: url_VirtualMachineTemplatesByPCList_594065, schemes: {Scheme.Https})
type
  Call_VirtualMachineTemplateByPCGet_594075 = ref object of OpenApiRestCall_593439
proc url_VirtualMachineTemplateByPCGet_594077(protocol: Scheme; host: string;
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

proc validate_VirtualMachineTemplateByPCGet_594076(path: JsonNode; query: JsonNode;
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
  var valid_594078 = path.getOrDefault("subscriptionId")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "subscriptionId", valid_594078
  var valid_594079 = path.getOrDefault("virtualMachineTemplateName")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "virtualMachineTemplateName", valid_594079
  var valid_594080 = path.getOrDefault("pcName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "pcName", valid_594080
  var valid_594081 = path.getOrDefault("regionId")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "regionId", valid_594081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594082 = query.getOrDefault("api-version")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "api-version", valid_594082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594083: Call_VirtualMachineTemplateByPCGet_594075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns virtual machine templates by its name
  ## 
  let valid = call_594083.validator(path, query, header, formData, body)
  let scheme = call_594083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594083.url(scheme.get, call_594083.host, call_594083.base,
                         call_594083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594083, url, valid)

proc call*(call_594084: Call_VirtualMachineTemplateByPCGet_594075;
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
  var path_594085 = newJObject()
  var query_594086 = newJObject()
  add(query_594086, "api-version", newJString(apiVersion))
  add(path_594085, "subscriptionId", newJString(subscriptionId))
  add(path_594085, "virtualMachineTemplateName",
      newJString(virtualMachineTemplateName))
  add(path_594085, "pcName", newJString(pcName))
  add(path_594085, "regionId", newJString(regionId))
  result = call_594084.call(path_594085, query_594086, nil, nil, nil)

var virtualMachineTemplateByPCGet* = Call_VirtualMachineTemplateByPCGet_594075(
    name: "virtualMachineTemplateByPCGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/virtualMachineTemplates/{virtualMachineTemplateName}",
    validator: validate_VirtualMachineTemplateByPCGet_594076, base: "",
    url: url_VirtualMachineTemplateByPCGet_594077, schemes: {Scheme.Https})
type
  Call_VirtualNetworksByPCList_594087 = ref object of OpenApiRestCall_593439
proc url_VirtualNetworksByPCList_594089(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksByPCList_594088(path: JsonNode; query: JsonNode;
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
  var valid_594090 = path.getOrDefault("subscriptionId")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "subscriptionId", valid_594090
  var valid_594091 = path.getOrDefault("pcName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "pcName", valid_594091
  var valid_594092 = path.getOrDefault("regionId")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "regionId", valid_594092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   resourcePoolName: JString (required)
  ##                   : Resource pool used to derive vSphere cluster which contains virtual networks
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594093 = query.getOrDefault("api-version")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "api-version", valid_594093
  var valid_594094 = query.getOrDefault("resourcePoolName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "resourcePoolName", valid_594094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594095: Call_VirtualNetworksByPCList_594087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return list of virtual networks in location for private cloud
  ## 
  let valid = call_594095.validator(path, query, header, formData, body)
  let scheme = call_594095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594095.url(scheme.get, call_594095.host, call_594095.base,
                         call_594095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594095, url, valid)

proc call*(call_594096: Call_VirtualNetworksByPCList_594087; apiVersion: string;
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
  var path_594097 = newJObject()
  var query_594098 = newJObject()
  add(query_594098, "api-version", newJString(apiVersion))
  add(path_594097, "subscriptionId", newJString(subscriptionId))
  add(query_594098, "resourcePoolName", newJString(resourcePoolName))
  add(path_594097, "pcName", newJString(pcName))
  add(path_594097, "regionId", newJString(regionId))
  result = call_594096.call(path_594097, query_594098, nil, nil, nil)

var virtualNetworksByPCList* = Call_VirtualNetworksByPCList_594087(
    name: "virtualNetworksByPCList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/virtualNetworks",
    validator: validate_VirtualNetworksByPCList_594088, base: "",
    url: url_VirtualNetworksByPCList_594089, schemes: {Scheme.Https})
type
  Call_VirtualNetworkByPCGet_594099 = ref object of OpenApiRestCall_593439
proc url_VirtualNetworkByPCGet_594101(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworkByPCGet_594100(path: JsonNode; query: JsonNode;
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
  var valid_594102 = path.getOrDefault("subscriptionId")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "subscriptionId", valid_594102
  var valid_594103 = path.getOrDefault("virtualNetworkName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "virtualNetworkName", valid_594103
  var valid_594104 = path.getOrDefault("pcName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "pcName", valid_594104
  var valid_594105 = path.getOrDefault("regionId")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "regionId", valid_594105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594106 = query.getOrDefault("api-version")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "api-version", valid_594106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594107: Call_VirtualNetworkByPCGet_594099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return virtual network by its name
  ## 
  let valid = call_594107.validator(path, query, header, formData, body)
  let scheme = call_594107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594107.url(scheme.get, call_594107.host, call_594107.base,
                         call_594107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594107, url, valid)

proc call*(call_594108: Call_VirtualNetworkByPCGet_594099; apiVersion: string;
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
  var path_594109 = newJObject()
  var query_594110 = newJObject()
  add(query_594110, "api-version", newJString(apiVersion))
  add(path_594109, "subscriptionId", newJString(subscriptionId))
  add(path_594109, "virtualNetworkName", newJString(virtualNetworkName))
  add(path_594109, "pcName", newJString(pcName))
  add(path_594109, "regionId", newJString(regionId))
  result = call_594108.call(path_594109, query_594110, nil, nil, nil)

var virtualNetworkByPCGet* = Call_VirtualNetworkByPCGet_594099(
    name: "virtualNetworkByPCGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/privateClouds/{pcName}/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworkByPCGet_594100, base: "",
    url: url_VirtualNetworkByPCGet_594101, schemes: {Scheme.Https})
type
  Call_UsagesWithinRegionList_594111 = ref object of OpenApiRestCall_593439
proc url_UsagesWithinRegionList_594113(protocol: Scheme; host: string; base: string;
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

proc validate_UsagesWithinRegionList_594112(path: JsonNode; query: JsonNode;
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
  var valid_594114 = path.getOrDefault("subscriptionId")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "subscriptionId", valid_594114
  var valid_594115 = path.getOrDefault("regionId")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "regionId", valid_594115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The filter to apply on the list operation. only name.value is allowed here as a filter e.g. $filter=name.value eq 'xxxx'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594116 = query.getOrDefault("api-version")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "api-version", valid_594116
  var valid_594117 = query.getOrDefault("$filter")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "$filter", valid_594117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594118: Call_UsagesWithinRegionList_594111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns list of usage in region
  ## 
  let valid = call_594118.validator(path, query, header, formData, body)
  let scheme = call_594118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594118.url(scheme.get, call_594118.host, call_594118.base,
                         call_594118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594118, url, valid)

proc call*(call_594119: Call_UsagesWithinRegionList_594111; apiVersion: string;
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
  var path_594120 = newJObject()
  var query_594121 = newJObject()
  add(query_594121, "api-version", newJString(apiVersion))
  add(path_594120, "subscriptionId", newJString(subscriptionId))
  add(path_594120, "regionId", newJString(regionId))
  add(query_594121, "$filter", newJString(Filter))
  result = call_594119.call(path_594120, query_594121, nil, nil, nil)

var usagesWithinRegionList* = Call_UsagesWithinRegionList_594111(
    name: "usagesWithinRegionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/locations/{regionId}/usages",
    validator: validate_UsagesWithinRegionList_594112, base: "",
    url: url_UsagesWithinRegionList_594113, schemes: {Scheme.Https})
type
  Call_VirtualMachineListBySubscription_594122 = ref object of OpenApiRestCall_593439
proc url_VirtualMachineListBySubscription_594124(protocol: Scheme; host: string;
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

proc validate_VirtualMachineListBySubscription_594123(path: JsonNode;
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
  var valid_594125 = path.getOrDefault("subscriptionId")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "subscriptionId", valid_594125
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
  var valid_594126 = query.getOrDefault("api-version")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "api-version", valid_594126
  var valid_594127 = query.getOrDefault("$top")
  valid_594127 = validateParameter(valid_594127, JInt, required = false, default = nil)
  if valid_594127 != nil:
    section.add "$top", valid_594127
  var valid_594128 = query.getOrDefault("$skipToken")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "$skipToken", valid_594128
  var valid_594129 = query.getOrDefault("$filter")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "$filter", valid_594129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594130: Call_VirtualMachineListBySubscription_594122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list virtual machine within subscription
  ## 
  let valid = call_594130.validator(path, query, header, formData, body)
  let scheme = call_594130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594130.url(scheme.get, call_594130.host, call_594130.base,
                         call_594130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594130, url, valid)

proc call*(call_594131: Call_VirtualMachineListBySubscription_594122;
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
  var path_594132 = newJObject()
  var query_594133 = newJObject()
  add(query_594133, "api-version", newJString(apiVersion))
  add(path_594132, "subscriptionId", newJString(subscriptionId))
  add(query_594133, "$top", newJInt(Top))
  add(query_594133, "$skipToken", newJString(SkipToken))
  add(query_594133, "$filter", newJString(Filter))
  result = call_594131.call(path_594132, query_594133, nil, nil, nil)

var virtualMachineListBySubscription* = Call_VirtualMachineListBySubscription_594122(
    name: "virtualMachineListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.VMwareCloudSimple/virtualMachines",
    validator: validate_VirtualMachineListBySubscription_594123, base: "",
    url: url_VirtualMachineListBySubscription_594124, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeListByResourceGroup_594134 = ref object of OpenApiRestCall_593439
proc url_DedicatedCloudNodeListByResourceGroup_594136(protocol: Scheme;
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

proc validate_DedicatedCloudNodeListByResourceGroup_594135(path: JsonNode;
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
  var valid_594137 = path.getOrDefault("resourceGroupName")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "resourceGroupName", valid_594137
  var valid_594138 = path.getOrDefault("subscriptionId")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "subscriptionId", valid_594138
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
  var valid_594139 = query.getOrDefault("api-version")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "api-version", valid_594139
  var valid_594140 = query.getOrDefault("$top")
  valid_594140 = validateParameter(valid_594140, JInt, required = false, default = nil)
  if valid_594140 != nil:
    section.add "$top", valid_594140
  var valid_594141 = query.getOrDefault("$skipToken")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "$skipToken", valid_594141
  var valid_594142 = query.getOrDefault("$filter")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "$filter", valid_594142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594143: Call_DedicatedCloudNodeListByResourceGroup_594134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of dedicate cloud nodes within resource group
  ## 
  let valid = call_594143.validator(path, query, header, formData, body)
  let scheme = call_594143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594143.url(scheme.get, call_594143.host, call_594143.base,
                         call_594143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594143, url, valid)

proc call*(call_594144: Call_DedicatedCloudNodeListByResourceGroup_594134;
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
  var path_594145 = newJObject()
  var query_594146 = newJObject()
  add(path_594145, "resourceGroupName", newJString(resourceGroupName))
  add(query_594146, "api-version", newJString(apiVersion))
  add(path_594145, "subscriptionId", newJString(subscriptionId))
  add(query_594146, "$top", newJInt(Top))
  add(query_594146, "$skipToken", newJString(SkipToken))
  add(query_594146, "$filter", newJString(Filter))
  result = call_594144.call(path_594145, query_594146, nil, nil, nil)

var dedicatedCloudNodeListByResourceGroup* = Call_DedicatedCloudNodeListByResourceGroup_594134(
    name: "dedicatedCloudNodeListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes",
    validator: validate_DedicatedCloudNodeListByResourceGroup_594135, base: "",
    url: url_DedicatedCloudNodeListByResourceGroup_594136, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeCreateOrUpdate_594156 = ref object of OpenApiRestCall_593439
proc url_DedicatedCloudNodeCreateOrUpdate_594158(protocol: Scheme; host: string;
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

proc validate_DedicatedCloudNodeCreateOrUpdate_594157(path: JsonNode;
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
  var valid_594176 = path.getOrDefault("resourceGroupName")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "resourceGroupName", valid_594176
  var valid_594177 = path.getOrDefault("subscriptionId")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "subscriptionId", valid_594177
  var valid_594178 = path.getOrDefault("dedicatedCloudNodeName")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "dedicatedCloudNodeName", valid_594178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594179 = query.getOrDefault("api-version")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "api-version", valid_594179
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_594180 = header.getOrDefault("Referer")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "Referer", valid_594180
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

proc call*(call_594182: Call_DedicatedCloudNodeCreateOrUpdate_594156;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns dedicated cloud node by its name
  ## 
  let valid = call_594182.validator(path, query, header, formData, body)
  let scheme = call_594182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594182.url(scheme.get, call_594182.host, call_594182.base,
                         call_594182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594182, url, valid)

proc call*(call_594183: Call_DedicatedCloudNodeCreateOrUpdate_594156;
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
  var path_594184 = newJObject()
  var query_594185 = newJObject()
  var body_594186 = newJObject()
  add(path_594184, "resourceGroupName", newJString(resourceGroupName))
  add(query_594185, "api-version", newJString(apiVersion))
  add(path_594184, "subscriptionId", newJString(subscriptionId))
  if dedicatedCloudNodeRequest != nil:
    body_594186 = dedicatedCloudNodeRequest
  add(path_594184, "dedicatedCloudNodeName", newJString(dedicatedCloudNodeName))
  result = call_594183.call(path_594184, query_594185, nil, nil, body_594186)

var dedicatedCloudNodeCreateOrUpdate* = Call_DedicatedCloudNodeCreateOrUpdate_594156(
    name: "dedicatedCloudNodeCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes/{dedicatedCloudNodeName}",
    validator: validate_DedicatedCloudNodeCreateOrUpdate_594157, base: "",
    url: url_DedicatedCloudNodeCreateOrUpdate_594158, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeGet_594147 = ref object of OpenApiRestCall_593439
proc url_DedicatedCloudNodeGet_594149(protocol: Scheme; host: string; base: string;
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

proc validate_DedicatedCloudNodeGet_594148(path: JsonNode; query: JsonNode;
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
  var valid_594150 = path.getOrDefault("resourceGroupName")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "resourceGroupName", valid_594150
  var valid_594151 = path.getOrDefault("subscriptionId")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "subscriptionId", valid_594151
  var valid_594152 = path.getOrDefault("dedicatedCloudNodeName")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "dedicatedCloudNodeName", valid_594152
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594153: Call_DedicatedCloudNodeGet_594147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns dedicated cloud node
  ## 
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_DedicatedCloudNodeGet_594147;
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
  var path_594155 = newJObject()
  add(path_594155, "resourceGroupName", newJString(resourceGroupName))
  add(path_594155, "subscriptionId", newJString(subscriptionId))
  add(path_594155, "dedicatedCloudNodeName", newJString(dedicatedCloudNodeName))
  result = call_594154.call(path_594155, nil, nil, nil, nil)

var dedicatedCloudNodeGet* = Call_DedicatedCloudNodeGet_594147(
    name: "dedicatedCloudNodeGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes/{dedicatedCloudNodeName}",
    validator: validate_DedicatedCloudNodeGet_594148, base: "",
    url: url_DedicatedCloudNodeGet_594149, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeUpdate_594198 = ref object of OpenApiRestCall_593439
proc url_DedicatedCloudNodeUpdate_594200(protocol: Scheme; host: string;
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

proc validate_DedicatedCloudNodeUpdate_594199(path: JsonNode; query: JsonNode;
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
  var valid_594201 = path.getOrDefault("resourceGroupName")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "resourceGroupName", valid_594201
  var valid_594202 = path.getOrDefault("subscriptionId")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "subscriptionId", valid_594202
  var valid_594203 = path.getOrDefault("dedicatedCloudNodeName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "dedicatedCloudNodeName", valid_594203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594204 = query.getOrDefault("api-version")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "api-version", valid_594204
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

proc call*(call_594206: Call_DedicatedCloudNodeUpdate_594198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches dedicated node properties
  ## 
  let valid = call_594206.validator(path, query, header, formData, body)
  let scheme = call_594206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594206.url(scheme.get, call_594206.host, call_594206.base,
                         call_594206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594206, url, valid)

proc call*(call_594207: Call_DedicatedCloudNodeUpdate_594198;
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
  var path_594208 = newJObject()
  var query_594209 = newJObject()
  var body_594210 = newJObject()
  add(path_594208, "resourceGroupName", newJString(resourceGroupName))
  add(query_594209, "api-version", newJString(apiVersion))
  add(path_594208, "subscriptionId", newJString(subscriptionId))
  if dedicatedCloudNodeRequest != nil:
    body_594210 = dedicatedCloudNodeRequest
  add(path_594208, "dedicatedCloudNodeName", newJString(dedicatedCloudNodeName))
  result = call_594207.call(path_594208, query_594209, nil, nil, body_594210)

var dedicatedCloudNodeUpdate* = Call_DedicatedCloudNodeUpdate_594198(
    name: "dedicatedCloudNodeUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes/{dedicatedCloudNodeName}",
    validator: validate_DedicatedCloudNodeUpdate_594199, base: "",
    url: url_DedicatedCloudNodeUpdate_594200, schemes: {Scheme.Https})
type
  Call_DedicatedCloudNodeDelete_594187 = ref object of OpenApiRestCall_593439
proc url_DedicatedCloudNodeDelete_594189(protocol: Scheme; host: string;
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

proc validate_DedicatedCloudNodeDelete_594188(path: JsonNode; query: JsonNode;
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
  var valid_594190 = path.getOrDefault("resourceGroupName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "resourceGroupName", valid_594190
  var valid_594191 = path.getOrDefault("subscriptionId")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "subscriptionId", valid_594191
  var valid_594192 = path.getOrDefault("dedicatedCloudNodeName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "dedicatedCloudNodeName", valid_594192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594193 = query.getOrDefault("api-version")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "api-version", valid_594193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594194: Call_DedicatedCloudNodeDelete_594187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete dedicated cloud node
  ## 
  let valid = call_594194.validator(path, query, header, formData, body)
  let scheme = call_594194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594194.url(scheme.get, call_594194.host, call_594194.base,
                         call_594194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594194, url, valid)

proc call*(call_594195: Call_DedicatedCloudNodeDelete_594187;
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
  var path_594196 = newJObject()
  var query_594197 = newJObject()
  add(path_594196, "resourceGroupName", newJString(resourceGroupName))
  add(query_594197, "api-version", newJString(apiVersion))
  add(path_594196, "subscriptionId", newJString(subscriptionId))
  add(path_594196, "dedicatedCloudNodeName", newJString(dedicatedCloudNodeName))
  result = call_594195.call(path_594196, query_594197, nil, nil, nil)

var dedicatedCloudNodeDelete* = Call_DedicatedCloudNodeDelete_594187(
    name: "dedicatedCloudNodeDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudNodes/{dedicatedCloudNodeName}",
    validator: validate_DedicatedCloudNodeDelete_594188, base: "",
    url: url_DedicatedCloudNodeDelete_594189, schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceListByResourceGroup_594211 = ref object of OpenApiRestCall_593439
proc url_DedicatedCloudServiceListByResourceGroup_594213(protocol: Scheme;
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

proc validate_DedicatedCloudServiceListByResourceGroup_594212(path: JsonNode;
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
  var valid_594214 = path.getOrDefault("resourceGroupName")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "resourceGroupName", valid_594214
  var valid_594215 = path.getOrDefault("subscriptionId")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "subscriptionId", valid_594215
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
  var valid_594216 = query.getOrDefault("api-version")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "api-version", valid_594216
  var valid_594217 = query.getOrDefault("$top")
  valid_594217 = validateParameter(valid_594217, JInt, required = false, default = nil)
  if valid_594217 != nil:
    section.add "$top", valid_594217
  var valid_594218 = query.getOrDefault("$skipToken")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "$skipToken", valid_594218
  var valid_594219 = query.getOrDefault("$filter")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "$filter", valid_594219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594220: Call_DedicatedCloudServiceListByResourceGroup_594211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of dedicated cloud service within resource group
  ## 
  let valid = call_594220.validator(path, query, header, formData, body)
  let scheme = call_594220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594220.url(scheme.get, call_594220.host, call_594220.base,
                         call_594220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594220, url, valid)

proc call*(call_594221: Call_DedicatedCloudServiceListByResourceGroup_594211;
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
  var path_594222 = newJObject()
  var query_594223 = newJObject()
  add(path_594222, "resourceGroupName", newJString(resourceGroupName))
  add(query_594223, "api-version", newJString(apiVersion))
  add(path_594222, "subscriptionId", newJString(subscriptionId))
  add(query_594223, "$top", newJInt(Top))
  add(query_594223, "$skipToken", newJString(SkipToken))
  add(query_594223, "$filter", newJString(Filter))
  result = call_594221.call(path_594222, query_594223, nil, nil, nil)

var dedicatedCloudServiceListByResourceGroup* = Call_DedicatedCloudServiceListByResourceGroup_594211(
    name: "dedicatedCloudServiceListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices",
    validator: validate_DedicatedCloudServiceListByResourceGroup_594212, base: "",
    url: url_DedicatedCloudServiceListByResourceGroup_594213,
    schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceCreateOrUpdate_594235 = ref object of OpenApiRestCall_593439
proc url_DedicatedCloudServiceCreateOrUpdate_594237(protocol: Scheme; host: string;
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

proc validate_DedicatedCloudServiceCreateOrUpdate_594236(path: JsonNode;
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
  var valid_594238 = path.getOrDefault("resourceGroupName")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "resourceGroupName", valid_594238
  var valid_594239 = path.getOrDefault("subscriptionId")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "subscriptionId", valid_594239
  var valid_594240 = path.getOrDefault("dedicatedCloudServiceName")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "dedicatedCloudServiceName", valid_594240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594241 = query.getOrDefault("api-version")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "api-version", valid_594241
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

proc call*(call_594243: Call_DedicatedCloudServiceCreateOrUpdate_594235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create dedicate cloud service
  ## 
  let valid = call_594243.validator(path, query, header, formData, body)
  let scheme = call_594243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594243.url(scheme.get, call_594243.host, call_594243.base,
                         call_594243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594243, url, valid)

proc call*(call_594244: Call_DedicatedCloudServiceCreateOrUpdate_594235;
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
  var path_594245 = newJObject()
  var query_594246 = newJObject()
  var body_594247 = newJObject()
  add(path_594245, "resourceGroupName", newJString(resourceGroupName))
  add(query_594246, "api-version", newJString(apiVersion))
  if dedicatedCloudServiceRequest != nil:
    body_594247 = dedicatedCloudServiceRequest
  add(path_594245, "subscriptionId", newJString(subscriptionId))
  add(path_594245, "dedicatedCloudServiceName",
      newJString(dedicatedCloudServiceName))
  result = call_594244.call(path_594245, query_594246, nil, nil, body_594247)

var dedicatedCloudServiceCreateOrUpdate* = Call_DedicatedCloudServiceCreateOrUpdate_594235(
    name: "dedicatedCloudServiceCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices/{dedicatedCloudServiceName}",
    validator: validate_DedicatedCloudServiceCreateOrUpdate_594236, base: "",
    url: url_DedicatedCloudServiceCreateOrUpdate_594237, schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceGet_594224 = ref object of OpenApiRestCall_593439
proc url_DedicatedCloudServiceGet_594226(protocol: Scheme; host: string;
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

proc validate_DedicatedCloudServiceGet_594225(path: JsonNode; query: JsonNode;
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
  var valid_594227 = path.getOrDefault("resourceGroupName")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "resourceGroupName", valid_594227
  var valid_594228 = path.getOrDefault("subscriptionId")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "subscriptionId", valid_594228
  var valid_594229 = path.getOrDefault("dedicatedCloudServiceName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "dedicatedCloudServiceName", valid_594229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594230 = query.getOrDefault("api-version")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "api-version", valid_594230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594231: Call_DedicatedCloudServiceGet_594224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Dedicate Cloud Service
  ## 
  let valid = call_594231.validator(path, query, header, formData, body)
  let scheme = call_594231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594231.url(scheme.get, call_594231.host, call_594231.base,
                         call_594231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594231, url, valid)

proc call*(call_594232: Call_DedicatedCloudServiceGet_594224;
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
  var path_594233 = newJObject()
  var query_594234 = newJObject()
  add(path_594233, "resourceGroupName", newJString(resourceGroupName))
  add(query_594234, "api-version", newJString(apiVersion))
  add(path_594233, "subscriptionId", newJString(subscriptionId))
  add(path_594233, "dedicatedCloudServiceName",
      newJString(dedicatedCloudServiceName))
  result = call_594232.call(path_594233, query_594234, nil, nil, nil)

var dedicatedCloudServiceGet* = Call_DedicatedCloudServiceGet_594224(
    name: "dedicatedCloudServiceGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices/{dedicatedCloudServiceName}",
    validator: validate_DedicatedCloudServiceGet_594225, base: "",
    url: url_DedicatedCloudServiceGet_594226, schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceUpdate_594259 = ref object of OpenApiRestCall_593439
proc url_DedicatedCloudServiceUpdate_594261(protocol: Scheme; host: string;
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

proc validate_DedicatedCloudServiceUpdate_594260(path: JsonNode; query: JsonNode;
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
  var valid_594262 = path.getOrDefault("resourceGroupName")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "resourceGroupName", valid_594262
  var valid_594263 = path.getOrDefault("subscriptionId")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "subscriptionId", valid_594263
  var valid_594264 = path.getOrDefault("dedicatedCloudServiceName")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "dedicatedCloudServiceName", valid_594264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594265 = query.getOrDefault("api-version")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "api-version", valid_594265
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

proc call*(call_594267: Call_DedicatedCloudServiceUpdate_594259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch dedicated cloud service's properties
  ## 
  let valid = call_594267.validator(path, query, header, formData, body)
  let scheme = call_594267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594267.url(scheme.get, call_594267.host, call_594267.base,
                         call_594267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594267, url, valid)

proc call*(call_594268: Call_DedicatedCloudServiceUpdate_594259;
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
  var path_594269 = newJObject()
  var query_594270 = newJObject()
  var body_594271 = newJObject()
  add(path_594269, "resourceGroupName", newJString(resourceGroupName))
  add(query_594270, "api-version", newJString(apiVersion))
  if dedicatedCloudServiceRequest != nil:
    body_594271 = dedicatedCloudServiceRequest
  add(path_594269, "subscriptionId", newJString(subscriptionId))
  add(path_594269, "dedicatedCloudServiceName",
      newJString(dedicatedCloudServiceName))
  result = call_594268.call(path_594269, query_594270, nil, nil, body_594271)

var dedicatedCloudServiceUpdate* = Call_DedicatedCloudServiceUpdate_594259(
    name: "dedicatedCloudServiceUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices/{dedicatedCloudServiceName}",
    validator: validate_DedicatedCloudServiceUpdate_594260, base: "",
    url: url_DedicatedCloudServiceUpdate_594261, schemes: {Scheme.Https})
type
  Call_DedicatedCloudServiceDelete_594248 = ref object of OpenApiRestCall_593439
proc url_DedicatedCloudServiceDelete_594250(protocol: Scheme; host: string;
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

proc validate_DedicatedCloudServiceDelete_594249(path: JsonNode; query: JsonNode;
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
  var valid_594251 = path.getOrDefault("resourceGroupName")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "resourceGroupName", valid_594251
  var valid_594252 = path.getOrDefault("subscriptionId")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "subscriptionId", valid_594252
  var valid_594253 = path.getOrDefault("dedicatedCloudServiceName")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "dedicatedCloudServiceName", valid_594253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594254 = query.getOrDefault("api-version")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "api-version", valid_594254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594255: Call_DedicatedCloudServiceDelete_594248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete dedicate cloud service
  ## 
  let valid = call_594255.validator(path, query, header, formData, body)
  let scheme = call_594255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594255.url(scheme.get, call_594255.host, call_594255.base,
                         call_594255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594255, url, valid)

proc call*(call_594256: Call_DedicatedCloudServiceDelete_594248;
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
  var path_594257 = newJObject()
  var query_594258 = newJObject()
  add(path_594257, "resourceGroupName", newJString(resourceGroupName))
  add(query_594258, "api-version", newJString(apiVersion))
  add(path_594257, "subscriptionId", newJString(subscriptionId))
  add(path_594257, "dedicatedCloudServiceName",
      newJString(dedicatedCloudServiceName))
  result = call_594256.call(path_594257, query_594258, nil, nil, nil)

var dedicatedCloudServiceDelete* = Call_DedicatedCloudServiceDelete_594248(
    name: "dedicatedCloudServiceDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/dedicatedCloudServices/{dedicatedCloudServiceName}",
    validator: validate_DedicatedCloudServiceDelete_594249, base: "",
    url: url_DedicatedCloudServiceDelete_594250, schemes: {Scheme.Https})
type
  Call_VirtualMachineListByResourceGroup_594272 = ref object of OpenApiRestCall_593439
proc url_VirtualMachineListByResourceGroup_594274(protocol: Scheme; host: string;
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

proc validate_VirtualMachineListByResourceGroup_594273(path: JsonNode;
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
  var valid_594275 = path.getOrDefault("resourceGroupName")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "resourceGroupName", valid_594275
  var valid_594276 = path.getOrDefault("subscriptionId")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "subscriptionId", valid_594276
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
  var valid_594277 = query.getOrDefault("api-version")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "api-version", valid_594277
  var valid_594278 = query.getOrDefault("$top")
  valid_594278 = validateParameter(valid_594278, JInt, required = false, default = nil)
  if valid_594278 != nil:
    section.add "$top", valid_594278
  var valid_594279 = query.getOrDefault("$skipToken")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "$skipToken", valid_594279
  var valid_594280 = query.getOrDefault("$filter")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "$filter", valid_594280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594281: Call_VirtualMachineListByResourceGroup_594272;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list of virtual machine within resource group
  ## 
  let valid = call_594281.validator(path, query, header, formData, body)
  let scheme = call_594281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594281.url(scheme.get, call_594281.host, call_594281.base,
                         call_594281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594281, url, valid)

proc call*(call_594282: Call_VirtualMachineListByResourceGroup_594272;
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
  var path_594283 = newJObject()
  var query_594284 = newJObject()
  add(path_594283, "resourceGroupName", newJString(resourceGroupName))
  add(query_594284, "api-version", newJString(apiVersion))
  add(path_594283, "subscriptionId", newJString(subscriptionId))
  add(query_594284, "$top", newJInt(Top))
  add(query_594284, "$skipToken", newJString(SkipToken))
  add(query_594284, "$filter", newJString(Filter))
  result = call_594282.call(path_594283, query_594284, nil, nil, nil)

var virtualMachineListByResourceGroup* = Call_VirtualMachineListByResourceGroup_594272(
    name: "virtualMachineListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines",
    validator: validate_VirtualMachineListByResourceGroup_594273, base: "",
    url: url_VirtualMachineListByResourceGroup_594274, schemes: {Scheme.Https})
type
  Call_VirtualMachineCreateOrUpdate_594296 = ref object of OpenApiRestCall_593439
proc url_VirtualMachineCreateOrUpdate_594298(protocol: Scheme; host: string;
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

proc validate_VirtualMachineCreateOrUpdate_594297(path: JsonNode; query: JsonNode;
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
  var valid_594299 = path.getOrDefault("resourceGroupName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "resourceGroupName", valid_594299
  var valid_594300 = path.getOrDefault("virtualMachineName")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "virtualMachineName", valid_594300
  var valid_594301 = path.getOrDefault("subscriptionId")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "subscriptionId", valid_594301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594302 = query.getOrDefault("api-version")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "api-version", valid_594302
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_594303 = header.getOrDefault("Referer")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "Referer", valid_594303
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

proc call*(call_594305: Call_VirtualMachineCreateOrUpdate_594296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create Or Update Virtual Machine
  ## 
  let valid = call_594305.validator(path, query, header, formData, body)
  let scheme = call_594305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594305.url(scheme.get, call_594305.host, call_594305.base,
                         call_594305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594305, url, valid)

proc call*(call_594306: Call_VirtualMachineCreateOrUpdate_594296;
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
  var path_594307 = newJObject()
  var query_594308 = newJObject()
  var body_594309 = newJObject()
  add(path_594307, "resourceGroupName", newJString(resourceGroupName))
  add(query_594308, "api-version", newJString(apiVersion))
  add(path_594307, "virtualMachineName", newJString(virtualMachineName))
  add(path_594307, "subscriptionId", newJString(subscriptionId))
  if virtualMachineRequest != nil:
    body_594309 = virtualMachineRequest
  result = call_594306.call(path_594307, query_594308, nil, nil, body_594309)

var virtualMachineCreateOrUpdate* = Call_VirtualMachineCreateOrUpdate_594296(
    name: "virtualMachineCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}",
    validator: validate_VirtualMachineCreateOrUpdate_594297, base: "",
    url: url_VirtualMachineCreateOrUpdate_594298, schemes: {Scheme.Https})
type
  Call_VirtualMachineGet_594285 = ref object of OpenApiRestCall_593439
proc url_VirtualMachineGet_594287(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineGet_594286(path: JsonNode; query: JsonNode;
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
  var valid_594288 = path.getOrDefault("resourceGroupName")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "resourceGroupName", valid_594288
  var valid_594289 = path.getOrDefault("virtualMachineName")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "virtualMachineName", valid_594289
  var valid_594290 = path.getOrDefault("subscriptionId")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "subscriptionId", valid_594290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594291 = query.getOrDefault("api-version")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "api-version", valid_594291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594292: Call_VirtualMachineGet_594285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual machine
  ## 
  let valid = call_594292.validator(path, query, header, formData, body)
  let scheme = call_594292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594292.url(scheme.get, call_594292.host, call_594292.base,
                         call_594292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594292, url, valid)

proc call*(call_594293: Call_VirtualMachineGet_594285; resourceGroupName: string;
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
  var path_594294 = newJObject()
  var query_594295 = newJObject()
  add(path_594294, "resourceGroupName", newJString(resourceGroupName))
  add(query_594295, "api-version", newJString(apiVersion))
  add(path_594294, "virtualMachineName", newJString(virtualMachineName))
  add(path_594294, "subscriptionId", newJString(subscriptionId))
  result = call_594293.call(path_594294, query_594295, nil, nil, nil)

var virtualMachineGet* = Call_VirtualMachineGet_594285(name: "virtualMachineGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}",
    validator: validate_VirtualMachineGet_594286, base: "",
    url: url_VirtualMachineGet_594287, schemes: {Scheme.Https})
type
  Call_VirtualMachineUpdate_594322 = ref object of OpenApiRestCall_593439
proc url_VirtualMachineUpdate_594324(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineUpdate_594323(path: JsonNode; query: JsonNode;
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
  var valid_594325 = path.getOrDefault("resourceGroupName")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "resourceGroupName", valid_594325
  var valid_594326 = path.getOrDefault("virtualMachineName")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "virtualMachineName", valid_594326
  var valid_594327 = path.getOrDefault("subscriptionId")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "subscriptionId", valid_594327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594328 = query.getOrDefault("api-version")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "api-version", valid_594328
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

proc call*(call_594330: Call_VirtualMachineUpdate_594322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch virtual machine properties
  ## 
  let valid = call_594330.validator(path, query, header, formData, body)
  let scheme = call_594330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594330.url(scheme.get, call_594330.host, call_594330.base,
                         call_594330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594330, url, valid)

proc call*(call_594331: Call_VirtualMachineUpdate_594322;
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
  var path_594332 = newJObject()
  var query_594333 = newJObject()
  var body_594334 = newJObject()
  add(path_594332, "resourceGroupName", newJString(resourceGroupName))
  add(query_594333, "api-version", newJString(apiVersion))
  add(path_594332, "virtualMachineName", newJString(virtualMachineName))
  add(path_594332, "subscriptionId", newJString(subscriptionId))
  if virtualMachineRequest != nil:
    body_594334 = virtualMachineRequest
  result = call_594331.call(path_594332, query_594333, nil, nil, body_594334)

var virtualMachineUpdate* = Call_VirtualMachineUpdate_594322(
    name: "virtualMachineUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}",
    validator: validate_VirtualMachineUpdate_594323, base: "",
    url: url_VirtualMachineUpdate_594324, schemes: {Scheme.Https})
type
  Call_VirtualMachineDelete_594310 = ref object of OpenApiRestCall_593439
proc url_VirtualMachineDelete_594312(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineDelete_594311(path: JsonNode; query: JsonNode;
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
  var valid_594313 = path.getOrDefault("resourceGroupName")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "resourceGroupName", valid_594313
  var valid_594314 = path.getOrDefault("virtualMachineName")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "virtualMachineName", valid_594314
  var valid_594315 = path.getOrDefault("subscriptionId")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "subscriptionId", valid_594315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594316 = query.getOrDefault("api-version")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "api-version", valid_594316
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_594317 = header.getOrDefault("Referer")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "Referer", valid_594317
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594318: Call_VirtualMachineDelete_594310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual machine
  ## 
  let valid = call_594318.validator(path, query, header, formData, body)
  let scheme = call_594318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594318.url(scheme.get, call_594318.host, call_594318.base,
                         call_594318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594318, url, valid)

proc call*(call_594319: Call_VirtualMachineDelete_594310;
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
  var path_594320 = newJObject()
  var query_594321 = newJObject()
  add(path_594320, "resourceGroupName", newJString(resourceGroupName))
  add(query_594321, "api-version", newJString(apiVersion))
  add(path_594320, "virtualMachineName", newJString(virtualMachineName))
  add(path_594320, "subscriptionId", newJString(subscriptionId))
  result = call_594319.call(path_594320, query_594321, nil, nil, nil)

var virtualMachineDelete* = Call_VirtualMachineDelete_594310(
    name: "virtualMachineDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}",
    validator: validate_VirtualMachineDelete_594311, base: "",
    url: url_VirtualMachineDelete_594312, schemes: {Scheme.Https})
type
  Call_VirtualMachineStart_594335 = ref object of OpenApiRestCall_593439
proc url_VirtualMachineStart_594337(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineStart_594336(path: JsonNode; query: JsonNode;
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
  var valid_594338 = path.getOrDefault("resourceGroupName")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "resourceGroupName", valid_594338
  var valid_594339 = path.getOrDefault("virtualMachineName")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "virtualMachineName", valid_594339
  var valid_594340 = path.getOrDefault("subscriptionId")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "subscriptionId", valid_594340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594341 = query.getOrDefault("api-version")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "api-version", valid_594341
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_594342 = header.getOrDefault("Referer")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "Referer", valid_594342
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594343: Call_VirtualMachineStart_594335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Power on virtual machine
  ## 
  let valid = call_594343.validator(path, query, header, formData, body)
  let scheme = call_594343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594343.url(scheme.get, call_594343.host, call_594343.base,
                         call_594343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594343, url, valid)

proc call*(call_594344: Call_VirtualMachineStart_594335; resourceGroupName: string;
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
  var path_594345 = newJObject()
  var query_594346 = newJObject()
  add(path_594345, "resourceGroupName", newJString(resourceGroupName))
  add(query_594346, "api-version", newJString(apiVersion))
  add(path_594345, "virtualMachineName", newJString(virtualMachineName))
  add(path_594345, "subscriptionId", newJString(subscriptionId))
  result = call_594344.call(path_594345, query_594346, nil, nil, nil)

var virtualMachineStart* = Call_VirtualMachineStart_594335(
    name: "virtualMachineStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}/start",
    validator: validate_VirtualMachineStart_594336, base: "",
    url: url_VirtualMachineStart_594337, schemes: {Scheme.Https})
type
  Call_VirtualMachineStop_594347 = ref object of OpenApiRestCall_593439
proc url_VirtualMachineStop_594349(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineStop_594348(path: JsonNode; query: JsonNode;
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
  var valid_594350 = path.getOrDefault("resourceGroupName")
  valid_594350 = validateParameter(valid_594350, JString, required = true,
                                 default = nil)
  if valid_594350 != nil:
    section.add "resourceGroupName", valid_594350
  var valid_594351 = path.getOrDefault("virtualMachineName")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "virtualMachineName", valid_594351
  var valid_594352 = path.getOrDefault("subscriptionId")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "subscriptionId", valid_594352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   mode: JString
  ##       : query stop mode parameter (reboot, shutdown, etc...)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594353 = query.getOrDefault("api-version")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "api-version", valid_594353
  var valid_594367 = query.getOrDefault("mode")
  valid_594367 = validateParameter(valid_594367, JString, required = false,
                                 default = newJString("reboot"))
  if valid_594367 != nil:
    section.add "mode", valid_594367
  result.add "query", section
  ## parameters in `header` object:
  ##   Referer: JString (required)
  ##          : referer url
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Referer` field"
  var valid_594368 = header.getOrDefault("Referer")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "Referer", valid_594368
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   m: JObject
  ##    : body stop mode parameter (reboot, shutdown, etc...)
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594370: Call_VirtualMachineStop_594347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Power off virtual machine, options: shutdown, poweroff, and suspend
  ## 
  let valid = call_594370.validator(path, query, header, formData, body)
  let scheme = call_594370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594370.url(scheme.get, call_594370.host, call_594370.base,
                         call_594370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594370, url, valid)

proc call*(call_594371: Call_VirtualMachineStop_594347; resourceGroupName: string;
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
  var path_594372 = newJObject()
  var query_594373 = newJObject()
  var body_594374 = newJObject()
  add(path_594372, "resourceGroupName", newJString(resourceGroupName))
  add(query_594373, "api-version", newJString(apiVersion))
  add(path_594372, "virtualMachineName", newJString(virtualMachineName))
  if m != nil:
    body_594374 = m
  add(path_594372, "subscriptionId", newJString(subscriptionId))
  add(query_594373, "mode", newJString(mode))
  result = call_594371.call(path_594372, query_594373, nil, nil, body_594374)

var virtualMachineStop* = Call_VirtualMachineStop_594347(
    name: "virtualMachineStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.VMwareCloudSimple/virtualMachines/{virtualMachineName}/stop",
    validator: validate_VirtualMachineStop_594348, base: "",
    url: url_VirtualMachineStop_594349, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
