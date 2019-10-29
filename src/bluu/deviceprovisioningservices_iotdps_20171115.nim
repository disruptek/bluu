
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: iotDpsClient
## version: 2017-11-15
## termsOfService: (not provided)
## license: (not provided)
## 
## API for using the Azure IoT Hub Device Provisioning Service features.
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "deviceprovisioningservices-iotdps"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563777 = ref object of OpenApiRestCall_563555
proc url_OperationsList_563779(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563778(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Microsoft.Devices REST API operations.
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
  var valid_563940 = query.getOrDefault("api-version")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "api-version", valid_563940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563963: Call_OperationsList_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.Devices REST API operations.
  ## 
  let valid = call_563963.validator(path, query, header, formData, body)
  let scheme = call_563963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563963.url(scheme.get, call_563963.host, call_563963.base,
                         call_563963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563963, url, valid)

proc call*(call_564034: Call_OperationsList_563777; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Microsoft.Devices REST API operations.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  var query_564035 = newJObject()
  add(query_564035, "api-version", newJString(apiVersion))
  result = call_564034.call(nil, query_564035, nil, nil, nil)

var operationsList* = Call_OperationsList_563777(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Devices/operations",
    validator: validate_OperationsList_563778, base: "", url: url_OperationsList_563779,
    schemes: {Scheme.Https})
type
  Call_IotDpsResourceCheckProvisioningServiceNameAvailability_564075 = ref object of OpenApiRestCall_563555
proc url_IotDpsResourceCheckProvisioningServiceNameAvailability_564077(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/checkProvisioningServiceNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotDpsResourceCheckProvisioningServiceNameAvailability_564076(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Check if a provisioning service name is available. This will validate if the name is syntactically valid and if the name is usable
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564092 = path.getOrDefault("subscriptionId")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = nil)
  if valid_564092 != nil:
    section.add "subscriptionId", valid_564092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564093 = query.getOrDefault("api-version")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "api-version", valid_564093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   arguments: JObject (required)
  ##            : Set the name parameter in the OperationInputs structure to the name of the provisioning service to check.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564095: Call_IotDpsResourceCheckProvisioningServiceNameAvailability_564075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check if a provisioning service name is available. This will validate if the name is syntactically valid and if the name is usable
  ## 
  let valid = call_564095.validator(path, query, header, formData, body)
  let scheme = call_564095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564095.url(scheme.get, call_564095.host, call_564095.base,
                         call_564095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564095, url, valid)

proc call*(call_564096: Call_IotDpsResourceCheckProvisioningServiceNameAvailability_564075;
          apiVersion: string; subscriptionId: string; arguments: JsonNode): Recallable =
  ## iotDpsResourceCheckProvisioningServiceNameAvailability
  ## Check if a provisioning service name is available. This will validate if the name is syntactically valid and if the name is usable
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   arguments: JObject (required)
  ##            : Set the name parameter in the OperationInputs structure to the name of the provisioning service to check.
  var path_564097 = newJObject()
  var query_564098 = newJObject()
  var body_564099 = newJObject()
  add(query_564098, "api-version", newJString(apiVersion))
  add(path_564097, "subscriptionId", newJString(subscriptionId))
  if arguments != nil:
    body_564099 = arguments
  result = call_564096.call(path_564097, query_564098, nil, nil, body_564099)

var iotDpsResourceCheckProvisioningServiceNameAvailability* = Call_IotDpsResourceCheckProvisioningServiceNameAvailability_564075(
    name: "iotDpsResourceCheckProvisioningServiceNameAvailability",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Devices/checkProvisioningServiceNameAvailability",
    validator: validate_IotDpsResourceCheckProvisioningServiceNameAvailability_564076,
    base: "", url: url_IotDpsResourceCheckProvisioningServiceNameAvailability_564077,
    schemes: {Scheme.Https})
type
  Call_IotDpsResourceListBySubscription_564100 = ref object of OpenApiRestCall_563555
proc url_IotDpsResourceListBySubscription_564102(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Devices/provisioningServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotDpsResourceListBySubscription_564101(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the provisioning services for a given subscription id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564103 = path.getOrDefault("subscriptionId")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "subscriptionId", valid_564103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564104 = query.getOrDefault("api-version")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "api-version", valid_564104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564105: Call_IotDpsResourceListBySubscription_564100;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the provisioning services for a given subscription id.
  ## 
  let valid = call_564105.validator(path, query, header, formData, body)
  let scheme = call_564105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564105.url(scheme.get, call_564105.host, call_564105.base,
                         call_564105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564105, url, valid)

proc call*(call_564106: Call_IotDpsResourceListBySubscription_564100;
          apiVersion: string; subscriptionId: string): Recallable =
  ## iotDpsResourceListBySubscription
  ## List all the provisioning services for a given subscription id.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_564107 = newJObject()
  var query_564108 = newJObject()
  add(query_564108, "api-version", newJString(apiVersion))
  add(path_564107, "subscriptionId", newJString(subscriptionId))
  result = call_564106.call(path_564107, query_564108, nil, nil, nil)

var iotDpsResourceListBySubscription* = Call_IotDpsResourceListBySubscription_564100(
    name: "iotDpsResourceListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Devices/provisioningServices",
    validator: validate_IotDpsResourceListBySubscription_564101, base: "",
    url: url_IotDpsResourceListBySubscription_564102, schemes: {Scheme.Https})
type
  Call_IotDpsResourceListByResourceGroup_564109 = ref object of OpenApiRestCall_563555
proc url_IotDpsResourceListByResourceGroup_564111(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Devices/provisioningServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotDpsResourceListByResourceGroup_564110(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of all provisioning services in the given resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564112 = path.getOrDefault("subscriptionId")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "subscriptionId", valid_564112
  var valid_564113 = path.getOrDefault("resourceGroupName")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "resourceGroupName", valid_564113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564114 = query.getOrDefault("api-version")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "api-version", valid_564114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564115: Call_IotDpsResourceListByResourceGroup_564109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a list of all provisioning services in the given resource group.
  ## 
  let valid = call_564115.validator(path, query, header, formData, body)
  let scheme = call_564115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564115.url(scheme.get, call_564115.host, call_564115.base,
                         call_564115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564115, url, valid)

proc call*(call_564116: Call_IotDpsResourceListByResourceGroup_564109;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## iotDpsResourceListByResourceGroup
  ## Get a list of all provisioning services in the given resource group.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group identifier.
  var path_564117 = newJObject()
  var query_564118 = newJObject()
  add(query_564118, "api-version", newJString(apiVersion))
  add(path_564117, "subscriptionId", newJString(subscriptionId))
  add(path_564117, "resourceGroupName", newJString(resourceGroupName))
  result = call_564116.call(path_564117, query_564118, nil, nil, nil)

var iotDpsResourceListByResourceGroup* = Call_IotDpsResourceListByResourceGroup_564109(
    name: "iotDpsResourceListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices",
    validator: validate_IotDpsResourceListByResourceGroup_564110, base: "",
    url: url_IotDpsResourceListByResourceGroup_564111, schemes: {Scheme.Https})
type
  Call_IotDpsResourceCreateOrUpdate_564130 = ref object of OpenApiRestCall_563555
proc url_IotDpsResourceCreateOrUpdate_564132(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "provisioningServiceName" in path,
        "`provisioningServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Devices/provisioningServices/"),
               (kind: VariableSegment, value: "provisioningServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotDpsResourceCreateOrUpdate_564131(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update the metadata of the provisioning service. The usual pattern to modify a property is to retrieve the provisioning service metadata and security metadata, and then combine them with the modified values in a new body to update the provisioning service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of provisioning service to create or update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564133 = path.getOrDefault("subscriptionId")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "subscriptionId", valid_564133
  var valid_564134 = path.getOrDefault("resourceGroupName")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "resourceGroupName", valid_564134
  var valid_564135 = path.getOrDefault("provisioningServiceName")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "provisioningServiceName", valid_564135
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564136 = query.getOrDefault("api-version")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "api-version", valid_564136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   iotDpsDescription: JObject (required)
  ##                    : Description of the provisioning service to create or update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564138: Call_IotDpsResourceCreateOrUpdate_564130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the metadata of the provisioning service. The usual pattern to modify a property is to retrieve the provisioning service metadata and security metadata, and then combine them with the modified values in a new body to update the provisioning service.
  ## 
  let valid = call_564138.validator(path, query, header, formData, body)
  let scheme = call_564138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564138.url(scheme.get, call_564138.host, call_564138.base,
                         call_564138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564138, url, valid)

proc call*(call_564139: Call_IotDpsResourceCreateOrUpdate_564130;
          apiVersion: string; iotDpsDescription: JsonNode; subscriptionId: string;
          resourceGroupName: string; provisioningServiceName: string): Recallable =
  ## iotDpsResourceCreateOrUpdate
  ## Create or update the metadata of the provisioning service. The usual pattern to modify a property is to retrieve the provisioning service metadata and security metadata, and then combine them with the modified values in a new body to update the provisioning service.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   iotDpsDescription: JObject (required)
  ##                    : Description of the provisioning service to create or update.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: string (required)
  ##                          : Name of provisioning service to create or update.
  var path_564140 = newJObject()
  var query_564141 = newJObject()
  var body_564142 = newJObject()
  add(query_564141, "api-version", newJString(apiVersion))
  if iotDpsDescription != nil:
    body_564142 = iotDpsDescription
  add(path_564140, "subscriptionId", newJString(subscriptionId))
  add(path_564140, "resourceGroupName", newJString(resourceGroupName))
  add(path_564140, "provisioningServiceName", newJString(provisioningServiceName))
  result = call_564139.call(path_564140, query_564141, nil, nil, body_564142)

var iotDpsResourceCreateOrUpdate* = Call_IotDpsResourceCreateOrUpdate_564130(
    name: "iotDpsResourceCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}",
    validator: validate_IotDpsResourceCreateOrUpdate_564131, base: "",
    url: url_IotDpsResourceCreateOrUpdate_564132, schemes: {Scheme.Https})
type
  Call_IotDpsResourceGet_564119 = ref object of OpenApiRestCall_563555
proc url_IotDpsResourceGet_564121(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "provisioningServiceName" in path,
        "`provisioningServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Devices/provisioningServices/"),
               (kind: VariableSegment, value: "provisioningServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotDpsResourceGet_564120(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get the metadata of the provisioning service without SAS keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of the provisioning service to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564122 = path.getOrDefault("subscriptionId")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "subscriptionId", valid_564122
  var valid_564123 = path.getOrDefault("resourceGroupName")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "resourceGroupName", valid_564123
  var valid_564124 = path.getOrDefault("provisioningServiceName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "provisioningServiceName", valid_564124
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564125 = query.getOrDefault("api-version")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "api-version", valid_564125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564126: Call_IotDpsResourceGet_564119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the metadata of the provisioning service without SAS keys.
  ## 
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_IotDpsResourceGet_564119; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          provisioningServiceName: string): Recallable =
  ## iotDpsResourceGet
  ## Get the metadata of the provisioning service without SAS keys.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   provisioningServiceName: string (required)
  ##                          : Name of the provisioning service to retrieve.
  var path_564128 = newJObject()
  var query_564129 = newJObject()
  add(query_564129, "api-version", newJString(apiVersion))
  add(path_564128, "subscriptionId", newJString(subscriptionId))
  add(path_564128, "resourceGroupName", newJString(resourceGroupName))
  add(path_564128, "provisioningServiceName", newJString(provisioningServiceName))
  result = call_564127.call(path_564128, query_564129, nil, nil, nil)

var iotDpsResourceGet* = Call_IotDpsResourceGet_564119(name: "iotDpsResourceGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}",
    validator: validate_IotDpsResourceGet_564120, base: "",
    url: url_IotDpsResourceGet_564121, schemes: {Scheme.Https})
type
  Call_IotDpsResourceUpdate_564154 = ref object of OpenApiRestCall_563555
proc url_IotDpsResourceUpdate_564156(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "provisioningServiceName" in path,
        "`provisioningServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Devices/provisioningServices/"),
               (kind: VariableSegment, value: "provisioningServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotDpsResourceUpdate_564155(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing provisioning service's tags. to update other fields use the CreateOrUpdate method
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of provisioning service to create or update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564174 = path.getOrDefault("subscriptionId")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "subscriptionId", valid_564174
  var valid_564175 = path.getOrDefault("resourceGroupName")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "resourceGroupName", valid_564175
  var valid_564176 = path.getOrDefault("provisioningServiceName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "provisioningServiceName", valid_564176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564177 = query.getOrDefault("api-version")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "api-version", valid_564177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ProvisioningServiceTags: JObject (required)
  ##                          : Updated tag information to set into the provisioning service instance.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564179: Call_IotDpsResourceUpdate_564154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing provisioning service's tags. to update other fields use the CreateOrUpdate method
  ## 
  let valid = call_564179.validator(path, query, header, formData, body)
  let scheme = call_564179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564179.url(scheme.get, call_564179.host, call_564179.base,
                         call_564179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564179, url, valid)

proc call*(call_564180: Call_IotDpsResourceUpdate_564154; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          provisioningServiceName: string; ProvisioningServiceTags: JsonNode): Recallable =
  ## iotDpsResourceUpdate
  ## Update an existing provisioning service's tags. to update other fields use the CreateOrUpdate method
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: string (required)
  ##                          : Name of provisioning service to create or update.
  ##   ProvisioningServiceTags: JObject (required)
  ##                          : Updated tag information to set into the provisioning service instance.
  var path_564181 = newJObject()
  var query_564182 = newJObject()
  var body_564183 = newJObject()
  add(query_564182, "api-version", newJString(apiVersion))
  add(path_564181, "subscriptionId", newJString(subscriptionId))
  add(path_564181, "resourceGroupName", newJString(resourceGroupName))
  add(path_564181, "provisioningServiceName", newJString(provisioningServiceName))
  if ProvisioningServiceTags != nil:
    body_564183 = ProvisioningServiceTags
  result = call_564180.call(path_564181, query_564182, nil, nil, body_564183)

var iotDpsResourceUpdate* = Call_IotDpsResourceUpdate_564154(
    name: "iotDpsResourceUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}",
    validator: validate_IotDpsResourceUpdate_564155, base: "",
    url: url_IotDpsResourceUpdate_564156, schemes: {Scheme.Https})
type
  Call_IotDpsResourceDelete_564143 = ref object of OpenApiRestCall_563555
proc url_IotDpsResourceDelete_564145(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "provisioningServiceName" in path,
        "`provisioningServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Devices/provisioningServices/"),
               (kind: VariableSegment, value: "provisioningServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotDpsResourceDelete_564144(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the Provisioning Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of provisioning service to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564146 = path.getOrDefault("subscriptionId")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "subscriptionId", valid_564146
  var valid_564147 = path.getOrDefault("resourceGroupName")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "resourceGroupName", valid_564147
  var valid_564148 = path.getOrDefault("provisioningServiceName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "provisioningServiceName", valid_564148
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564149 = query.getOrDefault("api-version")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "api-version", valid_564149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564150: Call_IotDpsResourceDelete_564143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the Provisioning Service.
  ## 
  let valid = call_564150.validator(path, query, header, formData, body)
  let scheme = call_564150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564150.url(scheme.get, call_564150.host, call_564150.base,
                         call_564150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564150, url, valid)

proc call*(call_564151: Call_IotDpsResourceDelete_564143; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          provisioningServiceName: string): Recallable =
  ## iotDpsResourceDelete
  ## Deletes the Provisioning Service.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: string (required)
  ##                          : Name of provisioning service to delete.
  var path_564152 = newJObject()
  var query_564153 = newJObject()
  add(query_564153, "api-version", newJString(apiVersion))
  add(path_564152, "subscriptionId", newJString(subscriptionId))
  add(path_564152, "resourceGroupName", newJString(resourceGroupName))
  add(path_564152, "provisioningServiceName", newJString(provisioningServiceName))
  result = call_564151.call(path_564152, query_564153, nil, nil, nil)

var iotDpsResourceDelete* = Call_IotDpsResourceDelete_564143(
    name: "iotDpsResourceDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}",
    validator: validate_IotDpsResourceDelete_564144, base: "",
    url: url_IotDpsResourceDelete_564145, schemes: {Scheme.Https})
type
  Call_DpsCertificateList_564184 = ref object of OpenApiRestCall_563555
proc url_DpsCertificateList_564186(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "provisioningServiceName" in path,
        "`provisioningServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Devices/provisioningServices/"),
               (kind: VariableSegment, value: "provisioningServiceName"),
               (kind: ConstantSegment, value: "/certificates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DpsCertificateList_564185(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get all the certificates tied to the provisioning service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Name of resource group.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of provisioning service to retrieve certificates for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564187 = path.getOrDefault("subscriptionId")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "subscriptionId", valid_564187
  var valid_564188 = path.getOrDefault("resourceGroupName")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "resourceGroupName", valid_564188
  var valid_564189 = path.getOrDefault("provisioningServiceName")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "provisioningServiceName", valid_564189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564190 = query.getOrDefault("api-version")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "api-version", valid_564190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564191: Call_DpsCertificateList_564184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the certificates tied to the provisioning service.
  ## 
  let valid = call_564191.validator(path, query, header, formData, body)
  let scheme = call_564191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564191.url(scheme.get, call_564191.host, call_564191.base,
                         call_564191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564191, url, valid)

proc call*(call_564192: Call_DpsCertificateList_564184; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          provisioningServiceName: string): Recallable =
  ## dpsCertificateList
  ## Get all the certificates tied to the provisioning service.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Name of resource group.
  ##   provisioningServiceName: string (required)
  ##                          : Name of provisioning service to retrieve certificates for.
  var path_564193 = newJObject()
  var query_564194 = newJObject()
  add(query_564194, "api-version", newJString(apiVersion))
  add(path_564193, "subscriptionId", newJString(subscriptionId))
  add(path_564193, "resourceGroupName", newJString(resourceGroupName))
  add(path_564193, "provisioningServiceName", newJString(provisioningServiceName))
  result = call_564192.call(path_564193, query_564194, nil, nil, nil)

var dpsCertificateList* = Call_DpsCertificateList_564184(
    name: "dpsCertificateList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates",
    validator: validate_DpsCertificateList_564185, base: "",
    url: url_DpsCertificateList_564186, schemes: {Scheme.Https})
type
  Call_DpsCertificateCreateOrUpdate_564208 = ref object of OpenApiRestCall_563555
proc url_DpsCertificateCreateOrUpdate_564210(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "provisioningServiceName" in path,
        "`provisioningServiceName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Devices/provisioningServices/"),
               (kind: VariableSegment, value: "provisioningServiceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DpsCertificateCreateOrUpdate_564209(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add new certificate or update an existing certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: JString (required)
  ##                          : The name of the provisioning service.
  ##   certificateName: JString (required)
  ##                  : The name of the certificate create or update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564211 = path.getOrDefault("subscriptionId")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "subscriptionId", valid_564211
  var valid_564212 = path.getOrDefault("resourceGroupName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "resourceGroupName", valid_564212
  var valid_564213 = path.getOrDefault("provisioningServiceName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "provisioningServiceName", valid_564213
  var valid_564214 = path.getOrDefault("certificateName")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "certificateName", valid_564214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564215 = query.getOrDefault("api-version")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "api-version", valid_564215
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the certificate. This is required to update an existing certificate, and ignored while creating a brand new certificate.
  section = newJObject()
  var valid_564216 = header.getOrDefault("If-Match")
  valid_564216 = validateParameter(valid_564216, JString, required = false,
                                 default = nil)
  if valid_564216 != nil:
    section.add "If-Match", valid_564216
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   certificateDescription: JObject (required)
  ##                         : The certificate body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564218: Call_DpsCertificateCreateOrUpdate_564208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add new certificate or update an existing certificate.
  ## 
  let valid = call_564218.validator(path, query, header, formData, body)
  let scheme = call_564218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564218.url(scheme.get, call_564218.host, call_564218.base,
                         call_564218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564218, url, valid)

proc call*(call_564219: Call_DpsCertificateCreateOrUpdate_564208;
          apiVersion: string; subscriptionId: string;
          certificateDescription: JsonNode; resourceGroupName: string;
          provisioningServiceName: string; certificateName: string): Recallable =
  ## dpsCertificateCreateOrUpdate
  ## Add new certificate or update an existing certificate.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   certificateDescription: JObject (required)
  ##                         : The certificate body.
  ##   resourceGroupName: string (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: string (required)
  ##                          : The name of the provisioning service.
  ##   certificateName: string (required)
  ##                  : The name of the certificate create or update.
  var path_564220 = newJObject()
  var query_564221 = newJObject()
  var body_564222 = newJObject()
  add(query_564221, "api-version", newJString(apiVersion))
  add(path_564220, "subscriptionId", newJString(subscriptionId))
  if certificateDescription != nil:
    body_564222 = certificateDescription
  add(path_564220, "resourceGroupName", newJString(resourceGroupName))
  add(path_564220, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_564220, "certificateName", newJString(certificateName))
  result = call_564219.call(path_564220, query_564221, nil, nil, body_564222)

var dpsCertificateCreateOrUpdate* = Call_DpsCertificateCreateOrUpdate_564208(
    name: "dpsCertificateCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}",
    validator: validate_DpsCertificateCreateOrUpdate_564209, base: "",
    url: url_DpsCertificateCreateOrUpdate_564210, schemes: {Scheme.Https})
type
  Call_DpsCertificateGet_564195 = ref object of OpenApiRestCall_563555
proc url_DpsCertificateGet_564197(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "provisioningServiceName" in path,
        "`provisioningServiceName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Devices/provisioningServices/"),
               (kind: VariableSegment, value: "provisioningServiceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DpsCertificateGet_564196(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get the certificate from the provisioning service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of the provisioning service the certificate is associated with.
  ##   certificateName: JString (required)
  ##                  : Name of the certificate to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564198 = path.getOrDefault("subscriptionId")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "subscriptionId", valid_564198
  var valid_564199 = path.getOrDefault("resourceGroupName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "resourceGroupName", valid_564199
  var valid_564200 = path.getOrDefault("provisioningServiceName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "provisioningServiceName", valid_564200
  var valid_564201 = path.getOrDefault("certificateName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "certificateName", valid_564201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564202 = query.getOrDefault("api-version")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "api-version", valid_564202
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the certificate.
  section = newJObject()
  var valid_564203 = header.getOrDefault("If-Match")
  valid_564203 = validateParameter(valid_564203, JString, required = false,
                                 default = nil)
  if valid_564203 != nil:
    section.add "If-Match", valid_564203
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564204: Call_DpsCertificateGet_564195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the certificate from the provisioning service.
  ## 
  let valid = call_564204.validator(path, query, header, formData, body)
  let scheme = call_564204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564204.url(scheme.get, call_564204.host, call_564204.base,
                         call_564204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564204, url, valid)

proc call*(call_564205: Call_DpsCertificateGet_564195; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          provisioningServiceName: string; certificateName: string): Recallable =
  ## dpsCertificateGet
  ## Get the certificate from the provisioning service.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: string (required)
  ##                          : Name of the provisioning service the certificate is associated with.
  ##   certificateName: string (required)
  ##                  : Name of the certificate to retrieve.
  var path_564206 = newJObject()
  var query_564207 = newJObject()
  add(query_564207, "api-version", newJString(apiVersion))
  add(path_564206, "subscriptionId", newJString(subscriptionId))
  add(path_564206, "resourceGroupName", newJString(resourceGroupName))
  add(path_564206, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_564206, "certificateName", newJString(certificateName))
  result = call_564205.call(path_564206, query_564207, nil, nil, nil)

var dpsCertificateGet* = Call_DpsCertificateGet_564195(name: "dpsCertificateGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}",
    validator: validate_DpsCertificateGet_564196, base: "",
    url: url_DpsCertificateGet_564197, schemes: {Scheme.Https})
type
  Call_DpsCertificateDelete_564223 = ref object of OpenApiRestCall_563555
proc url_DpsCertificateDelete_564225(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "provisioningServiceName" in path,
        "`provisioningServiceName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Devices/provisioningServices/"),
               (kind: VariableSegment, value: "provisioningServiceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DpsCertificateDelete_564224(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified certificate associated with the Provisioning Service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: JString (required)
  ##                          : The name of the provisioning service.
  ##   certificateName: JString (required)
  ##                  : This is a mandatory field, and is the logical name of the certificate that the provisioning service will access by.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564226 = path.getOrDefault("subscriptionId")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "subscriptionId", valid_564226
  var valid_564227 = path.getOrDefault("resourceGroupName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "resourceGroupName", valid_564227
  var valid_564228 = path.getOrDefault("provisioningServiceName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "provisioningServiceName", valid_564228
  var valid_564229 = path.getOrDefault("certificateName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "certificateName", valid_564229
  result.add "path", section
  ## parameters in `query` object:
  ##   certificate.purpose: JString
  ##                      : A description that mentions the purpose of the certificate.
  ##   certificate.lastUpdated: JString
  ##                          : Time the certificate is last updated.
  ##   api-version: JString (required)
  ##              : The version of the API.
  ##   certificate.created: JString
  ##                      : Time the certificate is created.
  ##   certificate.isVerified: JBool
  ##                         : Indicates if certificate has been verified by owner of the private key.
  ##   certificate.name: JString
  ##                   : This is optional, and it is the Common Name of the certificate.
  ##   certificate.rawBytes: JString
  ##                       : Raw data within the certificate.
  ##   certificate.hasPrivateKey: JBool
  ##                            : Indicates if the certificate contains a private key.
  ##   certificate.nonce: JString
  ##                    : Random number generated to indicate Proof of Possession.
  section = newJObject()
  var valid_564243 = query.getOrDefault("certificate.purpose")
  valid_564243 = validateParameter(valid_564243, JString, required = false,
                                 default = newJString("clientAuthentication"))
  if valid_564243 != nil:
    section.add "certificate.purpose", valid_564243
  var valid_564244 = query.getOrDefault("certificate.lastUpdated")
  valid_564244 = validateParameter(valid_564244, JString, required = false,
                                 default = nil)
  if valid_564244 != nil:
    section.add "certificate.lastUpdated", valid_564244
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564245 = query.getOrDefault("api-version")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "api-version", valid_564245
  var valid_564246 = query.getOrDefault("certificate.created")
  valid_564246 = validateParameter(valid_564246, JString, required = false,
                                 default = nil)
  if valid_564246 != nil:
    section.add "certificate.created", valid_564246
  var valid_564247 = query.getOrDefault("certificate.isVerified")
  valid_564247 = validateParameter(valid_564247, JBool, required = false, default = nil)
  if valid_564247 != nil:
    section.add "certificate.isVerified", valid_564247
  var valid_564248 = query.getOrDefault("certificate.name")
  valid_564248 = validateParameter(valid_564248, JString, required = false,
                                 default = nil)
  if valid_564248 != nil:
    section.add "certificate.name", valid_564248
  var valid_564249 = query.getOrDefault("certificate.rawBytes")
  valid_564249 = validateParameter(valid_564249, JString, required = false,
                                 default = nil)
  if valid_564249 != nil:
    section.add "certificate.rawBytes", valid_564249
  var valid_564250 = query.getOrDefault("certificate.hasPrivateKey")
  valid_564250 = validateParameter(valid_564250, JBool, required = false, default = nil)
  if valid_564250 != nil:
    section.add "certificate.hasPrivateKey", valid_564250
  var valid_564251 = query.getOrDefault("certificate.nonce")
  valid_564251 = validateParameter(valid_564251, JString, required = false,
                                 default = nil)
  if valid_564251 != nil:
    section.add "certificate.nonce", valid_564251
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the certificate
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564252 = header.getOrDefault("If-Match")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "If-Match", valid_564252
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564253: Call_DpsCertificateDelete_564223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified certificate associated with the Provisioning Service
  ## 
  let valid = call_564253.validator(path, query, header, formData, body)
  let scheme = call_564253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564253.url(scheme.get, call_564253.host, call_564253.base,
                         call_564253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564253, url, valid)

var dpsCertificateDelete* = Call_DpsCertificateDelete_564223(
    name: "dpsCertificateDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}",
    validator: validate_DpsCertificateDelete_564224, base: "",
    url: url_DpsCertificateDelete_564225, schemes: {Scheme.Https})
type
  Call_DpsCertificateGenerateVerificationCode_564257 = ref object of OpenApiRestCall_563555
proc url_DpsCertificateGenerateVerificationCode_564259(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "provisioningServiceName" in path,
        "`provisioningServiceName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Devices/provisioningServices/"),
               (kind: VariableSegment, value: "provisioningServiceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName"),
               (kind: ConstantSegment, value: "/generateVerificationCode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DpsCertificateGenerateVerificationCode_564258(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate verification code for Proof of Possession.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : name of resource group.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of provisioning service.
  ##   certificateName: JString (required)
  ##                  : The mandatory logical name of the certificate, that the provisioning service uses to access.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564260 = path.getOrDefault("subscriptionId")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "subscriptionId", valid_564260
  var valid_564261 = path.getOrDefault("resourceGroupName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "resourceGroupName", valid_564261
  var valid_564262 = path.getOrDefault("provisioningServiceName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "provisioningServiceName", valid_564262
  var valid_564263 = path.getOrDefault("certificateName")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "certificateName", valid_564263
  result.add "path", section
  ## parameters in `query` object:
  ##   certificate.purpose: JString
  ##                      : Description mentioning the purpose of the certificate.
  ##   certificate.lastUpdated: JString
  ##                          : Certificate last updated time.
  ##   api-version: JString (required)
  ##              : The version of the API.
  ##   certificate.created: JString
  ##                      : Certificate creation time.
  ##   certificate.isVerified: JBool
  ##                         : Indicates if the certificate has been verified by owner of the private key.
  ##   certificate.name: JString
  ##                   : Common Name for the certificate.
  ##   certificate.rawBytes: JString
  ##                       : Raw data of certificate.
  ##   certificate.hasPrivateKey: JBool
  ##                            : Indicates if the certificate contains private key.
  ##   certificate.nonce: JString
  ##                    : Random number generated to indicate Proof of Possession.
  section = newJObject()
  var valid_564264 = query.getOrDefault("certificate.purpose")
  valid_564264 = validateParameter(valid_564264, JString, required = false,
                                 default = newJString("clientAuthentication"))
  if valid_564264 != nil:
    section.add "certificate.purpose", valid_564264
  var valid_564265 = query.getOrDefault("certificate.lastUpdated")
  valid_564265 = validateParameter(valid_564265, JString, required = false,
                                 default = nil)
  if valid_564265 != nil:
    section.add "certificate.lastUpdated", valid_564265
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564266 = query.getOrDefault("api-version")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "api-version", valid_564266
  var valid_564267 = query.getOrDefault("certificate.created")
  valid_564267 = validateParameter(valid_564267, JString, required = false,
                                 default = nil)
  if valid_564267 != nil:
    section.add "certificate.created", valid_564267
  var valid_564268 = query.getOrDefault("certificate.isVerified")
  valid_564268 = validateParameter(valid_564268, JBool, required = false, default = nil)
  if valid_564268 != nil:
    section.add "certificate.isVerified", valid_564268
  var valid_564269 = query.getOrDefault("certificate.name")
  valid_564269 = validateParameter(valid_564269, JString, required = false,
                                 default = nil)
  if valid_564269 != nil:
    section.add "certificate.name", valid_564269
  var valid_564270 = query.getOrDefault("certificate.rawBytes")
  valid_564270 = validateParameter(valid_564270, JString, required = false,
                                 default = nil)
  if valid_564270 != nil:
    section.add "certificate.rawBytes", valid_564270
  var valid_564271 = query.getOrDefault("certificate.hasPrivateKey")
  valid_564271 = validateParameter(valid_564271, JBool, required = false, default = nil)
  if valid_564271 != nil:
    section.add "certificate.hasPrivateKey", valid_564271
  var valid_564272 = query.getOrDefault("certificate.nonce")
  valid_564272 = validateParameter(valid_564272, JString, required = false,
                                 default = nil)
  if valid_564272 != nil:
    section.add "certificate.nonce", valid_564272
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the certificate. This is required to update an existing certificate, and ignored while creating a brand new certificate.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564273 = header.getOrDefault("If-Match")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "If-Match", valid_564273
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564274: Call_DpsCertificateGenerateVerificationCode_564257;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate verification code for Proof of Possession.
  ## 
  let valid = call_564274.validator(path, query, header, formData, body)
  let scheme = call_564274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564274.url(scheme.get, call_564274.host, call_564274.base,
                         call_564274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564274, url, valid)

var dpsCertificateGenerateVerificationCode* = Call_DpsCertificateGenerateVerificationCode_564257(
    name: "dpsCertificateGenerateVerificationCode", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}/generateVerificationCode",
    validator: validate_DpsCertificateGenerateVerificationCode_564258, base: "",
    url: url_DpsCertificateGenerateVerificationCode_564259,
    schemes: {Scheme.Https})
type
  Call_DpsCertificateVerifyCertificate_564278 = ref object of OpenApiRestCall_563555
proc url_DpsCertificateVerifyCertificate_564280(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "provisioningServiceName" in path,
        "`provisioningServiceName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Devices/provisioningServices/"),
               (kind: VariableSegment, value: "provisioningServiceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName"),
               (kind: ConstantSegment, value: "/verify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DpsCertificateVerifyCertificate_564279(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verifies the certificate's private key possession by providing the leaf cert issued by the verifying pre uploaded certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   provisioningServiceName: JString (required)
  ##                          : Provisioning service name.
  ##   certificateName: JString (required)
  ##                  : The mandatory logical name of the certificate, that the provisioning service uses to access.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564281 = path.getOrDefault("subscriptionId")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "subscriptionId", valid_564281
  var valid_564282 = path.getOrDefault("resourceGroupName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "resourceGroupName", valid_564282
  var valid_564283 = path.getOrDefault("provisioningServiceName")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "provisioningServiceName", valid_564283
  var valid_564284 = path.getOrDefault("certificateName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "certificateName", valid_564284
  result.add "path", section
  ## parameters in `query` object:
  ##   certificate.purpose: JString
  ##                      : Describe the purpose of the certificate.
  ##   certificate.lastUpdated: JString
  ##                          : Certificate last updated time.
  ##   api-version: JString (required)
  ##              : The version of the API.
  ##   certificate.created: JString
  ##                      : Certificate creation time.
  ##   certificate.isVerified: JBool
  ##                         : Indicates if the certificate has been verified by owner of the private key.
  ##   certificate.name: JString
  ##                   : Common Name for the certificate.
  ##   certificate.rawBytes: JString
  ##                       : Raw data of certificate.
  ##   certificate.hasPrivateKey: JBool
  ##                            : Indicates if the certificate contains private key.
  ##   certificate.nonce: JString
  ##                    : Random number generated to indicate Proof of Possession.
  section = newJObject()
  var valid_564285 = query.getOrDefault("certificate.purpose")
  valid_564285 = validateParameter(valid_564285, JString, required = false,
                                 default = newJString("clientAuthentication"))
  if valid_564285 != nil:
    section.add "certificate.purpose", valid_564285
  var valid_564286 = query.getOrDefault("certificate.lastUpdated")
  valid_564286 = validateParameter(valid_564286, JString, required = false,
                                 default = nil)
  if valid_564286 != nil:
    section.add "certificate.lastUpdated", valid_564286
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564287 = query.getOrDefault("api-version")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "api-version", valid_564287
  var valid_564288 = query.getOrDefault("certificate.created")
  valid_564288 = validateParameter(valid_564288, JString, required = false,
                                 default = nil)
  if valid_564288 != nil:
    section.add "certificate.created", valid_564288
  var valid_564289 = query.getOrDefault("certificate.isVerified")
  valid_564289 = validateParameter(valid_564289, JBool, required = false, default = nil)
  if valid_564289 != nil:
    section.add "certificate.isVerified", valid_564289
  var valid_564290 = query.getOrDefault("certificate.name")
  valid_564290 = validateParameter(valid_564290, JString, required = false,
                                 default = nil)
  if valid_564290 != nil:
    section.add "certificate.name", valid_564290
  var valid_564291 = query.getOrDefault("certificate.rawBytes")
  valid_564291 = validateParameter(valid_564291, JString, required = false,
                                 default = nil)
  if valid_564291 != nil:
    section.add "certificate.rawBytes", valid_564291
  var valid_564292 = query.getOrDefault("certificate.hasPrivateKey")
  valid_564292 = validateParameter(valid_564292, JBool, required = false, default = nil)
  if valid_564292 != nil:
    section.add "certificate.hasPrivateKey", valid_564292
  var valid_564293 = query.getOrDefault("certificate.nonce")
  valid_564293 = validateParameter(valid_564293, JString, required = false,
                                 default = nil)
  if valid_564293 != nil:
    section.add "certificate.nonce", valid_564293
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the certificate.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564294 = header.getOrDefault("If-Match")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "If-Match", valid_564294
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : The name of the certificate
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564296: Call_DpsCertificateVerifyCertificate_564278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies the certificate's private key possession by providing the leaf cert issued by the verifying pre uploaded certificate.
  ## 
  let valid = call_564296.validator(path, query, header, formData, body)
  let scheme = call_564296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564296.url(scheme.get, call_564296.host, call_564296.base,
                         call_564296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564296, url, valid)

var dpsCertificateVerifyCertificate* = Call_DpsCertificateVerifyCertificate_564278(
    name: "dpsCertificateVerifyCertificate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}/verify",
    validator: validate_DpsCertificateVerifyCertificate_564279, base: "",
    url: url_DpsCertificateVerifyCertificate_564280, schemes: {Scheme.Https})
type
  Call_IotDpsResourceListKeysForKeyName_564301 = ref object of OpenApiRestCall_563555
proc url_IotDpsResourceListKeysForKeyName_564303(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "provisioningServiceName" in path,
        "`provisioningServiceName` is a required path parameter"
  assert "keyName" in path, "`keyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Devices/provisioningServices/"),
               (kind: VariableSegment, value: "provisioningServiceName"),
               (kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "keyName"),
               (kind: ConstantSegment, value: "/listkeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotDpsResourceListKeysForKeyName_564302(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List primary and secondary keys for a specific key name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   keyName: JString (required)
  ##          : Logical key name to get key-values for.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the provisioning service.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of the provisioning service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `keyName` field"
  var valid_564304 = path.getOrDefault("keyName")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "keyName", valid_564304
  var valid_564305 = path.getOrDefault("subscriptionId")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "subscriptionId", valid_564305
  var valid_564306 = path.getOrDefault("resourceGroupName")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "resourceGroupName", valid_564306
  var valid_564307 = path.getOrDefault("provisioningServiceName")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "provisioningServiceName", valid_564307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564308 = query.getOrDefault("api-version")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "api-version", valid_564308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564309: Call_IotDpsResourceListKeysForKeyName_564301;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List primary and secondary keys for a specific key name
  ## 
  let valid = call_564309.validator(path, query, header, formData, body)
  let scheme = call_564309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564309.url(scheme.get, call_564309.host, call_564309.base,
                         call_564309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564309, url, valid)

proc call*(call_564310: Call_IotDpsResourceListKeysForKeyName_564301;
          apiVersion: string; keyName: string; subscriptionId: string;
          resourceGroupName: string; provisioningServiceName: string): Recallable =
  ## iotDpsResourceListKeysForKeyName
  ## List primary and secondary keys for a specific key name
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   keyName: string (required)
  ##          : Logical key name to get key-values for.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the provisioning service.
  ##   provisioningServiceName: string (required)
  ##                          : Name of the provisioning service.
  var path_564311 = newJObject()
  var query_564312 = newJObject()
  add(query_564312, "api-version", newJString(apiVersion))
  add(path_564311, "keyName", newJString(keyName))
  add(path_564311, "subscriptionId", newJString(subscriptionId))
  add(path_564311, "resourceGroupName", newJString(resourceGroupName))
  add(path_564311, "provisioningServiceName", newJString(provisioningServiceName))
  result = call_564310.call(path_564311, query_564312, nil, nil, nil)

var iotDpsResourceListKeysForKeyName* = Call_IotDpsResourceListKeysForKeyName_564301(
    name: "iotDpsResourceListKeysForKeyName", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/keys/{keyName}/listkeys",
    validator: validate_IotDpsResourceListKeysForKeyName_564302, base: "",
    url: url_IotDpsResourceListKeysForKeyName_564303, schemes: {Scheme.Https})
type
  Call_IotDpsResourceListKeys_564313 = ref object of OpenApiRestCall_563555
proc url_IotDpsResourceListKeys_564315(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "provisioningServiceName" in path,
        "`provisioningServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Devices/provisioningServices/"),
               (kind: VariableSegment, value: "provisioningServiceName"),
               (kind: ConstantSegment, value: "/listkeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotDpsResourceListKeys_564314(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the primary and secondary keys for a provisioning service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : resource group name
  ##   provisioningServiceName: JString (required)
  ##                          : The provisioning service name to get the shared access keys for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564316 = path.getOrDefault("subscriptionId")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "subscriptionId", valid_564316
  var valid_564317 = path.getOrDefault("resourceGroupName")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "resourceGroupName", valid_564317
  var valid_564318 = path.getOrDefault("provisioningServiceName")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "provisioningServiceName", valid_564318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564319 = query.getOrDefault("api-version")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "api-version", valid_564319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564320: Call_IotDpsResourceListKeys_564313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the primary and secondary keys for a provisioning service.
  ## 
  let valid = call_564320.validator(path, query, header, formData, body)
  let scheme = call_564320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564320.url(scheme.get, call_564320.host, call_564320.base,
                         call_564320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564320, url, valid)

proc call*(call_564321: Call_IotDpsResourceListKeys_564313; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          provisioningServiceName: string): Recallable =
  ## iotDpsResourceListKeys
  ## List the primary and secondary keys for a provisioning service.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : resource group name
  ##   provisioningServiceName: string (required)
  ##                          : The provisioning service name to get the shared access keys for.
  var path_564322 = newJObject()
  var query_564323 = newJObject()
  add(query_564323, "api-version", newJString(apiVersion))
  add(path_564322, "subscriptionId", newJString(subscriptionId))
  add(path_564322, "resourceGroupName", newJString(resourceGroupName))
  add(path_564322, "provisioningServiceName", newJString(provisioningServiceName))
  result = call_564321.call(path_564322, query_564323, nil, nil, nil)

var iotDpsResourceListKeys* = Call_IotDpsResourceListKeys_564313(
    name: "iotDpsResourceListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/listkeys",
    validator: validate_IotDpsResourceListKeys_564314, base: "",
    url: url_IotDpsResourceListKeys_564315, schemes: {Scheme.Https})
type
  Call_IotDpsResourceGetOperationResult_564324 = ref object of OpenApiRestCall_563555
proc url_IotDpsResourceGetOperationResult_564326(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "provisioningServiceName" in path,
        "`provisioningServiceName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Devices/provisioningServices/"),
               (kind: VariableSegment, value: "provisioningServiceName"),
               (kind: ConstantSegment, value: "/operationresults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotDpsResourceGetOperationResult_564325(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of a long running operation, such as create, update or delete a provisioning service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : Operation id corresponding to long running operation. Use this to poll for the status.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of provisioning service that the operation is running on.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_564327 = path.getOrDefault("operationId")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "operationId", valid_564327
  var valid_564328 = path.getOrDefault("subscriptionId")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "subscriptionId", valid_564328
  var valid_564329 = path.getOrDefault("resourceGroupName")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "resourceGroupName", valid_564329
  var valid_564330 = path.getOrDefault("provisioningServiceName")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "provisioningServiceName", valid_564330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  ##   asyncinfo: JString (required)
  ##            : Async header used to poll on the status of the operation, obtained while creating the long running operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564331 = query.getOrDefault("api-version")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "api-version", valid_564331
  var valid_564332 = query.getOrDefault("asyncinfo")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = newJString("true"))
  if valid_564332 != nil:
    section.add "asyncinfo", valid_564332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564333: Call_IotDpsResourceGetOperationResult_564324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a long running operation, such as create, update or delete a provisioning service.
  ## 
  let valid = call_564333.validator(path, query, header, formData, body)
  let scheme = call_564333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564333.url(scheme.get, call_564333.host, call_564333.base,
                         call_564333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564333, url, valid)

proc call*(call_564334: Call_IotDpsResourceGetOperationResult_564324;
          apiVersion: string; operationId: string; subscriptionId: string;
          resourceGroupName: string; provisioningServiceName: string;
          asyncinfo: string = "true"): Recallable =
  ## iotDpsResourceGetOperationResult
  ## Gets the status of a long running operation, such as create, update or delete a provisioning service.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   operationId: string (required)
  ##              : Operation id corresponding to long running operation. Use this to poll for the status.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: string (required)
  ##                          : Name of provisioning service that the operation is running on.
  ##   asyncinfo: string (required)
  ##            : Async header used to poll on the status of the operation, obtained while creating the long running operation.
  var path_564335 = newJObject()
  var query_564336 = newJObject()
  add(query_564336, "api-version", newJString(apiVersion))
  add(path_564335, "operationId", newJString(operationId))
  add(path_564335, "subscriptionId", newJString(subscriptionId))
  add(path_564335, "resourceGroupName", newJString(resourceGroupName))
  add(path_564335, "provisioningServiceName", newJString(provisioningServiceName))
  add(query_564336, "asyncinfo", newJString(asyncinfo))
  result = call_564334.call(path_564335, query_564336, nil, nil, nil)

var iotDpsResourceGetOperationResult* = Call_IotDpsResourceGetOperationResult_564324(
    name: "iotDpsResourceGetOperationResult", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/operationresults/{operationId}",
    validator: validate_IotDpsResourceGetOperationResult_564325, base: "",
    url: url_IotDpsResourceGetOperationResult_564326, schemes: {Scheme.Https})
type
  Call_IotDpsResourceListValidSkus_564337 = ref object of OpenApiRestCall_563555
proc url_IotDpsResourceListValidSkus_564339(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "provisioningServiceName" in path,
        "`provisioningServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Devices/provisioningServices/"),
               (kind: VariableSegment, value: "provisioningServiceName"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotDpsResourceListValidSkus_564338(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of valid SKUs and tiers for a provisioning service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Name of resource group.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of provisioning service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564340 = path.getOrDefault("subscriptionId")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "subscriptionId", valid_564340
  var valid_564341 = path.getOrDefault("resourceGroupName")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "resourceGroupName", valid_564341
  var valid_564342 = path.getOrDefault("provisioningServiceName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "provisioningServiceName", valid_564342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564343 = query.getOrDefault("api-version")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "api-version", valid_564343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564344: Call_IotDpsResourceListValidSkus_564337; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of valid SKUs and tiers for a provisioning service.
  ## 
  let valid = call_564344.validator(path, query, header, formData, body)
  let scheme = call_564344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564344.url(scheme.get, call_564344.host, call_564344.base,
                         call_564344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564344, url, valid)

proc call*(call_564345: Call_IotDpsResourceListValidSkus_564337;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          provisioningServiceName: string): Recallable =
  ## iotDpsResourceListValidSkus
  ## Gets the list of valid SKUs and tiers for a provisioning service.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Name of resource group.
  ##   provisioningServiceName: string (required)
  ##                          : Name of provisioning service.
  var path_564346 = newJObject()
  var query_564347 = newJObject()
  add(query_564347, "api-version", newJString(apiVersion))
  add(path_564346, "subscriptionId", newJString(subscriptionId))
  add(path_564346, "resourceGroupName", newJString(resourceGroupName))
  add(path_564346, "provisioningServiceName", newJString(provisioningServiceName))
  result = call_564345.call(path_564346, query_564347, nil, nil, nil)

var iotDpsResourceListValidSkus* = Call_IotDpsResourceListValidSkus_564337(
    name: "iotDpsResourceListValidSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/skus",
    validator: validate_IotDpsResourceListValidSkus_564338, base: "",
    url: url_IotDpsResourceListValidSkus_564339, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
