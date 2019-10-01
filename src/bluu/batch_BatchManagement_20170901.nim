
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: BatchManagement
## version: 2017-09-01
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
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId")]
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
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   applicationId: JString (required)
  ##                : The ID of the application.
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
  var valid_575132 = path.getOrDefault("subscriptionId")
  valid_575132 = validateParameter(valid_575132, JString, required = true,
                                 default = nil)
  if valid_575132 != nil:
    section.add "subscriptionId", valid_575132
  var valid_575133 = path.getOrDefault("applicationId")
  valid_575133 = validateParameter(valid_575133, JString, required = true,
                                 default = nil)
  if valid_575133 != nil:
    section.add "applicationId", valid_575133
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
          apiVersion: string; subscriptionId: string; applicationId: string;
          accountName: string; parameters: JsonNode = nil): Recallable =
  ## applicationCreate
  ## Adds an application to the specified Batch account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   applicationId: string (required)
  ##                : The ID of the application.
  ##   parameters: JObject
  ##             : The parameters for the request.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575139 = newJObject()
  var query_575140 = newJObject()
  var body_575141 = newJObject()
  add(path_575139, "resourceGroupName", newJString(resourceGroupName))
  add(query_575140, "api-version", newJString(apiVersion))
  add(path_575139, "subscriptionId", newJString(subscriptionId))
  add(path_575139, "applicationId", newJString(applicationId))
  if parameters != nil:
    body_575141 = parameters
  add(path_575139, "accountName", newJString(accountName))
  result = call_575138.call(path_575139, query_575140, nil, nil, body_575141)

var applicationCreate* = Call_ApplicationCreate_575128(name: "applicationCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}",
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
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId")]
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
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   applicationId: JString (required)
  ##                : The ID of the application.
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
  var valid_575120 = path.getOrDefault("subscriptionId")
  valid_575120 = validateParameter(valid_575120, JString, required = true,
                                 default = nil)
  if valid_575120 != nil:
    section.add "subscriptionId", valid_575120
  var valid_575121 = path.getOrDefault("applicationId")
  valid_575121 = validateParameter(valid_575121, JString, required = true,
                                 default = nil)
  if valid_575121 != nil:
    section.add "applicationId", valid_575121
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
          apiVersion: string; subscriptionId: string; applicationId: string;
          accountName: string): Recallable =
  ## applicationGet
  ## Gets information about the specified application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   applicationId: string (required)
  ##                : The ID of the application.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575126 = newJObject()
  var query_575127 = newJObject()
  add(path_575126, "resourceGroupName", newJString(resourceGroupName))
  add(query_575127, "api-version", newJString(apiVersion))
  add(path_575126, "subscriptionId", newJString(subscriptionId))
  add(path_575126, "applicationId", newJString(applicationId))
  add(path_575126, "accountName", newJString(accountName))
  result = call_575125.call(path_575126, query_575127, nil, nil, nil)

var applicationGet* = Call_ApplicationGet_575116(name: "applicationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}",
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
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId")]
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
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   applicationId: JString (required)
  ##                : The ID of the application.
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
  var valid_575158 = path.getOrDefault("subscriptionId")
  valid_575158 = validateParameter(valid_575158, JString, required = true,
                                 default = nil)
  if valid_575158 != nil:
    section.add "subscriptionId", valid_575158
  var valid_575159 = path.getOrDefault("applicationId")
  valid_575159 = validateParameter(valid_575159, JString, required = true,
                                 default = nil)
  if valid_575159 != nil:
    section.add "applicationId", valid_575159
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
          apiVersion: string; subscriptionId: string; applicationId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## applicationUpdate
  ## Updates settings for the specified application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   applicationId: string (required)
  ##                : The ID of the application.
  ##   parameters: JObject (required)
  ##             : The parameters for the request.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575165 = newJObject()
  var query_575166 = newJObject()
  var body_575167 = newJObject()
  add(path_575165, "resourceGroupName", newJString(resourceGroupName))
  add(query_575166, "api-version", newJString(apiVersion))
  add(path_575165, "subscriptionId", newJString(subscriptionId))
  add(path_575165, "applicationId", newJString(applicationId))
  if parameters != nil:
    body_575167 = parameters
  add(path_575165, "accountName", newJString(accountName))
  result = call_575164.call(path_575165, query_575166, nil, nil, body_575167)

var applicationUpdate* = Call_ApplicationUpdate_575154(name: "applicationUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}",
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
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId")]
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
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   applicationId: JString (required)
  ##                : The ID of the application.
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
  var valid_575146 = path.getOrDefault("subscriptionId")
  valid_575146 = validateParameter(valid_575146, JString, required = true,
                                 default = nil)
  if valid_575146 != nil:
    section.add "subscriptionId", valid_575146
  var valid_575147 = path.getOrDefault("applicationId")
  valid_575147 = validateParameter(valid_575147, JString, required = true,
                                 default = nil)
  if valid_575147 != nil:
    section.add "applicationId", valid_575147
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
          apiVersion: string; subscriptionId: string; applicationId: string;
          accountName: string): Recallable =
  ## applicationDelete
  ## Deletes an application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   applicationId: string (required)
  ##                : The ID of the application.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575152 = newJObject()
  var query_575153 = newJObject()
  add(path_575152, "resourceGroupName", newJString(resourceGroupName))
  add(query_575153, "api-version", newJString(apiVersion))
  add(path_575152, "subscriptionId", newJString(subscriptionId))
  add(path_575152, "applicationId", newJString(applicationId))
  add(path_575152, "accountName", newJString(accountName))
  result = call_575151.call(path_575152, query_575153, nil, nil, nil)

var applicationDelete* = Call_ApplicationDelete_575142(name: "applicationDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}",
    validator: validate_ApplicationDelete_575143, base: "",
    url: url_ApplicationDelete_575144, schemes: {Scheme.Https})
type
  Call_ApplicationPackageCreate_575181 = ref object of OpenApiRestCall_574466
proc url_ApplicationPackageCreate_575183(protocol: Scheme; host: string;
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
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationPackageCreate_575182(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an application package record.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   version: JString (required)
  ##          : The version of the application.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   applicationId: JString (required)
  ##                : The ID of the application.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575184 = path.getOrDefault("resourceGroupName")
  valid_575184 = validateParameter(valid_575184, JString, required = true,
                                 default = nil)
  if valid_575184 != nil:
    section.add "resourceGroupName", valid_575184
  var valid_575185 = path.getOrDefault("version")
  valid_575185 = validateParameter(valid_575185, JString, required = true,
                                 default = nil)
  if valid_575185 != nil:
    section.add "version", valid_575185
  var valid_575186 = path.getOrDefault("subscriptionId")
  valid_575186 = validateParameter(valid_575186, JString, required = true,
                                 default = nil)
  if valid_575186 != nil:
    section.add "subscriptionId", valid_575186
  var valid_575187 = path.getOrDefault("applicationId")
  valid_575187 = validateParameter(valid_575187, JString, required = true,
                                 default = nil)
  if valid_575187 != nil:
    section.add "applicationId", valid_575187
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

proc call*(call_575190: Call_ApplicationPackageCreate_575181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an application package record.
  ## 
  let valid = call_575190.validator(path, query, header, formData, body)
  let scheme = call_575190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575190.url(scheme.get, call_575190.host, call_575190.base,
                         call_575190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575190, url, valid)

proc call*(call_575191: Call_ApplicationPackageCreate_575181;
          resourceGroupName: string; apiVersion: string; version: string;
          subscriptionId: string; applicationId: string; accountName: string): Recallable =
  ## applicationPackageCreate
  ## Creates an application package record.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   version: string (required)
  ##          : The version of the application.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   applicationId: string (required)
  ##                : The ID of the application.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575192 = newJObject()
  var query_575193 = newJObject()
  add(path_575192, "resourceGroupName", newJString(resourceGroupName))
  add(query_575193, "api-version", newJString(apiVersion))
  add(path_575192, "version", newJString(version))
  add(path_575192, "subscriptionId", newJString(subscriptionId))
  add(path_575192, "applicationId", newJString(applicationId))
  add(path_575192, "accountName", newJString(accountName))
  result = call_575191.call(path_575192, query_575193, nil, nil, nil)

var applicationPackageCreate* = Call_ApplicationPackageCreate_575181(
    name: "applicationPackageCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}/versions/{version}",
    validator: validate_ApplicationPackageCreate_575182, base: "",
    url: url_ApplicationPackageCreate_575183, schemes: {Scheme.Https})
type
  Call_ApplicationPackageGet_575168 = ref object of OpenApiRestCall_574466
proc url_ApplicationPackageGet_575170(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationPackageGet_575169(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified application package.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   version: JString (required)
  ##          : The version of the application.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   applicationId: JString (required)
  ##                : The ID of the application.
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
  var valid_575172 = path.getOrDefault("version")
  valid_575172 = validateParameter(valid_575172, JString, required = true,
                                 default = nil)
  if valid_575172 != nil:
    section.add "version", valid_575172
  var valid_575173 = path.getOrDefault("subscriptionId")
  valid_575173 = validateParameter(valid_575173, JString, required = true,
                                 default = nil)
  if valid_575173 != nil:
    section.add "subscriptionId", valid_575173
  var valid_575174 = path.getOrDefault("applicationId")
  valid_575174 = validateParameter(valid_575174, JString, required = true,
                                 default = nil)
  if valid_575174 != nil:
    section.add "applicationId", valid_575174
  var valid_575175 = path.getOrDefault("accountName")
  valid_575175 = validateParameter(valid_575175, JString, required = true,
                                 default = nil)
  if valid_575175 != nil:
    section.add "accountName", valid_575175
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575176 = query.getOrDefault("api-version")
  valid_575176 = validateParameter(valid_575176, JString, required = true,
                                 default = nil)
  if valid_575176 != nil:
    section.add "api-version", valid_575176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575177: Call_ApplicationPackageGet_575168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified application package.
  ## 
  let valid = call_575177.validator(path, query, header, formData, body)
  let scheme = call_575177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575177.url(scheme.get, call_575177.host, call_575177.base,
                         call_575177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575177, url, valid)

proc call*(call_575178: Call_ApplicationPackageGet_575168;
          resourceGroupName: string; apiVersion: string; version: string;
          subscriptionId: string; applicationId: string; accountName: string): Recallable =
  ## applicationPackageGet
  ## Gets information about the specified application package.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   version: string (required)
  ##          : The version of the application.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   applicationId: string (required)
  ##                : The ID of the application.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575179 = newJObject()
  var query_575180 = newJObject()
  add(path_575179, "resourceGroupName", newJString(resourceGroupName))
  add(query_575180, "api-version", newJString(apiVersion))
  add(path_575179, "version", newJString(version))
  add(path_575179, "subscriptionId", newJString(subscriptionId))
  add(path_575179, "applicationId", newJString(applicationId))
  add(path_575179, "accountName", newJString(accountName))
  result = call_575178.call(path_575179, query_575180, nil, nil, nil)

var applicationPackageGet* = Call_ApplicationPackageGet_575168(
    name: "applicationPackageGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}/versions/{version}",
    validator: validate_ApplicationPackageGet_575169, base: "",
    url: url_ApplicationPackageGet_575170, schemes: {Scheme.Https})
type
  Call_ApplicationPackageDelete_575194 = ref object of OpenApiRestCall_574466
proc url_ApplicationPackageDelete_575196(protocol: Scheme; host: string;
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
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationPackageDelete_575195(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an application package record and its associated binary file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   version: JString (required)
  ##          : The version of the application to delete.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   applicationId: JString (required)
  ##                : The ID of the application.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575197 = path.getOrDefault("resourceGroupName")
  valid_575197 = validateParameter(valid_575197, JString, required = true,
                                 default = nil)
  if valid_575197 != nil:
    section.add "resourceGroupName", valid_575197
  var valid_575198 = path.getOrDefault("version")
  valid_575198 = validateParameter(valid_575198, JString, required = true,
                                 default = nil)
  if valid_575198 != nil:
    section.add "version", valid_575198
  var valid_575199 = path.getOrDefault("subscriptionId")
  valid_575199 = validateParameter(valid_575199, JString, required = true,
                                 default = nil)
  if valid_575199 != nil:
    section.add "subscriptionId", valid_575199
  var valid_575200 = path.getOrDefault("applicationId")
  valid_575200 = validateParameter(valid_575200, JString, required = true,
                                 default = nil)
  if valid_575200 != nil:
    section.add "applicationId", valid_575200
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
  if body != nil:
    result.add "body", body

proc call*(call_575203: Call_ApplicationPackageDelete_575194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application package record and its associated binary file.
  ## 
  let valid = call_575203.validator(path, query, header, formData, body)
  let scheme = call_575203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575203.url(scheme.get, call_575203.host, call_575203.base,
                         call_575203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575203, url, valid)

proc call*(call_575204: Call_ApplicationPackageDelete_575194;
          resourceGroupName: string; apiVersion: string; version: string;
          subscriptionId: string; applicationId: string; accountName: string): Recallable =
  ## applicationPackageDelete
  ## Deletes an application package record and its associated binary file.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   version: string (required)
  ##          : The version of the application to delete.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   applicationId: string (required)
  ##                : The ID of the application.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575205 = newJObject()
  var query_575206 = newJObject()
  add(path_575205, "resourceGroupName", newJString(resourceGroupName))
  add(query_575206, "api-version", newJString(apiVersion))
  add(path_575205, "version", newJString(version))
  add(path_575205, "subscriptionId", newJString(subscriptionId))
  add(path_575205, "applicationId", newJString(applicationId))
  add(path_575205, "accountName", newJString(accountName))
  result = call_575204.call(path_575205, query_575206, nil, nil, nil)

var applicationPackageDelete* = Call_ApplicationPackageDelete_575194(
    name: "applicationPackageDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}/versions/{version}",
    validator: validate_ApplicationPackageDelete_575195, base: "",
    url: url_ApplicationPackageDelete_575196, schemes: {Scheme.Https})
type
  Call_ApplicationPackageActivate_575207 = ref object of OpenApiRestCall_574466
proc url_ApplicationPackageActivate_575209(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Batch/batchAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version"),
               (kind: ConstantSegment, value: "/activate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationPackageActivate_575208(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Activates the specified application package.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   version: JString (required)
  ##          : The version of the application to activate.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   applicationId: JString (required)
  ##                : The ID of the application.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575210 = path.getOrDefault("resourceGroupName")
  valid_575210 = validateParameter(valid_575210, JString, required = true,
                                 default = nil)
  if valid_575210 != nil:
    section.add "resourceGroupName", valid_575210
  var valid_575211 = path.getOrDefault("version")
  valid_575211 = validateParameter(valid_575211, JString, required = true,
                                 default = nil)
  if valid_575211 != nil:
    section.add "version", valid_575211
  var valid_575212 = path.getOrDefault("subscriptionId")
  valid_575212 = validateParameter(valid_575212, JString, required = true,
                                 default = nil)
  if valid_575212 != nil:
    section.add "subscriptionId", valid_575212
  var valid_575213 = path.getOrDefault("applicationId")
  valid_575213 = validateParameter(valid_575213, JString, required = true,
                                 default = nil)
  if valid_575213 != nil:
    section.add "applicationId", valid_575213
  var valid_575214 = path.getOrDefault("accountName")
  valid_575214 = validateParameter(valid_575214, JString, required = true,
                                 default = nil)
  if valid_575214 != nil:
    section.add "accountName", valid_575214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575215 = query.getOrDefault("api-version")
  valid_575215 = validateParameter(valid_575215, JString, required = true,
                                 default = nil)
  if valid_575215 != nil:
    section.add "api-version", valid_575215
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

proc call*(call_575217: Call_ApplicationPackageActivate_575207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activates the specified application package.
  ## 
  let valid = call_575217.validator(path, query, header, formData, body)
  let scheme = call_575217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575217.url(scheme.get, call_575217.host, call_575217.base,
                         call_575217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575217, url, valid)

proc call*(call_575218: Call_ApplicationPackageActivate_575207;
          resourceGroupName: string; apiVersion: string; version: string;
          subscriptionId: string; applicationId: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## applicationPackageActivate
  ## Activates the specified application package.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   version: string (required)
  ##          : The version of the application to activate.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   applicationId: string (required)
  ##                : The ID of the application.
  ##   parameters: JObject (required)
  ##             : The parameters for the request.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_575219 = newJObject()
  var query_575220 = newJObject()
  var body_575221 = newJObject()
  add(path_575219, "resourceGroupName", newJString(resourceGroupName))
  add(query_575220, "api-version", newJString(apiVersion))
  add(path_575219, "version", newJString(version))
  add(path_575219, "subscriptionId", newJString(subscriptionId))
  add(path_575219, "applicationId", newJString(applicationId))
  if parameters != nil:
    body_575221 = parameters
  add(path_575219, "accountName", newJString(accountName))
  result = call_575218.call(path_575219, query_575220, nil, nil, body_575221)

var applicationPackageActivate* = Call_ApplicationPackageActivate_575207(
    name: "applicationPackageActivate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}/versions/{version}/activate",
    validator: validate_ApplicationPackageActivate_575208, base: "",
    url: url_ApplicationPackageActivate_575209, schemes: {Scheme.Https})
type
  Call_CertificateListByBatchAccount_575222 = ref object of OpenApiRestCall_574466
proc url_CertificateListByBatchAccount_575224(protocol: Scheme; host: string;
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

proc validate_CertificateListByBatchAccount_575223(path: JsonNode; query: JsonNode;
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
  var valid_575226 = path.getOrDefault("resourceGroupName")
  valid_575226 = validateParameter(valid_575226, JString, required = true,
                                 default = nil)
  if valid_575226 != nil:
    section.add "resourceGroupName", valid_575226
  var valid_575227 = path.getOrDefault("subscriptionId")
  valid_575227 = validateParameter(valid_575227, JString, required = true,
                                 default = nil)
  if valid_575227 != nil:
    section.add "subscriptionId", valid_575227
  var valid_575228 = path.getOrDefault("accountName")
  valid_575228 = validateParameter(valid_575228, JString, required = true,
                                 default = nil)
  if valid_575228 != nil:
    section.add "accountName", valid_575228
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
  var valid_575229 = query.getOrDefault("api-version")
  valid_575229 = validateParameter(valid_575229, JString, required = true,
                                 default = nil)
  if valid_575229 != nil:
    section.add "api-version", valid_575229
  var valid_575230 = query.getOrDefault("maxresults")
  valid_575230 = validateParameter(valid_575230, JInt, required = false, default = nil)
  if valid_575230 != nil:
    section.add "maxresults", valid_575230
  var valid_575231 = query.getOrDefault("$select")
  valid_575231 = validateParameter(valid_575231, JString, required = false,
                                 default = nil)
  if valid_575231 != nil:
    section.add "$select", valid_575231
  var valid_575232 = query.getOrDefault("$filter")
  valid_575232 = validateParameter(valid_575232, JString, required = false,
                                 default = nil)
  if valid_575232 != nil:
    section.add "$filter", valid_575232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575233: Call_CertificateListByBatchAccount_575222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the certificates in the specified account.
  ## 
  let valid = call_575233.validator(path, query, header, formData, body)
  let scheme = call_575233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575233.url(scheme.get, call_575233.host, call_575233.base,
                         call_575233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575233, url, valid)

proc call*(call_575234: Call_CertificateListByBatchAccount_575222;
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
  var path_575235 = newJObject()
  var query_575236 = newJObject()
  add(path_575235, "resourceGroupName", newJString(resourceGroupName))
  add(query_575236, "api-version", newJString(apiVersion))
  add(path_575235, "subscriptionId", newJString(subscriptionId))
  add(query_575236, "maxresults", newJInt(maxresults))
  add(query_575236, "$select", newJString(Select))
  add(path_575235, "accountName", newJString(accountName))
  add(query_575236, "$filter", newJString(Filter))
  result = call_575234.call(path_575235, query_575236, nil, nil, nil)

var certificateListByBatchAccount* = Call_CertificateListByBatchAccount_575222(
    name: "certificateListByBatchAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates",
    validator: validate_CertificateListByBatchAccount_575223, base: "",
    url: url_CertificateListByBatchAccount_575224, schemes: {Scheme.Https})
type
  Call_CertificateCreate_575249 = ref object of OpenApiRestCall_574466
proc url_CertificateCreate_575251(protocol: Scheme; host: string; base: string;
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

proc validate_CertificateCreate_575250(path: JsonNode; query: JsonNode;
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
  var valid_575252 = path.getOrDefault("resourceGroupName")
  valid_575252 = validateParameter(valid_575252, JString, required = true,
                                 default = nil)
  if valid_575252 != nil:
    section.add "resourceGroupName", valid_575252
  var valid_575253 = path.getOrDefault("subscriptionId")
  valid_575253 = validateParameter(valid_575253, JString, required = true,
                                 default = nil)
  if valid_575253 != nil:
    section.add "subscriptionId", valid_575253
  var valid_575254 = path.getOrDefault("certificateName")
  valid_575254 = validateParameter(valid_575254, JString, required = true,
                                 default = nil)
  if valid_575254 != nil:
    section.add "certificateName", valid_575254
  var valid_575255 = path.getOrDefault("accountName")
  valid_575255 = validateParameter(valid_575255, JString, required = true,
                                 default = nil)
  if valid_575255 != nil:
    section.add "accountName", valid_575255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575256 = query.getOrDefault("api-version")
  valid_575256 = validateParameter(valid_575256, JString, required = true,
                                 default = nil)
  if valid_575256 != nil:
    section.add "api-version", valid_575256
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the certificate to update. A value of "*" can be used to apply the operation only if the certificate already exists. If omitted, this operation will always be applied.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new certificate to be created, but to prevent updating an existing certificate. Other values will be ignored.
  section = newJObject()
  var valid_575257 = header.getOrDefault("If-Match")
  valid_575257 = validateParameter(valid_575257, JString, required = false,
                                 default = nil)
  if valid_575257 != nil:
    section.add "If-Match", valid_575257
  var valid_575258 = header.getOrDefault("If-None-Match")
  valid_575258 = validateParameter(valid_575258, JString, required = false,
                                 default = nil)
  if valid_575258 != nil:
    section.add "If-None-Match", valid_575258
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

proc call*(call_575260: Call_CertificateCreate_575249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new certificate inside the specified account.
  ## 
  let valid = call_575260.validator(path, query, header, formData, body)
  let scheme = call_575260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575260.url(scheme.get, call_575260.host, call_575260.base,
                         call_575260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575260, url, valid)

proc call*(call_575261: Call_CertificateCreate_575249; resourceGroupName: string;
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
  var path_575262 = newJObject()
  var query_575263 = newJObject()
  var body_575264 = newJObject()
  add(path_575262, "resourceGroupName", newJString(resourceGroupName))
  add(query_575263, "api-version", newJString(apiVersion))
  add(path_575262, "subscriptionId", newJString(subscriptionId))
  add(path_575262, "certificateName", newJString(certificateName))
  if parameters != nil:
    body_575264 = parameters
  add(path_575262, "accountName", newJString(accountName))
  result = call_575261.call(path_575262, query_575263, nil, nil, body_575264)

var certificateCreate* = Call_CertificateCreate_575249(name: "certificateCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates/{certificateName}",
    validator: validate_CertificateCreate_575250, base: "",
    url: url_CertificateCreate_575251, schemes: {Scheme.Https})
type
  Call_CertificateGet_575237 = ref object of OpenApiRestCall_574466
proc url_CertificateGet_575239(protocol: Scheme; host: string; base: string;
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

proc validate_CertificateGet_575238(path: JsonNode; query: JsonNode;
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
  var valid_575240 = path.getOrDefault("resourceGroupName")
  valid_575240 = validateParameter(valid_575240, JString, required = true,
                                 default = nil)
  if valid_575240 != nil:
    section.add "resourceGroupName", valid_575240
  var valid_575241 = path.getOrDefault("subscriptionId")
  valid_575241 = validateParameter(valid_575241, JString, required = true,
                                 default = nil)
  if valid_575241 != nil:
    section.add "subscriptionId", valid_575241
  var valid_575242 = path.getOrDefault("certificateName")
  valid_575242 = validateParameter(valid_575242, JString, required = true,
                                 default = nil)
  if valid_575242 != nil:
    section.add "certificateName", valid_575242
  var valid_575243 = path.getOrDefault("accountName")
  valid_575243 = validateParameter(valid_575243, JString, required = true,
                                 default = nil)
  if valid_575243 != nil:
    section.add "accountName", valid_575243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575244 = query.getOrDefault("api-version")
  valid_575244 = validateParameter(valid_575244, JString, required = true,
                                 default = nil)
  if valid_575244 != nil:
    section.add "api-version", valid_575244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575245: Call_CertificateGet_575237; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified certificate.
  ## 
  let valid = call_575245.validator(path, query, header, formData, body)
  let scheme = call_575245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575245.url(scheme.get, call_575245.host, call_575245.base,
                         call_575245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575245, url, valid)

proc call*(call_575246: Call_CertificateGet_575237; resourceGroupName: string;
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
  var path_575247 = newJObject()
  var query_575248 = newJObject()
  add(path_575247, "resourceGroupName", newJString(resourceGroupName))
  add(query_575248, "api-version", newJString(apiVersion))
  add(path_575247, "subscriptionId", newJString(subscriptionId))
  add(path_575247, "certificateName", newJString(certificateName))
  add(path_575247, "accountName", newJString(accountName))
  result = call_575246.call(path_575247, query_575248, nil, nil, nil)

var certificateGet* = Call_CertificateGet_575237(name: "certificateGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates/{certificateName}",
    validator: validate_CertificateGet_575238, base: "", url: url_CertificateGet_575239,
    schemes: {Scheme.Https})
type
  Call_CertificateUpdate_575277 = ref object of OpenApiRestCall_574466
proc url_CertificateUpdate_575279(protocol: Scheme; host: string; base: string;
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

proc validate_CertificateUpdate_575278(path: JsonNode; query: JsonNode;
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
  var valid_575280 = path.getOrDefault("resourceGroupName")
  valid_575280 = validateParameter(valid_575280, JString, required = true,
                                 default = nil)
  if valid_575280 != nil:
    section.add "resourceGroupName", valid_575280
  var valid_575281 = path.getOrDefault("subscriptionId")
  valid_575281 = validateParameter(valid_575281, JString, required = true,
                                 default = nil)
  if valid_575281 != nil:
    section.add "subscriptionId", valid_575281
  var valid_575282 = path.getOrDefault("certificateName")
  valid_575282 = validateParameter(valid_575282, JString, required = true,
                                 default = nil)
  if valid_575282 != nil:
    section.add "certificateName", valid_575282
  var valid_575283 = path.getOrDefault("accountName")
  valid_575283 = validateParameter(valid_575283, JString, required = true,
                                 default = nil)
  if valid_575283 != nil:
    section.add "accountName", valid_575283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575284 = query.getOrDefault("api-version")
  valid_575284 = validateParameter(valid_575284, JString, required = true,
                                 default = nil)
  if valid_575284 != nil:
    section.add "api-version", valid_575284
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the certificate to update. This value can be omitted or set to "*" to apply the operation unconditionally.
  section = newJObject()
  var valid_575285 = header.getOrDefault("If-Match")
  valid_575285 = validateParameter(valid_575285, JString, required = false,
                                 default = nil)
  if valid_575285 != nil:
    section.add "If-Match", valid_575285
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

proc call*(call_575287: Call_CertificateUpdate_575277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing certificate.
  ## 
  let valid = call_575287.validator(path, query, header, formData, body)
  let scheme = call_575287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575287.url(scheme.get, call_575287.host, call_575287.base,
                         call_575287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575287, url, valid)

proc call*(call_575288: Call_CertificateUpdate_575277; resourceGroupName: string;
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
  var path_575289 = newJObject()
  var query_575290 = newJObject()
  var body_575291 = newJObject()
  add(path_575289, "resourceGroupName", newJString(resourceGroupName))
  add(query_575290, "api-version", newJString(apiVersion))
  add(path_575289, "subscriptionId", newJString(subscriptionId))
  add(path_575289, "certificateName", newJString(certificateName))
  if parameters != nil:
    body_575291 = parameters
  add(path_575289, "accountName", newJString(accountName))
  result = call_575288.call(path_575289, query_575290, nil, nil, body_575291)

var certificateUpdate* = Call_CertificateUpdate_575277(name: "certificateUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates/{certificateName}",
    validator: validate_CertificateUpdate_575278, base: "",
    url: url_CertificateUpdate_575279, schemes: {Scheme.Https})
type
  Call_CertificateDelete_575265 = ref object of OpenApiRestCall_574466
proc url_CertificateDelete_575267(protocol: Scheme; host: string; base: string;
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

proc validate_CertificateDelete_575266(path: JsonNode; query: JsonNode;
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
  var valid_575268 = path.getOrDefault("resourceGroupName")
  valid_575268 = validateParameter(valid_575268, JString, required = true,
                                 default = nil)
  if valid_575268 != nil:
    section.add "resourceGroupName", valid_575268
  var valid_575269 = path.getOrDefault("subscriptionId")
  valid_575269 = validateParameter(valid_575269, JString, required = true,
                                 default = nil)
  if valid_575269 != nil:
    section.add "subscriptionId", valid_575269
  var valid_575270 = path.getOrDefault("certificateName")
  valid_575270 = validateParameter(valid_575270, JString, required = true,
                                 default = nil)
  if valid_575270 != nil:
    section.add "certificateName", valid_575270
  var valid_575271 = path.getOrDefault("accountName")
  valid_575271 = validateParameter(valid_575271, JString, required = true,
                                 default = nil)
  if valid_575271 != nil:
    section.add "accountName", valid_575271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575272 = query.getOrDefault("api-version")
  valid_575272 = validateParameter(valid_575272, JString, required = true,
                                 default = nil)
  if valid_575272 != nil:
    section.add "api-version", valid_575272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575273: Call_CertificateDelete_575265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified certificate.
  ## 
  let valid = call_575273.validator(path, query, header, formData, body)
  let scheme = call_575273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575273.url(scheme.get, call_575273.host, call_575273.base,
                         call_575273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575273, url, valid)

proc call*(call_575274: Call_CertificateDelete_575265; resourceGroupName: string;
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
  var path_575275 = newJObject()
  var query_575276 = newJObject()
  add(path_575275, "resourceGroupName", newJString(resourceGroupName))
  add(query_575276, "api-version", newJString(apiVersion))
  add(path_575275, "subscriptionId", newJString(subscriptionId))
  add(path_575275, "certificateName", newJString(certificateName))
  add(path_575275, "accountName", newJString(accountName))
  result = call_575274.call(path_575275, query_575276, nil, nil, nil)

var certificateDelete* = Call_CertificateDelete_575265(name: "certificateDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates/{certificateName}",
    validator: validate_CertificateDelete_575266, base: "",
    url: url_CertificateDelete_575267, schemes: {Scheme.Https})
type
  Call_CertificateCancelDeletion_575292 = ref object of OpenApiRestCall_574466
proc url_CertificateCancelDeletion_575294(protocol: Scheme; host: string;
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

proc validate_CertificateCancelDeletion_575293(path: JsonNode; query: JsonNode;
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
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575300: Call_CertificateCancelDeletion_575292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If you try to delete a certificate that is being used by a pool or compute node, the status of the certificate changes to deleteFailed. If you decide that you want to continue using the certificate, you can use this operation to set the status of the certificate back to active. If you intend to delete the certificate, you do not need to run this operation after the deletion failed. You must make sure that the certificate is not being used by any resources, and then you can try again to delete the certificate.
  ## 
  let valid = call_575300.validator(path, query, header, formData, body)
  let scheme = call_575300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575300.url(scheme.get, call_575300.host, call_575300.base,
                         call_575300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575300, url, valid)

proc call*(call_575301: Call_CertificateCancelDeletion_575292;
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
  var path_575302 = newJObject()
  var query_575303 = newJObject()
  add(path_575302, "resourceGroupName", newJString(resourceGroupName))
  add(query_575303, "api-version", newJString(apiVersion))
  add(path_575302, "subscriptionId", newJString(subscriptionId))
  add(path_575302, "certificateName", newJString(certificateName))
  add(path_575302, "accountName", newJString(accountName))
  result = call_575301.call(path_575302, query_575303, nil, nil, nil)

var certificateCancelDeletion* = Call_CertificateCancelDeletion_575292(
    name: "certificateCancelDeletion", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates/{certificateName}/cancelDelete",
    validator: validate_CertificateCancelDeletion_575293, base: "",
    url: url_CertificateCancelDeletion_575294, schemes: {Scheme.Https})
type
  Call_BatchAccountGetKeys_575304 = ref object of OpenApiRestCall_574466
proc url_BatchAccountGetKeys_575306(protocol: Scheme; host: string; base: string;
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

proc validate_BatchAccountGetKeys_575305(path: JsonNode; query: JsonNode;
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
  var valid_575307 = path.getOrDefault("resourceGroupName")
  valid_575307 = validateParameter(valid_575307, JString, required = true,
                                 default = nil)
  if valid_575307 != nil:
    section.add "resourceGroupName", valid_575307
  var valid_575308 = path.getOrDefault("subscriptionId")
  valid_575308 = validateParameter(valid_575308, JString, required = true,
                                 default = nil)
  if valid_575308 != nil:
    section.add "subscriptionId", valid_575308
  var valid_575309 = path.getOrDefault("accountName")
  valid_575309 = validateParameter(valid_575309, JString, required = true,
                                 default = nil)
  if valid_575309 != nil:
    section.add "accountName", valid_575309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575310 = query.getOrDefault("api-version")
  valid_575310 = validateParameter(valid_575310, JString, required = true,
                                 default = nil)
  if valid_575310 != nil:
    section.add "api-version", valid_575310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575311: Call_BatchAccountGetKeys_575304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation applies only to Batch accounts created with a poolAllocationMode of 'BatchService'. If the Batch account was created with a poolAllocationMode of 'UserSubscription', clients cannot use access to keys to authenticate, and must use Azure Active Directory instead. In this case, getting the keys will fail.
  ## 
  let valid = call_575311.validator(path, query, header, formData, body)
  let scheme = call_575311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575311.url(scheme.get, call_575311.host, call_575311.base,
                         call_575311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575311, url, valid)

proc call*(call_575312: Call_BatchAccountGetKeys_575304; resourceGroupName: string;
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
  var path_575313 = newJObject()
  var query_575314 = newJObject()
  add(path_575313, "resourceGroupName", newJString(resourceGroupName))
  add(query_575314, "api-version", newJString(apiVersion))
  add(path_575313, "subscriptionId", newJString(subscriptionId))
  add(path_575313, "accountName", newJString(accountName))
  result = call_575312.call(path_575313, query_575314, nil, nil, nil)

var batchAccountGetKeys* = Call_BatchAccountGetKeys_575304(
    name: "batchAccountGetKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/listKeys",
    validator: validate_BatchAccountGetKeys_575305, base: "",
    url: url_BatchAccountGetKeys_575306, schemes: {Scheme.Https})
type
  Call_PoolListByBatchAccount_575315 = ref object of OpenApiRestCall_574466
proc url_PoolListByBatchAccount_575317(protocol: Scheme; host: string; base: string;
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

proc validate_PoolListByBatchAccount_575316(path: JsonNode; query: JsonNode;
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
  var valid_575318 = path.getOrDefault("resourceGroupName")
  valid_575318 = validateParameter(valid_575318, JString, required = true,
                                 default = nil)
  if valid_575318 != nil:
    section.add "resourceGroupName", valid_575318
  var valid_575319 = path.getOrDefault("subscriptionId")
  valid_575319 = validateParameter(valid_575319, JString, required = true,
                                 default = nil)
  if valid_575319 != nil:
    section.add "subscriptionId", valid_575319
  var valid_575320 = path.getOrDefault("accountName")
  valid_575320 = validateParameter(valid_575320, JString, required = true,
                                 default = nil)
  if valid_575320 != nil:
    section.add "accountName", valid_575320
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
  var valid_575321 = query.getOrDefault("api-version")
  valid_575321 = validateParameter(valid_575321, JString, required = true,
                                 default = nil)
  if valid_575321 != nil:
    section.add "api-version", valid_575321
  var valid_575322 = query.getOrDefault("maxresults")
  valid_575322 = validateParameter(valid_575322, JInt, required = false, default = nil)
  if valid_575322 != nil:
    section.add "maxresults", valid_575322
  var valid_575323 = query.getOrDefault("$select")
  valid_575323 = validateParameter(valid_575323, JString, required = false,
                                 default = nil)
  if valid_575323 != nil:
    section.add "$select", valid_575323
  var valid_575324 = query.getOrDefault("$filter")
  valid_575324 = validateParameter(valid_575324, JString, required = false,
                                 default = nil)
  if valid_575324 != nil:
    section.add "$filter", valid_575324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575325: Call_PoolListByBatchAccount_575315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the pools in the specified account.
  ## 
  let valid = call_575325.validator(path, query, header, formData, body)
  let scheme = call_575325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575325.url(scheme.get, call_575325.host, call_575325.base,
                         call_575325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575325, url, valid)

proc call*(call_575326: Call_PoolListByBatchAccount_575315;
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
  var path_575327 = newJObject()
  var query_575328 = newJObject()
  add(path_575327, "resourceGroupName", newJString(resourceGroupName))
  add(query_575328, "api-version", newJString(apiVersion))
  add(path_575327, "subscriptionId", newJString(subscriptionId))
  add(query_575328, "maxresults", newJInt(maxresults))
  add(query_575328, "$select", newJString(Select))
  add(path_575327, "accountName", newJString(accountName))
  add(query_575328, "$filter", newJString(Filter))
  result = call_575326.call(path_575327, query_575328, nil, nil, nil)

var poolListByBatchAccount* = Call_PoolListByBatchAccount_575315(
    name: "poolListByBatchAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools",
    validator: validate_PoolListByBatchAccount_575316, base: "",
    url: url_PoolListByBatchAccount_575317, schemes: {Scheme.Https})
type
  Call_PoolCreate_575341 = ref object of OpenApiRestCall_574466
proc url_PoolCreate_575343(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolCreate_575342(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575344 = path.getOrDefault("poolName")
  valid_575344 = validateParameter(valid_575344, JString, required = true,
                                 default = nil)
  if valid_575344 != nil:
    section.add "poolName", valid_575344
  var valid_575345 = path.getOrDefault("resourceGroupName")
  valid_575345 = validateParameter(valid_575345, JString, required = true,
                                 default = nil)
  if valid_575345 != nil:
    section.add "resourceGroupName", valid_575345
  var valid_575346 = path.getOrDefault("subscriptionId")
  valid_575346 = validateParameter(valid_575346, JString, required = true,
                                 default = nil)
  if valid_575346 != nil:
    section.add "subscriptionId", valid_575346
  var valid_575347 = path.getOrDefault("accountName")
  valid_575347 = validateParameter(valid_575347, JString, required = true,
                                 default = nil)
  if valid_575347 != nil:
    section.add "accountName", valid_575347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575348 = query.getOrDefault("api-version")
  valid_575348 = validateParameter(valid_575348, JString, required = true,
                                 default = nil)
  if valid_575348 != nil:
    section.add "api-version", valid_575348
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the pool to update. A value of "*" can be used to apply the operation only if the pool already exists. If omitted, this operation will always be applied.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new pool to be created, but to prevent updating an existing pool. Other values will be ignored.
  section = newJObject()
  var valid_575349 = header.getOrDefault("If-Match")
  valid_575349 = validateParameter(valid_575349, JString, required = false,
                                 default = nil)
  if valid_575349 != nil:
    section.add "If-Match", valid_575349
  var valid_575350 = header.getOrDefault("If-None-Match")
  valid_575350 = validateParameter(valid_575350, JString, required = false,
                                 default = nil)
  if valid_575350 != nil:
    section.add "If-None-Match", valid_575350
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

proc call*(call_575352: Call_PoolCreate_575341; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new pool inside the specified account.
  ## 
  let valid = call_575352.validator(path, query, header, formData, body)
  let scheme = call_575352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575352.url(scheme.get, call_575352.host, call_575352.base,
                         call_575352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575352, url, valid)

proc call*(call_575353: Call_PoolCreate_575341; poolName: string;
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
  var path_575354 = newJObject()
  var query_575355 = newJObject()
  var body_575356 = newJObject()
  add(path_575354, "poolName", newJString(poolName))
  add(path_575354, "resourceGroupName", newJString(resourceGroupName))
  add(query_575355, "api-version", newJString(apiVersion))
  add(path_575354, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575356 = parameters
  add(path_575354, "accountName", newJString(accountName))
  result = call_575353.call(path_575354, query_575355, nil, nil, body_575356)

var poolCreate* = Call_PoolCreate_575341(name: "poolCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}",
                                      validator: validate_PoolCreate_575342,
                                      base: "", url: url_PoolCreate_575343,
                                      schemes: {Scheme.Https})
type
  Call_PoolGet_575329 = ref object of OpenApiRestCall_574466
proc url_PoolGet_575331(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolGet_575330(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575332 = path.getOrDefault("poolName")
  valid_575332 = validateParameter(valid_575332, JString, required = true,
                                 default = nil)
  if valid_575332 != nil:
    section.add "poolName", valid_575332
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575336 = query.getOrDefault("api-version")
  valid_575336 = validateParameter(valid_575336, JString, required = true,
                                 default = nil)
  if valid_575336 != nil:
    section.add "api-version", valid_575336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575337: Call_PoolGet_575329; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified pool.
  ## 
  let valid = call_575337.validator(path, query, header, formData, body)
  let scheme = call_575337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575337.url(scheme.get, call_575337.host, call_575337.base,
                         call_575337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575337, url, valid)

proc call*(call_575338: Call_PoolGet_575329; poolName: string;
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
  var path_575339 = newJObject()
  var query_575340 = newJObject()
  add(path_575339, "poolName", newJString(poolName))
  add(path_575339, "resourceGroupName", newJString(resourceGroupName))
  add(query_575340, "api-version", newJString(apiVersion))
  add(path_575339, "subscriptionId", newJString(subscriptionId))
  add(path_575339, "accountName", newJString(accountName))
  result = call_575338.call(path_575339, query_575340, nil, nil, nil)

var poolGet* = Call_PoolGet_575329(name: "poolGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}",
                                validator: validate_PoolGet_575330, base: "",
                                url: url_PoolGet_575331, schemes: {Scheme.Https})
type
  Call_PoolUpdate_575369 = ref object of OpenApiRestCall_574466
proc url_PoolUpdate_575371(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolUpdate_575370(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575372 = path.getOrDefault("poolName")
  valid_575372 = validateParameter(valid_575372, JString, required = true,
                                 default = nil)
  if valid_575372 != nil:
    section.add "poolName", valid_575372
  var valid_575373 = path.getOrDefault("resourceGroupName")
  valid_575373 = validateParameter(valid_575373, JString, required = true,
                                 default = nil)
  if valid_575373 != nil:
    section.add "resourceGroupName", valid_575373
  var valid_575374 = path.getOrDefault("subscriptionId")
  valid_575374 = validateParameter(valid_575374, JString, required = true,
                                 default = nil)
  if valid_575374 != nil:
    section.add "subscriptionId", valid_575374
  var valid_575375 = path.getOrDefault("accountName")
  valid_575375 = validateParameter(valid_575375, JString, required = true,
                                 default = nil)
  if valid_575375 != nil:
    section.add "accountName", valid_575375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575376 = query.getOrDefault("api-version")
  valid_575376 = validateParameter(valid_575376, JString, required = true,
                                 default = nil)
  if valid_575376 != nil:
    section.add "api-version", valid_575376
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the pool to update. This value can be omitted or set to "*" to apply the operation unconditionally.
  section = newJObject()
  var valid_575377 = header.getOrDefault("If-Match")
  valid_575377 = validateParameter(valid_575377, JString, required = false,
                                 default = nil)
  if valid_575377 != nil:
    section.add "If-Match", valid_575377
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

proc call*(call_575379: Call_PoolUpdate_575369; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing pool.
  ## 
  let valid = call_575379.validator(path, query, header, formData, body)
  let scheme = call_575379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575379.url(scheme.get, call_575379.host, call_575379.base,
                         call_575379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575379, url, valid)

proc call*(call_575380: Call_PoolUpdate_575369; poolName: string;
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
  var path_575381 = newJObject()
  var query_575382 = newJObject()
  var body_575383 = newJObject()
  add(path_575381, "poolName", newJString(poolName))
  add(path_575381, "resourceGroupName", newJString(resourceGroupName))
  add(query_575382, "api-version", newJString(apiVersion))
  add(path_575381, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575383 = parameters
  add(path_575381, "accountName", newJString(accountName))
  result = call_575380.call(path_575381, query_575382, nil, nil, body_575383)

var poolUpdate* = Call_PoolUpdate_575369(name: "poolUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}",
                                      validator: validate_PoolUpdate_575370,
                                      base: "", url: url_PoolUpdate_575371,
                                      schemes: {Scheme.Https})
type
  Call_PoolDelete_575357 = ref object of OpenApiRestCall_574466
proc url_PoolDelete_575359(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolDelete_575358(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575360 = path.getOrDefault("poolName")
  valid_575360 = validateParameter(valid_575360, JString, required = true,
                                 default = nil)
  if valid_575360 != nil:
    section.add "poolName", valid_575360
  var valid_575361 = path.getOrDefault("resourceGroupName")
  valid_575361 = validateParameter(valid_575361, JString, required = true,
                                 default = nil)
  if valid_575361 != nil:
    section.add "resourceGroupName", valid_575361
  var valid_575362 = path.getOrDefault("subscriptionId")
  valid_575362 = validateParameter(valid_575362, JString, required = true,
                                 default = nil)
  if valid_575362 != nil:
    section.add "subscriptionId", valid_575362
  var valid_575363 = path.getOrDefault("accountName")
  valid_575363 = validateParameter(valid_575363, JString, required = true,
                                 default = nil)
  if valid_575363 != nil:
    section.add "accountName", valid_575363
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575364 = query.getOrDefault("api-version")
  valid_575364 = validateParameter(valid_575364, JString, required = true,
                                 default = nil)
  if valid_575364 != nil:
    section.add "api-version", valid_575364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575365: Call_PoolDelete_575357; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified pool.
  ## 
  let valid = call_575365.validator(path, query, header, formData, body)
  let scheme = call_575365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575365.url(scheme.get, call_575365.host, call_575365.base,
                         call_575365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575365, url, valid)

proc call*(call_575366: Call_PoolDelete_575357; poolName: string;
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
  var path_575367 = newJObject()
  var query_575368 = newJObject()
  add(path_575367, "poolName", newJString(poolName))
  add(path_575367, "resourceGroupName", newJString(resourceGroupName))
  add(query_575368, "api-version", newJString(apiVersion))
  add(path_575367, "subscriptionId", newJString(subscriptionId))
  add(path_575367, "accountName", newJString(accountName))
  result = call_575366.call(path_575367, query_575368, nil, nil, nil)

var poolDelete* = Call_PoolDelete_575357(name: "poolDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}",
                                      validator: validate_PoolDelete_575358,
                                      base: "", url: url_PoolDelete_575359,
                                      schemes: {Scheme.Https})
type
  Call_PoolDisableAutoScale_575384 = ref object of OpenApiRestCall_574466
proc url_PoolDisableAutoScale_575386(protocol: Scheme; host: string; base: string;
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

proc validate_PoolDisableAutoScale_575385(path: JsonNode; query: JsonNode;
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
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575392: Call_PoolDisableAutoScale_575384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disables automatic scaling for a pool.
  ## 
  let valid = call_575392.validator(path, query, header, formData, body)
  let scheme = call_575392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575392.url(scheme.get, call_575392.host, call_575392.base,
                         call_575392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575392, url, valid)

proc call*(call_575393: Call_PoolDisableAutoScale_575384; poolName: string;
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
  var path_575394 = newJObject()
  var query_575395 = newJObject()
  add(path_575394, "poolName", newJString(poolName))
  add(path_575394, "resourceGroupName", newJString(resourceGroupName))
  add(query_575395, "api-version", newJString(apiVersion))
  add(path_575394, "subscriptionId", newJString(subscriptionId))
  add(path_575394, "accountName", newJString(accountName))
  result = call_575393.call(path_575394, query_575395, nil, nil, nil)

var poolDisableAutoScale* = Call_PoolDisableAutoScale_575384(
    name: "poolDisableAutoScale", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}/disableAutoScale",
    validator: validate_PoolDisableAutoScale_575385, base: "",
    url: url_PoolDisableAutoScale_575386, schemes: {Scheme.Https})
type
  Call_PoolStopResize_575396 = ref object of OpenApiRestCall_574466
proc url_PoolStopResize_575398(protocol: Scheme; host: string; base: string;
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

proc validate_PoolStopResize_575397(path: JsonNode; query: JsonNode;
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
  var valid_575399 = path.getOrDefault("poolName")
  valid_575399 = validateParameter(valid_575399, JString, required = true,
                                 default = nil)
  if valid_575399 != nil:
    section.add "poolName", valid_575399
  var valid_575400 = path.getOrDefault("resourceGroupName")
  valid_575400 = validateParameter(valid_575400, JString, required = true,
                                 default = nil)
  if valid_575400 != nil:
    section.add "resourceGroupName", valid_575400
  var valid_575401 = path.getOrDefault("subscriptionId")
  valid_575401 = validateParameter(valid_575401, JString, required = true,
                                 default = nil)
  if valid_575401 != nil:
    section.add "subscriptionId", valid_575401
  var valid_575402 = path.getOrDefault("accountName")
  valid_575402 = validateParameter(valid_575402, JString, required = true,
                                 default = nil)
  if valid_575402 != nil:
    section.add "accountName", valid_575402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575403 = query.getOrDefault("api-version")
  valid_575403 = validateParameter(valid_575403, JString, required = true,
                                 default = nil)
  if valid_575403 != nil:
    section.add "api-version", valid_575403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575404: Call_PoolStopResize_575396; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This does not restore the pool to its previous state before the resize operation: it only stops any further changes being made, and the pool maintains its current state. After stopping, the pool stabilizes at the number of nodes it was at when the stop operation was done. During the stop operation, the pool allocation state changes first to stopping and then to steady. A resize operation need not be an explicit resize pool request; this API can also be used to halt the initial sizing of the pool when it is created.
  ## 
  let valid = call_575404.validator(path, query, header, formData, body)
  let scheme = call_575404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575404.url(scheme.get, call_575404.host, call_575404.base,
                         call_575404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575404, url, valid)

proc call*(call_575405: Call_PoolStopResize_575396; poolName: string;
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
  var path_575406 = newJObject()
  var query_575407 = newJObject()
  add(path_575406, "poolName", newJString(poolName))
  add(path_575406, "resourceGroupName", newJString(resourceGroupName))
  add(query_575407, "api-version", newJString(apiVersion))
  add(path_575406, "subscriptionId", newJString(subscriptionId))
  add(path_575406, "accountName", newJString(accountName))
  result = call_575405.call(path_575406, query_575407, nil, nil, nil)

var poolStopResize* = Call_PoolStopResize_575396(name: "poolStopResize",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}/stopResize",
    validator: validate_PoolStopResize_575397, base: "", url: url_PoolStopResize_575398,
    schemes: {Scheme.Https})
type
  Call_BatchAccountRegenerateKey_575408 = ref object of OpenApiRestCall_574466
proc url_BatchAccountRegenerateKey_575410(protocol: Scheme; host: string;
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

proc validate_BatchAccountRegenerateKey_575409(path: JsonNode; query: JsonNode;
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
  var valid_575411 = path.getOrDefault("resourceGroupName")
  valid_575411 = validateParameter(valid_575411, JString, required = true,
                                 default = nil)
  if valid_575411 != nil:
    section.add "resourceGroupName", valid_575411
  var valid_575412 = path.getOrDefault("subscriptionId")
  valid_575412 = validateParameter(valid_575412, JString, required = true,
                                 default = nil)
  if valid_575412 != nil:
    section.add "subscriptionId", valid_575412
  var valid_575413 = path.getOrDefault("accountName")
  valid_575413 = validateParameter(valid_575413, JString, required = true,
                                 default = nil)
  if valid_575413 != nil:
    section.add "accountName", valid_575413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575414 = query.getOrDefault("api-version")
  valid_575414 = validateParameter(valid_575414, JString, required = true,
                                 default = nil)
  if valid_575414 != nil:
    section.add "api-version", valid_575414
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

proc call*(call_575416: Call_BatchAccountRegenerateKey_575408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the specified account key for the Batch account.
  ## 
  let valid = call_575416.validator(path, query, header, formData, body)
  let scheme = call_575416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575416.url(scheme.get, call_575416.host, call_575416.base,
                         call_575416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575416, url, valid)

proc call*(call_575417: Call_BatchAccountRegenerateKey_575408;
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
  var path_575418 = newJObject()
  var query_575419 = newJObject()
  var body_575420 = newJObject()
  add(path_575418, "resourceGroupName", newJString(resourceGroupName))
  add(query_575419, "api-version", newJString(apiVersion))
  add(path_575418, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575420 = parameters
  add(path_575418, "accountName", newJString(accountName))
  result = call_575417.call(path_575418, query_575419, nil, nil, body_575420)

var batchAccountRegenerateKey* = Call_BatchAccountRegenerateKey_575408(
    name: "batchAccountRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/regenerateKeys",
    validator: validate_BatchAccountRegenerateKey_575409, base: "",
    url: url_BatchAccountRegenerateKey_575410, schemes: {Scheme.Https})
type
  Call_BatchAccountSynchronizeAutoStorageKeys_575421 = ref object of OpenApiRestCall_574466
proc url_BatchAccountSynchronizeAutoStorageKeys_575423(protocol: Scheme;
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

proc validate_BatchAccountSynchronizeAutoStorageKeys_575422(path: JsonNode;
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
  var valid_575424 = path.getOrDefault("resourceGroupName")
  valid_575424 = validateParameter(valid_575424, JString, required = true,
                                 default = nil)
  if valid_575424 != nil:
    section.add "resourceGroupName", valid_575424
  var valid_575425 = path.getOrDefault("subscriptionId")
  valid_575425 = validateParameter(valid_575425, JString, required = true,
                                 default = nil)
  if valid_575425 != nil:
    section.add "subscriptionId", valid_575425
  var valid_575426 = path.getOrDefault("accountName")
  valid_575426 = validateParameter(valid_575426, JString, required = true,
                                 default = nil)
  if valid_575426 != nil:
    section.add "accountName", valid_575426
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575427 = query.getOrDefault("api-version")
  valid_575427 = validateParameter(valid_575427, JString, required = true,
                                 default = nil)
  if valid_575427 != nil:
    section.add "api-version", valid_575427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575428: Call_BatchAccountSynchronizeAutoStorageKeys_575421;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Synchronizes access keys for the auto-storage account configured for the specified Batch account.
  ## 
  let valid = call_575428.validator(path, query, header, formData, body)
  let scheme = call_575428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575428.url(scheme.get, call_575428.host, call_575428.base,
                         call_575428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575428, url, valid)

proc call*(call_575429: Call_BatchAccountSynchronizeAutoStorageKeys_575421;
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
  var path_575430 = newJObject()
  var query_575431 = newJObject()
  add(path_575430, "resourceGroupName", newJString(resourceGroupName))
  add(query_575431, "api-version", newJString(apiVersion))
  add(path_575430, "subscriptionId", newJString(subscriptionId))
  add(path_575430, "accountName", newJString(accountName))
  result = call_575429.call(path_575430, query_575431, nil, nil, nil)

var batchAccountSynchronizeAutoStorageKeys* = Call_BatchAccountSynchronizeAutoStorageKeys_575421(
    name: "batchAccountSynchronizeAutoStorageKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/syncAutoStorageKeys",
    validator: validate_BatchAccountSynchronizeAutoStorageKeys_575422, base: "",
    url: url_BatchAccountSynchronizeAutoStorageKeys_575423,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
