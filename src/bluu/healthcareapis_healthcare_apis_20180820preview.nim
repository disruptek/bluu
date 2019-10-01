
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: HealthcareApisClient
## version: 2018-08-20-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Use this API to manage Microsoft HealthcareApis services in your Azure subscription.
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "healthcareapis-healthcare-apis"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567879 = ref object of OpenApiRestCall_567657
proc url_OperationsList_567881(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567880(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Healthcare service REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568053 = query.getOrDefault("api-version")
  valid_568053 = validateParameter(valid_568053, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_568053 != nil:
    section.add "api-version", valid_568053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568076: Call_OperationsList_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Healthcare service REST API operations.
  ## 
  let valid = call_568076.validator(path, query, header, formData, body)
  let scheme = call_568076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568076.url(scheme.get, call_568076.host, call_568076.base,
                         call_568076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568076, url, valid)

proc call*(call_568147: Call_OperationsList_567879;
          apiVersion: string = "2018-08-20-preview"): Recallable =
  ## operationsList
  ## Lists all of the available Healthcare service REST API operations.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  var query_568148 = newJObject()
  add(query_568148, "api-version", newJString(apiVersion))
  result = call_568147.call(nil, query_568148, nil, nil, nil)

var operationsList* = Call_OperationsList_567879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.HealthcareApis/operations",
    validator: validate_OperationsList_567880, base: "", url: url_OperationsList_567881,
    schemes: {Scheme.Https})
type
  Call_ServicesCheckNameAvailability_568188 = ref object of OpenApiRestCall_567657
proc url_ServicesCheckNameAvailability_568190(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.HealthcareApis/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCheckNameAvailability_568189(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check if a service instance name is available.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568205 = path.getOrDefault("subscriptionId")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "subscriptionId", valid_568205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_568206 != nil:
    section.add "api-version", valid_568206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   checkNameAvailabilityInputs: JObject (required)
  ##                              : Set the name parameter in the CheckNameAvailabilityParameters structure to the name of the service instance to check.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568208: Call_ServicesCheckNameAvailability_568188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check if a service instance name is available.
  ## 
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_ServicesCheckNameAvailability_568188;
          checkNameAvailabilityInputs: JsonNode; subscriptionId: string;
          apiVersion: string = "2018-08-20-preview"): Recallable =
  ## servicesCheckNameAvailability
  ## Check if a service instance name is available.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   checkNameAvailabilityInputs: JObject (required)
  ##                              : Set the name parameter in the CheckNameAvailabilityParameters structure to the name of the service instance to check.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568210 = newJObject()
  var query_568211 = newJObject()
  var body_568212 = newJObject()
  add(query_568211, "api-version", newJString(apiVersion))
  if checkNameAvailabilityInputs != nil:
    body_568212 = checkNameAvailabilityInputs
  add(path_568210, "subscriptionId", newJString(subscriptionId))
  result = call_568209.call(path_568210, query_568211, nil, nil, body_568212)

var servicesCheckNameAvailability* = Call_ServicesCheckNameAvailability_568188(
    name: "servicesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.HealthcareApis/checkNameAvailability",
    validator: validate_ServicesCheckNameAvailability_568189, base: "",
    url: url_ServicesCheckNameAvailability_568190, schemes: {Scheme.Https})
type
  Call_OperationResultsGet_568213 = ref object of OpenApiRestCall_567657
proc url_OperationResultsGet_568215(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "operationResultId" in path,
        "`operationResultId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HealthcareApis/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/operationresults/"),
               (kind: VariableSegment, value: "operationResultId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationResultsGet_568214(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get the operation result for a long running operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationResultId: JString (required)
  ##                    : The ID of the operation result to get.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   locationName: JString (required)
  ##               : The location of the operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationResultId` field"
  var valid_568216 = path.getOrDefault("operationResultId")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "operationResultId", valid_568216
  var valid_568217 = path.getOrDefault("subscriptionId")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "subscriptionId", valid_568217
  var valid_568218 = path.getOrDefault("locationName")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "locationName", valid_568218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568219 = query.getOrDefault("api-version")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_568219 != nil:
    section.add "api-version", valid_568219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568220: Call_OperationResultsGet_568213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the operation result for a long running operation.
  ## 
  let valid = call_568220.validator(path, query, header, formData, body)
  let scheme = call_568220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568220.url(scheme.get, call_568220.host, call_568220.base,
                         call_568220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568220, url, valid)

proc call*(call_568221: Call_OperationResultsGet_568213; operationResultId: string;
          subscriptionId: string; locationName: string;
          apiVersion: string = "2018-08-20-preview"): Recallable =
  ## operationResultsGet
  ## Get the operation result for a long running operation.
  ##   operationResultId: string (required)
  ##                    : The ID of the operation result to get.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   locationName: string (required)
  ##               : The location of the operation.
  var path_568222 = newJObject()
  var query_568223 = newJObject()
  add(path_568222, "operationResultId", newJString(operationResultId))
  add(query_568223, "api-version", newJString(apiVersion))
  add(path_568222, "subscriptionId", newJString(subscriptionId))
  add(path_568222, "locationName", newJString(locationName))
  result = call_568221.call(path_568222, query_568223, nil, nil, nil)

var operationResultsGet* = Call_OperationResultsGet_568213(
    name: "operationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.HealthcareApis/locations/{locationName}/operationresults/{operationResultId}",
    validator: validate_OperationResultsGet_568214, base: "",
    url: url_OperationResultsGet_568215, schemes: {Scheme.Https})
type
  Call_ServicesList_568224 = ref object of OpenApiRestCall_567657
proc url_ServicesList_568226(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.HealthcareApis/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesList_568225(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the service instances in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568227 = path.getOrDefault("subscriptionId")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "subscriptionId", valid_568227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568228 = query.getOrDefault("api-version")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_568228 != nil:
    section.add "api-version", valid_568228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568229: Call_ServicesList_568224; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the service instances in a subscription.
  ## 
  let valid = call_568229.validator(path, query, header, formData, body)
  let scheme = call_568229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568229.url(scheme.get, call_568229.host, call_568229.base,
                         call_568229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568229, url, valid)

proc call*(call_568230: Call_ServicesList_568224; subscriptionId: string;
          apiVersion: string = "2018-08-20-preview"): Recallable =
  ## servicesList
  ## Get all the service instances in a subscription.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568231 = newJObject()
  var query_568232 = newJObject()
  add(query_568232, "api-version", newJString(apiVersion))
  add(path_568231, "subscriptionId", newJString(subscriptionId))
  result = call_568230.call(path_568231, query_568232, nil, nil, nil)

var servicesList* = Call_ServicesList_568224(name: "servicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.HealthcareApis/services",
    validator: validate_ServicesList_568225, base: "", url: url_ServicesList_568226,
    schemes: {Scheme.Https})
type
  Call_ServicesListByResourceGroup_568233 = ref object of OpenApiRestCall_567657
proc url_ServicesListByResourceGroup_568235(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.HealthcareApis/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListByResourceGroup_568234(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the service instances in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the service instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568238 = query.getOrDefault("api-version")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_568238 != nil:
    section.add "api-version", valid_568238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568239: Call_ServicesListByResourceGroup_568233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the service instances in a resource group.
  ## 
  let valid = call_568239.validator(path, query, header, formData, body)
  let scheme = call_568239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568239.url(scheme.get, call_568239.host, call_568239.base,
                         call_568239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568239, url, valid)

proc call*(call_568240: Call_ServicesListByResourceGroup_568233;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2018-08-20-preview"): Recallable =
  ## servicesListByResourceGroup
  ## Get all the service instances in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the service instance.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568241 = newJObject()
  var query_568242 = newJObject()
  add(path_568241, "resourceGroupName", newJString(resourceGroupName))
  add(query_568242, "api-version", newJString(apiVersion))
  add(path_568241, "subscriptionId", newJString(subscriptionId))
  result = call_568240.call(path_568241, query_568242, nil, nil, nil)

var servicesListByResourceGroup* = Call_ServicesListByResourceGroup_568233(
    name: "servicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HealthcareApis/services",
    validator: validate_ServicesListByResourceGroup_568234, base: "",
    url: url_ServicesListByResourceGroup_568235, schemes: {Scheme.Https})
type
  Call_ServicesCreateOrUpdate_568254 = ref object of OpenApiRestCall_567657
proc url_ServicesCreateOrUpdate_568256(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HealthcareApis/services/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCreateOrUpdate_568255(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update the metadata of a service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the service instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568257 = path.getOrDefault("resourceGroupName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "resourceGroupName", valid_568257
  var valid_568258 = path.getOrDefault("subscriptionId")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "subscriptionId", valid_568258
  var valid_568259 = path.getOrDefault("resourceName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "resourceName", valid_568259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568260 = query.getOrDefault("api-version")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_568260 != nil:
    section.add "api-version", valid_568260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   serviceDescription: JObject (required)
  ##                     : The service instance metadata.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568262: Call_ServicesCreateOrUpdate_568254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the metadata of a service instance.
  ## 
  let valid = call_568262.validator(path, query, header, formData, body)
  let scheme = call_568262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568262.url(scheme.get, call_568262.host, call_568262.base,
                         call_568262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568262, url, valid)

proc call*(call_568263: Call_ServicesCreateOrUpdate_568254;
          resourceGroupName: string; serviceDescription: JsonNode;
          subscriptionId: string; resourceName: string;
          apiVersion: string = "2018-08-20-preview"): Recallable =
  ## servicesCreateOrUpdate
  ## Create or update the metadata of a service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the service instance.
  ##   serviceDescription: JObject (required)
  ##                     : The service instance metadata.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the service instance.
  var path_568264 = newJObject()
  var query_568265 = newJObject()
  var body_568266 = newJObject()
  add(path_568264, "resourceGroupName", newJString(resourceGroupName))
  if serviceDescription != nil:
    body_568266 = serviceDescription
  add(query_568265, "api-version", newJString(apiVersion))
  add(path_568264, "subscriptionId", newJString(subscriptionId))
  add(path_568264, "resourceName", newJString(resourceName))
  result = call_568263.call(path_568264, query_568265, nil, nil, body_568266)

var servicesCreateOrUpdate* = Call_ServicesCreateOrUpdate_568254(
    name: "servicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HealthcareApis/services/{resourceName}",
    validator: validate_ServicesCreateOrUpdate_568255, base: "",
    url: url_ServicesCreateOrUpdate_568256, schemes: {Scheme.Https})
type
  Call_ServicesGet_568243 = ref object of OpenApiRestCall_567657
proc url_ServicesGet_568245(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HealthcareApis/services/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesGet_568244(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the metadata of a service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the service instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568246 = path.getOrDefault("resourceGroupName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "resourceGroupName", valid_568246
  var valid_568247 = path.getOrDefault("subscriptionId")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "subscriptionId", valid_568247
  var valid_568248 = path.getOrDefault("resourceName")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "resourceName", valid_568248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568249 = query.getOrDefault("api-version")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_568249 != nil:
    section.add "api-version", valid_568249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568250: Call_ServicesGet_568243; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the metadata of a service instance.
  ## 
  let valid = call_568250.validator(path, query, header, formData, body)
  let scheme = call_568250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568250.url(scheme.get, call_568250.host, call_568250.base,
                         call_568250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568250, url, valid)

proc call*(call_568251: Call_ServicesGet_568243; resourceGroupName: string;
          subscriptionId: string; resourceName: string;
          apiVersion: string = "2018-08-20-preview"): Recallable =
  ## servicesGet
  ## Get the metadata of a service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the service instance.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the service instance.
  var path_568252 = newJObject()
  var query_568253 = newJObject()
  add(path_568252, "resourceGroupName", newJString(resourceGroupName))
  add(query_568253, "api-version", newJString(apiVersion))
  add(path_568252, "subscriptionId", newJString(subscriptionId))
  add(path_568252, "resourceName", newJString(resourceName))
  result = call_568251.call(path_568252, query_568253, nil, nil, nil)

var servicesGet* = Call_ServicesGet_568243(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HealthcareApis/services/{resourceName}",
                                        validator: validate_ServicesGet_568244,
                                        base: "", url: url_ServicesGet_568245,
                                        schemes: {Scheme.Https})
type
  Call_ServicesUpdate_568278 = ref object of OpenApiRestCall_567657
proc url_ServicesUpdate_568280(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HealthcareApis/services/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesUpdate_568279(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update the metadata of a service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the service instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568281 = path.getOrDefault("resourceGroupName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "resourceGroupName", valid_568281
  var valid_568282 = path.getOrDefault("subscriptionId")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "subscriptionId", valid_568282
  var valid_568283 = path.getOrDefault("resourceName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "resourceName", valid_568283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568284 = query.getOrDefault("api-version")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_568284 != nil:
    section.add "api-version", valid_568284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   servicePatchDescription: JObject (required)
  ##                          : The service instance metadata and security metadata.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568286: Call_ServicesUpdate_568278; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the metadata of a service instance.
  ## 
  let valid = call_568286.validator(path, query, header, formData, body)
  let scheme = call_568286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568286.url(scheme.get, call_568286.host, call_568286.base,
                         call_568286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568286, url, valid)

proc call*(call_568287: Call_ServicesUpdate_568278; resourceGroupName: string;
          subscriptionId: string; resourceName: string;
          servicePatchDescription: JsonNode;
          apiVersion: string = "2018-08-20-preview"): Recallable =
  ## servicesUpdate
  ## Update the metadata of a service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the service instance.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the service instance.
  ##   servicePatchDescription: JObject (required)
  ##                          : The service instance metadata and security metadata.
  var path_568288 = newJObject()
  var query_568289 = newJObject()
  var body_568290 = newJObject()
  add(path_568288, "resourceGroupName", newJString(resourceGroupName))
  add(query_568289, "api-version", newJString(apiVersion))
  add(path_568288, "subscriptionId", newJString(subscriptionId))
  add(path_568288, "resourceName", newJString(resourceName))
  if servicePatchDescription != nil:
    body_568290 = servicePatchDescription
  result = call_568287.call(path_568288, query_568289, nil, nil, body_568290)

var servicesUpdate* = Call_ServicesUpdate_568278(name: "servicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HealthcareApis/services/{resourceName}",
    validator: validate_ServicesUpdate_568279, base: "", url: url_ServicesUpdate_568280,
    schemes: {Scheme.Https})
type
  Call_ServicesDelete_568267 = ref object of OpenApiRestCall_567657
proc url_ServicesDelete_568269(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.HealthcareApis/services/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesDelete_568268(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete a service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the service instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568270 = path.getOrDefault("resourceGroupName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "resourceGroupName", valid_568270
  var valid_568271 = path.getOrDefault("subscriptionId")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "subscriptionId", valid_568271
  var valid_568272 = path.getOrDefault("resourceName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "resourceName", valid_568272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568273 = query.getOrDefault("api-version")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_568273 != nil:
    section.add "api-version", valid_568273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568274: Call_ServicesDelete_568267; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a service instance.
  ## 
  let valid = call_568274.validator(path, query, header, formData, body)
  let scheme = call_568274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568274.url(scheme.get, call_568274.host, call_568274.base,
                         call_568274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568274, url, valid)

proc call*(call_568275: Call_ServicesDelete_568267; resourceGroupName: string;
          subscriptionId: string; resourceName: string;
          apiVersion: string = "2018-08-20-preview"): Recallable =
  ## servicesDelete
  ## Delete a service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the service instance.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the service instance.
  var path_568276 = newJObject()
  var query_568277 = newJObject()
  add(path_568276, "resourceGroupName", newJString(resourceGroupName))
  add(query_568277, "api-version", newJString(apiVersion))
  add(path_568276, "subscriptionId", newJString(subscriptionId))
  add(path_568276, "resourceName", newJString(resourceName))
  result = call_568275.call(path_568276, query_568277, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_568267(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HealthcareApis/services/{resourceName}",
    validator: validate_ServicesDelete_568268, base: "", url: url_ServicesDelete_568269,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
