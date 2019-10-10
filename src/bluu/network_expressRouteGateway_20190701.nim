
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "network-expressRouteGateway"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ExpressRouteGatewaysListBySubscription_573879 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteGatewaysListBySubscription_573881(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteGateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteGatewaysListBySubscription_573880(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists ExpressRoute gateways under a given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574041 = path.getOrDefault("subscriptionId")
  valid_574041 = validateParameter(valid_574041, JString, required = true,
                                 default = nil)
  if valid_574041 != nil:
    section.add "subscriptionId", valid_574041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574042 = query.getOrDefault("api-version")
  valid_574042 = validateParameter(valid_574042, JString, required = true,
                                 default = nil)
  if valid_574042 != nil:
    section.add "api-version", valid_574042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574069: Call_ExpressRouteGatewaysListBySubscription_573879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ExpressRoute gateways under a given subscription.
  ## 
  let valid = call_574069.validator(path, query, header, formData, body)
  let scheme = call_574069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574069.url(scheme.get, call_574069.host, call_574069.base,
                         call_574069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574069, url, valid)

proc call*(call_574140: Call_ExpressRouteGatewaysListBySubscription_573879;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteGatewaysListBySubscription
  ## Lists ExpressRoute gateways under a given subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574141 = newJObject()
  var query_574143 = newJObject()
  add(query_574143, "api-version", newJString(apiVersion))
  add(path_574141, "subscriptionId", newJString(subscriptionId))
  result = call_574140.call(path_574141, query_574143, nil, nil, nil)

var expressRouteGatewaysListBySubscription* = Call_ExpressRouteGatewaysListBySubscription_573879(
    name: "expressRouteGatewaysListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteGateways",
    validator: validate_ExpressRouteGatewaysListBySubscription_573880, base: "",
    url: url_ExpressRouteGatewaysListBySubscription_573881,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteGatewaysListByResourceGroup_574182 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteGatewaysListByResourceGroup_574184(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteGateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteGatewaysListByResourceGroup_574183(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists ExpressRoute gateways in a given resource group.
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
  var valid_574185 = path.getOrDefault("resourceGroupName")
  valid_574185 = validateParameter(valid_574185, JString, required = true,
                                 default = nil)
  if valid_574185 != nil:
    section.add "resourceGroupName", valid_574185
  var valid_574186 = path.getOrDefault("subscriptionId")
  valid_574186 = validateParameter(valid_574186, JString, required = true,
                                 default = nil)
  if valid_574186 != nil:
    section.add "subscriptionId", valid_574186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574187 = query.getOrDefault("api-version")
  valid_574187 = validateParameter(valid_574187, JString, required = true,
                                 default = nil)
  if valid_574187 != nil:
    section.add "api-version", valid_574187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574188: Call_ExpressRouteGatewaysListByResourceGroup_574182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ExpressRoute gateways in a given resource group.
  ## 
  let valid = call_574188.validator(path, query, header, formData, body)
  let scheme = call_574188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574188.url(scheme.get, call_574188.host, call_574188.base,
                         call_574188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574188, url, valid)

proc call*(call_574189: Call_ExpressRouteGatewaysListByResourceGroup_574182;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteGatewaysListByResourceGroup
  ## Lists ExpressRoute gateways in a given resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574190 = newJObject()
  var query_574191 = newJObject()
  add(path_574190, "resourceGroupName", newJString(resourceGroupName))
  add(query_574191, "api-version", newJString(apiVersion))
  add(path_574190, "subscriptionId", newJString(subscriptionId))
  result = call_574189.call(path_574190, query_574191, nil, nil, nil)

var expressRouteGatewaysListByResourceGroup* = Call_ExpressRouteGatewaysListByResourceGroup_574182(
    name: "expressRouteGatewaysListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteGateways",
    validator: validate_ExpressRouteGatewaysListByResourceGroup_574183, base: "",
    url: url_ExpressRouteGatewaysListByResourceGroup_574184,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteGatewaysCreateOrUpdate_574203 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteGatewaysCreateOrUpdate_574205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "expressRouteGatewayName" in path,
        "`expressRouteGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteGateways/"),
               (kind: VariableSegment, value: "expressRouteGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteGatewaysCreateOrUpdate_574204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a ExpressRoute gateway in a specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRouteGatewayName: JString (required)
  ##                          : The name of the ExpressRoute gateway.
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
  var valid_574234 = path.getOrDefault("expressRouteGatewayName")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "expressRouteGatewayName", valid_574234
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
  ##   putExpressRouteGatewayParameters: JObject (required)
  ##                                   : Parameters required in an ExpressRoute gateway PUT operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574237: Call_ExpressRouteGatewaysCreateOrUpdate_574203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a ExpressRoute gateway in a specified resource group.
  ## 
  let valid = call_574237.validator(path, query, header, formData, body)
  let scheme = call_574237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574237.url(scheme.get, call_574237.host, call_574237.base,
                         call_574237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574237, url, valid)

proc call*(call_574238: Call_ExpressRouteGatewaysCreateOrUpdate_574203;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          expressRouteGatewayName: string;
          putExpressRouteGatewayParameters: JsonNode): Recallable =
  ## expressRouteGatewaysCreateOrUpdate
  ## Creates or updates a ExpressRoute gateway in a specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRouteGatewayName: string (required)
  ##                          : The name of the ExpressRoute gateway.
  ##   putExpressRouteGatewayParameters: JObject (required)
  ##                                   : Parameters required in an ExpressRoute gateway PUT operation.
  var path_574239 = newJObject()
  var query_574240 = newJObject()
  var body_574241 = newJObject()
  add(path_574239, "resourceGroupName", newJString(resourceGroupName))
  add(query_574240, "api-version", newJString(apiVersion))
  add(path_574239, "subscriptionId", newJString(subscriptionId))
  add(path_574239, "expressRouteGatewayName", newJString(expressRouteGatewayName))
  if putExpressRouteGatewayParameters != nil:
    body_574241 = putExpressRouteGatewayParameters
  result = call_574238.call(path_574239, query_574240, nil, nil, body_574241)

var expressRouteGatewaysCreateOrUpdate* = Call_ExpressRouteGatewaysCreateOrUpdate_574203(
    name: "expressRouteGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteGateways/{expressRouteGatewayName}",
    validator: validate_ExpressRouteGatewaysCreateOrUpdate_574204, base: "",
    url: url_ExpressRouteGatewaysCreateOrUpdate_574205, schemes: {Scheme.Https})
type
  Call_ExpressRouteGatewaysGet_574192 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteGatewaysGet_574194(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "expressRouteGatewayName" in path,
        "`expressRouteGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteGateways/"),
               (kind: VariableSegment, value: "expressRouteGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteGatewaysGet_574193(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the details of a ExpressRoute gateway in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRouteGatewayName: JString (required)
  ##                          : The name of the ExpressRoute gateway.
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
  var valid_574197 = path.getOrDefault("expressRouteGatewayName")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "expressRouteGatewayName", valid_574197
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

proc call*(call_574199: Call_ExpressRouteGatewaysGet_574192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the details of a ExpressRoute gateway in a resource group.
  ## 
  let valid = call_574199.validator(path, query, header, formData, body)
  let scheme = call_574199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574199.url(scheme.get, call_574199.host, call_574199.base,
                         call_574199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574199, url, valid)

proc call*(call_574200: Call_ExpressRouteGatewaysGet_574192;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          expressRouteGatewayName: string): Recallable =
  ## expressRouteGatewaysGet
  ## Fetches the details of a ExpressRoute gateway in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRouteGatewayName: string (required)
  ##                          : The name of the ExpressRoute gateway.
  var path_574201 = newJObject()
  var query_574202 = newJObject()
  add(path_574201, "resourceGroupName", newJString(resourceGroupName))
  add(query_574202, "api-version", newJString(apiVersion))
  add(path_574201, "subscriptionId", newJString(subscriptionId))
  add(path_574201, "expressRouteGatewayName", newJString(expressRouteGatewayName))
  result = call_574200.call(path_574201, query_574202, nil, nil, nil)

var expressRouteGatewaysGet* = Call_ExpressRouteGatewaysGet_574192(
    name: "expressRouteGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteGateways/{expressRouteGatewayName}",
    validator: validate_ExpressRouteGatewaysGet_574193, base: "",
    url: url_ExpressRouteGatewaysGet_574194, schemes: {Scheme.Https})
type
  Call_ExpressRouteGatewaysDelete_574242 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteGatewaysDelete_574244(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "expressRouteGatewayName" in path,
        "`expressRouteGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteGateways/"),
               (kind: VariableSegment, value: "expressRouteGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteGatewaysDelete_574243(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified ExpressRoute gateway in a resource group. An ExpressRoute gateway resource can only be deleted when there are no connection subresources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRouteGatewayName: JString (required)
  ##                          : The name of the ExpressRoute gateway.
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
  var valid_574247 = path.getOrDefault("expressRouteGatewayName")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "expressRouteGatewayName", valid_574247
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

proc call*(call_574249: Call_ExpressRouteGatewaysDelete_574242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified ExpressRoute gateway in a resource group. An ExpressRoute gateway resource can only be deleted when there are no connection subresources.
  ## 
  let valid = call_574249.validator(path, query, header, formData, body)
  let scheme = call_574249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574249.url(scheme.get, call_574249.host, call_574249.base,
                         call_574249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574249, url, valid)

proc call*(call_574250: Call_ExpressRouteGatewaysDelete_574242;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          expressRouteGatewayName: string): Recallable =
  ## expressRouteGatewaysDelete
  ## Deletes the specified ExpressRoute gateway in a resource group. An ExpressRoute gateway resource can only be deleted when there are no connection subresources.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRouteGatewayName: string (required)
  ##                          : The name of the ExpressRoute gateway.
  var path_574251 = newJObject()
  var query_574252 = newJObject()
  add(path_574251, "resourceGroupName", newJString(resourceGroupName))
  add(query_574252, "api-version", newJString(apiVersion))
  add(path_574251, "subscriptionId", newJString(subscriptionId))
  add(path_574251, "expressRouteGatewayName", newJString(expressRouteGatewayName))
  result = call_574250.call(path_574251, query_574252, nil, nil, nil)

var expressRouteGatewaysDelete* = Call_ExpressRouteGatewaysDelete_574242(
    name: "expressRouteGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteGateways/{expressRouteGatewayName}",
    validator: validate_ExpressRouteGatewaysDelete_574243, base: "",
    url: url_ExpressRouteGatewaysDelete_574244, schemes: {Scheme.Https})
type
  Call_ExpressRouteConnectionsList_574253 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteConnectionsList_574255(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "expressRouteGatewayName" in path,
        "`expressRouteGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteGateways/"),
               (kind: VariableSegment, value: "expressRouteGatewayName"),
               (kind: ConstantSegment, value: "/expressRouteConnections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteConnectionsList_574254(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists ExpressRouteConnections.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRouteGatewayName: JString (required)
  ##                          : The name of the ExpressRoute gateway.
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
  var valid_574258 = path.getOrDefault("expressRouteGatewayName")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "expressRouteGatewayName", valid_574258
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
  if body != nil:
    result.add "body", body

proc call*(call_574260: Call_ExpressRouteConnectionsList_574253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists ExpressRouteConnections.
  ## 
  let valid = call_574260.validator(path, query, header, formData, body)
  let scheme = call_574260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574260.url(scheme.get, call_574260.host, call_574260.base,
                         call_574260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574260, url, valid)

proc call*(call_574261: Call_ExpressRouteConnectionsList_574253;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          expressRouteGatewayName: string): Recallable =
  ## expressRouteConnectionsList
  ## Lists ExpressRouteConnections.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRouteGatewayName: string (required)
  ##                          : The name of the ExpressRoute gateway.
  var path_574262 = newJObject()
  var query_574263 = newJObject()
  add(path_574262, "resourceGroupName", newJString(resourceGroupName))
  add(query_574263, "api-version", newJString(apiVersion))
  add(path_574262, "subscriptionId", newJString(subscriptionId))
  add(path_574262, "expressRouteGatewayName", newJString(expressRouteGatewayName))
  result = call_574261.call(path_574262, query_574263, nil, nil, nil)

var expressRouteConnectionsList* = Call_ExpressRouteConnectionsList_574253(
    name: "expressRouteConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteGateways/{expressRouteGatewayName}/expressRouteConnections",
    validator: validate_ExpressRouteConnectionsList_574254, base: "",
    url: url_ExpressRouteConnectionsList_574255, schemes: {Scheme.Https})
type
  Call_ExpressRouteConnectionsCreateOrUpdate_574276 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteConnectionsCreateOrUpdate_574278(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "expressRouteGatewayName" in path,
        "`expressRouteGatewayName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteGateways/"),
               (kind: VariableSegment, value: "expressRouteGatewayName"),
               (kind: ConstantSegment, value: "/expressRouteConnections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteConnectionsCreateOrUpdate_574277(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a connection between an ExpressRoute gateway and an ExpressRoute circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRouteGatewayName: JString (required)
  ##                          : The name of the ExpressRoute gateway.
  ##   connectionName: JString (required)
  ##                 : The name of the connection subresource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574279 = path.getOrDefault("resourceGroupName")
  valid_574279 = validateParameter(valid_574279, JString, required = true,
                                 default = nil)
  if valid_574279 != nil:
    section.add "resourceGroupName", valid_574279
  var valid_574280 = path.getOrDefault("subscriptionId")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = nil)
  if valid_574280 != nil:
    section.add "subscriptionId", valid_574280
  var valid_574281 = path.getOrDefault("expressRouteGatewayName")
  valid_574281 = validateParameter(valid_574281, JString, required = true,
                                 default = nil)
  if valid_574281 != nil:
    section.add "expressRouteGatewayName", valid_574281
  var valid_574282 = path.getOrDefault("connectionName")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "connectionName", valid_574282
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
  ##   putExpressRouteConnectionParameters: JObject (required)
  ##                                      : Parameters required in an ExpressRouteConnection PUT operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574285: Call_ExpressRouteConnectionsCreateOrUpdate_574276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a connection between an ExpressRoute gateway and an ExpressRoute circuit.
  ## 
  let valid = call_574285.validator(path, query, header, formData, body)
  let scheme = call_574285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574285.url(scheme.get, call_574285.host, call_574285.base,
                         call_574285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574285, url, valid)

proc call*(call_574286: Call_ExpressRouteConnectionsCreateOrUpdate_574276;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          expressRouteGatewayName: string;
          putExpressRouteConnectionParameters: JsonNode; connectionName: string): Recallable =
  ## expressRouteConnectionsCreateOrUpdate
  ## Creates a connection between an ExpressRoute gateway and an ExpressRoute circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRouteGatewayName: string (required)
  ##                          : The name of the ExpressRoute gateway.
  ##   putExpressRouteConnectionParameters: JObject (required)
  ##                                      : Parameters required in an ExpressRouteConnection PUT operation.
  ##   connectionName: string (required)
  ##                 : The name of the connection subresource.
  var path_574287 = newJObject()
  var query_574288 = newJObject()
  var body_574289 = newJObject()
  add(path_574287, "resourceGroupName", newJString(resourceGroupName))
  add(query_574288, "api-version", newJString(apiVersion))
  add(path_574287, "subscriptionId", newJString(subscriptionId))
  add(path_574287, "expressRouteGatewayName", newJString(expressRouteGatewayName))
  if putExpressRouteConnectionParameters != nil:
    body_574289 = putExpressRouteConnectionParameters
  add(path_574287, "connectionName", newJString(connectionName))
  result = call_574286.call(path_574287, query_574288, nil, nil, body_574289)

var expressRouteConnectionsCreateOrUpdate* = Call_ExpressRouteConnectionsCreateOrUpdate_574276(
    name: "expressRouteConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteGateways/{expressRouteGatewayName}/expressRouteConnections/{connectionName}",
    validator: validate_ExpressRouteConnectionsCreateOrUpdate_574277, base: "",
    url: url_ExpressRouteConnectionsCreateOrUpdate_574278, schemes: {Scheme.Https})
type
  Call_ExpressRouteConnectionsGet_574264 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteConnectionsGet_574266(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "expressRouteGatewayName" in path,
        "`expressRouteGatewayName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteGateways/"),
               (kind: VariableSegment, value: "expressRouteGatewayName"),
               (kind: ConstantSegment, value: "/expressRouteConnections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteConnectionsGet_574265(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified ExpressRouteConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRouteGatewayName: JString (required)
  ##                          : The name of the ExpressRoute gateway.
  ##   connectionName: JString (required)
  ##                 : The name of the ExpressRoute connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574267 = path.getOrDefault("resourceGroupName")
  valid_574267 = validateParameter(valid_574267, JString, required = true,
                                 default = nil)
  if valid_574267 != nil:
    section.add "resourceGroupName", valid_574267
  var valid_574268 = path.getOrDefault("subscriptionId")
  valid_574268 = validateParameter(valid_574268, JString, required = true,
                                 default = nil)
  if valid_574268 != nil:
    section.add "subscriptionId", valid_574268
  var valid_574269 = path.getOrDefault("expressRouteGatewayName")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "expressRouteGatewayName", valid_574269
  var valid_574270 = path.getOrDefault("connectionName")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "connectionName", valid_574270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574271 = query.getOrDefault("api-version")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "api-version", valid_574271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574272: Call_ExpressRouteConnectionsGet_574264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ExpressRouteConnection.
  ## 
  let valid = call_574272.validator(path, query, header, formData, body)
  let scheme = call_574272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574272.url(scheme.get, call_574272.host, call_574272.base,
                         call_574272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574272, url, valid)

proc call*(call_574273: Call_ExpressRouteConnectionsGet_574264;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          expressRouteGatewayName: string; connectionName: string): Recallable =
  ## expressRouteConnectionsGet
  ## Gets the specified ExpressRouteConnection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRouteGatewayName: string (required)
  ##                          : The name of the ExpressRoute gateway.
  ##   connectionName: string (required)
  ##                 : The name of the ExpressRoute connection.
  var path_574274 = newJObject()
  var query_574275 = newJObject()
  add(path_574274, "resourceGroupName", newJString(resourceGroupName))
  add(query_574275, "api-version", newJString(apiVersion))
  add(path_574274, "subscriptionId", newJString(subscriptionId))
  add(path_574274, "expressRouteGatewayName", newJString(expressRouteGatewayName))
  add(path_574274, "connectionName", newJString(connectionName))
  result = call_574273.call(path_574274, query_574275, nil, nil, nil)

var expressRouteConnectionsGet* = Call_ExpressRouteConnectionsGet_574264(
    name: "expressRouteConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteGateways/{expressRouteGatewayName}/expressRouteConnections/{connectionName}",
    validator: validate_ExpressRouteConnectionsGet_574265, base: "",
    url: url_ExpressRouteConnectionsGet_574266, schemes: {Scheme.Https})
type
  Call_ExpressRouteConnectionsDelete_574290 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteConnectionsDelete_574292(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "expressRouteGatewayName" in path,
        "`expressRouteGatewayName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteGateways/"),
               (kind: VariableSegment, value: "expressRouteGatewayName"),
               (kind: ConstantSegment, value: "/expressRouteConnections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteConnectionsDelete_574291(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a connection to a ExpressRoute circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRouteGatewayName: JString (required)
  ##                          : The name of the ExpressRoute gateway.
  ##   connectionName: JString (required)
  ##                 : The name of the connection subresource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574293 = path.getOrDefault("resourceGroupName")
  valid_574293 = validateParameter(valid_574293, JString, required = true,
                                 default = nil)
  if valid_574293 != nil:
    section.add "resourceGroupName", valid_574293
  var valid_574294 = path.getOrDefault("subscriptionId")
  valid_574294 = validateParameter(valid_574294, JString, required = true,
                                 default = nil)
  if valid_574294 != nil:
    section.add "subscriptionId", valid_574294
  var valid_574295 = path.getOrDefault("expressRouteGatewayName")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "expressRouteGatewayName", valid_574295
  var valid_574296 = path.getOrDefault("connectionName")
  valid_574296 = validateParameter(valid_574296, JString, required = true,
                                 default = nil)
  if valid_574296 != nil:
    section.add "connectionName", valid_574296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574297 = query.getOrDefault("api-version")
  valid_574297 = validateParameter(valid_574297, JString, required = true,
                                 default = nil)
  if valid_574297 != nil:
    section.add "api-version", valid_574297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574298: Call_ExpressRouteConnectionsDelete_574290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a connection to a ExpressRoute circuit.
  ## 
  let valid = call_574298.validator(path, query, header, formData, body)
  let scheme = call_574298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574298.url(scheme.get, call_574298.host, call_574298.base,
                         call_574298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574298, url, valid)

proc call*(call_574299: Call_ExpressRouteConnectionsDelete_574290;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          expressRouteGatewayName: string; connectionName: string): Recallable =
  ## expressRouteConnectionsDelete
  ## Deletes a connection to a ExpressRoute circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRouteGatewayName: string (required)
  ##                          : The name of the ExpressRoute gateway.
  ##   connectionName: string (required)
  ##                 : The name of the connection subresource.
  var path_574300 = newJObject()
  var query_574301 = newJObject()
  add(path_574300, "resourceGroupName", newJString(resourceGroupName))
  add(query_574301, "api-version", newJString(apiVersion))
  add(path_574300, "subscriptionId", newJString(subscriptionId))
  add(path_574300, "expressRouteGatewayName", newJString(expressRouteGatewayName))
  add(path_574300, "connectionName", newJString(connectionName))
  result = call_574299.call(path_574300, query_574301, nil, nil, nil)

var expressRouteConnectionsDelete* = Call_ExpressRouteConnectionsDelete_574290(
    name: "expressRouteConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteGateways/{expressRouteGatewayName}/expressRouteConnections/{connectionName}",
    validator: validate_ExpressRouteConnectionsDelete_574291, base: "",
    url: url_ExpressRouteConnectionsDelete_574292, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
