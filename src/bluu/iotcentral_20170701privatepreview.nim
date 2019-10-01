
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: IotCentralClient
## version: 2017-07-01-privatepreview
## termsOfService: (not provided)
## license: (not provided)
## 
## Use this API to manage IoT Central Applications in your Azure subscription.
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "iotcentral"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567863 = ref object of OpenApiRestCall_567641
proc url_OperationsList_567865(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567864(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available IoT Central application REST API operations.
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
  var valid_568024 = query.getOrDefault("api-version")
  valid_568024 = validateParameter(valid_568024, JString, required = true,
                                 default = nil)
  if valid_568024 != nil:
    section.add "api-version", valid_568024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568047: Call_OperationsList_567863; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available IoT Central application REST API operations.
  ## 
  let valid = call_568047.validator(path, query, header, formData, body)
  let scheme = call_568047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568047.url(scheme.get, call_568047.host, call_568047.base,
                         call_568047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568047, url, valid)

proc call*(call_568118: Call_OperationsList_567863; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available IoT Central application REST API operations.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  var query_568119 = newJObject()
  add(query_568119, "api-version", newJString(apiVersion))
  result = call_568118.call(nil, query_568119, nil, nil, nil)

var operationsList* = Call_OperationsList_567863(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.IoTCentral/operations",
    validator: validate_OperationsList_567864, base: "", url: url_OperationsList_567865,
    schemes: {Scheme.Https})
type
  Call_AppsListBySubscription_568159 = ref object of OpenApiRestCall_567641
proc url_AppsListBySubscription_568161(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.IoTCentral/IoTApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsListBySubscription_568160(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all IoT Central Applications in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568176 = path.getOrDefault("subscriptionId")
  valid_568176 = validateParameter(valid_568176, JString, required = true,
                                 default = nil)
  if valid_568176 != nil:
    section.add "subscriptionId", valid_568176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568177 = query.getOrDefault("api-version")
  valid_568177 = validateParameter(valid_568177, JString, required = true,
                                 default = nil)
  if valid_568177 != nil:
    section.add "api-version", valid_568177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568178: Call_AppsListBySubscription_568159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all IoT Central Applications in a subscription.
  ## 
  let valid = call_568178.validator(path, query, header, formData, body)
  let scheme = call_568178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568178.url(scheme.get, call_568178.host, call_568178.base,
                         call_568178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568178, url, valid)

proc call*(call_568179: Call_AppsListBySubscription_568159; apiVersion: string;
          subscriptionId: string): Recallable =
  ## appsListBySubscription
  ## Get all IoT Central Applications in a subscription.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568180 = newJObject()
  var query_568181 = newJObject()
  add(query_568181, "api-version", newJString(apiVersion))
  add(path_568180, "subscriptionId", newJString(subscriptionId))
  result = call_568179.call(path_568180, query_568181, nil, nil, nil)

var appsListBySubscription* = Call_AppsListBySubscription_568159(
    name: "appsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.IoTCentral/IoTApps",
    validator: validate_AppsListBySubscription_568160, base: "",
    url: url_AppsListBySubscription_568161, schemes: {Scheme.Https})
type
  Call_AppsCheckNameAvailability_568182 = ref object of OpenApiRestCall_567641
proc url_AppsCheckNameAvailability_568184(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.IoTCentral/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsCheckNameAvailability_568183(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check if an IoT Central application name is available.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568185 = path.getOrDefault("subscriptionId")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "subscriptionId", valid_568185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568186 = query.getOrDefault("api-version")
  valid_568186 = validateParameter(valid_568186, JString, required = true,
                                 default = nil)
  if valid_568186 != nil:
    section.add "api-version", valid_568186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   operationInputs: JObject (required)
  ##                  : Set the name parameter in the OperationInputs structure to the name of the IoT Central application to check.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568188: Call_AppsCheckNameAvailability_568182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check if an IoT Central application name is available.
  ## 
  let valid = call_568188.validator(path, query, header, formData, body)
  let scheme = call_568188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568188.url(scheme.get, call_568188.host, call_568188.base,
                         call_568188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568188, url, valid)

proc call*(call_568189: Call_AppsCheckNameAvailability_568182; apiVersion: string;
          subscriptionId: string; operationInputs: JsonNode): Recallable =
  ## appsCheckNameAvailability
  ## Check if an IoT Central application name is available.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   operationInputs: JObject (required)
  ##                  : Set the name parameter in the OperationInputs structure to the name of the IoT Central application to check.
  var path_568190 = newJObject()
  var query_568191 = newJObject()
  var body_568192 = newJObject()
  add(query_568191, "api-version", newJString(apiVersion))
  add(path_568190, "subscriptionId", newJString(subscriptionId))
  if operationInputs != nil:
    body_568192 = operationInputs
  result = call_568189.call(path_568190, query_568191, nil, nil, body_568192)

var appsCheckNameAvailability* = Call_AppsCheckNameAvailability_568182(
    name: "appsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.IoTCentral/checkNameAvailability",
    validator: validate_AppsCheckNameAvailability_568183, base: "",
    url: url_AppsCheckNameAvailability_568184, schemes: {Scheme.Https})
type
  Call_AppsListByResourceGroup_568193 = ref object of OpenApiRestCall_567641
proc url_AppsListByResourceGroup_568195(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.IoTCentral/IoTApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsListByResourceGroup_568194(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the IoT Central Applications in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT Central application.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568196 = path.getOrDefault("resourceGroupName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "resourceGroupName", valid_568196
  var valid_568197 = path.getOrDefault("subscriptionId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "subscriptionId", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568199: Call_AppsListByResourceGroup_568193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the IoT Central Applications in a resource group.
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_AppsListByResourceGroup_568193;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## appsListByResourceGroup
  ## Get all the IoT Central Applications in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT Central application.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568201 = newJObject()
  var query_568202 = newJObject()
  add(path_568201, "resourceGroupName", newJString(resourceGroupName))
  add(query_568202, "api-version", newJString(apiVersion))
  add(path_568201, "subscriptionId", newJString(subscriptionId))
  result = call_568200.call(path_568201, query_568202, nil, nil, nil)

var appsListByResourceGroup* = Call_AppsListByResourceGroup_568193(
    name: "appsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IoTCentral/IoTApps",
    validator: validate_AppsListByResourceGroup_568194, base: "",
    url: url_AppsListByResourceGroup_568195, schemes: {Scheme.Https})
type
  Call_AppsCreateOrUpdate_568214 = ref object of OpenApiRestCall_567641
proc url_AppsCreateOrUpdate_568216(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.IoTCentral/IoTApps/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsCreateOrUpdate_568215(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Create or update the metadata of an IoT Central application. The usual pattern to modify a property is to retrieve the IoT Central application metadata and security metadata, and then combine them with the modified values in a new body to update the IoT Central application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT Central application.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The ARM resource name of the IoT Central application.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568217 = path.getOrDefault("resourceGroupName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "resourceGroupName", valid_568217
  var valid_568218 = path.getOrDefault("subscriptionId")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "subscriptionId", valid_568218
  var valid_568219 = path.getOrDefault("resourceName")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "resourceName", valid_568219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568220 = query.getOrDefault("api-version")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "api-version", valid_568220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   App: JObject (required)
  ##      : The IoT Central application metadata and security metadata.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_AppsCreateOrUpdate_568214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the metadata of an IoT Central application. The usual pattern to modify a property is to retrieve the IoT Central application metadata and security metadata, and then combine them with the modified values in a new body to update the IoT Central application.
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_AppsCreateOrUpdate_568214; resourceGroupName: string;
          apiVersion: string; App: JsonNode; subscriptionId: string;
          resourceName: string): Recallable =
  ## appsCreateOrUpdate
  ## Create or update the metadata of an IoT Central application. The usual pattern to modify a property is to retrieve the IoT Central application metadata and security metadata, and then combine them with the modified values in a new body to update the IoT Central application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT Central application.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   App: JObject (required)
  ##      : The IoT Central application metadata and security metadata.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The ARM resource name of the IoT Central application.
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  var body_568226 = newJObject()
  add(path_568224, "resourceGroupName", newJString(resourceGroupName))
  add(query_568225, "api-version", newJString(apiVersion))
  if App != nil:
    body_568226 = App
  add(path_568224, "subscriptionId", newJString(subscriptionId))
  add(path_568224, "resourceName", newJString(resourceName))
  result = call_568223.call(path_568224, query_568225, nil, nil, body_568226)

var appsCreateOrUpdate* = Call_AppsCreateOrUpdate_568214(
    name: "appsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IoTCentral/IoTApps/{resourceName}",
    validator: validate_AppsCreateOrUpdate_568215, base: "",
    url: url_AppsCreateOrUpdate_568216, schemes: {Scheme.Https})
type
  Call_AppsGet_568203 = ref object of OpenApiRestCall_567641
proc url_AppsGet_568205(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.IoTCentral/IoTApps/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsGet_568204(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the metadata of an IoT Central application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT Central application.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The ARM resource name of the IoT Central application.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568206 = path.getOrDefault("resourceGroupName")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "resourceGroupName", valid_568206
  var valid_568207 = path.getOrDefault("subscriptionId")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "subscriptionId", valid_568207
  var valid_568208 = path.getOrDefault("resourceName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "resourceName", valid_568208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568209 = query.getOrDefault("api-version")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "api-version", valid_568209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568210: Call_AppsGet_568203; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the metadata of an IoT Central application.
  ## 
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_AppsGet_568203; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## appsGet
  ## Get the metadata of an IoT Central application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT Central application.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The ARM resource name of the IoT Central application.
  var path_568212 = newJObject()
  var query_568213 = newJObject()
  add(path_568212, "resourceGroupName", newJString(resourceGroupName))
  add(query_568213, "api-version", newJString(apiVersion))
  add(path_568212, "subscriptionId", newJString(subscriptionId))
  add(path_568212, "resourceName", newJString(resourceName))
  result = call_568211.call(path_568212, query_568213, nil, nil, nil)

var appsGet* = Call_AppsGet_568203(name: "appsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IoTCentral/IoTApps/{resourceName}",
                                validator: validate_AppsGet_568204, base: "",
                                url: url_AppsGet_568205, schemes: {Scheme.Https})
type
  Call_AppsUpdate_568238 = ref object of OpenApiRestCall_567641
proc url_AppsUpdate_568240(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.IoTCentral/IoTApps/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsUpdate_568239(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the metadata of an IoT Central application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT Central application.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The ARM resource name of the IoT Central application.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568241 = path.getOrDefault("resourceGroupName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "resourceGroupName", valid_568241
  var valid_568242 = path.getOrDefault("subscriptionId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "subscriptionId", valid_568242
  var valid_568243 = path.getOrDefault("resourceName")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "resourceName", valid_568243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
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
  ## parameters in `body` object:
  ##   AppPatch: JObject (required)
  ##           : The IoT Central application metadata and security metadata.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568246: Call_AppsUpdate_568238; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the metadata of an IoT Central application.
  ## 
  let valid = call_568246.validator(path, query, header, formData, body)
  let scheme = call_568246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568246.url(scheme.get, call_568246.host, call_568246.base,
                         call_568246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568246, url, valid)

proc call*(call_568247: Call_AppsUpdate_568238; resourceGroupName: string;
          apiVersion: string; AppPatch: JsonNode; subscriptionId: string;
          resourceName: string): Recallable =
  ## appsUpdate
  ## Update the metadata of an IoT Central application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT Central application.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   AppPatch: JObject (required)
  ##           : The IoT Central application metadata and security metadata.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The ARM resource name of the IoT Central application.
  var path_568248 = newJObject()
  var query_568249 = newJObject()
  var body_568250 = newJObject()
  add(path_568248, "resourceGroupName", newJString(resourceGroupName))
  add(query_568249, "api-version", newJString(apiVersion))
  if AppPatch != nil:
    body_568250 = AppPatch
  add(path_568248, "subscriptionId", newJString(subscriptionId))
  add(path_568248, "resourceName", newJString(resourceName))
  result = call_568247.call(path_568248, query_568249, nil, nil, body_568250)

var appsUpdate* = Call_AppsUpdate_568238(name: "appsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IoTCentral/IoTApps/{resourceName}",
                                      validator: validate_AppsUpdate_568239,
                                      base: "", url: url_AppsUpdate_568240,
                                      schemes: {Scheme.Https})
type
  Call_AppsDelete_568227 = ref object of OpenApiRestCall_567641
proc url_AppsDelete_568229(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.IoTCentral/IoTApps/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsDelete_568228(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an IoT Central application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the IoT Central application.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceName: JString (required)
  ##               : The ARM resource name of the IoT Central application.
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
  var valid_568232 = path.getOrDefault("resourceName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "resourceName", valid_568232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API.
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

proc call*(call_568234: Call_AppsDelete_568227; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an IoT Central application.
  ## 
  let valid = call_568234.validator(path, query, header, formData, body)
  let scheme = call_568234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568234.url(scheme.get, call_568234.host, call_568234.base,
                         call_568234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568234, url, valid)

proc call*(call_568235: Call_AppsDelete_568227; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## appsDelete
  ## Delete an IoT Central application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the IoT Central application.
  ##   apiVersion: string (required)
  ##             : The version of the API.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceName: string (required)
  ##               : The ARM resource name of the IoT Central application.
  var path_568236 = newJObject()
  var query_568237 = newJObject()
  add(path_568236, "resourceGroupName", newJString(resourceGroupName))
  add(query_568237, "api-version", newJString(apiVersion))
  add(path_568236, "subscriptionId", newJString(subscriptionId))
  add(path_568236, "resourceName", newJString(resourceName))
  result = call_568235.call(path_568236, query_568237, nil, nil, nil)

var appsDelete* = Call_AppsDelete_568227(name: "appsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.IoTCentral/IoTApps/{resourceName}",
                                      validator: validate_AppsDelete_568228,
                                      base: "", url: url_AppsDelete_568229,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
