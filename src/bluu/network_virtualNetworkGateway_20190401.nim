
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2019-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Microsoft Azure Network management API provides a RESTful set of web services that interact with Microsoft Azure Networks service to manage your network resources. The API has entities that capture the relationship between an end user and the Microsoft Azure Networks service.
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
  macServiceName = "network-virtualNetworkGateway"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VirtualNetworkGatewayConnectionsList_567888 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewayConnectionsList_567890(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/connections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsList_567889(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568050 = path.getOrDefault("resourceGroupName")
  valid_568050 = validateParameter(valid_568050, JString, required = true,
                                 default = nil)
  if valid_568050 != nil:
    section.add "resourceGroupName", valid_568050
  var valid_568051 = path.getOrDefault("subscriptionId")
  valid_568051 = validateParameter(valid_568051, JString, required = true,
                                 default = nil)
  if valid_568051 != nil:
    section.add "subscriptionId", valid_568051
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568052 = query.getOrDefault("api-version")
  valid_568052 = validateParameter(valid_568052, JString, required = true,
                                 default = nil)
  if valid_568052 != nil:
    section.add "api-version", valid_568052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568079: Call_VirtualNetworkGatewayConnectionsList_567888;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ## 
  let valid = call_568079.validator(path, query, header, formData, body)
  let scheme = call_568079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568079.url(scheme.get, call_568079.host, call_568079.base,
                         call_568079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568079, url, valid)

proc call*(call_568150: Call_VirtualNetworkGatewayConnectionsList_567888;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworkGatewayConnectionsList
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568151 = newJObject()
  var query_568153 = newJObject()
  add(path_568151, "resourceGroupName", newJString(resourceGroupName))
  add(query_568153, "api-version", newJString(apiVersion))
  add(path_568151, "subscriptionId", newJString(subscriptionId))
  result = call_568150.call(path_568151, query_568153, nil, nil, nil)

var virtualNetworkGatewayConnectionsList* = Call_VirtualNetworkGatewayConnectionsList_567888(
    name: "virtualNetworkGatewayConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections",
    validator: validate_VirtualNetworkGatewayConnectionsList_567889, base: "",
    url: url_VirtualNetworkGatewayConnectionsList_567890, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_568203 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewayConnectionsCreateOrUpdate_568205(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayConnectionName" in path,
        "`virtualNetworkGatewayConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/connections/"), (
        kind: VariableSegment, value: "virtualNetworkGatewayConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsCreateOrUpdate_568204(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates a virtual network gateway connection in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The name of the virtual network gateway connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568232 = path.getOrDefault("resourceGroupName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "resourceGroupName", valid_568232
  var valid_568233 = path.getOrDefault("subscriptionId")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "subscriptionId", valid_568233
  var valid_568234 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568235 = query.getOrDefault("api-version")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "api-version", valid_568235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update virtual network gateway connection operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568237: Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_568203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a virtual network gateway connection in the specified resource group.
  ## 
  let valid = call_568237.validator(path, query, header, formData, body)
  let scheme = call_568237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568237.url(scheme.get, call_568237.host, call_568237.base,
                         call_568237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568237, url, valid)

proc call*(call_568238: Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_568203;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; virtualNetworkGatewayConnectionName: string): Recallable =
  ## virtualNetworkGatewayConnectionsCreateOrUpdate
  ## Creates or updates a virtual network gateway connection in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update virtual network gateway connection operation.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The name of the virtual network gateway connection.
  var path_568239 = newJObject()
  var query_568240 = newJObject()
  var body_568241 = newJObject()
  add(path_568239, "resourceGroupName", newJString(resourceGroupName))
  add(query_568240, "api-version", newJString(apiVersion))
  add(path_568239, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568241 = parameters
  add(path_568239, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568238.call(path_568239, query_568240, nil, nil, body_568241)

var virtualNetworkGatewayConnectionsCreateOrUpdate* = Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_568203(
    name: "virtualNetworkGatewayConnectionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsCreateOrUpdate_568204,
    base: "", url: url_VirtualNetworkGatewayConnectionsCreateOrUpdate_568205,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsGet_568192 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewayConnectionsGet_568194(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayConnectionName" in path,
        "`virtualNetworkGatewayConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/connections/"), (
        kind: VariableSegment, value: "virtualNetworkGatewayConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsGet_568193(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified virtual network gateway connection by resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The name of the virtual network gateway connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568195 = path.getOrDefault("resourceGroupName")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "resourceGroupName", valid_568195
  var valid_568196 = path.getOrDefault("subscriptionId")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "subscriptionId", valid_568196
  var valid_568197 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_568199: Call_VirtualNetworkGatewayConnectionsGet_568192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified virtual network gateway connection by resource group.
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_VirtualNetworkGatewayConnectionsGet_568192;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayConnectionName: string): Recallable =
  ## virtualNetworkGatewayConnectionsGet
  ## Gets the specified virtual network gateway connection by resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The name of the virtual network gateway connection.
  var path_568201 = newJObject()
  var query_568202 = newJObject()
  add(path_568201, "resourceGroupName", newJString(resourceGroupName))
  add(query_568202, "api-version", newJString(apiVersion))
  add(path_568201, "subscriptionId", newJString(subscriptionId))
  add(path_568201, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568200.call(path_568201, query_568202, nil, nil, nil)

var virtualNetworkGatewayConnectionsGet* = Call_VirtualNetworkGatewayConnectionsGet_568192(
    name: "virtualNetworkGatewayConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsGet_568193, base: "",
    url: url_VirtualNetworkGatewayConnectionsGet_568194, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsUpdateTags_568253 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewayConnectionsUpdateTags_568255(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayConnectionName" in path,
        "`virtualNetworkGatewayConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/connections/"), (
        kind: VariableSegment, value: "virtualNetworkGatewayConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsUpdateTags_568254(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a virtual network gateway connection tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The name of the virtual network gateway connection.
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
  var valid_568258 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update virtual network gateway connection tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568261: Call_VirtualNetworkGatewayConnectionsUpdateTags_568253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a virtual network gateway connection tags.
  ## 
  let valid = call_568261.validator(path, query, header, formData, body)
  let scheme = call_568261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568261.url(scheme.get, call_568261.host, call_568261.base,
                         call_568261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568261, url, valid)

proc call*(call_568262: Call_VirtualNetworkGatewayConnectionsUpdateTags_568253;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; virtualNetworkGatewayConnectionName: string): Recallable =
  ## virtualNetworkGatewayConnectionsUpdateTags
  ## Updates a virtual network gateway connection tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update virtual network gateway connection tags.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The name of the virtual network gateway connection.
  var path_568263 = newJObject()
  var query_568264 = newJObject()
  var body_568265 = newJObject()
  add(path_568263, "resourceGroupName", newJString(resourceGroupName))
  add(query_568264, "api-version", newJString(apiVersion))
  add(path_568263, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568265 = parameters
  add(path_568263, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568262.call(path_568263, query_568264, nil, nil, body_568265)

var virtualNetworkGatewayConnectionsUpdateTags* = Call_VirtualNetworkGatewayConnectionsUpdateTags_568253(
    name: "virtualNetworkGatewayConnectionsUpdateTags",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsUpdateTags_568254,
    base: "", url: url_VirtualNetworkGatewayConnectionsUpdateTags_568255,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsDelete_568242 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewayConnectionsDelete_568244(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayConnectionName" in path,
        "`virtualNetworkGatewayConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/connections/"), (
        kind: VariableSegment, value: "virtualNetworkGatewayConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsDelete_568243(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified virtual network Gateway connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The name of the virtual network gateway connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568245 = path.getOrDefault("resourceGroupName")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "resourceGroupName", valid_568245
  var valid_568246 = path.getOrDefault("subscriptionId")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "subscriptionId", valid_568246
  var valid_568247 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568248 = query.getOrDefault("api-version")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "api-version", valid_568248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568249: Call_VirtualNetworkGatewayConnectionsDelete_568242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified virtual network Gateway connection.
  ## 
  let valid = call_568249.validator(path, query, header, formData, body)
  let scheme = call_568249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568249.url(scheme.get, call_568249.host, call_568249.base,
                         call_568249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568249, url, valid)

proc call*(call_568250: Call_VirtualNetworkGatewayConnectionsDelete_568242;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayConnectionName: string): Recallable =
  ## virtualNetworkGatewayConnectionsDelete
  ## Deletes the specified virtual network Gateway connection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The name of the virtual network gateway connection.
  var path_568251 = newJObject()
  var query_568252 = newJObject()
  add(path_568251, "resourceGroupName", newJString(resourceGroupName))
  add(query_568252, "api-version", newJString(apiVersion))
  add(path_568251, "subscriptionId", newJString(subscriptionId))
  add(path_568251, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568250.call(path_568251, query_568252, nil, nil, nil)

var virtualNetworkGatewayConnectionsDelete* = Call_VirtualNetworkGatewayConnectionsDelete_568242(
    name: "virtualNetworkGatewayConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsDelete_568243, base: "",
    url: url_VirtualNetworkGatewayConnectionsDelete_568244,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsSetSharedKey_568277 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewayConnectionsSetSharedKey_568279(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayConnectionName" in path,
        "`virtualNetworkGatewayConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/connections/"), (
        kind: VariableSegment, value: "virtualNetworkGatewayConnectionName"),
               (kind: ConstantSegment, value: "/sharedkey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsSetSharedKey_568278(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put VirtualNetworkGatewayConnectionSharedKey operation sets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The virtual network gateway connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568280 = path.getOrDefault("resourceGroupName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "resourceGroupName", valid_568280
  var valid_568281 = path.getOrDefault("subscriptionId")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "subscriptionId", valid_568281
  var valid_568282 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568283 = query.getOrDefault("api-version")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "api-version", valid_568283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Set Virtual Network Gateway connection Shared key operation throughNetwork resource provider.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568285: Call_VirtualNetworkGatewayConnectionsSetSharedKey_568277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGatewayConnectionSharedKey operation sets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_568285.validator(path, query, header, formData, body)
  let scheme = call_568285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568285.url(scheme.get, call_568285.host, call_568285.base,
                         call_568285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568285, url, valid)

proc call*(call_568286: Call_VirtualNetworkGatewayConnectionsSetSharedKey_568277;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; virtualNetworkGatewayConnectionName: string): Recallable =
  ## virtualNetworkGatewayConnectionsSetSharedKey
  ## The Put VirtualNetworkGatewayConnectionSharedKey operation sets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Set Virtual Network Gateway connection Shared key operation throughNetwork resource provider.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The virtual network gateway connection name.
  var path_568287 = newJObject()
  var query_568288 = newJObject()
  var body_568289 = newJObject()
  add(path_568287, "resourceGroupName", newJString(resourceGroupName))
  add(query_568288, "api-version", newJString(apiVersion))
  add(path_568287, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568289 = parameters
  add(path_568287, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568286.call(path_568287, query_568288, nil, nil, body_568289)

var virtualNetworkGatewayConnectionsSetSharedKey* = Call_VirtualNetworkGatewayConnectionsSetSharedKey_568277(
    name: "virtualNetworkGatewayConnectionsSetSharedKey",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey",
    validator: validate_VirtualNetworkGatewayConnectionsSetSharedKey_568278,
    base: "", url: url_VirtualNetworkGatewayConnectionsSetSharedKey_568279,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsGetSharedKey_568266 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewayConnectionsGetSharedKey_568268(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayConnectionName" in path,
        "`virtualNetworkGatewayConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/connections/"), (
        kind: VariableSegment, value: "virtualNetworkGatewayConnectionName"),
               (kind: ConstantSegment, value: "/sharedkey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsGetSharedKey_568267(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get VirtualNetworkGatewayConnectionSharedKey operation retrieves information about the specified virtual network gateway connection shared key through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The virtual network gateway connection shared key name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568269 = path.getOrDefault("resourceGroupName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "resourceGroupName", valid_568269
  var valid_568270 = path.getOrDefault("subscriptionId")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "subscriptionId", valid_568270
  var valid_568271 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568272 = query.getOrDefault("api-version")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "api-version", valid_568272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568273: Call_VirtualNetworkGatewayConnectionsGetSharedKey_568266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get VirtualNetworkGatewayConnectionSharedKey operation retrieves information about the specified virtual network gateway connection shared key through Network resource provider.
  ## 
  let valid = call_568273.validator(path, query, header, formData, body)
  let scheme = call_568273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568273.url(scheme.get, call_568273.host, call_568273.base,
                         call_568273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568273, url, valid)

proc call*(call_568274: Call_VirtualNetworkGatewayConnectionsGetSharedKey_568266;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayConnectionName: string): Recallable =
  ## virtualNetworkGatewayConnectionsGetSharedKey
  ## The Get VirtualNetworkGatewayConnectionSharedKey operation retrieves information about the specified virtual network gateway connection shared key through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The virtual network gateway connection shared key name.
  var path_568275 = newJObject()
  var query_568276 = newJObject()
  add(path_568275, "resourceGroupName", newJString(resourceGroupName))
  add(query_568276, "api-version", newJString(apiVersion))
  add(path_568275, "subscriptionId", newJString(subscriptionId))
  add(path_568275, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568274.call(path_568275, query_568276, nil, nil, nil)

var virtualNetworkGatewayConnectionsGetSharedKey* = Call_VirtualNetworkGatewayConnectionsGetSharedKey_568266(
    name: "virtualNetworkGatewayConnectionsGetSharedKey",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey",
    validator: validate_VirtualNetworkGatewayConnectionsGetSharedKey_568267,
    base: "", url: url_VirtualNetworkGatewayConnectionsGetSharedKey_568268,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsResetSharedKey_568290 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewayConnectionsResetSharedKey_568292(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayConnectionName" in path,
        "`virtualNetworkGatewayConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/connections/"), (
        kind: VariableSegment, value: "virtualNetworkGatewayConnectionName"),
               (kind: ConstantSegment, value: "/sharedkey/reset")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsResetSharedKey_568291(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The VirtualNetworkGatewayConnectionResetSharedKey operation resets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The virtual network gateway connection reset shared key Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568303 = path.getOrDefault("resourceGroupName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "resourceGroupName", valid_568303
  var valid_568304 = path.getOrDefault("subscriptionId")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "subscriptionId", valid_568304
  var valid_568305 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568306 = query.getOrDefault("api-version")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "api-version", valid_568306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the begin reset virtual network gateway connection shared key operation through network resource provider.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568308: Call_VirtualNetworkGatewayConnectionsResetSharedKey_568290;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The VirtualNetworkGatewayConnectionResetSharedKey operation resets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_568308.validator(path, query, header, formData, body)
  let scheme = call_568308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568308.url(scheme.get, call_568308.host, call_568308.base,
                         call_568308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568308, url, valid)

proc call*(call_568309: Call_VirtualNetworkGatewayConnectionsResetSharedKey_568290;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; virtualNetworkGatewayConnectionName: string): Recallable =
  ## virtualNetworkGatewayConnectionsResetSharedKey
  ## The VirtualNetworkGatewayConnectionResetSharedKey operation resets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the begin reset virtual network gateway connection shared key operation through network resource provider.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The virtual network gateway connection reset shared key Name.
  var path_568310 = newJObject()
  var query_568311 = newJObject()
  var body_568312 = newJObject()
  add(path_568310, "resourceGroupName", newJString(resourceGroupName))
  add(query_568311, "api-version", newJString(apiVersion))
  add(path_568310, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568312 = parameters
  add(path_568310, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568309.call(path_568310, query_568311, nil, nil, body_568312)

var virtualNetworkGatewayConnectionsResetSharedKey* = Call_VirtualNetworkGatewayConnectionsResetSharedKey_568290(
    name: "virtualNetworkGatewayConnectionsResetSharedKey",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey/reset",
    validator: validate_VirtualNetworkGatewayConnectionsResetSharedKey_568291,
    base: "", url: url_VirtualNetworkGatewayConnectionsResetSharedKey_568292,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysVpnDeviceConfigurationScript_568313 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysVpnDeviceConfigurationScript_568315(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayConnectionName" in path,
        "`virtualNetworkGatewayConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/connections/"), (
        kind: VariableSegment, value: "virtualNetworkGatewayConnectionName"),
               (kind: ConstantSegment, value: "/vpndeviceconfigurationscript")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysVpnDeviceConfigurationScript_568314(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a xml format representation for vpn device configuration script.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The name of the virtual network gateway connection for which the configuration script is generated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568316 = path.getOrDefault("resourceGroupName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "resourceGroupName", valid_568316
  var valid_568317 = path.getOrDefault("subscriptionId")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "subscriptionId", valid_568317
  var valid_568318 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568319 = query.getOrDefault("api-version")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "api-version", valid_568319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the generate vpn device script operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568321: Call_VirtualNetworkGatewaysVpnDeviceConfigurationScript_568313;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a xml format representation for vpn device configuration script.
  ## 
  let valid = call_568321.validator(path, query, header, formData, body)
  let scheme = call_568321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568321.url(scheme.get, call_568321.host, call_568321.base,
                         call_568321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568321, url, valid)

proc call*(call_568322: Call_VirtualNetworkGatewaysVpnDeviceConfigurationScript_568313;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; virtualNetworkGatewayConnectionName: string): Recallable =
  ## virtualNetworkGatewaysVpnDeviceConfigurationScript
  ## Gets a xml format representation for vpn device configuration script.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the generate vpn device script operation.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The name of the virtual network gateway connection for which the configuration script is generated.
  var path_568323 = newJObject()
  var query_568324 = newJObject()
  var body_568325 = newJObject()
  add(path_568323, "resourceGroupName", newJString(resourceGroupName))
  add(query_568324, "api-version", newJString(apiVersion))
  add(path_568323, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568325 = parameters
  add(path_568323, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568322.call(path_568323, query_568324, nil, nil, body_568325)

var virtualNetworkGatewaysVpnDeviceConfigurationScript* = Call_VirtualNetworkGatewaysVpnDeviceConfigurationScript_568313(
    name: "virtualNetworkGatewaysVpnDeviceConfigurationScript",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/vpndeviceconfigurationscript",
    validator: validate_VirtualNetworkGatewaysVpnDeviceConfigurationScript_568314,
    base: "", url: url_VirtualNetworkGatewaysVpnDeviceConfigurationScript_568315,
    schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysList_568326 = ref object of OpenApiRestCall_567666
proc url_LocalNetworkGatewaysList_568328(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/localNetworkGateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocalNetworkGatewaysList_568327(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the local network gateways in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568329 = path.getOrDefault("resourceGroupName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "resourceGroupName", valid_568329
  var valid_568330 = path.getOrDefault("subscriptionId")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "subscriptionId", valid_568330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568331 = query.getOrDefault("api-version")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "api-version", valid_568331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568332: Call_LocalNetworkGatewaysList_568326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the local network gateways in a resource group.
  ## 
  let valid = call_568332.validator(path, query, header, formData, body)
  let scheme = call_568332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568332.url(scheme.get, call_568332.host, call_568332.base,
                         call_568332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568332, url, valid)

proc call*(call_568333: Call_LocalNetworkGatewaysList_568326;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## localNetworkGatewaysList
  ## Gets all the local network gateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568334 = newJObject()
  var query_568335 = newJObject()
  add(path_568334, "resourceGroupName", newJString(resourceGroupName))
  add(query_568335, "api-version", newJString(apiVersion))
  add(path_568334, "subscriptionId", newJString(subscriptionId))
  result = call_568333.call(path_568334, query_568335, nil, nil, nil)

var localNetworkGatewaysList* = Call_LocalNetworkGatewaysList_568326(
    name: "localNetworkGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways",
    validator: validate_LocalNetworkGatewaysList_568327, base: "",
    url: url_LocalNetworkGatewaysList_568328, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysCreateOrUpdate_568347 = ref object of OpenApiRestCall_567666
proc url_LocalNetworkGatewaysCreateOrUpdate_568349(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "localNetworkGatewayName" in path,
        "`localNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/localNetworkGateways/"),
               (kind: VariableSegment, value: "localNetworkGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocalNetworkGatewaysCreateOrUpdate_568348(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a local network gateway in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   localNetworkGatewayName: JString (required)
  ##                          : The name of the local network gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568350 = path.getOrDefault("resourceGroupName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "resourceGroupName", valid_568350
  var valid_568351 = path.getOrDefault("localNetworkGatewayName")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "localNetworkGatewayName", valid_568351
  var valid_568352 = path.getOrDefault("subscriptionId")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "subscriptionId", valid_568352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568353 = query.getOrDefault("api-version")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "api-version", valid_568353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update local network gateway operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568355: Call_LocalNetworkGatewaysCreateOrUpdate_568347;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a local network gateway in the specified resource group.
  ## 
  let valid = call_568355.validator(path, query, header, formData, body)
  let scheme = call_568355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568355.url(scheme.get, call_568355.host, call_568355.base,
                         call_568355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568355, url, valid)

proc call*(call_568356: Call_LocalNetworkGatewaysCreateOrUpdate_568347;
          resourceGroupName: string; localNetworkGatewayName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## localNetworkGatewaysCreateOrUpdate
  ## Creates or updates a local network gateway in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   localNetworkGatewayName: string (required)
  ##                          : The name of the local network gateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update local network gateway operation.
  var path_568357 = newJObject()
  var query_568358 = newJObject()
  var body_568359 = newJObject()
  add(path_568357, "resourceGroupName", newJString(resourceGroupName))
  add(path_568357, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_568358, "api-version", newJString(apiVersion))
  add(path_568357, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568359 = parameters
  result = call_568356.call(path_568357, query_568358, nil, nil, body_568359)

var localNetworkGatewaysCreateOrUpdate* = Call_LocalNetworkGatewaysCreateOrUpdate_568347(
    name: "localNetworkGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysCreateOrUpdate_568348, base: "",
    url: url_LocalNetworkGatewaysCreateOrUpdate_568349, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysGet_568336 = ref object of OpenApiRestCall_567666
proc url_LocalNetworkGatewaysGet_568338(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "localNetworkGatewayName" in path,
        "`localNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/localNetworkGateways/"),
               (kind: VariableSegment, value: "localNetworkGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocalNetworkGatewaysGet_568337(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified local network gateway in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   localNetworkGatewayName: JString (required)
  ##                          : The name of the local network gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568339 = path.getOrDefault("resourceGroupName")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "resourceGroupName", valid_568339
  var valid_568340 = path.getOrDefault("localNetworkGatewayName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "localNetworkGatewayName", valid_568340
  var valid_568341 = path.getOrDefault("subscriptionId")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "subscriptionId", valid_568341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568342 = query.getOrDefault("api-version")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "api-version", valid_568342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568343: Call_LocalNetworkGatewaysGet_568336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified local network gateway in a resource group.
  ## 
  let valid = call_568343.validator(path, query, header, formData, body)
  let scheme = call_568343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568343.url(scheme.get, call_568343.host, call_568343.base,
                         call_568343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568343, url, valid)

proc call*(call_568344: Call_LocalNetworkGatewaysGet_568336;
          resourceGroupName: string; localNetworkGatewayName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## localNetworkGatewaysGet
  ## Gets the specified local network gateway in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   localNetworkGatewayName: string (required)
  ##                          : The name of the local network gateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568345 = newJObject()
  var query_568346 = newJObject()
  add(path_568345, "resourceGroupName", newJString(resourceGroupName))
  add(path_568345, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_568346, "api-version", newJString(apiVersion))
  add(path_568345, "subscriptionId", newJString(subscriptionId))
  result = call_568344.call(path_568345, query_568346, nil, nil, nil)

var localNetworkGatewaysGet* = Call_LocalNetworkGatewaysGet_568336(
    name: "localNetworkGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysGet_568337, base: "",
    url: url_LocalNetworkGatewaysGet_568338, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysUpdateTags_568371 = ref object of OpenApiRestCall_567666
proc url_LocalNetworkGatewaysUpdateTags_568373(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "localNetworkGatewayName" in path,
        "`localNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/localNetworkGateways/"),
               (kind: VariableSegment, value: "localNetworkGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocalNetworkGatewaysUpdateTags_568372(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a local network gateway tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   localNetworkGatewayName: JString (required)
  ##                          : The name of the local network gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568374 = path.getOrDefault("resourceGroupName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "resourceGroupName", valid_568374
  var valid_568375 = path.getOrDefault("localNetworkGatewayName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "localNetworkGatewayName", valid_568375
  var valid_568376 = path.getOrDefault("subscriptionId")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "subscriptionId", valid_568376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568377 = query.getOrDefault("api-version")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "api-version", valid_568377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update local network gateway tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568379: Call_LocalNetworkGatewaysUpdateTags_568371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a local network gateway tags.
  ## 
  let valid = call_568379.validator(path, query, header, formData, body)
  let scheme = call_568379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568379.url(scheme.get, call_568379.host, call_568379.base,
                         call_568379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568379, url, valid)

proc call*(call_568380: Call_LocalNetworkGatewaysUpdateTags_568371;
          resourceGroupName: string; localNetworkGatewayName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## localNetworkGatewaysUpdateTags
  ## Updates a local network gateway tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   localNetworkGatewayName: string (required)
  ##                          : The name of the local network gateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update local network gateway tags.
  var path_568381 = newJObject()
  var query_568382 = newJObject()
  var body_568383 = newJObject()
  add(path_568381, "resourceGroupName", newJString(resourceGroupName))
  add(path_568381, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_568382, "api-version", newJString(apiVersion))
  add(path_568381, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568383 = parameters
  result = call_568380.call(path_568381, query_568382, nil, nil, body_568383)

var localNetworkGatewaysUpdateTags* = Call_LocalNetworkGatewaysUpdateTags_568371(
    name: "localNetworkGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysUpdateTags_568372, base: "",
    url: url_LocalNetworkGatewaysUpdateTags_568373, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysDelete_568360 = ref object of OpenApiRestCall_567666
proc url_LocalNetworkGatewaysDelete_568362(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "localNetworkGatewayName" in path,
        "`localNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/localNetworkGateways/"),
               (kind: VariableSegment, value: "localNetworkGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocalNetworkGatewaysDelete_568361(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified local network gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   localNetworkGatewayName: JString (required)
  ##                          : The name of the local network gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568363 = path.getOrDefault("resourceGroupName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "resourceGroupName", valid_568363
  var valid_568364 = path.getOrDefault("localNetworkGatewayName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "localNetworkGatewayName", valid_568364
  var valid_568365 = path.getOrDefault("subscriptionId")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "subscriptionId", valid_568365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568366 = query.getOrDefault("api-version")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "api-version", valid_568366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568367: Call_LocalNetworkGatewaysDelete_568360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified local network gateway.
  ## 
  let valid = call_568367.validator(path, query, header, formData, body)
  let scheme = call_568367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568367.url(scheme.get, call_568367.host, call_568367.base,
                         call_568367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568367, url, valid)

proc call*(call_568368: Call_LocalNetworkGatewaysDelete_568360;
          resourceGroupName: string; localNetworkGatewayName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## localNetworkGatewaysDelete
  ## Deletes the specified local network gateway.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   localNetworkGatewayName: string (required)
  ##                          : The name of the local network gateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568369 = newJObject()
  var query_568370 = newJObject()
  add(path_568369, "resourceGroupName", newJString(resourceGroupName))
  add(path_568369, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_568370, "api-version", newJString(apiVersion))
  add(path_568369, "subscriptionId", newJString(subscriptionId))
  result = call_568368.call(path_568369, query_568370, nil, nil, nil)

var localNetworkGatewaysDelete* = Call_LocalNetworkGatewaysDelete_568360(
    name: "localNetworkGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysDelete_568361, base: "",
    url: url_LocalNetworkGatewaysDelete_568362, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysList_568384 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysList_568386(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Network/virtualNetworkGateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysList_568385(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all virtual network gateways by resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568387 = path.getOrDefault("resourceGroupName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "resourceGroupName", valid_568387
  var valid_568388 = path.getOrDefault("subscriptionId")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "subscriptionId", valid_568388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_568390: Call_VirtualNetworkGatewaysList_568384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all virtual network gateways by resource group.
  ## 
  let valid = call_568390.validator(path, query, header, formData, body)
  let scheme = call_568390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568390.url(scheme.get, call_568390.host, call_568390.base,
                         call_568390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568390, url, valid)

proc call*(call_568391: Call_VirtualNetworkGatewaysList_568384;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworkGatewaysList
  ## Gets all virtual network gateways by resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568392 = newJObject()
  var query_568393 = newJObject()
  add(path_568392, "resourceGroupName", newJString(resourceGroupName))
  add(query_568393, "api-version", newJString(apiVersion))
  add(path_568392, "subscriptionId", newJString(subscriptionId))
  result = call_568391.call(path_568392, query_568393, nil, nil, nil)

var virtualNetworkGatewaysList* = Call_VirtualNetworkGatewaysList_568384(
    name: "virtualNetworkGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways",
    validator: validate_VirtualNetworkGatewaysList_568385, base: "",
    url: url_VirtualNetworkGatewaysList_568386, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysCreateOrUpdate_568405 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysCreateOrUpdate_568407(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysCreateOrUpdate_568406(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a virtual network gateway in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568408 = path.getOrDefault("resourceGroupName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "resourceGroupName", valid_568408
  var valid_568409 = path.getOrDefault("subscriptionId")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "subscriptionId", valid_568409
  var valid_568410 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "virtualNetworkGatewayName", valid_568410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568411 = query.getOrDefault("api-version")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "api-version", valid_568411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update virtual network gateway operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568413: Call_VirtualNetworkGatewaysCreateOrUpdate_568405;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a virtual network gateway in the specified resource group.
  ## 
  let valid = call_568413.validator(path, query, header, formData, body)
  let scheme = call_568413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568413.url(scheme.get, call_568413.host, call_568413.base,
                         call_568413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568413, url, valid)

proc call*(call_568414: Call_VirtualNetworkGatewaysCreateOrUpdate_568405;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysCreateOrUpdate
  ## Creates or updates a virtual network gateway in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update virtual network gateway operation.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_568415 = newJObject()
  var query_568416 = newJObject()
  var body_568417 = newJObject()
  add(path_568415, "resourceGroupName", newJString(resourceGroupName))
  add(query_568416, "api-version", newJString(apiVersion))
  add(path_568415, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568417 = parameters
  add(path_568415, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568414.call(path_568415, query_568416, nil, nil, body_568417)

var virtualNetworkGatewaysCreateOrUpdate* = Call_VirtualNetworkGatewaysCreateOrUpdate_568405(
    name: "virtualNetworkGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysCreateOrUpdate_568406, base: "",
    url: url_VirtualNetworkGatewaysCreateOrUpdate_568407, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGet_568394 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysGet_568396(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysGet_568395(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified virtual network gateway by resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568397 = path.getOrDefault("resourceGroupName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "resourceGroupName", valid_568397
  var valid_568398 = path.getOrDefault("subscriptionId")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "subscriptionId", valid_568398
  var valid_568399 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "virtualNetworkGatewayName", valid_568399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568400 = query.getOrDefault("api-version")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "api-version", valid_568400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568401: Call_VirtualNetworkGatewaysGet_568394; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified virtual network gateway by resource group.
  ## 
  let valid = call_568401.validator(path, query, header, formData, body)
  let scheme = call_568401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568401.url(scheme.get, call_568401.host, call_568401.base,
                         call_568401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568401, url, valid)

proc call*(call_568402: Call_VirtualNetworkGatewaysGet_568394;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysGet
  ## Gets the specified virtual network gateway by resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_568403 = newJObject()
  var query_568404 = newJObject()
  add(path_568403, "resourceGroupName", newJString(resourceGroupName))
  add(query_568404, "api-version", newJString(apiVersion))
  add(path_568403, "subscriptionId", newJString(subscriptionId))
  add(path_568403, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568402.call(path_568403, query_568404, nil, nil, nil)

var virtualNetworkGatewaysGet* = Call_VirtualNetworkGatewaysGet_568394(
    name: "virtualNetworkGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysGet_568395, base: "",
    url: url_VirtualNetworkGatewaysGet_568396, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysUpdateTags_568429 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysUpdateTags_568431(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysUpdateTags_568430(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a virtual network gateway tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568432 = path.getOrDefault("resourceGroupName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "resourceGroupName", valid_568432
  var valid_568433 = path.getOrDefault("subscriptionId")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "subscriptionId", valid_568433
  var valid_568434 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "virtualNetworkGatewayName", valid_568434
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568435 = query.getOrDefault("api-version")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "api-version", valid_568435
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update virtual network gateway tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568437: Call_VirtualNetworkGatewaysUpdateTags_568429;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a virtual network gateway tags.
  ## 
  let valid = call_568437.validator(path, query, header, formData, body)
  let scheme = call_568437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568437.url(scheme.get, call_568437.host, call_568437.base,
                         call_568437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568437, url, valid)

proc call*(call_568438: Call_VirtualNetworkGatewaysUpdateTags_568429;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysUpdateTags
  ## Updates a virtual network gateway tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update virtual network gateway tags.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_568439 = newJObject()
  var query_568440 = newJObject()
  var body_568441 = newJObject()
  add(path_568439, "resourceGroupName", newJString(resourceGroupName))
  add(query_568440, "api-version", newJString(apiVersion))
  add(path_568439, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568441 = parameters
  add(path_568439, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568438.call(path_568439, query_568440, nil, nil, body_568441)

var virtualNetworkGatewaysUpdateTags* = Call_VirtualNetworkGatewaysUpdateTags_568429(
    name: "virtualNetworkGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysUpdateTags_568430, base: "",
    url: url_VirtualNetworkGatewaysUpdateTags_568431, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysDelete_568418 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysDelete_568420(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysDelete_568419(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified virtual network gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568421 = path.getOrDefault("resourceGroupName")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "resourceGroupName", valid_568421
  var valid_568422 = path.getOrDefault("subscriptionId")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "subscriptionId", valid_568422
  var valid_568423 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "virtualNetworkGatewayName", valid_568423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568424 = query.getOrDefault("api-version")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "api-version", valid_568424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568425: Call_VirtualNetworkGatewaysDelete_568418; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified virtual network gateway.
  ## 
  let valid = call_568425.validator(path, query, header, formData, body)
  let scheme = call_568425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568425.url(scheme.get, call_568425.host, call_568425.base,
                         call_568425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568425, url, valid)

proc call*(call_568426: Call_VirtualNetworkGatewaysDelete_568418;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysDelete
  ## Deletes the specified virtual network gateway.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_568427 = newJObject()
  var query_568428 = newJObject()
  add(path_568427, "resourceGroupName", newJString(resourceGroupName))
  add(query_568428, "api-version", newJString(apiVersion))
  add(path_568427, "subscriptionId", newJString(subscriptionId))
  add(path_568427, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568426.call(path_568427, query_568428, nil, nil, nil)

var virtualNetworkGatewaysDelete* = Call_VirtualNetworkGatewaysDelete_568418(
    name: "virtualNetworkGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysDelete_568419, base: "",
    url: url_VirtualNetworkGatewaysDelete_568420, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysListConnections_568442 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysListConnections_568444(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName"),
               (kind: ConstantSegment, value: "/connections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysListConnections_568443(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the connections in a virtual network gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568445 = path.getOrDefault("resourceGroupName")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "resourceGroupName", valid_568445
  var valid_568446 = path.getOrDefault("subscriptionId")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "subscriptionId", valid_568446
  var valid_568447 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "virtualNetworkGatewayName", valid_568447
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568448 = query.getOrDefault("api-version")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "api-version", valid_568448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568449: Call_VirtualNetworkGatewaysListConnections_568442;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the connections in a virtual network gateway.
  ## 
  let valid = call_568449.validator(path, query, header, formData, body)
  let scheme = call_568449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568449.url(scheme.get, call_568449.host, call_568449.base,
                         call_568449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568449, url, valid)

proc call*(call_568450: Call_VirtualNetworkGatewaysListConnections_568442;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysListConnections
  ## Gets all the connections in a virtual network gateway.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_568451 = newJObject()
  var query_568452 = newJObject()
  add(path_568451, "resourceGroupName", newJString(resourceGroupName))
  add(query_568452, "api-version", newJString(apiVersion))
  add(path_568451, "subscriptionId", newJString(subscriptionId))
  add(path_568451, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568450.call(path_568451, query_568452, nil, nil, nil)

var virtualNetworkGatewaysListConnections* = Call_VirtualNetworkGatewaysListConnections_568442(
    name: "virtualNetworkGatewaysListConnections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/connections",
    validator: validate_VirtualNetworkGatewaysListConnections_568443, base: "",
    url: url_VirtualNetworkGatewaysListConnections_568444, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGeneratevpnclientpackage_568453 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysGeneratevpnclientpackage_568455(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName"),
               (kind: ConstantSegment, value: "/generatevpnclientpackage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysGeneratevpnclientpackage_568454(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Generates VPN client package for P2S client of the virtual network gateway in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568456 = path.getOrDefault("resourceGroupName")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "resourceGroupName", valid_568456
  var valid_568457 = path.getOrDefault("subscriptionId")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "subscriptionId", valid_568457
  var valid_568458 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "virtualNetworkGatewayName", valid_568458
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568459 = query.getOrDefault("api-version")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "api-version", valid_568459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the generate virtual network gateway VPN client package operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568461: Call_VirtualNetworkGatewaysGeneratevpnclientpackage_568453;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates VPN client package for P2S client of the virtual network gateway in the specified resource group.
  ## 
  let valid = call_568461.validator(path, query, header, formData, body)
  let scheme = call_568461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568461.url(scheme.get, call_568461.host, call_568461.base,
                         call_568461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568461, url, valid)

proc call*(call_568462: Call_VirtualNetworkGatewaysGeneratevpnclientpackage_568453;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysGeneratevpnclientpackage
  ## Generates VPN client package for P2S client of the virtual network gateway in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the generate virtual network gateway VPN client package operation.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_568463 = newJObject()
  var query_568464 = newJObject()
  var body_568465 = newJObject()
  add(path_568463, "resourceGroupName", newJString(resourceGroupName))
  add(query_568464, "api-version", newJString(apiVersion))
  add(path_568463, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568465 = parameters
  add(path_568463, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568462.call(path_568463, query_568464, nil, nil, body_568465)

var virtualNetworkGatewaysGeneratevpnclientpackage* = Call_VirtualNetworkGatewaysGeneratevpnclientpackage_568453(
    name: "virtualNetworkGatewaysGeneratevpnclientpackage",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/generatevpnclientpackage",
    validator: validate_VirtualNetworkGatewaysGeneratevpnclientpackage_568454,
    base: "", url: url_VirtualNetworkGatewaysGeneratevpnclientpackage_568455,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGenerateVpnProfile_568466 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysGenerateVpnProfile_568468(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName"),
               (kind: ConstantSegment, value: "/generatevpnprofile")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysGenerateVpnProfile_568467(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates VPN profile for P2S client of the virtual network gateway in the specified resource group. Used for IKEV2 and radius based authentication.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568469 = path.getOrDefault("resourceGroupName")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "resourceGroupName", valid_568469
  var valid_568470 = path.getOrDefault("subscriptionId")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "subscriptionId", valid_568470
  var valid_568471 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "virtualNetworkGatewayName", valid_568471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568472 = query.getOrDefault("api-version")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "api-version", valid_568472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the generate virtual network gateway VPN client package operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568474: Call_VirtualNetworkGatewaysGenerateVpnProfile_568466;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates VPN profile for P2S client of the virtual network gateway in the specified resource group. Used for IKEV2 and radius based authentication.
  ## 
  let valid = call_568474.validator(path, query, header, formData, body)
  let scheme = call_568474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568474.url(scheme.get, call_568474.host, call_568474.base,
                         call_568474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568474, url, valid)

proc call*(call_568475: Call_VirtualNetworkGatewaysGenerateVpnProfile_568466;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysGenerateVpnProfile
  ## Generates VPN profile for P2S client of the virtual network gateway in the specified resource group. Used for IKEV2 and radius based authentication.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the generate virtual network gateway VPN client package operation.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_568476 = newJObject()
  var query_568477 = newJObject()
  var body_568478 = newJObject()
  add(path_568476, "resourceGroupName", newJString(resourceGroupName))
  add(query_568477, "api-version", newJString(apiVersion))
  add(path_568476, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568478 = parameters
  add(path_568476, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568475.call(path_568476, query_568477, nil, nil, body_568478)

var virtualNetworkGatewaysGenerateVpnProfile* = Call_VirtualNetworkGatewaysGenerateVpnProfile_568466(
    name: "virtualNetworkGatewaysGenerateVpnProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/generatevpnprofile",
    validator: validate_VirtualNetworkGatewaysGenerateVpnProfile_568467, base: "",
    url: url_VirtualNetworkGatewaysGenerateVpnProfile_568468,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGetAdvertisedRoutes_568479 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysGetAdvertisedRoutes_568481(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName"),
               (kind: ConstantSegment, value: "/getAdvertisedRoutes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysGetAdvertisedRoutes_568480(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves a list of routes the virtual network gateway is advertising to the specified peer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568482 = path.getOrDefault("resourceGroupName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "resourceGroupName", valid_568482
  var valid_568483 = path.getOrDefault("subscriptionId")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "subscriptionId", valid_568483
  var valid_568484 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "virtualNetworkGatewayName", valid_568484
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   peer: JString (required)
  ##       : The IP address of the peer.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568485 = query.getOrDefault("api-version")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "api-version", valid_568485
  var valid_568486 = query.getOrDefault("peer")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "peer", valid_568486
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568487: Call_VirtualNetworkGatewaysGetAdvertisedRoutes_568479;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves a list of routes the virtual network gateway is advertising to the specified peer.
  ## 
  let valid = call_568487.validator(path, query, header, formData, body)
  let scheme = call_568487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568487.url(scheme.get, call_568487.host, call_568487.base,
                         call_568487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568487, url, valid)

proc call*(call_568488: Call_VirtualNetworkGatewaysGetAdvertisedRoutes_568479;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          peer: string; virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysGetAdvertisedRoutes
  ## This operation retrieves a list of routes the virtual network gateway is advertising to the specified peer.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   peer: string (required)
  ##       : The IP address of the peer.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_568489 = newJObject()
  var query_568490 = newJObject()
  add(path_568489, "resourceGroupName", newJString(resourceGroupName))
  add(query_568490, "api-version", newJString(apiVersion))
  add(path_568489, "subscriptionId", newJString(subscriptionId))
  add(query_568490, "peer", newJString(peer))
  add(path_568489, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568488.call(path_568489, query_568490, nil, nil, nil)

var virtualNetworkGatewaysGetAdvertisedRoutes* = Call_VirtualNetworkGatewaysGetAdvertisedRoutes_568479(
    name: "virtualNetworkGatewaysGetAdvertisedRoutes", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/getAdvertisedRoutes",
    validator: validate_VirtualNetworkGatewaysGetAdvertisedRoutes_568480,
    base: "", url: url_VirtualNetworkGatewaysGetAdvertisedRoutes_568481,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGetBgpPeerStatus_568491 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysGetBgpPeerStatus_568493(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName"),
               (kind: ConstantSegment, value: "/getBgpPeerStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysGetBgpPeerStatus_568492(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The GetBgpPeerStatus operation retrieves the status of all BGP peers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568494 = path.getOrDefault("resourceGroupName")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "resourceGroupName", valid_568494
  var valid_568495 = path.getOrDefault("subscriptionId")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "subscriptionId", valid_568495
  var valid_568496 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "virtualNetworkGatewayName", valid_568496
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   peer: JString
  ##       : The IP address of the peer to retrieve the status of.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568497 = query.getOrDefault("api-version")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "api-version", valid_568497
  var valid_568498 = query.getOrDefault("peer")
  valid_568498 = validateParameter(valid_568498, JString, required = false,
                                 default = nil)
  if valid_568498 != nil:
    section.add "peer", valid_568498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568499: Call_VirtualNetworkGatewaysGetBgpPeerStatus_568491;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The GetBgpPeerStatus operation retrieves the status of all BGP peers.
  ## 
  let valid = call_568499.validator(path, query, header, formData, body)
  let scheme = call_568499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568499.url(scheme.get, call_568499.host, call_568499.base,
                         call_568499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568499, url, valid)

proc call*(call_568500: Call_VirtualNetworkGatewaysGetBgpPeerStatus_568491;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayName: string; peer: string = ""): Recallable =
  ## virtualNetworkGatewaysGetBgpPeerStatus
  ## The GetBgpPeerStatus operation retrieves the status of all BGP peers.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   peer: string
  ##       : The IP address of the peer to retrieve the status of.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_568501 = newJObject()
  var query_568502 = newJObject()
  add(path_568501, "resourceGroupName", newJString(resourceGroupName))
  add(query_568502, "api-version", newJString(apiVersion))
  add(path_568501, "subscriptionId", newJString(subscriptionId))
  add(query_568502, "peer", newJString(peer))
  add(path_568501, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568500.call(path_568501, query_568502, nil, nil, nil)

var virtualNetworkGatewaysGetBgpPeerStatus* = Call_VirtualNetworkGatewaysGetBgpPeerStatus_568491(
    name: "virtualNetworkGatewaysGetBgpPeerStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/getBgpPeerStatus",
    validator: validate_VirtualNetworkGatewaysGetBgpPeerStatus_568492, base: "",
    url: url_VirtualNetworkGatewaysGetBgpPeerStatus_568493,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGetLearnedRoutes_568503 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysGetLearnedRoutes_568505(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName"),
               (kind: ConstantSegment, value: "/getLearnedRoutes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysGetLearnedRoutes_568504(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves a list of routes the virtual network gateway has learned, including routes learned from BGP peers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568506 = path.getOrDefault("resourceGroupName")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "resourceGroupName", valid_568506
  var valid_568507 = path.getOrDefault("subscriptionId")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "subscriptionId", valid_568507
  var valid_568508 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "virtualNetworkGatewayName", valid_568508
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568509 = query.getOrDefault("api-version")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "api-version", valid_568509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568510: Call_VirtualNetworkGatewaysGetLearnedRoutes_568503;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves a list of routes the virtual network gateway has learned, including routes learned from BGP peers.
  ## 
  let valid = call_568510.validator(path, query, header, formData, body)
  let scheme = call_568510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568510.url(scheme.get, call_568510.host, call_568510.base,
                         call_568510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568510, url, valid)

proc call*(call_568511: Call_VirtualNetworkGatewaysGetLearnedRoutes_568503;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysGetLearnedRoutes
  ## This operation retrieves a list of routes the virtual network gateway has learned, including routes learned from BGP peers.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_568512 = newJObject()
  var query_568513 = newJObject()
  add(path_568512, "resourceGroupName", newJString(resourceGroupName))
  add(query_568513, "api-version", newJString(apiVersion))
  add(path_568512, "subscriptionId", newJString(subscriptionId))
  add(path_568512, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568511.call(path_568512, query_568513, nil, nil, nil)

var virtualNetworkGatewaysGetLearnedRoutes* = Call_VirtualNetworkGatewaysGetLearnedRoutes_568503(
    name: "virtualNetworkGatewaysGetLearnedRoutes", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/getLearnedRoutes",
    validator: validate_VirtualNetworkGatewaysGetLearnedRoutes_568504, base: "",
    url: url_VirtualNetworkGatewaysGetLearnedRoutes_568505,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGetVpnclientConnectionHealth_568514 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysGetVpnclientConnectionHealth_568516(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName"),
               (kind: ConstantSegment, value: "/getVpnClientConnectionHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysGetVpnclientConnectionHealth_568515(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get VPN client connection health detail per P2S client connection of the virtual network gateway in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568517 = path.getOrDefault("resourceGroupName")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "resourceGroupName", valid_568517
  var valid_568518 = path.getOrDefault("subscriptionId")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "subscriptionId", valid_568518
  var valid_568519 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "virtualNetworkGatewayName", valid_568519
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568520 = query.getOrDefault("api-version")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "api-version", valid_568520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568521: Call_VirtualNetworkGatewaysGetVpnclientConnectionHealth_568514;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get VPN client connection health detail per P2S client connection of the virtual network gateway in the specified resource group.
  ## 
  let valid = call_568521.validator(path, query, header, formData, body)
  let scheme = call_568521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568521.url(scheme.get, call_568521.host, call_568521.base,
                         call_568521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568521, url, valid)

proc call*(call_568522: Call_VirtualNetworkGatewaysGetVpnclientConnectionHealth_568514;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysGetVpnclientConnectionHealth
  ## Get VPN client connection health detail per P2S client connection of the virtual network gateway in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_568523 = newJObject()
  var query_568524 = newJObject()
  add(path_568523, "resourceGroupName", newJString(resourceGroupName))
  add(query_568524, "api-version", newJString(apiVersion))
  add(path_568523, "subscriptionId", newJString(subscriptionId))
  add(path_568523, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568522.call(path_568523, query_568524, nil, nil, nil)

var virtualNetworkGatewaysGetVpnclientConnectionHealth* = Call_VirtualNetworkGatewaysGetVpnclientConnectionHealth_568514(
    name: "virtualNetworkGatewaysGetVpnclientConnectionHealth",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/getVpnClientConnectionHealth",
    validator: validate_VirtualNetworkGatewaysGetVpnclientConnectionHealth_568515,
    base: "", url: url_VirtualNetworkGatewaysGetVpnclientConnectionHealth_568516,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGetVpnclientIpsecParameters_568525 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysGetVpnclientIpsecParameters_568527(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName"),
               (kind: ConstantSegment, value: "/getvpnclientipsecparameters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysGetVpnclientIpsecParameters_568526(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The Get VpnclientIpsecParameters operation retrieves information about the vpnclient ipsec policy for P2S client of virtual network gateway in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The virtual network gateway name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568528 = path.getOrDefault("resourceGroupName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "resourceGroupName", valid_568528
  var valid_568529 = path.getOrDefault("subscriptionId")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "subscriptionId", valid_568529
  var valid_568530 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "virtualNetworkGatewayName", valid_568530
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568531 = query.getOrDefault("api-version")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "api-version", valid_568531
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568532: Call_VirtualNetworkGatewaysGetVpnclientIpsecParameters_568525;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get VpnclientIpsecParameters operation retrieves information about the vpnclient ipsec policy for P2S client of virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_568532.validator(path, query, header, formData, body)
  let scheme = call_568532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568532.url(scheme.get, call_568532.host, call_568532.base,
                         call_568532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568532, url, valid)

proc call*(call_568533: Call_VirtualNetworkGatewaysGetVpnclientIpsecParameters_568525;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysGetVpnclientIpsecParameters
  ## The Get VpnclientIpsecParameters operation retrieves information about the vpnclient ipsec policy for P2S client of virtual network gateway in the specified resource group through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The virtual network gateway name.
  var path_568534 = newJObject()
  var query_568535 = newJObject()
  add(path_568534, "resourceGroupName", newJString(resourceGroupName))
  add(query_568535, "api-version", newJString(apiVersion))
  add(path_568534, "subscriptionId", newJString(subscriptionId))
  add(path_568534, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568533.call(path_568534, query_568535, nil, nil, nil)

var virtualNetworkGatewaysGetVpnclientIpsecParameters* = Call_VirtualNetworkGatewaysGetVpnclientIpsecParameters_568525(
    name: "virtualNetworkGatewaysGetVpnclientIpsecParameters",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/getvpnclientipsecparameters",
    validator: validate_VirtualNetworkGatewaysGetVpnclientIpsecParameters_568526,
    base: "", url: url_VirtualNetworkGatewaysGetVpnclientIpsecParameters_568527,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGetVpnProfilePackageUrl_568536 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysGetVpnProfilePackageUrl_568538(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName"),
               (kind: ConstantSegment, value: "/getvpnprofilepackageurl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysGetVpnProfilePackageUrl_568537(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets pre-generated VPN profile for P2S client of the virtual network gateway in the specified resource group. The profile needs to be generated first using generateVpnProfile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568539 = path.getOrDefault("resourceGroupName")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "resourceGroupName", valid_568539
  var valid_568540 = path.getOrDefault("subscriptionId")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "subscriptionId", valid_568540
  var valid_568541 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "virtualNetworkGatewayName", valid_568541
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568542 = query.getOrDefault("api-version")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "api-version", valid_568542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568543: Call_VirtualNetworkGatewaysGetVpnProfilePackageUrl_568536;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets pre-generated VPN profile for P2S client of the virtual network gateway in the specified resource group. The profile needs to be generated first using generateVpnProfile.
  ## 
  let valid = call_568543.validator(path, query, header, formData, body)
  let scheme = call_568543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568543.url(scheme.get, call_568543.host, call_568543.base,
                         call_568543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568543, url, valid)

proc call*(call_568544: Call_VirtualNetworkGatewaysGetVpnProfilePackageUrl_568536;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysGetVpnProfilePackageUrl
  ## Gets pre-generated VPN profile for P2S client of the virtual network gateway in the specified resource group. The profile needs to be generated first using generateVpnProfile.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_568545 = newJObject()
  var query_568546 = newJObject()
  add(path_568545, "resourceGroupName", newJString(resourceGroupName))
  add(query_568546, "api-version", newJString(apiVersion))
  add(path_568545, "subscriptionId", newJString(subscriptionId))
  add(path_568545, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568544.call(path_568545, query_568546, nil, nil, nil)

var virtualNetworkGatewaysGetVpnProfilePackageUrl* = Call_VirtualNetworkGatewaysGetVpnProfilePackageUrl_568536(
    name: "virtualNetworkGatewaysGetVpnProfilePackageUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/getvpnprofilepackageurl",
    validator: validate_VirtualNetworkGatewaysGetVpnProfilePackageUrl_568537,
    base: "", url: url_VirtualNetworkGatewaysGetVpnProfilePackageUrl_568538,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysReset_568547 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysReset_568549(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName"),
               (kind: ConstantSegment, value: "/reset")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysReset_568548(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets the primary of the virtual network gateway in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568550 = path.getOrDefault("resourceGroupName")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "resourceGroupName", valid_568550
  var valid_568551 = path.getOrDefault("subscriptionId")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "subscriptionId", valid_568551
  var valid_568552 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "virtualNetworkGatewayName", valid_568552
  result.add "path", section
  ## parameters in `query` object:
  ##   gatewayVip: JString
  ##             : Virtual network gateway vip address supplied to the begin reset of the active-active feature enabled gateway.
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568553 = query.getOrDefault("gatewayVip")
  valid_568553 = validateParameter(valid_568553, JString, required = false,
                                 default = nil)
  if valid_568553 != nil:
    section.add "gatewayVip", valid_568553
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568554 = query.getOrDefault("api-version")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "api-version", valid_568554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568555: Call_VirtualNetworkGatewaysReset_568547; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the primary of the virtual network gateway in the specified resource group.
  ## 
  let valid = call_568555.validator(path, query, header, formData, body)
  let scheme = call_568555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568555.url(scheme.get, call_568555.host, call_568555.base,
                         call_568555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568555, url, valid)

proc call*(call_568556: Call_VirtualNetworkGatewaysReset_568547;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayName: string; gatewayVip: string = ""): Recallable =
  ## virtualNetworkGatewaysReset
  ## Resets the primary of the virtual network gateway in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   gatewayVip: string
  ##             : Virtual network gateway vip address supplied to the begin reset of the active-active feature enabled gateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_568557 = newJObject()
  var query_568558 = newJObject()
  add(path_568557, "resourceGroupName", newJString(resourceGroupName))
  add(query_568558, "gatewayVip", newJString(gatewayVip))
  add(query_568558, "api-version", newJString(apiVersion))
  add(path_568557, "subscriptionId", newJString(subscriptionId))
  add(path_568557, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568556.call(path_568557, query_568558, nil, nil, nil)

var virtualNetworkGatewaysReset* = Call_VirtualNetworkGatewaysReset_568547(
    name: "virtualNetworkGatewaysReset", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/reset",
    validator: validate_VirtualNetworkGatewaysReset_568548, base: "",
    url: url_VirtualNetworkGatewaysReset_568549, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysResetVpnClientSharedKey_568559 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysResetVpnClientSharedKey_568561(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName"),
               (kind: ConstantSegment, value: "/resetvpnclientsharedkey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysResetVpnClientSharedKey_568560(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Resets the VPN client shared key of the virtual network gateway in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568562 = path.getOrDefault("resourceGroupName")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "resourceGroupName", valid_568562
  var valid_568563 = path.getOrDefault("subscriptionId")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "subscriptionId", valid_568563
  var valid_568564 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "virtualNetworkGatewayName", valid_568564
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568565 = query.getOrDefault("api-version")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "api-version", valid_568565
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568566: Call_VirtualNetworkGatewaysResetVpnClientSharedKey_568559;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets the VPN client shared key of the virtual network gateway in the specified resource group.
  ## 
  let valid = call_568566.validator(path, query, header, formData, body)
  let scheme = call_568566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568566.url(scheme.get, call_568566.host, call_568566.base,
                         call_568566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568566, url, valid)

proc call*(call_568567: Call_VirtualNetworkGatewaysResetVpnClientSharedKey_568559;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysResetVpnClientSharedKey
  ## Resets the VPN client shared key of the virtual network gateway in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_568568 = newJObject()
  var query_568569 = newJObject()
  add(path_568568, "resourceGroupName", newJString(resourceGroupName))
  add(query_568569, "api-version", newJString(apiVersion))
  add(path_568568, "subscriptionId", newJString(subscriptionId))
  add(path_568568, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568567.call(path_568568, query_568569, nil, nil, nil)

var virtualNetworkGatewaysResetVpnClientSharedKey* = Call_VirtualNetworkGatewaysResetVpnClientSharedKey_568559(
    name: "virtualNetworkGatewaysResetVpnClientSharedKey",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/resetvpnclientsharedkey",
    validator: validate_VirtualNetworkGatewaysResetVpnClientSharedKey_568560,
    base: "", url: url_VirtualNetworkGatewaysResetVpnClientSharedKey_568561,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysSetVpnclientIpsecParameters_568570 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysSetVpnclientIpsecParameters_568572(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName"),
               (kind: ConstantSegment, value: "/setvpnclientipsecparameters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysSetVpnclientIpsecParameters_568571(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The Set VpnclientIpsecParameters operation sets the vpnclient ipsec policy for P2S client of virtual network gateway in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568573 = path.getOrDefault("resourceGroupName")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "resourceGroupName", valid_568573
  var valid_568574 = path.getOrDefault("subscriptionId")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "subscriptionId", valid_568574
  var valid_568575 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "virtualNetworkGatewayName", valid_568575
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568576 = query.getOrDefault("api-version")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "api-version", valid_568576
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vpnclientIpsecParams: JObject (required)
  ##                       : Parameters supplied to the Begin Set vpnclient ipsec parameters of Virtual Network Gateway P2S client operation through Network resource provider.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568578: Call_VirtualNetworkGatewaysSetVpnclientIpsecParameters_568570;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Set VpnclientIpsecParameters operation sets the vpnclient ipsec policy for P2S client of virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_568578.validator(path, query, header, formData, body)
  let scheme = call_568578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568578.url(scheme.get, call_568578.host, call_568578.base,
                         call_568578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568578, url, valid)

proc call*(call_568579: Call_VirtualNetworkGatewaysSetVpnclientIpsecParameters_568570;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayName: string; vpnclientIpsecParams: JsonNode): Recallable =
  ## virtualNetworkGatewaysSetVpnclientIpsecParameters
  ## The Set VpnclientIpsecParameters operation sets the vpnclient ipsec policy for P2S client of virtual network gateway in the specified resource group through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  ##   vpnclientIpsecParams: JObject (required)
  ##                       : Parameters supplied to the Begin Set vpnclient ipsec parameters of Virtual Network Gateway P2S client operation through Network resource provider.
  var path_568580 = newJObject()
  var query_568581 = newJObject()
  var body_568582 = newJObject()
  add(path_568580, "resourceGroupName", newJString(resourceGroupName))
  add(query_568581, "api-version", newJString(apiVersion))
  add(path_568580, "subscriptionId", newJString(subscriptionId))
  add(path_568580, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  if vpnclientIpsecParams != nil:
    body_568582 = vpnclientIpsecParams
  result = call_568579.call(path_568580, query_568581, nil, nil, body_568582)

var virtualNetworkGatewaysSetVpnclientIpsecParameters* = Call_VirtualNetworkGatewaysSetVpnclientIpsecParameters_568570(
    name: "virtualNetworkGatewaysSetVpnclientIpsecParameters",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/setvpnclientipsecparameters",
    validator: validate_VirtualNetworkGatewaysSetVpnclientIpsecParameters_568571,
    base: "", url: url_VirtualNetworkGatewaysSetVpnclientIpsecParameters_568572,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysSupportedVpnDevices_568583 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworkGatewaysSupportedVpnDevices_568585(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName"),
               (kind: ConstantSegment, value: "/supportedvpndevices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysSupportedVpnDevices_568584(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a xml format representation for supported vpn devices.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568586 = path.getOrDefault("resourceGroupName")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "resourceGroupName", valid_568586
  var valid_568587 = path.getOrDefault("subscriptionId")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "subscriptionId", valid_568587
  var valid_568588 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "virtualNetworkGatewayName", valid_568588
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568589 = query.getOrDefault("api-version")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "api-version", valid_568589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568590: Call_VirtualNetworkGatewaysSupportedVpnDevices_568583;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a xml format representation for supported vpn devices.
  ## 
  let valid = call_568590.validator(path, query, header, formData, body)
  let scheme = call_568590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568590.url(scheme.get, call_568590.host, call_568590.base,
                         call_568590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568590, url, valid)

proc call*(call_568591: Call_VirtualNetworkGatewaysSupportedVpnDevices_568583;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysSupportedVpnDevices
  ## Gets a xml format representation for supported vpn devices.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_568592 = newJObject()
  var query_568593 = newJObject()
  add(path_568592, "resourceGroupName", newJString(resourceGroupName))
  add(query_568593, "api-version", newJString(apiVersion))
  add(path_568592, "subscriptionId", newJString(subscriptionId))
  add(path_568592, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568591.call(path_568592, query_568593, nil, nil, nil)

var virtualNetworkGatewaysSupportedVpnDevices* = Call_VirtualNetworkGatewaysSupportedVpnDevices_568583(
    name: "virtualNetworkGatewaysSupportedVpnDevices", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/supportedvpndevices",
    validator: validate_VirtualNetworkGatewaysSupportedVpnDevices_568584,
    base: "", url: url_VirtualNetworkGatewaysSupportedVpnDevices_568585,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
