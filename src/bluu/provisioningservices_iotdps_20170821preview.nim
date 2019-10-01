
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  macServiceName = "provisioningservices-iotdps"
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
  Call_IotDpsResourceCheckNameAvailability_568175 = ref object of OpenApiRestCall_567657
proc url_IotDpsResourceCheckNameAvailability_568177(protocol: Scheme; host: string;
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

proc validate_IotDpsResourceCheckNameAvailability_568176(path: JsonNode;
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

proc call*(call_568195: Call_IotDpsResourceCheckNameAvailability_568175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check if a provisioning service name is available.
  ## 
  let valid = call_568195.validator(path, query, header, formData, body)
  let scheme = call_568195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568195.url(scheme.get, call_568195.host, call_568195.base,
                         call_568195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568195, url, valid)

proc call*(call_568196: Call_IotDpsResourceCheckNameAvailability_568175;
          apiVersion: string; subscriptionId: string; arguments: JsonNode): Recallable =
  ## iotDpsResourceCheckNameAvailability
  ## Check if a provisioning service name is available.
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

var iotDpsResourceCheckNameAvailability* = Call_IotDpsResourceCheckNameAvailability_568175(
    name: "iotDpsResourceCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Devices/checkProvisioningServiceNameAvailability",
    validator: validate_IotDpsResourceCheckNameAvailability_568176, base: "",
    url: url_IotDpsResourceCheckNameAvailability_568177, schemes: {Scheme.Https})
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
  ## Get all the provisioning services in a subscription.
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
  ## Get all the provisioning services in a subscription.
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
  ## Get the non-security related metadata of the provisioning service.
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
  ## Get the non-security related metadata of the provisioning service.
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
  ## Get the non-security related metadata of the provisioning service.
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
  Call_DpsCertificatesList_568254 = ref object of OpenApiRestCall_567657
proc url_DpsCertificatesList_568256(protocol: Scheme; host: string; base: string;
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

proc validate_DpsCertificatesList_568255(path: JsonNode; query: JsonNode;
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
  var valid_568257 = path.getOrDefault("resourceGroupName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "resourceGroupName", valid_568257
  var valid_568258 = path.getOrDefault("provisioningServiceName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "provisioningServiceName", valid_568258
  var valid_568259 = path.getOrDefault("subscriptionId")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "subscriptionId", valid_568259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568260 = query.getOrDefault("api-version")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "api-version", valid_568260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568261: Call_DpsCertificatesList_568254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the certificates tied to the provisioning service.
  ## 
  let valid = call_568261.validator(path, query, header, formData, body)
  let scheme = call_568261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568261.url(scheme.get, call_568261.host, call_568261.base,
                         call_568261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568261, url, valid)

proc call*(call_568262: Call_DpsCertificatesList_568254; resourceGroupName: string;
          apiVersion: string; provisioningServiceName: string;
          subscriptionId: string): Recallable =
  ## dpsCertificatesList
  ## Get all the certificates tied to the provisioning service.
  ##   resourceGroupName: string (required)
  ##                    : Name of resource group.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   provisioningServiceName: string (required)
  ##                          : Name of provisioning service to retrieve certificates for.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568263 = newJObject()
  var query_568264 = newJObject()
  add(path_568263, "resourceGroupName", newJString(resourceGroupName))
  add(query_568264, "api-version", newJString(apiVersion))
  add(path_568263, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_568263, "subscriptionId", newJString(subscriptionId))
  result = call_568262.call(path_568263, query_568264, nil, nil, nil)

var dpsCertificatesList* = Call_DpsCertificatesList_568254(
    name: "dpsCertificatesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates",
    validator: validate_DpsCertificatesList_568255, base: "",
    url: url_DpsCertificatesList_568256, schemes: {Scheme.Https})
type
  Call_DpsCertificateCreateOrUpdate_568278 = ref object of OpenApiRestCall_567657
proc url_DpsCertificateCreateOrUpdate_568280(protocol: Scheme; host: string;
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

proc validate_DpsCertificateCreateOrUpdate_568279(path: JsonNode; query: JsonNode;
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
  var valid_568281 = path.getOrDefault("resourceGroupName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "resourceGroupName", valid_568281
  var valid_568282 = path.getOrDefault("provisioningServiceName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "provisioningServiceName", valid_568282
  var valid_568283 = path.getOrDefault("subscriptionId")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "subscriptionId", valid_568283
  var valid_568284 = path.getOrDefault("certificateName")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "certificateName", valid_568284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568285 = query.getOrDefault("api-version")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "api-version", valid_568285
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the certificate. This is required to update an existing certificate, and ignored while creating a brand new certificate.
  section = newJObject()
  var valid_568286 = header.getOrDefault("If-Match")
  valid_568286 = validateParameter(valid_568286, JString, required = false,
                                 default = nil)
  if valid_568286 != nil:
    section.add "If-Match", valid_568286
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

proc call*(call_568288: Call_DpsCertificateCreateOrUpdate_568278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add new certificate or update an existing certificate.
  ## 
  let valid = call_568288.validator(path, query, header, formData, body)
  let scheme = call_568288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568288.url(scheme.get, call_568288.host, call_568288.base,
                         call_568288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568288, url, valid)

proc call*(call_568289: Call_DpsCertificateCreateOrUpdate_568278;
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
  var path_568290 = newJObject()
  var query_568291 = newJObject()
  var body_568292 = newJObject()
  add(path_568290, "resourceGroupName", newJString(resourceGroupName))
  add(query_568291, "api-version", newJString(apiVersion))
  add(path_568290, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_568290, "subscriptionId", newJString(subscriptionId))
  add(path_568290, "certificateName", newJString(certificateName))
  if certificateDescription != nil:
    body_568292 = certificateDescription
  result = call_568289.call(path_568290, query_568291, nil, nil, body_568292)

var dpsCertificateCreateOrUpdate* = Call_DpsCertificateCreateOrUpdate_568278(
    name: "dpsCertificateCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}",
    validator: validate_DpsCertificateCreateOrUpdate_568279, base: "",
    url: url_DpsCertificateCreateOrUpdate_568280, schemes: {Scheme.Https})
type
  Call_DpsCertificateGet_568265 = ref object of OpenApiRestCall_567657
proc url_DpsCertificateGet_568267(protocol: Scheme; host: string; base: string;
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

proc validate_DpsCertificateGet_568266(path: JsonNode; query: JsonNode;
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
  var valid_568268 = path.getOrDefault("resourceGroupName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "resourceGroupName", valid_568268
  var valid_568269 = path.getOrDefault("provisioningServiceName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "provisioningServiceName", valid_568269
  var valid_568270 = path.getOrDefault("subscriptionId")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "subscriptionId", valid_568270
  var valid_568271 = path.getOrDefault("certificateName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "certificateName", valid_568271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568272 = query.getOrDefault("api-version")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "api-version", valid_568272
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the certificate.
  section = newJObject()
  var valid_568273 = header.getOrDefault("If-Match")
  valid_568273 = validateParameter(valid_568273, JString, required = false,
                                 default = nil)
  if valid_568273 != nil:
    section.add "If-Match", valid_568273
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568274: Call_DpsCertificateGet_568265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the certificate from the provisioning service.
  ## 
  let valid = call_568274.validator(path, query, header, formData, body)
  let scheme = call_568274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568274.url(scheme.get, call_568274.host, call_568274.base,
                         call_568274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568274, url, valid)

proc call*(call_568275: Call_DpsCertificateGet_568265; resourceGroupName: string;
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
  var path_568276 = newJObject()
  var query_568277 = newJObject()
  add(path_568276, "resourceGroupName", newJString(resourceGroupName))
  add(query_568277, "api-version", newJString(apiVersion))
  add(path_568276, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_568276, "subscriptionId", newJString(subscriptionId))
  add(path_568276, "certificateName", newJString(certificateName))
  result = call_568275.call(path_568276, query_568277, nil, nil, nil)

var dpsCertificateGet* = Call_DpsCertificateGet_568265(name: "dpsCertificateGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}",
    validator: validate_DpsCertificateGet_568266, base: "",
    url: url_DpsCertificateGet_568267, schemes: {Scheme.Https})
type
  Call_DpsCertificateDelete_568293 = ref object of OpenApiRestCall_567657
proc url_DpsCertificateDelete_568295(protocol: Scheme; host: string; base: string;
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

proc validate_DpsCertificateDelete_568294(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_568296 = path.getOrDefault("resourceGroupName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "resourceGroupName", valid_568296
  var valid_568297 = path.getOrDefault("provisioningServiceName")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "provisioningServiceName", valid_568297
  var valid_568298 = path.getOrDefault("subscriptionId")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "subscriptionId", valid_568298
  var valid_568299 = path.getOrDefault("certificateName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "certificateName", valid_568299
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
  var valid_568300 = query.getOrDefault("certificate.hasPrivateKey")
  valid_568300 = validateParameter(valid_568300, JBool, required = false, default = nil)
  if valid_568300 != nil:
    section.add "certificate.hasPrivateKey", valid_568300
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568301 = query.getOrDefault("api-version")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "api-version", valid_568301
  var valid_568302 = query.getOrDefault("certificate.name")
  valid_568302 = validateParameter(valid_568302, JString, required = false,
                                 default = nil)
  if valid_568302 != nil:
    section.add "certificate.name", valid_568302
  var valid_568303 = query.getOrDefault("certificate.lastUpdated")
  valid_568303 = validateParameter(valid_568303, JString, required = false,
                                 default = nil)
  if valid_568303 != nil:
    section.add "certificate.lastUpdated", valid_568303
  var valid_568304 = query.getOrDefault("certificate.created")
  valid_568304 = validateParameter(valid_568304, JString, required = false,
                                 default = nil)
  if valid_568304 != nil:
    section.add "certificate.created", valid_568304
  var valid_568318 = query.getOrDefault("certificate.purpose")
  valid_568318 = validateParameter(valid_568318, JString, required = false,
                                 default = newJString("clientAuthentication"))
  if valid_568318 != nil:
    section.add "certificate.purpose", valid_568318
  var valid_568319 = query.getOrDefault("certificate.isVerified")
  valid_568319 = validateParameter(valid_568319, JBool, required = false, default = nil)
  if valid_568319 != nil:
    section.add "certificate.isVerified", valid_568319
  var valid_568320 = query.getOrDefault("certificate.nonce")
  valid_568320 = validateParameter(valid_568320, JString, required = false,
                                 default = nil)
  if valid_568320 != nil:
    section.add "certificate.nonce", valid_568320
  var valid_568321 = query.getOrDefault("certificate.rawBytes")
  valid_568321 = validateParameter(valid_568321, JString, required = false,
                                 default = nil)
  if valid_568321 != nil:
    section.add "certificate.rawBytes", valid_568321
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the certificate
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_568322 = header.getOrDefault("If-Match")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "If-Match", valid_568322
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568323: Call_DpsCertificateDelete_568293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568323.validator(path, query, header, formData, body)
  let scheme = call_568323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568323.url(scheme.get, call_568323.host, call_568323.base,
                         call_568323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568323, url, valid)

var dpsCertificateDelete* = Call_DpsCertificateDelete_568293(
    name: "dpsCertificateDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}",
    validator: validate_DpsCertificateDelete_568294, base: "",
    url: url_DpsCertificateDelete_568295, schemes: {Scheme.Https})
type
  Call_DpsCertificateGenerateVerificationCode_568327 = ref object of OpenApiRestCall_567657
proc url_DpsCertificateGenerateVerificationCode_568329(protocol: Scheme;
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

proc validate_DpsCertificateGenerateVerificationCode_568328(path: JsonNode;
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
  var valid_568330 = path.getOrDefault("resourceGroupName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "resourceGroupName", valid_568330
  var valid_568331 = path.getOrDefault("provisioningServiceName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "provisioningServiceName", valid_568331
  var valid_568332 = path.getOrDefault("subscriptionId")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "subscriptionId", valid_568332
  var valid_568333 = path.getOrDefault("certificateName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "certificateName", valid_568333
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
  var valid_568334 = query.getOrDefault("certificate.hasPrivateKey")
  valid_568334 = validateParameter(valid_568334, JBool, required = false, default = nil)
  if valid_568334 != nil:
    section.add "certificate.hasPrivateKey", valid_568334
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568335 = query.getOrDefault("api-version")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "api-version", valid_568335
  var valid_568336 = query.getOrDefault("certificate.name")
  valid_568336 = validateParameter(valid_568336, JString, required = false,
                                 default = nil)
  if valid_568336 != nil:
    section.add "certificate.name", valid_568336
  var valid_568337 = query.getOrDefault("certificate.lastUpdated")
  valid_568337 = validateParameter(valid_568337, JString, required = false,
                                 default = nil)
  if valid_568337 != nil:
    section.add "certificate.lastUpdated", valid_568337
  var valid_568338 = query.getOrDefault("certificate.created")
  valid_568338 = validateParameter(valid_568338, JString, required = false,
                                 default = nil)
  if valid_568338 != nil:
    section.add "certificate.created", valid_568338
  var valid_568339 = query.getOrDefault("certificate.purpose")
  valid_568339 = validateParameter(valid_568339, JString, required = false,
                                 default = newJString("clientAuthentication"))
  if valid_568339 != nil:
    section.add "certificate.purpose", valid_568339
  var valid_568340 = query.getOrDefault("certificate.isVerified")
  valid_568340 = validateParameter(valid_568340, JBool, required = false, default = nil)
  if valid_568340 != nil:
    section.add "certificate.isVerified", valid_568340
  var valid_568341 = query.getOrDefault("certificate.nonce")
  valid_568341 = validateParameter(valid_568341, JString, required = false,
                                 default = nil)
  if valid_568341 != nil:
    section.add "certificate.nonce", valid_568341
  var valid_568342 = query.getOrDefault("certificate.rawBytes")
  valid_568342 = validateParameter(valid_568342, JString, required = false,
                                 default = nil)
  if valid_568342 != nil:
    section.add "certificate.rawBytes", valid_568342
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the certificate. This is required to update an existing certificate, and ignored while creating a brand new certificate.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_568343 = header.getOrDefault("If-Match")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "If-Match", valid_568343
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568344: Call_DpsCertificateGenerateVerificationCode_568327;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate verification code for Proof of Possession.
  ## 
  let valid = call_568344.validator(path, query, header, formData, body)
  let scheme = call_568344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568344.url(scheme.get, call_568344.host, call_568344.base,
                         call_568344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568344, url, valid)

var dpsCertificateGenerateVerificationCode* = Call_DpsCertificateGenerateVerificationCode_568327(
    name: "dpsCertificateGenerateVerificationCode", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}/generateVerificationCode",
    validator: validate_DpsCertificateGenerateVerificationCode_568328, base: "",
    url: url_DpsCertificateGenerateVerificationCode_568329,
    schemes: {Scheme.Https})
type
  Call_DpsCertificateVerifyCertificate_568348 = ref object of OpenApiRestCall_567657
proc url_DpsCertificateVerifyCertificate_568350(protocol: Scheme; host: string;
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

proc validate_DpsCertificateVerifyCertificate_568349(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verifies certificate for the provisioning service.
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
  var valid_568351 = path.getOrDefault("resourceGroupName")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "resourceGroupName", valid_568351
  var valid_568352 = path.getOrDefault("provisioningServiceName")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "provisioningServiceName", valid_568352
  var valid_568353 = path.getOrDefault("subscriptionId")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "subscriptionId", valid_568353
  var valid_568354 = path.getOrDefault("certificateName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "certificateName", valid_568354
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
  var valid_568355 = query.getOrDefault("certificate.hasPrivateKey")
  valid_568355 = validateParameter(valid_568355, JBool, required = false, default = nil)
  if valid_568355 != nil:
    section.add "certificate.hasPrivateKey", valid_568355
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568356 = query.getOrDefault("api-version")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "api-version", valid_568356
  var valid_568357 = query.getOrDefault("certificate.name")
  valid_568357 = validateParameter(valid_568357, JString, required = false,
                                 default = nil)
  if valid_568357 != nil:
    section.add "certificate.name", valid_568357
  var valid_568358 = query.getOrDefault("certificate.lastUpdated")
  valid_568358 = validateParameter(valid_568358, JString, required = false,
                                 default = nil)
  if valid_568358 != nil:
    section.add "certificate.lastUpdated", valid_568358
  var valid_568359 = query.getOrDefault("certificate.created")
  valid_568359 = validateParameter(valid_568359, JString, required = false,
                                 default = nil)
  if valid_568359 != nil:
    section.add "certificate.created", valid_568359
  var valid_568360 = query.getOrDefault("certificate.purpose")
  valid_568360 = validateParameter(valid_568360, JString, required = false,
                                 default = newJString("clientAuthentication"))
  if valid_568360 != nil:
    section.add "certificate.purpose", valid_568360
  var valid_568361 = query.getOrDefault("certificate.isVerified")
  valid_568361 = validateParameter(valid_568361, JBool, required = false, default = nil)
  if valid_568361 != nil:
    section.add "certificate.isVerified", valid_568361
  var valid_568362 = query.getOrDefault("certificate.nonce")
  valid_568362 = validateParameter(valid_568362, JString, required = false,
                                 default = nil)
  if valid_568362 != nil:
    section.add "certificate.nonce", valid_568362
  var valid_568363 = query.getOrDefault("certificate.rawBytes")
  valid_568363 = validateParameter(valid_568363, JString, required = false,
                                 default = nil)
  if valid_568363 != nil:
    section.add "certificate.rawBytes", valid_568363
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the certificate.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_568364 = header.getOrDefault("If-Match")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "If-Match", valid_568364
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568366: Call_DpsCertificateVerifyCertificate_568348;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies certificate for the provisioning service.
  ## 
  let valid = call_568366.validator(path, query, header, formData, body)
  let scheme = call_568366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568366.url(scheme.get, call_568366.host, call_568366.base,
                         call_568366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568366, url, valid)

var dpsCertificateVerifyCertificate* = Call_DpsCertificateVerifyCertificate_568348(
    name: "dpsCertificateVerifyCertificate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/certificates/{certificateName}/verify",
    validator: validate_DpsCertificateVerifyCertificate_568349, base: "",
    url: url_DpsCertificateVerifyCertificate_568350, schemes: {Scheme.Https})
type
  Call_IotDpsResourceGetKeysForKeyName_568371 = ref object of OpenApiRestCall_567657
proc url_IotDpsResourceGetKeysForKeyName_568373(protocol: Scheme; host: string;
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

proc validate_IotDpsResourceGetKeysForKeyName_568372(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a shared access policy by name from a provisioning service.
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
  var valid_568374 = path.getOrDefault("resourceGroupName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "resourceGroupName", valid_568374
  var valid_568375 = path.getOrDefault("provisioningServiceName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "provisioningServiceName", valid_568375
  var valid_568376 = path.getOrDefault("keyName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "keyName", valid_568376
  var valid_568377 = path.getOrDefault("subscriptionId")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "subscriptionId", valid_568377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568378 = query.getOrDefault("api-version")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "api-version", valid_568378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568379: Call_IotDpsResourceGetKeysForKeyName_568371;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a shared access policy by name from a provisioning service.
  ## 
  let valid = call_568379.validator(path, query, header, formData, body)
  let scheme = call_568379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568379.url(scheme.get, call_568379.host, call_568379.base,
                         call_568379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568379, url, valid)

proc call*(call_568380: Call_IotDpsResourceGetKeysForKeyName_568371;
          resourceGroupName: string; apiVersion: string;
          provisioningServiceName: string; keyName: string; subscriptionId: string): Recallable =
  ## iotDpsResourceGetKeysForKeyName
  ## Get a shared access policy by name from a provisioning service.
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
  var path_568381 = newJObject()
  var query_568382 = newJObject()
  add(path_568381, "resourceGroupName", newJString(resourceGroupName))
  add(query_568382, "api-version", newJString(apiVersion))
  add(path_568381, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_568381, "keyName", newJString(keyName))
  add(path_568381, "subscriptionId", newJString(subscriptionId))
  result = call_568380.call(path_568381, query_568382, nil, nil, nil)

var iotDpsResourceGetKeysForKeyName* = Call_IotDpsResourceGetKeysForKeyName_568371(
    name: "iotDpsResourceGetKeysForKeyName", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/keys/{keyName}/listkeys",
    validator: validate_IotDpsResourceGetKeysForKeyName_568372, base: "",
    url: url_IotDpsResourceGetKeysForKeyName_568373, schemes: {Scheme.Https})
type
  Call_IotDpsResourceListKeys_568383 = ref object of OpenApiRestCall_567657
proc url_IotDpsResourceListKeys_568385(protocol: Scheme; host: string; base: string;
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

proc validate_IotDpsResourceListKeys_568384(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the security metadata for a provisioning service.
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
  var valid_568386 = path.getOrDefault("resourceGroupName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "resourceGroupName", valid_568386
  var valid_568387 = path.getOrDefault("provisioningServiceName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "provisioningServiceName", valid_568387
  var valid_568388 = path.getOrDefault("subscriptionId")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "subscriptionId", valid_568388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568389 = query.getOrDefault("api-version")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "api-version", valid_568389
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568390: Call_IotDpsResourceListKeys_568383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the security metadata for a provisioning service.
  ## 
  let valid = call_568390.validator(path, query, header, formData, body)
  let scheme = call_568390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568390.url(scheme.get, call_568390.host, call_568390.base,
                         call_568390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568390, url, valid)

proc call*(call_568391: Call_IotDpsResourceListKeys_568383;
          resourceGroupName: string; apiVersion: string;
          provisioningServiceName: string; subscriptionId: string): Recallable =
  ## iotDpsResourceListKeys
  ## Get the security metadata for a provisioning service.
  ##   resourceGroupName: string (required)
  ##                    : resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   provisioningServiceName: string (required)
  ##                          : The provisioning service name to get the shared access keys for.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568392 = newJObject()
  var query_568393 = newJObject()
  add(path_568392, "resourceGroupName", newJString(resourceGroupName))
  add(query_568393, "api-version", newJString(apiVersion))
  add(path_568392, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_568392, "subscriptionId", newJString(subscriptionId))
  result = call_568391.call(path_568392, query_568393, nil, nil, nil)

var iotDpsResourceListKeys* = Call_IotDpsResourceListKeys_568383(
    name: "iotDpsResourceListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/listkeys",
    validator: validate_IotDpsResourceListKeys_568384, base: "",
    url: url_IotDpsResourceListKeys_568385, schemes: {Scheme.Https})
type
  Call_IotDpsResourceGetOperationResult_568394 = ref object of OpenApiRestCall_567657
proc url_IotDpsResourceGetOperationResult_568396(protocol: Scheme; host: string;
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

proc validate_IotDpsResourceGetOperationResult_568395(path: JsonNode;
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
  var valid_568397 = path.getOrDefault("resourceGroupName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "resourceGroupName", valid_568397
  var valid_568398 = path.getOrDefault("provisioningServiceName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "provisioningServiceName", valid_568398
  var valid_568399 = path.getOrDefault("subscriptionId")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "subscriptionId", valid_568399
  var valid_568400 = path.getOrDefault("operationId")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "operationId", valid_568400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  ##   asyncinfo: JString (required)
  ##            : Async header used to poll on the status of the operation, obtained while creating the long running operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568401 = query.getOrDefault("api-version")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "api-version", valid_568401
  var valid_568402 = query.getOrDefault("asyncinfo")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = newJString("true"))
  if valid_568402 != nil:
    section.add "asyncinfo", valid_568402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568403: Call_IotDpsResourceGetOperationResult_568394;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a long running operation, such as create, update or delete a provisioning service.
  ## 
  let valid = call_568403.validator(path, query, header, formData, body)
  let scheme = call_568403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568403.url(scheme.get, call_568403.host, call_568403.base,
                         call_568403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568403, url, valid)

proc call*(call_568404: Call_IotDpsResourceGetOperationResult_568394;
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
  var path_568405 = newJObject()
  var query_568406 = newJObject()
  add(path_568405, "resourceGroupName", newJString(resourceGroupName))
  add(query_568406, "api-version", newJString(apiVersion))
  add(path_568405, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_568405, "subscriptionId", newJString(subscriptionId))
  add(query_568406, "asyncinfo", newJString(asyncinfo))
  add(path_568405, "operationId", newJString(operationId))
  result = call_568404.call(path_568405, query_568406, nil, nil, nil)

var iotDpsResourceGetOperationResult* = Call_IotDpsResourceGetOperationResult_568394(
    name: "iotDpsResourceGetOperationResult", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/operationresults/{operationId}",
    validator: validate_IotDpsResourceGetOperationResult_568395, base: "",
    url: url_IotDpsResourceGetOperationResult_568396, schemes: {Scheme.Https})
type
  Call_IotDpsResourceListValidSkus_568407 = ref object of OpenApiRestCall_567657
proc url_IotDpsResourceListValidSkus_568409(protocol: Scheme; host: string;
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

proc validate_IotDpsResourceListValidSkus_568408(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of valid SKUs for a provisioning service.
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
  var valid_568410 = path.getOrDefault("resourceGroupName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "resourceGroupName", valid_568410
  var valid_568411 = path.getOrDefault("provisioningServiceName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "provisioningServiceName", valid_568411
  var valid_568412 = path.getOrDefault("subscriptionId")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "subscriptionId", valid_568412
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568413 = query.getOrDefault("api-version")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "api-version", valid_568413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568414: Call_IotDpsResourceListValidSkus_568407; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of valid SKUs for a provisioning service.
  ## 
  let valid = call_568414.validator(path, query, header, formData, body)
  let scheme = call_568414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568414.url(scheme.get, call_568414.host, call_568414.base,
                         call_568414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568414, url, valid)

proc call*(call_568415: Call_IotDpsResourceListValidSkus_568407;
          resourceGroupName: string; apiVersion: string;
          provisioningServiceName: string; subscriptionId: string): Recallable =
  ## iotDpsResourceListValidSkus
  ## Get the list of valid SKUs for a provisioning service.
  ##   resourceGroupName: string (required)
  ##                    : Name of resource group.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   provisioningServiceName: string (required)
  ##                          : Name of provisioning service.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568416 = newJObject()
  var query_568417 = newJObject()
  add(path_568416, "resourceGroupName", newJString(resourceGroupName))
  add(query_568417, "api-version", newJString(apiVersion))
  add(path_568416, "provisioningServiceName", newJString(provisioningServiceName))
  add(path_568416, "subscriptionId", newJString(subscriptionId))
  result = call_568415.call(path_568416, query_568417, nil, nil, nil)

var iotDpsResourceListValidSkus* = Call_IotDpsResourceListValidSkus_568407(
    name: "iotDpsResourceListValidSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/provisioningServices/{provisioningServiceName}/skus",
    validator: validate_IotDpsResourceListValidSkus_568408, base: "",
    url: url_IotDpsResourceListValidSkus_568409, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
