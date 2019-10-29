
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Microsoft Storage Sync
## version: 2019-03-01
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

  OpenApiRestCall_563565 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563565](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563565): Option[Scheme] {.used.} =
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
  macServiceName = "storagesync"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563787 = ref object of OpenApiRestCall_563565
proc url_OperationsList_563789(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563788(path: JsonNode; query: JsonNode;
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
  var valid_563937 = query.getOrDefault("api-version")
  valid_563937 = validateParameter(valid_563937, JString, required = true,
                                 default = nil)
  if valid_563937 != nil:
    section.add "api-version", valid_563937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_OperationsList_563787; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Storage Sync Rest API operations.
  ## 
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_OperationsList_563787; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Storage Sync Rest API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  result = call_564035.call(nil, query_564036, nil, nil, nil)

var operationsList* = Call_OperationsList_563787(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.StorageSync/operations",
    validator: validate_OperationsList_563788, base: "", url: url_OperationsList_563789,
    schemes: {Scheme.Https})
type
  Call_StorageSyncServicesCheckNameAvailability_564076 = ref object of OpenApiRestCall_563565
proc url_StorageSyncServicesCheckNameAvailability_564078(protocol: Scheme;
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

proc validate_StorageSyncServicesCheckNameAvailability_564077(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the give namespace name availability.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The desired region for the name check.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564119 = path.getOrDefault("locationName")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "locationName", valid_564119
  var valid_564120 = path.getOrDefault("subscriptionId")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "subscriptionId", valid_564120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given namespace name
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564123: Call_StorageSyncServicesCheckNameAvailability_564076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the give namespace name availability.
  ## 
  let valid = call_564123.validator(path, query, header, formData, body)
  let scheme = call_564123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564123.url(scheme.get, call_564123.host, call_564123.base,
                         call_564123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564123, url, valid)

proc call*(call_564124: Call_StorageSyncServicesCheckNameAvailability_564076;
          apiVersion: string; locationName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## storageSyncServicesCheckNameAvailability
  ## Check the give namespace name availability.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   locationName: string (required)
  ##               : The desired region for the name check.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given namespace name
  var path_564125 = newJObject()
  var query_564126 = newJObject()
  var body_564127 = newJObject()
  add(query_564126, "api-version", newJString(apiVersion))
  add(path_564125, "locationName", newJString(locationName))
  add(path_564125, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564127 = parameters
  result = call_564124.call(path_564125, query_564126, nil, nil, body_564127)

var storageSyncServicesCheckNameAvailability* = Call_StorageSyncServicesCheckNameAvailability_564076(
    name: "storageSyncServicesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.StorageSync/locations/{locationName}/checkNameAvailability",
    validator: validate_StorageSyncServicesCheckNameAvailability_564077, base: "",
    url: url_StorageSyncServicesCheckNameAvailability_564078,
    schemes: {Scheme.Https})
type
  Call_StorageSyncServicesListBySubscription_564128 = ref object of OpenApiRestCall_563565
proc url_StorageSyncServicesListBySubscription_564130(protocol: Scheme;
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

proc validate_StorageSyncServicesListBySubscription_564129(path: JsonNode;
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
  var valid_564131 = path.getOrDefault("subscriptionId")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "subscriptionId", valid_564131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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

proc call*(call_564133: Call_StorageSyncServicesListBySubscription_564128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a StorageSyncService list by subscription.
  ## 
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_StorageSyncServicesListBySubscription_564128;
          apiVersion: string; subscriptionId: string): Recallable =
  ## storageSyncServicesListBySubscription
  ## Get a StorageSyncService list by subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  add(query_564136, "api-version", newJString(apiVersion))
  add(path_564135, "subscriptionId", newJString(subscriptionId))
  result = call_564134.call(path_564135, query_564136, nil, nil, nil)

var storageSyncServicesListBySubscription* = Call_StorageSyncServicesListBySubscription_564128(
    name: "storageSyncServicesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.StorageSync/storageSyncServices",
    validator: validate_StorageSyncServicesListBySubscription_564129, base: "",
    url: url_StorageSyncServicesListBySubscription_564130, schemes: {Scheme.Https})
type
  Call_OperationStatusGet_564137 = ref object of OpenApiRestCall_563565
proc url_OperationStatusGet_564139(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "workflowId" in path, "`workflowId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StorageSync/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/workflows/"),
               (kind: VariableSegment, value: "workflowId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationStatusGet_564138(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get Operation status
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowId: JString (required)
  ##             : workflow Id
  ##   locationName: JString (required)
  ##               : The desired region to obtain information from.
  ##   operationId: JString (required)
  ##              : operation Id
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowId` field"
  var valid_564140 = path.getOrDefault("workflowId")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "workflowId", valid_564140
  var valid_564141 = path.getOrDefault("locationName")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "locationName", valid_564141
  var valid_564142 = path.getOrDefault("operationId")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "operationId", valid_564142
  var valid_564143 = path.getOrDefault("subscriptionId")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "subscriptionId", valid_564143
  var valid_564144 = path.getOrDefault("resourceGroupName")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "resourceGroupName", valid_564144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564145 = query.getOrDefault("api-version")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "api-version", valid_564145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564146: Call_OperationStatusGet_564137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Operation status
  ## 
  let valid = call_564146.validator(path, query, header, formData, body)
  let scheme = call_564146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564146.url(scheme.get, call_564146.host, call_564146.base,
                         call_564146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564146, url, valid)

proc call*(call_564147: Call_OperationStatusGet_564137; workflowId: string;
          apiVersion: string; locationName: string; operationId: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## operationStatusGet
  ## Get Operation status
  ##   workflowId: string (required)
  ##             : workflow Id
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   locationName: string (required)
  ##               : The desired region to obtain information from.
  ##   operationId: string (required)
  ##              : operation Id
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564148 = newJObject()
  var query_564149 = newJObject()
  add(path_564148, "workflowId", newJString(workflowId))
  add(query_564149, "api-version", newJString(apiVersion))
  add(path_564148, "locationName", newJString(locationName))
  add(path_564148, "operationId", newJString(operationId))
  add(path_564148, "subscriptionId", newJString(subscriptionId))
  add(path_564148, "resourceGroupName", newJString(resourceGroupName))
  result = call_564147.call(path_564148, query_564149, nil, nil, nil)

var operationStatusGet* = Call_OperationStatusGet_564137(
    name: "operationStatusGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/locations/{locationName}/workflows/{workflowId}/operations/{operationId}",
    validator: validate_OperationStatusGet_564138, base: "",
    url: url_OperationStatusGet_564139, schemes: {Scheme.Https})
type
  Call_StorageSyncServicesListByResourceGroup_564150 = ref object of OpenApiRestCall_563565
proc url_StorageSyncServicesListByResourceGroup_564152(protocol: Scheme;
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

proc validate_StorageSyncServicesListByResourceGroup_564151(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a StorageSyncService list by Resource group name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564153 = path.getOrDefault("subscriptionId")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "subscriptionId", valid_564153
  var valid_564154 = path.getOrDefault("resourceGroupName")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "resourceGroupName", valid_564154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564155 = query.getOrDefault("api-version")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "api-version", valid_564155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564156: Call_StorageSyncServicesListByResourceGroup_564150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a StorageSyncService list by Resource group name.
  ## 
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_StorageSyncServicesListByResourceGroup_564150;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## storageSyncServicesListByResourceGroup
  ## Get a StorageSyncService list by Resource group name.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564158 = newJObject()
  var query_564159 = newJObject()
  add(query_564159, "api-version", newJString(apiVersion))
  add(path_564158, "subscriptionId", newJString(subscriptionId))
  add(path_564158, "resourceGroupName", newJString(resourceGroupName))
  result = call_564157.call(path_564158, query_564159, nil, nil, nil)

var storageSyncServicesListByResourceGroup* = Call_StorageSyncServicesListByResourceGroup_564150(
    name: "storageSyncServicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices",
    validator: validate_StorageSyncServicesListByResourceGroup_564151, base: "",
    url: url_StorageSyncServicesListByResourceGroup_564152,
    schemes: {Scheme.Https})
type
  Call_StorageSyncServicesCreate_564171 = ref object of OpenApiRestCall_563565
proc url_StorageSyncServicesCreate_564173(protocol: Scheme; host: string;
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

proc validate_StorageSyncServicesCreate_564172(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new StorageSyncService.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564174 = path.getOrDefault("subscriptionId")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "subscriptionId", valid_564174
  var valid_564175 = path.getOrDefault("resourceGroupName")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "resourceGroupName", valid_564175
  var valid_564176 = path.getOrDefault("storageSyncServiceName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "storageSyncServiceName", valid_564176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564177 = query.getOrDefault("api-version")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "api-version", valid_564177
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

proc call*(call_564179: Call_StorageSyncServicesCreate_564171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new StorageSyncService.
  ## 
  let valid = call_564179.validator(path, query, header, formData, body)
  let scheme = call_564179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564179.url(scheme.get, call_564179.host, call_564179.base,
                         call_564179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564179, url, valid)

proc call*(call_564180: Call_StorageSyncServicesCreate_564171; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string; parameters: JsonNode): Recallable =
  ## storageSyncServicesCreate
  ## Create a new StorageSyncService.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Storage Sync Service resource name.
  var path_564181 = newJObject()
  var query_564182 = newJObject()
  var body_564183 = newJObject()
  add(query_564182, "api-version", newJString(apiVersion))
  add(path_564181, "subscriptionId", newJString(subscriptionId))
  add(path_564181, "resourceGroupName", newJString(resourceGroupName))
  add(path_564181, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564183 = parameters
  result = call_564180.call(path_564181, query_564182, nil, nil, body_564183)

var storageSyncServicesCreate* = Call_StorageSyncServicesCreate_564171(
    name: "storageSyncServicesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}",
    validator: validate_StorageSyncServicesCreate_564172, base: "",
    url: url_StorageSyncServicesCreate_564173, schemes: {Scheme.Https})
type
  Call_StorageSyncServicesGet_564160 = ref object of OpenApiRestCall_563565
proc url_StorageSyncServicesGet_564162(protocol: Scheme; host: string; base: string;
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

proc validate_StorageSyncServicesGet_564161(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a given StorageSyncService.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564163 = path.getOrDefault("subscriptionId")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "subscriptionId", valid_564163
  var valid_564164 = path.getOrDefault("resourceGroupName")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "resourceGroupName", valid_564164
  var valid_564165 = path.getOrDefault("storageSyncServiceName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "storageSyncServiceName", valid_564165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564166 = query.getOrDefault("api-version")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "api-version", valid_564166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564167: Call_StorageSyncServicesGet_564160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a given StorageSyncService.
  ## 
  let valid = call_564167.validator(path, query, header, formData, body)
  let scheme = call_564167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564167.url(scheme.get, call_564167.host, call_564167.base,
                         call_564167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564167, url, valid)

proc call*(call_564168: Call_StorageSyncServicesGet_564160; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## storageSyncServicesGet
  ## Get a given StorageSyncService.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564169 = newJObject()
  var query_564170 = newJObject()
  add(query_564170, "api-version", newJString(apiVersion))
  add(path_564169, "subscriptionId", newJString(subscriptionId))
  add(path_564169, "resourceGroupName", newJString(resourceGroupName))
  add(path_564169, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564168.call(path_564169, query_564170, nil, nil, nil)

var storageSyncServicesGet* = Call_StorageSyncServicesGet_564160(
    name: "storageSyncServicesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}",
    validator: validate_StorageSyncServicesGet_564161, base: "",
    url: url_StorageSyncServicesGet_564162, schemes: {Scheme.Https})
type
  Call_StorageSyncServicesUpdate_564195 = ref object of OpenApiRestCall_563565
proc url_StorageSyncServicesUpdate_564197(protocol: Scheme; host: string;
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

proc validate_StorageSyncServicesUpdate_564196(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch a given StorageSyncService.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564198 = path.getOrDefault("subscriptionId")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "subscriptionId", valid_564198
  var valid_564199 = path.getOrDefault("resourceGroupName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "resourceGroupName", valid_564199
  var valid_564200 = path.getOrDefault("storageSyncServiceName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "storageSyncServiceName", valid_564200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564201 = query.getOrDefault("api-version")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "api-version", valid_564201
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

proc call*(call_564203: Call_StorageSyncServicesUpdate_564195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a given StorageSyncService.
  ## 
  let valid = call_564203.validator(path, query, header, formData, body)
  let scheme = call_564203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564203.url(scheme.get, call_564203.host, call_564203.base,
                         call_564203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564203, url, valid)

proc call*(call_564204: Call_StorageSyncServicesUpdate_564195; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string; parameters: JsonNode = nil): Recallable =
  ## storageSyncServicesUpdate
  ## Patch a given StorageSyncService.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject
  ##             : Storage Sync Service resource.
  var path_564205 = newJObject()
  var query_564206 = newJObject()
  var body_564207 = newJObject()
  add(query_564206, "api-version", newJString(apiVersion))
  add(path_564205, "subscriptionId", newJString(subscriptionId))
  add(path_564205, "resourceGroupName", newJString(resourceGroupName))
  add(path_564205, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564207 = parameters
  result = call_564204.call(path_564205, query_564206, nil, nil, body_564207)

var storageSyncServicesUpdate* = Call_StorageSyncServicesUpdate_564195(
    name: "storageSyncServicesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}",
    validator: validate_StorageSyncServicesUpdate_564196, base: "",
    url: url_StorageSyncServicesUpdate_564197, schemes: {Scheme.Https})
type
  Call_StorageSyncServicesDelete_564184 = ref object of OpenApiRestCall_563565
proc url_StorageSyncServicesDelete_564186(protocol: Scheme; host: string;
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

proc validate_StorageSyncServicesDelete_564185(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a given StorageSyncService.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564187 = path.getOrDefault("subscriptionId")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "subscriptionId", valid_564187
  var valid_564188 = path.getOrDefault("resourceGroupName")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "resourceGroupName", valid_564188
  var valid_564189 = path.getOrDefault("storageSyncServiceName")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "storageSyncServiceName", valid_564189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564190 = query.getOrDefault("api-version")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "api-version", valid_564190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564191: Call_StorageSyncServicesDelete_564184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a given StorageSyncService.
  ## 
  let valid = call_564191.validator(path, query, header, formData, body)
  let scheme = call_564191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564191.url(scheme.get, call_564191.host, call_564191.base,
                         call_564191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564191, url, valid)

proc call*(call_564192: Call_StorageSyncServicesDelete_564184; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## storageSyncServicesDelete
  ## Delete a given StorageSyncService.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564193 = newJObject()
  var query_564194 = newJObject()
  add(query_564194, "api-version", newJString(apiVersion))
  add(path_564193, "subscriptionId", newJString(subscriptionId))
  add(path_564193, "resourceGroupName", newJString(resourceGroupName))
  add(path_564193, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564192.call(path_564193, query_564194, nil, nil, nil)

var storageSyncServicesDelete* = Call_StorageSyncServicesDelete_564184(
    name: "storageSyncServicesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}",
    validator: validate_StorageSyncServicesDelete_564185, base: "",
    url: url_StorageSyncServicesDelete_564186, schemes: {Scheme.Https})
type
  Call_RegisteredServersListByStorageSyncService_564208 = ref object of OpenApiRestCall_563565
proc url_RegisteredServersListByStorageSyncService_564210(protocol: Scheme;
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

proc validate_RegisteredServersListByStorageSyncService_564209(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a given registered server list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564211 = path.getOrDefault("subscriptionId")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "subscriptionId", valid_564211
  var valid_564212 = path.getOrDefault("resourceGroupName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "resourceGroupName", valid_564212
  var valid_564213 = path.getOrDefault("storageSyncServiceName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "storageSyncServiceName", valid_564213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564214 = query.getOrDefault("api-version")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "api-version", valid_564214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564215: Call_RegisteredServersListByStorageSyncService_564208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a given registered server list.
  ## 
  let valid = call_564215.validator(path, query, header, formData, body)
  let scheme = call_564215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564215.url(scheme.get, call_564215.host, call_564215.base,
                         call_564215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564215, url, valid)

proc call*(call_564216: Call_RegisteredServersListByStorageSyncService_564208;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## registeredServersListByStorageSyncService
  ## Get a given registered server list.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564217 = newJObject()
  var query_564218 = newJObject()
  add(query_564218, "api-version", newJString(apiVersion))
  add(path_564217, "subscriptionId", newJString(subscriptionId))
  add(path_564217, "resourceGroupName", newJString(resourceGroupName))
  add(path_564217, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564216.call(path_564217, query_564218, nil, nil, nil)

var registeredServersListByStorageSyncService* = Call_RegisteredServersListByStorageSyncService_564208(
    name: "registeredServersListByStorageSyncService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers",
    validator: validate_RegisteredServersListByStorageSyncService_564209,
    base: "", url: url_RegisteredServersListByStorageSyncService_564210,
    schemes: {Scheme.Https})
type
  Call_RegisteredServersCreate_564231 = ref object of OpenApiRestCall_563565
proc url_RegisteredServersCreate_564233(protocol: Scheme; host: string; base: string;
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

proc validate_RegisteredServersCreate_564232(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a new registered server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverId: JString (required)
  ##           : GUID identifying the on-premises server.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serverId` field"
  var valid_564234 = path.getOrDefault("serverId")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "serverId", valid_564234
  var valid_564235 = path.getOrDefault("subscriptionId")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "subscriptionId", valid_564235
  var valid_564236 = path.getOrDefault("resourceGroupName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "resourceGroupName", valid_564236
  var valid_564237 = path.getOrDefault("storageSyncServiceName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "storageSyncServiceName", valid_564237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564238 = query.getOrDefault("api-version")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "api-version", valid_564238
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

proc call*(call_564240: Call_RegisteredServersCreate_564231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a new registered server.
  ## 
  let valid = call_564240.validator(path, query, header, formData, body)
  let scheme = call_564240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564240.url(scheme.get, call_564240.host, call_564240.base,
                         call_564240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564240, url, valid)

proc call*(call_564241: Call_RegisteredServersCreate_564231; apiVersion: string;
          serverId: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string; parameters: JsonNode): Recallable =
  ## registeredServersCreate
  ## Add a new registered server.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   serverId: string (required)
  ##           : GUID identifying the on-premises server.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Body of Registered Server object.
  var path_564242 = newJObject()
  var query_564243 = newJObject()
  var body_564244 = newJObject()
  add(query_564243, "api-version", newJString(apiVersion))
  add(path_564242, "serverId", newJString(serverId))
  add(path_564242, "subscriptionId", newJString(subscriptionId))
  add(path_564242, "resourceGroupName", newJString(resourceGroupName))
  add(path_564242, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564244 = parameters
  result = call_564241.call(path_564242, query_564243, nil, nil, body_564244)

var registeredServersCreate* = Call_RegisteredServersCreate_564231(
    name: "registeredServersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers/{serverId}",
    validator: validate_RegisteredServersCreate_564232, base: "",
    url: url_RegisteredServersCreate_564233, schemes: {Scheme.Https})
type
  Call_RegisteredServersGet_564219 = ref object of OpenApiRestCall_563565
proc url_RegisteredServersGet_564221(protocol: Scheme; host: string; base: string;
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

proc validate_RegisteredServersGet_564220(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a given registered server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverId: JString (required)
  ##           : GUID identifying the on-premises server.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serverId` field"
  var valid_564222 = path.getOrDefault("serverId")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "serverId", valid_564222
  var valid_564223 = path.getOrDefault("subscriptionId")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "subscriptionId", valid_564223
  var valid_564224 = path.getOrDefault("resourceGroupName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "resourceGroupName", valid_564224
  var valid_564225 = path.getOrDefault("storageSyncServiceName")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "storageSyncServiceName", valid_564225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564226 = query.getOrDefault("api-version")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "api-version", valid_564226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564227: Call_RegisteredServersGet_564219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a given registered server.
  ## 
  let valid = call_564227.validator(path, query, header, formData, body)
  let scheme = call_564227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564227.url(scheme.get, call_564227.host, call_564227.base,
                         call_564227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564227, url, valid)

proc call*(call_564228: Call_RegisteredServersGet_564219; apiVersion: string;
          serverId: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## registeredServersGet
  ## Get a given registered server.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   serverId: string (required)
  ##           : GUID identifying the on-premises server.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564229 = newJObject()
  var query_564230 = newJObject()
  add(query_564230, "api-version", newJString(apiVersion))
  add(path_564229, "serverId", newJString(serverId))
  add(path_564229, "subscriptionId", newJString(subscriptionId))
  add(path_564229, "resourceGroupName", newJString(resourceGroupName))
  add(path_564229, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564228.call(path_564229, query_564230, nil, nil, nil)

var registeredServersGet* = Call_RegisteredServersGet_564219(
    name: "registeredServersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers/{serverId}",
    validator: validate_RegisteredServersGet_564220, base: "",
    url: url_RegisteredServersGet_564221, schemes: {Scheme.Https})
type
  Call_RegisteredServersDelete_564245 = ref object of OpenApiRestCall_563565
proc url_RegisteredServersDelete_564247(protocol: Scheme; host: string; base: string;
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

proc validate_RegisteredServersDelete_564246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the given registered server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverId: JString (required)
  ##           : GUID identifying the on-premises server.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serverId` field"
  var valid_564248 = path.getOrDefault("serverId")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "serverId", valid_564248
  var valid_564249 = path.getOrDefault("subscriptionId")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "subscriptionId", valid_564249
  var valid_564250 = path.getOrDefault("resourceGroupName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "resourceGroupName", valid_564250
  var valid_564251 = path.getOrDefault("storageSyncServiceName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "storageSyncServiceName", valid_564251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564252 = query.getOrDefault("api-version")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "api-version", valid_564252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564253: Call_RegisteredServersDelete_564245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the given registered server.
  ## 
  let valid = call_564253.validator(path, query, header, formData, body)
  let scheme = call_564253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564253.url(scheme.get, call_564253.host, call_564253.base,
                         call_564253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564253, url, valid)

proc call*(call_564254: Call_RegisteredServersDelete_564245; apiVersion: string;
          serverId: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## registeredServersDelete
  ## Delete the given registered server.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   serverId: string (required)
  ##           : GUID identifying the on-premises server.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564255 = newJObject()
  var query_564256 = newJObject()
  add(query_564256, "api-version", newJString(apiVersion))
  add(path_564255, "serverId", newJString(serverId))
  add(path_564255, "subscriptionId", newJString(subscriptionId))
  add(path_564255, "resourceGroupName", newJString(resourceGroupName))
  add(path_564255, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564254.call(path_564255, query_564256, nil, nil, nil)

var registeredServersDelete* = Call_RegisteredServersDelete_564245(
    name: "registeredServersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers/{serverId}",
    validator: validate_RegisteredServersDelete_564246, base: "",
    url: url_RegisteredServersDelete_564247, schemes: {Scheme.Https})
type
  Call_RegisteredServersTriggerRollover_564257 = ref object of OpenApiRestCall_563565
proc url_RegisteredServersTriggerRollover_564259(protocol: Scheme; host: string;
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

proc validate_RegisteredServersTriggerRollover_564258(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Triggers Server certificate rollover.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverId: JString (required)
  ##           : Server Id
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serverId` field"
  var valid_564260 = path.getOrDefault("serverId")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "serverId", valid_564260
  var valid_564261 = path.getOrDefault("subscriptionId")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "subscriptionId", valid_564261
  var valid_564262 = path.getOrDefault("resourceGroupName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "resourceGroupName", valid_564262
  var valid_564263 = path.getOrDefault("storageSyncServiceName")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "storageSyncServiceName", valid_564263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564264 = query.getOrDefault("api-version")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "api-version", valid_564264
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

proc call*(call_564266: Call_RegisteredServersTriggerRollover_564257;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Triggers Server certificate rollover.
  ## 
  let valid = call_564266.validator(path, query, header, formData, body)
  let scheme = call_564266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564266.url(scheme.get, call_564266.host, call_564266.base,
                         call_564266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564266, url, valid)

proc call*(call_564267: Call_RegisteredServersTriggerRollover_564257;
          apiVersion: string; serverId: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string;
          parameters: JsonNode): Recallable =
  ## registeredServersTriggerRollover
  ## Triggers Server certificate rollover.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   serverId: string (required)
  ##           : Server Id
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Body of Trigger Rollover request.
  var path_564268 = newJObject()
  var query_564269 = newJObject()
  var body_564270 = newJObject()
  add(query_564269, "api-version", newJString(apiVersion))
  add(path_564268, "serverId", newJString(serverId))
  add(path_564268, "subscriptionId", newJString(subscriptionId))
  add(path_564268, "resourceGroupName", newJString(resourceGroupName))
  add(path_564268, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564270 = parameters
  result = call_564267.call(path_564268, query_564269, nil, nil, body_564270)

var registeredServersTriggerRollover* = Call_RegisteredServersTriggerRollover_564257(
    name: "registeredServersTriggerRollover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers/{serverId}/triggerRollover",
    validator: validate_RegisteredServersTriggerRollover_564258, base: "",
    url: url_RegisteredServersTriggerRollover_564259, schemes: {Scheme.Https})
type
  Call_SyncGroupsListByStorageSyncService_564271 = ref object of OpenApiRestCall_563565
proc url_SyncGroupsListByStorageSyncService_564273(protocol: Scheme; host: string;
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

proc validate_SyncGroupsListByStorageSyncService_564272(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a SyncGroup List.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564274 = path.getOrDefault("subscriptionId")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "subscriptionId", valid_564274
  var valid_564275 = path.getOrDefault("resourceGroupName")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "resourceGroupName", valid_564275
  var valid_564276 = path.getOrDefault("storageSyncServiceName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "storageSyncServiceName", valid_564276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564277 = query.getOrDefault("api-version")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "api-version", valid_564277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564278: Call_SyncGroupsListByStorageSyncService_564271;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a SyncGroup List.
  ## 
  let valid = call_564278.validator(path, query, header, formData, body)
  let scheme = call_564278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564278.url(scheme.get, call_564278.host, call_564278.base,
                         call_564278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564278, url, valid)

proc call*(call_564279: Call_SyncGroupsListByStorageSyncService_564271;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## syncGroupsListByStorageSyncService
  ## Get a SyncGroup List.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564280 = newJObject()
  var query_564281 = newJObject()
  add(query_564281, "api-version", newJString(apiVersion))
  add(path_564280, "subscriptionId", newJString(subscriptionId))
  add(path_564280, "resourceGroupName", newJString(resourceGroupName))
  add(path_564280, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564279.call(path_564280, query_564281, nil, nil, nil)

var syncGroupsListByStorageSyncService* = Call_SyncGroupsListByStorageSyncService_564271(
    name: "syncGroupsListByStorageSyncService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups",
    validator: validate_SyncGroupsListByStorageSyncService_564272, base: "",
    url: url_SyncGroupsListByStorageSyncService_564273, schemes: {Scheme.Https})
type
  Call_SyncGroupsCreate_564294 = ref object of OpenApiRestCall_563565
proc url_SyncGroupsCreate_564296(protocol: Scheme; host: string; base: string;
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

proc validate_SyncGroupsCreate_564295(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Create a new SyncGroup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564297 = path.getOrDefault("syncGroupName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "syncGroupName", valid_564297
  var valid_564298 = path.getOrDefault("subscriptionId")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "subscriptionId", valid_564298
  var valid_564299 = path.getOrDefault("resourceGroupName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "resourceGroupName", valid_564299
  var valid_564300 = path.getOrDefault("storageSyncServiceName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "storageSyncServiceName", valid_564300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564301 = query.getOrDefault("api-version")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "api-version", valid_564301
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

proc call*(call_564303: Call_SyncGroupsCreate_564294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new SyncGroup.
  ## 
  let valid = call_564303.validator(path, query, header, formData, body)
  let scheme = call_564303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564303.url(scheme.get, call_564303.host, call_564303.base,
                         call_564303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564303, url, valid)

proc call*(call_564304: Call_SyncGroupsCreate_564294; syncGroupName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string; parameters: JsonNode): Recallable =
  ## syncGroupsCreate
  ## Create a new SyncGroup.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Sync Group Body
  var path_564305 = newJObject()
  var query_564306 = newJObject()
  var body_564307 = newJObject()
  add(path_564305, "syncGroupName", newJString(syncGroupName))
  add(query_564306, "api-version", newJString(apiVersion))
  add(path_564305, "subscriptionId", newJString(subscriptionId))
  add(path_564305, "resourceGroupName", newJString(resourceGroupName))
  add(path_564305, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564307 = parameters
  result = call_564304.call(path_564305, query_564306, nil, nil, body_564307)

var syncGroupsCreate* = Call_SyncGroupsCreate_564294(name: "syncGroupsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}",
    validator: validate_SyncGroupsCreate_564295, base: "",
    url: url_SyncGroupsCreate_564296, schemes: {Scheme.Https})
type
  Call_SyncGroupsGet_564282 = ref object of OpenApiRestCall_563565
proc url_SyncGroupsGet_564284(protocol: Scheme; host: string; base: string;
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

proc validate_SyncGroupsGet_564283(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a given SyncGroup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564285 = path.getOrDefault("syncGroupName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "syncGroupName", valid_564285
  var valid_564286 = path.getOrDefault("subscriptionId")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "subscriptionId", valid_564286
  var valid_564287 = path.getOrDefault("resourceGroupName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "resourceGroupName", valid_564287
  var valid_564288 = path.getOrDefault("storageSyncServiceName")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "storageSyncServiceName", valid_564288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564289 = query.getOrDefault("api-version")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "api-version", valid_564289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564290: Call_SyncGroupsGet_564282; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a given SyncGroup.
  ## 
  let valid = call_564290.validator(path, query, header, formData, body)
  let scheme = call_564290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564290.url(scheme.get, call_564290.host, call_564290.base,
                         call_564290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564290, url, valid)

proc call*(call_564291: Call_SyncGroupsGet_564282; syncGroupName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## syncGroupsGet
  ## Get a given SyncGroup.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564292 = newJObject()
  var query_564293 = newJObject()
  add(path_564292, "syncGroupName", newJString(syncGroupName))
  add(query_564293, "api-version", newJString(apiVersion))
  add(path_564292, "subscriptionId", newJString(subscriptionId))
  add(path_564292, "resourceGroupName", newJString(resourceGroupName))
  add(path_564292, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564291.call(path_564292, query_564293, nil, nil, nil)

var syncGroupsGet* = Call_SyncGroupsGet_564282(name: "syncGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}",
    validator: validate_SyncGroupsGet_564283, base: "", url: url_SyncGroupsGet_564284,
    schemes: {Scheme.Https})
type
  Call_SyncGroupsDelete_564308 = ref object of OpenApiRestCall_563565
proc url_SyncGroupsDelete_564310(protocol: Scheme; host: string; base: string;
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

proc validate_SyncGroupsDelete_564309(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Delete a given SyncGroup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564311 = path.getOrDefault("syncGroupName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "syncGroupName", valid_564311
  var valid_564312 = path.getOrDefault("subscriptionId")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "subscriptionId", valid_564312
  var valid_564313 = path.getOrDefault("resourceGroupName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "resourceGroupName", valid_564313
  var valid_564314 = path.getOrDefault("storageSyncServiceName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "storageSyncServiceName", valid_564314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564315 = query.getOrDefault("api-version")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "api-version", valid_564315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564316: Call_SyncGroupsDelete_564308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a given SyncGroup.
  ## 
  let valid = call_564316.validator(path, query, header, formData, body)
  let scheme = call_564316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564316.url(scheme.get, call_564316.host, call_564316.base,
                         call_564316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564316, url, valid)

proc call*(call_564317: Call_SyncGroupsDelete_564308; syncGroupName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## syncGroupsDelete
  ## Delete a given SyncGroup.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564318 = newJObject()
  var query_564319 = newJObject()
  add(path_564318, "syncGroupName", newJString(syncGroupName))
  add(query_564319, "api-version", newJString(apiVersion))
  add(path_564318, "subscriptionId", newJString(subscriptionId))
  add(path_564318, "resourceGroupName", newJString(resourceGroupName))
  add(path_564318, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564317.call(path_564318, query_564319, nil, nil, nil)

var syncGroupsDelete* = Call_SyncGroupsDelete_564308(name: "syncGroupsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}",
    validator: validate_SyncGroupsDelete_564309, base: "",
    url: url_SyncGroupsDelete_564310, schemes: {Scheme.Https})
type
  Call_CloudEndpointsListBySyncGroup_564320 = ref object of OpenApiRestCall_563565
proc url_CloudEndpointsListBySyncGroup_564322(protocol: Scheme; host: string;
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

proc validate_CloudEndpointsListBySyncGroup_564321(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a CloudEndpoint List.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564323 = path.getOrDefault("syncGroupName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "syncGroupName", valid_564323
  var valid_564324 = path.getOrDefault("subscriptionId")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "subscriptionId", valid_564324
  var valid_564325 = path.getOrDefault("resourceGroupName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "resourceGroupName", valid_564325
  var valid_564326 = path.getOrDefault("storageSyncServiceName")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "storageSyncServiceName", valid_564326
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564327 = query.getOrDefault("api-version")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "api-version", valid_564327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564328: Call_CloudEndpointsListBySyncGroup_564320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a CloudEndpoint List.
  ## 
  let valid = call_564328.validator(path, query, header, formData, body)
  let scheme = call_564328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564328.url(scheme.get, call_564328.host, call_564328.base,
                         call_564328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564328, url, valid)

proc call*(call_564329: Call_CloudEndpointsListBySyncGroup_564320;
          syncGroupName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string): Recallable =
  ## cloudEndpointsListBySyncGroup
  ## Get a CloudEndpoint List.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564330 = newJObject()
  var query_564331 = newJObject()
  add(path_564330, "syncGroupName", newJString(syncGroupName))
  add(query_564331, "api-version", newJString(apiVersion))
  add(path_564330, "subscriptionId", newJString(subscriptionId))
  add(path_564330, "resourceGroupName", newJString(resourceGroupName))
  add(path_564330, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564329.call(path_564330, query_564331, nil, nil, nil)

var cloudEndpointsListBySyncGroup* = Call_CloudEndpointsListBySyncGroup_564320(
    name: "cloudEndpointsListBySyncGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints",
    validator: validate_CloudEndpointsListBySyncGroup_564321, base: "",
    url: url_CloudEndpointsListBySyncGroup_564322, schemes: {Scheme.Https})
type
  Call_CloudEndpointsCreate_564345 = ref object of OpenApiRestCall_563565
proc url_CloudEndpointsCreate_564347(protocol: Scheme; host: string; base: string;
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

proc validate_CloudEndpointsCreate_564346(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new CloudEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: JString (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564348 = path.getOrDefault("syncGroupName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "syncGroupName", valid_564348
  var valid_564349 = path.getOrDefault("cloudEndpointName")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "cloudEndpointName", valid_564349
  var valid_564350 = path.getOrDefault("subscriptionId")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "subscriptionId", valid_564350
  var valid_564351 = path.getOrDefault("resourceGroupName")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "resourceGroupName", valid_564351
  var valid_564352 = path.getOrDefault("storageSyncServiceName")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "storageSyncServiceName", valid_564352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564353 = query.getOrDefault("api-version")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "api-version", valid_564353
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

proc call*(call_564355: Call_CloudEndpointsCreate_564345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new CloudEndpoint.
  ## 
  let valid = call_564355.validator(path, query, header, formData, body)
  let scheme = call_564355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564355.url(scheme.get, call_564355.host, call_564355.base,
                         call_564355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564355, url, valid)

proc call*(call_564356: Call_CloudEndpointsCreate_564345; syncGroupName: string;
          apiVersion: string; cloudEndpointName: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string;
          parameters: JsonNode): Recallable =
  ## cloudEndpointsCreate
  ## Create a new CloudEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Body of Cloud Endpoint resource.
  var path_564357 = newJObject()
  var query_564358 = newJObject()
  var body_564359 = newJObject()
  add(path_564357, "syncGroupName", newJString(syncGroupName))
  add(query_564358, "api-version", newJString(apiVersion))
  add(path_564357, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_564357, "subscriptionId", newJString(subscriptionId))
  add(path_564357, "resourceGroupName", newJString(resourceGroupName))
  add(path_564357, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564359 = parameters
  result = call_564356.call(path_564357, query_564358, nil, nil, body_564359)

var cloudEndpointsCreate* = Call_CloudEndpointsCreate_564345(
    name: "cloudEndpointsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}",
    validator: validate_CloudEndpointsCreate_564346, base: "",
    url: url_CloudEndpointsCreate_564347, schemes: {Scheme.Https})
type
  Call_CloudEndpointsGet_564332 = ref object of OpenApiRestCall_563565
proc url_CloudEndpointsGet_564334(protocol: Scheme; host: string; base: string;
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

proc validate_CloudEndpointsGet_564333(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get a given CloudEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: JString (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564335 = path.getOrDefault("syncGroupName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "syncGroupName", valid_564335
  var valid_564336 = path.getOrDefault("cloudEndpointName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "cloudEndpointName", valid_564336
  var valid_564337 = path.getOrDefault("subscriptionId")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "subscriptionId", valid_564337
  var valid_564338 = path.getOrDefault("resourceGroupName")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "resourceGroupName", valid_564338
  var valid_564339 = path.getOrDefault("storageSyncServiceName")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "storageSyncServiceName", valid_564339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564340 = query.getOrDefault("api-version")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "api-version", valid_564340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564341: Call_CloudEndpointsGet_564332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a given CloudEndpoint.
  ## 
  let valid = call_564341.validator(path, query, header, formData, body)
  let scheme = call_564341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564341.url(scheme.get, call_564341.host, call_564341.base,
                         call_564341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564341, url, valid)

proc call*(call_564342: Call_CloudEndpointsGet_564332; syncGroupName: string;
          apiVersion: string; cloudEndpointName: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string): Recallable =
  ## cloudEndpointsGet
  ## Get a given CloudEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564343 = newJObject()
  var query_564344 = newJObject()
  add(path_564343, "syncGroupName", newJString(syncGroupName))
  add(query_564344, "api-version", newJString(apiVersion))
  add(path_564343, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_564343, "subscriptionId", newJString(subscriptionId))
  add(path_564343, "resourceGroupName", newJString(resourceGroupName))
  add(path_564343, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564342.call(path_564343, query_564344, nil, nil, nil)

var cloudEndpointsGet* = Call_CloudEndpointsGet_564332(name: "cloudEndpointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}",
    validator: validate_CloudEndpointsGet_564333, base: "",
    url: url_CloudEndpointsGet_564334, schemes: {Scheme.Https})
type
  Call_CloudEndpointsDelete_564360 = ref object of OpenApiRestCall_563565
proc url_CloudEndpointsDelete_564362(protocol: Scheme; host: string; base: string;
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

proc validate_CloudEndpointsDelete_564361(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a given CloudEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: JString (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564363 = path.getOrDefault("syncGroupName")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "syncGroupName", valid_564363
  var valid_564364 = path.getOrDefault("cloudEndpointName")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "cloudEndpointName", valid_564364
  var valid_564365 = path.getOrDefault("subscriptionId")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "subscriptionId", valid_564365
  var valid_564366 = path.getOrDefault("resourceGroupName")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "resourceGroupName", valid_564366
  var valid_564367 = path.getOrDefault("storageSyncServiceName")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "storageSyncServiceName", valid_564367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564368 = query.getOrDefault("api-version")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "api-version", valid_564368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564369: Call_CloudEndpointsDelete_564360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a given CloudEndpoint.
  ## 
  let valid = call_564369.validator(path, query, header, formData, body)
  let scheme = call_564369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564369.url(scheme.get, call_564369.host, call_564369.base,
                         call_564369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564369, url, valid)

proc call*(call_564370: Call_CloudEndpointsDelete_564360; syncGroupName: string;
          apiVersion: string; cloudEndpointName: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string): Recallable =
  ## cloudEndpointsDelete
  ## Delete a given CloudEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564371 = newJObject()
  var query_564372 = newJObject()
  add(path_564371, "syncGroupName", newJString(syncGroupName))
  add(query_564372, "api-version", newJString(apiVersion))
  add(path_564371, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_564371, "subscriptionId", newJString(subscriptionId))
  add(path_564371, "resourceGroupName", newJString(resourceGroupName))
  add(path_564371, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564370.call(path_564371, query_564372, nil, nil, nil)

var cloudEndpointsDelete* = Call_CloudEndpointsDelete_564360(
    name: "cloudEndpointsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}",
    validator: validate_CloudEndpointsDelete_564361, base: "",
    url: url_CloudEndpointsDelete_564362, schemes: {Scheme.Https})
type
  Call_CloudEndpointsPostBackup_564373 = ref object of OpenApiRestCall_563565
proc url_CloudEndpointsPostBackup_564375(protocol: Scheme; host: string;
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

proc validate_CloudEndpointsPostBackup_564374(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Post Backup a given CloudEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: JString (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564376 = path.getOrDefault("syncGroupName")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "syncGroupName", valid_564376
  var valid_564377 = path.getOrDefault("cloudEndpointName")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "cloudEndpointName", valid_564377
  var valid_564378 = path.getOrDefault("subscriptionId")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "subscriptionId", valid_564378
  var valid_564379 = path.getOrDefault("resourceGroupName")
  valid_564379 = validateParameter(valid_564379, JString, required = true,
                                 default = nil)
  if valid_564379 != nil:
    section.add "resourceGroupName", valid_564379
  var valid_564380 = path.getOrDefault("storageSyncServiceName")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "storageSyncServiceName", valid_564380
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564381 = query.getOrDefault("api-version")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "api-version", valid_564381
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

proc call*(call_564383: Call_CloudEndpointsPostBackup_564373; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Post Backup a given CloudEndpoint.
  ## 
  let valid = call_564383.validator(path, query, header, formData, body)
  let scheme = call_564383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564383.url(scheme.get, call_564383.host, call_564383.base,
                         call_564383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564383, url, valid)

proc call*(call_564384: Call_CloudEndpointsPostBackup_564373;
          syncGroupName: string; apiVersion: string; cloudEndpointName: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string; parameters: JsonNode): Recallable =
  ## cloudEndpointsPostBackup
  ## Post Backup a given CloudEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Body of Backup request.
  var path_564385 = newJObject()
  var query_564386 = newJObject()
  var body_564387 = newJObject()
  add(path_564385, "syncGroupName", newJString(syncGroupName))
  add(query_564386, "api-version", newJString(apiVersion))
  add(path_564385, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_564385, "subscriptionId", newJString(subscriptionId))
  add(path_564385, "resourceGroupName", newJString(resourceGroupName))
  add(path_564385, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564387 = parameters
  result = call_564384.call(path_564385, query_564386, nil, nil, body_564387)

var cloudEndpointsPostBackup* = Call_CloudEndpointsPostBackup_564373(
    name: "cloudEndpointsPostBackup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/postbackup",
    validator: validate_CloudEndpointsPostBackup_564374, base: "",
    url: url_CloudEndpointsPostBackup_564375, schemes: {Scheme.Https})
type
  Call_CloudEndpointsPostRestore_564388 = ref object of OpenApiRestCall_563565
proc url_CloudEndpointsPostRestore_564390(protocol: Scheme; host: string;
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

proc validate_CloudEndpointsPostRestore_564389(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Post Restore a given CloudEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: JString (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564391 = path.getOrDefault("syncGroupName")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "syncGroupName", valid_564391
  var valid_564392 = path.getOrDefault("cloudEndpointName")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "cloudEndpointName", valid_564392
  var valid_564393 = path.getOrDefault("subscriptionId")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "subscriptionId", valid_564393
  var valid_564394 = path.getOrDefault("resourceGroupName")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "resourceGroupName", valid_564394
  var valid_564395 = path.getOrDefault("storageSyncServiceName")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "storageSyncServiceName", valid_564395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564396 = query.getOrDefault("api-version")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "api-version", valid_564396
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

proc call*(call_564398: Call_CloudEndpointsPostRestore_564388; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Post Restore a given CloudEndpoint.
  ## 
  let valid = call_564398.validator(path, query, header, formData, body)
  let scheme = call_564398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564398.url(scheme.get, call_564398.host, call_564398.base,
                         call_564398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564398, url, valid)

proc call*(call_564399: Call_CloudEndpointsPostRestore_564388;
          syncGroupName: string; apiVersion: string; cloudEndpointName: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string; parameters: JsonNode): Recallable =
  ## cloudEndpointsPostRestore
  ## Post Restore a given CloudEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Body of Cloud Endpoint object.
  var path_564400 = newJObject()
  var query_564401 = newJObject()
  var body_564402 = newJObject()
  add(path_564400, "syncGroupName", newJString(syncGroupName))
  add(query_564401, "api-version", newJString(apiVersion))
  add(path_564400, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_564400, "subscriptionId", newJString(subscriptionId))
  add(path_564400, "resourceGroupName", newJString(resourceGroupName))
  add(path_564400, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564402 = parameters
  result = call_564399.call(path_564400, query_564401, nil, nil, body_564402)

var cloudEndpointsPostRestore* = Call_CloudEndpointsPostRestore_564388(
    name: "cloudEndpointsPostRestore", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/postrestore",
    validator: validate_CloudEndpointsPostRestore_564389, base: "",
    url: url_CloudEndpointsPostRestore_564390, schemes: {Scheme.Https})
type
  Call_CloudEndpointsPreBackup_564403 = ref object of OpenApiRestCall_563565
proc url_CloudEndpointsPreBackup_564405(protocol: Scheme; host: string; base: string;
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

proc validate_CloudEndpointsPreBackup_564404(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pre Backup a given CloudEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: JString (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564406 = path.getOrDefault("syncGroupName")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "syncGroupName", valid_564406
  var valid_564407 = path.getOrDefault("cloudEndpointName")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "cloudEndpointName", valid_564407
  var valid_564408 = path.getOrDefault("subscriptionId")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "subscriptionId", valid_564408
  var valid_564409 = path.getOrDefault("resourceGroupName")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "resourceGroupName", valid_564409
  var valid_564410 = path.getOrDefault("storageSyncServiceName")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "storageSyncServiceName", valid_564410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564411 = query.getOrDefault("api-version")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "api-version", valid_564411
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

proc call*(call_564413: Call_CloudEndpointsPreBackup_564403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pre Backup a given CloudEndpoint.
  ## 
  let valid = call_564413.validator(path, query, header, formData, body)
  let scheme = call_564413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564413.url(scheme.get, call_564413.host, call_564413.base,
                         call_564413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564413, url, valid)

proc call*(call_564414: Call_CloudEndpointsPreBackup_564403; syncGroupName: string;
          apiVersion: string; cloudEndpointName: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string;
          parameters: JsonNode): Recallable =
  ## cloudEndpointsPreBackup
  ## Pre Backup a given CloudEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Body of Backup request.
  var path_564415 = newJObject()
  var query_564416 = newJObject()
  var body_564417 = newJObject()
  add(path_564415, "syncGroupName", newJString(syncGroupName))
  add(query_564416, "api-version", newJString(apiVersion))
  add(path_564415, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_564415, "subscriptionId", newJString(subscriptionId))
  add(path_564415, "resourceGroupName", newJString(resourceGroupName))
  add(path_564415, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564417 = parameters
  result = call_564414.call(path_564415, query_564416, nil, nil, body_564417)

var cloudEndpointsPreBackup* = Call_CloudEndpointsPreBackup_564403(
    name: "cloudEndpointsPreBackup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/prebackup",
    validator: validate_CloudEndpointsPreBackup_564404, base: "",
    url: url_CloudEndpointsPreBackup_564405, schemes: {Scheme.Https})
type
  Call_CloudEndpointsPreRestore_564418 = ref object of OpenApiRestCall_563565
proc url_CloudEndpointsPreRestore_564420(protocol: Scheme; host: string;
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

proc validate_CloudEndpointsPreRestore_564419(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pre Restore a given CloudEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: JString (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564421 = path.getOrDefault("syncGroupName")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "syncGroupName", valid_564421
  var valid_564422 = path.getOrDefault("cloudEndpointName")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "cloudEndpointName", valid_564422
  var valid_564423 = path.getOrDefault("subscriptionId")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "subscriptionId", valid_564423
  var valid_564424 = path.getOrDefault("resourceGroupName")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "resourceGroupName", valid_564424
  var valid_564425 = path.getOrDefault("storageSyncServiceName")
  valid_564425 = validateParameter(valid_564425, JString, required = true,
                                 default = nil)
  if valid_564425 != nil:
    section.add "storageSyncServiceName", valid_564425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564426 = query.getOrDefault("api-version")
  valid_564426 = validateParameter(valid_564426, JString, required = true,
                                 default = nil)
  if valid_564426 != nil:
    section.add "api-version", valid_564426
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

proc call*(call_564428: Call_CloudEndpointsPreRestore_564418; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pre Restore a given CloudEndpoint.
  ## 
  let valid = call_564428.validator(path, query, header, formData, body)
  let scheme = call_564428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564428.url(scheme.get, call_564428.host, call_564428.base,
                         call_564428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564428, url, valid)

proc call*(call_564429: Call_CloudEndpointsPreRestore_564418;
          syncGroupName: string; apiVersion: string; cloudEndpointName: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string; parameters: JsonNode): Recallable =
  ## cloudEndpointsPreRestore
  ## Pre Restore a given CloudEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Body of Cloud Endpoint object.
  var path_564430 = newJObject()
  var query_564431 = newJObject()
  var body_564432 = newJObject()
  add(path_564430, "syncGroupName", newJString(syncGroupName))
  add(query_564431, "api-version", newJString(apiVersion))
  add(path_564430, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_564430, "subscriptionId", newJString(subscriptionId))
  add(path_564430, "resourceGroupName", newJString(resourceGroupName))
  add(path_564430, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564432 = parameters
  result = call_564429.call(path_564430, query_564431, nil, nil, body_564432)

var cloudEndpointsPreRestore* = Call_CloudEndpointsPreRestore_564418(
    name: "cloudEndpointsPreRestore", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/prerestore",
    validator: validate_CloudEndpointsPreRestore_564419, base: "",
    url: url_CloudEndpointsPreRestore_564420, schemes: {Scheme.Https})
type
  Call_CloudEndpointsRestoreheartbeat_564433 = ref object of OpenApiRestCall_563565
proc url_CloudEndpointsRestoreheartbeat_564435(protocol: Scheme; host: string;
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

proc validate_CloudEndpointsRestoreheartbeat_564434(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restore Heartbeat a given CloudEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: JString (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564436 = path.getOrDefault("syncGroupName")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "syncGroupName", valid_564436
  var valid_564437 = path.getOrDefault("cloudEndpointName")
  valid_564437 = validateParameter(valid_564437, JString, required = true,
                                 default = nil)
  if valid_564437 != nil:
    section.add "cloudEndpointName", valid_564437
  var valid_564438 = path.getOrDefault("subscriptionId")
  valid_564438 = validateParameter(valid_564438, JString, required = true,
                                 default = nil)
  if valid_564438 != nil:
    section.add "subscriptionId", valid_564438
  var valid_564439 = path.getOrDefault("resourceGroupName")
  valid_564439 = validateParameter(valid_564439, JString, required = true,
                                 default = nil)
  if valid_564439 != nil:
    section.add "resourceGroupName", valid_564439
  var valid_564440 = path.getOrDefault("storageSyncServiceName")
  valid_564440 = validateParameter(valid_564440, JString, required = true,
                                 default = nil)
  if valid_564440 != nil:
    section.add "storageSyncServiceName", valid_564440
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564441 = query.getOrDefault("api-version")
  valid_564441 = validateParameter(valid_564441, JString, required = true,
                                 default = nil)
  if valid_564441 != nil:
    section.add "api-version", valid_564441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564442: Call_CloudEndpointsRestoreheartbeat_564433; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restore Heartbeat a given CloudEndpoint.
  ## 
  let valid = call_564442.validator(path, query, header, formData, body)
  let scheme = call_564442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564442.url(scheme.get, call_564442.host, call_564442.base,
                         call_564442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564442, url, valid)

proc call*(call_564443: Call_CloudEndpointsRestoreheartbeat_564433;
          syncGroupName: string; apiVersion: string; cloudEndpointName: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## cloudEndpointsRestoreheartbeat
  ## Restore Heartbeat a given CloudEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564444 = newJObject()
  var query_564445 = newJObject()
  add(path_564444, "syncGroupName", newJString(syncGroupName))
  add(query_564445, "api-version", newJString(apiVersion))
  add(path_564444, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_564444, "subscriptionId", newJString(subscriptionId))
  add(path_564444, "resourceGroupName", newJString(resourceGroupName))
  add(path_564444, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564443.call(path_564444, query_564445, nil, nil, nil)

var cloudEndpointsRestoreheartbeat* = Call_CloudEndpointsRestoreheartbeat_564433(
    name: "cloudEndpointsRestoreheartbeat", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/restoreheartbeat",
    validator: validate_CloudEndpointsRestoreheartbeat_564434, base: "",
    url: url_CloudEndpointsRestoreheartbeat_564435, schemes: {Scheme.Https})
type
  Call_CloudEndpointsTriggerChangeDetection_564446 = ref object of OpenApiRestCall_563565
proc url_CloudEndpointsTriggerChangeDetection_564448(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/triggerChangeDetection")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudEndpointsTriggerChangeDetection_564447(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Triggers detection of changes performed on Azure File share connected to the specified Azure File Sync Cloud Endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   cloudEndpointName: JString (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564449 = path.getOrDefault("syncGroupName")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "syncGroupName", valid_564449
  var valid_564450 = path.getOrDefault("cloudEndpointName")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "cloudEndpointName", valid_564450
  var valid_564451 = path.getOrDefault("subscriptionId")
  valid_564451 = validateParameter(valid_564451, JString, required = true,
                                 default = nil)
  if valid_564451 != nil:
    section.add "subscriptionId", valid_564451
  var valid_564452 = path.getOrDefault("resourceGroupName")
  valid_564452 = validateParameter(valid_564452, JString, required = true,
                                 default = nil)
  if valid_564452 != nil:
    section.add "resourceGroupName", valid_564452
  var valid_564453 = path.getOrDefault("storageSyncServiceName")
  valid_564453 = validateParameter(valid_564453, JString, required = true,
                                 default = nil)
  if valid_564453 != nil:
    section.add "storageSyncServiceName", valid_564453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564454 = query.getOrDefault("api-version")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "api-version", valid_564454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Trigger Change Detection Action parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564456: Call_CloudEndpointsTriggerChangeDetection_564446;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Triggers detection of changes performed on Azure File share connected to the specified Azure File Sync Cloud Endpoint.
  ## 
  let valid = call_564456.validator(path, query, header, formData, body)
  let scheme = call_564456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564456.url(scheme.get, call_564456.host, call_564456.base,
                         call_564456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564456, url, valid)

proc call*(call_564457: Call_CloudEndpointsTriggerChangeDetection_564446;
          syncGroupName: string; apiVersion: string; cloudEndpointName: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string; parameters: JsonNode): Recallable =
  ## cloudEndpointsTriggerChangeDetection
  ## Triggers detection of changes performed on Azure File share connected to the specified Azure File Sync Cloud Endpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Trigger Change Detection Action parameters.
  var path_564458 = newJObject()
  var query_564459 = newJObject()
  var body_564460 = newJObject()
  add(path_564458, "syncGroupName", newJString(syncGroupName))
  add(query_564459, "api-version", newJString(apiVersion))
  add(path_564458, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_564458, "subscriptionId", newJString(subscriptionId))
  add(path_564458, "resourceGroupName", newJString(resourceGroupName))
  add(path_564458, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564460 = parameters
  result = call_564457.call(path_564458, query_564459, nil, nil, body_564460)

var cloudEndpointsTriggerChangeDetection* = Call_CloudEndpointsTriggerChangeDetection_564446(
    name: "cloudEndpointsTriggerChangeDetection", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/triggerChangeDetection",
    validator: validate_CloudEndpointsTriggerChangeDetection_564447, base: "",
    url: url_CloudEndpointsTriggerChangeDetection_564448, schemes: {Scheme.Https})
type
  Call_ServerEndpointsListBySyncGroup_564461 = ref object of OpenApiRestCall_563565
proc url_ServerEndpointsListBySyncGroup_564463(protocol: Scheme; host: string;
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

proc validate_ServerEndpointsListBySyncGroup_564462(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a ServerEndpoint list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564464 = path.getOrDefault("syncGroupName")
  valid_564464 = validateParameter(valid_564464, JString, required = true,
                                 default = nil)
  if valid_564464 != nil:
    section.add "syncGroupName", valid_564464
  var valid_564465 = path.getOrDefault("subscriptionId")
  valid_564465 = validateParameter(valid_564465, JString, required = true,
                                 default = nil)
  if valid_564465 != nil:
    section.add "subscriptionId", valid_564465
  var valid_564466 = path.getOrDefault("resourceGroupName")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "resourceGroupName", valid_564466
  var valid_564467 = path.getOrDefault("storageSyncServiceName")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "storageSyncServiceName", valid_564467
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564468 = query.getOrDefault("api-version")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "api-version", valid_564468
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564469: Call_ServerEndpointsListBySyncGroup_564461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a ServerEndpoint list.
  ## 
  let valid = call_564469.validator(path, query, header, formData, body)
  let scheme = call_564469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564469.url(scheme.get, call_564469.host, call_564469.base,
                         call_564469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564469, url, valid)

proc call*(call_564470: Call_ServerEndpointsListBySyncGroup_564461;
          syncGroupName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string): Recallable =
  ## serverEndpointsListBySyncGroup
  ## Get a ServerEndpoint list.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564471 = newJObject()
  var query_564472 = newJObject()
  add(path_564471, "syncGroupName", newJString(syncGroupName))
  add(query_564472, "api-version", newJString(apiVersion))
  add(path_564471, "subscriptionId", newJString(subscriptionId))
  add(path_564471, "resourceGroupName", newJString(resourceGroupName))
  add(path_564471, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564470.call(path_564471, query_564472, nil, nil, nil)

var serverEndpointsListBySyncGroup* = Call_ServerEndpointsListBySyncGroup_564461(
    name: "serverEndpointsListBySyncGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints",
    validator: validate_ServerEndpointsListBySyncGroup_564462, base: "",
    url: url_ServerEndpointsListBySyncGroup_564463, schemes: {Scheme.Https})
type
  Call_ServerEndpointsCreate_564486 = ref object of OpenApiRestCall_563565
proc url_ServerEndpointsCreate_564488(protocol: Scheme; host: string; base: string;
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

proc validate_ServerEndpointsCreate_564487(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new ServerEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   serverEndpointName: JString (required)
  ##                     : Name of Server Endpoint object.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564489 = path.getOrDefault("syncGroupName")
  valid_564489 = validateParameter(valid_564489, JString, required = true,
                                 default = nil)
  if valid_564489 != nil:
    section.add "syncGroupName", valid_564489
  var valid_564490 = path.getOrDefault("serverEndpointName")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "serverEndpointName", valid_564490
  var valid_564491 = path.getOrDefault("subscriptionId")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "subscriptionId", valid_564491
  var valid_564492 = path.getOrDefault("resourceGroupName")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "resourceGroupName", valid_564492
  var valid_564493 = path.getOrDefault("storageSyncServiceName")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "storageSyncServiceName", valid_564493
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564494 = query.getOrDefault("api-version")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = nil)
  if valid_564494 != nil:
    section.add "api-version", valid_564494
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

proc call*(call_564496: Call_ServerEndpointsCreate_564486; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new ServerEndpoint.
  ## 
  let valid = call_564496.validator(path, query, header, formData, body)
  let scheme = call_564496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564496.url(scheme.get, call_564496.host, call_564496.base,
                         call_564496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564496, url, valid)

proc call*(call_564497: Call_ServerEndpointsCreate_564486; syncGroupName: string;
          apiVersion: string; serverEndpointName: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string;
          parameters: JsonNode): Recallable =
  ## serverEndpointsCreate
  ## Create a new ServerEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   serverEndpointName: string (required)
  ##                     : Name of Server Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Body of Server Endpoint object.
  var path_564498 = newJObject()
  var query_564499 = newJObject()
  var body_564500 = newJObject()
  add(path_564498, "syncGroupName", newJString(syncGroupName))
  add(query_564499, "api-version", newJString(apiVersion))
  add(path_564498, "serverEndpointName", newJString(serverEndpointName))
  add(path_564498, "subscriptionId", newJString(subscriptionId))
  add(path_564498, "resourceGroupName", newJString(resourceGroupName))
  add(path_564498, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564500 = parameters
  result = call_564497.call(path_564498, query_564499, nil, nil, body_564500)

var serverEndpointsCreate* = Call_ServerEndpointsCreate_564486(
    name: "serverEndpointsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}",
    validator: validate_ServerEndpointsCreate_564487, base: "",
    url: url_ServerEndpointsCreate_564488, schemes: {Scheme.Https})
type
  Call_ServerEndpointsGet_564473 = ref object of OpenApiRestCall_563565
proc url_ServerEndpointsGet_564475(protocol: Scheme; host: string; base: string;
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

proc validate_ServerEndpointsGet_564474(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get a ServerEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   serverEndpointName: JString (required)
  ##                     : Name of Server Endpoint object.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564476 = path.getOrDefault("syncGroupName")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = nil)
  if valid_564476 != nil:
    section.add "syncGroupName", valid_564476
  var valid_564477 = path.getOrDefault("serverEndpointName")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "serverEndpointName", valid_564477
  var valid_564478 = path.getOrDefault("subscriptionId")
  valid_564478 = validateParameter(valid_564478, JString, required = true,
                                 default = nil)
  if valid_564478 != nil:
    section.add "subscriptionId", valid_564478
  var valid_564479 = path.getOrDefault("resourceGroupName")
  valid_564479 = validateParameter(valid_564479, JString, required = true,
                                 default = nil)
  if valid_564479 != nil:
    section.add "resourceGroupName", valid_564479
  var valid_564480 = path.getOrDefault("storageSyncServiceName")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "storageSyncServiceName", valid_564480
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564481 = query.getOrDefault("api-version")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "api-version", valid_564481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564482: Call_ServerEndpointsGet_564473; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a ServerEndpoint.
  ## 
  let valid = call_564482.validator(path, query, header, formData, body)
  let scheme = call_564482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564482.url(scheme.get, call_564482.host, call_564482.base,
                         call_564482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564482, url, valid)

proc call*(call_564483: Call_ServerEndpointsGet_564473; syncGroupName: string;
          apiVersion: string; serverEndpointName: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string): Recallable =
  ## serverEndpointsGet
  ## Get a ServerEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   serverEndpointName: string (required)
  ##                     : Name of Server Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564484 = newJObject()
  var query_564485 = newJObject()
  add(path_564484, "syncGroupName", newJString(syncGroupName))
  add(query_564485, "api-version", newJString(apiVersion))
  add(path_564484, "serverEndpointName", newJString(serverEndpointName))
  add(path_564484, "subscriptionId", newJString(subscriptionId))
  add(path_564484, "resourceGroupName", newJString(resourceGroupName))
  add(path_564484, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564483.call(path_564484, query_564485, nil, nil, nil)

var serverEndpointsGet* = Call_ServerEndpointsGet_564473(
    name: "serverEndpointsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}",
    validator: validate_ServerEndpointsGet_564474, base: "",
    url: url_ServerEndpointsGet_564475, schemes: {Scheme.Https})
type
  Call_ServerEndpointsUpdate_564514 = ref object of OpenApiRestCall_563565
proc url_ServerEndpointsUpdate_564516(protocol: Scheme; host: string; base: string;
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

proc validate_ServerEndpointsUpdate_564515(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch a given ServerEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   serverEndpointName: JString (required)
  ##                     : Name of Server Endpoint object.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564517 = path.getOrDefault("syncGroupName")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "syncGroupName", valid_564517
  var valid_564518 = path.getOrDefault("serverEndpointName")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "serverEndpointName", valid_564518
  var valid_564519 = path.getOrDefault("subscriptionId")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "subscriptionId", valid_564519
  var valid_564520 = path.getOrDefault("resourceGroupName")
  valid_564520 = validateParameter(valid_564520, JString, required = true,
                                 default = nil)
  if valid_564520 != nil:
    section.add "resourceGroupName", valid_564520
  var valid_564521 = path.getOrDefault("storageSyncServiceName")
  valid_564521 = validateParameter(valid_564521, JString, required = true,
                                 default = nil)
  if valid_564521 != nil:
    section.add "storageSyncServiceName", valid_564521
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564522 = query.getOrDefault("api-version")
  valid_564522 = validateParameter(valid_564522, JString, required = true,
                                 default = nil)
  if valid_564522 != nil:
    section.add "api-version", valid_564522
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

proc call*(call_564524: Call_ServerEndpointsUpdate_564514; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a given ServerEndpoint.
  ## 
  let valid = call_564524.validator(path, query, header, formData, body)
  let scheme = call_564524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564524.url(scheme.get, call_564524.host, call_564524.base,
                         call_564524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564524, url, valid)

proc call*(call_564525: Call_ServerEndpointsUpdate_564514; syncGroupName: string;
          apiVersion: string; serverEndpointName: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string;
          parameters: JsonNode = nil): Recallable =
  ## serverEndpointsUpdate
  ## Patch a given ServerEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   serverEndpointName: string (required)
  ##                     : Name of Server Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject
  ##             : Any of the properties applicable in PUT request.
  var path_564526 = newJObject()
  var query_564527 = newJObject()
  var body_564528 = newJObject()
  add(path_564526, "syncGroupName", newJString(syncGroupName))
  add(query_564527, "api-version", newJString(apiVersion))
  add(path_564526, "serverEndpointName", newJString(serverEndpointName))
  add(path_564526, "subscriptionId", newJString(subscriptionId))
  add(path_564526, "resourceGroupName", newJString(resourceGroupName))
  add(path_564526, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564528 = parameters
  result = call_564525.call(path_564526, query_564527, nil, nil, body_564528)

var serverEndpointsUpdate* = Call_ServerEndpointsUpdate_564514(
    name: "serverEndpointsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}",
    validator: validate_ServerEndpointsUpdate_564515, base: "",
    url: url_ServerEndpointsUpdate_564516, schemes: {Scheme.Https})
type
  Call_ServerEndpointsDelete_564501 = ref object of OpenApiRestCall_563565
proc url_ServerEndpointsDelete_564503(protocol: Scheme; host: string; base: string;
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

proc validate_ServerEndpointsDelete_564502(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a given ServerEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   serverEndpointName: JString (required)
  ##                     : Name of Server Endpoint object.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564504 = path.getOrDefault("syncGroupName")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "syncGroupName", valid_564504
  var valid_564505 = path.getOrDefault("serverEndpointName")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "serverEndpointName", valid_564505
  var valid_564506 = path.getOrDefault("subscriptionId")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = nil)
  if valid_564506 != nil:
    section.add "subscriptionId", valid_564506
  var valid_564507 = path.getOrDefault("resourceGroupName")
  valid_564507 = validateParameter(valid_564507, JString, required = true,
                                 default = nil)
  if valid_564507 != nil:
    section.add "resourceGroupName", valid_564507
  var valid_564508 = path.getOrDefault("storageSyncServiceName")
  valid_564508 = validateParameter(valid_564508, JString, required = true,
                                 default = nil)
  if valid_564508 != nil:
    section.add "storageSyncServiceName", valid_564508
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564509 = query.getOrDefault("api-version")
  valid_564509 = validateParameter(valid_564509, JString, required = true,
                                 default = nil)
  if valid_564509 != nil:
    section.add "api-version", valid_564509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564510: Call_ServerEndpointsDelete_564501; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a given ServerEndpoint.
  ## 
  let valid = call_564510.validator(path, query, header, formData, body)
  let scheme = call_564510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564510.url(scheme.get, call_564510.host, call_564510.base,
                         call_564510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564510, url, valid)

proc call*(call_564511: Call_ServerEndpointsDelete_564501; syncGroupName: string;
          apiVersion: string; serverEndpointName: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string): Recallable =
  ## serverEndpointsDelete
  ## Delete a given ServerEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   serverEndpointName: string (required)
  ##                     : Name of Server Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564512 = newJObject()
  var query_564513 = newJObject()
  add(path_564512, "syncGroupName", newJString(syncGroupName))
  add(query_564513, "api-version", newJString(apiVersion))
  add(path_564512, "serverEndpointName", newJString(serverEndpointName))
  add(path_564512, "subscriptionId", newJString(subscriptionId))
  add(path_564512, "resourceGroupName", newJString(resourceGroupName))
  add(path_564512, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564511.call(path_564512, query_564513, nil, nil, nil)

var serverEndpointsDelete* = Call_ServerEndpointsDelete_564501(
    name: "serverEndpointsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}",
    validator: validate_ServerEndpointsDelete_564502, base: "",
    url: url_ServerEndpointsDelete_564503, schemes: {Scheme.Https})
type
  Call_ServerEndpointsRecallAction_564529 = ref object of OpenApiRestCall_563565
proc url_ServerEndpointsRecallAction_564531(protocol: Scheme; host: string;
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

proc validate_ServerEndpointsRecallAction_564530(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Recall a server endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   serverEndpointName: JString (required)
  ##                     : Name of Server Endpoint object.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564532 = path.getOrDefault("syncGroupName")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "syncGroupName", valid_564532
  var valid_564533 = path.getOrDefault("serverEndpointName")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "serverEndpointName", valid_564533
  var valid_564534 = path.getOrDefault("subscriptionId")
  valid_564534 = validateParameter(valid_564534, JString, required = true,
                                 default = nil)
  if valid_564534 != nil:
    section.add "subscriptionId", valid_564534
  var valid_564535 = path.getOrDefault("resourceGroupName")
  valid_564535 = validateParameter(valid_564535, JString, required = true,
                                 default = nil)
  if valid_564535 != nil:
    section.add "resourceGroupName", valid_564535
  var valid_564536 = path.getOrDefault("storageSyncServiceName")
  valid_564536 = validateParameter(valid_564536, JString, required = true,
                                 default = nil)
  if valid_564536 != nil:
    section.add "storageSyncServiceName", valid_564536
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564537 = query.getOrDefault("api-version")
  valid_564537 = validateParameter(valid_564537, JString, required = true,
                                 default = nil)
  if valid_564537 != nil:
    section.add "api-version", valid_564537
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

proc call*(call_564539: Call_ServerEndpointsRecallAction_564529; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recall a server endpoint.
  ## 
  let valid = call_564539.validator(path, query, header, formData, body)
  let scheme = call_564539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564539.url(scheme.get, call_564539.host, call_564539.base,
                         call_564539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564539, url, valid)

proc call*(call_564540: Call_ServerEndpointsRecallAction_564529;
          syncGroupName: string; apiVersion: string; serverEndpointName: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string; parameters: JsonNode): Recallable =
  ## serverEndpointsRecallAction
  ## Recall a server endpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   serverEndpointName: string (required)
  ##                     : Name of Server Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Body of Recall Action object.
  var path_564541 = newJObject()
  var query_564542 = newJObject()
  var body_564543 = newJObject()
  add(path_564541, "syncGroupName", newJString(syncGroupName))
  add(query_564542, "api-version", newJString(apiVersion))
  add(path_564541, "serverEndpointName", newJString(serverEndpointName))
  add(path_564541, "subscriptionId", newJString(subscriptionId))
  add(path_564541, "resourceGroupName", newJString(resourceGroupName))
  add(path_564541, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564543 = parameters
  result = call_564540.call(path_564541, query_564542, nil, nil, body_564543)

var serverEndpointsRecallAction* = Call_ServerEndpointsRecallAction_564529(
    name: "serverEndpointsRecallAction", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}/recallAction",
    validator: validate_ServerEndpointsRecallAction_564530, base: "",
    url: url_ServerEndpointsRecallAction_564531, schemes: {Scheme.Https})
type
  Call_WorkflowsListByStorageSyncService_564544 = ref object of OpenApiRestCall_563565
proc url_WorkflowsListByStorageSyncService_564546(protocol: Scheme; host: string;
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

proc validate_WorkflowsListByStorageSyncService_564545(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Workflow List
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564547 = path.getOrDefault("subscriptionId")
  valid_564547 = validateParameter(valid_564547, JString, required = true,
                                 default = nil)
  if valid_564547 != nil:
    section.add "subscriptionId", valid_564547
  var valid_564548 = path.getOrDefault("resourceGroupName")
  valid_564548 = validateParameter(valid_564548, JString, required = true,
                                 default = nil)
  if valid_564548 != nil:
    section.add "resourceGroupName", valid_564548
  var valid_564549 = path.getOrDefault("storageSyncServiceName")
  valid_564549 = validateParameter(valid_564549, JString, required = true,
                                 default = nil)
  if valid_564549 != nil:
    section.add "storageSyncServiceName", valid_564549
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564550 = query.getOrDefault("api-version")
  valid_564550 = validateParameter(valid_564550, JString, required = true,
                                 default = nil)
  if valid_564550 != nil:
    section.add "api-version", valid_564550
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564551: Call_WorkflowsListByStorageSyncService_564544;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a Workflow List
  ## 
  let valid = call_564551.validator(path, query, header, formData, body)
  let scheme = call_564551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564551.url(scheme.get, call_564551.host, call_564551.base,
                         call_564551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564551, url, valid)

proc call*(call_564552: Call_WorkflowsListByStorageSyncService_564544;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## workflowsListByStorageSyncService
  ## Get a Workflow List
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564553 = newJObject()
  var query_564554 = newJObject()
  add(query_564554, "api-version", newJString(apiVersion))
  add(path_564553, "subscriptionId", newJString(subscriptionId))
  add(path_564553, "resourceGroupName", newJString(resourceGroupName))
  add(path_564553, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564552.call(path_564553, query_564554, nil, nil, nil)

var workflowsListByStorageSyncService* = Call_WorkflowsListByStorageSyncService_564544(
    name: "workflowsListByStorageSyncService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/workflows",
    validator: validate_WorkflowsListByStorageSyncService_564545, base: "",
    url: url_WorkflowsListByStorageSyncService_564546, schemes: {Scheme.Https})
type
  Call_WorkflowsGet_564555 = ref object of OpenApiRestCall_563565
proc url_WorkflowsGet_564557(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsGet_564556(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Workflows resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowId: JString (required)
  ##             : workflow Id
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowId` field"
  var valid_564558 = path.getOrDefault("workflowId")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "workflowId", valid_564558
  var valid_564559 = path.getOrDefault("subscriptionId")
  valid_564559 = validateParameter(valid_564559, JString, required = true,
                                 default = nil)
  if valid_564559 != nil:
    section.add "subscriptionId", valid_564559
  var valid_564560 = path.getOrDefault("resourceGroupName")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = nil)
  if valid_564560 != nil:
    section.add "resourceGroupName", valid_564560
  var valid_564561 = path.getOrDefault("storageSyncServiceName")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = nil)
  if valid_564561 != nil:
    section.add "storageSyncServiceName", valid_564561
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564562 = query.getOrDefault("api-version")
  valid_564562 = validateParameter(valid_564562, JString, required = true,
                                 default = nil)
  if valid_564562 != nil:
    section.add "api-version", valid_564562
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564563: Call_WorkflowsGet_564555; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Workflows resource
  ## 
  let valid = call_564563.validator(path, query, header, formData, body)
  let scheme = call_564563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564563.url(scheme.get, call_564563.host, call_564563.base,
                         call_564563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564563, url, valid)

proc call*(call_564564: Call_WorkflowsGet_564555; workflowId: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## workflowsGet
  ## Get Workflows resource
  ##   workflowId: string (required)
  ##             : workflow Id
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564565 = newJObject()
  var query_564566 = newJObject()
  add(path_564565, "workflowId", newJString(workflowId))
  add(query_564566, "api-version", newJString(apiVersion))
  add(path_564565, "subscriptionId", newJString(subscriptionId))
  add(path_564565, "resourceGroupName", newJString(resourceGroupName))
  add(path_564565, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564564.call(path_564565, query_564566, nil, nil, nil)

var workflowsGet* = Call_WorkflowsGet_564555(name: "workflowsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/workflows/{workflowId}",
    validator: validate_WorkflowsGet_564556, base: "", url: url_WorkflowsGet_564557,
    schemes: {Scheme.Https})
type
  Call_WorkflowsAbort_564567 = ref object of OpenApiRestCall_563565
proc url_WorkflowsAbort_564569(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsAbort_564568(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Abort the given workflow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowId: JString (required)
  ##             : workflow Id
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowId` field"
  var valid_564570 = path.getOrDefault("workflowId")
  valid_564570 = validateParameter(valid_564570, JString, required = true,
                                 default = nil)
  if valid_564570 != nil:
    section.add "workflowId", valid_564570
  var valid_564571 = path.getOrDefault("subscriptionId")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "subscriptionId", valid_564571
  var valid_564572 = path.getOrDefault("resourceGroupName")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "resourceGroupName", valid_564572
  var valid_564573 = path.getOrDefault("storageSyncServiceName")
  valid_564573 = validateParameter(valid_564573, JString, required = true,
                                 default = nil)
  if valid_564573 != nil:
    section.add "storageSyncServiceName", valid_564573
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564574 = query.getOrDefault("api-version")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "api-version", valid_564574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564575: Call_WorkflowsAbort_564567; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Abort the given workflow.
  ## 
  let valid = call_564575.validator(path, query, header, formData, body)
  let scheme = call_564575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564575.url(scheme.get, call_564575.host, call_564575.base,
                         call_564575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564575, url, valid)

proc call*(call_564576: Call_WorkflowsAbort_564567; workflowId: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## workflowsAbort
  ## Abort the given workflow.
  ##   workflowId: string (required)
  ##             : workflow Id
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564577 = newJObject()
  var query_564578 = newJObject()
  add(path_564577, "workflowId", newJString(workflowId))
  add(query_564578, "api-version", newJString(apiVersion))
  add(path_564577, "subscriptionId", newJString(subscriptionId))
  add(path_564577, "resourceGroupName", newJString(resourceGroupName))
  add(path_564577, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564576.call(path_564577, query_564578, nil, nil, nil)

var workflowsAbort* = Call_WorkflowsAbort_564567(name: "workflowsAbort",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/workflows/{workflowId}/abort",
    validator: validate_WorkflowsAbort_564568, base: "", url: url_WorkflowsAbort_564569,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
