
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: BatchManagement
## version: 2018-12-01
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

  OpenApiRestCall_574466 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574466](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574466): Option[Scheme] {.used.} =
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
  macServiceName = "batch-BatchManagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_574688 = ref object of OpenApiRestCall_574466
proc url_OperationsList_574690(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_574689(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists available operations for the Microsoft.Batch provider
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574849 = query.getOrDefault("api-version")
  valid_574849 = validateParameter(valid_574849, JString, required = true,
                                 default = nil)
  if valid_574849 != nil:
    section.add "api-version", valid_574849
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574872: Call_OperationsList_574688; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations for the Microsoft.Batch provider
  ## 
  let valid = call_574872.validator(path, query, header, formData, body)
  let scheme = call_574872.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574872.url(scheme.get, call_574872.host, call_574872.base,
                         call_574872.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574872, url, valid)

proc call*(call_574943: Call_OperationsList_574688; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations for the Microsoft.Batch provider
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  var query_574944 = newJObject()
  add(query_574944, "api-version", newJString(apiVersion))
  result = call_574943.call(nil, query_574944, nil, nil, nil)

var operationsList* = Call_OperationsList_574688(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Batch/operations",
    validator: validate_OperationsList_574689, base: "", url: url_OperationsList_574690,
    schemes: {Scheme.Https})
type
  Call_BatchAccountList_574984 = ref object of OpenApiRestCall_574466
proc url_BatchAccountList_574986(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountList_574985(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets information about the Batch accounts associated with the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575001 = path.getOrDefault("subscriptionId")
  valid_575001 = validateParameter(valid_575001, JString, required = true,
                                 default = nil)
  if valid_575001 != nil:
    section.add "subscriptionId", valid_575001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575002 = query.getOrDefault("api-version")
  valid_575002 = validateParameter(valid_575002, JString, required = true,
                                 default = nil)
  if valid_575002 != nil:
    section.add "api-version", valid_575002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575003: Call_BatchAccountList_574984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the Batch accounts associated with the subscription.
  ## 
  let valid = call_575003.validator(path, query, header, formData, body)
  let scheme = call_575003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575003.url(scheme.get, call_575003.host, call_575003.base,
                         call_575003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575003, url, valid)

proc call*(call_575004: Call_BatchAccountList_574984; apiVersion: string;
          subscriptionId: string): Recallable =
  ## batchAccountList
  ## Gets information about the Batch accounts associated with the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  var path_575005 = newJObject()
  var query_575006 = newJObject()
  add(query_575006, "api-version", newJString(apiVersion))
  add(path_575005, "subscriptionId", newJString(subscriptionId))
  result = call_575004.call(path_575005, query_575006, nil, nil, nil)

var batchAccountList* = Call_BatchAccountList_574984(name: "batchAccountList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Batch/batchAccounts",
    validator: validate_BatchAccountList_574985, base: "",
    url: url_BatchAccountList_574986, schemes: {Scheme.Https})
type
  Call_LocationCheckNameAvailability_575007 = ref object of OpenApiRestCall_574466
proc url_LocationCheckNameAvailability_575009(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationCheckNameAvailability_575008(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the Batch account name is available in the specified region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   locationName: JString (required)
  ##               : The desired region for the name check.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575027 = path.getOrDefault("subscriptionId")
  valid_575027 = validateParameter(valid_575027, JString, required = true,
                                 default = nil)
  if valid_575027 != nil:
    section.add "subscriptionId", valid_575027
  var valid_575028 = path.getOrDefault("locationName")
  valid_575028 = validateParameter(valid_575028, JString, required = true,
                                 default = nil)
  if valid_575028 != nil:
    section.add "locationName", valid_575028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575029 = query.getOrDefault("api-version")
  valid_575029 = validateParameter(valid_575029, JString, required = true,
                                 default = nil)
  if valid_575029 != nil:
    section.add "api-version", valid_575029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Properties needed to check the availability of a name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575031: Call_LocationCheckNameAvailability_575007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the Batch account name is available in the specified region.
  ## 
  let valid = call_575031.validator(path, query, header, formData, body)
  let scheme = call_575031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575031.url(scheme.get, call_575031.host, call_575031.base,
                         call_575031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575031, url, valid)

proc call*(call_575032: Call_LocationCheckNameAvailability_575007;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          locationName: string): Recallable =
  ## locationCheckNameAvailability
  ## Checks whether the Batch account name is available in the specified region.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   parameters: JObject (required)
  ##             : Properties needed to check the availability of a name.
  ##   locationName: string (required)
  ##               : The desired region for the name check.
  var path_575033 = newJObject()
  var query_575034 = newJObject()
  var body_575035 = newJObject()
  add(query_575034, "api-version", newJString(apiVersion))
  add(path_575033, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575035 = parameters
  add(path_575033, "locationName", newJString(locationName))
  result = call_575032.call(path_575033, query_575034, nil, nil, body_575035)

var locationCheckNameAvailability* = Call_LocationCheckNameAvailability_575007(
    name: "locationCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Batch/locations/{locationName}/checkNameAvailability",
    validator: validate_LocationCheckNameAvailability_575008, base: "",
    url: url_LocationCheckNameAvailability_575009, schemes: {Scheme.Https})
type
  Call_LocationGetQuotas_575036 = ref object of OpenApiRestCall_574466
proc url_LocationGetQuotas_575038(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/quotas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationGetQuotas_575037(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the Batch service quotas for the specified subscription at the given location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   locationName: JString (required)
  ##               : The region for which to retrieve Batch service quotas.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575039 = path.getOrDefault("subscriptionId")
  valid_575039 = validateParameter(valid_575039, JString, required = true,
                                 default = nil)
  if valid_575039 != nil:
    section.add "subscriptionId", valid_575039
  var valid_575040 = path.getOrDefault("locationName")
  valid_575040 = validateParameter(valid_575040, JString, required = true,
                                 default = nil)
  if valid_575040 != nil:
    section.add "locationName", valid_575040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575041 = query.getOrDefault("api-version")
  valid_575041 = validateParameter(valid_575041, JString, required = true,
                                 default = nil)
  if valid_575041 != nil:
    section.add "api-version", valid_575041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575042: Call_LocationGetQuotas_575036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Batch service quotas for the specified subscription at the given location.
  ## 
  let valid = call_575042.validator(path, query, header, formData, body)
  let scheme = call_575042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575042.url(scheme.get, call_575042.host, call_575042.base,
                         call_575042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575042, url, valid)

proc call*(call_575043: Call_LocationGetQuotas_575036; apiVersion: string;
          subscriptionId: string; locationName: string): Recallable =
  ## locationGetQuotas
  ## Gets the Batch service quotas for the specified subscription at the given location.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   locationName: string (required)
  ##               : The region for which to retrieve Batch service quotas.
  var path_575044 = newJObject()
  var query_575045 = newJObject()
  add(query_575045, "api-version", newJString(apiVersion))
  add(path_575044, "subscriptionId", newJString(subscriptionId))
  add(path_575044, "locationName", newJString(locationName))
  result = call_575043.call(path_575044, query_575045, nil, nil, nil)

var locationGetQuotas* = Call_LocationGetQuotas_575036(name: "locationGetQuotas",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Batch/locations/{locationName}/quotas",
    validator: validate_LocationGetQuotas_575037, base: "",
    url: url_LocationGetQuotas_575038, schemes: {Scheme.Https})
type
  Call_BatchAccountListByResourceGroup_575046 = ref object of OpenApiRestCall_574466
proc url_BatchAccountListByResourceGroup_575048(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountListByResourceGroup_575047(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the Batch accounts associated with the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575049 = path.getOrDefault("resourceGroupName")
  valid_575049 = validateParameter(valid_575049, JString, required = true,
                                 default = nil)
  if valid_575049 != nil:
    section.add "resourceGroupName", valid_575049
  var valid_575050 = path.getOrDefault("subscriptionId")
  valid_575050 = validateParameter(valid_575050, JString, required = true,
                                 default = nil)
  if valid_575050 != nil:
    section.add "subscriptionId", valid_575050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575051 = query.getOrDefault("api-version")
  valid_575051 = validateParameter(valid_575051, JString, required = true,
                                 default = nil)
  if valid_575051 != nil:
    section.add "api-version", valid_575051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575052: Call_BatchAccountListByResourceGroup_575046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the Batch accounts associated with the specified resource group.
  ## 
  let valid = call_575052.validator(path, query, header, formData, body)
  let scheme = call_575052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575052.url(scheme.get, call_575052.host, call_575052.base,
                         call_575052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575052, url, valid)

proc call*(call_575053: Call_BatchAccountListByResourceGroup_575046;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## batchAccountListByResourceGroup
  ## Gets information about the Batch accounts associated with the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  var path_575054 = newJObject()
  var query_575055 = newJObject()
  add(path_575054, "resourceGroupName", newJString(resourceGroupName))
  add(query_575055, "api-version", newJString(apiVersion))
  add(path_575054, "subscriptionId", newJString(subscriptionId))
  result = call_575053.call(path_575054, query_575055, nil, nil, nil)

var batchAccountListByResourceGroup* = Call_BatchAccountListByResourceGroup_575046(
    name: "batchAccountListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts",
    validator: validate_BatchAccountListByResourceGroup_575047, base: "",
    url: url_BatchAccountListByResourceGroup_575048, schemes: {Scheme.Https})
type
  Call_BatchAccountCreate_575067 = ref object of OpenApiRestCall_574466
proc url_BatchAccountCreate_575069(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountCreate_575068(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a new Batch account with the specified parameters. Existing accounts cannot be updated with this API and should instead be updated with the Update Batch Account API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : A name for the Batch account which must be unique within the region. Batch account names must be between 3 and 24 characters in length and must use only numbers and lowercase letters. This name is used as part of the DNS name that is used to access the Batch service in the region in which the account is created. For example: http://accountname.region.batch.azure.com/.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575070 = path.getOrDefault("resourceGroupName")
  valid_575070 = validateParameter(valid_575070, JString, required = true,
                                 default = nil)
  if valid_575070 != nil:
    section.add "resourceGroupName", valid_575070
  var valid_575071 = path.getOrDefault("subscriptionId")
  valid_575071 = validateParameter(valid_575071, JString, required = true,
                                 default = nil)
  if valid_575071 != nil:
    section.add "subscriptionId", valid_575071
  var valid_575072 = path.getOrDefault("accountName")
  valid_575072 = validateParameter(valid_575072, JString, required = true,
                                 default = nil)
  if valid_575072 != nil:
    section.add "accountName", valid_575072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575073 = query.getOrDefault("api-version")
  valid_575073 = validateParameter(valid_575073, JString, required = true,
                                 default = nil)
  if valid_575073 != nil:
    section.add "api-version", valid_575073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters for account creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575075: Call_BatchAccountCreate_575067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Batch account with the specified parameters. Existing accounts cannot be updated with this API and should instead be updated with the Update Batch Account API.
  ## 
  let valid = call_575075.validator(path, query, header, formData, body)
  let scheme = call_575075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575075.url(scheme.get, call_575075.host, call_575075.base,
                         call_575075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575075, url, valid)

proc call*(call_575076: Call_BatchAccountCreate_575067; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## batchAccountCreate
  ## Creates a new Batch account with the specified parameters. Existing accounts cannot be updated with this API and should instead be updated with the Update Batch Account API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   parameters: JObject (required)
  ##             : Additional parameters for account creation.
  ##   accountName: string (required)
  ##              : A name for the Batch account which must be unique within the region. Batch account names must be between 3 and 24 characters in length and must use only numbers and lowercase letters. This name is used as part of the DNS name that is used to access the Batch service in the region in which the account is created. For example: http://accountname.region.batch.azure.com/.
  var path_575077 = newJObject()
  var query_575078 = newJObject()
  var body_575079 = newJObject()
  add(path_575077, "resourceGroupName", newJString(resourceGroupName))
  add(query_575078, "api-version", newJString(apiVersion))
  add(path_575077, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575079 = parameters
  add(path_575077, "accountName", newJString(accountName))
  result = call_575076.call(path_575077, query_575078, nil, nil, body_575079)

var batchAccountCreate* = Call_BatchAccountCreate_575067(
    name: "batchAccountCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}",
    validator: validate_BatchAccountCreate_575068, base: "",
    url: url_BatchAccountCreate_575069, schemes: {Scheme.Https})
type
  Call_BatchAccountGet_575056 = ref object of OpenApiRestCall_574466
proc url_BatchAccountGet_575058(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountGet_575057(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets information about the specified Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575059 = path.getOrDefault("resourceGroupName")
  valid_575059 = validateParameter(valid_575059, JString, required = true,
                                 default = nil)
  if valid_575059 != nil:
    section.add "resourceGroupName", valid_575059
  var valid_575060 = path.getOrDefault("subscriptionId")
  valid_575060 = validateParameter(valid_575060, JString, required = true,
                                 default = nil)
  if valid_575060 != nil:
    section.add "subscriptionId", valid_575060
  var valid_575061 = path.getOrDefault("accountName")
  valid_575061 = validateParameter(valid_575061, JString, required = true,
                                 default = nil)
  if valid_575061 != nil:
    section.add "accountName", valid_575061
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575062 = query.getOrDefault("api-version")
  valid_575062 = validateParameter(valid_575062, JString, required = true,
                                 default = nil)
  if valid_575062 != nil:
    section.add "api-version", valid_575062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575063: Call_BatchAccountGet_575056; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified Batch account.
  ## 
  let valid = call_575063.validator(path, query, header, formData, body)
  let scheme = call_575063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575063.url(scheme.get, call_575063.host, call_575063.base,
                         call_575063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575063, url, valid)

proc call*(call_575064: Call_BatchAccountGet_575056; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## batchAccountGet
  ## Gets information about the specified Batch account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575065 = newJObject()
  var query_575066 = newJObject()
  add(path_575065, "resourceGroupName", newJString(resourceGroupName))
  add(query_575066, "api-version", newJString(apiVersion))
  add(path_575065, "subscriptionId", newJString(subscriptionId))
  add(path_575065, "accountName", newJString(accountName))
  result = call_575064.call(path_575065, query_575066, nil, nil, nil)

var batchAccountGet* = Call_BatchAccountGet_575056(name: "batchAccountGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}",
    validator: validate_BatchAccountGet_575057, base: "", url: url_BatchAccountGet_575058,
    schemes: {Scheme.Https})
type
  Call_BatchAccountUpdate_575091 = ref object of OpenApiRestCall_574466
proc url_BatchAccountUpdate_575093(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountUpdate_575092(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the properties of an existing Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575094 = path.getOrDefault("resourceGroupName")
  valid_575094 = validateParameter(valid_575094, JString, required = true,
                                 default = nil)
  if valid_575094 != nil:
    section.add "resourceGroupName", valid_575094
  var valid_575095 = path.getOrDefault("subscriptionId")
  valid_575095 = validateParameter(valid_575095, JString, required = true,
                                 default = nil)
  if valid_575095 != nil:
    section.add "subscriptionId", valid_575095
  var valid_575096 = path.getOrDefault("accountName")
  valid_575096 = validateParameter(valid_575096, JString, required = true,
                                 default = nil)
  if valid_575096 != nil:
    section.add "accountName", valid_575096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575097 = query.getOrDefault("api-version")
  valid_575097 = validateParameter(valid_575097, JString, required = true,
                                 default = nil)
  if valid_575097 != nil:
    section.add "api-version", valid_575097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters for account update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575099: Call_BatchAccountUpdate_575091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing Batch account.
  ## 
  let valid = call_575099.validator(path, query, header, formData, body)
  let scheme = call_575099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575099.url(scheme.get, call_575099.host, call_575099.base,
                         call_575099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575099, url, valid)

proc call*(call_575100: Call_BatchAccountUpdate_575091; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## batchAccountUpdate
  ## Updates the properties of an existing Batch account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   parameters: JObject (required)
  ##             : Additional parameters for account update.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575101 = newJObject()
  var query_575102 = newJObject()
  var body_575103 = newJObject()
  add(path_575101, "resourceGroupName", newJString(resourceGroupName))
  add(query_575102, "api-version", newJString(apiVersion))
  add(path_575101, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575103 = parameters
  add(path_575101, "accountName", newJString(accountName))
  result = call_575100.call(path_575101, query_575102, nil, nil, body_575103)

var batchAccountUpdate* = Call_BatchAccountUpdate_575091(
    name: "batchAccountUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}",
    validator: validate_BatchAccountUpdate_575092, base: "",
    url: url_BatchAccountUpdate_575093, schemes: {Scheme.Https})
type
  Call_BatchAccountDelete_575080 = ref object of OpenApiRestCall_574466
proc url_BatchAccountDelete_575082(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountDelete_575081(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the specified Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575083 = path.getOrDefault("resourceGroupName")
  valid_575083 = validateParameter(valid_575083, JString, required = true,
                                 default = nil)
  if valid_575083 != nil:
    section.add "resourceGroupName", valid_575083
  var valid_575084 = path.getOrDefault("subscriptionId")
  valid_575084 = validateParameter(valid_575084, JString, required = true,
                                 default = nil)
  if valid_575084 != nil:
    section.add "subscriptionId", valid_575084
  var valid_575085 = path.getOrDefault("accountName")
  valid_575085 = validateParameter(valid_575085, JString, required = true,
                                 default = nil)
  if valid_575085 != nil:
    section.add "accountName", valid_575085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575086 = query.getOrDefault("api-version")
  valid_575086 = validateParameter(valid_575086, JString, required = true,
                                 default = nil)
  if valid_575086 != nil:
    section.add "api-version", valid_575086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575087: Call_BatchAccountDelete_575080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Batch account.
  ## 
  let valid = call_575087.validator(path, query, header, formData, body)
  let scheme = call_575087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575087.url(scheme.get, call_575087.host, call_575087.base,
                         call_575087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575087, url, valid)

proc call*(call_575088: Call_BatchAccountDelete_575080; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## batchAccountDelete
  ## Deletes the specified Batch account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575089 = newJObject()
  var query_575090 = newJObject()
  add(path_575089, "resourceGroupName", newJString(resourceGroupName))
  add(query_575090, "api-version", newJString(apiVersion))
  add(path_575089, "subscriptionId", newJString(subscriptionId))
  add(path_575089, "accountName", newJString(accountName))
  result = call_575088.call(path_575089, query_575090, nil, nil, nil)

var batchAccountDelete* = Call_BatchAccountDelete_575080(
    name: "batchAccountDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}",
    validator: validate_BatchAccountDelete_575081, base: "",
    url: url_BatchAccountDelete_575082, schemes: {Scheme.Https})
type
  Call_ApplicationList_575104 = ref object of OpenApiRestCall_574466
proc url_ApplicationList_575106(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationList_575105(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists all of the applications in the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575107 = path.getOrDefault("resourceGroupName")
  valid_575107 = validateParameter(valid_575107, JString, required = true,
                                 default = nil)
  if valid_575107 != nil:
    section.add "resourceGroupName", valid_575107
  var valid_575108 = path.getOrDefault("subscriptionId")
  valid_575108 = validateParameter(valid_575108, JString, required = true,
                                 default = nil)
  if valid_575108 != nil:
    section.add "subscriptionId", valid_575108
  var valid_575109 = path.getOrDefault("accountName")
  valid_575109 = validateParameter(valid_575109, JString, required = true,
                                 default = nil)
  if valid_575109 != nil:
    section.add "accountName", valid_575109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575110 = query.getOrDefault("api-version")
  valid_575110 = validateParameter(valid_575110, JString, required = true,
                                 default = nil)
  if valid_575110 != nil:
    section.add "api-version", valid_575110
  var valid_575111 = query.getOrDefault("maxresults")
  valid_575111 = validateParameter(valid_575111, JInt, required = false, default = nil)
  if valid_575111 != nil:
    section.add "maxresults", valid_575111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575112: Call_ApplicationList_575104; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the applications in the specified account.
  ## 
  let valid = call_575112.validator(path, query, header, formData, body)
  let scheme = call_575112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575112.url(scheme.get, call_575112.host, call_575112.base,
                         call_575112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575112, url, valid)

proc call*(call_575113: Call_ApplicationList_575104; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string;
          maxresults: int = 0): Recallable =
  ## applicationList
  ## Lists all of the applications in the specified account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   maxresults: int
  ##             : The maximum number of items to return in the response.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575114 = newJObject()
  var query_575115 = newJObject()
  add(path_575114, "resourceGroupName", newJString(resourceGroupName))
  add(query_575115, "api-version", newJString(apiVersion))
  add(path_575114, "subscriptionId", newJString(subscriptionId))
  add(query_575115, "maxresults", newJInt(maxresults))
  add(path_575114, "accountName", newJString(accountName))
  result = call_575113.call(path_575114, query_575115, nil, nil, nil)

var applicationList* = Call_ApplicationList_575104(name: "applicationList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications",
    validator: validate_ApplicationList_575105, base: "", url: url_ApplicationList_575106,
    schemes: {Scheme.Https})
type
  Call_ApplicationCreate_575128 = ref object of OpenApiRestCall_574466
proc url_ApplicationCreate_575130(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationCreate_575129(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Adds an application to the specified Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575131 = path.getOrDefault("resourceGroupName")
  valid_575131 = validateParameter(valid_575131, JString, required = true,
                                 default = nil)
  if valid_575131 != nil:
    section.add "resourceGroupName", valid_575131
  var valid_575132 = path.getOrDefault("applicationName")
  valid_575132 = validateParameter(valid_575132, JString, required = true,
                                 default = nil)
  if valid_575132 != nil:
    section.add "applicationName", valid_575132
  var valid_575133 = path.getOrDefault("subscriptionId")
  valid_575133 = validateParameter(valid_575133, JString, required = true,
                                 default = nil)
  if valid_575133 != nil:
    section.add "subscriptionId", valid_575133
  var valid_575134 = path.getOrDefault("accountName")
  valid_575134 = validateParameter(valid_575134, JString, required = true,
                                 default = nil)
  if valid_575134 != nil:
    section.add "accountName", valid_575134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575135 = query.getOrDefault("api-version")
  valid_575135 = validateParameter(valid_575135, JString, required = true,
                                 default = nil)
  if valid_575135 != nil:
    section.add "api-version", valid_575135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575137: Call_ApplicationCreate_575128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an application to the specified Batch account.
  ## 
  let valid = call_575137.validator(path, query, header, formData, body)
  let scheme = call_575137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575137.url(scheme.get, call_575137.host, call_575137.base,
                         call_575137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575137, url, valid)

proc call*(call_575138: Call_ApplicationCreate_575128; resourceGroupName: string;
          applicationName: string; apiVersion: string; subscriptionId: string;
          accountName: string; parameters: JsonNode = nil): Recallable =
  ## applicationCreate
  ## Adds an application to the specified Batch account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   parameters: JObject
  ##             : The parameters for the request.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575139 = newJObject()
  var query_575140 = newJObject()
  var body_575141 = newJObject()
  add(path_575139, "resourceGroupName", newJString(resourceGroupName))
  add(path_575139, "applicationName", newJString(applicationName))
  add(query_575140, "api-version", newJString(apiVersion))
  add(path_575139, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575141 = parameters
  add(path_575139, "accountName", newJString(accountName))
  result = call_575138.call(path_575139, query_575140, nil, nil, body_575141)

var applicationCreate* = Call_ApplicationCreate_575128(name: "applicationCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}",
    validator: validate_ApplicationCreate_575129, base: "",
    url: url_ApplicationCreate_575130, schemes: {Scheme.Https})
type
  Call_ApplicationGet_575116 = ref object of OpenApiRestCall_574466
proc url_ApplicationGet_575118(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGet_575117(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about the specified application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575119 = path.getOrDefault("resourceGroupName")
  valid_575119 = validateParameter(valid_575119, JString, required = true,
                                 default = nil)
  if valid_575119 != nil:
    section.add "resourceGroupName", valid_575119
  var valid_575120 = path.getOrDefault("applicationName")
  valid_575120 = validateParameter(valid_575120, JString, required = true,
                                 default = nil)
  if valid_575120 != nil:
    section.add "applicationName", valid_575120
  var valid_575121 = path.getOrDefault("subscriptionId")
  valid_575121 = validateParameter(valid_575121, JString, required = true,
                                 default = nil)
  if valid_575121 != nil:
    section.add "subscriptionId", valid_575121
  var valid_575122 = path.getOrDefault("accountName")
  valid_575122 = validateParameter(valid_575122, JString, required = true,
                                 default = nil)
  if valid_575122 != nil:
    section.add "accountName", valid_575122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575123 = query.getOrDefault("api-version")
  valid_575123 = validateParameter(valid_575123, JString, required = true,
                                 default = nil)
  if valid_575123 != nil:
    section.add "api-version", valid_575123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575124: Call_ApplicationGet_575116; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified application.
  ## 
  let valid = call_575124.validator(path, query, header, formData, body)
  let scheme = call_575124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575124.url(scheme.get, call_575124.host, call_575124.base,
                         call_575124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575124, url, valid)

proc call*(call_575125: Call_ApplicationGet_575116; resourceGroupName: string;
          applicationName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## applicationGet
  ## Gets information about the specified application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575126 = newJObject()
  var query_575127 = newJObject()
  add(path_575126, "resourceGroupName", newJString(resourceGroupName))
  add(path_575126, "applicationName", newJString(applicationName))
  add(query_575127, "api-version", newJString(apiVersion))
  add(path_575126, "subscriptionId", newJString(subscriptionId))
  add(path_575126, "accountName", newJString(accountName))
  result = call_575125.call(path_575126, query_575127, nil, nil, nil)

var applicationGet* = Call_ApplicationGet_575116(name: "applicationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}",
    validator: validate_ApplicationGet_575117, base: "", url: url_ApplicationGet_575118,
    schemes: {Scheme.Https})
type
  Call_ApplicationUpdate_575154 = ref object of OpenApiRestCall_574466
proc url_ApplicationUpdate_575156(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationUpdate_575155(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates settings for the specified application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575157 = path.getOrDefault("resourceGroupName")
  valid_575157 = validateParameter(valid_575157, JString, required = true,
                                 default = nil)
  if valid_575157 != nil:
    section.add "resourceGroupName", valid_575157
  var valid_575158 = path.getOrDefault("applicationName")
  valid_575158 = validateParameter(valid_575158, JString, required = true,
                                 default = nil)
  if valid_575158 != nil:
    section.add "applicationName", valid_575158
  var valid_575159 = path.getOrDefault("subscriptionId")
  valid_575159 = validateParameter(valid_575159, JString, required = true,
                                 default = nil)
  if valid_575159 != nil:
    section.add "subscriptionId", valid_575159
  var valid_575160 = path.getOrDefault("accountName")
  valid_575160 = validateParameter(valid_575160, JString, required = true,
                                 default = nil)
  if valid_575160 != nil:
    section.add "accountName", valid_575160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575161 = query.getOrDefault("api-version")
  valid_575161 = validateParameter(valid_575161, JString, required = true,
                                 default = nil)
  if valid_575161 != nil:
    section.add "api-version", valid_575161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575163: Call_ApplicationUpdate_575154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates settings for the specified application.
  ## 
  let valid = call_575163.validator(path, query, header, formData, body)
  let scheme = call_575163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575163.url(scheme.get, call_575163.host, call_575163.base,
                         call_575163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575163, url, valid)

proc call*(call_575164: Call_ApplicationUpdate_575154; resourceGroupName: string;
          applicationName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## applicationUpdate
  ## Updates settings for the specified application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   parameters: JObject (required)
  ##             : The parameters for the request.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575165 = newJObject()
  var query_575166 = newJObject()
  var body_575167 = newJObject()
  add(path_575165, "resourceGroupName", newJString(resourceGroupName))
  add(path_575165, "applicationName", newJString(applicationName))
  add(query_575166, "api-version", newJString(apiVersion))
  add(path_575165, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575167 = parameters
  add(path_575165, "accountName", newJString(accountName))
  result = call_575164.call(path_575165, query_575166, nil, nil, body_575167)

var applicationUpdate* = Call_ApplicationUpdate_575154(name: "applicationUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}",
    validator: validate_ApplicationUpdate_575155, base: "",
    url: url_ApplicationUpdate_575156, schemes: {Scheme.Https})
type
  Call_ApplicationDelete_575142 = ref object of OpenApiRestCall_574466
proc url_ApplicationDelete_575144(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationDelete_575143(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575145 = path.getOrDefault("resourceGroupName")
  valid_575145 = validateParameter(valid_575145, JString, required = true,
                                 default = nil)
  if valid_575145 != nil:
    section.add "resourceGroupName", valid_575145
  var valid_575146 = path.getOrDefault("applicationName")
  valid_575146 = validateParameter(valid_575146, JString, required = true,
                                 default = nil)
  if valid_575146 != nil:
    section.add "applicationName", valid_575146
  var valid_575147 = path.getOrDefault("subscriptionId")
  valid_575147 = validateParameter(valid_575147, JString, required = true,
                                 default = nil)
  if valid_575147 != nil:
    section.add "subscriptionId", valid_575147
  var valid_575148 = path.getOrDefault("accountName")
  valid_575148 = validateParameter(valid_575148, JString, required = true,
                                 default = nil)
  if valid_575148 != nil:
    section.add "accountName", valid_575148
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575149 = query.getOrDefault("api-version")
  valid_575149 = validateParameter(valid_575149, JString, required = true,
                                 default = nil)
  if valid_575149 != nil:
    section.add "api-version", valid_575149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575150: Call_ApplicationDelete_575142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application.
  ## 
  let valid = call_575150.validator(path, query, header, formData, body)
  let scheme = call_575150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575150.url(scheme.get, call_575150.host, call_575150.base,
                         call_575150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575150, url, valid)

proc call*(call_575151: Call_ApplicationDelete_575142; resourceGroupName: string;
          applicationName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## applicationDelete
  ## Deletes an application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575152 = newJObject()
  var query_575153 = newJObject()
  add(path_575152, "resourceGroupName", newJString(resourceGroupName))
  add(path_575152, "applicationName", newJString(applicationName))
  add(query_575153, "api-version", newJString(apiVersion))
  add(path_575152, "subscriptionId", newJString(subscriptionId))
  add(path_575152, "accountName", newJString(accountName))
  result = call_575151.call(path_575152, query_575153, nil, nil, nil)

var applicationDelete* = Call_ApplicationDelete_575142(name: "applicationDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}",
    validator: validate_ApplicationDelete_575143, base: "",
    url: url_ApplicationDelete_575144, schemes: {Scheme.Https})
type
  Call_ApplicationPackageList_575168 = ref object of OpenApiRestCall_574466
proc url_ApplicationPackageList_575170(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationPackageList_575169(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the application packages in the specified application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575171 = path.getOrDefault("resourceGroupName")
  valid_575171 = validateParameter(valid_575171, JString, required = true,
                                 default = nil)
  if valid_575171 != nil:
    section.add "resourceGroupName", valid_575171
  var valid_575172 = path.getOrDefault("applicationName")
  valid_575172 = validateParameter(valid_575172, JString, required = true,
                                 default = nil)
  if valid_575172 != nil:
    section.add "applicationName", valid_575172
  var valid_575173 = path.getOrDefault("subscriptionId")
  valid_575173 = validateParameter(valid_575173, JString, required = true,
                                 default = nil)
  if valid_575173 != nil:
    section.add "subscriptionId", valid_575173
  var valid_575174 = path.getOrDefault("accountName")
  valid_575174 = validateParameter(valid_575174, JString, required = true,
                                 default = nil)
  if valid_575174 != nil:
    section.add "accountName", valid_575174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575175 = query.getOrDefault("api-version")
  valid_575175 = validateParameter(valid_575175, JString, required = true,
                                 default = nil)
  if valid_575175 != nil:
    section.add "api-version", valid_575175
  var valid_575176 = query.getOrDefault("maxresults")
  valid_575176 = validateParameter(valid_575176, JInt, required = false, default = nil)
  if valid_575176 != nil:
    section.add "maxresults", valid_575176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575177: Call_ApplicationPackageList_575168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the application packages in the specified application.
  ## 
  let valid = call_575177.validator(path, query, header, formData, body)
  let scheme = call_575177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575177.url(scheme.get, call_575177.host, call_575177.base,
                         call_575177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575177, url, valid)

proc call*(call_575178: Call_ApplicationPackageList_575168;
          resourceGroupName: string; applicationName: string; apiVersion: string;
          subscriptionId: string; accountName: string; maxresults: int = 0): Recallable =
  ## applicationPackageList
  ## Lists all of the application packages in the specified application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   maxresults: int
  ##             : The maximum number of items to return in the response.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575179 = newJObject()
  var query_575180 = newJObject()
  add(path_575179, "resourceGroupName", newJString(resourceGroupName))
  add(path_575179, "applicationName", newJString(applicationName))
  add(query_575180, "api-version", newJString(apiVersion))
  add(path_575179, "subscriptionId", newJString(subscriptionId))
  add(query_575180, "maxresults", newJInt(maxresults))
  add(path_575179, "accountName", newJString(accountName))
  result = call_575178.call(path_575179, query_575180, nil, nil, nil)

var applicationPackageList* = Call_ApplicationPackageList_575168(
    name: "applicationPackageList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}/versions",
    validator: validate_ApplicationPackageList_575169, base: "",
    url: url_ApplicationPackageList_575170, schemes: {Scheme.Https})
type
  Call_ApplicationPackageCreate_575194 = ref object of OpenApiRestCall_574466
proc url_ApplicationPackageCreate_575196(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "versionName" in path, "`versionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationPackageCreate_575195(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an application package record.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionName: JString (required)
  ##              : The version of the application.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionName` field"
  var valid_575197 = path.getOrDefault("versionName")
  valid_575197 = validateParameter(valid_575197, JString, required = true,
                                 default = nil)
  if valid_575197 != nil:
    section.add "versionName", valid_575197
  var valid_575198 = path.getOrDefault("resourceGroupName")
  valid_575198 = validateParameter(valid_575198, JString, required = true,
                                 default = nil)
  if valid_575198 != nil:
    section.add "resourceGroupName", valid_575198
  var valid_575199 = path.getOrDefault("applicationName")
  valid_575199 = validateParameter(valid_575199, JString, required = true,
                                 default = nil)
  if valid_575199 != nil:
    section.add "applicationName", valid_575199
  var valid_575200 = path.getOrDefault("subscriptionId")
  valid_575200 = validateParameter(valid_575200, JString, required = true,
                                 default = nil)
  if valid_575200 != nil:
    section.add "subscriptionId", valid_575200
  var valid_575201 = path.getOrDefault("accountName")
  valid_575201 = validateParameter(valid_575201, JString, required = true,
                                 default = nil)
  if valid_575201 != nil:
    section.add "accountName", valid_575201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575202 = query.getOrDefault("api-version")
  valid_575202 = validateParameter(valid_575202, JString, required = true,
                                 default = nil)
  if valid_575202 != nil:
    section.add "api-version", valid_575202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575204: Call_ApplicationPackageCreate_575194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an application package record.
  ## 
  let valid = call_575204.validator(path, query, header, formData, body)
  let scheme = call_575204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575204.url(scheme.get, call_575204.host, call_575204.base,
                         call_575204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575204, url, valid)

proc call*(call_575205: Call_ApplicationPackageCreate_575194; versionName: string;
          resourceGroupName: string; applicationName: string; apiVersion: string;
          subscriptionId: string; accountName: string; parameters: JsonNode = nil): Recallable =
  ## applicationPackageCreate
  ## Creates an application package record.
  ##   versionName: string (required)
  ##              : The version of the application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   parameters: JObject
  ##             : The parameters for the request.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575206 = newJObject()
  var query_575207 = newJObject()
  var body_575208 = newJObject()
  add(path_575206, "versionName", newJString(versionName))
  add(path_575206, "resourceGroupName", newJString(resourceGroupName))
  add(path_575206, "applicationName", newJString(applicationName))
  add(query_575207, "api-version", newJString(apiVersion))
  add(path_575206, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575208 = parameters
  add(path_575206, "accountName", newJString(accountName))
  result = call_575205.call(path_575206, query_575207, nil, nil, body_575208)

var applicationPackageCreate* = Call_ApplicationPackageCreate_575194(
    name: "applicationPackageCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}/versions/{versionName}",
    validator: validate_ApplicationPackageCreate_575195, base: "",
    url: url_ApplicationPackageCreate_575196, schemes: {Scheme.Https})
type
  Call_ApplicationPackageGet_575181 = ref object of OpenApiRestCall_574466
proc url_ApplicationPackageGet_575183(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "versionName" in path, "`versionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationPackageGet_575182(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified application package.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionName: JString (required)
  ##              : The version of the application.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionName` field"
  var valid_575184 = path.getOrDefault("versionName")
  valid_575184 = validateParameter(valid_575184, JString, required = true,
                                 default = nil)
  if valid_575184 != nil:
    section.add "versionName", valid_575184
  var valid_575185 = path.getOrDefault("resourceGroupName")
  valid_575185 = validateParameter(valid_575185, JString, required = true,
                                 default = nil)
  if valid_575185 != nil:
    section.add "resourceGroupName", valid_575185
  var valid_575186 = path.getOrDefault("applicationName")
  valid_575186 = validateParameter(valid_575186, JString, required = true,
                                 default = nil)
  if valid_575186 != nil:
    section.add "applicationName", valid_575186
  var valid_575187 = path.getOrDefault("subscriptionId")
  valid_575187 = validateParameter(valid_575187, JString, required = true,
                                 default = nil)
  if valid_575187 != nil:
    section.add "subscriptionId", valid_575187
  var valid_575188 = path.getOrDefault("accountName")
  valid_575188 = validateParameter(valid_575188, JString, required = true,
                                 default = nil)
  if valid_575188 != nil:
    section.add "accountName", valid_575188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575189 = query.getOrDefault("api-version")
  valid_575189 = validateParameter(valid_575189, JString, required = true,
                                 default = nil)
  if valid_575189 != nil:
    section.add "api-version", valid_575189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575190: Call_ApplicationPackageGet_575181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified application package.
  ## 
  let valid = call_575190.validator(path, query, header, formData, body)
  let scheme = call_575190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575190.url(scheme.get, call_575190.host, call_575190.base,
                         call_575190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575190, url, valid)

proc call*(call_575191: Call_ApplicationPackageGet_575181; versionName: string;
          resourceGroupName: string; applicationName: string; apiVersion: string;
          subscriptionId: string; accountName: string): Recallable =
  ## applicationPackageGet
  ## Gets information about the specified application package.
  ##   versionName: string (required)
  ##              : The version of the application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575192 = newJObject()
  var query_575193 = newJObject()
  add(path_575192, "versionName", newJString(versionName))
  add(path_575192, "resourceGroupName", newJString(resourceGroupName))
  add(path_575192, "applicationName", newJString(applicationName))
  add(query_575193, "api-version", newJString(apiVersion))
  add(path_575192, "subscriptionId", newJString(subscriptionId))
  add(path_575192, "accountName", newJString(accountName))
  result = call_575191.call(path_575192, query_575193, nil, nil, nil)

var applicationPackageGet* = Call_ApplicationPackageGet_575181(
    name: "applicationPackageGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}/versions/{versionName}",
    validator: validate_ApplicationPackageGet_575182, base: "",
    url: url_ApplicationPackageGet_575183, schemes: {Scheme.Https})
type
  Call_ApplicationPackageDelete_575209 = ref object of OpenApiRestCall_574466
proc url_ApplicationPackageDelete_575211(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "versionName" in path, "`versionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationPackageDelete_575210(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an application package record and its associated binary file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionName: JString (required)
  ##              : The version of the application.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionName` field"
  var valid_575212 = path.getOrDefault("versionName")
  valid_575212 = validateParameter(valid_575212, JString, required = true,
                                 default = nil)
  if valid_575212 != nil:
    section.add "versionName", valid_575212
  var valid_575213 = path.getOrDefault("resourceGroupName")
  valid_575213 = validateParameter(valid_575213, JString, required = true,
                                 default = nil)
  if valid_575213 != nil:
    section.add "resourceGroupName", valid_575213
  var valid_575214 = path.getOrDefault("applicationName")
  valid_575214 = validateParameter(valid_575214, JString, required = true,
                                 default = nil)
  if valid_575214 != nil:
    section.add "applicationName", valid_575214
  var valid_575215 = path.getOrDefault("subscriptionId")
  valid_575215 = validateParameter(valid_575215, JString, required = true,
                                 default = nil)
  if valid_575215 != nil:
    section.add "subscriptionId", valid_575215
  var valid_575216 = path.getOrDefault("accountName")
  valid_575216 = validateParameter(valid_575216, JString, required = true,
                                 default = nil)
  if valid_575216 != nil:
    section.add "accountName", valid_575216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575217 = query.getOrDefault("api-version")
  valid_575217 = validateParameter(valid_575217, JString, required = true,
                                 default = nil)
  if valid_575217 != nil:
    section.add "api-version", valid_575217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575218: Call_ApplicationPackageDelete_575209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application package record and its associated binary file.
  ## 
  let valid = call_575218.validator(path, query, header, formData, body)
  let scheme = call_575218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575218.url(scheme.get, call_575218.host, call_575218.base,
                         call_575218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575218, url, valid)

proc call*(call_575219: Call_ApplicationPackageDelete_575209; versionName: string;
          resourceGroupName: string; applicationName: string; apiVersion: string;
          subscriptionId: string; accountName: string): Recallable =
  ## applicationPackageDelete
  ## Deletes an application package record and its associated binary file.
  ##   versionName: string (required)
  ##              : The version of the application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575220 = newJObject()
  var query_575221 = newJObject()
  add(path_575220, "versionName", newJString(versionName))
  add(path_575220, "resourceGroupName", newJString(resourceGroupName))
  add(path_575220, "applicationName", newJString(applicationName))
  add(query_575221, "api-version", newJString(apiVersion))
  add(path_575220, "subscriptionId", newJString(subscriptionId))
  add(path_575220, "accountName", newJString(accountName))
  result = call_575219.call(path_575220, query_575221, nil, nil, nil)

var applicationPackageDelete* = Call_ApplicationPackageDelete_575209(
    name: "applicationPackageDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}/versions/{versionName}",
    validator: validate_ApplicationPackageDelete_575210, base: "",
    url: url_ApplicationPackageDelete_575211, schemes: {Scheme.Https})
type
  Call_ApplicationPackageActivate_575222 = ref object of OpenApiRestCall_574466
proc url_ApplicationPackageActivate_575224(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "versionName" in path, "`versionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionName"),
               (kind: ConstantSegment, value: "/activate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationPackageActivate_575223(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Activates the specified application package.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionName: JString (required)
  ##              : The version of the application.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionName` field"
  var valid_575225 = path.getOrDefault("versionName")
  valid_575225 = validateParameter(valid_575225, JString, required = true,
                                 default = nil)
  if valid_575225 != nil:
    section.add "versionName", valid_575225
  var valid_575226 = path.getOrDefault("resourceGroupName")
  valid_575226 = validateParameter(valid_575226, JString, required = true,
                                 default = nil)
  if valid_575226 != nil:
    section.add "resourceGroupName", valid_575226
  var valid_575227 = path.getOrDefault("applicationName")
  valid_575227 = validateParameter(valid_575227, JString, required = true,
                                 default = nil)
  if valid_575227 != nil:
    section.add "applicationName", valid_575227
  var valid_575228 = path.getOrDefault("subscriptionId")
  valid_575228 = validateParameter(valid_575228, JString, required = true,
                                 default = nil)
  if valid_575228 != nil:
    section.add "subscriptionId", valid_575228
  var valid_575229 = path.getOrDefault("accountName")
  valid_575229 = validateParameter(valid_575229, JString, required = true,
                                 default = nil)
  if valid_575229 != nil:
    section.add "accountName", valid_575229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575230 = query.getOrDefault("api-version")
  valid_575230 = validateParameter(valid_575230, JString, required = true,
                                 default = nil)
  if valid_575230 != nil:
    section.add "api-version", valid_575230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575232: Call_ApplicationPackageActivate_575222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activates the specified application package.
  ## 
  let valid = call_575232.validator(path, query, header, formData, body)
  let scheme = call_575232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575232.url(scheme.get, call_575232.host, call_575232.base,
                         call_575232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575232, url, valid)

proc call*(call_575233: Call_ApplicationPackageActivate_575222;
          versionName: string; resourceGroupName: string; applicationName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## applicationPackageActivate
  ## Activates the specified application package.
  ##   versionName: string (required)
  ##              : The version of the application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   parameters: JObject (required)
  ##             : The parameters for the request.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575234 = newJObject()
  var query_575235 = newJObject()
  var body_575236 = newJObject()
  add(path_575234, "versionName", newJString(versionName))
  add(path_575234, "resourceGroupName", newJString(resourceGroupName))
  add(path_575234, "applicationName", newJString(applicationName))
  add(query_575235, "api-version", newJString(apiVersion))
  add(path_575234, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575236 = parameters
  add(path_575234, "accountName", newJString(accountName))
  result = call_575233.call(path_575234, query_575235, nil, nil, body_575236)

var applicationPackageActivate* = Call_ApplicationPackageActivate_575222(
    name: "applicationPackageActivate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}/versions/{versionName}/activate",
    validator: validate_ApplicationPackageActivate_575223, base: "",
    url: url_ApplicationPackageActivate_575224, schemes: {Scheme.Https})
type
  Call_CertificateListByBatchAccount_575237 = ref object of OpenApiRestCall_574466
proc url_CertificateListByBatchAccount_575239(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/certificates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificateListByBatchAccount_575238(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the certificates in the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575241 = path.getOrDefault("resourceGroupName")
  valid_575241 = validateParameter(valid_575241, JString, required = true,
                                 default = nil)
  if valid_575241 != nil:
    section.add "resourceGroupName", valid_575241
  var valid_575242 = path.getOrDefault("subscriptionId")
  valid_575242 = validateParameter(valid_575242, JString, required = true,
                                 default = nil)
  if valid_575242 != nil:
    section.add "subscriptionId", valid_575242
  var valid_575243 = path.getOrDefault("accountName")
  valid_575243 = validateParameter(valid_575243, JString, required = true,
                                 default = nil)
  if valid_575243 != nil:
    section.add "accountName", valid_575243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response.
  ##   $select: JString
  ##          : Comma separated list of properties that should be returned. e.g. "properties/provisioningState". Only top level properties under properties/ are valid for selection.
  ##   $filter: JString
  ##          : OData filter expression. Valid properties for filtering are "properties/provisioningState", "properties/provisioningStateTransitionTime", "name".
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575244 = query.getOrDefault("api-version")
  valid_575244 = validateParameter(valid_575244, JString, required = true,
                                 default = nil)
  if valid_575244 != nil:
    section.add "api-version", valid_575244
  var valid_575245 = query.getOrDefault("maxresults")
  valid_575245 = validateParameter(valid_575245, JInt, required = false, default = nil)
  if valid_575245 != nil:
    section.add "maxresults", valid_575245
  var valid_575246 = query.getOrDefault("$select")
  valid_575246 = validateParameter(valid_575246, JString, required = false,
                                 default = nil)
  if valid_575246 != nil:
    section.add "$select", valid_575246
  var valid_575247 = query.getOrDefault("$filter")
  valid_575247 = validateParameter(valid_575247, JString, required = false,
                                 default = nil)
  if valid_575247 != nil:
    section.add "$filter", valid_575247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575248: Call_CertificateListByBatchAccount_575237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the certificates in the specified account.
  ## 
  let valid = call_575248.validator(path, query, header, formData, body)
  let scheme = call_575248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575248.url(scheme.get, call_575248.host, call_575248.base,
                         call_575248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575248, url, valid)

proc call*(call_575249: Call_CertificateListByBatchAccount_575237;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; maxresults: int = 0; Select: string = "";
          Filter: string = ""): Recallable =
  ## certificateListByBatchAccount
  ## Lists all of the certificates in the specified account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   maxresults: int
  ##             : The maximum number of items to return in the response.
  ##   Select: string
  ##         : Comma separated list of properties that should be returned. e.g. "properties/provisioningState". Only top level properties under properties/ are valid for selection.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  ##   Filter: string
  ##         : OData filter expression. Valid properties for filtering are "properties/provisioningState", "properties/provisioningStateTransitionTime", "name".
  var path_575250 = newJObject()
  var query_575251 = newJObject()
  add(path_575250, "resourceGroupName", newJString(resourceGroupName))
  add(query_575251, "api-version", newJString(apiVersion))
  add(path_575250, "subscriptionId", newJString(subscriptionId))
  add(query_575251, "maxresults", newJInt(maxresults))
  add(query_575251, "$select", newJString(Select))
  add(path_575250, "accountName", newJString(accountName))
  add(query_575251, "$filter", newJString(Filter))
  result = call_575249.call(path_575250, query_575251, nil, nil, nil)

var certificateListByBatchAccount* = Call_CertificateListByBatchAccount_575237(
    name: "certificateListByBatchAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates",
    validator: validate_CertificateListByBatchAccount_575238, base: "",
    url: url_CertificateListByBatchAccount_575239, schemes: {Scheme.Https})
type
  Call_CertificateCreate_575264 = ref object of OpenApiRestCall_574466
proc url_CertificateCreate_575266(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificateCreate_575265(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a new certificate inside the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   certificateName: JString (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575267 = path.getOrDefault("resourceGroupName")
  valid_575267 = validateParameter(valid_575267, JString, required = true,
                                 default = nil)
  if valid_575267 != nil:
    section.add "resourceGroupName", valid_575267
  var valid_575268 = path.getOrDefault("subscriptionId")
  valid_575268 = validateParameter(valid_575268, JString, required = true,
                                 default = nil)
  if valid_575268 != nil:
    section.add "subscriptionId", valid_575268
  var valid_575269 = path.getOrDefault("certificateName")
  valid_575269 = validateParameter(valid_575269, JString, required = true,
                                 default = nil)
  if valid_575269 != nil:
    section.add "certificateName", valid_575269
  var valid_575270 = path.getOrDefault("accountName")
  valid_575270 = validateParameter(valid_575270, JString, required = true,
                                 default = nil)
  if valid_575270 != nil:
    section.add "accountName", valid_575270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575271 = query.getOrDefault("api-version")
  valid_575271 = validateParameter(valid_575271, JString, required = true,
                                 default = nil)
  if valid_575271 != nil:
    section.add "api-version", valid_575271
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the certificate to update. A value of "*" can be used to apply the operation only if the certificate already exists. If omitted, this operation will always be applied.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new certificate to be created, but to prevent updating an existing certificate. Other values will be ignored.
  section = newJObject()
  var valid_575272 = header.getOrDefault("If-Match")
  valid_575272 = validateParameter(valid_575272, JString, required = false,
                                 default = nil)
  if valid_575272 != nil:
    section.add "If-Match", valid_575272
  var valid_575273 = header.getOrDefault("If-None-Match")
  valid_575273 = validateParameter(valid_575273, JString, required = false,
                                 default = nil)
  if valid_575273 != nil:
    section.add "If-None-Match", valid_575273
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters for certificate creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575275: Call_CertificateCreate_575264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new certificate inside the specified account.
  ## 
  let valid = call_575275.validator(path, query, header, formData, body)
  let scheme = call_575275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575275.url(scheme.get, call_575275.host, call_575275.base,
                         call_575275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575275, url, valid)

proc call*(call_575276: Call_CertificateCreate_575264; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; certificateName: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## certificateCreate
  ## Creates a new certificate inside the specified account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   certificateName: string (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  ##   parameters: JObject (required)
  ##             : Additional parameters for certificate creation.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575277 = newJObject()
  var query_575278 = newJObject()
  var body_575279 = newJObject()
  add(path_575277, "resourceGroupName", newJString(resourceGroupName))
  add(query_575278, "api-version", newJString(apiVersion))
  add(path_575277, "subscriptionId", newJString(subscriptionId))
  add(path_575277, "certificateName", newJString(certificateName))
  if parameters != nil:
    body_575279 = parameters
  add(path_575277, "accountName", newJString(accountName))
  result = call_575276.call(path_575277, query_575278, nil, nil, body_575279)

var certificateCreate* = Call_CertificateCreate_575264(name: "certificateCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates/{certificateName}",
    validator: validate_CertificateCreate_575265, base: "",
    url: url_CertificateCreate_575266, schemes: {Scheme.Https})
type
  Call_CertificateGet_575252 = ref object of OpenApiRestCall_574466
proc url_CertificateGet_575254(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificateGet_575253(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about the specified certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   certificateName: JString (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575255 = path.getOrDefault("resourceGroupName")
  valid_575255 = validateParameter(valid_575255, JString, required = true,
                                 default = nil)
  if valid_575255 != nil:
    section.add "resourceGroupName", valid_575255
  var valid_575256 = path.getOrDefault("subscriptionId")
  valid_575256 = validateParameter(valid_575256, JString, required = true,
                                 default = nil)
  if valid_575256 != nil:
    section.add "subscriptionId", valid_575256
  var valid_575257 = path.getOrDefault("certificateName")
  valid_575257 = validateParameter(valid_575257, JString, required = true,
                                 default = nil)
  if valid_575257 != nil:
    section.add "certificateName", valid_575257
  var valid_575258 = path.getOrDefault("accountName")
  valid_575258 = validateParameter(valid_575258, JString, required = true,
                                 default = nil)
  if valid_575258 != nil:
    section.add "accountName", valid_575258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575259 = query.getOrDefault("api-version")
  valid_575259 = validateParameter(valid_575259, JString, required = true,
                                 default = nil)
  if valid_575259 != nil:
    section.add "api-version", valid_575259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575260: Call_CertificateGet_575252; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified certificate.
  ## 
  let valid = call_575260.validator(path, query, header, formData, body)
  let scheme = call_575260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575260.url(scheme.get, call_575260.host, call_575260.base,
                         call_575260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575260, url, valid)

proc call*(call_575261: Call_CertificateGet_575252; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; certificateName: string;
          accountName: string): Recallable =
  ## certificateGet
  ## Gets information about the specified certificate.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   certificateName: string (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575262 = newJObject()
  var query_575263 = newJObject()
  add(path_575262, "resourceGroupName", newJString(resourceGroupName))
  add(query_575263, "api-version", newJString(apiVersion))
  add(path_575262, "subscriptionId", newJString(subscriptionId))
  add(path_575262, "certificateName", newJString(certificateName))
  add(path_575262, "accountName", newJString(accountName))
  result = call_575261.call(path_575262, query_575263, nil, nil, nil)

var certificateGet* = Call_CertificateGet_575252(name: "certificateGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates/{certificateName}",
    validator: validate_CertificateGet_575253, base: "", url: url_CertificateGet_575254,
    schemes: {Scheme.Https})
type
  Call_CertificateUpdate_575292 = ref object of OpenApiRestCall_574466
proc url_CertificateUpdate_575294(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificateUpdate_575293(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the properties of an existing certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   certificateName: JString (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575295 = path.getOrDefault("resourceGroupName")
  valid_575295 = validateParameter(valid_575295, JString, required = true,
                                 default = nil)
  if valid_575295 != nil:
    section.add "resourceGroupName", valid_575295
  var valid_575296 = path.getOrDefault("subscriptionId")
  valid_575296 = validateParameter(valid_575296, JString, required = true,
                                 default = nil)
  if valid_575296 != nil:
    section.add "subscriptionId", valid_575296
  var valid_575297 = path.getOrDefault("certificateName")
  valid_575297 = validateParameter(valid_575297, JString, required = true,
                                 default = nil)
  if valid_575297 != nil:
    section.add "certificateName", valid_575297
  var valid_575298 = path.getOrDefault("accountName")
  valid_575298 = validateParameter(valid_575298, JString, required = true,
                                 default = nil)
  if valid_575298 != nil:
    section.add "accountName", valid_575298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575299 = query.getOrDefault("api-version")
  valid_575299 = validateParameter(valid_575299, JString, required = true,
                                 default = nil)
  if valid_575299 != nil:
    section.add "api-version", valid_575299
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the certificate to update. This value can be omitted or set to "*" to apply the operation unconditionally.
  section = newJObject()
  var valid_575300 = header.getOrDefault("If-Match")
  valid_575300 = validateParameter(valid_575300, JString, required = false,
                                 default = nil)
  if valid_575300 != nil:
    section.add "If-Match", valid_575300
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Certificate entity to update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575302: Call_CertificateUpdate_575292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing certificate.
  ## 
  let valid = call_575302.validator(path, query, header, formData, body)
  let scheme = call_575302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575302.url(scheme.get, call_575302.host, call_575302.base,
                         call_575302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575302, url, valid)

proc call*(call_575303: Call_CertificateUpdate_575292; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; certificateName: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## certificateUpdate
  ## Updates the properties of an existing certificate.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   certificateName: string (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  ##   parameters: JObject (required)
  ##             : Certificate entity to update.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575304 = newJObject()
  var query_575305 = newJObject()
  var body_575306 = newJObject()
  add(path_575304, "resourceGroupName", newJString(resourceGroupName))
  add(query_575305, "api-version", newJString(apiVersion))
  add(path_575304, "subscriptionId", newJString(subscriptionId))
  add(path_575304, "certificateName", newJString(certificateName))
  if parameters != nil:
    body_575306 = parameters
  add(path_575304, "accountName", newJString(accountName))
  result = call_575303.call(path_575304, query_575305, nil, nil, body_575306)

var certificateUpdate* = Call_CertificateUpdate_575292(name: "certificateUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates/{certificateName}",
    validator: validate_CertificateUpdate_575293, base: "",
    url: url_CertificateUpdate_575294, schemes: {Scheme.Https})
type
  Call_CertificateDelete_575280 = ref object of OpenApiRestCall_574466
proc url_CertificateDelete_575282(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificateDelete_575281(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes the specified certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   certificateName: JString (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575283 = path.getOrDefault("resourceGroupName")
  valid_575283 = validateParameter(valid_575283, JString, required = true,
                                 default = nil)
  if valid_575283 != nil:
    section.add "resourceGroupName", valid_575283
  var valid_575284 = path.getOrDefault("subscriptionId")
  valid_575284 = validateParameter(valid_575284, JString, required = true,
                                 default = nil)
  if valid_575284 != nil:
    section.add "subscriptionId", valid_575284
  var valid_575285 = path.getOrDefault("certificateName")
  valid_575285 = validateParameter(valid_575285, JString, required = true,
                                 default = nil)
  if valid_575285 != nil:
    section.add "certificateName", valid_575285
  var valid_575286 = path.getOrDefault("accountName")
  valid_575286 = validateParameter(valid_575286, JString, required = true,
                                 default = nil)
  if valid_575286 != nil:
    section.add "accountName", valid_575286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575287 = query.getOrDefault("api-version")
  valid_575287 = validateParameter(valid_575287, JString, required = true,
                                 default = nil)
  if valid_575287 != nil:
    section.add "api-version", valid_575287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575288: Call_CertificateDelete_575280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified certificate.
  ## 
  let valid = call_575288.validator(path, query, header, formData, body)
  let scheme = call_575288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575288.url(scheme.get, call_575288.host, call_575288.base,
                         call_575288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575288, url, valid)

proc call*(call_575289: Call_CertificateDelete_575280; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; certificateName: string;
          accountName: string): Recallable =
  ## certificateDelete
  ## Deletes the specified certificate.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   certificateName: string (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575290 = newJObject()
  var query_575291 = newJObject()
  add(path_575290, "resourceGroupName", newJString(resourceGroupName))
  add(query_575291, "api-version", newJString(apiVersion))
  add(path_575290, "subscriptionId", newJString(subscriptionId))
  add(path_575290, "certificateName", newJString(certificateName))
  add(path_575290, "accountName", newJString(accountName))
  result = call_575289.call(path_575290, query_575291, nil, nil, nil)

var certificateDelete* = Call_CertificateDelete_575280(name: "certificateDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates/{certificateName}",
    validator: validate_CertificateDelete_575281, base: "",
    url: url_CertificateDelete_575282, schemes: {Scheme.Https})
type
  Call_CertificateCancelDeletion_575307 = ref object of OpenApiRestCall_574466
proc url_CertificateCancelDeletion_575309(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName"),
               (kind: ConstantSegment, value: "/cancelDelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificateCancelDeletion_575308(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## If you try to delete a certificate that is being used by a pool or compute node, the status of the certificate changes to deleteFailed. If you decide that you want to continue using the certificate, you can use this operation to set the status of the certificate back to active. If you intend to delete the certificate, you do not need to run this operation after the deletion failed. You must make sure that the certificate is not being used by any resources, and then you can try again to delete the certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   certificateName: JString (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575310 = path.getOrDefault("resourceGroupName")
  valid_575310 = validateParameter(valid_575310, JString, required = true,
                                 default = nil)
  if valid_575310 != nil:
    section.add "resourceGroupName", valid_575310
  var valid_575311 = path.getOrDefault("subscriptionId")
  valid_575311 = validateParameter(valid_575311, JString, required = true,
                                 default = nil)
  if valid_575311 != nil:
    section.add "subscriptionId", valid_575311
  var valid_575312 = path.getOrDefault("certificateName")
  valid_575312 = validateParameter(valid_575312, JString, required = true,
                                 default = nil)
  if valid_575312 != nil:
    section.add "certificateName", valid_575312
  var valid_575313 = path.getOrDefault("accountName")
  valid_575313 = validateParameter(valid_575313, JString, required = true,
                                 default = nil)
  if valid_575313 != nil:
    section.add "accountName", valid_575313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575314 = query.getOrDefault("api-version")
  valid_575314 = validateParameter(valid_575314, JString, required = true,
                                 default = nil)
  if valid_575314 != nil:
    section.add "api-version", valid_575314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575315: Call_CertificateCancelDeletion_575307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If you try to delete a certificate that is being used by a pool or compute node, the status of the certificate changes to deleteFailed. If you decide that you want to continue using the certificate, you can use this operation to set the status of the certificate back to active. If you intend to delete the certificate, you do not need to run this operation after the deletion failed. You must make sure that the certificate is not being used by any resources, and then you can try again to delete the certificate.
  ## 
  let valid = call_575315.validator(path, query, header, formData, body)
  let scheme = call_575315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575315.url(scheme.get, call_575315.host, call_575315.base,
                         call_575315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575315, url, valid)

proc call*(call_575316: Call_CertificateCancelDeletion_575307;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          certificateName: string; accountName: string): Recallable =
  ## certificateCancelDeletion
  ## If you try to delete a certificate that is being used by a pool or compute node, the status of the certificate changes to deleteFailed. If you decide that you want to continue using the certificate, you can use this operation to set the status of the certificate back to active. If you intend to delete the certificate, you do not need to run this operation after the deletion failed. You must make sure that the certificate is not being used by any resources, and then you can try again to delete the certificate.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   certificateName: string (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575317 = newJObject()
  var query_575318 = newJObject()
  add(path_575317, "resourceGroupName", newJString(resourceGroupName))
  add(query_575318, "api-version", newJString(apiVersion))
  add(path_575317, "subscriptionId", newJString(subscriptionId))
  add(path_575317, "certificateName", newJString(certificateName))
  add(path_575317, "accountName", newJString(accountName))
  result = call_575316.call(path_575317, query_575318, nil, nil, nil)

var certificateCancelDeletion* = Call_CertificateCancelDeletion_575307(
    name: "certificateCancelDeletion", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates/{certificateName}/cancelDelete",
    validator: validate_CertificateCancelDeletion_575308, base: "",
    url: url_CertificateCancelDeletion_575309, schemes: {Scheme.Https})
type
  Call_BatchAccountGetKeys_575319 = ref object of OpenApiRestCall_574466
proc url_BatchAccountGetKeys_575321(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountGetKeys_575320(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## This operation applies only to Batch accounts created with a poolAllocationMode of 'BatchService'. If the Batch account was created with a poolAllocationMode of 'UserSubscription', clients cannot use access to keys to authenticate, and must use Azure Active Directory instead. In this case, getting the keys will fail.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575322 = path.getOrDefault("resourceGroupName")
  valid_575322 = validateParameter(valid_575322, JString, required = true,
                                 default = nil)
  if valid_575322 != nil:
    section.add "resourceGroupName", valid_575322
  var valid_575323 = path.getOrDefault("subscriptionId")
  valid_575323 = validateParameter(valid_575323, JString, required = true,
                                 default = nil)
  if valid_575323 != nil:
    section.add "subscriptionId", valid_575323
  var valid_575324 = path.getOrDefault("accountName")
  valid_575324 = validateParameter(valid_575324, JString, required = true,
                                 default = nil)
  if valid_575324 != nil:
    section.add "accountName", valid_575324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575325 = query.getOrDefault("api-version")
  valid_575325 = validateParameter(valid_575325, JString, required = true,
                                 default = nil)
  if valid_575325 != nil:
    section.add "api-version", valid_575325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575326: Call_BatchAccountGetKeys_575319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation applies only to Batch accounts created with a poolAllocationMode of 'BatchService'. If the Batch account was created with a poolAllocationMode of 'UserSubscription', clients cannot use access to keys to authenticate, and must use Azure Active Directory instead. In this case, getting the keys will fail.
  ## 
  let valid = call_575326.validator(path, query, header, formData, body)
  let scheme = call_575326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575326.url(scheme.get, call_575326.host, call_575326.base,
                         call_575326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575326, url, valid)

proc call*(call_575327: Call_BatchAccountGetKeys_575319; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## batchAccountGetKeys
  ## This operation applies only to Batch accounts created with a poolAllocationMode of 'BatchService'. If the Batch account was created with a poolAllocationMode of 'UserSubscription', clients cannot use access to keys to authenticate, and must use Azure Active Directory instead. In this case, getting the keys will fail.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575328 = newJObject()
  var query_575329 = newJObject()
  add(path_575328, "resourceGroupName", newJString(resourceGroupName))
  add(query_575329, "api-version", newJString(apiVersion))
  add(path_575328, "subscriptionId", newJString(subscriptionId))
  add(path_575328, "accountName", newJString(accountName))
  result = call_575327.call(path_575328, query_575329, nil, nil, nil)

var batchAccountGetKeys* = Call_BatchAccountGetKeys_575319(
    name: "batchAccountGetKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/listKeys",
    validator: validate_BatchAccountGetKeys_575320, base: "",
    url: url_BatchAccountGetKeys_575321, schemes: {Scheme.Https})
type
  Call_PoolListByBatchAccount_575330 = ref object of OpenApiRestCall_574466
proc url_PoolListByBatchAccount_575332(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/pools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolListByBatchAccount_575331(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the pools in the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575333 = path.getOrDefault("resourceGroupName")
  valid_575333 = validateParameter(valid_575333, JString, required = true,
                                 default = nil)
  if valid_575333 != nil:
    section.add "resourceGroupName", valid_575333
  var valid_575334 = path.getOrDefault("subscriptionId")
  valid_575334 = validateParameter(valid_575334, JString, required = true,
                                 default = nil)
  if valid_575334 != nil:
    section.add "subscriptionId", valid_575334
  var valid_575335 = path.getOrDefault("accountName")
  valid_575335 = validateParameter(valid_575335, JString, required = true,
                                 default = nil)
  if valid_575335 != nil:
    section.add "accountName", valid_575335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response.
  ##   $select: JString
  ##          : Comma separated list of properties that should be returned. e.g. "properties/provisioningState". Only top level properties under properties/ are valid for selection.
  ##   $filter: JString
  ##          : OData filter expression. Valid properties for filtering are:
  ## 
  ##  name
  ##  properties/allocationState
  ##  properties/allocationStateTransitionTime
  ##  properties/creationTime
  ##  properties/provisioningState
  ##  properties/provisioningStateTransitionTime
  ##  properties/lastModified
  ##  properties/vmSize
  ##  properties/interNodeCommunication
  ##  properties/scaleSettings/autoScale
  ##  properties/scaleSettings/fixedScale
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575336 = query.getOrDefault("api-version")
  valid_575336 = validateParameter(valid_575336, JString, required = true,
                                 default = nil)
  if valid_575336 != nil:
    section.add "api-version", valid_575336
  var valid_575337 = query.getOrDefault("maxresults")
  valid_575337 = validateParameter(valid_575337, JInt, required = false, default = nil)
  if valid_575337 != nil:
    section.add "maxresults", valid_575337
  var valid_575338 = query.getOrDefault("$select")
  valid_575338 = validateParameter(valid_575338, JString, required = false,
                                 default = nil)
  if valid_575338 != nil:
    section.add "$select", valid_575338
  var valid_575339 = query.getOrDefault("$filter")
  valid_575339 = validateParameter(valid_575339, JString, required = false,
                                 default = nil)
  if valid_575339 != nil:
    section.add "$filter", valid_575339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575340: Call_PoolListByBatchAccount_575330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the pools in the specified account.
  ## 
  let valid = call_575340.validator(path, query, header, formData, body)
  let scheme = call_575340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575340.url(scheme.get, call_575340.host, call_575340.base,
                         call_575340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575340, url, valid)

proc call*(call_575341: Call_PoolListByBatchAccount_575330;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; maxresults: int = 0; Select: string = "";
          Filter: string = ""): Recallable =
  ## poolListByBatchAccount
  ## Lists all of the pools in the specified account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   maxresults: int
  ##             : The maximum number of items to return in the response.
  ##   Select: string
  ##         : Comma separated list of properties that should be returned. e.g. "properties/provisioningState". Only top level properties under properties/ are valid for selection.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  ##   Filter: string
  ##         : OData filter expression. Valid properties for filtering are:
  ## 
  ##  name
  ##  properties/allocationState
  ##  properties/allocationStateTransitionTime
  ##  properties/creationTime
  ##  properties/provisioningState
  ##  properties/provisioningStateTransitionTime
  ##  properties/lastModified
  ##  properties/vmSize
  ##  properties/interNodeCommunication
  ##  properties/scaleSettings/autoScale
  ##  properties/scaleSettings/fixedScale
  var path_575342 = newJObject()
  var query_575343 = newJObject()
  add(path_575342, "resourceGroupName", newJString(resourceGroupName))
  add(query_575343, "api-version", newJString(apiVersion))
  add(path_575342, "subscriptionId", newJString(subscriptionId))
  add(query_575343, "maxresults", newJInt(maxresults))
  add(query_575343, "$select", newJString(Select))
  add(path_575342, "accountName", newJString(accountName))
  add(query_575343, "$filter", newJString(Filter))
  result = call_575341.call(path_575342, query_575343, nil, nil, nil)

var poolListByBatchAccount* = Call_PoolListByBatchAccount_575330(
    name: "poolListByBatchAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools",
    validator: validate_PoolListByBatchAccount_575331, base: "",
    url: url_PoolListByBatchAccount_575332, schemes: {Scheme.Https})
type
  Call_PoolCreate_575356 = ref object of OpenApiRestCall_574466
proc url_PoolCreate_575358(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolCreate_575357(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new pool inside the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_575359 = path.getOrDefault("poolName")
  valid_575359 = validateParameter(valid_575359, JString, required = true,
                                 default = nil)
  if valid_575359 != nil:
    section.add "poolName", valid_575359
  var valid_575360 = path.getOrDefault("resourceGroupName")
  valid_575360 = validateParameter(valid_575360, JString, required = true,
                                 default = nil)
  if valid_575360 != nil:
    section.add "resourceGroupName", valid_575360
  var valid_575361 = path.getOrDefault("subscriptionId")
  valid_575361 = validateParameter(valid_575361, JString, required = true,
                                 default = nil)
  if valid_575361 != nil:
    section.add "subscriptionId", valid_575361
  var valid_575362 = path.getOrDefault("accountName")
  valid_575362 = validateParameter(valid_575362, JString, required = true,
                                 default = nil)
  if valid_575362 != nil:
    section.add "accountName", valid_575362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575363 = query.getOrDefault("api-version")
  valid_575363 = validateParameter(valid_575363, JString, required = true,
                                 default = nil)
  if valid_575363 != nil:
    section.add "api-version", valid_575363
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the pool to update. A value of "*" can be used to apply the operation only if the pool already exists. If omitted, this operation will always be applied.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new pool to be created, but to prevent updating an existing pool. Other values will be ignored.
  section = newJObject()
  var valid_575364 = header.getOrDefault("If-Match")
  valid_575364 = validateParameter(valid_575364, JString, required = false,
                                 default = nil)
  if valid_575364 != nil:
    section.add "If-Match", valid_575364
  var valid_575365 = header.getOrDefault("If-None-Match")
  valid_575365 = validateParameter(valid_575365, JString, required = false,
                                 default = nil)
  if valid_575365 != nil:
    section.add "If-None-Match", valid_575365
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters for pool creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575367: Call_PoolCreate_575356; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new pool inside the specified account.
  ## 
  let valid = call_575367.validator(path, query, header, formData, body)
  let scheme = call_575367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575367.url(scheme.get, call_575367.host, call_575367.base,
                         call_575367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575367, url, valid)

proc call*(call_575368: Call_PoolCreate_575356; poolName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## poolCreate
  ## Creates a new pool inside the specified account.
  ##   poolName: string (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   parameters: JObject (required)
  ##             : Additional parameters for pool creation.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575369 = newJObject()
  var query_575370 = newJObject()
  var body_575371 = newJObject()
  add(path_575369, "poolName", newJString(poolName))
  add(path_575369, "resourceGroupName", newJString(resourceGroupName))
  add(query_575370, "api-version", newJString(apiVersion))
  add(path_575369, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575371 = parameters
  add(path_575369, "accountName", newJString(accountName))
  result = call_575368.call(path_575369, query_575370, nil, nil, body_575371)

var poolCreate* = Call_PoolCreate_575356(name: "poolCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}",
                                      validator: validate_PoolCreate_575357,
                                      base: "", url: url_PoolCreate_575358,
                                      schemes: {Scheme.Https})
type
  Call_PoolGet_575344 = ref object of OpenApiRestCall_574466
proc url_PoolGet_575346(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolGet_575345(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_575347 = path.getOrDefault("poolName")
  valid_575347 = validateParameter(valid_575347, JString, required = true,
                                 default = nil)
  if valid_575347 != nil:
    section.add "poolName", valid_575347
  var valid_575348 = path.getOrDefault("resourceGroupName")
  valid_575348 = validateParameter(valid_575348, JString, required = true,
                                 default = nil)
  if valid_575348 != nil:
    section.add "resourceGroupName", valid_575348
  var valid_575349 = path.getOrDefault("subscriptionId")
  valid_575349 = validateParameter(valid_575349, JString, required = true,
                                 default = nil)
  if valid_575349 != nil:
    section.add "subscriptionId", valid_575349
  var valid_575350 = path.getOrDefault("accountName")
  valid_575350 = validateParameter(valid_575350, JString, required = true,
                                 default = nil)
  if valid_575350 != nil:
    section.add "accountName", valid_575350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575351 = query.getOrDefault("api-version")
  valid_575351 = validateParameter(valid_575351, JString, required = true,
                                 default = nil)
  if valid_575351 != nil:
    section.add "api-version", valid_575351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575352: Call_PoolGet_575344; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified pool.
  ## 
  let valid = call_575352.validator(path, query, header, formData, body)
  let scheme = call_575352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575352.url(scheme.get, call_575352.host, call_575352.base,
                         call_575352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575352, url, valid)

proc call*(call_575353: Call_PoolGet_575344; poolName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## poolGet
  ## Gets information about the specified pool.
  ##   poolName: string (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575354 = newJObject()
  var query_575355 = newJObject()
  add(path_575354, "poolName", newJString(poolName))
  add(path_575354, "resourceGroupName", newJString(resourceGroupName))
  add(query_575355, "api-version", newJString(apiVersion))
  add(path_575354, "subscriptionId", newJString(subscriptionId))
  add(path_575354, "accountName", newJString(accountName))
  result = call_575353.call(path_575354, query_575355, nil, nil, nil)

var poolGet* = Call_PoolGet_575344(name: "poolGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}",
                                validator: validate_PoolGet_575345, base: "",
                                url: url_PoolGet_575346, schemes: {Scheme.Https})
type
  Call_PoolUpdate_575384 = ref object of OpenApiRestCall_574466
proc url_PoolUpdate_575386(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolUpdate_575385(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the properties of an existing pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_575387 = path.getOrDefault("poolName")
  valid_575387 = validateParameter(valid_575387, JString, required = true,
                                 default = nil)
  if valid_575387 != nil:
    section.add "poolName", valid_575387
  var valid_575388 = path.getOrDefault("resourceGroupName")
  valid_575388 = validateParameter(valid_575388, JString, required = true,
                                 default = nil)
  if valid_575388 != nil:
    section.add "resourceGroupName", valid_575388
  var valid_575389 = path.getOrDefault("subscriptionId")
  valid_575389 = validateParameter(valid_575389, JString, required = true,
                                 default = nil)
  if valid_575389 != nil:
    section.add "subscriptionId", valid_575389
  var valid_575390 = path.getOrDefault("accountName")
  valid_575390 = validateParameter(valid_575390, JString, required = true,
                                 default = nil)
  if valid_575390 != nil:
    section.add "accountName", valid_575390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575391 = query.getOrDefault("api-version")
  valid_575391 = validateParameter(valid_575391, JString, required = true,
                                 default = nil)
  if valid_575391 != nil:
    section.add "api-version", valid_575391
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the pool to update. This value can be omitted or set to "*" to apply the operation unconditionally.
  section = newJObject()
  var valid_575392 = header.getOrDefault("If-Match")
  valid_575392 = validateParameter(valid_575392, JString, required = false,
                                 default = nil)
  if valid_575392 != nil:
    section.add "If-Match", valid_575392
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Pool properties that should be updated. Properties that are supplied will be updated, any property not supplied will be unchanged.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575394: Call_PoolUpdate_575384; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing pool.
  ## 
  let valid = call_575394.validator(path, query, header, formData, body)
  let scheme = call_575394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575394.url(scheme.get, call_575394.host, call_575394.base,
                         call_575394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575394, url, valid)

proc call*(call_575395: Call_PoolUpdate_575384; poolName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## poolUpdate
  ## Updates the properties of an existing pool.
  ##   poolName: string (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   parameters: JObject (required)
  ##             : Pool properties that should be updated. Properties that are supplied will be updated, any property not supplied will be unchanged.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575396 = newJObject()
  var query_575397 = newJObject()
  var body_575398 = newJObject()
  add(path_575396, "poolName", newJString(poolName))
  add(path_575396, "resourceGroupName", newJString(resourceGroupName))
  add(query_575397, "api-version", newJString(apiVersion))
  add(path_575396, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575398 = parameters
  add(path_575396, "accountName", newJString(accountName))
  result = call_575395.call(path_575396, query_575397, nil, nil, body_575398)

var poolUpdate* = Call_PoolUpdate_575384(name: "poolUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}",
                                      validator: validate_PoolUpdate_575385,
                                      base: "", url: url_PoolUpdate_575386,
                                      schemes: {Scheme.Https})
type
  Call_PoolDelete_575372 = ref object of OpenApiRestCall_574466
proc url_PoolDelete_575374(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolDelete_575373(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_575375 = path.getOrDefault("poolName")
  valid_575375 = validateParameter(valid_575375, JString, required = true,
                                 default = nil)
  if valid_575375 != nil:
    section.add "poolName", valid_575375
  var valid_575376 = path.getOrDefault("resourceGroupName")
  valid_575376 = validateParameter(valid_575376, JString, required = true,
                                 default = nil)
  if valid_575376 != nil:
    section.add "resourceGroupName", valid_575376
  var valid_575377 = path.getOrDefault("subscriptionId")
  valid_575377 = validateParameter(valid_575377, JString, required = true,
                                 default = nil)
  if valid_575377 != nil:
    section.add "subscriptionId", valid_575377
  var valid_575378 = path.getOrDefault("accountName")
  valid_575378 = validateParameter(valid_575378, JString, required = true,
                                 default = nil)
  if valid_575378 != nil:
    section.add "accountName", valid_575378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575379 = query.getOrDefault("api-version")
  valid_575379 = validateParameter(valid_575379, JString, required = true,
                                 default = nil)
  if valid_575379 != nil:
    section.add "api-version", valid_575379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575380: Call_PoolDelete_575372; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified pool.
  ## 
  let valid = call_575380.validator(path, query, header, formData, body)
  let scheme = call_575380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575380.url(scheme.get, call_575380.host, call_575380.base,
                         call_575380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575380, url, valid)

proc call*(call_575381: Call_PoolDelete_575372; poolName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## poolDelete
  ## Deletes the specified pool.
  ##   poolName: string (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575382 = newJObject()
  var query_575383 = newJObject()
  add(path_575382, "poolName", newJString(poolName))
  add(path_575382, "resourceGroupName", newJString(resourceGroupName))
  add(query_575383, "api-version", newJString(apiVersion))
  add(path_575382, "subscriptionId", newJString(subscriptionId))
  add(path_575382, "accountName", newJString(accountName))
  result = call_575381.call(path_575382, query_575383, nil, nil, nil)

var poolDelete* = Call_PoolDelete_575372(name: "poolDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}",
                                      validator: validate_PoolDelete_575373,
                                      base: "", url: url_PoolDelete_575374,
                                      schemes: {Scheme.Https})
type
  Call_PoolDisableAutoScale_575399 = ref object of OpenApiRestCall_574466
proc url_PoolDisableAutoScale_575401(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/disableAutoScale")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolDisableAutoScale_575400(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Disables automatic scaling for a pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_575402 = path.getOrDefault("poolName")
  valid_575402 = validateParameter(valid_575402, JString, required = true,
                                 default = nil)
  if valid_575402 != nil:
    section.add "poolName", valid_575402
  var valid_575403 = path.getOrDefault("resourceGroupName")
  valid_575403 = validateParameter(valid_575403, JString, required = true,
                                 default = nil)
  if valid_575403 != nil:
    section.add "resourceGroupName", valid_575403
  var valid_575404 = path.getOrDefault("subscriptionId")
  valid_575404 = validateParameter(valid_575404, JString, required = true,
                                 default = nil)
  if valid_575404 != nil:
    section.add "subscriptionId", valid_575404
  var valid_575405 = path.getOrDefault("accountName")
  valid_575405 = validateParameter(valid_575405, JString, required = true,
                                 default = nil)
  if valid_575405 != nil:
    section.add "accountName", valid_575405
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575406 = query.getOrDefault("api-version")
  valid_575406 = validateParameter(valid_575406, JString, required = true,
                                 default = nil)
  if valid_575406 != nil:
    section.add "api-version", valid_575406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575407: Call_PoolDisableAutoScale_575399; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disables automatic scaling for a pool.
  ## 
  let valid = call_575407.validator(path, query, header, formData, body)
  let scheme = call_575407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575407.url(scheme.get, call_575407.host, call_575407.base,
                         call_575407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575407, url, valid)

proc call*(call_575408: Call_PoolDisableAutoScale_575399; poolName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## poolDisableAutoScale
  ## Disables automatic scaling for a pool.
  ##   poolName: string (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575409 = newJObject()
  var query_575410 = newJObject()
  add(path_575409, "poolName", newJString(poolName))
  add(path_575409, "resourceGroupName", newJString(resourceGroupName))
  add(query_575410, "api-version", newJString(apiVersion))
  add(path_575409, "subscriptionId", newJString(subscriptionId))
  add(path_575409, "accountName", newJString(accountName))
  result = call_575408.call(path_575409, query_575410, nil, nil, nil)

var poolDisableAutoScale* = Call_PoolDisableAutoScale_575399(
    name: "poolDisableAutoScale", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}/disableAutoScale",
    validator: validate_PoolDisableAutoScale_575400, base: "",
    url: url_PoolDisableAutoScale_575401, schemes: {Scheme.Https})
type
  Call_PoolStopResize_575411 = ref object of OpenApiRestCall_574466
proc url_PoolStopResize_575413(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/stopResize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolStopResize_575412(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## This does not restore the pool to its previous state before the resize operation: it only stops any further changes being made, and the pool maintains its current state. After stopping, the pool stabilizes at the number of nodes it was at when the stop operation was done. During the stop operation, the pool allocation state changes first to stopping and then to steady. A resize operation need not be an explicit resize pool request; this API can also be used to halt the initial sizing of the pool when it is created.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_575414 = path.getOrDefault("poolName")
  valid_575414 = validateParameter(valid_575414, JString, required = true,
                                 default = nil)
  if valid_575414 != nil:
    section.add "poolName", valid_575414
  var valid_575415 = path.getOrDefault("resourceGroupName")
  valid_575415 = validateParameter(valid_575415, JString, required = true,
                                 default = nil)
  if valid_575415 != nil:
    section.add "resourceGroupName", valid_575415
  var valid_575416 = path.getOrDefault("subscriptionId")
  valid_575416 = validateParameter(valid_575416, JString, required = true,
                                 default = nil)
  if valid_575416 != nil:
    section.add "subscriptionId", valid_575416
  var valid_575417 = path.getOrDefault("accountName")
  valid_575417 = validateParameter(valid_575417, JString, required = true,
                                 default = nil)
  if valid_575417 != nil:
    section.add "accountName", valid_575417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575418 = query.getOrDefault("api-version")
  valid_575418 = validateParameter(valid_575418, JString, required = true,
                                 default = nil)
  if valid_575418 != nil:
    section.add "api-version", valid_575418
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575419: Call_PoolStopResize_575411; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This does not restore the pool to its previous state before the resize operation: it only stops any further changes being made, and the pool maintains its current state. After stopping, the pool stabilizes at the number of nodes it was at when the stop operation was done. During the stop operation, the pool allocation state changes first to stopping and then to steady. A resize operation need not be an explicit resize pool request; this API can also be used to halt the initial sizing of the pool when it is created.
  ## 
  let valid = call_575419.validator(path, query, header, formData, body)
  let scheme = call_575419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575419.url(scheme.get, call_575419.host, call_575419.base,
                         call_575419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575419, url, valid)

proc call*(call_575420: Call_PoolStopResize_575411; poolName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## poolStopResize
  ## This does not restore the pool to its previous state before the resize operation: it only stops any further changes being made, and the pool maintains its current state. After stopping, the pool stabilizes at the number of nodes it was at when the stop operation was done. During the stop operation, the pool allocation state changes first to stopping and then to steady. A resize operation need not be an explicit resize pool request; this API can also be used to halt the initial sizing of the pool when it is created.
  ##   poolName: string (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575421 = newJObject()
  var query_575422 = newJObject()
  add(path_575421, "poolName", newJString(poolName))
  add(path_575421, "resourceGroupName", newJString(resourceGroupName))
  add(query_575422, "api-version", newJString(apiVersion))
  add(path_575421, "subscriptionId", newJString(subscriptionId))
  add(path_575421, "accountName", newJString(accountName))
  result = call_575420.call(path_575421, query_575422, nil, nil, nil)

var poolStopResize* = Call_PoolStopResize_575411(name: "poolStopResize",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}/stopResize",
    validator: validate_PoolStopResize_575412, base: "", url: url_PoolStopResize_575413,
    schemes: {Scheme.Https})
type
  Call_BatchAccountRegenerateKey_575423 = ref object of OpenApiRestCall_574466
proc url_BatchAccountRegenerateKey_575425(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountRegenerateKey_575424(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the specified account key for the Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575426 = path.getOrDefault("resourceGroupName")
  valid_575426 = validateParameter(valid_575426, JString, required = true,
                                 default = nil)
  if valid_575426 != nil:
    section.add "resourceGroupName", valid_575426
  var valid_575427 = path.getOrDefault("subscriptionId")
  valid_575427 = validateParameter(valid_575427, JString, required = true,
                                 default = nil)
  if valid_575427 != nil:
    section.add "subscriptionId", valid_575427
  var valid_575428 = path.getOrDefault("accountName")
  valid_575428 = validateParameter(valid_575428, JString, required = true,
                                 default = nil)
  if valid_575428 != nil:
    section.add "accountName", valid_575428
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575429 = query.getOrDefault("api-version")
  valid_575429 = validateParameter(valid_575429, JString, required = true,
                                 default = nil)
  if valid_575429 != nil:
    section.add "api-version", valid_575429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The type of key to regenerate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575431: Call_BatchAccountRegenerateKey_575423; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the specified account key for the Batch account.
  ## 
  let valid = call_575431.validator(path, query, header, formData, body)
  let scheme = call_575431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575431.url(scheme.get, call_575431.host, call_575431.base,
                         call_575431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575431, url, valid)

proc call*(call_575432: Call_BatchAccountRegenerateKey_575423;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## batchAccountRegenerateKey
  ## Regenerates the specified account key for the Batch account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   parameters: JObject (required)
  ##             : The type of key to regenerate.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575433 = newJObject()
  var query_575434 = newJObject()
  var body_575435 = newJObject()
  add(path_575433, "resourceGroupName", newJString(resourceGroupName))
  add(query_575434, "api-version", newJString(apiVersion))
  add(path_575433, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575435 = parameters
  add(path_575433, "accountName", newJString(accountName))
  result = call_575432.call(path_575433, query_575434, nil, nil, body_575435)

var batchAccountRegenerateKey* = Call_BatchAccountRegenerateKey_575423(
    name: "batchAccountRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/regenerateKeys",
    validator: validate_BatchAccountRegenerateKey_575424, base: "",
    url: url_BatchAccountRegenerateKey_575425, schemes: {Scheme.Https})
type
  Call_BatchAccountSynchronizeAutoStorageKeys_575436 = ref object of OpenApiRestCall_574466
proc url_BatchAccountSynchronizeAutoStorageKeys_575438(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/syncAutoStorageKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BatchAccountSynchronizeAutoStorageKeys_575437(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Synchronizes access keys for the auto-storage account configured for the specified Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575439 = path.getOrDefault("resourceGroupName")
  valid_575439 = validateParameter(valid_575439, JString, required = true,
                                 default = nil)
  if valid_575439 != nil:
    section.add "resourceGroupName", valid_575439
  var valid_575440 = path.getOrDefault("subscriptionId")
  valid_575440 = validateParameter(valid_575440, JString, required = true,
                                 default = nil)
  if valid_575440 != nil:
    section.add "subscriptionId", valid_575440
  var valid_575441 = path.getOrDefault("accountName")
  valid_575441 = validateParameter(valid_575441, JString, required = true,
                                 default = nil)
  if valid_575441 != nil:
    section.add "accountName", valid_575441
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575442 = query.getOrDefault("api-version")
  valid_575442 = validateParameter(valid_575442, JString, required = true,
                                 default = nil)
  if valid_575442 != nil:
    section.add "api-version", valid_575442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575443: Call_BatchAccountSynchronizeAutoStorageKeys_575436;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Synchronizes access keys for the auto-storage account configured for the specified Batch account.
  ## 
  let valid = call_575443.validator(path, query, header, formData, body)
  let scheme = call_575443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575443.url(scheme.get, call_575443.host, call_575443.base,
                         call_575443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575443, url, valid)

proc call*(call_575444: Call_BatchAccountSynchronizeAutoStorageKeys_575436;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## batchAccountSynchronizeAutoStorageKeys
  ## Synchronizes access keys for the auto-storage account configured for the specified Batch account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575445 = newJObject()
  var query_575446 = newJObject()
  add(path_575445, "resourceGroupName", newJString(resourceGroupName))
  add(query_575446, "api-version", newJString(apiVersion))
  add(path_575445, "subscriptionId", newJString(subscriptionId))
  add(path_575445, "accountName", newJString(accountName))
  result = call_575444.call(path_575445, query_575446, nil, nil, nil)

var batchAccountSynchronizeAutoStorageKeys* = Call_BatchAccountSynchronizeAutoStorageKeys_575436(
    name: "batchAccountSynchronizeAutoStorageKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/syncAutoStorageKeys",
    validator: validate_BatchAccountSynchronizeAutoStorageKeys_575437, base: "",
    url: url_BatchAccountSynchronizeAutoStorageKeys_575438,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
