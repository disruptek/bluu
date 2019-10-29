
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: HybridDataManagementClient
## version: 2016-06-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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
  macServiceName = "hybriddatamanager-hybriddata"
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
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
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
  ##   apiVersion: string (required)
  ##             : The API Version
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  result = call_564035.call(nil, query_564036, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.HybridData/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_DataManagersList_564076 = ref object of OpenApiRestCall_563556
proc url_DataManagersList_564078(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.HybridData/dataManagers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataManagersList_564077(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists all the data manager resources available under the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
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
  ##              : The API Version
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

proc call*(call_564095: Call_DataManagersList_564076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the data manager resources available under the subscription.
  ## 
  let valid = call_564095.validator(path, query, header, formData, body)
  let scheme = call_564095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564095.url(scheme.get, call_564095.host, call_564095.base,
                         call_564095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564095, url, valid)

proc call*(call_564096: Call_DataManagersList_564076; apiVersion: string;
          subscriptionId: string): Recallable =
  ## dataManagersList
  ## Lists all the data manager resources available under the subscription.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  var path_564097 = newJObject()
  var query_564098 = newJObject()
  add(query_564098, "api-version", newJString(apiVersion))
  add(path_564097, "subscriptionId", newJString(subscriptionId))
  result = call_564096.call(path_564097, query_564098, nil, nil, nil)

var dataManagersList* = Call_DataManagersList_564076(name: "dataManagersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.HybridData/dataManagers",
    validator: validate_DataManagersList_564077, base: "",
    url: url_DataManagersList_564078, schemes: {Scheme.Https})
type
  Call_DataManagersListByResourceGroup_564099 = ref object of OpenApiRestCall_563556
proc url_DataManagersListByResourceGroup_564101(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.HybridData/dataManagers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataManagersListByResourceGroup_564100(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the data manager resources available under the given resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
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
  ##              : The API Version
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

proc call*(call_564105: Call_DataManagersListByResourceGroup_564099;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the data manager resources available under the given resource group.
  ## 
  let valid = call_564105.validator(path, query, header, formData, body)
  let scheme = call_564105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564105.url(scheme.get, call_564105.host, call_564105.base,
                         call_564105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564105, url, valid)

proc call*(call_564106: Call_DataManagersListByResourceGroup_564099;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## dataManagersListByResourceGroup
  ## Lists all the data manager resources available under the given resource group.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  var path_564107 = newJObject()
  var query_564108 = newJObject()
  add(query_564108, "api-version", newJString(apiVersion))
  add(path_564107, "subscriptionId", newJString(subscriptionId))
  add(path_564107, "resourceGroupName", newJString(resourceGroupName))
  result = call_564106.call(path_564107, query_564108, nil, nil, nil)

var dataManagersListByResourceGroup* = Call_DataManagersListByResourceGroup_564099(
    name: "dataManagersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers",
    validator: validate_DataManagersListByResourceGroup_564100, base: "",
    url: url_DataManagersListByResourceGroup_564101, schemes: {Scheme.Https})
type
  Call_DataManagersCreate_564120 = ref object of OpenApiRestCall_563556
proc url_DataManagersCreate_564122(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataManagersCreate_564121(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a new data manager resource with the specified parameters. Existing resources cannot be updated with this API
  ## and should instead be updated with the Update data manager resource API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
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
  var valid_564125 = path.getOrDefault("dataManagerName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "dataManagerName", valid_564125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
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
  ##   dataManager: JObject (required)
  ##              : Data manager resource details from request body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564128: Call_DataManagersCreate_564120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new data manager resource with the specified parameters. Existing resources cannot be updated with this API
  ## and should instead be updated with the Update data manager resource API.
  ## 
  let valid = call_564128.validator(path, query, header, formData, body)
  let scheme = call_564128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564128.url(scheme.get, call_564128.host, call_564128.base,
                         call_564128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564128, url, valid)

proc call*(call_564129: Call_DataManagersCreate_564120; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; dataManager: JsonNode;
          dataManagerName: string): Recallable =
  ## dataManagersCreate
  ## Creates a new data manager resource with the specified parameters. Existing resources cannot be updated with this API
  ## and should instead be updated with the Update data manager resource API.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManager: JObject (required)
  ##              : Data manager resource details from request body.
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564130 = newJObject()
  var query_564131 = newJObject()
  var body_564132 = newJObject()
  add(query_564131, "api-version", newJString(apiVersion))
  add(path_564130, "subscriptionId", newJString(subscriptionId))
  add(path_564130, "resourceGroupName", newJString(resourceGroupName))
  if dataManager != nil:
    body_564132 = dataManager
  add(path_564130, "dataManagerName", newJString(dataManagerName))
  result = call_564129.call(path_564130, query_564131, nil, nil, body_564132)

var dataManagersCreate* = Call_DataManagersCreate_564120(
    name: "dataManagersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}",
    validator: validate_DataManagersCreate_564121, base: "",
    url: url_DataManagersCreate_564122, schemes: {Scheme.Https})
type
  Call_DataManagersGet_564109 = ref object of OpenApiRestCall_563556
proc url_DataManagersGet_564111(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataManagersGet_564110(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets information about the specified data manager resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
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
  var valid_564114 = path.getOrDefault("dataManagerName")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "dataManagerName", valid_564114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
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

proc call*(call_564116: Call_DataManagersGet_564109; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified data manager resource.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_DataManagersGet_564109; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; dataManagerName: string): Recallable =
  ## dataManagersGet
  ## Gets information about the specified data manager resource.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564118 = newJObject()
  var query_564119 = newJObject()
  add(query_564119, "api-version", newJString(apiVersion))
  add(path_564118, "subscriptionId", newJString(subscriptionId))
  add(path_564118, "resourceGroupName", newJString(resourceGroupName))
  add(path_564118, "dataManagerName", newJString(dataManagerName))
  result = call_564117.call(path_564118, query_564119, nil, nil, nil)

var dataManagersGet* = Call_DataManagersGet_564109(name: "dataManagersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}",
    validator: validate_DataManagersGet_564110, base: "", url: url_DataManagersGet_564111,
    schemes: {Scheme.Https})
type
  Call_DataManagersUpdate_564144 = ref object of OpenApiRestCall_563556
proc url_DataManagersUpdate_564146(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataManagersUpdate_564145(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the properties of an existing data manager resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
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
  var valid_564149 = path.getOrDefault("dataManagerName")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "dataManagerName", valid_564149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564150 = query.getOrDefault("api-version")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "api-version", valid_564150
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The patch will be performed only if the ETag of the data manager resource on the server matches this value.
  section = newJObject()
  var valid_564151 = header.getOrDefault("If-Match")
  valid_564151 = validateParameter(valid_564151, JString, required = false,
                                 default = nil)
  if valid_564151 != nil:
    section.add "If-Match", valid_564151
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dataManagerUpdateParameter: JObject (required)
  ##                             : Data manager resource details from request body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564153: Call_DataManagersUpdate_564144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing data manager resource.
  ## 
  let valid = call_564153.validator(path, query, header, formData, body)
  let scheme = call_564153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564153.url(scheme.get, call_564153.host, call_564153.base,
                         call_564153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564153, url, valid)

proc call*(call_564154: Call_DataManagersUpdate_564144;
          dataManagerUpdateParameter: JsonNode; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; dataManagerName: string): Recallable =
  ## dataManagersUpdate
  ## Updates the properties of an existing data manager resource.
  ##   dataManagerUpdateParameter: JObject (required)
  ##                             : Data manager resource details from request body.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564155 = newJObject()
  var query_564156 = newJObject()
  var body_564157 = newJObject()
  if dataManagerUpdateParameter != nil:
    body_564157 = dataManagerUpdateParameter
  add(query_564156, "api-version", newJString(apiVersion))
  add(path_564155, "subscriptionId", newJString(subscriptionId))
  add(path_564155, "resourceGroupName", newJString(resourceGroupName))
  add(path_564155, "dataManagerName", newJString(dataManagerName))
  result = call_564154.call(path_564155, query_564156, nil, nil, body_564157)

var dataManagersUpdate* = Call_DataManagersUpdate_564144(
    name: "dataManagersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}",
    validator: validate_DataManagersUpdate_564145, base: "",
    url: url_DataManagersUpdate_564146, schemes: {Scheme.Https})
type
  Call_DataManagersDelete_564133 = ref object of OpenApiRestCall_563556
proc url_DataManagersDelete_564135(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataManagersDelete_564134(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a data manager resource in Microsoft Azure.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
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
  var valid_564138 = path.getOrDefault("dataManagerName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "dataManagerName", valid_564138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
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

proc call*(call_564140: Call_DataManagersDelete_564133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a data manager resource in Microsoft Azure.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_DataManagersDelete_564133; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; dataManagerName: string): Recallable =
  ## dataManagersDelete
  ## Deletes a data manager resource in Microsoft Azure.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564142 = newJObject()
  var query_564143 = newJObject()
  add(query_564143, "api-version", newJString(apiVersion))
  add(path_564142, "subscriptionId", newJString(subscriptionId))
  add(path_564142, "resourceGroupName", newJString(resourceGroupName))
  add(path_564142, "dataManagerName", newJString(dataManagerName))
  result = call_564141.call(path_564142, query_564143, nil, nil, nil)

var dataManagersDelete* = Call_DataManagersDelete_564133(
    name: "dataManagersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}",
    validator: validate_DataManagersDelete_564134, base: "",
    url: url_DataManagersDelete_564135, schemes: {Scheme.Https})
type
  Call_DataServicesListByDataManager_564158 = ref object of OpenApiRestCall_563556
proc url_DataServicesListByDataManager_564160(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataServicesListByDataManager_564159(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets all the data services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564161 = path.getOrDefault("subscriptionId")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "subscriptionId", valid_564161
  var valid_564162 = path.getOrDefault("resourceGroupName")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "resourceGroupName", valid_564162
  var valid_564163 = path.getOrDefault("dataManagerName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "dataManagerName", valid_564163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
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

proc call*(call_564165: Call_DataServicesListByDataManager_564158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets all the data services.
  ## 
  let valid = call_564165.validator(path, query, header, formData, body)
  let scheme = call_564165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564165.url(scheme.get, call_564165.host, call_564165.base,
                         call_564165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564165, url, valid)

proc call*(call_564166: Call_DataServicesListByDataManager_564158;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          dataManagerName: string): Recallable =
  ## dataServicesListByDataManager
  ## This method gets all the data services.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564167 = newJObject()
  var query_564168 = newJObject()
  add(query_564168, "api-version", newJString(apiVersion))
  add(path_564167, "subscriptionId", newJString(subscriptionId))
  add(path_564167, "resourceGroupName", newJString(resourceGroupName))
  add(path_564167, "dataManagerName", newJString(dataManagerName))
  result = call_564166.call(path_564167, query_564168, nil, nil, nil)

var dataServicesListByDataManager* = Call_DataServicesListByDataManager_564158(
    name: "dataServicesListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices",
    validator: validate_DataServicesListByDataManager_564159, base: "",
    url: url_DataServicesListByDataManager_564160, schemes: {Scheme.Https})
type
  Call_DataServicesGet_564169 = ref object of OpenApiRestCall_563556
proc url_DataServicesGet_564171(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  assert "dataServiceName" in path, "`dataServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataServices/"),
               (kind: VariableSegment, value: "dataServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataServicesGet_564170(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the data service that match the data service name given.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataServiceName: JString (required)
  ##                  : The name of the data service that is being queried.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataServiceName` field"
  var valid_564172 = path.getOrDefault("dataServiceName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "dataServiceName", valid_564172
  var valid_564173 = path.getOrDefault("subscriptionId")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "subscriptionId", valid_564173
  var valid_564174 = path.getOrDefault("resourceGroupName")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "resourceGroupName", valid_564174
  var valid_564175 = path.getOrDefault("dataManagerName")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "dataManagerName", valid_564175
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564176 = query.getOrDefault("api-version")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "api-version", valid_564176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564177: Call_DataServicesGet_564169; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the data service that match the data service name given.
  ## 
  let valid = call_564177.validator(path, query, header, formData, body)
  let scheme = call_564177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564177.url(scheme.get, call_564177.host, call_564177.base,
                         call_564177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564177, url, valid)

proc call*(call_564178: Call_DataServicesGet_564169; dataServiceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          dataManagerName: string): Recallable =
  ## dataServicesGet
  ## Gets the data service that match the data service name given.
  ##   dataServiceName: string (required)
  ##                  : The name of the data service that is being queried.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564179 = newJObject()
  var query_564180 = newJObject()
  add(path_564179, "dataServiceName", newJString(dataServiceName))
  add(query_564180, "api-version", newJString(apiVersion))
  add(path_564179, "subscriptionId", newJString(subscriptionId))
  add(path_564179, "resourceGroupName", newJString(resourceGroupName))
  add(path_564179, "dataManagerName", newJString(dataManagerName))
  result = call_564178.call(path_564179, query_564180, nil, nil, nil)

var dataServicesGet* = Call_DataServicesGet_564169(name: "dataServicesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}",
    validator: validate_DataServicesGet_564170, base: "", url: url_DataServicesGet_564171,
    schemes: {Scheme.Https})
type
  Call_JobDefinitionsListByDataService_564181 = ref object of OpenApiRestCall_563556
proc url_JobDefinitionsListByDataService_564183(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  assert "dataServiceName" in path, "`dataServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataServices/"),
               (kind: VariableSegment, value: "dataServiceName"),
               (kind: ConstantSegment, value: "/jobDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobDefinitionsListByDataService_564182(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets all the job definitions of the given data service name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataServiceName: JString (required)
  ##                  : The data service type of interest.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataServiceName` field"
  var valid_564185 = path.getOrDefault("dataServiceName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "dataServiceName", valid_564185
  var valid_564186 = path.getOrDefault("subscriptionId")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "subscriptionId", valid_564186
  var valid_564187 = path.getOrDefault("resourceGroupName")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "resourceGroupName", valid_564187
  var valid_564188 = path.getOrDefault("dataManagerName")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "dataManagerName", valid_564188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564189 = query.getOrDefault("api-version")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "api-version", valid_564189
  var valid_564190 = query.getOrDefault("$filter")
  valid_564190 = validateParameter(valid_564190, JString, required = false,
                                 default = nil)
  if valid_564190 != nil:
    section.add "$filter", valid_564190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564191: Call_JobDefinitionsListByDataService_564181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This method gets all the job definitions of the given data service name.
  ## 
  let valid = call_564191.validator(path, query, header, formData, body)
  let scheme = call_564191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564191.url(scheme.get, call_564191.host, call_564191.base,
                         call_564191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564191, url, valid)

proc call*(call_564192: Call_JobDefinitionsListByDataService_564181;
          dataServiceName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; dataManagerName: string; Filter: string = ""): Recallable =
  ## jobDefinitionsListByDataService
  ## This method gets all the job definitions of the given data service name.
  ##   dataServiceName: string (required)
  ##                  : The data service type of interest.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   Filter: string
  ##         : OData Filter options
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564193 = newJObject()
  var query_564194 = newJObject()
  add(path_564193, "dataServiceName", newJString(dataServiceName))
  add(query_564194, "api-version", newJString(apiVersion))
  add(path_564193, "subscriptionId", newJString(subscriptionId))
  add(path_564193, "resourceGroupName", newJString(resourceGroupName))
  add(query_564194, "$filter", newJString(Filter))
  add(path_564193, "dataManagerName", newJString(dataManagerName))
  result = call_564192.call(path_564193, query_564194, nil, nil, nil)

var jobDefinitionsListByDataService* = Call_JobDefinitionsListByDataService_564181(
    name: "jobDefinitionsListByDataService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions",
    validator: validate_JobDefinitionsListByDataService_564182, base: "",
    url: url_JobDefinitionsListByDataService_564183, schemes: {Scheme.Https})
type
  Call_JobDefinitionsCreateOrUpdate_564208 = ref object of OpenApiRestCall_563556
proc url_JobDefinitionsCreateOrUpdate_564210(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  assert "dataServiceName" in path, "`dataServiceName` is a required path parameter"
  assert "jobDefinitionName" in path,
        "`jobDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataServices/"),
               (kind: VariableSegment, value: "dataServiceName"),
               (kind: ConstantSegment, value: "/jobDefinitions/"),
               (kind: VariableSegment, value: "jobDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobDefinitionsCreateOrUpdate_564209(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a job definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataServiceName: JString (required)
  ##                  : The data service type of the job definition.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   jobDefinitionName: JString (required)
  ##                    : The job definition name to be created or updated.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataServiceName` field"
  var valid_564211 = path.getOrDefault("dataServiceName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "dataServiceName", valid_564211
  var valid_564212 = path.getOrDefault("subscriptionId")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "subscriptionId", valid_564212
  var valid_564213 = path.getOrDefault("jobDefinitionName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "jobDefinitionName", valid_564213
  var valid_564214 = path.getOrDefault("resourceGroupName")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "resourceGroupName", valid_564214
  var valid_564215 = path.getOrDefault("dataManagerName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "dataManagerName", valid_564215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564216 = query.getOrDefault("api-version")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "api-version", valid_564216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   jobDefinition: JObject (required)
  ##                : Job Definition object to be created or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564218: Call_JobDefinitionsCreateOrUpdate_564208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job definition.
  ## 
  let valid = call_564218.validator(path, query, header, formData, body)
  let scheme = call_564218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564218.url(scheme.get, call_564218.host, call_564218.base,
                         call_564218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564218, url, valid)

proc call*(call_564219: Call_JobDefinitionsCreateOrUpdate_564208;
          dataServiceName: string; apiVersion: string; jobDefinition: JsonNode;
          subscriptionId: string; jobDefinitionName: string;
          resourceGroupName: string; dataManagerName: string): Recallable =
  ## jobDefinitionsCreateOrUpdate
  ## Creates or updates a job definition.
  ##   dataServiceName: string (required)
  ##                  : The data service type of the job definition.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   jobDefinition: JObject (required)
  ##                : Job Definition object to be created or updated.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   jobDefinitionName: string (required)
  ##                    : The job definition name to be created or updated.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564220 = newJObject()
  var query_564221 = newJObject()
  var body_564222 = newJObject()
  add(path_564220, "dataServiceName", newJString(dataServiceName))
  add(query_564221, "api-version", newJString(apiVersion))
  if jobDefinition != nil:
    body_564222 = jobDefinition
  add(path_564220, "subscriptionId", newJString(subscriptionId))
  add(path_564220, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_564220, "resourceGroupName", newJString(resourceGroupName))
  add(path_564220, "dataManagerName", newJString(dataManagerName))
  result = call_564219.call(path_564220, query_564221, nil, nil, body_564222)

var jobDefinitionsCreateOrUpdate* = Call_JobDefinitionsCreateOrUpdate_564208(
    name: "jobDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}",
    validator: validate_JobDefinitionsCreateOrUpdate_564209, base: "",
    url: url_JobDefinitionsCreateOrUpdate_564210, schemes: {Scheme.Https})
type
  Call_JobDefinitionsGet_564195 = ref object of OpenApiRestCall_563556
proc url_JobDefinitionsGet_564197(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  assert "dataServiceName" in path, "`dataServiceName` is a required path parameter"
  assert "jobDefinitionName" in path,
        "`jobDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataServices/"),
               (kind: VariableSegment, value: "dataServiceName"),
               (kind: ConstantSegment, value: "/jobDefinitions/"),
               (kind: VariableSegment, value: "jobDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobDefinitionsGet_564196(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## This method gets job definition object by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataServiceName: JString (required)
  ##                  : The data service name of the job definition
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   jobDefinitionName: JString (required)
  ##                    : The job definition name that is being queried.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataServiceName` field"
  var valid_564198 = path.getOrDefault("dataServiceName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "dataServiceName", valid_564198
  var valid_564199 = path.getOrDefault("subscriptionId")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "subscriptionId", valid_564199
  var valid_564200 = path.getOrDefault("jobDefinitionName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "jobDefinitionName", valid_564200
  var valid_564201 = path.getOrDefault("resourceGroupName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "resourceGroupName", valid_564201
  var valid_564202 = path.getOrDefault("dataManagerName")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "dataManagerName", valid_564202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564203 = query.getOrDefault("api-version")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "api-version", valid_564203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564204: Call_JobDefinitionsGet_564195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets job definition object by name.
  ## 
  let valid = call_564204.validator(path, query, header, formData, body)
  let scheme = call_564204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564204.url(scheme.get, call_564204.host, call_564204.base,
                         call_564204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564204, url, valid)

proc call*(call_564205: Call_JobDefinitionsGet_564195; dataServiceName: string;
          apiVersion: string; subscriptionId: string; jobDefinitionName: string;
          resourceGroupName: string; dataManagerName: string): Recallable =
  ## jobDefinitionsGet
  ## This method gets job definition object by name.
  ##   dataServiceName: string (required)
  ##                  : The data service name of the job definition
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   jobDefinitionName: string (required)
  ##                    : The job definition name that is being queried.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564206 = newJObject()
  var query_564207 = newJObject()
  add(path_564206, "dataServiceName", newJString(dataServiceName))
  add(query_564207, "api-version", newJString(apiVersion))
  add(path_564206, "subscriptionId", newJString(subscriptionId))
  add(path_564206, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_564206, "resourceGroupName", newJString(resourceGroupName))
  add(path_564206, "dataManagerName", newJString(dataManagerName))
  result = call_564205.call(path_564206, query_564207, nil, nil, nil)

var jobDefinitionsGet* = Call_JobDefinitionsGet_564195(name: "jobDefinitionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}",
    validator: validate_JobDefinitionsGet_564196, base: "",
    url: url_JobDefinitionsGet_564197, schemes: {Scheme.Https})
type
  Call_JobDefinitionsDelete_564223 = ref object of OpenApiRestCall_563556
proc url_JobDefinitionsDelete_564225(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  assert "dataServiceName" in path, "`dataServiceName` is a required path parameter"
  assert "jobDefinitionName" in path,
        "`jobDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataServices/"),
               (kind: VariableSegment, value: "dataServiceName"),
               (kind: ConstantSegment, value: "/jobDefinitions/"),
               (kind: VariableSegment, value: "jobDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobDefinitionsDelete_564224(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method deletes the given job definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataServiceName: JString (required)
  ##                  : The data service type of the job definition.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   jobDefinitionName: JString (required)
  ##                    : The job definition name to be deleted.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataServiceName` field"
  var valid_564226 = path.getOrDefault("dataServiceName")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "dataServiceName", valid_564226
  var valid_564227 = path.getOrDefault("subscriptionId")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "subscriptionId", valid_564227
  var valid_564228 = path.getOrDefault("jobDefinitionName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "jobDefinitionName", valid_564228
  var valid_564229 = path.getOrDefault("resourceGroupName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "resourceGroupName", valid_564229
  var valid_564230 = path.getOrDefault("dataManagerName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "dataManagerName", valid_564230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564231 = query.getOrDefault("api-version")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "api-version", valid_564231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564232: Call_JobDefinitionsDelete_564223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method deletes the given job definition.
  ## 
  let valid = call_564232.validator(path, query, header, formData, body)
  let scheme = call_564232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564232.url(scheme.get, call_564232.host, call_564232.base,
                         call_564232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564232, url, valid)

proc call*(call_564233: Call_JobDefinitionsDelete_564223; dataServiceName: string;
          apiVersion: string; subscriptionId: string; jobDefinitionName: string;
          resourceGroupName: string; dataManagerName: string): Recallable =
  ## jobDefinitionsDelete
  ## This method deletes the given job definition.
  ##   dataServiceName: string (required)
  ##                  : The data service type of the job definition.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   jobDefinitionName: string (required)
  ##                    : The job definition name to be deleted.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564234 = newJObject()
  var query_564235 = newJObject()
  add(path_564234, "dataServiceName", newJString(dataServiceName))
  add(query_564235, "api-version", newJString(apiVersion))
  add(path_564234, "subscriptionId", newJString(subscriptionId))
  add(path_564234, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_564234, "resourceGroupName", newJString(resourceGroupName))
  add(path_564234, "dataManagerName", newJString(dataManagerName))
  result = call_564233.call(path_564234, query_564235, nil, nil, nil)

var jobDefinitionsDelete* = Call_JobDefinitionsDelete_564223(
    name: "jobDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}",
    validator: validate_JobDefinitionsDelete_564224, base: "",
    url: url_JobDefinitionsDelete_564225, schemes: {Scheme.Https})
type
  Call_JobsListByJobDefinition_564236 = ref object of OpenApiRestCall_563556
proc url_JobsListByJobDefinition_564238(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  assert "dataServiceName" in path, "`dataServiceName` is a required path parameter"
  assert "jobDefinitionName" in path,
        "`jobDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataServices/"),
               (kind: VariableSegment, value: "dataServiceName"),
               (kind: ConstantSegment, value: "/jobDefinitions/"),
               (kind: VariableSegment, value: "jobDefinitionName"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListByJobDefinition_564237(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets all the jobs of a given job definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataServiceName: JString (required)
  ##                  : The name of the data service of the job definition.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   jobDefinitionName: JString (required)
  ##                    : The name of the job definition for which jobs are needed.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataServiceName` field"
  var valid_564239 = path.getOrDefault("dataServiceName")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "dataServiceName", valid_564239
  var valid_564240 = path.getOrDefault("subscriptionId")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "subscriptionId", valid_564240
  var valid_564241 = path.getOrDefault("jobDefinitionName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "jobDefinitionName", valid_564241
  var valid_564242 = path.getOrDefault("resourceGroupName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "resourceGroupName", valid_564242
  var valid_564243 = path.getOrDefault("dataManagerName")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "dataManagerName", valid_564243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564244 = query.getOrDefault("api-version")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "api-version", valid_564244
  var valid_564245 = query.getOrDefault("$filter")
  valid_564245 = validateParameter(valid_564245, JString, required = false,
                                 default = nil)
  if valid_564245 != nil:
    section.add "$filter", valid_564245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564246: Call_JobsListByJobDefinition_564236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets all the jobs of a given job definition.
  ## 
  let valid = call_564246.validator(path, query, header, formData, body)
  let scheme = call_564246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564246.url(scheme.get, call_564246.host, call_564246.base,
                         call_564246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564246, url, valid)

proc call*(call_564247: Call_JobsListByJobDefinition_564236;
          dataServiceName: string; apiVersion: string; subscriptionId: string;
          jobDefinitionName: string; resourceGroupName: string;
          dataManagerName: string; Filter: string = ""): Recallable =
  ## jobsListByJobDefinition
  ## This method gets all the jobs of a given job definition.
  ##   dataServiceName: string (required)
  ##                  : The name of the data service of the job definition.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   jobDefinitionName: string (required)
  ##                    : The name of the job definition for which jobs are needed.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   Filter: string
  ##         : OData Filter options
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564248 = newJObject()
  var query_564249 = newJObject()
  add(path_564248, "dataServiceName", newJString(dataServiceName))
  add(query_564249, "api-version", newJString(apiVersion))
  add(path_564248, "subscriptionId", newJString(subscriptionId))
  add(path_564248, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_564248, "resourceGroupName", newJString(resourceGroupName))
  add(query_564249, "$filter", newJString(Filter))
  add(path_564248, "dataManagerName", newJString(dataManagerName))
  result = call_564247.call(path_564248, query_564249, nil, nil, nil)

var jobsListByJobDefinition* = Call_JobsListByJobDefinition_564236(
    name: "jobsListByJobDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}/jobs",
    validator: validate_JobsListByJobDefinition_564237, base: "",
    url: url_JobsListByJobDefinition_564238, schemes: {Scheme.Https})
type
  Call_JobsGet_564250 = ref object of OpenApiRestCall_563556
proc url_JobsGet_564252(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  assert "dataServiceName" in path, "`dataServiceName` is a required path parameter"
  assert "jobDefinitionName" in path,
        "`jobDefinitionName` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataServices/"),
               (kind: VariableSegment, value: "dataServiceName"),
               (kind: ConstantSegment, value: "/jobDefinitions/"),
               (kind: VariableSegment, value: "jobDefinitionName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsGet_564251(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets a data manager job given the jobId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataServiceName: JString (required)
  ##                  : The name of the data service of the job definition.
  ##   jobId: JString (required)
  ##        : The job id of the job queried.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   jobDefinitionName: JString (required)
  ##                    : The name of the job definition of the job.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataServiceName` field"
  var valid_564253 = path.getOrDefault("dataServiceName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "dataServiceName", valid_564253
  var valid_564254 = path.getOrDefault("jobId")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "jobId", valid_564254
  var valid_564255 = path.getOrDefault("subscriptionId")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "subscriptionId", valid_564255
  var valid_564256 = path.getOrDefault("jobDefinitionName")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "jobDefinitionName", valid_564256
  var valid_564257 = path.getOrDefault("resourceGroupName")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "resourceGroupName", valid_564257
  var valid_564258 = path.getOrDefault("dataManagerName")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "dataManagerName", valid_564258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $expand: JString
  ##          : $expand is supported on details parameter for job, which provides details on the job stages.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564259 = query.getOrDefault("api-version")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "api-version", valid_564259
  var valid_564260 = query.getOrDefault("$expand")
  valid_564260 = validateParameter(valid_564260, JString, required = false,
                                 default = nil)
  if valid_564260 != nil:
    section.add "$expand", valid_564260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564261: Call_JobsGet_564250; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets a data manager job given the jobId.
  ## 
  let valid = call_564261.validator(path, query, header, formData, body)
  let scheme = call_564261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564261.url(scheme.get, call_564261.host, call_564261.base,
                         call_564261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564261, url, valid)

proc call*(call_564262: Call_JobsGet_564250; dataServiceName: string; jobId: string;
          apiVersion: string; subscriptionId: string; jobDefinitionName: string;
          resourceGroupName: string; dataManagerName: string; Expand: string = ""): Recallable =
  ## jobsGet
  ## This method gets a data manager job given the jobId.
  ##   dataServiceName: string (required)
  ##                  : The name of the data service of the job definition.
  ##   jobId: string (required)
  ##        : The job id of the job queried.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   Expand: string
  ##         : $expand is supported on details parameter for job, which provides details on the job stages.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   jobDefinitionName: string (required)
  ##                    : The name of the job definition of the job.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564263 = newJObject()
  var query_564264 = newJObject()
  add(path_564263, "dataServiceName", newJString(dataServiceName))
  add(path_564263, "jobId", newJString(jobId))
  add(query_564264, "api-version", newJString(apiVersion))
  add(query_564264, "$expand", newJString(Expand))
  add(path_564263, "subscriptionId", newJString(subscriptionId))
  add(path_564263, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_564263, "resourceGroupName", newJString(resourceGroupName))
  add(path_564263, "dataManagerName", newJString(dataManagerName))
  result = call_564262.call(path_564263, query_564264, nil, nil, nil)

var jobsGet* = Call_JobsGet_564250(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}/jobs/{jobId}",
                                validator: validate_JobsGet_564251, base: "",
                                url: url_JobsGet_564252, schemes: {Scheme.Https})
type
  Call_JobsCancel_564265 = ref object of OpenApiRestCall_563556
proc url_JobsCancel_564267(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  assert "dataServiceName" in path, "`dataServiceName` is a required path parameter"
  assert "jobDefinitionName" in path,
        "`jobDefinitionName` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataServices/"),
               (kind: VariableSegment, value: "dataServiceName"),
               (kind: ConstantSegment, value: "/jobDefinitions/"),
               (kind: VariableSegment, value: "jobDefinitionName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsCancel_564266(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the given job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataServiceName: JString (required)
  ##                  : The name of the data service of the job definition.
  ##   jobId: JString (required)
  ##        : The job id of the job queried.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   jobDefinitionName: JString (required)
  ##                    : The name of the job definition of the job.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataServiceName` field"
  var valid_564268 = path.getOrDefault("dataServiceName")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "dataServiceName", valid_564268
  var valid_564269 = path.getOrDefault("jobId")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "jobId", valid_564269
  var valid_564270 = path.getOrDefault("subscriptionId")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "subscriptionId", valid_564270
  var valid_564271 = path.getOrDefault("jobDefinitionName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "jobDefinitionName", valid_564271
  var valid_564272 = path.getOrDefault("resourceGroupName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "resourceGroupName", valid_564272
  var valid_564273 = path.getOrDefault("dataManagerName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "dataManagerName", valid_564273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564274 = query.getOrDefault("api-version")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "api-version", valid_564274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564275: Call_JobsCancel_564265; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the given job.
  ## 
  let valid = call_564275.validator(path, query, header, formData, body)
  let scheme = call_564275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564275.url(scheme.get, call_564275.host, call_564275.base,
                         call_564275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564275, url, valid)

proc call*(call_564276: Call_JobsCancel_564265; dataServiceName: string;
          jobId: string; apiVersion: string; subscriptionId: string;
          jobDefinitionName: string; resourceGroupName: string;
          dataManagerName: string): Recallable =
  ## jobsCancel
  ## Cancels the given job.
  ##   dataServiceName: string (required)
  ##                  : The name of the data service of the job definition.
  ##   jobId: string (required)
  ##        : The job id of the job queried.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   jobDefinitionName: string (required)
  ##                    : The name of the job definition of the job.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564277 = newJObject()
  var query_564278 = newJObject()
  add(path_564277, "dataServiceName", newJString(dataServiceName))
  add(path_564277, "jobId", newJString(jobId))
  add(query_564278, "api-version", newJString(apiVersion))
  add(path_564277, "subscriptionId", newJString(subscriptionId))
  add(path_564277, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_564277, "resourceGroupName", newJString(resourceGroupName))
  add(path_564277, "dataManagerName", newJString(dataManagerName))
  result = call_564276.call(path_564277, query_564278, nil, nil, nil)

var jobsCancel* = Call_JobsCancel_564265(name: "jobsCancel",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}/jobs/{jobId}/cancel",
                                      validator: validate_JobsCancel_564266,
                                      base: "", url: url_JobsCancel_564267,
                                      schemes: {Scheme.Https})
type
  Call_JobsResume_564279 = ref object of OpenApiRestCall_563556
proc url_JobsResume_564281(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  assert "dataServiceName" in path, "`dataServiceName` is a required path parameter"
  assert "jobDefinitionName" in path,
        "`jobDefinitionName` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataServices/"),
               (kind: VariableSegment, value: "dataServiceName"),
               (kind: ConstantSegment, value: "/jobDefinitions/"),
               (kind: VariableSegment, value: "jobDefinitionName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/resume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsResume_564280(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Resumes the given job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataServiceName: JString (required)
  ##                  : The name of the data service of the job definition.
  ##   jobId: JString (required)
  ##        : The job id of the job queried.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   jobDefinitionName: JString (required)
  ##                    : The name of the job definition of the job.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataServiceName` field"
  var valid_564282 = path.getOrDefault("dataServiceName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "dataServiceName", valid_564282
  var valid_564283 = path.getOrDefault("jobId")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "jobId", valid_564283
  var valid_564284 = path.getOrDefault("subscriptionId")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "subscriptionId", valid_564284
  var valid_564285 = path.getOrDefault("jobDefinitionName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "jobDefinitionName", valid_564285
  var valid_564286 = path.getOrDefault("resourceGroupName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "resourceGroupName", valid_564286
  var valid_564287 = path.getOrDefault("dataManagerName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "dataManagerName", valid_564287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
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
  if body != nil:
    result.add "body", body

proc call*(call_564289: Call_JobsResume_564279; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resumes the given job.
  ## 
  let valid = call_564289.validator(path, query, header, formData, body)
  let scheme = call_564289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564289.url(scheme.get, call_564289.host, call_564289.base,
                         call_564289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564289, url, valid)

proc call*(call_564290: Call_JobsResume_564279; dataServiceName: string;
          jobId: string; apiVersion: string; subscriptionId: string;
          jobDefinitionName: string; resourceGroupName: string;
          dataManagerName: string): Recallable =
  ## jobsResume
  ## Resumes the given job.
  ##   dataServiceName: string (required)
  ##                  : The name of the data service of the job definition.
  ##   jobId: string (required)
  ##        : The job id of the job queried.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   jobDefinitionName: string (required)
  ##                    : The name of the job definition of the job.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564291 = newJObject()
  var query_564292 = newJObject()
  add(path_564291, "dataServiceName", newJString(dataServiceName))
  add(path_564291, "jobId", newJString(jobId))
  add(query_564292, "api-version", newJString(apiVersion))
  add(path_564291, "subscriptionId", newJString(subscriptionId))
  add(path_564291, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_564291, "resourceGroupName", newJString(resourceGroupName))
  add(path_564291, "dataManagerName", newJString(dataManagerName))
  result = call_564290.call(path_564291, query_564292, nil, nil, nil)

var jobsResume* = Call_JobsResume_564279(name: "jobsResume",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}/jobs/{jobId}/resume",
                                      validator: validate_JobsResume_564280,
                                      base: "", url: url_JobsResume_564281,
                                      schemes: {Scheme.Https})
type
  Call_JobDefinitionsRun_564293 = ref object of OpenApiRestCall_563556
proc url_JobDefinitionsRun_564295(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  assert "dataServiceName" in path, "`dataServiceName` is a required path parameter"
  assert "jobDefinitionName" in path,
        "`jobDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataServices/"),
               (kind: VariableSegment, value: "dataServiceName"),
               (kind: ConstantSegment, value: "/jobDefinitions/"),
               (kind: VariableSegment, value: "jobDefinitionName"),
               (kind: ConstantSegment, value: "/run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobDefinitionsRun_564294(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## This method runs a job instance of the given job definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataServiceName: JString (required)
  ##                  : The data service type of the job definition.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   jobDefinitionName: JString (required)
  ##                    : Name of the job definition.
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataServiceName` field"
  var valid_564296 = path.getOrDefault("dataServiceName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "dataServiceName", valid_564296
  var valid_564297 = path.getOrDefault("subscriptionId")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "subscriptionId", valid_564297
  var valid_564298 = path.getOrDefault("jobDefinitionName")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "jobDefinitionName", valid_564298
  var valid_564299 = path.getOrDefault("resourceGroupName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "resourceGroupName", valid_564299
  var valid_564300 = path.getOrDefault("dataManagerName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "dataManagerName", valid_564300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
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
  ##   runParameters: JObject (required)
  ##                : Run time parameters for the job definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564303: Call_JobDefinitionsRun_564293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method runs a job instance of the given job definition.
  ## 
  let valid = call_564303.validator(path, query, header, formData, body)
  let scheme = call_564303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564303.url(scheme.get, call_564303.host, call_564303.base,
                         call_564303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564303, url, valid)

proc call*(call_564304: Call_JobDefinitionsRun_564293; dataServiceName: string;
          apiVersion: string; runParameters: JsonNode; subscriptionId: string;
          jobDefinitionName: string; resourceGroupName: string;
          dataManagerName: string): Recallable =
  ## jobDefinitionsRun
  ## This method runs a job instance of the given job definition.
  ##   dataServiceName: string (required)
  ##                  : The data service type of the job definition.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   runParameters: JObject (required)
  ##                : Run time parameters for the job definition.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   jobDefinitionName: string (required)
  ##                    : Name of the job definition.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564305 = newJObject()
  var query_564306 = newJObject()
  var body_564307 = newJObject()
  add(path_564305, "dataServiceName", newJString(dataServiceName))
  add(query_564306, "api-version", newJString(apiVersion))
  if runParameters != nil:
    body_564307 = runParameters
  add(path_564305, "subscriptionId", newJString(subscriptionId))
  add(path_564305, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_564305, "resourceGroupName", newJString(resourceGroupName))
  add(path_564305, "dataManagerName", newJString(dataManagerName))
  result = call_564304.call(path_564305, query_564306, nil, nil, body_564307)

var jobDefinitionsRun* = Call_JobDefinitionsRun_564293(name: "jobDefinitionsRun",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}/run",
    validator: validate_JobDefinitionsRun_564294, base: "",
    url: url_JobDefinitionsRun_564295, schemes: {Scheme.Https})
type
  Call_JobsListByDataService_564308 = ref object of OpenApiRestCall_563556
proc url_JobsListByDataService_564310(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  assert "dataServiceName" in path, "`dataServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataServices/"),
               (kind: VariableSegment, value: "dataServiceName"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListByDataService_564309(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets all the jobs of a data service type in a given resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataServiceName: JString (required)
  ##                  : The name of the data service of interest.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataServiceName` field"
  var valid_564311 = path.getOrDefault("dataServiceName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "dataServiceName", valid_564311
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
  var valid_564314 = path.getOrDefault("dataManagerName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "dataManagerName", valid_564314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564315 = query.getOrDefault("api-version")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "api-version", valid_564315
  var valid_564316 = query.getOrDefault("$filter")
  valid_564316 = validateParameter(valid_564316, JString, required = false,
                                 default = nil)
  if valid_564316 != nil:
    section.add "$filter", valid_564316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564317: Call_JobsListByDataService_564308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets all the jobs of a data service type in a given resource.
  ## 
  let valid = call_564317.validator(path, query, header, formData, body)
  let scheme = call_564317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564317.url(scheme.get, call_564317.host, call_564317.base,
                         call_564317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564317, url, valid)

proc call*(call_564318: Call_JobsListByDataService_564308; dataServiceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          dataManagerName: string; Filter: string = ""): Recallable =
  ## jobsListByDataService
  ## This method gets all the jobs of a data service type in a given resource.
  ##   dataServiceName: string (required)
  ##                  : The name of the data service of interest.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   Filter: string
  ##         : OData Filter options
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564319 = newJObject()
  var query_564320 = newJObject()
  add(path_564319, "dataServiceName", newJString(dataServiceName))
  add(query_564320, "api-version", newJString(apiVersion))
  add(path_564319, "subscriptionId", newJString(subscriptionId))
  add(path_564319, "resourceGroupName", newJString(resourceGroupName))
  add(query_564320, "$filter", newJString(Filter))
  add(path_564319, "dataManagerName", newJString(dataManagerName))
  result = call_564318.call(path_564319, query_564320, nil, nil, nil)

var jobsListByDataService* = Call_JobsListByDataService_564308(
    name: "jobsListByDataService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobs",
    validator: validate_JobsListByDataService_564309, base: "",
    url: url_JobsListByDataService_564310, schemes: {Scheme.Https})
type
  Call_DataStoreTypesListByDataManager_564321 = ref object of OpenApiRestCall_563556
proc url_DataStoreTypesListByDataManager_564323(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataStoreTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataStoreTypesListByDataManager_564322(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the data store/repository types that the resource supports.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
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
  var valid_564326 = path.getOrDefault("dataManagerName")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "dataManagerName", valid_564326
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
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

proc call*(call_564328: Call_DataStoreTypesListByDataManager_564321;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the data store/repository types that the resource supports.
  ## 
  let valid = call_564328.validator(path, query, header, formData, body)
  let scheme = call_564328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564328.url(scheme.get, call_564328.host, call_564328.base,
                         call_564328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564328, url, valid)

proc call*(call_564329: Call_DataStoreTypesListByDataManager_564321;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          dataManagerName: string): Recallable =
  ## dataStoreTypesListByDataManager
  ## Gets all the data store/repository types that the resource supports.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564330 = newJObject()
  var query_564331 = newJObject()
  add(query_564331, "api-version", newJString(apiVersion))
  add(path_564330, "subscriptionId", newJString(subscriptionId))
  add(path_564330, "resourceGroupName", newJString(resourceGroupName))
  add(path_564330, "dataManagerName", newJString(dataManagerName))
  result = call_564329.call(path_564330, query_564331, nil, nil, nil)

var dataStoreTypesListByDataManager* = Call_DataStoreTypesListByDataManager_564321(
    name: "dataStoreTypesListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStoreTypes",
    validator: validate_DataStoreTypesListByDataManager_564322, base: "",
    url: url_DataStoreTypesListByDataManager_564323, schemes: {Scheme.Https})
type
  Call_DataStoreTypesGet_564332 = ref object of OpenApiRestCall_563556
proc url_DataStoreTypesGet_564334(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  assert "dataStoreTypeName" in path,
        "`dataStoreTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataStoreTypes/"),
               (kind: VariableSegment, value: "dataStoreTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataStoreTypesGet_564333(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the data store/repository type given its name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataStoreTypeName: JString (required)
  ##                    : The data store/repository type name for which details are needed.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataStoreTypeName` field"
  var valid_564335 = path.getOrDefault("dataStoreTypeName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "dataStoreTypeName", valid_564335
  var valid_564336 = path.getOrDefault("subscriptionId")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "subscriptionId", valid_564336
  var valid_564337 = path.getOrDefault("resourceGroupName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "resourceGroupName", valid_564337
  var valid_564338 = path.getOrDefault("dataManagerName")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "dataManagerName", valid_564338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564339 = query.getOrDefault("api-version")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "api-version", valid_564339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564340: Call_DataStoreTypesGet_564332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the data store/repository type given its name.
  ## 
  let valid = call_564340.validator(path, query, header, formData, body)
  let scheme = call_564340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564340.url(scheme.get, call_564340.host, call_564340.base,
                         call_564340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564340, url, valid)

proc call*(call_564341: Call_DataStoreTypesGet_564332; dataStoreTypeName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          dataManagerName: string): Recallable =
  ## dataStoreTypesGet
  ## Gets the data store/repository type given its name.
  ##   dataStoreTypeName: string (required)
  ##                    : The data store/repository type name for which details are needed.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564342 = newJObject()
  var query_564343 = newJObject()
  add(path_564342, "dataStoreTypeName", newJString(dataStoreTypeName))
  add(query_564343, "api-version", newJString(apiVersion))
  add(path_564342, "subscriptionId", newJString(subscriptionId))
  add(path_564342, "resourceGroupName", newJString(resourceGroupName))
  add(path_564342, "dataManagerName", newJString(dataManagerName))
  result = call_564341.call(path_564342, query_564343, nil, nil, nil)

var dataStoreTypesGet* = Call_DataStoreTypesGet_564332(name: "dataStoreTypesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStoreTypes/{dataStoreTypeName}",
    validator: validate_DataStoreTypesGet_564333, base: "",
    url: url_DataStoreTypesGet_564334, schemes: {Scheme.Https})
type
  Call_DataStoresListByDataManager_564344 = ref object of OpenApiRestCall_563556
proc url_DataStoresListByDataManager_564346(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataStoresListByDataManager_564345(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the data stores/repositories in the given resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564347 = path.getOrDefault("subscriptionId")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "subscriptionId", valid_564347
  var valid_564348 = path.getOrDefault("resourceGroupName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "resourceGroupName", valid_564348
  var valid_564349 = path.getOrDefault("dataManagerName")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "dataManagerName", valid_564349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564350 = query.getOrDefault("api-version")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "api-version", valid_564350
  var valid_564351 = query.getOrDefault("$filter")
  valid_564351 = validateParameter(valid_564351, JString, required = false,
                                 default = nil)
  if valid_564351 != nil:
    section.add "$filter", valid_564351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564352: Call_DataStoresListByDataManager_564344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the data stores/repositories in the given resource.
  ## 
  let valid = call_564352.validator(path, query, header, formData, body)
  let scheme = call_564352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564352.url(scheme.get, call_564352.host, call_564352.base,
                         call_564352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564352, url, valid)

proc call*(call_564353: Call_DataStoresListByDataManager_564344;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          dataManagerName: string; Filter: string = ""): Recallable =
  ## dataStoresListByDataManager
  ## Gets all the data stores/repositories in the given resource.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   Filter: string
  ##         : OData Filter options
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564354 = newJObject()
  var query_564355 = newJObject()
  add(query_564355, "api-version", newJString(apiVersion))
  add(path_564354, "subscriptionId", newJString(subscriptionId))
  add(path_564354, "resourceGroupName", newJString(resourceGroupName))
  add(query_564355, "$filter", newJString(Filter))
  add(path_564354, "dataManagerName", newJString(dataManagerName))
  result = call_564353.call(path_564354, query_564355, nil, nil, nil)

var dataStoresListByDataManager* = Call_DataStoresListByDataManager_564344(
    name: "dataStoresListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStores",
    validator: validate_DataStoresListByDataManager_564345, base: "",
    url: url_DataStoresListByDataManager_564346, schemes: {Scheme.Https})
type
  Call_DataStoresCreateOrUpdate_564368 = ref object of OpenApiRestCall_563556
proc url_DataStoresCreateOrUpdate_564370(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  assert "dataStoreName" in path, "`dataStoreName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataStores/"),
               (kind: VariableSegment, value: "dataStoreName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataStoresCreateOrUpdate_564369(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the data store/repository in the data manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataStoreName: JString (required)
  ##                : The data store/repository name to be created or updated.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataStoreName` field"
  var valid_564371 = path.getOrDefault("dataStoreName")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "dataStoreName", valid_564371
  var valid_564372 = path.getOrDefault("subscriptionId")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "subscriptionId", valid_564372
  var valid_564373 = path.getOrDefault("resourceGroupName")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "resourceGroupName", valid_564373
  var valid_564374 = path.getOrDefault("dataManagerName")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "dataManagerName", valid_564374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564375 = query.getOrDefault("api-version")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "api-version", valid_564375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dataStore: JObject (required)
  ##            : The data store/repository object to be created or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564377: Call_DataStoresCreateOrUpdate_564368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the data store/repository in the data manager.
  ## 
  let valid = call_564377.validator(path, query, header, formData, body)
  let scheme = call_564377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564377.url(scheme.get, call_564377.host, call_564377.base,
                         call_564377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564377, url, valid)

proc call*(call_564378: Call_DataStoresCreateOrUpdate_564368; apiVersion: string;
          dataStoreName: string; dataStore: JsonNode; subscriptionId: string;
          resourceGroupName: string; dataManagerName: string): Recallable =
  ## dataStoresCreateOrUpdate
  ## Creates or updates the data store/repository in the data manager.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   dataStoreName: string (required)
  ##                : The data store/repository name to be created or updated.
  ##   dataStore: JObject (required)
  ##            : The data store/repository object to be created or updated.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564379 = newJObject()
  var query_564380 = newJObject()
  var body_564381 = newJObject()
  add(query_564380, "api-version", newJString(apiVersion))
  add(path_564379, "dataStoreName", newJString(dataStoreName))
  if dataStore != nil:
    body_564381 = dataStore
  add(path_564379, "subscriptionId", newJString(subscriptionId))
  add(path_564379, "resourceGroupName", newJString(resourceGroupName))
  add(path_564379, "dataManagerName", newJString(dataManagerName))
  result = call_564378.call(path_564379, query_564380, nil, nil, body_564381)

var dataStoresCreateOrUpdate* = Call_DataStoresCreateOrUpdate_564368(
    name: "dataStoresCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStores/{dataStoreName}",
    validator: validate_DataStoresCreateOrUpdate_564369, base: "",
    url: url_DataStoresCreateOrUpdate_564370, schemes: {Scheme.Https})
type
  Call_DataStoresGet_564356 = ref object of OpenApiRestCall_563556
proc url_DataStoresGet_564358(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  assert "dataStoreName" in path, "`dataStoreName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataStores/"),
               (kind: VariableSegment, value: "dataStoreName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataStoresGet_564357(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets the data store/repository by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataStoreName: JString (required)
  ##                : The data store/repository name queried.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataStoreName` field"
  var valid_564359 = path.getOrDefault("dataStoreName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "dataStoreName", valid_564359
  var valid_564360 = path.getOrDefault("subscriptionId")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "subscriptionId", valid_564360
  var valid_564361 = path.getOrDefault("resourceGroupName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "resourceGroupName", valid_564361
  var valid_564362 = path.getOrDefault("dataManagerName")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "dataManagerName", valid_564362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564363 = query.getOrDefault("api-version")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "api-version", valid_564363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564364: Call_DataStoresGet_564356; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets the data store/repository by name.
  ## 
  let valid = call_564364.validator(path, query, header, formData, body)
  let scheme = call_564364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564364.url(scheme.get, call_564364.host, call_564364.base,
                         call_564364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564364, url, valid)

proc call*(call_564365: Call_DataStoresGet_564356; apiVersion: string;
          dataStoreName: string; subscriptionId: string; resourceGroupName: string;
          dataManagerName: string): Recallable =
  ## dataStoresGet
  ## This method gets the data store/repository by name.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   dataStoreName: string (required)
  ##                : The data store/repository name queried.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564366 = newJObject()
  var query_564367 = newJObject()
  add(query_564367, "api-version", newJString(apiVersion))
  add(path_564366, "dataStoreName", newJString(dataStoreName))
  add(path_564366, "subscriptionId", newJString(subscriptionId))
  add(path_564366, "resourceGroupName", newJString(resourceGroupName))
  add(path_564366, "dataManagerName", newJString(dataManagerName))
  result = call_564365.call(path_564366, query_564367, nil, nil, nil)

var dataStoresGet* = Call_DataStoresGet_564356(name: "dataStoresGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStores/{dataStoreName}",
    validator: validate_DataStoresGet_564357, base: "", url: url_DataStoresGet_564358,
    schemes: {Scheme.Https})
type
  Call_DataStoresDelete_564382 = ref object of OpenApiRestCall_563556
proc url_DataStoresDelete_564384(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  assert "dataStoreName" in path, "`dataStoreName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/dataStores/"),
               (kind: VariableSegment, value: "dataStoreName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataStoresDelete_564383(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## This method deletes the given data store/repository.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataStoreName: JString (required)
  ##                : The data store/repository name to be deleted.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataStoreName` field"
  var valid_564385 = path.getOrDefault("dataStoreName")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "dataStoreName", valid_564385
  var valid_564386 = path.getOrDefault("subscriptionId")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "subscriptionId", valid_564386
  var valid_564387 = path.getOrDefault("resourceGroupName")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "resourceGroupName", valid_564387
  var valid_564388 = path.getOrDefault("dataManagerName")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "dataManagerName", valid_564388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564389 = query.getOrDefault("api-version")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "api-version", valid_564389
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564390: Call_DataStoresDelete_564382; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method deletes the given data store/repository.
  ## 
  let valid = call_564390.validator(path, query, header, formData, body)
  let scheme = call_564390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564390.url(scheme.get, call_564390.host, call_564390.base,
                         call_564390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564390, url, valid)

proc call*(call_564391: Call_DataStoresDelete_564382; apiVersion: string;
          dataStoreName: string; subscriptionId: string; resourceGroupName: string;
          dataManagerName: string): Recallable =
  ## dataStoresDelete
  ## This method deletes the given data store/repository.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   dataStoreName: string (required)
  ##                : The data store/repository name to be deleted.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564392 = newJObject()
  var query_564393 = newJObject()
  add(query_564393, "api-version", newJString(apiVersion))
  add(path_564392, "dataStoreName", newJString(dataStoreName))
  add(path_564392, "subscriptionId", newJString(subscriptionId))
  add(path_564392, "resourceGroupName", newJString(resourceGroupName))
  add(path_564392, "dataManagerName", newJString(dataManagerName))
  result = call_564391.call(path_564392, query_564393, nil, nil, nil)

var dataStoresDelete* = Call_DataStoresDelete_564382(name: "dataStoresDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStores/{dataStoreName}",
    validator: validate_DataStoresDelete_564383, base: "",
    url: url_DataStoresDelete_564384, schemes: {Scheme.Https})
type
  Call_JobDefinitionsListByDataManager_564394 = ref object of OpenApiRestCall_563556
proc url_JobDefinitionsListByDataManager_564396(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/jobDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobDefinitionsListByDataManager_564395(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets all the job definitions of the given data manager resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564397 = path.getOrDefault("subscriptionId")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "subscriptionId", valid_564397
  var valid_564398 = path.getOrDefault("resourceGroupName")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "resourceGroupName", valid_564398
  var valid_564399 = path.getOrDefault("dataManagerName")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "dataManagerName", valid_564399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564400 = query.getOrDefault("api-version")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "api-version", valid_564400
  var valid_564401 = query.getOrDefault("$filter")
  valid_564401 = validateParameter(valid_564401, JString, required = false,
                                 default = nil)
  if valid_564401 != nil:
    section.add "$filter", valid_564401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564402: Call_JobDefinitionsListByDataManager_564394;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This method gets all the job definitions of the given data manager resource.
  ## 
  let valid = call_564402.validator(path, query, header, formData, body)
  let scheme = call_564402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564402.url(scheme.get, call_564402.host, call_564402.base,
                         call_564402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564402, url, valid)

proc call*(call_564403: Call_JobDefinitionsListByDataManager_564394;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          dataManagerName: string; Filter: string = ""): Recallable =
  ## jobDefinitionsListByDataManager
  ## This method gets all the job definitions of the given data manager resource.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   Filter: string
  ##         : OData Filter options
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564404 = newJObject()
  var query_564405 = newJObject()
  add(query_564405, "api-version", newJString(apiVersion))
  add(path_564404, "subscriptionId", newJString(subscriptionId))
  add(path_564404, "resourceGroupName", newJString(resourceGroupName))
  add(query_564405, "$filter", newJString(Filter))
  add(path_564404, "dataManagerName", newJString(dataManagerName))
  result = call_564403.call(path_564404, query_564405, nil, nil, nil)

var jobDefinitionsListByDataManager* = Call_JobDefinitionsListByDataManager_564394(
    name: "jobDefinitionsListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/jobDefinitions",
    validator: validate_JobDefinitionsListByDataManager_564395, base: "",
    url: url_JobDefinitionsListByDataManager_564396, schemes: {Scheme.Https})
type
  Call_JobsListByDataManager_564406 = ref object of OpenApiRestCall_563556
proc url_JobsListByDataManager_564408(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListByDataManager_564407(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets all the jobs at the data manager resource level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564409 = path.getOrDefault("subscriptionId")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "subscriptionId", valid_564409
  var valid_564410 = path.getOrDefault("resourceGroupName")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "resourceGroupName", valid_564410
  var valid_564411 = path.getOrDefault("dataManagerName")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "dataManagerName", valid_564411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564412 = query.getOrDefault("api-version")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "api-version", valid_564412
  var valid_564413 = query.getOrDefault("$filter")
  valid_564413 = validateParameter(valid_564413, JString, required = false,
                                 default = nil)
  if valid_564413 != nil:
    section.add "$filter", valid_564413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564414: Call_JobsListByDataManager_564406; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets all the jobs at the data manager resource level.
  ## 
  let valid = call_564414.validator(path, query, header, formData, body)
  let scheme = call_564414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564414.url(scheme.get, call_564414.host, call_564414.base,
                         call_564414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564414, url, valid)

proc call*(call_564415: Call_JobsListByDataManager_564406; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          dataManagerName: string; Filter: string = ""): Recallable =
  ## jobsListByDataManager
  ## This method gets all the jobs at the data manager resource level.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   Filter: string
  ##         : OData Filter options
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564416 = newJObject()
  var query_564417 = newJObject()
  add(query_564417, "api-version", newJString(apiVersion))
  add(path_564416, "subscriptionId", newJString(subscriptionId))
  add(path_564416, "resourceGroupName", newJString(resourceGroupName))
  add(query_564417, "$filter", newJString(Filter))
  add(path_564416, "dataManagerName", newJString(dataManagerName))
  result = call_564415.call(path_564416, query_564417, nil, nil, nil)

var jobsListByDataManager* = Call_JobsListByDataManager_564406(
    name: "jobsListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/jobs",
    validator: validate_JobsListByDataManager_564407, base: "",
    url: url_JobsListByDataManager_564408, schemes: {Scheme.Https})
type
  Call_PublicKeysListByDataManager_564418 = ref object of OpenApiRestCall_563556
proc url_PublicKeysListByDataManager_564420(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/publicKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublicKeysListByDataManager_564419(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets the list view of public keys, however it will only have one element.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564421 = path.getOrDefault("subscriptionId")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "subscriptionId", valid_564421
  var valid_564422 = path.getOrDefault("resourceGroupName")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "resourceGroupName", valid_564422
  var valid_564423 = path.getOrDefault("dataManagerName")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "dataManagerName", valid_564423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564424 = query.getOrDefault("api-version")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "api-version", valid_564424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564425: Call_PublicKeysListByDataManager_564418; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets the list view of public keys, however it will only have one element.
  ## 
  let valid = call_564425.validator(path, query, header, formData, body)
  let scheme = call_564425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564425.url(scheme.get, call_564425.host, call_564425.base,
                         call_564425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564425, url, valid)

proc call*(call_564426: Call_PublicKeysListByDataManager_564418;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          dataManagerName: string): Recallable =
  ## publicKeysListByDataManager
  ## This method gets the list view of public keys, however it will only have one element.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564427 = newJObject()
  var query_564428 = newJObject()
  add(query_564428, "api-version", newJString(apiVersion))
  add(path_564427, "subscriptionId", newJString(subscriptionId))
  add(path_564427, "resourceGroupName", newJString(resourceGroupName))
  add(path_564427, "dataManagerName", newJString(dataManagerName))
  result = call_564426.call(path_564427, query_564428, nil, nil, nil)

var publicKeysListByDataManager* = Call_PublicKeysListByDataManager_564418(
    name: "publicKeysListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/publicKeys",
    validator: validate_PublicKeysListByDataManager_564419, base: "",
    url: url_PublicKeysListByDataManager_564420, schemes: {Scheme.Https})
type
  Call_PublicKeysGet_564429 = ref object of OpenApiRestCall_563556
proc url_PublicKeysGet_564431(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dataManagerName" in path, "`dataManagerName` is a required path parameter"
  assert "publicKeyName" in path, "`publicKeyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HybridData/dataManagers/"),
               (kind: VariableSegment, value: "dataManagerName"),
               (kind: ConstantSegment, value: "/publicKeys/"),
               (kind: VariableSegment, value: "publicKeyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublicKeysGet_564430(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets the public keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   publicKeyName: JString (required)
  ##                : Name of the public key.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `publicKeyName` field"
  var valid_564432 = path.getOrDefault("publicKeyName")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "publicKeyName", valid_564432
  var valid_564433 = path.getOrDefault("subscriptionId")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "subscriptionId", valid_564433
  var valid_564434 = path.getOrDefault("resourceGroupName")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "resourceGroupName", valid_564434
  var valid_564435 = path.getOrDefault("dataManagerName")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "dataManagerName", valid_564435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564436 = query.getOrDefault("api-version")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "api-version", valid_564436
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564437: Call_PublicKeysGet_564429; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets the public keys.
  ## 
  let valid = call_564437.validator(path, query, header, formData, body)
  let scheme = call_564437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564437.url(scheme.get, call_564437.host, call_564437.base,
                         call_564437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564437, url, valid)

proc call*(call_564438: Call_PublicKeysGet_564429; apiVersion: string;
          publicKeyName: string; subscriptionId: string; resourceGroupName: string;
          dataManagerName: string): Recallable =
  ## publicKeysGet
  ## This method gets the public keys.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   publicKeyName: string (required)
  ##                : Name of the public key.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_564439 = newJObject()
  var query_564440 = newJObject()
  add(query_564440, "api-version", newJString(apiVersion))
  add(path_564439, "publicKeyName", newJString(publicKeyName))
  add(path_564439, "subscriptionId", newJString(subscriptionId))
  add(path_564439, "resourceGroupName", newJString(resourceGroupName))
  add(path_564439, "dataManagerName", newJString(dataManagerName))
  result = call_564438.call(path_564439, query_564440, nil, nil, nil)

var publicKeysGet* = Call_PublicKeysGet_564429(name: "publicKeysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/publicKeys/{publicKeyName}",
    validator: validate_PublicKeysGet_564430, base: "", url: url_PublicKeysGet_564431,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
