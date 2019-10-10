
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2019-07-01
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

  OpenApiRestCall_573666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573666): Option[Scheme] {.used.} =
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
  Call_VirtualNetworkGatewayConnectionsList_573888 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewayConnectionsList_573890(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsList_573889(path: JsonNode;
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
  var valid_574050 = path.getOrDefault("resourceGroupName")
  valid_574050 = validateParameter(valid_574050, JString, required = true,
                                 default = nil)
  if valid_574050 != nil:
    section.add "resourceGroupName", valid_574050
  var valid_574051 = path.getOrDefault("subscriptionId")
  valid_574051 = validateParameter(valid_574051, JString, required = true,
                                 default = nil)
  if valid_574051 != nil:
    section.add "subscriptionId", valid_574051
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574052 = query.getOrDefault("api-version")
  valid_574052 = validateParameter(valid_574052, JString, required = true,
                                 default = nil)
  if valid_574052 != nil:
    section.add "api-version", valid_574052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574079: Call_VirtualNetworkGatewayConnectionsList_573888;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ## 
  let valid = call_574079.validator(path, query, header, formData, body)
  let scheme = call_574079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574079.url(scheme.get, call_574079.host, call_574079.base,
                         call_574079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574079, url, valid)

proc call*(call_574150: Call_VirtualNetworkGatewayConnectionsList_573888;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworkGatewayConnectionsList
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574151 = newJObject()
  var query_574153 = newJObject()
  add(path_574151, "resourceGroupName", newJString(resourceGroupName))
  add(query_574153, "api-version", newJString(apiVersion))
  add(path_574151, "subscriptionId", newJString(subscriptionId))
  result = call_574150.call(path_574151, query_574153, nil, nil, nil)

var virtualNetworkGatewayConnectionsList* = Call_VirtualNetworkGatewayConnectionsList_573888(
    name: "virtualNetworkGatewayConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections",
    validator: validate_VirtualNetworkGatewayConnectionsList_573889, base: "",
    url: url_VirtualNetworkGatewayConnectionsList_573890, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_574203 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewayConnectionsCreateOrUpdate_574205(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsCreateOrUpdate_574204(
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
  var valid_574232 = path.getOrDefault("resourceGroupName")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "resourceGroupName", valid_574232
  var valid_574233 = path.getOrDefault("subscriptionId")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "subscriptionId", valid_574233
  var valid_574234 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_574234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574235 = query.getOrDefault("api-version")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "api-version", valid_574235
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

proc call*(call_574237: Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_574203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a virtual network gateway connection in the specified resource group.
  ## 
  let valid = call_574237.validator(path, query, header, formData, body)
  let scheme = call_574237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574237.url(scheme.get, call_574237.host, call_574237.base,
                         call_574237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574237, url, valid)

proc call*(call_574238: Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_574203;
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
  var path_574239 = newJObject()
  var query_574240 = newJObject()
  var body_574241 = newJObject()
  add(path_574239, "resourceGroupName", newJString(resourceGroupName))
  add(query_574240, "api-version", newJString(apiVersion))
  add(path_574239, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574241 = parameters
  add(path_574239, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_574238.call(path_574239, query_574240, nil, nil, body_574241)

var virtualNetworkGatewayConnectionsCreateOrUpdate* = Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_574203(
    name: "virtualNetworkGatewayConnectionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsCreateOrUpdate_574204,
    base: "", url: url_VirtualNetworkGatewayConnectionsCreateOrUpdate_574205,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsGet_574192 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewayConnectionsGet_574194(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewayConnectionsGet_574193(path: JsonNode;
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
  var valid_574195 = path.getOrDefault("resourceGroupName")
  valid_574195 = validateParameter(valid_574195, JString, required = true,
                                 default = nil)
  if valid_574195 != nil:
    section.add "resourceGroupName", valid_574195
  var valid_574196 = path.getOrDefault("subscriptionId")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "subscriptionId", valid_574196
  var valid_574197 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_574197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574198 = query.getOrDefault("api-version")
  valid_574198 = validateParameter(valid_574198, JString, required = true,
                                 default = nil)
  if valid_574198 != nil:
    section.add "api-version", valid_574198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574199: Call_VirtualNetworkGatewayConnectionsGet_574192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified virtual network gateway connection by resource group.
  ## 
  let valid = call_574199.validator(path, query, header, formData, body)
  let scheme = call_574199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574199.url(scheme.get, call_574199.host, call_574199.base,
                         call_574199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574199, url, valid)

proc call*(call_574200: Call_VirtualNetworkGatewayConnectionsGet_574192;
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
  var path_574201 = newJObject()
  var query_574202 = newJObject()
  add(path_574201, "resourceGroupName", newJString(resourceGroupName))
  add(query_574202, "api-version", newJString(apiVersion))
  add(path_574201, "subscriptionId", newJString(subscriptionId))
  add(path_574201, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_574200.call(path_574201, query_574202, nil, nil, nil)

var virtualNetworkGatewayConnectionsGet* = Call_VirtualNetworkGatewayConnectionsGet_574192(
    name: "virtualNetworkGatewayConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsGet_574193, base: "",
    url: url_VirtualNetworkGatewayConnectionsGet_574194, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsUpdateTags_574253 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewayConnectionsUpdateTags_574255(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsUpdateTags_574254(path: JsonNode;
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
  var valid_574256 = path.getOrDefault("resourceGroupName")
  valid_574256 = validateParameter(valid_574256, JString, required = true,
                                 default = nil)
  if valid_574256 != nil:
    section.add "resourceGroupName", valid_574256
  var valid_574257 = path.getOrDefault("subscriptionId")
  valid_574257 = validateParameter(valid_574257, JString, required = true,
                                 default = nil)
  if valid_574257 != nil:
    section.add "subscriptionId", valid_574257
  var valid_574258 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_574258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574259 = query.getOrDefault("api-version")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "api-version", valid_574259
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

proc call*(call_574261: Call_VirtualNetworkGatewayConnectionsUpdateTags_574253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a virtual network gateway connection tags.
  ## 
  let valid = call_574261.validator(path, query, header, formData, body)
  let scheme = call_574261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574261.url(scheme.get, call_574261.host, call_574261.base,
                         call_574261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574261, url, valid)

proc call*(call_574262: Call_VirtualNetworkGatewayConnectionsUpdateTags_574253;
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
  var path_574263 = newJObject()
  var query_574264 = newJObject()
  var body_574265 = newJObject()
  add(path_574263, "resourceGroupName", newJString(resourceGroupName))
  add(query_574264, "api-version", newJString(apiVersion))
  add(path_574263, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574265 = parameters
  add(path_574263, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_574262.call(path_574263, query_574264, nil, nil, body_574265)

var virtualNetworkGatewayConnectionsUpdateTags* = Call_VirtualNetworkGatewayConnectionsUpdateTags_574253(
    name: "virtualNetworkGatewayConnectionsUpdateTags",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsUpdateTags_574254,
    base: "", url: url_VirtualNetworkGatewayConnectionsUpdateTags_574255,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsDelete_574242 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewayConnectionsDelete_574244(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsDelete_574243(path: JsonNode;
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
  var valid_574245 = path.getOrDefault("resourceGroupName")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "resourceGroupName", valid_574245
  var valid_574246 = path.getOrDefault("subscriptionId")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "subscriptionId", valid_574246
  var valid_574247 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_574247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574248 = query.getOrDefault("api-version")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "api-version", valid_574248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574249: Call_VirtualNetworkGatewayConnectionsDelete_574242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified virtual network Gateway connection.
  ## 
  let valid = call_574249.validator(path, query, header, formData, body)
  let scheme = call_574249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574249.url(scheme.get, call_574249.host, call_574249.base,
                         call_574249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574249, url, valid)

proc call*(call_574250: Call_VirtualNetworkGatewayConnectionsDelete_574242;
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
  var path_574251 = newJObject()
  var query_574252 = newJObject()
  add(path_574251, "resourceGroupName", newJString(resourceGroupName))
  add(query_574252, "api-version", newJString(apiVersion))
  add(path_574251, "subscriptionId", newJString(subscriptionId))
  add(path_574251, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_574250.call(path_574251, query_574252, nil, nil, nil)

var virtualNetworkGatewayConnectionsDelete* = Call_VirtualNetworkGatewayConnectionsDelete_574242(
    name: "virtualNetworkGatewayConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsDelete_574243, base: "",
    url: url_VirtualNetworkGatewayConnectionsDelete_574244,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsSetSharedKey_574277 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewayConnectionsSetSharedKey_574279(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsSetSharedKey_574278(path: JsonNode;
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
  var valid_574280 = path.getOrDefault("resourceGroupName")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = nil)
  if valid_574280 != nil:
    section.add "resourceGroupName", valid_574280
  var valid_574281 = path.getOrDefault("subscriptionId")
  valid_574281 = validateParameter(valid_574281, JString, required = true,
                                 default = nil)
  if valid_574281 != nil:
    section.add "subscriptionId", valid_574281
  var valid_574282 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_574282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574283 = query.getOrDefault("api-version")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "api-version", valid_574283
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

proc call*(call_574285: Call_VirtualNetworkGatewayConnectionsSetSharedKey_574277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGatewayConnectionSharedKey operation sets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_574285.validator(path, query, header, formData, body)
  let scheme = call_574285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574285.url(scheme.get, call_574285.host, call_574285.base,
                         call_574285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574285, url, valid)

proc call*(call_574286: Call_VirtualNetworkGatewayConnectionsSetSharedKey_574277;
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
  var path_574287 = newJObject()
  var query_574288 = newJObject()
  var body_574289 = newJObject()
  add(path_574287, "resourceGroupName", newJString(resourceGroupName))
  add(query_574288, "api-version", newJString(apiVersion))
  add(path_574287, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574289 = parameters
  add(path_574287, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_574286.call(path_574287, query_574288, nil, nil, body_574289)

var virtualNetworkGatewayConnectionsSetSharedKey* = Call_VirtualNetworkGatewayConnectionsSetSharedKey_574277(
    name: "virtualNetworkGatewayConnectionsSetSharedKey",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey",
    validator: validate_VirtualNetworkGatewayConnectionsSetSharedKey_574278,
    base: "", url: url_VirtualNetworkGatewayConnectionsSetSharedKey_574279,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsGetSharedKey_574266 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewayConnectionsGetSharedKey_574268(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsGetSharedKey_574267(path: JsonNode;
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
  var valid_574269 = path.getOrDefault("resourceGroupName")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "resourceGroupName", valid_574269
  var valid_574270 = path.getOrDefault("subscriptionId")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "subscriptionId", valid_574270
  var valid_574271 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_574271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574272 = query.getOrDefault("api-version")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "api-version", valid_574272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574273: Call_VirtualNetworkGatewayConnectionsGetSharedKey_574266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get VirtualNetworkGatewayConnectionSharedKey operation retrieves information about the specified virtual network gateway connection shared key through Network resource provider.
  ## 
  let valid = call_574273.validator(path, query, header, formData, body)
  let scheme = call_574273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574273.url(scheme.get, call_574273.host, call_574273.base,
                         call_574273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574273, url, valid)

proc call*(call_574274: Call_VirtualNetworkGatewayConnectionsGetSharedKey_574266;
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
  var path_574275 = newJObject()
  var query_574276 = newJObject()
  add(path_574275, "resourceGroupName", newJString(resourceGroupName))
  add(query_574276, "api-version", newJString(apiVersion))
  add(path_574275, "subscriptionId", newJString(subscriptionId))
  add(path_574275, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_574274.call(path_574275, query_574276, nil, nil, nil)

var virtualNetworkGatewayConnectionsGetSharedKey* = Call_VirtualNetworkGatewayConnectionsGetSharedKey_574266(
    name: "virtualNetworkGatewayConnectionsGetSharedKey",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey",
    validator: validate_VirtualNetworkGatewayConnectionsGetSharedKey_574267,
    base: "", url: url_VirtualNetworkGatewayConnectionsGetSharedKey_574268,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsResetSharedKey_574290 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewayConnectionsResetSharedKey_574292(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsResetSharedKey_574291(
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
  var valid_574303 = path.getOrDefault("resourceGroupName")
  valid_574303 = validateParameter(valid_574303, JString, required = true,
                                 default = nil)
  if valid_574303 != nil:
    section.add "resourceGroupName", valid_574303
  var valid_574304 = path.getOrDefault("subscriptionId")
  valid_574304 = validateParameter(valid_574304, JString, required = true,
                                 default = nil)
  if valid_574304 != nil:
    section.add "subscriptionId", valid_574304
  var valid_574305 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_574305 = validateParameter(valid_574305, JString, required = true,
                                 default = nil)
  if valid_574305 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_574305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574306 = query.getOrDefault("api-version")
  valid_574306 = validateParameter(valid_574306, JString, required = true,
                                 default = nil)
  if valid_574306 != nil:
    section.add "api-version", valid_574306
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

proc call*(call_574308: Call_VirtualNetworkGatewayConnectionsResetSharedKey_574290;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The VirtualNetworkGatewayConnectionResetSharedKey operation resets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_574308.validator(path, query, header, formData, body)
  let scheme = call_574308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574308.url(scheme.get, call_574308.host, call_574308.base,
                         call_574308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574308, url, valid)

proc call*(call_574309: Call_VirtualNetworkGatewayConnectionsResetSharedKey_574290;
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
  var path_574310 = newJObject()
  var query_574311 = newJObject()
  var body_574312 = newJObject()
  add(path_574310, "resourceGroupName", newJString(resourceGroupName))
  add(query_574311, "api-version", newJString(apiVersion))
  add(path_574310, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574312 = parameters
  add(path_574310, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_574309.call(path_574310, query_574311, nil, nil, body_574312)

var virtualNetworkGatewayConnectionsResetSharedKey* = Call_VirtualNetworkGatewayConnectionsResetSharedKey_574290(
    name: "virtualNetworkGatewayConnectionsResetSharedKey",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey/reset",
    validator: validate_VirtualNetworkGatewayConnectionsResetSharedKey_574291,
    base: "", url: url_VirtualNetworkGatewayConnectionsResetSharedKey_574292,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsStartPacketCapture_574313 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewayConnectionsStartPacketCapture_574315(
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
               (kind: ConstantSegment, value: "/startPacketCapture")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsStartPacketCapture_574314(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Starts packet capture on virtual network gateway connection in the specified resource group.
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
  var valid_574316 = path.getOrDefault("resourceGroupName")
  valid_574316 = validateParameter(valid_574316, JString, required = true,
                                 default = nil)
  if valid_574316 != nil:
    section.add "resourceGroupName", valid_574316
  var valid_574317 = path.getOrDefault("subscriptionId")
  valid_574317 = validateParameter(valid_574317, JString, required = true,
                                 default = nil)
  if valid_574317 != nil:
    section.add "subscriptionId", valid_574317
  var valid_574318 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_574318 = validateParameter(valid_574318, JString, required = true,
                                 default = nil)
  if valid_574318 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_574318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574319 = query.getOrDefault("api-version")
  valid_574319 = validateParameter(valid_574319, JString, required = true,
                                 default = nil)
  if valid_574319 != nil:
    section.add "api-version", valid_574319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Virtual network gateway packet capture parameters supplied to start packet capture on gateway connection.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574321: Call_VirtualNetworkGatewayConnectionsStartPacketCapture_574313;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts packet capture on virtual network gateway connection in the specified resource group.
  ## 
  let valid = call_574321.validator(path, query, header, formData, body)
  let scheme = call_574321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574321.url(scheme.get, call_574321.host, call_574321.base,
                         call_574321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574321, url, valid)

proc call*(call_574322: Call_VirtualNetworkGatewayConnectionsStartPacketCapture_574313;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayConnectionName: string; parameters: JsonNode = nil): Recallable =
  ## virtualNetworkGatewayConnectionsStartPacketCapture
  ## Starts packet capture on virtual network gateway connection in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject
  ##             : Virtual network gateway packet capture parameters supplied to start packet capture on gateway connection.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The name of the virtual network gateway connection.
  var path_574323 = newJObject()
  var query_574324 = newJObject()
  var body_574325 = newJObject()
  add(path_574323, "resourceGroupName", newJString(resourceGroupName))
  add(query_574324, "api-version", newJString(apiVersion))
  add(path_574323, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574325 = parameters
  add(path_574323, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_574322.call(path_574323, query_574324, nil, nil, body_574325)

var virtualNetworkGatewayConnectionsStartPacketCapture* = Call_VirtualNetworkGatewayConnectionsStartPacketCapture_574313(
    name: "virtualNetworkGatewayConnectionsStartPacketCapture",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/startPacketCapture",
    validator: validate_VirtualNetworkGatewayConnectionsStartPacketCapture_574314,
    base: "", url: url_VirtualNetworkGatewayConnectionsStartPacketCapture_574315,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsStopPacketCapture_574326 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewayConnectionsStopPacketCapture_574328(
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
               (kind: ConstantSegment, value: "/stopPacketCapture")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsStopPacketCapture_574327(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Stops packet capture on virtual network gateway connection in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The name of the virtual network gateway Connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574329 = path.getOrDefault("resourceGroupName")
  valid_574329 = validateParameter(valid_574329, JString, required = true,
                                 default = nil)
  if valid_574329 != nil:
    section.add "resourceGroupName", valid_574329
  var valid_574330 = path.getOrDefault("subscriptionId")
  valid_574330 = validateParameter(valid_574330, JString, required = true,
                                 default = nil)
  if valid_574330 != nil:
    section.add "subscriptionId", valid_574330
  var valid_574331 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_574331 = validateParameter(valid_574331, JString, required = true,
                                 default = nil)
  if valid_574331 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_574331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574332 = query.getOrDefault("api-version")
  valid_574332 = validateParameter(valid_574332, JString, required = true,
                                 default = nil)
  if valid_574332 != nil:
    section.add "api-version", valid_574332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Virtual network gateway packet capture parameters supplied to stop packet capture on gateway connection.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574334: Call_VirtualNetworkGatewayConnectionsStopPacketCapture_574326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops packet capture on virtual network gateway connection in the specified resource group.
  ## 
  let valid = call_574334.validator(path, query, header, formData, body)
  let scheme = call_574334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574334.url(scheme.get, call_574334.host, call_574334.base,
                         call_574334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574334, url, valid)

proc call*(call_574335: Call_VirtualNetworkGatewayConnectionsStopPacketCapture_574326;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; virtualNetworkGatewayConnectionName: string): Recallable =
  ## virtualNetworkGatewayConnectionsStopPacketCapture
  ## Stops packet capture on virtual network gateway connection in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Virtual network gateway packet capture parameters supplied to stop packet capture on gateway connection.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The name of the virtual network gateway Connection.
  var path_574336 = newJObject()
  var query_574337 = newJObject()
  var body_574338 = newJObject()
  add(path_574336, "resourceGroupName", newJString(resourceGroupName))
  add(query_574337, "api-version", newJString(apiVersion))
  add(path_574336, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574338 = parameters
  add(path_574336, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_574335.call(path_574336, query_574337, nil, nil, body_574338)

var virtualNetworkGatewayConnectionsStopPacketCapture* = Call_VirtualNetworkGatewayConnectionsStopPacketCapture_574326(
    name: "virtualNetworkGatewayConnectionsStopPacketCapture",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/stopPacketCapture",
    validator: validate_VirtualNetworkGatewayConnectionsStopPacketCapture_574327,
    base: "", url: url_VirtualNetworkGatewayConnectionsStopPacketCapture_574328,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysVpnDeviceConfigurationScript_574339 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysVpnDeviceConfigurationScript_574341(
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

proc validate_VirtualNetworkGatewaysVpnDeviceConfigurationScript_574340(
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
  var valid_574342 = path.getOrDefault("resourceGroupName")
  valid_574342 = validateParameter(valid_574342, JString, required = true,
                                 default = nil)
  if valid_574342 != nil:
    section.add "resourceGroupName", valid_574342
  var valid_574343 = path.getOrDefault("subscriptionId")
  valid_574343 = validateParameter(valid_574343, JString, required = true,
                                 default = nil)
  if valid_574343 != nil:
    section.add "subscriptionId", valid_574343
  var valid_574344 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_574344 = validateParameter(valid_574344, JString, required = true,
                                 default = nil)
  if valid_574344 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_574344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574345 = query.getOrDefault("api-version")
  valid_574345 = validateParameter(valid_574345, JString, required = true,
                                 default = nil)
  if valid_574345 != nil:
    section.add "api-version", valid_574345
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

proc call*(call_574347: Call_VirtualNetworkGatewaysVpnDeviceConfigurationScript_574339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a xml format representation for vpn device configuration script.
  ## 
  let valid = call_574347.validator(path, query, header, formData, body)
  let scheme = call_574347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574347.url(scheme.get, call_574347.host, call_574347.base,
                         call_574347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574347, url, valid)

proc call*(call_574348: Call_VirtualNetworkGatewaysVpnDeviceConfigurationScript_574339;
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
  var path_574349 = newJObject()
  var query_574350 = newJObject()
  var body_574351 = newJObject()
  add(path_574349, "resourceGroupName", newJString(resourceGroupName))
  add(query_574350, "api-version", newJString(apiVersion))
  add(path_574349, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574351 = parameters
  add(path_574349, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_574348.call(path_574349, query_574350, nil, nil, body_574351)

var virtualNetworkGatewaysVpnDeviceConfigurationScript* = Call_VirtualNetworkGatewaysVpnDeviceConfigurationScript_574339(
    name: "virtualNetworkGatewaysVpnDeviceConfigurationScript",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/vpndeviceconfigurationscript",
    validator: validate_VirtualNetworkGatewaysVpnDeviceConfigurationScript_574340,
    base: "", url: url_VirtualNetworkGatewaysVpnDeviceConfigurationScript_574341,
    schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysList_574352 = ref object of OpenApiRestCall_573666
proc url_LocalNetworkGatewaysList_574354(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysList_574353(path: JsonNode; query: JsonNode;
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
  var valid_574355 = path.getOrDefault("resourceGroupName")
  valid_574355 = validateParameter(valid_574355, JString, required = true,
                                 default = nil)
  if valid_574355 != nil:
    section.add "resourceGroupName", valid_574355
  var valid_574356 = path.getOrDefault("subscriptionId")
  valid_574356 = validateParameter(valid_574356, JString, required = true,
                                 default = nil)
  if valid_574356 != nil:
    section.add "subscriptionId", valid_574356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574357 = query.getOrDefault("api-version")
  valid_574357 = validateParameter(valid_574357, JString, required = true,
                                 default = nil)
  if valid_574357 != nil:
    section.add "api-version", valid_574357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574358: Call_LocalNetworkGatewaysList_574352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the local network gateways in a resource group.
  ## 
  let valid = call_574358.validator(path, query, header, formData, body)
  let scheme = call_574358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574358.url(scheme.get, call_574358.host, call_574358.base,
                         call_574358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574358, url, valid)

proc call*(call_574359: Call_LocalNetworkGatewaysList_574352;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## localNetworkGatewaysList
  ## Gets all the local network gateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574360 = newJObject()
  var query_574361 = newJObject()
  add(path_574360, "resourceGroupName", newJString(resourceGroupName))
  add(query_574361, "api-version", newJString(apiVersion))
  add(path_574360, "subscriptionId", newJString(subscriptionId))
  result = call_574359.call(path_574360, query_574361, nil, nil, nil)

var localNetworkGatewaysList* = Call_LocalNetworkGatewaysList_574352(
    name: "localNetworkGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways",
    validator: validate_LocalNetworkGatewaysList_574353, base: "",
    url: url_LocalNetworkGatewaysList_574354, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysCreateOrUpdate_574373 = ref object of OpenApiRestCall_573666
proc url_LocalNetworkGatewaysCreateOrUpdate_574375(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysCreateOrUpdate_574374(path: JsonNode;
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
  var valid_574376 = path.getOrDefault("resourceGroupName")
  valid_574376 = validateParameter(valid_574376, JString, required = true,
                                 default = nil)
  if valid_574376 != nil:
    section.add "resourceGroupName", valid_574376
  var valid_574377 = path.getOrDefault("localNetworkGatewayName")
  valid_574377 = validateParameter(valid_574377, JString, required = true,
                                 default = nil)
  if valid_574377 != nil:
    section.add "localNetworkGatewayName", valid_574377
  var valid_574378 = path.getOrDefault("subscriptionId")
  valid_574378 = validateParameter(valid_574378, JString, required = true,
                                 default = nil)
  if valid_574378 != nil:
    section.add "subscriptionId", valid_574378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574379 = query.getOrDefault("api-version")
  valid_574379 = validateParameter(valid_574379, JString, required = true,
                                 default = nil)
  if valid_574379 != nil:
    section.add "api-version", valid_574379
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

proc call*(call_574381: Call_LocalNetworkGatewaysCreateOrUpdate_574373;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a local network gateway in the specified resource group.
  ## 
  let valid = call_574381.validator(path, query, header, formData, body)
  let scheme = call_574381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574381.url(scheme.get, call_574381.host, call_574381.base,
                         call_574381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574381, url, valid)

proc call*(call_574382: Call_LocalNetworkGatewaysCreateOrUpdate_574373;
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
  var path_574383 = newJObject()
  var query_574384 = newJObject()
  var body_574385 = newJObject()
  add(path_574383, "resourceGroupName", newJString(resourceGroupName))
  add(path_574383, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_574384, "api-version", newJString(apiVersion))
  add(path_574383, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574385 = parameters
  result = call_574382.call(path_574383, query_574384, nil, nil, body_574385)

var localNetworkGatewaysCreateOrUpdate* = Call_LocalNetworkGatewaysCreateOrUpdate_574373(
    name: "localNetworkGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysCreateOrUpdate_574374, base: "",
    url: url_LocalNetworkGatewaysCreateOrUpdate_574375, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysGet_574362 = ref object of OpenApiRestCall_573666
proc url_LocalNetworkGatewaysGet_574364(protocol: Scheme; host: string; base: string;
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

proc validate_LocalNetworkGatewaysGet_574363(path: JsonNode; query: JsonNode;
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
  var valid_574365 = path.getOrDefault("resourceGroupName")
  valid_574365 = validateParameter(valid_574365, JString, required = true,
                                 default = nil)
  if valid_574365 != nil:
    section.add "resourceGroupName", valid_574365
  var valid_574366 = path.getOrDefault("localNetworkGatewayName")
  valid_574366 = validateParameter(valid_574366, JString, required = true,
                                 default = nil)
  if valid_574366 != nil:
    section.add "localNetworkGatewayName", valid_574366
  var valid_574367 = path.getOrDefault("subscriptionId")
  valid_574367 = validateParameter(valid_574367, JString, required = true,
                                 default = nil)
  if valid_574367 != nil:
    section.add "subscriptionId", valid_574367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574368 = query.getOrDefault("api-version")
  valid_574368 = validateParameter(valid_574368, JString, required = true,
                                 default = nil)
  if valid_574368 != nil:
    section.add "api-version", valid_574368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574369: Call_LocalNetworkGatewaysGet_574362; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified local network gateway in a resource group.
  ## 
  let valid = call_574369.validator(path, query, header, formData, body)
  let scheme = call_574369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574369.url(scheme.get, call_574369.host, call_574369.base,
                         call_574369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574369, url, valid)

proc call*(call_574370: Call_LocalNetworkGatewaysGet_574362;
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
  var path_574371 = newJObject()
  var query_574372 = newJObject()
  add(path_574371, "resourceGroupName", newJString(resourceGroupName))
  add(path_574371, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_574372, "api-version", newJString(apiVersion))
  add(path_574371, "subscriptionId", newJString(subscriptionId))
  result = call_574370.call(path_574371, query_574372, nil, nil, nil)

var localNetworkGatewaysGet* = Call_LocalNetworkGatewaysGet_574362(
    name: "localNetworkGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysGet_574363, base: "",
    url: url_LocalNetworkGatewaysGet_574364, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysUpdateTags_574397 = ref object of OpenApiRestCall_573666
proc url_LocalNetworkGatewaysUpdateTags_574399(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysUpdateTags_574398(path: JsonNode;
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
  var valid_574400 = path.getOrDefault("resourceGroupName")
  valid_574400 = validateParameter(valid_574400, JString, required = true,
                                 default = nil)
  if valid_574400 != nil:
    section.add "resourceGroupName", valid_574400
  var valid_574401 = path.getOrDefault("localNetworkGatewayName")
  valid_574401 = validateParameter(valid_574401, JString, required = true,
                                 default = nil)
  if valid_574401 != nil:
    section.add "localNetworkGatewayName", valid_574401
  var valid_574402 = path.getOrDefault("subscriptionId")
  valid_574402 = validateParameter(valid_574402, JString, required = true,
                                 default = nil)
  if valid_574402 != nil:
    section.add "subscriptionId", valid_574402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574403 = query.getOrDefault("api-version")
  valid_574403 = validateParameter(valid_574403, JString, required = true,
                                 default = nil)
  if valid_574403 != nil:
    section.add "api-version", valid_574403
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

proc call*(call_574405: Call_LocalNetworkGatewaysUpdateTags_574397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a local network gateway tags.
  ## 
  let valid = call_574405.validator(path, query, header, formData, body)
  let scheme = call_574405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574405.url(scheme.get, call_574405.host, call_574405.base,
                         call_574405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574405, url, valid)

proc call*(call_574406: Call_LocalNetworkGatewaysUpdateTags_574397;
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
  var path_574407 = newJObject()
  var query_574408 = newJObject()
  var body_574409 = newJObject()
  add(path_574407, "resourceGroupName", newJString(resourceGroupName))
  add(path_574407, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_574408, "api-version", newJString(apiVersion))
  add(path_574407, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574409 = parameters
  result = call_574406.call(path_574407, query_574408, nil, nil, body_574409)

var localNetworkGatewaysUpdateTags* = Call_LocalNetworkGatewaysUpdateTags_574397(
    name: "localNetworkGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysUpdateTags_574398, base: "",
    url: url_LocalNetworkGatewaysUpdateTags_574399, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysDelete_574386 = ref object of OpenApiRestCall_573666
proc url_LocalNetworkGatewaysDelete_574388(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysDelete_574387(path: JsonNode; query: JsonNode;
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
  var valid_574389 = path.getOrDefault("resourceGroupName")
  valid_574389 = validateParameter(valid_574389, JString, required = true,
                                 default = nil)
  if valid_574389 != nil:
    section.add "resourceGroupName", valid_574389
  var valid_574390 = path.getOrDefault("localNetworkGatewayName")
  valid_574390 = validateParameter(valid_574390, JString, required = true,
                                 default = nil)
  if valid_574390 != nil:
    section.add "localNetworkGatewayName", valid_574390
  var valid_574391 = path.getOrDefault("subscriptionId")
  valid_574391 = validateParameter(valid_574391, JString, required = true,
                                 default = nil)
  if valid_574391 != nil:
    section.add "subscriptionId", valid_574391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574392 = query.getOrDefault("api-version")
  valid_574392 = validateParameter(valid_574392, JString, required = true,
                                 default = nil)
  if valid_574392 != nil:
    section.add "api-version", valid_574392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574393: Call_LocalNetworkGatewaysDelete_574386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified local network gateway.
  ## 
  let valid = call_574393.validator(path, query, header, formData, body)
  let scheme = call_574393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574393.url(scheme.get, call_574393.host, call_574393.base,
                         call_574393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574393, url, valid)

proc call*(call_574394: Call_LocalNetworkGatewaysDelete_574386;
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
  var path_574395 = newJObject()
  var query_574396 = newJObject()
  add(path_574395, "resourceGroupName", newJString(resourceGroupName))
  add(path_574395, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_574396, "api-version", newJString(apiVersion))
  add(path_574395, "subscriptionId", newJString(subscriptionId))
  result = call_574394.call(path_574395, query_574396, nil, nil, nil)

var localNetworkGatewaysDelete* = Call_LocalNetworkGatewaysDelete_574386(
    name: "localNetworkGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysDelete_574387, base: "",
    url: url_LocalNetworkGatewaysDelete_574388, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysList_574410 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysList_574412(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysList_574411(path: JsonNode; query: JsonNode;
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
  var valid_574413 = path.getOrDefault("resourceGroupName")
  valid_574413 = validateParameter(valid_574413, JString, required = true,
                                 default = nil)
  if valid_574413 != nil:
    section.add "resourceGroupName", valid_574413
  var valid_574414 = path.getOrDefault("subscriptionId")
  valid_574414 = validateParameter(valid_574414, JString, required = true,
                                 default = nil)
  if valid_574414 != nil:
    section.add "subscriptionId", valid_574414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574415 = query.getOrDefault("api-version")
  valid_574415 = validateParameter(valid_574415, JString, required = true,
                                 default = nil)
  if valid_574415 != nil:
    section.add "api-version", valid_574415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574416: Call_VirtualNetworkGatewaysList_574410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all virtual network gateways by resource group.
  ## 
  let valid = call_574416.validator(path, query, header, formData, body)
  let scheme = call_574416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574416.url(scheme.get, call_574416.host, call_574416.base,
                         call_574416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574416, url, valid)

proc call*(call_574417: Call_VirtualNetworkGatewaysList_574410;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworkGatewaysList
  ## Gets all virtual network gateways by resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574418 = newJObject()
  var query_574419 = newJObject()
  add(path_574418, "resourceGroupName", newJString(resourceGroupName))
  add(query_574419, "api-version", newJString(apiVersion))
  add(path_574418, "subscriptionId", newJString(subscriptionId))
  result = call_574417.call(path_574418, query_574419, nil, nil, nil)

var virtualNetworkGatewaysList* = Call_VirtualNetworkGatewaysList_574410(
    name: "virtualNetworkGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways",
    validator: validate_VirtualNetworkGatewaysList_574411, base: "",
    url: url_VirtualNetworkGatewaysList_574412, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysCreateOrUpdate_574431 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysCreateOrUpdate_574433(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysCreateOrUpdate_574432(path: JsonNode;
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
  var valid_574434 = path.getOrDefault("resourceGroupName")
  valid_574434 = validateParameter(valid_574434, JString, required = true,
                                 default = nil)
  if valid_574434 != nil:
    section.add "resourceGroupName", valid_574434
  var valid_574435 = path.getOrDefault("subscriptionId")
  valid_574435 = validateParameter(valid_574435, JString, required = true,
                                 default = nil)
  if valid_574435 != nil:
    section.add "subscriptionId", valid_574435
  var valid_574436 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574436 = validateParameter(valid_574436, JString, required = true,
                                 default = nil)
  if valid_574436 != nil:
    section.add "virtualNetworkGatewayName", valid_574436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574437 = query.getOrDefault("api-version")
  valid_574437 = validateParameter(valid_574437, JString, required = true,
                                 default = nil)
  if valid_574437 != nil:
    section.add "api-version", valid_574437
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

proc call*(call_574439: Call_VirtualNetworkGatewaysCreateOrUpdate_574431;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a virtual network gateway in the specified resource group.
  ## 
  let valid = call_574439.validator(path, query, header, formData, body)
  let scheme = call_574439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574439.url(scheme.get, call_574439.host, call_574439.base,
                         call_574439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574439, url, valid)

proc call*(call_574440: Call_VirtualNetworkGatewaysCreateOrUpdate_574431;
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
  var path_574441 = newJObject()
  var query_574442 = newJObject()
  var body_574443 = newJObject()
  add(path_574441, "resourceGroupName", newJString(resourceGroupName))
  add(query_574442, "api-version", newJString(apiVersion))
  add(path_574441, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574443 = parameters
  add(path_574441, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574440.call(path_574441, query_574442, nil, nil, body_574443)

var virtualNetworkGatewaysCreateOrUpdate* = Call_VirtualNetworkGatewaysCreateOrUpdate_574431(
    name: "virtualNetworkGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysCreateOrUpdate_574432, base: "",
    url: url_VirtualNetworkGatewaysCreateOrUpdate_574433, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGet_574420 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysGet_574422(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysGet_574421(path: JsonNode; query: JsonNode;
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
  var valid_574423 = path.getOrDefault("resourceGroupName")
  valid_574423 = validateParameter(valid_574423, JString, required = true,
                                 default = nil)
  if valid_574423 != nil:
    section.add "resourceGroupName", valid_574423
  var valid_574424 = path.getOrDefault("subscriptionId")
  valid_574424 = validateParameter(valid_574424, JString, required = true,
                                 default = nil)
  if valid_574424 != nil:
    section.add "subscriptionId", valid_574424
  var valid_574425 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574425 = validateParameter(valid_574425, JString, required = true,
                                 default = nil)
  if valid_574425 != nil:
    section.add "virtualNetworkGatewayName", valid_574425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574426 = query.getOrDefault("api-version")
  valid_574426 = validateParameter(valid_574426, JString, required = true,
                                 default = nil)
  if valid_574426 != nil:
    section.add "api-version", valid_574426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574427: Call_VirtualNetworkGatewaysGet_574420; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified virtual network gateway by resource group.
  ## 
  let valid = call_574427.validator(path, query, header, formData, body)
  let scheme = call_574427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574427.url(scheme.get, call_574427.host, call_574427.base,
                         call_574427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574427, url, valid)

proc call*(call_574428: Call_VirtualNetworkGatewaysGet_574420;
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
  var path_574429 = newJObject()
  var query_574430 = newJObject()
  add(path_574429, "resourceGroupName", newJString(resourceGroupName))
  add(query_574430, "api-version", newJString(apiVersion))
  add(path_574429, "subscriptionId", newJString(subscriptionId))
  add(path_574429, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574428.call(path_574429, query_574430, nil, nil, nil)

var virtualNetworkGatewaysGet* = Call_VirtualNetworkGatewaysGet_574420(
    name: "virtualNetworkGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysGet_574421, base: "",
    url: url_VirtualNetworkGatewaysGet_574422, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysUpdateTags_574455 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysUpdateTags_574457(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysUpdateTags_574456(path: JsonNode;
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
  var valid_574458 = path.getOrDefault("resourceGroupName")
  valid_574458 = validateParameter(valid_574458, JString, required = true,
                                 default = nil)
  if valid_574458 != nil:
    section.add "resourceGroupName", valid_574458
  var valid_574459 = path.getOrDefault("subscriptionId")
  valid_574459 = validateParameter(valid_574459, JString, required = true,
                                 default = nil)
  if valid_574459 != nil:
    section.add "subscriptionId", valid_574459
  var valid_574460 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574460 = validateParameter(valid_574460, JString, required = true,
                                 default = nil)
  if valid_574460 != nil:
    section.add "virtualNetworkGatewayName", valid_574460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574461 = query.getOrDefault("api-version")
  valid_574461 = validateParameter(valid_574461, JString, required = true,
                                 default = nil)
  if valid_574461 != nil:
    section.add "api-version", valid_574461
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

proc call*(call_574463: Call_VirtualNetworkGatewaysUpdateTags_574455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a virtual network gateway tags.
  ## 
  let valid = call_574463.validator(path, query, header, formData, body)
  let scheme = call_574463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574463.url(scheme.get, call_574463.host, call_574463.base,
                         call_574463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574463, url, valid)

proc call*(call_574464: Call_VirtualNetworkGatewaysUpdateTags_574455;
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
  var path_574465 = newJObject()
  var query_574466 = newJObject()
  var body_574467 = newJObject()
  add(path_574465, "resourceGroupName", newJString(resourceGroupName))
  add(query_574466, "api-version", newJString(apiVersion))
  add(path_574465, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574467 = parameters
  add(path_574465, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574464.call(path_574465, query_574466, nil, nil, body_574467)

var virtualNetworkGatewaysUpdateTags* = Call_VirtualNetworkGatewaysUpdateTags_574455(
    name: "virtualNetworkGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysUpdateTags_574456, base: "",
    url: url_VirtualNetworkGatewaysUpdateTags_574457, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysDelete_574444 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysDelete_574446(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysDelete_574445(path: JsonNode; query: JsonNode;
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
  var valid_574447 = path.getOrDefault("resourceGroupName")
  valid_574447 = validateParameter(valid_574447, JString, required = true,
                                 default = nil)
  if valid_574447 != nil:
    section.add "resourceGroupName", valid_574447
  var valid_574448 = path.getOrDefault("subscriptionId")
  valid_574448 = validateParameter(valid_574448, JString, required = true,
                                 default = nil)
  if valid_574448 != nil:
    section.add "subscriptionId", valid_574448
  var valid_574449 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574449 = validateParameter(valid_574449, JString, required = true,
                                 default = nil)
  if valid_574449 != nil:
    section.add "virtualNetworkGatewayName", valid_574449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574450 = query.getOrDefault("api-version")
  valid_574450 = validateParameter(valid_574450, JString, required = true,
                                 default = nil)
  if valid_574450 != nil:
    section.add "api-version", valid_574450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574451: Call_VirtualNetworkGatewaysDelete_574444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified virtual network gateway.
  ## 
  let valid = call_574451.validator(path, query, header, formData, body)
  let scheme = call_574451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574451.url(scheme.get, call_574451.host, call_574451.base,
                         call_574451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574451, url, valid)

proc call*(call_574452: Call_VirtualNetworkGatewaysDelete_574444;
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
  var path_574453 = newJObject()
  var query_574454 = newJObject()
  add(path_574453, "resourceGroupName", newJString(resourceGroupName))
  add(query_574454, "api-version", newJString(apiVersion))
  add(path_574453, "subscriptionId", newJString(subscriptionId))
  add(path_574453, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574452.call(path_574453, query_574454, nil, nil, nil)

var virtualNetworkGatewaysDelete* = Call_VirtualNetworkGatewaysDelete_574444(
    name: "virtualNetworkGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysDelete_574445, base: "",
    url: url_VirtualNetworkGatewaysDelete_574446, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysListConnections_574468 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysListConnections_574470(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysListConnections_574469(path: JsonNode;
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
  var valid_574471 = path.getOrDefault("resourceGroupName")
  valid_574471 = validateParameter(valid_574471, JString, required = true,
                                 default = nil)
  if valid_574471 != nil:
    section.add "resourceGroupName", valid_574471
  var valid_574472 = path.getOrDefault("subscriptionId")
  valid_574472 = validateParameter(valid_574472, JString, required = true,
                                 default = nil)
  if valid_574472 != nil:
    section.add "subscriptionId", valid_574472
  var valid_574473 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574473 = validateParameter(valid_574473, JString, required = true,
                                 default = nil)
  if valid_574473 != nil:
    section.add "virtualNetworkGatewayName", valid_574473
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574474 = query.getOrDefault("api-version")
  valid_574474 = validateParameter(valid_574474, JString, required = true,
                                 default = nil)
  if valid_574474 != nil:
    section.add "api-version", valid_574474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574475: Call_VirtualNetworkGatewaysListConnections_574468;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the connections in a virtual network gateway.
  ## 
  let valid = call_574475.validator(path, query, header, formData, body)
  let scheme = call_574475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574475.url(scheme.get, call_574475.host, call_574475.base,
                         call_574475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574475, url, valid)

proc call*(call_574476: Call_VirtualNetworkGatewaysListConnections_574468;
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
  var path_574477 = newJObject()
  var query_574478 = newJObject()
  add(path_574477, "resourceGroupName", newJString(resourceGroupName))
  add(query_574478, "api-version", newJString(apiVersion))
  add(path_574477, "subscriptionId", newJString(subscriptionId))
  add(path_574477, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574476.call(path_574477, query_574478, nil, nil, nil)

var virtualNetworkGatewaysListConnections* = Call_VirtualNetworkGatewaysListConnections_574468(
    name: "virtualNetworkGatewaysListConnections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/connections",
    validator: validate_VirtualNetworkGatewaysListConnections_574469, base: "",
    url: url_VirtualNetworkGatewaysListConnections_574470, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGeneratevpnclientpackage_574479 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysGeneratevpnclientpackage_574481(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysGeneratevpnclientpackage_574480(
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
  var valid_574482 = path.getOrDefault("resourceGroupName")
  valid_574482 = validateParameter(valid_574482, JString, required = true,
                                 default = nil)
  if valid_574482 != nil:
    section.add "resourceGroupName", valid_574482
  var valid_574483 = path.getOrDefault("subscriptionId")
  valid_574483 = validateParameter(valid_574483, JString, required = true,
                                 default = nil)
  if valid_574483 != nil:
    section.add "subscriptionId", valid_574483
  var valid_574484 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574484 = validateParameter(valid_574484, JString, required = true,
                                 default = nil)
  if valid_574484 != nil:
    section.add "virtualNetworkGatewayName", valid_574484
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574485 = query.getOrDefault("api-version")
  valid_574485 = validateParameter(valid_574485, JString, required = true,
                                 default = nil)
  if valid_574485 != nil:
    section.add "api-version", valid_574485
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

proc call*(call_574487: Call_VirtualNetworkGatewaysGeneratevpnclientpackage_574479;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates VPN client package for P2S client of the virtual network gateway in the specified resource group.
  ## 
  let valid = call_574487.validator(path, query, header, formData, body)
  let scheme = call_574487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574487.url(scheme.get, call_574487.host, call_574487.base,
                         call_574487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574487, url, valid)

proc call*(call_574488: Call_VirtualNetworkGatewaysGeneratevpnclientpackage_574479;
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
  var path_574489 = newJObject()
  var query_574490 = newJObject()
  var body_574491 = newJObject()
  add(path_574489, "resourceGroupName", newJString(resourceGroupName))
  add(query_574490, "api-version", newJString(apiVersion))
  add(path_574489, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574491 = parameters
  add(path_574489, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574488.call(path_574489, query_574490, nil, nil, body_574491)

var virtualNetworkGatewaysGeneratevpnclientpackage* = Call_VirtualNetworkGatewaysGeneratevpnclientpackage_574479(
    name: "virtualNetworkGatewaysGeneratevpnclientpackage",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/generatevpnclientpackage",
    validator: validate_VirtualNetworkGatewaysGeneratevpnclientpackage_574480,
    base: "", url: url_VirtualNetworkGatewaysGeneratevpnclientpackage_574481,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGenerateVpnProfile_574492 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysGenerateVpnProfile_574494(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysGenerateVpnProfile_574493(path: JsonNode;
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
  var valid_574495 = path.getOrDefault("resourceGroupName")
  valid_574495 = validateParameter(valid_574495, JString, required = true,
                                 default = nil)
  if valid_574495 != nil:
    section.add "resourceGroupName", valid_574495
  var valid_574496 = path.getOrDefault("subscriptionId")
  valid_574496 = validateParameter(valid_574496, JString, required = true,
                                 default = nil)
  if valid_574496 != nil:
    section.add "subscriptionId", valid_574496
  var valid_574497 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574497 = validateParameter(valid_574497, JString, required = true,
                                 default = nil)
  if valid_574497 != nil:
    section.add "virtualNetworkGatewayName", valid_574497
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574498 = query.getOrDefault("api-version")
  valid_574498 = validateParameter(valid_574498, JString, required = true,
                                 default = nil)
  if valid_574498 != nil:
    section.add "api-version", valid_574498
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

proc call*(call_574500: Call_VirtualNetworkGatewaysGenerateVpnProfile_574492;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates VPN profile for P2S client of the virtual network gateway in the specified resource group. Used for IKEV2 and radius based authentication.
  ## 
  let valid = call_574500.validator(path, query, header, formData, body)
  let scheme = call_574500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574500.url(scheme.get, call_574500.host, call_574500.base,
                         call_574500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574500, url, valid)

proc call*(call_574501: Call_VirtualNetworkGatewaysGenerateVpnProfile_574492;
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
  var path_574502 = newJObject()
  var query_574503 = newJObject()
  var body_574504 = newJObject()
  add(path_574502, "resourceGroupName", newJString(resourceGroupName))
  add(query_574503, "api-version", newJString(apiVersion))
  add(path_574502, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574504 = parameters
  add(path_574502, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574501.call(path_574502, query_574503, nil, nil, body_574504)

var virtualNetworkGatewaysGenerateVpnProfile* = Call_VirtualNetworkGatewaysGenerateVpnProfile_574492(
    name: "virtualNetworkGatewaysGenerateVpnProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/generatevpnprofile",
    validator: validate_VirtualNetworkGatewaysGenerateVpnProfile_574493, base: "",
    url: url_VirtualNetworkGatewaysGenerateVpnProfile_574494,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGetAdvertisedRoutes_574505 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysGetAdvertisedRoutes_574507(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysGetAdvertisedRoutes_574506(path: JsonNode;
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
  var valid_574508 = path.getOrDefault("resourceGroupName")
  valid_574508 = validateParameter(valid_574508, JString, required = true,
                                 default = nil)
  if valid_574508 != nil:
    section.add "resourceGroupName", valid_574508
  var valid_574509 = path.getOrDefault("subscriptionId")
  valid_574509 = validateParameter(valid_574509, JString, required = true,
                                 default = nil)
  if valid_574509 != nil:
    section.add "subscriptionId", valid_574509
  var valid_574510 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574510 = validateParameter(valid_574510, JString, required = true,
                                 default = nil)
  if valid_574510 != nil:
    section.add "virtualNetworkGatewayName", valid_574510
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   peer: JString (required)
  ##       : The IP address of the peer.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574511 = query.getOrDefault("api-version")
  valid_574511 = validateParameter(valid_574511, JString, required = true,
                                 default = nil)
  if valid_574511 != nil:
    section.add "api-version", valid_574511
  var valid_574512 = query.getOrDefault("peer")
  valid_574512 = validateParameter(valid_574512, JString, required = true,
                                 default = nil)
  if valid_574512 != nil:
    section.add "peer", valid_574512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574513: Call_VirtualNetworkGatewaysGetAdvertisedRoutes_574505;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves a list of routes the virtual network gateway is advertising to the specified peer.
  ## 
  let valid = call_574513.validator(path, query, header, formData, body)
  let scheme = call_574513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574513.url(scheme.get, call_574513.host, call_574513.base,
                         call_574513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574513, url, valid)

proc call*(call_574514: Call_VirtualNetworkGatewaysGetAdvertisedRoutes_574505;
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
  var path_574515 = newJObject()
  var query_574516 = newJObject()
  add(path_574515, "resourceGroupName", newJString(resourceGroupName))
  add(query_574516, "api-version", newJString(apiVersion))
  add(path_574515, "subscriptionId", newJString(subscriptionId))
  add(query_574516, "peer", newJString(peer))
  add(path_574515, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574514.call(path_574515, query_574516, nil, nil, nil)

var virtualNetworkGatewaysGetAdvertisedRoutes* = Call_VirtualNetworkGatewaysGetAdvertisedRoutes_574505(
    name: "virtualNetworkGatewaysGetAdvertisedRoutes", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/getAdvertisedRoutes",
    validator: validate_VirtualNetworkGatewaysGetAdvertisedRoutes_574506,
    base: "", url: url_VirtualNetworkGatewaysGetAdvertisedRoutes_574507,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGetBgpPeerStatus_574517 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysGetBgpPeerStatus_574519(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysGetBgpPeerStatus_574518(path: JsonNode;
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
  var valid_574520 = path.getOrDefault("resourceGroupName")
  valid_574520 = validateParameter(valid_574520, JString, required = true,
                                 default = nil)
  if valid_574520 != nil:
    section.add "resourceGroupName", valid_574520
  var valid_574521 = path.getOrDefault("subscriptionId")
  valid_574521 = validateParameter(valid_574521, JString, required = true,
                                 default = nil)
  if valid_574521 != nil:
    section.add "subscriptionId", valid_574521
  var valid_574522 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574522 = validateParameter(valid_574522, JString, required = true,
                                 default = nil)
  if valid_574522 != nil:
    section.add "virtualNetworkGatewayName", valid_574522
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   peer: JString
  ##       : The IP address of the peer to retrieve the status of.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574523 = query.getOrDefault("api-version")
  valid_574523 = validateParameter(valid_574523, JString, required = true,
                                 default = nil)
  if valid_574523 != nil:
    section.add "api-version", valid_574523
  var valid_574524 = query.getOrDefault("peer")
  valid_574524 = validateParameter(valid_574524, JString, required = false,
                                 default = nil)
  if valid_574524 != nil:
    section.add "peer", valid_574524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574525: Call_VirtualNetworkGatewaysGetBgpPeerStatus_574517;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The GetBgpPeerStatus operation retrieves the status of all BGP peers.
  ## 
  let valid = call_574525.validator(path, query, header, formData, body)
  let scheme = call_574525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574525.url(scheme.get, call_574525.host, call_574525.base,
                         call_574525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574525, url, valid)

proc call*(call_574526: Call_VirtualNetworkGatewaysGetBgpPeerStatus_574517;
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
  var path_574527 = newJObject()
  var query_574528 = newJObject()
  add(path_574527, "resourceGroupName", newJString(resourceGroupName))
  add(query_574528, "api-version", newJString(apiVersion))
  add(path_574527, "subscriptionId", newJString(subscriptionId))
  add(query_574528, "peer", newJString(peer))
  add(path_574527, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574526.call(path_574527, query_574528, nil, nil, nil)

var virtualNetworkGatewaysGetBgpPeerStatus* = Call_VirtualNetworkGatewaysGetBgpPeerStatus_574517(
    name: "virtualNetworkGatewaysGetBgpPeerStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/getBgpPeerStatus",
    validator: validate_VirtualNetworkGatewaysGetBgpPeerStatus_574518, base: "",
    url: url_VirtualNetworkGatewaysGetBgpPeerStatus_574519,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGetLearnedRoutes_574529 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysGetLearnedRoutes_574531(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysGetLearnedRoutes_574530(path: JsonNode;
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
  var valid_574532 = path.getOrDefault("resourceGroupName")
  valid_574532 = validateParameter(valid_574532, JString, required = true,
                                 default = nil)
  if valid_574532 != nil:
    section.add "resourceGroupName", valid_574532
  var valid_574533 = path.getOrDefault("subscriptionId")
  valid_574533 = validateParameter(valid_574533, JString, required = true,
                                 default = nil)
  if valid_574533 != nil:
    section.add "subscriptionId", valid_574533
  var valid_574534 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574534 = validateParameter(valid_574534, JString, required = true,
                                 default = nil)
  if valid_574534 != nil:
    section.add "virtualNetworkGatewayName", valid_574534
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574535 = query.getOrDefault("api-version")
  valid_574535 = validateParameter(valid_574535, JString, required = true,
                                 default = nil)
  if valid_574535 != nil:
    section.add "api-version", valid_574535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574536: Call_VirtualNetworkGatewaysGetLearnedRoutes_574529;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves a list of routes the virtual network gateway has learned, including routes learned from BGP peers.
  ## 
  let valid = call_574536.validator(path, query, header, formData, body)
  let scheme = call_574536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574536.url(scheme.get, call_574536.host, call_574536.base,
                         call_574536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574536, url, valid)

proc call*(call_574537: Call_VirtualNetworkGatewaysGetLearnedRoutes_574529;
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
  var path_574538 = newJObject()
  var query_574539 = newJObject()
  add(path_574538, "resourceGroupName", newJString(resourceGroupName))
  add(query_574539, "api-version", newJString(apiVersion))
  add(path_574538, "subscriptionId", newJString(subscriptionId))
  add(path_574538, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574537.call(path_574538, query_574539, nil, nil, nil)

var virtualNetworkGatewaysGetLearnedRoutes* = Call_VirtualNetworkGatewaysGetLearnedRoutes_574529(
    name: "virtualNetworkGatewaysGetLearnedRoutes", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/getLearnedRoutes",
    validator: validate_VirtualNetworkGatewaysGetLearnedRoutes_574530, base: "",
    url: url_VirtualNetworkGatewaysGetLearnedRoutes_574531,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGetVpnclientConnectionHealth_574540 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysGetVpnclientConnectionHealth_574542(
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

proc validate_VirtualNetworkGatewaysGetVpnclientConnectionHealth_574541(
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
  var valid_574543 = path.getOrDefault("resourceGroupName")
  valid_574543 = validateParameter(valid_574543, JString, required = true,
                                 default = nil)
  if valid_574543 != nil:
    section.add "resourceGroupName", valid_574543
  var valid_574544 = path.getOrDefault("subscriptionId")
  valid_574544 = validateParameter(valid_574544, JString, required = true,
                                 default = nil)
  if valid_574544 != nil:
    section.add "subscriptionId", valid_574544
  var valid_574545 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574545 = validateParameter(valid_574545, JString, required = true,
                                 default = nil)
  if valid_574545 != nil:
    section.add "virtualNetworkGatewayName", valid_574545
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574546 = query.getOrDefault("api-version")
  valid_574546 = validateParameter(valid_574546, JString, required = true,
                                 default = nil)
  if valid_574546 != nil:
    section.add "api-version", valid_574546
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574547: Call_VirtualNetworkGatewaysGetVpnclientConnectionHealth_574540;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get VPN client connection health detail per P2S client connection of the virtual network gateway in the specified resource group.
  ## 
  let valid = call_574547.validator(path, query, header, formData, body)
  let scheme = call_574547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574547.url(scheme.get, call_574547.host, call_574547.base,
                         call_574547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574547, url, valid)

proc call*(call_574548: Call_VirtualNetworkGatewaysGetVpnclientConnectionHealth_574540;
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
  var path_574549 = newJObject()
  var query_574550 = newJObject()
  add(path_574549, "resourceGroupName", newJString(resourceGroupName))
  add(query_574550, "api-version", newJString(apiVersion))
  add(path_574549, "subscriptionId", newJString(subscriptionId))
  add(path_574549, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574548.call(path_574549, query_574550, nil, nil, nil)

var virtualNetworkGatewaysGetVpnclientConnectionHealth* = Call_VirtualNetworkGatewaysGetVpnclientConnectionHealth_574540(
    name: "virtualNetworkGatewaysGetVpnclientConnectionHealth",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/getVpnClientConnectionHealth",
    validator: validate_VirtualNetworkGatewaysGetVpnclientConnectionHealth_574541,
    base: "", url: url_VirtualNetworkGatewaysGetVpnclientConnectionHealth_574542,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGetVpnclientIpsecParameters_574551 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysGetVpnclientIpsecParameters_574553(
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

proc validate_VirtualNetworkGatewaysGetVpnclientIpsecParameters_574552(
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
  var valid_574554 = path.getOrDefault("resourceGroupName")
  valid_574554 = validateParameter(valid_574554, JString, required = true,
                                 default = nil)
  if valid_574554 != nil:
    section.add "resourceGroupName", valid_574554
  var valid_574555 = path.getOrDefault("subscriptionId")
  valid_574555 = validateParameter(valid_574555, JString, required = true,
                                 default = nil)
  if valid_574555 != nil:
    section.add "subscriptionId", valid_574555
  var valid_574556 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574556 = validateParameter(valid_574556, JString, required = true,
                                 default = nil)
  if valid_574556 != nil:
    section.add "virtualNetworkGatewayName", valid_574556
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574557 = query.getOrDefault("api-version")
  valid_574557 = validateParameter(valid_574557, JString, required = true,
                                 default = nil)
  if valid_574557 != nil:
    section.add "api-version", valid_574557
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574558: Call_VirtualNetworkGatewaysGetVpnclientIpsecParameters_574551;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get VpnclientIpsecParameters operation retrieves information about the vpnclient ipsec policy for P2S client of virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_574558.validator(path, query, header, formData, body)
  let scheme = call_574558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574558.url(scheme.get, call_574558.host, call_574558.base,
                         call_574558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574558, url, valid)

proc call*(call_574559: Call_VirtualNetworkGatewaysGetVpnclientIpsecParameters_574551;
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
  var path_574560 = newJObject()
  var query_574561 = newJObject()
  add(path_574560, "resourceGroupName", newJString(resourceGroupName))
  add(query_574561, "api-version", newJString(apiVersion))
  add(path_574560, "subscriptionId", newJString(subscriptionId))
  add(path_574560, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574559.call(path_574560, query_574561, nil, nil, nil)

var virtualNetworkGatewaysGetVpnclientIpsecParameters* = Call_VirtualNetworkGatewaysGetVpnclientIpsecParameters_574551(
    name: "virtualNetworkGatewaysGetVpnclientIpsecParameters",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/getvpnclientipsecparameters",
    validator: validate_VirtualNetworkGatewaysGetVpnclientIpsecParameters_574552,
    base: "", url: url_VirtualNetworkGatewaysGetVpnclientIpsecParameters_574553,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGetVpnProfilePackageUrl_574562 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysGetVpnProfilePackageUrl_574564(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysGetVpnProfilePackageUrl_574563(
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
  var valid_574565 = path.getOrDefault("resourceGroupName")
  valid_574565 = validateParameter(valid_574565, JString, required = true,
                                 default = nil)
  if valid_574565 != nil:
    section.add "resourceGroupName", valid_574565
  var valid_574566 = path.getOrDefault("subscriptionId")
  valid_574566 = validateParameter(valid_574566, JString, required = true,
                                 default = nil)
  if valid_574566 != nil:
    section.add "subscriptionId", valid_574566
  var valid_574567 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574567 = validateParameter(valid_574567, JString, required = true,
                                 default = nil)
  if valid_574567 != nil:
    section.add "virtualNetworkGatewayName", valid_574567
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574568 = query.getOrDefault("api-version")
  valid_574568 = validateParameter(valid_574568, JString, required = true,
                                 default = nil)
  if valid_574568 != nil:
    section.add "api-version", valid_574568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574569: Call_VirtualNetworkGatewaysGetVpnProfilePackageUrl_574562;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets pre-generated VPN profile for P2S client of the virtual network gateway in the specified resource group. The profile needs to be generated first using generateVpnProfile.
  ## 
  let valid = call_574569.validator(path, query, header, formData, body)
  let scheme = call_574569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574569.url(scheme.get, call_574569.host, call_574569.base,
                         call_574569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574569, url, valid)

proc call*(call_574570: Call_VirtualNetworkGatewaysGetVpnProfilePackageUrl_574562;
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
  var path_574571 = newJObject()
  var query_574572 = newJObject()
  add(path_574571, "resourceGroupName", newJString(resourceGroupName))
  add(query_574572, "api-version", newJString(apiVersion))
  add(path_574571, "subscriptionId", newJString(subscriptionId))
  add(path_574571, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574570.call(path_574571, query_574572, nil, nil, nil)

var virtualNetworkGatewaysGetVpnProfilePackageUrl* = Call_VirtualNetworkGatewaysGetVpnProfilePackageUrl_574562(
    name: "virtualNetworkGatewaysGetVpnProfilePackageUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/getvpnprofilepackageurl",
    validator: validate_VirtualNetworkGatewaysGetVpnProfilePackageUrl_574563,
    base: "", url: url_VirtualNetworkGatewaysGetVpnProfilePackageUrl_574564,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysReset_574573 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysReset_574575(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysReset_574574(path: JsonNode; query: JsonNode;
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
  var valid_574576 = path.getOrDefault("resourceGroupName")
  valid_574576 = validateParameter(valid_574576, JString, required = true,
                                 default = nil)
  if valid_574576 != nil:
    section.add "resourceGroupName", valid_574576
  var valid_574577 = path.getOrDefault("subscriptionId")
  valid_574577 = validateParameter(valid_574577, JString, required = true,
                                 default = nil)
  if valid_574577 != nil:
    section.add "subscriptionId", valid_574577
  var valid_574578 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574578 = validateParameter(valid_574578, JString, required = true,
                                 default = nil)
  if valid_574578 != nil:
    section.add "virtualNetworkGatewayName", valid_574578
  result.add "path", section
  ## parameters in `query` object:
  ##   gatewayVip: JString
  ##             : Virtual network gateway vip address supplied to the begin reset of the active-active feature enabled gateway.
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_574579 = query.getOrDefault("gatewayVip")
  valid_574579 = validateParameter(valid_574579, JString, required = false,
                                 default = nil)
  if valid_574579 != nil:
    section.add "gatewayVip", valid_574579
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574580 = query.getOrDefault("api-version")
  valid_574580 = validateParameter(valid_574580, JString, required = true,
                                 default = nil)
  if valid_574580 != nil:
    section.add "api-version", valid_574580
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574581: Call_VirtualNetworkGatewaysReset_574573; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the primary of the virtual network gateway in the specified resource group.
  ## 
  let valid = call_574581.validator(path, query, header, formData, body)
  let scheme = call_574581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574581.url(scheme.get, call_574581.host, call_574581.base,
                         call_574581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574581, url, valid)

proc call*(call_574582: Call_VirtualNetworkGatewaysReset_574573;
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
  var path_574583 = newJObject()
  var query_574584 = newJObject()
  add(path_574583, "resourceGroupName", newJString(resourceGroupName))
  add(query_574584, "gatewayVip", newJString(gatewayVip))
  add(query_574584, "api-version", newJString(apiVersion))
  add(path_574583, "subscriptionId", newJString(subscriptionId))
  add(path_574583, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574582.call(path_574583, query_574584, nil, nil, nil)

var virtualNetworkGatewaysReset* = Call_VirtualNetworkGatewaysReset_574573(
    name: "virtualNetworkGatewaysReset", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/reset",
    validator: validate_VirtualNetworkGatewaysReset_574574, base: "",
    url: url_VirtualNetworkGatewaysReset_574575, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysResetVpnClientSharedKey_574585 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysResetVpnClientSharedKey_574587(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysResetVpnClientSharedKey_574586(
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
  var valid_574588 = path.getOrDefault("resourceGroupName")
  valid_574588 = validateParameter(valid_574588, JString, required = true,
                                 default = nil)
  if valid_574588 != nil:
    section.add "resourceGroupName", valid_574588
  var valid_574589 = path.getOrDefault("subscriptionId")
  valid_574589 = validateParameter(valid_574589, JString, required = true,
                                 default = nil)
  if valid_574589 != nil:
    section.add "subscriptionId", valid_574589
  var valid_574590 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574590 = validateParameter(valid_574590, JString, required = true,
                                 default = nil)
  if valid_574590 != nil:
    section.add "virtualNetworkGatewayName", valid_574590
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574591 = query.getOrDefault("api-version")
  valid_574591 = validateParameter(valid_574591, JString, required = true,
                                 default = nil)
  if valid_574591 != nil:
    section.add "api-version", valid_574591
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574592: Call_VirtualNetworkGatewaysResetVpnClientSharedKey_574585;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets the VPN client shared key of the virtual network gateway in the specified resource group.
  ## 
  let valid = call_574592.validator(path, query, header, formData, body)
  let scheme = call_574592.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574592.url(scheme.get, call_574592.host, call_574592.base,
                         call_574592.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574592, url, valid)

proc call*(call_574593: Call_VirtualNetworkGatewaysResetVpnClientSharedKey_574585;
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
  var path_574594 = newJObject()
  var query_574595 = newJObject()
  add(path_574594, "resourceGroupName", newJString(resourceGroupName))
  add(query_574595, "api-version", newJString(apiVersion))
  add(path_574594, "subscriptionId", newJString(subscriptionId))
  add(path_574594, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574593.call(path_574594, query_574595, nil, nil, nil)

var virtualNetworkGatewaysResetVpnClientSharedKey* = Call_VirtualNetworkGatewaysResetVpnClientSharedKey_574585(
    name: "virtualNetworkGatewaysResetVpnClientSharedKey",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/resetvpnclientsharedkey",
    validator: validate_VirtualNetworkGatewaysResetVpnClientSharedKey_574586,
    base: "", url: url_VirtualNetworkGatewaysResetVpnClientSharedKey_574587,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysSetVpnclientIpsecParameters_574596 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysSetVpnclientIpsecParameters_574598(
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

proc validate_VirtualNetworkGatewaysSetVpnclientIpsecParameters_574597(
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
  var valid_574599 = path.getOrDefault("resourceGroupName")
  valid_574599 = validateParameter(valid_574599, JString, required = true,
                                 default = nil)
  if valid_574599 != nil:
    section.add "resourceGroupName", valid_574599
  var valid_574600 = path.getOrDefault("subscriptionId")
  valid_574600 = validateParameter(valid_574600, JString, required = true,
                                 default = nil)
  if valid_574600 != nil:
    section.add "subscriptionId", valid_574600
  var valid_574601 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574601 = validateParameter(valid_574601, JString, required = true,
                                 default = nil)
  if valid_574601 != nil:
    section.add "virtualNetworkGatewayName", valid_574601
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574602 = query.getOrDefault("api-version")
  valid_574602 = validateParameter(valid_574602, JString, required = true,
                                 default = nil)
  if valid_574602 != nil:
    section.add "api-version", valid_574602
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

proc call*(call_574604: Call_VirtualNetworkGatewaysSetVpnclientIpsecParameters_574596;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Set VpnclientIpsecParameters operation sets the vpnclient ipsec policy for P2S client of virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_574604.validator(path, query, header, formData, body)
  let scheme = call_574604.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574604.url(scheme.get, call_574604.host, call_574604.base,
                         call_574604.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574604, url, valid)

proc call*(call_574605: Call_VirtualNetworkGatewaysSetVpnclientIpsecParameters_574596;
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
  var path_574606 = newJObject()
  var query_574607 = newJObject()
  var body_574608 = newJObject()
  add(path_574606, "resourceGroupName", newJString(resourceGroupName))
  add(query_574607, "api-version", newJString(apiVersion))
  add(path_574606, "subscriptionId", newJString(subscriptionId))
  add(path_574606, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  if vpnclientIpsecParams != nil:
    body_574608 = vpnclientIpsecParams
  result = call_574605.call(path_574606, query_574607, nil, nil, body_574608)

var virtualNetworkGatewaysSetVpnclientIpsecParameters* = Call_VirtualNetworkGatewaysSetVpnclientIpsecParameters_574596(
    name: "virtualNetworkGatewaysSetVpnclientIpsecParameters",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/setvpnclientipsecparameters",
    validator: validate_VirtualNetworkGatewaysSetVpnclientIpsecParameters_574597,
    base: "", url: url_VirtualNetworkGatewaysSetVpnclientIpsecParameters_574598,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysStartPacketCapture_574609 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysStartPacketCapture_574611(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/startPacketCapture")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysStartPacketCapture_574610(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts packet capture on virtual network gateway in the specified resource group.
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
  var valid_574612 = path.getOrDefault("resourceGroupName")
  valid_574612 = validateParameter(valid_574612, JString, required = true,
                                 default = nil)
  if valid_574612 != nil:
    section.add "resourceGroupName", valid_574612
  var valid_574613 = path.getOrDefault("subscriptionId")
  valid_574613 = validateParameter(valid_574613, JString, required = true,
                                 default = nil)
  if valid_574613 != nil:
    section.add "subscriptionId", valid_574613
  var valid_574614 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574614 = validateParameter(valid_574614, JString, required = true,
                                 default = nil)
  if valid_574614 != nil:
    section.add "virtualNetworkGatewayName", valid_574614
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574615 = query.getOrDefault("api-version")
  valid_574615 = validateParameter(valid_574615, JString, required = true,
                                 default = nil)
  if valid_574615 != nil:
    section.add "api-version", valid_574615
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Virtual network gateway packet capture parameters supplied to start packet capture on gateway.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574617: Call_VirtualNetworkGatewaysStartPacketCapture_574609;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts packet capture on virtual network gateway in the specified resource group.
  ## 
  let valid = call_574617.validator(path, query, header, formData, body)
  let scheme = call_574617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574617.url(scheme.get, call_574617.host, call_574617.base,
                         call_574617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574617, url, valid)

proc call*(call_574618: Call_VirtualNetworkGatewaysStartPacketCapture_574609;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayName: string; parameters: JsonNode = nil): Recallable =
  ## virtualNetworkGatewaysStartPacketCapture
  ## Starts packet capture on virtual network gateway in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject
  ##             : Virtual network gateway packet capture parameters supplied to start packet capture on gateway.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_574619 = newJObject()
  var query_574620 = newJObject()
  var body_574621 = newJObject()
  add(path_574619, "resourceGroupName", newJString(resourceGroupName))
  add(query_574620, "api-version", newJString(apiVersion))
  add(path_574619, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574621 = parameters
  add(path_574619, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574618.call(path_574619, query_574620, nil, nil, body_574621)

var virtualNetworkGatewaysStartPacketCapture* = Call_VirtualNetworkGatewaysStartPacketCapture_574609(
    name: "virtualNetworkGatewaysStartPacketCapture", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/startPacketCapture",
    validator: validate_VirtualNetworkGatewaysStartPacketCapture_574610, base: "",
    url: url_VirtualNetworkGatewaysStartPacketCapture_574611,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysStopPacketCapture_574622 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysStopPacketCapture_574624(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/stopPacketCapture")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysStopPacketCapture_574623(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops packet capture on virtual network gateway in the specified resource group.
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
  var valid_574625 = path.getOrDefault("resourceGroupName")
  valid_574625 = validateParameter(valid_574625, JString, required = true,
                                 default = nil)
  if valid_574625 != nil:
    section.add "resourceGroupName", valid_574625
  var valid_574626 = path.getOrDefault("subscriptionId")
  valid_574626 = validateParameter(valid_574626, JString, required = true,
                                 default = nil)
  if valid_574626 != nil:
    section.add "subscriptionId", valid_574626
  var valid_574627 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574627 = validateParameter(valid_574627, JString, required = true,
                                 default = nil)
  if valid_574627 != nil:
    section.add "virtualNetworkGatewayName", valid_574627
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574628 = query.getOrDefault("api-version")
  valid_574628 = validateParameter(valid_574628, JString, required = true,
                                 default = nil)
  if valid_574628 != nil:
    section.add "api-version", valid_574628
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Virtual network gateway packet capture parameters supplied to stop packet capture on gateway.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574630: Call_VirtualNetworkGatewaysStopPacketCapture_574622;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops packet capture on virtual network gateway in the specified resource group.
  ## 
  let valid = call_574630.validator(path, query, header, formData, body)
  let scheme = call_574630.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574630.url(scheme.get, call_574630.host, call_574630.base,
                         call_574630.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574630, url, valid)

proc call*(call_574631: Call_VirtualNetworkGatewaysStopPacketCapture_574622;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysStopPacketCapture
  ## Stops packet capture on virtual network gateway in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Virtual network gateway packet capture parameters supplied to stop packet capture on gateway.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_574632 = newJObject()
  var query_574633 = newJObject()
  var body_574634 = newJObject()
  add(path_574632, "resourceGroupName", newJString(resourceGroupName))
  add(query_574633, "api-version", newJString(apiVersion))
  add(path_574632, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574634 = parameters
  add(path_574632, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574631.call(path_574632, query_574633, nil, nil, body_574634)

var virtualNetworkGatewaysStopPacketCapture* = Call_VirtualNetworkGatewaysStopPacketCapture_574622(
    name: "virtualNetworkGatewaysStopPacketCapture", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/stopPacketCapture",
    validator: validate_VirtualNetworkGatewaysStopPacketCapture_574623, base: "",
    url: url_VirtualNetworkGatewaysStopPacketCapture_574624,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysSupportedVpnDevices_574635 = ref object of OpenApiRestCall_573666
proc url_VirtualNetworkGatewaysSupportedVpnDevices_574637(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysSupportedVpnDevices_574636(path: JsonNode;
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
  var valid_574638 = path.getOrDefault("resourceGroupName")
  valid_574638 = validateParameter(valid_574638, JString, required = true,
                                 default = nil)
  if valid_574638 != nil:
    section.add "resourceGroupName", valid_574638
  var valid_574639 = path.getOrDefault("subscriptionId")
  valid_574639 = validateParameter(valid_574639, JString, required = true,
                                 default = nil)
  if valid_574639 != nil:
    section.add "subscriptionId", valid_574639
  var valid_574640 = path.getOrDefault("virtualNetworkGatewayName")
  valid_574640 = validateParameter(valid_574640, JString, required = true,
                                 default = nil)
  if valid_574640 != nil:
    section.add "virtualNetworkGatewayName", valid_574640
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574641 = query.getOrDefault("api-version")
  valid_574641 = validateParameter(valid_574641, JString, required = true,
                                 default = nil)
  if valid_574641 != nil:
    section.add "api-version", valid_574641
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574642: Call_VirtualNetworkGatewaysSupportedVpnDevices_574635;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a xml format representation for supported vpn devices.
  ## 
  let valid = call_574642.validator(path, query, header, formData, body)
  let scheme = call_574642.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574642.url(scheme.get, call_574642.host, call_574642.base,
                         call_574642.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574642, url, valid)

proc call*(call_574643: Call_VirtualNetworkGatewaysSupportedVpnDevices_574635;
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
  var path_574644 = newJObject()
  var query_574645 = newJObject()
  add(path_574644, "resourceGroupName", newJString(resourceGroupName))
  add(query_574645, "api-version", newJString(apiVersion))
  add(path_574644, "subscriptionId", newJString(subscriptionId))
  add(path_574644, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_574643.call(path_574644, query_574645, nil, nil, nil)

var virtualNetworkGatewaysSupportedVpnDevices* = Call_VirtualNetworkGatewaysSupportedVpnDevices_574635(
    name: "virtualNetworkGatewaysSupportedVpnDevices", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/supportedvpndevices",
    validator: validate_VirtualNetworkGatewaysSupportedVpnDevices_574636,
    base: "", url: url_VirtualNetworkGatewaysSupportedVpnDevices_574637,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
