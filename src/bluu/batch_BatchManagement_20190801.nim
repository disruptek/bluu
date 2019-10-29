
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: BatchManagement
## version: 2019-08-01
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

  OpenApiRestCall_563564 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563564](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563564): Option[Scheme] {.used.} =
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
  macServiceName = "batch-BatchManagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563786 = ref object of OpenApiRestCall_563564
proc url_OperationsList_563788(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563787(path: JsonNode; query: JsonNode;
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
  var valid_563949 = query.getOrDefault("api-version")
  valid_563949 = validateParameter(valid_563949, JString, required = true,
                                 default = nil)
  if valid_563949 != nil:
    section.add "api-version", valid_563949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563972: Call_OperationsList_563786; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations for the Microsoft.Batch provider
  ## 
  let valid = call_563972.validator(path, query, header, formData, body)
  let scheme = call_563972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563972.url(scheme.get, call_563972.host, call_563972.base,
                         call_563972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563972, url, valid)

proc call*(call_564043: Call_OperationsList_563786; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations for the Microsoft.Batch provider
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  var query_564044 = newJObject()
  add(query_564044, "api-version", newJString(apiVersion))
  result = call_564043.call(nil, query_564044, nil, nil, nil)

var operationsList* = Call_OperationsList_563786(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Batch/operations",
    validator: validate_OperationsList_563787, base: "", url: url_OperationsList_563788,
    schemes: {Scheme.Https})
type
  Call_BatchAccountList_564084 = ref object of OpenApiRestCall_563564
proc url_BatchAccountList_564086(protocol: Scheme; host: string; base: string;
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

proc validate_BatchAccountList_564085(path: JsonNode; query: JsonNode;
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
  var valid_564101 = path.getOrDefault("subscriptionId")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "subscriptionId", valid_564101
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564102 = query.getOrDefault("api-version")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "api-version", valid_564102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564103: Call_BatchAccountList_564084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the Batch accounts associated with the subscription.
  ## 
  let valid = call_564103.validator(path, query, header, formData, body)
  let scheme = call_564103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564103.url(scheme.get, call_564103.host, call_564103.base,
                         call_564103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564103, url, valid)

proc call*(call_564104: Call_BatchAccountList_564084; apiVersion: string;
          subscriptionId: string): Recallable =
  ## batchAccountList
  ## Gets information about the Batch accounts associated with the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  var path_564105 = newJObject()
  var query_564106 = newJObject()
  add(query_564106, "api-version", newJString(apiVersion))
  add(path_564105, "subscriptionId", newJString(subscriptionId))
  result = call_564104.call(path_564105, query_564106, nil, nil, nil)

var batchAccountList* = Call_BatchAccountList_564084(name: "batchAccountList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Batch/batchAccounts",
    validator: validate_BatchAccountList_564085, base: "",
    url: url_BatchAccountList_564086, schemes: {Scheme.Https})
type
  Call_LocationCheckNameAvailability_564107 = ref object of OpenApiRestCall_563564
proc url_LocationCheckNameAvailability_564109(protocol: Scheme; host: string;
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

proc validate_LocationCheckNameAvailability_564108(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the Batch account name is available in the specified region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The desired region for the name check.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564127 = path.getOrDefault("locationName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "locationName", valid_564127
  var valid_564128 = path.getOrDefault("subscriptionId")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "subscriptionId", valid_564128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564129 = query.getOrDefault("api-version")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "api-version", valid_564129
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

proc call*(call_564131: Call_LocationCheckNameAvailability_564107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the Batch account name is available in the specified region.
  ## 
  let valid = call_564131.validator(path, query, header, formData, body)
  let scheme = call_564131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564131.url(scheme.get, call_564131.host, call_564131.base,
                         call_564131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564131, url, valid)

proc call*(call_564132: Call_LocationCheckNameAvailability_564107;
          apiVersion: string; locationName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## locationCheckNameAvailability
  ## Checks whether the Batch account name is available in the specified region.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   locationName: string (required)
  ##               : The desired region for the name check.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   parameters: JObject (required)
  ##             : Properties needed to check the availability of a name.
  var path_564133 = newJObject()
  var query_564134 = newJObject()
  var body_564135 = newJObject()
  add(query_564134, "api-version", newJString(apiVersion))
  add(path_564133, "locationName", newJString(locationName))
  add(path_564133, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564135 = parameters
  result = call_564132.call(path_564133, query_564134, nil, nil, body_564135)

var locationCheckNameAvailability* = Call_LocationCheckNameAvailability_564107(
    name: "locationCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Batch/locations/{locationName}/checkNameAvailability",
    validator: validate_LocationCheckNameAvailability_564108, base: "",
    url: url_LocationCheckNameAvailability_564109, schemes: {Scheme.Https})
type
  Call_LocationGetQuotas_564136 = ref object of OpenApiRestCall_563564
proc url_LocationGetQuotas_564138(protocol: Scheme; host: string; base: string;
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

proc validate_LocationGetQuotas_564137(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the Batch service quotas for the specified subscription at the given location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The region for which to retrieve Batch service quotas.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564139 = path.getOrDefault("locationName")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "locationName", valid_564139
  var valid_564140 = path.getOrDefault("subscriptionId")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "subscriptionId", valid_564140
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564141 = query.getOrDefault("api-version")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "api-version", valid_564141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564142: Call_LocationGetQuotas_564136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Batch service quotas for the specified subscription at the given location.
  ## 
  let valid = call_564142.validator(path, query, header, formData, body)
  let scheme = call_564142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564142.url(scheme.get, call_564142.host, call_564142.base,
                         call_564142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564142, url, valid)

proc call*(call_564143: Call_LocationGetQuotas_564136; apiVersion: string;
          locationName: string; subscriptionId: string): Recallable =
  ## locationGetQuotas
  ## Gets the Batch service quotas for the specified subscription at the given location.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   locationName: string (required)
  ##               : The region for which to retrieve Batch service quotas.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  var path_564144 = newJObject()
  var query_564145 = newJObject()
  add(query_564145, "api-version", newJString(apiVersion))
  add(path_564144, "locationName", newJString(locationName))
  add(path_564144, "subscriptionId", newJString(subscriptionId))
  result = call_564143.call(path_564144, query_564145, nil, nil, nil)

var locationGetQuotas* = Call_LocationGetQuotas_564136(name: "locationGetQuotas",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Batch/locations/{locationName}/quotas",
    validator: validate_LocationGetQuotas_564137, base: "",
    url: url_LocationGetQuotas_564138, schemes: {Scheme.Https})
type
  Call_BatchAccountListByResourceGroup_564146 = ref object of OpenApiRestCall_563564
proc url_BatchAccountListByResourceGroup_564148(protocol: Scheme; host: string;
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

proc validate_BatchAccountListByResourceGroup_564147(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the Batch accounts associated with the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564149 = path.getOrDefault("subscriptionId")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "subscriptionId", valid_564149
  var valid_564150 = path.getOrDefault("resourceGroupName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "resourceGroupName", valid_564150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564151 = query.getOrDefault("api-version")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "api-version", valid_564151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564152: Call_BatchAccountListByResourceGroup_564146;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the Batch accounts associated with the specified resource group.
  ## 
  let valid = call_564152.validator(path, query, header, formData, body)
  let scheme = call_564152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564152.url(scheme.get, call_564152.host, call_564152.base,
                         call_564152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564152, url, valid)

proc call*(call_564153: Call_BatchAccountListByResourceGroup_564146;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## batchAccountListByResourceGroup
  ## Gets information about the Batch accounts associated with the specified resource group.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  var path_564154 = newJObject()
  var query_564155 = newJObject()
  add(query_564155, "api-version", newJString(apiVersion))
  add(path_564154, "subscriptionId", newJString(subscriptionId))
  add(path_564154, "resourceGroupName", newJString(resourceGroupName))
  result = call_564153.call(path_564154, query_564155, nil, nil, nil)

var batchAccountListByResourceGroup* = Call_BatchAccountListByResourceGroup_564146(
    name: "batchAccountListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts",
    validator: validate_BatchAccountListByResourceGroup_564147, base: "",
    url: url_BatchAccountListByResourceGroup_564148, schemes: {Scheme.Https})
type
  Call_BatchAccountCreate_564167 = ref object of OpenApiRestCall_563564
proc url_BatchAccountCreate_564169(protocol: Scheme; host: string; base: string;
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

proc validate_BatchAccountCreate_564168(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a new Batch account with the specified parameters. Existing accounts cannot be updated with this API and should instead be updated with the Update Batch Account API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : A name for the Batch account which must be unique within the region. Batch account names must be between 3 and 24 characters in length and must use only numbers and lowercase letters. This name is used as part of the DNS name that is used to access the Batch service in the region in which the account is created. For example: http://accountname.region.batch.azure.com/.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564170 = path.getOrDefault("subscriptionId")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "subscriptionId", valid_564170
  var valid_564171 = path.getOrDefault("resourceGroupName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "resourceGroupName", valid_564171
  var valid_564172 = path.getOrDefault("accountName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "accountName", valid_564172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564173 = query.getOrDefault("api-version")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "api-version", valid_564173
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

proc call*(call_564175: Call_BatchAccountCreate_564167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Batch account with the specified parameters. Existing accounts cannot be updated with this API and should instead be updated with the Update Batch Account API.
  ## 
  let valid = call_564175.validator(path, query, header, formData, body)
  let scheme = call_564175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564175.url(scheme.get, call_564175.host, call_564175.base,
                         call_564175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564175, url, valid)

proc call*(call_564176: Call_BatchAccountCreate_564167; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## batchAccountCreate
  ## Creates a new Batch account with the specified parameters. Existing accounts cannot be updated with this API and should instead be updated with the Update Batch Account API.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   parameters: JObject (required)
  ##             : Additional parameters for account creation.
  ##   accountName: string (required)
  ##              : A name for the Batch account which must be unique within the region. Batch account names must be between 3 and 24 characters in length and must use only numbers and lowercase letters. This name is used as part of the DNS name that is used to access the Batch service in the region in which the account is created. For example: http://accountname.region.batch.azure.com/.
  var path_564177 = newJObject()
  var query_564178 = newJObject()
  var body_564179 = newJObject()
  add(query_564178, "api-version", newJString(apiVersion))
  add(path_564177, "subscriptionId", newJString(subscriptionId))
  add(path_564177, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564179 = parameters
  add(path_564177, "accountName", newJString(accountName))
  result = call_564176.call(path_564177, query_564178, nil, nil, body_564179)

var batchAccountCreate* = Call_BatchAccountCreate_564167(
    name: "batchAccountCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}",
    validator: validate_BatchAccountCreate_564168, base: "",
    url: url_BatchAccountCreate_564169, schemes: {Scheme.Https})
type
  Call_BatchAccountGet_564156 = ref object of OpenApiRestCall_563564
proc url_BatchAccountGet_564158(protocol: Scheme; host: string; base: string;
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

proc validate_BatchAccountGet_564157(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets information about the specified Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564159 = path.getOrDefault("subscriptionId")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "subscriptionId", valid_564159
  var valid_564160 = path.getOrDefault("resourceGroupName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "resourceGroupName", valid_564160
  var valid_564161 = path.getOrDefault("accountName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "accountName", valid_564161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564162 = query.getOrDefault("api-version")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "api-version", valid_564162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564163: Call_BatchAccountGet_564156; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified Batch account.
  ## 
  let valid = call_564163.validator(path, query, header, formData, body)
  let scheme = call_564163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564163.url(scheme.get, call_564163.host, call_564163.base,
                         call_564163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564163, url, valid)

proc call*(call_564164: Call_BatchAccountGet_564156; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## batchAccountGet
  ## Gets information about the specified Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564165 = newJObject()
  var query_564166 = newJObject()
  add(query_564166, "api-version", newJString(apiVersion))
  add(path_564165, "subscriptionId", newJString(subscriptionId))
  add(path_564165, "resourceGroupName", newJString(resourceGroupName))
  add(path_564165, "accountName", newJString(accountName))
  result = call_564164.call(path_564165, query_564166, nil, nil, nil)

var batchAccountGet* = Call_BatchAccountGet_564156(name: "batchAccountGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}",
    validator: validate_BatchAccountGet_564157, base: "", url: url_BatchAccountGet_564158,
    schemes: {Scheme.Https})
type
  Call_BatchAccountUpdate_564191 = ref object of OpenApiRestCall_563564
proc url_BatchAccountUpdate_564193(protocol: Scheme; host: string; base: string;
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

proc validate_BatchAccountUpdate_564192(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the properties of an existing Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564194 = path.getOrDefault("subscriptionId")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "subscriptionId", valid_564194
  var valid_564195 = path.getOrDefault("resourceGroupName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "resourceGroupName", valid_564195
  var valid_564196 = path.getOrDefault("accountName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "accountName", valid_564196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564197 = query.getOrDefault("api-version")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "api-version", valid_564197
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

proc call*(call_564199: Call_BatchAccountUpdate_564191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing Batch account.
  ## 
  let valid = call_564199.validator(path, query, header, formData, body)
  let scheme = call_564199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564199.url(scheme.get, call_564199.host, call_564199.base,
                         call_564199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564199, url, valid)

proc call*(call_564200: Call_BatchAccountUpdate_564191; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## batchAccountUpdate
  ## Updates the properties of an existing Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   parameters: JObject (required)
  ##             : Additional parameters for account update.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564201 = newJObject()
  var query_564202 = newJObject()
  var body_564203 = newJObject()
  add(query_564202, "api-version", newJString(apiVersion))
  add(path_564201, "subscriptionId", newJString(subscriptionId))
  add(path_564201, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564203 = parameters
  add(path_564201, "accountName", newJString(accountName))
  result = call_564200.call(path_564201, query_564202, nil, nil, body_564203)

var batchAccountUpdate* = Call_BatchAccountUpdate_564191(
    name: "batchAccountUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}",
    validator: validate_BatchAccountUpdate_564192, base: "",
    url: url_BatchAccountUpdate_564193, schemes: {Scheme.Https})
type
  Call_BatchAccountDelete_564180 = ref object of OpenApiRestCall_563564
proc url_BatchAccountDelete_564182(protocol: Scheme; host: string; base: string;
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

proc validate_BatchAccountDelete_564181(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the specified Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564183 = path.getOrDefault("subscriptionId")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "subscriptionId", valid_564183
  var valid_564184 = path.getOrDefault("resourceGroupName")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "resourceGroupName", valid_564184
  var valid_564185 = path.getOrDefault("accountName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "accountName", valid_564185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564186 = query.getOrDefault("api-version")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "api-version", valid_564186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564187: Call_BatchAccountDelete_564180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Batch account.
  ## 
  let valid = call_564187.validator(path, query, header, formData, body)
  let scheme = call_564187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564187.url(scheme.get, call_564187.host, call_564187.base,
                         call_564187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564187, url, valid)

proc call*(call_564188: Call_BatchAccountDelete_564180; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## batchAccountDelete
  ## Deletes the specified Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564189 = newJObject()
  var query_564190 = newJObject()
  add(query_564190, "api-version", newJString(apiVersion))
  add(path_564189, "subscriptionId", newJString(subscriptionId))
  add(path_564189, "resourceGroupName", newJString(resourceGroupName))
  add(path_564189, "accountName", newJString(accountName))
  result = call_564188.call(path_564189, query_564190, nil, nil, nil)

var batchAccountDelete* = Call_BatchAccountDelete_564180(
    name: "batchAccountDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}",
    validator: validate_BatchAccountDelete_564181, base: "",
    url: url_BatchAccountDelete_564182, schemes: {Scheme.Https})
type
  Call_ApplicationList_564204 = ref object of OpenApiRestCall_563564
proc url_ApplicationList_564206(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationList_564205(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists all of the applications in the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564207 = path.getOrDefault("subscriptionId")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "subscriptionId", valid_564207
  var valid_564208 = path.getOrDefault("resourceGroupName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "resourceGroupName", valid_564208
  var valid_564209 = path.getOrDefault("accountName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "accountName", valid_564209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564210 = query.getOrDefault("api-version")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "api-version", valid_564210
  var valid_564211 = query.getOrDefault("maxresults")
  valid_564211 = validateParameter(valid_564211, JInt, required = false, default = nil)
  if valid_564211 != nil:
    section.add "maxresults", valid_564211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564212: Call_ApplicationList_564204; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the applications in the specified account.
  ## 
  let valid = call_564212.validator(path, query, header, formData, body)
  let scheme = call_564212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564212.url(scheme.get, call_564212.host, call_564212.base,
                         call_564212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564212, url, valid)

proc call*(call_564213: Call_ApplicationList_564204; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string;
          maxresults: int = 0): Recallable =
  ## applicationList
  ## Lists all of the applications in the specified account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   maxresults: int
  ##             : The maximum number of items to return in the response.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564214 = newJObject()
  var query_564215 = newJObject()
  add(query_564215, "api-version", newJString(apiVersion))
  add(path_564214, "subscriptionId", newJString(subscriptionId))
  add(query_564215, "maxresults", newJInt(maxresults))
  add(path_564214, "resourceGroupName", newJString(resourceGroupName))
  add(path_564214, "accountName", newJString(accountName))
  result = call_564213.call(path_564214, query_564215, nil, nil, nil)

var applicationList* = Call_ApplicationList_564204(name: "applicationList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications",
    validator: validate_ApplicationList_564205, base: "", url: url_ApplicationList_564206,
    schemes: {Scheme.Https})
type
  Call_ApplicationCreate_564228 = ref object of OpenApiRestCall_563564
proc url_ApplicationCreate_564230(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationCreate_564229(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Adds an application to the specified Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564231 = path.getOrDefault("applicationName")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "applicationName", valid_564231
  var valid_564232 = path.getOrDefault("subscriptionId")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "subscriptionId", valid_564232
  var valid_564233 = path.getOrDefault("resourceGroupName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "resourceGroupName", valid_564233
  var valid_564234 = path.getOrDefault("accountName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "accountName", valid_564234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564235 = query.getOrDefault("api-version")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "api-version", valid_564235
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

proc call*(call_564237: Call_ApplicationCreate_564228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an application to the specified Batch account.
  ## 
  let valid = call_564237.validator(path, query, header, formData, body)
  let scheme = call_564237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564237.url(scheme.get, call_564237.host, call_564237.base,
                         call_564237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564237, url, valid)

proc call*(call_564238: Call_ApplicationCreate_564228; apiVersion: string;
          applicationName: string; subscriptionId: string;
          resourceGroupName: string; accountName: string; parameters: JsonNode = nil): Recallable =
  ## applicationCreate
  ## Adds an application to the specified Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   parameters: JObject
  ##             : The parameters for the request.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564239 = newJObject()
  var query_564240 = newJObject()
  var body_564241 = newJObject()
  add(query_564240, "api-version", newJString(apiVersion))
  add(path_564239, "applicationName", newJString(applicationName))
  add(path_564239, "subscriptionId", newJString(subscriptionId))
  add(path_564239, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564241 = parameters
  add(path_564239, "accountName", newJString(accountName))
  result = call_564238.call(path_564239, query_564240, nil, nil, body_564241)

var applicationCreate* = Call_ApplicationCreate_564228(name: "applicationCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}",
    validator: validate_ApplicationCreate_564229, base: "",
    url: url_ApplicationCreate_564230, schemes: {Scheme.Https})
type
  Call_ApplicationGet_564216 = ref object of OpenApiRestCall_563564
proc url_ApplicationGet_564218(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGet_564217(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about the specified application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564219 = path.getOrDefault("applicationName")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "applicationName", valid_564219
  var valid_564220 = path.getOrDefault("subscriptionId")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "subscriptionId", valid_564220
  var valid_564221 = path.getOrDefault("resourceGroupName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "resourceGroupName", valid_564221
  var valid_564222 = path.getOrDefault("accountName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "accountName", valid_564222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564223 = query.getOrDefault("api-version")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "api-version", valid_564223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564224: Call_ApplicationGet_564216; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified application.
  ## 
  let valid = call_564224.validator(path, query, header, formData, body)
  let scheme = call_564224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564224.url(scheme.get, call_564224.host, call_564224.base,
                         call_564224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564224, url, valid)

proc call*(call_564225: Call_ApplicationGet_564216; apiVersion: string;
          applicationName: string; subscriptionId: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## applicationGet
  ## Gets information about the specified application.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564226 = newJObject()
  var query_564227 = newJObject()
  add(query_564227, "api-version", newJString(apiVersion))
  add(path_564226, "applicationName", newJString(applicationName))
  add(path_564226, "subscriptionId", newJString(subscriptionId))
  add(path_564226, "resourceGroupName", newJString(resourceGroupName))
  add(path_564226, "accountName", newJString(accountName))
  result = call_564225.call(path_564226, query_564227, nil, nil, nil)

var applicationGet* = Call_ApplicationGet_564216(name: "applicationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}",
    validator: validate_ApplicationGet_564217, base: "", url: url_ApplicationGet_564218,
    schemes: {Scheme.Https})
type
  Call_ApplicationUpdate_564254 = ref object of OpenApiRestCall_563564
proc url_ApplicationUpdate_564256(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationUpdate_564255(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates settings for the specified application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564257 = path.getOrDefault("applicationName")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "applicationName", valid_564257
  var valid_564258 = path.getOrDefault("subscriptionId")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "subscriptionId", valid_564258
  var valid_564259 = path.getOrDefault("resourceGroupName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "resourceGroupName", valid_564259
  var valid_564260 = path.getOrDefault("accountName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "accountName", valid_564260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564261 = query.getOrDefault("api-version")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "api-version", valid_564261
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

proc call*(call_564263: Call_ApplicationUpdate_564254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates settings for the specified application.
  ## 
  let valid = call_564263.validator(path, query, header, formData, body)
  let scheme = call_564263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564263.url(scheme.get, call_564263.host, call_564263.base,
                         call_564263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564263, url, valid)

proc call*(call_564264: Call_ApplicationUpdate_564254; apiVersion: string;
          applicationName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode; accountName: string): Recallable =
  ## applicationUpdate
  ## Updates settings for the specified application.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   parameters: JObject (required)
  ##             : The parameters for the request.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564265 = newJObject()
  var query_564266 = newJObject()
  var body_564267 = newJObject()
  add(query_564266, "api-version", newJString(apiVersion))
  add(path_564265, "applicationName", newJString(applicationName))
  add(path_564265, "subscriptionId", newJString(subscriptionId))
  add(path_564265, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564267 = parameters
  add(path_564265, "accountName", newJString(accountName))
  result = call_564264.call(path_564265, query_564266, nil, nil, body_564267)

var applicationUpdate* = Call_ApplicationUpdate_564254(name: "applicationUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}",
    validator: validate_ApplicationUpdate_564255, base: "",
    url: url_ApplicationUpdate_564256, schemes: {Scheme.Https})
type
  Call_ApplicationDelete_564242 = ref object of OpenApiRestCall_563564
proc url_ApplicationDelete_564244(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationDelete_564243(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564245 = path.getOrDefault("applicationName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "applicationName", valid_564245
  var valid_564246 = path.getOrDefault("subscriptionId")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "subscriptionId", valid_564246
  var valid_564247 = path.getOrDefault("resourceGroupName")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "resourceGroupName", valid_564247
  var valid_564248 = path.getOrDefault("accountName")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "accountName", valid_564248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564249 = query.getOrDefault("api-version")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "api-version", valid_564249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564250: Call_ApplicationDelete_564242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application.
  ## 
  let valid = call_564250.validator(path, query, header, formData, body)
  let scheme = call_564250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564250.url(scheme.get, call_564250.host, call_564250.base,
                         call_564250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564250, url, valid)

proc call*(call_564251: Call_ApplicationDelete_564242; apiVersion: string;
          applicationName: string; subscriptionId: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## applicationDelete
  ## Deletes an application.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564252 = newJObject()
  var query_564253 = newJObject()
  add(query_564253, "api-version", newJString(apiVersion))
  add(path_564252, "applicationName", newJString(applicationName))
  add(path_564252, "subscriptionId", newJString(subscriptionId))
  add(path_564252, "resourceGroupName", newJString(resourceGroupName))
  add(path_564252, "accountName", newJString(accountName))
  result = call_564251.call(path_564252, query_564253, nil, nil, nil)

var applicationDelete* = Call_ApplicationDelete_564242(name: "applicationDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}",
    validator: validate_ApplicationDelete_564243, base: "",
    url: url_ApplicationDelete_564244, schemes: {Scheme.Https})
type
  Call_ApplicationPackageList_564268 = ref object of OpenApiRestCall_563564
proc url_ApplicationPackageList_564270(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationPackageList_564269(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the application packages in the specified application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564271 = path.getOrDefault("applicationName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "applicationName", valid_564271
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
  var valid_564274 = path.getOrDefault("accountName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "accountName", valid_564274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564275 = query.getOrDefault("api-version")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "api-version", valid_564275
  var valid_564276 = query.getOrDefault("maxresults")
  valid_564276 = validateParameter(valid_564276, JInt, required = false, default = nil)
  if valid_564276 != nil:
    section.add "maxresults", valid_564276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564277: Call_ApplicationPackageList_564268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the application packages in the specified application.
  ## 
  let valid = call_564277.validator(path, query, header, formData, body)
  let scheme = call_564277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564277.url(scheme.get, call_564277.host, call_564277.base,
                         call_564277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564277, url, valid)

proc call*(call_564278: Call_ApplicationPackageList_564268; apiVersion: string;
          applicationName: string; subscriptionId: string;
          resourceGroupName: string; accountName: string; maxresults: int = 0): Recallable =
  ## applicationPackageList
  ## Lists all of the application packages in the specified application.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   maxresults: int
  ##             : The maximum number of items to return in the response.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564279 = newJObject()
  var query_564280 = newJObject()
  add(query_564280, "api-version", newJString(apiVersion))
  add(path_564279, "applicationName", newJString(applicationName))
  add(path_564279, "subscriptionId", newJString(subscriptionId))
  add(query_564280, "maxresults", newJInt(maxresults))
  add(path_564279, "resourceGroupName", newJString(resourceGroupName))
  add(path_564279, "accountName", newJString(accountName))
  result = call_564278.call(path_564279, query_564280, nil, nil, nil)

var applicationPackageList* = Call_ApplicationPackageList_564268(
    name: "applicationPackageList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}/versions",
    validator: validate_ApplicationPackageList_564269, base: "",
    url: url_ApplicationPackageList_564270, schemes: {Scheme.Https})
type
  Call_ApplicationPackageCreate_564294 = ref object of OpenApiRestCall_563564
proc url_ApplicationPackageCreate_564296(protocol: Scheme; host: string;
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

proc validate_ApplicationPackageCreate_564295(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an application package record. The record contains the SAS where the package should be uploaded to.  Once it is uploaded the `ApplicationPackage` needs to be activated using `ApplicationPackageActive` before it can be used.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   versionName: JString (required)
  ##              : The version of the application.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564297 = path.getOrDefault("applicationName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "applicationName", valid_564297
  var valid_564298 = path.getOrDefault("subscriptionId")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "subscriptionId", valid_564298
  var valid_564299 = path.getOrDefault("versionName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "versionName", valid_564299
  var valid_564300 = path.getOrDefault("resourceGroupName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "resourceGroupName", valid_564300
  var valid_564301 = path.getOrDefault("accountName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "accountName", valid_564301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564302 = query.getOrDefault("api-version")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "api-version", valid_564302
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

proc call*(call_564304: Call_ApplicationPackageCreate_564294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an application package record. The record contains the SAS where the package should be uploaded to.  Once it is uploaded the `ApplicationPackage` needs to be activated using `ApplicationPackageActive` before it can be used.
  ## 
  let valid = call_564304.validator(path, query, header, formData, body)
  let scheme = call_564304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564304.url(scheme.get, call_564304.host, call_564304.base,
                         call_564304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564304, url, valid)

proc call*(call_564305: Call_ApplicationPackageCreate_564294; apiVersion: string;
          applicationName: string; subscriptionId: string; versionName: string;
          resourceGroupName: string; accountName: string; parameters: JsonNode = nil): Recallable =
  ## applicationPackageCreate
  ## Creates an application package record. The record contains the SAS where the package should be uploaded to.  Once it is uploaded the `ApplicationPackage` needs to be activated using `ApplicationPackageActive` before it can be used.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   versionName: string (required)
  ##              : The version of the application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   parameters: JObject
  ##             : The parameters for the request.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564306 = newJObject()
  var query_564307 = newJObject()
  var body_564308 = newJObject()
  add(query_564307, "api-version", newJString(apiVersion))
  add(path_564306, "applicationName", newJString(applicationName))
  add(path_564306, "subscriptionId", newJString(subscriptionId))
  add(path_564306, "versionName", newJString(versionName))
  add(path_564306, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564308 = parameters
  add(path_564306, "accountName", newJString(accountName))
  result = call_564305.call(path_564306, query_564307, nil, nil, body_564308)

var applicationPackageCreate* = Call_ApplicationPackageCreate_564294(
    name: "applicationPackageCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}/versions/{versionName}",
    validator: validate_ApplicationPackageCreate_564295, base: "",
    url: url_ApplicationPackageCreate_564296, schemes: {Scheme.Https})
type
  Call_ApplicationPackageGet_564281 = ref object of OpenApiRestCall_563564
proc url_ApplicationPackageGet_564283(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationPackageGet_564282(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified application package.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   versionName: JString (required)
  ##              : The version of the application.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564284 = path.getOrDefault("applicationName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "applicationName", valid_564284
  var valid_564285 = path.getOrDefault("subscriptionId")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "subscriptionId", valid_564285
  var valid_564286 = path.getOrDefault("versionName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "versionName", valid_564286
  var valid_564287 = path.getOrDefault("resourceGroupName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "resourceGroupName", valid_564287
  var valid_564288 = path.getOrDefault("accountName")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "accountName", valid_564288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
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

proc call*(call_564290: Call_ApplicationPackageGet_564281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified application package.
  ## 
  let valid = call_564290.validator(path, query, header, formData, body)
  let scheme = call_564290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564290.url(scheme.get, call_564290.host, call_564290.base,
                         call_564290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564290, url, valid)

proc call*(call_564291: Call_ApplicationPackageGet_564281; apiVersion: string;
          applicationName: string; subscriptionId: string; versionName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## applicationPackageGet
  ## Gets information about the specified application package.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   versionName: string (required)
  ##              : The version of the application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564292 = newJObject()
  var query_564293 = newJObject()
  add(query_564293, "api-version", newJString(apiVersion))
  add(path_564292, "applicationName", newJString(applicationName))
  add(path_564292, "subscriptionId", newJString(subscriptionId))
  add(path_564292, "versionName", newJString(versionName))
  add(path_564292, "resourceGroupName", newJString(resourceGroupName))
  add(path_564292, "accountName", newJString(accountName))
  result = call_564291.call(path_564292, query_564293, nil, nil, nil)

var applicationPackageGet* = Call_ApplicationPackageGet_564281(
    name: "applicationPackageGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}/versions/{versionName}",
    validator: validate_ApplicationPackageGet_564282, base: "",
    url: url_ApplicationPackageGet_564283, schemes: {Scheme.Https})
type
  Call_ApplicationPackageDelete_564309 = ref object of OpenApiRestCall_563564
proc url_ApplicationPackageDelete_564311(protocol: Scheme; host: string;
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

proc validate_ApplicationPackageDelete_564310(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an application package record and its associated binary file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   versionName: JString (required)
  ##              : The version of the application.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564312 = path.getOrDefault("applicationName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "applicationName", valid_564312
  var valid_564313 = path.getOrDefault("subscriptionId")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "subscriptionId", valid_564313
  var valid_564314 = path.getOrDefault("versionName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "versionName", valid_564314
  var valid_564315 = path.getOrDefault("resourceGroupName")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "resourceGroupName", valid_564315
  var valid_564316 = path.getOrDefault("accountName")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "accountName", valid_564316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564317 = query.getOrDefault("api-version")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "api-version", valid_564317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564318: Call_ApplicationPackageDelete_564309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application package record and its associated binary file.
  ## 
  let valid = call_564318.validator(path, query, header, formData, body)
  let scheme = call_564318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564318.url(scheme.get, call_564318.host, call_564318.base,
                         call_564318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564318, url, valid)

proc call*(call_564319: Call_ApplicationPackageDelete_564309; apiVersion: string;
          applicationName: string; subscriptionId: string; versionName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## applicationPackageDelete
  ## Deletes an application package record and its associated binary file.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   versionName: string (required)
  ##              : The version of the application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564320 = newJObject()
  var query_564321 = newJObject()
  add(query_564321, "api-version", newJString(apiVersion))
  add(path_564320, "applicationName", newJString(applicationName))
  add(path_564320, "subscriptionId", newJString(subscriptionId))
  add(path_564320, "versionName", newJString(versionName))
  add(path_564320, "resourceGroupName", newJString(resourceGroupName))
  add(path_564320, "accountName", newJString(accountName))
  result = call_564319.call(path_564320, query_564321, nil, nil, nil)

var applicationPackageDelete* = Call_ApplicationPackageDelete_564309(
    name: "applicationPackageDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}/versions/{versionName}",
    validator: validate_ApplicationPackageDelete_564310, base: "",
    url: url_ApplicationPackageDelete_564311, schemes: {Scheme.Https})
type
  Call_ApplicationPackageActivate_564322 = ref object of OpenApiRestCall_563564
proc url_ApplicationPackageActivate_564324(protocol: Scheme; host: string;
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

proc validate_ApplicationPackageActivate_564323(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Activates the specified application package. This should be done after the `ApplicationPackage` was created and uploaded. This needs to be done before an `ApplicationPackage` can be used on Pools or Tasks
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   versionName: JString (required)
  ##              : The version of the application.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564325 = path.getOrDefault("applicationName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "applicationName", valid_564325
  var valid_564326 = path.getOrDefault("subscriptionId")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "subscriptionId", valid_564326
  var valid_564327 = path.getOrDefault("versionName")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "versionName", valid_564327
  var valid_564328 = path.getOrDefault("resourceGroupName")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "resourceGroupName", valid_564328
  var valid_564329 = path.getOrDefault("accountName")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "accountName", valid_564329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564330 = query.getOrDefault("api-version")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "api-version", valid_564330
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

proc call*(call_564332: Call_ApplicationPackageActivate_564322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activates the specified application package. This should be done after the `ApplicationPackage` was created and uploaded. This needs to be done before an `ApplicationPackage` can be used on Pools or Tasks
  ## 
  let valid = call_564332.validator(path, query, header, formData, body)
  let scheme = call_564332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564332.url(scheme.get, call_564332.host, call_564332.base,
                         call_564332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564332, url, valid)

proc call*(call_564333: Call_ApplicationPackageActivate_564322; apiVersion: string;
          applicationName: string; subscriptionId: string; versionName: string;
          resourceGroupName: string; parameters: JsonNode; accountName: string): Recallable =
  ## applicationPackageActivate
  ## Activates the specified application package. This should be done after the `ApplicationPackage` was created and uploaded. This needs to be done before an `ApplicationPackage` can be used on Pools or Tasks
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   applicationName: string (required)
  ##                  : The name of the application. This must be unique within the account.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   versionName: string (required)
  ##              : The version of the application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   parameters: JObject (required)
  ##             : The parameters for the request.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564334 = newJObject()
  var query_564335 = newJObject()
  var body_564336 = newJObject()
  add(query_564335, "api-version", newJString(apiVersion))
  add(path_564334, "applicationName", newJString(applicationName))
  add(path_564334, "subscriptionId", newJString(subscriptionId))
  add(path_564334, "versionName", newJString(versionName))
  add(path_564334, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564336 = parameters
  add(path_564334, "accountName", newJString(accountName))
  result = call_564333.call(path_564334, query_564335, nil, nil, body_564336)

var applicationPackageActivate* = Call_ApplicationPackageActivate_564322(
    name: "applicationPackageActivate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationName}/versions/{versionName}/activate",
    validator: validate_ApplicationPackageActivate_564323, base: "",
    url: url_ApplicationPackageActivate_564324, schemes: {Scheme.Https})
type
  Call_CertificateListByBatchAccount_564337 = ref object of OpenApiRestCall_563564
proc url_CertificateListByBatchAccount_564339(protocol: Scheme; host: string;
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

proc validate_CertificateListByBatchAccount_564338(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the certificates in the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564341 = path.getOrDefault("subscriptionId")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "subscriptionId", valid_564341
  var valid_564342 = path.getOrDefault("resourceGroupName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "resourceGroupName", valid_564342
  var valid_564343 = path.getOrDefault("accountName")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "accountName", valid_564343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  ##   $select: JString
  ##          : Comma separated list of properties that should be returned. e.g. "properties/provisioningState". Only top level properties under properties/ are valid for selection.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response.
  ##   $filter: JString
  ##          : OData filter expression. Valid properties for filtering are "properties/provisioningState", "properties/provisioningStateTransitionTime", "name".
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564344 = query.getOrDefault("api-version")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "api-version", valid_564344
  var valid_564345 = query.getOrDefault("$select")
  valid_564345 = validateParameter(valid_564345, JString, required = false,
                                 default = nil)
  if valid_564345 != nil:
    section.add "$select", valid_564345
  var valid_564346 = query.getOrDefault("maxresults")
  valid_564346 = validateParameter(valid_564346, JInt, required = false, default = nil)
  if valid_564346 != nil:
    section.add "maxresults", valid_564346
  var valid_564347 = query.getOrDefault("$filter")
  valid_564347 = validateParameter(valid_564347, JString, required = false,
                                 default = nil)
  if valid_564347 != nil:
    section.add "$filter", valid_564347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564348: Call_CertificateListByBatchAccount_564337; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the certificates in the specified account.
  ## 
  let valid = call_564348.validator(path, query, header, formData, body)
  let scheme = call_564348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564348.url(scheme.get, call_564348.host, call_564348.base,
                         call_564348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564348, url, valid)

proc call*(call_564349: Call_CertificateListByBatchAccount_564337;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string; Select: string = ""; maxresults: int = 0;
          Filter: string = ""): Recallable =
  ## certificateListByBatchAccount
  ## Lists all of the certificates in the specified account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   Select: string
  ##         : Comma separated list of properties that should be returned. e.g. "properties/provisioningState". Only top level properties under properties/ are valid for selection.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   maxresults: int
  ##             : The maximum number of items to return in the response.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   Filter: string
  ##         : OData filter expression. Valid properties for filtering are "properties/provisioningState", "properties/provisioningStateTransitionTime", "name".
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564350 = newJObject()
  var query_564351 = newJObject()
  add(query_564351, "api-version", newJString(apiVersion))
  add(query_564351, "$select", newJString(Select))
  add(path_564350, "subscriptionId", newJString(subscriptionId))
  add(query_564351, "maxresults", newJInt(maxresults))
  add(path_564350, "resourceGroupName", newJString(resourceGroupName))
  add(query_564351, "$filter", newJString(Filter))
  add(path_564350, "accountName", newJString(accountName))
  result = call_564349.call(path_564350, query_564351, nil, nil, nil)

var certificateListByBatchAccount* = Call_CertificateListByBatchAccount_564337(
    name: "certificateListByBatchAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates",
    validator: validate_CertificateListByBatchAccount_564338, base: "",
    url: url_CertificateListByBatchAccount_564339, schemes: {Scheme.Https})
type
  Call_CertificateCreate_564364 = ref object of OpenApiRestCall_563564
proc url_CertificateCreate_564366(protocol: Scheme; host: string; base: string;
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

proc validate_CertificateCreate_564365(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a new certificate inside the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  ##   certificateName: JString (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564367 = path.getOrDefault("subscriptionId")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "subscriptionId", valid_564367
  var valid_564368 = path.getOrDefault("resourceGroupName")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "resourceGroupName", valid_564368
  var valid_564369 = path.getOrDefault("accountName")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "accountName", valid_564369
  var valid_564370 = path.getOrDefault("certificateName")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "certificateName", valid_564370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564371 = query.getOrDefault("api-version")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "api-version", valid_564371
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new certificate to be created, but to prevent updating an existing certificate. Other values will be ignored.
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the certificate to update. A value of "*" can be used to apply the operation only if the certificate already exists. If omitted, this operation will always be applied.
  section = newJObject()
  var valid_564372 = header.getOrDefault("If-None-Match")
  valid_564372 = validateParameter(valid_564372, JString, required = false,
                                 default = nil)
  if valid_564372 != nil:
    section.add "If-None-Match", valid_564372
  var valid_564373 = header.getOrDefault("If-Match")
  valid_564373 = validateParameter(valid_564373, JString, required = false,
                                 default = nil)
  if valid_564373 != nil:
    section.add "If-Match", valid_564373
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

proc call*(call_564375: Call_CertificateCreate_564364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new certificate inside the specified account.
  ## 
  let valid = call_564375.validator(path, query, header, formData, body)
  let scheme = call_564375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564375.url(scheme.get, call_564375.host, call_564375.base,
                         call_564375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564375, url, valid)

proc call*(call_564376: Call_CertificateCreate_564364; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode;
          accountName: string; certificateName: string): Recallable =
  ## certificateCreate
  ## Creates a new certificate inside the specified account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   parameters: JObject (required)
  ##             : Additional parameters for certificate creation.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  ##   certificateName: string (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  var path_564377 = newJObject()
  var query_564378 = newJObject()
  var body_564379 = newJObject()
  add(query_564378, "api-version", newJString(apiVersion))
  add(path_564377, "subscriptionId", newJString(subscriptionId))
  add(path_564377, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564379 = parameters
  add(path_564377, "accountName", newJString(accountName))
  add(path_564377, "certificateName", newJString(certificateName))
  result = call_564376.call(path_564377, query_564378, nil, nil, body_564379)

var certificateCreate* = Call_CertificateCreate_564364(name: "certificateCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates/{certificateName}",
    validator: validate_CertificateCreate_564365, base: "",
    url: url_CertificateCreate_564366, schemes: {Scheme.Https})
type
  Call_CertificateGet_564352 = ref object of OpenApiRestCall_563564
proc url_CertificateGet_564354(protocol: Scheme; host: string; base: string;
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

proc validate_CertificateGet_564353(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about the specified certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  ##   certificateName: JString (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564355 = path.getOrDefault("subscriptionId")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "subscriptionId", valid_564355
  var valid_564356 = path.getOrDefault("resourceGroupName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "resourceGroupName", valid_564356
  var valid_564357 = path.getOrDefault("accountName")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "accountName", valid_564357
  var valid_564358 = path.getOrDefault("certificateName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "certificateName", valid_564358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564359 = query.getOrDefault("api-version")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "api-version", valid_564359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564360: Call_CertificateGet_564352; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified certificate.
  ## 
  let valid = call_564360.validator(path, query, header, formData, body)
  let scheme = call_564360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564360.url(scheme.get, call_564360.host, call_564360.base,
                         call_564360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564360, url, valid)

proc call*(call_564361: Call_CertificateGet_564352; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string;
          certificateName: string): Recallable =
  ## certificateGet
  ## Gets information about the specified certificate.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  ##   certificateName: string (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  var path_564362 = newJObject()
  var query_564363 = newJObject()
  add(query_564363, "api-version", newJString(apiVersion))
  add(path_564362, "subscriptionId", newJString(subscriptionId))
  add(path_564362, "resourceGroupName", newJString(resourceGroupName))
  add(path_564362, "accountName", newJString(accountName))
  add(path_564362, "certificateName", newJString(certificateName))
  result = call_564361.call(path_564362, query_564363, nil, nil, nil)

var certificateGet* = Call_CertificateGet_564352(name: "certificateGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates/{certificateName}",
    validator: validate_CertificateGet_564353, base: "", url: url_CertificateGet_564354,
    schemes: {Scheme.Https})
type
  Call_CertificateUpdate_564392 = ref object of OpenApiRestCall_563564
proc url_CertificateUpdate_564394(protocol: Scheme; host: string; base: string;
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

proc validate_CertificateUpdate_564393(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the properties of an existing certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  ##   certificateName: JString (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564395 = path.getOrDefault("subscriptionId")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "subscriptionId", valid_564395
  var valid_564396 = path.getOrDefault("resourceGroupName")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "resourceGroupName", valid_564396
  var valid_564397 = path.getOrDefault("accountName")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "accountName", valid_564397
  var valid_564398 = path.getOrDefault("certificateName")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "certificateName", valid_564398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564399 = query.getOrDefault("api-version")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "api-version", valid_564399
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the certificate to update. This value can be omitted or set to "*" to apply the operation unconditionally.
  section = newJObject()
  var valid_564400 = header.getOrDefault("If-Match")
  valid_564400 = validateParameter(valid_564400, JString, required = false,
                                 default = nil)
  if valid_564400 != nil:
    section.add "If-Match", valid_564400
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

proc call*(call_564402: Call_CertificateUpdate_564392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing certificate.
  ## 
  let valid = call_564402.validator(path, query, header, formData, body)
  let scheme = call_564402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564402.url(scheme.get, call_564402.host, call_564402.base,
                         call_564402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564402, url, valid)

proc call*(call_564403: Call_CertificateUpdate_564392; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode;
          accountName: string; certificateName: string): Recallable =
  ## certificateUpdate
  ## Updates the properties of an existing certificate.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   parameters: JObject (required)
  ##             : Certificate entity to update.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  ##   certificateName: string (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  var path_564404 = newJObject()
  var query_564405 = newJObject()
  var body_564406 = newJObject()
  add(query_564405, "api-version", newJString(apiVersion))
  add(path_564404, "subscriptionId", newJString(subscriptionId))
  add(path_564404, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564406 = parameters
  add(path_564404, "accountName", newJString(accountName))
  add(path_564404, "certificateName", newJString(certificateName))
  result = call_564403.call(path_564404, query_564405, nil, nil, body_564406)

var certificateUpdate* = Call_CertificateUpdate_564392(name: "certificateUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates/{certificateName}",
    validator: validate_CertificateUpdate_564393, base: "",
    url: url_CertificateUpdate_564394, schemes: {Scheme.Https})
type
  Call_CertificateDelete_564380 = ref object of OpenApiRestCall_563564
proc url_CertificateDelete_564382(protocol: Scheme; host: string; base: string;
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

proc validate_CertificateDelete_564381(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes the specified certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  ##   certificateName: JString (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564383 = path.getOrDefault("subscriptionId")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "subscriptionId", valid_564383
  var valid_564384 = path.getOrDefault("resourceGroupName")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "resourceGroupName", valid_564384
  var valid_564385 = path.getOrDefault("accountName")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "accountName", valid_564385
  var valid_564386 = path.getOrDefault("certificateName")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "certificateName", valid_564386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564387 = query.getOrDefault("api-version")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "api-version", valid_564387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564388: Call_CertificateDelete_564380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified certificate.
  ## 
  let valid = call_564388.validator(path, query, header, formData, body)
  let scheme = call_564388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564388.url(scheme.get, call_564388.host, call_564388.base,
                         call_564388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564388, url, valid)

proc call*(call_564389: Call_CertificateDelete_564380; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string;
          certificateName: string): Recallable =
  ## certificateDelete
  ## Deletes the specified certificate.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  ##   certificateName: string (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  var path_564390 = newJObject()
  var query_564391 = newJObject()
  add(query_564391, "api-version", newJString(apiVersion))
  add(path_564390, "subscriptionId", newJString(subscriptionId))
  add(path_564390, "resourceGroupName", newJString(resourceGroupName))
  add(path_564390, "accountName", newJString(accountName))
  add(path_564390, "certificateName", newJString(certificateName))
  result = call_564389.call(path_564390, query_564391, nil, nil, nil)

var certificateDelete* = Call_CertificateDelete_564380(name: "certificateDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates/{certificateName}",
    validator: validate_CertificateDelete_564381, base: "",
    url: url_CertificateDelete_564382, schemes: {Scheme.Https})
type
  Call_CertificateCancelDeletion_564407 = ref object of OpenApiRestCall_563564
proc url_CertificateCancelDeletion_564409(protocol: Scheme; host: string;
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

proc validate_CertificateCancelDeletion_564408(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## If you try to delete a certificate that is being used by a pool or compute node, the status of the certificate changes to deleteFailed. If you decide that you want to continue using the certificate, you can use this operation to set the status of the certificate back to active. If you intend to delete the certificate, you do not need to run this operation after the deletion failed. You must make sure that the certificate is not being used by any resources, and then you can try again to delete the certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  ##   certificateName: JString (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564410 = path.getOrDefault("subscriptionId")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "subscriptionId", valid_564410
  var valid_564411 = path.getOrDefault("resourceGroupName")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "resourceGroupName", valid_564411
  var valid_564412 = path.getOrDefault("accountName")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "accountName", valid_564412
  var valid_564413 = path.getOrDefault("certificateName")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "certificateName", valid_564413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
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
  if body != nil:
    result.add "body", body

proc call*(call_564415: Call_CertificateCancelDeletion_564407; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If you try to delete a certificate that is being used by a pool or compute node, the status of the certificate changes to deleteFailed. If you decide that you want to continue using the certificate, you can use this operation to set the status of the certificate back to active. If you intend to delete the certificate, you do not need to run this operation after the deletion failed. You must make sure that the certificate is not being used by any resources, and then you can try again to delete the certificate.
  ## 
  let valid = call_564415.validator(path, query, header, formData, body)
  let scheme = call_564415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564415.url(scheme.get, call_564415.host, call_564415.base,
                         call_564415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564415, url, valid)

proc call*(call_564416: Call_CertificateCancelDeletion_564407; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string;
          certificateName: string): Recallable =
  ## certificateCancelDeletion
  ## If you try to delete a certificate that is being used by a pool or compute node, the status of the certificate changes to deleteFailed. If you decide that you want to continue using the certificate, you can use this operation to set the status of the certificate back to active. If you intend to delete the certificate, you do not need to run this operation after the deletion failed. You must make sure that the certificate is not being used by any resources, and then you can try again to delete the certificate.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  ##   certificateName: string (required)
  ##                  : The identifier for the certificate. This must be made up of algorithm and thumbprint separated by a dash, and must match the certificate data in the request. For example SHA1-a3d1c5.
  var path_564417 = newJObject()
  var query_564418 = newJObject()
  add(query_564418, "api-version", newJString(apiVersion))
  add(path_564417, "subscriptionId", newJString(subscriptionId))
  add(path_564417, "resourceGroupName", newJString(resourceGroupName))
  add(path_564417, "accountName", newJString(accountName))
  add(path_564417, "certificateName", newJString(certificateName))
  result = call_564416.call(path_564417, query_564418, nil, nil, nil)

var certificateCancelDeletion* = Call_CertificateCancelDeletion_564407(
    name: "certificateCancelDeletion", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/certificates/{certificateName}/cancelDelete",
    validator: validate_CertificateCancelDeletion_564408, base: "",
    url: url_CertificateCancelDeletion_564409, schemes: {Scheme.Https})
type
  Call_BatchAccountGetKeys_564419 = ref object of OpenApiRestCall_563564
proc url_BatchAccountGetKeys_564421(protocol: Scheme; host: string; base: string;
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

proc validate_BatchAccountGetKeys_564420(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## This operation applies only to Batch accounts created with a poolAllocationMode of 'BatchService'. If the Batch account was created with a poolAllocationMode of 'UserSubscription', clients cannot use access to keys to authenticate, and must use Azure Active Directory instead. In this case, getting the keys will fail.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564422 = path.getOrDefault("subscriptionId")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "subscriptionId", valid_564422
  var valid_564423 = path.getOrDefault("resourceGroupName")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "resourceGroupName", valid_564423
  var valid_564424 = path.getOrDefault("accountName")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "accountName", valid_564424
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564425 = query.getOrDefault("api-version")
  valid_564425 = validateParameter(valid_564425, JString, required = true,
                                 default = nil)
  if valid_564425 != nil:
    section.add "api-version", valid_564425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564426: Call_BatchAccountGetKeys_564419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation applies only to Batch accounts created with a poolAllocationMode of 'BatchService'. If the Batch account was created with a poolAllocationMode of 'UserSubscription', clients cannot use access to keys to authenticate, and must use Azure Active Directory instead. In this case, getting the keys will fail.
  ## 
  let valid = call_564426.validator(path, query, header, formData, body)
  let scheme = call_564426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564426.url(scheme.get, call_564426.host, call_564426.base,
                         call_564426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564426, url, valid)

proc call*(call_564427: Call_BatchAccountGetKeys_564419; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## batchAccountGetKeys
  ## This operation applies only to Batch accounts created with a poolAllocationMode of 'BatchService'. If the Batch account was created with a poolAllocationMode of 'UserSubscription', clients cannot use access to keys to authenticate, and must use Azure Active Directory instead. In this case, getting the keys will fail.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564428 = newJObject()
  var query_564429 = newJObject()
  add(query_564429, "api-version", newJString(apiVersion))
  add(path_564428, "subscriptionId", newJString(subscriptionId))
  add(path_564428, "resourceGroupName", newJString(resourceGroupName))
  add(path_564428, "accountName", newJString(accountName))
  result = call_564427.call(path_564428, query_564429, nil, nil, nil)

var batchAccountGetKeys* = Call_BatchAccountGetKeys_564419(
    name: "batchAccountGetKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/listKeys",
    validator: validate_BatchAccountGetKeys_564420, base: "",
    url: url_BatchAccountGetKeys_564421, schemes: {Scheme.Https})
type
  Call_PoolListByBatchAccount_564430 = ref object of OpenApiRestCall_563564
proc url_PoolListByBatchAccount_564432(protocol: Scheme; host: string; base: string;
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

proc validate_PoolListByBatchAccount_564431(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the pools in the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
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
  var valid_564435 = path.getOrDefault("accountName")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "accountName", valid_564435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  ##   $select: JString
  ##          : Comma separated list of properties that should be returned. e.g. "properties/provisioningState". Only top level properties under properties/ are valid for selection.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response.
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
  var valid_564436 = query.getOrDefault("api-version")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "api-version", valid_564436
  var valid_564437 = query.getOrDefault("$select")
  valid_564437 = validateParameter(valid_564437, JString, required = false,
                                 default = nil)
  if valid_564437 != nil:
    section.add "$select", valid_564437
  var valid_564438 = query.getOrDefault("maxresults")
  valid_564438 = validateParameter(valid_564438, JInt, required = false, default = nil)
  if valid_564438 != nil:
    section.add "maxresults", valid_564438
  var valid_564439 = query.getOrDefault("$filter")
  valid_564439 = validateParameter(valid_564439, JString, required = false,
                                 default = nil)
  if valid_564439 != nil:
    section.add "$filter", valid_564439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564440: Call_PoolListByBatchAccount_564430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the pools in the specified account.
  ## 
  let valid = call_564440.validator(path, query, header, formData, body)
  let scheme = call_564440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564440.url(scheme.get, call_564440.host, call_564440.base,
                         call_564440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564440, url, valid)

proc call*(call_564441: Call_PoolListByBatchAccount_564430; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string;
          Select: string = ""; maxresults: int = 0; Filter: string = ""): Recallable =
  ## poolListByBatchAccount
  ## Lists all of the pools in the specified account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   Select: string
  ##         : Comma separated list of properties that should be returned. e.g. "properties/provisioningState". Only top level properties under properties/ are valid for selection.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   maxresults: int
  ##             : The maximum number of items to return in the response.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
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
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564442 = newJObject()
  var query_564443 = newJObject()
  add(query_564443, "api-version", newJString(apiVersion))
  add(query_564443, "$select", newJString(Select))
  add(path_564442, "subscriptionId", newJString(subscriptionId))
  add(query_564443, "maxresults", newJInt(maxresults))
  add(path_564442, "resourceGroupName", newJString(resourceGroupName))
  add(query_564443, "$filter", newJString(Filter))
  add(path_564442, "accountName", newJString(accountName))
  result = call_564441.call(path_564442, query_564443, nil, nil, nil)

var poolListByBatchAccount* = Call_PoolListByBatchAccount_564430(
    name: "poolListByBatchAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools",
    validator: validate_PoolListByBatchAccount_564431, base: "",
    url: url_PoolListByBatchAccount_564432, schemes: {Scheme.Https})
type
  Call_PoolCreate_564456 = ref object of OpenApiRestCall_563564
proc url_PoolCreate_564458(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolCreate_564457(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new pool inside the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   poolName: JString (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564459 = path.getOrDefault("subscriptionId")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "subscriptionId", valid_564459
  var valid_564460 = path.getOrDefault("poolName")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "poolName", valid_564460
  var valid_564461 = path.getOrDefault("resourceGroupName")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = nil)
  if valid_564461 != nil:
    section.add "resourceGroupName", valid_564461
  var valid_564462 = path.getOrDefault("accountName")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "accountName", valid_564462
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564463 = query.getOrDefault("api-version")
  valid_564463 = validateParameter(valid_564463, JString, required = true,
                                 default = nil)
  if valid_564463 != nil:
    section.add "api-version", valid_564463
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new pool to be created, but to prevent updating an existing pool. Other values will be ignored.
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the pool to update. A value of "*" can be used to apply the operation only if the pool already exists. If omitted, this operation will always be applied.
  section = newJObject()
  var valid_564464 = header.getOrDefault("If-None-Match")
  valid_564464 = validateParameter(valid_564464, JString, required = false,
                                 default = nil)
  if valid_564464 != nil:
    section.add "If-None-Match", valid_564464
  var valid_564465 = header.getOrDefault("If-Match")
  valid_564465 = validateParameter(valid_564465, JString, required = false,
                                 default = nil)
  if valid_564465 != nil:
    section.add "If-Match", valid_564465
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

proc call*(call_564467: Call_PoolCreate_564456; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new pool inside the specified account.
  ## 
  let valid = call_564467.validator(path, query, header, formData, body)
  let scheme = call_564467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564467.url(scheme.get, call_564467.host, call_564467.base,
                         call_564467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564467, url, valid)

proc call*(call_564468: Call_PoolCreate_564456; apiVersion: string;
          subscriptionId: string; poolName: string; resourceGroupName: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## poolCreate
  ## Creates a new pool inside the specified account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   poolName: string (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   parameters: JObject (required)
  ##             : Additional parameters for pool creation.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564469 = newJObject()
  var query_564470 = newJObject()
  var body_564471 = newJObject()
  add(query_564470, "api-version", newJString(apiVersion))
  add(path_564469, "subscriptionId", newJString(subscriptionId))
  add(path_564469, "poolName", newJString(poolName))
  add(path_564469, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564471 = parameters
  add(path_564469, "accountName", newJString(accountName))
  result = call_564468.call(path_564469, query_564470, nil, nil, body_564471)

var poolCreate* = Call_PoolCreate_564456(name: "poolCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}",
                                      validator: validate_PoolCreate_564457,
                                      base: "", url: url_PoolCreate_564458,
                                      schemes: {Scheme.Https})
type
  Call_PoolGet_564444 = ref object of OpenApiRestCall_563564
proc url_PoolGet_564446(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolGet_564445(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   poolName: JString (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564447 = path.getOrDefault("subscriptionId")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "subscriptionId", valid_564447
  var valid_564448 = path.getOrDefault("poolName")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "poolName", valid_564448
  var valid_564449 = path.getOrDefault("resourceGroupName")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "resourceGroupName", valid_564449
  var valid_564450 = path.getOrDefault("accountName")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "accountName", valid_564450
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564451 = query.getOrDefault("api-version")
  valid_564451 = validateParameter(valid_564451, JString, required = true,
                                 default = nil)
  if valid_564451 != nil:
    section.add "api-version", valid_564451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564452: Call_PoolGet_564444; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified pool.
  ## 
  let valid = call_564452.validator(path, query, header, formData, body)
  let scheme = call_564452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564452.url(scheme.get, call_564452.host, call_564452.base,
                         call_564452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564452, url, valid)

proc call*(call_564453: Call_PoolGet_564444; apiVersion: string;
          subscriptionId: string; poolName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## poolGet
  ## Gets information about the specified pool.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   poolName: string (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564454 = newJObject()
  var query_564455 = newJObject()
  add(query_564455, "api-version", newJString(apiVersion))
  add(path_564454, "subscriptionId", newJString(subscriptionId))
  add(path_564454, "poolName", newJString(poolName))
  add(path_564454, "resourceGroupName", newJString(resourceGroupName))
  add(path_564454, "accountName", newJString(accountName))
  result = call_564453.call(path_564454, query_564455, nil, nil, nil)

var poolGet* = Call_PoolGet_564444(name: "poolGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}",
                                validator: validate_PoolGet_564445, base: "",
                                url: url_PoolGet_564446, schemes: {Scheme.Https})
type
  Call_PoolUpdate_564484 = ref object of OpenApiRestCall_563564
proc url_PoolUpdate_564486(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolUpdate_564485(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the properties of an existing pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   poolName: JString (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564487 = path.getOrDefault("subscriptionId")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "subscriptionId", valid_564487
  var valid_564488 = path.getOrDefault("poolName")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "poolName", valid_564488
  var valid_564489 = path.getOrDefault("resourceGroupName")
  valid_564489 = validateParameter(valid_564489, JString, required = true,
                                 default = nil)
  if valid_564489 != nil:
    section.add "resourceGroupName", valid_564489
  var valid_564490 = path.getOrDefault("accountName")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "accountName", valid_564490
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564491 = query.getOrDefault("api-version")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "api-version", valid_564491
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the pool to update. This value can be omitted or set to "*" to apply the operation unconditionally.
  section = newJObject()
  var valid_564492 = header.getOrDefault("If-Match")
  valid_564492 = validateParameter(valid_564492, JString, required = false,
                                 default = nil)
  if valid_564492 != nil:
    section.add "If-Match", valid_564492
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

proc call*(call_564494: Call_PoolUpdate_564484; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing pool.
  ## 
  let valid = call_564494.validator(path, query, header, formData, body)
  let scheme = call_564494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564494.url(scheme.get, call_564494.host, call_564494.base,
                         call_564494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564494, url, valid)

proc call*(call_564495: Call_PoolUpdate_564484; apiVersion: string;
          subscriptionId: string; poolName: string; resourceGroupName: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## poolUpdate
  ## Updates the properties of an existing pool.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   poolName: string (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   parameters: JObject (required)
  ##             : Pool properties that should be updated. Properties that are supplied will be updated, any property not supplied will be unchanged.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564496 = newJObject()
  var query_564497 = newJObject()
  var body_564498 = newJObject()
  add(query_564497, "api-version", newJString(apiVersion))
  add(path_564496, "subscriptionId", newJString(subscriptionId))
  add(path_564496, "poolName", newJString(poolName))
  add(path_564496, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564498 = parameters
  add(path_564496, "accountName", newJString(accountName))
  result = call_564495.call(path_564496, query_564497, nil, nil, body_564498)

var poolUpdate* = Call_PoolUpdate_564484(name: "poolUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}",
                                      validator: validate_PoolUpdate_564485,
                                      base: "", url: url_PoolUpdate_564486,
                                      schemes: {Scheme.Https})
type
  Call_PoolDelete_564472 = ref object of OpenApiRestCall_563564
proc url_PoolDelete_564474(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolDelete_564473(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   poolName: JString (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564475 = path.getOrDefault("subscriptionId")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = nil)
  if valid_564475 != nil:
    section.add "subscriptionId", valid_564475
  var valid_564476 = path.getOrDefault("poolName")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = nil)
  if valid_564476 != nil:
    section.add "poolName", valid_564476
  var valid_564477 = path.getOrDefault("resourceGroupName")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "resourceGroupName", valid_564477
  var valid_564478 = path.getOrDefault("accountName")
  valid_564478 = validateParameter(valid_564478, JString, required = true,
                                 default = nil)
  if valid_564478 != nil:
    section.add "accountName", valid_564478
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564479 = query.getOrDefault("api-version")
  valid_564479 = validateParameter(valid_564479, JString, required = true,
                                 default = nil)
  if valid_564479 != nil:
    section.add "api-version", valid_564479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564480: Call_PoolDelete_564472; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified pool.
  ## 
  let valid = call_564480.validator(path, query, header, formData, body)
  let scheme = call_564480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564480.url(scheme.get, call_564480.host, call_564480.base,
                         call_564480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564480, url, valid)

proc call*(call_564481: Call_PoolDelete_564472; apiVersion: string;
          subscriptionId: string; poolName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## poolDelete
  ## Deletes the specified pool.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   poolName: string (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564482 = newJObject()
  var query_564483 = newJObject()
  add(query_564483, "api-version", newJString(apiVersion))
  add(path_564482, "subscriptionId", newJString(subscriptionId))
  add(path_564482, "poolName", newJString(poolName))
  add(path_564482, "resourceGroupName", newJString(resourceGroupName))
  add(path_564482, "accountName", newJString(accountName))
  result = call_564481.call(path_564482, query_564483, nil, nil, nil)

var poolDelete* = Call_PoolDelete_564472(name: "poolDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}",
                                      validator: validate_PoolDelete_564473,
                                      base: "", url: url_PoolDelete_564474,
                                      schemes: {Scheme.Https})
type
  Call_PoolDisableAutoScale_564499 = ref object of OpenApiRestCall_563564
proc url_PoolDisableAutoScale_564501(protocol: Scheme; host: string; base: string;
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

proc validate_PoolDisableAutoScale_564500(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Disables automatic scaling for a pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   poolName: JString (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564502 = path.getOrDefault("subscriptionId")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "subscriptionId", valid_564502
  var valid_564503 = path.getOrDefault("poolName")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "poolName", valid_564503
  var valid_564504 = path.getOrDefault("resourceGroupName")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "resourceGroupName", valid_564504
  var valid_564505 = path.getOrDefault("accountName")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "accountName", valid_564505
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564506 = query.getOrDefault("api-version")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = nil)
  if valid_564506 != nil:
    section.add "api-version", valid_564506
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564507: Call_PoolDisableAutoScale_564499; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disables automatic scaling for a pool.
  ## 
  let valid = call_564507.validator(path, query, header, formData, body)
  let scheme = call_564507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564507.url(scheme.get, call_564507.host, call_564507.base,
                         call_564507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564507, url, valid)

proc call*(call_564508: Call_PoolDisableAutoScale_564499; apiVersion: string;
          subscriptionId: string; poolName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## poolDisableAutoScale
  ## Disables automatic scaling for a pool.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   poolName: string (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564509 = newJObject()
  var query_564510 = newJObject()
  add(query_564510, "api-version", newJString(apiVersion))
  add(path_564509, "subscriptionId", newJString(subscriptionId))
  add(path_564509, "poolName", newJString(poolName))
  add(path_564509, "resourceGroupName", newJString(resourceGroupName))
  add(path_564509, "accountName", newJString(accountName))
  result = call_564508.call(path_564509, query_564510, nil, nil, nil)

var poolDisableAutoScale* = Call_PoolDisableAutoScale_564499(
    name: "poolDisableAutoScale", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}/disableAutoScale",
    validator: validate_PoolDisableAutoScale_564500, base: "",
    url: url_PoolDisableAutoScale_564501, schemes: {Scheme.Https})
type
  Call_PoolStopResize_564511 = ref object of OpenApiRestCall_563564
proc url_PoolStopResize_564513(protocol: Scheme; host: string; base: string;
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

proc validate_PoolStopResize_564512(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## This does not restore the pool to its previous state before the resize operation: it only stops any further changes being made, and the pool maintains its current state. After stopping, the pool stabilizes at the number of nodes it was at when the stop operation was done. During the stop operation, the pool allocation state changes first to stopping and then to steady. A resize operation need not be an explicit resize pool request; this API can also be used to halt the initial sizing of the pool when it is created.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   poolName: JString (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564514 = path.getOrDefault("subscriptionId")
  valid_564514 = validateParameter(valid_564514, JString, required = true,
                                 default = nil)
  if valid_564514 != nil:
    section.add "subscriptionId", valid_564514
  var valid_564515 = path.getOrDefault("poolName")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "poolName", valid_564515
  var valid_564516 = path.getOrDefault("resourceGroupName")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "resourceGroupName", valid_564516
  var valid_564517 = path.getOrDefault("accountName")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "accountName", valid_564517
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564518 = query.getOrDefault("api-version")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "api-version", valid_564518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564519: Call_PoolStopResize_564511; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This does not restore the pool to its previous state before the resize operation: it only stops any further changes being made, and the pool maintains its current state. After stopping, the pool stabilizes at the number of nodes it was at when the stop operation was done. During the stop operation, the pool allocation state changes first to stopping and then to steady. A resize operation need not be an explicit resize pool request; this API can also be used to halt the initial sizing of the pool when it is created.
  ## 
  let valid = call_564519.validator(path, query, header, formData, body)
  let scheme = call_564519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564519.url(scheme.get, call_564519.host, call_564519.base,
                         call_564519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564519, url, valid)

proc call*(call_564520: Call_PoolStopResize_564511; apiVersion: string;
          subscriptionId: string; poolName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## poolStopResize
  ## This does not restore the pool to its previous state before the resize operation: it only stops any further changes being made, and the pool maintains its current state. After stopping, the pool stabilizes at the number of nodes it was at when the stop operation was done. During the stop operation, the pool allocation state changes first to stopping and then to steady. A resize operation need not be an explicit resize pool request; this API can also be used to halt the initial sizing of the pool when it is created.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   poolName: string (required)
  ##           : The pool name. This must be unique within the account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564521 = newJObject()
  var query_564522 = newJObject()
  add(query_564522, "api-version", newJString(apiVersion))
  add(path_564521, "subscriptionId", newJString(subscriptionId))
  add(path_564521, "poolName", newJString(poolName))
  add(path_564521, "resourceGroupName", newJString(resourceGroupName))
  add(path_564521, "accountName", newJString(accountName))
  result = call_564520.call(path_564521, query_564522, nil, nil, nil)

var poolStopResize* = Call_PoolStopResize_564511(name: "poolStopResize",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/pools/{poolName}/stopResize",
    validator: validate_PoolStopResize_564512, base: "", url: url_PoolStopResize_564513,
    schemes: {Scheme.Https})
type
  Call_BatchAccountRegenerateKey_564523 = ref object of OpenApiRestCall_563564
proc url_BatchAccountRegenerateKey_564525(protocol: Scheme; host: string;
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

proc validate_BatchAccountRegenerateKey_564524(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the specified account key for the Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564526 = path.getOrDefault("subscriptionId")
  valid_564526 = validateParameter(valid_564526, JString, required = true,
                                 default = nil)
  if valid_564526 != nil:
    section.add "subscriptionId", valid_564526
  var valid_564527 = path.getOrDefault("resourceGroupName")
  valid_564527 = validateParameter(valid_564527, JString, required = true,
                                 default = nil)
  if valid_564527 != nil:
    section.add "resourceGroupName", valid_564527
  var valid_564528 = path.getOrDefault("accountName")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "accountName", valid_564528
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564529 = query.getOrDefault("api-version")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "api-version", valid_564529
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

proc call*(call_564531: Call_BatchAccountRegenerateKey_564523; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the specified account key for the Batch account.
  ## 
  let valid = call_564531.validator(path, query, header, formData, body)
  let scheme = call_564531.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564531.url(scheme.get, call_564531.host, call_564531.base,
                         call_564531.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564531, url, valid)

proc call*(call_564532: Call_BatchAccountRegenerateKey_564523; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## batchAccountRegenerateKey
  ## Regenerates the specified account key for the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   parameters: JObject (required)
  ##             : The type of key to regenerate.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564533 = newJObject()
  var query_564534 = newJObject()
  var body_564535 = newJObject()
  add(query_564534, "api-version", newJString(apiVersion))
  add(path_564533, "subscriptionId", newJString(subscriptionId))
  add(path_564533, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564535 = parameters
  add(path_564533, "accountName", newJString(accountName))
  result = call_564532.call(path_564533, query_564534, nil, nil, body_564535)

var batchAccountRegenerateKey* = Call_BatchAccountRegenerateKey_564523(
    name: "batchAccountRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/regenerateKeys",
    validator: validate_BatchAccountRegenerateKey_564524, base: "",
    url: url_BatchAccountRegenerateKey_564525, schemes: {Scheme.Https})
type
  Call_BatchAccountSynchronizeAutoStorageKeys_564536 = ref object of OpenApiRestCall_563564
proc url_BatchAccountSynchronizeAutoStorageKeys_564538(protocol: Scheme;
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

proc validate_BatchAccountSynchronizeAutoStorageKeys_564537(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Synchronizes access keys for the auto-storage account configured for the specified Batch account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: JString (required)
  ##              : The name of the Batch account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564539 = path.getOrDefault("subscriptionId")
  valid_564539 = validateParameter(valid_564539, JString, required = true,
                                 default = nil)
  if valid_564539 != nil:
    section.add "subscriptionId", valid_564539
  var valid_564540 = path.getOrDefault("resourceGroupName")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "resourceGroupName", valid_564540
  var valid_564541 = path.getOrDefault("accountName")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "accountName", valid_564541
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564542 = query.getOrDefault("api-version")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "api-version", valid_564542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564543: Call_BatchAccountSynchronizeAutoStorageKeys_564536;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Synchronizes access keys for the auto-storage account configured for the specified Batch account.
  ## 
  let valid = call_564543.validator(path, query, header, formData, body)
  let scheme = call_564543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564543.url(scheme.get, call_564543.host, call_564543.base,
                         call_564543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564543, url, valid)

proc call*(call_564544: Call_BatchAccountSynchronizeAutoStorageKeys_564536;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## batchAccountSynchronizeAutoStorageKeys
  ## Synchronizes access keys for the auto-storage account configured for the specified Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   accountName: string (required)
  ##              : The name of the Batch account.
  var path_564545 = newJObject()
  var query_564546 = newJObject()
  add(query_564546, "api-version", newJString(apiVersion))
  add(path_564545, "subscriptionId", newJString(subscriptionId))
  add(path_564545, "resourceGroupName", newJString(resourceGroupName))
  add(path_564545, "accountName", newJString(accountName))
  result = call_564544.call(path_564545, query_564546, nil, nil, nil)

var batchAccountSynchronizeAutoStorageKeys* = Call_BatchAccountSynchronizeAutoStorageKeys_564536(
    name: "batchAccountSynchronizeAutoStorageKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/syncAutoStorageKeys",
    validator: validate_BatchAccountSynchronizeAutoStorageKeys_564537, base: "",
    url: url_BatchAccountSynchronizeAutoStorageKeys_564538,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
