
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2018-07-01
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
  macServiceName = "network-virtualNetworkGateway"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VirtualNetworkGatewayConnectionsList_567879 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewayConnectionsList_567881(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsList_567880(path: JsonNode;
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
  var valid_568041 = path.getOrDefault("resourceGroupName")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "resourceGroupName", valid_568041
  var valid_568042 = path.getOrDefault("subscriptionId")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "subscriptionId", valid_568042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568043 = query.getOrDefault("api-version")
  valid_568043 = validateParameter(valid_568043, JString, required = true,
                                 default = nil)
  if valid_568043 != nil:
    section.add "api-version", valid_568043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568070: Call_VirtualNetworkGatewayConnectionsList_567879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ## 
  let valid = call_568070.validator(path, query, header, formData, body)
  let scheme = call_568070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568070.url(scheme.get, call_568070.host, call_568070.base,
                         call_568070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568070, url, valid)

proc call*(call_568141: Call_VirtualNetworkGatewayConnectionsList_567879;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworkGatewayConnectionsList
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568142 = newJObject()
  var query_568144 = newJObject()
  add(path_568142, "resourceGroupName", newJString(resourceGroupName))
  add(query_568144, "api-version", newJString(apiVersion))
  add(path_568142, "subscriptionId", newJString(subscriptionId))
  result = call_568141.call(path_568142, query_568144, nil, nil, nil)

var virtualNetworkGatewayConnectionsList* = Call_VirtualNetworkGatewayConnectionsList_567879(
    name: "virtualNetworkGatewayConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections",
    validator: validate_VirtualNetworkGatewayConnectionsList_567880, base: "",
    url: url_VirtualNetworkGatewayConnectionsList_567881, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_568194 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewayConnectionsCreateOrUpdate_568196(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsCreateOrUpdate_568195(
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
  var valid_568223 = path.getOrDefault("resourceGroupName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "resourceGroupName", valid_568223
  var valid_568224 = path.getOrDefault("subscriptionId")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "subscriptionId", valid_568224
  var valid_568225 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568226 = query.getOrDefault("api-version")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "api-version", valid_568226
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

proc call*(call_568228: Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_568194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a virtual network gateway connection in the specified resource group.
  ## 
  let valid = call_568228.validator(path, query, header, formData, body)
  let scheme = call_568228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568228.url(scheme.get, call_568228.host, call_568228.base,
                         call_568228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568228, url, valid)

proc call*(call_568229: Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_568194;
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
  var path_568230 = newJObject()
  var query_568231 = newJObject()
  var body_568232 = newJObject()
  add(path_568230, "resourceGroupName", newJString(resourceGroupName))
  add(query_568231, "api-version", newJString(apiVersion))
  add(path_568230, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568232 = parameters
  add(path_568230, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568229.call(path_568230, query_568231, nil, nil, body_568232)

var virtualNetworkGatewayConnectionsCreateOrUpdate* = Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_568194(
    name: "virtualNetworkGatewayConnectionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsCreateOrUpdate_568195,
    base: "", url: url_VirtualNetworkGatewayConnectionsCreateOrUpdate_568196,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsGet_568183 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewayConnectionsGet_568185(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewayConnectionsGet_568184(path: JsonNode;
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
  var valid_568186 = path.getOrDefault("resourceGroupName")
  valid_568186 = validateParameter(valid_568186, JString, required = true,
                                 default = nil)
  if valid_568186 != nil:
    section.add "resourceGroupName", valid_568186
  var valid_568187 = path.getOrDefault("subscriptionId")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "subscriptionId", valid_568187
  var valid_568188 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568189 = query.getOrDefault("api-version")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "api-version", valid_568189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568190: Call_VirtualNetworkGatewayConnectionsGet_568183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified virtual network gateway connection by resource group.
  ## 
  let valid = call_568190.validator(path, query, header, formData, body)
  let scheme = call_568190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568190.url(scheme.get, call_568190.host, call_568190.base,
                         call_568190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568190, url, valid)

proc call*(call_568191: Call_VirtualNetworkGatewayConnectionsGet_568183;
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
  var path_568192 = newJObject()
  var query_568193 = newJObject()
  add(path_568192, "resourceGroupName", newJString(resourceGroupName))
  add(query_568193, "api-version", newJString(apiVersion))
  add(path_568192, "subscriptionId", newJString(subscriptionId))
  add(path_568192, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568191.call(path_568192, query_568193, nil, nil, nil)

var virtualNetworkGatewayConnectionsGet* = Call_VirtualNetworkGatewayConnectionsGet_568183(
    name: "virtualNetworkGatewayConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsGet_568184, base: "",
    url: url_VirtualNetworkGatewayConnectionsGet_568185, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsUpdateTags_568244 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewayConnectionsUpdateTags_568246(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsUpdateTags_568245(path: JsonNode;
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
  var valid_568247 = path.getOrDefault("resourceGroupName")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "resourceGroupName", valid_568247
  var valid_568248 = path.getOrDefault("subscriptionId")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "subscriptionId", valid_568248
  var valid_568249 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568250 = query.getOrDefault("api-version")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "api-version", valid_568250
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

proc call*(call_568252: Call_VirtualNetworkGatewayConnectionsUpdateTags_568244;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a virtual network gateway connection tags.
  ## 
  let valid = call_568252.validator(path, query, header, formData, body)
  let scheme = call_568252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568252.url(scheme.get, call_568252.host, call_568252.base,
                         call_568252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568252, url, valid)

proc call*(call_568253: Call_VirtualNetworkGatewayConnectionsUpdateTags_568244;
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
  var path_568254 = newJObject()
  var query_568255 = newJObject()
  var body_568256 = newJObject()
  add(path_568254, "resourceGroupName", newJString(resourceGroupName))
  add(query_568255, "api-version", newJString(apiVersion))
  add(path_568254, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568256 = parameters
  add(path_568254, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568253.call(path_568254, query_568255, nil, nil, body_568256)

var virtualNetworkGatewayConnectionsUpdateTags* = Call_VirtualNetworkGatewayConnectionsUpdateTags_568244(
    name: "virtualNetworkGatewayConnectionsUpdateTags",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsUpdateTags_568245,
    base: "", url: url_VirtualNetworkGatewayConnectionsUpdateTags_568246,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsDelete_568233 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewayConnectionsDelete_568235(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsDelete_568234(path: JsonNode;
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
  var valid_568236 = path.getOrDefault("resourceGroupName")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "resourceGroupName", valid_568236
  var valid_568237 = path.getOrDefault("subscriptionId")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "subscriptionId", valid_568237
  var valid_568238 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568239 = query.getOrDefault("api-version")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "api-version", valid_568239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568240: Call_VirtualNetworkGatewayConnectionsDelete_568233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified virtual network Gateway connection.
  ## 
  let valid = call_568240.validator(path, query, header, formData, body)
  let scheme = call_568240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568240.url(scheme.get, call_568240.host, call_568240.base,
                         call_568240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568240, url, valid)

proc call*(call_568241: Call_VirtualNetworkGatewayConnectionsDelete_568233;
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
  var path_568242 = newJObject()
  var query_568243 = newJObject()
  add(path_568242, "resourceGroupName", newJString(resourceGroupName))
  add(query_568243, "api-version", newJString(apiVersion))
  add(path_568242, "subscriptionId", newJString(subscriptionId))
  add(path_568242, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568241.call(path_568242, query_568243, nil, nil, nil)

var virtualNetworkGatewayConnectionsDelete* = Call_VirtualNetworkGatewayConnectionsDelete_568233(
    name: "virtualNetworkGatewayConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsDelete_568234, base: "",
    url: url_VirtualNetworkGatewayConnectionsDelete_568235,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsSetSharedKey_568268 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewayConnectionsSetSharedKey_568270(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsSetSharedKey_568269(path: JsonNode;
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
  var valid_568271 = path.getOrDefault("resourceGroupName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "resourceGroupName", valid_568271
  var valid_568272 = path.getOrDefault("subscriptionId")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "subscriptionId", valid_568272
  var valid_568273 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568274 = query.getOrDefault("api-version")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "api-version", valid_568274
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

proc call*(call_568276: Call_VirtualNetworkGatewayConnectionsSetSharedKey_568268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGatewayConnectionSharedKey operation sets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_568276.validator(path, query, header, formData, body)
  let scheme = call_568276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568276.url(scheme.get, call_568276.host, call_568276.base,
                         call_568276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568276, url, valid)

proc call*(call_568277: Call_VirtualNetworkGatewayConnectionsSetSharedKey_568268;
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
  var path_568278 = newJObject()
  var query_568279 = newJObject()
  var body_568280 = newJObject()
  add(path_568278, "resourceGroupName", newJString(resourceGroupName))
  add(query_568279, "api-version", newJString(apiVersion))
  add(path_568278, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568280 = parameters
  add(path_568278, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568277.call(path_568278, query_568279, nil, nil, body_568280)

var virtualNetworkGatewayConnectionsSetSharedKey* = Call_VirtualNetworkGatewayConnectionsSetSharedKey_568268(
    name: "virtualNetworkGatewayConnectionsSetSharedKey",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey",
    validator: validate_VirtualNetworkGatewayConnectionsSetSharedKey_568269,
    base: "", url: url_VirtualNetworkGatewayConnectionsSetSharedKey_568270,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsGetSharedKey_568257 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewayConnectionsGetSharedKey_568259(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsGetSharedKey_568258(path: JsonNode;
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
  var valid_568260 = path.getOrDefault("resourceGroupName")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "resourceGroupName", valid_568260
  var valid_568261 = path.getOrDefault("subscriptionId")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "subscriptionId", valid_568261
  var valid_568262 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568263 = query.getOrDefault("api-version")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "api-version", valid_568263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568264: Call_VirtualNetworkGatewayConnectionsGetSharedKey_568257;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get VirtualNetworkGatewayConnectionSharedKey operation retrieves information about the specified virtual network gateway connection shared key through Network resource provider.
  ## 
  let valid = call_568264.validator(path, query, header, formData, body)
  let scheme = call_568264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568264.url(scheme.get, call_568264.host, call_568264.base,
                         call_568264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568264, url, valid)

proc call*(call_568265: Call_VirtualNetworkGatewayConnectionsGetSharedKey_568257;
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
  var path_568266 = newJObject()
  var query_568267 = newJObject()
  add(path_568266, "resourceGroupName", newJString(resourceGroupName))
  add(query_568267, "api-version", newJString(apiVersion))
  add(path_568266, "subscriptionId", newJString(subscriptionId))
  add(path_568266, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568265.call(path_568266, query_568267, nil, nil, nil)

var virtualNetworkGatewayConnectionsGetSharedKey* = Call_VirtualNetworkGatewayConnectionsGetSharedKey_568257(
    name: "virtualNetworkGatewayConnectionsGetSharedKey",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey",
    validator: validate_VirtualNetworkGatewayConnectionsGetSharedKey_568258,
    base: "", url: url_VirtualNetworkGatewayConnectionsGetSharedKey_568259,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsResetSharedKey_568281 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewayConnectionsResetSharedKey_568283(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsResetSharedKey_568282(
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
  var valid_568294 = path.getOrDefault("resourceGroupName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "resourceGroupName", valid_568294
  var valid_568295 = path.getOrDefault("subscriptionId")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "subscriptionId", valid_568295
  var valid_568296 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568297 = query.getOrDefault("api-version")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "api-version", valid_568297
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

proc call*(call_568299: Call_VirtualNetworkGatewayConnectionsResetSharedKey_568281;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The VirtualNetworkGatewayConnectionResetSharedKey operation resets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_568299.validator(path, query, header, formData, body)
  let scheme = call_568299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568299.url(scheme.get, call_568299.host, call_568299.base,
                         call_568299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568299, url, valid)

proc call*(call_568300: Call_VirtualNetworkGatewayConnectionsResetSharedKey_568281;
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
  var path_568301 = newJObject()
  var query_568302 = newJObject()
  var body_568303 = newJObject()
  add(path_568301, "resourceGroupName", newJString(resourceGroupName))
  add(query_568302, "api-version", newJString(apiVersion))
  add(path_568301, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568303 = parameters
  add(path_568301, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568300.call(path_568301, query_568302, nil, nil, body_568303)

var virtualNetworkGatewayConnectionsResetSharedKey* = Call_VirtualNetworkGatewayConnectionsResetSharedKey_568281(
    name: "virtualNetworkGatewayConnectionsResetSharedKey",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey/reset",
    validator: validate_VirtualNetworkGatewayConnectionsResetSharedKey_568282,
    base: "", url: url_VirtualNetworkGatewayConnectionsResetSharedKey_568283,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysVpnDeviceConfigurationScript_568304 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewaysVpnDeviceConfigurationScript_568306(
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

proc validate_VirtualNetworkGatewaysVpnDeviceConfigurationScript_568305(
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
  var valid_568307 = path.getOrDefault("resourceGroupName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "resourceGroupName", valid_568307
  var valid_568308 = path.getOrDefault("subscriptionId")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "subscriptionId", valid_568308
  var valid_568309 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568310 = query.getOrDefault("api-version")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "api-version", valid_568310
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

proc call*(call_568312: Call_VirtualNetworkGatewaysVpnDeviceConfigurationScript_568304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a xml format representation for vpn device configuration script.
  ## 
  let valid = call_568312.validator(path, query, header, formData, body)
  let scheme = call_568312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568312.url(scheme.get, call_568312.host, call_568312.base,
                         call_568312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568312, url, valid)

proc call*(call_568313: Call_VirtualNetworkGatewaysVpnDeviceConfigurationScript_568304;
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
  var path_568314 = newJObject()
  var query_568315 = newJObject()
  var body_568316 = newJObject()
  add(path_568314, "resourceGroupName", newJString(resourceGroupName))
  add(query_568315, "api-version", newJString(apiVersion))
  add(path_568314, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568316 = parameters
  add(path_568314, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568313.call(path_568314, query_568315, nil, nil, body_568316)

var virtualNetworkGatewaysVpnDeviceConfigurationScript* = Call_VirtualNetworkGatewaysVpnDeviceConfigurationScript_568304(
    name: "virtualNetworkGatewaysVpnDeviceConfigurationScript",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/vpndeviceconfigurationscript",
    validator: validate_VirtualNetworkGatewaysVpnDeviceConfigurationScript_568305,
    base: "", url: url_VirtualNetworkGatewaysVpnDeviceConfigurationScript_568306,
    schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysList_568317 = ref object of OpenApiRestCall_567657
proc url_LocalNetworkGatewaysList_568319(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysList_568318(path: JsonNode; query: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568322 = query.getOrDefault("api-version")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "api-version", valid_568322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568323: Call_LocalNetworkGatewaysList_568317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the local network gateways in a resource group.
  ## 
  let valid = call_568323.validator(path, query, header, formData, body)
  let scheme = call_568323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568323.url(scheme.get, call_568323.host, call_568323.base,
                         call_568323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568323, url, valid)

proc call*(call_568324: Call_LocalNetworkGatewaysList_568317;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## localNetworkGatewaysList
  ## Gets all the local network gateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568325 = newJObject()
  var query_568326 = newJObject()
  add(path_568325, "resourceGroupName", newJString(resourceGroupName))
  add(query_568326, "api-version", newJString(apiVersion))
  add(path_568325, "subscriptionId", newJString(subscriptionId))
  result = call_568324.call(path_568325, query_568326, nil, nil, nil)

var localNetworkGatewaysList* = Call_LocalNetworkGatewaysList_568317(
    name: "localNetworkGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways",
    validator: validate_LocalNetworkGatewaysList_568318, base: "",
    url: url_LocalNetworkGatewaysList_568319, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysCreateOrUpdate_568338 = ref object of OpenApiRestCall_567657
proc url_LocalNetworkGatewaysCreateOrUpdate_568340(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysCreateOrUpdate_568339(path: JsonNode;
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
  var valid_568341 = path.getOrDefault("resourceGroupName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "resourceGroupName", valid_568341
  var valid_568342 = path.getOrDefault("localNetworkGatewayName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "localNetworkGatewayName", valid_568342
  var valid_568343 = path.getOrDefault("subscriptionId")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "subscriptionId", valid_568343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568344 = query.getOrDefault("api-version")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "api-version", valid_568344
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

proc call*(call_568346: Call_LocalNetworkGatewaysCreateOrUpdate_568338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a local network gateway in the specified resource group.
  ## 
  let valid = call_568346.validator(path, query, header, formData, body)
  let scheme = call_568346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568346.url(scheme.get, call_568346.host, call_568346.base,
                         call_568346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568346, url, valid)

proc call*(call_568347: Call_LocalNetworkGatewaysCreateOrUpdate_568338;
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
  var path_568348 = newJObject()
  var query_568349 = newJObject()
  var body_568350 = newJObject()
  add(path_568348, "resourceGroupName", newJString(resourceGroupName))
  add(path_568348, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_568349, "api-version", newJString(apiVersion))
  add(path_568348, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568350 = parameters
  result = call_568347.call(path_568348, query_568349, nil, nil, body_568350)

var localNetworkGatewaysCreateOrUpdate* = Call_LocalNetworkGatewaysCreateOrUpdate_568338(
    name: "localNetworkGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysCreateOrUpdate_568339, base: "",
    url: url_LocalNetworkGatewaysCreateOrUpdate_568340, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysGet_568327 = ref object of OpenApiRestCall_567657
proc url_LocalNetworkGatewaysGet_568329(protocol: Scheme; host: string; base: string;
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

proc validate_LocalNetworkGatewaysGet_568328(path: JsonNode; query: JsonNode;
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
  var valid_568330 = path.getOrDefault("resourceGroupName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "resourceGroupName", valid_568330
  var valid_568331 = path.getOrDefault("localNetworkGatewayName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "localNetworkGatewayName", valid_568331
  var valid_568332 = path.getOrDefault("subscriptionId")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "subscriptionId", valid_568332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_568334: Call_LocalNetworkGatewaysGet_568327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified local network gateway in a resource group.
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_LocalNetworkGatewaysGet_568327;
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
  var path_568336 = newJObject()
  var query_568337 = newJObject()
  add(path_568336, "resourceGroupName", newJString(resourceGroupName))
  add(path_568336, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_568337, "api-version", newJString(apiVersion))
  add(path_568336, "subscriptionId", newJString(subscriptionId))
  result = call_568335.call(path_568336, query_568337, nil, nil, nil)

var localNetworkGatewaysGet* = Call_LocalNetworkGatewaysGet_568327(
    name: "localNetworkGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysGet_568328, base: "",
    url: url_LocalNetworkGatewaysGet_568329, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysUpdateTags_568362 = ref object of OpenApiRestCall_567657
proc url_LocalNetworkGatewaysUpdateTags_568364(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysUpdateTags_568363(path: JsonNode;
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
  var valid_568365 = path.getOrDefault("resourceGroupName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "resourceGroupName", valid_568365
  var valid_568366 = path.getOrDefault("localNetworkGatewayName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "localNetworkGatewayName", valid_568366
  var valid_568367 = path.getOrDefault("subscriptionId")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "subscriptionId", valid_568367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568368 = query.getOrDefault("api-version")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "api-version", valid_568368
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

proc call*(call_568370: Call_LocalNetworkGatewaysUpdateTags_568362; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a local network gateway tags.
  ## 
  let valid = call_568370.validator(path, query, header, formData, body)
  let scheme = call_568370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568370.url(scheme.get, call_568370.host, call_568370.base,
                         call_568370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568370, url, valid)

proc call*(call_568371: Call_LocalNetworkGatewaysUpdateTags_568362;
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
  var path_568372 = newJObject()
  var query_568373 = newJObject()
  var body_568374 = newJObject()
  add(path_568372, "resourceGroupName", newJString(resourceGroupName))
  add(path_568372, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_568373, "api-version", newJString(apiVersion))
  add(path_568372, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568374 = parameters
  result = call_568371.call(path_568372, query_568373, nil, nil, body_568374)

var localNetworkGatewaysUpdateTags* = Call_LocalNetworkGatewaysUpdateTags_568362(
    name: "localNetworkGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysUpdateTags_568363, base: "",
    url: url_LocalNetworkGatewaysUpdateTags_568364, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysDelete_568351 = ref object of OpenApiRestCall_567657
proc url_LocalNetworkGatewaysDelete_568353(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysDelete_568352(path: JsonNode; query: JsonNode;
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
  var valid_568354 = path.getOrDefault("resourceGroupName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "resourceGroupName", valid_568354
  var valid_568355 = path.getOrDefault("localNetworkGatewayName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "localNetworkGatewayName", valid_568355
  var valid_568356 = path.getOrDefault("subscriptionId")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "subscriptionId", valid_568356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568357 = query.getOrDefault("api-version")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "api-version", valid_568357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568358: Call_LocalNetworkGatewaysDelete_568351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified local network gateway.
  ## 
  let valid = call_568358.validator(path, query, header, formData, body)
  let scheme = call_568358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568358.url(scheme.get, call_568358.host, call_568358.base,
                         call_568358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568358, url, valid)

proc call*(call_568359: Call_LocalNetworkGatewaysDelete_568351;
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
  var path_568360 = newJObject()
  var query_568361 = newJObject()
  add(path_568360, "resourceGroupName", newJString(resourceGroupName))
  add(path_568360, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_568361, "api-version", newJString(apiVersion))
  add(path_568360, "subscriptionId", newJString(subscriptionId))
  result = call_568359.call(path_568360, query_568361, nil, nil, nil)

var localNetworkGatewaysDelete* = Call_LocalNetworkGatewaysDelete_568351(
    name: "localNetworkGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysDelete_568352, base: "",
    url: url_LocalNetworkGatewaysDelete_568353, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysList_568375 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewaysList_568377(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysList_568376(path: JsonNode; query: JsonNode;
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
  var valid_568378 = path.getOrDefault("resourceGroupName")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "resourceGroupName", valid_568378
  var valid_568379 = path.getOrDefault("subscriptionId")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "subscriptionId", valid_568379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568380 = query.getOrDefault("api-version")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "api-version", valid_568380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568381: Call_VirtualNetworkGatewaysList_568375; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all virtual network gateways by resource group.
  ## 
  let valid = call_568381.validator(path, query, header, formData, body)
  let scheme = call_568381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568381.url(scheme.get, call_568381.host, call_568381.base,
                         call_568381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568381, url, valid)

proc call*(call_568382: Call_VirtualNetworkGatewaysList_568375;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworkGatewaysList
  ## Gets all virtual network gateways by resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568383 = newJObject()
  var query_568384 = newJObject()
  add(path_568383, "resourceGroupName", newJString(resourceGroupName))
  add(query_568384, "api-version", newJString(apiVersion))
  add(path_568383, "subscriptionId", newJString(subscriptionId))
  result = call_568382.call(path_568383, query_568384, nil, nil, nil)

var virtualNetworkGatewaysList* = Call_VirtualNetworkGatewaysList_568375(
    name: "virtualNetworkGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways",
    validator: validate_VirtualNetworkGatewaysList_568376, base: "",
    url: url_VirtualNetworkGatewaysList_568377, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysCreateOrUpdate_568396 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewaysCreateOrUpdate_568398(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysCreateOrUpdate_568397(path: JsonNode;
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
  var valid_568399 = path.getOrDefault("resourceGroupName")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "resourceGroupName", valid_568399
  var valid_568400 = path.getOrDefault("subscriptionId")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "subscriptionId", valid_568400
  var valid_568401 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "virtualNetworkGatewayName", valid_568401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568402 = query.getOrDefault("api-version")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "api-version", valid_568402
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

proc call*(call_568404: Call_VirtualNetworkGatewaysCreateOrUpdate_568396;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a virtual network gateway in the specified resource group.
  ## 
  let valid = call_568404.validator(path, query, header, formData, body)
  let scheme = call_568404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568404.url(scheme.get, call_568404.host, call_568404.base,
                         call_568404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568404, url, valid)

proc call*(call_568405: Call_VirtualNetworkGatewaysCreateOrUpdate_568396;
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
  var path_568406 = newJObject()
  var query_568407 = newJObject()
  var body_568408 = newJObject()
  add(path_568406, "resourceGroupName", newJString(resourceGroupName))
  add(query_568407, "api-version", newJString(apiVersion))
  add(path_568406, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568408 = parameters
  add(path_568406, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568405.call(path_568406, query_568407, nil, nil, body_568408)

var virtualNetworkGatewaysCreateOrUpdate* = Call_VirtualNetworkGatewaysCreateOrUpdate_568396(
    name: "virtualNetworkGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysCreateOrUpdate_568397, base: "",
    url: url_VirtualNetworkGatewaysCreateOrUpdate_568398, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGet_568385 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewaysGet_568387(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysGet_568386(path: JsonNode; query: JsonNode;
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
  var valid_568388 = path.getOrDefault("resourceGroupName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "resourceGroupName", valid_568388
  var valid_568389 = path.getOrDefault("subscriptionId")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "subscriptionId", valid_568389
  var valid_568390 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "virtualNetworkGatewayName", valid_568390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568391 = query.getOrDefault("api-version")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "api-version", valid_568391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568392: Call_VirtualNetworkGatewaysGet_568385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified virtual network gateway by resource group.
  ## 
  let valid = call_568392.validator(path, query, header, formData, body)
  let scheme = call_568392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568392.url(scheme.get, call_568392.host, call_568392.base,
                         call_568392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568392, url, valid)

proc call*(call_568393: Call_VirtualNetworkGatewaysGet_568385;
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
  var path_568394 = newJObject()
  var query_568395 = newJObject()
  add(path_568394, "resourceGroupName", newJString(resourceGroupName))
  add(query_568395, "api-version", newJString(apiVersion))
  add(path_568394, "subscriptionId", newJString(subscriptionId))
  add(path_568394, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568393.call(path_568394, query_568395, nil, nil, nil)

var virtualNetworkGatewaysGet* = Call_VirtualNetworkGatewaysGet_568385(
    name: "virtualNetworkGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysGet_568386, base: "",
    url: url_VirtualNetworkGatewaysGet_568387, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysUpdateTags_568420 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewaysUpdateTags_568422(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysUpdateTags_568421(path: JsonNode;
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
  var valid_568423 = path.getOrDefault("resourceGroupName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "resourceGroupName", valid_568423
  var valid_568424 = path.getOrDefault("subscriptionId")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "subscriptionId", valid_568424
  var valid_568425 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "virtualNetworkGatewayName", valid_568425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568426 = query.getOrDefault("api-version")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "api-version", valid_568426
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

proc call*(call_568428: Call_VirtualNetworkGatewaysUpdateTags_568420;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a virtual network gateway tags.
  ## 
  let valid = call_568428.validator(path, query, header, formData, body)
  let scheme = call_568428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568428.url(scheme.get, call_568428.host, call_568428.base,
                         call_568428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568428, url, valid)

proc call*(call_568429: Call_VirtualNetworkGatewaysUpdateTags_568420;
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
  var path_568430 = newJObject()
  var query_568431 = newJObject()
  var body_568432 = newJObject()
  add(path_568430, "resourceGroupName", newJString(resourceGroupName))
  add(query_568431, "api-version", newJString(apiVersion))
  add(path_568430, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568432 = parameters
  add(path_568430, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568429.call(path_568430, query_568431, nil, nil, body_568432)

var virtualNetworkGatewaysUpdateTags* = Call_VirtualNetworkGatewaysUpdateTags_568420(
    name: "virtualNetworkGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysUpdateTags_568421, base: "",
    url: url_VirtualNetworkGatewaysUpdateTags_568422, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysDelete_568409 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewaysDelete_568411(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysDelete_568410(path: JsonNode; query: JsonNode;
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
  var valid_568412 = path.getOrDefault("resourceGroupName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "resourceGroupName", valid_568412
  var valid_568413 = path.getOrDefault("subscriptionId")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "subscriptionId", valid_568413
  var valid_568414 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "virtualNetworkGatewayName", valid_568414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568415 = query.getOrDefault("api-version")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "api-version", valid_568415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568416: Call_VirtualNetworkGatewaysDelete_568409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified virtual network gateway.
  ## 
  let valid = call_568416.validator(path, query, header, formData, body)
  let scheme = call_568416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568416.url(scheme.get, call_568416.host, call_568416.base,
                         call_568416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568416, url, valid)

proc call*(call_568417: Call_VirtualNetworkGatewaysDelete_568409;
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
  var path_568418 = newJObject()
  var query_568419 = newJObject()
  add(path_568418, "resourceGroupName", newJString(resourceGroupName))
  add(query_568419, "api-version", newJString(apiVersion))
  add(path_568418, "subscriptionId", newJString(subscriptionId))
  add(path_568418, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568417.call(path_568418, query_568419, nil, nil, nil)

var virtualNetworkGatewaysDelete* = Call_VirtualNetworkGatewaysDelete_568409(
    name: "virtualNetworkGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysDelete_568410, base: "",
    url: url_VirtualNetworkGatewaysDelete_568411, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysListConnections_568433 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewaysListConnections_568435(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysListConnections_568434(path: JsonNode;
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
  var valid_568436 = path.getOrDefault("resourceGroupName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "resourceGroupName", valid_568436
  var valid_568437 = path.getOrDefault("subscriptionId")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "subscriptionId", valid_568437
  var valid_568438 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "virtualNetworkGatewayName", valid_568438
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568439 = query.getOrDefault("api-version")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "api-version", valid_568439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568440: Call_VirtualNetworkGatewaysListConnections_568433;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the connections in a virtual network gateway.
  ## 
  let valid = call_568440.validator(path, query, header, formData, body)
  let scheme = call_568440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568440.url(scheme.get, call_568440.host, call_568440.base,
                         call_568440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568440, url, valid)

proc call*(call_568441: Call_VirtualNetworkGatewaysListConnections_568433;
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
  var path_568442 = newJObject()
  var query_568443 = newJObject()
  add(path_568442, "resourceGroupName", newJString(resourceGroupName))
  add(query_568443, "api-version", newJString(apiVersion))
  add(path_568442, "subscriptionId", newJString(subscriptionId))
  add(path_568442, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568441.call(path_568442, query_568443, nil, nil, nil)

var virtualNetworkGatewaysListConnections* = Call_VirtualNetworkGatewaysListConnections_568433(
    name: "virtualNetworkGatewaysListConnections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/connections",
    validator: validate_VirtualNetworkGatewaysListConnections_568434, base: "",
    url: url_VirtualNetworkGatewaysListConnections_568435, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGeneratevpnclientpackage_568444 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewaysGeneratevpnclientpackage_568446(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysGeneratevpnclientpackage_568445(
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
  var valid_568447 = path.getOrDefault("resourceGroupName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "resourceGroupName", valid_568447
  var valid_568448 = path.getOrDefault("subscriptionId")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "subscriptionId", valid_568448
  var valid_568449 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "virtualNetworkGatewayName", valid_568449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568450 = query.getOrDefault("api-version")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "api-version", valid_568450
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

proc call*(call_568452: Call_VirtualNetworkGatewaysGeneratevpnclientpackage_568444;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates VPN client package for P2S client of the virtual network gateway in the specified resource group.
  ## 
  let valid = call_568452.validator(path, query, header, formData, body)
  let scheme = call_568452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568452.url(scheme.get, call_568452.host, call_568452.base,
                         call_568452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568452, url, valid)

proc call*(call_568453: Call_VirtualNetworkGatewaysGeneratevpnclientpackage_568444;
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
  var path_568454 = newJObject()
  var query_568455 = newJObject()
  var body_568456 = newJObject()
  add(path_568454, "resourceGroupName", newJString(resourceGroupName))
  add(query_568455, "api-version", newJString(apiVersion))
  add(path_568454, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568456 = parameters
  add(path_568454, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568453.call(path_568454, query_568455, nil, nil, body_568456)

var virtualNetworkGatewaysGeneratevpnclientpackage* = Call_VirtualNetworkGatewaysGeneratevpnclientpackage_568444(
    name: "virtualNetworkGatewaysGeneratevpnclientpackage",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/generatevpnclientpackage",
    validator: validate_VirtualNetworkGatewaysGeneratevpnclientpackage_568445,
    base: "", url: url_VirtualNetworkGatewaysGeneratevpnclientpackage_568446,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGenerateVpnProfile_568457 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewaysGenerateVpnProfile_568459(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysGenerateVpnProfile_568458(path: JsonNode;
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
  var valid_568460 = path.getOrDefault("resourceGroupName")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "resourceGroupName", valid_568460
  var valid_568461 = path.getOrDefault("subscriptionId")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "subscriptionId", valid_568461
  var valid_568462 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "virtualNetworkGatewayName", valid_568462
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568463 = query.getOrDefault("api-version")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "api-version", valid_568463
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

proc call*(call_568465: Call_VirtualNetworkGatewaysGenerateVpnProfile_568457;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates VPN profile for P2S client of the virtual network gateway in the specified resource group. Used for IKEV2 and radius based authentication.
  ## 
  let valid = call_568465.validator(path, query, header, formData, body)
  let scheme = call_568465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568465.url(scheme.get, call_568465.host, call_568465.base,
                         call_568465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568465, url, valid)

proc call*(call_568466: Call_VirtualNetworkGatewaysGenerateVpnProfile_568457;
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
  var path_568467 = newJObject()
  var query_568468 = newJObject()
  var body_568469 = newJObject()
  add(path_568467, "resourceGroupName", newJString(resourceGroupName))
  add(query_568468, "api-version", newJString(apiVersion))
  add(path_568467, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568469 = parameters
  add(path_568467, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568466.call(path_568467, query_568468, nil, nil, body_568469)

var virtualNetworkGatewaysGenerateVpnProfile* = Call_VirtualNetworkGatewaysGenerateVpnProfile_568457(
    name: "virtualNetworkGatewaysGenerateVpnProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/generatevpnprofile",
    validator: validate_VirtualNetworkGatewaysGenerateVpnProfile_568458, base: "",
    url: url_VirtualNetworkGatewaysGenerateVpnProfile_568459,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGetAdvertisedRoutes_568470 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewaysGetAdvertisedRoutes_568472(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysGetAdvertisedRoutes_568471(path: JsonNode;
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
  var valid_568473 = path.getOrDefault("resourceGroupName")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "resourceGroupName", valid_568473
  var valid_568474 = path.getOrDefault("subscriptionId")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "subscriptionId", valid_568474
  var valid_568475 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "virtualNetworkGatewayName", valid_568475
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   peer: JString (required)
  ##       : The IP address of the peer
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568476 = query.getOrDefault("api-version")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "api-version", valid_568476
  var valid_568477 = query.getOrDefault("peer")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "peer", valid_568477
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568478: Call_VirtualNetworkGatewaysGetAdvertisedRoutes_568470;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves a list of routes the virtual network gateway is advertising to the specified peer.
  ## 
  let valid = call_568478.validator(path, query, header, formData, body)
  let scheme = call_568478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568478.url(scheme.get, call_568478.host, call_568478.base,
                         call_568478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568478, url, valid)

proc call*(call_568479: Call_VirtualNetworkGatewaysGetAdvertisedRoutes_568470;
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
  ##       : The IP address of the peer
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_568480 = newJObject()
  var query_568481 = newJObject()
  add(path_568480, "resourceGroupName", newJString(resourceGroupName))
  add(query_568481, "api-version", newJString(apiVersion))
  add(path_568480, "subscriptionId", newJString(subscriptionId))
  add(query_568481, "peer", newJString(peer))
  add(path_568480, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568479.call(path_568480, query_568481, nil, nil, nil)

var virtualNetworkGatewaysGetAdvertisedRoutes* = Call_VirtualNetworkGatewaysGetAdvertisedRoutes_568470(
    name: "virtualNetworkGatewaysGetAdvertisedRoutes", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/getAdvertisedRoutes",
    validator: validate_VirtualNetworkGatewaysGetAdvertisedRoutes_568471,
    base: "", url: url_VirtualNetworkGatewaysGetAdvertisedRoutes_568472,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGetBgpPeerStatus_568482 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewaysGetBgpPeerStatus_568484(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysGetBgpPeerStatus_568483(path: JsonNode;
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
  var valid_568485 = path.getOrDefault("resourceGroupName")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "resourceGroupName", valid_568485
  var valid_568486 = path.getOrDefault("subscriptionId")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "subscriptionId", valid_568486
  var valid_568487 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "virtualNetworkGatewayName", valid_568487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   peer: JString
  ##       : The IP address of the peer to retrieve the status of.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568488 = query.getOrDefault("api-version")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "api-version", valid_568488
  var valid_568489 = query.getOrDefault("peer")
  valid_568489 = validateParameter(valid_568489, JString, required = false,
                                 default = nil)
  if valid_568489 != nil:
    section.add "peer", valid_568489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568490: Call_VirtualNetworkGatewaysGetBgpPeerStatus_568482;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The GetBgpPeerStatus operation retrieves the status of all BGP peers.
  ## 
  let valid = call_568490.validator(path, query, header, formData, body)
  let scheme = call_568490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568490.url(scheme.get, call_568490.host, call_568490.base,
                         call_568490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568490, url, valid)

proc call*(call_568491: Call_VirtualNetworkGatewaysGetBgpPeerStatus_568482;
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
  var path_568492 = newJObject()
  var query_568493 = newJObject()
  add(path_568492, "resourceGroupName", newJString(resourceGroupName))
  add(query_568493, "api-version", newJString(apiVersion))
  add(path_568492, "subscriptionId", newJString(subscriptionId))
  add(query_568493, "peer", newJString(peer))
  add(path_568492, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568491.call(path_568492, query_568493, nil, nil, nil)

var virtualNetworkGatewaysGetBgpPeerStatus* = Call_VirtualNetworkGatewaysGetBgpPeerStatus_568482(
    name: "virtualNetworkGatewaysGetBgpPeerStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/getBgpPeerStatus",
    validator: validate_VirtualNetworkGatewaysGetBgpPeerStatus_568483, base: "",
    url: url_VirtualNetworkGatewaysGetBgpPeerStatus_568484,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGetLearnedRoutes_568494 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewaysGetLearnedRoutes_568496(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysGetLearnedRoutes_568495(path: JsonNode;
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
  var valid_568497 = path.getOrDefault("resourceGroupName")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "resourceGroupName", valid_568497
  var valid_568498 = path.getOrDefault("subscriptionId")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "subscriptionId", valid_568498
  var valid_568499 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "virtualNetworkGatewayName", valid_568499
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568500 = query.getOrDefault("api-version")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "api-version", valid_568500
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568501: Call_VirtualNetworkGatewaysGetLearnedRoutes_568494;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves a list of routes the virtual network gateway has learned, including routes learned from BGP peers.
  ## 
  let valid = call_568501.validator(path, query, header, formData, body)
  let scheme = call_568501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568501.url(scheme.get, call_568501.host, call_568501.base,
                         call_568501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568501, url, valid)

proc call*(call_568502: Call_VirtualNetworkGatewaysGetLearnedRoutes_568494;
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
  var path_568503 = newJObject()
  var query_568504 = newJObject()
  add(path_568503, "resourceGroupName", newJString(resourceGroupName))
  add(query_568504, "api-version", newJString(apiVersion))
  add(path_568503, "subscriptionId", newJString(subscriptionId))
  add(path_568503, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568502.call(path_568503, query_568504, nil, nil, nil)

var virtualNetworkGatewaysGetLearnedRoutes* = Call_VirtualNetworkGatewaysGetLearnedRoutes_568494(
    name: "virtualNetworkGatewaysGetLearnedRoutes", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/getLearnedRoutes",
    validator: validate_VirtualNetworkGatewaysGetLearnedRoutes_568495, base: "",
    url: url_VirtualNetworkGatewaysGetLearnedRoutes_568496,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGetVpnclientIpsecParameters_568505 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewaysGetVpnclientIpsecParameters_568507(
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

proc validate_VirtualNetworkGatewaysGetVpnclientIpsecParameters_568506(
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
  var valid_568508 = path.getOrDefault("resourceGroupName")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "resourceGroupName", valid_568508
  var valid_568509 = path.getOrDefault("subscriptionId")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "subscriptionId", valid_568509
  var valid_568510 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "virtualNetworkGatewayName", valid_568510
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568511 = query.getOrDefault("api-version")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "api-version", valid_568511
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568512: Call_VirtualNetworkGatewaysGetVpnclientIpsecParameters_568505;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get VpnclientIpsecParameters operation retrieves information about the vpnclient ipsec policy for P2S client of virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_568512.validator(path, query, header, formData, body)
  let scheme = call_568512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568512.url(scheme.get, call_568512.host, call_568512.base,
                         call_568512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568512, url, valid)

proc call*(call_568513: Call_VirtualNetworkGatewaysGetVpnclientIpsecParameters_568505;
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
  var path_568514 = newJObject()
  var query_568515 = newJObject()
  add(path_568514, "resourceGroupName", newJString(resourceGroupName))
  add(query_568515, "api-version", newJString(apiVersion))
  add(path_568514, "subscriptionId", newJString(subscriptionId))
  add(path_568514, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568513.call(path_568514, query_568515, nil, nil, nil)

var virtualNetworkGatewaysGetVpnclientIpsecParameters* = Call_VirtualNetworkGatewaysGetVpnclientIpsecParameters_568505(
    name: "virtualNetworkGatewaysGetVpnclientIpsecParameters",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/getvpnclientipsecparameters",
    validator: validate_VirtualNetworkGatewaysGetVpnclientIpsecParameters_568506,
    base: "", url: url_VirtualNetworkGatewaysGetVpnclientIpsecParameters_568507,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGetVpnProfilePackageUrl_568516 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewaysGetVpnProfilePackageUrl_568518(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysGetVpnProfilePackageUrl_568517(
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
  var valid_568519 = path.getOrDefault("resourceGroupName")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "resourceGroupName", valid_568519
  var valid_568520 = path.getOrDefault("subscriptionId")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "subscriptionId", valid_568520
  var valid_568521 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "virtualNetworkGatewayName", valid_568521
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568522 = query.getOrDefault("api-version")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "api-version", valid_568522
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568523: Call_VirtualNetworkGatewaysGetVpnProfilePackageUrl_568516;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets pre-generated VPN profile for P2S client of the virtual network gateway in the specified resource group. The profile needs to be generated first using generateVpnProfile.
  ## 
  let valid = call_568523.validator(path, query, header, formData, body)
  let scheme = call_568523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568523.url(scheme.get, call_568523.host, call_568523.base,
                         call_568523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568523, url, valid)

proc call*(call_568524: Call_VirtualNetworkGatewaysGetVpnProfilePackageUrl_568516;
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
  var path_568525 = newJObject()
  var query_568526 = newJObject()
  add(path_568525, "resourceGroupName", newJString(resourceGroupName))
  add(query_568526, "api-version", newJString(apiVersion))
  add(path_568525, "subscriptionId", newJString(subscriptionId))
  add(path_568525, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568524.call(path_568525, query_568526, nil, nil, nil)

var virtualNetworkGatewaysGetVpnProfilePackageUrl* = Call_VirtualNetworkGatewaysGetVpnProfilePackageUrl_568516(
    name: "virtualNetworkGatewaysGetVpnProfilePackageUrl",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/getvpnprofilepackageurl",
    validator: validate_VirtualNetworkGatewaysGetVpnProfilePackageUrl_568517,
    base: "", url: url_VirtualNetworkGatewaysGetVpnProfilePackageUrl_568518,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysReset_568527 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewaysReset_568529(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysReset_568528(path: JsonNode; query: JsonNode;
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
  var valid_568530 = path.getOrDefault("resourceGroupName")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "resourceGroupName", valid_568530
  var valid_568531 = path.getOrDefault("subscriptionId")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "subscriptionId", valid_568531
  var valid_568532 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "virtualNetworkGatewayName", valid_568532
  result.add "path", section
  ## parameters in `query` object:
  ##   gatewayVip: JString
  ##             : Virtual network gateway vip address supplied to the begin reset of the active-active feature enabled gateway.
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568533 = query.getOrDefault("gatewayVip")
  valid_568533 = validateParameter(valid_568533, JString, required = false,
                                 default = nil)
  if valid_568533 != nil:
    section.add "gatewayVip", valid_568533
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568534 = query.getOrDefault("api-version")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "api-version", valid_568534
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568535: Call_VirtualNetworkGatewaysReset_568527; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the primary of the virtual network gateway in the specified resource group.
  ## 
  let valid = call_568535.validator(path, query, header, formData, body)
  let scheme = call_568535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568535.url(scheme.get, call_568535.host, call_568535.base,
                         call_568535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568535, url, valid)

proc call*(call_568536: Call_VirtualNetworkGatewaysReset_568527;
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
  var path_568537 = newJObject()
  var query_568538 = newJObject()
  add(path_568537, "resourceGroupName", newJString(resourceGroupName))
  add(query_568538, "gatewayVip", newJString(gatewayVip))
  add(query_568538, "api-version", newJString(apiVersion))
  add(path_568537, "subscriptionId", newJString(subscriptionId))
  add(path_568537, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568536.call(path_568537, query_568538, nil, nil, nil)

var virtualNetworkGatewaysReset* = Call_VirtualNetworkGatewaysReset_568527(
    name: "virtualNetworkGatewaysReset", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/reset",
    validator: validate_VirtualNetworkGatewaysReset_568528, base: "",
    url: url_VirtualNetworkGatewaysReset_568529, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysSetVpnclientIpsecParameters_568539 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewaysSetVpnclientIpsecParameters_568541(
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

proc validate_VirtualNetworkGatewaysSetVpnclientIpsecParameters_568540(
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
  var valid_568542 = path.getOrDefault("resourceGroupName")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "resourceGroupName", valid_568542
  var valid_568543 = path.getOrDefault("subscriptionId")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "subscriptionId", valid_568543
  var valid_568544 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "virtualNetworkGatewayName", valid_568544
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568545 = query.getOrDefault("api-version")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "api-version", valid_568545
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

proc call*(call_568547: Call_VirtualNetworkGatewaysSetVpnclientIpsecParameters_568539;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Set VpnclientIpsecParameters operation sets the vpnclient ipsec policy for P2S client of virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_568547.validator(path, query, header, formData, body)
  let scheme = call_568547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568547.url(scheme.get, call_568547.host, call_568547.base,
                         call_568547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568547, url, valid)

proc call*(call_568548: Call_VirtualNetworkGatewaysSetVpnclientIpsecParameters_568539;
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
  var path_568549 = newJObject()
  var query_568550 = newJObject()
  var body_568551 = newJObject()
  add(path_568549, "resourceGroupName", newJString(resourceGroupName))
  add(query_568550, "api-version", newJString(apiVersion))
  add(path_568549, "subscriptionId", newJString(subscriptionId))
  add(path_568549, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  if vpnclientIpsecParams != nil:
    body_568551 = vpnclientIpsecParams
  result = call_568548.call(path_568549, query_568550, nil, nil, body_568551)

var virtualNetworkGatewaysSetVpnclientIpsecParameters* = Call_VirtualNetworkGatewaysSetVpnclientIpsecParameters_568539(
    name: "virtualNetworkGatewaysSetVpnclientIpsecParameters",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/setvpnclientipsecparameters",
    validator: validate_VirtualNetworkGatewaysSetVpnclientIpsecParameters_568540,
    base: "", url: url_VirtualNetworkGatewaysSetVpnclientIpsecParameters_568541,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysSupportedVpnDevices_568552 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkGatewaysSupportedVpnDevices_568554(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysSupportedVpnDevices_568553(path: JsonNode;
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
  var valid_568555 = path.getOrDefault("resourceGroupName")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "resourceGroupName", valid_568555
  var valid_568556 = path.getOrDefault("subscriptionId")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "subscriptionId", valid_568556
  var valid_568557 = path.getOrDefault("virtualNetworkGatewayName")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "virtualNetworkGatewayName", valid_568557
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568558 = query.getOrDefault("api-version")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "api-version", valid_568558
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568559: Call_VirtualNetworkGatewaysSupportedVpnDevices_568552;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a xml format representation for supported vpn devices.
  ## 
  let valid = call_568559.validator(path, query, header, formData, body)
  let scheme = call_568559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568559.url(scheme.get, call_568559.host, call_568559.base,
                         call_568559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568559, url, valid)

proc call*(call_568560: Call_VirtualNetworkGatewaysSupportedVpnDevices_568552;
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
  var path_568561 = newJObject()
  var query_568562 = newJObject()
  add(path_568561, "resourceGroupName", newJString(resourceGroupName))
  add(query_568562, "api-version", newJString(apiVersion))
  add(path_568561, "subscriptionId", newJString(subscriptionId))
  add(path_568561, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_568560.call(path_568561, query_568562, nil, nil, nil)

var virtualNetworkGatewaysSupportedVpnDevices* = Call_VirtualNetworkGatewaysSupportedVpnDevices_568552(
    name: "virtualNetworkGatewaysSupportedVpnDevices", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/supportedvpndevices",
    validator: validate_VirtualNetworkGatewaysSupportedVpnDevices_568553,
    base: "", url: url_VirtualNetworkGatewaysSupportedVpnDevices_568554,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
