
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: iotHubClient
## version: 2018-04-01
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
  Call_ResourceProviderCommonGetSubscriptionQuota_568218 = ref object of OpenApiRestCall_567666
proc url_ResourceProviderCommonGetSubscriptionQuota_568220(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceProviderCommonGetSubscriptionQuota_568219(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the number of free and paid iot hubs in the subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568221 = path.getOrDefault("subscriptionId")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "subscriptionId", valid_568221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568222 = query.getOrDefault("api-version")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "api-version", valid_568222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568223: Call_ResourceProviderCommonGetSubscriptionQuota_568218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the number of free and paid iot hubs in the subscription
  ## 
  let valid = call_568223.validator(path, query, header, formData, body)
  let scheme = call_568223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568223.url(scheme.get, call_568223.host, call_568223.base,
                         call_568223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568223, url, valid)

proc call*(call_568224: Call_ResourceProviderCommonGetSubscriptionQuota_568218;
          apiVersion: string; subscriptionId: string): Recallable =
  ## resourceProviderCommonGetSubscriptionQuota
  ## Get the number of free and paid iot hubs in the subscription
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568225 = newJObject()
  var query_568226 = newJObject()
  add(query_568226, "api-version", newJString(apiVersion))
  add(path_568225, "subscriptionId", newJString(subscriptionId))
  result = call_568224.call(path_568225, query_568226, nil, nil, nil)

var resourceProviderCommonGetSubscriptionQuota* = Call_ResourceProviderCommonGetSubscriptionQuota_568218(
    name: "resourceProviderCommonGetSubscriptionQuota", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Devices/usages",
    validator: validate_ResourceProviderCommonGetSubscriptionQuota_568219,
    base: "", url: url_ResourceProviderCommonGetSubscriptionQuota_568220,
    schemes: {Scheme.Https})
type
  Call_IotHubResourceListByResourceGroup_568227 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceListByResourceGroup_568229(protocol: Scheme; host: string;
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

proc validate_IotHubResourceListByResourceGroup_568228(path: JsonNode;
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
  var valid_568230 = path.getOrDefault("resourceGroupName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "resourceGroupName", valid_568230
  var valid_568231 = path.getOrDefault("subscriptionId")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "subscriptionId", valid_568231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568232 = query.getOrDefault("api-version")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "api-version", valid_568232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568233: Call_IotHubResourceListByResourceGroup_568227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all the IoT hubs in a resource group.
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_IotHubResourceListByResourceGroup_568227;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## iotHubResourceListByResourceGroup
  ## Get all the IoT hubs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT hub.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(path_568235, "resourceGroupName", newJString(resourceGroupName))
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var iotHubResourceListByResourceGroup* = Call_IotHubResourceListByResourceGroup_568227(
    name: "iotHubResourceListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs",
    validator: validate_IotHubResourceListByResourceGroup_568228, base: "",
    url: url_IotHubResourceListByResourceGroup_568229, schemes: {Scheme.Https})
type
  Call_IotHubResourceTestAllRoutes_568237 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceTestAllRoutes_568239(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "iotHubName" in path, "`iotHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "iotHubName"),
               (kind: ConstantSegment, value: "/routing/routes/$testall")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceTestAllRoutes_568238(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Test all routes configured in this Iot Hub
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : resource group which Iot Hub belongs to
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   iotHubName: JString (required)
  ##             : IotHub to be tested
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568240 = path.getOrDefault("resourceGroupName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "resourceGroupName", valid_568240
  var valid_568241 = path.getOrDefault("subscriptionId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "subscriptionId", valid_568241
  var valid_568242 = path.getOrDefault("iotHubName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "iotHubName", valid_568242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568243 = query.getOrDefault("api-version")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "api-version", valid_568243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Input for testing all routes
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568245: Call_IotHubResourceTestAllRoutes_568237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Test all routes configured in this Iot Hub
  ## 
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_IotHubResourceTestAllRoutes_568237;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; iotHubName: string): Recallable =
  ## iotHubResourceTestAllRoutes
  ## Test all routes configured in this Iot Hub
  ##   resourceGroupName: string (required)
  ##                    : resource group which Iot Hub belongs to
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   input: JObject (required)
  ##        : Input for testing all routes
  ##   iotHubName: string (required)
  ##             : IotHub to be tested
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  var body_568249 = newJObject()
  add(path_568247, "resourceGroupName", newJString(resourceGroupName))
  add(query_568248, "api-version", newJString(apiVersion))
  add(path_568247, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_568249 = input
  add(path_568247, "iotHubName", newJString(iotHubName))
  result = call_568246.call(path_568247, query_568248, nil, nil, body_568249)

var iotHubResourceTestAllRoutes* = Call_IotHubResourceTestAllRoutes_568237(
    name: "iotHubResourceTestAllRoutes", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{iotHubName}/routing/routes/$testall",
    validator: validate_IotHubResourceTestAllRoutes_568238, base: "",
    url: url_IotHubResourceTestAllRoutes_568239, schemes: {Scheme.Https})
type
  Call_IotHubResourceTestRoute_568250 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceTestRoute_568252(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "iotHubName" in path, "`iotHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "iotHubName"),
               (kind: ConstantSegment, value: "/routing/routes/$testnew")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceTestRoute_568251(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Test the new route for this Iot Hub
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : resource group which Iot Hub belongs to
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   iotHubName: JString (required)
  ##             : IotHub to be tested
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568253 = path.getOrDefault("resourceGroupName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "resourceGroupName", valid_568253
  var valid_568254 = path.getOrDefault("subscriptionId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "subscriptionId", valid_568254
  var valid_568255 = path.getOrDefault("iotHubName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "iotHubName", valid_568255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568256 = query.getOrDefault("api-version")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "api-version", valid_568256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Route that needs to be tested
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568258: Call_IotHubResourceTestRoute_568250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Test the new route for this Iot Hub
  ## 
  let valid = call_568258.validator(path, query, header, formData, body)
  let scheme = call_568258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568258.url(scheme.get, call_568258.host, call_568258.base,
                         call_568258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568258, url, valid)

proc call*(call_568259: Call_IotHubResourceTestRoute_568250;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; iotHubName: string): Recallable =
  ## iotHubResourceTestRoute
  ## Test the new route for this Iot Hub
  ##   resourceGroupName: string (required)
  ##                    : resource group which Iot Hub belongs to
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   input: JObject (required)
  ##        : Route that needs to be tested
  ##   iotHubName: string (required)
  ##             : IotHub to be tested
  var path_568260 = newJObject()
  var query_568261 = newJObject()
  var body_568262 = newJObject()
  add(path_568260, "resourceGroupName", newJString(resourceGroupName))
  add(query_568261, "api-version", newJString(apiVersion))
  add(path_568260, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_568262 = input
  add(path_568260, "iotHubName", newJString(iotHubName))
  result = call_568259.call(path_568260, query_568261, nil, nil, body_568262)

var iotHubResourceTestRoute* = Call_IotHubResourceTestRoute_568250(
    name: "iotHubResourceTestRoute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{iotHubName}/routing/routes/$testnew",
    validator: validate_IotHubResourceTestRoute_568251, base: "",
    url: url_IotHubResourceTestRoute_568252, schemes: {Scheme.Https})
type
  Call_IotHubResourceGetEndpointHealth_568263 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceGetEndpointHealth_568265(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "iotHubName" in path, "`iotHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Devices/IotHubs/"),
               (kind: VariableSegment, value: "iotHubName"),
               (kind: ConstantSegment, value: "/routingEndpointsHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotHubResourceGetEndpointHealth_568264(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the health for routing endpoints.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   iotHubName: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568266 = path.getOrDefault("resourceGroupName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "resourceGroupName", valid_568266
  var valid_568267 = path.getOrDefault("subscriptionId")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "subscriptionId", valid_568267
  var valid_568268 = path.getOrDefault("iotHubName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "iotHubName", valid_568268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568269 = query.getOrDefault("api-version")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "api-version", valid_568269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568270: Call_IotHubResourceGetEndpointHealth_568263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the health for routing endpoints.
  ## 
  let valid = call_568270.validator(path, query, header, formData, body)
  let scheme = call_568270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568270.url(scheme.get, call_568270.host, call_568270.base,
                         call_568270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568270, url, valid)

proc call*(call_568271: Call_IotHubResourceGetEndpointHealth_568263;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          iotHubName: string): Recallable =
  ## iotHubResourceGetEndpointHealth
  ## Get the health for routing endpoints.
  ##   resourceGroupName: string (required)
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   iotHubName: string (required)
  var path_568272 = newJObject()
  var query_568273 = newJObject()
  add(path_568272, "resourceGroupName", newJString(resourceGroupName))
  add(query_568273, "api-version", newJString(apiVersion))
  add(path_568272, "subscriptionId", newJString(subscriptionId))
  add(path_568272, "iotHubName", newJString(iotHubName))
  result = call_568271.call(path_568272, query_568273, nil, nil, nil)

var iotHubResourceGetEndpointHealth* = Call_IotHubResourceGetEndpointHealth_568263(
    name: "iotHubResourceGetEndpointHealth", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{iotHubName}/routingEndpointsHealth",
    validator: validate_IotHubResourceGetEndpointHealth_568264, base: "",
    url: url_IotHubResourceGetEndpointHealth_568265, schemes: {Scheme.Https})
type
  Call_IotHubResourceCreateOrUpdate_568285 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceCreateOrUpdate_568287(protocol: Scheme; host: string;
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

proc validate_IotHubResourceCreateOrUpdate_568286(path: JsonNode; query: JsonNode;
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
  var valid_568288 = path.getOrDefault("resourceGroupName")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "resourceGroupName", valid_568288
  var valid_568289 = path.getOrDefault("subscriptionId")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "subscriptionId", valid_568289
  var valid_568290 = path.getOrDefault("resourceName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "resourceName", valid_568290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568291 = query.getOrDefault("api-version")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "api-version", valid_568291
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the IoT Hub. Do not specify for creating a brand new IoT Hub. Required to update an existing IoT Hub.
  section = newJObject()
  var valid_568292 = header.getOrDefault("If-Match")
  valid_568292 = validateParameter(valid_568292, JString, required = false,
                                 default = nil)
  if valid_568292 != nil:
    section.add "If-Match", valid_568292
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

proc call*(call_568294: Call_IotHubResourceCreateOrUpdate_568285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the metadata of an Iot hub. The usual pattern to modify a property is to retrieve the IoT hub metadata and security metadata, and then combine them with the modified values in a new body to update the IoT hub.
  ## 
  let valid = call_568294.validator(path, query, header, formData, body)
  let scheme = call_568294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568294.url(scheme.get, call_568294.host, call_568294.base,
                         call_568294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568294, url, valid)

proc call*(call_568295: Call_IotHubResourceCreateOrUpdate_568285;
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
  var path_568296 = newJObject()
  var query_568297 = newJObject()
  var body_568298 = newJObject()
  add(path_568296, "resourceGroupName", newJString(resourceGroupName))
  add(query_568297, "api-version", newJString(apiVersion))
  add(path_568296, "subscriptionId", newJString(subscriptionId))
  add(path_568296, "resourceName", newJString(resourceName))
  if iotHubDescription != nil:
    body_568298 = iotHubDescription
  result = call_568295.call(path_568296, query_568297, nil, nil, body_568298)

var iotHubResourceCreateOrUpdate* = Call_IotHubResourceCreateOrUpdate_568285(
    name: "iotHubResourceCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}",
    validator: validate_IotHubResourceCreateOrUpdate_568286, base: "",
    url: url_IotHubResourceCreateOrUpdate_568287, schemes: {Scheme.Https})
type
  Call_IotHubResourceGet_568274 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceGet_568276(protocol: Scheme; host: string; base: string;
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

proc validate_IotHubResourceGet_568275(path: JsonNode; query: JsonNode;
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
  var valid_568277 = path.getOrDefault("resourceGroupName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "resourceGroupName", valid_568277
  var valid_568278 = path.getOrDefault("subscriptionId")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "subscriptionId", valid_568278
  var valid_568279 = path.getOrDefault("resourceName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "resourceName", valid_568279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568280 = query.getOrDefault("api-version")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "api-version", valid_568280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568281: Call_IotHubResourceGet_568274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the non-security related metadata of an IoT hub.
  ## 
  let valid = call_568281.validator(path, query, header, formData, body)
  let scheme = call_568281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568281.url(scheme.get, call_568281.host, call_568281.base,
                         call_568281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568281, url, valid)

proc call*(call_568282: Call_IotHubResourceGet_568274; resourceGroupName: string;
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
  var path_568283 = newJObject()
  var query_568284 = newJObject()
  add(path_568283, "resourceGroupName", newJString(resourceGroupName))
  add(query_568284, "api-version", newJString(apiVersion))
  add(path_568283, "subscriptionId", newJString(subscriptionId))
  add(path_568283, "resourceName", newJString(resourceName))
  result = call_568282.call(path_568283, query_568284, nil, nil, nil)

var iotHubResourceGet* = Call_IotHubResourceGet_568274(name: "iotHubResourceGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}",
    validator: validate_IotHubResourceGet_568275, base: "",
    url: url_IotHubResourceGet_568276, schemes: {Scheme.Https})
type
  Call_IotHubResourceUpdate_568310 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceUpdate_568312(protocol: Scheme; host: string; base: string;
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

proc validate_IotHubResourceUpdate_568311(path: JsonNode; query: JsonNode;
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
  var valid_568330 = path.getOrDefault("resourceGroupName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "resourceGroupName", valid_568330
  var valid_568331 = path.getOrDefault("subscriptionId")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "subscriptionId", valid_568331
  var valid_568332 = path.getOrDefault("resourceName")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "resourceName", valid_568332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
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
  ## parameters in `body` object:
  ##   IotHubTags: JObject (required)
  ##             : Updated tag information to set into the iot hub instance.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568335: Call_IotHubResourceUpdate_568310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing IoT Hub tags. to update other fields use the CreateOrUpdate method
  ## 
  let valid = call_568335.validator(path, query, header, formData, body)
  let scheme = call_568335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568335.url(scheme.get, call_568335.host, call_568335.base,
                         call_568335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568335, url, valid)

proc call*(call_568336: Call_IotHubResourceUpdate_568310;
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
  var path_568337 = newJObject()
  var query_568338 = newJObject()
  var body_568339 = newJObject()
  add(path_568337, "resourceGroupName", newJString(resourceGroupName))
  add(query_568338, "api-version", newJString(apiVersion))
  add(path_568337, "subscriptionId", newJString(subscriptionId))
  add(path_568337, "resourceName", newJString(resourceName))
  if IotHubTags != nil:
    body_568339 = IotHubTags
  result = call_568336.call(path_568337, query_568338, nil, nil, body_568339)

var iotHubResourceUpdate* = Call_IotHubResourceUpdate_568310(
    name: "iotHubResourceUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}",
    validator: validate_IotHubResourceUpdate_568311, base: "",
    url: url_IotHubResourceUpdate_568312, schemes: {Scheme.Https})
type
  Call_IotHubResourceDelete_568299 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceDelete_568301(protocol: Scheme; host: string; base: string;
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

proc validate_IotHubResourceDelete_568300(path: JsonNode; query: JsonNode;
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
  var valid_568302 = path.getOrDefault("resourceGroupName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "resourceGroupName", valid_568302
  var valid_568303 = path.getOrDefault("subscriptionId")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "subscriptionId", valid_568303
  var valid_568304 = path.getOrDefault("resourceName")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "resourceName", valid_568304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568305 = query.getOrDefault("api-version")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "api-version", valid_568305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568306: Call_IotHubResourceDelete_568299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an IoT hub.
  ## 
  let valid = call_568306.validator(path, query, header, formData, body)
  let scheme = call_568306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568306.url(scheme.get, call_568306.host, call_568306.base,
                         call_568306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568306, url, valid)

proc call*(call_568307: Call_IotHubResourceDelete_568299;
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
  var path_568308 = newJObject()
  var query_568309 = newJObject()
  add(path_568308, "resourceGroupName", newJString(resourceGroupName))
  add(query_568309, "api-version", newJString(apiVersion))
  add(path_568308, "subscriptionId", newJString(subscriptionId))
  add(path_568308, "resourceName", newJString(resourceName))
  result = call_568307.call(path_568308, query_568309, nil, nil, nil)

var iotHubResourceDelete* = Call_IotHubResourceDelete_568299(
    name: "iotHubResourceDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}",
    validator: validate_IotHubResourceDelete_568300, base: "",
    url: url_IotHubResourceDelete_568301, schemes: {Scheme.Https})
type
  Call_IotHubResourceGetKeysForKeyName_568340 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceGetKeysForKeyName_568342(protocol: Scheme; host: string;
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

proc validate_IotHubResourceGetKeysForKeyName_568341(path: JsonNode;
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
  var valid_568343 = path.getOrDefault("resourceGroupName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "resourceGroupName", valid_568343
  var valid_568344 = path.getOrDefault("keyName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "keyName", valid_568344
  var valid_568345 = path.getOrDefault("subscriptionId")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "subscriptionId", valid_568345
  var valid_568346 = path.getOrDefault("resourceName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "resourceName", valid_568346
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
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568348: Call_IotHubResourceGetKeysForKeyName_568340;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a shared access policy by name from an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-security.
  ## 
  let valid = call_568348.validator(path, query, header, formData, body)
  let scheme = call_568348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568348.url(scheme.get, call_568348.host, call_568348.base,
                         call_568348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568348, url, valid)

proc call*(call_568349: Call_IotHubResourceGetKeysForKeyName_568340;
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
  var path_568350 = newJObject()
  var query_568351 = newJObject()
  add(path_568350, "resourceGroupName", newJString(resourceGroupName))
  add(query_568351, "api-version", newJString(apiVersion))
  add(path_568350, "keyName", newJString(keyName))
  add(path_568350, "subscriptionId", newJString(subscriptionId))
  add(path_568350, "resourceName", newJString(resourceName))
  result = call_568349.call(path_568350, query_568351, nil, nil, nil)

var iotHubResourceGetKeysForKeyName* = Call_IotHubResourceGetKeysForKeyName_568340(
    name: "iotHubResourceGetKeysForKeyName", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/IotHubKeys/{keyName}/listkeys",
    validator: validate_IotHubResourceGetKeysForKeyName_568341, base: "",
    url: url_IotHubResourceGetKeysForKeyName_568342, schemes: {Scheme.Https})
type
  Call_IotHubResourceGetStats_568352 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceGetStats_568354(protocol: Scheme; host: string; base: string;
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

proc validate_IotHubResourceGetStats_568353(path: JsonNode; query: JsonNode;
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
  var valid_568355 = path.getOrDefault("resourceGroupName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "resourceGroupName", valid_568355
  var valid_568356 = path.getOrDefault("subscriptionId")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "subscriptionId", valid_568356
  var valid_568357 = path.getOrDefault("resourceName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "resourceName", valid_568357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
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

proc call*(call_568359: Call_IotHubResourceGetStats_568352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the statistics from an IoT hub.
  ## 
  let valid = call_568359.validator(path, query, header, formData, body)
  let scheme = call_568359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568359.url(scheme.get, call_568359.host, call_568359.base,
                         call_568359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568359, url, valid)

proc call*(call_568360: Call_IotHubResourceGetStats_568352;
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
  var path_568361 = newJObject()
  var query_568362 = newJObject()
  add(path_568361, "resourceGroupName", newJString(resourceGroupName))
  add(query_568362, "api-version", newJString(apiVersion))
  add(path_568361, "subscriptionId", newJString(subscriptionId))
  add(path_568361, "resourceName", newJString(resourceName))
  result = call_568360.call(path_568361, query_568362, nil, nil, nil)

var iotHubResourceGetStats* = Call_IotHubResourceGetStats_568352(
    name: "iotHubResourceGetStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/IotHubStats",
    validator: validate_IotHubResourceGetStats_568353, base: "",
    url: url_IotHubResourceGetStats_568354, schemes: {Scheme.Https})
type
  Call_CertificatesListByIotHub_568363 = ref object of OpenApiRestCall_567666
proc url_CertificatesListByIotHub_568365(protocol: Scheme; host: string;
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

proc validate_CertificatesListByIotHub_568364(path: JsonNode; query: JsonNode;
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
  var valid_568366 = path.getOrDefault("resourceGroupName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "resourceGroupName", valid_568366
  var valid_568367 = path.getOrDefault("subscriptionId")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "subscriptionId", valid_568367
  var valid_568368 = path.getOrDefault("resourceName")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "resourceName", valid_568368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568369 = query.getOrDefault("api-version")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "api-version", valid_568369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568370: Call_CertificatesListByIotHub_568363; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of certificates.
  ## 
  let valid = call_568370.validator(path, query, header, formData, body)
  let scheme = call_568370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568370.url(scheme.get, call_568370.host, call_568370.base,
                         call_568370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568370, url, valid)

proc call*(call_568371: Call_CertificatesListByIotHub_568363;
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
  var path_568372 = newJObject()
  var query_568373 = newJObject()
  add(path_568372, "resourceGroupName", newJString(resourceGroupName))
  add(query_568373, "api-version", newJString(apiVersion))
  add(path_568372, "subscriptionId", newJString(subscriptionId))
  add(path_568372, "resourceName", newJString(resourceName))
  result = call_568371.call(path_568372, query_568373, nil, nil, nil)

var certificatesListByIotHub* = Call_CertificatesListByIotHub_568363(
    name: "certificatesListByIotHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates",
    validator: validate_CertificatesListByIotHub_568364, base: "",
    url: url_CertificatesListByIotHub_568365, schemes: {Scheme.Https})
type
  Call_CertificatesCreateOrUpdate_568386 = ref object of OpenApiRestCall_567666
proc url_CertificatesCreateOrUpdate_568388(protocol: Scheme; host: string;
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

proc validate_CertificatesCreateOrUpdate_568387(path: JsonNode; query: JsonNode;
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
  var valid_568389 = path.getOrDefault("resourceGroupName")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "resourceGroupName", valid_568389
  var valid_568390 = path.getOrDefault("subscriptionId")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "subscriptionId", valid_568390
  var valid_568391 = path.getOrDefault("resourceName")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "resourceName", valid_568391
  var valid_568392 = path.getOrDefault("certificateName")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "certificateName", valid_568392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568393 = query.getOrDefault("api-version")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "api-version", valid_568393
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Certificate. Do not specify for creating a brand new certificate. Required to update an existing certificate.
  section = newJObject()
  var valid_568394 = header.getOrDefault("If-Match")
  valid_568394 = validateParameter(valid_568394, JString, required = false,
                                 default = nil)
  if valid_568394 != nil:
    section.add "If-Match", valid_568394
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

proc call*(call_568396: Call_CertificatesCreateOrUpdate_568386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds new or replaces existing certificate.
  ## 
  let valid = call_568396.validator(path, query, header, formData, body)
  let scheme = call_568396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568396.url(scheme.get, call_568396.host, call_568396.base,
                         call_568396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568396, url, valid)

proc call*(call_568397: Call_CertificatesCreateOrUpdate_568386;
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
  var path_568398 = newJObject()
  var query_568399 = newJObject()
  var body_568400 = newJObject()
  add(path_568398, "resourceGroupName", newJString(resourceGroupName))
  add(query_568399, "api-version", newJString(apiVersion))
  add(path_568398, "subscriptionId", newJString(subscriptionId))
  add(path_568398, "resourceName", newJString(resourceName))
  add(path_568398, "certificateName", newJString(certificateName))
  if certificateDescription != nil:
    body_568400 = certificateDescription
  result = call_568397.call(path_568398, query_568399, nil, nil, body_568400)

var certificatesCreateOrUpdate* = Call_CertificatesCreateOrUpdate_568386(
    name: "certificatesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates/{certificateName}",
    validator: validate_CertificatesCreateOrUpdate_568387, base: "",
    url: url_CertificatesCreateOrUpdate_568388, schemes: {Scheme.Https})
type
  Call_CertificatesGet_568374 = ref object of OpenApiRestCall_567666
proc url_CertificatesGet_568376(protocol: Scheme; host: string; base: string;
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

proc validate_CertificatesGet_568375(path: JsonNode; query: JsonNode;
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
  var valid_568377 = path.getOrDefault("resourceGroupName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "resourceGroupName", valid_568377
  var valid_568378 = path.getOrDefault("subscriptionId")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "subscriptionId", valid_568378
  var valid_568379 = path.getOrDefault("resourceName")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "resourceName", valid_568379
  var valid_568380 = path.getOrDefault("certificateName")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "certificateName", valid_568380
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568381 = query.getOrDefault("api-version")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "api-version", valid_568381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568382: Call_CertificatesGet_568374; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the certificate.
  ## 
  let valid = call_568382.validator(path, query, header, formData, body)
  let scheme = call_568382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568382.url(scheme.get, call_568382.host, call_568382.base,
                         call_568382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568382, url, valid)

proc call*(call_568383: Call_CertificatesGet_568374; resourceGroupName: string;
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
  var path_568384 = newJObject()
  var query_568385 = newJObject()
  add(path_568384, "resourceGroupName", newJString(resourceGroupName))
  add(query_568385, "api-version", newJString(apiVersion))
  add(path_568384, "subscriptionId", newJString(subscriptionId))
  add(path_568384, "resourceName", newJString(resourceName))
  add(path_568384, "certificateName", newJString(certificateName))
  result = call_568383.call(path_568384, query_568385, nil, nil, nil)

var certificatesGet* = Call_CertificatesGet_568374(name: "certificatesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates/{certificateName}",
    validator: validate_CertificatesGet_568375, base: "", url: url_CertificatesGet_568376,
    schemes: {Scheme.Https})
type
  Call_CertificatesDelete_568401 = ref object of OpenApiRestCall_567666
proc url_CertificatesDelete_568403(protocol: Scheme; host: string; base: string;
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

proc validate_CertificatesDelete_568402(path: JsonNode; query: JsonNode;
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
  var valid_568404 = path.getOrDefault("resourceGroupName")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "resourceGroupName", valid_568404
  var valid_568405 = path.getOrDefault("subscriptionId")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "subscriptionId", valid_568405
  var valid_568406 = path.getOrDefault("resourceName")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "resourceName", valid_568406
  var valid_568407 = path.getOrDefault("certificateName")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "certificateName", valid_568407
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
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Certificate.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_568409 = header.getOrDefault("If-Match")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "If-Match", valid_568409
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568410: Call_CertificatesDelete_568401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing X509 certificate or does nothing if it does not exist.
  ## 
  let valid = call_568410.validator(path, query, header, formData, body)
  let scheme = call_568410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568410.url(scheme.get, call_568410.host, call_568410.base,
                         call_568410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568410, url, valid)

proc call*(call_568411: Call_CertificatesDelete_568401; resourceGroupName: string;
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
  var path_568412 = newJObject()
  var query_568413 = newJObject()
  add(path_568412, "resourceGroupName", newJString(resourceGroupName))
  add(query_568413, "api-version", newJString(apiVersion))
  add(path_568412, "subscriptionId", newJString(subscriptionId))
  add(path_568412, "resourceName", newJString(resourceName))
  add(path_568412, "certificateName", newJString(certificateName))
  result = call_568411.call(path_568412, query_568413, nil, nil, nil)

var certificatesDelete* = Call_CertificatesDelete_568401(
    name: "certificatesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates/{certificateName}",
    validator: validate_CertificatesDelete_568402, base: "",
    url: url_CertificatesDelete_568403, schemes: {Scheme.Https})
type
  Call_CertificatesGenerateVerificationCode_568414 = ref object of OpenApiRestCall_567666
proc url_CertificatesGenerateVerificationCode_568416(protocol: Scheme;
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

proc validate_CertificatesGenerateVerificationCode_568415(path: JsonNode;
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
  var valid_568417 = path.getOrDefault("resourceGroupName")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "resourceGroupName", valid_568417
  var valid_568418 = path.getOrDefault("subscriptionId")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "subscriptionId", valid_568418
  var valid_568419 = path.getOrDefault("resourceName")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "resourceName", valid_568419
  var valid_568420 = path.getOrDefault("certificateName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "certificateName", valid_568420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568421 = query.getOrDefault("api-version")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "api-version", valid_568421
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Certificate.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_568422 = header.getOrDefault("If-Match")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "If-Match", valid_568422
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568423: Call_CertificatesGenerateVerificationCode_568414;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates verification code for proof of possession flow. The verification code will be used to generate a leaf certificate.
  ## 
  let valid = call_568423.validator(path, query, header, formData, body)
  let scheme = call_568423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568423.url(scheme.get, call_568423.host, call_568423.base,
                         call_568423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568423, url, valid)

proc call*(call_568424: Call_CertificatesGenerateVerificationCode_568414;
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
  var path_568425 = newJObject()
  var query_568426 = newJObject()
  add(path_568425, "resourceGroupName", newJString(resourceGroupName))
  add(query_568426, "api-version", newJString(apiVersion))
  add(path_568425, "subscriptionId", newJString(subscriptionId))
  add(path_568425, "resourceName", newJString(resourceName))
  add(path_568425, "certificateName", newJString(certificateName))
  result = call_568424.call(path_568425, query_568426, nil, nil, nil)

var certificatesGenerateVerificationCode* = Call_CertificatesGenerateVerificationCode_568414(
    name: "certificatesGenerateVerificationCode", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates/{certificateName}/generateVerificationCode",
    validator: validate_CertificatesGenerateVerificationCode_568415, base: "",
    url: url_CertificatesGenerateVerificationCode_568416, schemes: {Scheme.Https})
type
  Call_CertificatesVerify_568427 = ref object of OpenApiRestCall_567666
proc url_CertificatesVerify_568429(protocol: Scheme; host: string; base: string;
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

proc validate_CertificatesVerify_568428(path: JsonNode; query: JsonNode;
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
  var valid_568430 = path.getOrDefault("resourceGroupName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "resourceGroupName", valid_568430
  var valid_568431 = path.getOrDefault("subscriptionId")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "subscriptionId", valid_568431
  var valid_568432 = path.getOrDefault("resourceName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "resourceName", valid_568432
  var valid_568433 = path.getOrDefault("certificateName")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "certificateName", valid_568433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568434 = query.getOrDefault("api-version")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "api-version", valid_568434
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Certificate.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_568435 = header.getOrDefault("If-Match")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "If-Match", valid_568435
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

proc call*(call_568437: Call_CertificatesVerify_568427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verifies the certificate's private key possession by providing the leaf cert issued by the verifying pre uploaded certificate.
  ## 
  let valid = call_568437.validator(path, query, header, formData, body)
  let scheme = call_568437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568437.url(scheme.get, call_568437.host, call_568437.base,
                         call_568437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568437, url, valid)

proc call*(call_568438: Call_CertificatesVerify_568427; resourceGroupName: string;
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
  var path_568439 = newJObject()
  var query_568440 = newJObject()
  var body_568441 = newJObject()
  add(path_568439, "resourceGroupName", newJString(resourceGroupName))
  add(query_568440, "api-version", newJString(apiVersion))
  add(path_568439, "subscriptionId", newJString(subscriptionId))
  add(path_568439, "resourceName", newJString(resourceName))
  add(path_568439, "certificateName", newJString(certificateName))
  if certificateVerificationBody != nil:
    body_568441 = certificateVerificationBody
  result = call_568438.call(path_568439, query_568440, nil, nil, body_568441)

var certificatesVerify* = Call_CertificatesVerify_568427(
    name: "certificatesVerify", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/certificates/{certificateName}/verify",
    validator: validate_CertificatesVerify_568428, base: "",
    url: url_CertificatesVerify_568429, schemes: {Scheme.Https})
type
  Call_IotHubResourceListEventHubConsumerGroups_568442 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceListEventHubConsumerGroups_568444(protocol: Scheme;
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

proc validate_IotHubResourceListEventHubConsumerGroups_568443(path: JsonNode;
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
  var valid_568445 = path.getOrDefault("resourceGroupName")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "resourceGroupName", valid_568445
  var valid_568446 = path.getOrDefault("eventHubEndpointName")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "eventHubEndpointName", valid_568446
  var valid_568447 = path.getOrDefault("subscriptionId")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "subscriptionId", valid_568447
  var valid_568448 = path.getOrDefault("resourceName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "resourceName", valid_568448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568449 = query.getOrDefault("api-version")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "api-version", valid_568449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568450: Call_IotHubResourceListEventHubConsumerGroups_568442;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a list of the consumer groups in the Event Hub-compatible device-to-cloud endpoint in an IoT hub.
  ## 
  let valid = call_568450.validator(path, query, header, formData, body)
  let scheme = call_568450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568450.url(scheme.get, call_568450.host, call_568450.base,
                         call_568450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568450, url, valid)

proc call*(call_568451: Call_IotHubResourceListEventHubConsumerGroups_568442;
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
  var path_568452 = newJObject()
  var query_568453 = newJObject()
  add(path_568452, "resourceGroupName", newJString(resourceGroupName))
  add(query_568453, "api-version", newJString(apiVersion))
  add(path_568452, "eventHubEndpointName", newJString(eventHubEndpointName))
  add(path_568452, "subscriptionId", newJString(subscriptionId))
  add(path_568452, "resourceName", newJString(resourceName))
  result = call_568451.call(path_568452, query_568453, nil, nil, nil)

var iotHubResourceListEventHubConsumerGroups* = Call_IotHubResourceListEventHubConsumerGroups_568442(
    name: "iotHubResourceListEventHubConsumerGroups", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/eventHubEndpoints/{eventHubEndpointName}/ConsumerGroups",
    validator: validate_IotHubResourceListEventHubConsumerGroups_568443, base: "",
    url: url_IotHubResourceListEventHubConsumerGroups_568444,
    schemes: {Scheme.Https})
type
  Call_IotHubResourceCreateEventHubConsumerGroup_568467 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceCreateEventHubConsumerGroup_568469(protocol: Scheme;
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

proc validate_IotHubResourceCreateEventHubConsumerGroup_568468(path: JsonNode;
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
  var valid_568470 = path.getOrDefault("resourceGroupName")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "resourceGroupName", valid_568470
  var valid_568471 = path.getOrDefault("name")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "name", valid_568471
  var valid_568472 = path.getOrDefault("eventHubEndpointName")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "eventHubEndpointName", valid_568472
  var valid_568473 = path.getOrDefault("subscriptionId")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "subscriptionId", valid_568473
  var valid_568474 = path.getOrDefault("resourceName")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "resourceName", valid_568474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568475 = query.getOrDefault("api-version")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "api-version", valid_568475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568476: Call_IotHubResourceCreateEventHubConsumerGroup_568467;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a consumer group to an Event Hub-compatible endpoint in an IoT hub.
  ## 
  let valid = call_568476.validator(path, query, header, formData, body)
  let scheme = call_568476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568476.url(scheme.get, call_568476.host, call_568476.base,
                         call_568476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568476, url, valid)

proc call*(call_568477: Call_IotHubResourceCreateEventHubConsumerGroup_568467;
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
  var path_568478 = newJObject()
  var query_568479 = newJObject()
  add(path_568478, "resourceGroupName", newJString(resourceGroupName))
  add(query_568479, "api-version", newJString(apiVersion))
  add(path_568478, "name", newJString(name))
  add(path_568478, "eventHubEndpointName", newJString(eventHubEndpointName))
  add(path_568478, "subscriptionId", newJString(subscriptionId))
  add(path_568478, "resourceName", newJString(resourceName))
  result = call_568477.call(path_568478, query_568479, nil, nil, nil)

var iotHubResourceCreateEventHubConsumerGroup* = Call_IotHubResourceCreateEventHubConsumerGroup_568467(
    name: "iotHubResourceCreateEventHubConsumerGroup", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/eventHubEndpoints/{eventHubEndpointName}/ConsumerGroups/{name}",
    validator: validate_IotHubResourceCreateEventHubConsumerGroup_568468,
    base: "", url: url_IotHubResourceCreateEventHubConsumerGroup_568469,
    schemes: {Scheme.Https})
type
  Call_IotHubResourceGetEventHubConsumerGroup_568454 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceGetEventHubConsumerGroup_568456(protocol: Scheme;
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

proc validate_IotHubResourceGetEventHubConsumerGroup_568455(path: JsonNode;
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
  var valid_568457 = path.getOrDefault("resourceGroupName")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "resourceGroupName", valid_568457
  var valid_568458 = path.getOrDefault("name")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "name", valid_568458
  var valid_568459 = path.getOrDefault("eventHubEndpointName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "eventHubEndpointName", valid_568459
  var valid_568460 = path.getOrDefault("subscriptionId")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "subscriptionId", valid_568460
  var valid_568461 = path.getOrDefault("resourceName")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "resourceName", valid_568461
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568462 = query.getOrDefault("api-version")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "api-version", valid_568462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568463: Call_IotHubResourceGetEventHubConsumerGroup_568454;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a consumer group from the Event Hub-compatible device-to-cloud endpoint for an IoT hub.
  ## 
  let valid = call_568463.validator(path, query, header, formData, body)
  let scheme = call_568463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568463.url(scheme.get, call_568463.host, call_568463.base,
                         call_568463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568463, url, valid)

proc call*(call_568464: Call_IotHubResourceGetEventHubConsumerGroup_568454;
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
  var path_568465 = newJObject()
  var query_568466 = newJObject()
  add(path_568465, "resourceGroupName", newJString(resourceGroupName))
  add(query_568466, "api-version", newJString(apiVersion))
  add(path_568465, "name", newJString(name))
  add(path_568465, "eventHubEndpointName", newJString(eventHubEndpointName))
  add(path_568465, "subscriptionId", newJString(subscriptionId))
  add(path_568465, "resourceName", newJString(resourceName))
  result = call_568464.call(path_568465, query_568466, nil, nil, nil)

var iotHubResourceGetEventHubConsumerGroup* = Call_IotHubResourceGetEventHubConsumerGroup_568454(
    name: "iotHubResourceGetEventHubConsumerGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/eventHubEndpoints/{eventHubEndpointName}/ConsumerGroups/{name}",
    validator: validate_IotHubResourceGetEventHubConsumerGroup_568455, base: "",
    url: url_IotHubResourceGetEventHubConsumerGroup_568456,
    schemes: {Scheme.Https})
type
  Call_IotHubResourceDeleteEventHubConsumerGroup_568480 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceDeleteEventHubConsumerGroup_568482(protocol: Scheme;
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

proc validate_IotHubResourceDeleteEventHubConsumerGroup_568481(path: JsonNode;
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
  var valid_568483 = path.getOrDefault("resourceGroupName")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "resourceGroupName", valid_568483
  var valid_568484 = path.getOrDefault("name")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "name", valid_568484
  var valid_568485 = path.getOrDefault("eventHubEndpointName")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "eventHubEndpointName", valid_568485
  var valid_568486 = path.getOrDefault("subscriptionId")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "subscriptionId", valid_568486
  var valid_568487 = path.getOrDefault("resourceName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "resourceName", valid_568487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568488 = query.getOrDefault("api-version")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "api-version", valid_568488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568489: Call_IotHubResourceDeleteEventHubConsumerGroup_568480;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a consumer group from an Event Hub-compatible endpoint in an IoT hub.
  ## 
  let valid = call_568489.validator(path, query, header, formData, body)
  let scheme = call_568489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568489.url(scheme.get, call_568489.host, call_568489.base,
                         call_568489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568489, url, valid)

proc call*(call_568490: Call_IotHubResourceDeleteEventHubConsumerGroup_568480;
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
  var path_568491 = newJObject()
  var query_568492 = newJObject()
  add(path_568491, "resourceGroupName", newJString(resourceGroupName))
  add(query_568492, "api-version", newJString(apiVersion))
  add(path_568491, "name", newJString(name))
  add(path_568491, "eventHubEndpointName", newJString(eventHubEndpointName))
  add(path_568491, "subscriptionId", newJString(subscriptionId))
  add(path_568491, "resourceName", newJString(resourceName))
  result = call_568490.call(path_568491, query_568492, nil, nil, nil)

var iotHubResourceDeleteEventHubConsumerGroup* = Call_IotHubResourceDeleteEventHubConsumerGroup_568480(
    name: "iotHubResourceDeleteEventHubConsumerGroup",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/eventHubEndpoints/{eventHubEndpointName}/ConsumerGroups/{name}",
    validator: validate_IotHubResourceDeleteEventHubConsumerGroup_568481,
    base: "", url: url_IotHubResourceDeleteEventHubConsumerGroup_568482,
    schemes: {Scheme.Https})
type
  Call_IotHubResourceExportDevices_568493 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceExportDevices_568495(protocol: Scheme; host: string;
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

proc validate_IotHubResourceExportDevices_568494(path: JsonNode; query: JsonNode;
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
  var valid_568496 = path.getOrDefault("resourceGroupName")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "resourceGroupName", valid_568496
  var valid_568497 = path.getOrDefault("subscriptionId")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "subscriptionId", valid_568497
  var valid_568498 = path.getOrDefault("resourceName")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "resourceName", valid_568498
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568499 = query.getOrDefault("api-version")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "api-version", valid_568499
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

proc call*(call_568501: Call_IotHubResourceExportDevices_568493; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports all the device identities in the IoT hub identity registry to an Azure Storage blob container. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry#import-and-export-device-identities.
  ## 
  let valid = call_568501.validator(path, query, header, formData, body)
  let scheme = call_568501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568501.url(scheme.get, call_568501.host, call_568501.base,
                         call_568501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568501, url, valid)

proc call*(call_568502: Call_IotHubResourceExportDevices_568493;
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
  var path_568503 = newJObject()
  var query_568504 = newJObject()
  var body_568505 = newJObject()
  add(path_568503, "resourceGroupName", newJString(resourceGroupName))
  add(query_568504, "api-version", newJString(apiVersion))
  add(path_568503, "subscriptionId", newJString(subscriptionId))
  add(path_568503, "resourceName", newJString(resourceName))
  if exportDevicesParameters != nil:
    body_568505 = exportDevicesParameters
  result = call_568502.call(path_568503, query_568504, nil, nil, body_568505)

var iotHubResourceExportDevices* = Call_IotHubResourceExportDevices_568493(
    name: "iotHubResourceExportDevices", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/exportDevices",
    validator: validate_IotHubResourceExportDevices_568494, base: "",
    url: url_IotHubResourceExportDevices_568495, schemes: {Scheme.Https})
type
  Call_IotHubResourceImportDevices_568506 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceImportDevices_568508(protocol: Scheme; host: string;
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

proc validate_IotHubResourceImportDevices_568507(path: JsonNode; query: JsonNode;
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
  var valid_568509 = path.getOrDefault("resourceGroupName")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "resourceGroupName", valid_568509
  var valid_568510 = path.getOrDefault("subscriptionId")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "subscriptionId", valid_568510
  var valid_568511 = path.getOrDefault("resourceName")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "resourceName", valid_568511
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568512 = query.getOrDefault("api-version")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "api-version", valid_568512
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

proc call*(call_568514: Call_IotHubResourceImportDevices_568506; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Import, update, or delete device identities in the IoT hub identity registry from a blob. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry#import-and-export-device-identities.
  ## 
  let valid = call_568514.validator(path, query, header, formData, body)
  let scheme = call_568514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568514.url(scheme.get, call_568514.host, call_568514.base,
                         call_568514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568514, url, valid)

proc call*(call_568515: Call_IotHubResourceImportDevices_568506;
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
  var path_568516 = newJObject()
  var query_568517 = newJObject()
  var body_568518 = newJObject()
  add(path_568516, "resourceGroupName", newJString(resourceGroupName))
  add(query_568517, "api-version", newJString(apiVersion))
  if importDevicesParameters != nil:
    body_568518 = importDevicesParameters
  add(path_568516, "subscriptionId", newJString(subscriptionId))
  add(path_568516, "resourceName", newJString(resourceName))
  result = call_568515.call(path_568516, query_568517, nil, nil, body_568518)

var iotHubResourceImportDevices* = Call_IotHubResourceImportDevices_568506(
    name: "iotHubResourceImportDevices", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/importDevices",
    validator: validate_IotHubResourceImportDevices_568507, base: "",
    url: url_IotHubResourceImportDevices_568508, schemes: {Scheme.Https})
type
  Call_IotHubResourceListJobs_568519 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceListJobs_568521(protocol: Scheme; host: string; base: string;
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

proc validate_IotHubResourceListJobs_568520(path: JsonNode; query: JsonNode;
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
  var valid_568522 = path.getOrDefault("resourceGroupName")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "resourceGroupName", valid_568522
  var valid_568523 = path.getOrDefault("subscriptionId")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "subscriptionId", valid_568523
  var valid_568524 = path.getOrDefault("resourceName")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "resourceName", valid_568524
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568525 = query.getOrDefault("api-version")
  valid_568525 = validateParameter(valid_568525, JString, required = true,
                                 default = nil)
  if valid_568525 != nil:
    section.add "api-version", valid_568525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568526: Call_IotHubResourceListJobs_568519; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of all the jobs in an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry.
  ## 
  let valid = call_568526.validator(path, query, header, formData, body)
  let scheme = call_568526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568526.url(scheme.get, call_568526.host, call_568526.base,
                         call_568526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568526, url, valid)

proc call*(call_568527: Call_IotHubResourceListJobs_568519;
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
  var path_568528 = newJObject()
  var query_568529 = newJObject()
  add(path_568528, "resourceGroupName", newJString(resourceGroupName))
  add(query_568529, "api-version", newJString(apiVersion))
  add(path_568528, "subscriptionId", newJString(subscriptionId))
  add(path_568528, "resourceName", newJString(resourceName))
  result = call_568527.call(path_568528, query_568529, nil, nil, nil)

var iotHubResourceListJobs* = Call_IotHubResourceListJobs_568519(
    name: "iotHubResourceListJobs", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/jobs",
    validator: validate_IotHubResourceListJobs_568520, base: "",
    url: url_IotHubResourceListJobs_568521, schemes: {Scheme.Https})
type
  Call_IotHubResourceGetJob_568530 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceGetJob_568532(protocol: Scheme; host: string; base: string;
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

proc validate_IotHubResourceGetJob_568531(path: JsonNode; query: JsonNode;
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
  var valid_568533 = path.getOrDefault("resourceGroupName")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "resourceGroupName", valid_568533
  var valid_568534 = path.getOrDefault("jobId")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "jobId", valid_568534
  var valid_568535 = path.getOrDefault("subscriptionId")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "subscriptionId", valid_568535
  var valid_568536 = path.getOrDefault("resourceName")
  valid_568536 = validateParameter(valid_568536, JString, required = true,
                                 default = nil)
  if valid_568536 != nil:
    section.add "resourceName", valid_568536
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568537 = query.getOrDefault("api-version")
  valid_568537 = validateParameter(valid_568537, JString, required = true,
                                 default = nil)
  if valid_568537 != nil:
    section.add "api-version", valid_568537
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568538: Call_IotHubResourceGetJob_568530; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of a job from an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry.
  ## 
  let valid = call_568538.validator(path, query, header, formData, body)
  let scheme = call_568538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568538.url(scheme.get, call_568538.host, call_568538.base,
                         call_568538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568538, url, valid)

proc call*(call_568539: Call_IotHubResourceGetJob_568530;
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
  var path_568540 = newJObject()
  var query_568541 = newJObject()
  add(path_568540, "resourceGroupName", newJString(resourceGroupName))
  add(query_568541, "api-version", newJString(apiVersion))
  add(path_568540, "jobId", newJString(jobId))
  add(path_568540, "subscriptionId", newJString(subscriptionId))
  add(path_568540, "resourceName", newJString(resourceName))
  result = call_568539.call(path_568540, query_568541, nil, nil, nil)

var iotHubResourceGetJob* = Call_IotHubResourceGetJob_568530(
    name: "iotHubResourceGetJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/jobs/{jobId}",
    validator: validate_IotHubResourceGetJob_568531, base: "",
    url: url_IotHubResourceGetJob_568532, schemes: {Scheme.Https})
type
  Call_IotHubResourceListKeys_568542 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceListKeys_568544(protocol: Scheme; host: string; base: string;
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

proc validate_IotHubResourceListKeys_568543(path: JsonNode; query: JsonNode;
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
  var valid_568545 = path.getOrDefault("resourceGroupName")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "resourceGroupName", valid_568545
  var valid_568546 = path.getOrDefault("subscriptionId")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "subscriptionId", valid_568546
  var valid_568547 = path.getOrDefault("resourceName")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "resourceName", valid_568547
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568548 = query.getOrDefault("api-version")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "api-version", valid_568548
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568549: Call_IotHubResourceListKeys_568542; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the security metadata for an IoT hub. For more information, see: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-security.
  ## 
  let valid = call_568549.validator(path, query, header, formData, body)
  let scheme = call_568549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568549.url(scheme.get, call_568549.host, call_568549.base,
                         call_568549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568549, url, valid)

proc call*(call_568550: Call_IotHubResourceListKeys_568542;
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
  var path_568551 = newJObject()
  var query_568552 = newJObject()
  add(path_568551, "resourceGroupName", newJString(resourceGroupName))
  add(query_568552, "api-version", newJString(apiVersion))
  add(path_568551, "subscriptionId", newJString(subscriptionId))
  add(path_568551, "resourceName", newJString(resourceName))
  result = call_568550.call(path_568551, query_568552, nil, nil, nil)

var iotHubResourceListKeys* = Call_IotHubResourceListKeys_568542(
    name: "iotHubResourceListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/listkeys",
    validator: validate_IotHubResourceListKeys_568543, base: "",
    url: url_IotHubResourceListKeys_568544, schemes: {Scheme.Https})
type
  Call_IotHubResourceGetQuotaMetrics_568553 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceGetQuotaMetrics_568555(protocol: Scheme; host: string;
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

proc validate_IotHubResourceGetQuotaMetrics_568554(path: JsonNode; query: JsonNode;
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
  var valid_568556 = path.getOrDefault("resourceGroupName")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "resourceGroupName", valid_568556
  var valid_568557 = path.getOrDefault("subscriptionId")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "subscriptionId", valid_568557
  var valid_568558 = path.getOrDefault("resourceName")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "resourceName", valid_568558
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568559 = query.getOrDefault("api-version")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "api-version", valid_568559
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568560: Call_IotHubResourceGetQuotaMetrics_568553; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the quota metrics for an IoT hub.
  ## 
  let valid = call_568560.validator(path, query, header, formData, body)
  let scheme = call_568560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568560.url(scheme.get, call_568560.host, call_568560.base,
                         call_568560.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568560, url, valid)

proc call*(call_568561: Call_IotHubResourceGetQuotaMetrics_568553;
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
  var path_568562 = newJObject()
  var query_568563 = newJObject()
  add(path_568562, "resourceGroupName", newJString(resourceGroupName))
  add(query_568563, "api-version", newJString(apiVersion))
  add(path_568562, "subscriptionId", newJString(subscriptionId))
  add(path_568562, "resourceName", newJString(resourceName))
  result = call_568561.call(path_568562, query_568563, nil, nil, nil)

var iotHubResourceGetQuotaMetrics* = Call_IotHubResourceGetQuotaMetrics_568553(
    name: "iotHubResourceGetQuotaMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/quotaMetrics",
    validator: validate_IotHubResourceGetQuotaMetrics_568554, base: "",
    url: url_IotHubResourceGetQuotaMetrics_568555, schemes: {Scheme.Https})
type
  Call_IotHubResourceGetValidSkus_568564 = ref object of OpenApiRestCall_567666
proc url_IotHubResourceGetValidSkus_568566(protocol: Scheme; host: string;
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

proc validate_IotHubResourceGetValidSkus_568565(path: JsonNode; query: JsonNode;
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
  var valid_568567 = path.getOrDefault("resourceGroupName")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "resourceGroupName", valid_568567
  var valid_568568 = path.getOrDefault("subscriptionId")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "subscriptionId", valid_568568
  var valid_568569 = path.getOrDefault("resourceName")
  valid_568569 = validateParameter(valid_568569, JString, required = true,
                                 default = nil)
  if valid_568569 != nil:
    section.add "resourceName", valid_568569
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568570 = query.getOrDefault("api-version")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "api-version", valid_568570
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568571: Call_IotHubResourceGetValidSkus_568564; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of valid SKUs for an IoT hub.
  ## 
  let valid = call_568571.validator(path, query, header, formData, body)
  let scheme = call_568571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568571.url(scheme.get, call_568571.host, call_568571.base,
                         call_568571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568571, url, valid)

proc call*(call_568572: Call_IotHubResourceGetValidSkus_568564;
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
  var path_568573 = newJObject()
  var query_568574 = newJObject()
  add(path_568573, "resourceGroupName", newJString(resourceGroupName))
  add(query_568574, "api-version", newJString(apiVersion))
  add(path_568573, "subscriptionId", newJString(subscriptionId))
  add(path_568573, "resourceName", newJString(resourceName))
  result = call_568572.call(path_568573, query_568574, nil, nil, nil)

var iotHubResourceGetValidSkus* = Call_IotHubResourceGetValidSkus_568564(
    name: "iotHubResourceGetValidSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/skus",
    validator: validate_IotHubResourceGetValidSkus_568565, base: "",
    url: url_IotHubResourceGetValidSkus_568566, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
