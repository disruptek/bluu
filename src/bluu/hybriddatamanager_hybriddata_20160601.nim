
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "hybriddatamanager-hybriddata"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567880 = ref object of OpenApiRestCall_567658
proc url_OperationsList_567882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567881(path: JsonNode; query: JsonNode;
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
  var valid_568041 = query.getOrDefault("api-version")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "api-version", valid_568041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568064: Call_OperationsList_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568064.validator(path, query, header, formData, body)
  let scheme = call_568064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568064.url(scheme.get, call_568064.host, call_568064.base,
                         call_568064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568064, url, valid)

proc call*(call_568135: Call_OperationsList_567880; apiVersion: string): Recallable =
  ## operationsList
  ##   apiVersion: string (required)
  ##             : The API Version
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  result = call_568135.call(nil, query_568136, nil, nil, nil)

var operationsList* = Call_OperationsList_567880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.HybridData/operations",
    validator: validate_OperationsList_567881, base: "", url: url_OperationsList_567882,
    schemes: {Scheme.Https})
type
  Call_DataManagersList_568176 = ref object of OpenApiRestCall_567658
proc url_DataManagersList_568178(protocol: Scheme; host: string; base: string;
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

proc validate_DataManagersList_568177(path: JsonNode; query: JsonNode;
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
  var valid_568193 = path.getOrDefault("subscriptionId")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "subscriptionId", valid_568193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568194 = query.getOrDefault("api-version")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "api-version", valid_568194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568195: Call_DataManagersList_568176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the data manager resources available under the subscription.
  ## 
  let valid = call_568195.validator(path, query, header, formData, body)
  let scheme = call_568195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568195.url(scheme.get, call_568195.host, call_568195.base,
                         call_568195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568195, url, valid)

proc call*(call_568196: Call_DataManagersList_568176; apiVersion: string;
          subscriptionId: string): Recallable =
  ## dataManagersList
  ## Lists all the data manager resources available under the subscription.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  var path_568197 = newJObject()
  var query_568198 = newJObject()
  add(query_568198, "api-version", newJString(apiVersion))
  add(path_568197, "subscriptionId", newJString(subscriptionId))
  result = call_568196.call(path_568197, query_568198, nil, nil, nil)

var dataManagersList* = Call_DataManagersList_568176(name: "dataManagersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.HybridData/dataManagers",
    validator: validate_DataManagersList_568177, base: "",
    url: url_DataManagersList_568178, schemes: {Scheme.Https})
type
  Call_DataManagersListByResourceGroup_568199 = ref object of OpenApiRestCall_567658
proc url_DataManagersListByResourceGroup_568201(protocol: Scheme; host: string;
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

proc validate_DataManagersListByResourceGroup_568200(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the data manager resources available under the given resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568202 = path.getOrDefault("resourceGroupName")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "resourceGroupName", valid_568202
  var valid_568203 = path.getOrDefault("subscriptionId")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "subscriptionId", valid_568203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568204 = query.getOrDefault("api-version")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "api-version", valid_568204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568205: Call_DataManagersListByResourceGroup_568199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the data manager resources available under the given resource group.
  ## 
  let valid = call_568205.validator(path, query, header, formData, body)
  let scheme = call_568205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568205.url(scheme.get, call_568205.host, call_568205.base,
                         call_568205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568205, url, valid)

proc call*(call_568206: Call_DataManagersListByResourceGroup_568199;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## dataManagersListByResourceGroup
  ## Lists all the data manager resources available under the given resource group.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  var path_568207 = newJObject()
  var query_568208 = newJObject()
  add(path_568207, "resourceGroupName", newJString(resourceGroupName))
  add(query_568208, "api-version", newJString(apiVersion))
  add(path_568207, "subscriptionId", newJString(subscriptionId))
  result = call_568206.call(path_568207, query_568208, nil, nil, nil)

var dataManagersListByResourceGroup* = Call_DataManagersListByResourceGroup_568199(
    name: "dataManagersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers",
    validator: validate_DataManagersListByResourceGroup_568200, base: "",
    url: url_DataManagersListByResourceGroup_568201, schemes: {Scheme.Https})
type
  Call_DataManagersCreate_568220 = ref object of OpenApiRestCall_567658
proc url_DataManagersCreate_568222(protocol: Scheme; host: string; base: string;
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

proc validate_DataManagersCreate_568221(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a new data manager resource with the specified parameters. Existing resources cannot be updated with this API
  ## and should instead be updated with the Update data manager resource API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568223 = path.getOrDefault("resourceGroupName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "resourceGroupName", valid_568223
  var valid_568224 = path.getOrDefault("subscriptionId")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "subscriptionId", valid_568224
  var valid_568225 = path.getOrDefault("dataManagerName")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "dataManagerName", valid_568225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568226 = query.getOrDefault("api-version")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "api-version", valid_568226
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

proc call*(call_568228: Call_DataManagersCreate_568220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new data manager resource with the specified parameters. Existing resources cannot be updated with this API
  ## and should instead be updated with the Update data manager resource API.
  ## 
  let valid = call_568228.validator(path, query, header, formData, body)
  let scheme = call_568228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568228.url(scheme.get, call_568228.host, call_568228.base,
                         call_568228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568228, url, valid)

proc call*(call_568229: Call_DataManagersCreate_568220; dataManager: JsonNode;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataManagerName: string): Recallable =
  ## dataManagersCreate
  ## Creates a new data manager resource with the specified parameters. Existing resources cannot be updated with this API
  ## and should instead be updated with the Update data manager resource API.
  ##   dataManager: JObject (required)
  ##              : Data manager resource details from request body.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_568230 = newJObject()
  var query_568231 = newJObject()
  var body_568232 = newJObject()
  if dataManager != nil:
    body_568232 = dataManager
  add(path_568230, "resourceGroupName", newJString(resourceGroupName))
  add(query_568231, "api-version", newJString(apiVersion))
  add(path_568230, "subscriptionId", newJString(subscriptionId))
  add(path_568230, "dataManagerName", newJString(dataManagerName))
  result = call_568229.call(path_568230, query_568231, nil, nil, body_568232)

var dataManagersCreate* = Call_DataManagersCreate_568220(
    name: "dataManagersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}",
    validator: validate_DataManagersCreate_568221, base: "",
    url: url_DataManagersCreate_568222, schemes: {Scheme.Https})
type
  Call_DataManagersGet_568209 = ref object of OpenApiRestCall_567658
proc url_DataManagersGet_568211(protocol: Scheme; host: string; base: string;
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

proc validate_DataManagersGet_568210(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets information about the specified data manager resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568212 = path.getOrDefault("resourceGroupName")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "resourceGroupName", valid_568212
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
  var valid_568214 = path.getOrDefault("dataManagerName")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "dataManagerName", valid_568214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568215 = query.getOrDefault("api-version")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "api-version", valid_568215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568216: Call_DataManagersGet_568209; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified data manager resource.
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_DataManagersGet_568209; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; dataManagerName: string): Recallable =
  ## dataManagersGet
  ## Gets information about the specified data manager resource.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_568218 = newJObject()
  var query_568219 = newJObject()
  add(path_568218, "resourceGroupName", newJString(resourceGroupName))
  add(query_568219, "api-version", newJString(apiVersion))
  add(path_568218, "subscriptionId", newJString(subscriptionId))
  add(path_568218, "dataManagerName", newJString(dataManagerName))
  result = call_568217.call(path_568218, query_568219, nil, nil, nil)

var dataManagersGet* = Call_DataManagersGet_568209(name: "dataManagersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}",
    validator: validate_DataManagersGet_568210, base: "", url: url_DataManagersGet_568211,
    schemes: {Scheme.Https})
type
  Call_DataManagersUpdate_568244 = ref object of OpenApiRestCall_567658
proc url_DataManagersUpdate_568246(protocol: Scheme; host: string; base: string;
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

proc validate_DataManagersUpdate_568245(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the properties of an existing data manager resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568247 = path.getOrDefault("resourceGroupName")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "resourceGroupName", valid_568247
  var valid_568248 = path.getOrDefault("subscriptionId")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "subscriptionId", valid_568248
  var valid_568249 = path.getOrDefault("dataManagerName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "dataManagerName", valid_568249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568250 = query.getOrDefault("api-version")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "api-version", valid_568250
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The patch will be performed only if the ETag of the data manager resource on the server matches this value.
  section = newJObject()
  var valid_568251 = header.getOrDefault("If-Match")
  valid_568251 = validateParameter(valid_568251, JString, required = false,
                                 default = nil)
  if valid_568251 != nil:
    section.add "If-Match", valid_568251
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

proc call*(call_568253: Call_DataManagersUpdate_568244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing data manager resource.
  ## 
  let valid = call_568253.validator(path, query, header, formData, body)
  let scheme = call_568253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568253.url(scheme.get, call_568253.host, call_568253.base,
                         call_568253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568253, url, valid)

proc call*(call_568254: Call_DataManagersUpdate_568244; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          dataManagerUpdateParameter: JsonNode; dataManagerName: string): Recallable =
  ## dataManagersUpdate
  ## Updates the properties of an existing data manager resource.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerUpdateParameter: JObject (required)
  ##                             : Data manager resource details from request body.
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_568255 = newJObject()
  var query_568256 = newJObject()
  var body_568257 = newJObject()
  add(path_568255, "resourceGroupName", newJString(resourceGroupName))
  add(query_568256, "api-version", newJString(apiVersion))
  add(path_568255, "subscriptionId", newJString(subscriptionId))
  if dataManagerUpdateParameter != nil:
    body_568257 = dataManagerUpdateParameter
  add(path_568255, "dataManagerName", newJString(dataManagerName))
  result = call_568254.call(path_568255, query_568256, nil, nil, body_568257)

var dataManagersUpdate* = Call_DataManagersUpdate_568244(
    name: "dataManagersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}",
    validator: validate_DataManagersUpdate_568245, base: "",
    url: url_DataManagersUpdate_568246, schemes: {Scheme.Https})
type
  Call_DataManagersDelete_568233 = ref object of OpenApiRestCall_567658
proc url_DataManagersDelete_568235(protocol: Scheme; host: string; base: string;
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

proc validate_DataManagersDelete_568234(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a data manager resource in Microsoft Azure.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568236 = path.getOrDefault("resourceGroupName")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "resourceGroupName", valid_568236
  var valid_568237 = path.getOrDefault("subscriptionId")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "subscriptionId", valid_568237
  var valid_568238 = path.getOrDefault("dataManagerName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "dataManagerName", valid_568238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568239 = query.getOrDefault("api-version")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "api-version", valid_568239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568240: Call_DataManagersDelete_568233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a data manager resource in Microsoft Azure.
  ## 
  let valid = call_568240.validator(path, query, header, formData, body)
  let scheme = call_568240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568240.url(scheme.get, call_568240.host, call_568240.base,
                         call_568240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568240, url, valid)

proc call*(call_568241: Call_DataManagersDelete_568233; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; dataManagerName: string): Recallable =
  ## dataManagersDelete
  ## Deletes a data manager resource in Microsoft Azure.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_568242 = newJObject()
  var query_568243 = newJObject()
  add(path_568242, "resourceGroupName", newJString(resourceGroupName))
  add(query_568243, "api-version", newJString(apiVersion))
  add(path_568242, "subscriptionId", newJString(subscriptionId))
  add(path_568242, "dataManagerName", newJString(dataManagerName))
  result = call_568241.call(path_568242, query_568243, nil, nil, nil)

var dataManagersDelete* = Call_DataManagersDelete_568233(
    name: "dataManagersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}",
    validator: validate_DataManagersDelete_568234, base: "",
    url: url_DataManagersDelete_568235, schemes: {Scheme.Https})
type
  Call_DataServicesListByDataManager_568258 = ref object of OpenApiRestCall_567658
proc url_DataServicesListByDataManager_568260(protocol: Scheme; host: string;
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

proc validate_DataServicesListByDataManager_568259(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets all the data services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
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
  var valid_568263 = path.getOrDefault("dataManagerName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "dataManagerName", valid_568263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
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

proc call*(call_568265: Call_DataServicesListByDataManager_568258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets all the data services.
  ## 
  let valid = call_568265.validator(path, query, header, formData, body)
  let scheme = call_568265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568265.url(scheme.get, call_568265.host, call_568265.base,
                         call_568265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568265, url, valid)

proc call*(call_568266: Call_DataServicesListByDataManager_568258;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataManagerName: string): Recallable =
  ## dataServicesListByDataManager
  ## This method gets all the data services.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_568267 = newJObject()
  var query_568268 = newJObject()
  add(path_568267, "resourceGroupName", newJString(resourceGroupName))
  add(query_568268, "api-version", newJString(apiVersion))
  add(path_568267, "subscriptionId", newJString(subscriptionId))
  add(path_568267, "dataManagerName", newJString(dataManagerName))
  result = call_568266.call(path_568267, query_568268, nil, nil, nil)

var dataServicesListByDataManager* = Call_DataServicesListByDataManager_568258(
    name: "dataServicesListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices",
    validator: validate_DataServicesListByDataManager_568259, base: "",
    url: url_DataServicesListByDataManager_568260, schemes: {Scheme.Https})
type
  Call_DataServicesGet_568269 = ref object of OpenApiRestCall_567658
proc url_DataServicesGet_568271(protocol: Scheme; host: string; base: string;
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

proc validate_DataServicesGet_568270(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the data service that match the data service name given.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   dataServiceName: JString (required)
  ##                  : The name of the data service that is being queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568272 = path.getOrDefault("resourceGroupName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "resourceGroupName", valid_568272
  var valid_568273 = path.getOrDefault("subscriptionId")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "subscriptionId", valid_568273
  var valid_568274 = path.getOrDefault("dataManagerName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "dataManagerName", valid_568274
  var valid_568275 = path.getOrDefault("dataServiceName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "dataServiceName", valid_568275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568276 = query.getOrDefault("api-version")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "api-version", valid_568276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568277: Call_DataServicesGet_568269; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the data service that match the data service name given.
  ## 
  let valid = call_568277.validator(path, query, header, formData, body)
  let scheme = call_568277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568277.url(scheme.get, call_568277.host, call_568277.base,
                         call_568277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568277, url, valid)

proc call*(call_568278: Call_DataServicesGet_568269; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; dataManagerName: string;
          dataServiceName: string): Recallable =
  ## dataServicesGet
  ## Gets the data service that match the data service name given.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   dataServiceName: string (required)
  ##                  : The name of the data service that is being queried.
  var path_568279 = newJObject()
  var query_568280 = newJObject()
  add(path_568279, "resourceGroupName", newJString(resourceGroupName))
  add(query_568280, "api-version", newJString(apiVersion))
  add(path_568279, "subscriptionId", newJString(subscriptionId))
  add(path_568279, "dataManagerName", newJString(dataManagerName))
  add(path_568279, "dataServiceName", newJString(dataServiceName))
  result = call_568278.call(path_568279, query_568280, nil, nil, nil)

var dataServicesGet* = Call_DataServicesGet_568269(name: "dataServicesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}",
    validator: validate_DataServicesGet_568270, base: "", url: url_DataServicesGet_568271,
    schemes: {Scheme.Https})
type
  Call_JobDefinitionsListByDataService_568281 = ref object of OpenApiRestCall_567658
proc url_JobDefinitionsListByDataService_568283(protocol: Scheme; host: string;
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

proc validate_JobDefinitionsListByDataService_568282(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets all the job definitions of the given data service name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   dataServiceName: JString (required)
  ##                  : The data service type of interest.
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
  var valid_568287 = path.getOrDefault("dataManagerName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "dataManagerName", valid_568287
  var valid_568288 = path.getOrDefault("dataServiceName")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "dataServiceName", valid_568288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568289 = query.getOrDefault("api-version")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "api-version", valid_568289
  var valid_568290 = query.getOrDefault("$filter")
  valid_568290 = validateParameter(valid_568290, JString, required = false,
                                 default = nil)
  if valid_568290 != nil:
    section.add "$filter", valid_568290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568291: Call_JobDefinitionsListByDataService_568281;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This method gets all the job definitions of the given data service name.
  ## 
  let valid = call_568291.validator(path, query, header, formData, body)
  let scheme = call_568291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568291.url(scheme.get, call_568291.host, call_568291.base,
                         call_568291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568291, url, valid)

proc call*(call_568292: Call_JobDefinitionsListByDataService_568281;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataManagerName: string; dataServiceName: string; Filter: string = ""): Recallable =
  ## jobDefinitionsListByDataService
  ## This method gets all the job definitions of the given data service name.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   dataServiceName: string (required)
  ##                  : The data service type of interest.
  ##   Filter: string
  ##         : OData Filter options
  var path_568293 = newJObject()
  var query_568294 = newJObject()
  add(path_568293, "resourceGroupName", newJString(resourceGroupName))
  add(query_568294, "api-version", newJString(apiVersion))
  add(path_568293, "subscriptionId", newJString(subscriptionId))
  add(path_568293, "dataManagerName", newJString(dataManagerName))
  add(path_568293, "dataServiceName", newJString(dataServiceName))
  add(query_568294, "$filter", newJString(Filter))
  result = call_568292.call(path_568293, query_568294, nil, nil, nil)

var jobDefinitionsListByDataService* = Call_JobDefinitionsListByDataService_568281(
    name: "jobDefinitionsListByDataService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions",
    validator: validate_JobDefinitionsListByDataService_568282, base: "",
    url: url_JobDefinitionsListByDataService_568283, schemes: {Scheme.Https})
type
  Call_JobDefinitionsCreateOrUpdate_568308 = ref object of OpenApiRestCall_567658
proc url_JobDefinitionsCreateOrUpdate_568310(protocol: Scheme; host: string;
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

proc validate_JobDefinitionsCreateOrUpdate_568309(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a job definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   jobDefinitionName: JString (required)
  ##                    : The job definition name to be created or updated.
  ##   dataServiceName: JString (required)
  ##                  : The data service type of the job definition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568311 = path.getOrDefault("resourceGroupName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "resourceGroupName", valid_568311
  var valid_568312 = path.getOrDefault("subscriptionId")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "subscriptionId", valid_568312
  var valid_568313 = path.getOrDefault("dataManagerName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "dataManagerName", valid_568313
  var valid_568314 = path.getOrDefault("jobDefinitionName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "jobDefinitionName", valid_568314
  var valid_568315 = path.getOrDefault("dataServiceName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "dataServiceName", valid_568315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568316 = query.getOrDefault("api-version")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "api-version", valid_568316
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

proc call*(call_568318: Call_JobDefinitionsCreateOrUpdate_568308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job definition.
  ## 
  let valid = call_568318.validator(path, query, header, formData, body)
  let scheme = call_568318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568318.url(scheme.get, call_568318.host, call_568318.base,
                         call_568318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568318, url, valid)

proc call*(call_568319: Call_JobDefinitionsCreateOrUpdate_568308;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataManagerName: string; jobDefinitionName: string;
          dataServiceName: string; jobDefinition: JsonNode): Recallable =
  ## jobDefinitionsCreateOrUpdate
  ## Creates or updates a job definition.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   jobDefinitionName: string (required)
  ##                    : The job definition name to be created or updated.
  ##   dataServiceName: string (required)
  ##                  : The data service type of the job definition.
  ##   jobDefinition: JObject (required)
  ##                : Job Definition object to be created or updated.
  var path_568320 = newJObject()
  var query_568321 = newJObject()
  var body_568322 = newJObject()
  add(path_568320, "resourceGroupName", newJString(resourceGroupName))
  add(query_568321, "api-version", newJString(apiVersion))
  add(path_568320, "subscriptionId", newJString(subscriptionId))
  add(path_568320, "dataManagerName", newJString(dataManagerName))
  add(path_568320, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_568320, "dataServiceName", newJString(dataServiceName))
  if jobDefinition != nil:
    body_568322 = jobDefinition
  result = call_568319.call(path_568320, query_568321, nil, nil, body_568322)

var jobDefinitionsCreateOrUpdate* = Call_JobDefinitionsCreateOrUpdate_568308(
    name: "jobDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}",
    validator: validate_JobDefinitionsCreateOrUpdate_568309, base: "",
    url: url_JobDefinitionsCreateOrUpdate_568310, schemes: {Scheme.Https})
type
  Call_JobDefinitionsGet_568295 = ref object of OpenApiRestCall_567658
proc url_JobDefinitionsGet_568297(protocol: Scheme; host: string; base: string;
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

proc validate_JobDefinitionsGet_568296(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## This method gets job definition object by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   jobDefinitionName: JString (required)
  ##                    : The job definition name that is being queried.
  ##   dataServiceName: JString (required)
  ##                  : The data service name of the job definition
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
  var valid_568300 = path.getOrDefault("dataManagerName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "dataManagerName", valid_568300
  var valid_568301 = path.getOrDefault("jobDefinitionName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "jobDefinitionName", valid_568301
  var valid_568302 = path.getOrDefault("dataServiceName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "dataServiceName", valid_568302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568303 = query.getOrDefault("api-version")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "api-version", valid_568303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568304: Call_JobDefinitionsGet_568295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets job definition object by name.
  ## 
  let valid = call_568304.validator(path, query, header, formData, body)
  let scheme = call_568304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568304.url(scheme.get, call_568304.host, call_568304.base,
                         call_568304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568304, url, valid)

proc call*(call_568305: Call_JobDefinitionsGet_568295; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; dataManagerName: string;
          jobDefinitionName: string; dataServiceName: string): Recallable =
  ## jobDefinitionsGet
  ## This method gets job definition object by name.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   jobDefinitionName: string (required)
  ##                    : The job definition name that is being queried.
  ##   dataServiceName: string (required)
  ##                  : The data service name of the job definition
  var path_568306 = newJObject()
  var query_568307 = newJObject()
  add(path_568306, "resourceGroupName", newJString(resourceGroupName))
  add(query_568307, "api-version", newJString(apiVersion))
  add(path_568306, "subscriptionId", newJString(subscriptionId))
  add(path_568306, "dataManagerName", newJString(dataManagerName))
  add(path_568306, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_568306, "dataServiceName", newJString(dataServiceName))
  result = call_568305.call(path_568306, query_568307, nil, nil, nil)

var jobDefinitionsGet* = Call_JobDefinitionsGet_568295(name: "jobDefinitionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}",
    validator: validate_JobDefinitionsGet_568296, base: "",
    url: url_JobDefinitionsGet_568297, schemes: {Scheme.Https})
type
  Call_JobDefinitionsDelete_568323 = ref object of OpenApiRestCall_567658
proc url_JobDefinitionsDelete_568325(protocol: Scheme; host: string; base: string;
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

proc validate_JobDefinitionsDelete_568324(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method deletes the given job definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   jobDefinitionName: JString (required)
  ##                    : The job definition name to be deleted.
  ##   dataServiceName: JString (required)
  ##                  : The data service type of the job definition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568326 = path.getOrDefault("resourceGroupName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "resourceGroupName", valid_568326
  var valid_568327 = path.getOrDefault("subscriptionId")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "subscriptionId", valid_568327
  var valid_568328 = path.getOrDefault("dataManagerName")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "dataManagerName", valid_568328
  var valid_568329 = path.getOrDefault("jobDefinitionName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "jobDefinitionName", valid_568329
  var valid_568330 = path.getOrDefault("dataServiceName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "dataServiceName", valid_568330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568331 = query.getOrDefault("api-version")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "api-version", valid_568331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568332: Call_JobDefinitionsDelete_568323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method deletes the given job definition.
  ## 
  let valid = call_568332.validator(path, query, header, formData, body)
  let scheme = call_568332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568332.url(scheme.get, call_568332.host, call_568332.base,
                         call_568332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568332, url, valid)

proc call*(call_568333: Call_JobDefinitionsDelete_568323;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataManagerName: string; jobDefinitionName: string;
          dataServiceName: string): Recallable =
  ## jobDefinitionsDelete
  ## This method deletes the given job definition.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   jobDefinitionName: string (required)
  ##                    : The job definition name to be deleted.
  ##   dataServiceName: string (required)
  ##                  : The data service type of the job definition.
  var path_568334 = newJObject()
  var query_568335 = newJObject()
  add(path_568334, "resourceGroupName", newJString(resourceGroupName))
  add(query_568335, "api-version", newJString(apiVersion))
  add(path_568334, "subscriptionId", newJString(subscriptionId))
  add(path_568334, "dataManagerName", newJString(dataManagerName))
  add(path_568334, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_568334, "dataServiceName", newJString(dataServiceName))
  result = call_568333.call(path_568334, query_568335, nil, nil, nil)

var jobDefinitionsDelete* = Call_JobDefinitionsDelete_568323(
    name: "jobDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}",
    validator: validate_JobDefinitionsDelete_568324, base: "",
    url: url_JobDefinitionsDelete_568325, schemes: {Scheme.Https})
type
  Call_JobsListByJobDefinition_568336 = ref object of OpenApiRestCall_567658
proc url_JobsListByJobDefinition_568338(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByJobDefinition_568337(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets all the jobs of a given job definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   jobDefinitionName: JString (required)
  ##                    : The name of the job definition for which jobs are needed.
  ##   dataServiceName: JString (required)
  ##                  : The name of the data service of the job definition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568339 = path.getOrDefault("resourceGroupName")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "resourceGroupName", valid_568339
  var valid_568340 = path.getOrDefault("subscriptionId")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "subscriptionId", valid_568340
  var valid_568341 = path.getOrDefault("dataManagerName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "dataManagerName", valid_568341
  var valid_568342 = path.getOrDefault("jobDefinitionName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "jobDefinitionName", valid_568342
  var valid_568343 = path.getOrDefault("dataServiceName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "dataServiceName", valid_568343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568344 = query.getOrDefault("api-version")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "api-version", valid_568344
  var valid_568345 = query.getOrDefault("$filter")
  valid_568345 = validateParameter(valid_568345, JString, required = false,
                                 default = nil)
  if valid_568345 != nil:
    section.add "$filter", valid_568345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568346: Call_JobsListByJobDefinition_568336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets all the jobs of a given job definition.
  ## 
  let valid = call_568346.validator(path, query, header, formData, body)
  let scheme = call_568346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568346.url(scheme.get, call_568346.host, call_568346.base,
                         call_568346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568346, url, valid)

proc call*(call_568347: Call_JobsListByJobDefinition_568336;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataManagerName: string; jobDefinitionName: string;
          dataServiceName: string; Filter: string = ""): Recallable =
  ## jobsListByJobDefinition
  ## This method gets all the jobs of a given job definition.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   jobDefinitionName: string (required)
  ##                    : The name of the job definition for which jobs are needed.
  ##   dataServiceName: string (required)
  ##                  : The name of the data service of the job definition.
  ##   Filter: string
  ##         : OData Filter options
  var path_568348 = newJObject()
  var query_568349 = newJObject()
  add(path_568348, "resourceGroupName", newJString(resourceGroupName))
  add(query_568349, "api-version", newJString(apiVersion))
  add(path_568348, "subscriptionId", newJString(subscriptionId))
  add(path_568348, "dataManagerName", newJString(dataManagerName))
  add(path_568348, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_568348, "dataServiceName", newJString(dataServiceName))
  add(query_568349, "$filter", newJString(Filter))
  result = call_568347.call(path_568348, query_568349, nil, nil, nil)

var jobsListByJobDefinition* = Call_JobsListByJobDefinition_568336(
    name: "jobsListByJobDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}/jobs",
    validator: validate_JobsListByJobDefinition_568337, base: "",
    url: url_JobsListByJobDefinition_568338, schemes: {Scheme.Https})
type
  Call_JobsGet_568350 = ref object of OpenApiRestCall_567658
proc url_JobsGet_568352(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_568351(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets a data manager job given the jobId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   jobId: JString (required)
  ##        : The job id of the job queried.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   jobDefinitionName: JString (required)
  ##                    : The name of the job definition of the job.
  ##   dataServiceName: JString (required)
  ##                  : The name of the data service of the job definition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568353 = path.getOrDefault("resourceGroupName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "resourceGroupName", valid_568353
  var valid_568354 = path.getOrDefault("jobId")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "jobId", valid_568354
  var valid_568355 = path.getOrDefault("subscriptionId")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "subscriptionId", valid_568355
  var valid_568356 = path.getOrDefault("dataManagerName")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "dataManagerName", valid_568356
  var valid_568357 = path.getOrDefault("jobDefinitionName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "jobDefinitionName", valid_568357
  var valid_568358 = path.getOrDefault("dataServiceName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "dataServiceName", valid_568358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $expand: JString
  ##          : $expand is supported on details parameter for job, which provides details on the job stages.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568359 = query.getOrDefault("api-version")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "api-version", valid_568359
  var valid_568360 = query.getOrDefault("$expand")
  valid_568360 = validateParameter(valid_568360, JString, required = false,
                                 default = nil)
  if valid_568360 != nil:
    section.add "$expand", valid_568360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568361: Call_JobsGet_568350; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets a data manager job given the jobId.
  ## 
  let valid = call_568361.validator(path, query, header, formData, body)
  let scheme = call_568361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568361.url(scheme.get, call_568361.host, call_568361.base,
                         call_568361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568361, url, valid)

proc call*(call_568362: Call_JobsGet_568350; resourceGroupName: string;
          apiVersion: string; jobId: string; subscriptionId: string;
          dataManagerName: string; jobDefinitionName: string;
          dataServiceName: string; Expand: string = ""): Recallable =
  ## jobsGet
  ## This method gets a data manager job given the jobId.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   Expand: string
  ##         : $expand is supported on details parameter for job, which provides details on the job stages.
  ##   jobId: string (required)
  ##        : The job id of the job queried.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   jobDefinitionName: string (required)
  ##                    : The name of the job definition of the job.
  ##   dataServiceName: string (required)
  ##                  : The name of the data service of the job definition.
  var path_568363 = newJObject()
  var query_568364 = newJObject()
  add(path_568363, "resourceGroupName", newJString(resourceGroupName))
  add(query_568364, "api-version", newJString(apiVersion))
  add(query_568364, "$expand", newJString(Expand))
  add(path_568363, "jobId", newJString(jobId))
  add(path_568363, "subscriptionId", newJString(subscriptionId))
  add(path_568363, "dataManagerName", newJString(dataManagerName))
  add(path_568363, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_568363, "dataServiceName", newJString(dataServiceName))
  result = call_568362.call(path_568363, query_568364, nil, nil, nil)

var jobsGet* = Call_JobsGet_568350(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}/jobs/{jobId}",
                                validator: validate_JobsGet_568351, base: "",
                                url: url_JobsGet_568352, schemes: {Scheme.Https})
type
  Call_JobsCancel_568365 = ref object of OpenApiRestCall_567658
proc url_JobsCancel_568367(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsCancel_568366(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the given job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   jobId: JString (required)
  ##        : The job id of the job queried.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   jobDefinitionName: JString (required)
  ##                    : The name of the job definition of the job.
  ##   dataServiceName: JString (required)
  ##                  : The name of the data service of the job definition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568368 = path.getOrDefault("resourceGroupName")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "resourceGroupName", valid_568368
  var valid_568369 = path.getOrDefault("jobId")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "jobId", valid_568369
  var valid_568370 = path.getOrDefault("subscriptionId")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "subscriptionId", valid_568370
  var valid_568371 = path.getOrDefault("dataManagerName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "dataManagerName", valid_568371
  var valid_568372 = path.getOrDefault("jobDefinitionName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "jobDefinitionName", valid_568372
  var valid_568373 = path.getOrDefault("dataServiceName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "dataServiceName", valid_568373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568374 = query.getOrDefault("api-version")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "api-version", valid_568374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568375: Call_JobsCancel_568365; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the given job.
  ## 
  let valid = call_568375.validator(path, query, header, formData, body)
  let scheme = call_568375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568375.url(scheme.get, call_568375.host, call_568375.base,
                         call_568375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568375, url, valid)

proc call*(call_568376: Call_JobsCancel_568365; resourceGroupName: string;
          apiVersion: string; jobId: string; subscriptionId: string;
          dataManagerName: string; jobDefinitionName: string;
          dataServiceName: string): Recallable =
  ## jobsCancel
  ## Cancels the given job.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   jobId: string (required)
  ##        : The job id of the job queried.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   jobDefinitionName: string (required)
  ##                    : The name of the job definition of the job.
  ##   dataServiceName: string (required)
  ##                  : The name of the data service of the job definition.
  var path_568377 = newJObject()
  var query_568378 = newJObject()
  add(path_568377, "resourceGroupName", newJString(resourceGroupName))
  add(query_568378, "api-version", newJString(apiVersion))
  add(path_568377, "jobId", newJString(jobId))
  add(path_568377, "subscriptionId", newJString(subscriptionId))
  add(path_568377, "dataManagerName", newJString(dataManagerName))
  add(path_568377, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_568377, "dataServiceName", newJString(dataServiceName))
  result = call_568376.call(path_568377, query_568378, nil, nil, nil)

var jobsCancel* = Call_JobsCancel_568365(name: "jobsCancel",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}/jobs/{jobId}/cancel",
                                      validator: validate_JobsCancel_568366,
                                      base: "", url: url_JobsCancel_568367,
                                      schemes: {Scheme.Https})
type
  Call_JobsResume_568379 = ref object of OpenApiRestCall_567658
proc url_JobsResume_568381(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsResume_568380(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Resumes the given job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   jobId: JString (required)
  ##        : The job id of the job queried.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   jobDefinitionName: JString (required)
  ##                    : The name of the job definition of the job.
  ##   dataServiceName: JString (required)
  ##                  : The name of the data service of the job definition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568382 = path.getOrDefault("resourceGroupName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "resourceGroupName", valid_568382
  var valid_568383 = path.getOrDefault("jobId")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "jobId", valid_568383
  var valid_568384 = path.getOrDefault("subscriptionId")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "subscriptionId", valid_568384
  var valid_568385 = path.getOrDefault("dataManagerName")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "dataManagerName", valid_568385
  var valid_568386 = path.getOrDefault("jobDefinitionName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "jobDefinitionName", valid_568386
  var valid_568387 = path.getOrDefault("dataServiceName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "dataServiceName", valid_568387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
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
  if body != nil:
    result.add "body", body

proc call*(call_568389: Call_JobsResume_568379; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resumes the given job.
  ## 
  let valid = call_568389.validator(path, query, header, formData, body)
  let scheme = call_568389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568389.url(scheme.get, call_568389.host, call_568389.base,
                         call_568389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568389, url, valid)

proc call*(call_568390: Call_JobsResume_568379; resourceGroupName: string;
          apiVersion: string; jobId: string; subscriptionId: string;
          dataManagerName: string; jobDefinitionName: string;
          dataServiceName: string): Recallable =
  ## jobsResume
  ## Resumes the given job.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   jobId: string (required)
  ##        : The job id of the job queried.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   jobDefinitionName: string (required)
  ##                    : The name of the job definition of the job.
  ##   dataServiceName: string (required)
  ##                  : The name of the data service of the job definition.
  var path_568391 = newJObject()
  var query_568392 = newJObject()
  add(path_568391, "resourceGroupName", newJString(resourceGroupName))
  add(query_568392, "api-version", newJString(apiVersion))
  add(path_568391, "jobId", newJString(jobId))
  add(path_568391, "subscriptionId", newJString(subscriptionId))
  add(path_568391, "dataManagerName", newJString(dataManagerName))
  add(path_568391, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_568391, "dataServiceName", newJString(dataServiceName))
  result = call_568390.call(path_568391, query_568392, nil, nil, nil)

var jobsResume* = Call_JobsResume_568379(name: "jobsResume",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}/jobs/{jobId}/resume",
                                      validator: validate_JobsResume_568380,
                                      base: "", url: url_JobsResume_568381,
                                      schemes: {Scheme.Https})
type
  Call_JobDefinitionsRun_568393 = ref object of OpenApiRestCall_567658
proc url_JobDefinitionsRun_568395(protocol: Scheme; host: string; base: string;
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

proc validate_JobDefinitionsRun_568394(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## This method runs a job instance of the given job definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   jobDefinitionName: JString (required)
  ##                    : Name of the job definition.
  ##   dataServiceName: JString (required)
  ##                  : The data service type of the job definition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568396 = path.getOrDefault("resourceGroupName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "resourceGroupName", valid_568396
  var valid_568397 = path.getOrDefault("subscriptionId")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "subscriptionId", valid_568397
  var valid_568398 = path.getOrDefault("dataManagerName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "dataManagerName", valid_568398
  var valid_568399 = path.getOrDefault("jobDefinitionName")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "jobDefinitionName", valid_568399
  var valid_568400 = path.getOrDefault("dataServiceName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "dataServiceName", valid_568400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568401 = query.getOrDefault("api-version")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "api-version", valid_568401
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

proc call*(call_568403: Call_JobDefinitionsRun_568393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method runs a job instance of the given job definition.
  ## 
  let valid = call_568403.validator(path, query, header, formData, body)
  let scheme = call_568403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568403.url(scheme.get, call_568403.host, call_568403.base,
                         call_568403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568403, url, valid)

proc call*(call_568404: Call_JobDefinitionsRun_568393; resourceGroupName: string;
          apiVersion: string; runParameters: JsonNode; subscriptionId: string;
          dataManagerName: string; jobDefinitionName: string;
          dataServiceName: string): Recallable =
  ## jobDefinitionsRun
  ## This method runs a job instance of the given job definition.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   runParameters: JObject (required)
  ##                : Run time parameters for the job definition.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   jobDefinitionName: string (required)
  ##                    : Name of the job definition.
  ##   dataServiceName: string (required)
  ##                  : The data service type of the job definition.
  var path_568405 = newJObject()
  var query_568406 = newJObject()
  var body_568407 = newJObject()
  add(path_568405, "resourceGroupName", newJString(resourceGroupName))
  add(query_568406, "api-version", newJString(apiVersion))
  if runParameters != nil:
    body_568407 = runParameters
  add(path_568405, "subscriptionId", newJString(subscriptionId))
  add(path_568405, "dataManagerName", newJString(dataManagerName))
  add(path_568405, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_568405, "dataServiceName", newJString(dataServiceName))
  result = call_568404.call(path_568405, query_568406, nil, nil, body_568407)

var jobDefinitionsRun* = Call_JobDefinitionsRun_568393(name: "jobDefinitionsRun",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}/run",
    validator: validate_JobDefinitionsRun_568394, base: "",
    url: url_JobDefinitionsRun_568395, schemes: {Scheme.Https})
type
  Call_JobsListByDataService_568408 = ref object of OpenApiRestCall_567658
proc url_JobsListByDataService_568410(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByDataService_568409(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets all the jobs of a data service type in a given resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   dataServiceName: JString (required)
  ##                  : The name of the data service of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568411 = path.getOrDefault("resourceGroupName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "resourceGroupName", valid_568411
  var valid_568412 = path.getOrDefault("subscriptionId")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "subscriptionId", valid_568412
  var valid_568413 = path.getOrDefault("dataManagerName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "dataManagerName", valid_568413
  var valid_568414 = path.getOrDefault("dataServiceName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "dataServiceName", valid_568414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568415 = query.getOrDefault("api-version")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "api-version", valid_568415
  var valid_568416 = query.getOrDefault("$filter")
  valid_568416 = validateParameter(valid_568416, JString, required = false,
                                 default = nil)
  if valid_568416 != nil:
    section.add "$filter", valid_568416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568417: Call_JobsListByDataService_568408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets all the jobs of a data service type in a given resource.
  ## 
  let valid = call_568417.validator(path, query, header, formData, body)
  let scheme = call_568417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568417.url(scheme.get, call_568417.host, call_568417.base,
                         call_568417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568417, url, valid)

proc call*(call_568418: Call_JobsListByDataService_568408;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataManagerName: string; dataServiceName: string; Filter: string = ""): Recallable =
  ## jobsListByDataService
  ## This method gets all the jobs of a data service type in a given resource.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   dataServiceName: string (required)
  ##                  : The name of the data service of interest.
  ##   Filter: string
  ##         : OData Filter options
  var path_568419 = newJObject()
  var query_568420 = newJObject()
  add(path_568419, "resourceGroupName", newJString(resourceGroupName))
  add(query_568420, "api-version", newJString(apiVersion))
  add(path_568419, "subscriptionId", newJString(subscriptionId))
  add(path_568419, "dataManagerName", newJString(dataManagerName))
  add(path_568419, "dataServiceName", newJString(dataServiceName))
  add(query_568420, "$filter", newJString(Filter))
  result = call_568418.call(path_568419, query_568420, nil, nil, nil)

var jobsListByDataService* = Call_JobsListByDataService_568408(
    name: "jobsListByDataService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobs",
    validator: validate_JobsListByDataService_568409, base: "",
    url: url_JobsListByDataService_568410, schemes: {Scheme.Https})
type
  Call_DataStoreTypesListByDataManager_568421 = ref object of OpenApiRestCall_567658
proc url_DataStoreTypesListByDataManager_568423(protocol: Scheme; host: string;
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

proc validate_DataStoreTypesListByDataManager_568422(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the data store/repository types that the resource supports.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568424 = path.getOrDefault("resourceGroupName")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "resourceGroupName", valid_568424
  var valid_568425 = path.getOrDefault("subscriptionId")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "subscriptionId", valid_568425
  var valid_568426 = path.getOrDefault("dataManagerName")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "dataManagerName", valid_568426
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
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

proc call*(call_568428: Call_DataStoreTypesListByDataManager_568421;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the data store/repository types that the resource supports.
  ## 
  let valid = call_568428.validator(path, query, header, formData, body)
  let scheme = call_568428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568428.url(scheme.get, call_568428.host, call_568428.base,
                         call_568428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568428, url, valid)

proc call*(call_568429: Call_DataStoreTypesListByDataManager_568421;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataManagerName: string): Recallable =
  ## dataStoreTypesListByDataManager
  ## Gets all the data store/repository types that the resource supports.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_568430 = newJObject()
  var query_568431 = newJObject()
  add(path_568430, "resourceGroupName", newJString(resourceGroupName))
  add(query_568431, "api-version", newJString(apiVersion))
  add(path_568430, "subscriptionId", newJString(subscriptionId))
  add(path_568430, "dataManagerName", newJString(dataManagerName))
  result = call_568429.call(path_568430, query_568431, nil, nil, nil)

var dataStoreTypesListByDataManager* = Call_DataStoreTypesListByDataManager_568421(
    name: "dataStoreTypesListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStoreTypes",
    validator: validate_DataStoreTypesListByDataManager_568422, base: "",
    url: url_DataStoreTypesListByDataManager_568423, schemes: {Scheme.Https})
type
  Call_DataStoreTypesGet_568432 = ref object of OpenApiRestCall_567658
proc url_DataStoreTypesGet_568434(protocol: Scheme; host: string; base: string;
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

proc validate_DataStoreTypesGet_568433(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the data store/repository type given its name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   dataStoreTypeName: JString (required)
  ##                    : The data store/repository type name for which details are needed.
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
  var valid_568437 = path.getOrDefault("dataManagerName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "dataManagerName", valid_568437
  var valid_568438 = path.getOrDefault("dataStoreTypeName")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "dataStoreTypeName", valid_568438
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568439 = query.getOrDefault("api-version")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "api-version", valid_568439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568440: Call_DataStoreTypesGet_568432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the data store/repository type given its name.
  ## 
  let valid = call_568440.validator(path, query, header, formData, body)
  let scheme = call_568440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568440.url(scheme.get, call_568440.host, call_568440.base,
                         call_568440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568440, url, valid)

proc call*(call_568441: Call_DataStoreTypesGet_568432; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; dataManagerName: string;
          dataStoreTypeName: string): Recallable =
  ## dataStoreTypesGet
  ## Gets the data store/repository type given its name.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   dataStoreTypeName: string (required)
  ##                    : The data store/repository type name for which details are needed.
  var path_568442 = newJObject()
  var query_568443 = newJObject()
  add(path_568442, "resourceGroupName", newJString(resourceGroupName))
  add(query_568443, "api-version", newJString(apiVersion))
  add(path_568442, "subscriptionId", newJString(subscriptionId))
  add(path_568442, "dataManagerName", newJString(dataManagerName))
  add(path_568442, "dataStoreTypeName", newJString(dataStoreTypeName))
  result = call_568441.call(path_568442, query_568443, nil, nil, nil)

var dataStoreTypesGet* = Call_DataStoreTypesGet_568432(name: "dataStoreTypesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStoreTypes/{dataStoreTypeName}",
    validator: validate_DataStoreTypesGet_568433, base: "",
    url: url_DataStoreTypesGet_568434, schemes: {Scheme.Https})
type
  Call_DataStoresListByDataManager_568444 = ref object of OpenApiRestCall_567658
proc url_DataStoresListByDataManager_568446(protocol: Scheme; host: string;
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

proc validate_DataStoresListByDataManager_568445(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the data stores/repositories in the given resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568447 = path.getOrDefault("resourceGroupName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "resourceGroupName", valid_568447
  var valid_568448 = path.getOrDefault("subscriptionId")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "subscriptionId", valid_568448
  var valid_568449 = path.getOrDefault("dataManagerName")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "dataManagerName", valid_568449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568450 = query.getOrDefault("api-version")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "api-version", valid_568450
  var valid_568451 = query.getOrDefault("$filter")
  valid_568451 = validateParameter(valid_568451, JString, required = false,
                                 default = nil)
  if valid_568451 != nil:
    section.add "$filter", valid_568451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568452: Call_DataStoresListByDataManager_568444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the data stores/repositories in the given resource.
  ## 
  let valid = call_568452.validator(path, query, header, formData, body)
  let scheme = call_568452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568452.url(scheme.get, call_568452.host, call_568452.base,
                         call_568452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568452, url, valid)

proc call*(call_568453: Call_DataStoresListByDataManager_568444;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataManagerName: string; Filter: string = ""): Recallable =
  ## dataStoresListByDataManager
  ## Gets all the data stores/repositories in the given resource.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   Filter: string
  ##         : OData Filter options
  var path_568454 = newJObject()
  var query_568455 = newJObject()
  add(path_568454, "resourceGroupName", newJString(resourceGroupName))
  add(query_568455, "api-version", newJString(apiVersion))
  add(path_568454, "subscriptionId", newJString(subscriptionId))
  add(path_568454, "dataManagerName", newJString(dataManagerName))
  add(query_568455, "$filter", newJString(Filter))
  result = call_568453.call(path_568454, query_568455, nil, nil, nil)

var dataStoresListByDataManager* = Call_DataStoresListByDataManager_568444(
    name: "dataStoresListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStores",
    validator: validate_DataStoresListByDataManager_568445, base: "",
    url: url_DataStoresListByDataManager_568446, schemes: {Scheme.Https})
type
  Call_DataStoresCreateOrUpdate_568468 = ref object of OpenApiRestCall_567658
proc url_DataStoresCreateOrUpdate_568470(protocol: Scheme; host: string;
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

proc validate_DataStoresCreateOrUpdate_568469(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the data store/repository in the data manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   dataStoreName: JString (required)
  ##                : The data store/repository name to be created or updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568471 = path.getOrDefault("resourceGroupName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "resourceGroupName", valid_568471
  var valid_568472 = path.getOrDefault("subscriptionId")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "subscriptionId", valid_568472
  var valid_568473 = path.getOrDefault("dataManagerName")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "dataManagerName", valid_568473
  var valid_568474 = path.getOrDefault("dataStoreName")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "dataStoreName", valid_568474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568475 = query.getOrDefault("api-version")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "api-version", valid_568475
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

proc call*(call_568477: Call_DataStoresCreateOrUpdate_568468; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the data store/repository in the data manager.
  ## 
  let valid = call_568477.validator(path, query, header, formData, body)
  let scheme = call_568477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568477.url(scheme.get, call_568477.host, call_568477.base,
                         call_568477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568477, url, valid)

proc call*(call_568478: Call_DataStoresCreateOrUpdate_568468;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataManagerName: string; dataStore: JsonNode; dataStoreName: string): Recallable =
  ## dataStoresCreateOrUpdate
  ## Creates or updates the data store/repository in the data manager.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   dataStore: JObject (required)
  ##            : The data store/repository object to be created or updated.
  ##   dataStoreName: string (required)
  ##                : The data store/repository name to be created or updated.
  var path_568479 = newJObject()
  var query_568480 = newJObject()
  var body_568481 = newJObject()
  add(path_568479, "resourceGroupName", newJString(resourceGroupName))
  add(query_568480, "api-version", newJString(apiVersion))
  add(path_568479, "subscriptionId", newJString(subscriptionId))
  add(path_568479, "dataManagerName", newJString(dataManagerName))
  if dataStore != nil:
    body_568481 = dataStore
  add(path_568479, "dataStoreName", newJString(dataStoreName))
  result = call_568478.call(path_568479, query_568480, nil, nil, body_568481)

var dataStoresCreateOrUpdate* = Call_DataStoresCreateOrUpdate_568468(
    name: "dataStoresCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStores/{dataStoreName}",
    validator: validate_DataStoresCreateOrUpdate_568469, base: "",
    url: url_DataStoresCreateOrUpdate_568470, schemes: {Scheme.Https})
type
  Call_DataStoresGet_568456 = ref object of OpenApiRestCall_567658
proc url_DataStoresGet_568458(protocol: Scheme; host: string; base: string;
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

proc validate_DataStoresGet_568457(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets the data store/repository by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   dataStoreName: JString (required)
  ##                : The data store/repository name queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568459 = path.getOrDefault("resourceGroupName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "resourceGroupName", valid_568459
  var valid_568460 = path.getOrDefault("subscriptionId")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "subscriptionId", valid_568460
  var valid_568461 = path.getOrDefault("dataManagerName")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "dataManagerName", valid_568461
  var valid_568462 = path.getOrDefault("dataStoreName")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "dataStoreName", valid_568462
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568463 = query.getOrDefault("api-version")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "api-version", valid_568463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568464: Call_DataStoresGet_568456; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets the data store/repository by name.
  ## 
  let valid = call_568464.validator(path, query, header, formData, body)
  let scheme = call_568464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568464.url(scheme.get, call_568464.host, call_568464.base,
                         call_568464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568464, url, valid)

proc call*(call_568465: Call_DataStoresGet_568456; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; dataManagerName: string;
          dataStoreName: string): Recallable =
  ## dataStoresGet
  ## This method gets the data store/repository by name.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   dataStoreName: string (required)
  ##                : The data store/repository name queried.
  var path_568466 = newJObject()
  var query_568467 = newJObject()
  add(path_568466, "resourceGroupName", newJString(resourceGroupName))
  add(query_568467, "api-version", newJString(apiVersion))
  add(path_568466, "subscriptionId", newJString(subscriptionId))
  add(path_568466, "dataManagerName", newJString(dataManagerName))
  add(path_568466, "dataStoreName", newJString(dataStoreName))
  result = call_568465.call(path_568466, query_568467, nil, nil, nil)

var dataStoresGet* = Call_DataStoresGet_568456(name: "dataStoresGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStores/{dataStoreName}",
    validator: validate_DataStoresGet_568457, base: "", url: url_DataStoresGet_568458,
    schemes: {Scheme.Https})
type
  Call_DataStoresDelete_568482 = ref object of OpenApiRestCall_567658
proc url_DataStoresDelete_568484(protocol: Scheme; host: string; base: string;
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

proc validate_DataStoresDelete_568483(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## This method deletes the given data store/repository.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   dataStoreName: JString (required)
  ##                : The data store/repository name to be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568485 = path.getOrDefault("resourceGroupName")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "resourceGroupName", valid_568485
  var valid_568486 = path.getOrDefault("subscriptionId")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "subscriptionId", valid_568486
  var valid_568487 = path.getOrDefault("dataManagerName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "dataManagerName", valid_568487
  var valid_568488 = path.getOrDefault("dataStoreName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "dataStoreName", valid_568488
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568489 = query.getOrDefault("api-version")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "api-version", valid_568489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568490: Call_DataStoresDelete_568482; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method deletes the given data store/repository.
  ## 
  let valid = call_568490.validator(path, query, header, formData, body)
  let scheme = call_568490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568490.url(scheme.get, call_568490.host, call_568490.base,
                         call_568490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568490, url, valid)

proc call*(call_568491: Call_DataStoresDelete_568482; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; dataManagerName: string;
          dataStoreName: string): Recallable =
  ## dataStoresDelete
  ## This method deletes the given data store/repository.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   dataStoreName: string (required)
  ##                : The data store/repository name to be deleted.
  var path_568492 = newJObject()
  var query_568493 = newJObject()
  add(path_568492, "resourceGroupName", newJString(resourceGroupName))
  add(query_568493, "api-version", newJString(apiVersion))
  add(path_568492, "subscriptionId", newJString(subscriptionId))
  add(path_568492, "dataManagerName", newJString(dataManagerName))
  add(path_568492, "dataStoreName", newJString(dataStoreName))
  result = call_568491.call(path_568492, query_568493, nil, nil, nil)

var dataStoresDelete* = Call_DataStoresDelete_568482(name: "dataStoresDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStores/{dataStoreName}",
    validator: validate_DataStoresDelete_568483, base: "",
    url: url_DataStoresDelete_568484, schemes: {Scheme.Https})
type
  Call_JobDefinitionsListByDataManager_568494 = ref object of OpenApiRestCall_567658
proc url_JobDefinitionsListByDataManager_568496(protocol: Scheme; host: string;
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

proc validate_JobDefinitionsListByDataManager_568495(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets all the job definitions of the given data manager resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568497 = path.getOrDefault("resourceGroupName")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "resourceGroupName", valid_568497
  var valid_568498 = path.getOrDefault("subscriptionId")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "subscriptionId", valid_568498
  var valid_568499 = path.getOrDefault("dataManagerName")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "dataManagerName", valid_568499
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568500 = query.getOrDefault("api-version")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "api-version", valid_568500
  var valid_568501 = query.getOrDefault("$filter")
  valid_568501 = validateParameter(valid_568501, JString, required = false,
                                 default = nil)
  if valid_568501 != nil:
    section.add "$filter", valid_568501
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568502: Call_JobDefinitionsListByDataManager_568494;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This method gets all the job definitions of the given data manager resource.
  ## 
  let valid = call_568502.validator(path, query, header, formData, body)
  let scheme = call_568502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568502.url(scheme.get, call_568502.host, call_568502.base,
                         call_568502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568502, url, valid)

proc call*(call_568503: Call_JobDefinitionsListByDataManager_568494;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataManagerName: string; Filter: string = ""): Recallable =
  ## jobDefinitionsListByDataManager
  ## This method gets all the job definitions of the given data manager resource.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   Filter: string
  ##         : OData Filter options
  var path_568504 = newJObject()
  var query_568505 = newJObject()
  add(path_568504, "resourceGroupName", newJString(resourceGroupName))
  add(query_568505, "api-version", newJString(apiVersion))
  add(path_568504, "subscriptionId", newJString(subscriptionId))
  add(path_568504, "dataManagerName", newJString(dataManagerName))
  add(query_568505, "$filter", newJString(Filter))
  result = call_568503.call(path_568504, query_568505, nil, nil, nil)

var jobDefinitionsListByDataManager* = Call_JobDefinitionsListByDataManager_568494(
    name: "jobDefinitionsListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/jobDefinitions",
    validator: validate_JobDefinitionsListByDataManager_568495, base: "",
    url: url_JobDefinitionsListByDataManager_568496, schemes: {Scheme.Https})
type
  Call_JobsListByDataManager_568506 = ref object of OpenApiRestCall_567658
proc url_JobsListByDataManager_568508(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByDataManager_568507(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets all the jobs at the data manager resource level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568509 = path.getOrDefault("resourceGroupName")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "resourceGroupName", valid_568509
  var valid_568510 = path.getOrDefault("subscriptionId")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "subscriptionId", valid_568510
  var valid_568511 = path.getOrDefault("dataManagerName")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "dataManagerName", valid_568511
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568512 = query.getOrDefault("api-version")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "api-version", valid_568512
  var valid_568513 = query.getOrDefault("$filter")
  valid_568513 = validateParameter(valid_568513, JString, required = false,
                                 default = nil)
  if valid_568513 != nil:
    section.add "$filter", valid_568513
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568514: Call_JobsListByDataManager_568506; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets all the jobs at the data manager resource level.
  ## 
  let valid = call_568514.validator(path, query, header, formData, body)
  let scheme = call_568514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568514.url(scheme.get, call_568514.host, call_568514.base,
                         call_568514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568514, url, valid)

proc call*(call_568515: Call_JobsListByDataManager_568506;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataManagerName: string; Filter: string = ""): Recallable =
  ## jobsListByDataManager
  ## This method gets all the jobs at the data manager resource level.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  ##   Filter: string
  ##         : OData Filter options
  var path_568516 = newJObject()
  var query_568517 = newJObject()
  add(path_568516, "resourceGroupName", newJString(resourceGroupName))
  add(query_568517, "api-version", newJString(apiVersion))
  add(path_568516, "subscriptionId", newJString(subscriptionId))
  add(path_568516, "dataManagerName", newJString(dataManagerName))
  add(query_568517, "$filter", newJString(Filter))
  result = call_568515.call(path_568516, query_568517, nil, nil, nil)

var jobsListByDataManager* = Call_JobsListByDataManager_568506(
    name: "jobsListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/jobs",
    validator: validate_JobsListByDataManager_568507, base: "",
    url: url_JobsListByDataManager_568508, schemes: {Scheme.Https})
type
  Call_PublicKeysListByDataManager_568518 = ref object of OpenApiRestCall_567658
proc url_PublicKeysListByDataManager_568520(protocol: Scheme; host: string;
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

proc validate_PublicKeysListByDataManager_568519(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets the list view of public keys, however it will only have one element.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568521 = path.getOrDefault("resourceGroupName")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "resourceGroupName", valid_568521
  var valid_568522 = path.getOrDefault("subscriptionId")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "subscriptionId", valid_568522
  var valid_568523 = path.getOrDefault("dataManagerName")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "dataManagerName", valid_568523
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568524 = query.getOrDefault("api-version")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "api-version", valid_568524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568525: Call_PublicKeysListByDataManager_568518; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets the list view of public keys, however it will only have one element.
  ## 
  let valid = call_568525.validator(path, query, header, formData, body)
  let scheme = call_568525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568525.url(scheme.get, call_568525.host, call_568525.base,
                         call_568525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568525, url, valid)

proc call*(call_568526: Call_PublicKeysListByDataManager_568518;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dataManagerName: string): Recallable =
  ## publicKeysListByDataManager
  ## This method gets the list view of public keys, however it will only have one element.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_568527 = newJObject()
  var query_568528 = newJObject()
  add(path_568527, "resourceGroupName", newJString(resourceGroupName))
  add(query_568528, "api-version", newJString(apiVersion))
  add(path_568527, "subscriptionId", newJString(subscriptionId))
  add(path_568527, "dataManagerName", newJString(dataManagerName))
  result = call_568526.call(path_568527, query_568528, nil, nil, nil)

var publicKeysListByDataManager* = Call_PublicKeysListByDataManager_568518(
    name: "publicKeysListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/publicKeys",
    validator: validate_PublicKeysListByDataManager_568519, base: "",
    url: url_PublicKeysListByDataManager_568520, schemes: {Scheme.Https})
type
  Call_PublicKeysGet_568529 = ref object of OpenApiRestCall_567658
proc url_PublicKeysGet_568531(protocol: Scheme; host: string; base: string;
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

proc validate_PublicKeysGet_568530(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## This method gets the public keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Resource Group Name
  ##   publicKeyName: JString (required)
  ##                : Name of the public key.
  ##   subscriptionId: JString (required)
  ##                 : The Subscription Id
  ##   dataManagerName: JString (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568532 = path.getOrDefault("resourceGroupName")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "resourceGroupName", valid_568532
  var valid_568533 = path.getOrDefault("publicKeyName")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "publicKeyName", valid_568533
  var valid_568534 = path.getOrDefault("subscriptionId")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "subscriptionId", valid_568534
  var valid_568535 = path.getOrDefault("dataManagerName")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "dataManagerName", valid_568535
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568536 = query.getOrDefault("api-version")
  valid_568536 = validateParameter(valid_568536, JString, required = true,
                                 default = nil)
  if valid_568536 != nil:
    section.add "api-version", valid_568536
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568537: Call_PublicKeysGet_568529; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets the public keys.
  ## 
  let valid = call_568537.validator(path, query, header, formData, body)
  let scheme = call_568537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568537.url(scheme.get, call_568537.host, call_568537.base,
                         call_568537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568537, url, valid)

proc call*(call_568538: Call_PublicKeysGet_568529; resourceGroupName: string;
          apiVersion: string; publicKeyName: string; subscriptionId: string;
          dataManagerName: string): Recallable =
  ## publicKeysGet
  ## This method gets the public keys.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   publicKeyName: string (required)
  ##                : Name of the public key.
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  ##   dataManagerName: string (required)
  ##                  : The name of the DataManager Resource within the specified resource group. DataManager names must be between 3 and 24 characters in length and use any alphanumeric and underscore only
  var path_568539 = newJObject()
  var query_568540 = newJObject()
  add(path_568539, "resourceGroupName", newJString(resourceGroupName))
  add(query_568540, "api-version", newJString(apiVersion))
  add(path_568539, "publicKeyName", newJString(publicKeyName))
  add(path_568539, "subscriptionId", newJString(subscriptionId))
  add(path_568539, "dataManagerName", newJString(dataManagerName))
  result = call_568538.call(path_568539, query_568540, nil, nil, nil)

var publicKeysGet* = Call_PublicKeysGet_568529(name: "publicKeysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/publicKeys/{publicKeyName}",
    validator: validate_PublicKeysGet_568530, base: "", url: url_PublicKeysGet_568531,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
