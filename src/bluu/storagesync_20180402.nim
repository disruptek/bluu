
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Microsoft Storage Sync
## version: 2018-04-02
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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
  macServiceName = "storagesync"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593660 = ref object of OpenApiRestCall_593438
proc url_OperationsList_593662(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593661(path: JsonNode; query: JsonNode;
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
  var valid_593808 = query.getOrDefault("api-version")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "api-version", valid_593808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593835: Call_OperationsList_593660; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Storage Sync Rest API operations.
  ## 
  let valid = call_593835.validator(path, query, header, formData, body)
  let scheme = call_593835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593835.url(scheme.get, call_593835.host, call_593835.base,
                         call_593835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593835, url, valid)

proc call*(call_593906: Call_OperationsList_593660; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Storage Sync Rest API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  var query_593907 = newJObject()
  add(query_593907, "api-version", newJString(apiVersion))
  result = call_593906.call(nil, query_593907, nil, nil, nil)

var operationsList* = Call_OperationsList_593660(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.StorageSync/operations",
    validator: validate_OperationsList_593661, base: "", url: url_OperationsList_593662,
    schemes: {Scheme.Https})
type
  Call_StorageSyncServicesCheckNameAvailability_593947 = ref object of OpenApiRestCall_593438
proc url_StorageSyncServicesCheckNameAvailability_593949(protocol: Scheme;
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

proc validate_StorageSyncServicesCheckNameAvailability_593948(path: JsonNode;
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
  var valid_593990 = path.getOrDefault("subscriptionId")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "subscriptionId", valid_593990
  var valid_593991 = path.getOrDefault("locationName")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "locationName", valid_593991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593992 = query.getOrDefault("api-version")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "api-version", valid_593992
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

proc call*(call_593994: Call_StorageSyncServicesCheckNameAvailability_593947;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the give namespace name availability.
  ## 
  let valid = call_593994.validator(path, query, header, formData, body)
  let scheme = call_593994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593994.url(scheme.get, call_593994.host, call_593994.base,
                         call_593994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593994, url, valid)

proc call*(call_593995: Call_StorageSyncServicesCheckNameAvailability_593947;
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
  var path_593996 = newJObject()
  var query_593997 = newJObject()
  var body_593998 = newJObject()
  add(query_593997, "api-version", newJString(apiVersion))
  add(path_593996, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593998 = parameters
  add(path_593996, "locationName", newJString(locationName))
  result = call_593995.call(path_593996, query_593997, nil, nil, body_593998)

var storageSyncServicesCheckNameAvailability* = Call_StorageSyncServicesCheckNameAvailability_593947(
    name: "storageSyncServicesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.StorageSync/locations/{locationName}/checkNameAvailability",
    validator: validate_StorageSyncServicesCheckNameAvailability_593948, base: "",
    url: url_StorageSyncServicesCheckNameAvailability_593949,
    schemes: {Scheme.Https})
type
  Call_StorageSyncServicesListBySubscription_593999 = ref object of OpenApiRestCall_593438
proc url_StorageSyncServicesListBySubscription_594001(protocol: Scheme;
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

proc validate_StorageSyncServicesListBySubscription_594000(path: JsonNode;
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
  var valid_594002 = path.getOrDefault("subscriptionId")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "subscriptionId", valid_594002
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594003 = query.getOrDefault("api-version")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "api-version", valid_594003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594004: Call_StorageSyncServicesListBySubscription_593999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a StorageSyncService list by subscription.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_StorageSyncServicesListBySubscription_593999;
          apiVersion: string; subscriptionId: string): Recallable =
  ## storageSyncServicesListBySubscription
  ## Get a StorageSyncService list by subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  add(query_594007, "api-version", newJString(apiVersion))
  add(path_594006, "subscriptionId", newJString(subscriptionId))
  result = call_594005.call(path_594006, query_594007, nil, nil, nil)

var storageSyncServicesListBySubscription* = Call_StorageSyncServicesListBySubscription_593999(
    name: "storageSyncServicesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.StorageSync/storageSyncServices",
    validator: validate_StorageSyncServicesListBySubscription_594000, base: "",
    url: url_StorageSyncServicesListBySubscription_594001, schemes: {Scheme.Https})
type
  Call_StorageSyncServicesListByResourceGroup_594008 = ref object of OpenApiRestCall_593438
proc url_StorageSyncServicesListByResourceGroup_594010(protocol: Scheme;
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

proc validate_StorageSyncServicesListByResourceGroup_594009(path: JsonNode;
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
  var valid_594011 = path.getOrDefault("resourceGroupName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "resourceGroupName", valid_594011
  var valid_594012 = path.getOrDefault("subscriptionId")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "subscriptionId", valid_594012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594013 = query.getOrDefault("api-version")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "api-version", valid_594013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594014: Call_StorageSyncServicesListByResourceGroup_594008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a StorageSyncService list by Resource group name.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_StorageSyncServicesListByResourceGroup_594008;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## storageSyncServicesListByResourceGroup
  ## Get a StorageSyncService list by Resource group name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  add(path_594016, "resourceGroupName", newJString(resourceGroupName))
  add(query_594017, "api-version", newJString(apiVersion))
  add(path_594016, "subscriptionId", newJString(subscriptionId))
  result = call_594015.call(path_594016, query_594017, nil, nil, nil)

var storageSyncServicesListByResourceGroup* = Call_StorageSyncServicesListByResourceGroup_594008(
    name: "storageSyncServicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices",
    validator: validate_StorageSyncServicesListByResourceGroup_594009, base: "",
    url: url_StorageSyncServicesListByResourceGroup_594010,
    schemes: {Scheme.Https})
type
  Call_StorageSyncServicesCreate_594029 = ref object of OpenApiRestCall_593438
proc url_StorageSyncServicesCreate_594031(protocol: Scheme; host: string;
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

proc validate_StorageSyncServicesCreate_594030(path: JsonNode; query: JsonNode;
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
  var valid_594032 = path.getOrDefault("resourceGroupName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "resourceGroupName", valid_594032
  var valid_594033 = path.getOrDefault("subscriptionId")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "subscriptionId", valid_594033
  var valid_594034 = path.getOrDefault("storageSyncServiceName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "storageSyncServiceName", valid_594034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Storage Sync Service resource name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_StorageSyncServicesCreate_594029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new StorageSyncService.
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_StorageSyncServicesCreate_594029;
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
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  var body_594041 = newJObject()
  add(path_594039, "resourceGroupName", newJString(resourceGroupName))
  add(query_594040, "api-version", newJString(apiVersion))
  add(path_594039, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594041 = parameters
  add(path_594039, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594038.call(path_594039, query_594040, nil, nil, body_594041)

var storageSyncServicesCreate* = Call_StorageSyncServicesCreate_594029(
    name: "storageSyncServicesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}",
    validator: validate_StorageSyncServicesCreate_594030, base: "",
    url: url_StorageSyncServicesCreate_594031, schemes: {Scheme.Https})
type
  Call_StorageSyncServicesGet_594018 = ref object of OpenApiRestCall_593438
proc url_StorageSyncServicesGet_594020(protocol: Scheme; host: string; base: string;
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

proc validate_StorageSyncServicesGet_594019(path: JsonNode; query: JsonNode;
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
  var valid_594021 = path.getOrDefault("resourceGroupName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "resourceGroupName", valid_594021
  var valid_594022 = path.getOrDefault("subscriptionId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "subscriptionId", valid_594022
  var valid_594023 = path.getOrDefault("storageSyncServiceName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "storageSyncServiceName", valid_594023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
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

proc call*(call_594025: Call_StorageSyncServicesGet_594018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a given StorageSyncService.
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_StorageSyncServicesGet_594018;
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
  var path_594027 = newJObject()
  var query_594028 = newJObject()
  add(path_594027, "resourceGroupName", newJString(resourceGroupName))
  add(query_594028, "api-version", newJString(apiVersion))
  add(path_594027, "subscriptionId", newJString(subscriptionId))
  add(path_594027, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594026.call(path_594027, query_594028, nil, nil, nil)

var storageSyncServicesGet* = Call_StorageSyncServicesGet_594018(
    name: "storageSyncServicesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}",
    validator: validate_StorageSyncServicesGet_594019, base: "",
    url: url_StorageSyncServicesGet_594020, schemes: {Scheme.Https})
type
  Call_StorageSyncServicesUpdate_594053 = ref object of OpenApiRestCall_593438
proc url_StorageSyncServicesUpdate_594055(protocol: Scheme; host: string;
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

proc validate_StorageSyncServicesUpdate_594054(path: JsonNode; query: JsonNode;
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
  var valid_594056 = path.getOrDefault("resourceGroupName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "resourceGroupName", valid_594056
  var valid_594057 = path.getOrDefault("subscriptionId")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "subscriptionId", valid_594057
  var valid_594058 = path.getOrDefault("storageSyncServiceName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "storageSyncServiceName", valid_594058
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594059 = query.getOrDefault("api-version")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "api-version", valid_594059
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

proc call*(call_594061: Call_StorageSyncServicesUpdate_594053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a given StorageSyncService.
  ## 
  let valid = call_594061.validator(path, query, header, formData, body)
  let scheme = call_594061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594061.url(scheme.get, call_594061.host, call_594061.base,
                         call_594061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594061, url, valid)

proc call*(call_594062: Call_StorageSyncServicesUpdate_594053;
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
  var path_594063 = newJObject()
  var query_594064 = newJObject()
  var body_594065 = newJObject()
  add(path_594063, "resourceGroupName", newJString(resourceGroupName))
  add(query_594064, "api-version", newJString(apiVersion))
  add(path_594063, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594065 = parameters
  add(path_594063, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594062.call(path_594063, query_594064, nil, nil, body_594065)

var storageSyncServicesUpdate* = Call_StorageSyncServicesUpdate_594053(
    name: "storageSyncServicesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}",
    validator: validate_StorageSyncServicesUpdate_594054, base: "",
    url: url_StorageSyncServicesUpdate_594055, schemes: {Scheme.Https})
type
  Call_StorageSyncServicesDelete_594042 = ref object of OpenApiRestCall_593438
proc url_StorageSyncServicesDelete_594044(protocol: Scheme; host: string;
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

proc validate_StorageSyncServicesDelete_594043(path: JsonNode; query: JsonNode;
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
  var valid_594045 = path.getOrDefault("resourceGroupName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "resourceGroupName", valid_594045
  var valid_594046 = path.getOrDefault("subscriptionId")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "subscriptionId", valid_594046
  var valid_594047 = path.getOrDefault("storageSyncServiceName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "storageSyncServiceName", valid_594047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594048 = query.getOrDefault("api-version")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "api-version", valid_594048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594049: Call_StorageSyncServicesDelete_594042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a given StorageSyncService.
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_StorageSyncServicesDelete_594042;
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
  var path_594051 = newJObject()
  var query_594052 = newJObject()
  add(path_594051, "resourceGroupName", newJString(resourceGroupName))
  add(query_594052, "api-version", newJString(apiVersion))
  add(path_594051, "subscriptionId", newJString(subscriptionId))
  add(path_594051, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594050.call(path_594051, query_594052, nil, nil, nil)

var storageSyncServicesDelete* = Call_StorageSyncServicesDelete_594042(
    name: "storageSyncServicesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}",
    validator: validate_StorageSyncServicesDelete_594043, base: "",
    url: url_StorageSyncServicesDelete_594044, schemes: {Scheme.Https})
type
  Call_RegisteredServersListByStorageSyncService_594066 = ref object of OpenApiRestCall_593438
proc url_RegisteredServersListByStorageSyncService_594068(protocol: Scheme;
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

proc validate_RegisteredServersListByStorageSyncService_594067(path: JsonNode;
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
  var valid_594069 = path.getOrDefault("resourceGroupName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "resourceGroupName", valid_594069
  var valid_594070 = path.getOrDefault("subscriptionId")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "subscriptionId", valid_594070
  var valid_594071 = path.getOrDefault("storageSyncServiceName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "storageSyncServiceName", valid_594071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594072 = query.getOrDefault("api-version")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "api-version", valid_594072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594073: Call_RegisteredServersListByStorageSyncService_594066;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a given registered server list.
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_RegisteredServersListByStorageSyncService_594066;
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
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  add(path_594075, "resourceGroupName", newJString(resourceGroupName))
  add(query_594076, "api-version", newJString(apiVersion))
  add(path_594075, "subscriptionId", newJString(subscriptionId))
  add(path_594075, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594074.call(path_594075, query_594076, nil, nil, nil)

var registeredServersListByStorageSyncService* = Call_RegisteredServersListByStorageSyncService_594066(
    name: "registeredServersListByStorageSyncService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers",
    validator: validate_RegisteredServersListByStorageSyncService_594067,
    base: "", url: url_RegisteredServersListByStorageSyncService_594068,
    schemes: {Scheme.Https})
type
  Call_RegisteredServersCreate_594089 = ref object of OpenApiRestCall_593438
proc url_RegisteredServersCreate_594091(protocol: Scheme; host: string; base: string;
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

proc validate_RegisteredServersCreate_594090(path: JsonNode; query: JsonNode;
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
  var valid_594092 = path.getOrDefault("resourceGroupName")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "resourceGroupName", valid_594092
  var valid_594093 = path.getOrDefault("subscriptionId")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "subscriptionId", valid_594093
  var valid_594094 = path.getOrDefault("serverId")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "serverId", valid_594094
  var valid_594095 = path.getOrDefault("storageSyncServiceName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "storageSyncServiceName", valid_594095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594096 = query.getOrDefault("api-version")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "api-version", valid_594096
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

proc call*(call_594098: Call_RegisteredServersCreate_594089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a new registered server.
  ## 
  let valid = call_594098.validator(path, query, header, formData, body)
  let scheme = call_594098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594098.url(scheme.get, call_594098.host, call_594098.base,
                         call_594098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594098, url, valid)

proc call*(call_594099: Call_RegisteredServersCreate_594089;
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
  var path_594100 = newJObject()
  var query_594101 = newJObject()
  var body_594102 = newJObject()
  add(path_594100, "resourceGroupName", newJString(resourceGroupName))
  add(query_594101, "api-version", newJString(apiVersion))
  add(path_594100, "subscriptionId", newJString(subscriptionId))
  add(path_594100, "serverId", newJString(serverId))
  if parameters != nil:
    body_594102 = parameters
  add(path_594100, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594099.call(path_594100, query_594101, nil, nil, body_594102)

var registeredServersCreate* = Call_RegisteredServersCreate_594089(
    name: "registeredServersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers/{serverId}",
    validator: validate_RegisteredServersCreate_594090, base: "",
    url: url_RegisteredServersCreate_594091, schemes: {Scheme.Https})
type
  Call_RegisteredServersGet_594077 = ref object of OpenApiRestCall_593438
proc url_RegisteredServersGet_594079(protocol: Scheme; host: string; base: string;
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

proc validate_RegisteredServersGet_594078(path: JsonNode; query: JsonNode;
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
  var valid_594080 = path.getOrDefault("resourceGroupName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "resourceGroupName", valid_594080
  var valid_594081 = path.getOrDefault("subscriptionId")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "subscriptionId", valid_594081
  var valid_594082 = path.getOrDefault("serverId")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "serverId", valid_594082
  var valid_594083 = path.getOrDefault("storageSyncServiceName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "storageSyncServiceName", valid_594083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594084 = query.getOrDefault("api-version")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "api-version", valid_594084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594085: Call_RegisteredServersGet_594077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a given registered server.
  ## 
  let valid = call_594085.validator(path, query, header, formData, body)
  let scheme = call_594085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594085.url(scheme.get, call_594085.host, call_594085.base,
                         call_594085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594085, url, valid)

proc call*(call_594086: Call_RegisteredServersGet_594077;
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
  var path_594087 = newJObject()
  var query_594088 = newJObject()
  add(path_594087, "resourceGroupName", newJString(resourceGroupName))
  add(query_594088, "api-version", newJString(apiVersion))
  add(path_594087, "subscriptionId", newJString(subscriptionId))
  add(path_594087, "serverId", newJString(serverId))
  add(path_594087, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594086.call(path_594087, query_594088, nil, nil, nil)

var registeredServersGet* = Call_RegisteredServersGet_594077(
    name: "registeredServersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers/{serverId}",
    validator: validate_RegisteredServersGet_594078, base: "",
    url: url_RegisteredServersGet_594079, schemes: {Scheme.Https})
type
  Call_RegisteredServersDelete_594103 = ref object of OpenApiRestCall_593438
proc url_RegisteredServersDelete_594105(protocol: Scheme; host: string; base: string;
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

proc validate_RegisteredServersDelete_594104(path: JsonNode; query: JsonNode;
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
  var valid_594106 = path.getOrDefault("resourceGroupName")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "resourceGroupName", valid_594106
  var valid_594107 = path.getOrDefault("subscriptionId")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "subscriptionId", valid_594107
  var valid_594108 = path.getOrDefault("serverId")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "serverId", valid_594108
  var valid_594109 = path.getOrDefault("storageSyncServiceName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "storageSyncServiceName", valid_594109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594110 = query.getOrDefault("api-version")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "api-version", valid_594110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594111: Call_RegisteredServersDelete_594103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the given registered server.
  ## 
  let valid = call_594111.validator(path, query, header, formData, body)
  let scheme = call_594111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594111.url(scheme.get, call_594111.host, call_594111.base,
                         call_594111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594111, url, valid)

proc call*(call_594112: Call_RegisteredServersDelete_594103;
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
  var path_594113 = newJObject()
  var query_594114 = newJObject()
  add(path_594113, "resourceGroupName", newJString(resourceGroupName))
  add(query_594114, "api-version", newJString(apiVersion))
  add(path_594113, "subscriptionId", newJString(subscriptionId))
  add(path_594113, "serverId", newJString(serverId))
  add(path_594113, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594112.call(path_594113, query_594114, nil, nil, nil)

var registeredServersDelete* = Call_RegisteredServersDelete_594103(
    name: "registeredServersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/registeredServers/{serverId}",
    validator: validate_RegisteredServersDelete_594104, base: "",
    url: url_RegisteredServersDelete_594105, schemes: {Scheme.Https})
type
  Call_SyncGroupsListByStorageSyncService_594115 = ref object of OpenApiRestCall_593438
proc url_SyncGroupsListByStorageSyncService_594117(protocol: Scheme; host: string;
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

proc validate_SyncGroupsListByStorageSyncService_594116(path: JsonNode;
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
  var valid_594118 = path.getOrDefault("resourceGroupName")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "resourceGroupName", valid_594118
  var valid_594119 = path.getOrDefault("subscriptionId")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "subscriptionId", valid_594119
  var valid_594120 = path.getOrDefault("storageSyncServiceName")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "storageSyncServiceName", valid_594120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594121 = query.getOrDefault("api-version")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "api-version", valid_594121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594122: Call_SyncGroupsListByStorageSyncService_594115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a SyncGroup List.
  ## 
  let valid = call_594122.validator(path, query, header, formData, body)
  let scheme = call_594122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594122.url(scheme.get, call_594122.host, call_594122.base,
                         call_594122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594122, url, valid)

proc call*(call_594123: Call_SyncGroupsListByStorageSyncService_594115;
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
  var path_594124 = newJObject()
  var query_594125 = newJObject()
  add(path_594124, "resourceGroupName", newJString(resourceGroupName))
  add(query_594125, "api-version", newJString(apiVersion))
  add(path_594124, "subscriptionId", newJString(subscriptionId))
  add(path_594124, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594123.call(path_594124, query_594125, nil, nil, nil)

var syncGroupsListByStorageSyncService* = Call_SyncGroupsListByStorageSyncService_594115(
    name: "syncGroupsListByStorageSyncService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups",
    validator: validate_SyncGroupsListByStorageSyncService_594116, base: "",
    url: url_SyncGroupsListByStorageSyncService_594117, schemes: {Scheme.Https})
type
  Call_SyncGroupsCreate_594138 = ref object of OpenApiRestCall_593438
proc url_SyncGroupsCreate_594140(protocol: Scheme; host: string; base: string;
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

proc validate_SyncGroupsCreate_594139(path: JsonNode; query: JsonNode;
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
  var valid_594141 = path.getOrDefault("resourceGroupName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "resourceGroupName", valid_594141
  var valid_594142 = path.getOrDefault("subscriptionId")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "subscriptionId", valid_594142
  var valid_594143 = path.getOrDefault("syncGroupName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "syncGroupName", valid_594143
  var valid_594144 = path.getOrDefault("storageSyncServiceName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "storageSyncServiceName", valid_594144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594145 = query.getOrDefault("api-version")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "api-version", valid_594145
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

proc call*(call_594147: Call_SyncGroupsCreate_594138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new SyncGroup.
  ## 
  let valid = call_594147.validator(path, query, header, formData, body)
  let scheme = call_594147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594147.url(scheme.get, call_594147.host, call_594147.base,
                         call_594147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594147, url, valid)

proc call*(call_594148: Call_SyncGroupsCreate_594138; resourceGroupName: string;
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
  var path_594149 = newJObject()
  var query_594150 = newJObject()
  var body_594151 = newJObject()
  add(path_594149, "resourceGroupName", newJString(resourceGroupName))
  add(query_594150, "api-version", newJString(apiVersion))
  add(path_594149, "subscriptionId", newJString(subscriptionId))
  add(path_594149, "syncGroupName", newJString(syncGroupName))
  if parameters != nil:
    body_594151 = parameters
  add(path_594149, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594148.call(path_594149, query_594150, nil, nil, body_594151)

var syncGroupsCreate* = Call_SyncGroupsCreate_594138(name: "syncGroupsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}",
    validator: validate_SyncGroupsCreate_594139, base: "",
    url: url_SyncGroupsCreate_594140, schemes: {Scheme.Https})
type
  Call_SyncGroupsGet_594126 = ref object of OpenApiRestCall_593438
proc url_SyncGroupsGet_594128(protocol: Scheme; host: string; base: string;
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

proc validate_SyncGroupsGet_594127(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594129 = path.getOrDefault("resourceGroupName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "resourceGroupName", valid_594129
  var valid_594130 = path.getOrDefault("subscriptionId")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "subscriptionId", valid_594130
  var valid_594131 = path.getOrDefault("syncGroupName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "syncGroupName", valid_594131
  var valid_594132 = path.getOrDefault("storageSyncServiceName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "storageSyncServiceName", valid_594132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594133 = query.getOrDefault("api-version")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "api-version", valid_594133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594134: Call_SyncGroupsGet_594126; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a given SyncGroup.
  ## 
  let valid = call_594134.validator(path, query, header, formData, body)
  let scheme = call_594134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594134.url(scheme.get, call_594134.host, call_594134.base,
                         call_594134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594134, url, valid)

proc call*(call_594135: Call_SyncGroupsGet_594126; resourceGroupName: string;
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
  var path_594136 = newJObject()
  var query_594137 = newJObject()
  add(path_594136, "resourceGroupName", newJString(resourceGroupName))
  add(query_594137, "api-version", newJString(apiVersion))
  add(path_594136, "subscriptionId", newJString(subscriptionId))
  add(path_594136, "syncGroupName", newJString(syncGroupName))
  add(path_594136, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594135.call(path_594136, query_594137, nil, nil, nil)

var syncGroupsGet* = Call_SyncGroupsGet_594126(name: "syncGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}",
    validator: validate_SyncGroupsGet_594127, base: "", url: url_SyncGroupsGet_594128,
    schemes: {Scheme.Https})
type
  Call_SyncGroupsDelete_594152 = ref object of OpenApiRestCall_593438
proc url_SyncGroupsDelete_594154(protocol: Scheme; host: string; base: string;
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

proc validate_SyncGroupsDelete_594153(path: JsonNode; query: JsonNode;
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
  var valid_594155 = path.getOrDefault("resourceGroupName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "resourceGroupName", valid_594155
  var valid_594156 = path.getOrDefault("subscriptionId")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "subscriptionId", valid_594156
  var valid_594157 = path.getOrDefault("syncGroupName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "syncGroupName", valid_594157
  var valid_594158 = path.getOrDefault("storageSyncServiceName")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "storageSyncServiceName", valid_594158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594159 = query.getOrDefault("api-version")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "api-version", valid_594159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594160: Call_SyncGroupsDelete_594152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a given SyncGroup.
  ## 
  let valid = call_594160.validator(path, query, header, formData, body)
  let scheme = call_594160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594160.url(scheme.get, call_594160.host, call_594160.base,
                         call_594160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594160, url, valid)

proc call*(call_594161: Call_SyncGroupsDelete_594152; resourceGroupName: string;
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
  var path_594162 = newJObject()
  var query_594163 = newJObject()
  add(path_594162, "resourceGroupName", newJString(resourceGroupName))
  add(query_594163, "api-version", newJString(apiVersion))
  add(path_594162, "subscriptionId", newJString(subscriptionId))
  add(path_594162, "syncGroupName", newJString(syncGroupName))
  add(path_594162, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594161.call(path_594162, query_594163, nil, nil, nil)

var syncGroupsDelete* = Call_SyncGroupsDelete_594152(name: "syncGroupsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}",
    validator: validate_SyncGroupsDelete_594153, base: "",
    url: url_SyncGroupsDelete_594154, schemes: {Scheme.Https})
type
  Call_CloudEndpointsListBySyncGroup_594164 = ref object of OpenApiRestCall_593438
proc url_CloudEndpointsListBySyncGroup_594166(protocol: Scheme; host: string;
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

proc validate_CloudEndpointsListBySyncGroup_594165(path: JsonNode; query: JsonNode;
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
  var valid_594167 = path.getOrDefault("resourceGroupName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "resourceGroupName", valid_594167
  var valid_594168 = path.getOrDefault("subscriptionId")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "subscriptionId", valid_594168
  var valid_594169 = path.getOrDefault("syncGroupName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "syncGroupName", valid_594169
  var valid_594170 = path.getOrDefault("storageSyncServiceName")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "storageSyncServiceName", valid_594170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594171 = query.getOrDefault("api-version")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "api-version", valid_594171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594172: Call_CloudEndpointsListBySyncGroup_594164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a CloudEndpoint List.
  ## 
  let valid = call_594172.validator(path, query, header, formData, body)
  let scheme = call_594172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594172.url(scheme.get, call_594172.host, call_594172.base,
                         call_594172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594172, url, valid)

proc call*(call_594173: Call_CloudEndpointsListBySyncGroup_594164;
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
  var path_594174 = newJObject()
  var query_594175 = newJObject()
  add(path_594174, "resourceGroupName", newJString(resourceGroupName))
  add(query_594175, "api-version", newJString(apiVersion))
  add(path_594174, "subscriptionId", newJString(subscriptionId))
  add(path_594174, "syncGroupName", newJString(syncGroupName))
  add(path_594174, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594173.call(path_594174, query_594175, nil, nil, nil)

var cloudEndpointsListBySyncGroup* = Call_CloudEndpointsListBySyncGroup_594164(
    name: "cloudEndpointsListBySyncGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints",
    validator: validate_CloudEndpointsListBySyncGroup_594165, base: "",
    url: url_CloudEndpointsListBySyncGroup_594166, schemes: {Scheme.Https})
type
  Call_CloudEndpointsCreate_594189 = ref object of OpenApiRestCall_593438
proc url_CloudEndpointsCreate_594191(protocol: Scheme; host: string; base: string;
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

proc validate_CloudEndpointsCreate_594190(path: JsonNode; query: JsonNode;
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
  var valid_594192 = path.getOrDefault("resourceGroupName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "resourceGroupName", valid_594192
  var valid_594193 = path.getOrDefault("subscriptionId")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "subscriptionId", valid_594193
  var valid_594194 = path.getOrDefault("syncGroupName")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "syncGroupName", valid_594194
  var valid_594195 = path.getOrDefault("cloudEndpointName")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "cloudEndpointName", valid_594195
  var valid_594196 = path.getOrDefault("storageSyncServiceName")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "storageSyncServiceName", valid_594196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594197 = query.getOrDefault("api-version")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "api-version", valid_594197
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

proc call*(call_594199: Call_CloudEndpointsCreate_594189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new CloudEndpoint.
  ## 
  let valid = call_594199.validator(path, query, header, formData, body)
  let scheme = call_594199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594199.url(scheme.get, call_594199.host, call_594199.base,
                         call_594199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594199, url, valid)

proc call*(call_594200: Call_CloudEndpointsCreate_594189;
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
  var path_594201 = newJObject()
  var query_594202 = newJObject()
  var body_594203 = newJObject()
  add(path_594201, "resourceGroupName", newJString(resourceGroupName))
  add(query_594202, "api-version", newJString(apiVersion))
  add(path_594201, "subscriptionId", newJString(subscriptionId))
  add(path_594201, "syncGroupName", newJString(syncGroupName))
  add(path_594201, "cloudEndpointName", newJString(cloudEndpointName))
  if parameters != nil:
    body_594203 = parameters
  add(path_594201, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594200.call(path_594201, query_594202, nil, nil, body_594203)

var cloudEndpointsCreate* = Call_CloudEndpointsCreate_594189(
    name: "cloudEndpointsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}",
    validator: validate_CloudEndpointsCreate_594190, base: "",
    url: url_CloudEndpointsCreate_594191, schemes: {Scheme.Https})
type
  Call_CloudEndpointsGet_594176 = ref object of OpenApiRestCall_593438
proc url_CloudEndpointsGet_594178(protocol: Scheme; host: string; base: string;
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

proc validate_CloudEndpointsGet_594177(path: JsonNode; query: JsonNode;
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
  var valid_594179 = path.getOrDefault("resourceGroupName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "resourceGroupName", valid_594179
  var valid_594180 = path.getOrDefault("subscriptionId")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "subscriptionId", valid_594180
  var valid_594181 = path.getOrDefault("syncGroupName")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "syncGroupName", valid_594181
  var valid_594182 = path.getOrDefault("cloudEndpointName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "cloudEndpointName", valid_594182
  var valid_594183 = path.getOrDefault("storageSyncServiceName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "storageSyncServiceName", valid_594183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594184 = query.getOrDefault("api-version")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "api-version", valid_594184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594185: Call_CloudEndpointsGet_594176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a given CloudEndpoint.
  ## 
  let valid = call_594185.validator(path, query, header, formData, body)
  let scheme = call_594185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594185.url(scheme.get, call_594185.host, call_594185.base,
                         call_594185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594185, url, valid)

proc call*(call_594186: Call_CloudEndpointsGet_594176; resourceGroupName: string;
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
  var path_594187 = newJObject()
  var query_594188 = newJObject()
  add(path_594187, "resourceGroupName", newJString(resourceGroupName))
  add(query_594188, "api-version", newJString(apiVersion))
  add(path_594187, "subscriptionId", newJString(subscriptionId))
  add(path_594187, "syncGroupName", newJString(syncGroupName))
  add(path_594187, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_594187, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594186.call(path_594187, query_594188, nil, nil, nil)

var cloudEndpointsGet* = Call_CloudEndpointsGet_594176(name: "cloudEndpointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}",
    validator: validate_CloudEndpointsGet_594177, base: "",
    url: url_CloudEndpointsGet_594178, schemes: {Scheme.Https})
type
  Call_CloudEndpointsDelete_594204 = ref object of OpenApiRestCall_593438
proc url_CloudEndpointsDelete_594206(protocol: Scheme; host: string; base: string;
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

proc validate_CloudEndpointsDelete_594205(path: JsonNode; query: JsonNode;
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
  var valid_594207 = path.getOrDefault("resourceGroupName")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "resourceGroupName", valid_594207
  var valid_594208 = path.getOrDefault("subscriptionId")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "subscriptionId", valid_594208
  var valid_594209 = path.getOrDefault("syncGroupName")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "syncGroupName", valid_594209
  var valid_594210 = path.getOrDefault("cloudEndpointName")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "cloudEndpointName", valid_594210
  var valid_594211 = path.getOrDefault("storageSyncServiceName")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "storageSyncServiceName", valid_594211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594212 = query.getOrDefault("api-version")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "api-version", valid_594212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594213: Call_CloudEndpointsDelete_594204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a given CloudEndpoint.
  ## 
  let valid = call_594213.validator(path, query, header, formData, body)
  let scheme = call_594213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594213.url(scheme.get, call_594213.host, call_594213.base,
                         call_594213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594213, url, valid)

proc call*(call_594214: Call_CloudEndpointsDelete_594204;
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
  var path_594215 = newJObject()
  var query_594216 = newJObject()
  add(path_594215, "resourceGroupName", newJString(resourceGroupName))
  add(query_594216, "api-version", newJString(apiVersion))
  add(path_594215, "subscriptionId", newJString(subscriptionId))
  add(path_594215, "syncGroupName", newJString(syncGroupName))
  add(path_594215, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_594215, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594214.call(path_594215, query_594216, nil, nil, nil)

var cloudEndpointsDelete* = Call_CloudEndpointsDelete_594204(
    name: "cloudEndpointsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}",
    validator: validate_CloudEndpointsDelete_594205, base: "",
    url: url_CloudEndpointsDelete_594206, schemes: {Scheme.Https})
type
  Call_CloudEndpointsPostBackup_594217 = ref object of OpenApiRestCall_593438
proc url_CloudEndpointsPostBackup_594219(protocol: Scheme; host: string;
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

proc validate_CloudEndpointsPostBackup_594218(path: JsonNode; query: JsonNode;
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
  var valid_594220 = path.getOrDefault("resourceGroupName")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "resourceGroupName", valid_594220
  var valid_594221 = path.getOrDefault("subscriptionId")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "subscriptionId", valid_594221
  var valid_594222 = path.getOrDefault("syncGroupName")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "syncGroupName", valid_594222
  var valid_594223 = path.getOrDefault("cloudEndpointName")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "cloudEndpointName", valid_594223
  var valid_594224 = path.getOrDefault("storageSyncServiceName")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "storageSyncServiceName", valid_594224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594225 = query.getOrDefault("api-version")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "api-version", valid_594225
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

proc call*(call_594227: Call_CloudEndpointsPostBackup_594217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Post Backup a given CloudEndpoint.
  ## 
  let valid = call_594227.validator(path, query, header, formData, body)
  let scheme = call_594227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594227.url(scheme.get, call_594227.host, call_594227.base,
                         call_594227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594227, url, valid)

proc call*(call_594228: Call_CloudEndpointsPostBackup_594217;
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
  var path_594229 = newJObject()
  var query_594230 = newJObject()
  var body_594231 = newJObject()
  add(path_594229, "resourceGroupName", newJString(resourceGroupName))
  add(query_594230, "api-version", newJString(apiVersion))
  add(path_594229, "subscriptionId", newJString(subscriptionId))
  add(path_594229, "syncGroupName", newJString(syncGroupName))
  add(path_594229, "cloudEndpointName", newJString(cloudEndpointName))
  if parameters != nil:
    body_594231 = parameters
  add(path_594229, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594228.call(path_594229, query_594230, nil, nil, body_594231)

var cloudEndpointsPostBackup* = Call_CloudEndpointsPostBackup_594217(
    name: "cloudEndpointsPostBackup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/postbackup",
    validator: validate_CloudEndpointsPostBackup_594218, base: "",
    url: url_CloudEndpointsPostBackup_594219, schemes: {Scheme.Https})
type
  Call_CloudEndpointsPostRestore_594232 = ref object of OpenApiRestCall_593438
proc url_CloudEndpointsPostRestore_594234(protocol: Scheme; host: string;
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

proc validate_CloudEndpointsPostRestore_594233(path: JsonNode; query: JsonNode;
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
  var valid_594235 = path.getOrDefault("resourceGroupName")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "resourceGroupName", valid_594235
  var valid_594236 = path.getOrDefault("subscriptionId")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "subscriptionId", valid_594236
  var valid_594237 = path.getOrDefault("syncGroupName")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "syncGroupName", valid_594237
  var valid_594238 = path.getOrDefault("cloudEndpointName")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "cloudEndpointName", valid_594238
  var valid_594239 = path.getOrDefault("storageSyncServiceName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "storageSyncServiceName", valid_594239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594240 = query.getOrDefault("api-version")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "api-version", valid_594240
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

proc call*(call_594242: Call_CloudEndpointsPostRestore_594232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Post Restore a given CloudEndpoint.
  ## 
  let valid = call_594242.validator(path, query, header, formData, body)
  let scheme = call_594242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594242.url(scheme.get, call_594242.host, call_594242.base,
                         call_594242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594242, url, valid)

proc call*(call_594243: Call_CloudEndpointsPostRestore_594232;
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
  var path_594244 = newJObject()
  var query_594245 = newJObject()
  var body_594246 = newJObject()
  add(path_594244, "resourceGroupName", newJString(resourceGroupName))
  add(query_594245, "api-version", newJString(apiVersion))
  add(path_594244, "subscriptionId", newJString(subscriptionId))
  add(path_594244, "syncGroupName", newJString(syncGroupName))
  add(path_594244, "cloudEndpointName", newJString(cloudEndpointName))
  if parameters != nil:
    body_594246 = parameters
  add(path_594244, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594243.call(path_594244, query_594245, nil, nil, body_594246)

var cloudEndpointsPostRestore* = Call_CloudEndpointsPostRestore_594232(
    name: "cloudEndpointsPostRestore", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/postrestore",
    validator: validate_CloudEndpointsPostRestore_594233, base: "",
    url: url_CloudEndpointsPostRestore_594234, schemes: {Scheme.Https})
type
  Call_CloudEndpointsPreBackup_594247 = ref object of OpenApiRestCall_593438
proc url_CloudEndpointsPreBackup_594249(protocol: Scheme; host: string; base: string;
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

proc validate_CloudEndpointsPreBackup_594248(path: JsonNode; query: JsonNode;
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
  var valid_594250 = path.getOrDefault("resourceGroupName")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "resourceGroupName", valid_594250
  var valid_594251 = path.getOrDefault("subscriptionId")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "subscriptionId", valid_594251
  var valid_594252 = path.getOrDefault("syncGroupName")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "syncGroupName", valid_594252
  var valid_594253 = path.getOrDefault("cloudEndpointName")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "cloudEndpointName", valid_594253
  var valid_594254 = path.getOrDefault("storageSyncServiceName")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "storageSyncServiceName", valid_594254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594255 = query.getOrDefault("api-version")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "api-version", valid_594255
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

proc call*(call_594257: Call_CloudEndpointsPreBackup_594247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pre Backup a given CloudEndpoint.
  ## 
  let valid = call_594257.validator(path, query, header, formData, body)
  let scheme = call_594257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594257.url(scheme.get, call_594257.host, call_594257.base,
                         call_594257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594257, url, valid)

proc call*(call_594258: Call_CloudEndpointsPreBackup_594247;
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
  var path_594259 = newJObject()
  var query_594260 = newJObject()
  var body_594261 = newJObject()
  add(path_594259, "resourceGroupName", newJString(resourceGroupName))
  add(query_594260, "api-version", newJString(apiVersion))
  add(path_594259, "subscriptionId", newJString(subscriptionId))
  add(path_594259, "syncGroupName", newJString(syncGroupName))
  add(path_594259, "cloudEndpointName", newJString(cloudEndpointName))
  if parameters != nil:
    body_594261 = parameters
  add(path_594259, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594258.call(path_594259, query_594260, nil, nil, body_594261)

var cloudEndpointsPreBackup* = Call_CloudEndpointsPreBackup_594247(
    name: "cloudEndpointsPreBackup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/prebackup",
    validator: validate_CloudEndpointsPreBackup_594248, base: "",
    url: url_CloudEndpointsPreBackup_594249, schemes: {Scheme.Https})
type
  Call_CloudEndpointsPreRestore_594262 = ref object of OpenApiRestCall_593438
proc url_CloudEndpointsPreRestore_594264(protocol: Scheme; host: string;
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

proc validate_CloudEndpointsPreRestore_594263(path: JsonNode; query: JsonNode;
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
  var valid_594265 = path.getOrDefault("resourceGroupName")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "resourceGroupName", valid_594265
  var valid_594266 = path.getOrDefault("subscriptionId")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "subscriptionId", valid_594266
  var valid_594267 = path.getOrDefault("syncGroupName")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "syncGroupName", valid_594267
  var valid_594268 = path.getOrDefault("cloudEndpointName")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "cloudEndpointName", valid_594268
  var valid_594269 = path.getOrDefault("storageSyncServiceName")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "storageSyncServiceName", valid_594269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594270 = query.getOrDefault("api-version")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "api-version", valid_594270
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

proc call*(call_594272: Call_CloudEndpointsPreRestore_594262; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pre Restore a given CloudEndpoint.
  ## 
  let valid = call_594272.validator(path, query, header, formData, body)
  let scheme = call_594272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594272.url(scheme.get, call_594272.host, call_594272.base,
                         call_594272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594272, url, valid)

proc call*(call_594273: Call_CloudEndpointsPreRestore_594262;
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
  var path_594274 = newJObject()
  var query_594275 = newJObject()
  var body_594276 = newJObject()
  add(path_594274, "resourceGroupName", newJString(resourceGroupName))
  add(query_594275, "api-version", newJString(apiVersion))
  add(path_594274, "subscriptionId", newJString(subscriptionId))
  add(path_594274, "syncGroupName", newJString(syncGroupName))
  add(path_594274, "cloudEndpointName", newJString(cloudEndpointName))
  if parameters != nil:
    body_594276 = parameters
  add(path_594274, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594273.call(path_594274, query_594275, nil, nil, body_594276)

var cloudEndpointsPreRestore* = Call_CloudEndpointsPreRestore_594262(
    name: "cloudEndpointsPreRestore", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/prerestore",
    validator: validate_CloudEndpointsPreRestore_594263, base: "",
    url: url_CloudEndpointsPreRestore_594264, schemes: {Scheme.Https})
type
  Call_CloudEndpointsRestoreheartbeat_594277 = ref object of OpenApiRestCall_593438
proc url_CloudEndpointsRestoreheartbeat_594279(protocol: Scheme; host: string;
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

proc validate_CloudEndpointsRestoreheartbeat_594278(path: JsonNode;
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
  var valid_594280 = path.getOrDefault("resourceGroupName")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "resourceGroupName", valid_594280
  var valid_594281 = path.getOrDefault("subscriptionId")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "subscriptionId", valid_594281
  var valid_594282 = path.getOrDefault("syncGroupName")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "syncGroupName", valid_594282
  var valid_594283 = path.getOrDefault("cloudEndpointName")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "cloudEndpointName", valid_594283
  var valid_594284 = path.getOrDefault("storageSyncServiceName")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "storageSyncServiceName", valid_594284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594285 = query.getOrDefault("api-version")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "api-version", valid_594285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594286: Call_CloudEndpointsRestoreheartbeat_594277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restore Heartbeat a given CloudEndpoint.
  ## 
  let valid = call_594286.validator(path, query, header, formData, body)
  let scheme = call_594286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594286.url(scheme.get, call_594286.host, call_594286.base,
                         call_594286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594286, url, valid)

proc call*(call_594287: Call_CloudEndpointsRestoreheartbeat_594277;
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
  var path_594288 = newJObject()
  var query_594289 = newJObject()
  add(path_594288, "resourceGroupName", newJString(resourceGroupName))
  add(query_594289, "api-version", newJString(apiVersion))
  add(path_594288, "subscriptionId", newJString(subscriptionId))
  add(path_594288, "syncGroupName", newJString(syncGroupName))
  add(path_594288, "cloudEndpointName", newJString(cloudEndpointName))
  add(path_594288, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594287.call(path_594288, query_594289, nil, nil, nil)

var cloudEndpointsRestoreheartbeat* = Call_CloudEndpointsRestoreheartbeat_594277(
    name: "cloudEndpointsRestoreheartbeat", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/cloudEndpoints/{cloudEndpointName}/restoreheartbeat",
    validator: validate_CloudEndpointsRestoreheartbeat_594278, base: "",
    url: url_CloudEndpointsRestoreheartbeat_594279, schemes: {Scheme.Https})
type
  Call_ServerEndpointsListBySyncGroup_594290 = ref object of OpenApiRestCall_593438
proc url_ServerEndpointsListBySyncGroup_594292(protocol: Scheme; host: string;
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

proc validate_ServerEndpointsListBySyncGroup_594291(path: JsonNode;
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
  var valid_594293 = path.getOrDefault("resourceGroupName")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "resourceGroupName", valid_594293
  var valid_594294 = path.getOrDefault("subscriptionId")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "subscriptionId", valid_594294
  var valid_594295 = path.getOrDefault("syncGroupName")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "syncGroupName", valid_594295
  var valid_594296 = path.getOrDefault("storageSyncServiceName")
  valid_594296 = validateParameter(valid_594296, JString, required = true,
                                 default = nil)
  if valid_594296 != nil:
    section.add "storageSyncServiceName", valid_594296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594297 = query.getOrDefault("api-version")
  valid_594297 = validateParameter(valid_594297, JString, required = true,
                                 default = nil)
  if valid_594297 != nil:
    section.add "api-version", valid_594297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594298: Call_ServerEndpointsListBySyncGroup_594290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a ServerEndpoint list.
  ## 
  let valid = call_594298.validator(path, query, header, formData, body)
  let scheme = call_594298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594298.url(scheme.get, call_594298.host, call_594298.base,
                         call_594298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594298, url, valid)

proc call*(call_594299: Call_ServerEndpointsListBySyncGroup_594290;
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
  var path_594300 = newJObject()
  var query_594301 = newJObject()
  add(path_594300, "resourceGroupName", newJString(resourceGroupName))
  add(query_594301, "api-version", newJString(apiVersion))
  add(path_594300, "subscriptionId", newJString(subscriptionId))
  add(path_594300, "syncGroupName", newJString(syncGroupName))
  add(path_594300, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594299.call(path_594300, query_594301, nil, nil, nil)

var serverEndpointsListBySyncGroup* = Call_ServerEndpointsListBySyncGroup_594290(
    name: "serverEndpointsListBySyncGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints",
    validator: validate_ServerEndpointsListBySyncGroup_594291, base: "",
    url: url_ServerEndpointsListBySyncGroup_594292, schemes: {Scheme.Https})
type
  Call_ServerEndpointsCreate_594315 = ref object of OpenApiRestCall_593438
proc url_ServerEndpointsCreate_594317(protocol: Scheme; host: string; base: string;
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

proc validate_ServerEndpointsCreate_594316(path: JsonNode; query: JsonNode;
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
  var valid_594318 = path.getOrDefault("serverEndpointName")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "serverEndpointName", valid_594318
  var valid_594319 = path.getOrDefault("resourceGroupName")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "resourceGroupName", valid_594319
  var valid_594320 = path.getOrDefault("subscriptionId")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "subscriptionId", valid_594320
  var valid_594321 = path.getOrDefault("syncGroupName")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "syncGroupName", valid_594321
  var valid_594322 = path.getOrDefault("storageSyncServiceName")
  valid_594322 = validateParameter(valid_594322, JString, required = true,
                                 default = nil)
  if valid_594322 != nil:
    section.add "storageSyncServiceName", valid_594322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594323 = query.getOrDefault("api-version")
  valid_594323 = validateParameter(valid_594323, JString, required = true,
                                 default = nil)
  if valid_594323 != nil:
    section.add "api-version", valid_594323
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

proc call*(call_594325: Call_ServerEndpointsCreate_594315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new ServerEndpoint.
  ## 
  let valid = call_594325.validator(path, query, header, formData, body)
  let scheme = call_594325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594325.url(scheme.get, call_594325.host, call_594325.base,
                         call_594325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594325, url, valid)

proc call*(call_594326: Call_ServerEndpointsCreate_594315;
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
  var path_594327 = newJObject()
  var query_594328 = newJObject()
  var body_594329 = newJObject()
  add(path_594327, "serverEndpointName", newJString(serverEndpointName))
  add(path_594327, "resourceGroupName", newJString(resourceGroupName))
  add(query_594328, "api-version", newJString(apiVersion))
  add(path_594327, "subscriptionId", newJString(subscriptionId))
  add(path_594327, "syncGroupName", newJString(syncGroupName))
  if parameters != nil:
    body_594329 = parameters
  add(path_594327, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594326.call(path_594327, query_594328, nil, nil, body_594329)

var serverEndpointsCreate* = Call_ServerEndpointsCreate_594315(
    name: "serverEndpointsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}",
    validator: validate_ServerEndpointsCreate_594316, base: "",
    url: url_ServerEndpointsCreate_594317, schemes: {Scheme.Https})
type
  Call_ServerEndpointsGet_594302 = ref object of OpenApiRestCall_593438
proc url_ServerEndpointsGet_594304(protocol: Scheme; host: string; base: string;
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

proc validate_ServerEndpointsGet_594303(path: JsonNode; query: JsonNode;
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
  var valid_594305 = path.getOrDefault("serverEndpointName")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "serverEndpointName", valid_594305
  var valid_594306 = path.getOrDefault("resourceGroupName")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "resourceGroupName", valid_594306
  var valid_594307 = path.getOrDefault("subscriptionId")
  valid_594307 = validateParameter(valid_594307, JString, required = true,
                                 default = nil)
  if valid_594307 != nil:
    section.add "subscriptionId", valid_594307
  var valid_594308 = path.getOrDefault("syncGroupName")
  valid_594308 = validateParameter(valid_594308, JString, required = true,
                                 default = nil)
  if valid_594308 != nil:
    section.add "syncGroupName", valid_594308
  var valid_594309 = path.getOrDefault("storageSyncServiceName")
  valid_594309 = validateParameter(valid_594309, JString, required = true,
                                 default = nil)
  if valid_594309 != nil:
    section.add "storageSyncServiceName", valid_594309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594310 = query.getOrDefault("api-version")
  valid_594310 = validateParameter(valid_594310, JString, required = true,
                                 default = nil)
  if valid_594310 != nil:
    section.add "api-version", valid_594310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594311: Call_ServerEndpointsGet_594302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a ServerEndpoint.
  ## 
  let valid = call_594311.validator(path, query, header, formData, body)
  let scheme = call_594311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594311.url(scheme.get, call_594311.host, call_594311.base,
                         call_594311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594311, url, valid)

proc call*(call_594312: Call_ServerEndpointsGet_594302; serverEndpointName: string;
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
  var path_594313 = newJObject()
  var query_594314 = newJObject()
  add(path_594313, "serverEndpointName", newJString(serverEndpointName))
  add(path_594313, "resourceGroupName", newJString(resourceGroupName))
  add(query_594314, "api-version", newJString(apiVersion))
  add(path_594313, "subscriptionId", newJString(subscriptionId))
  add(path_594313, "syncGroupName", newJString(syncGroupName))
  add(path_594313, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594312.call(path_594313, query_594314, nil, nil, nil)

var serverEndpointsGet* = Call_ServerEndpointsGet_594302(
    name: "serverEndpointsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}",
    validator: validate_ServerEndpointsGet_594303, base: "",
    url: url_ServerEndpointsGet_594304, schemes: {Scheme.Https})
type
  Call_ServerEndpointsUpdate_594343 = ref object of OpenApiRestCall_593438
proc url_ServerEndpointsUpdate_594345(protocol: Scheme; host: string; base: string;
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

proc validate_ServerEndpointsUpdate_594344(path: JsonNode; query: JsonNode;
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
  var valid_594346 = path.getOrDefault("serverEndpointName")
  valid_594346 = validateParameter(valid_594346, JString, required = true,
                                 default = nil)
  if valid_594346 != nil:
    section.add "serverEndpointName", valid_594346
  var valid_594347 = path.getOrDefault("resourceGroupName")
  valid_594347 = validateParameter(valid_594347, JString, required = true,
                                 default = nil)
  if valid_594347 != nil:
    section.add "resourceGroupName", valid_594347
  var valid_594348 = path.getOrDefault("subscriptionId")
  valid_594348 = validateParameter(valid_594348, JString, required = true,
                                 default = nil)
  if valid_594348 != nil:
    section.add "subscriptionId", valid_594348
  var valid_594349 = path.getOrDefault("syncGroupName")
  valid_594349 = validateParameter(valid_594349, JString, required = true,
                                 default = nil)
  if valid_594349 != nil:
    section.add "syncGroupName", valid_594349
  var valid_594350 = path.getOrDefault("storageSyncServiceName")
  valid_594350 = validateParameter(valid_594350, JString, required = true,
                                 default = nil)
  if valid_594350 != nil:
    section.add "storageSyncServiceName", valid_594350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594351 = query.getOrDefault("api-version")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "api-version", valid_594351
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

proc call*(call_594353: Call_ServerEndpointsUpdate_594343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a given ServerEndpoint.
  ## 
  let valid = call_594353.validator(path, query, header, formData, body)
  let scheme = call_594353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594353.url(scheme.get, call_594353.host, call_594353.base,
                         call_594353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594353, url, valid)

proc call*(call_594354: Call_ServerEndpointsUpdate_594343;
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
  var path_594355 = newJObject()
  var query_594356 = newJObject()
  var body_594357 = newJObject()
  add(path_594355, "serverEndpointName", newJString(serverEndpointName))
  add(path_594355, "resourceGroupName", newJString(resourceGroupName))
  add(query_594356, "api-version", newJString(apiVersion))
  add(path_594355, "subscriptionId", newJString(subscriptionId))
  add(path_594355, "syncGroupName", newJString(syncGroupName))
  if parameters != nil:
    body_594357 = parameters
  add(path_594355, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594354.call(path_594355, query_594356, nil, nil, body_594357)

var serverEndpointsUpdate* = Call_ServerEndpointsUpdate_594343(
    name: "serverEndpointsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}",
    validator: validate_ServerEndpointsUpdate_594344, base: "",
    url: url_ServerEndpointsUpdate_594345, schemes: {Scheme.Https})
type
  Call_ServerEndpointsDelete_594330 = ref object of OpenApiRestCall_593438
proc url_ServerEndpointsDelete_594332(protocol: Scheme; host: string; base: string;
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

proc validate_ServerEndpointsDelete_594331(path: JsonNode; query: JsonNode;
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
  var valid_594333 = path.getOrDefault("serverEndpointName")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = nil)
  if valid_594333 != nil:
    section.add "serverEndpointName", valid_594333
  var valid_594334 = path.getOrDefault("resourceGroupName")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "resourceGroupName", valid_594334
  var valid_594335 = path.getOrDefault("subscriptionId")
  valid_594335 = validateParameter(valid_594335, JString, required = true,
                                 default = nil)
  if valid_594335 != nil:
    section.add "subscriptionId", valid_594335
  var valid_594336 = path.getOrDefault("syncGroupName")
  valid_594336 = validateParameter(valid_594336, JString, required = true,
                                 default = nil)
  if valid_594336 != nil:
    section.add "syncGroupName", valid_594336
  var valid_594337 = path.getOrDefault("storageSyncServiceName")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "storageSyncServiceName", valid_594337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594338 = query.getOrDefault("api-version")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "api-version", valid_594338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594339: Call_ServerEndpointsDelete_594330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a given ServerEndpoint.
  ## 
  let valid = call_594339.validator(path, query, header, formData, body)
  let scheme = call_594339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594339.url(scheme.get, call_594339.host, call_594339.base,
                         call_594339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594339, url, valid)

proc call*(call_594340: Call_ServerEndpointsDelete_594330;
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
  var path_594341 = newJObject()
  var query_594342 = newJObject()
  add(path_594341, "serverEndpointName", newJString(serverEndpointName))
  add(path_594341, "resourceGroupName", newJString(resourceGroupName))
  add(query_594342, "api-version", newJString(apiVersion))
  add(path_594341, "subscriptionId", newJString(subscriptionId))
  add(path_594341, "syncGroupName", newJString(syncGroupName))
  add(path_594341, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594340.call(path_594341, query_594342, nil, nil, nil)

var serverEndpointsDelete* = Call_ServerEndpointsDelete_594330(
    name: "serverEndpointsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}",
    validator: validate_ServerEndpointsDelete_594331, base: "",
    url: url_ServerEndpointsDelete_594332, schemes: {Scheme.Https})
type
  Call_ServerEndpointsRecallAction_594358 = ref object of OpenApiRestCall_593438
proc url_ServerEndpointsRecallAction_594360(protocol: Scheme; host: string;
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

proc validate_ServerEndpointsRecallAction_594359(path: JsonNode; query: JsonNode;
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
  var valid_594361 = path.getOrDefault("serverEndpointName")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "serverEndpointName", valid_594361
  var valid_594362 = path.getOrDefault("resourceGroupName")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "resourceGroupName", valid_594362
  var valid_594363 = path.getOrDefault("subscriptionId")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "subscriptionId", valid_594363
  var valid_594364 = path.getOrDefault("syncGroupName")
  valid_594364 = validateParameter(valid_594364, JString, required = true,
                                 default = nil)
  if valid_594364 != nil:
    section.add "syncGroupName", valid_594364
  var valid_594365 = path.getOrDefault("storageSyncServiceName")
  valid_594365 = validateParameter(valid_594365, JString, required = true,
                                 default = nil)
  if valid_594365 != nil:
    section.add "storageSyncServiceName", valid_594365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594366 = query.getOrDefault("api-version")
  valid_594366 = validateParameter(valid_594366, JString, required = true,
                                 default = nil)
  if valid_594366 != nil:
    section.add "api-version", valid_594366
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

proc call*(call_594368: Call_ServerEndpointsRecallAction_594358; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recall a server endpoint.
  ## 
  let valid = call_594368.validator(path, query, header, formData, body)
  let scheme = call_594368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594368.url(scheme.get, call_594368.host, call_594368.base,
                         call_594368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594368, url, valid)

proc call*(call_594369: Call_ServerEndpointsRecallAction_594358;
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
  var path_594370 = newJObject()
  var query_594371 = newJObject()
  var body_594372 = newJObject()
  add(path_594370, "serverEndpointName", newJString(serverEndpointName))
  add(path_594370, "resourceGroupName", newJString(resourceGroupName))
  add(query_594371, "api-version", newJString(apiVersion))
  add(path_594370, "subscriptionId", newJString(subscriptionId))
  add(path_594370, "syncGroupName", newJString(syncGroupName))
  if parameters != nil:
    body_594372 = parameters
  add(path_594370, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594369.call(path_594370, query_594371, nil, nil, body_594372)

var serverEndpointsRecallAction* = Call_ServerEndpointsRecallAction_594358(
    name: "serverEndpointsRecallAction", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/syncGroups/{syncGroupName}/serverEndpoints/{serverEndpointName}/recallAction",
    validator: validate_ServerEndpointsRecallAction_594359, base: "",
    url: url_ServerEndpointsRecallAction_594360, schemes: {Scheme.Https})
type
  Call_WorkflowsGet_594373 = ref object of OpenApiRestCall_593438
proc url_WorkflowsGet_594375(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsGet_594374(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594376 = path.getOrDefault("resourceGroupName")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "resourceGroupName", valid_594376
  var valid_594377 = path.getOrDefault("subscriptionId")
  valid_594377 = validateParameter(valid_594377, JString, required = true,
                                 default = nil)
  if valid_594377 != nil:
    section.add "subscriptionId", valid_594377
  var valid_594378 = path.getOrDefault("workflowId")
  valid_594378 = validateParameter(valid_594378, JString, required = true,
                                 default = nil)
  if valid_594378 != nil:
    section.add "workflowId", valid_594378
  var valid_594379 = path.getOrDefault("storageSyncServiceName")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = nil)
  if valid_594379 != nil:
    section.add "storageSyncServiceName", valid_594379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594380 = query.getOrDefault("api-version")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "api-version", valid_594380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594381: Call_WorkflowsGet_594373; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Workflows resource
  ## 
  let valid = call_594381.validator(path, query, header, formData, body)
  let scheme = call_594381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594381.url(scheme.get, call_594381.host, call_594381.base,
                         call_594381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594381, url, valid)

proc call*(call_594382: Call_WorkflowsGet_594373; resourceGroupName: string;
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
  var path_594383 = newJObject()
  var query_594384 = newJObject()
  add(path_594383, "resourceGroupName", newJString(resourceGroupName))
  add(query_594384, "api-version", newJString(apiVersion))
  add(path_594383, "subscriptionId", newJString(subscriptionId))
  add(path_594383, "workflowId", newJString(workflowId))
  add(path_594383, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594382.call(path_594383, query_594384, nil, nil, nil)

var workflowsGet* = Call_WorkflowsGet_594373(name: "workflowsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/workflows/{workflowId}",
    validator: validate_WorkflowsGet_594374, base: "", url: url_WorkflowsGet_594375,
    schemes: {Scheme.Https})
type
  Call_WorkflowsAbort_594385 = ref object of OpenApiRestCall_593438
proc url_WorkflowsAbort_594387(protocol: Scheme; host: string; base: string;
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

proc validate_WorkflowsAbort_594386(path: JsonNode; query: JsonNode;
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
  var valid_594388 = path.getOrDefault("resourceGroupName")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "resourceGroupName", valid_594388
  var valid_594389 = path.getOrDefault("subscriptionId")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "subscriptionId", valid_594389
  var valid_594390 = path.getOrDefault("workflowId")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "workflowId", valid_594390
  var valid_594391 = path.getOrDefault("storageSyncServiceName")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = nil)
  if valid_594391 != nil:
    section.add "storageSyncServiceName", valid_594391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594392 = query.getOrDefault("api-version")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "api-version", valid_594392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594393: Call_WorkflowsAbort_594385; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Abort the given workflow.
  ## 
  let valid = call_594393.validator(path, query, header, formData, body)
  let scheme = call_594393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594393.url(scheme.get, call_594393.host, call_594393.base,
                         call_594393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594393, url, valid)

proc call*(call_594394: Call_WorkflowsAbort_594385; resourceGroupName: string;
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
  var path_594395 = newJObject()
  var query_594396 = newJObject()
  add(path_594395, "resourceGroupName", newJString(resourceGroupName))
  add(query_594396, "api-version", newJString(apiVersion))
  add(path_594395, "subscriptionId", newJString(subscriptionId))
  add(path_594395, "workflowId", newJString(workflowId))
  add(path_594395, "storageSyncServiceName", newJString(storageSyncServiceName))
  result = call_594394.call(path_594395, query_594396, nil, nil, nil)

var workflowsAbort* = Call_WorkflowsAbort_594385(name: "workflowsAbort",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorageSync/storageSyncServices/{storageSyncServiceName}/workflows/{workflowId}/abort",
    validator: validate_WorkflowsAbort_594386, base: "", url: url_WorkflowsAbort_594387,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
