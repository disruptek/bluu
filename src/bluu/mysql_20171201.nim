
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: MySQLManagementClient
## version: 2017-12-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Microsoft Azure management API provides create, read, update, and delete functionality for Azure MySQL resources including servers, databases, firewall rules, VNET rules, log files and configurations with new business model.
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

  OpenApiRestCall_567668 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567668](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567668): Option[Scheme] {.used.} =
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
  macServiceName = "mysql"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567890 = ref object of OpenApiRestCall_567668
proc url_OperationsList_567892(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567891(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568051 = query.getOrDefault("api-version")
  valid_568051 = validateParameter(valid_568051, JString, required = true,
                                 default = nil)
  if valid_568051 != nil:
    section.add "api-version", valid_568051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568074: Call_OperationsList_567890; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available REST API operations.
  ## 
  let valid = call_568074.validator(path, query, header, formData, body)
  let scheme = call_568074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568074.url(scheme.get, call_568074.host, call_568074.base,
                         call_568074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568074, url, valid)

proc call*(call_568145: Call_OperationsList_567890; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  var query_568146 = newJObject()
  add(query_568146, "api-version", newJString(apiVersion))
  result = call_568145.call(nil, query_568146, nil, nil, nil)

var operationsList* = Call_OperationsList_567890(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DBforMySQL/operations",
    validator: validate_OperationsList_567891, base: "", url: url_OperationsList_567892,
    schemes: {Scheme.Https})
type
  Call_CheckNameAvailabilityExecute_568186 = ref object of OpenApiRestCall_567668
proc url_CheckNameAvailabilityExecute_568188(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DBforMySQL/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CheckNameAvailabilityExecute_568187(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the availability of name for resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568220 = path.getOrDefault("subscriptionId")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "subscriptionId", valid_568220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nameAvailabilityRequest: JObject (required)
  ##                          : The required parameters for checking if resource name is available.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568223: Call_CheckNameAvailabilityExecute_568186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check the availability of name for resource
  ## 
  let valid = call_568223.validator(path, query, header, formData, body)
  let scheme = call_568223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568223.url(scheme.get, call_568223.host, call_568223.base,
                         call_568223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568223, url, valid)

proc call*(call_568224: Call_CheckNameAvailabilityExecute_568186;
          apiVersion: string; subscriptionId: string;
          nameAvailabilityRequest: JsonNode): Recallable =
  ## checkNameAvailabilityExecute
  ## Check the availability of name for resource
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   nameAvailabilityRequest: JObject (required)
  ##                          : The required parameters for checking if resource name is available.
  var path_568225 = newJObject()
  var query_568226 = newJObject()
  var body_568227 = newJObject()
  add(query_568226, "api-version", newJString(apiVersion))
  add(path_568225, "subscriptionId", newJString(subscriptionId))
  if nameAvailabilityRequest != nil:
    body_568227 = nameAvailabilityRequest
  result = call_568224.call(path_568225, query_568226, nil, nil, body_568227)

var checkNameAvailabilityExecute* = Call_CheckNameAvailabilityExecute_568186(
    name: "checkNameAvailabilityExecute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DBforMySQL/checkNameAvailability",
    validator: validate_CheckNameAvailabilityExecute_568187, base: "",
    url: url_CheckNameAvailabilityExecute_568188, schemes: {Scheme.Https})
type
  Call_LocationBasedPerformanceTierList_568228 = ref object of OpenApiRestCall_567668
proc url_LocationBasedPerformanceTierList_568230(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/performanceTiers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationBasedPerformanceTierList_568229(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the performance tiers at specified location in a given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   locationName: JString (required)
  ##               : The name of the location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568231 = path.getOrDefault("subscriptionId")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "subscriptionId", valid_568231
  var valid_568232 = path.getOrDefault("locationName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "locationName", valid_568232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568233 = query.getOrDefault("api-version")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "api-version", valid_568233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568234: Call_LocationBasedPerformanceTierList_568228;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the performance tiers at specified location in a given subscription.
  ## 
  let valid = call_568234.validator(path, query, header, formData, body)
  let scheme = call_568234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568234.url(scheme.get, call_568234.host, call_568234.base,
                         call_568234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568234, url, valid)

proc call*(call_568235: Call_LocationBasedPerformanceTierList_568228;
          apiVersion: string; subscriptionId: string; locationName: string): Recallable =
  ## locationBasedPerformanceTierList
  ## List all the performance tiers at specified location in a given subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   locationName: string (required)
  ##               : The name of the location.
  var path_568236 = newJObject()
  var query_568237 = newJObject()
  add(query_568237, "api-version", newJString(apiVersion))
  add(path_568236, "subscriptionId", newJString(subscriptionId))
  add(path_568236, "locationName", newJString(locationName))
  result = call_568235.call(path_568236, query_568237, nil, nil, nil)

var locationBasedPerformanceTierList* = Call_LocationBasedPerformanceTierList_568228(
    name: "locationBasedPerformanceTierList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DBforMySQL/locations/{locationName}/performanceTiers",
    validator: validate_LocationBasedPerformanceTierList_568229, base: "",
    url: url_LocationBasedPerformanceTierList_568230, schemes: {Scheme.Https})
type
  Call_LocationBasedRecommendedActionSessionsOperationStatusGet_568238 = ref object of OpenApiRestCall_567668
proc url_LocationBasedRecommendedActionSessionsOperationStatusGet_568240(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/locations/"),
               (kind: VariableSegment, value: "locationName"), (
        kind: ConstantSegment,
        value: "/recommendedActionSessionsAzureAsyncOperation/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationBasedRecommendedActionSessionsOperationStatusGet_568239(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Recommendation action session operation status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   locationName: JString (required)
  ##               : The name of the location.
  ##   operationId: JString (required)
  ##              : The operation identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568241 = path.getOrDefault("subscriptionId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "subscriptionId", valid_568241
  var valid_568242 = path.getOrDefault("locationName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "locationName", valid_568242
  var valid_568243 = path.getOrDefault("operationId")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "operationId", valid_568243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568244 = query.getOrDefault("api-version")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "api-version", valid_568244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568245: Call_LocationBasedRecommendedActionSessionsOperationStatusGet_568238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Recommendation action session operation status.
  ## 
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_LocationBasedRecommendedActionSessionsOperationStatusGet_568238;
          apiVersion: string; subscriptionId: string; locationName: string;
          operationId: string): Recallable =
  ## locationBasedRecommendedActionSessionsOperationStatusGet
  ## Recommendation action session operation status.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   locationName: string (required)
  ##               : The name of the location.
  ##   operationId: string (required)
  ##              : The operation identifier.
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  add(query_568248, "api-version", newJString(apiVersion))
  add(path_568247, "subscriptionId", newJString(subscriptionId))
  add(path_568247, "locationName", newJString(locationName))
  add(path_568247, "operationId", newJString(operationId))
  result = call_568246.call(path_568247, query_568248, nil, nil, nil)

var locationBasedRecommendedActionSessionsOperationStatusGet* = Call_LocationBasedRecommendedActionSessionsOperationStatusGet_568238(
    name: "locationBasedRecommendedActionSessionsOperationStatusGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DBforMySQL/locations/{locationName}/recommendedActionSessionsAzureAsyncOperation/{operationId}", validator: validate_LocationBasedRecommendedActionSessionsOperationStatusGet_568239,
    base: "", url: url_LocationBasedRecommendedActionSessionsOperationStatusGet_568240,
    schemes: {Scheme.Https})
type
  Call_LocationBasedRecommendedActionSessionsResultList_568249 = ref object of OpenApiRestCall_567668
proc url_LocationBasedRecommendedActionSessionsResultList_568251(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/locations/"),
               (kind: VariableSegment, value: "locationName"), (
        kind: ConstantSegment,
        value: "/recommendedActionSessionsOperationResults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationBasedRecommendedActionSessionsResultList_568250(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Recommendation action session operation result.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   locationName: JString (required)
  ##               : The name of the location.
  ##   operationId: JString (required)
  ##              : The operation identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568252 = path.getOrDefault("subscriptionId")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "subscriptionId", valid_568252
  var valid_568253 = path.getOrDefault("locationName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "locationName", valid_568253
  var valid_568254 = path.getOrDefault("operationId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "operationId", valid_568254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568255 = query.getOrDefault("api-version")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "api-version", valid_568255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568256: Call_LocationBasedRecommendedActionSessionsResultList_568249;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Recommendation action session operation result.
  ## 
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_LocationBasedRecommendedActionSessionsResultList_568249;
          apiVersion: string; subscriptionId: string; locationName: string;
          operationId: string): Recallable =
  ## locationBasedRecommendedActionSessionsResultList
  ## Recommendation action session operation result.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   locationName: string (required)
  ##               : The name of the location.
  ##   operationId: string (required)
  ##              : The operation identifier.
  var path_568258 = newJObject()
  var query_568259 = newJObject()
  add(query_568259, "api-version", newJString(apiVersion))
  add(path_568258, "subscriptionId", newJString(subscriptionId))
  add(path_568258, "locationName", newJString(locationName))
  add(path_568258, "operationId", newJString(operationId))
  result = call_568257.call(path_568258, query_568259, nil, nil, nil)

var locationBasedRecommendedActionSessionsResultList* = Call_LocationBasedRecommendedActionSessionsResultList_568249(
    name: "locationBasedRecommendedActionSessionsResultList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DBforMySQL/locations/{locationName}/recommendedActionSessionsOperationResults/{operationId}",
    validator: validate_LocationBasedRecommendedActionSessionsResultList_568250,
    base: "", url: url_LocationBasedRecommendedActionSessionsResultList_568251,
    schemes: {Scheme.Https})
type
  Call_ServersList_568260 = ref object of OpenApiRestCall_567668
proc url_ServersList_568262(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersList_568261(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the servers in a given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568263 = path.getOrDefault("subscriptionId")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "subscriptionId", valid_568263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
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

proc call*(call_568265: Call_ServersList_568260; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the servers in a given subscription.
  ## 
  let valid = call_568265.validator(path, query, header, formData, body)
  let scheme = call_568265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568265.url(scheme.get, call_568265.host, call_568265.base,
                         call_568265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568265, url, valid)

proc call*(call_568266: Call_ServersList_568260; apiVersion: string;
          subscriptionId: string): Recallable =
  ## serversList
  ## List all the servers in a given subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568267 = newJObject()
  var query_568268 = newJObject()
  add(query_568268, "api-version", newJString(apiVersion))
  add(path_568267, "subscriptionId", newJString(subscriptionId))
  result = call_568266.call(path_568267, query_568268, nil, nil, nil)

var serversList* = Call_ServersList_568260(name: "serversList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DBforMySQL/servers",
                                        validator: validate_ServersList_568261,
                                        base: "", url: url_ServersList_568262,
                                        schemes: {Scheme.Https})
type
  Call_ServersListByResourceGroup_568269 = ref object of OpenApiRestCall_567668
proc url_ServersListByResourceGroup_568271(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersListByResourceGroup_568270(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the servers in a given resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568274 = query.getOrDefault("api-version")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "api-version", valid_568274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568275: Call_ServersListByResourceGroup_568269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the servers in a given resource group.
  ## 
  let valid = call_568275.validator(path, query, header, formData, body)
  let scheme = call_568275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568275.url(scheme.get, call_568275.host, call_568275.base,
                         call_568275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568275, url, valid)

proc call*(call_568276: Call_ServersListByResourceGroup_568269;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## serversListByResourceGroup
  ## List all the servers in a given resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568277 = newJObject()
  var query_568278 = newJObject()
  add(path_568277, "resourceGroupName", newJString(resourceGroupName))
  add(query_568278, "api-version", newJString(apiVersion))
  add(path_568277, "subscriptionId", newJString(subscriptionId))
  result = call_568276.call(path_568277, query_568278, nil, nil, nil)

var serversListByResourceGroup* = Call_ServersListByResourceGroup_568269(
    name: "serversListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers",
    validator: validate_ServersListByResourceGroup_568270, base: "",
    url: url_ServersListByResourceGroup_568271, schemes: {Scheme.Https})
type
  Call_ServersCreate_568290 = ref object of OpenApiRestCall_567668
proc url_ServersCreate_568292(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersCreate_568291(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new server or updates an existing server. The update action will overwrite the existing server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568293 = path.getOrDefault("resourceGroupName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "resourceGroupName", valid_568293
  var valid_568294 = path.getOrDefault("serverName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "serverName", valid_568294
  var valid_568295 = path.getOrDefault("subscriptionId")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "subscriptionId", valid_568295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568296 = query.getOrDefault("api-version")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "api-version", valid_568296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The required parameters for creating or updating a server.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568298: Call_ServersCreate_568290; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new server or updates an existing server. The update action will overwrite the existing server.
  ## 
  let valid = call_568298.validator(path, query, header, formData, body)
  let scheme = call_568298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568298.url(scheme.get, call_568298.host, call_568298.base,
                         call_568298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568298, url, valid)

proc call*(call_568299: Call_ServersCreate_568290; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## serversCreate
  ## Creates a new server or updates an existing server. The update action will overwrite the existing server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The required parameters for creating or updating a server.
  var path_568300 = newJObject()
  var query_568301 = newJObject()
  var body_568302 = newJObject()
  add(path_568300, "resourceGroupName", newJString(resourceGroupName))
  add(query_568301, "api-version", newJString(apiVersion))
  add(path_568300, "serverName", newJString(serverName))
  add(path_568300, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568302 = parameters
  result = call_568299.call(path_568300, query_568301, nil, nil, body_568302)

var serversCreate* = Call_ServersCreate_568290(name: "serversCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}",
    validator: validate_ServersCreate_568291, base: "", url: url_ServersCreate_568292,
    schemes: {Scheme.Https})
type
  Call_ServersGet_568279 = ref object of OpenApiRestCall_567668
proc url_ServersGet_568281(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersGet_568280(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568282 = path.getOrDefault("resourceGroupName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "resourceGroupName", valid_568282
  var valid_568283 = path.getOrDefault("serverName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "serverName", valid_568283
  var valid_568284 = path.getOrDefault("subscriptionId")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "subscriptionId", valid_568284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568285 = query.getOrDefault("api-version")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "api-version", valid_568285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568286: Call_ServersGet_568279; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a server.
  ## 
  let valid = call_568286.validator(path, query, header, formData, body)
  let scheme = call_568286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568286.url(scheme.get, call_568286.host, call_568286.base,
                         call_568286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568286, url, valid)

proc call*(call_568287: Call_ServersGet_568279; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string): Recallable =
  ## serversGet
  ## Gets information about a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568288 = newJObject()
  var query_568289 = newJObject()
  add(path_568288, "resourceGroupName", newJString(resourceGroupName))
  add(query_568289, "api-version", newJString(apiVersion))
  add(path_568288, "serverName", newJString(serverName))
  add(path_568288, "subscriptionId", newJString(subscriptionId))
  result = call_568287.call(path_568288, query_568289, nil, nil, nil)

var serversGet* = Call_ServersGet_568279(name: "serversGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}",
                                      validator: validate_ServersGet_568280,
                                      base: "", url: url_ServersGet_568281,
                                      schemes: {Scheme.Https})
type
  Call_ServersUpdate_568314 = ref object of OpenApiRestCall_567668
proc url_ServersUpdate_568316(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersUpdate_568315(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing server. The request body can contain one to many of the properties present in the normal server definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568317 = path.getOrDefault("resourceGroupName")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "resourceGroupName", valid_568317
  var valid_568318 = path.getOrDefault("serverName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "serverName", valid_568318
  var valid_568319 = path.getOrDefault("subscriptionId")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "subscriptionId", valid_568319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568320 = query.getOrDefault("api-version")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "api-version", valid_568320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The required parameters for updating a server.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568322: Call_ServersUpdate_568314; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing server. The request body can contain one to many of the properties present in the normal server definition.
  ## 
  let valid = call_568322.validator(path, query, header, formData, body)
  let scheme = call_568322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568322.url(scheme.get, call_568322.host, call_568322.base,
                         call_568322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568322, url, valid)

proc call*(call_568323: Call_ServersUpdate_568314; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## serversUpdate
  ## Updates an existing server. The request body can contain one to many of the properties present in the normal server definition.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The required parameters for updating a server.
  var path_568324 = newJObject()
  var query_568325 = newJObject()
  var body_568326 = newJObject()
  add(path_568324, "resourceGroupName", newJString(resourceGroupName))
  add(query_568325, "api-version", newJString(apiVersion))
  add(path_568324, "serverName", newJString(serverName))
  add(path_568324, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568326 = parameters
  result = call_568323.call(path_568324, query_568325, nil, nil, body_568326)

var serversUpdate* = Call_ServersUpdate_568314(name: "serversUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}",
    validator: validate_ServersUpdate_568315, base: "", url: url_ServersUpdate_568316,
    schemes: {Scheme.Https})
type
  Call_ServersDelete_568303 = ref object of OpenApiRestCall_567668
proc url_ServersDelete_568305(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersDelete_568304(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568306 = path.getOrDefault("resourceGroupName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "resourceGroupName", valid_568306
  var valid_568307 = path.getOrDefault("serverName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "serverName", valid_568307
  var valid_568308 = path.getOrDefault("subscriptionId")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "subscriptionId", valid_568308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568309 = query.getOrDefault("api-version")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "api-version", valid_568309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568310: Call_ServersDelete_568303; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a server.
  ## 
  let valid = call_568310.validator(path, query, header, formData, body)
  let scheme = call_568310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568310.url(scheme.get, call_568310.host, call_568310.base,
                         call_568310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568310, url, valid)

proc call*(call_568311: Call_ServersDelete_568303; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string): Recallable =
  ## serversDelete
  ## Deletes a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568312 = newJObject()
  var query_568313 = newJObject()
  add(path_568312, "resourceGroupName", newJString(resourceGroupName))
  add(query_568313, "api-version", newJString(apiVersion))
  add(path_568312, "serverName", newJString(serverName))
  add(path_568312, "subscriptionId", newJString(subscriptionId))
  result = call_568311.call(path_568312, query_568313, nil, nil, nil)

var serversDelete* = Call_ServersDelete_568303(name: "serversDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}",
    validator: validate_ServersDelete_568304, base: "", url: url_ServersDelete_568305,
    schemes: {Scheme.Https})
type
  Call_AdvisorsListByServer_568327 = ref object of OpenApiRestCall_567668
proc url_AdvisorsListByServer_568329(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/advisors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdvisorsListByServer_568328(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List recommendation action advisors.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568330 = path.getOrDefault("resourceGroupName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "resourceGroupName", valid_568330
  var valid_568331 = path.getOrDefault("serverName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "serverName", valid_568331
  var valid_568332 = path.getOrDefault("subscriptionId")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "subscriptionId", valid_568332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568333 = query.getOrDefault("api-version")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "api-version", valid_568333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568334: Call_AdvisorsListByServer_568327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List recommendation action advisors.
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_AdvisorsListByServer_568327;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## advisorsListByServer
  ## List recommendation action advisors.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568336 = newJObject()
  var query_568337 = newJObject()
  add(path_568336, "resourceGroupName", newJString(resourceGroupName))
  add(query_568337, "api-version", newJString(apiVersion))
  add(path_568336, "serverName", newJString(serverName))
  add(path_568336, "subscriptionId", newJString(subscriptionId))
  result = call_568335.call(path_568336, query_568337, nil, nil, nil)

var advisorsListByServer* = Call_AdvisorsListByServer_568327(
    name: "advisorsListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/advisors",
    validator: validate_AdvisorsListByServer_568328, base: "",
    url: url_AdvisorsListByServer_568329, schemes: {Scheme.Https})
type
  Call_AdvisorsGet_568338 = ref object of OpenApiRestCall_567668
proc url_AdvisorsGet_568340(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "advisorName" in path, "`advisorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/advisors/"),
               (kind: VariableSegment, value: "advisorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdvisorsGet_568339(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a recommendation action advisor.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   advisorName: JString (required)
  ##              : The advisor name for recommendation action.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568341 = path.getOrDefault("resourceGroupName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "resourceGroupName", valid_568341
  var valid_568342 = path.getOrDefault("serverName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "serverName", valid_568342
  var valid_568343 = path.getOrDefault("subscriptionId")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "subscriptionId", valid_568343
  var valid_568344 = path.getOrDefault("advisorName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "advisorName", valid_568344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568345 = query.getOrDefault("api-version")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "api-version", valid_568345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568346: Call_AdvisorsGet_568338; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a recommendation action advisor.
  ## 
  let valid = call_568346.validator(path, query, header, formData, body)
  let scheme = call_568346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568346.url(scheme.get, call_568346.host, call_568346.base,
                         call_568346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568346, url, valid)

proc call*(call_568347: Call_AdvisorsGet_568338; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          advisorName: string): Recallable =
  ## advisorsGet
  ## Get a recommendation action advisor.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   advisorName: string (required)
  ##              : The advisor name for recommendation action.
  var path_568348 = newJObject()
  var query_568349 = newJObject()
  add(path_568348, "resourceGroupName", newJString(resourceGroupName))
  add(query_568349, "api-version", newJString(apiVersion))
  add(path_568348, "serverName", newJString(serverName))
  add(path_568348, "subscriptionId", newJString(subscriptionId))
  add(path_568348, "advisorName", newJString(advisorName))
  result = call_568347.call(path_568348, query_568349, nil, nil, nil)

var advisorsGet* = Call_AdvisorsGet_568338(name: "advisorsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/advisors/{advisorName}",
                                        validator: validate_AdvisorsGet_568339,
                                        base: "", url: url_AdvisorsGet_568340,
                                        schemes: {Scheme.Https})
type
  Call_CreateRecommendedActionSession_568350 = ref object of OpenApiRestCall_567668
proc url_CreateRecommendedActionSession_568352(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "advisorName" in path, "`advisorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/advisors/"),
               (kind: VariableSegment, value: "advisorName"), (
        kind: ConstantSegment, value: "/createRecommendedActionSession")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CreateRecommendedActionSession_568351(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create recommendation action session for the advisor.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   advisorName: JString (required)
  ##              : The advisor name for recommendation action.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568353 = path.getOrDefault("resourceGroupName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "resourceGroupName", valid_568353
  var valid_568354 = path.getOrDefault("serverName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "serverName", valid_568354
  var valid_568355 = path.getOrDefault("subscriptionId")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "subscriptionId", valid_568355
  var valid_568356 = path.getOrDefault("advisorName")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "advisorName", valid_568356
  result.add "path", section
  ## parameters in `query` object:
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `databaseName` field"
  var valid_568357 = query.getOrDefault("databaseName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "databaseName", valid_568357
  var valid_568358 = query.getOrDefault("api-version")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "api-version", valid_568358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568359: Call_CreateRecommendedActionSession_568350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create recommendation action session for the advisor.
  ## 
  let valid = call_568359.validator(path, query, header, formData, body)
  let scheme = call_568359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568359.url(scheme.get, call_568359.host, call_568359.base,
                         call_568359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568359, url, valid)

proc call*(call_568360: Call_CreateRecommendedActionSession_568350;
          databaseName: string; resourceGroupName: string; apiVersion: string;
          serverName: string; subscriptionId: string; advisorName: string): Recallable =
  ## createRecommendedActionSession
  ## Create recommendation action session for the advisor.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   advisorName: string (required)
  ##              : The advisor name for recommendation action.
  var path_568361 = newJObject()
  var query_568362 = newJObject()
  add(query_568362, "databaseName", newJString(databaseName))
  add(path_568361, "resourceGroupName", newJString(resourceGroupName))
  add(query_568362, "api-version", newJString(apiVersion))
  add(path_568361, "serverName", newJString(serverName))
  add(path_568361, "subscriptionId", newJString(subscriptionId))
  add(path_568361, "advisorName", newJString(advisorName))
  result = call_568360.call(path_568361, query_568362, nil, nil, nil)

var createRecommendedActionSession* = Call_CreateRecommendedActionSession_568350(
    name: "createRecommendedActionSession", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/advisors/{advisorName}/createRecommendedActionSession",
    validator: validate_CreateRecommendedActionSession_568351, base: "",
    url: url_CreateRecommendedActionSession_568352, schemes: {Scheme.Https})
type
  Call_RecommendedActionsListByServer_568363 = ref object of OpenApiRestCall_567668
proc url_RecommendedActionsListByServer_568365(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "advisorName" in path, "`advisorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/advisors/"),
               (kind: VariableSegment, value: "advisorName"),
               (kind: ConstantSegment, value: "/recommendedActions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendedActionsListByServer_568364(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve recommended actions from the advisor.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   advisorName: JString (required)
  ##              : The advisor name for recommendation action.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568366 = path.getOrDefault("resourceGroupName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "resourceGroupName", valid_568366
  var valid_568367 = path.getOrDefault("serverName")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "serverName", valid_568367
  var valid_568368 = path.getOrDefault("subscriptionId")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "subscriptionId", valid_568368
  var valid_568369 = path.getOrDefault("advisorName")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "advisorName", valid_568369
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   sessionId: JString
  ##            : The recommendation action session identifier.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568370 = query.getOrDefault("api-version")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "api-version", valid_568370
  var valid_568371 = query.getOrDefault("sessionId")
  valid_568371 = validateParameter(valid_568371, JString, required = false,
                                 default = nil)
  if valid_568371 != nil:
    section.add "sessionId", valid_568371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568372: Call_RecommendedActionsListByServer_568363; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve recommended actions from the advisor.
  ## 
  let valid = call_568372.validator(path, query, header, formData, body)
  let scheme = call_568372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568372.url(scheme.get, call_568372.host, call_568372.base,
                         call_568372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568372, url, valid)

proc call*(call_568373: Call_RecommendedActionsListByServer_568363;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; advisorName: string; sessionId: string = ""): Recallable =
  ## recommendedActionsListByServer
  ## Retrieve recommended actions from the advisor.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   advisorName: string (required)
  ##              : The advisor name for recommendation action.
  ##   sessionId: string
  ##            : The recommendation action session identifier.
  var path_568374 = newJObject()
  var query_568375 = newJObject()
  add(path_568374, "resourceGroupName", newJString(resourceGroupName))
  add(query_568375, "api-version", newJString(apiVersion))
  add(path_568374, "serverName", newJString(serverName))
  add(path_568374, "subscriptionId", newJString(subscriptionId))
  add(path_568374, "advisorName", newJString(advisorName))
  add(query_568375, "sessionId", newJString(sessionId))
  result = call_568373.call(path_568374, query_568375, nil, nil, nil)

var recommendedActionsListByServer* = Call_RecommendedActionsListByServer_568363(
    name: "recommendedActionsListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/advisors/{advisorName}/recommendedActions",
    validator: validate_RecommendedActionsListByServer_568364, base: "",
    url: url_RecommendedActionsListByServer_568365, schemes: {Scheme.Https})
type
  Call_RecommendedActionsGet_568376 = ref object of OpenApiRestCall_567668
proc url_RecommendedActionsGet_568378(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "advisorName" in path, "`advisorName` is a required path parameter"
  assert "recommendedActionName" in path,
        "`recommendedActionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/advisors/"),
               (kind: VariableSegment, value: "advisorName"),
               (kind: ConstantSegment, value: "/recommendedActions/"),
               (kind: VariableSegment, value: "recommendedActionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendedActionsGet_568377(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve recommended actions from the advisor.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   advisorName: JString (required)
  ##              : The advisor name for recommendation action.
  ##   recommendedActionName: JString (required)
  ##                        : The recommended action name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568379 = path.getOrDefault("resourceGroupName")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "resourceGroupName", valid_568379
  var valid_568380 = path.getOrDefault("serverName")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "serverName", valid_568380
  var valid_568381 = path.getOrDefault("subscriptionId")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "subscriptionId", valid_568381
  var valid_568382 = path.getOrDefault("advisorName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "advisorName", valid_568382
  var valid_568383 = path.getOrDefault("recommendedActionName")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "recommendedActionName", valid_568383
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568384 = query.getOrDefault("api-version")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "api-version", valid_568384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568385: Call_RecommendedActionsGet_568376; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve recommended actions from the advisor.
  ## 
  let valid = call_568385.validator(path, query, header, formData, body)
  let scheme = call_568385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568385.url(scheme.get, call_568385.host, call_568385.base,
                         call_568385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568385, url, valid)

proc call*(call_568386: Call_RecommendedActionsGet_568376;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; advisorName: string; recommendedActionName: string): Recallable =
  ## recommendedActionsGet
  ## Retrieve recommended actions from the advisor.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   advisorName: string (required)
  ##              : The advisor name for recommendation action.
  ##   recommendedActionName: string (required)
  ##                        : The recommended action name.
  var path_568387 = newJObject()
  var query_568388 = newJObject()
  add(path_568387, "resourceGroupName", newJString(resourceGroupName))
  add(query_568388, "api-version", newJString(apiVersion))
  add(path_568387, "serverName", newJString(serverName))
  add(path_568387, "subscriptionId", newJString(subscriptionId))
  add(path_568387, "advisorName", newJString(advisorName))
  add(path_568387, "recommendedActionName", newJString(recommendedActionName))
  result = call_568386.call(path_568387, query_568388, nil, nil, nil)

var recommendedActionsGet* = Call_RecommendedActionsGet_568376(
    name: "recommendedActionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/advisors/{advisorName}/recommendedActions/{recommendedActionName}",
    validator: validate_RecommendedActionsGet_568377, base: "",
    url: url_RecommendedActionsGet_568378, schemes: {Scheme.Https})
type
  Call_ConfigurationsListByServer_568389 = ref object of OpenApiRestCall_567668
proc url_ConfigurationsListByServer_568391(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationsListByServer_568390(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the configurations in a given server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568392 = path.getOrDefault("resourceGroupName")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "resourceGroupName", valid_568392
  var valid_568393 = path.getOrDefault("serverName")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "serverName", valid_568393
  var valid_568394 = path.getOrDefault("subscriptionId")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "subscriptionId", valid_568394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568395 = query.getOrDefault("api-version")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "api-version", valid_568395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568396: Call_ConfigurationsListByServer_568389; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the configurations in a given server.
  ## 
  let valid = call_568396.validator(path, query, header, formData, body)
  let scheme = call_568396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568396.url(scheme.get, call_568396.host, call_568396.base,
                         call_568396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568396, url, valid)

proc call*(call_568397: Call_ConfigurationsListByServer_568389;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## configurationsListByServer
  ## List all the configurations in a given server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568398 = newJObject()
  var query_568399 = newJObject()
  add(path_568398, "resourceGroupName", newJString(resourceGroupName))
  add(query_568399, "api-version", newJString(apiVersion))
  add(path_568398, "serverName", newJString(serverName))
  add(path_568398, "subscriptionId", newJString(subscriptionId))
  result = call_568397.call(path_568398, query_568399, nil, nil, nil)

var configurationsListByServer* = Call_ConfigurationsListByServer_568389(
    name: "configurationsListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/configurations",
    validator: validate_ConfigurationsListByServer_568390, base: "",
    url: url_ConfigurationsListByServer_568391, schemes: {Scheme.Https})
type
  Call_ConfigurationsCreateOrUpdate_568412 = ref object of OpenApiRestCall_567668
proc url_ConfigurationsCreateOrUpdate_568414(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "configurationName" in path,
        "`configurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/configurations/"),
               (kind: VariableSegment, value: "configurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationsCreateOrUpdate_568413(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a configuration of a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   configurationName: JString (required)
  ##                    : The name of the server configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568415 = path.getOrDefault("resourceGroupName")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "resourceGroupName", valid_568415
  var valid_568416 = path.getOrDefault("serverName")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "serverName", valid_568416
  var valid_568417 = path.getOrDefault("subscriptionId")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "subscriptionId", valid_568417
  var valid_568418 = path.getOrDefault("configurationName")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "configurationName", valid_568418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568419 = query.getOrDefault("api-version")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "api-version", valid_568419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The required parameters for updating a server configuration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568421: Call_ConfigurationsCreateOrUpdate_568412; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a configuration of a server.
  ## 
  let valid = call_568421.validator(path, query, header, formData, body)
  let scheme = call_568421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568421.url(scheme.get, call_568421.host, call_568421.base,
                         call_568421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568421, url, valid)

proc call*(call_568422: Call_ConfigurationsCreateOrUpdate_568412;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; configurationName: string; parameters: JsonNode): Recallable =
  ## configurationsCreateOrUpdate
  ## Updates a configuration of a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   configurationName: string (required)
  ##                    : The name of the server configuration.
  ##   parameters: JObject (required)
  ##             : The required parameters for updating a server configuration.
  var path_568423 = newJObject()
  var query_568424 = newJObject()
  var body_568425 = newJObject()
  add(path_568423, "resourceGroupName", newJString(resourceGroupName))
  add(query_568424, "api-version", newJString(apiVersion))
  add(path_568423, "serverName", newJString(serverName))
  add(path_568423, "subscriptionId", newJString(subscriptionId))
  add(path_568423, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_568425 = parameters
  result = call_568422.call(path_568423, query_568424, nil, nil, body_568425)

var configurationsCreateOrUpdate* = Call_ConfigurationsCreateOrUpdate_568412(
    name: "configurationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/configurations/{configurationName}",
    validator: validate_ConfigurationsCreateOrUpdate_568413, base: "",
    url: url_ConfigurationsCreateOrUpdate_568414, schemes: {Scheme.Https})
type
  Call_ConfigurationsGet_568400 = ref object of OpenApiRestCall_567668
proc url_ConfigurationsGet_568402(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "configurationName" in path,
        "`configurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/configurations/"),
               (kind: VariableSegment, value: "configurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationsGet_568401(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets information about a configuration of server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   configurationName: JString (required)
  ##                    : The name of the server configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568403 = path.getOrDefault("resourceGroupName")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "resourceGroupName", valid_568403
  var valid_568404 = path.getOrDefault("serverName")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "serverName", valid_568404
  var valid_568405 = path.getOrDefault("subscriptionId")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "subscriptionId", valid_568405
  var valid_568406 = path.getOrDefault("configurationName")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "configurationName", valid_568406
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568407 = query.getOrDefault("api-version")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "api-version", valid_568407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568408: Call_ConfigurationsGet_568400; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a configuration of server.
  ## 
  let valid = call_568408.validator(path, query, header, formData, body)
  let scheme = call_568408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568408.url(scheme.get, call_568408.host, call_568408.base,
                         call_568408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568408, url, valid)

proc call*(call_568409: Call_ConfigurationsGet_568400; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          configurationName: string): Recallable =
  ## configurationsGet
  ## Gets information about a configuration of server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   configurationName: string (required)
  ##                    : The name of the server configuration.
  var path_568410 = newJObject()
  var query_568411 = newJObject()
  add(path_568410, "resourceGroupName", newJString(resourceGroupName))
  add(query_568411, "api-version", newJString(apiVersion))
  add(path_568410, "serverName", newJString(serverName))
  add(path_568410, "subscriptionId", newJString(subscriptionId))
  add(path_568410, "configurationName", newJString(configurationName))
  result = call_568409.call(path_568410, query_568411, nil, nil, nil)

var configurationsGet* = Call_ConfigurationsGet_568400(name: "configurationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/configurations/{configurationName}",
    validator: validate_ConfigurationsGet_568401, base: "",
    url: url_ConfigurationsGet_568402, schemes: {Scheme.Https})
type
  Call_DatabasesListByServer_568426 = ref object of OpenApiRestCall_567668
proc url_DatabasesListByServer_568428(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesListByServer_568427(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the databases in a given server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568429 = path.getOrDefault("resourceGroupName")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "resourceGroupName", valid_568429
  var valid_568430 = path.getOrDefault("serverName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "serverName", valid_568430
  var valid_568431 = path.getOrDefault("subscriptionId")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "subscriptionId", valid_568431
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568432 = query.getOrDefault("api-version")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "api-version", valid_568432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568433: Call_DatabasesListByServer_568426; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the databases in a given server.
  ## 
  let valid = call_568433.validator(path, query, header, formData, body)
  let scheme = call_568433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568433.url(scheme.get, call_568433.host, call_568433.base,
                         call_568433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568433, url, valid)

proc call*(call_568434: Call_DatabasesListByServer_568426;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## databasesListByServer
  ## List all the databases in a given server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568435 = newJObject()
  var query_568436 = newJObject()
  add(path_568435, "resourceGroupName", newJString(resourceGroupName))
  add(query_568436, "api-version", newJString(apiVersion))
  add(path_568435, "serverName", newJString(serverName))
  add(path_568435, "subscriptionId", newJString(subscriptionId))
  result = call_568434.call(path_568435, query_568436, nil, nil, nil)

var databasesListByServer* = Call_DatabasesListByServer_568426(
    name: "databasesListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/databases",
    validator: validate_DatabasesListByServer_568427, base: "",
    url: url_DatabasesListByServer_568428, schemes: {Scheme.Https})
type
  Call_DatabasesCreateOrUpdate_568449 = ref object of OpenApiRestCall_567668
proc url_DatabasesCreateOrUpdate_568451(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesCreateOrUpdate_568450(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new database or updates an existing database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568452 = path.getOrDefault("resourceGroupName")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "resourceGroupName", valid_568452
  var valid_568453 = path.getOrDefault("serverName")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "serverName", valid_568453
  var valid_568454 = path.getOrDefault("subscriptionId")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "subscriptionId", valid_568454
  var valid_568455 = path.getOrDefault("databaseName")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "databaseName", valid_568455
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568456 = query.getOrDefault("api-version")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "api-version", valid_568456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The required parameters for creating or updating a database.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568458: Call_DatabasesCreateOrUpdate_568449; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new database or updates an existing database.
  ## 
  let valid = call_568458.validator(path, query, header, formData, body)
  let scheme = call_568458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568458.url(scheme.get, call_568458.host, call_568458.base,
                         call_568458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568458, url, valid)

proc call*(call_568459: Call_DatabasesCreateOrUpdate_568449;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string; parameters: JsonNode): Recallable =
  ## databasesCreateOrUpdate
  ## Creates a new database or updates an existing database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   parameters: JObject (required)
  ##             : The required parameters for creating or updating a database.
  var path_568460 = newJObject()
  var query_568461 = newJObject()
  var body_568462 = newJObject()
  add(path_568460, "resourceGroupName", newJString(resourceGroupName))
  add(query_568461, "api-version", newJString(apiVersion))
  add(path_568460, "serverName", newJString(serverName))
  add(path_568460, "subscriptionId", newJString(subscriptionId))
  add(path_568460, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_568462 = parameters
  result = call_568459.call(path_568460, query_568461, nil, nil, body_568462)

var databasesCreateOrUpdate* = Call_DatabasesCreateOrUpdate_568449(
    name: "databasesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/databases/{databaseName}",
    validator: validate_DatabasesCreateOrUpdate_568450, base: "",
    url: url_DatabasesCreateOrUpdate_568451, schemes: {Scheme.Https})
type
  Call_DatabasesGet_568437 = ref object of OpenApiRestCall_567668
proc url_DatabasesGet_568439(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesGet_568438(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568440 = path.getOrDefault("resourceGroupName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "resourceGroupName", valid_568440
  var valid_568441 = path.getOrDefault("serverName")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "serverName", valid_568441
  var valid_568442 = path.getOrDefault("subscriptionId")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "subscriptionId", valid_568442
  var valid_568443 = path.getOrDefault("databaseName")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "databaseName", valid_568443
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568444 = query.getOrDefault("api-version")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "api-version", valid_568444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568445: Call_DatabasesGet_568437; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a database.
  ## 
  let valid = call_568445.validator(path, query, header, formData, body)
  let scheme = call_568445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568445.url(scheme.get, call_568445.host, call_568445.base,
                         call_568445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568445, url, valid)

proc call*(call_568446: Call_DatabasesGet_568437; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string): Recallable =
  ## databasesGet
  ## Gets information about a database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  var path_568447 = newJObject()
  var query_568448 = newJObject()
  add(path_568447, "resourceGroupName", newJString(resourceGroupName))
  add(query_568448, "api-version", newJString(apiVersion))
  add(path_568447, "serverName", newJString(serverName))
  add(path_568447, "subscriptionId", newJString(subscriptionId))
  add(path_568447, "databaseName", newJString(databaseName))
  result = call_568446.call(path_568447, query_568448, nil, nil, nil)

var databasesGet* = Call_DatabasesGet_568437(name: "databasesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/databases/{databaseName}",
    validator: validate_DatabasesGet_568438, base: "", url: url_DatabasesGet_568439,
    schemes: {Scheme.Https})
type
  Call_DatabasesDelete_568463 = ref object of OpenApiRestCall_567668
proc url_DatabasesDelete_568465(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesDelete_568464(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568466 = path.getOrDefault("resourceGroupName")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "resourceGroupName", valid_568466
  var valid_568467 = path.getOrDefault("serverName")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "serverName", valid_568467
  var valid_568468 = path.getOrDefault("subscriptionId")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "subscriptionId", valid_568468
  var valid_568469 = path.getOrDefault("databaseName")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "databaseName", valid_568469
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568470 = query.getOrDefault("api-version")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "api-version", valid_568470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568471: Call_DatabasesDelete_568463; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a database.
  ## 
  let valid = call_568471.validator(path, query, header, formData, body)
  let scheme = call_568471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568471.url(scheme.get, call_568471.host, call_568471.base,
                         call_568471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568471, url, valid)

proc call*(call_568472: Call_DatabasesDelete_568463; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string): Recallable =
  ## databasesDelete
  ## Deletes a database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  var path_568473 = newJObject()
  var query_568474 = newJObject()
  add(path_568473, "resourceGroupName", newJString(resourceGroupName))
  add(query_568474, "api-version", newJString(apiVersion))
  add(path_568473, "serverName", newJString(serverName))
  add(path_568473, "subscriptionId", newJString(subscriptionId))
  add(path_568473, "databaseName", newJString(databaseName))
  result = call_568472.call(path_568473, query_568474, nil, nil, nil)

var databasesDelete* = Call_DatabasesDelete_568463(name: "databasesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/databases/{databaseName}",
    validator: validate_DatabasesDelete_568464, base: "", url: url_DatabasesDelete_568465,
    schemes: {Scheme.Https})
type
  Call_FirewallRulesListByServer_568475 = ref object of OpenApiRestCall_567668
proc url_FirewallRulesListByServer_568477(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/firewallRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesListByServer_568476(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the firewall rules in a given server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568478 = path.getOrDefault("resourceGroupName")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "resourceGroupName", valid_568478
  var valid_568479 = path.getOrDefault("serverName")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "serverName", valid_568479
  var valid_568480 = path.getOrDefault("subscriptionId")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "subscriptionId", valid_568480
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568481 = query.getOrDefault("api-version")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "api-version", valid_568481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568482: Call_FirewallRulesListByServer_568475; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the firewall rules in a given server.
  ## 
  let valid = call_568482.validator(path, query, header, formData, body)
  let scheme = call_568482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568482.url(scheme.get, call_568482.host, call_568482.base,
                         call_568482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568482, url, valid)

proc call*(call_568483: Call_FirewallRulesListByServer_568475;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## firewallRulesListByServer
  ## List all the firewall rules in a given server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568484 = newJObject()
  var query_568485 = newJObject()
  add(path_568484, "resourceGroupName", newJString(resourceGroupName))
  add(query_568485, "api-version", newJString(apiVersion))
  add(path_568484, "serverName", newJString(serverName))
  add(path_568484, "subscriptionId", newJString(subscriptionId))
  result = call_568483.call(path_568484, query_568485, nil, nil, nil)

var firewallRulesListByServer* = Call_FirewallRulesListByServer_568475(
    name: "firewallRulesListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/firewallRules",
    validator: validate_FirewallRulesListByServer_568476, base: "",
    url: url_FirewallRulesListByServer_568477, schemes: {Scheme.Https})
type
  Call_FirewallRulesCreateOrUpdate_568498 = ref object of OpenApiRestCall_567668
proc url_FirewallRulesCreateOrUpdate_568500(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "firewallRuleName" in path,
        "`firewallRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesCreateOrUpdate_568499(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new firewall rule or updates an existing firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the server firewall rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568501 = path.getOrDefault("resourceGroupName")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "resourceGroupName", valid_568501
  var valid_568502 = path.getOrDefault("serverName")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "serverName", valid_568502
  var valid_568503 = path.getOrDefault("subscriptionId")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "subscriptionId", valid_568503
  var valid_568504 = path.getOrDefault("firewallRuleName")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "firewallRuleName", valid_568504
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568505 = query.getOrDefault("api-version")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "api-version", valid_568505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The required parameters for creating or updating a firewall rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568507: Call_FirewallRulesCreateOrUpdate_568498; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new firewall rule or updates an existing firewall rule.
  ## 
  let valid = call_568507.validator(path, query, header, formData, body)
  let scheme = call_568507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568507.url(scheme.get, call_568507.host, call_568507.base,
                         call_568507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568507, url, valid)

proc call*(call_568508: Call_FirewallRulesCreateOrUpdate_568498;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; parameters: JsonNode; firewallRuleName: string): Recallable =
  ## firewallRulesCreateOrUpdate
  ## Creates a new firewall rule or updates an existing firewall rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The required parameters for creating or updating a firewall rule.
  ##   firewallRuleName: string (required)
  ##                   : The name of the server firewall rule.
  var path_568509 = newJObject()
  var query_568510 = newJObject()
  var body_568511 = newJObject()
  add(path_568509, "resourceGroupName", newJString(resourceGroupName))
  add(query_568510, "api-version", newJString(apiVersion))
  add(path_568509, "serverName", newJString(serverName))
  add(path_568509, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568511 = parameters
  add(path_568509, "firewallRuleName", newJString(firewallRuleName))
  result = call_568508.call(path_568509, query_568510, nil, nil, body_568511)

var firewallRulesCreateOrUpdate* = Call_FirewallRulesCreateOrUpdate_568498(
    name: "firewallRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesCreateOrUpdate_568499, base: "",
    url: url_FirewallRulesCreateOrUpdate_568500, schemes: {Scheme.Https})
type
  Call_FirewallRulesGet_568486 = ref object of OpenApiRestCall_567668
proc url_FirewallRulesGet_568488(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "firewallRuleName" in path,
        "`firewallRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesGet_568487(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets information about a server firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the server firewall rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568489 = path.getOrDefault("resourceGroupName")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "resourceGroupName", valid_568489
  var valid_568490 = path.getOrDefault("serverName")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "serverName", valid_568490
  var valid_568491 = path.getOrDefault("subscriptionId")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "subscriptionId", valid_568491
  var valid_568492 = path.getOrDefault("firewallRuleName")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "firewallRuleName", valid_568492
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568493 = query.getOrDefault("api-version")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "api-version", valid_568493
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568494: Call_FirewallRulesGet_568486; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a server firewall rule.
  ## 
  let valid = call_568494.validator(path, query, header, formData, body)
  let scheme = call_568494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568494.url(scheme.get, call_568494.host, call_568494.base,
                         call_568494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568494, url, valid)

proc call*(call_568495: Call_FirewallRulesGet_568486; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          firewallRuleName: string): Recallable =
  ## firewallRulesGet
  ## Gets information about a server firewall rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   firewallRuleName: string (required)
  ##                   : The name of the server firewall rule.
  var path_568496 = newJObject()
  var query_568497 = newJObject()
  add(path_568496, "resourceGroupName", newJString(resourceGroupName))
  add(query_568497, "api-version", newJString(apiVersion))
  add(path_568496, "serverName", newJString(serverName))
  add(path_568496, "subscriptionId", newJString(subscriptionId))
  add(path_568496, "firewallRuleName", newJString(firewallRuleName))
  result = call_568495.call(path_568496, query_568497, nil, nil, nil)

var firewallRulesGet* = Call_FirewallRulesGet_568486(name: "firewallRulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesGet_568487, base: "",
    url: url_FirewallRulesGet_568488, schemes: {Scheme.Https})
type
  Call_FirewallRulesDelete_568512 = ref object of OpenApiRestCall_567668
proc url_FirewallRulesDelete_568514(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "firewallRuleName" in path,
        "`firewallRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesDelete_568513(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a server firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the server firewall rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568515 = path.getOrDefault("resourceGroupName")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "resourceGroupName", valid_568515
  var valid_568516 = path.getOrDefault("serverName")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "serverName", valid_568516
  var valid_568517 = path.getOrDefault("subscriptionId")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "subscriptionId", valid_568517
  var valid_568518 = path.getOrDefault("firewallRuleName")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "firewallRuleName", valid_568518
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568519 = query.getOrDefault("api-version")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "api-version", valid_568519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568520: Call_FirewallRulesDelete_568512; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a server firewall rule.
  ## 
  let valid = call_568520.validator(path, query, header, formData, body)
  let scheme = call_568520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568520.url(scheme.get, call_568520.host, call_568520.base,
                         call_568520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568520, url, valid)

proc call*(call_568521: Call_FirewallRulesDelete_568512; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          firewallRuleName: string): Recallable =
  ## firewallRulesDelete
  ## Deletes a server firewall rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   firewallRuleName: string (required)
  ##                   : The name of the server firewall rule.
  var path_568522 = newJObject()
  var query_568523 = newJObject()
  add(path_568522, "resourceGroupName", newJString(resourceGroupName))
  add(query_568523, "api-version", newJString(apiVersion))
  add(path_568522, "serverName", newJString(serverName))
  add(path_568522, "subscriptionId", newJString(subscriptionId))
  add(path_568522, "firewallRuleName", newJString(firewallRuleName))
  result = call_568521.call(path_568522, query_568523, nil, nil, nil)

var firewallRulesDelete* = Call_FirewallRulesDelete_568512(
    name: "firewallRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesDelete_568513, base: "",
    url: url_FirewallRulesDelete_568514, schemes: {Scheme.Https})
type
  Call_LogFilesListByServer_568524 = ref object of OpenApiRestCall_567668
proc url_LogFilesListByServer_568526(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/logFiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LogFilesListByServer_568525(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the log files in a given server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568527 = path.getOrDefault("resourceGroupName")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "resourceGroupName", valid_568527
  var valid_568528 = path.getOrDefault("serverName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "serverName", valid_568528
  var valid_568529 = path.getOrDefault("subscriptionId")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "subscriptionId", valid_568529
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568530 = query.getOrDefault("api-version")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "api-version", valid_568530
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568531: Call_LogFilesListByServer_568524; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the log files in a given server.
  ## 
  let valid = call_568531.validator(path, query, header, formData, body)
  let scheme = call_568531.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568531.url(scheme.get, call_568531.host, call_568531.base,
                         call_568531.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568531, url, valid)

proc call*(call_568532: Call_LogFilesListByServer_568524;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## logFilesListByServer
  ## List all the log files in a given server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568533 = newJObject()
  var query_568534 = newJObject()
  add(path_568533, "resourceGroupName", newJString(resourceGroupName))
  add(query_568534, "api-version", newJString(apiVersion))
  add(path_568533, "serverName", newJString(serverName))
  add(path_568533, "subscriptionId", newJString(subscriptionId))
  result = call_568532.call(path_568533, query_568534, nil, nil, nil)

var logFilesListByServer* = Call_LogFilesListByServer_568524(
    name: "logFilesListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/logFiles",
    validator: validate_LogFilesListByServer_568525, base: "",
    url: url_LogFilesListByServer_568526, schemes: {Scheme.Https})
type
  Call_QueryTextsListByServer_568535 = ref object of OpenApiRestCall_567668
proc url_QueryTextsListByServer_568537(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/queryTexts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryTextsListByServer_568536(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the Query-Store query texts for specified queryIds.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568538 = path.getOrDefault("resourceGroupName")
  valid_568538 = validateParameter(valid_568538, JString, required = true,
                                 default = nil)
  if valid_568538 != nil:
    section.add "resourceGroupName", valid_568538
  var valid_568539 = path.getOrDefault("serverName")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "serverName", valid_568539
  var valid_568540 = path.getOrDefault("subscriptionId")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "subscriptionId", valid_568540
  result.add "path", section
  ## parameters in `query` object:
  ##   queryIds: JArray (required)
  ##           : The query identifiers
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `queryIds` field"
  var valid_568541 = query.getOrDefault("queryIds")
  valid_568541 = validateParameter(valid_568541, JArray, required = true, default = nil)
  if valid_568541 != nil:
    section.add "queryIds", valid_568541
  var valid_568542 = query.getOrDefault("api-version")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "api-version", valid_568542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568543: Call_QueryTextsListByServer_568535; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the Query-Store query texts for specified queryIds.
  ## 
  let valid = call_568543.validator(path, query, header, formData, body)
  let scheme = call_568543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568543.url(scheme.get, call_568543.host, call_568543.base,
                         call_568543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568543, url, valid)

proc call*(call_568544: Call_QueryTextsListByServer_568535; queryIds: JsonNode;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## queryTextsListByServer
  ## Retrieve the Query-Store query texts for specified queryIds.
  ##   queryIds: JArray (required)
  ##           : The query identifiers
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568545 = newJObject()
  var query_568546 = newJObject()
  if queryIds != nil:
    query_568546.add "queryIds", queryIds
  add(path_568545, "resourceGroupName", newJString(resourceGroupName))
  add(query_568546, "api-version", newJString(apiVersion))
  add(path_568545, "serverName", newJString(serverName))
  add(path_568545, "subscriptionId", newJString(subscriptionId))
  result = call_568544.call(path_568545, query_568546, nil, nil, nil)

var queryTextsListByServer* = Call_QueryTextsListByServer_568535(
    name: "queryTextsListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/queryTexts",
    validator: validate_QueryTextsListByServer_568536, base: "",
    url: url_QueryTextsListByServer_568537, schemes: {Scheme.Https})
type
  Call_QueryTextsGet_568547 = ref object of OpenApiRestCall_567668
proc url_QueryTextsGet_568549(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "queryId" in path, "`queryId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/queryTexts/"),
               (kind: VariableSegment, value: "queryId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryTextsGet_568548(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the Query-Store query texts for the queryId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   queryId: JString (required)
  ##          : The Query-Store query identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `queryId` field"
  var valid_568550 = path.getOrDefault("queryId")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "queryId", valid_568550
  var valid_568551 = path.getOrDefault("resourceGroupName")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "resourceGroupName", valid_568551
  var valid_568552 = path.getOrDefault("serverName")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "serverName", valid_568552
  var valid_568553 = path.getOrDefault("subscriptionId")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "subscriptionId", valid_568553
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568554 = query.getOrDefault("api-version")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "api-version", valid_568554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568555: Call_QueryTextsGet_568547; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the Query-Store query texts for the queryId.
  ## 
  let valid = call_568555.validator(path, query, header, formData, body)
  let scheme = call_568555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568555.url(scheme.get, call_568555.host, call_568555.base,
                         call_568555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568555, url, valid)

proc call*(call_568556: Call_QueryTextsGet_568547; queryId: string;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## queryTextsGet
  ## Retrieve the Query-Store query texts for the queryId.
  ##   queryId: string (required)
  ##          : The Query-Store query identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568557 = newJObject()
  var query_568558 = newJObject()
  add(path_568557, "queryId", newJString(queryId))
  add(path_568557, "resourceGroupName", newJString(resourceGroupName))
  add(query_568558, "api-version", newJString(apiVersion))
  add(path_568557, "serverName", newJString(serverName))
  add(path_568557, "subscriptionId", newJString(subscriptionId))
  result = call_568556.call(path_568557, query_568558, nil, nil, nil)

var queryTextsGet* = Call_QueryTextsGet_568547(name: "queryTextsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/queryTexts/{queryId}",
    validator: validate_QueryTextsGet_568548, base: "", url: url_QueryTextsGet_568549,
    schemes: {Scheme.Https})
type
  Call_ReplicasListByServer_568559 = ref object of OpenApiRestCall_567668
proc url_ReplicasListByServer_568561(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/replicas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicasListByServer_568560(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the replicas for a given server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568562 = path.getOrDefault("resourceGroupName")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "resourceGroupName", valid_568562
  var valid_568563 = path.getOrDefault("serverName")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "serverName", valid_568563
  var valid_568564 = path.getOrDefault("subscriptionId")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "subscriptionId", valid_568564
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568565 = query.getOrDefault("api-version")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "api-version", valid_568565
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568566: Call_ReplicasListByServer_568559; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the replicas for a given server.
  ## 
  let valid = call_568566.validator(path, query, header, formData, body)
  let scheme = call_568566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568566.url(scheme.get, call_568566.host, call_568566.base,
                         call_568566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568566, url, valid)

proc call*(call_568567: Call_ReplicasListByServer_568559;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## replicasListByServer
  ## List all the replicas for a given server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568568 = newJObject()
  var query_568569 = newJObject()
  add(path_568568, "resourceGroupName", newJString(resourceGroupName))
  add(query_568569, "api-version", newJString(apiVersion))
  add(path_568568, "serverName", newJString(serverName))
  add(path_568568, "subscriptionId", newJString(subscriptionId))
  result = call_568567.call(path_568568, query_568569, nil, nil, nil)

var replicasListByServer* = Call_ReplicasListByServer_568559(
    name: "replicasListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/replicas",
    validator: validate_ReplicasListByServer_568560, base: "",
    url: url_ReplicasListByServer_568561, schemes: {Scheme.Https})
type
  Call_ServersRestart_568570 = ref object of OpenApiRestCall_567668
proc url_ServersRestart_568572(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersRestart_568571(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Restarts a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568573 = path.getOrDefault("resourceGroupName")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "resourceGroupName", valid_568573
  var valid_568574 = path.getOrDefault("serverName")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "serverName", valid_568574
  var valid_568575 = path.getOrDefault("subscriptionId")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "subscriptionId", valid_568575
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568576 = query.getOrDefault("api-version")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "api-version", valid_568576
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568577: Call_ServersRestart_568570; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a server.
  ## 
  let valid = call_568577.validator(path, query, header, formData, body)
  let scheme = call_568577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568577.url(scheme.get, call_568577.host, call_568577.base,
                         call_568577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568577, url, valid)

proc call*(call_568578: Call_ServersRestart_568570; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string): Recallable =
  ## serversRestart
  ## Restarts a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568579 = newJObject()
  var query_568580 = newJObject()
  add(path_568579, "resourceGroupName", newJString(resourceGroupName))
  add(query_568580, "api-version", newJString(apiVersion))
  add(path_568579, "serverName", newJString(serverName))
  add(path_568579, "subscriptionId", newJString(subscriptionId))
  result = call_568578.call(path_568579, query_568580, nil, nil, nil)

var serversRestart* = Call_ServersRestart_568570(name: "serversRestart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/restart",
    validator: validate_ServersRestart_568571, base: "", url: url_ServersRestart_568572,
    schemes: {Scheme.Https})
type
  Call_ServerSecurityAlertPoliciesCreateOrUpdate_568606 = ref object of OpenApiRestCall_567668
proc url_ServerSecurityAlertPoliciesCreateOrUpdate_568608(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "securityAlertPolicyName" in path,
        "`securityAlertPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/securityAlertPolicies/"),
               (kind: VariableSegment, value: "securityAlertPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerSecurityAlertPoliciesCreateOrUpdate_568607(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a threat detection policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   securityAlertPolicyName: JString (required)
  ##                          : The name of the threat detection policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568609 = path.getOrDefault("resourceGroupName")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "resourceGroupName", valid_568609
  var valid_568610 = path.getOrDefault("serverName")
  valid_568610 = validateParameter(valid_568610, JString, required = true,
                                 default = nil)
  if valid_568610 != nil:
    section.add "serverName", valid_568610
  var valid_568611 = path.getOrDefault("subscriptionId")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = nil)
  if valid_568611 != nil:
    section.add "subscriptionId", valid_568611
  var valid_568612 = path.getOrDefault("securityAlertPolicyName")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = newJString("Default"))
  if valid_568612 != nil:
    section.add "securityAlertPolicyName", valid_568612
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568613 = query.getOrDefault("api-version")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "api-version", valid_568613
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The server security alert policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568615: Call_ServerSecurityAlertPoliciesCreateOrUpdate_568606;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a threat detection policy.
  ## 
  let valid = call_568615.validator(path, query, header, formData, body)
  let scheme = call_568615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568615.url(scheme.get, call_568615.host, call_568615.base,
                         call_568615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568615, url, valid)

proc call*(call_568616: Call_ServerSecurityAlertPoliciesCreateOrUpdate_568606;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; parameters: JsonNode;
          securityAlertPolicyName: string = "Default"): Recallable =
  ## serverSecurityAlertPoliciesCreateOrUpdate
  ## Creates or updates a threat detection policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   securityAlertPolicyName: string (required)
  ##                          : The name of the threat detection policy.
  ##   parameters: JObject (required)
  ##             : The server security alert policy.
  var path_568617 = newJObject()
  var query_568618 = newJObject()
  var body_568619 = newJObject()
  add(path_568617, "resourceGroupName", newJString(resourceGroupName))
  add(query_568618, "api-version", newJString(apiVersion))
  add(path_568617, "serverName", newJString(serverName))
  add(path_568617, "subscriptionId", newJString(subscriptionId))
  add(path_568617, "securityAlertPolicyName", newJString(securityAlertPolicyName))
  if parameters != nil:
    body_568619 = parameters
  result = call_568616.call(path_568617, query_568618, nil, nil, body_568619)

var serverSecurityAlertPoliciesCreateOrUpdate* = Call_ServerSecurityAlertPoliciesCreateOrUpdate_568606(
    name: "serverSecurityAlertPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/securityAlertPolicies/{securityAlertPolicyName}",
    validator: validate_ServerSecurityAlertPoliciesCreateOrUpdate_568607,
    base: "", url: url_ServerSecurityAlertPoliciesCreateOrUpdate_568608,
    schemes: {Scheme.Https})
type
  Call_ServerSecurityAlertPoliciesGet_568581 = ref object of OpenApiRestCall_567668
proc url_ServerSecurityAlertPoliciesGet_568583(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "securityAlertPolicyName" in path,
        "`securityAlertPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/securityAlertPolicies/"),
               (kind: VariableSegment, value: "securityAlertPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerSecurityAlertPoliciesGet_568582(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a server's security alert policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   securityAlertPolicyName: JString (required)
  ##                          : The name of the security alert policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568584 = path.getOrDefault("resourceGroupName")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "resourceGroupName", valid_568584
  var valid_568585 = path.getOrDefault("serverName")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "serverName", valid_568585
  var valid_568586 = path.getOrDefault("subscriptionId")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "subscriptionId", valid_568586
  var valid_568600 = path.getOrDefault("securityAlertPolicyName")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = newJString("Default"))
  if valid_568600 != nil:
    section.add "securityAlertPolicyName", valid_568600
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568601 = query.getOrDefault("api-version")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "api-version", valid_568601
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568602: Call_ServerSecurityAlertPoliciesGet_568581; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a server's security alert policy.
  ## 
  let valid = call_568602.validator(path, query, header, formData, body)
  let scheme = call_568602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568602.url(scheme.get, call_568602.host, call_568602.base,
                         call_568602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568602, url, valid)

proc call*(call_568603: Call_ServerSecurityAlertPoliciesGet_568581;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; securityAlertPolicyName: string = "Default"): Recallable =
  ## serverSecurityAlertPoliciesGet
  ## Get a server's security alert policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   securityAlertPolicyName: string (required)
  ##                          : The name of the security alert policy.
  var path_568604 = newJObject()
  var query_568605 = newJObject()
  add(path_568604, "resourceGroupName", newJString(resourceGroupName))
  add(query_568605, "api-version", newJString(apiVersion))
  add(path_568604, "serverName", newJString(serverName))
  add(path_568604, "subscriptionId", newJString(subscriptionId))
  add(path_568604, "securityAlertPolicyName", newJString(securityAlertPolicyName))
  result = call_568603.call(path_568604, query_568605, nil, nil, nil)

var serverSecurityAlertPoliciesGet* = Call_ServerSecurityAlertPoliciesGet_568581(
    name: "serverSecurityAlertPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/securityAlertPolicies/{securityAlertPolicyName}",
    validator: validate_ServerSecurityAlertPoliciesGet_568582, base: "",
    url: url_ServerSecurityAlertPoliciesGet_568583, schemes: {Scheme.Https})
type
  Call_TopQueryStatisticsListByServer_568620 = ref object of OpenApiRestCall_567668
proc url_TopQueryStatisticsListByServer_568622(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/topQueryStatistics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopQueryStatisticsListByServer_568621(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the Query-Store top queries for specified metric and aggregation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568623 = path.getOrDefault("resourceGroupName")
  valid_568623 = validateParameter(valid_568623, JString, required = true,
                                 default = nil)
  if valid_568623 != nil:
    section.add "resourceGroupName", valid_568623
  var valid_568624 = path.getOrDefault("serverName")
  valid_568624 = validateParameter(valid_568624, JString, required = true,
                                 default = nil)
  if valid_568624 != nil:
    section.add "serverName", valid_568624
  var valid_568625 = path.getOrDefault("subscriptionId")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "subscriptionId", valid_568625
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568626 = query.getOrDefault("api-version")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "api-version", valid_568626
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The required parameters for retrieving top query statistics.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568628: Call_TopQueryStatisticsListByServer_568620; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the Query-Store top queries for specified metric and aggregation.
  ## 
  let valid = call_568628.validator(path, query, header, formData, body)
  let scheme = call_568628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568628.url(scheme.get, call_568628.host, call_568628.base,
                         call_568628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568628, url, valid)

proc call*(call_568629: Call_TopQueryStatisticsListByServer_568620;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## topQueryStatisticsListByServer
  ## Retrieve the Query-Store top queries for specified metric and aggregation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The required parameters for retrieving top query statistics.
  var path_568630 = newJObject()
  var query_568631 = newJObject()
  var body_568632 = newJObject()
  add(path_568630, "resourceGroupName", newJString(resourceGroupName))
  add(query_568631, "api-version", newJString(apiVersion))
  add(path_568630, "serverName", newJString(serverName))
  add(path_568630, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568632 = parameters
  result = call_568629.call(path_568630, query_568631, nil, nil, body_568632)

var topQueryStatisticsListByServer* = Call_TopQueryStatisticsListByServer_568620(
    name: "topQueryStatisticsListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/topQueryStatistics",
    validator: validate_TopQueryStatisticsListByServer_568621, base: "",
    url: url_TopQueryStatisticsListByServer_568622, schemes: {Scheme.Https})
type
  Call_TopQueryStatisticsGet_568633 = ref object of OpenApiRestCall_567668
proc url_TopQueryStatisticsGet_568635(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "queryStatisticId" in path,
        "`queryStatisticId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/topQueryStatistics/"),
               (kind: VariableSegment, value: "queryStatisticId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopQueryStatisticsGet_568634(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the query statistic for specified identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   queryStatisticId: JString (required)
  ##                   : The Query Statistic identifier.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568636 = path.getOrDefault("resourceGroupName")
  valid_568636 = validateParameter(valid_568636, JString, required = true,
                                 default = nil)
  if valid_568636 != nil:
    section.add "resourceGroupName", valid_568636
  var valid_568637 = path.getOrDefault("queryStatisticId")
  valid_568637 = validateParameter(valid_568637, JString, required = true,
                                 default = nil)
  if valid_568637 != nil:
    section.add "queryStatisticId", valid_568637
  var valid_568638 = path.getOrDefault("serverName")
  valid_568638 = validateParameter(valid_568638, JString, required = true,
                                 default = nil)
  if valid_568638 != nil:
    section.add "serverName", valid_568638
  var valid_568639 = path.getOrDefault("subscriptionId")
  valid_568639 = validateParameter(valid_568639, JString, required = true,
                                 default = nil)
  if valid_568639 != nil:
    section.add "subscriptionId", valid_568639
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568640 = query.getOrDefault("api-version")
  valid_568640 = validateParameter(valid_568640, JString, required = true,
                                 default = nil)
  if valid_568640 != nil:
    section.add "api-version", valid_568640
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568641: Call_TopQueryStatisticsGet_568633; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the query statistic for specified identifier.
  ## 
  let valid = call_568641.validator(path, query, header, formData, body)
  let scheme = call_568641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568641.url(scheme.get, call_568641.host, call_568641.base,
                         call_568641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568641, url, valid)

proc call*(call_568642: Call_TopQueryStatisticsGet_568633;
          resourceGroupName: string; apiVersion: string; queryStatisticId: string;
          serverName: string; subscriptionId: string): Recallable =
  ## topQueryStatisticsGet
  ## Retrieve the query statistic for specified identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   queryStatisticId: string (required)
  ##                   : The Query Statistic identifier.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568643 = newJObject()
  var query_568644 = newJObject()
  add(path_568643, "resourceGroupName", newJString(resourceGroupName))
  add(query_568644, "api-version", newJString(apiVersion))
  add(path_568643, "queryStatisticId", newJString(queryStatisticId))
  add(path_568643, "serverName", newJString(serverName))
  add(path_568643, "subscriptionId", newJString(subscriptionId))
  result = call_568642.call(path_568643, query_568644, nil, nil, nil)

var topQueryStatisticsGet* = Call_TopQueryStatisticsGet_568633(
    name: "topQueryStatisticsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/topQueryStatistics/{queryStatisticId}",
    validator: validate_TopQueryStatisticsGet_568634, base: "",
    url: url_TopQueryStatisticsGet_568635, schemes: {Scheme.Https})
type
  Call_VirtualNetworkRulesListByServer_568645 = ref object of OpenApiRestCall_567668
proc url_VirtualNetworkRulesListByServer_568647(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/virtualNetworkRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkRulesListByServer_568646(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of virtual network rules in a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568648 = path.getOrDefault("resourceGroupName")
  valid_568648 = validateParameter(valid_568648, JString, required = true,
                                 default = nil)
  if valid_568648 != nil:
    section.add "resourceGroupName", valid_568648
  var valid_568649 = path.getOrDefault("serverName")
  valid_568649 = validateParameter(valid_568649, JString, required = true,
                                 default = nil)
  if valid_568649 != nil:
    section.add "serverName", valid_568649
  var valid_568650 = path.getOrDefault("subscriptionId")
  valid_568650 = validateParameter(valid_568650, JString, required = true,
                                 default = nil)
  if valid_568650 != nil:
    section.add "subscriptionId", valid_568650
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568651 = query.getOrDefault("api-version")
  valid_568651 = validateParameter(valid_568651, JString, required = true,
                                 default = nil)
  if valid_568651 != nil:
    section.add "api-version", valid_568651
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568652: Call_VirtualNetworkRulesListByServer_568645;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual network rules in a server.
  ## 
  let valid = call_568652.validator(path, query, header, formData, body)
  let scheme = call_568652.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568652.url(scheme.get, call_568652.host, call_568652.base,
                         call_568652.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568652, url, valid)

proc call*(call_568653: Call_VirtualNetworkRulesListByServer_568645;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## virtualNetworkRulesListByServer
  ## Gets a list of virtual network rules in a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568654 = newJObject()
  var query_568655 = newJObject()
  add(path_568654, "resourceGroupName", newJString(resourceGroupName))
  add(query_568655, "api-version", newJString(apiVersion))
  add(path_568654, "serverName", newJString(serverName))
  add(path_568654, "subscriptionId", newJString(subscriptionId))
  result = call_568653.call(path_568654, query_568655, nil, nil, nil)

var virtualNetworkRulesListByServer* = Call_VirtualNetworkRulesListByServer_568645(
    name: "virtualNetworkRulesListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/virtualNetworkRules",
    validator: validate_VirtualNetworkRulesListByServer_568646, base: "",
    url: url_VirtualNetworkRulesListByServer_568647, schemes: {Scheme.Https})
type
  Call_VirtualNetworkRulesCreateOrUpdate_568668 = ref object of OpenApiRestCall_567668
proc url_VirtualNetworkRulesCreateOrUpdate_568670(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "virtualNetworkRuleName" in path,
        "`virtualNetworkRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/virtualNetworkRules/"),
               (kind: VariableSegment, value: "virtualNetworkRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkRulesCreateOrUpdate_568669(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an existing virtual network rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   virtualNetworkRuleName: JString (required)
  ##                         : The name of the virtual network rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568671 = path.getOrDefault("resourceGroupName")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "resourceGroupName", valid_568671
  var valid_568672 = path.getOrDefault("serverName")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "serverName", valid_568672
  var valid_568673 = path.getOrDefault("subscriptionId")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = nil)
  if valid_568673 != nil:
    section.add "subscriptionId", valid_568673
  var valid_568674 = path.getOrDefault("virtualNetworkRuleName")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = nil)
  if valid_568674 != nil:
    section.add "virtualNetworkRuleName", valid_568674
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568675 = query.getOrDefault("api-version")
  valid_568675 = validateParameter(valid_568675, JString, required = true,
                                 default = nil)
  if valid_568675 != nil:
    section.add "api-version", valid_568675
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The requested virtual Network Rule Resource state.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568677: Call_VirtualNetworkRulesCreateOrUpdate_568668;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an existing virtual network rule.
  ## 
  let valid = call_568677.validator(path, query, header, formData, body)
  let scheme = call_568677.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568677.url(scheme.get, call_568677.host, call_568677.base,
                         call_568677.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568677, url, valid)

proc call*(call_568678: Call_VirtualNetworkRulesCreateOrUpdate_568668;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; virtualNetworkRuleName: string;
          parameters: JsonNode): Recallable =
  ## virtualNetworkRulesCreateOrUpdate
  ## Creates or updates an existing virtual network rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   virtualNetworkRuleName: string (required)
  ##                         : The name of the virtual network rule.
  ##   parameters: JObject (required)
  ##             : The requested virtual Network Rule Resource state.
  var path_568679 = newJObject()
  var query_568680 = newJObject()
  var body_568681 = newJObject()
  add(path_568679, "resourceGroupName", newJString(resourceGroupName))
  add(query_568680, "api-version", newJString(apiVersion))
  add(path_568679, "serverName", newJString(serverName))
  add(path_568679, "subscriptionId", newJString(subscriptionId))
  add(path_568679, "virtualNetworkRuleName", newJString(virtualNetworkRuleName))
  if parameters != nil:
    body_568681 = parameters
  result = call_568678.call(path_568679, query_568680, nil, nil, body_568681)

var virtualNetworkRulesCreateOrUpdate* = Call_VirtualNetworkRulesCreateOrUpdate_568668(
    name: "virtualNetworkRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/virtualNetworkRules/{virtualNetworkRuleName}",
    validator: validate_VirtualNetworkRulesCreateOrUpdate_568669, base: "",
    url: url_VirtualNetworkRulesCreateOrUpdate_568670, schemes: {Scheme.Https})
type
  Call_VirtualNetworkRulesGet_568656 = ref object of OpenApiRestCall_567668
proc url_VirtualNetworkRulesGet_568658(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "virtualNetworkRuleName" in path,
        "`virtualNetworkRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/virtualNetworkRules/"),
               (kind: VariableSegment, value: "virtualNetworkRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkRulesGet_568657(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a virtual network rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   virtualNetworkRuleName: JString (required)
  ##                         : The name of the virtual network rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568659 = path.getOrDefault("resourceGroupName")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "resourceGroupName", valid_568659
  var valid_568660 = path.getOrDefault("serverName")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = nil)
  if valid_568660 != nil:
    section.add "serverName", valid_568660
  var valid_568661 = path.getOrDefault("subscriptionId")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = nil)
  if valid_568661 != nil:
    section.add "subscriptionId", valid_568661
  var valid_568662 = path.getOrDefault("virtualNetworkRuleName")
  valid_568662 = validateParameter(valid_568662, JString, required = true,
                                 default = nil)
  if valid_568662 != nil:
    section.add "virtualNetworkRuleName", valid_568662
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568663 = query.getOrDefault("api-version")
  valid_568663 = validateParameter(valid_568663, JString, required = true,
                                 default = nil)
  if valid_568663 != nil:
    section.add "api-version", valid_568663
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568664: Call_VirtualNetworkRulesGet_568656; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual network rule.
  ## 
  let valid = call_568664.validator(path, query, header, formData, body)
  let scheme = call_568664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568664.url(scheme.get, call_568664.host, call_568664.base,
                         call_568664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568664, url, valid)

proc call*(call_568665: Call_VirtualNetworkRulesGet_568656;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; virtualNetworkRuleName: string): Recallable =
  ## virtualNetworkRulesGet
  ## Gets a virtual network rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   virtualNetworkRuleName: string (required)
  ##                         : The name of the virtual network rule.
  var path_568666 = newJObject()
  var query_568667 = newJObject()
  add(path_568666, "resourceGroupName", newJString(resourceGroupName))
  add(query_568667, "api-version", newJString(apiVersion))
  add(path_568666, "serverName", newJString(serverName))
  add(path_568666, "subscriptionId", newJString(subscriptionId))
  add(path_568666, "virtualNetworkRuleName", newJString(virtualNetworkRuleName))
  result = call_568665.call(path_568666, query_568667, nil, nil, nil)

var virtualNetworkRulesGet* = Call_VirtualNetworkRulesGet_568656(
    name: "virtualNetworkRulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/virtualNetworkRules/{virtualNetworkRuleName}",
    validator: validate_VirtualNetworkRulesGet_568657, base: "",
    url: url_VirtualNetworkRulesGet_568658, schemes: {Scheme.Https})
type
  Call_VirtualNetworkRulesDelete_568682 = ref object of OpenApiRestCall_567668
proc url_VirtualNetworkRulesDelete_568684(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "virtualNetworkRuleName" in path,
        "`virtualNetworkRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/virtualNetworkRules/"),
               (kind: VariableSegment, value: "virtualNetworkRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkRulesDelete_568683(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the virtual network rule with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   virtualNetworkRuleName: JString (required)
  ##                         : The name of the virtual network rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568685 = path.getOrDefault("resourceGroupName")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "resourceGroupName", valid_568685
  var valid_568686 = path.getOrDefault("serverName")
  valid_568686 = validateParameter(valid_568686, JString, required = true,
                                 default = nil)
  if valid_568686 != nil:
    section.add "serverName", valid_568686
  var valid_568687 = path.getOrDefault("subscriptionId")
  valid_568687 = validateParameter(valid_568687, JString, required = true,
                                 default = nil)
  if valid_568687 != nil:
    section.add "subscriptionId", valid_568687
  var valid_568688 = path.getOrDefault("virtualNetworkRuleName")
  valid_568688 = validateParameter(valid_568688, JString, required = true,
                                 default = nil)
  if valid_568688 != nil:
    section.add "virtualNetworkRuleName", valid_568688
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568689 = query.getOrDefault("api-version")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = nil)
  if valid_568689 != nil:
    section.add "api-version", valid_568689
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568690: Call_VirtualNetworkRulesDelete_568682; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the virtual network rule with the given name.
  ## 
  let valid = call_568690.validator(path, query, header, formData, body)
  let scheme = call_568690.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568690.url(scheme.get, call_568690.host, call_568690.base,
                         call_568690.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568690, url, valid)

proc call*(call_568691: Call_VirtualNetworkRulesDelete_568682;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; virtualNetworkRuleName: string): Recallable =
  ## virtualNetworkRulesDelete
  ## Deletes the virtual network rule with the given name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   virtualNetworkRuleName: string (required)
  ##                         : The name of the virtual network rule.
  var path_568692 = newJObject()
  var query_568693 = newJObject()
  add(path_568692, "resourceGroupName", newJString(resourceGroupName))
  add(query_568693, "api-version", newJString(apiVersion))
  add(path_568692, "serverName", newJString(serverName))
  add(path_568692, "subscriptionId", newJString(subscriptionId))
  add(path_568692, "virtualNetworkRuleName", newJString(virtualNetworkRuleName))
  result = call_568691.call(path_568692, query_568693, nil, nil, nil)

var virtualNetworkRulesDelete* = Call_VirtualNetworkRulesDelete_568682(
    name: "virtualNetworkRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/virtualNetworkRules/{virtualNetworkRuleName}",
    validator: validate_VirtualNetworkRulesDelete_568683, base: "",
    url: url_VirtualNetworkRulesDelete_568684, schemes: {Scheme.Https})
type
  Call_WaitStatisticsListByServer_568694 = ref object of OpenApiRestCall_567668
proc url_WaitStatisticsListByServer_568696(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/waitStatistics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WaitStatisticsListByServer_568695(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve wait statistics for specified aggregation window.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568697 = path.getOrDefault("resourceGroupName")
  valid_568697 = validateParameter(valid_568697, JString, required = true,
                                 default = nil)
  if valid_568697 != nil:
    section.add "resourceGroupName", valid_568697
  var valid_568698 = path.getOrDefault("serverName")
  valid_568698 = validateParameter(valid_568698, JString, required = true,
                                 default = nil)
  if valid_568698 != nil:
    section.add "serverName", valid_568698
  var valid_568699 = path.getOrDefault("subscriptionId")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "subscriptionId", valid_568699
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568700 = query.getOrDefault("api-version")
  valid_568700 = validateParameter(valid_568700, JString, required = true,
                                 default = nil)
  if valid_568700 != nil:
    section.add "api-version", valid_568700
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The required parameters for retrieving wait statistics.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568702: Call_WaitStatisticsListByServer_568694; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve wait statistics for specified aggregation window.
  ## 
  let valid = call_568702.validator(path, query, header, formData, body)
  let scheme = call_568702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568702.url(scheme.get, call_568702.host, call_568702.base,
                         call_568702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568702, url, valid)

proc call*(call_568703: Call_WaitStatisticsListByServer_568694;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## waitStatisticsListByServer
  ## Retrieve wait statistics for specified aggregation window.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The required parameters for retrieving wait statistics.
  var path_568704 = newJObject()
  var query_568705 = newJObject()
  var body_568706 = newJObject()
  add(path_568704, "resourceGroupName", newJString(resourceGroupName))
  add(query_568705, "api-version", newJString(apiVersion))
  add(path_568704, "serverName", newJString(serverName))
  add(path_568704, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568706 = parameters
  result = call_568703.call(path_568704, query_568705, nil, nil, body_568706)

var waitStatisticsListByServer* = Call_WaitStatisticsListByServer_568694(
    name: "waitStatisticsListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/waitStatistics",
    validator: validate_WaitStatisticsListByServer_568695, base: "",
    url: url_WaitStatisticsListByServer_568696, schemes: {Scheme.Https})
type
  Call_WaitStatisticsGet_568707 = ref object of OpenApiRestCall_567668
proc url_WaitStatisticsGet_568709(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "waitStatisticsId" in path,
        "`waitStatisticsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMySQL/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/waitStatistics/"),
               (kind: VariableSegment, value: "waitStatisticsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WaitStatisticsGet_568708(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieve wait statistics for specified identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   waitStatisticsId: JString (required)
  ##                   : The Wait Statistic identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568710 = path.getOrDefault("resourceGroupName")
  valid_568710 = validateParameter(valid_568710, JString, required = true,
                                 default = nil)
  if valid_568710 != nil:
    section.add "resourceGroupName", valid_568710
  var valid_568711 = path.getOrDefault("serverName")
  valid_568711 = validateParameter(valid_568711, JString, required = true,
                                 default = nil)
  if valid_568711 != nil:
    section.add "serverName", valid_568711
  var valid_568712 = path.getOrDefault("subscriptionId")
  valid_568712 = validateParameter(valid_568712, JString, required = true,
                                 default = nil)
  if valid_568712 != nil:
    section.add "subscriptionId", valid_568712
  var valid_568713 = path.getOrDefault("waitStatisticsId")
  valid_568713 = validateParameter(valid_568713, JString, required = true,
                                 default = nil)
  if valid_568713 != nil:
    section.add "waitStatisticsId", valid_568713
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568714 = query.getOrDefault("api-version")
  valid_568714 = validateParameter(valid_568714, JString, required = true,
                                 default = nil)
  if valid_568714 != nil:
    section.add "api-version", valid_568714
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568715: Call_WaitStatisticsGet_568707; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve wait statistics for specified identifier.
  ## 
  let valid = call_568715.validator(path, query, header, formData, body)
  let scheme = call_568715.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568715.url(scheme.get, call_568715.host, call_568715.base,
                         call_568715.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568715, url, valid)

proc call*(call_568716: Call_WaitStatisticsGet_568707; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          waitStatisticsId: string): Recallable =
  ## waitStatisticsGet
  ## Retrieve wait statistics for specified identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   waitStatisticsId: string (required)
  ##                   : The Wait Statistic identifier.
  var path_568717 = newJObject()
  var query_568718 = newJObject()
  add(path_568717, "resourceGroupName", newJString(resourceGroupName))
  add(query_568718, "api-version", newJString(apiVersion))
  add(path_568717, "serverName", newJString(serverName))
  add(path_568717, "subscriptionId", newJString(subscriptionId))
  add(path_568717, "waitStatisticsId", newJString(waitStatisticsId))
  result = call_568716.call(path_568717, query_568718, nil, nil, nil)

var waitStatisticsGet* = Call_WaitStatisticsGet_568707(name: "waitStatisticsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMySQL/servers/{serverName}/waitStatistics/{waitStatisticsId}",
    validator: validate_WaitStatisticsGet_568708, base: "",
    url: url_WaitStatisticsGet_568709, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
