
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Microsoft Storage Sync
## version: 2017-06-05-preview
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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  Call_OperationsList_563778 = ref object of OpenApiRestCall_563556
proc url_OperationsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563779(path: JsonNode; query: JsonNode;
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
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563941 = query.getOrDefault("api-version")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "api-version", valid_563941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_OperationsList_563778; path: JsonNode; query: JsonNode;
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

proc call*(call_564035: Call_OperationsList_563778; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Storage Sync Rest API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  result = call_564035.call(nil, query_564036, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.StorageSync/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_StorageSyncServicesListBySubscription_564076 = ref object of OpenApiRestCall_563556
proc url_StorageSyncServicesListBySubscription_564078(protocol: Scheme;
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

proc validate_StorageSyncServicesListBySubscription_564077(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a StorageSyncService list by subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564093 = path.getOrDefault("subscriptionId")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "subscriptionId", valid_564093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564094 = query.getOrDefault("api-version")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "api-version", valid_564094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564095: Call_StorageSyncServicesListBySubscription_564076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a StorageSyncService list by subscription.
  ## 
  let valid = call_564095.validator(path, query, header, formData, body)
  let scheme = call_564095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564095.url(scheme.get, call_564095.host, call_564095.base,
                         call_564095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564095, url, valid)

proc call*(call_564096: Call_StorageSyncServicesListBySubscription_564076;
          apiVersion: string; subscriptionId: string): Recallable =
  ## storageSyncServicesListBySubscription
  ## Get a StorageSyncService list by subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564097 = newJObject()
  var query_564098 = newJObject()
  add(query_564098, "api-version", newJString(apiVersion))
  add(path_564097, "subscriptionId", newJString(subscriptionId))
  result = call_564096.call(path_564097, query_564098, nil, nil, nil)

var storageSyncServicesListBySubscription* = Call_StorageSyncServicesListBySubscription_564076(
    name: "storageSyncServicesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.StorageSync/storageSyncServices",
    validator: validate_StorageSyncServicesListBySubscription_564077, base: "",
    url: url_StorageSyncServicesListBySubscription_564078, schemes: {Scheme.Https})
type
  Call_StorageSyncServicesListByResourceGroup_564099 = ref object of OpenApiRestCall_563556
proc url_StorageSyncServicesListByResourceGroup_564101(protocol: Scheme;
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

proc validate_StorageSyncServicesListByResourceGroup_564100(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a StorageSyncService list by Resource group name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564102 = path.getOrDefault("subscriptionId")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "subscriptionId", valid_564102
  var valid_564103 = path.getOrDefault("resourceGroupName")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "resourceGroupName", valid_564103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564104 = query.getOrDefault("api-version")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "api-version", valid_564104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564105: Call_StorageSyncServicesListByResourceGroup_564099;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a StorageSyncService list by Resource group name.
  ## 
  let valid = call_564105.validator(path, query, header, formData, body)
  let scheme = call_564105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564105.url(scheme.get, call_564105.host, call_564105.base,
                         call_564105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564105, url, valid)

proc call*(call_564106: Call_StorageSyncServicesListByResourceGroup_564099;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## storageSyncServicesListByResourceGroup
  ## Get a StorageSyncService list by Resource group name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  var path_564107 = newJObject()
  var query_564108 = newJObject()
  add(query_564108, "api-version", newJString(apiVersion))
  add(path_564107, "subscriptionId", newJString(subscriptionId))
  add(path_564107, "resourceGroupName", newJString(resourceGroupName))
  result = call_564106.call(path_564107, query_564108, nil, nil, nil)

var storageSyncServicesListByResourceGroup* = Call_StorageSyncServicesListByResourceGroup_564099(
    name: "storageSyncServicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices",
    validator: validate_StorageSyncServicesListByResourceGroup_564100, base: "",
    url: url_StorageSyncServicesListByResourceGroup_564101,
    schemes: {Scheme.Https})
type
  Call_StorageSyncServicesCreate_564120 = ref object of OpenApiRestCall_563556
proc url_StorageSyncServicesCreate_564122(protocol: Scheme; host: string;
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

proc validate_StorageSyncServicesCreate_564121(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new StorageSyncService.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564123 = path.getOrDefault("subscriptionId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "subscriptionId", valid_564123
  var valid_564124 = path.getOrDefault("resourceGroupName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "resourceGroupName", valid_564124
  var valid_564125 = path.getOrDefault("storageSyncServiceName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "storageSyncServiceName", valid_564125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564126 = query.getOrDefault("api-version")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "api-version", valid_564126
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

proc call*(call_564128: Call_StorageSyncServicesCreate_564120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new StorageSyncService.
  ## 
  let valid = call_564128.validator(path, query, header, formData, body)
  let scheme = call_564128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564128.url(scheme.get, call_564128.host, call_564128.base,
                         call_564128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564128, url, valid)

proc call*(call_564129: Call_StorageSyncServicesCreate_564120; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string; parameters: JsonNode): Recallable =
  ## storageSyncServicesCreate
  ## Create a new StorageSyncService.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Storage Sync Service resource name.
  var path_564130 = newJObject()
  var query_564131 = newJObject()
  var body_564132 = newJObject()
  add(query_564131, "api-version", newJString(apiVersion))
  add(path_564130, "subscriptionId", newJString(subscriptionId))
  add(path_564130, "resourceGroupName", newJString(resourceGroupName))
  add(path_564130, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564132 = parameters
  result = call_564129.call(path_564130, query_564131, nil, nil, body_564132)

var storageSyncServicesCreate* = Call_StorageSyncServicesCreate_564120(
    name: "storageSyncServicesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}",
    validator: validate_StorageSyncServicesCreate_564121, base: "",
    url: url_StorageSyncServicesCreate_564122, schemes: {Scheme.Https})
type
  Call_StorageSyncServicesGet_564109 = ref object of OpenApiRestCall_563556
proc url_StorageSyncServicesGet_564111(protocol: Scheme; host: string; base: string;
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

proc validate_StorageSyncServicesGet_564110(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a given StorageSyncService.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564112 = path.getOrDefault("subscriptionId")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "subscriptionId", valid_564112
  var valid_564113 = path.getOrDefault("resourceGroupName")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "resourceGroupName", valid_564113
  var valid_564114 = path.getOrDefault("storageSyncServiceName")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "storageSyncServiceName", valid_564114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564115 = query.getOrDefault("api-version")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "api-version", valid_564115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564116: Call_StorageSyncServicesGet_564109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a given StorageSyncService.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_StorageSyncServicesGet_564109; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## storageSyncServicesGet
  ## Get a given StorageSyncService.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564118 = newJObject()
  var query_564119 = newJObject()
  add(query_564119, "api-version", newJString(apiVersion))
  add(path_564118, "subscriptionId", newJString(subscriptionId))
  add(path_564118, "resourceGroupName", newJString(resourceGroupName))
  add(path_564118, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564117.call(path_564118, query_564119, nil, nil, nil)

var storageSyncServicesGet* = Call_StorageSyncServicesGet_564109(
    name: "storageSyncServicesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}",
    validator: validate_StorageSyncServicesGet_564110, base: "",
    url: url_StorageSyncServicesGet_564111, schemes: {Scheme.Https})
type
  Call_StorageSyncServicesUpdate_564144 = ref object of OpenApiRestCall_563556
proc url_StorageSyncServicesUpdate_564146(protocol: Scheme; host: string;
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

proc validate_StorageSyncServicesUpdate_564145(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch a given StorageSyncService.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564147 = path.getOrDefault("subscriptionId")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "subscriptionId", valid_564147
  var valid_564148 = path.getOrDefault("resourceGroupName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "resourceGroupName", valid_564148
  var valid_564149 = path.getOrDefault("storageSyncServiceName")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "storageSyncServiceName", valid_564149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564150 = query.getOrDefault("api-version")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "api-version", valid_564150
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

proc call*(call_564152: Call_StorageSyncServicesUpdate_564144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a given StorageSyncService.
  ## 
  let valid = call_564152.validator(path, query, header, formData, body)
  let scheme = call_564152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564152.url(scheme.get, call_564152.host, call_564152.base,
                         call_564152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564152, url, valid)

proc call*(call_564153: Call_StorageSyncServicesUpdate_564144; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string; parameters: JsonNode = nil): Recallable =
  ## storageSyncServicesUpdate
  ## Patch a given StorageSyncService.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject
  ##             : Storage Sync Service resource.
  var path_564154 = newJObject()
  var query_564155 = newJObject()
  var body_564156 = newJObject()
  add(query_564155, "api-version", newJString(apiVersion))
  add(path_564154, "subscriptionId", newJString(subscriptionId))
  add(path_564154, "resourceGroupName", newJString(resourceGroupName))
  add(path_564154, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564156 = parameters
  result = call_564153.call(path_564154, query_564155, nil, nil, body_564156)

var storageSyncServicesUpdate* = Call_StorageSyncServicesUpdate_564144(
    name: "storageSyncServicesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}",
    validator: validate_StorageSyncServicesUpdate_564145, base: "",
    url: url_StorageSyncServicesUpdate_564146, schemes: {Scheme.Https})
type
  Call_StorageSyncServicesDelete_564133 = ref object of OpenApiRestCall_563556
proc url_StorageSyncServicesDelete_564135(protocol: Scheme; host: string;
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

proc validate_StorageSyncServicesDelete_564134(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a given StorageSyncService.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564136 = path.getOrDefault("subscriptionId")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "subscriptionId", valid_564136
  var valid_564137 = path.getOrDefault("resourceGroupName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "resourceGroupName", valid_564137
  var valid_564138 = path.getOrDefault("storageSyncServiceName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "storageSyncServiceName", valid_564138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564139 = query.getOrDefault("api-version")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "api-version", valid_564139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564140: Call_StorageSyncServicesDelete_564133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a given StorageSyncService.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_StorageSyncServicesDelete_564133; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## storageSyncServicesDelete
  ## Delete a given StorageSyncService.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564142 = newJObject()
  var query_564143 = newJObject()
  add(query_564143, "api-version", newJString(apiVersion))
  add(path_564142, "subscriptionId", newJString(subscriptionId))
  add(path_564142, "resourceGroupName", newJString(resourceGroupName))
  add(path_564142, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564141.call(path_564142, query_564143, nil, nil, nil)

var storageSyncServicesDelete* = Call_StorageSyncServicesDelete_564133(
    name: "storageSyncServicesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}",
    validator: validate_StorageSyncServicesDelete_564134, base: "",
    url: url_StorageSyncServicesDelete_564135, schemes: {Scheme.Https})
type
  Call_RegisteredServersListByStorageSyncService_564157 = ref object of OpenApiRestCall_563556
proc url_RegisteredServersListByStorageSyncService_564159(protocol: Scheme;
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

proc validate_RegisteredServersListByStorageSyncService_564158(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a given registered server list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564160 = path.getOrDefault("subscriptionId")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "subscriptionId", valid_564160
  var valid_564161 = path.getOrDefault("resourceGroupName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "resourceGroupName", valid_564161
  var valid_564162 = path.getOrDefault("storageSyncServiceName")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "storageSyncServiceName", valid_564162
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564163 = query.getOrDefault("api-version")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "api-version", valid_564163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564164: Call_RegisteredServersListByStorageSyncService_564157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a given registered server list.
  ## 
  let valid = call_564164.validator(path, query, header, formData, body)
  let scheme = call_564164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564164.url(scheme.get, call_564164.host, call_564164.base,
                         call_564164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564164, url, valid)

proc call*(call_564165: Call_RegisteredServersListByStorageSyncService_564157;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## registeredServersListByStorageSyncService
  ## Get a given registered server list.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564166 = newJObject()
  var query_564167 = newJObject()
  add(query_564167, "api-version", newJString(apiVersion))
  add(path_564166, "subscriptionId", newJString(subscriptionId))
  add(path_564166, "resourceGroupName", newJString(resourceGroupName))
  add(path_564166, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564165.call(path_564166, query_564167, nil, nil, nil)

var registeredServersListByStorageSyncService* = Call_RegisteredServersListByStorageSyncService_564157(
    name: "registeredServersListByStorageSyncService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers",
    validator: validate_RegisteredServersListByStorageSyncService_564158,
    base: "", url: url_RegisteredServersListByStorageSyncService_564159,
    schemes: {Scheme.Https})
type
  Call_RegisteredServersCreate_564180 = ref object of OpenApiRestCall_563556
proc url_RegisteredServersCreate_564182(protocol: Scheme; host: string; base: string;
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

proc validate_RegisteredServersCreate_564181(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a new registered server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverId: JString (required)
  ##           : GUID identifying the on-premises server.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serverId` field"
  var valid_564183 = path.getOrDefault("serverId")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "serverId", valid_564183
  var valid_564184 = path.getOrDefault("subscriptionId")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "subscriptionId", valid_564184
  var valid_564185 = path.getOrDefault("resourceGroupName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "resourceGroupName", valid_564185
  var valid_564186 = path.getOrDefault("storageSyncServiceName")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "storageSyncServiceName", valid_564186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Body of Registered Server object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564189: Call_RegisteredServersCreate_564180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a new registered server.
  ## 
  let valid = call_564189.validator(path, query, header, formData, body)
  let scheme = call_564189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564189.url(scheme.get, call_564189.host, call_564189.base,
                         call_564189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564189, url, valid)

proc call*(call_564190: Call_RegisteredServersCreate_564180; apiVersion: string;
          serverId: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string; parameters: JsonNode): Recallable =
  ## registeredServersCreate
  ## Add a new registered server.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   serverId: string (required)
  ##           : GUID identifying the on-premises server.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Body of Registered Server object.
  var path_564191 = newJObject()
  var query_564192 = newJObject()
  var body_564193 = newJObject()
  add(query_564192, "api-version", newJString(apiVersion))
  add(path_564191, "serverId", newJString(serverId))
  add(path_564191, "subscriptionId", newJString(subscriptionId))
  add(path_564191, "resourceGroupName", newJString(resourceGroupName))
  add(path_564191, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564193 = parameters
  result = call_564190.call(path_564191, query_564192, nil, nil, body_564193)

var registeredServersCreate* = Call_RegisteredServersCreate_564180(
    name: "registeredServersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers/{serverId}",
    validator: validate_RegisteredServersCreate_564181, base: "",
    url: url_RegisteredServersCreate_564182, schemes: {Scheme.Https})
type
  Call_RegisteredServersGet_564168 = ref object of OpenApiRestCall_563556
proc url_RegisteredServersGet_564170(protocol: Scheme; host: string; base: string;
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

proc validate_RegisteredServersGet_564169(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a given registered server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverId: JString (required)
  ##           : GUID identifying the on-premises server.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serverId` field"
  var valid_564171 = path.getOrDefault("serverId")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "serverId", valid_564171
  var valid_564172 = path.getOrDefault("subscriptionId")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "subscriptionId", valid_564172
  var valid_564173 = path.getOrDefault("resourceGroupName")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "resourceGroupName", valid_564173
  var valid_564174 = path.getOrDefault("storageSyncServiceName")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "storageSyncServiceName", valid_564174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_564176: Call_RegisteredServersGet_564168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a given registered server.
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_RegisteredServersGet_564168; apiVersion: string;
          serverId: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## registeredServersGet
  ## Get a given registered server.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   serverId: string (required)
  ##           : GUID identifying the on-premises server.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564178 = newJObject()
  var query_564179 = newJObject()
  add(query_564179, "api-version", newJString(apiVersion))
  add(path_564178, "serverId", newJString(serverId))
  add(path_564178, "subscriptionId", newJString(subscriptionId))
  add(path_564178, "resourceGroupName", newJString(resourceGroupName))
  add(path_564178, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564177.call(path_564178, query_564179, nil, nil, nil)

var registeredServersGet* = Call_RegisteredServersGet_564168(
    name: "registeredServersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers/{serverId}",
    validator: validate_RegisteredServersGet_564169, base: "",
    url: url_RegisteredServersGet_564170, schemes: {Scheme.Https})
type
  Call_RegisteredServersDelete_564194 = ref object of OpenApiRestCall_563556
proc url_RegisteredServersDelete_564196(protocol: Scheme; host: string; base: string;
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

proc validate_RegisteredServersDelete_564195(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the given registered server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverId: JString (required)
  ##           : GUID identifying the on-premises server.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serverId` field"
  var valid_564197 = path.getOrDefault("serverId")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "serverId", valid_564197
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
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564202: Call_RegisteredServersDelete_564194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the given registered server.
  ## 
  let valid = call_564202.validator(path, query, header, formData, body)
  let scheme = call_564202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564202.url(scheme.get, call_564202.host, call_564202.base,
                         call_564202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564202, url, valid)

proc call*(call_564203: Call_RegisteredServersDelete_564194; apiVersion: string;
          serverId: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## registeredServersDelete
  ## Delete the given registered server.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   serverId: string (required)
  ##           : GUID identifying the on-premises server.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564204 = newJObject()
  var query_564205 = newJObject()
  add(query_564205, "api-version", newJString(apiVersion))
  add(path_564204, "serverId", newJString(serverId))
  add(path_564204, "subscriptionId", newJString(subscriptionId))
  add(path_564204, "resourceGroupName", newJString(resourceGroupName))
  add(path_564204, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564203.call(path_564204, query_564205, nil, nil, nil)

var registeredServersDelete* = Call_RegisteredServersDelete_564194(
    name: "registeredServersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers/{serverId}",
    validator: validate_RegisteredServersDelete_564195, base: "",
    url: url_RegisteredServersDelete_564196, schemes: {Scheme.Https})
type
  Call_SyncGroupsListByStorageSyncService_564206 = ref object of OpenApiRestCall_563556
proc url_SyncGroupsListByStorageSyncService_564208(protocol: Scheme; host: string;
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

proc validate_SyncGroupsListByStorageSyncService_564207(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a SyncGroup List.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564209 = path.getOrDefault("subscriptionId")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "subscriptionId", valid_564209
  var valid_564210 = path.getOrDefault("resourceGroupName")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "resourceGroupName", valid_564210
  var valid_564211 = path.getOrDefault("storageSyncServiceName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "storageSyncServiceName", valid_564211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564212 = query.getOrDefault("api-version")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "api-version", valid_564212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564213: Call_SyncGroupsListByStorageSyncService_564206;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a SyncGroup List.
  ## 
  let valid = call_564213.validator(path, query, header, formData, body)
  let scheme = call_564213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564213.url(scheme.get, call_564213.host, call_564213.base,
                         call_564213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564213, url, valid)

proc call*(call_564214: Call_SyncGroupsListByStorageSyncService_564206;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## syncGroupsListByStorageSyncService
  ## Get a SyncGroup List.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564215 = newJObject()
  var query_564216 = newJObject()
  add(query_564216, "api-version", newJString(apiVersion))
  add(path_564215, "subscriptionId", newJString(subscriptionId))
  add(path_564215, "resourceGroupName", newJString(resourceGroupName))
  add(path_564215, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564214.call(path_564215, query_564216, nil, nil, nil)

var syncGroupsListByStorageSyncService* = Call_SyncGroupsListByStorageSyncService_564206(
    name: "syncGroupsListByStorageSyncService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups",
    validator: validate_SyncGroupsListByStorageSyncService_564207, base: "",
    url: url_SyncGroupsListByStorageSyncService_564208, schemes: {Scheme.Https})
type
  Call_SyncGroupsCreate_564229 = ref object of OpenApiRestCall_563556
proc url_SyncGroupsCreate_564231(protocol: Scheme; host: string; base: string;
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

proc validate_SyncGroupsCreate_564230(path: JsonNode; query: JsonNode;
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
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564232 = path.getOrDefault("syncGroupName")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "syncGroupName", valid_564232
  var valid_564233 = path.getOrDefault("subscriptionId")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "subscriptionId", valid_564233
  var valid_564234 = path.getOrDefault("resourceGroupName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "resourceGroupName", valid_564234
  var valid_564235 = path.getOrDefault("storageSyncServiceName")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "storageSyncServiceName", valid_564235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564236 = query.getOrDefault("api-version")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "api-version", valid_564236
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

proc call*(call_564238: Call_SyncGroupsCreate_564229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new SyncGroup.
  ## 
  let valid = call_564238.validator(path, query, header, formData, body)
  let scheme = call_564238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564238.url(scheme.get, call_564238.host, call_564238.base,
                         call_564238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564238, url, valid)

proc call*(call_564239: Call_SyncGroupsCreate_564229; syncGroupName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string; parameters: JsonNode): Recallable =
  ## syncGroupsCreate
  ## Create a new SyncGroup.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Sync Group Body
  var path_564240 = newJObject()
  var query_564241 = newJObject()
  var body_564242 = newJObject()
  add(path_564240, "syncGroupName", newJString(syncGroupName))
  add(query_564241, "api-version", newJString(apiVersion))
  add(path_564240, "subscriptionId", newJString(subscriptionId))
  add(path_564240, "resourceGroupName", newJString(resourceGroupName))
  add(path_564240, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564242 = parameters
  result = call_564239.call(path_564240, query_564241, nil, nil, body_564242)

var syncGroupsCreate* = Call_SyncGroupsCreate_564229(name: "syncGroupsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}",
    validator: validate_SyncGroupsCreate_564230, base: "",
    url: url_SyncGroupsCreate_564231, schemes: {Scheme.Https})
type
  Call_SyncGroupsGet_564217 = ref object of OpenApiRestCall_563556
proc url_SyncGroupsGet_564219(protocol: Scheme; host: string; base: string;
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

proc validate_SyncGroupsGet_564218(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a given SyncGroup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564220 = path.getOrDefault("syncGroupName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "syncGroupName", valid_564220
  var valid_564221 = path.getOrDefault("subscriptionId")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "subscriptionId", valid_564221
  var valid_564222 = path.getOrDefault("resourceGroupName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "resourceGroupName", valid_564222
  var valid_564223 = path.getOrDefault("storageSyncServiceName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "storageSyncServiceName", valid_564223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564224 = query.getOrDefault("api-version")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "api-version", valid_564224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564225: Call_SyncGroupsGet_564217; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a given SyncGroup.
  ## 
  let valid = call_564225.validator(path, query, header, formData, body)
  let scheme = call_564225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564225.url(scheme.get, call_564225.host, call_564225.base,
                         call_564225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564225, url, valid)

proc call*(call_564226: Call_SyncGroupsGet_564217; syncGroupName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## syncGroupsGet
  ## Get a given SyncGroup.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564227 = newJObject()
  var query_564228 = newJObject()
  add(path_564227, "syncGroupName", newJString(syncGroupName))
  add(query_564228, "api-version", newJString(apiVersion))
  add(path_564227, "subscriptionId", newJString(subscriptionId))
  add(path_564227, "resourceGroupName", newJString(resourceGroupName))
  add(path_564227, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564226.call(path_564227, query_564228, nil, nil, nil)

var syncGroupsGet* = Call_SyncGroupsGet_564217(name: "syncGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}",
    validator: validate_SyncGroupsGet_564218, base: "", url: url_SyncGroupsGet_564219,
    schemes: {Scheme.Https})
type
  Call_SyncGroupsDelete_564243 = ref object of OpenApiRestCall_563556
proc url_SyncGroupsDelete_564245(protocol: Scheme; host: string; base: string;
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

proc validate_SyncGroupsDelete_564244(path: JsonNode; query: JsonNode;
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
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564246 = path.getOrDefault("syncGroupName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "syncGroupName", valid_564246
  var valid_564247 = path.getOrDefault("subscriptionId")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "subscriptionId", valid_564247
  var valid_564248 = path.getOrDefault("resourceGroupName")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "resourceGroupName", valid_564248
  var valid_564249 = path.getOrDefault("storageSyncServiceName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "storageSyncServiceName", valid_564249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564250 = query.getOrDefault("api-version")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "api-version", valid_564250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564251: Call_SyncGroupsDelete_564243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a given SyncGroup.
  ## 
  let valid = call_564251.validator(path, query, header, formData, body)
  let scheme = call_564251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564251.url(scheme.get, call_564251.host, call_564251.base,
                         call_564251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564251, url, valid)

proc call*(call_564252: Call_SyncGroupsDelete_564243; syncGroupName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## syncGroupsDelete
  ## Delete a given SyncGroup.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564253 = newJObject()
  var query_564254 = newJObject()
  add(path_564253, "syncGroupName", newJString(syncGroupName))
  add(query_564254, "api-version", newJString(apiVersion))
  add(path_564253, "subscriptionId", newJString(subscriptionId))
  add(path_564253, "resourceGroupName", newJString(resourceGroupName))
  add(path_564253, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564252.call(path_564253, query_564254, nil, nil, nil)

var syncGroupsDelete* = Call_SyncGroupsDelete_564243(name: "syncGroupsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}",
    validator: validate_SyncGroupsDelete_564244, base: "",
    url: url_SyncGroupsDelete_564245, schemes: {Scheme.Https})
type
  Call_CloudEndpointsListBySyncGroup_564255 = ref object of OpenApiRestCall_563556
proc url_CloudEndpointsListBySyncGroup_564257(protocol: Scheme; host: string;
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

proc validate_CloudEndpointsListBySyncGroup_564256(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a CloudEndpoint List.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564258 = path.getOrDefault("syncGroupName")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "syncGroupName", valid_564258
  var valid_564259 = path.getOrDefault("subscriptionId")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "subscriptionId", valid_564259
  var valid_564260 = path.getOrDefault("resourceGroupName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "resourceGroupName", valid_564260
  var valid_564261 = path.getOrDefault("storageSyncServiceName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "storageSyncServiceName", valid_564261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564262 = query.getOrDefault("api-version")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "api-version", valid_564262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564263: Call_CloudEndpointsListBySyncGroup_564255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a CloudEndpoint List.
  ## 
  let valid = call_564263.validator(path, query, header, formData, body)
  let scheme = call_564263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564263.url(scheme.get, call_564263.host, call_564263.base,
                         call_564263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564263, url, valid)

proc call*(call_564264: Call_CloudEndpointsListBySyncGroup_564255;
          syncGroupName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string): Recallable =
  ## cloudEndpointsListBySyncGroup
  ## Get a CloudEndpoint List.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564265 = newJObject()
  var query_564266 = newJObject()
  add(path_564265, "syncGroupName", newJString(syncGroupName))
  add(query_564266, "api-version", newJString(apiVersion))
  add(path_564265, "subscriptionId", newJString(subscriptionId))
  add(path_564265, "resourceGroupName", newJString(resourceGroupName))
  add(path_564265, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564264.call(path_564265, query_564266, nil, nil, nil)

var cloudEndpointsListBySyncGroup* = Call_CloudEndpointsListBySyncGroup_564255(
    name: "cloudEndpointsListBySyncGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints",
    validator: validate_CloudEndpointsListBySyncGroup_564256, base: "",
    url: url_CloudEndpointsListBySyncGroup_564257, schemes: {Scheme.Https})
type
  Call_CloudEndpointsCreate_564280 = ref object of OpenApiRestCall_563556
proc url_CloudEndpointsCreate_564282(protocol: Scheme; host: string; base: string;
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

proc validate_CloudEndpointsCreate_564281(path: JsonNode; query: JsonNode;
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
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564283 = path.getOrDefault("syncGroupName")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "syncGroupName", valid_564283
  var valid_564284 = path.getOrDefault("cloudEndpointName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "cloudEndpointName", valid_564284
  var valid_564285 = path.getOrDefault("subscriptionId")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "subscriptionId", valid_564285
  var valid_564286 = path.getOrDefault("resourceGroupName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "resourceGroupName", valid_564286
  var valid_564287 = path.getOrDefault("storageSyncServiceName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "storageSyncServiceName", valid_564287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564288 = query.getOrDefault("api-version")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "api-version", valid_564288
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

proc call*(call_564290: Call_CloudEndpointsCreate_564280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new CloudEndpoint.
  ## 
  let valid = call_564290.validator(path, query, header, formData, body)
  let scheme = call_564290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564290.url(scheme.get, call_564290.host, call_564290.base,
                         call_564290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564290, url, valid)

proc call*(call_564291: Call_CloudEndpointsCreate_564280; syncGroupName: string;
          apiVersion: string; cloudEndpointName: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string;
          parameters: JsonNode): Recallable =
  ## cloudEndpointsCreate
  ## Create a new CloudEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Body of Cloud Endpoint resource.
  var path_564292 = newJObject()
  var query_564293 = newJObject()
  var body_564294 = newJObject()
  add(path_564292, "syncGroupName", newJString(syncGroupName))
  add(query_564293, "api-version", newJString(apiVersion))
  add(path_564292, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_564292, "subscriptionId", newJString(subscriptionId))
  add(path_564292, "resourceGroupName", newJString(resourceGroupName))
  add(path_564292, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564294 = parameters
  result = call_564291.call(path_564292, query_564293, nil, nil, body_564294)

var cloudEndpointsCreate* = Call_CloudEndpointsCreate_564280(
    name: "cloudEndpointsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}",
    validator: validate_CloudEndpointsCreate_564281, base: "",
    url: url_CloudEndpointsCreate_564282, schemes: {Scheme.Https})
type
  Call_CloudEndpointsGet_564267 = ref object of OpenApiRestCall_563556
proc url_CloudEndpointsGet_564269(protocol: Scheme; host: string; base: string;
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

proc validate_CloudEndpointsGet_564268(path: JsonNode; query: JsonNode;
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
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564270 = path.getOrDefault("syncGroupName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "syncGroupName", valid_564270
  var valid_564271 = path.getOrDefault("cloudEndpointName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "cloudEndpointName", valid_564271
  var valid_564272 = path.getOrDefault("subscriptionId")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "subscriptionId", valid_564272
  var valid_564273 = path.getOrDefault("resourceGroupName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "resourceGroupName", valid_564273
  var valid_564274 = path.getOrDefault("storageSyncServiceName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "storageSyncServiceName", valid_564274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564275 = query.getOrDefault("api-version")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "api-version", valid_564275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564276: Call_CloudEndpointsGet_564267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a given CloudEndpoint.
  ## 
  let valid = call_564276.validator(path, query, header, formData, body)
  let scheme = call_564276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564276.url(scheme.get, call_564276.host, call_564276.base,
                         call_564276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564276, url, valid)

proc call*(call_564277: Call_CloudEndpointsGet_564267; syncGroupName: string;
          apiVersion: string; cloudEndpointName: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string): Recallable =
  ## cloudEndpointsGet
  ## Get a given CloudEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564278 = newJObject()
  var query_564279 = newJObject()
  add(path_564278, "syncGroupName", newJString(syncGroupName))
  add(query_564279, "api-version", newJString(apiVersion))
  add(path_564278, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_564278, "subscriptionId", newJString(subscriptionId))
  add(path_564278, "resourceGroupName", newJString(resourceGroupName))
  add(path_564278, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564277.call(path_564278, query_564279, nil, nil, nil)

var cloudEndpointsGet* = Call_CloudEndpointsGet_564267(name: "cloudEndpointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}",
    validator: validate_CloudEndpointsGet_564268, base: "",
    url: url_CloudEndpointsGet_564269, schemes: {Scheme.Https})
type
  Call_CloudEndpointsDelete_564295 = ref object of OpenApiRestCall_563556
proc url_CloudEndpointsDelete_564297(protocol: Scheme; host: string; base: string;
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

proc validate_CloudEndpointsDelete_564296(path: JsonNode; query: JsonNode;
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
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564298 = path.getOrDefault("syncGroupName")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "syncGroupName", valid_564298
  var valid_564299 = path.getOrDefault("cloudEndpointName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "cloudEndpointName", valid_564299
  var valid_564300 = path.getOrDefault("subscriptionId")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "subscriptionId", valid_564300
  var valid_564301 = path.getOrDefault("resourceGroupName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "resourceGroupName", valid_564301
  var valid_564302 = path.getOrDefault("storageSyncServiceName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "storageSyncServiceName", valid_564302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564303 = query.getOrDefault("api-version")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "api-version", valid_564303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564304: Call_CloudEndpointsDelete_564295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a given CloudEndpoint.
  ## 
  let valid = call_564304.validator(path, query, header, formData, body)
  let scheme = call_564304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564304.url(scheme.get, call_564304.host, call_564304.base,
                         call_564304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564304, url, valid)

proc call*(call_564305: Call_CloudEndpointsDelete_564295; syncGroupName: string;
          apiVersion: string; cloudEndpointName: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string): Recallable =
  ## cloudEndpointsDelete
  ## Delete a given CloudEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564306 = newJObject()
  var query_564307 = newJObject()
  add(path_564306, "syncGroupName", newJString(syncGroupName))
  add(query_564307, "api-version", newJString(apiVersion))
  add(path_564306, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_564306, "subscriptionId", newJString(subscriptionId))
  add(path_564306, "resourceGroupName", newJString(resourceGroupName))
  add(path_564306, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564305.call(path_564306, query_564307, nil, nil, nil)

var cloudEndpointsDelete* = Call_CloudEndpointsDelete_564295(
    name: "cloudEndpointsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}",
    validator: validate_CloudEndpointsDelete_564296, base: "",
    url: url_CloudEndpointsDelete_564297, schemes: {Scheme.Https})
type
  Call_CloudEndpointsPostBackup_564308 = ref object of OpenApiRestCall_563556
proc url_CloudEndpointsPostBackup_564310(protocol: Scheme; host: string;
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

proc validate_CloudEndpointsPostBackup_564309(path: JsonNode; query: JsonNode;
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
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
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
  var valid_564312 = path.getOrDefault("cloudEndpointName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "cloudEndpointName", valid_564312
  var valid_564313 = path.getOrDefault("subscriptionId")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "subscriptionId", valid_564313
  var valid_564314 = path.getOrDefault("resourceGroupName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "resourceGroupName", valid_564314
  var valid_564315 = path.getOrDefault("storageSyncServiceName")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "storageSyncServiceName", valid_564315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564316 = query.getOrDefault("api-version")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "api-version", valid_564316
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

proc call*(call_564318: Call_CloudEndpointsPostBackup_564308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Post Backup a given CloudEndpoint.
  ## 
  let valid = call_564318.validator(path, query, header, formData, body)
  let scheme = call_564318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564318.url(scheme.get, call_564318.host, call_564318.base,
                         call_564318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564318, url, valid)

proc call*(call_564319: Call_CloudEndpointsPostBackup_564308;
          syncGroupName: string; apiVersion: string; cloudEndpointName: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string; parameters: JsonNode): Recallable =
  ## cloudEndpointsPostBackup
  ## Post Backup a given CloudEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Body of Backup request.
  var path_564320 = newJObject()
  var query_564321 = newJObject()
  var body_564322 = newJObject()
  add(path_564320, "syncGroupName", newJString(syncGroupName))
  add(query_564321, "api-version", newJString(apiVersion))
  add(path_564320, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_564320, "subscriptionId", newJString(subscriptionId))
  add(path_564320, "resourceGroupName", newJString(resourceGroupName))
  add(path_564320, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564322 = parameters
  result = call_564319.call(path_564320, query_564321, nil, nil, body_564322)

var cloudEndpointsPostBackup* = Call_CloudEndpointsPostBackup_564308(
    name: "cloudEndpointsPostBackup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/postbackup",
    validator: validate_CloudEndpointsPostBackup_564309, base: "",
    url: url_CloudEndpointsPostBackup_564310, schemes: {Scheme.Https})
type
  Call_CloudEndpointsPostRestore_564323 = ref object of OpenApiRestCall_563556
proc url_CloudEndpointsPostRestore_564325(protocol: Scheme; host: string;
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

proc validate_CloudEndpointsPostRestore_564324(path: JsonNode; query: JsonNode;
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
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564326 = path.getOrDefault("syncGroupName")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "syncGroupName", valid_564326
  var valid_564327 = path.getOrDefault("cloudEndpointName")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "cloudEndpointName", valid_564327
  var valid_564328 = path.getOrDefault("subscriptionId")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "subscriptionId", valid_564328
  var valid_564329 = path.getOrDefault("resourceGroupName")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "resourceGroupName", valid_564329
  var valid_564330 = path.getOrDefault("storageSyncServiceName")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "storageSyncServiceName", valid_564330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564331 = query.getOrDefault("api-version")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "api-version", valid_564331
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

proc call*(call_564333: Call_CloudEndpointsPostRestore_564323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Post Restore a given CloudEndpoint.
  ## 
  let valid = call_564333.validator(path, query, header, formData, body)
  let scheme = call_564333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564333.url(scheme.get, call_564333.host, call_564333.base,
                         call_564333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564333, url, valid)

proc call*(call_564334: Call_CloudEndpointsPostRestore_564323;
          syncGroupName: string; apiVersion: string; cloudEndpointName: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string; parameters: JsonNode): Recallable =
  ## cloudEndpointsPostRestore
  ## Post Restore a given CloudEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Body of Cloud Endpoint object.
  var path_564335 = newJObject()
  var query_564336 = newJObject()
  var body_564337 = newJObject()
  add(path_564335, "syncGroupName", newJString(syncGroupName))
  add(query_564336, "api-version", newJString(apiVersion))
  add(path_564335, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_564335, "subscriptionId", newJString(subscriptionId))
  add(path_564335, "resourceGroupName", newJString(resourceGroupName))
  add(path_564335, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564337 = parameters
  result = call_564334.call(path_564335, query_564336, nil, nil, body_564337)

var cloudEndpointsPostRestore* = Call_CloudEndpointsPostRestore_564323(
    name: "cloudEndpointsPostRestore", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/postrestore",
    validator: validate_CloudEndpointsPostRestore_564324, base: "",
    url: url_CloudEndpointsPostRestore_564325, schemes: {Scheme.Https})
type
  Call_CloudEndpointsPreBackup_564338 = ref object of OpenApiRestCall_563556
proc url_CloudEndpointsPreBackup_564340(protocol: Scheme; host: string; base: string;
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

proc validate_CloudEndpointsPreBackup_564339(path: JsonNode; query: JsonNode;
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
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564341 = path.getOrDefault("syncGroupName")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "syncGroupName", valid_564341
  var valid_564342 = path.getOrDefault("cloudEndpointName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "cloudEndpointName", valid_564342
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
  var valid_564345 = path.getOrDefault("storageSyncServiceName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "storageSyncServiceName", valid_564345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564346 = query.getOrDefault("api-version")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "api-version", valid_564346
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

proc call*(call_564348: Call_CloudEndpointsPreBackup_564338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pre Backup a given CloudEndpoint.
  ## 
  let valid = call_564348.validator(path, query, header, formData, body)
  let scheme = call_564348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564348.url(scheme.get, call_564348.host, call_564348.base,
                         call_564348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564348, url, valid)

proc call*(call_564349: Call_CloudEndpointsPreBackup_564338; syncGroupName: string;
          apiVersion: string; cloudEndpointName: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string;
          parameters: JsonNode): Recallable =
  ## cloudEndpointsPreBackup
  ## Pre Backup a given CloudEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Body of Backup request.
  var path_564350 = newJObject()
  var query_564351 = newJObject()
  var body_564352 = newJObject()
  add(path_564350, "syncGroupName", newJString(syncGroupName))
  add(query_564351, "api-version", newJString(apiVersion))
  add(path_564350, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_564350, "subscriptionId", newJString(subscriptionId))
  add(path_564350, "resourceGroupName", newJString(resourceGroupName))
  add(path_564350, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564352 = parameters
  result = call_564349.call(path_564350, query_564351, nil, nil, body_564352)

var cloudEndpointsPreBackup* = Call_CloudEndpointsPreBackup_564338(
    name: "cloudEndpointsPreBackup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/prebackup",
    validator: validate_CloudEndpointsPreBackup_564339, base: "",
    url: url_CloudEndpointsPreBackup_564340, schemes: {Scheme.Https})
type
  Call_CloudEndpointsPreRestore_564353 = ref object of OpenApiRestCall_563556
proc url_CloudEndpointsPreRestore_564355(protocol: Scheme; host: string;
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

proc validate_CloudEndpointsPreRestore_564354(path: JsonNode; query: JsonNode;
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
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564356 = path.getOrDefault("syncGroupName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "syncGroupName", valid_564356
  var valid_564357 = path.getOrDefault("cloudEndpointName")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "cloudEndpointName", valid_564357
  var valid_564358 = path.getOrDefault("subscriptionId")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "subscriptionId", valid_564358
  var valid_564359 = path.getOrDefault("resourceGroupName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "resourceGroupName", valid_564359
  var valid_564360 = path.getOrDefault("storageSyncServiceName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "storageSyncServiceName", valid_564360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564361 = query.getOrDefault("api-version")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "api-version", valid_564361
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

proc call*(call_564363: Call_CloudEndpointsPreRestore_564353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pre Restore a given CloudEndpoint.
  ## 
  let valid = call_564363.validator(path, query, header, formData, body)
  let scheme = call_564363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564363.url(scheme.get, call_564363.host, call_564363.base,
                         call_564363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564363, url, valid)

proc call*(call_564364: Call_CloudEndpointsPreRestore_564353;
          syncGroupName: string; apiVersion: string; cloudEndpointName: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string; parameters: JsonNode): Recallable =
  ## cloudEndpointsPreRestore
  ## Pre Restore a given CloudEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Body of Cloud Endpoint object.
  var path_564365 = newJObject()
  var query_564366 = newJObject()
  var body_564367 = newJObject()
  add(path_564365, "syncGroupName", newJString(syncGroupName))
  add(query_564366, "api-version", newJString(apiVersion))
  add(path_564365, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_564365, "subscriptionId", newJString(subscriptionId))
  add(path_564365, "resourceGroupName", newJString(resourceGroupName))
  add(path_564365, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564367 = parameters
  result = call_564364.call(path_564365, query_564366, nil, nil, body_564367)

var cloudEndpointsPreRestore* = Call_CloudEndpointsPreRestore_564353(
    name: "cloudEndpointsPreRestore", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/prerestore",
    validator: validate_CloudEndpointsPreRestore_564354, base: "",
    url: url_CloudEndpointsPreRestore_564355, schemes: {Scheme.Https})
type
  Call_CloudEndpointsRestoreHeatbeat_564368 = ref object of OpenApiRestCall_563556
proc url_CloudEndpointsRestoreHeatbeat_564370(protocol: Scheme; host: string;
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

proc validate_CloudEndpointsRestoreHeatbeat_564369(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564371 = path.getOrDefault("syncGroupName")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "syncGroupName", valid_564371
  var valid_564372 = path.getOrDefault("cloudEndpointName")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "cloudEndpointName", valid_564372
  var valid_564373 = path.getOrDefault("subscriptionId")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "subscriptionId", valid_564373
  var valid_564374 = path.getOrDefault("resourceGroupName")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "resourceGroupName", valid_564374
  var valid_564375 = path.getOrDefault("storageSyncServiceName")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "storageSyncServiceName", valid_564375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564376 = query.getOrDefault("api-version")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "api-version", valid_564376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564377: Call_CloudEndpointsRestoreHeatbeat_564368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restore Heartbeat a given CloudEndpoint.
  ## 
  let valid = call_564377.validator(path, query, header, formData, body)
  let scheme = call_564377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564377.url(scheme.get, call_564377.host, call_564377.base,
                         call_564377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564377, url, valid)

proc call*(call_564378: Call_CloudEndpointsRestoreHeatbeat_564368;
          syncGroupName: string; apiVersion: string; cloudEndpointName: string;
          subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## cloudEndpointsRestoreHeatbeat
  ## Restore Heartbeat a given CloudEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   cloudEndpointName: string (required)
  ##                    : Name of Cloud Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564379 = newJObject()
  var query_564380 = newJObject()
  add(path_564379, "syncGroupName", newJString(syncGroupName))
  add(query_564380, "api-version", newJString(apiVersion))
  add(path_564379, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_564379, "subscriptionId", newJString(subscriptionId))
  add(path_564379, "resourceGroupName", newJString(resourceGroupName))
  add(path_564379, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564378.call(path_564379, query_564380, nil, nil, nil)

var cloudEndpointsRestoreHeatbeat* = Call_CloudEndpointsRestoreHeatbeat_564368(
    name: "cloudEndpointsRestoreHeatbeat", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/restoreheartbeat",
    validator: validate_CloudEndpointsRestoreHeatbeat_564369, base: "",
    url: url_CloudEndpointsRestoreHeatbeat_564370, schemes: {Scheme.Https})
type
  Call_ServerEndpointsListBySyncGroup_564381 = ref object of OpenApiRestCall_563556
proc url_ServerEndpointsListBySyncGroup_564383(protocol: Scheme; host: string;
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

proc validate_ServerEndpointsListBySyncGroup_564382(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a ServerEndpoint list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   syncGroupName: JString (required)
  ##                : Name of Sync Group resource.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564384 = path.getOrDefault("syncGroupName")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "syncGroupName", valid_564384
  var valid_564385 = path.getOrDefault("subscriptionId")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "subscriptionId", valid_564385
  var valid_564386 = path.getOrDefault("resourceGroupName")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "resourceGroupName", valid_564386
  var valid_564387 = path.getOrDefault("storageSyncServiceName")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "storageSyncServiceName", valid_564387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564388 = query.getOrDefault("api-version")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "api-version", valid_564388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564389: Call_ServerEndpointsListBySyncGroup_564381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a ServerEndpoint list.
  ## 
  let valid = call_564389.validator(path, query, header, formData, body)
  let scheme = call_564389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564389.url(scheme.get, call_564389.host, call_564389.base,
                         call_564389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564389, url, valid)

proc call*(call_564390: Call_ServerEndpointsListBySyncGroup_564381;
          syncGroupName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string): Recallable =
  ## serverEndpointsListBySyncGroup
  ## Get a ServerEndpoint list.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564391 = newJObject()
  var query_564392 = newJObject()
  add(path_564391, "syncGroupName", newJString(syncGroupName))
  add(query_564392, "api-version", newJString(apiVersion))
  add(path_564391, "subscriptionId", newJString(subscriptionId))
  add(path_564391, "resourceGroupName", newJString(resourceGroupName))
  add(path_564391, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564390.call(path_564391, query_564392, nil, nil, nil)

var serverEndpointsListBySyncGroup* = Call_ServerEndpointsListBySyncGroup_564381(
    name: "serverEndpointsListBySyncGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints",
    validator: validate_ServerEndpointsListBySyncGroup_564382, base: "",
    url: url_ServerEndpointsListBySyncGroup_564383, schemes: {Scheme.Https})
type
  Call_ServerEndpointsCreate_564406 = ref object of OpenApiRestCall_563556
proc url_ServerEndpointsCreate_564408(protocol: Scheme; host: string; base: string;
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

proc validate_ServerEndpointsCreate_564407(path: JsonNode; query: JsonNode;
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
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564409 = path.getOrDefault("syncGroupName")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "syncGroupName", valid_564409
  var valid_564410 = path.getOrDefault("serverEndpointName")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "serverEndpointName", valid_564410
  var valid_564411 = path.getOrDefault("subscriptionId")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "subscriptionId", valid_564411
  var valid_564412 = path.getOrDefault("resourceGroupName")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "resourceGroupName", valid_564412
  var valid_564413 = path.getOrDefault("storageSyncServiceName")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "storageSyncServiceName", valid_564413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564414 = query.getOrDefault("api-version")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "api-version", valid_564414
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

proc call*(call_564416: Call_ServerEndpointsCreate_564406; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new ServerEndpoint.
  ## 
  let valid = call_564416.validator(path, query, header, formData, body)
  let scheme = call_564416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564416.url(scheme.get, call_564416.host, call_564416.base,
                         call_564416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564416, url, valid)

proc call*(call_564417: Call_ServerEndpointsCreate_564406; syncGroupName: string;
          apiVersion: string; serverEndpointName: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string;
          parameters: JsonNode): Recallable =
  ## serverEndpointsCreate
  ## Create a new ServerEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   serverEndpointName: string (required)
  ##                     : Name of Server Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject (required)
  ##             : Body of Server Endpoint object.
  var path_564418 = newJObject()
  var query_564419 = newJObject()
  var body_564420 = newJObject()
  add(path_564418, "syncGroupName", newJString(syncGroupName))
  add(query_564419, "api-version", newJString(apiVersion))
  add(path_564418, "serverEndpointName", newJString(serverEndpointName))
  add(path_564418, "subscriptionId", newJString(subscriptionId))
  add(path_564418, "resourceGroupName", newJString(resourceGroupName))
  add(path_564418, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564420 = parameters
  result = call_564417.call(path_564418, query_564419, nil, nil, body_564420)

var serverEndpointsCreate* = Call_ServerEndpointsCreate_564406(
    name: "serverEndpointsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}",
    validator: validate_ServerEndpointsCreate_564407, base: "",
    url: url_ServerEndpointsCreate_564408, schemes: {Scheme.Https})
type
  Call_ServerEndpointsGet_564393 = ref object of OpenApiRestCall_563556
proc url_ServerEndpointsGet_564395(protocol: Scheme; host: string; base: string;
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

proc validate_ServerEndpointsGet_564394(path: JsonNode; query: JsonNode;
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
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564396 = path.getOrDefault("syncGroupName")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "syncGroupName", valid_564396
  var valid_564397 = path.getOrDefault("serverEndpointName")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "serverEndpointName", valid_564397
  var valid_564398 = path.getOrDefault("subscriptionId")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "subscriptionId", valid_564398
  var valid_564399 = path.getOrDefault("resourceGroupName")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "resourceGroupName", valid_564399
  var valid_564400 = path.getOrDefault("storageSyncServiceName")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "storageSyncServiceName", valid_564400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564401 = query.getOrDefault("api-version")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "api-version", valid_564401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564402: Call_ServerEndpointsGet_564393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a ServerEndpoint.
  ## 
  let valid = call_564402.validator(path, query, header, formData, body)
  let scheme = call_564402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564402.url(scheme.get, call_564402.host, call_564402.base,
                         call_564402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564402, url, valid)

proc call*(call_564403: Call_ServerEndpointsGet_564393; syncGroupName: string;
          apiVersion: string; serverEndpointName: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string): Recallable =
  ## serverEndpointsGet
  ## Get a ServerEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   serverEndpointName: string (required)
  ##                     : Name of Server Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564404 = newJObject()
  var query_564405 = newJObject()
  add(path_564404, "syncGroupName", newJString(syncGroupName))
  add(query_564405, "api-version", newJString(apiVersion))
  add(path_564404, "serverEndpointName", newJString(serverEndpointName))
  add(path_564404, "subscriptionId", newJString(subscriptionId))
  add(path_564404, "resourceGroupName", newJString(resourceGroupName))
  add(path_564404, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564403.call(path_564404, query_564405, nil, nil, nil)

var serverEndpointsGet* = Call_ServerEndpointsGet_564393(
    name: "serverEndpointsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}",
    validator: validate_ServerEndpointsGet_564394, base: "",
    url: url_ServerEndpointsGet_564395, schemes: {Scheme.Https})
type
  Call_ServerEndpointsUpdate_564434 = ref object of OpenApiRestCall_563556
proc url_ServerEndpointsUpdate_564436(protocol: Scheme; host: string; base: string;
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

proc validate_ServerEndpointsUpdate_564435(path: JsonNode; query: JsonNode;
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
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564437 = path.getOrDefault("syncGroupName")
  valid_564437 = validateParameter(valid_564437, JString, required = true,
                                 default = nil)
  if valid_564437 != nil:
    section.add "syncGroupName", valid_564437
  var valid_564438 = path.getOrDefault("serverEndpointName")
  valid_564438 = validateParameter(valid_564438, JString, required = true,
                                 default = nil)
  if valid_564438 != nil:
    section.add "serverEndpointName", valid_564438
  var valid_564439 = path.getOrDefault("subscriptionId")
  valid_564439 = validateParameter(valid_564439, JString, required = true,
                                 default = nil)
  if valid_564439 != nil:
    section.add "subscriptionId", valid_564439
  var valid_564440 = path.getOrDefault("resourceGroupName")
  valid_564440 = validateParameter(valid_564440, JString, required = true,
                                 default = nil)
  if valid_564440 != nil:
    section.add "resourceGroupName", valid_564440
  var valid_564441 = path.getOrDefault("storageSyncServiceName")
  valid_564441 = validateParameter(valid_564441, JString, required = true,
                                 default = nil)
  if valid_564441 != nil:
    section.add "storageSyncServiceName", valid_564441
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564442 = query.getOrDefault("api-version")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "api-version", valid_564442
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

proc call*(call_564444: Call_ServerEndpointsUpdate_564434; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a given ServerEndpoint.
  ## 
  let valid = call_564444.validator(path, query, header, formData, body)
  let scheme = call_564444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564444.url(scheme.get, call_564444.host, call_564444.base,
                         call_564444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564444, url, valid)

proc call*(call_564445: Call_ServerEndpointsUpdate_564434; syncGroupName: string;
          apiVersion: string; serverEndpointName: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string;
          parameters: JsonNode = nil): Recallable =
  ## serverEndpointsUpdate
  ## Patch a given ServerEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   serverEndpointName: string (required)
  ##                     : Name of Server Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  ##   parameters: JObject
  ##             : Any of the properties applicable in PUT request.
  var path_564446 = newJObject()
  var query_564447 = newJObject()
  var body_564448 = newJObject()
  add(path_564446, "syncGroupName", newJString(syncGroupName))
  add(query_564447, "api-version", newJString(apiVersion))
  add(path_564446, "serverEndpointName", newJString(serverEndpointName))
  add(path_564446, "subscriptionId", newJString(subscriptionId))
  add(path_564446, "resourceGroupName", newJString(resourceGroupName))
  add(path_564446, "storageSyncServiceName", newJString(storageSyncServiceName))
  if parameters != nil:
    body_564448 = parameters
  result = call_564445.call(path_564446, query_564447, nil, nil, body_564448)

var serverEndpointsUpdate* = Call_ServerEndpointsUpdate_564434(
    name: "serverEndpointsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}",
    validator: validate_ServerEndpointsUpdate_564435, base: "",
    url: url_ServerEndpointsUpdate_564436, schemes: {Scheme.Https})
type
  Call_ServerEndpointsDelete_564421 = ref object of OpenApiRestCall_563556
proc url_ServerEndpointsDelete_564423(protocol: Scheme; host: string; base: string;
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

proc validate_ServerEndpointsDelete_564422(path: JsonNode; query: JsonNode;
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
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564424 = path.getOrDefault("syncGroupName")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "syncGroupName", valid_564424
  var valid_564425 = path.getOrDefault("serverEndpointName")
  valid_564425 = validateParameter(valid_564425, JString, required = true,
                                 default = nil)
  if valid_564425 != nil:
    section.add "serverEndpointName", valid_564425
  var valid_564426 = path.getOrDefault("subscriptionId")
  valid_564426 = validateParameter(valid_564426, JString, required = true,
                                 default = nil)
  if valid_564426 != nil:
    section.add "subscriptionId", valid_564426
  var valid_564427 = path.getOrDefault("resourceGroupName")
  valid_564427 = validateParameter(valid_564427, JString, required = true,
                                 default = nil)
  if valid_564427 != nil:
    section.add "resourceGroupName", valid_564427
  var valid_564428 = path.getOrDefault("storageSyncServiceName")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "storageSyncServiceName", valid_564428
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564429 = query.getOrDefault("api-version")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "api-version", valid_564429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564430: Call_ServerEndpointsDelete_564421; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a given ServerEndpoint.
  ## 
  let valid = call_564430.validator(path, query, header, formData, body)
  let scheme = call_564430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564430.url(scheme.get, call_564430.host, call_564430.base,
                         call_564430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564430, url, valid)

proc call*(call_564431: Call_ServerEndpointsDelete_564421; syncGroupName: string;
          apiVersion: string; serverEndpointName: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string): Recallable =
  ## serverEndpointsDelete
  ## Delete a given ServerEndpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   serverEndpointName: string (required)
  ##                     : Name of Server Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564432 = newJObject()
  var query_564433 = newJObject()
  add(path_564432, "syncGroupName", newJString(syncGroupName))
  add(query_564433, "api-version", newJString(apiVersion))
  add(path_564432, "serverEndpointName", newJString(serverEndpointName))
  add(path_564432, "subscriptionId", newJString(subscriptionId))
  add(path_564432, "resourceGroupName", newJString(resourceGroupName))
  add(path_564432, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564431.call(path_564432, query_564433, nil, nil, nil)

var serverEndpointsDelete* = Call_ServerEndpointsDelete_564421(
    name: "serverEndpointsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}",
    validator: validate_ServerEndpointsDelete_564422, base: "",
    url: url_ServerEndpointsDelete_564423, schemes: {Scheme.Https})
type
  Call_ServerEndpointsRecall_564449 = ref object of OpenApiRestCall_563556
proc url_ServerEndpointsRecall_564451(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "serverEndpointName"),
               (kind: ConstantSegment, value: "/recallAction")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerEndpointsRecall_564450(path: JsonNode; query: JsonNode;
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
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `syncGroupName` field"
  var valid_564452 = path.getOrDefault("syncGroupName")
  valid_564452 = validateParameter(valid_564452, JString, required = true,
                                 default = nil)
  if valid_564452 != nil:
    section.add "syncGroupName", valid_564452
  var valid_564453 = path.getOrDefault("serverEndpointName")
  valid_564453 = validateParameter(valid_564453, JString, required = true,
                                 default = nil)
  if valid_564453 != nil:
    section.add "serverEndpointName", valid_564453
  var valid_564454 = path.getOrDefault("subscriptionId")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "subscriptionId", valid_564454
  var valid_564455 = path.getOrDefault("resourceGroupName")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "resourceGroupName", valid_564455
  var valid_564456 = path.getOrDefault("storageSyncServiceName")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "storageSyncServiceName", valid_564456
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564458: Call_ServerEndpointsRecall_564449; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recall a server endpoint.
  ## 
  let valid = call_564458.validator(path, query, header, formData, body)
  let scheme = call_564458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564458.url(scheme.get, call_564458.host, call_564458.base,
                         call_564458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564458, url, valid)

proc call*(call_564459: Call_ServerEndpointsRecall_564449; syncGroupName: string;
          apiVersion: string; serverEndpointName: string; subscriptionId: string;
          resourceGroupName: string; storageSyncServiceName: string): Recallable =
  ## serverEndpointsRecall
  ## Recall a server endpoint.
  ##   syncGroupName: string (required)
  ##                : Name of Sync Group resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   serverEndpointName: string (required)
  ##                     : Name of Server Endpoint object.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564460 = newJObject()
  var query_564461 = newJObject()
  add(path_564460, "syncGroupName", newJString(syncGroupName))
  add(query_564461, "api-version", newJString(apiVersion))
  add(path_564460, "serverEndpointName", newJString(serverEndpointName))
  add(path_564460, "subscriptionId", newJString(subscriptionId))
  add(path_564460, "resourceGroupName", newJString(resourceGroupName))
  add(path_564460, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564459.call(path_564460, query_564461, nil, nil, nil)

var serverEndpointsRecall* = Call_ServerEndpointsRecall_564449(
    name: "serverEndpointsRecall", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}/recallAction",
    validator: validate_ServerEndpointsRecall_564450, base: "",
    url: url_ServerEndpointsRecall_564451, schemes: {Scheme.Https})
type
  Call_WorkflowsGet_564462 = ref object of OpenApiRestCall_563556
proc url_WorkflowsGet_564464(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsGet_564463(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Workflows resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workflowId: JString (required)
  ##             : workflow Id
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowId` field"
  var valid_564465 = path.getOrDefault("workflowId")
  valid_564465 = validateParameter(valid_564465, JString, required = true,
                                 default = nil)
  if valid_564465 != nil:
    section.add "workflowId", valid_564465
  var valid_564466 = path.getOrDefault("subscriptionId")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "subscriptionId", valid_564466
  var valid_564467 = path.getOrDefault("resourceGroupName")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "resourceGroupName", valid_564467
  var valid_564468 = path.getOrDefault("storageSyncServiceName")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "storageSyncServiceName", valid_564468
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564469 = query.getOrDefault("api-version")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "api-version", valid_564469
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564470: Call_WorkflowsGet_564462; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Workflows resource
  ## 
  let valid = call_564470.validator(path, query, header, formData, body)
  let scheme = call_564470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564470.url(scheme.get, call_564470.host, call_564470.base,
                         call_564470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564470, url, valid)

proc call*(call_564471: Call_WorkflowsGet_564462; workflowId: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## workflowsGet
  ## Get Workflows resource
  ##   workflowId: string (required)
  ##             : workflow Id
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564472 = newJObject()
  var query_564473 = newJObject()
  add(path_564472, "workflowId", newJString(workflowId))
  add(query_564473, "api-version", newJString(apiVersion))
  add(path_564472, "subscriptionId", newJString(subscriptionId))
  add(path_564472, "resourceGroupName", newJString(resourceGroupName))
  add(path_564472, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564471.call(path_564472, query_564473, nil, nil, nil)

var workflowsGet* = Call_WorkflowsGet_564462(name: "workflowsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/workflows/{workflowId}",
    validator: validate_WorkflowsGet_564463, base: "", url: url_WorkflowsGet_564464,
    schemes: {Scheme.Https})
type
  Call_WorkflowsAbort_564474 = ref object of OpenApiRestCall_563556
proc url_WorkflowsAbort_564476(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsAbort_564475(path: JsonNode; query: JsonNode;
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
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: JString (required)
  ##                         : Name of Storage Sync Service resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `workflowId` field"
  var valid_564477 = path.getOrDefault("workflowId")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "workflowId", valid_564477
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
  ##              : Client Api Version.
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

proc call*(call_564482: Call_WorkflowsAbort_564474; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Abort the given workflow.
  ## 
  let valid = call_564482.validator(path, query, header, formData, body)
  let scheme = call_564482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564482.url(scheme.get, call_564482.host, call_564482.base,
                         call_564482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564482, url, valid)

proc call*(call_564483: Call_WorkflowsAbort_564474; workflowId: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          storageSyncServiceName: string): Recallable =
  ## workflowsAbort
  ## Abort the given workflow.
  ##   workflowId: string (required)
  ##             : workflow Id
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   storageSyncServiceName: string (required)
  ##                         : Name of Storage Sync Service resource.
  var path_564484 = newJObject()
  var query_564485 = newJObject()
  add(path_564484, "workflowId", newJString(workflowId))
  add(query_564485, "api-version", newJString(apiVersion))
  add(path_564484, "subscriptionId", newJString(subscriptionId))
  add(path_564484, "resourceGroupName", newJString(resourceGroupName))
  add(path_564484, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_564483.call(path_564484, query_564485, nil, nil, nil)

var workflowsAbort* = Call_WorkflowsAbort_564474(name: "workflowsAbort",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/workflows/{workflowId}/abort",
    validator: validate_WorkflowsAbort_564475, base: "", url: url_WorkflowsAbort_564476,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
