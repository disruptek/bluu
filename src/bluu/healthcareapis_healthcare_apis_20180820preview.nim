
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "healthcareapis-healthcare-apis"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593646 = ref object of OpenApiRestCall_593424
proc url_OperationsList_593648(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593647(path: JsonNode; query: JsonNode;
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
  var valid_593820 = query.getOrDefault("api-version")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_593820 != nil:
    section.add "api-version", valid_593820
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593843: Call_OperationsList_593646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Healthcare service REST API operations.
  ## 
  let valid = call_593843.validator(path, query, header, formData, body)
  let scheme = call_593843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593843.url(scheme.get, call_593843.host, call_593843.base,
                         call_593843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593843, url, valid)

proc call*(call_593914: Call_OperationsList_593646;
          apiVersion: string = "2018-08-20-preview"): Recallable =
  ## operationsList
  ## Lists all of the available Healthcare service REST API operations.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  var query_593915 = newJObject()
  add(query_593915, "api-version", newJString(apiVersion))
  result = call_593914.call(nil, query_593915, nil, nil, nil)

var operationsList* = Call_OperationsList_593646(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.HealthcareApis/operations",
    validator: validate_OperationsList_593647, base: "", url: url_OperationsList_593648,
    schemes: {Scheme.Https})
type
  Call_ServicesCheckNameAvailability_593955 = ref object of OpenApiRestCall_593424
proc url_ServicesCheckNameAvailability_593957(protocol: Scheme; host: string;
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

proc validate_ServicesCheckNameAvailability_593956(path: JsonNode; query: JsonNode;
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
  var valid_593972 = path.getOrDefault("subscriptionId")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "subscriptionId", valid_593972
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593973 = query.getOrDefault("api-version")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_593973 != nil:
    section.add "api-version", valid_593973
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

proc call*(call_593975: Call_ServicesCheckNameAvailability_593955; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check if a service instance name is available.
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_ServicesCheckNameAvailability_593955;
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
  var path_593977 = newJObject()
  var query_593978 = newJObject()
  var body_593979 = newJObject()
  add(query_593978, "api-version", newJString(apiVersion))
  if checkNameAvailabilityInputs != nil:
    body_593979 = checkNameAvailabilityInputs
  add(path_593977, "subscriptionId", newJString(subscriptionId))
  result = call_593976.call(path_593977, query_593978, nil, nil, body_593979)

var servicesCheckNameAvailability* = Call_ServicesCheckNameAvailability_593955(
    name: "servicesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.HealthcareApis/checkNameAvailability",
    validator: validate_ServicesCheckNameAvailability_593956, base: "",
    url: url_ServicesCheckNameAvailability_593957, schemes: {Scheme.Https})
type
  Call_OperationResultsGet_593980 = ref object of OpenApiRestCall_593424
proc url_OperationResultsGet_593982(protocol: Scheme; host: string; base: string;
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

proc validate_OperationResultsGet_593981(path: JsonNode; query: JsonNode;
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
  var valid_593983 = path.getOrDefault("operationResultId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "operationResultId", valid_593983
  var valid_593984 = path.getOrDefault("subscriptionId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "subscriptionId", valid_593984
  var valid_593985 = path.getOrDefault("locationName")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "locationName", valid_593985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593986 = query.getOrDefault("api-version")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_593986 != nil:
    section.add "api-version", valid_593986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_OperationResultsGet_593980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the operation result for a long running operation.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_OperationResultsGet_593980; operationResultId: string;
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
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  add(path_593989, "operationResultId", newJString(operationResultId))
  add(query_593990, "api-version", newJString(apiVersion))
  add(path_593989, "subscriptionId", newJString(subscriptionId))
  add(path_593989, "locationName", newJString(locationName))
  result = call_593988.call(path_593989, query_593990, nil, nil, nil)

var operationResultsGet* = Call_OperationResultsGet_593980(
    name: "operationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.HealthcareApis/locations/{locationName}/operationresults/{operationResultId}",
    validator: validate_OperationResultsGet_593981, base: "",
    url: url_OperationResultsGet_593982, schemes: {Scheme.Https})
type
  Call_ServicesList_593991 = ref object of OpenApiRestCall_593424
proc url_ServicesList_593993(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesList_593992(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593994 = path.getOrDefault("subscriptionId")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "subscriptionId", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593995 = query.getOrDefault("api-version")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_593995 != nil:
    section.add "api-version", valid_593995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593996: Call_ServicesList_593991; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the service instances in a subscription.
  ## 
  let valid = call_593996.validator(path, query, header, formData, body)
  let scheme = call_593996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593996.url(scheme.get, call_593996.host, call_593996.base,
                         call_593996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593996, url, valid)

proc call*(call_593997: Call_ServicesList_593991; subscriptionId: string;
          apiVersion: string = "2018-08-20-preview"): Recallable =
  ## servicesList
  ## Get all the service instances in a subscription.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_593998 = newJObject()
  var query_593999 = newJObject()
  add(query_593999, "api-version", newJString(apiVersion))
  add(path_593998, "subscriptionId", newJString(subscriptionId))
  result = call_593997.call(path_593998, query_593999, nil, nil, nil)

var servicesList* = Call_ServicesList_593991(name: "servicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.HealthcareApis/services",
    validator: validate_ServicesList_593992, base: "", url: url_ServicesList_593993,
    schemes: {Scheme.Https})
type
  Call_ServicesListByResourceGroup_594000 = ref object of OpenApiRestCall_593424
proc url_ServicesListByResourceGroup_594002(protocol: Scheme; host: string;
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

proc validate_ServicesListByResourceGroup_594001(path: JsonNode; query: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594005 = query.getOrDefault("api-version")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_594005 != nil:
    section.add "api-version", valid_594005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594006: Call_ServicesListByResourceGroup_594000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the service instances in a resource group.
  ## 
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_ServicesListByResourceGroup_594000;
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
  var path_594008 = newJObject()
  var query_594009 = newJObject()
  add(path_594008, "resourceGroupName", newJString(resourceGroupName))
  add(query_594009, "api-version", newJString(apiVersion))
  add(path_594008, "subscriptionId", newJString(subscriptionId))
  result = call_594007.call(path_594008, query_594009, nil, nil, nil)

var servicesListByResourceGroup* = Call_ServicesListByResourceGroup_594000(
    name: "servicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HealthcareApis/services",
    validator: validate_ServicesListByResourceGroup_594001, base: "",
    url: url_ServicesListByResourceGroup_594002, schemes: {Scheme.Https})
type
  Call_ServicesCreateOrUpdate_594021 = ref object of OpenApiRestCall_593424
proc url_ServicesCreateOrUpdate_594023(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesCreateOrUpdate_594022(path: JsonNode; query: JsonNode;
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
  var valid_594024 = path.getOrDefault("resourceGroupName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "resourceGroupName", valid_594024
  var valid_594025 = path.getOrDefault("subscriptionId")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "subscriptionId", valid_594025
  var valid_594026 = path.getOrDefault("resourceName")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "resourceName", valid_594026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594027 = query.getOrDefault("api-version")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_594027 != nil:
    section.add "api-version", valid_594027
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

proc call*(call_594029: Call_ServicesCreateOrUpdate_594021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the metadata of a service instance.
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_ServicesCreateOrUpdate_594021;
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
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  var body_594033 = newJObject()
  add(path_594031, "resourceGroupName", newJString(resourceGroupName))
  if serviceDescription != nil:
    body_594033 = serviceDescription
  add(query_594032, "api-version", newJString(apiVersion))
  add(path_594031, "subscriptionId", newJString(subscriptionId))
  add(path_594031, "resourceName", newJString(resourceName))
  result = call_594030.call(path_594031, query_594032, nil, nil, body_594033)

var servicesCreateOrUpdate* = Call_ServicesCreateOrUpdate_594021(
    name: "servicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HealthcareApis/services/{resourceName}",
    validator: validate_ServicesCreateOrUpdate_594022, base: "",
    url: url_ServicesCreateOrUpdate_594023, schemes: {Scheme.Https})
type
  Call_ServicesGet_594010 = ref object of OpenApiRestCall_593424
proc url_ServicesGet_594012(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesGet_594011(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594013 = path.getOrDefault("resourceGroupName")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "resourceGroupName", valid_594013
  var valid_594014 = path.getOrDefault("subscriptionId")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "subscriptionId", valid_594014
  var valid_594015 = path.getOrDefault("resourceName")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "resourceName", valid_594015
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594016 = query.getOrDefault("api-version")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_594016 != nil:
    section.add "api-version", valid_594016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594017: Call_ServicesGet_594010; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the metadata of a service instance.
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_ServicesGet_594010; resourceGroupName: string;
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
  var path_594019 = newJObject()
  var query_594020 = newJObject()
  add(path_594019, "resourceGroupName", newJString(resourceGroupName))
  add(query_594020, "api-version", newJString(apiVersion))
  add(path_594019, "subscriptionId", newJString(subscriptionId))
  add(path_594019, "resourceName", newJString(resourceName))
  result = call_594018.call(path_594019, query_594020, nil, nil, nil)

var servicesGet* = Call_ServicesGet_594010(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HealthcareApis/services/{resourceName}",
                                        validator: validate_ServicesGet_594011,
                                        base: "", url: url_ServicesGet_594012,
                                        schemes: {Scheme.Https})
type
  Call_ServicesUpdate_594045 = ref object of OpenApiRestCall_593424
proc url_ServicesUpdate_594047(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesUpdate_594046(path: JsonNode; query: JsonNode;
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
  var valid_594048 = path.getOrDefault("resourceGroupName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "resourceGroupName", valid_594048
  var valid_594049 = path.getOrDefault("subscriptionId")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "subscriptionId", valid_594049
  var valid_594050 = path.getOrDefault("resourceName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "resourceName", valid_594050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594051 = query.getOrDefault("api-version")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_594051 != nil:
    section.add "api-version", valid_594051
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

proc call*(call_594053: Call_ServicesUpdate_594045; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the metadata of a service instance.
  ## 
  let valid = call_594053.validator(path, query, header, formData, body)
  let scheme = call_594053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594053.url(scheme.get, call_594053.host, call_594053.base,
                         call_594053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594053, url, valid)

proc call*(call_594054: Call_ServicesUpdate_594045; resourceGroupName: string;
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
  var path_594055 = newJObject()
  var query_594056 = newJObject()
  var body_594057 = newJObject()
  add(path_594055, "resourceGroupName", newJString(resourceGroupName))
  add(query_594056, "api-version", newJString(apiVersion))
  add(path_594055, "subscriptionId", newJString(subscriptionId))
  add(path_594055, "resourceName", newJString(resourceName))
  if servicePatchDescription != nil:
    body_594057 = servicePatchDescription
  result = call_594054.call(path_594055, query_594056, nil, nil, body_594057)

var servicesUpdate* = Call_ServicesUpdate_594045(name: "servicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HealthcareApis/services/{resourceName}",
    validator: validate_ServicesUpdate_594046, base: "", url: url_ServicesUpdate_594047,
    schemes: {Scheme.Https})
type
  Call_ServicesDelete_594034 = ref object of OpenApiRestCall_593424
proc url_ServicesDelete_594036(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesDelete_594035(path: JsonNode; query: JsonNode;
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
  var valid_594037 = path.getOrDefault("resourceGroupName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "resourceGroupName", valid_594037
  var valid_594038 = path.getOrDefault("subscriptionId")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "subscriptionId", valid_594038
  var valid_594039 = path.getOrDefault("resourceName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "resourceName", valid_594039
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594040 = query.getOrDefault("api-version")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = newJString("2018-08-20-preview"))
  if valid_594040 != nil:
    section.add "api-version", valid_594040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594041: Call_ServicesDelete_594034; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a service instance.
  ## 
  let valid = call_594041.validator(path, query, header, formData, body)
  let scheme = call_594041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594041.url(scheme.get, call_594041.host, call_594041.base,
                         call_594041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594041, url, valid)

proc call*(call_594042: Call_ServicesDelete_594034; resourceGroupName: string;
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
  var path_594043 = newJObject()
  var query_594044 = newJObject()
  add(path_594043, "resourceGroupName", newJString(resourceGroupName))
  add(query_594044, "api-version", newJString(apiVersion))
  add(path_594043, "subscriptionId", newJString(subscriptionId))
  add(path_594043, "resourceName", newJString(resourceName))
  result = call_594042.call(path_594043, query_594044, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_594034(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HealthcareApis/services/{resourceName}",
    validator: validate_ServicesDelete_594035, base: "", url: url_ServicesDelete_594036,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
