
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: iotDpsClient
## version: 2017-08-21-preview
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
  Call_IotDpsResourceCheckNameAvailability_564075 = ref object of OpenApiRestCall_563555
proc url_IotDpsResourceCheckNameAvailability_564077(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_IotDpsResourceCheckNameAvailability_564076(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check if a provisioning service name is available.
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

proc call*(call_564095: Call_IotDpsResourceCheckNameAvailability_564075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check if a provisioning service name is available.
  ## 
  let valid = call_564095.validator(path, query, header, formData, body)
  let scheme = call_564095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564095.url(scheme.get, call_564095.host, call_564095.base,
                         call_564095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564095, url, valid)

proc call*(call_564096: Call_IotDpsResourceCheckNameAvailability_564075;
          apiVersion: string; subscriptionId: string; arguments: JsonNode): Recallable =
  ## iotDpsResourceCheckNameAvailability
  ## Check if a provisioning service name is available.
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

var iotDpsResourceCheckNameAvailability* = Call_IotDpsResourceCheckNameAvailability_564075(
    name: "iotDpsResourceCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Devices/checkProvisioningServiceNameAvailability",
    validator: validate_IotDpsResourceCheckNameAvailability_564076, base: "",
    url: url_IotDpsResourceCheckNameAvailability_564077, schemes: {Scheme.Https})
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
  ## Get all the provisioning services in a subscription.
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
  ## Get all the provisioning services in a subscription.
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
  ## Get all the provisioning services in a subscription.
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
  ## Get the non-security related metadata of the provisioning service.
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
  ## Get the non-security related metadata of the provisioning service.
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
  ## Get the non-security related metadata of the provisioning service.
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
  Call_DpsCertificatesList_564154 = ref object of OpenApiRestCall_563555
proc url_DpsCertificatesList_564156(protocol: Scheme; host: string; base: string;
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

proc validate_DpsCertificatesList_564155(path: JsonNode; query: JsonNode;
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
  var valid_564157 = path.getOrDefault("subscriptionId")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "subscriptionId", valid_564157
  var valid_564158 = path.getOrDefault("resourceGroupName")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "resourceGroupName", valid_564158
  var valid_564159 = path.getOrDefault("provisioningServiceName")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "provisioningServiceName", valid_564159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564160 = query.getOrDefault("api-version")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "api-version", valid_564160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564161: Call_DpsCertificatesList_564154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the certificates tied to the provisioning service.
  ## 
  let valid = call_564161.validator(path, query, header, formData, body)
  let scheme = call_564161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564161.url(scheme.get, call_564161.host, call_564161.base,
                         call_564161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564161, url, valid)

proc call*(call_564162: Call_DpsCertificatesList_564154; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          provisioningServiceName: string): Recallable =
  ## dpsCertificatesList
  ## Get all the certificates tied to the provisioning service.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Name of resource group.
  ##   provisioningServiceName: string (required)
  ##                          : Name of provisioning service to retrieve certificates for.
  var path_564163 = newJObject()
  var query_564164 = newJObject()
  add(query_564164, "api-version", newJString(apiVersion))
  add(path_564163, "subscriptionId", newJString(subscriptionId))
  add(path_564163, "resourceGroupName", newJString(resourceGroupName))
  add(path_564163, "provisioningServiceName", newJString(provisioningServiceName))
  result = call_564162.call(path_564163, query_564164, nil, nil, nil)

var dpsCertificatesList* = Call_DpsCertificatesList_564154(
    name: "dpsCertificatesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates",
    validator: validate_DpsCertificatesList_564155, base: "",
    url: url_DpsCertificatesList_564156, schemes: {Scheme.Https})
type
  Call_DpsCertificateCreateOrUpdate_564178 = ref object of OpenApiRestCall_563555
proc url_DpsCertificateCreateOrUpdate_564180(protocol: Scheme; host: string;
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

proc validate_DpsCertificateCreateOrUpdate_564179(path: JsonNode; query: JsonNode;
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
  var valid_564181 = path.getOrDefault("subscriptionId")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "subscriptionId", valid_564181
  var valid_564182 = path.getOrDefault("resourceGroupName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "resourceGroupName", valid_564182
  var valid_564183 = path.getOrDefault("provisioningServiceName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "provisioningServiceName", valid_564183
  var valid_564184 = path.getOrDefault("certificateName")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "certificateName", valid_564184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564185 = query.getOrDefault("api-version")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "api-version", valid_564185
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the certificate. This is required to update an existing certificate, and ignored while creating a brand new certificate.
  section = newJObject()
  var valid_564186 = header.getOrDefault("If-Match")
  valid_564186 = validateParameter(valid_564186, JString, required = false,
                                 default = nil)
  if valid_564186 != nil:
    section.add "If-Match", valid_564186
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

proc call*(call_564188: Call_DpsCertificateCreateOrUpdate_564178; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add new certificate or update an existing certificate.
  ## 
  let valid = call_564188.validator(path, query, header, formData, body)
  let scheme = call_564188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564188.url(scheme.get, call_564188.host, call_564188.base,
                         call_564188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564188, url, valid)

proc call*(call_564189: Call_DpsCertificateCreateOrUpdate_564178;
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
  var path_564190 = newJObject()
  var query_564191 = newJObject()
  var body_564192 = newJObject()
  add(query_564191, "api-version", newJString(apiVersion))
  add(path_564190, "subscriptionId", newJString(subscriptionId))
  if certificateDescription != nil:
    body_564192 = certificateDescription
  add(path_564190, "resourceGroupName", newJString(resourceGroupName))
  add(path_564190, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_564190, "certificateName", newJString(certificateName))
  result = call_564189.call(path_564190, query_564191, nil, nil, body_564192)

var dpsCertificateCreateOrUpdate* = Call_DpsCertificateCreateOrUpdate_564178(
    name: "dpsCertificateCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}",
    validator: validate_DpsCertificateCreateOrUpdate_564179, base: "",
    url: url_DpsCertificateCreateOrUpdate_564180, schemes: {Scheme.Https})
type
  Call_DpsCertificateGet_564165 = ref object of OpenApiRestCall_563555
proc url_DpsCertificateGet_564167(protocol: Scheme; host: string; base: string;
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

proc validate_DpsCertificateGet_564166(path: JsonNode; query: JsonNode;
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
  var valid_564168 = path.getOrDefault("subscriptionId")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "subscriptionId", valid_564168
  var valid_564169 = path.getOrDefault("resourceGroupName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "resourceGroupName", valid_564169
  var valid_564170 = path.getOrDefault("provisioningServiceName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "provisioningServiceName", valid_564170
  var valid_564171 = path.getOrDefault("certificateName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "certificateName", valid_564171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564172 = query.getOrDefault("api-version")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "api-version", valid_564172
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the certificate.
  section = newJObject()
  var valid_564173 = header.getOrDefault("If-Match")
  valid_564173 = validateParameter(valid_564173, JString, required = false,
                                 default = nil)
  if valid_564173 != nil:
    section.add "If-Match", valid_564173
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564174: Call_DpsCertificateGet_564165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the certificate from the provisioning service.
  ## 
  let valid = call_564174.validator(path, query, header, formData, body)
  let scheme = call_564174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564174.url(scheme.get, call_564174.host, call_564174.base,
                         call_564174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564174, url, valid)

proc call*(call_564175: Call_DpsCertificateGet_564165; apiVersion: string;
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
  var path_564176 = newJObject()
  var query_564177 = newJObject()
  add(query_564177, "api-version", newJString(apiVersion))
  add(path_564176, "subscriptionId", newJString(subscriptionId))
  add(path_564176, "resourceGroupName", newJString(resourceGroupName))
  add(path_564176, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_564176, "certificateName", newJString(certificateName))
  result = call_564175.call(path_564176, query_564177, nil, nil, nil)

var dpsCertificateGet* = Call_DpsCertificateGet_564165(name: "dpsCertificateGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}",
    validator: validate_DpsCertificateGet_564166, base: "",
    url: url_DpsCertificateGet_564167, schemes: {Scheme.Https})
type
  Call_DpsCertificateDelete_564193 = ref object of OpenApiRestCall_563555
proc url_DpsCertificateDelete_564195(protocol: Scheme; host: string; base: string;
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

proc validate_DpsCertificateDelete_564194(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564196 = path.getOrDefault("subscriptionId")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "subscriptionId", valid_564196
  var valid_564197 = path.getOrDefault("resourceGroupName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "resourceGroupName", valid_564197
  var valid_564198 = path.getOrDefault("provisioningServiceName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "provisioningServiceName", valid_564198
  var valid_564199 = path.getOrDefault("certificateName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "certificateName", valid_564199
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
  var valid_564213 = query.getOrDefault("certificate.purpose")
  valid_564213 = validateParameter(valid_564213, JString, required = false,
                                 default = newJString("clientAuthentication"))
  if valid_564213 != nil:
    section.add "certificate.purpose", valid_564213
  var valid_564214 = query.getOrDefault("certificate.lastUpdated")
  valid_564214 = validateParameter(valid_564214, JString, required = false,
                                 default = nil)
  if valid_564214 != nil:
    section.add "certificate.lastUpdated", valid_564214
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564215 = query.getOrDefault("api-version")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "api-version", valid_564215
  var valid_564216 = query.getOrDefault("certificate.created")
  valid_564216 = validateParameter(valid_564216, JString, required = false,
                                 default = nil)
  if valid_564216 != nil:
    section.add "certificate.created", valid_564216
  var valid_564217 = query.getOrDefault("certificate.isVerified")
  valid_564217 = validateParameter(valid_564217, JBool, required = false, default = nil)
  if valid_564217 != nil:
    section.add "certificate.isVerified", valid_564217
  var valid_564218 = query.getOrDefault("certificate.name")
  valid_564218 = validateParameter(valid_564218, JString, required = false,
                                 default = nil)
  if valid_564218 != nil:
    section.add "certificate.name", valid_564218
  var valid_564219 = query.getOrDefault("certificate.rawBytes")
  valid_564219 = validateParameter(valid_564219, JString, required = false,
                                 default = nil)
  if valid_564219 != nil:
    section.add "certificate.rawBytes", valid_564219
  var valid_564220 = query.getOrDefault("certificate.hasPrivateKey")
  valid_564220 = validateParameter(valid_564220, JBool, required = false, default = nil)
  if valid_564220 != nil:
    section.add "certificate.hasPrivateKey", valid_564220
  var valid_564221 = query.getOrDefault("certificate.nonce")
  valid_564221 = validateParameter(valid_564221, JString, required = false,
                                 default = nil)
  if valid_564221 != nil:
    section.add "certificate.nonce", valid_564221
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the certificate
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564222 = header.getOrDefault("If-Match")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "If-Match", valid_564222
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564223: Call_DpsCertificateDelete_564193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564223.validator(path, query, header, formData, body)
  let scheme = call_564223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564223.url(scheme.get, call_564223.host, call_564223.base,
                         call_564223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564223, url, valid)

var dpsCertificateDelete* = Call_DpsCertificateDelete_564193(
    name: "dpsCertificateDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}",
    validator: validate_DpsCertificateDelete_564194, base: "",
    url: url_DpsCertificateDelete_564195, schemes: {Scheme.Https})
type
  Call_DpsCertificateGenerateVerificationCode_564227 = ref object of OpenApiRestCall_563555
proc url_DpsCertificateGenerateVerificationCode_564229(protocol: Scheme;
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

proc validate_DpsCertificateGenerateVerificationCode_564228(path: JsonNode;
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
  var valid_564230 = path.getOrDefault("subscriptionId")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "subscriptionId", valid_564230
  var valid_564231 = path.getOrDefault("resourceGroupName")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "resourceGroupName", valid_564231
  var valid_564232 = path.getOrDefault("provisioningServiceName")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "provisioningServiceName", valid_564232
  var valid_564233 = path.getOrDefault("certificateName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "certificateName", valid_564233
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
  var valid_564234 = query.getOrDefault("certificate.purpose")
  valid_564234 = validateParameter(valid_564234, JString, required = false,
                                 default = newJString("clientAuthentication"))
  if valid_564234 != nil:
    section.add "certificate.purpose", valid_564234
  var valid_564235 = query.getOrDefault("certificate.lastUpdated")
  valid_564235 = validateParameter(valid_564235, JString, required = false,
                                 default = nil)
  if valid_564235 != nil:
    section.add "certificate.lastUpdated", valid_564235
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564236 = query.getOrDefault("api-version")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "api-version", valid_564236
  var valid_564237 = query.getOrDefault("certificate.created")
  valid_564237 = validateParameter(valid_564237, JString, required = false,
                                 default = nil)
  if valid_564237 != nil:
    section.add "certificate.created", valid_564237
  var valid_564238 = query.getOrDefault("certificate.isVerified")
  valid_564238 = validateParameter(valid_564238, JBool, required = false, default = nil)
  if valid_564238 != nil:
    section.add "certificate.isVerified", valid_564238
  var valid_564239 = query.getOrDefault("certificate.name")
  valid_564239 = validateParameter(valid_564239, JString, required = false,
                                 default = nil)
  if valid_564239 != nil:
    section.add "certificate.name", valid_564239
  var valid_564240 = query.getOrDefault("certificate.rawBytes")
  valid_564240 = validateParameter(valid_564240, JString, required = false,
                                 default = nil)
  if valid_564240 != nil:
    section.add "certificate.rawBytes", valid_564240
  var valid_564241 = query.getOrDefault("certificate.hasPrivateKey")
  valid_564241 = validateParameter(valid_564241, JBool, required = false, default = nil)
  if valid_564241 != nil:
    section.add "certificate.hasPrivateKey", valid_564241
  var valid_564242 = query.getOrDefault("certificate.nonce")
  valid_564242 = validateParameter(valid_564242, JString, required = false,
                                 default = nil)
  if valid_564242 != nil:
    section.add "certificate.nonce", valid_564242
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the certificate. This is required to update an existing certificate, and ignored while creating a brand new certificate.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564243 = header.getOrDefault("If-Match")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "If-Match", valid_564243
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564244: Call_DpsCertificateGenerateVerificationCode_564227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate verification code for Proof of Possession.
  ## 
  let valid = call_564244.validator(path, query, header, formData, body)
  let scheme = call_564244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564244.url(scheme.get, call_564244.host, call_564244.base,
                         call_564244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564244, url, valid)

var dpsCertificateGenerateVerificationCode* = Call_DpsCertificateGenerateVerificationCode_564227(
    name: "dpsCertificateGenerateVerificationCode", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}/generateVerificationCode",
    validator: validate_DpsCertificateGenerateVerificationCode_564228, base: "",
    url: url_DpsCertificateGenerateVerificationCode_564229,
    schemes: {Scheme.Https})
type
  Call_DpsCertificateVerifyCertificate_564248 = ref object of OpenApiRestCall_563555
proc url_DpsCertificateVerifyCertificate_564250(protocol: Scheme; host: string;
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

proc validate_DpsCertificateVerifyCertificate_564249(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verifies certificate for the provisioning service.
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
  var valid_564251 = path.getOrDefault("subscriptionId")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "subscriptionId", valid_564251
  var valid_564252 = path.getOrDefault("resourceGroupName")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "resourceGroupName", valid_564252
  var valid_564253 = path.getOrDefault("provisioningServiceName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "provisioningServiceName", valid_564253
  var valid_564254 = path.getOrDefault("certificateName")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "certificateName", valid_564254
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
  var valid_564255 = query.getOrDefault("certificate.purpose")
  valid_564255 = validateParameter(valid_564255, JString, required = false,
                                 default = newJString("clientAuthentication"))
  if valid_564255 != nil:
    section.add "certificate.purpose", valid_564255
  var valid_564256 = query.getOrDefault("certificate.lastUpdated")
  valid_564256 = validateParameter(valid_564256, JString, required = false,
                                 default = nil)
  if valid_564256 != nil:
    section.add "certificate.lastUpdated", valid_564256
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564257 = query.getOrDefault("api-version")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "api-version", valid_564257
  var valid_564258 = query.getOrDefault("certificate.created")
  valid_564258 = validateParameter(valid_564258, JString, required = false,
                                 default = nil)
  if valid_564258 != nil:
    section.add "certificate.created", valid_564258
  var valid_564259 = query.getOrDefault("certificate.isVerified")
  valid_564259 = validateParameter(valid_564259, JBool, required = false, default = nil)
  if valid_564259 != nil:
    section.add "certificate.isVerified", valid_564259
  var valid_564260 = query.getOrDefault("certificate.name")
  valid_564260 = validateParameter(valid_564260, JString, required = false,
                                 default = nil)
  if valid_564260 != nil:
    section.add "certificate.name", valid_564260
  var valid_564261 = query.getOrDefault("certificate.rawBytes")
  valid_564261 = validateParameter(valid_564261, JString, required = false,
                                 default = nil)
  if valid_564261 != nil:
    section.add "certificate.rawBytes", valid_564261
  var valid_564262 = query.getOrDefault("certificate.hasPrivateKey")
  valid_564262 = validateParameter(valid_564262, JBool, required = false, default = nil)
  if valid_564262 != nil:
    section.add "certificate.hasPrivateKey", valid_564262
  var valid_564263 = query.getOrDefault("certificate.nonce")
  valid_564263 = validateParameter(valid_564263, JString, required = false,
                                 default = nil)
  if valid_564263 != nil:
    section.add "certificate.nonce", valid_564263
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the certificate.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564264 = header.getOrDefault("If-Match")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "If-Match", valid_564264
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564266: Call_DpsCertificateVerifyCertificate_564248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies certificate for the provisioning service.
  ## 
  let valid = call_564266.validator(path, query, header, formData, body)
  let scheme = call_564266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564266.url(scheme.get, call_564266.host, call_564266.base,
                         call_564266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564266, url, valid)

var dpsCertificateVerifyCertificate* = Call_DpsCertificateVerifyCertificate_564248(
    name: "dpsCertificateVerifyCertificate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}/verify",
    validator: validate_DpsCertificateVerifyCertificate_564249, base: "",
    url: url_DpsCertificateVerifyCertificate_564250, schemes: {Scheme.Https})
type
  Call_IotDpsResourceGetKeysForKeyName_564271 = ref object of OpenApiRestCall_563555
proc url_IotDpsResourceGetKeysForKeyName_564273(protocol: Scheme; host: string;
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

proc validate_IotDpsResourceGetKeysForKeyName_564272(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a shared access policy by name from a provisioning service.
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
  var valid_564274 = path.getOrDefault("keyName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "keyName", valid_564274
  var valid_564275 = path.getOrDefault("subscriptionId")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "subscriptionId", valid_564275
  var valid_564276 = path.getOrDefault("resourceGroupName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "resourceGroupName", valid_564276
  var valid_564277 = path.getOrDefault("provisioningServiceName")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "provisioningServiceName", valid_564277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564278 = query.getOrDefault("api-version")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "api-version", valid_564278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564279: Call_IotDpsResourceGetKeysForKeyName_564271;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a shared access policy by name from a provisioning service.
  ## 
  let valid = call_564279.validator(path, query, header, formData, body)
  let scheme = call_564279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564279.url(scheme.get, call_564279.host, call_564279.base,
                         call_564279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564279, url, valid)

proc call*(call_564280: Call_IotDpsResourceGetKeysForKeyName_564271;
          apiVersion: string; keyName: string; subscriptionId: string;
          resourceGroupName: string; provisioningServiceName: string): Recallable =
  ## iotDpsResourceGetKeysForKeyName
  ## Get a shared access policy by name from a provisioning service.
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
  var path_564281 = newJObject()
  var query_564282 = newJObject()
  add(query_564282, "api-version", newJString(apiVersion))
  add(path_564281, "keyName", newJString(keyName))
  add(path_564281, "subscriptionId", newJString(subscriptionId))
  add(path_564281, "resourceGroupName", newJString(resourceGroupName))
  add(path_564281, "provisioningServiceName", newJString(provisioningServiceName))
  result = call_564280.call(path_564281, query_564282, nil, nil, nil)

var iotDpsResourceGetKeysForKeyName* = Call_IotDpsResourceGetKeysForKeyName_564271(
    name: "iotDpsResourceGetKeysForKeyName", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/keys/{keyName}/listkeys",
    validator: validate_IotDpsResourceGetKeysForKeyName_564272, base: "",
    url: url_IotDpsResourceGetKeysForKeyName_564273, schemes: {Scheme.Https})
type
  Call_IotDpsResourceListKeys_564283 = ref object of OpenApiRestCall_563555
proc url_IotDpsResourceListKeys_564285(protocol: Scheme; host: string; base: string;
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

proc validate_IotDpsResourceListKeys_564284(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the security metadata for a provisioning service.
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
  var valid_564286 = path.getOrDefault("subscriptionId")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "subscriptionId", valid_564286
  var valid_564287 = path.getOrDefault("resourceGroupName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "resourceGroupName", valid_564287
  var valid_564288 = path.getOrDefault("provisioningServiceName")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "provisioningServiceName", valid_564288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
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

proc call*(call_564290: Call_IotDpsResourceListKeys_564283; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the security metadata for a provisioning service.
  ## 
  let valid = call_564290.validator(path, query, header, formData, body)
  let scheme = call_564290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564290.url(scheme.get, call_564290.host, call_564290.base,
                         call_564290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564290, url, valid)

proc call*(call_564291: Call_IotDpsResourceListKeys_564283; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          provisioningServiceName: string): Recallable =
  ## iotDpsResourceListKeys
  ## Get the security metadata for a provisioning service.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : resource group name
  ##   provisioningServiceName: string (required)
  ##                          : The provisioning service name to get the shared access keys for.
  var path_564292 = newJObject()
  var query_564293 = newJObject()
  add(query_564293, "api-version", newJString(apiVersion))
  add(path_564292, "subscriptionId", newJString(subscriptionId))
  add(path_564292, "resourceGroupName", newJString(resourceGroupName))
  add(path_564292, "provisioningServiceName", newJString(provisioningServiceName))
  result = call_564291.call(path_564292, query_564293, nil, nil, nil)

var iotDpsResourceListKeys* = Call_IotDpsResourceListKeys_564283(
    name: "iotDpsResourceListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/listkeys",
    validator: validate_IotDpsResourceListKeys_564284, base: "",
    url: url_IotDpsResourceListKeys_564285, schemes: {Scheme.Https})
type
  Call_IotDpsResourceGetOperationResult_564294 = ref object of OpenApiRestCall_563555
proc url_IotDpsResourceGetOperationResult_564296(protocol: Scheme; host: string;
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

proc validate_IotDpsResourceGetOperationResult_564295(path: JsonNode;
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
  var valid_564297 = path.getOrDefault("operationId")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "operationId", valid_564297
  var valid_564298 = path.getOrDefault("subscriptionId")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "subscriptionId", valid_564298
  var valid_564299 = path.getOrDefault("resourceGroupName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "resourceGroupName", valid_564299
  var valid_564300 = path.getOrDefault("provisioningServiceName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "provisioningServiceName", valid_564300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  ##   asyncinfo: JString (required)
  ##            : Async header used to poll on the status of the operation, obtained while creating the long running operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564301 = query.getOrDefault("api-version")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "api-version", valid_564301
  var valid_564302 = query.getOrDefault("asyncinfo")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = newJString("true"))
  if valid_564302 != nil:
    section.add "asyncinfo", valid_564302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564303: Call_IotDpsResourceGetOperationResult_564294;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a long running operation, such as create, update or delete a provisioning service.
  ## 
  let valid = call_564303.validator(path, query, header, formData, body)
  let scheme = call_564303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564303.url(scheme.get, call_564303.host, call_564303.base,
                         call_564303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564303, url, valid)

proc call*(call_564304: Call_IotDpsResourceGetOperationResult_564294;
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
  var path_564305 = newJObject()
  var query_564306 = newJObject()
  add(query_564306, "api-version", newJString(apiVersion))
  add(path_564305, "operationId", newJString(operationId))
  add(path_564305, "subscriptionId", newJString(subscriptionId))
  add(path_564305, "resourceGroupName", newJString(resourceGroupName))
  add(path_564305, "provisioningServiceName", newJString(provisioningServiceName))
  add(query_564306, "asyncinfo", newJString(asyncinfo))
  result = call_564304.call(path_564305, query_564306, nil, nil, nil)

var iotDpsResourceGetOperationResult* = Call_IotDpsResourceGetOperationResult_564294(
    name: "iotDpsResourceGetOperationResult", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/operationresults/{operationId}",
    validator: validate_IotDpsResourceGetOperationResult_564295, base: "",
    url: url_IotDpsResourceGetOperationResult_564296, schemes: {Scheme.Https})
type
  Call_IotDpsResourceListValidSkus_564307 = ref object of OpenApiRestCall_563555
proc url_IotDpsResourceListValidSkus_564309(protocol: Scheme; host: string;
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

proc validate_IotDpsResourceListValidSkus_564308(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of valid SKUs for a provisioning service.
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
  var valid_564310 = path.getOrDefault("subscriptionId")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "subscriptionId", valid_564310
  var valid_564311 = path.getOrDefault("resourceGroupName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "resourceGroupName", valid_564311
  var valid_564312 = path.getOrDefault("provisioningServiceName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "provisioningServiceName", valid_564312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564313 = query.getOrDefault("api-version")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "api-version", valid_564313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564314: Call_IotDpsResourceListValidSkus_564307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of valid SKUs for a provisioning service.
  ## 
  let valid = call_564314.validator(path, query, header, formData, body)
  let scheme = call_564314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564314.url(scheme.get, call_564314.host, call_564314.base,
                         call_564314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564314, url, valid)

proc call*(call_564315: Call_IotDpsResourceListValidSkus_564307;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          provisioningServiceName: string): Recallable =
  ## iotDpsResourceListValidSkus
  ## Get the list of valid SKUs for a provisioning service.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Name of resource group.
  ##   provisioningServiceName: string (required)
  ##                          : Name of provisioning service.
  var path_564316 = newJObject()
  var query_564317 = newJObject()
  add(query_564317, "api-version", newJString(apiVersion))
  add(path_564316, "subscriptionId", newJString(subscriptionId))
  add(path_564316, "resourceGroupName", newJString(resourceGroupName))
  add(path_564316, "provisioningServiceName", newJString(provisioningServiceName))
  result = call_564315.call(path_564316, query_564317, nil, nil, nil)

var iotDpsResourceListValidSkus* = Call_IotDpsResourceListValidSkus_564307(
    name: "iotDpsResourceListValidSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/skus",
    validator: validate_IotDpsResourceListValidSkus_564308, base: "",
    url: url_IotDpsResourceListValidSkus_564309, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
