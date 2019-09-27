
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
  macServiceName = "hybriddatamanager-hybriddata"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593647 = ref object of OpenApiRestCall_593425
proc url_OperationsList_593649(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593648(path: JsonNode; query: JsonNode;
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

proc call*(call_593831: Call_OperationsList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593831.validator(path, query, header, formData, body)
  let scheme = call_593831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593831.url(scheme.get, call_593831.host, call_593831.base,
                         call_593831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593831, url, valid)

proc call*(call_593902: Call_OperationsList_593647; apiVersion: string): Recallable =
  ## operationsList
  ##   apiVersion: string (required)
  ##             : The API Version
  var query_593903 = newJObject()
  add(query_593903, "api-version", newJString(apiVersion))
  result = call_593902.call(nil, query_593903, nil, nil, nil)

var operationsList* = Call_OperationsList_593647(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.HybridData/operations",
    validator: validate_OperationsList_593648, base: "", url: url_OperationsList_593649,
    schemes: {Scheme.Https})
type
  Call_DataManagersList_593943 = ref object of OpenApiRestCall_593425
proc url_DataManagersList_593945(protocol: Scheme; host: string; base: string;
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

proc validate_DataManagersList_593944(path: JsonNode; query: JsonNode;
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
  var valid_593960 = path.getOrDefault("subscriptionId")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "subscriptionId", valid_593960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593962: Call_DataManagersList_593943; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the data manager resources available under the subscription.
  ## 
  let valid = call_593962.validator(path, query, header, formData, body)
  let scheme = call_593962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593962.url(scheme.get, call_593962.host, call_593962.base,
                         call_593962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593962, url, valid)

proc call*(call_593963: Call_DataManagersList_593943; apiVersion: string;
          subscriptionId: string): Recallable =
  ## dataManagersList
  ## Lists all the data manager resources available under the subscription.
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  var path_593964 = newJObject()
  var query_593965 = newJObject()
  add(query_593965, "api-version", newJString(apiVersion))
  add(path_593964, "subscriptionId", newJString(subscriptionId))
  result = call_593963.call(path_593964, query_593965, nil, nil, nil)

var dataManagersList* = Call_DataManagersList_593943(name: "dataManagersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.HybridData/dataManagers",
    validator: validate_DataManagersList_593944, base: "",
    url: url_DataManagersList_593945, schemes: {Scheme.Https})
type
  Call_DataManagersListByResourceGroup_593966 = ref object of OpenApiRestCall_593425
proc url_DataManagersListByResourceGroup_593968(protocol: Scheme; host: string;
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

proc validate_DataManagersListByResourceGroup_593967(path: JsonNode;
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
  var valid_593969 = path.getOrDefault("resourceGroupName")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "resourceGroupName", valid_593969
  var valid_593970 = path.getOrDefault("subscriptionId")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "subscriptionId", valid_593970
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593971 = query.getOrDefault("api-version")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "api-version", valid_593971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593972: Call_DataManagersListByResourceGroup_593966;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the data manager resources available under the given resource group.
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_DataManagersListByResourceGroup_593966;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## dataManagersListByResourceGroup
  ## Lists all the data manager resources available under the given resource group.
  ##   resourceGroupName: string (required)
  ##                    : The Resource Group Name
  ##   apiVersion: string (required)
  ##             : The API Version
  ##   subscriptionId: string (required)
  ##                 : The Subscription Id
  var path_593974 = newJObject()
  var query_593975 = newJObject()
  add(path_593974, "resourceGroupName", newJString(resourceGroupName))
  add(query_593975, "api-version", newJString(apiVersion))
  add(path_593974, "subscriptionId", newJString(subscriptionId))
  result = call_593973.call(path_593974, query_593975, nil, nil, nil)

var dataManagersListByResourceGroup* = Call_DataManagersListByResourceGroup_593966(
    name: "dataManagersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers",
    validator: validate_DataManagersListByResourceGroup_593967, base: "",
    url: url_DataManagersListByResourceGroup_593968, schemes: {Scheme.Https})
type
  Call_DataManagersCreate_593987 = ref object of OpenApiRestCall_593425
proc url_DataManagersCreate_593989(protocol: Scheme; host: string; base: string;
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

proc validate_DataManagersCreate_593988(path: JsonNode; query: JsonNode;
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
  var valid_593990 = path.getOrDefault("resourceGroupName")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "resourceGroupName", valid_593990
  var valid_593991 = path.getOrDefault("subscriptionId")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "subscriptionId", valid_593991
  var valid_593992 = path.getOrDefault("dataManagerName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "dataManagerName", valid_593992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593993 = query.getOrDefault("api-version")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "api-version", valid_593993
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

proc call*(call_593995: Call_DataManagersCreate_593987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new data manager resource with the specified parameters. Existing resources cannot be updated with this API
  ## and should instead be updated with the Update data manager resource API.
  ## 
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_DataManagersCreate_593987; dataManager: JsonNode;
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
  var path_593997 = newJObject()
  var query_593998 = newJObject()
  var body_593999 = newJObject()
  if dataManager != nil:
    body_593999 = dataManager
  add(path_593997, "resourceGroupName", newJString(resourceGroupName))
  add(query_593998, "api-version", newJString(apiVersion))
  add(path_593997, "subscriptionId", newJString(subscriptionId))
  add(path_593997, "dataManagerName", newJString(dataManagerName))
  result = call_593996.call(path_593997, query_593998, nil, nil, body_593999)

var dataManagersCreate* = Call_DataManagersCreate_593987(
    name: "dataManagersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}",
    validator: validate_DataManagersCreate_593988, base: "",
    url: url_DataManagersCreate_593989, schemes: {Scheme.Https})
type
  Call_DataManagersGet_593976 = ref object of OpenApiRestCall_593425
proc url_DataManagersGet_593978(protocol: Scheme; host: string; base: string;
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

proc validate_DataManagersGet_593977(path: JsonNode; query: JsonNode;
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
  var valid_593979 = path.getOrDefault("resourceGroupName")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "resourceGroupName", valid_593979
  var valid_593980 = path.getOrDefault("subscriptionId")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "subscriptionId", valid_593980
  var valid_593981 = path.getOrDefault("dataManagerName")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "dataManagerName", valid_593981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593982 = query.getOrDefault("api-version")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "api-version", valid_593982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593983: Call_DataManagersGet_593976; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified data manager resource.
  ## 
  let valid = call_593983.validator(path, query, header, formData, body)
  let scheme = call_593983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593983.url(scheme.get, call_593983.host, call_593983.base,
                         call_593983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593983, url, valid)

proc call*(call_593984: Call_DataManagersGet_593976; resourceGroupName: string;
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
  var path_593985 = newJObject()
  var query_593986 = newJObject()
  add(path_593985, "resourceGroupName", newJString(resourceGroupName))
  add(query_593986, "api-version", newJString(apiVersion))
  add(path_593985, "subscriptionId", newJString(subscriptionId))
  add(path_593985, "dataManagerName", newJString(dataManagerName))
  result = call_593984.call(path_593985, query_593986, nil, nil, nil)

var dataManagersGet* = Call_DataManagersGet_593976(name: "dataManagersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}",
    validator: validate_DataManagersGet_593977, base: "", url: url_DataManagersGet_593978,
    schemes: {Scheme.Https})
type
  Call_DataManagersUpdate_594011 = ref object of OpenApiRestCall_593425
proc url_DataManagersUpdate_594013(protocol: Scheme; host: string; base: string;
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

proc validate_DataManagersUpdate_594012(path: JsonNode; query: JsonNode;
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
  var valid_594014 = path.getOrDefault("resourceGroupName")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "resourceGroupName", valid_594014
  var valid_594015 = path.getOrDefault("subscriptionId")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "subscriptionId", valid_594015
  var valid_594016 = path.getOrDefault("dataManagerName")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "dataManagerName", valid_594016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594017 = query.getOrDefault("api-version")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "api-version", valid_594017
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The patch will be performed only if the ETag of the data manager resource on the server matches this value.
  section = newJObject()
  var valid_594018 = header.getOrDefault("If-Match")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "If-Match", valid_594018
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

proc call*(call_594020: Call_DataManagersUpdate_594011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing data manager resource.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_DataManagersUpdate_594011; resourceGroupName: string;
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
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  var body_594024 = newJObject()
  add(path_594022, "resourceGroupName", newJString(resourceGroupName))
  add(query_594023, "api-version", newJString(apiVersion))
  add(path_594022, "subscriptionId", newJString(subscriptionId))
  if dataManagerUpdateParameter != nil:
    body_594024 = dataManagerUpdateParameter
  add(path_594022, "dataManagerName", newJString(dataManagerName))
  result = call_594021.call(path_594022, query_594023, nil, nil, body_594024)

var dataManagersUpdate* = Call_DataManagersUpdate_594011(
    name: "dataManagersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}",
    validator: validate_DataManagersUpdate_594012, base: "",
    url: url_DataManagersUpdate_594013, schemes: {Scheme.Https})
type
  Call_DataManagersDelete_594000 = ref object of OpenApiRestCall_593425
proc url_DataManagersDelete_594002(protocol: Scheme; host: string; base: string;
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

proc validate_DataManagersDelete_594001(path: JsonNode; query: JsonNode;
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
  var valid_594003 = path.getOrDefault("resourceGroupName")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "resourceGroupName", valid_594003
  var valid_594004 = path.getOrDefault("subscriptionId")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "subscriptionId", valid_594004
  var valid_594005 = path.getOrDefault("dataManagerName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "dataManagerName", valid_594005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594006 = query.getOrDefault("api-version")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "api-version", valid_594006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594007: Call_DataManagersDelete_594000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a data manager resource in Microsoft Azure.
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_DataManagersDelete_594000; resourceGroupName: string;
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
  var path_594009 = newJObject()
  var query_594010 = newJObject()
  add(path_594009, "resourceGroupName", newJString(resourceGroupName))
  add(query_594010, "api-version", newJString(apiVersion))
  add(path_594009, "subscriptionId", newJString(subscriptionId))
  add(path_594009, "dataManagerName", newJString(dataManagerName))
  result = call_594008.call(path_594009, query_594010, nil, nil, nil)

var dataManagersDelete* = Call_DataManagersDelete_594000(
    name: "dataManagersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}",
    validator: validate_DataManagersDelete_594001, base: "",
    url: url_DataManagersDelete_594002, schemes: {Scheme.Https})
type
  Call_DataServicesListByDataManager_594025 = ref object of OpenApiRestCall_593425
proc url_DataServicesListByDataManager_594027(protocol: Scheme; host: string;
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

proc validate_DataServicesListByDataManager_594026(path: JsonNode; query: JsonNode;
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
  var valid_594028 = path.getOrDefault("resourceGroupName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "resourceGroupName", valid_594028
  var valid_594029 = path.getOrDefault("subscriptionId")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "subscriptionId", valid_594029
  var valid_594030 = path.getOrDefault("dataManagerName")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "dataManagerName", valid_594030
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594031 = query.getOrDefault("api-version")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "api-version", valid_594031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594032: Call_DataServicesListByDataManager_594025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets all the data services.
  ## 
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_DataServicesListByDataManager_594025;
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
  var path_594034 = newJObject()
  var query_594035 = newJObject()
  add(path_594034, "resourceGroupName", newJString(resourceGroupName))
  add(query_594035, "api-version", newJString(apiVersion))
  add(path_594034, "subscriptionId", newJString(subscriptionId))
  add(path_594034, "dataManagerName", newJString(dataManagerName))
  result = call_594033.call(path_594034, query_594035, nil, nil, nil)

var dataServicesListByDataManager* = Call_DataServicesListByDataManager_594025(
    name: "dataServicesListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices",
    validator: validate_DataServicesListByDataManager_594026, base: "",
    url: url_DataServicesListByDataManager_594027, schemes: {Scheme.Https})
type
  Call_DataServicesGet_594036 = ref object of OpenApiRestCall_593425
proc url_DataServicesGet_594038(protocol: Scheme; host: string; base: string;
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

proc validate_DataServicesGet_594037(path: JsonNode; query: JsonNode;
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
  var valid_594039 = path.getOrDefault("resourceGroupName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "resourceGroupName", valid_594039
  var valid_594040 = path.getOrDefault("subscriptionId")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "subscriptionId", valid_594040
  var valid_594041 = path.getOrDefault("dataManagerName")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "dataManagerName", valid_594041
  var valid_594042 = path.getOrDefault("dataServiceName")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "dataServiceName", valid_594042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594043 = query.getOrDefault("api-version")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "api-version", valid_594043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594044: Call_DataServicesGet_594036; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the data service that match the data service name given.
  ## 
  let valid = call_594044.validator(path, query, header, formData, body)
  let scheme = call_594044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594044.url(scheme.get, call_594044.host, call_594044.base,
                         call_594044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594044, url, valid)

proc call*(call_594045: Call_DataServicesGet_594036; resourceGroupName: string;
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
  var path_594046 = newJObject()
  var query_594047 = newJObject()
  add(path_594046, "resourceGroupName", newJString(resourceGroupName))
  add(query_594047, "api-version", newJString(apiVersion))
  add(path_594046, "subscriptionId", newJString(subscriptionId))
  add(path_594046, "dataManagerName", newJString(dataManagerName))
  add(path_594046, "dataServiceName", newJString(dataServiceName))
  result = call_594045.call(path_594046, query_594047, nil, nil, nil)

var dataServicesGet* = Call_DataServicesGet_594036(name: "dataServicesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}",
    validator: validate_DataServicesGet_594037, base: "", url: url_DataServicesGet_594038,
    schemes: {Scheme.Https})
type
  Call_JobDefinitionsListByDataService_594048 = ref object of OpenApiRestCall_593425
proc url_JobDefinitionsListByDataService_594050(protocol: Scheme; host: string;
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

proc validate_JobDefinitionsListByDataService_594049(path: JsonNode;
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
  var valid_594052 = path.getOrDefault("resourceGroupName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "resourceGroupName", valid_594052
  var valid_594053 = path.getOrDefault("subscriptionId")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "subscriptionId", valid_594053
  var valid_594054 = path.getOrDefault("dataManagerName")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "dataManagerName", valid_594054
  var valid_594055 = path.getOrDefault("dataServiceName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "dataServiceName", valid_594055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594056 = query.getOrDefault("api-version")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "api-version", valid_594056
  var valid_594057 = query.getOrDefault("$filter")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "$filter", valid_594057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594058: Call_JobDefinitionsListByDataService_594048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This method gets all the job definitions of the given data service name.
  ## 
  let valid = call_594058.validator(path, query, header, formData, body)
  let scheme = call_594058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594058.url(scheme.get, call_594058.host, call_594058.base,
                         call_594058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594058, url, valid)

proc call*(call_594059: Call_JobDefinitionsListByDataService_594048;
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
  var path_594060 = newJObject()
  var query_594061 = newJObject()
  add(path_594060, "resourceGroupName", newJString(resourceGroupName))
  add(query_594061, "api-version", newJString(apiVersion))
  add(path_594060, "subscriptionId", newJString(subscriptionId))
  add(path_594060, "dataManagerName", newJString(dataManagerName))
  add(path_594060, "dataServiceName", newJString(dataServiceName))
  add(query_594061, "$filter", newJString(Filter))
  result = call_594059.call(path_594060, query_594061, nil, nil, nil)

var jobDefinitionsListByDataService* = Call_JobDefinitionsListByDataService_594048(
    name: "jobDefinitionsListByDataService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions",
    validator: validate_JobDefinitionsListByDataService_594049, base: "",
    url: url_JobDefinitionsListByDataService_594050, schemes: {Scheme.Https})
type
  Call_JobDefinitionsCreateOrUpdate_594075 = ref object of OpenApiRestCall_593425
proc url_JobDefinitionsCreateOrUpdate_594077(protocol: Scheme; host: string;
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

proc validate_JobDefinitionsCreateOrUpdate_594076(path: JsonNode; query: JsonNode;
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
  var valid_594078 = path.getOrDefault("resourceGroupName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "resourceGroupName", valid_594078
  var valid_594079 = path.getOrDefault("subscriptionId")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "subscriptionId", valid_594079
  var valid_594080 = path.getOrDefault("dataManagerName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "dataManagerName", valid_594080
  var valid_594081 = path.getOrDefault("jobDefinitionName")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "jobDefinitionName", valid_594081
  var valid_594082 = path.getOrDefault("dataServiceName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "dataServiceName", valid_594082
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594083 = query.getOrDefault("api-version")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "api-version", valid_594083
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

proc call*(call_594085: Call_JobDefinitionsCreateOrUpdate_594075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a job definition.
  ## 
  let valid = call_594085.validator(path, query, header, formData, body)
  let scheme = call_594085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594085.url(scheme.get, call_594085.host, call_594085.base,
                         call_594085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594085, url, valid)

proc call*(call_594086: Call_JobDefinitionsCreateOrUpdate_594075;
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
  var path_594087 = newJObject()
  var query_594088 = newJObject()
  var body_594089 = newJObject()
  add(path_594087, "resourceGroupName", newJString(resourceGroupName))
  add(query_594088, "api-version", newJString(apiVersion))
  add(path_594087, "subscriptionId", newJString(subscriptionId))
  add(path_594087, "dataManagerName", newJString(dataManagerName))
  add(path_594087, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_594087, "dataServiceName", newJString(dataServiceName))
  if jobDefinition != nil:
    body_594089 = jobDefinition
  result = call_594086.call(path_594087, query_594088, nil, nil, body_594089)

var jobDefinitionsCreateOrUpdate* = Call_JobDefinitionsCreateOrUpdate_594075(
    name: "jobDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}",
    validator: validate_JobDefinitionsCreateOrUpdate_594076, base: "",
    url: url_JobDefinitionsCreateOrUpdate_594077, schemes: {Scheme.Https})
type
  Call_JobDefinitionsGet_594062 = ref object of OpenApiRestCall_593425
proc url_JobDefinitionsGet_594064(protocol: Scheme; host: string; base: string;
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

proc validate_JobDefinitionsGet_594063(path: JsonNode; query: JsonNode;
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
  var valid_594065 = path.getOrDefault("resourceGroupName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "resourceGroupName", valid_594065
  var valid_594066 = path.getOrDefault("subscriptionId")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "subscriptionId", valid_594066
  var valid_594067 = path.getOrDefault("dataManagerName")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "dataManagerName", valid_594067
  var valid_594068 = path.getOrDefault("jobDefinitionName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "jobDefinitionName", valid_594068
  var valid_594069 = path.getOrDefault("dataServiceName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "dataServiceName", valid_594069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594070 = query.getOrDefault("api-version")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "api-version", valid_594070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594071: Call_JobDefinitionsGet_594062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets job definition object by name.
  ## 
  let valid = call_594071.validator(path, query, header, formData, body)
  let scheme = call_594071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594071.url(scheme.get, call_594071.host, call_594071.base,
                         call_594071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594071, url, valid)

proc call*(call_594072: Call_JobDefinitionsGet_594062; resourceGroupName: string;
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
  var path_594073 = newJObject()
  var query_594074 = newJObject()
  add(path_594073, "resourceGroupName", newJString(resourceGroupName))
  add(query_594074, "api-version", newJString(apiVersion))
  add(path_594073, "subscriptionId", newJString(subscriptionId))
  add(path_594073, "dataManagerName", newJString(dataManagerName))
  add(path_594073, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_594073, "dataServiceName", newJString(dataServiceName))
  result = call_594072.call(path_594073, query_594074, nil, nil, nil)

var jobDefinitionsGet* = Call_JobDefinitionsGet_594062(name: "jobDefinitionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}",
    validator: validate_JobDefinitionsGet_594063, base: "",
    url: url_JobDefinitionsGet_594064, schemes: {Scheme.Https})
type
  Call_JobDefinitionsDelete_594090 = ref object of OpenApiRestCall_593425
proc url_JobDefinitionsDelete_594092(protocol: Scheme; host: string; base: string;
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

proc validate_JobDefinitionsDelete_594091(path: JsonNode; query: JsonNode;
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
  var valid_594093 = path.getOrDefault("resourceGroupName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "resourceGroupName", valid_594093
  var valid_594094 = path.getOrDefault("subscriptionId")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "subscriptionId", valid_594094
  var valid_594095 = path.getOrDefault("dataManagerName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "dataManagerName", valid_594095
  var valid_594096 = path.getOrDefault("jobDefinitionName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "jobDefinitionName", valid_594096
  var valid_594097 = path.getOrDefault("dataServiceName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "dataServiceName", valid_594097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594098 = query.getOrDefault("api-version")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "api-version", valid_594098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594099: Call_JobDefinitionsDelete_594090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method deletes the given job definition.
  ## 
  let valid = call_594099.validator(path, query, header, formData, body)
  let scheme = call_594099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594099.url(scheme.get, call_594099.host, call_594099.base,
                         call_594099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594099, url, valid)

proc call*(call_594100: Call_JobDefinitionsDelete_594090;
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
  var path_594101 = newJObject()
  var query_594102 = newJObject()
  add(path_594101, "resourceGroupName", newJString(resourceGroupName))
  add(query_594102, "api-version", newJString(apiVersion))
  add(path_594101, "subscriptionId", newJString(subscriptionId))
  add(path_594101, "dataManagerName", newJString(dataManagerName))
  add(path_594101, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_594101, "dataServiceName", newJString(dataServiceName))
  result = call_594100.call(path_594101, query_594102, nil, nil, nil)

var jobDefinitionsDelete* = Call_JobDefinitionsDelete_594090(
    name: "jobDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}",
    validator: validate_JobDefinitionsDelete_594091, base: "",
    url: url_JobDefinitionsDelete_594092, schemes: {Scheme.Https})
type
  Call_JobsListByJobDefinition_594103 = ref object of OpenApiRestCall_593425
proc url_JobsListByJobDefinition_594105(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByJobDefinition_594104(path: JsonNode; query: JsonNode;
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
  var valid_594108 = path.getOrDefault("dataManagerName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "dataManagerName", valid_594108
  var valid_594109 = path.getOrDefault("jobDefinitionName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "jobDefinitionName", valid_594109
  var valid_594110 = path.getOrDefault("dataServiceName")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "dataServiceName", valid_594110
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594111 = query.getOrDefault("api-version")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "api-version", valid_594111
  var valid_594112 = query.getOrDefault("$filter")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "$filter", valid_594112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594113: Call_JobsListByJobDefinition_594103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets all the jobs of a given job definition.
  ## 
  let valid = call_594113.validator(path, query, header, formData, body)
  let scheme = call_594113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594113.url(scheme.get, call_594113.host, call_594113.base,
                         call_594113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594113, url, valid)

proc call*(call_594114: Call_JobsListByJobDefinition_594103;
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
  var path_594115 = newJObject()
  var query_594116 = newJObject()
  add(path_594115, "resourceGroupName", newJString(resourceGroupName))
  add(query_594116, "api-version", newJString(apiVersion))
  add(path_594115, "subscriptionId", newJString(subscriptionId))
  add(path_594115, "dataManagerName", newJString(dataManagerName))
  add(path_594115, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_594115, "dataServiceName", newJString(dataServiceName))
  add(query_594116, "$filter", newJString(Filter))
  result = call_594114.call(path_594115, query_594116, nil, nil, nil)

var jobsListByJobDefinition* = Call_JobsListByJobDefinition_594103(
    name: "jobsListByJobDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}/jobs",
    validator: validate_JobsListByJobDefinition_594104, base: "",
    url: url_JobsListByJobDefinition_594105, schemes: {Scheme.Https})
type
  Call_JobsGet_594117 = ref object of OpenApiRestCall_593425
proc url_JobsGet_594119(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_594118(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594120 = path.getOrDefault("resourceGroupName")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "resourceGroupName", valid_594120
  var valid_594121 = path.getOrDefault("jobId")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "jobId", valid_594121
  var valid_594122 = path.getOrDefault("subscriptionId")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "subscriptionId", valid_594122
  var valid_594123 = path.getOrDefault("dataManagerName")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "dataManagerName", valid_594123
  var valid_594124 = path.getOrDefault("jobDefinitionName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "jobDefinitionName", valid_594124
  var valid_594125 = path.getOrDefault("dataServiceName")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "dataServiceName", valid_594125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $expand: JString
  ##          : $expand is supported on details parameter for job, which provides details on the job stages.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594126 = query.getOrDefault("api-version")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "api-version", valid_594126
  var valid_594127 = query.getOrDefault("$expand")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "$expand", valid_594127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594128: Call_JobsGet_594117; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets a data manager job given the jobId.
  ## 
  let valid = call_594128.validator(path, query, header, formData, body)
  let scheme = call_594128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594128.url(scheme.get, call_594128.host, call_594128.base,
                         call_594128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594128, url, valid)

proc call*(call_594129: Call_JobsGet_594117; resourceGroupName: string;
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
  var path_594130 = newJObject()
  var query_594131 = newJObject()
  add(path_594130, "resourceGroupName", newJString(resourceGroupName))
  add(query_594131, "api-version", newJString(apiVersion))
  add(query_594131, "$expand", newJString(Expand))
  add(path_594130, "jobId", newJString(jobId))
  add(path_594130, "subscriptionId", newJString(subscriptionId))
  add(path_594130, "dataManagerName", newJString(dataManagerName))
  add(path_594130, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_594130, "dataServiceName", newJString(dataServiceName))
  result = call_594129.call(path_594130, query_594131, nil, nil, nil)

var jobsGet* = Call_JobsGet_594117(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}/jobs/{jobId}",
                                validator: validate_JobsGet_594118, base: "",
                                url: url_JobsGet_594119, schemes: {Scheme.Https})
type
  Call_JobsCancel_594132 = ref object of OpenApiRestCall_593425
proc url_JobsCancel_594134(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsCancel_594133(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594135 = path.getOrDefault("resourceGroupName")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "resourceGroupName", valid_594135
  var valid_594136 = path.getOrDefault("jobId")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "jobId", valid_594136
  var valid_594137 = path.getOrDefault("subscriptionId")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "subscriptionId", valid_594137
  var valid_594138 = path.getOrDefault("dataManagerName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "dataManagerName", valid_594138
  var valid_594139 = path.getOrDefault("jobDefinitionName")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "jobDefinitionName", valid_594139
  var valid_594140 = path.getOrDefault("dataServiceName")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "dataServiceName", valid_594140
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594141 = query.getOrDefault("api-version")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "api-version", valid_594141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594142: Call_JobsCancel_594132; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the given job.
  ## 
  let valid = call_594142.validator(path, query, header, formData, body)
  let scheme = call_594142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594142.url(scheme.get, call_594142.host, call_594142.base,
                         call_594142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594142, url, valid)

proc call*(call_594143: Call_JobsCancel_594132; resourceGroupName: string;
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
  var path_594144 = newJObject()
  var query_594145 = newJObject()
  add(path_594144, "resourceGroupName", newJString(resourceGroupName))
  add(query_594145, "api-version", newJString(apiVersion))
  add(path_594144, "jobId", newJString(jobId))
  add(path_594144, "subscriptionId", newJString(subscriptionId))
  add(path_594144, "dataManagerName", newJString(dataManagerName))
  add(path_594144, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_594144, "dataServiceName", newJString(dataServiceName))
  result = call_594143.call(path_594144, query_594145, nil, nil, nil)

var jobsCancel* = Call_JobsCancel_594132(name: "jobsCancel",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}/jobs/{jobId}/cancel",
                                      validator: validate_JobsCancel_594133,
                                      base: "", url: url_JobsCancel_594134,
                                      schemes: {Scheme.Https})
type
  Call_JobsResume_594146 = ref object of OpenApiRestCall_593425
proc url_JobsResume_594148(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsResume_594147(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594149 = path.getOrDefault("resourceGroupName")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "resourceGroupName", valid_594149
  var valid_594150 = path.getOrDefault("jobId")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "jobId", valid_594150
  var valid_594151 = path.getOrDefault("subscriptionId")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "subscriptionId", valid_594151
  var valid_594152 = path.getOrDefault("dataManagerName")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "dataManagerName", valid_594152
  var valid_594153 = path.getOrDefault("jobDefinitionName")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "jobDefinitionName", valid_594153
  var valid_594154 = path.getOrDefault("dataServiceName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "dataServiceName", valid_594154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594155 = query.getOrDefault("api-version")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "api-version", valid_594155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594156: Call_JobsResume_594146; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resumes the given job.
  ## 
  let valid = call_594156.validator(path, query, header, formData, body)
  let scheme = call_594156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594156.url(scheme.get, call_594156.host, call_594156.base,
                         call_594156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594156, url, valid)

proc call*(call_594157: Call_JobsResume_594146; resourceGroupName: string;
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
  var path_594158 = newJObject()
  var query_594159 = newJObject()
  add(path_594158, "resourceGroupName", newJString(resourceGroupName))
  add(query_594159, "api-version", newJString(apiVersion))
  add(path_594158, "jobId", newJString(jobId))
  add(path_594158, "subscriptionId", newJString(subscriptionId))
  add(path_594158, "dataManagerName", newJString(dataManagerName))
  add(path_594158, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_594158, "dataServiceName", newJString(dataServiceName))
  result = call_594157.call(path_594158, query_594159, nil, nil, nil)

var jobsResume* = Call_JobsResume_594146(name: "jobsResume",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}/jobs/{jobId}/resume",
                                      validator: validate_JobsResume_594147,
                                      base: "", url: url_JobsResume_594148,
                                      schemes: {Scheme.Https})
type
  Call_JobDefinitionsRun_594160 = ref object of OpenApiRestCall_593425
proc url_JobDefinitionsRun_594162(protocol: Scheme; host: string; base: string;
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

proc validate_JobDefinitionsRun_594161(path: JsonNode; query: JsonNode;
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
  var valid_594163 = path.getOrDefault("resourceGroupName")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "resourceGroupName", valid_594163
  var valid_594164 = path.getOrDefault("subscriptionId")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "subscriptionId", valid_594164
  var valid_594165 = path.getOrDefault("dataManagerName")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "dataManagerName", valid_594165
  var valid_594166 = path.getOrDefault("jobDefinitionName")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "jobDefinitionName", valid_594166
  var valid_594167 = path.getOrDefault("dataServiceName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "dataServiceName", valid_594167
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594168 = query.getOrDefault("api-version")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "api-version", valid_594168
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

proc call*(call_594170: Call_JobDefinitionsRun_594160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method runs a job instance of the given job definition.
  ## 
  let valid = call_594170.validator(path, query, header, formData, body)
  let scheme = call_594170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594170.url(scheme.get, call_594170.host, call_594170.base,
                         call_594170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594170, url, valid)

proc call*(call_594171: Call_JobDefinitionsRun_594160; resourceGroupName: string;
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
  var path_594172 = newJObject()
  var query_594173 = newJObject()
  var body_594174 = newJObject()
  add(path_594172, "resourceGroupName", newJString(resourceGroupName))
  add(query_594173, "api-version", newJString(apiVersion))
  if runParameters != nil:
    body_594174 = runParameters
  add(path_594172, "subscriptionId", newJString(subscriptionId))
  add(path_594172, "dataManagerName", newJString(dataManagerName))
  add(path_594172, "jobDefinitionName", newJString(jobDefinitionName))
  add(path_594172, "dataServiceName", newJString(dataServiceName))
  result = call_594171.call(path_594172, query_594173, nil, nil, body_594174)

var jobDefinitionsRun* = Call_JobDefinitionsRun_594160(name: "jobDefinitionsRun",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobDefinitions/{jobDefinitionName}/run",
    validator: validate_JobDefinitionsRun_594161, base: "",
    url: url_JobDefinitionsRun_594162, schemes: {Scheme.Https})
type
  Call_JobsListByDataService_594175 = ref object of OpenApiRestCall_593425
proc url_JobsListByDataService_594177(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByDataService_594176(path: JsonNode; query: JsonNode;
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
  var valid_594178 = path.getOrDefault("resourceGroupName")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "resourceGroupName", valid_594178
  var valid_594179 = path.getOrDefault("subscriptionId")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "subscriptionId", valid_594179
  var valid_594180 = path.getOrDefault("dataManagerName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "dataManagerName", valid_594180
  var valid_594181 = path.getOrDefault("dataServiceName")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "dataServiceName", valid_594181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594182 = query.getOrDefault("api-version")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "api-version", valid_594182
  var valid_594183 = query.getOrDefault("$filter")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "$filter", valid_594183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594184: Call_JobsListByDataService_594175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets all the jobs of a data service type in a given resource.
  ## 
  let valid = call_594184.validator(path, query, header, formData, body)
  let scheme = call_594184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594184.url(scheme.get, call_594184.host, call_594184.base,
                         call_594184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594184, url, valid)

proc call*(call_594185: Call_JobsListByDataService_594175;
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
  var path_594186 = newJObject()
  var query_594187 = newJObject()
  add(path_594186, "resourceGroupName", newJString(resourceGroupName))
  add(query_594187, "api-version", newJString(apiVersion))
  add(path_594186, "subscriptionId", newJString(subscriptionId))
  add(path_594186, "dataManagerName", newJString(dataManagerName))
  add(path_594186, "dataServiceName", newJString(dataServiceName))
  add(query_594187, "$filter", newJString(Filter))
  result = call_594185.call(path_594186, query_594187, nil, nil, nil)

var jobsListByDataService* = Call_JobsListByDataService_594175(
    name: "jobsListByDataService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataServices/{dataServiceName}/jobs",
    validator: validate_JobsListByDataService_594176, base: "",
    url: url_JobsListByDataService_594177, schemes: {Scheme.Https})
type
  Call_DataStoreTypesListByDataManager_594188 = ref object of OpenApiRestCall_593425
proc url_DataStoreTypesListByDataManager_594190(protocol: Scheme; host: string;
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

proc validate_DataStoreTypesListByDataManager_594189(path: JsonNode;
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
  var valid_594191 = path.getOrDefault("resourceGroupName")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "resourceGroupName", valid_594191
  var valid_594192 = path.getOrDefault("subscriptionId")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "subscriptionId", valid_594192
  var valid_594193 = path.getOrDefault("dataManagerName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "dataManagerName", valid_594193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594194 = query.getOrDefault("api-version")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "api-version", valid_594194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594195: Call_DataStoreTypesListByDataManager_594188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the data store/repository types that the resource supports.
  ## 
  let valid = call_594195.validator(path, query, header, formData, body)
  let scheme = call_594195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594195.url(scheme.get, call_594195.host, call_594195.base,
                         call_594195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594195, url, valid)

proc call*(call_594196: Call_DataStoreTypesListByDataManager_594188;
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
  var path_594197 = newJObject()
  var query_594198 = newJObject()
  add(path_594197, "resourceGroupName", newJString(resourceGroupName))
  add(query_594198, "api-version", newJString(apiVersion))
  add(path_594197, "subscriptionId", newJString(subscriptionId))
  add(path_594197, "dataManagerName", newJString(dataManagerName))
  result = call_594196.call(path_594197, query_594198, nil, nil, nil)

var dataStoreTypesListByDataManager* = Call_DataStoreTypesListByDataManager_594188(
    name: "dataStoreTypesListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStoreTypes",
    validator: validate_DataStoreTypesListByDataManager_594189, base: "",
    url: url_DataStoreTypesListByDataManager_594190, schemes: {Scheme.Https})
type
  Call_DataStoreTypesGet_594199 = ref object of OpenApiRestCall_593425
proc url_DataStoreTypesGet_594201(protocol: Scheme; host: string; base: string;
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

proc validate_DataStoreTypesGet_594200(path: JsonNode; query: JsonNode;
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
  var valid_594202 = path.getOrDefault("resourceGroupName")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "resourceGroupName", valid_594202
  var valid_594203 = path.getOrDefault("subscriptionId")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "subscriptionId", valid_594203
  var valid_594204 = path.getOrDefault("dataManagerName")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "dataManagerName", valid_594204
  var valid_594205 = path.getOrDefault("dataStoreTypeName")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "dataStoreTypeName", valid_594205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594206 = query.getOrDefault("api-version")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "api-version", valid_594206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594207: Call_DataStoreTypesGet_594199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the data store/repository type given its name.
  ## 
  let valid = call_594207.validator(path, query, header, formData, body)
  let scheme = call_594207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594207.url(scheme.get, call_594207.host, call_594207.base,
                         call_594207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594207, url, valid)

proc call*(call_594208: Call_DataStoreTypesGet_594199; resourceGroupName: string;
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
  var path_594209 = newJObject()
  var query_594210 = newJObject()
  add(path_594209, "resourceGroupName", newJString(resourceGroupName))
  add(query_594210, "api-version", newJString(apiVersion))
  add(path_594209, "subscriptionId", newJString(subscriptionId))
  add(path_594209, "dataManagerName", newJString(dataManagerName))
  add(path_594209, "dataStoreTypeName", newJString(dataStoreTypeName))
  result = call_594208.call(path_594209, query_594210, nil, nil, nil)

var dataStoreTypesGet* = Call_DataStoreTypesGet_594199(name: "dataStoreTypesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStoreTypes/{dataStoreTypeName}",
    validator: validate_DataStoreTypesGet_594200, base: "",
    url: url_DataStoreTypesGet_594201, schemes: {Scheme.Https})
type
  Call_DataStoresListByDataManager_594211 = ref object of OpenApiRestCall_593425
proc url_DataStoresListByDataManager_594213(protocol: Scheme; host: string;
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

proc validate_DataStoresListByDataManager_594212(path: JsonNode; query: JsonNode;
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
  var valid_594216 = path.getOrDefault("dataManagerName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "dataManagerName", valid_594216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594217 = query.getOrDefault("api-version")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "api-version", valid_594217
  var valid_594218 = query.getOrDefault("$filter")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "$filter", valid_594218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594219: Call_DataStoresListByDataManager_594211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the data stores/repositories in the given resource.
  ## 
  let valid = call_594219.validator(path, query, header, formData, body)
  let scheme = call_594219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594219.url(scheme.get, call_594219.host, call_594219.base,
                         call_594219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594219, url, valid)

proc call*(call_594220: Call_DataStoresListByDataManager_594211;
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
  var path_594221 = newJObject()
  var query_594222 = newJObject()
  add(path_594221, "resourceGroupName", newJString(resourceGroupName))
  add(query_594222, "api-version", newJString(apiVersion))
  add(path_594221, "subscriptionId", newJString(subscriptionId))
  add(path_594221, "dataManagerName", newJString(dataManagerName))
  add(query_594222, "$filter", newJString(Filter))
  result = call_594220.call(path_594221, query_594222, nil, nil, nil)

var dataStoresListByDataManager* = Call_DataStoresListByDataManager_594211(
    name: "dataStoresListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStores",
    validator: validate_DataStoresListByDataManager_594212, base: "",
    url: url_DataStoresListByDataManager_594213, schemes: {Scheme.Https})
type
  Call_DataStoresCreateOrUpdate_594235 = ref object of OpenApiRestCall_593425
proc url_DataStoresCreateOrUpdate_594237(protocol: Scheme; host: string;
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

proc validate_DataStoresCreateOrUpdate_594236(path: JsonNode; query: JsonNode;
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
  var valid_594240 = path.getOrDefault("dataManagerName")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "dataManagerName", valid_594240
  var valid_594241 = path.getOrDefault("dataStoreName")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "dataStoreName", valid_594241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594242 = query.getOrDefault("api-version")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "api-version", valid_594242
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

proc call*(call_594244: Call_DataStoresCreateOrUpdate_594235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the data store/repository in the data manager.
  ## 
  let valid = call_594244.validator(path, query, header, formData, body)
  let scheme = call_594244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594244.url(scheme.get, call_594244.host, call_594244.base,
                         call_594244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594244, url, valid)

proc call*(call_594245: Call_DataStoresCreateOrUpdate_594235;
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
  var path_594246 = newJObject()
  var query_594247 = newJObject()
  var body_594248 = newJObject()
  add(path_594246, "resourceGroupName", newJString(resourceGroupName))
  add(query_594247, "api-version", newJString(apiVersion))
  add(path_594246, "subscriptionId", newJString(subscriptionId))
  add(path_594246, "dataManagerName", newJString(dataManagerName))
  if dataStore != nil:
    body_594248 = dataStore
  add(path_594246, "dataStoreName", newJString(dataStoreName))
  result = call_594245.call(path_594246, query_594247, nil, nil, body_594248)

var dataStoresCreateOrUpdate* = Call_DataStoresCreateOrUpdate_594235(
    name: "dataStoresCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStores/{dataStoreName}",
    validator: validate_DataStoresCreateOrUpdate_594236, base: "",
    url: url_DataStoresCreateOrUpdate_594237, schemes: {Scheme.Https})
type
  Call_DataStoresGet_594223 = ref object of OpenApiRestCall_593425
proc url_DataStoresGet_594225(protocol: Scheme; host: string; base: string;
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

proc validate_DataStoresGet_594224(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594226 = path.getOrDefault("resourceGroupName")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "resourceGroupName", valid_594226
  var valid_594227 = path.getOrDefault("subscriptionId")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "subscriptionId", valid_594227
  var valid_594228 = path.getOrDefault("dataManagerName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "dataManagerName", valid_594228
  var valid_594229 = path.getOrDefault("dataStoreName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "dataStoreName", valid_594229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
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

proc call*(call_594231: Call_DataStoresGet_594223; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets the data store/repository by name.
  ## 
  let valid = call_594231.validator(path, query, header, formData, body)
  let scheme = call_594231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594231.url(scheme.get, call_594231.host, call_594231.base,
                         call_594231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594231, url, valid)

proc call*(call_594232: Call_DataStoresGet_594223; resourceGroupName: string;
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
  var path_594233 = newJObject()
  var query_594234 = newJObject()
  add(path_594233, "resourceGroupName", newJString(resourceGroupName))
  add(query_594234, "api-version", newJString(apiVersion))
  add(path_594233, "subscriptionId", newJString(subscriptionId))
  add(path_594233, "dataManagerName", newJString(dataManagerName))
  add(path_594233, "dataStoreName", newJString(dataStoreName))
  result = call_594232.call(path_594233, query_594234, nil, nil, nil)

var dataStoresGet* = Call_DataStoresGet_594223(name: "dataStoresGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStores/{dataStoreName}",
    validator: validate_DataStoresGet_594224, base: "", url: url_DataStoresGet_594225,
    schemes: {Scheme.Https})
type
  Call_DataStoresDelete_594249 = ref object of OpenApiRestCall_593425
proc url_DataStoresDelete_594251(protocol: Scheme; host: string; base: string;
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

proc validate_DataStoresDelete_594250(path: JsonNode; query: JsonNode;
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
  var valid_594252 = path.getOrDefault("resourceGroupName")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "resourceGroupName", valid_594252
  var valid_594253 = path.getOrDefault("subscriptionId")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "subscriptionId", valid_594253
  var valid_594254 = path.getOrDefault("dataManagerName")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "dataManagerName", valid_594254
  var valid_594255 = path.getOrDefault("dataStoreName")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "dataStoreName", valid_594255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594256 = query.getOrDefault("api-version")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "api-version", valid_594256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594257: Call_DataStoresDelete_594249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method deletes the given data store/repository.
  ## 
  let valid = call_594257.validator(path, query, header, formData, body)
  let scheme = call_594257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594257.url(scheme.get, call_594257.host, call_594257.base,
                         call_594257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594257, url, valid)

proc call*(call_594258: Call_DataStoresDelete_594249; resourceGroupName: string;
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
  var path_594259 = newJObject()
  var query_594260 = newJObject()
  add(path_594259, "resourceGroupName", newJString(resourceGroupName))
  add(query_594260, "api-version", newJString(apiVersion))
  add(path_594259, "subscriptionId", newJString(subscriptionId))
  add(path_594259, "dataManagerName", newJString(dataManagerName))
  add(path_594259, "dataStoreName", newJString(dataStoreName))
  result = call_594258.call(path_594259, query_594260, nil, nil, nil)

var dataStoresDelete* = Call_DataStoresDelete_594249(name: "dataStoresDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/dataStores/{dataStoreName}",
    validator: validate_DataStoresDelete_594250, base: "",
    url: url_DataStoresDelete_594251, schemes: {Scheme.Https})
type
  Call_JobDefinitionsListByDataManager_594261 = ref object of OpenApiRestCall_593425
proc url_JobDefinitionsListByDataManager_594263(protocol: Scheme; host: string;
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

proc validate_JobDefinitionsListByDataManager_594262(path: JsonNode;
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
  var valid_594264 = path.getOrDefault("resourceGroupName")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "resourceGroupName", valid_594264
  var valid_594265 = path.getOrDefault("subscriptionId")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "subscriptionId", valid_594265
  var valid_594266 = path.getOrDefault("dataManagerName")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "dataManagerName", valid_594266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594267 = query.getOrDefault("api-version")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "api-version", valid_594267
  var valid_594268 = query.getOrDefault("$filter")
  valid_594268 = validateParameter(valid_594268, JString, required = false,
                                 default = nil)
  if valid_594268 != nil:
    section.add "$filter", valid_594268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594269: Call_JobDefinitionsListByDataManager_594261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This method gets all the job definitions of the given data manager resource.
  ## 
  let valid = call_594269.validator(path, query, header, formData, body)
  let scheme = call_594269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594269.url(scheme.get, call_594269.host, call_594269.base,
                         call_594269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594269, url, valid)

proc call*(call_594270: Call_JobDefinitionsListByDataManager_594261;
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
  var path_594271 = newJObject()
  var query_594272 = newJObject()
  add(path_594271, "resourceGroupName", newJString(resourceGroupName))
  add(query_594272, "api-version", newJString(apiVersion))
  add(path_594271, "subscriptionId", newJString(subscriptionId))
  add(path_594271, "dataManagerName", newJString(dataManagerName))
  add(query_594272, "$filter", newJString(Filter))
  result = call_594270.call(path_594271, query_594272, nil, nil, nil)

var jobDefinitionsListByDataManager* = Call_JobDefinitionsListByDataManager_594261(
    name: "jobDefinitionsListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/jobDefinitions",
    validator: validate_JobDefinitionsListByDataManager_594262, base: "",
    url: url_JobDefinitionsListByDataManager_594263, schemes: {Scheme.Https})
type
  Call_JobsListByDataManager_594273 = ref object of OpenApiRestCall_593425
proc url_JobsListByDataManager_594275(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByDataManager_594274(path: JsonNode; query: JsonNode;
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
  var valid_594276 = path.getOrDefault("resourceGroupName")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "resourceGroupName", valid_594276
  var valid_594277 = path.getOrDefault("subscriptionId")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "subscriptionId", valid_594277
  var valid_594278 = path.getOrDefault("dataManagerName")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "dataManagerName", valid_594278
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594279 = query.getOrDefault("api-version")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "api-version", valid_594279
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

proc call*(call_594281: Call_JobsListByDataManager_594273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets all the jobs at the data manager resource level.
  ## 
  let valid = call_594281.validator(path, query, header, formData, body)
  let scheme = call_594281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594281.url(scheme.get, call_594281.host, call_594281.base,
                         call_594281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594281, url, valid)

proc call*(call_594282: Call_JobsListByDataManager_594273;
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
  var path_594283 = newJObject()
  var query_594284 = newJObject()
  add(path_594283, "resourceGroupName", newJString(resourceGroupName))
  add(query_594284, "api-version", newJString(apiVersion))
  add(path_594283, "subscriptionId", newJString(subscriptionId))
  add(path_594283, "dataManagerName", newJString(dataManagerName))
  add(query_594284, "$filter", newJString(Filter))
  result = call_594282.call(path_594283, query_594284, nil, nil, nil)

var jobsListByDataManager* = Call_JobsListByDataManager_594273(
    name: "jobsListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/jobs",
    validator: validate_JobsListByDataManager_594274, base: "",
    url: url_JobsListByDataManager_594275, schemes: {Scheme.Https})
type
  Call_PublicKeysListByDataManager_594285 = ref object of OpenApiRestCall_593425
proc url_PublicKeysListByDataManager_594287(protocol: Scheme; host: string;
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

proc validate_PublicKeysListByDataManager_594286(path: JsonNode; query: JsonNode;
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
  var valid_594288 = path.getOrDefault("resourceGroupName")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "resourceGroupName", valid_594288
  var valid_594289 = path.getOrDefault("subscriptionId")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "subscriptionId", valid_594289
  var valid_594290 = path.getOrDefault("dataManagerName")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "dataManagerName", valid_594290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
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

proc call*(call_594292: Call_PublicKeysListByDataManager_594285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets the list view of public keys, however it will only have one element.
  ## 
  let valid = call_594292.validator(path, query, header, formData, body)
  let scheme = call_594292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594292.url(scheme.get, call_594292.host, call_594292.base,
                         call_594292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594292, url, valid)

proc call*(call_594293: Call_PublicKeysListByDataManager_594285;
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
  var path_594294 = newJObject()
  var query_594295 = newJObject()
  add(path_594294, "resourceGroupName", newJString(resourceGroupName))
  add(query_594295, "api-version", newJString(apiVersion))
  add(path_594294, "subscriptionId", newJString(subscriptionId))
  add(path_594294, "dataManagerName", newJString(dataManagerName))
  result = call_594293.call(path_594294, query_594295, nil, nil, nil)

var publicKeysListByDataManager* = Call_PublicKeysListByDataManager_594285(
    name: "publicKeysListByDataManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/publicKeys",
    validator: validate_PublicKeysListByDataManager_594286, base: "",
    url: url_PublicKeysListByDataManager_594287, schemes: {Scheme.Https})
type
  Call_PublicKeysGet_594296 = ref object of OpenApiRestCall_593425
proc url_PublicKeysGet_594298(protocol: Scheme; host: string; base: string;
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

proc validate_PublicKeysGet_594297(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594299 = path.getOrDefault("resourceGroupName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "resourceGroupName", valid_594299
  var valid_594300 = path.getOrDefault("publicKeyName")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "publicKeyName", valid_594300
  var valid_594301 = path.getOrDefault("subscriptionId")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "subscriptionId", valid_594301
  var valid_594302 = path.getOrDefault("dataManagerName")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "dataManagerName", valid_594302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594303 = query.getOrDefault("api-version")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "api-version", valid_594303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594304: Call_PublicKeysGet_594296; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method gets the public keys.
  ## 
  let valid = call_594304.validator(path, query, header, formData, body)
  let scheme = call_594304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594304.url(scheme.get, call_594304.host, call_594304.base,
                         call_594304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594304, url, valid)

proc call*(call_594305: Call_PublicKeysGet_594296; resourceGroupName: string;
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
  var path_594306 = newJObject()
  var query_594307 = newJObject()
  add(path_594306, "resourceGroupName", newJString(resourceGroupName))
  add(query_594307, "api-version", newJString(apiVersion))
  add(path_594306, "publicKeyName", newJString(publicKeyName))
  add(path_594306, "subscriptionId", newJString(subscriptionId))
  add(path_594306, "dataManagerName", newJString(dataManagerName))
  result = call_594305.call(path_594306, query_594307, nil, nil, nil)

var publicKeysGet* = Call_PublicKeysGet_594296(name: "publicKeysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridData/dataManagers/{dataManagerName}/publicKeys/{publicKeyName}",
    validator: validate_PublicKeysGet_594297, base: "", url: url_PublicKeysGet_594298,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
