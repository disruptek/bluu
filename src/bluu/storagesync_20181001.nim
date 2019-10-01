
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Microsoft Storage Sync
## version: 2018-10-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Microsoft Storage Sync Service API
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

  OpenApiRestCall_567667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567667): Option[Scheme] {.used.} =
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
  macServiceName = "storagesync"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567889 = ref object of OpenApiRestCall_567667
proc url_OperationsList_567891(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567890(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Storage Sync Rest API operations.
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
  var valid_568037 = query.getOrDefault("api-version")
  valid_568037 = validateParameter(valid_568037, JString, required = true,
                                 default = nil)
  if valid_568037 != nil:
    section.add "api-version", valid_568037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568064: Call_OperationsList_567889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Storage Sync Rest API operations.
  ## 
  let valid = call_568064.validator(path, query, header, formData, body)
  let scheme = call_568064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568064.url(scheme.get, call_568064.host, call_568064.base,
                         call_568064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568064, url, valid)

proc call*(call_568135: Call_OperationsList_567889; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Storage Sync Rest API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  result = call_568135.call(nil, query_568136, nil, nil, nil)

var operationsList* = Call_OperationsList_567889(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.StorageSync/operations",
    validator: validate_OperationsList_567890, base: "", url: url_OperationsList_567891,
    schemes: {Scheme.Https})
type
  Call_StorageSyncServicesCheckNameAvailability_568176 = ref object of OpenApiRestCall_567667
proc url_StorageSyncServicesCheckNameAvailability_568178(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageSyncServicesCheckNameAvailability_568177(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the give namespace name availability.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   locationName: JString (required)
  ##               : The desired region for the name check.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568219 = path.getOrDefault("subscriptionId")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "subscriptionId", valid_568219
  var valid_568220 = path.getOrDefault("locationName")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "locationName", valid_568220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given namespace name
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568223: Call_StorageSyncServicesCheckNameAvailability_568176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the give namespace name availability.
  ## 
  let valid = call_568223.validator(path, query, header, formData, body)
  let scheme = call_568223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568223.url(scheme.get, call_568223.host, call_568223.base,
                         call_568223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568223, url, valid)

proc call*(call_568224: Call_StorageSyncServicesCheckNameAvailability_568176;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          locationName: string): Recallable =
  ## storageSyncServicesCheckNameAvailability
  ## Check the give namespace name availability.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given namespace name
  ##   locationName: string (required)
  ##               : The desired region for the name check.
  var path_568225 = newJObject()
  var query_568226 = newJObject()
  var body_568227 = newJObject()
  add(query_568226, "api-version", newJString(apiVersion))
  add(path_568225, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568227 = parameters
  add(path_568225, "locationName", newJString(locationName))
  result = call_568224.call(path_568225, query_568226, nil, nil, body_568227)

var storageSyncServicesCheckNameAvailability* = Call_StorageSyncServicesCheckNameAvailability_568176(
    name: "storageSyncServicesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.StorageSync/locations/{locationName}/checkNameAvailability",
    validator: validate_StorageSyncServicesCheckNameAvailability_568177, base: "",
    url: url_StorageSyncServicesCheckNameAvailability_568178,
    schemes: {Scheme.Https})
type
  Call_StorageSyncServicesListBySubscription_568228 = ref object of OpenApiRestCall_567667
proc url_StorageSyncServicesListBySubscription_568230(protocol: Scheme;
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
        value: "/providers/Microsoft.StorageSync/storageSyncServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageSyncServicesListBySubscription_568229(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a StorageSyncService list by subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568231 = path.getOrDefault("subscriptionId")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "subscriptionId", valid_568231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568232 = query.getOrDefault("api-version")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "api-version", valid_568232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568233: Call_StorageSyncServicesListBySubscription_568228;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a StorageSyncService list by subscription.
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_StorageSyncServicesListBySubscription_568228;
          apiVersion: string; subscriptionId: string): Recallable =
  ## storageSyncServicesListBySubscription
  ## Get a StorageSyncService list by subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var storageSyncServicesListBySubscription* = Call_StorageSyncServicesListBySubscription_568228(
    name: "storageSyncServicesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.StorageSync/storageSyncServices",
    validator: validate_StorageSyncServicesListBySubscription_568229, base: "",
    url: url_StorageSyncServicesListBySubscription_568230, schemes: {Scheme.Https})
type
  Call_StorageSyncServicesListByResourceGroup_568237 = ref object of OpenApiRestCall_567667
proc url_StorageSyncServicesListByResourceGroup_568239(protocol: Scheme;
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
        value: "/providers/Microsoft.StorageSync/storageSyncServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageSyncServicesListByResourceGroup_568238(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a StorageSyncService list by Resource group name.
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
  var valid_568240 = path.getOrDefault("resourceGroupName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "resourceGroupName", valid_568240
  var valid_568241 = path.getOrDefault("subscriptionId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "subscriptionId", valid_568241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568242 = query.getOrDefault("api-version")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "api-version", valid_568242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568243: Call_StorageSyncServicesListByResourceGroup_568237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a StorageSyncService list by Resource group name.
  ## 
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_StorageSyncServicesListByResourceGroup_568237;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## storageSyncServicesListByResourceGroup
  ## Get a StorageSyncService list by Resource group name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568245 = newJObject()
  var query_568246 = newJObject()
  add(path_568245, "resourceGroupName", newJString(resourceGroupName))
  add(query_568246, "api-version", newJString(apiVersion))
  add(path_568245, "subscriptionId", newJString(subscriptionId))
  result = call_568244.call(path_568245, query_568246, nil, nil, nil)

var storageSyncServicesListByResourceGroup* = Call_StorageSyncServicesListByResourceGroup_568237(
    name: "storageSyncServicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices",
    validator: validate_StorageSyncServicesListByResourceGroup_568238, base: "",
    url: url_StorageSyncServicesListByResourceGroup_568239,
    schemes: {Scheme.Https})
type
  Call_StorageSyncServicesCreate_568258 = ref object of OpenApiRestCall_567667
proc url_StorageSyncServicesCreate_568260(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageSyncServicesCreate_568259(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new StorageSyncService.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568261 = path.getOrDefault("resourceGroupName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "resourceGroupName", valid_568261
  var valid_568262 = path.getOrDefault("subscriptionId")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "subscriptionId", valid_568262
  var valid_568263 = path.getOrDefault("storageSyncServiceName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "storageSyncServiceName", valid_568263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Storage Sync Service resource name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568266: Call_StorageSyncServicesCreate_568258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new StorageSyncService.
  ## 
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_StorageSyncServicesCreate_568258;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; storageSyncServiceName: string): Recallable =
  ## storageSyncServicesCreate
  ## Create a new StorageSyncService.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Storage Sync Service resource name.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568268 = newJObject()
  var query_568269 = newJObject()
  var body_568270 = newJObject()
  add(path_568268, "resourceGroupName", newJString(resourceGroupName))
  add(query_568269, "api-version", newJString(apiVersion))
  add(path_568268, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568270 = parameters
  add(path_568268, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568267.call(path_568268, query_568269, nil, nil, body_568270)

var storageSyncServicesCreate* = Call_StorageSyncServicesCreate_568258(
    name: "storageSyncServicesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}",
    validator: validate_StorageSyncServicesCreate_568259, base: "",
    url: url_StorageSyncServicesCreate_568260, schemes: {Scheme.Https})
type
  Call_StorageSyncServicesGet_568247 = ref object of OpenApiRestCall_567667
proc url_StorageSyncServicesGet_568249(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageSyncServicesGet_568248(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a given StorageSyncService.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568250 = path.getOrDefault("resourceGroupName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "resourceGroupName", valid_568250
  var valid_568251 = path.getOrDefault("subscriptionId")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "subscriptionId", valid_568251
  var valid_568252 = path.getOrDefault("storageSyncServiceName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "storageSyncServiceName", valid_568252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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

proc call*(call_568254: Call_StorageSyncServicesGet_568247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a given StorageSyncService.
  ## 
  let valid = call_568254.validator(path, query, header, formData, body)
  let scheme = call_568254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568254.url(scheme.get, call_568254.host, call_568254.base,
                         call_568254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568254, url, valid)

proc call*(call_568255: Call_StorageSyncServicesGet_568247;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          storageSyncServiceName: string): Recallable =
  ## storageSyncServicesGet
  ## Get a given StorageSyncService.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568256 = newJObject()
  var query_568257 = newJObject()
  add(path_568256, "resourceGroupName", newJString(resourceGroupName))
  add(query_568257, "api-version", newJString(apiVersion))
  add(path_568256, "subscriptionId", newJString(subscriptionId))
  add(path_568256, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568255.call(path_568256, query_568257, nil, nil, nil)

var storageSyncServicesGet* = Call_StorageSyncServicesGet_568247(
    name: "storageSyncServicesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}",
    validator: validate_StorageSyncServicesGet_568248, base: "",
    url: url_StorageSyncServicesGet_568249, schemes: {Scheme.Https})
type
  Call_StorageSyncServicesUpdate_568282 = ref object of OpenApiRestCall_567667
proc url_StorageSyncServicesUpdate_568284(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageSyncServicesUpdate_568283(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch a given StorageSyncService.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568285 = path.getOrDefault("resourceGroupName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "resourceGroupName", valid_568285
  var valid_568286 = path.getOrDefault("subscriptionId")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "subscriptionId", valid_568286
  var valid_568287 = path.getOrDefault("storageSyncServiceName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "storageSyncServiceName", valid_568287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568288 = query.getOrDefault("api-version")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "api-version", valid_568288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Storage Sync Service resource.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568290: Call_StorageSyncServicesUpdate_568282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a given StorageSyncService.
  ## 
  let valid = call_568290.validator(path, query, header, formData, body)
  let scheme = call_568290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568290.url(scheme.get, call_568290.host, call_568290.base,
                         call_568290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568290, url, valid)

proc call*(call_568291: Call_StorageSyncServicesUpdate_568282;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          storageSyncServiceName: string; parameters: JsonNode = nil): Recallable =
  ## storageSyncServicesUpdate
  ## Patch a given StorageSyncService.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject
  ##             : Storage Sync Service resource.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568292 = newJObject()
  var query_568293 = newJObject()
  var body_568294 = newJObject()
  add(path_568292, "resourceGroupName", newJString(resourceGroupName))
  add(query_568293, "api-version", newJString(apiVersion))
  add(path_568292, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568294 = parameters
  add(path_568292, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568291.call(path_568292, query_568293, nil, nil, body_568294)

var storageSyncServicesUpdate* = Call_StorageSyncServicesUpdate_568282(
    name: "storageSyncServicesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}",
    validator: validate_StorageSyncServicesUpdate_568283, base: "",
    url: url_StorageSyncServicesUpdate_568284, schemes: {Scheme.Https})
type
  Call_StorageSyncServicesDelete_568271 = ref object of OpenApiRestCall_567667
proc url_StorageSyncServicesDelete_568273(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageSyncServicesDelete_568272(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a given StorageSyncService.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568274 = path.getOrDefault("resourceGroupName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "resourceGroupName", valid_568274
  var valid_568275 = path.getOrDefault("subscriptionId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "subscriptionId", valid_568275
  var valid_568276 = path.getOrDefault("storageSyncServiceName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "storageSyncServiceName", valid_568276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568277 = query.getOrDefault("api-version")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "api-version", valid_568277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568278: Call_StorageSyncServicesDelete_568271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a given StorageSyncService.
  ## 
  let valid = call_568278.validator(path, query, header, formData, body)
  let scheme = call_568278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568278.url(scheme.get, call_568278.host, call_568278.base,
                         call_568278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568278, url, valid)

proc call*(call_568279: Call_StorageSyncServicesDelete_568271;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          storageSyncServiceName: string): Recallable =
  ## storageSyncServicesDelete
  ## Delete a given StorageSyncService.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568280 = newJObject()
  var query_568281 = newJObject()
  add(path_568280, "resourceGroupName", newJString(resourceGroupName))
  add(query_568281, "api-version", newJString(apiVersion))
  add(path_568280, "subscriptionId", newJString(subscriptionId))
  add(path_568280, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568279.call(path_568280, query_568281, nil, nil, nil)

var storageSyncServicesDelete* = Call_StorageSyncServicesDelete_568271(
    name: "storageSyncServicesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}",
    validator: validate_StorageSyncServicesDelete_568272, base: "",
    url: url_StorageSyncServicesDelete_568273, schemes: {Scheme.Https})
type
  Call_RegisteredServersListByStorageSyncService_568295 = ref object of OpenApiRestCall_567667
proc url_RegisteredServersListByStorageSyncService_568297(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/registeredServers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegisteredServersListByStorageSyncService_568296(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a given registered server list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568298 = path.getOrDefault("resourceGroupName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "resourceGroupName", valid_568298
  var valid_568299 = path.getOrDefault("subscriptionId")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "subscriptionId", valid_568299
  var valid_568300 = path.getOrDefault("storageSyncServiceName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "storageSyncServiceName", valid_568300
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

proc call*(call_568302: Call_RegisteredServersListByStorageSyncService_568295;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a given registered server list.
  ## 
  let valid = call_568302.validator(path, query, header, formData, body)
  let scheme = call_568302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568302.url(scheme.get, call_568302.host, call_568302.base,
                         call_568302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568302, url, valid)

proc call*(call_568303: Call_RegisteredServersListByStorageSyncService_568295;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          storageSyncServiceName: string): Recallable =
  ## registeredServersListByStorageSyncService
  ## Get a given registered server list.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568304 = newJObject()
  var query_568305 = newJObject()
  add(path_568304, "resourceGroupName", newJString(resourceGroupName))
  add(query_568305, "api-version", newJString(apiVersion))
  add(path_568304, "subscriptionId", newJString(subscriptionId))
  add(path_568304, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568303.call(path_568304, query_568305, nil, nil, nil)

var registeredServersListByStorageSyncService* = Call_RegisteredServersListByStorageSyncService_568295(
    name: "registeredServersListByStorageSyncService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers",
    validator: validate_RegisteredServersListByStorageSyncService_568296,
    base: "", url: url_RegisteredServersListByStorageSyncService_568297,
    schemes: {Scheme.Https})
type
  Call_RegisteredServersCreate_568318 = ref object of OpenApiRestCall_567667
proc url_RegisteredServersCreate_568320(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "serverId" in path, "`serverId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/registeredServers/"),
               (kind: VariableSegment, value: "serverId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegisteredServersCreate_568319(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a new registered server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   serverId: JString (required)
  ##           : GUID identifying the on-premises server.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
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
  var valid_568323 = path.getOrDefault("serverId")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "serverId", valid_568323
  var valid_568324 = path.getOrDefault("storageSyncServiceName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "storageSyncServiceName", valid_568324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568325 = query.getOrDefault("api-version")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "api-version", valid_568325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Body of Registered Server object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568327: Call_RegisteredServersCreate_568318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a new registered server.
  ## 
  let valid = call_568327.validator(path, query, header, formData, body)
  let scheme = call_568327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568327.url(scheme.get, call_568327.host, call_568327.base,
                         call_568327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568327, url, valid)

proc call*(call_568328: Call_RegisteredServersCreate_568318;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serverId: string; parameters: JsonNode; storageSyncServiceName: string): Recallable =
  ## registeredServersCreate
  ## Add a new registered server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   serverId: string (required)
  ##           : GUID identifying the on-premises server.
  ##   parameters: JObject (required)
  ##             : Body of Registered Server object.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568329 = newJObject()
  var query_568330 = newJObject()
  var body_568331 = newJObject()
  add(path_568329, "resourceGroupName", newJString(resourceGroupName))
  add(query_568330, "api-version", newJString(apiVersion))
  add(path_568329, "subscriptionId", newJString(subscriptionId))
  add(path_568329, "serverId", newJString(serverId))
  if parameters != nil:
    body_568331 = parameters
  add(path_568329, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568328.call(path_568329, query_568330, nil, nil, body_568331)

var registeredServersCreate* = Call_RegisteredServersCreate_568318(
    name: "registeredServersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers/{serverId}",
    validator: validate_RegisteredServersCreate_568319, base: "",
    url: url_RegisteredServersCreate_568320, schemes: {Scheme.Https})
type
  Call_RegisteredServersGet_568306 = ref object of OpenApiRestCall_567667
proc url_RegisteredServersGet_568308(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "serverId" in path, "`serverId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/registeredServers/"),
               (kind: VariableSegment, value: "serverId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegisteredServersGet_568307(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a given registered server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   serverId: JString (required)
  ##           : GUID identifying the on-premises server.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
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
  var valid_568311 = path.getOrDefault("serverId")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "serverId", valid_568311
  var valid_568312 = path.getOrDefault("storageSyncServiceName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "storageSyncServiceName", valid_568312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568313 = query.getOrDefault("api-version")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "api-version", valid_568313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568314: Call_RegisteredServersGet_568306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a given registered server.
  ## 
  let valid = call_568314.validator(path, query, header, formData, body)
  let scheme = call_568314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568314.url(scheme.get, call_568314.host, call_568314.base,
                         call_568314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568314, url, valid)

proc call*(call_568315: Call_RegisteredServersGet_568306;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serverId: string; storageSyncServiceName: string): Recallable =
  ## registeredServersGet
  ## Get a given registered server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   serverId: string (required)
  ##           : GUID identifying the on-premises server.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568316 = newJObject()
  var query_568317 = newJObject()
  add(path_568316, "resourceGroupName", newJString(resourceGroupName))
  add(query_568317, "api-version", newJString(apiVersion))
  add(path_568316, "subscriptionId", newJString(subscriptionId))
  add(path_568316, "serverId", newJString(serverId))
  add(path_568316, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568315.call(path_568316, query_568317, nil, nil, nil)

var registeredServersGet* = Call_RegisteredServersGet_568306(
    name: "registeredServersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers/{serverId}",
    validator: validate_RegisteredServersGet_568307, base: "",
    url: url_RegisteredServersGet_568308, schemes: {Scheme.Https})
type
  Call_RegisteredServersDelete_568332 = ref object of OpenApiRestCall_567667
proc url_RegisteredServersDelete_568334(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "serverId" in path, "`serverId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/registeredServers/"),
               (kind: VariableSegment, value: "serverId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegisteredServersDelete_568333(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the given registered server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   serverId: JString (required)
  ##           : GUID identifying the on-premises server.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568335 = path.getOrDefault("resourceGroupName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "resourceGroupName", valid_568335
  var valid_568336 = path.getOrDefault("subscriptionId")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "subscriptionId", valid_568336
  var valid_568337 = path.getOrDefault("serverId")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "serverId", valid_568337
  var valid_568338 = path.getOrDefault("storageSyncServiceName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "storageSyncServiceName", valid_568338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568339 = query.getOrDefault("api-version")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "api-version", valid_568339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568340: Call_RegisteredServersDelete_568332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the given registered server.
  ## 
  let valid = call_568340.validator(path, query, header, formData, body)
  let scheme = call_568340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568340.url(scheme.get, call_568340.host, call_568340.base,
                         call_568340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568340, url, valid)

proc call*(call_568341: Call_RegisteredServersDelete_568332;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serverId: string; storageSyncServiceName: string): Recallable =
  ## registeredServersDelete
  ## Delete the given registered server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   serverId: string (required)
  ##           : GUID identifying the on-premises server.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568342 = newJObject()
  var query_568343 = newJObject()
  add(path_568342, "resourceGroupName", newJString(resourceGroupName))
  add(query_568343, "api-version", newJString(apiVersion))
  add(path_568342, "subscriptionId", newJString(subscriptionId))
  add(path_568342, "serverId", newJString(serverId))
  add(path_568342, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568341.call(path_568342, query_568343, nil, nil, nil)

var registeredServersDelete* = Call_RegisteredServersDelete_568332(
    name: "registeredServersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers/{serverId}",
    validator: validate_RegisteredServersDelete_568333, base: "",
    url: url_RegisteredServersDelete_568334, schemes: {Scheme.Https})
type
  Call_RegisteredServersTriggerRollover_568344 = ref object of OpenApiRestCall_567667
proc url_RegisteredServersTriggerRollover_568346(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "serverId" in path, "`serverId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/registeredServers/"),
               (kind: VariableSegment, value: "serverId"),
               (kind: ConstantSegment, value: "/triggerRollover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegisteredServersTriggerRollover_568345(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Triggers Server certificate rollover.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   serverId: JString (required)
  ##           : Server Id
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568347 = path.getOrDefault("resourceGroupName")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "resourceGroupName", valid_568347
  var valid_568348 = path.getOrDefault("subscriptionId")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "subscriptionId", valid_568348
  var valid_568349 = path.getOrDefault("serverId")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "serverId", valid_568349
  var valid_568350 = path.getOrDefault("storageSyncServiceName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "storageSyncServiceName", valid_568350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568351 = query.getOrDefault("api-version")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "api-version", valid_568351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Body of Trigger Rollover request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568353: Call_RegisteredServersTriggerRollover_568344;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Triggers Server certificate rollover.
  ## 
  let valid = call_568353.validator(path, query, header, formData, body)
  let scheme = call_568353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568353.url(scheme.get, call_568353.host, call_568353.base,
                         call_568353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568353, url, valid)

proc call*(call_568354: Call_RegisteredServersTriggerRollover_568344;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serverId: string; parameters: JsonNode; storageSyncServiceName: string): Recallable =
  ## registeredServersTriggerRollover
  ## Triggers Server certificate rollover.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   serverId: string (required)
  ##           : Server Id
  ##   parameters: JObject (required)
  ##             : Body of Trigger Rollover request.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568355 = newJObject()
  var query_568356 = newJObject()
  var body_568357 = newJObject()
  add(path_568355, "resourceGroupName", newJString(resourceGroupName))
  add(query_568356, "api-version", newJString(apiVersion))
  add(path_568355, "subscriptionId", newJString(subscriptionId))
  add(path_568355, "serverId", newJString(serverId))
  if parameters != nil:
    body_568357 = parameters
  add(path_568355, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568354.call(path_568355, query_568356, nil, nil, body_568357)

var registeredServersTriggerRollover* = Call_RegisteredServersTriggerRollover_568344(
    name: "registeredServersTriggerRollover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers/{serverId}/triggerRollover",
    validator: validate_RegisteredServersTriggerRollover_568345, base: "",
    url: url_RegisteredServersTriggerRollover_568346, schemes: {Scheme.Https})
type
  Call_SyncGroupsListByStorageSyncService_568358 = ref object of OpenApiRestCall_567667
proc url_SyncGroupsListByStorageSyncService_568360(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SyncGroupsListByStorageSyncService_568359(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a SyncGroup List.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568361 = path.getOrDefault("resourceGroupName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "resourceGroupName", valid_568361
  var valid_568362 = path.getOrDefault("subscriptionId")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "subscriptionId", valid_568362
  var valid_568363 = path.getOrDefault("storageSyncServiceName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "storageSyncServiceName", valid_568363
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568364 = query.getOrDefault("api-version")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "api-version", valid_568364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568365: Call_SyncGroupsListByStorageSyncService_568358;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a SyncGroup List.
  ## 
  let valid = call_568365.validator(path, query, header, formData, body)
  let scheme = call_568365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568365.url(scheme.get, call_568365.host, call_568365.base,
                         call_568365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568365, url, valid)

proc call*(call_568366: Call_SyncGroupsListByStorageSyncService_568358;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          storageSyncServiceName: string): Recallable =
  ## syncGroupsListByStorageSyncService
  ## Get a SyncGroup List.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568367 = newJObject()
  var query_568368 = newJObject()
  add(path_568367, "resourceGroupName", newJString(resourceGroupName))
  add(query_568368, "api-version", newJString(apiVersion))
  add(path_568367, "subscriptionId", newJString(subscriptionId))
  add(path_568367, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568366.call(path_568367, query_568368, nil, nil, nil)

var syncGroupsListByStorageSyncService* = Call_SyncGroupsListByStorageSyncService_568358(
    name: "syncGroupsListByStorageSyncService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups",
    validator: validate_SyncGroupsListByStorageSyncService_568359, base: "",
    url: url_SyncGroupsListByStorageSyncService_568360, schemes: {Scheme.Https})
type
  Call_SyncGroupsCreate_568381 = ref object of OpenApiRestCall_567667
proc url_SyncGroupsCreate_568383(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SyncGroupsCreate_568382(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Create a new SyncGroup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568384 = path.getOrDefault("resourceGroupName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "resourceGroupName", valid_568384
  var valid_568385 = path.getOrDefault("subscriptionId")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "subscriptionId", valid_568385
  var valid_568386 = path.getOrDefault("syncGroupName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "syncGroupName", valid_568386
  var valid_568387 = path.getOrDefault("storageSyncServiceName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "storageSyncServiceName", valid_568387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568388 = query.getOrDefault("api-version")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "api-version", valid_568388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Sync Group Body
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568390: Call_SyncGroupsCreate_568381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new SyncGroup.
  ## 
  let valid = call_568390.validator(path, query, header, formData, body)
  let scheme = call_568390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568390.url(scheme.get, call_568390.host, call_568390.base,
                         call_568390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568390, url, valid)

proc call*(call_568391: Call_SyncGroupsCreate_568381; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; syncGroupName: string;
          parameters: JsonNode; storageSyncServiceName: string): Recallable =
  ## syncGroupsCreate
  ## Create a new SyncGroup.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   parameters: JObject (required)
  ##             : Sync Group Body
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568392 = newJObject()
  var query_568393 = newJObject()
  var body_568394 = newJObject()
  add(path_568392, "resourceGroupName", newJString(resourceGroupName))
  add(query_568393, "api-version", newJString(apiVersion))
  add(path_568392, "subscriptionId", newJString(subscriptionId))
  add(path_568392, "syncGroupName", newJString(syncGroupName))
  if parameters != nil:
    body_568394 = parameters
  add(path_568392, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568391.call(path_568392, query_568393, nil, nil, body_568394)

var syncGroupsCreate* = Call_SyncGroupsCreate_568381(name: "syncGroupsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}",
    validator: validate_SyncGroupsCreate_568382, base: "",
    url: url_SyncGroupsCreate_568383, schemes: {Scheme.Https})
type
  Call_SyncGroupsGet_568369 = ref object of OpenApiRestCall_567667
proc url_SyncGroupsGet_568371(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SyncGroupsGet_568370(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a given SyncGroup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568372 = path.getOrDefault("resourceGroupName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "resourceGroupName", valid_568372
  var valid_568373 = path.getOrDefault("subscriptionId")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "subscriptionId", valid_568373
  var valid_568374 = path.getOrDefault("syncGroupName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "syncGroupName", valid_568374
  var valid_568375 = path.getOrDefault("storageSyncServiceName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "storageSyncServiceName", valid_568375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568376 = query.getOrDefault("api-version")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "api-version", valid_568376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568377: Call_SyncGroupsGet_568369; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a given SyncGroup.
  ## 
  let valid = call_568377.validator(path, query, header, formData, body)
  let scheme = call_568377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568377.url(scheme.get, call_568377.host, call_568377.base,
                         call_568377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568377, url, valid)

proc call*(call_568378: Call_SyncGroupsGet_568369; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; syncGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## syncGroupsGet
  ## Get a given SyncGroup.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568379 = newJObject()
  var query_568380 = newJObject()
  add(path_568379, "resourceGroupName", newJString(resourceGroupName))
  add(query_568380, "api-version", newJString(apiVersion))
  add(path_568379, "subscriptionId", newJString(subscriptionId))
  add(path_568379, "syncGroupName", newJString(syncGroupName))
  add(path_568379, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568378.call(path_568379, query_568380, nil, nil, nil)

var syncGroupsGet* = Call_SyncGroupsGet_568369(name: "syncGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}",
    validator: validate_SyncGroupsGet_568370, base: "", url: url_SyncGroupsGet_568371,
    schemes: {Scheme.Https})
type
  Call_SyncGroupsDelete_568395 = ref object of OpenApiRestCall_567667
proc url_SyncGroupsDelete_568397(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SyncGroupsDelete_568396(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Delete a given SyncGroup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568398 = path.getOrDefault("resourceGroupName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "resourceGroupName", valid_568398
  var valid_568399 = path.getOrDefault("subscriptionId")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "subscriptionId", valid_568399
  var valid_568400 = path.getOrDefault("syncGroupName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "syncGroupName", valid_568400
  var valid_568401 = path.getOrDefault("storageSyncServiceName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "storageSyncServiceName", valid_568401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568402 = query.getOrDefault("api-version")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "api-version", valid_568402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568403: Call_SyncGroupsDelete_568395; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a given SyncGroup.
  ## 
  let valid = call_568403.validator(path, query, header, formData, body)
  let scheme = call_568403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568403.url(scheme.get, call_568403.host, call_568403.base,
                         call_568403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568403, url, valid)

proc call*(call_568404: Call_SyncGroupsDelete_568395; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; syncGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## syncGroupsDelete
  ## Delete a given SyncGroup.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568405 = newJObject()
  var query_568406 = newJObject()
  add(path_568405, "resourceGroupName", newJString(resourceGroupName))
  add(query_568406, "api-version", newJString(apiVersion))
  add(path_568405, "subscriptionId", newJString(subscriptionId))
  add(path_568405, "syncGroupName", newJString(syncGroupName))
  add(path_568405, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568404.call(path_568405, query_568406, nil, nil, nil)

var syncGroupsDelete* = Call_SyncGroupsDelete_568395(name: "syncGroupsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}",
    validator: validate_SyncGroupsDelete_568396, base: "",
    url: url_SyncGroupsDelete_568397, schemes: {Scheme.Https})
type
  Call_CloudEndpointsListBySyncGroup_568407 = ref object of OpenApiRestCall_567667
proc url_CloudEndpointsListBySyncGroup_568409(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName"),
               (kind: ConstantSegment, value: "/cloudEndpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudEndpointsListBySyncGroup_568408(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a CloudEndpoint List.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568410 = path.getOrDefault("resourceGroupName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "resourceGroupName", valid_568410
  var valid_568411 = path.getOrDefault("subscriptionId")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "subscriptionId", valid_568411
  var valid_568412 = path.getOrDefault("syncGroupName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "syncGroupName", valid_568412
  var valid_568413 = path.getOrDefault("storageSyncServiceName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "storageSyncServiceName", valid_568413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568414 = query.getOrDefault("api-version")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "api-version", valid_568414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568415: Call_CloudEndpointsListBySyncGroup_568407; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a CloudEndpoint List.
  ## 
  let valid = call_568415.validator(path, query, header, formData, body)
  let scheme = call_568415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568415.url(scheme.get, call_568415.host, call_568415.base,
                         call_568415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568415, url, valid)

proc call*(call_568416: Call_CloudEndpointsListBySyncGroup_568407;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          syncGroupName: string; storageSyncServiceName: string): Recallable =
  ## cloudEndpointsListBySyncGroup
  ## Get a CloudEndpoint List.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568417 = newJObject()
  var query_568418 = newJObject()
  add(path_568417, "resourceGroupName", newJString(resourceGroupName))
  add(query_568418, "api-version", newJString(apiVersion))
  add(path_568417, "subscriptionId", newJString(subscriptionId))
  add(path_568417, "syncGroupName", newJString(syncGroupName))
  add(path_568417, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568416.call(path_568417, query_568418, nil, nil, nil)

var cloudEndpointsListBySyncGroup* = Call_CloudEndpointsListBySyncGroup_568407(
    name: "cloudEndpointsListBySyncGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints",
    validator: validate_CloudEndpointsListBySyncGroup_568408, base: "",
    url: url_CloudEndpointsListBySyncGroup_568409, schemes: {Scheme.Https})
type
  Call_CloudEndpointsCreate_568432 = ref object of OpenApiRestCall_567667
proc url_CloudEndpointsCreate_568434(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  assert "cloudEndpointName" in path,
        "`cloudEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName"),
               (kind: ConstantSegment, value: "/cloudEndpoints/"),
               (kind: VariableSegment, value: "cloudEndpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudEndpointsCreate_568433(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new CloudEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: JString (required)
  ##                    : Name of Cloud Endpoint object.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568435 = path.getOrDefault("resourceGroupName")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "resourceGroupName", valid_568435
  var valid_568436 = path.getOrDefault("subscriptionId")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "subscriptionId", valid_568436
  var valid_568437 = path.getOrDefault("syncGroupName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "syncGroupName", valid_568437
  var valid_568438 = path.getOrDefault("cloudEndpointName")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "cloudEndpointName", valid_568438
  var valid_568439 = path.getOrDefault("storageSyncServiceName")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "storageSyncServiceName", valid_568439
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568440 = query.getOrDefault("api-version")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "api-version", valid_568440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Body of Cloud Endpoint resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568442: Call_CloudEndpointsCreate_568432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new CloudEndpoint.
  ## 
  let valid = call_568442.validator(path, query, header, formData, body)
  let scheme = call_568442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568442.url(scheme.get, call_568442.host, call_568442.base,
                         call_568442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568442, url, valid)

proc call*(call_568443: Call_CloudEndpointsCreate_568432;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          syncGroupName: string; cloudEndpointName: string; parameters: JsonNode;
          storageSyncServiceName: string): Recallable =
  ## cloudEndpointsCreate
  ## Create a new CloudEndpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   parameters: JObject (required)
  ##             : Body of Cloud Endpoint resource.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568444 = newJObject()
  var query_568445 = newJObject()
  var body_568446 = newJObject()
  add(path_568444, "resourceGroupName", newJString(resourceGroupName))
  add(query_568445, "api-version", newJString(apiVersion))
  add(path_568444, "subscriptionId", newJString(subscriptionId))
  add(path_568444, "syncGroupName", newJString(syncGroupName))
  add(path_568444, "cloudEndpointName", newJString(cloudEndpointName))
  if parameters != nil:
    body_568446 = parameters
  add(path_568444, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568443.call(path_568444, query_568445, nil, nil, body_568446)

var cloudEndpointsCreate* = Call_CloudEndpointsCreate_568432(
    name: "cloudEndpointsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}",
    validator: validate_CloudEndpointsCreate_568433, base: "",
    url: url_CloudEndpointsCreate_568434, schemes: {Scheme.Https})
type
  Call_CloudEndpointsGet_568419 = ref object of OpenApiRestCall_567667
proc url_CloudEndpointsGet_568421(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  assert "cloudEndpointName" in path,
        "`cloudEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName"),
               (kind: ConstantSegment, value: "/cloudEndpoints/"),
               (kind: VariableSegment, value: "cloudEndpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudEndpointsGet_568420(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get a given CloudEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: JString (required)
  ##                    : Name of Cloud Endpoint object.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568422 = path.getOrDefault("resourceGroupName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "resourceGroupName", valid_568422
  var valid_568423 = path.getOrDefault("subscriptionId")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "subscriptionId", valid_568423
  var valid_568424 = path.getOrDefault("syncGroupName")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "syncGroupName", valid_568424
  var valid_568425 = path.getOrDefault("cloudEndpointName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "cloudEndpointName", valid_568425
  var valid_568426 = path.getOrDefault("storageSyncServiceName")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "storageSyncServiceName", valid_568426
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568427 = query.getOrDefault("api-version")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "api-version", valid_568427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568428: Call_CloudEndpointsGet_568419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a given CloudEndpoint.
  ## 
  let valid = call_568428.validator(path, query, header, formData, body)
  let scheme = call_568428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568428.url(scheme.get, call_568428.host, call_568428.base,
                         call_568428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568428, url, valid)

proc call*(call_568429: Call_CloudEndpointsGet_568419; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; syncGroupName: string;
          cloudEndpointName: string; storageSyncServiceName: string): Recallable =
  ## cloudEndpointsGet
  ## Get a given CloudEndpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568430 = newJObject()
  var query_568431 = newJObject()
  add(path_568430, "resourceGroupName", newJString(resourceGroupName))
  add(query_568431, "api-version", newJString(apiVersion))
  add(path_568430, "subscriptionId", newJString(subscriptionId))
  add(path_568430, "syncGroupName", newJString(syncGroupName))
  add(path_568430, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_568430, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568429.call(path_568430, query_568431, nil, nil, nil)

var cloudEndpointsGet* = Call_CloudEndpointsGet_568419(name: "cloudEndpointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}",
    validator: validate_CloudEndpointsGet_568420, base: "",
    url: url_CloudEndpointsGet_568421, schemes: {Scheme.Https})
type
  Call_CloudEndpointsDelete_568447 = ref object of OpenApiRestCall_567667
proc url_CloudEndpointsDelete_568449(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  assert "cloudEndpointName" in path,
        "`cloudEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName"),
               (kind: ConstantSegment, value: "/cloudEndpoints/"),
               (kind: VariableSegment, value: "cloudEndpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudEndpointsDelete_568448(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a given CloudEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: JString (required)
  ##                    : Name of Cloud Endpoint object.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568450 = path.getOrDefault("resourceGroupName")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "resourceGroupName", valid_568450
  var valid_568451 = path.getOrDefault("subscriptionId")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "subscriptionId", valid_568451
  var valid_568452 = path.getOrDefault("syncGroupName")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "syncGroupName", valid_568452
  var valid_568453 = path.getOrDefault("cloudEndpointName")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "cloudEndpointName", valid_568453
  var valid_568454 = path.getOrDefault("storageSyncServiceName")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "storageSyncServiceName", valid_568454
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568455 = query.getOrDefault("api-version")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "api-version", valid_568455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568456: Call_CloudEndpointsDelete_568447; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a given CloudEndpoint.
  ## 
  let valid = call_568456.validator(path, query, header, formData, body)
  let scheme = call_568456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568456.url(scheme.get, call_568456.host, call_568456.base,
                         call_568456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568456, url, valid)

proc call*(call_568457: Call_CloudEndpointsDelete_568447;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          syncGroupName: string; cloudEndpointName: string;
          storageSyncServiceName: string): Recallable =
  ## cloudEndpointsDelete
  ## Delete a given CloudEndpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568458 = newJObject()
  var query_568459 = newJObject()
  add(path_568458, "resourceGroupName", newJString(resourceGroupName))
  add(query_568459, "api-version", newJString(apiVersion))
  add(path_568458, "subscriptionId", newJString(subscriptionId))
  add(path_568458, "syncGroupName", newJString(syncGroupName))
  add(path_568458, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_568458, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568457.call(path_568458, query_568459, nil, nil, nil)

var cloudEndpointsDelete* = Call_CloudEndpointsDelete_568447(
    name: "cloudEndpointsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}",
    validator: validate_CloudEndpointsDelete_568448, base: "",
    url: url_CloudEndpointsDelete_568449, schemes: {Scheme.Https})
type
  Call_CloudEndpointsPostBackup_568460 = ref object of OpenApiRestCall_567667
proc url_CloudEndpointsPostBackup_568462(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  assert "cloudEndpointName" in path,
        "`cloudEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName"),
               (kind: ConstantSegment, value: "/cloudEndpoints/"),
               (kind: VariableSegment, value: "cloudEndpointName"),
               (kind: ConstantSegment, value: "/postbackup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudEndpointsPostBackup_568461(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Post Backup a given CloudEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: JString (required)
  ##                    : Name of Cloud Endpoint object.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568463 = path.getOrDefault("resourceGroupName")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "resourceGroupName", valid_568463
  var valid_568464 = path.getOrDefault("subscriptionId")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "subscriptionId", valid_568464
  var valid_568465 = path.getOrDefault("syncGroupName")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "syncGroupName", valid_568465
  var valid_568466 = path.getOrDefault("cloudEndpointName")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "cloudEndpointName", valid_568466
  var valid_568467 = path.getOrDefault("storageSyncServiceName")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "storageSyncServiceName", valid_568467
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568468 = query.getOrDefault("api-version")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "api-version", valid_568468
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Body of Backup request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568470: Call_CloudEndpointsPostBackup_568460; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Post Backup a given CloudEndpoint.
  ## 
  let valid = call_568470.validator(path, query, header, formData, body)
  let scheme = call_568470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568470.url(scheme.get, call_568470.host, call_568470.base,
                         call_568470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568470, url, valid)

proc call*(call_568471: Call_CloudEndpointsPostBackup_568460;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          syncGroupName: string; cloudEndpointName: string; parameters: JsonNode;
          storageSyncServiceName: string): Recallable =
  ## cloudEndpointsPostBackup
  ## Post Backup a given CloudEndpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   parameters: JObject (required)
  ##             : Body of Backup request.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568472 = newJObject()
  var query_568473 = newJObject()
  var body_568474 = newJObject()
  add(path_568472, "resourceGroupName", newJString(resourceGroupName))
  add(query_568473, "api-version", newJString(apiVersion))
  add(path_568472, "subscriptionId", newJString(subscriptionId))
  add(path_568472, "syncGroupName", newJString(syncGroupName))
  add(path_568472, "cloudEndpointName", newJString(cloudEndpointName))
  if parameters != nil:
    body_568474 = parameters
  add(path_568472, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568471.call(path_568472, query_568473, nil, nil, body_568474)

var cloudEndpointsPostBackup* = Call_CloudEndpointsPostBackup_568460(
    name: "cloudEndpointsPostBackup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/postbackup",
    validator: validate_CloudEndpointsPostBackup_568461, base: "",
    url: url_CloudEndpointsPostBackup_568462, schemes: {Scheme.Https})
type
  Call_CloudEndpointsPostRestore_568475 = ref object of OpenApiRestCall_567667
proc url_CloudEndpointsPostRestore_568477(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  assert "cloudEndpointName" in path,
        "`cloudEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName"),
               (kind: ConstantSegment, value: "/cloudEndpoints/"),
               (kind: VariableSegment, value: "cloudEndpointName"),
               (kind: ConstantSegment, value: "/postrestore")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudEndpointsPostRestore_568476(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Post Restore a given CloudEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: JString (required)
  ##                    : Name of Cloud Endpoint object.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568478 = path.getOrDefault("resourceGroupName")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "resourceGroupName", valid_568478
  var valid_568479 = path.getOrDefault("subscriptionId")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "subscriptionId", valid_568479
  var valid_568480 = path.getOrDefault("syncGroupName")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "syncGroupName", valid_568480
  var valid_568481 = path.getOrDefault("cloudEndpointName")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "cloudEndpointName", valid_568481
  var valid_568482 = path.getOrDefault("storageSyncServiceName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "storageSyncServiceName", valid_568482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Body of Cloud Endpoint object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568485: Call_CloudEndpointsPostRestore_568475; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Post Restore a given CloudEndpoint.
  ## 
  let valid = call_568485.validator(path, query, header, formData, body)
  let scheme = call_568485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568485.url(scheme.get, call_568485.host, call_568485.base,
                         call_568485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568485, url, valid)

proc call*(call_568486: Call_CloudEndpointsPostRestore_568475;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          syncGroupName: string; cloudEndpointName: string; parameters: JsonNode;
          storageSyncServiceName: string): Recallable =
  ## cloudEndpointsPostRestore
  ## Post Restore a given CloudEndpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   parameters: JObject (required)
  ##             : Body of Cloud Endpoint object.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568487 = newJObject()
  var query_568488 = newJObject()
  var body_568489 = newJObject()
  add(path_568487, "resourceGroupName", newJString(resourceGroupName))
  add(query_568488, "api-version", newJString(apiVersion))
  add(path_568487, "subscriptionId", newJString(subscriptionId))
  add(path_568487, "syncGroupName", newJString(syncGroupName))
  add(path_568487, "cloudEndpointName", newJString(cloudEndpointName))
  if parameters != nil:
    body_568489 = parameters
  add(path_568487, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568486.call(path_568487, query_568488, nil, nil, body_568489)

var cloudEndpointsPostRestore* = Call_CloudEndpointsPostRestore_568475(
    name: "cloudEndpointsPostRestore", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/postrestore",
    validator: validate_CloudEndpointsPostRestore_568476, base: "",
    url: url_CloudEndpointsPostRestore_568477, schemes: {Scheme.Https})
type
  Call_CloudEndpointsPreBackup_568490 = ref object of OpenApiRestCall_567667
proc url_CloudEndpointsPreBackup_568492(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  assert "cloudEndpointName" in path,
        "`cloudEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName"),
               (kind: ConstantSegment, value: "/cloudEndpoints/"),
               (kind: VariableSegment, value: "cloudEndpointName"),
               (kind: ConstantSegment, value: "/prebackup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudEndpointsPreBackup_568491(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pre Backup a given CloudEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: JString (required)
  ##                    : Name of Cloud Endpoint object.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568493 = path.getOrDefault("resourceGroupName")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "resourceGroupName", valid_568493
  var valid_568494 = path.getOrDefault("subscriptionId")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "subscriptionId", valid_568494
  var valid_568495 = path.getOrDefault("syncGroupName")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "syncGroupName", valid_568495
  var valid_568496 = path.getOrDefault("cloudEndpointName")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "cloudEndpointName", valid_568496
  var valid_568497 = path.getOrDefault("storageSyncServiceName")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "storageSyncServiceName", valid_568497
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568498 = query.getOrDefault("api-version")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "api-version", valid_568498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Body of Backup request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568500: Call_CloudEndpointsPreBackup_568490; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pre Backup a given CloudEndpoint.
  ## 
  let valid = call_568500.validator(path, query, header, formData, body)
  let scheme = call_568500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568500.url(scheme.get, call_568500.host, call_568500.base,
                         call_568500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568500, url, valid)

proc call*(call_568501: Call_CloudEndpointsPreBackup_568490;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          syncGroupName: string; cloudEndpointName: string; parameters: JsonNode;
          storageSyncServiceName: string): Recallable =
  ## cloudEndpointsPreBackup
  ## Pre Backup a given CloudEndpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   parameters: JObject (required)
  ##             : Body of Backup request.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568502 = newJObject()
  var query_568503 = newJObject()
  var body_568504 = newJObject()
  add(path_568502, "resourceGroupName", newJString(resourceGroupName))
  add(query_568503, "api-version", newJString(apiVersion))
  add(path_568502, "subscriptionId", newJString(subscriptionId))
  add(path_568502, "syncGroupName", newJString(syncGroupName))
  add(path_568502, "cloudEndpointName", newJString(cloudEndpointName))
  if parameters != nil:
    body_568504 = parameters
  add(path_568502, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568501.call(path_568502, query_568503, nil, nil, body_568504)

var cloudEndpointsPreBackup* = Call_CloudEndpointsPreBackup_568490(
    name: "cloudEndpointsPreBackup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/prebackup",
    validator: validate_CloudEndpointsPreBackup_568491, base: "",
    url: url_CloudEndpointsPreBackup_568492, schemes: {Scheme.Https})
type
  Call_CloudEndpointsPreRestore_568505 = ref object of OpenApiRestCall_567667
proc url_CloudEndpointsPreRestore_568507(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  assert "cloudEndpointName" in path,
        "`cloudEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName"),
               (kind: ConstantSegment, value: "/cloudEndpoints/"),
               (kind: VariableSegment, value: "cloudEndpointName"),
               (kind: ConstantSegment, value: "/prerestore")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudEndpointsPreRestore_568506(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pre Restore a given CloudEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: JString (required)
  ##                    : Name of Cloud Endpoint object.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568508 = path.getOrDefault("resourceGroupName")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "resourceGroupName", valid_568508
  var valid_568509 = path.getOrDefault("subscriptionId")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "subscriptionId", valid_568509
  var valid_568510 = path.getOrDefault("syncGroupName")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "syncGroupName", valid_568510
  var valid_568511 = path.getOrDefault("cloudEndpointName")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "cloudEndpointName", valid_568511
  var valid_568512 = path.getOrDefault("storageSyncServiceName")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "storageSyncServiceName", valid_568512
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568513 = query.getOrDefault("api-version")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "api-version", valid_568513
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Body of Cloud Endpoint object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568515: Call_CloudEndpointsPreRestore_568505; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pre Restore a given CloudEndpoint.
  ## 
  let valid = call_568515.validator(path, query, header, formData, body)
  let scheme = call_568515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568515.url(scheme.get, call_568515.host, call_568515.base,
                         call_568515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568515, url, valid)

proc call*(call_568516: Call_CloudEndpointsPreRestore_568505;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          syncGroupName: string; cloudEndpointName: string; parameters: JsonNode;
          storageSyncServiceName: string): Recallable =
  ## cloudEndpointsPreRestore
  ## Pre Restore a given CloudEndpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   parameters: JObject (required)
  ##             : Body of Cloud Endpoint object.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568517 = newJObject()
  var query_568518 = newJObject()
  var body_568519 = newJObject()
  add(path_568517, "resourceGroupName", newJString(resourceGroupName))
  add(query_568518, "api-version", newJString(apiVersion))
  add(path_568517, "subscriptionId", newJString(subscriptionId))
  add(path_568517, "syncGroupName", newJString(syncGroupName))
  add(path_568517, "cloudEndpointName", newJString(cloudEndpointName))
  if parameters != nil:
    body_568519 = parameters
  add(path_568517, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568516.call(path_568517, query_568518, nil, nil, body_568519)

var cloudEndpointsPreRestore* = Call_CloudEndpointsPreRestore_568505(
    name: "cloudEndpointsPreRestore", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/prerestore",
    validator: validate_CloudEndpointsPreRestore_568506, base: "",
    url: url_CloudEndpointsPreRestore_568507, schemes: {Scheme.Https})
type
  Call_CloudEndpointsRestoreheartbeat_568520 = ref object of OpenApiRestCall_567667
proc url_CloudEndpointsRestoreheartbeat_568522(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  assert "cloudEndpointName" in path,
        "`cloudEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName"),
               (kind: ConstantSegment, value: "/cloudEndpoints/"),
               (kind: VariableSegment, value: "cloudEndpointName"),
               (kind: ConstantSegment, value: "/restoreheartbeat")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudEndpointsRestoreheartbeat_568521(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restore Heartbeat a given CloudEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: JString (required)
  ##                    : Name of Cloud Endpoint object.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568523 = path.getOrDefault("resourceGroupName")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "resourceGroupName", valid_568523
  var valid_568524 = path.getOrDefault("subscriptionId")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "subscriptionId", valid_568524
  var valid_568525 = path.getOrDefault("syncGroupName")
  valid_568525 = validateParameter(valid_568525, JString, required = true,
                                 default = nil)
  if valid_568525 != nil:
    section.add "syncGroupName", valid_568525
  var valid_568526 = path.getOrDefault("cloudEndpointName")
  valid_568526 = validateParameter(valid_568526, JString, required = true,
                                 default = nil)
  if valid_568526 != nil:
    section.add "cloudEndpointName", valid_568526
  var valid_568527 = path.getOrDefault("storageSyncServiceName")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "storageSyncServiceName", valid_568527
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568528 = query.getOrDefault("api-version")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "api-version", valid_568528
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568529: Call_CloudEndpointsRestoreheartbeat_568520; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restore Heartbeat a given CloudEndpoint.
  ## 
  let valid = call_568529.validator(path, query, header, formData, body)
  let scheme = call_568529.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568529.url(scheme.get, call_568529.host, call_568529.base,
                         call_568529.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568529, url, valid)

proc call*(call_568530: Call_CloudEndpointsRestoreheartbeat_568520;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          syncGroupName: string; cloudEndpointName: string;
          storageSyncServiceName: string): Recallable =
  ## cloudEndpointsRestoreheartbeat
  ## Restore Heartbeat a given CloudEndpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568531 = newJObject()
  var query_568532 = newJObject()
  add(path_568531, "resourceGroupName", newJString(resourceGroupName))
  add(query_568532, "api-version", newJString(apiVersion))
  add(path_568531, "subscriptionId", newJString(subscriptionId))
  add(path_568531, "syncGroupName", newJString(syncGroupName))
  add(path_568531, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_568531, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568530.call(path_568531, query_568532, nil, nil, nil)

var cloudEndpointsRestoreheartbeat* = Call_CloudEndpointsRestoreheartbeat_568520(
    name: "cloudEndpointsRestoreheartbeat", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/restoreheartbeat",
    validator: validate_CloudEndpointsRestoreheartbeat_568521, base: "",
    url: url_CloudEndpointsRestoreheartbeat_568522, schemes: {Scheme.Https})
type
  Call_ServerEndpointsListBySyncGroup_568533 = ref object of OpenApiRestCall_567667
proc url_ServerEndpointsListBySyncGroup_568535(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName"),
               (kind: ConstantSegment, value: "/serverEndpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerEndpointsListBySyncGroup_568534(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a ServerEndpoint list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568536 = path.getOrDefault("resourceGroupName")
  valid_568536 = validateParameter(valid_568536, JString, required = true,
                                 default = nil)
  if valid_568536 != nil:
    section.add "resourceGroupName", valid_568536
  var valid_568537 = path.getOrDefault("subscriptionId")
  valid_568537 = validateParameter(valid_568537, JString, required = true,
                                 default = nil)
  if valid_568537 != nil:
    section.add "subscriptionId", valid_568537
  var valid_568538 = path.getOrDefault("syncGroupName")
  valid_568538 = validateParameter(valid_568538, JString, required = true,
                                 default = nil)
  if valid_568538 != nil:
    section.add "syncGroupName", valid_568538
  var valid_568539 = path.getOrDefault("storageSyncServiceName")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "storageSyncServiceName", valid_568539
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568540 = query.getOrDefault("api-version")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "api-version", valid_568540
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568541: Call_ServerEndpointsListBySyncGroup_568533; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a ServerEndpoint list.
  ## 
  let valid = call_568541.validator(path, query, header, formData, body)
  let scheme = call_568541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568541.url(scheme.get, call_568541.host, call_568541.base,
                         call_568541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568541, url, valid)

proc call*(call_568542: Call_ServerEndpointsListBySyncGroup_568533;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          syncGroupName: string; storageSyncServiceName: string): Recallable =
  ## serverEndpointsListBySyncGroup
  ## Get a ServerEndpoint list.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568543 = newJObject()
  var query_568544 = newJObject()
  add(path_568543, "resourceGroupName", newJString(resourceGroupName))
  add(query_568544, "api-version", newJString(apiVersion))
  add(path_568543, "subscriptionId", newJString(subscriptionId))
  add(path_568543, "syncGroupName", newJString(syncGroupName))
  add(path_568543, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568542.call(path_568543, query_568544, nil, nil, nil)

var serverEndpointsListBySyncGroup* = Call_ServerEndpointsListBySyncGroup_568533(
    name: "serverEndpointsListBySyncGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints",
    validator: validate_ServerEndpointsListBySyncGroup_568534, base: "",
    url: url_ServerEndpointsListBySyncGroup_568535, schemes: {Scheme.Https})
type
  Call_ServerEndpointsCreate_568558 = ref object of OpenApiRestCall_567667
proc url_ServerEndpointsCreate_568560(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  assert "serverEndpointName" in path,
        "`serverEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName"),
               (kind: ConstantSegment, value: "/serverEndpoints/"),
               (kind: VariableSegment, value: "serverEndpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerEndpointsCreate_568559(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new ServerEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverEndpointName: JString (required)
  ##                     : Name of Server Endpoint object.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverEndpointName` field"
  var valid_568561 = path.getOrDefault("serverEndpointName")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "serverEndpointName", valid_568561
  var valid_568562 = path.getOrDefault("resourceGroupName")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "resourceGroupName", valid_568562
  var valid_568563 = path.getOrDefault("subscriptionId")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "subscriptionId", valid_568563
  var valid_568564 = path.getOrDefault("syncGroupName")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "syncGroupName", valid_568564
  var valid_568565 = path.getOrDefault("storageSyncServiceName")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "storageSyncServiceName", valid_568565
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568566 = query.getOrDefault("api-version")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "api-version", valid_568566
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Body of Server Endpoint object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568568: Call_ServerEndpointsCreate_568558; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new ServerEndpoint.
  ## 
  let valid = call_568568.validator(path, query, header, formData, body)
  let scheme = call_568568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568568.url(scheme.get, call_568568.host, call_568568.base,
                         call_568568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568568, url, valid)

proc call*(call_568569: Call_ServerEndpointsCreate_568558;
          serverEndpointName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; syncGroupName: string; parameters: JsonNode;
          storageSyncServiceName: string): Recallable =
  ## serverEndpointsCreate
  ## Create a new ServerEndpoint.
  ##   serverEndpointName: string (required)
  ##                     : Name of Server Endpoint object.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   parameters: JObject (required)
  ##             : Body of Server Endpoint object.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568570 = newJObject()
  var query_568571 = newJObject()
  var body_568572 = newJObject()
  add(path_568570, "serverEndpointName", newJString(serverEndpointName))
  add(path_568570, "resourceGroupName", newJString(resourceGroupName))
  add(query_568571, "api-version", newJString(apiVersion))
  add(path_568570, "subscriptionId", newJString(subscriptionId))
  add(path_568570, "syncGroupName", newJString(syncGroupName))
  if parameters != nil:
    body_568572 = parameters
  add(path_568570, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568569.call(path_568570, query_568571, nil, nil, body_568572)

var serverEndpointsCreate* = Call_ServerEndpointsCreate_568558(
    name: "serverEndpointsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}",
    validator: validate_ServerEndpointsCreate_568559, base: "",
    url: url_ServerEndpointsCreate_568560, schemes: {Scheme.Https})
type
  Call_ServerEndpointsGet_568545 = ref object of OpenApiRestCall_567667
proc url_ServerEndpointsGet_568547(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  assert "serverEndpointName" in path,
        "`serverEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName"),
               (kind: ConstantSegment, value: "/serverEndpoints/"),
               (kind: VariableSegment, value: "serverEndpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerEndpointsGet_568546(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get a ServerEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverEndpointName: JString (required)
  ##                     : Name of Server Endpoint object.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverEndpointName` field"
  var valid_568548 = path.getOrDefault("serverEndpointName")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "serverEndpointName", valid_568548
  var valid_568549 = path.getOrDefault("resourceGroupName")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "resourceGroupName", valid_568549
  var valid_568550 = path.getOrDefault("subscriptionId")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "subscriptionId", valid_568550
  var valid_568551 = path.getOrDefault("syncGroupName")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "syncGroupName", valid_568551
  var valid_568552 = path.getOrDefault("storageSyncServiceName")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "storageSyncServiceName", valid_568552
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568553 = query.getOrDefault("api-version")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "api-version", valid_568553
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568554: Call_ServerEndpointsGet_568545; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a ServerEndpoint.
  ## 
  let valid = call_568554.validator(path, query, header, formData, body)
  let scheme = call_568554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568554.url(scheme.get, call_568554.host, call_568554.base,
                         call_568554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568554, url, valid)

proc call*(call_568555: Call_ServerEndpointsGet_568545; serverEndpointName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          syncGroupName: string; storageSyncServiceName: string): Recallable =
  ## serverEndpointsGet
  ## Get a ServerEndpoint.
  ##   serverEndpointName: string (required)
  ##                     : Name of Server Endpoint object.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568556 = newJObject()
  var query_568557 = newJObject()
  add(path_568556, "serverEndpointName", newJString(serverEndpointName))
  add(path_568556, "resourceGroupName", newJString(resourceGroupName))
  add(query_568557, "api-version", newJString(apiVersion))
  add(path_568556, "subscriptionId", newJString(subscriptionId))
  add(path_568556, "syncGroupName", newJString(syncGroupName))
  add(path_568556, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568555.call(path_568556, query_568557, nil, nil, nil)

var serverEndpointsGet* = Call_ServerEndpointsGet_568545(
    name: "serverEndpointsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}",
    validator: validate_ServerEndpointsGet_568546, base: "",
    url: url_ServerEndpointsGet_568547, schemes: {Scheme.Https})
type
  Call_ServerEndpointsUpdate_568586 = ref object of OpenApiRestCall_567667
proc url_ServerEndpointsUpdate_568588(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  assert "serverEndpointName" in path,
        "`serverEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName"),
               (kind: ConstantSegment, value: "/serverEndpoints/"),
               (kind: VariableSegment, value: "serverEndpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerEndpointsUpdate_568587(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch a given ServerEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverEndpointName: JString (required)
  ##                     : Name of Server Endpoint object.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverEndpointName` field"
  var valid_568589 = path.getOrDefault("serverEndpointName")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "serverEndpointName", valid_568589
  var valid_568590 = path.getOrDefault("resourceGroupName")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "resourceGroupName", valid_568590
  var valid_568591 = path.getOrDefault("subscriptionId")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "subscriptionId", valid_568591
  var valid_568592 = path.getOrDefault("syncGroupName")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "syncGroupName", valid_568592
  var valid_568593 = path.getOrDefault("storageSyncServiceName")
  valid_568593 = validateParameter(valid_568593, JString, required = true,
                                 default = nil)
  if valid_568593 != nil:
    section.add "storageSyncServiceName", valid_568593
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568594 = query.getOrDefault("api-version")
  valid_568594 = validateParameter(valid_568594, JString, required = true,
                                 default = nil)
  if valid_568594 != nil:
    section.add "api-version", valid_568594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Any of the properties applicable in PUT request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568596: Call_ServerEndpointsUpdate_568586; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a given ServerEndpoint.
  ## 
  let valid = call_568596.validator(path, query, header, formData, body)
  let scheme = call_568596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568596.url(scheme.get, call_568596.host, call_568596.base,
                         call_568596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568596, url, valid)

proc call*(call_568597: Call_ServerEndpointsUpdate_568586;
          serverEndpointName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; syncGroupName: string;
          storageSyncServiceName: string; parameters: JsonNode = nil): Recallable =
  ## serverEndpointsUpdate
  ## Patch a given ServerEndpoint.
  ##   serverEndpointName: string (required)
  ##                     : Name of Server Endpoint object.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   parameters: JObject
  ##             : Any of the properties applicable in PUT request.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568598 = newJObject()
  var query_568599 = newJObject()
  var body_568600 = newJObject()
  add(path_568598, "serverEndpointName", newJString(serverEndpointName))
  add(path_568598, "resourceGroupName", newJString(resourceGroupName))
  add(query_568599, "api-version", newJString(apiVersion))
  add(path_568598, "subscriptionId", newJString(subscriptionId))
  add(path_568598, "syncGroupName", newJString(syncGroupName))
  if parameters != nil:
    body_568600 = parameters
  add(path_568598, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568597.call(path_568598, query_568599, nil, nil, body_568600)

var serverEndpointsUpdate* = Call_ServerEndpointsUpdate_568586(
    name: "serverEndpointsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}",
    validator: validate_ServerEndpointsUpdate_568587, base: "",
    url: url_ServerEndpointsUpdate_568588, schemes: {Scheme.Https})
type
  Call_ServerEndpointsDelete_568573 = ref object of OpenApiRestCall_567667
proc url_ServerEndpointsDelete_568575(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  assert "serverEndpointName" in path,
        "`serverEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName"),
               (kind: ConstantSegment, value: "/serverEndpoints/"),
               (kind: VariableSegment, value: "serverEndpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerEndpointsDelete_568574(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a given ServerEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverEndpointName: JString (required)
  ##                     : Name of Server Endpoint object.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverEndpointName` field"
  var valid_568576 = path.getOrDefault("serverEndpointName")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "serverEndpointName", valid_568576
  var valid_568577 = path.getOrDefault("resourceGroupName")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "resourceGroupName", valid_568577
  var valid_568578 = path.getOrDefault("subscriptionId")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "subscriptionId", valid_568578
  var valid_568579 = path.getOrDefault("syncGroupName")
  valid_568579 = validateParameter(valid_568579, JString, required = true,
                                 default = nil)
  if valid_568579 != nil:
    section.add "syncGroupName", valid_568579
  var valid_568580 = path.getOrDefault("storageSyncServiceName")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "storageSyncServiceName", valid_568580
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568581 = query.getOrDefault("api-version")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "api-version", valid_568581
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568582: Call_ServerEndpointsDelete_568573; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a given ServerEndpoint.
  ## 
  let valid = call_568582.validator(path, query, header, formData, body)
  let scheme = call_568582.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568582.url(scheme.get, call_568582.host, call_568582.base,
                         call_568582.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568582, url, valid)

proc call*(call_568583: Call_ServerEndpointsDelete_568573;
          serverEndpointName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; syncGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## serverEndpointsDelete
  ## Delete a given ServerEndpoint.
  ##   serverEndpointName: string (required)
  ##                     : Name of Server Endpoint object.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568584 = newJObject()
  var query_568585 = newJObject()
  add(path_568584, "serverEndpointName", newJString(serverEndpointName))
  add(path_568584, "resourceGroupName", newJString(resourceGroupName))
  add(query_568585, "api-version", newJString(apiVersion))
  add(path_568584, "subscriptionId", newJString(subscriptionId))
  add(path_568584, "syncGroupName", newJString(syncGroupName))
  add(path_568584, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568583.call(path_568584, query_568585, nil, nil, nil)

var serverEndpointsDelete* = Call_ServerEndpointsDelete_568573(
    name: "serverEndpointsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}",
    validator: validate_ServerEndpointsDelete_568574, base: "",
    url: url_ServerEndpointsDelete_568575, schemes: {Scheme.Https})
type
  Call_ServerEndpointsRecallAction_568601 = ref object of OpenApiRestCall_567667
proc url_ServerEndpointsRecallAction_568603(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "syncGroupName" in path, "`syncGroupName` is a required path parameter"
  assert "serverEndpointName" in path,
        "`serverEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/syncGroups/"),
               (kind: VariableSegment, value: "syncGroupName"),
               (kind: ConstantSegment, value: "/serverEndpoints/"),
               (kind: VariableSegment, value: "serverEndpointName"),
               (kind: ConstantSegment, value: "/recallAction")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerEndpointsRecallAction_568602(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Recall a server endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverEndpointName: JString (required)
  ##                     : Name of Server Endpoint object.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverEndpointName` field"
  var valid_568604 = path.getOrDefault("serverEndpointName")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "serverEndpointName", valid_568604
  var valid_568605 = path.getOrDefault("resourceGroupName")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = nil)
  if valid_568605 != nil:
    section.add "resourceGroupName", valid_568605
  var valid_568606 = path.getOrDefault("subscriptionId")
  valid_568606 = validateParameter(valid_568606, JString, required = true,
                                 default = nil)
  if valid_568606 != nil:
    section.add "subscriptionId", valid_568606
  var valid_568607 = path.getOrDefault("syncGroupName")
  valid_568607 = validateParameter(valid_568607, JString, required = true,
                                 default = nil)
  if valid_568607 != nil:
    section.add "syncGroupName", valid_568607
  var valid_568608 = path.getOrDefault("storageSyncServiceName")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "storageSyncServiceName", valid_568608
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568609 = query.getOrDefault("api-version")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "api-version", valid_568609
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Body of Recall Action object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568611: Call_ServerEndpointsRecallAction_568601; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recall a server endpoint.
  ## 
  let valid = call_568611.validator(path, query, header, formData, body)
  let scheme = call_568611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568611.url(scheme.get, call_568611.host, call_568611.base,
                         call_568611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568611, url, valid)

proc call*(call_568612: Call_ServerEndpointsRecallAction_568601;
          serverEndpointName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; syncGroupName: string; parameters: JsonNode;
          storageSyncServiceName: string): Recallable =
  ## serverEndpointsRecallAction
  ## Recall a server endpoint.
  ##   serverEndpointName: string (required)
  ##                     : Name of Server Endpoint object.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   parameters: JObject (required)
  ##             : Body of Recall Action object.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568613 = newJObject()
  var query_568614 = newJObject()
  var body_568615 = newJObject()
  add(path_568613, "serverEndpointName", newJString(serverEndpointName))
  add(path_568613, "resourceGroupName", newJString(resourceGroupName))
  add(query_568614, "api-version", newJString(apiVersion))
  add(path_568613, "subscriptionId", newJString(subscriptionId))
  add(path_568613, "syncGroupName", newJString(syncGroupName))
  if parameters != nil:
    body_568615 = parameters
  add(path_568613, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568612.call(path_568613, query_568614, nil, nil, body_568615)

var serverEndpointsRecallAction* = Call_ServerEndpointsRecallAction_568601(
    name: "serverEndpointsRecallAction", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}/recallAction",
    validator: validate_ServerEndpointsRecallAction_568602, base: "",
    url: url_ServerEndpointsRecallAction_568603, schemes: {Scheme.Https})
type
  Call_WorkflowsListByStorageSyncService_568616 = ref object of OpenApiRestCall_567667
proc url_WorkflowsListByStorageSyncService_568618(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/workflows")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsListByStorageSyncService_568617(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Workflow List
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568619 = path.getOrDefault("resourceGroupName")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "resourceGroupName", valid_568619
  var valid_568620 = path.getOrDefault("subscriptionId")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = nil)
  if valid_568620 != nil:
    section.add "subscriptionId", valid_568620
  var valid_568621 = path.getOrDefault("storageSyncServiceName")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "storageSyncServiceName", valid_568621
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568622 = query.getOrDefault("api-version")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "api-version", valid_568622
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568623: Call_WorkflowsListByStorageSyncService_568616;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a Workflow List
  ## 
  let valid = call_568623.validator(path, query, header, formData, body)
  let scheme = call_568623.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568623.url(scheme.get, call_568623.host, call_568623.base,
                         call_568623.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568623, url, valid)

proc call*(call_568624: Call_WorkflowsListByStorageSyncService_568616;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          storageSyncServiceName: string): Recallable =
  ## workflowsListByStorageSyncService
  ## Get a Workflow List
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568625 = newJObject()
  var query_568626 = newJObject()
  add(path_568625, "resourceGroupName", newJString(resourceGroupName))
  add(query_568626, "api-version", newJString(apiVersion))
  add(path_568625, "subscriptionId", newJString(subscriptionId))
  add(path_568625, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568624.call(path_568625, query_568626, nil, nil, nil)

var workflowsListByStorageSyncService* = Call_WorkflowsListByStorageSyncService_568616(
    name: "workflowsListByStorageSyncService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/workflows",
    validator: validate_WorkflowsListByStorageSyncService_568617, base: "",
    url: url_WorkflowsListByStorageSyncService_568618, schemes: {Scheme.Https})
type
  Call_WorkflowsGet_568627 = ref object of OpenApiRestCall_567667
proc url_WorkflowsGet_568629(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "workflowId" in path, "`workflowId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/workflows/"),
               (kind: VariableSegment, value: "workflowId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsGet_568628(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Workflows resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   workflowId: JString (required)
  ##             : workflow Id
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568630 = path.getOrDefault("resourceGroupName")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "resourceGroupName", valid_568630
  var valid_568631 = path.getOrDefault("subscriptionId")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "subscriptionId", valid_568631
  var valid_568632 = path.getOrDefault("workflowId")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "workflowId", valid_568632
  var valid_568633 = path.getOrDefault("storageSyncServiceName")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "storageSyncServiceName", valid_568633
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568634 = query.getOrDefault("api-version")
  valid_568634 = validateParameter(valid_568634, JString, required = true,
                                 default = nil)
  if valid_568634 != nil:
    section.add "api-version", valid_568634
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568635: Call_WorkflowsGet_568627; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Workflows resource
  ## 
  let valid = call_568635.validator(path, query, header, formData, body)
  let scheme = call_568635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568635.url(scheme.get, call_568635.host, call_568635.base,
                         call_568635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568635, url, valid)

proc call*(call_568636: Call_WorkflowsGet_568627; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workflowId: string;
          storageSyncServiceName: string): Recallable =
  ## workflowsGet
  ## Get Workflows resource
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   workflowId: string (required)
  ##             : workflow Id
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568637 = newJObject()
  var query_568638 = newJObject()
  add(path_568637, "resourceGroupName", newJString(resourceGroupName))
  add(query_568638, "api-version", newJString(apiVersion))
  add(path_568637, "subscriptionId", newJString(subscriptionId))
  add(path_568637, "workflowId", newJString(workflowId))
  add(path_568637, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568636.call(path_568637, query_568638, nil, nil, nil)

var workflowsGet* = Call_WorkflowsGet_568627(name: "workflowsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/workflows/{workflowId}",
    validator: validate_WorkflowsGet_568628, base: "", url: url_WorkflowsGet_568629,
    schemes: {Scheme.Https})
type
  Call_WorkflowsAbort_568639 = ref object of OpenApiRestCall_567667
proc url_WorkflowsAbort_568641(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "storageSyncServiceName" in path,
        "`storageSyncServiceName` is a required path parameter"
  assert "workflowId" in path, "`workflowId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/storageSyncServices/"),
               (kind: VariableSegment, value: "storageSyncServiceName"),
               (kind: ConstantSegment, value: "/workflows/"),
               (kind: VariableSegment, value: "workflowId"),
               (kind: ConstantSegment, value: "/abort")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkflowsAbort_568640(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Abort the given workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   workflowId: JString (required)
  ##             : workflow Id
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568642 = path.getOrDefault("resourceGroupName")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "resourceGroupName", valid_568642
  var valid_568643 = path.getOrDefault("subscriptionId")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "subscriptionId", valid_568643
  var valid_568644 = path.getOrDefault("workflowId")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "workflowId", valid_568644
  var valid_568645 = path.getOrDefault("storageSyncServiceName")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = nil)
  if valid_568645 != nil:
    section.add "storageSyncServiceName", valid_568645
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568646 = query.getOrDefault("api-version")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "api-version", valid_568646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568647: Call_WorkflowsAbort_568639; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Abort the given workflow.
  ## 
  let valid = call_568647.validator(path, query, header, formData, body)
  let scheme = call_568647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568647.url(scheme.get, call_568647.host, call_568647.base,
                         call_568647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568647, url, valid)

proc call*(call_568648: Call_WorkflowsAbort_568639; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workflowId: string;
          storageSyncServiceName: string): Recallable =
  ## workflowsAbort
  ## Abort the given workflow.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   workflowId: string (required)
  ##             : workflow Id
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_568649 = newJObject()
  var query_568650 = newJObject()
  add(path_568649, "resourceGroupName", newJString(resourceGroupName))
  add(query_568650, "api-version", newJString(apiVersion))
  add(path_568649, "subscriptionId", newJString(subscriptionId))
  add(path_568649, "workflowId", newJString(workflowId))
  add(path_568649, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_568648.call(path_568649, query_568650, nil, nil, nil)

var workflowsAbort* = Call_WorkflowsAbort_568639(name: "workflowsAbort",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/workflows/{workflowId}/abort",
    validator: validate_WorkflowsAbort_568640, base: "", url: url_WorkflowsAbort_568641,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
