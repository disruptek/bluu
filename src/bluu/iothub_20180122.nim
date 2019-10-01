
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: iotHubClient
## version: 2018-01-22
## termsOfService: (not provided)
## license: (not provided)
## 
## Use this API to manage the IoT hubs in your Azure subscription.
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

  OpenApiRestCall_567666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567666): Option[Scheme] {.used.} =
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
  macServiceName = "iothub"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567888 = ref object of OpenApiRestCall_567666
proc url_OperationsList_567890(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567889(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available IoT Hub REST API operations.
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
  var valid_568049 = query.getOrDefault("api-version")
  valid_568049 = validateParameter(valid_568049, JString, required = true,
                                 default = nil)
  if valid_568049 != nil:
    section.add "api-version", valid_568049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568072: Call_OperationsList_567888; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available IoT Hub REST API operations.
  ## 
  let valid = call_568072.validator(path, query, header, formData, body)
  let scheme = call_568072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568072.url(scheme.get, call_568072.host, call_568072.base,
                         call_568072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568072, url, valid)

proc call*(call_568143: Call_OperationsList_567888; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available IoT Hub REST API operations.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  var query_568144 = newJObject()
  add(query_568144, "api-version", newJString(apiVersion))
  result = call_568143.call(nil, query_568144, nil, nil, nil)

var operationsList* = Call_OperationsList_567888(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Devices/operations",
    validator: validate_OperationsList_567889, base: "", url: url_OperationsList_567890,
    schemes: {Scheme.Https})
type
  Call_IotHubResourceListBySubscription_568184 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceListBySubscription_568186(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceListBySubscription_568185(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the IoT hubs in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568201 = path.getOrDefault("subscriptionId")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "subscriptionId", valid_568201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568202 = query.getOrDefault("api-version")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "api-version", valid_568202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568203: Call_IotHubResourceListBySubscription_568184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all the IoT hubs in a subscription.
  ## 
  let valid = call_568203.validator(path, query, header, formData, body)
  let scheme = call_568203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568203.url(scheme.get, call_568203.host, call_568203.base,
                         call_568203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568203, url, valid)

proc call*(call_568204: Call_IotHubResourceListBySubscription_568184;
          apiVersion: string; subscriptionId: string): Recallable =
  ## iotHubResourceListBySubscription
  ## Get all the IoT hubs in a subscription.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568205 = newJObject()
  var query_568206 = newJObject()
  add(query_568206, "api-version", newJString(apiVersion))
  add(path_568205, "subscriptionId", newJString(subscriptionId))
  result = call_568204.call(path_568205, query_568206, nil, nil, nil)

var iotHubResourceListBySubscription* = Call_IotHubResourceListBySubscription_568184(
    name: "iotHubResourceListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Devices/IotHubs",
    validator: validate_IotHubResourceListBySubscription_568185, base: "",
    url: url_IotHubResourceListBySubscription_568186, schemes: {Scheme.Https})
type
  Call_IotHubResourceCheckNameAvailability_568207 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceCheckNameAvailability_568209(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Devices/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceCheckNameAvailability_568208(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check if an IoT hub name is available.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568210 = path.getOrDefault("subscriptionId")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "subscriptionId", valid_568210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568211 = query.getOrDefault("api-version")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "api-version", valid_568211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   operationInputs: JObject (required)
  ##                  : Set the name parameter in the OperationInputs structure to the name of the IoT hub to check.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568213: Call_IotHubResourceCheckNameAvailability_568207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check if an IoT hub name is available.
  ## 
  let valid = call_568213.validator(path, query, header, formData, body)
  let scheme = call_568213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568213.url(scheme.get, call_568213.host, call_568213.base,
                         call_568213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568213, url, valid)

proc call*(call_568214: Call_IotHubResourceCheckNameAvailability_568207;
          apiVersion: string; subscriptionId: string; operationInputs: JsonNode): Recallable =
  ## iotHubResourceCheckNameAvailability
  ## Check if an IoT hub name is available.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   operationInputs: JObject (required)
  ##                  : Set the name parameter in the OperationInputs structure to the name of the IoT hub to check.
  var path_568215 = newJObject()
  var query_568216 = newJObject()
  var body_568217 = newJObject()
  add(query_568216, "api-version", newJString(apiVersion))
  add(path_568215, "subscriptionId", newJString(subscriptionId))
  if operationInputs != nil:
    body_568217 = operationInputs
  result = call_568214.call(path_568215, query_568216, nil, nil, body_568217)

var iotHubResourceCheckNameAvailability* = Call_IotHubResourceCheckNameAvailability_568207(
    name: "iotHubResourceCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Devices/checkNameAvailability",
    validator: validate_IotHubResourceCheckNameAvailability_568208, base: "",
    url: url_IotHubResourceCheckNameAvailability_568209, schemes: {Scheme.Https})
type
  Call_IotHubResourceListByResourceGroup_568218 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceListByResourceGroup_568220(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceListByResourceGroup_568219(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the IoT hubs in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568221 = path.getOrDefault("resourceGroupName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "resourceGroupName", valid_568221
  var valid_568222 = path.getOrDefault("subscriptionId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "subscriptionId", valid_568222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568223 = query.getOrDefault("api-version")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "api-version", valid_568223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568224: Call_IotHubResourceListByResourceGroup_568218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all the IoT hubs in a resource group.
  ## 
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_IotHubResourceListByResourceGroup_568218;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## iotHubResourceListByResourceGroup
  ## Get all the IoT hubs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568226 = newJObject()
  var query_568227 = newJObject()
  add(path_568226, "resourceGroupName", newJString(resourceGroupName))
  add(query_568227, "api-version", newJString(apiVersion))
  add(path_568226, "subscriptionId", newJString(subscriptionId))
  result = call_568225.call(path_568226, query_568227, nil, nil, nil)

var iotHubResourceListByResourceGroup* = Call_IotHubResourceListByResourceGroup_568218(
    name: "iotHubResourceListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs",
    validator: validate_IotHubResourceListByResourceGroup_568219, base: "",
    url: url_IotHubResourceListByResourceGroup_568220, schemes: {Scheme.Https})
type
  Call_IotHubResourceCreateOrUpdate_568239 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceCreateOrUpdate_568241(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceCreateOrUpdate_568240(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update the metadata of an Iot hub. The usual pattern to modify a property is to retrieve the IoT hub metadata and security metadata, and then combine them with the modified values in a new body to update the IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568242 = path.getOrDefault("resourceGroupName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "resourceGroupName", valid_568242
  var valid_568243 = path.getOrDefault("subscriptionId")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "subscriptionId", valid_568243
  var valid_568244 = path.getOrDefault("resourceName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "resourceName", valid_568244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568245 = query.getOrDefault("api-version")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "api-version", valid_568245
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the IoT Hub. Do not specify for creating a brand new IoT Hub. Required to update an existing IoT Hub.
  section = newJObject()
  var valid_568246 = header.getOrDefault("If-Match")
  valid_568246 = validateParameter(valid_568246, JString, required = false,
                                 default = nil)
  if valid_568246 != nil:
    section.add "If-Match", valid_568246
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   iotHubDescription: JObject (required)
  ##                    : The IoT hub metadata and security metadata.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568248: Call_IotHubResourceCreateOrUpdate_568239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the metadata of an Iot hub. The usual pattern to modify a property is to retrieve the IoT hub metadata and security metadata, and then combine them with the modified values in a new body to update the IoT hub.
  ## 
  let valid = call_568248.validator(path, query, header, formData, body)
  let scheme = call_568248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568248.url(scheme.get, call_568248.host, call_568248.base,
                         call_568248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568248, url, valid)

proc call*(call_568249: Call_IotHubResourceCreateOrUpdate_568239;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; iotHubDescription: JsonNode): Recallable =
  ## iotHubResourceCreateOrUpdate
  ## Create or update the metadata of an Iot hub. The usual pattern to modify a property is to retrieve the IoT hub metadata and security metadata, and then combine them with the modified values in a new body to update the IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  ##   iotHubDescription: JObject (required)
  ##                    : The IoT hub metadata and security metadata.
  var path_568250 = newJObject()
  var query_568251 = newJObject()
  var body_568252 = newJObject()
  add(path_568250, "resourceGroupName", newJString(resourceGroupName))
  add(query_568251, "api-version", newJString(apiVersion))
  add(path_568250, "subscriptionId", newJString(subscriptionId))
  add(path_568250, "resourceName", newJString(resourceName))
  if iotHubDescription != nil:
    body_568252 = iotHubDescription
  result = call_568249.call(path_568250, query_568251, nil, nil, body_568252)

var iotHubResourceCreateOrUpdate* = Call_IotHubResourceCreateOrUpdate_568239(
    name: "iotHubResourceCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}",
    validator: validate_IotHubResourceCreateOrUpdate_568240, base: "",
    url: url_IotHubResourceCreateOrUpdate_568241, schemes: {Scheme.Https})
type
  Call_IotHubResourceGet_568228 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceGet_568230(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceGet_568229(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get the non-security related metadata of an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568231 = path.getOrDefault("resourceGroupName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "resourceGroupName", valid_568231
  var valid_568232 = path.getOrDefault("subscriptionId")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "subscriptionId", valid_568232
  var valid_568233 = path.getOrDefault("resourceName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "resourceName", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568235: Call_IotHubResourceGet_568228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the non-security related metadata of an IoT hub.
  ## 
  let valid = call_568235.validator(path, query, header, formData, body)
  let scheme = call_568235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568235.url(scheme.get, call_568235.host, call_568235.base,
                         call_568235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568235, url, valid)

proc call*(call_568236: Call_IotHubResourceGet_568228; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## iotHubResourceGet
  ## Get the non-security related metadata of an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_568237 = newJObject()
  var query_568238 = newJObject()
  add(path_568237, "resourceGroupName", newJString(resourceGroupName))
  add(query_568238, "api-version", newJString(apiVersion))
  add(path_568237, "subscriptionId", newJString(subscriptionId))
  add(path_568237, "resourceName", newJString(resourceName))
  result = call_568236.call(path_568237, query_568238, nil, nil, nil)

var iotHubResourceGet* = Call_IotHubResourceGet_568228(name: "iotHubResourceGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}",
    validator: validate_IotHubResourceGet_568229, base: "",
    url: url_IotHubResourceGet_568230, schemes: {Scheme.Https})
type
  Call_IotHubResourceUpdate_568264 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceUpdate_568266(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceUpdate_568265(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing IoT Hub tags. to update other fields use the CreateOrUpdate method
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group identifier.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : Name of iot hub to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568284 = path.getOrDefault("resourceGroupName")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "resourceGroupName", valid_568284
  var valid_568285 = path.getOrDefault("subscriptionId")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "subscriptionId", valid_568285
  var valid_568286 = path.getOrDefault("resourceName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "resourceName", valid_568286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568287 = query.getOrDefault("api-version")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "api-version", valid_568287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   IotHubTags: JObject (required)
  ##             : Updated tag information to set into the iot hub instance.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568289: Call_IotHubResourceUpdate_568264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing IoT Hub tags. to update other fields use the CreateOrUpdate method
  ## 
  let valid = call_568289.validator(path, query, header, formData, body)
  let scheme = call_568289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568289.url(scheme.get, call_568289.host, call_568289.base,
                         call_568289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568289, url, valid)

proc call*(call_568290: Call_IotHubResourceUpdate_568264;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; IotHubTags: JsonNode): Recallable =
  ## iotHubResourceUpdate
  ## Update an existing IoT Hub tags. to update other fields use the CreateOrUpdate method
  ##   resourceGroupName: string (required)
  ##                    : Resource group identifier.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : Name of iot hub to update.
  ##   IotHubTags: JObject (required)
  ##             : Updated tag information to set into the iot hub instance.
  var path_568291 = newJObject()
  var query_568292 = newJObject()
  var body_568293 = newJObject()
  add(path_568291, "resourceGroupName", newJString(resourceGroupName))
  add(query_568292, "api-version", newJString(apiVersion))
  add(path_568291, "subscriptionId", newJString(subscriptionId))
  add(path_568291, "resourceName", newJString(resourceName))
  if IotHubTags != nil:
    body_568293 = IotHubTags
  result = call_568290.call(path_568291, query_568292, nil, nil, body_568293)

var iotHubResourceUpdate* = Call_IotHubResourceUpdate_568264(
    name: "iotHubResourceUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}",
    validator: validate_IotHubResourceUpdate_568265, base: "",
    url: url_IotHubResourceUpdate_568266, schemes: {Scheme.Https})
type
  Call_IotHubResourceDelete_568253 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceDelete_568255(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceDelete_568254(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568256 = path.getOrDefault("resourceGroupName")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "resourceGroupName", valid_568256
  var valid_568257 = path.getOrDefault("subscriptionId")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "subscriptionId", valid_568257
  var valid_568258 = path.getOrDefault("resourceName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "resourceName", valid_568258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568259 = query.getOrDefault("api-version")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "api-version", valid_568259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568260: Call_IotHubResourceDelete_568253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an IoT hub.
  ## 
  let valid = call_568260.validator(path, query, header, formData, body)
  let scheme = call_568260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568260.url(scheme.get, call_568260.host, call_568260.base,
                         call_568260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568260, url, valid)

proc call*(call_568261: Call_IotHubResourceDelete_568253;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## iotHubResourceDelete
  ## Delete an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_568262 = newJObject()
  var query_568263 = newJObject()
  add(path_568262, "resourceGroupName", newJString(resourceGroupName))
  add(query_568263, "api-version", newJString(apiVersion))
  add(path_568262, "subscriptionId", newJString(subscriptionId))
  add(path_568262, "resourceName", newJString(resourceName))
  result = call_568261.call(path_568262, query_568263, nil, nil, nil)

var iotHubResourceDelete* = Call_IotHubResourceDelete_568253(
    name: "iotHubResourceDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}",
    validator: validate_IotHubResourceDelete_568254, base: "",
    url: url_IotHubResourceDelete_568255, schemes: {Scheme.Https})
type
  Call_IotHubResourceGetKeysForKeyName_568294 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceGetKeysForKeyName_568296(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "keyName" in path, "`keyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/IotHubKeys/"),
               (kind: VariableSegment, value: "keyName"),
               (kind: ConstantSegment, value: "/listkeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceGetKeysForKeyName_568295(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a shared access policy by name from an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-security.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   keyName: JString (required)
  ##          : The name of the shared access policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568297 = path.getOrDefault("resourceGroupName")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "resourceGroupName", valid_568297
  var valid_568298 = path.getOrDefault("keyName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "keyName", valid_568298
  var valid_568299 = path.getOrDefault("subscriptionId")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "subscriptionId", valid_568299
  var valid_568300 = path.getOrDefault("resourceName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "resourceName", valid_568300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568301 = query.getOrDefault("api-version")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "api-version", valid_568301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568302: Call_IotHubResourceGetKeysForKeyName_568294;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a shared access policy by name from an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-security.
  ## 
  let valid = call_568302.validator(path, query, header, formData, body)
  let scheme = call_568302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568302.url(scheme.get, call_568302.host, call_568302.base,
                         call_568302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568302, url, valid)

proc call*(call_568303: Call_IotHubResourceGetKeysForKeyName_568294;
          resourceGroupName: string; apiVersion: string; keyName: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## iotHubResourceGetKeysForKeyName
  ## Get a shared access policy by name from an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-security.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   keyName: string (required)
  ##          : The name of the shared access policy.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_568304 = newJObject()
  var query_568305 = newJObject()
  add(path_568304, "resourceGroupName", newJString(resourceGroupName))
  add(query_568305, "api-version", newJString(apiVersion))
  add(path_568304, "keyName", newJString(keyName))
  add(path_568304, "subscriptionId", newJString(subscriptionId))
  add(path_568304, "resourceName", newJString(resourceName))
  result = call_568303.call(path_568304, query_568305, nil, nil, nil)

var iotHubResourceGetKeysForKeyName* = Call_IotHubResourceGetKeysForKeyName_568294(
    name: "iotHubResourceGetKeysForKeyName", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/IotHubKeys/{keyName}/listkeys",
    validator: validate_IotHubResourceGetKeysForKeyName_568295, base: "",
    url: url_IotHubResourceGetKeysForKeyName_568296, schemes: {Scheme.Https})
type
  Call_IotHubResourceGetStats_568306 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceGetStats_568308(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/IotHubStats")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceGetStats_568307(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the statistics from an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568309 = path.getOrDefault("resourceGroupName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "resourceGroupName", valid_568309
  var valid_568310 = path.getOrDefault("subscriptionId")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "subscriptionId", valid_568310
  var valid_568311 = path.getOrDefault("resourceName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "resourceName", valid_568311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568312 = query.getOrDefault("api-version")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "api-version", valid_568312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568313: Call_IotHubResourceGetStats_568306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the statistics from an IoT hub.
  ## 
  let valid = call_568313.validator(path, query, header, formData, body)
  let scheme = call_568313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568313.url(scheme.get, call_568313.host, call_568313.base,
                         call_568313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568313, url, valid)

proc call*(call_568314: Call_IotHubResourceGetStats_568306;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## iotHubResourceGetStats
  ## Get the statistics from an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_568315 = newJObject()
  var query_568316 = newJObject()
  add(path_568315, "resourceGroupName", newJString(resourceGroupName))
  add(query_568316, "api-version", newJString(apiVersion))
  add(path_568315, "subscriptionId", newJString(subscriptionId))
  add(path_568315, "resourceName", newJString(resourceName))
  result = call_568314.call(path_568315, query_568316, nil, nil, nil)

var iotHubResourceGetStats* = Call_IotHubResourceGetStats_568306(
    name: "iotHubResourceGetStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/IotHubStats",
    validator: validate_IotHubResourceGetStats_568307, base: "",
    url: url_IotHubResourceGetStats_568308, schemes: {Scheme.Https})
type
  Call_CertificatesListByIotHub_568317 = ref object of OpenApiRestCall_567666
proc url_CertificatesListByIotHub_568319(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/certificates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificatesListByIotHub_568318(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of certificates.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568320 = path.getOrDefault("resourceGroupName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "resourceGroupName", valid_568320
  var valid_568321 = path.getOrDefault("subscriptionId")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "subscriptionId", valid_568321
  var valid_568322 = path.getOrDefault("resourceName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "resourceName", valid_568322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568323 = query.getOrDefault("api-version")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "api-version", valid_568323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568324: Call_CertificatesListByIotHub_568317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of certificates.
  ## 
  let valid = call_568324.validator(path, query, header, formData, body)
  let scheme = call_568324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568324.url(scheme.get, call_568324.host, call_568324.base,
                         call_568324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568324, url, valid)

proc call*(call_568325: Call_CertificatesListByIotHub_568317;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## certificatesListByIotHub
  ## Returns the list of certificates.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_568326 = newJObject()
  var query_568327 = newJObject()
  add(path_568326, "resourceGroupName", newJString(resourceGroupName))
  add(query_568327, "api-version", newJString(apiVersion))
  add(path_568326, "subscriptionId", newJString(subscriptionId))
  add(path_568326, "resourceName", newJString(resourceName))
  result = call_568325.call(path_568326, query_568327, nil, nil, nil)

var certificatesListByIotHub* = Call_CertificatesListByIotHub_568317(
    name: "certificatesListByIotHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates",
    validator: validate_CertificatesListByIotHub_568318, base: "",
    url: url_CertificatesListByIotHub_568319, schemes: {Scheme.Https})
type
  Call_CertificatesCreateOrUpdate_568340 = ref object of OpenApiRestCall_567666
proc url_CertificatesCreateOrUpdate_568342(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificatesCreateOrUpdate_568341(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds new or replaces existing certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  ##   certificateName: JString (required)
  ##                  : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568343 = path.getOrDefault("resourceGroupName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "resourceGroupName", valid_568343
  var valid_568344 = path.getOrDefault("subscriptionId")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "subscriptionId", valid_568344
  var valid_568345 = path.getOrDefault("resourceName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "resourceName", valid_568345
  var valid_568346 = path.getOrDefault("certificateName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "certificateName", valid_568346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568347 = query.getOrDefault("api-version")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "api-version", valid_568347
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Certificate. Do not specify for creating a brand new certificate. Required to update an existing certificate.
  section = newJObject()
  var valid_568348 = header.getOrDefault("If-Match")
  valid_568348 = validateParameter(valid_568348, JString, required = false,
                                 default = nil)
  if valid_568348 != nil:
    section.add "If-Match", valid_568348
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

proc call*(call_568350: Call_CertificatesCreateOrUpdate_568340; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds new or replaces existing certificate.
  ## 
  let valid = call_568350.validator(path, query, header, formData, body)
  let scheme = call_568350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568350.url(scheme.get, call_568350.host, call_568350.base,
                         call_568350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568350, url, valid)

proc call*(call_568351: Call_CertificatesCreateOrUpdate_568340;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; certificateName: string;
          certificateDescription: JsonNode): Recallable =
  ## certificatesCreateOrUpdate
  ## Adds new or replaces existing certificate.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  ##   certificateDescription: JObject (required)
  ##                         : The certificate body.
  var path_568352 = newJObject()
  var query_568353 = newJObject()
  var body_568354 = newJObject()
  add(path_568352, "resourceGroupName", newJString(resourceGroupName))
  add(query_568353, "api-version", newJString(apiVersion))
  add(path_568352, "subscriptionId", newJString(subscriptionId))
  add(path_568352, "resourceName", newJString(resourceName))
  add(path_568352, "certificateName", newJString(certificateName))
  if certificateDescription != nil:
    body_568354 = certificateDescription
  result = call_568351.call(path_568352, query_568353, nil, nil, body_568354)

var certificatesCreateOrUpdate* = Call_CertificatesCreateOrUpdate_568340(
    name: "certificatesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates/{certificateName}",
    validator: validate_CertificatesCreateOrUpdate_568341, base: "",
    url: url_CertificatesCreateOrUpdate_568342, schemes: {Scheme.Https})
type
  Call_CertificatesGet_568328 = ref object of OpenApiRestCall_567666
proc url_CertificatesGet_568330(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificatesGet_568329(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns the certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  ##   certificateName: JString (required)
  ##                  : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568331 = path.getOrDefault("resourceGroupName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "resourceGroupName", valid_568331
  var valid_568332 = path.getOrDefault("subscriptionId")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "subscriptionId", valid_568332
  var valid_568333 = path.getOrDefault("resourceName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "resourceName", valid_568333
  var valid_568334 = path.getOrDefault("certificateName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "certificateName", valid_568334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568335 = query.getOrDefault("api-version")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "api-version", valid_568335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568336: Call_CertificatesGet_568328; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the certificate.
  ## 
  let valid = call_568336.validator(path, query, header, formData, body)
  let scheme = call_568336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568336.url(scheme.get, call_568336.host, call_568336.base,
                         call_568336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568336, url, valid)

proc call*(call_568337: Call_CertificatesGet_568328; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          certificateName: string): Recallable =
  ## certificatesGet
  ## Returns the certificate.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_568338 = newJObject()
  var query_568339 = newJObject()
  add(path_568338, "resourceGroupName", newJString(resourceGroupName))
  add(query_568339, "api-version", newJString(apiVersion))
  add(path_568338, "subscriptionId", newJString(subscriptionId))
  add(path_568338, "resourceName", newJString(resourceName))
  add(path_568338, "certificateName", newJString(certificateName))
  result = call_568337.call(path_568338, query_568339, nil, nil, nil)

var certificatesGet* = Call_CertificatesGet_568328(name: "certificatesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates/{certificateName}",
    validator: validate_CertificatesGet_568329, base: "", url: url_CertificatesGet_568330,
    schemes: {Scheme.Https})
type
  Call_CertificatesDelete_568355 = ref object of OpenApiRestCall_567666
proc url_CertificatesDelete_568357(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificatesDelete_568356(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes an existing X509 certificate or does nothing if it does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  ##   certificateName: JString (required)
  ##                  : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568358 = path.getOrDefault("resourceGroupName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "resourceGroupName", valid_568358
  var valid_568359 = path.getOrDefault("subscriptionId")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "subscriptionId", valid_568359
  var valid_568360 = path.getOrDefault("resourceName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "resourceName", valid_568360
  var valid_568361 = path.getOrDefault("certificateName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "certificateName", valid_568361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568362 = query.getOrDefault("api-version")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "api-version", valid_568362
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Certificate.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_568363 = header.getOrDefault("If-Match")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "If-Match", valid_568363
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568364: Call_CertificatesDelete_568355; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing X509 certificate or does nothing if it does not exist.
  ## 
  let valid = call_568364.validator(path, query, header, formData, body)
  let scheme = call_568364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568364.url(scheme.get, call_568364.host, call_568364.base,
                         call_568364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568364, url, valid)

proc call*(call_568365: Call_CertificatesDelete_568355; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          certificateName: string): Recallable =
  ## certificatesDelete
  ## Deletes an existing X509 certificate or does nothing if it does not exist.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_568366 = newJObject()
  var query_568367 = newJObject()
  add(path_568366, "resourceGroupName", newJString(resourceGroupName))
  add(query_568367, "api-version", newJString(apiVersion))
  add(path_568366, "subscriptionId", newJString(subscriptionId))
  add(path_568366, "resourceName", newJString(resourceName))
  add(path_568366, "certificateName", newJString(certificateName))
  result = call_568365.call(path_568366, query_568367, nil, nil, nil)

var certificatesDelete* = Call_CertificatesDelete_568355(
    name: "certificatesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates/{certificateName}",
    validator: validate_CertificatesDelete_568356, base: "",
    url: url_CertificatesDelete_568357, schemes: {Scheme.Https})
type
  Call_CertificatesGenerateVerificationCode_568368 = ref object of OpenApiRestCall_567666
proc url_CertificatesGenerateVerificationCode_568370(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName"),
               (kind: ConstantSegment, value: "/generateVerificationCode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificatesGenerateVerificationCode_568369(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates verification code for proof of possession flow. The verification code will be used to generate a leaf certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  ##   certificateName: JString (required)
  ##                  : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568371 = path.getOrDefault("resourceGroupName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "resourceGroupName", valid_568371
  var valid_568372 = path.getOrDefault("subscriptionId")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "subscriptionId", valid_568372
  var valid_568373 = path.getOrDefault("resourceName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "resourceName", valid_568373
  var valid_568374 = path.getOrDefault("certificateName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "certificateName", valid_568374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568375 = query.getOrDefault("api-version")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "api-version", valid_568375
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Certificate.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_568376 = header.getOrDefault("If-Match")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "If-Match", valid_568376
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568377: Call_CertificatesGenerateVerificationCode_568368;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates verification code for proof of possession flow. The verification code will be used to generate a leaf certificate.
  ## 
  let valid = call_568377.validator(path, query, header, formData, body)
  let scheme = call_568377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568377.url(scheme.get, call_568377.host, call_568377.base,
                         call_568377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568377, url, valid)

proc call*(call_568378: Call_CertificatesGenerateVerificationCode_568368;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; certificateName: string): Recallable =
  ## certificatesGenerateVerificationCode
  ## Generates verification code for proof of possession flow. The verification code will be used to generate a leaf certificate.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_568379 = newJObject()
  var query_568380 = newJObject()
  add(path_568379, "resourceGroupName", newJString(resourceGroupName))
  add(query_568380, "api-version", newJString(apiVersion))
  add(path_568379, "subscriptionId", newJString(subscriptionId))
  add(path_568379, "resourceName", newJString(resourceName))
  add(path_568379, "certificateName", newJString(certificateName))
  result = call_568378.call(path_568379, query_568380, nil, nil, nil)

var certificatesGenerateVerificationCode* = Call_CertificatesGenerateVerificationCode_568368(
    name: "certificatesGenerateVerificationCode", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates/{certificateName}/generateVerificationCode",
    validator: validate_CertificatesGenerateVerificationCode_568369, base: "",
    url: url_CertificatesGenerateVerificationCode_568370, schemes: {Scheme.Https})
type
  Call_CertificatesVerify_568381 = ref object of OpenApiRestCall_567666
proc url_CertificatesVerify_568383(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName"),
               (kind: ConstantSegment, value: "/verify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificatesVerify_568382(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Verifies the certificate's private key possession by providing the leaf cert issued by the verifying pre uploaded certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  ##   certificateName: JString (required)
  ##                  : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568384 = path.getOrDefault("resourceGroupName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "resourceGroupName", valid_568384
  var valid_568385 = path.getOrDefault("subscriptionId")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "subscriptionId", valid_568385
  var valid_568386 = path.getOrDefault("resourceName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "resourceName", valid_568386
  var valid_568387 = path.getOrDefault("certificateName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "certificateName", valid_568387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568388 = query.getOrDefault("api-version")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "api-version", valid_568388
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Certificate.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_568389 = header.getOrDefault("If-Match")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "If-Match", valid_568389
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   certificateVerificationBody: JObject (required)
  ##                              : The name of the certificate
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568391: Call_CertificatesVerify_568381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verifies the certificate's private key possession by providing the leaf cert issued by the verifying pre uploaded certificate.
  ## 
  let valid = call_568391.validator(path, query, header, formData, body)
  let scheme = call_568391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568391.url(scheme.get, call_568391.host, call_568391.base,
                         call_568391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568391, url, valid)

proc call*(call_568392: Call_CertificatesVerify_568381; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          certificateName: string; certificateVerificationBody: JsonNode): Recallable =
  ## certificatesVerify
  ## Verifies the certificate's private key possession by providing the leaf cert issued by the verifying pre uploaded certificate.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  ##   certificateVerificationBody: JObject (required)
  ##                              : The name of the certificate
  var path_568393 = newJObject()
  var query_568394 = newJObject()
  var body_568395 = newJObject()
  add(path_568393, "resourceGroupName", newJString(resourceGroupName))
  add(query_568394, "api-version", newJString(apiVersion))
  add(path_568393, "subscriptionId", newJString(subscriptionId))
  add(path_568393, "resourceName", newJString(resourceName))
  add(path_568393, "certificateName", newJString(certificateName))
  if certificateVerificationBody != nil:
    body_568395 = certificateVerificationBody
  result = call_568392.call(path_568393, query_568394, nil, nil, body_568395)

var certificatesVerify* = Call_CertificatesVerify_568381(
    name: "certificatesVerify", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates/{certificateName}/verify",
    validator: validate_CertificatesVerify_568382, base: "",
    url: url_CertificatesVerify_568383, schemes: {Scheme.Https})
type
  Call_IotHubResourceListEventHubConsumerGroups_568396 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceListEventHubConsumerGroups_568398(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "eventHubEndpointName" in path,
        "`eventHubEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/eventHubEndpoints/"),
               (kind: VariableSegment, value: "eventHubEndpointName"),
               (kind: ConstantSegment, value: "/ConsumerGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceListEventHubConsumerGroups_568397(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of the consumer groups in the Event Hub-compatible device-to-cloud endpoint in an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   eventHubEndpointName: JString (required)
  ##                       : The name of the Event Hub-compatible endpoint.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568399 = path.getOrDefault("resourceGroupName")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "resourceGroupName", valid_568399
  var valid_568400 = path.getOrDefault("eventHubEndpointName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "eventHubEndpointName", valid_568400
  var valid_568401 = path.getOrDefault("subscriptionId")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "subscriptionId", valid_568401
  var valid_568402 = path.getOrDefault("resourceName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "resourceName", valid_568402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568403 = query.getOrDefault("api-version")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "api-version", valid_568403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568404: Call_IotHubResourceListEventHubConsumerGroups_568396;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a list of the consumer groups in the Event Hub-compatible device-to-cloud endpoint in an IoT hub.
  ## 
  let valid = call_568404.validator(path, query, header, formData, body)
  let scheme = call_568404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568404.url(scheme.get, call_568404.host, call_568404.base,
                         call_568404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568404, url, valid)

proc call*(call_568405: Call_IotHubResourceListEventHubConsumerGroups_568396;
          resourceGroupName: string; apiVersion: string;
          eventHubEndpointName: string; subscriptionId: string; resourceName: string): Recallable =
  ## iotHubResourceListEventHubConsumerGroups
  ## Get a list of the consumer groups in the Event Hub-compatible device-to-cloud endpoint in an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   eventHubEndpointName: string (required)
  ##                       : The name of the Event Hub-compatible endpoint.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_568406 = newJObject()
  var query_568407 = newJObject()
  add(path_568406, "resourceGroupName", newJString(resourceGroupName))
  add(query_568407, "api-version", newJString(apiVersion))
  add(path_568406, "eventHubEndpointName", newJString(eventHubEndpointName))
  add(path_568406, "subscriptionId", newJString(subscriptionId))
  add(path_568406, "resourceName", newJString(resourceName))
  result = call_568405.call(path_568406, query_568407, nil, nil, nil)

var iotHubResourceListEventHubConsumerGroups* = Call_IotHubResourceListEventHubConsumerGroups_568396(
    name: "iotHubResourceListEventHubConsumerGroups", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/eventHubEndpoints/{eventHubEndpointName}/ConsumerGroups",
    validator: validate_IotHubResourceListEventHubConsumerGroups_568397, base: "",
    url: url_IotHubResourceListEventHubConsumerGroups_568398,
    schemes: {Scheme.Https})
type
  Call_IotHubResourceCreateEventHubConsumerGroup_568421 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceCreateEventHubConsumerGroup_568423(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "eventHubEndpointName" in path,
        "`eventHubEndpointName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/eventHubEndpoints/"),
               (kind: VariableSegment, value: "eventHubEndpointName"),
               (kind: ConstantSegment, value: "/ConsumerGroups/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceCreateEventHubConsumerGroup_568422(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a consumer group to an Event Hub-compatible endpoint in an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   name: JString (required)
  ##       : The name of the consumer group to add.
  ##   eventHubEndpointName: JString (required)
  ##                       : The name of the Event Hub-compatible endpoint in the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568424 = path.getOrDefault("resourceGroupName")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "resourceGroupName", valid_568424
  var valid_568425 = path.getOrDefault("name")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "name", valid_568425
  var valid_568426 = path.getOrDefault("eventHubEndpointName")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "eventHubEndpointName", valid_568426
  var valid_568427 = path.getOrDefault("subscriptionId")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "subscriptionId", valid_568427
  var valid_568428 = path.getOrDefault("resourceName")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "resourceName", valid_568428
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568429 = query.getOrDefault("api-version")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "api-version", valid_568429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568430: Call_IotHubResourceCreateEventHubConsumerGroup_568421;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a consumer group to an Event Hub-compatible endpoint in an IoT hub.
  ## 
  let valid = call_568430.validator(path, query, header, formData, body)
  let scheme = call_568430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568430.url(scheme.get, call_568430.host, call_568430.base,
                         call_568430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568430, url, valid)

proc call*(call_568431: Call_IotHubResourceCreateEventHubConsumerGroup_568421;
          resourceGroupName: string; apiVersion: string; name: string;
          eventHubEndpointName: string; subscriptionId: string; resourceName: string): Recallable =
  ## iotHubResourceCreateEventHubConsumerGroup
  ## Add a consumer group to an Event Hub-compatible endpoint in an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   name: string (required)
  ##       : The name of the consumer group to add.
  ##   eventHubEndpointName: string (required)
  ##                       : The name of the Event Hub-compatible endpoint in the IoT hub.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_568432 = newJObject()
  var query_568433 = newJObject()
  add(path_568432, "resourceGroupName", newJString(resourceGroupName))
  add(query_568433, "api-version", newJString(apiVersion))
  add(path_568432, "name", newJString(name))
  add(path_568432, "eventHubEndpointName", newJString(eventHubEndpointName))
  add(path_568432, "subscriptionId", newJString(subscriptionId))
  add(path_568432, "resourceName", newJString(resourceName))
  result = call_568431.call(path_568432, query_568433, nil, nil, nil)

var iotHubResourceCreateEventHubConsumerGroup* = Call_IotHubResourceCreateEventHubConsumerGroup_568421(
    name: "iotHubResourceCreateEventHubConsumerGroup", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/eventHubEndpoints/{eventHubEndpointName}/ConsumerGroups/{name}",
    validator: validate_IotHubResourceCreateEventHubConsumerGroup_568422,
    base: "", url: url_IotHubResourceCreateEventHubConsumerGroup_568423,
    schemes: {Scheme.Https})
type
  Call_IotHubResourceGetEventHubConsumerGroup_568408 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceGetEventHubConsumerGroup_568410(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "eventHubEndpointName" in path,
        "`eventHubEndpointName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/eventHubEndpoints/"),
               (kind: VariableSegment, value: "eventHubEndpointName"),
               (kind: ConstantSegment, value: "/ConsumerGroups/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceGetEventHubConsumerGroup_568409(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a consumer group from the Event Hub-compatible device-to-cloud endpoint for an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   name: JString (required)
  ##       : The name of the consumer group to retrieve.
  ##   eventHubEndpointName: JString (required)
  ##                       : The name of the Event Hub-compatible endpoint in the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568411 = path.getOrDefault("resourceGroupName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "resourceGroupName", valid_568411
  var valid_568412 = path.getOrDefault("name")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "name", valid_568412
  var valid_568413 = path.getOrDefault("eventHubEndpointName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "eventHubEndpointName", valid_568413
  var valid_568414 = path.getOrDefault("subscriptionId")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "subscriptionId", valid_568414
  var valid_568415 = path.getOrDefault("resourceName")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "resourceName", valid_568415
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568416 = query.getOrDefault("api-version")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "api-version", valid_568416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568417: Call_IotHubResourceGetEventHubConsumerGroup_568408;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a consumer group from the Event Hub-compatible device-to-cloud endpoint for an IoT hub.
  ## 
  let valid = call_568417.validator(path, query, header, formData, body)
  let scheme = call_568417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568417.url(scheme.get, call_568417.host, call_568417.base,
                         call_568417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568417, url, valid)

proc call*(call_568418: Call_IotHubResourceGetEventHubConsumerGroup_568408;
          resourceGroupName: string; apiVersion: string; name: string;
          eventHubEndpointName: string; subscriptionId: string; resourceName: string): Recallable =
  ## iotHubResourceGetEventHubConsumerGroup
  ## Get a consumer group from the Event Hub-compatible device-to-cloud endpoint for an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   name: string (required)
  ##       : The name of the consumer group to retrieve.
  ##   eventHubEndpointName: string (required)
  ##                       : The name of the Event Hub-compatible endpoint in the IoT hub.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_568419 = newJObject()
  var query_568420 = newJObject()
  add(path_568419, "resourceGroupName", newJString(resourceGroupName))
  add(query_568420, "api-version", newJString(apiVersion))
  add(path_568419, "name", newJString(name))
  add(path_568419, "eventHubEndpointName", newJString(eventHubEndpointName))
  add(path_568419, "subscriptionId", newJString(subscriptionId))
  add(path_568419, "resourceName", newJString(resourceName))
  result = call_568418.call(path_568419, query_568420, nil, nil, nil)

var iotHubResourceGetEventHubConsumerGroup* = Call_IotHubResourceGetEventHubConsumerGroup_568408(
    name: "iotHubResourceGetEventHubConsumerGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/eventHubEndpoints/{eventHubEndpointName}/ConsumerGroups/{name}",
    validator: validate_IotHubResourceGetEventHubConsumerGroup_568409, base: "",
    url: url_IotHubResourceGetEventHubConsumerGroup_568410,
    schemes: {Scheme.Https})
type
  Call_IotHubResourceDeleteEventHubConsumerGroup_568434 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceDeleteEventHubConsumerGroup_568436(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "eventHubEndpointName" in path,
        "`eventHubEndpointName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/eventHubEndpoints/"),
               (kind: VariableSegment, value: "eventHubEndpointName"),
               (kind: ConstantSegment, value: "/ConsumerGroups/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceDeleteEventHubConsumerGroup_568435(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a consumer group from an Event Hub-compatible endpoint in an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   name: JString (required)
  ##       : The name of the consumer group to delete.
  ##   eventHubEndpointName: JString (required)
  ##                       : The name of the Event Hub-compatible endpoint in the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568437 = path.getOrDefault("resourceGroupName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "resourceGroupName", valid_568437
  var valid_568438 = path.getOrDefault("name")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "name", valid_568438
  var valid_568439 = path.getOrDefault("eventHubEndpointName")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "eventHubEndpointName", valid_568439
  var valid_568440 = path.getOrDefault("subscriptionId")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "subscriptionId", valid_568440
  var valid_568441 = path.getOrDefault("resourceName")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "resourceName", valid_568441
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568442 = query.getOrDefault("api-version")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "api-version", valid_568442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568443: Call_IotHubResourceDeleteEventHubConsumerGroup_568434;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a consumer group from an Event Hub-compatible endpoint in an IoT hub.
  ## 
  let valid = call_568443.validator(path, query, header, formData, body)
  let scheme = call_568443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568443.url(scheme.get, call_568443.host, call_568443.base,
                         call_568443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568443, url, valid)

proc call*(call_568444: Call_IotHubResourceDeleteEventHubConsumerGroup_568434;
          resourceGroupName: string; apiVersion: string; name: string;
          eventHubEndpointName: string; subscriptionId: string; resourceName: string): Recallable =
  ## iotHubResourceDeleteEventHubConsumerGroup
  ## Delete a consumer group from an Event Hub-compatible endpoint in an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   name: string (required)
  ##       : The name of the consumer group to delete.
  ##   eventHubEndpointName: string (required)
  ##                       : The name of the Event Hub-compatible endpoint in the IoT hub.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_568445 = newJObject()
  var query_568446 = newJObject()
  add(path_568445, "resourceGroupName", newJString(resourceGroupName))
  add(query_568446, "api-version", newJString(apiVersion))
  add(path_568445, "name", newJString(name))
  add(path_568445, "eventHubEndpointName", newJString(eventHubEndpointName))
  add(path_568445, "subscriptionId", newJString(subscriptionId))
  add(path_568445, "resourceName", newJString(resourceName))
  result = call_568444.call(path_568445, query_568446, nil, nil, nil)

var iotHubResourceDeleteEventHubConsumerGroup* = Call_IotHubResourceDeleteEventHubConsumerGroup_568434(
    name: "iotHubResourceDeleteEventHubConsumerGroup",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/eventHubEndpoints/{eventHubEndpointName}/ConsumerGroups/{name}",
    validator: validate_IotHubResourceDeleteEventHubConsumerGroup_568435,
    base: "", url: url_IotHubResourceDeleteEventHubConsumerGroup_568436,
    schemes: {Scheme.Https})
type
  Call_IotHubResourceExportDevices_568447 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceExportDevices_568449(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/exportDevices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceExportDevices_568448(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports all the device identities in the IoT hub identity registry to an Azure Storage blob container. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry#import-and-export-device-identities.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568450 = path.getOrDefault("resourceGroupName")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "resourceGroupName", valid_568450
  var valid_568451 = path.getOrDefault("subscriptionId")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "subscriptionId", valid_568451
  var valid_568452 = path.getOrDefault("resourceName")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "resourceName", valid_568452
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568453 = query.getOrDefault("api-version")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "api-version", valid_568453
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   exportDevicesParameters: JObject (required)
  ##                          : The parameters that specify the export devices operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568455: Call_IotHubResourceExportDevices_568447; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports all the device identities in the IoT hub identity registry to an Azure Storage blob container. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry#import-and-export-device-identities.
  ## 
  let valid = call_568455.validator(path, query, header, formData, body)
  let scheme = call_568455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568455.url(scheme.get, call_568455.host, call_568455.base,
                         call_568455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568455, url, valid)

proc call*(call_568456: Call_IotHubResourceExportDevices_568447;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; exportDevicesParameters: JsonNode): Recallable =
  ## iotHubResourceExportDevices
  ## Exports all the device identities in the IoT hub identity registry to an Azure Storage blob container. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry#import-and-export-device-identities.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  ##   exportDevicesParameters: JObject (required)
  ##                          : The parameters that specify the export devices operation.
  var path_568457 = newJObject()
  var query_568458 = newJObject()
  var body_568459 = newJObject()
  add(path_568457, "resourceGroupName", newJString(resourceGroupName))
  add(query_568458, "api-version", newJString(apiVersion))
  add(path_568457, "subscriptionId", newJString(subscriptionId))
  add(path_568457, "resourceName", newJString(resourceName))
  if exportDevicesParameters != nil:
    body_568459 = exportDevicesParameters
  result = call_568456.call(path_568457, query_568458, nil, nil, body_568459)

var iotHubResourceExportDevices* = Call_IotHubResourceExportDevices_568447(
    name: "iotHubResourceExportDevices", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/exportDevices",
    validator: validate_IotHubResourceExportDevices_568448, base: "",
    url: url_IotHubResourceExportDevices_568449, schemes: {Scheme.Https})
type
  Call_IotHubResourceImportDevices_568460 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceImportDevices_568462(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/importDevices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceImportDevices_568461(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Import, update, or delete device identities in the IoT hub identity registry from a blob. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry#import-and-export-device-identities.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568463 = path.getOrDefault("resourceGroupName")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "resourceGroupName", valid_568463
  var valid_568464 = path.getOrDefault("subscriptionId")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "subscriptionId", valid_568464
  var valid_568465 = path.getOrDefault("resourceName")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "resourceName", valid_568465
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568466 = query.getOrDefault("api-version")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "api-version", valid_568466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   importDevicesParameters: JObject (required)
  ##                          : The parameters that specify the import devices operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568468: Call_IotHubResourceImportDevices_568460; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Import, update, or delete device identities in the IoT hub identity registry from a blob. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry#import-and-export-device-identities.
  ## 
  let valid = call_568468.validator(path, query, header, formData, body)
  let scheme = call_568468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568468.url(scheme.get, call_568468.host, call_568468.base,
                         call_568468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568468, url, valid)

proc call*(call_568469: Call_IotHubResourceImportDevices_568460;
          resourceGroupName: string; apiVersion: string;
          importDevicesParameters: JsonNode; subscriptionId: string;
          resourceName: string): Recallable =
  ## iotHubResourceImportDevices
  ## Import, update, or delete device identities in the IoT hub identity registry from a blob. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry#import-and-export-device-identities.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   importDevicesParameters: JObject (required)
  ##                          : The parameters that specify the import devices operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_568470 = newJObject()
  var query_568471 = newJObject()
  var body_568472 = newJObject()
  add(path_568470, "resourceGroupName", newJString(resourceGroupName))
  add(query_568471, "api-version", newJString(apiVersion))
  if importDevicesParameters != nil:
    body_568472 = importDevicesParameters
  add(path_568470, "subscriptionId", newJString(subscriptionId))
  add(path_568470, "resourceName", newJString(resourceName))
  result = call_568469.call(path_568470, query_568471, nil, nil, body_568472)

var iotHubResourceImportDevices* = Call_IotHubResourceImportDevices_568460(
    name: "iotHubResourceImportDevices", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/importDevices",
    validator: validate_IotHubResourceImportDevices_568461, base: "",
    url: url_IotHubResourceImportDevices_568462, schemes: {Scheme.Https})
type
  Call_IotHubResourceListJobs_568473 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceListJobs_568475(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceListJobs_568474(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of all the jobs in an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568476 = path.getOrDefault("resourceGroupName")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "resourceGroupName", valid_568476
  var valid_568477 = path.getOrDefault("subscriptionId")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "subscriptionId", valid_568477
  var valid_568478 = path.getOrDefault("resourceName")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "resourceName", valid_568478
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568479 = query.getOrDefault("api-version")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "api-version", valid_568479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568480: Call_IotHubResourceListJobs_568473; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of all the jobs in an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry.
  ## 
  let valid = call_568480.validator(path, query, header, formData, body)
  let scheme = call_568480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568480.url(scheme.get, call_568480.host, call_568480.base,
                         call_568480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568480, url, valid)

proc call*(call_568481: Call_IotHubResourceListJobs_568473;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## iotHubResourceListJobs
  ## Get a list of all the jobs in an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_568482 = newJObject()
  var query_568483 = newJObject()
  add(path_568482, "resourceGroupName", newJString(resourceGroupName))
  add(query_568483, "api-version", newJString(apiVersion))
  add(path_568482, "subscriptionId", newJString(subscriptionId))
  add(path_568482, "resourceName", newJString(resourceName))
  result = call_568481.call(path_568482, query_568483, nil, nil, nil)

var iotHubResourceListJobs* = Call_IotHubResourceListJobs_568473(
    name: "iotHubResourceListJobs", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/jobs",
    validator: validate_IotHubResourceListJobs_568474, base: "",
    url: url_IotHubResourceListJobs_568475, schemes: {Scheme.Https})
type
  Call_IotHubResourceGetJob_568484 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceGetJob_568486(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceGetJob_568485(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the details of a job from an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   jobId: JString (required)
  ##        : The job identifier.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568487 = path.getOrDefault("resourceGroupName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "resourceGroupName", valid_568487
  var valid_568488 = path.getOrDefault("jobId")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "jobId", valid_568488
  var valid_568489 = path.getOrDefault("subscriptionId")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "subscriptionId", valid_568489
  var valid_568490 = path.getOrDefault("resourceName")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "resourceName", valid_568490
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568491 = query.getOrDefault("api-version")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "api-version", valid_568491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568492: Call_IotHubResourceGetJob_568484; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of a job from an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry.
  ## 
  let valid = call_568492.validator(path, query, header, formData, body)
  let scheme = call_568492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568492.url(scheme.get, call_568492.host, call_568492.base,
                         call_568492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568492, url, valid)

proc call*(call_568493: Call_IotHubResourceGetJob_568484;
          resourceGroupName: string; apiVersion: string; jobId: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## iotHubResourceGetJob
  ## Get the details of a job from an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   jobId: string (required)
  ##        : The job identifier.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_568494 = newJObject()
  var query_568495 = newJObject()
  add(path_568494, "resourceGroupName", newJString(resourceGroupName))
  add(query_568495, "api-version", newJString(apiVersion))
  add(path_568494, "jobId", newJString(jobId))
  add(path_568494, "subscriptionId", newJString(subscriptionId))
  add(path_568494, "resourceName", newJString(resourceName))
  result = call_568493.call(path_568494, query_568495, nil, nil, nil)

var iotHubResourceGetJob* = Call_IotHubResourceGetJob_568484(
    name: "iotHubResourceGetJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/jobs/{jobId}",
    validator: validate_IotHubResourceGetJob_568485, base: "",
    url: url_IotHubResourceGetJob_568486, schemes: {Scheme.Https})
type
  Call_IotHubResourceListKeys_568496 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceListKeys_568498(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/listkeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceListKeys_568497(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the security metadata for an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-security.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568499 = path.getOrDefault("resourceGroupName")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "resourceGroupName", valid_568499
  var valid_568500 = path.getOrDefault("subscriptionId")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "subscriptionId", valid_568500
  var valid_568501 = path.getOrDefault("resourceName")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "resourceName", valid_568501
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568502 = query.getOrDefault("api-version")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "api-version", valid_568502
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568503: Call_IotHubResourceListKeys_568496; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the security metadata for an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-security.
  ## 
  let valid = call_568503.validator(path, query, header, formData, body)
  let scheme = call_568503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568503.url(scheme.get, call_568503.host, call_568503.base,
                         call_568503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568503, url, valid)

proc call*(call_568504: Call_IotHubResourceListKeys_568496;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## iotHubResourceListKeys
  ## Get the security metadata for an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-security.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_568505 = newJObject()
  var query_568506 = newJObject()
  add(path_568505, "resourceGroupName", newJString(resourceGroupName))
  add(query_568506, "api-version", newJString(apiVersion))
  add(path_568505, "subscriptionId", newJString(subscriptionId))
  add(path_568505, "resourceName", newJString(resourceName))
  result = call_568504.call(path_568505, query_568506, nil, nil, nil)

var iotHubResourceListKeys* = Call_IotHubResourceListKeys_568496(
    name: "iotHubResourceListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/listkeys",
    validator: validate_IotHubResourceListKeys_568497, base: "",
    url: url_IotHubResourceListKeys_568498, schemes: {Scheme.Https})
type
  Call_IotHubResourceGetQuotaMetrics_568507 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceGetQuotaMetrics_568509(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/quotaMetrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceGetQuotaMetrics_568508(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the quota metrics for an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568510 = path.getOrDefault("resourceGroupName")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "resourceGroupName", valid_568510
  var valid_568511 = path.getOrDefault("subscriptionId")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "subscriptionId", valid_568511
  var valid_568512 = path.getOrDefault("resourceName")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "resourceName", valid_568512
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568513 = query.getOrDefault("api-version")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "api-version", valid_568513
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568514: Call_IotHubResourceGetQuotaMetrics_568507; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the quota metrics for an IoT hub.
  ## 
  let valid = call_568514.validator(path, query, header, formData, body)
  let scheme = call_568514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568514.url(scheme.get, call_568514.host, call_568514.base,
                         call_568514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568514, url, valid)

proc call*(call_568515: Call_IotHubResourceGetQuotaMetrics_568507;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## iotHubResourceGetQuotaMetrics
  ## Get the quota metrics for an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_568516 = newJObject()
  var query_568517 = newJObject()
  add(path_568516, "resourceGroupName", newJString(resourceGroupName))
  add(query_568517, "api-version", newJString(apiVersion))
  add(path_568516, "subscriptionId", newJString(subscriptionId))
  add(path_568516, "resourceName", newJString(resourceName))
  result = call_568515.call(path_568516, query_568517, nil, nil, nil)

var iotHubResourceGetQuotaMetrics* = Call_IotHubResourceGetQuotaMetrics_568507(
    name: "iotHubResourceGetQuotaMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/quotaMetrics",
    validator: validate_IotHubResourceGetQuotaMetrics_568508, base: "",
    url: url_IotHubResourceGetQuotaMetrics_568509, schemes: {Scheme.Https})
type
  Call_IotHubResourceGetValidSkus_568518 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceGetValidSkus_568520(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceGetValidSkus_568519(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of valid SKUs for an IoT hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The name of the IoT hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568521 = path.getOrDefault("resourceGroupName")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "resourceGroupName", valid_568521
  var valid_568522 = path.getOrDefault("subscriptionId")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "subscriptionId", valid_568522
  var valid_568523 = path.getOrDefault("resourceName")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "resourceName", valid_568523
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568524 = query.getOrDefault("api-version")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "api-version", valid_568524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568525: Call_IotHubResourceGetValidSkus_568518; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of valid SKUs for an IoT hub.
  ## 
  let valid = call_568525.validator(path, query, header, formData, body)
  let scheme = call_568525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568525.url(scheme.get, call_568525.host, call_568525.base,
                         call_568525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568525, url, valid)

proc call*(call_568526: Call_IotHubResourceGetValidSkus_568518;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## iotHubResourceGetValidSkus
  ## Get the list of valid SKUs for an IoT hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The name of the IoT hub.
  var path_568527 = newJObject()
  var query_568528 = newJObject()
  add(path_568527, "resourceGroupName", newJString(resourceGroupName))
  add(query_568528, "api-version", newJString(apiVersion))
  add(path_568527, "subscriptionId", newJString(subscriptionId))
  add(path_568527, "resourceName", newJString(resourceName))
  result = call_568526.call(path_568527, query_568528, nil, nil, nil)

var iotHubResourceGetValidSkus* = Call_IotHubResourceGetValidSkus_568518(
    name: "iotHubResourceGetValidSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/skus",
    validator: validate_IotHubResourceGetValidSkus_568519, base: "",
    url: url_IotHubResourceGetValidSkus_568520, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
