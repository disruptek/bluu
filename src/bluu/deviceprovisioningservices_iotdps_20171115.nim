
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  macServiceName = "deviceprovisioningservices-iotdps"
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
  var valid_568040 = query.getOrDefault("api-version")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "api-version", valid_568040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568063: Call_OperationsList_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.Devices REST API operations.
  ## 
  let valid = call_568063.validator(path, query, header, formData, body)
  let scheme = call_568063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568063.url(scheme.get, call_568063.host, call_568063.base,
                         call_568063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568063, url, valid)

proc call*(call_568134: Call_OperationsList_567879; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Microsoft.Devices REST API operations.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  var query_568135 = newJObject()
  add(query_568135, "api-version", newJString(apiVersion))
  result = call_568134.call(nil, query_568135, nil, nil, nil)

var operationsList* = Call_OperationsList_567879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Devices/operations",
    validator: validate_OperationsList_567880, base: "", url: url_OperationsList_567881,
    schemes: {Scheme.Https})
type
  Call_IotDpsResourceCheckProvisioningServiceNameAvailability_568175 = ref object of OpenApiRestCall_567657
proc url_IotDpsResourceCheckProvisioningServiceNameAvailability_568177(
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

proc validate_IotDpsResourceCheckProvisioningServiceNameAvailability_568176(
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
  var valid_568192 = path.getOrDefault("subscriptionId")
  valid_568192 = validateParameter(valid_568192, JString, required = true,
                                 default = nil)
  if valid_568192 != nil:
    section.add "subscriptionId", valid_568192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568193 = query.getOrDefault("api-version")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "api-version", valid_568193
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

proc call*(call_568195: Call_IotDpsResourceCheckProvisioningServiceNameAvailability_568175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check if a provisioning service name is available. This will validate if the name is syntactically valid and if the name is usable
  ## 
  let valid = call_568195.validator(path, query, header, formData, body)
  let scheme = call_568195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568195.url(scheme.get, call_568195.host, call_568195.base,
                         call_568195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568195, url, valid)

proc call*(call_568196: Call_IotDpsResourceCheckProvisioningServiceNameAvailability_568175;
          apiVersion: string; subscriptionId: string; arguments: JsonNode): Recallable =
  ## iotDpsResourceCheckProvisioningServiceNameAvailability
  ## Check if a provisioning service name is available. This will validate if the name is syntactically valid and if the name is usable
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   arguments: JObject (required)
  ##            : Set the name parameter in the OperationInputs structure to the name of the provisioning service to check.
  var path_568197 = newJObject()
  var query_568198 = newJObject()
  var body_568199 = newJObject()
  add(query_568198, "api-version", newJString(apiVersion))
  add(path_568197, "subscriptionId", newJString(subscriptionId))
  if arguments != nil:
    body_568199 = arguments
  result = call_568196.call(path_568197, query_568198, nil, nil, body_568199)

var iotDpsResourceCheckProvisioningServiceNameAvailability* = Call_IotDpsResourceCheckProvisioningServiceNameAvailability_568175(
    name: "iotDpsResourceCheckProvisioningServiceNameAvailability",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Devices/checkProvisioningServiceNameAvailability",
    validator: validate_IotDpsResourceCheckProvisioningServiceNameAvailability_568176,
    base: "", url: url_IotDpsResourceCheckProvisioningServiceNameAvailability_568177,
    schemes: {Scheme.Https})
type
  Call_IotDpsResourceListBySubscription_568200 = ref object of OpenApiRestCall_567657
proc url_IotDpsResourceListBySubscription_568202(protocol: Scheme; host: string;
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

proc validate_IotDpsResourceListBySubscription_568201(path: JsonNode;
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
  var valid_568203 = path.getOrDefault("subscriptionId")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "subscriptionId", valid_568203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568204 = query.getOrDefault("api-version")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "api-version", valid_568204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568205: Call_IotDpsResourceListBySubscription_568200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the provisioning services for a given subscription id.
  ## 
  let valid = call_568205.validator(path, query, header, formData, body)
  let scheme = call_568205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568205.url(scheme.get, call_568205.host, call_568205.base,
                         call_568205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568205, url, valid)

proc call*(call_568206: Call_IotDpsResourceListBySubscription_568200;
          apiVersion: string; subscriptionId: string): Recallable =
  ## iotDpsResourceListBySubscription
  ## List all the provisioning services for a given subscription id.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568207 = newJObject()
  var query_568208 = newJObject()
  add(query_568208, "api-version", newJString(apiVersion))
  add(path_568207, "subscriptionId", newJString(subscriptionId))
  result = call_568206.call(path_568207, query_568208, nil, nil, nil)

var iotDpsResourceListBySubscription* = Call_IotDpsResourceListBySubscription_568200(
    name: "iotDpsResourceListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Devices/provisioningServices",
    validator: validate_IotDpsResourceListBySubscription_568201, base: "",
    url: url_IotDpsResourceListBySubscription_568202, schemes: {Scheme.Https})
type
  Call_IotDpsResourceListByResourceGroup_568209 = ref object of OpenApiRestCall_567657
proc url_IotDpsResourceListByResourceGroup_568211(protocol: Scheme; host: string;
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

proc validate_IotDpsResourceListByResourceGroup_568210(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of all provisioning services in the given resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568212 = path.getOrDefault("resourceGroupName")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "resourceGroupName", valid_568212
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "api-version", valid_568214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568215: Call_IotDpsResourceListByResourceGroup_568209;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a list of all provisioning services in the given resource group.
  ## 
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_IotDpsResourceListByResourceGroup_568209;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## iotDpsResourceListByResourceGroup
  ## Get a list of all provisioning services in the given resource group.
  ##   resourceGroupName: string (required)
  ##                    : Resource group identifier.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568217 = newJObject()
  var query_568218 = newJObject()
  add(path_568217, "resourceGroupName", newJString(resourceGroupName))
  add(query_568218, "api-version", newJString(apiVersion))
  add(path_568217, "subscriptionId", newJString(subscriptionId))
  result = call_568216.call(path_568217, query_568218, nil, nil, nil)

var iotDpsResourceListByResourceGroup* = Call_IotDpsResourceListByResourceGroup_568209(
    name: "iotDpsResourceListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices",
    validator: validate_IotDpsResourceListByResourceGroup_568210, base: "",
    url: url_IotDpsResourceListByResourceGroup_568211, schemes: {Scheme.Https})
type
  Call_IotDpsResourceCreateOrUpdate_568230 = ref object of OpenApiRestCall_567657
proc url_IotDpsResourceCreateOrUpdate_568232(protocol: Scheme; host: string;
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

proc validate_IotDpsResourceCreateOrUpdate_568231(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update the metadata of the provisioning service. The usual pattern to modify a property is to retrieve the provisioning service metadata and security metadata, and then combine them with the modified values in a new body to update the provisioning service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of provisioning service to create or update.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568233 = path.getOrDefault("resourceGroupName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "resourceGroupName", valid_568233
  var valid_568234 = path.getOrDefault("provisioningServiceName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "provisioningServiceName", valid_568234
  var valid_568235 = path.getOrDefault("subscriptionId")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "subscriptionId", valid_568235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568236 = query.getOrDefault("api-version")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "api-version", valid_568236
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

proc call*(call_568238: Call_IotDpsResourceCreateOrUpdate_568230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the metadata of the provisioning service. The usual pattern to modify a property is to retrieve the provisioning service metadata and security metadata, and then combine them with the modified values in a new body to update the provisioning service.
  ## 
  let valid = call_568238.validator(path, query, header, formData, body)
  let scheme = call_568238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568238.url(scheme.get, call_568238.host, call_568238.base,
                         call_568238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568238, url, valid)

proc call*(call_568239: Call_IotDpsResourceCreateOrUpdate_568230;
          resourceGroupName: string; apiVersion: string;
          provisioningServiceName: string; subscriptionId: string;
          iotDpsDescription: JsonNode): Recallable =
  ## iotDpsResourceCreateOrUpdate
  ## Create or update the metadata of the provisioning service. The usual pattern to modify a property is to retrieve the provisioning service metadata and security metadata, and then combine them with the modified values in a new body to update the provisioning service.
  ##   resourceGroupName: string (required)
  ##                    : Resource group identifier.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   provisioningServiceName: string (required)
  ##                          : Name of provisioning service to create or update.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   iotDpsDescription: JObject (required)
  ##                    : Description of the provisioning service to create or update.
  var path_568240 = newJObject()
  var query_568241 = newJObject()
  var body_568242 = newJObject()
  add(path_568240, "resourceGroupName", newJString(resourceGroupName))
  add(query_568241, "api-version", newJString(apiVersion))
  add(path_568240, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_568240, "subscriptionId", newJString(subscriptionId))
  if iotDpsDescription != nil:
    body_568242 = iotDpsDescription
  result = call_568239.call(path_568240, query_568241, nil, nil, body_568242)

var iotDpsResourceCreateOrUpdate* = Call_IotDpsResourceCreateOrUpdate_568230(
    name: "iotDpsResourceCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}",
    validator: validate_IotDpsResourceCreateOrUpdate_568231, base: "",
    url: url_IotDpsResourceCreateOrUpdate_568232, schemes: {Scheme.Https})
type
  Call_IotDpsResourceGet_568219 = ref object of OpenApiRestCall_567657
proc url_IotDpsResourceGet_568221(protocol: Scheme; host: string; base: string;
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

proc validate_IotDpsResourceGet_568220(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get the metadata of the provisioning service without SAS keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of the provisioning service to retrieve.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568222 = path.getOrDefault("resourceGroupName")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "resourceGroupName", valid_568222
  var valid_568223 = path.getOrDefault("provisioningServiceName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "provisioningServiceName", valid_568223
  var valid_568224 = path.getOrDefault("subscriptionId")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "subscriptionId", valid_568224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568225 = query.getOrDefault("api-version")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "api-version", valid_568225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568226: Call_IotDpsResourceGet_568219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the metadata of the provisioning service without SAS keys.
  ## 
  let valid = call_568226.validator(path, query, header, formData, body)
  let scheme = call_568226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568226.url(scheme.get, call_568226.host, call_568226.base,
                         call_568226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568226, url, valid)

proc call*(call_568227: Call_IotDpsResourceGet_568219; resourceGroupName: string;
          apiVersion: string; provisioningServiceName: string;
          subscriptionId: string): Recallable =
  ## iotDpsResourceGet
  ## Get the metadata of the provisioning service without SAS keys.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   provisioningServiceName: string (required)
  ##                          : Name of the provisioning service to retrieve.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568228 = newJObject()
  var query_568229 = newJObject()
  add(path_568228, "resourceGroupName", newJString(resourceGroupName))
  add(query_568229, "api-version", newJString(apiVersion))
  add(path_568228, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_568228, "subscriptionId", newJString(subscriptionId))
  result = call_568227.call(path_568228, query_568229, nil, nil, nil)

var iotDpsResourceGet* = Call_IotDpsResourceGet_568219(name: "iotDpsResourceGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}",
    validator: validate_IotDpsResourceGet_568220, base: "",
    url: url_IotDpsResourceGet_568221, schemes: {Scheme.Https})
type
  Call_IotDpsResourceUpdate_568254 = ref object of OpenApiRestCall_567657
proc url_IotDpsResourceUpdate_568256(protocol: Scheme; host: string; base: string;
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

proc validate_IotDpsResourceUpdate_568255(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing provisioning service's tags. to update other fields use the CreateOrUpdate method
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of provisioning service to create or update.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568274 = path.getOrDefault("resourceGroupName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "resourceGroupName", valid_568274
  var valid_568275 = path.getOrDefault("provisioningServiceName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "provisioningServiceName", valid_568275
  var valid_568276 = path.getOrDefault("subscriptionId")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "subscriptionId", valid_568276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568277 = query.getOrDefault("api-version")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "api-version", valid_568277
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

proc call*(call_568279: Call_IotDpsResourceUpdate_568254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing provisioning service's tags. to update other fields use the CreateOrUpdate method
  ## 
  let valid = call_568279.validator(path, query, header, formData, body)
  let scheme = call_568279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568279.url(scheme.get, call_568279.host, call_568279.base,
                         call_568279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568279, url, valid)

proc call*(call_568280: Call_IotDpsResourceUpdate_568254;
          resourceGroupName: string; apiVersion: string;
          provisioningServiceName: string; ProvisioningServiceTags: JsonNode;
          subscriptionId: string): Recallable =
  ## iotDpsResourceUpdate
  ## Update an existing provisioning service's tags. to update other fields use the CreateOrUpdate method
  ##   resourceGroupName: string (required)
  ##                    : Resource group identifier.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   provisioningServiceName: string (required)
  ##                          : Name of provisioning service to create or update.
  ##   ProvisioningServiceTags: JObject (required)
  ##                          : Updated tag information to set into the provisioning service instance.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568281 = newJObject()
  var query_568282 = newJObject()
  var body_568283 = newJObject()
  add(path_568281, "resourceGroupName", newJString(resourceGroupName))
  add(query_568282, "api-version", newJString(apiVersion))
  add(path_568281, "provisioningServiceName", newJString(provisioningServiceName))
  if ProvisioningServiceTags != nil:
    body_568283 = ProvisioningServiceTags
  add(path_568281, "subscriptionId", newJString(subscriptionId))
  result = call_568280.call(path_568281, query_568282, nil, nil, body_568283)

var iotDpsResourceUpdate* = Call_IotDpsResourceUpdate_568254(
    name: "iotDpsResourceUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}",
    validator: validate_IotDpsResourceUpdate_568255, base: "",
    url: url_IotDpsResourceUpdate_568256, schemes: {Scheme.Https})
type
  Call_IotDpsResourceDelete_568243 = ref object of OpenApiRestCall_567657
proc url_IotDpsResourceDelete_568245(protocol: Scheme; host: string; base: string;
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

proc validate_IotDpsResourceDelete_568244(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the Provisioning Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of provisioning service to delete.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568246 = path.getOrDefault("resourceGroupName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "resourceGroupName", valid_568246
  var valid_568247 = path.getOrDefault("provisioningServiceName")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "provisioningServiceName", valid_568247
  var valid_568248 = path.getOrDefault("subscriptionId")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "subscriptionId", valid_568248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568249 = query.getOrDefault("api-version")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "api-version", valid_568249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568250: Call_IotDpsResourceDelete_568243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the Provisioning Service.
  ## 
  let valid = call_568250.validator(path, query, header, formData, body)
  let scheme = call_568250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568250.url(scheme.get, call_568250.host, call_568250.base,
                         call_568250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568250, url, valid)

proc call*(call_568251: Call_IotDpsResourceDelete_568243;
          resourceGroupName: string; apiVersion: string;
          provisioningServiceName: string; subscriptionId: string): Recallable =
  ## iotDpsResourceDelete
  ## Deletes the Provisioning Service.
  ##   resourceGroupName: string (required)
  ##                    : Resource group identifier.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   provisioningServiceName: string (required)
  ##                          : Name of provisioning service to delete.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568252 = newJObject()
  var query_568253 = newJObject()
  add(path_568252, "resourceGroupName", newJString(resourceGroupName))
  add(query_568253, "api-version", newJString(apiVersion))
  add(path_568252, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_568252, "subscriptionId", newJString(subscriptionId))
  result = call_568251.call(path_568252, query_568253, nil, nil, nil)

var iotDpsResourceDelete* = Call_IotDpsResourceDelete_568243(
    name: "iotDpsResourceDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}",
    validator: validate_IotDpsResourceDelete_568244, base: "",
    url: url_IotDpsResourceDelete_568245, schemes: {Scheme.Https})
type
  Call_DpsCertificateList_568284 = ref object of OpenApiRestCall_567657
proc url_DpsCertificateList_568286(protocol: Scheme; host: string; base: string;
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

proc validate_DpsCertificateList_568285(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get all the certificates tied to the provisioning service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of resource group.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of provisioning service to retrieve certificates for.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568287 = path.getOrDefault("resourceGroupName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "resourceGroupName", valid_568287
  var valid_568288 = path.getOrDefault("provisioningServiceName")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "provisioningServiceName", valid_568288
  var valid_568289 = path.getOrDefault("subscriptionId")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "subscriptionId", valid_568289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568290 = query.getOrDefault("api-version")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "api-version", valid_568290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568291: Call_DpsCertificateList_568284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the certificates tied to the provisioning service.
  ## 
  let valid = call_568291.validator(path, query, header, formData, body)
  let scheme = call_568291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568291.url(scheme.get, call_568291.host, call_568291.base,
                         call_568291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568291, url, valid)

proc call*(call_568292: Call_DpsCertificateList_568284; resourceGroupName: string;
          apiVersion: string; provisioningServiceName: string;
          subscriptionId: string): Recallable =
  ## dpsCertificateList
  ## Get all the certificates tied to the provisioning service.
  ##   resourceGroupName: string (required)
  ##                    : Name of resource group.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   provisioningServiceName: string (required)
  ##                          : Name of provisioning service to retrieve certificates for.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568293 = newJObject()
  var query_568294 = newJObject()
  add(path_568293, "resourceGroupName", newJString(resourceGroupName))
  add(query_568294, "api-version", newJString(apiVersion))
  add(path_568293, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_568293, "subscriptionId", newJString(subscriptionId))
  result = call_568292.call(path_568293, query_568294, nil, nil, nil)

var dpsCertificateList* = Call_DpsCertificateList_568284(
    name: "dpsCertificateList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates",
    validator: validate_DpsCertificateList_568285, base: "",
    url: url_DpsCertificateList_568286, schemes: {Scheme.Https})
type
  Call_DpsCertificateCreateOrUpdate_568308 = ref object of OpenApiRestCall_567657
proc url_DpsCertificateCreateOrUpdate_568310(protocol: Scheme; host: string;
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

proc validate_DpsCertificateCreateOrUpdate_568309(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add new certificate or update an existing certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: JString (required)
  ##                          : The name of the provisioning service.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   certificateName: JString (required)
  ##                  : The name of the certificate create or update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568311 = path.getOrDefault("resourceGroupName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "resourceGroupName", valid_568311
  var valid_568312 = path.getOrDefault("provisioningServiceName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "provisioningServiceName", valid_568312
  var valid_568313 = path.getOrDefault("subscriptionId")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "subscriptionId", valid_568313
  var valid_568314 = path.getOrDefault("certificateName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "certificateName", valid_568314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568315 = query.getOrDefault("api-version")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "api-version", valid_568315
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the certificate. This is required to update an existing certificate, and ignored while creating a brand new certificate.
  section = newJObject()
  var valid_568316 = header.getOrDefault("If-Match")
  valid_568316 = validateParameter(valid_568316, JString, required = false,
                                 default = nil)
  if valid_568316 != nil:
    section.add "If-Match", valid_568316
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

proc call*(call_568318: Call_DpsCertificateCreateOrUpdate_568308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add new certificate or update an existing certificate.
  ## 
  let valid = call_568318.validator(path, query, header, formData, body)
  let scheme = call_568318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568318.url(scheme.get, call_568318.host, call_568318.base,
                         call_568318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568318, url, valid)

proc call*(call_568319: Call_DpsCertificateCreateOrUpdate_568308;
          resourceGroupName: string; apiVersion: string;
          provisioningServiceName: string; subscriptionId: string;
          certificateName: string; certificateDescription: JsonNode): Recallable =
  ## dpsCertificateCreateOrUpdate
  ## Add new certificate or update an existing certificate.
  ##   resourceGroupName: string (required)
  ##                    : Resource group identifier.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   provisioningServiceName: string (required)
  ##                          : The name of the provisioning service.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   certificateName: string (required)
  ##                  : The name of the certificate create or update.
  ##   certificateDescription: JObject (required)
  ##                         : The certificate body.
  var path_568320 = newJObject()
  var query_568321 = newJObject()
  var body_568322 = newJObject()
  add(path_568320, "resourceGroupName", newJString(resourceGroupName))
  add(query_568321, "api-version", newJString(apiVersion))
  add(path_568320, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_568320, "subscriptionId", newJString(subscriptionId))
  add(path_568320, "certificateName", newJString(certificateName))
  if certificateDescription != nil:
    body_568322 = certificateDescription
  result = call_568319.call(path_568320, query_568321, nil, nil, body_568322)

var dpsCertificateCreateOrUpdate* = Call_DpsCertificateCreateOrUpdate_568308(
    name: "dpsCertificateCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}",
    validator: validate_DpsCertificateCreateOrUpdate_568309, base: "",
    url: url_DpsCertificateCreateOrUpdate_568310, schemes: {Scheme.Https})
type
  Call_DpsCertificateGet_568295 = ref object of OpenApiRestCall_567657
proc url_DpsCertificateGet_568297(protocol: Scheme; host: string; base: string;
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

proc validate_DpsCertificateGet_568296(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get the certificate from the provisioning service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of the provisioning service the certificate is associated with.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   certificateName: JString (required)
  ##                  : Name of the certificate to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568298 = path.getOrDefault("resourceGroupName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "resourceGroupName", valid_568298
  var valid_568299 = path.getOrDefault("provisioningServiceName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "provisioningServiceName", valid_568299
  var valid_568300 = path.getOrDefault("subscriptionId")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "subscriptionId", valid_568300
  var valid_568301 = path.getOrDefault("certificateName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "certificateName", valid_568301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568302 = query.getOrDefault("api-version")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "api-version", valid_568302
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the certificate.
  section = newJObject()
  var valid_568303 = header.getOrDefault("If-Match")
  valid_568303 = validateParameter(valid_568303, JString, required = false,
                                 default = nil)
  if valid_568303 != nil:
    section.add "If-Match", valid_568303
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568304: Call_DpsCertificateGet_568295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the certificate from the provisioning service.
  ## 
  let valid = call_568304.validator(path, query, header, formData, body)
  let scheme = call_568304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568304.url(scheme.get, call_568304.host, call_568304.base,
                         call_568304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568304, url, valid)

proc call*(call_568305: Call_DpsCertificateGet_568295; resourceGroupName: string;
          apiVersion: string; provisioningServiceName: string;
          subscriptionId: string; certificateName: string): Recallable =
  ## dpsCertificateGet
  ## Get the certificate from the provisioning service.
  ##   resourceGroupName: string (required)
  ##                    : Resource group identifier.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   provisioningServiceName: string (required)
  ##                          : Name of the provisioning service the certificate is associated with.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   certificateName: string (required)
  ##                  : Name of the certificate to retrieve.
  var path_568306 = newJObject()
  var query_568307 = newJObject()
  add(path_568306, "resourceGroupName", newJString(resourceGroupName))
  add(query_568307, "api-version", newJString(apiVersion))
  add(path_568306, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_568306, "subscriptionId", newJString(subscriptionId))
  add(path_568306, "certificateName", newJString(certificateName))
  result = call_568305.call(path_568306, query_568307, nil, nil, nil)

var dpsCertificateGet* = Call_DpsCertificateGet_568295(name: "dpsCertificateGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}",
    validator: validate_DpsCertificateGet_568296, base: "",
    url: url_DpsCertificateGet_568297, schemes: {Scheme.Https})
type
  Call_DpsCertificateDelete_568323 = ref object of OpenApiRestCall_567657
proc url_DpsCertificateDelete_568325(protocol: Scheme; host: string; base: string;
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

proc validate_DpsCertificateDelete_568324(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified certificate associated with the Provisioning Service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: JString (required)
  ##                          : The name of the provisioning service.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   certificateName: JString (required)
  ##                  : This is a mandatory field, and is the logical name of the certificate that the provisioning service will access by.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568326 = path.getOrDefault("resourceGroupName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "resourceGroupName", valid_568326
  var valid_568327 = path.getOrDefault("provisioningServiceName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "provisioningServiceName", valid_568327
  var valid_568328 = path.getOrDefault("subscriptionId")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "subscriptionId", valid_568328
  var valid_568329 = path.getOrDefault("certificateName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "certificateName", valid_568329
  result.add "path", section
  ## parameters in `query` object:
  ##   certificate.hasPrivateKey: JBool
  ##                            : Indicates if the certificate contains a private key.
  ##   api-version: JString (required)
  ##              : The version of the API.
  ##   certificate.name: JString
  ##                   : This is optional, and it is the Common Name of the certificate.
  ##   certificate.lastUpdated: JString
  ##                          : Time the certificate is last updated.
  ##   certificate.created: JString
  ##                      : Time the certificate is created.
  ##   certificate.purpose: JString
  ##                      : A description that mentions the purpose of the certificate.
  ##   certificate.isVerified: JBool
  ##                         : Indicates if certificate has been verified by owner of the private key.
  ##   certificate.nonce: JString
  ##                    : Random number generated to indicate Proof of Possession.
  ##   certificate.rawBytes: JString
  ##                       : Raw data within the certificate.
  section = newJObject()
  var valid_568330 = query.getOrDefault("certificate.hasPrivateKey")
  valid_568330 = validateParameter(valid_568330, JBool, required = false, default = nil)
  if valid_568330 != nil:
    section.add "certificate.hasPrivateKey", valid_568330
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568331 = query.getOrDefault("api-version")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "api-version", valid_568331
  var valid_568332 = query.getOrDefault("certificate.name")
  valid_568332 = validateParameter(valid_568332, JString, required = false,
                                 default = nil)
  if valid_568332 != nil:
    section.add "certificate.name", valid_568332
  var valid_568333 = query.getOrDefault("certificate.lastUpdated")
  valid_568333 = validateParameter(valid_568333, JString, required = false,
                                 default = nil)
  if valid_568333 != nil:
    section.add "certificate.lastUpdated", valid_568333
  var valid_568334 = query.getOrDefault("certificate.created")
  valid_568334 = validateParameter(valid_568334, JString, required = false,
                                 default = nil)
  if valid_568334 != nil:
    section.add "certificate.created", valid_568334
  var valid_568348 = query.getOrDefault("certificate.purpose")
  valid_568348 = validateParameter(valid_568348, JString, required = false,
                                 default = newJString("clientAuthentication"))
  if valid_568348 != nil:
    section.add "certificate.purpose", valid_568348
  var valid_568349 = query.getOrDefault("certificate.isVerified")
  valid_568349 = validateParameter(valid_568349, JBool, required = false, default = nil)
  if valid_568349 != nil:
    section.add "certificate.isVerified", valid_568349
  var valid_568350 = query.getOrDefault("certificate.nonce")
  valid_568350 = validateParameter(valid_568350, JString, required = false,
                                 default = nil)
  if valid_568350 != nil:
    section.add "certificate.nonce", valid_568350
  var valid_568351 = query.getOrDefault("certificate.rawBytes")
  valid_568351 = validateParameter(valid_568351, JString, required = false,
                                 default = nil)
  if valid_568351 != nil:
    section.add "certificate.rawBytes", valid_568351
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the certificate
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_568352 = header.getOrDefault("If-Match")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "If-Match", valid_568352
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568353: Call_DpsCertificateDelete_568323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified certificate associated with the Provisioning Service
  ## 
  let valid = call_568353.validator(path, query, header, formData, body)
  let scheme = call_568353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568353.url(scheme.get, call_568353.host, call_568353.base,
                         call_568353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568353, url, valid)

var dpsCertificateDelete* = Call_DpsCertificateDelete_568323(
    name: "dpsCertificateDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}",
    validator: validate_DpsCertificateDelete_568324, base: "",
    url: url_DpsCertificateDelete_568325, schemes: {Scheme.Https})
type
  Call_DpsCertificateGenerateVerificationCode_568357 = ref object of OpenApiRestCall_567657
proc url_DpsCertificateGenerateVerificationCode_568359(protocol: Scheme;
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

proc validate_DpsCertificateGenerateVerificationCode_568358(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate verification code for Proof of Possession.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : name of resource group.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of provisioning service.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   certificateName: JString (required)
  ##                  : The mandatory logical name of the certificate, that the provisioning service uses to access.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568360 = path.getOrDefault("resourceGroupName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "resourceGroupName", valid_568360
  var valid_568361 = path.getOrDefault("provisioningServiceName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "provisioningServiceName", valid_568361
  var valid_568362 = path.getOrDefault("subscriptionId")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "subscriptionId", valid_568362
  var valid_568363 = path.getOrDefault("certificateName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "certificateName", valid_568363
  result.add "path", section
  ## parameters in `query` object:
  ##   certificate.hasPrivateKey: JBool
  ##                            : Indicates if the certificate contains private key.
  ##   api-version: JString (required)
  ##              : The version of the API.
  ##   certificate.name: JString
  ##                   : Common Name for the certificate.
  ##   certificate.lastUpdated: JString
  ##                          : Certificate last updated time.
  ##   certificate.created: JString
  ##                      : Certificate creation time.
  ##   certificate.purpose: JString
  ##                      : Description mentioning the purpose of the certificate.
  ##   certificate.isVerified: JBool
  ##                         : Indicates if the certificate has been verified by owner of the private key.
  ##   certificate.nonce: JString
  ##                    : Random number generated to indicate Proof of Possession.
  ##   certificate.rawBytes: JString
  ##                       : Raw data of certificate.
  section = newJObject()
  var valid_568364 = query.getOrDefault("certificate.hasPrivateKey")
  valid_568364 = validateParameter(valid_568364, JBool, required = false, default = nil)
  if valid_568364 != nil:
    section.add "certificate.hasPrivateKey", valid_568364
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568365 = query.getOrDefault("api-version")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "api-version", valid_568365
  var valid_568366 = query.getOrDefault("certificate.name")
  valid_568366 = validateParameter(valid_568366, JString, required = false,
                                 default = nil)
  if valid_568366 != nil:
    section.add "certificate.name", valid_568366
  var valid_568367 = query.getOrDefault("certificate.lastUpdated")
  valid_568367 = validateParameter(valid_568367, JString, required = false,
                                 default = nil)
  if valid_568367 != nil:
    section.add "certificate.lastUpdated", valid_568367
  var valid_568368 = query.getOrDefault("certificate.created")
  valid_568368 = validateParameter(valid_568368, JString, required = false,
                                 default = nil)
  if valid_568368 != nil:
    section.add "certificate.created", valid_568368
  var valid_568369 = query.getOrDefault("certificate.purpose")
  valid_568369 = validateParameter(valid_568369, JString, required = false,
                                 default = newJString("clientAuthentication"))
  if valid_568369 != nil:
    section.add "certificate.purpose", valid_568369
  var valid_568370 = query.getOrDefault("certificate.isVerified")
  valid_568370 = validateParameter(valid_568370, JBool, required = false, default = nil)
  if valid_568370 != nil:
    section.add "certificate.isVerified", valid_568370
  var valid_568371 = query.getOrDefault("certificate.nonce")
  valid_568371 = validateParameter(valid_568371, JString, required = false,
                                 default = nil)
  if valid_568371 != nil:
    section.add "certificate.nonce", valid_568371
  var valid_568372 = query.getOrDefault("certificate.rawBytes")
  valid_568372 = validateParameter(valid_568372, JString, required = false,
                                 default = nil)
  if valid_568372 != nil:
    section.add "certificate.rawBytes", valid_568372
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the certificate. This is required to update an existing certificate, and ignored while creating a brand new certificate.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_568373 = header.getOrDefault("If-Match")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "If-Match", valid_568373
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568374: Call_DpsCertificateGenerateVerificationCode_568357;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate verification code for Proof of Possession.
  ## 
  let valid = call_568374.validator(path, query, header, formData, body)
  let scheme = call_568374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568374.url(scheme.get, call_568374.host, call_568374.base,
                         call_568374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568374, url, valid)

var dpsCertificateGenerateVerificationCode* = Call_DpsCertificateGenerateVerificationCode_568357(
    name: "dpsCertificateGenerateVerificationCode", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}/generateVerificationCode",
    validator: validate_DpsCertificateGenerateVerificationCode_568358, base: "",
    url: url_DpsCertificateGenerateVerificationCode_568359,
    schemes: {Scheme.Https})
type
  Call_DpsCertificateVerifyCertificate_568378 = ref object of OpenApiRestCall_567657
proc url_DpsCertificateVerifyCertificate_568380(protocol: Scheme; host: string;
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

proc validate_DpsCertificateVerifyCertificate_568379(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verifies the certificate's private key possession by providing the leaf cert issued by the verifying pre uploaded certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   provisioningServiceName: JString (required)
  ##                          : Provisioning service name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   certificateName: JString (required)
  ##                  : The mandatory logical name of the certificate, that the provisioning service uses to access.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568381 = path.getOrDefault("resourceGroupName")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "resourceGroupName", valid_568381
  var valid_568382 = path.getOrDefault("provisioningServiceName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "provisioningServiceName", valid_568382
  var valid_568383 = path.getOrDefault("subscriptionId")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "subscriptionId", valid_568383
  var valid_568384 = path.getOrDefault("certificateName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "certificateName", valid_568384
  result.add "path", section
  ## parameters in `query` object:
  ##   certificate.hasPrivateKey: JBool
  ##                            : Indicates if the certificate contains private key.
  ##   api-version: JString (required)
  ##              : The version of the API.
  ##   certificate.name: JString
  ##                   : Common Name for the certificate.
  ##   certificate.lastUpdated: JString
  ##                          : Certificate last updated time.
  ##   certificate.created: JString
  ##                      : Certificate creation time.
  ##   certificate.purpose: JString
  ##                      : Describe the purpose of the certificate.
  ##   certificate.isVerified: JBool
  ##                         : Indicates if the certificate has been verified by owner of the private key.
  ##   certificate.nonce: JString
  ##                    : Random number generated to indicate Proof of Possession.
  ##   certificate.rawBytes: JString
  ##                       : Raw data of certificate.
  section = newJObject()
  var valid_568385 = query.getOrDefault("certificate.hasPrivateKey")
  valid_568385 = validateParameter(valid_568385, JBool, required = false, default = nil)
  if valid_568385 != nil:
    section.add "certificate.hasPrivateKey", valid_568385
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568386 = query.getOrDefault("api-version")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "api-version", valid_568386
  var valid_568387 = query.getOrDefault("certificate.name")
  valid_568387 = validateParameter(valid_568387, JString, required = false,
                                 default = nil)
  if valid_568387 != nil:
    section.add "certificate.name", valid_568387
  var valid_568388 = query.getOrDefault("certificate.lastUpdated")
  valid_568388 = validateParameter(valid_568388, JString, required = false,
                                 default = nil)
  if valid_568388 != nil:
    section.add "certificate.lastUpdated", valid_568388
  var valid_568389 = query.getOrDefault("certificate.created")
  valid_568389 = validateParameter(valid_568389, JString, required = false,
                                 default = nil)
  if valid_568389 != nil:
    section.add "certificate.created", valid_568389
  var valid_568390 = query.getOrDefault("certificate.purpose")
  valid_568390 = validateParameter(valid_568390, JString, required = false,
                                 default = newJString("clientAuthentication"))
  if valid_568390 != nil:
    section.add "certificate.purpose", valid_568390
  var valid_568391 = query.getOrDefault("certificate.isVerified")
  valid_568391 = validateParameter(valid_568391, JBool, required = false, default = nil)
  if valid_568391 != nil:
    section.add "certificate.isVerified", valid_568391
  var valid_568392 = query.getOrDefault("certificate.nonce")
  valid_568392 = validateParameter(valid_568392, JString, required = false,
                                 default = nil)
  if valid_568392 != nil:
    section.add "certificate.nonce", valid_568392
  var valid_568393 = query.getOrDefault("certificate.rawBytes")
  valid_568393 = validateParameter(valid_568393, JString, required = false,
                                 default = nil)
  if valid_568393 != nil:
    section.add "certificate.rawBytes", valid_568393
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the certificate.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_568394 = header.getOrDefault("If-Match")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "If-Match", valid_568394
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

proc call*(call_568396: Call_DpsCertificateVerifyCertificate_568378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies the certificate's private key possession by providing the leaf cert issued by the verifying pre uploaded certificate.
  ## 
  let valid = call_568396.validator(path, query, header, formData, body)
  let scheme = call_568396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568396.url(scheme.get, call_568396.host, call_568396.base,
                         call_568396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568396, url, valid)

var dpsCertificateVerifyCertificate* = Call_DpsCertificateVerifyCertificate_568378(
    name: "dpsCertificateVerifyCertificate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}/verify",
    validator: validate_DpsCertificateVerifyCertificate_568379, base: "",
    url: url_DpsCertificateVerifyCertificate_568380, schemes: {Scheme.Https})
type
  Call_IotDpsResourceListKeysForKeyName_568401 = ref object of OpenApiRestCall_567657
proc url_IotDpsResourceListKeysForKeyName_568403(protocol: Scheme; host: string;
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

proc validate_IotDpsResourceListKeysForKeyName_568402(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List primary and secondary keys for a specific key name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the provisioning service.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of the provisioning service.
  ##   keyName: JString (required)
  ##          : Logical key name to get key-values for.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568404 = path.getOrDefault("resourceGroupName")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "resourceGroupName", valid_568404
  var valid_568405 = path.getOrDefault("provisioningServiceName")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "provisioningServiceName", valid_568405
  var valid_568406 = path.getOrDefault("keyName")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "keyName", valid_568406
  var valid_568407 = path.getOrDefault("subscriptionId")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "subscriptionId", valid_568407
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568408 = query.getOrDefault("api-version")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "api-version", valid_568408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568409: Call_IotDpsResourceListKeysForKeyName_568401;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List primary and secondary keys for a specific key name
  ## 
  let valid = call_568409.validator(path, query, header, formData, body)
  let scheme = call_568409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568409.url(scheme.get, call_568409.host, call_568409.base,
                         call_568409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568409, url, valid)

proc call*(call_568410: Call_IotDpsResourceListKeysForKeyName_568401;
          resourceGroupName: string; apiVersion: string;
          provisioningServiceName: string; keyName: string; subscriptionId: string): Recallable =
  ## iotDpsResourceListKeysForKeyName
  ## List primary and secondary keys for a specific key name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the provisioning service.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   provisioningServiceName: string (required)
  ##                          : Name of the provisioning service.
  ##   keyName: string (required)
  ##          : Logical key name to get key-values for.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568411 = newJObject()
  var query_568412 = newJObject()
  add(path_568411, "resourceGroupName", newJString(resourceGroupName))
  add(query_568412, "api-version", newJString(apiVersion))
  add(path_568411, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_568411, "keyName", newJString(keyName))
  add(path_568411, "subscriptionId", newJString(subscriptionId))
  result = call_568410.call(path_568411, query_568412, nil, nil, nil)

var iotDpsResourceListKeysForKeyName* = Call_IotDpsResourceListKeysForKeyName_568401(
    name: "iotDpsResourceListKeysForKeyName", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/keys/{keyName}/listkeys",
    validator: validate_IotDpsResourceListKeysForKeyName_568402, base: "",
    url: url_IotDpsResourceListKeysForKeyName_568403, schemes: {Scheme.Https})
type
  Call_IotDpsResourceListKeys_568413 = ref object of OpenApiRestCall_567657
proc url_IotDpsResourceListKeys_568415(protocol: Scheme; host: string; base: string;
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

proc validate_IotDpsResourceListKeys_568414(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the primary and secondary keys for a provisioning service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : resource group name
  ##   provisioningServiceName: JString (required)
  ##                          : The provisioning service name to get the shared access keys for.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568416 = path.getOrDefault("resourceGroupName")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "resourceGroupName", valid_568416
  var valid_568417 = path.getOrDefault("provisioningServiceName")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "provisioningServiceName", valid_568417
  var valid_568418 = path.getOrDefault("subscriptionId")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "subscriptionId", valid_568418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
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
  if body != nil:
    result.add "body", body

proc call*(call_568420: Call_IotDpsResourceListKeys_568413; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the primary and secondary keys for a provisioning service.
  ## 
  let valid = call_568420.validator(path, query, header, formData, body)
  let scheme = call_568420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568420.url(scheme.get, call_568420.host, call_568420.base,
                         call_568420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568420, url, valid)

proc call*(call_568421: Call_IotDpsResourceListKeys_568413;
          resourceGroupName: string; apiVersion: string;
          provisioningServiceName: string; subscriptionId: string): Recallable =
  ## iotDpsResourceListKeys
  ## List the primary and secondary keys for a provisioning service.
  ##   resourceGroupName: string (required)
  ##                    : resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   provisioningServiceName: string (required)
  ##                          : The provisioning service name to get the shared access keys for.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568422 = newJObject()
  var query_568423 = newJObject()
  add(path_568422, "resourceGroupName", newJString(resourceGroupName))
  add(query_568423, "api-version", newJString(apiVersion))
  add(path_568422, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_568422, "subscriptionId", newJString(subscriptionId))
  result = call_568421.call(path_568422, query_568423, nil, nil, nil)

var iotDpsResourceListKeys* = Call_IotDpsResourceListKeys_568413(
    name: "iotDpsResourceListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/listkeys",
    validator: validate_IotDpsResourceListKeys_568414, base: "",
    url: url_IotDpsResourceListKeys_568415, schemes: {Scheme.Https})
type
  Call_IotDpsResourceGetOperationResult_568424 = ref object of OpenApiRestCall_567657
proc url_IotDpsResourceGetOperationResult_568426(protocol: Scheme; host: string;
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

proc validate_IotDpsResourceGetOperationResult_568425(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of a long running operation, such as create, update or delete a provisioning service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of provisioning service that the operation is running on.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   operationId: JString (required)
  ##              : Operation id corresponding to long running operation. Use this to poll for the status.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568427 = path.getOrDefault("resourceGroupName")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "resourceGroupName", valid_568427
  var valid_568428 = path.getOrDefault("provisioningServiceName")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "provisioningServiceName", valid_568428
  var valid_568429 = path.getOrDefault("subscriptionId")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "subscriptionId", valid_568429
  var valid_568430 = path.getOrDefault("operationId")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "operationId", valid_568430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  ##   asyncinfo: JString (required)
  ##            : Async header used to poll on the status of the operation, obtained while creating the long running operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568431 = query.getOrDefault("api-version")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "api-version", valid_568431
  var valid_568432 = query.getOrDefault("asyncinfo")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = newJString("true"))
  if valid_568432 != nil:
    section.add "asyncinfo", valid_568432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568433: Call_IotDpsResourceGetOperationResult_568424;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a long running operation, such as create, update or delete a provisioning service.
  ## 
  let valid = call_568433.validator(path, query, header, formData, body)
  let scheme = call_568433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568433.url(scheme.get, call_568433.host, call_568433.base,
                         call_568433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568433, url, valid)

proc call*(call_568434: Call_IotDpsResourceGetOperationResult_568424;
          resourceGroupName: string; apiVersion: string;
          provisioningServiceName: string; subscriptionId: string;
          operationId: string; asyncinfo: string = "true"): Recallable =
  ## iotDpsResourceGetOperationResult
  ## Gets the status of a long running operation, such as create, update or delete a provisioning service.
  ##   resourceGroupName: string (required)
  ##                    : Resource group identifier.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   provisioningServiceName: string (required)
  ##                          : Name of provisioning service that the operation is running on.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   asyncinfo: string (required)
  ##            : Async header used to poll on the status of the operation, obtained while creating the long running operation.
  ##   operationId: string (required)
  ##              : Operation id corresponding to long running operation. Use this to poll for the status.
  var path_568435 = newJObject()
  var query_568436 = newJObject()
  add(path_568435, "resourceGroupName", newJString(resourceGroupName))
  add(query_568436, "api-version", newJString(apiVersion))
  add(path_568435, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_568435, "subscriptionId", newJString(subscriptionId))
  add(query_568436, "asyncinfo", newJString(asyncinfo))
  add(path_568435, "operationId", newJString(operationId))
  result = call_568434.call(path_568435, query_568436, nil, nil, nil)

var iotDpsResourceGetOperationResult* = Call_IotDpsResourceGetOperationResult_568424(
    name: "iotDpsResourceGetOperationResult", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/operationresults/{operationId}",
    validator: validate_IotDpsResourceGetOperationResult_568425, base: "",
    url: url_IotDpsResourceGetOperationResult_568426, schemes: {Scheme.Https})
type
  Call_IotDpsResourceListValidSkus_568437 = ref object of OpenApiRestCall_567657
proc url_IotDpsResourceListValidSkus_568439(protocol: Scheme; host: string;
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

proc validate_IotDpsResourceListValidSkus_568438(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of valid SKUs and tiers for a provisioning service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of resource group.
  ##   provisioningServiceName: JString (required)
  ##                          : Name of provisioning service.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568440 = path.getOrDefault("resourceGroupName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "resourceGroupName", valid_568440
  var valid_568441 = path.getOrDefault("provisioningServiceName")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "provisioningServiceName", valid_568441
  var valid_568442 = path.getOrDefault("subscriptionId")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "subscriptionId", valid_568442
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568443 = query.getOrDefault("api-version")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "api-version", valid_568443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568444: Call_IotDpsResourceListValidSkus_568437; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of valid SKUs and tiers for a provisioning service.
  ## 
  let valid = call_568444.validator(path, query, header, formData, body)
  let scheme = call_568444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568444.url(scheme.get, call_568444.host, call_568444.base,
                         call_568444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568444, url, valid)

proc call*(call_568445: Call_IotDpsResourceListValidSkus_568437;
          resourceGroupName: string; apiVersion: string;
          provisioningServiceName: string; subscriptionId: string): Recallable =
  ## iotDpsResourceListValidSkus
  ## Gets the list of valid SKUs and tiers for a provisioning service.
  ##   resourceGroupName: string (required)
  ##                    : Name of resource group.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   provisioningServiceName: string (required)
  ##                          : Name of provisioning service.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568446 = newJObject()
  var query_568447 = newJObject()
  add(path_568446, "resourceGroupName", newJString(resourceGroupName))
  add(query_568447, "api-version", newJString(apiVersion))
  add(path_568446, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_568446, "subscriptionId", newJString(subscriptionId))
  result = call_568445.call(path_568446, query_568447, nil, nil, nil)

var iotDpsResourceListValidSkus* = Call_IotDpsResourceListValidSkus_568437(
    name: "iotDpsResourceListValidSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/skus",
    validator: validate_IotDpsResourceListValidSkus_568438, base: "",
    url: url_IotDpsResourceListValidSkus_568439, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
