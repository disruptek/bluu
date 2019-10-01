
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: BatchManagement
## version: 2017-05-01
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

  OpenApiRestCall_574457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574457): Option[Scheme] {.used.} =
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
  Call_OperationsList_574679 = ref object of OpenApiRestCall_574457
proc url_OperationsList_574681(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_574680(path: JsonNode; query: JsonNode;
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
  var valid_574840 = query.getOrDefault("api-version")
  valid_574840 = validateParameter(valid_574840, JString, required = true,
                                 default = nil)
  if valid_574840 != nil:
    section.add "api-version", valid_574840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574863: Call_OperationsList_574679; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations for the Microsoft.Batch provider
  ## 
  let valid = call_574863.validator(path, query, header, formData, body)
  let scheme = call_574863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574863.url(scheme.get, call_574863.host, call_574863.base,
                         call_574863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574863, url, valid)

proc call*(call_574934: Call_OperationsList_574679; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations for the Microsoft.Batch provider
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  var query_574935 = newJObject()
  add(query_574935, "api-version", newJString(apiVersion))
  result = call_574934.call(nil, query_574935, nil, nil, nil)

var operationsList* = Call_OperationsList_574679(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Batch/operations",
    validator: validate_OperationsList_574680, base: "", url: url_OperationsList_574681,
    schemes: {Scheme.Https})
type
  Call_BatchAccountList_574975 = ref object of OpenApiRestCall_574457
proc url_BatchAccountList_574977(protocol: Scheme; host: string; base: string;
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

proc validate_BatchAccountList_574976(path: JsonNode; query: JsonNode;
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
  var valid_574992 = path.getOrDefault("subscriptionId")
  valid_574992 = validateParameter(valid_574992, JString, required = true,
                                 default = nil)
  if valid_574992 != nil:
    section.add "subscriptionId", valid_574992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574993 = query.getOrDefault("api-version")
  valid_574993 = validateParameter(valid_574993, JString, required = true,
                                 default = nil)
  if valid_574993 != nil:
    section.add "api-version", valid_574993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574994: Call_BatchAccountList_574975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the Batch accounts associated with the subscription.
  ## 
  let valid = call_574994.validator(path, query, header, formData, body)
  let scheme = call_574994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574994.url(scheme.get, call_574994.host, call_574994.base,
                         call_574994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574994, url, valid)

proc call*(call_574995: Call_BatchAccountList_574975; apiVersion: string;
          subscriptionId: string): Recallable =
  ## batchAccountList
  ## Gets information about the Batch accounts associated with the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  var path_574996 = newJObject()
  var query_574997 = newJObject()
  add(query_574997, "api-version", newJString(apiVersion))
  add(path_574996, "subscriptionId", newJString(subscriptionId))
  result = call_574995.call(path_574996, query_574997, nil, nil, nil)

var batchAccountList* = Call_BatchAccountList_574975(name: "batchAccountList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Batch/batchAccounts",
    validator: validate_BatchAccountList_574976, base: "",
    url: url_BatchAccountList_574977, schemes: {Scheme.Https})
type
  Call_LocationCheckNameAvailability_574998 = ref object of OpenApiRestCall_574457
proc url_LocationCheckNameAvailability_575000(protocol: Scheme; host: string;
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

proc validate_LocationCheckNameAvailability_574999(path: JsonNode; query: JsonNode;
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
  var valid_575018 = path.getOrDefault("subscriptionId")
  valid_575018 = validateParameter(valid_575018, JString, required = true,
                                 default = nil)
  if valid_575018 != nil:
    section.add "subscriptionId", valid_575018
  var valid_575019 = path.getOrDefault("locationName")
  valid_575019 = validateParameter(valid_575019, JString, required = true,
                                 default = nil)
  if valid_575019 != nil:
    section.add "locationName", valid_575019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575020 = query.getOrDefault("api-version")
  valid_575020 = validateParameter(valid_575020, JString, required = true,
                                 default = nil)
  if valid_575020 != nil:
    section.add "api-version", valid_575020
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

proc call*(call_575022: Call_LocationCheckNameAvailability_574998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the Batch account name is available in the specified region.
  ## 
  let valid = call_575022.validator(path, query, header, formData, body)
  let scheme = call_575022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575022.url(scheme.get, call_575022.host, call_575022.base,
                         call_575022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575022, url, valid)

proc call*(call_575023: Call_LocationCheckNameAvailability_574998;
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
  var path_575024 = newJObject()
  var query_575025 = newJObject()
  var body_575026 = newJObject()
  add(query_575025, "api-version", newJString(apiVersion))
  add(path_575024, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575026 = parameters
  add(path_575024, "locationName", newJString(locationName))
  result = call_575023.call(path_575024, query_575025, nil, nil, body_575026)

var locationCheckNameAvailability* = Call_LocationCheckNameAvailability_574998(
    name: "locationCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Batch/locations/{locationName}/checkNameAvailability",
    validator: validate_LocationCheckNameAvailability_574999, base: "",
    url: url_LocationCheckNameAvailability_575000, schemes: {Scheme.Https})
type
  Call_LocationGetQuotas_575027 = ref object of OpenApiRestCall_574457
proc url_LocationGetQuotas_575029(protocol: Scheme; host: string; base: string;
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

proc validate_LocationGetQuotas_575028(path: JsonNode; query: JsonNode;
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
  var valid_575030 = path.getOrDefault("subscriptionId")
  valid_575030 = validateParameter(valid_575030, JString, required = true,
                                 default = nil)
  if valid_575030 != nil:
    section.add "subscriptionId", valid_575030
  var valid_575031 = path.getOrDefault("locationName")
  valid_575031 = validateParameter(valid_575031, JString, required = true,
                                 default = nil)
  if valid_575031 != nil:
    section.add "locationName", valid_575031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575032 = query.getOrDefault("api-version")
  valid_575032 = validateParameter(valid_575032, JString, required = true,
                                 default = nil)
  if valid_575032 != nil:
    section.add "api-version", valid_575032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575033: Call_LocationGetQuotas_575027; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Batch service quotas for the specified subscription at the given location.
  ## 
  let valid = call_575033.validator(path, query, header, formData, body)
  let scheme = call_575033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575033.url(scheme.get, call_575033.host, call_575033.base,
                         call_575033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575033, url, valid)

proc call*(call_575034: Call_LocationGetQuotas_575027; apiVersion: string;
          subscriptionId: string; locationName: string): Recallable =
  ## locationGetQuotas
  ## Gets the Batch service quotas for the specified subscription at the given location.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   locationName: string (required)
  ##               : The region for which to retrieve Batch service quotas.
  var path_575035 = newJObject()
  var query_575036 = newJObject()
  add(query_575036, "api-version", newJString(apiVersion))
  add(path_575035, "subscriptionId", newJString(subscriptionId))
  add(path_575035, "locationName", newJString(locationName))
  result = call_575034.call(path_575035, query_575036, nil, nil, nil)

var locationGetQuotas* = Call_LocationGetQuotas_575027(name: "locationGetQuotas",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Batch/locations/{locationName}/quotas",
    validator: validate_LocationGetQuotas_575028, base: "",
    url: url_LocationGetQuotas_575029, schemes: {Scheme.Https})
type
  Call_BatchAccountListByResourceGroup_575037 = ref object of OpenApiRestCall_574457
proc url_BatchAccountListByResourceGroup_575039(protocol: Scheme; host: string;
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

proc validate_BatchAccountListByResourceGroup_575038(path: JsonNode;
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
  var valid_575040 = path.getOrDefault("resourceGroupName")
  valid_575040 = validateParameter(valid_575040, JString, required = true,
                                 default = nil)
  if valid_575040 != nil:
    section.add "resourceGroupName", valid_575040
  var valid_575041 = path.getOrDefault("subscriptionId")
  valid_575041 = validateParameter(valid_575041, JString, required = true,
                                 default = nil)
  if valid_575041 != nil:
    section.add "subscriptionId", valid_575041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575042 = query.getOrDefault("api-version")
  valid_575042 = validateParameter(valid_575042, JString, required = true,
                                 default = nil)
  if valid_575042 != nil:
    section.add "api-version", valid_575042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575043: Call_BatchAccountListByResourceGroup_575037;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the Batch accounts associated with the specified resource group.
  ## 
  let valid = call_575043.validator(path, query, header, formData, body)
  let scheme = call_575043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575043.url(scheme.get, call_575043.host, call_575043.base,
                         call_575043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575043, url, valid)

proc call*(call_575044: Call_BatchAccountListByResourceGroup_575037;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## batchAccountListByResourceGroup
  ## Gets information about the Batch accounts associated with the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the Batch account.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  var path_575045 = newJObject()
  var query_575046 = newJObject()
  add(path_575045, "resourceGroupName", newJString(resourceGroupName))
  add(query_575046, "api-version", newJString(apiVersion))
  add(path_575045, "subscriptionId", newJString(subscriptionId))
  result = call_575044.call(path_575045, query_575046, nil, nil, nil)

var batchAccountListByResourceGroup* = Call_BatchAccountListByResourceGroup_575037(
    name: "batchAccountListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts",
    validator: validate_BatchAccountListByResourceGroup_575038, base: "",
    url: url_BatchAccountListByResourceGroup_575039, schemes: {Scheme.Https})
type
  Call_BatchAccountCreate_575058 = ref object of OpenApiRestCall_574457
proc url_BatchAccountCreate_575060(protocol: Scheme; host: string; base: string;
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

proc validate_BatchAccountCreate_575059(path: JsonNode; query: JsonNode;
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
  var valid_575061 = path.getOrDefault("resourceGroupName")
  valid_575061 = validateParameter(valid_575061, JString, required = true,
                                 default = nil)
  if valid_575061 != nil:
    section.add "resourceGroupName", valid_575061
  var valid_575062 = path.getOrDefault("subscriptionId")
  valid_575062 = validateParameter(valid_575062, JString, required = true,
                                 default = nil)
  if valid_575062 != nil:
    section.add "subscriptionId", valid_575062
  var valid_575063 = path.getOrDefault("accountName")
  valid_575063 = validateParameter(valid_575063, JString, required = true,
                                 default = nil)
  if valid_575063 != nil:
    section.add "accountName", valid_575063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575064 = query.getOrDefault("api-version")
  valid_575064 = validateParameter(valid_575064, JString, required = true,
                                 default = nil)
  if valid_575064 != nil:
    section.add "api-version", valid_575064
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

proc call*(call_575066: Call_BatchAccountCreate_575058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Batch account with the specified parameters. Existing accounts cannot be updated with this API and should instead be updated with the Update Batch Account API.
  ## 
  let valid = call_575066.validator(path, query, header, formData, body)
  let scheme = call_575066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575066.url(scheme.get, call_575066.host, call_575066.base,
                         call_575066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575066, url, valid)

proc call*(call_575067: Call_BatchAccountCreate_575058; resourceGroupName: string;
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
  var path_575068 = newJObject()
  var query_575069 = newJObject()
  var body_575070 = newJObject()
  add(path_575068, "resourceGroupName", newJString(resourceGroupName))
  add(query_575069, "api-version", newJString(apiVersion))
  add(path_575068, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575070 = parameters
  add(path_575068, "accountName", newJString(accountName))
  result = call_575067.call(path_575068, query_575069, nil, nil, body_575070)

var batchAccountCreate* = Call_BatchAccountCreate_575058(
    name: "batchAccountCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}",
    validator: validate_BatchAccountCreate_575059, base: "",
    url: url_BatchAccountCreate_575060, schemes: {Scheme.Https})
type
  Call_BatchAccountGet_575047 = ref object of OpenApiRestCall_574457
proc url_BatchAccountGet_575049(protocol: Scheme; host: string; base: string;
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

proc validate_BatchAccountGet_575048(path: JsonNode; query: JsonNode;
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
  var valid_575050 = path.getOrDefault("resourceGroupName")
  valid_575050 = validateParameter(valid_575050, JString, required = true,
                                 default = nil)
  if valid_575050 != nil:
    section.add "resourceGroupName", valid_575050
  var valid_575051 = path.getOrDefault("subscriptionId")
  valid_575051 = validateParameter(valid_575051, JString, required = true,
                                 default = nil)
  if valid_575051 != nil:
    section.add "subscriptionId", valid_575051
  var valid_575052 = path.getOrDefault("accountName")
  valid_575052 = validateParameter(valid_575052, JString, required = true,
                                 default = nil)
  if valid_575052 != nil:
    section.add "accountName", valid_575052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575053 = query.getOrDefault("api-version")
  valid_575053 = validateParameter(valid_575053, JString, required = true,
                                 default = nil)
  if valid_575053 != nil:
    section.add "api-version", valid_575053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575054: Call_BatchAccountGet_575047; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified Batch account.
  ## 
  let valid = call_575054.validator(path, query, header, formData, body)
  let scheme = call_575054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575054.url(scheme.get, call_575054.host, call_575054.base,
                         call_575054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575054, url, valid)

proc call*(call_575055: Call_BatchAccountGet_575047; resourceGroupName: string;
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
  var path_575056 = newJObject()
  var query_575057 = newJObject()
  add(path_575056, "resourceGroupName", newJString(resourceGroupName))
  add(query_575057, "api-version", newJString(apiVersion))
  add(path_575056, "subscriptionId", newJString(subscriptionId))
  add(path_575056, "accountName", newJString(accountName))
  result = call_575055.call(path_575056, query_575057, nil, nil, nil)

var batchAccountGet* = Call_BatchAccountGet_575047(name: "batchAccountGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}",
    validator: validate_BatchAccountGet_575048, base: "", url: url_BatchAccountGet_575049,
    schemes: {Scheme.Https})
type
  Call_BatchAccountUpdate_575082 = ref object of OpenApiRestCall_574457
proc url_BatchAccountUpdate_575084(protocol: Scheme; host: string; base: string;
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

proc validate_BatchAccountUpdate_575083(path: JsonNode; query: JsonNode;
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
  var valid_575085 = path.getOrDefault("resourceGroupName")
  valid_575085 = validateParameter(valid_575085, JString, required = true,
                                 default = nil)
  if valid_575085 != nil:
    section.add "resourceGroupName", valid_575085
  var valid_575086 = path.getOrDefault("subscriptionId")
  valid_575086 = validateParameter(valid_575086, JString, required = true,
                                 default = nil)
  if valid_575086 != nil:
    section.add "subscriptionId", valid_575086
  var valid_575087 = path.getOrDefault("accountName")
  valid_575087 = validateParameter(valid_575087, JString, required = true,
                                 default = nil)
  if valid_575087 != nil:
    section.add "accountName", valid_575087
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575088 = query.getOrDefault("api-version")
  valid_575088 = validateParameter(valid_575088, JString, required = true,
                                 default = nil)
  if valid_575088 != nil:
    section.add "api-version", valid_575088
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

proc call*(call_575090: Call_BatchAccountUpdate_575082; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing Batch account.
  ## 
  let valid = call_575090.validator(path, query, header, formData, body)
  let scheme = call_575090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575090.url(scheme.get, call_575090.host, call_575090.base,
                         call_575090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575090, url, valid)

proc call*(call_575091: Call_BatchAccountUpdate_575082; resourceGroupName: string;
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
  var path_575092 = newJObject()
  var query_575093 = newJObject()
  var body_575094 = newJObject()
  add(path_575092, "resourceGroupName", newJString(resourceGroupName))
  add(query_575093, "api-version", newJString(apiVersion))
  add(path_575092, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575094 = parameters
  add(path_575092, "accountName", newJString(accountName))
  result = call_575091.call(path_575092, query_575093, nil, nil, body_575094)

var batchAccountUpdate* = Call_BatchAccountUpdate_575082(
    name: "batchAccountUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}",
    validator: validate_BatchAccountUpdate_575083, base: "",
    url: url_BatchAccountUpdate_575084, schemes: {Scheme.Https})
type
  Call_BatchAccountDelete_575071 = ref object of OpenApiRestCall_574457
proc url_BatchAccountDelete_575073(protocol: Scheme; host: string; base: string;
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

proc validate_BatchAccountDelete_575072(path: JsonNode; query: JsonNode;
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
  var valid_575074 = path.getOrDefault("resourceGroupName")
  valid_575074 = validateParameter(valid_575074, JString, required = true,
                                 default = nil)
  if valid_575074 != nil:
    section.add "resourceGroupName", valid_575074
  var valid_575075 = path.getOrDefault("subscriptionId")
  valid_575075 = validateParameter(valid_575075, JString, required = true,
                                 default = nil)
  if valid_575075 != nil:
    section.add "subscriptionId", valid_575075
  var valid_575076 = path.getOrDefault("accountName")
  valid_575076 = validateParameter(valid_575076, JString, required = true,
                                 default = nil)
  if valid_575076 != nil:
    section.add "accountName", valid_575076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575077 = query.getOrDefault("api-version")
  valid_575077 = validateParameter(valid_575077, JString, required = true,
                                 default = nil)
  if valid_575077 != nil:
    section.add "api-version", valid_575077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575078: Call_BatchAccountDelete_575071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Batch account.
  ## 
  let valid = call_575078.validator(path, query, header, formData, body)
  let scheme = call_575078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575078.url(scheme.get, call_575078.host, call_575078.base,
                         call_575078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575078, url, valid)

proc call*(call_575079: Call_BatchAccountDelete_575071; resourceGroupName: string;
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
  var path_575080 = newJObject()
  var query_575081 = newJObject()
  add(path_575080, "resourceGroupName", newJString(resourceGroupName))
  add(query_575081, "api-version", newJString(apiVersion))
  add(path_575080, "subscriptionId", newJString(subscriptionId))
  add(path_575080, "accountName", newJString(accountName))
  result = call_575079.call(path_575080, query_575081, nil, nil, nil)

var batchAccountDelete* = Call_BatchAccountDelete_575071(
    name: "batchAccountDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}",
    validator: validate_BatchAccountDelete_575072, base: "",
    url: url_BatchAccountDelete_575073, schemes: {Scheme.Https})
type
  Call_ApplicationList_575095 = ref object of OpenApiRestCall_574457
proc url_ApplicationList_575097(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationList_575096(path: JsonNode; query: JsonNode;
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
  var valid_575098 = path.getOrDefault("resourceGroupName")
  valid_575098 = validateParameter(valid_575098, JString, required = true,
                                 default = nil)
  if valid_575098 != nil:
    section.add "resourceGroupName", valid_575098
  var valid_575099 = path.getOrDefault("subscriptionId")
  valid_575099 = validateParameter(valid_575099, JString, required = true,
                                 default = nil)
  if valid_575099 != nil:
    section.add "subscriptionId", valid_575099
  var valid_575100 = path.getOrDefault("accountName")
  valid_575100 = validateParameter(valid_575100, JString, required = true,
                                 default = nil)
  if valid_575100 != nil:
    section.add "accountName", valid_575100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575101 = query.getOrDefault("api-version")
  valid_575101 = validateParameter(valid_575101, JString, required = true,
                                 default = nil)
  if valid_575101 != nil:
    section.add "api-version", valid_575101
  var valid_575102 = query.getOrDefault("maxresults")
  valid_575102 = validateParameter(valid_575102, JInt, required = false, default = nil)
  if valid_575102 != nil:
    section.add "maxresults", valid_575102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575103: Call_ApplicationList_575095; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the applications in the specified account.
  ## 
  let valid = call_575103.validator(path, query, header, formData, body)
  let scheme = call_575103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575103.url(scheme.get, call_575103.host, call_575103.base,
                         call_575103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575103, url, valid)

proc call*(call_575104: Call_ApplicationList_575095; resourceGroupName: string;
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
  var path_575105 = newJObject()
  var query_575106 = newJObject()
  add(path_575105, "resourceGroupName", newJString(resourceGroupName))
  add(query_575106, "api-version", newJString(apiVersion))
  add(path_575105, "subscriptionId", newJString(subscriptionId))
  add(query_575106, "maxresults", newJInt(maxresults))
  add(path_575105, "accountName", newJString(accountName))
  result = call_575104.call(path_575105, query_575106, nil, nil, nil)

var applicationList* = Call_ApplicationList_575095(name: "applicationList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications",
    validator: validate_ApplicationList_575096, base: "", url: url_ApplicationList_575097,
    schemes: {Scheme.Https})
type
  Call_ApplicationCreate_575119 = ref object of OpenApiRestCall_574457
proc url_ApplicationCreate_575121(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationCreate_575120(path: JsonNode; query: JsonNode;
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
  var valid_575122 = path.getOrDefault("resourceGroupName")
  valid_575122 = validateParameter(valid_575122, JString, required = true,
                                 default = nil)
  if valid_575122 != nil:
    section.add "resourceGroupName", valid_575122
  var valid_575123 = path.getOrDefault("subscriptionId")
  valid_575123 = validateParameter(valid_575123, JString, required = true,
                                 default = nil)
  if valid_575123 != nil:
    section.add "subscriptionId", valid_575123
  var valid_575124 = path.getOrDefault("applicationId")
  valid_575124 = validateParameter(valid_575124, JString, required = true,
                                 default = nil)
  if valid_575124 != nil:
    section.add "applicationId", valid_575124
  var valid_575125 = path.getOrDefault("accountName")
  valid_575125 = validateParameter(valid_575125, JString, required = true,
                                 default = nil)
  if valid_575125 != nil:
    section.add "accountName", valid_575125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575126 = query.getOrDefault("api-version")
  valid_575126 = validateParameter(valid_575126, JString, required = true,
                                 default = nil)
  if valid_575126 != nil:
    section.add "api-version", valid_575126
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

proc call*(call_575128: Call_ApplicationCreate_575119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an application to the specified Batch account.
  ## 
  let valid = call_575128.validator(path, query, header, formData, body)
  let scheme = call_575128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575128.url(scheme.get, call_575128.host, call_575128.base,
                         call_575128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575128, url, valid)

proc call*(call_575129: Call_ApplicationCreate_575119; resourceGroupName: string;
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
  var path_575130 = newJObject()
  var query_575131 = newJObject()
  var body_575132 = newJObject()
  add(path_575130, "resourceGroupName", newJString(resourceGroupName))
  add(query_575131, "api-version", newJString(apiVersion))
  add(path_575130, "subscriptionId", newJString(subscriptionId))
  add(path_575130, "applicationId", newJString(applicationId))
  if parameters != nil:
    body_575132 = parameters
  add(path_575130, "accountName", newJString(accountName))
  result = call_575129.call(path_575130, query_575131, nil, nil, body_575132)

var applicationCreate* = Call_ApplicationCreate_575119(name: "applicationCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}",
    validator: validate_ApplicationCreate_575120, base: "",
    url: url_ApplicationCreate_575121, schemes: {Scheme.Https})
type
  Call_ApplicationGet_575107 = ref object of OpenApiRestCall_574457
proc url_ApplicationGet_575109(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGet_575108(path: JsonNode; query: JsonNode;
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
  var valid_575110 = path.getOrDefault("resourceGroupName")
  valid_575110 = validateParameter(valid_575110, JString, required = true,
                                 default = nil)
  if valid_575110 != nil:
    section.add "resourceGroupName", valid_575110
  var valid_575111 = path.getOrDefault("subscriptionId")
  valid_575111 = validateParameter(valid_575111, JString, required = true,
                                 default = nil)
  if valid_575111 != nil:
    section.add "subscriptionId", valid_575111
  var valid_575112 = path.getOrDefault("applicationId")
  valid_575112 = validateParameter(valid_575112, JString, required = true,
                                 default = nil)
  if valid_575112 != nil:
    section.add "applicationId", valid_575112
  var valid_575113 = path.getOrDefault("accountName")
  valid_575113 = validateParameter(valid_575113, JString, required = true,
                                 default = nil)
  if valid_575113 != nil:
    section.add "accountName", valid_575113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575114 = query.getOrDefault("api-version")
  valid_575114 = validateParameter(valid_575114, JString, required = true,
                                 default = nil)
  if valid_575114 != nil:
    section.add "api-version", valid_575114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575115: Call_ApplicationGet_575107; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified application.
  ## 
  let valid = call_575115.validator(path, query, header, formData, body)
  let scheme = call_575115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575115.url(scheme.get, call_575115.host, call_575115.base,
                         call_575115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575115, url, valid)

proc call*(call_575116: Call_ApplicationGet_575107; resourceGroupName: string;
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
  var path_575117 = newJObject()
  var query_575118 = newJObject()
  add(path_575117, "resourceGroupName", newJString(resourceGroupName))
  add(query_575118, "api-version", newJString(apiVersion))
  add(path_575117, "subscriptionId", newJString(subscriptionId))
  add(path_575117, "applicationId", newJString(applicationId))
  add(path_575117, "accountName", newJString(accountName))
  result = call_575116.call(path_575117, query_575118, nil, nil, nil)

var applicationGet* = Call_ApplicationGet_575107(name: "applicationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}",
    validator: validate_ApplicationGet_575108, base: "", url: url_ApplicationGet_575109,
    schemes: {Scheme.Https})
type
  Call_ApplicationUpdate_575145 = ref object of OpenApiRestCall_574457
proc url_ApplicationUpdate_575147(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationUpdate_575146(path: JsonNode; query: JsonNode;
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
  var valid_575148 = path.getOrDefault("resourceGroupName")
  valid_575148 = validateParameter(valid_575148, JString, required = true,
                                 default = nil)
  if valid_575148 != nil:
    section.add "resourceGroupName", valid_575148
  var valid_575149 = path.getOrDefault("subscriptionId")
  valid_575149 = validateParameter(valid_575149, JString, required = true,
                                 default = nil)
  if valid_575149 != nil:
    section.add "subscriptionId", valid_575149
  var valid_575150 = path.getOrDefault("applicationId")
  valid_575150 = validateParameter(valid_575150, JString, required = true,
                                 default = nil)
  if valid_575150 != nil:
    section.add "applicationId", valid_575150
  var valid_575151 = path.getOrDefault("accountName")
  valid_575151 = validateParameter(valid_575151, JString, required = true,
                                 default = nil)
  if valid_575151 != nil:
    section.add "accountName", valid_575151
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575152 = query.getOrDefault("api-version")
  valid_575152 = validateParameter(valid_575152, JString, required = true,
                                 default = nil)
  if valid_575152 != nil:
    section.add "api-version", valid_575152
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

proc call*(call_575154: Call_ApplicationUpdate_575145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates settings for the specified application.
  ## 
  let valid = call_575154.validator(path, query, header, formData, body)
  let scheme = call_575154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575154.url(scheme.get, call_575154.host, call_575154.base,
                         call_575154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575154, url, valid)

proc call*(call_575155: Call_ApplicationUpdate_575145; resourceGroupName: string;
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
  var path_575156 = newJObject()
  var query_575157 = newJObject()
  var body_575158 = newJObject()
  add(path_575156, "resourceGroupName", newJString(resourceGroupName))
  add(query_575157, "api-version", newJString(apiVersion))
  add(path_575156, "subscriptionId", newJString(subscriptionId))
  add(path_575156, "applicationId", newJString(applicationId))
  if parameters != nil:
    body_575158 = parameters
  add(path_575156, "accountName", newJString(accountName))
  result = call_575155.call(path_575156, query_575157, nil, nil, body_575158)

var applicationUpdate* = Call_ApplicationUpdate_575145(name: "applicationUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}",
    validator: validate_ApplicationUpdate_575146, base: "",
    url: url_ApplicationUpdate_575147, schemes: {Scheme.Https})
type
  Call_ApplicationDelete_575133 = ref object of OpenApiRestCall_574457
proc url_ApplicationDelete_575135(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationDelete_575134(path: JsonNode; query: JsonNode;
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
  var valid_575136 = path.getOrDefault("resourceGroupName")
  valid_575136 = validateParameter(valid_575136, JString, required = true,
                                 default = nil)
  if valid_575136 != nil:
    section.add "resourceGroupName", valid_575136
  var valid_575137 = path.getOrDefault("subscriptionId")
  valid_575137 = validateParameter(valid_575137, JString, required = true,
                                 default = nil)
  if valid_575137 != nil:
    section.add "subscriptionId", valid_575137
  var valid_575138 = path.getOrDefault("applicationId")
  valid_575138 = validateParameter(valid_575138, JString, required = true,
                                 default = nil)
  if valid_575138 != nil:
    section.add "applicationId", valid_575138
  var valid_575139 = path.getOrDefault("accountName")
  valid_575139 = validateParameter(valid_575139, JString, required = true,
                                 default = nil)
  if valid_575139 != nil:
    section.add "accountName", valid_575139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575140 = query.getOrDefault("api-version")
  valid_575140 = validateParameter(valid_575140, JString, required = true,
                                 default = nil)
  if valid_575140 != nil:
    section.add "api-version", valid_575140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575141: Call_ApplicationDelete_575133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application.
  ## 
  let valid = call_575141.validator(path, query, header, formData, body)
  let scheme = call_575141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575141.url(scheme.get, call_575141.host, call_575141.base,
                         call_575141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575141, url, valid)

proc call*(call_575142: Call_ApplicationDelete_575133; resourceGroupName: string;
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
  var path_575143 = newJObject()
  var query_575144 = newJObject()
  add(path_575143, "resourceGroupName", newJString(resourceGroupName))
  add(query_575144, "api-version", newJString(apiVersion))
  add(path_575143, "subscriptionId", newJString(subscriptionId))
  add(path_575143, "applicationId", newJString(applicationId))
  add(path_575143, "accountName", newJString(accountName))
  result = call_575142.call(path_575143, query_575144, nil, nil, nil)

var applicationDelete* = Call_ApplicationDelete_575133(name: "applicationDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}",
    validator: validate_ApplicationDelete_575134, base: "",
    url: url_ApplicationDelete_575135, schemes: {Scheme.Https})
type
  Call_ApplicationPackageCreate_575172 = ref object of OpenApiRestCall_574457
proc url_ApplicationPackageCreate_575174(protocol: Scheme; host: string;
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

proc validate_ApplicationPackageCreate_575173(path: JsonNode; query: JsonNode;
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
  var valid_575175 = path.getOrDefault("resourceGroupName")
  valid_575175 = validateParameter(valid_575175, JString, required = true,
                                 default = nil)
  if valid_575175 != nil:
    section.add "resourceGroupName", valid_575175
  var valid_575176 = path.getOrDefault("version")
  valid_575176 = validateParameter(valid_575176, JString, required = true,
                                 default = nil)
  if valid_575176 != nil:
    section.add "version", valid_575176
  var valid_575177 = path.getOrDefault("subscriptionId")
  valid_575177 = validateParameter(valid_575177, JString, required = true,
                                 default = nil)
  if valid_575177 != nil:
    section.add "subscriptionId", valid_575177
  var valid_575178 = path.getOrDefault("applicationId")
  valid_575178 = validateParameter(valid_575178, JString, required = true,
                                 default = nil)
  if valid_575178 != nil:
    section.add "applicationId", valid_575178
  var valid_575179 = path.getOrDefault("accountName")
  valid_575179 = validateParameter(valid_575179, JString, required = true,
                                 default = nil)
  if valid_575179 != nil:
    section.add "accountName", valid_575179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575180 = query.getOrDefault("api-version")
  valid_575180 = validateParameter(valid_575180, JString, required = true,
                                 default = nil)
  if valid_575180 != nil:
    section.add "api-version", valid_575180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575181: Call_ApplicationPackageCreate_575172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an application package record.
  ## 
  let valid = call_575181.validator(path, query, header, formData, body)
  let scheme = call_575181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575181.url(scheme.get, call_575181.host, call_575181.base,
                         call_575181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575181, url, valid)

proc call*(call_575182: Call_ApplicationPackageCreate_575172;
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
  var path_575183 = newJObject()
  var query_575184 = newJObject()
  add(path_575183, "resourceGroupName", newJString(resourceGroupName))
  add(query_575184, "api-version", newJString(apiVersion))
  add(path_575183, "version", newJString(version))
  add(path_575183, "subscriptionId", newJString(subscriptionId))
  add(path_575183, "applicationId", newJString(applicationId))
  add(path_575183, "accountName", newJString(accountName))
  result = call_575182.call(path_575183, query_575184, nil, nil, nil)

var applicationPackageCreate* = Call_ApplicationPackageCreate_575172(
    name: "applicationPackageCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}/versions/{version}",
    validator: validate_ApplicationPackageCreate_575173, base: "",
    url: url_ApplicationPackageCreate_575174, schemes: {Scheme.Https})
type
  Call_ApplicationPackageGet_575159 = ref object of OpenApiRestCall_574457
proc url_ApplicationPackageGet_575161(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationPackageGet_575160(path: JsonNode; query: JsonNode;
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
  var valid_575162 = path.getOrDefault("resourceGroupName")
  valid_575162 = validateParameter(valid_575162, JString, required = true,
                                 default = nil)
  if valid_575162 != nil:
    section.add "resourceGroupName", valid_575162
  var valid_575163 = path.getOrDefault("version")
  valid_575163 = validateParameter(valid_575163, JString, required = true,
                                 default = nil)
  if valid_575163 != nil:
    section.add "version", valid_575163
  var valid_575164 = path.getOrDefault("subscriptionId")
  valid_575164 = validateParameter(valid_575164, JString, required = true,
                                 default = nil)
  if valid_575164 != nil:
    section.add "subscriptionId", valid_575164
  var valid_575165 = path.getOrDefault("applicationId")
  valid_575165 = validateParameter(valid_575165, JString, required = true,
                                 default = nil)
  if valid_575165 != nil:
    section.add "applicationId", valid_575165
  var valid_575166 = path.getOrDefault("accountName")
  valid_575166 = validateParameter(valid_575166, JString, required = true,
                                 default = nil)
  if valid_575166 != nil:
    section.add "accountName", valid_575166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575167 = query.getOrDefault("api-version")
  valid_575167 = validateParameter(valid_575167, JString, required = true,
                                 default = nil)
  if valid_575167 != nil:
    section.add "api-version", valid_575167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575168: Call_ApplicationPackageGet_575159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified application package.
  ## 
  let valid = call_575168.validator(path, query, header, formData, body)
  let scheme = call_575168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575168.url(scheme.get, call_575168.host, call_575168.base,
                         call_575168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575168, url, valid)

proc call*(call_575169: Call_ApplicationPackageGet_575159;
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
  var path_575170 = newJObject()
  var query_575171 = newJObject()
  add(path_575170, "resourceGroupName", newJString(resourceGroupName))
  add(query_575171, "api-version", newJString(apiVersion))
  add(path_575170, "version", newJString(version))
  add(path_575170, "subscriptionId", newJString(subscriptionId))
  add(path_575170, "applicationId", newJString(applicationId))
  add(path_575170, "accountName", newJString(accountName))
  result = call_575169.call(path_575170, query_575171, nil, nil, nil)

var applicationPackageGet* = Call_ApplicationPackageGet_575159(
    name: "applicationPackageGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}/versions/{version}",
    validator: validate_ApplicationPackageGet_575160, base: "",
    url: url_ApplicationPackageGet_575161, schemes: {Scheme.Https})
type
  Call_ApplicationPackageDelete_575185 = ref object of OpenApiRestCall_574457
proc url_ApplicationPackageDelete_575187(protocol: Scheme; host: string;
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

proc validate_ApplicationPackageDelete_575186(path: JsonNode; query: JsonNode;
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
  var valid_575188 = path.getOrDefault("resourceGroupName")
  valid_575188 = validateParameter(valid_575188, JString, required = true,
                                 default = nil)
  if valid_575188 != nil:
    section.add "resourceGroupName", valid_575188
  var valid_575189 = path.getOrDefault("version")
  valid_575189 = validateParameter(valid_575189, JString, required = true,
                                 default = nil)
  if valid_575189 != nil:
    section.add "version", valid_575189
  var valid_575190 = path.getOrDefault("subscriptionId")
  valid_575190 = validateParameter(valid_575190, JString, required = true,
                                 default = nil)
  if valid_575190 != nil:
    section.add "subscriptionId", valid_575190
  var valid_575191 = path.getOrDefault("applicationId")
  valid_575191 = validateParameter(valid_575191, JString, required = true,
                                 default = nil)
  if valid_575191 != nil:
    section.add "applicationId", valid_575191
  var valid_575192 = path.getOrDefault("accountName")
  valid_575192 = validateParameter(valid_575192, JString, required = true,
                                 default = nil)
  if valid_575192 != nil:
    section.add "accountName", valid_575192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575193 = query.getOrDefault("api-version")
  valid_575193 = validateParameter(valid_575193, JString, required = true,
                                 default = nil)
  if valid_575193 != nil:
    section.add "api-version", valid_575193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575194: Call_ApplicationPackageDelete_575185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application package record and its associated binary file.
  ## 
  let valid = call_575194.validator(path, query, header, formData, body)
  let scheme = call_575194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575194.url(scheme.get, call_575194.host, call_575194.base,
                         call_575194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575194, url, valid)

proc call*(call_575195: Call_ApplicationPackageDelete_575185;
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
  var path_575196 = newJObject()
  var query_575197 = newJObject()
  add(path_575196, "resourceGroupName", newJString(resourceGroupName))
  add(query_575197, "api-version", newJString(apiVersion))
  add(path_575196, "version", newJString(version))
  add(path_575196, "subscriptionId", newJString(subscriptionId))
  add(path_575196, "applicationId", newJString(applicationId))
  add(path_575196, "accountName", newJString(accountName))
  result = call_575195.call(path_575196, query_575197, nil, nil, nil)

var applicationPackageDelete* = Call_ApplicationPackageDelete_575185(
    name: "applicationPackageDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}/versions/{version}",
    validator: validate_ApplicationPackageDelete_575186, base: "",
    url: url_ApplicationPackageDelete_575187, schemes: {Scheme.Https})
type
  Call_ApplicationPackageActivate_575198 = ref object of OpenApiRestCall_574457
proc url_ApplicationPackageActivate_575200(protocol: Scheme; host: string;
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

proc validate_ApplicationPackageActivate_575199(path: JsonNode; query: JsonNode;
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
  var valid_575201 = path.getOrDefault("resourceGroupName")
  valid_575201 = validateParameter(valid_575201, JString, required = true,
                                 default = nil)
  if valid_575201 != nil:
    section.add "resourceGroupName", valid_575201
  var valid_575202 = path.getOrDefault("version")
  valid_575202 = validateParameter(valid_575202, JString, required = true,
                                 default = nil)
  if valid_575202 != nil:
    section.add "version", valid_575202
  var valid_575203 = path.getOrDefault("subscriptionId")
  valid_575203 = validateParameter(valid_575203, JString, required = true,
                                 default = nil)
  if valid_575203 != nil:
    section.add "subscriptionId", valid_575203
  var valid_575204 = path.getOrDefault("applicationId")
  valid_575204 = validateParameter(valid_575204, JString, required = true,
                                 default = nil)
  if valid_575204 != nil:
    section.add "applicationId", valid_575204
  var valid_575205 = path.getOrDefault("accountName")
  valid_575205 = validateParameter(valid_575205, JString, required = true,
                                 default = nil)
  if valid_575205 != nil:
    section.add "accountName", valid_575205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575206 = query.getOrDefault("api-version")
  valid_575206 = validateParameter(valid_575206, JString, required = true,
                                 default = nil)
  if valid_575206 != nil:
    section.add "api-version", valid_575206
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

proc call*(call_575208: Call_ApplicationPackageActivate_575198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activates the specified application package.
  ## 
  let valid = call_575208.validator(path, query, header, formData, body)
  let scheme = call_575208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575208.url(scheme.get, call_575208.host, call_575208.base,
                         call_575208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575208, url, valid)

proc call*(call_575209: Call_ApplicationPackageActivate_575198;
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
  var path_575210 = newJObject()
  var query_575211 = newJObject()
  var body_575212 = newJObject()
  add(path_575210, "resourceGroupName", newJString(resourceGroupName))
  add(query_575211, "api-version", newJString(apiVersion))
  add(path_575210, "version", newJString(version))
  add(path_575210, "subscriptionId", newJString(subscriptionId))
  add(path_575210, "applicationId", newJString(applicationId))
  if parameters != nil:
    body_575212 = parameters
  add(path_575210, "accountName", newJString(accountName))
  result = call_575209.call(path_575210, query_575211, nil, nil, body_575212)

var applicationPackageActivate* = Call_ApplicationPackageActivate_575198(
    name: "applicationPackageActivate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/applications/{applicationId}/versions/{version}/activate",
    validator: validate_ApplicationPackageActivate_575199, base: "",
    url: url_ApplicationPackageActivate_575200, schemes: {Scheme.Https})
type
  Call_BatchAccountGetKeys_575213 = ref object of OpenApiRestCall_574457
proc url_BatchAccountGetKeys_575215(protocol: Scheme; host: string; base: string;
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

proc validate_BatchAccountGetKeys_575214(path: JsonNode; query: JsonNode;
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
  var valid_575216 = path.getOrDefault("resourceGroupName")
  valid_575216 = validateParameter(valid_575216, JString, required = true,
                                 default = nil)
  if valid_575216 != nil:
    section.add "resourceGroupName", valid_575216
  var valid_575217 = path.getOrDefault("subscriptionId")
  valid_575217 = validateParameter(valid_575217, JString, required = true,
                                 default = nil)
  if valid_575217 != nil:
    section.add "subscriptionId", valid_575217
  var valid_575218 = path.getOrDefault("accountName")
  valid_575218 = validateParameter(valid_575218, JString, required = true,
                                 default = nil)
  if valid_575218 != nil:
    section.add "accountName", valid_575218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575219 = query.getOrDefault("api-version")
  valid_575219 = validateParameter(valid_575219, JString, required = true,
                                 default = nil)
  if valid_575219 != nil:
    section.add "api-version", valid_575219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575220: Call_BatchAccountGetKeys_575213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation applies only to Batch accounts created with a poolAllocationMode of 'BatchService'. If the Batch account was created with a poolAllocationMode of 'UserSubscription', clients cannot use access to keys to authenticate, and must use Azure Active Directory instead. In this case, getting the keys will fail.
  ## 
  let valid = call_575220.validator(path, query, header, formData, body)
  let scheme = call_575220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575220.url(scheme.get, call_575220.host, call_575220.base,
                         call_575220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575220, url, valid)

proc call*(call_575221: Call_BatchAccountGetKeys_575213; resourceGroupName: string;
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
  var path_575222 = newJObject()
  var query_575223 = newJObject()
  add(path_575222, "resourceGroupName", newJString(resourceGroupName))
  add(query_575223, "api-version", newJString(apiVersion))
  add(path_575222, "subscriptionId", newJString(subscriptionId))
  add(path_575222, "accountName", newJString(accountName))
  result = call_575221.call(path_575222, query_575223, nil, nil, nil)

var batchAccountGetKeys* = Call_BatchAccountGetKeys_575213(
    name: "batchAccountGetKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/listKeys",
    validator: validate_BatchAccountGetKeys_575214, base: "",
    url: url_BatchAccountGetKeys_575215, schemes: {Scheme.Https})
type
  Call_BatchAccountRegenerateKey_575224 = ref object of OpenApiRestCall_574457
proc url_BatchAccountRegenerateKey_575226(protocol: Scheme; host: string;
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

proc validate_BatchAccountRegenerateKey_575225(path: JsonNode; query: JsonNode;
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
  var valid_575227 = path.getOrDefault("resourceGroupName")
  valid_575227 = validateParameter(valid_575227, JString, required = true,
                                 default = nil)
  if valid_575227 != nil:
    section.add "resourceGroupName", valid_575227
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
  ##             : The type of key to regenerate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575232: Call_BatchAccountRegenerateKey_575224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the specified account key for the Batch account.
  ## 
  let valid = call_575232.validator(path, query, header, formData, body)
  let scheme = call_575232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575232.url(scheme.get, call_575232.host, call_575232.base,
                         call_575232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575232, url, valid)

proc call*(call_575233: Call_BatchAccountRegenerateKey_575224;
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
  var path_575234 = newJObject()
  var query_575235 = newJObject()
  var body_575236 = newJObject()
  add(path_575234, "resourceGroupName", newJString(resourceGroupName))
  add(query_575235, "api-version", newJString(apiVersion))
  add(path_575234, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_575236 = parameters
  add(path_575234, "accountName", newJString(accountName))
  result = call_575233.call(path_575234, query_575235, nil, nil, body_575236)

var batchAccountRegenerateKey* = Call_BatchAccountRegenerateKey_575224(
    name: "batchAccountRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/regenerateKeys",
    validator: validate_BatchAccountRegenerateKey_575225, base: "",
    url: url_BatchAccountRegenerateKey_575226, schemes: {Scheme.Https})
type
  Call_BatchAccountSynchronizeAutoStorageKeys_575237 = ref object of OpenApiRestCall_574457
proc url_BatchAccountSynchronizeAutoStorageKeys_575239(protocol: Scheme;
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

proc validate_BatchAccountSynchronizeAutoStorageKeys_575238(path: JsonNode;
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
  var valid_575242 = path.getOrDefault("accountName")
  valid_575242 = validateParameter(valid_575242, JString, required = true,
                                 default = nil)
  if valid_575242 != nil:
    section.add "accountName", valid_575242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575243 = query.getOrDefault("api-version")
  valid_575243 = validateParameter(valid_575243, JString, required = true,
                                 default = nil)
  if valid_575243 != nil:
    section.add "api-version", valid_575243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575244: Call_BatchAccountSynchronizeAutoStorageKeys_575237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Synchronizes access keys for the auto-storage account configured for the specified Batch account.
  ## 
  let valid = call_575244.validator(path, query, header, formData, body)
  let scheme = call_575244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575244.url(scheme.get, call_575244.host, call_575244.base,
                         call_575244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575244, url, valid)

proc call*(call_575245: Call_BatchAccountSynchronizeAutoStorageKeys_575237;
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
  var path_575246 = newJObject()
  var query_575247 = newJObject()
  add(path_575246, "resourceGroupName", newJString(resourceGroupName))
  add(query_575247, "api-version", newJString(apiVersion))
  add(path_575246, "subscriptionId", newJString(subscriptionId))
  add(path_575246, "accountName", newJString(accountName))
  result = call_575245.call(path_575246, query_575247, nil, nil, nil)

var batchAccountSynchronizeAutoStorageKeys* = Call_BatchAccountSynchronizeAutoStorageKeys_575237(
    name: "batchAccountSynchronizeAutoStorageKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Batch/batchAccounts/{accountName}/syncAutoStorageKeys",
    validator: validate_BatchAccountSynchronizeAutoStorageKeys_575238, base: "",
    url: url_BatchAccountSynchronizeAutoStorageKeys_575239,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
