
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  Call_OperationsList_573879 = ref object of OpenApiRestCall_573657
proc url_OperationsList_573881(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_573880(path: JsonNode; query: JsonNode;
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
  var valid_574053 = query.getOrDefault("api-version")
  valid_574053 = validateParameter(valid_574053, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_574053 != nil:
    section.add "api-version", valid_574053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574076: Call_OperationsList_573879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Healthcare service REST API operations.
  ## 
  let valid = call_574076.validator(path, query, header, formData, body)
  let scheme = call_574076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574076.url(scheme.get, call_574076.host, call_574076.base,
                         call_574076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574076, url, valid)

proc call*(call_574147: Call_OperationsList_573879;
          apiVersion: string = "2018-08-20-preview"): Recallable =
  ## operationsList
  ## Lists all of the available Healthcare service REST API operations.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  var query_574148 = newJObject()
  add(query_574148, "api-version", newJString(apiVersion))
  result = call_574147.call(nil, query_574148, nil, nil, nil)

var operationsList* = Call_OperationsList_573879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.HealthcareApis/operations",
    validator: validate_OperationsList_573880, base: "", url: url_OperationsList_573881,
    schemes: {Scheme.Https})
type
  Call_ServicesCheckNameAvailability_574188 = ref object of OpenApiRestCall_573657
proc url_ServicesCheckNameAvailability_574190(protocol: Scheme; host: string;
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

proc validate_ServicesCheckNameAvailability_574189(path: JsonNode; query: JsonNode;
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
  var valid_574205 = path.getOrDefault("subscriptionId")
  valid_574205 = validateParameter(valid_574205, JString, required = true,
                                 default = nil)
  if valid_574205 != nil:
    section.add "subscriptionId", valid_574205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574206 = query.getOrDefault("api-version")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_574206 != nil:
    section.add "api-version", valid_574206
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

proc call*(call_574208: Call_ServicesCheckNameAvailability_574188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check if a service instance name is available.
  ## 
  let valid = call_574208.validator(path, query, header, formData, body)
  let scheme = call_574208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574208.url(scheme.get, call_574208.host, call_574208.base,
                         call_574208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574208, url, valid)

proc call*(call_574209: Call_ServicesCheckNameAvailability_574188;
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
  var path_574210 = newJObject()
  var query_574211 = newJObject()
  var body_574212 = newJObject()
  add(query_574211, "api-version", newJString(apiVersion))
  if checkNameAvailabilityInputs != nil:
    body_574212 = checkNameAvailabilityInputs
  add(path_574210, "subscriptionId", newJString(subscriptionId))
  result = call_574209.call(path_574210, query_574211, nil, nil, body_574212)

var servicesCheckNameAvailability* = Call_ServicesCheckNameAvailability_574188(
    name: "servicesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.HealthcareApis/checkNameAvailability",
    validator: validate_ServicesCheckNameAvailability_574189, base: "",
    url: url_ServicesCheckNameAvailability_574190, schemes: {Scheme.Https})
type
  Call_OperationResultsGet_574213 = ref object of OpenApiRestCall_573657
proc url_OperationResultsGet_574215(protocol: Scheme; host: string; base: string;
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

proc validate_OperationResultsGet_574214(path: JsonNode; query: JsonNode;
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
  var valid_574216 = path.getOrDefault("operationResultId")
  valid_574216 = validateParameter(valid_574216, JString, required = true,
                                 default = nil)
  if valid_574216 != nil:
    section.add "operationResultId", valid_574216
  var valid_574217 = path.getOrDefault("subscriptionId")
  valid_574217 = validateParameter(valid_574217, JString, required = true,
                                 default = nil)
  if valid_574217 != nil:
    section.add "subscriptionId", valid_574217
  var valid_574218 = path.getOrDefault("locationName")
  valid_574218 = validateParameter(valid_574218, JString, required = true,
                                 default = nil)
  if valid_574218 != nil:
    section.add "locationName", valid_574218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574219 = query.getOrDefault("api-version")
  valid_574219 = validateParameter(valid_574219, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_574219 != nil:
    section.add "api-version", valid_574219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574220: Call_OperationResultsGet_574213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the operation result for a long running operation.
  ## 
  let valid = call_574220.validator(path, query, header, formData, body)
  let scheme = call_574220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574220.url(scheme.get, call_574220.host, call_574220.base,
                         call_574220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574220, url, valid)

proc call*(call_574221: Call_OperationResultsGet_574213; operationResultId: string;
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
  var path_574222 = newJObject()
  var query_574223 = newJObject()
  add(path_574222, "operationResultId", newJString(operationResultId))
  add(query_574223, "api-version", newJString(apiVersion))
  add(path_574222, "subscriptionId", newJString(subscriptionId))
  add(path_574222, "locationName", newJString(locationName))
  result = call_574221.call(path_574222, query_574223, nil, nil, nil)

var operationResultsGet* = Call_OperationResultsGet_574213(
    name: "operationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.HealthcareApis/locations/{locationName}/operationresults/{operationResultId}",
    validator: validate_OperationResultsGet_574214, base: "",
    url: url_OperationResultsGet_574215, schemes: {Scheme.Https})
type
  Call_ServicesList_574224 = ref object of OpenApiRestCall_573657
proc url_ServicesList_574226(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesList_574225(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574227 = path.getOrDefault("subscriptionId")
  valid_574227 = validateParameter(valid_574227, JString, required = true,
                                 default = nil)
  if valid_574227 != nil:
    section.add "subscriptionId", valid_574227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574228 = query.getOrDefault("api-version")
  valid_574228 = validateParameter(valid_574228, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_574228 != nil:
    section.add "api-version", valid_574228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574229: Call_ServicesList_574224; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the service instances in a subscription.
  ## 
  let valid = call_574229.validator(path, query, header, formData, body)
  let scheme = call_574229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574229.url(scheme.get, call_574229.host, call_574229.base,
                         call_574229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574229, url, valid)

proc call*(call_574230: Call_ServicesList_574224; subscriptionId: string;
          apiVersion: string = "2018-08-20-preview"): Recallable =
  ## servicesList
  ## Get all the service instances in a subscription.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_574231 = newJObject()
  var query_574232 = newJObject()
  add(query_574232, "api-version", newJString(apiVersion))
  add(path_574231, "subscriptionId", newJString(subscriptionId))
  result = call_574230.call(path_574231, query_574232, nil, nil, nil)

var servicesList* = Call_ServicesList_574224(name: "servicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.HealthcareApis/services",
    validator: validate_ServicesList_574225, base: "", url: url_ServicesList_574226,
    schemes: {Scheme.Https})
type
  Call_ServicesListByResourceGroup_574233 = ref object of OpenApiRestCall_573657
proc url_ServicesListByResourceGroup_574235(protocol: Scheme; host: string;
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

proc validate_ServicesListByResourceGroup_574234(path: JsonNode; query: JsonNode;
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
  var valid_574236 = path.getOrDefault("resourceGroupName")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "resourceGroupName", valid_574236
  var valid_574237 = path.getOrDefault("subscriptionId")
  valid_574237 = validateParameter(valid_574237, JString, required = true,
                                 default = nil)
  if valid_574237 != nil:
    section.add "subscriptionId", valid_574237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574238 = query.getOrDefault("api-version")
  valid_574238 = validateParameter(valid_574238, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_574238 != nil:
    section.add "api-version", valid_574238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574239: Call_ServicesListByResourceGroup_574233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the service instances in a resource group.
  ## 
  let valid = call_574239.validator(path, query, header, formData, body)
  let scheme = call_574239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574239.url(scheme.get, call_574239.host, call_574239.base,
                         call_574239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574239, url, valid)

proc call*(call_574240: Call_ServicesListByResourceGroup_574233;
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
  var path_574241 = newJObject()
  var query_574242 = newJObject()
  add(path_574241, "resourceGroupName", newJString(resourceGroupName))
  add(query_574242, "api-version", newJString(apiVersion))
  add(path_574241, "subscriptionId", newJString(subscriptionId))
  result = call_574240.call(path_574241, query_574242, nil, nil, nil)

var servicesListByResourceGroup* = Call_ServicesListByResourceGroup_574233(
    name: "servicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HealthcareApis/services",
    validator: validate_ServicesListByResourceGroup_574234, base: "",
    url: url_ServicesListByResourceGroup_574235, schemes: {Scheme.Https})
type
  Call_ServicesCreateOrUpdate_574254 = ref object of OpenApiRestCall_573657
proc url_ServicesCreateOrUpdate_574256(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesCreateOrUpdate_574255(path: JsonNode; query: JsonNode;
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
  var valid_574257 = path.getOrDefault("resourceGroupName")
  valid_574257 = validateParameter(valid_574257, JString, required = true,
                                 default = nil)
  if valid_574257 != nil:
    section.add "resourceGroupName", valid_574257
  var valid_574258 = path.getOrDefault("subscriptionId")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "subscriptionId", valid_574258
  var valid_574259 = path.getOrDefault("resourceName")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "resourceName", valid_574259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574260 = query.getOrDefault("api-version")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_574260 != nil:
    section.add "api-version", valid_574260
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

proc call*(call_574262: Call_ServicesCreateOrUpdate_574254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the metadata of a service instance.
  ## 
  let valid = call_574262.validator(path, query, header, formData, body)
  let scheme = call_574262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574262.url(scheme.get, call_574262.host, call_574262.base,
                         call_574262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574262, url, valid)

proc call*(call_574263: Call_ServicesCreateOrUpdate_574254;
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
  var path_574264 = newJObject()
  var query_574265 = newJObject()
  var body_574266 = newJObject()
  add(path_574264, "resourceGroupName", newJString(resourceGroupName))
  if serviceDescription != nil:
    body_574266 = serviceDescription
  add(query_574265, "api-version", newJString(apiVersion))
  add(path_574264, "subscriptionId", newJString(subscriptionId))
  add(path_574264, "resourceName", newJString(resourceName))
  result = call_574263.call(path_574264, query_574265, nil, nil, body_574266)

var servicesCreateOrUpdate* = Call_ServicesCreateOrUpdate_574254(
    name: "servicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HealthcareApis/services/{resourceName}",
    validator: validate_ServicesCreateOrUpdate_574255, base: "",
    url: url_ServicesCreateOrUpdate_574256, schemes: {Scheme.Https})
type
  Call_ServicesGet_574243 = ref object of OpenApiRestCall_573657
proc url_ServicesGet_574245(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesGet_574244(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574246 = path.getOrDefault("resourceGroupName")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "resourceGroupName", valid_574246
  var valid_574247 = path.getOrDefault("subscriptionId")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "subscriptionId", valid_574247
  var valid_574248 = path.getOrDefault("resourceName")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "resourceName", valid_574248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574249 = query.getOrDefault("api-version")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_574249 != nil:
    section.add "api-version", valid_574249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574250: Call_ServicesGet_574243; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the metadata of a service instance.
  ## 
  let valid = call_574250.validator(path, query, header, formData, body)
  let scheme = call_574250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574250.url(scheme.get, call_574250.host, call_574250.base,
                         call_574250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574250, url, valid)

proc call*(call_574251: Call_ServicesGet_574243; resourceGroupName: string;
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
  var path_574252 = newJObject()
  var query_574253 = newJObject()
  add(path_574252, "resourceGroupName", newJString(resourceGroupName))
  add(query_574253, "api-version", newJString(apiVersion))
  add(path_574252, "subscriptionId", newJString(subscriptionId))
  add(path_574252, "resourceName", newJString(resourceName))
  result = call_574251.call(path_574252, query_574253, nil, nil, nil)

var servicesGet* = Call_ServicesGet_574243(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HealthcareApis/services/{resourceName}",
                                        validator: validate_ServicesGet_574244,
                                        base: "", url: url_ServicesGet_574245,
                                        schemes: {Scheme.Https})
type
  Call_ServicesUpdate_574278 = ref object of OpenApiRestCall_573657
proc url_ServicesUpdate_574280(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesUpdate_574279(path: JsonNode; query: JsonNode;
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
  var valid_574281 = path.getOrDefault("resourceGroupName")
  valid_574281 = validateParameter(valid_574281, JString, required = true,
                                 default = nil)
  if valid_574281 != nil:
    section.add "resourceGroupName", valid_574281
  var valid_574282 = path.getOrDefault("subscriptionId")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "subscriptionId", valid_574282
  var valid_574283 = path.getOrDefault("resourceName")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "resourceName", valid_574283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574284 = query.getOrDefault("api-version")
  valid_574284 = validateParameter(valid_574284, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_574284 != nil:
    section.add "api-version", valid_574284
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

proc call*(call_574286: Call_ServicesUpdate_574278; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the metadata of a service instance.
  ## 
  let valid = call_574286.validator(path, query, header, formData, body)
  let scheme = call_574286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574286.url(scheme.get, call_574286.host, call_574286.base,
                         call_574286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574286, url, valid)

proc call*(call_574287: Call_ServicesUpdate_574278; resourceGroupName: string;
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
  var path_574288 = newJObject()
  var query_574289 = newJObject()
  var body_574290 = newJObject()
  add(path_574288, "resourceGroupName", newJString(resourceGroupName))
  add(query_574289, "api-version", newJString(apiVersion))
  add(path_574288, "subscriptionId", newJString(subscriptionId))
  add(path_574288, "resourceName", newJString(resourceName))
  if servicePatchDescription != nil:
    body_574290 = servicePatchDescription
  result = call_574287.call(path_574288, query_574289, nil, nil, body_574290)

var servicesUpdate* = Call_ServicesUpdate_574278(name: "servicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HealthcareApis/services/{resourceName}",
    validator: validate_ServicesUpdate_574279, base: "", url: url_ServicesUpdate_574280,
    schemes: {Scheme.Https})
type
  Call_ServicesDelete_574267 = ref object of OpenApiRestCall_573657
proc url_ServicesDelete_574269(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesDelete_574268(path: JsonNode; query: JsonNode;
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
  var valid_574270 = path.getOrDefault("resourceGroupName")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "resourceGroupName", valid_574270
  var valid_574271 = path.getOrDefault("subscriptionId")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "subscriptionId", valid_574271
  var valid_574272 = path.getOrDefault("resourceName")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "resourceName", valid_574272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574273 = query.getOrDefault("api-version")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_574273 != nil:
    section.add "api-version", valid_574273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574274: Call_ServicesDelete_574267; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a service instance.
  ## 
  let valid = call_574274.validator(path, query, header, formData, body)
  let scheme = call_574274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574274.url(scheme.get, call_574274.host, call_574274.base,
                         call_574274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574274, url, valid)

proc call*(call_574275: Call_ServicesDelete_574267; resourceGroupName: string;
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
  var path_574276 = newJObject()
  var query_574277 = newJObject()
  add(path_574276, "resourceGroupName", newJString(resourceGroupName))
  add(query_574277, "api-version", newJString(apiVersion))
  add(path_574276, "subscriptionId", newJString(subscriptionId))
  add(path_574276, "resourceName", newJString(resourceName))
  result = call_574275.call(path_574276, query_574277, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_574267(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HealthcareApis/services/{resourceName}",
    validator: validate_ServicesDelete_574268, base: "", url: url_ServicesDelete_574269,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
