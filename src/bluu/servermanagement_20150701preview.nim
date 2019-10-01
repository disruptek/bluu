
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ServerManagement
## version: 2015-07-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## REST API for Azure Server Management Service.
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
  macServiceName = "servermanagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GatewayList_567879 = ref object of OpenApiRestCall_567657
proc url_GatewayList_567881(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/gateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GatewayList_567880(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists gateways in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568054 = path.getOrDefault("subscriptionId")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = nil)
  if valid_568054 != nil:
    section.add "subscriptionId", valid_568054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568055 = query.getOrDefault("api-version")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "api-version", valid_568055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568078: Call_GatewayList_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists gateways in a subscription.
  ## 
  let valid = call_568078.validator(path, query, header, formData, body)
  let scheme = call_568078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568078.url(scheme.get, call_568078.host, call_568078.base,
                         call_568078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568078, url, valid)

proc call*(call_568149: Call_GatewayList_567879; apiVersion: string;
          subscriptionId: string): Recallable =
  ## gatewayList
  ## Lists gateways in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568150 = newJObject()
  var query_568152 = newJObject()
  add(query_568152, "api-version", newJString(apiVersion))
  add(path_568150, "subscriptionId", newJString(subscriptionId))
  result = call_568149.call(path_568150, query_568152, nil, nil, nil)

var gatewayList* = Call_GatewayList_567879(name: "gatewayList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServerManagement/gateways",
                                        validator: validate_GatewayList_567880,
                                        base: "", url: url_GatewayList_567881,
                                        schemes: {Scheme.Https})
type
  Call_NodeList_568191 = ref object of OpenApiRestCall_567657
proc url_NodeList_568193(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/nodes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodeList_568192(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists nodes in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568194 = path.getOrDefault("subscriptionId")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "subscriptionId", valid_568194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568195 = query.getOrDefault("api-version")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "api-version", valid_568195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568196: Call_NodeList_568191; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists nodes in a subscription.
  ## 
  let valid = call_568196.validator(path, query, header, formData, body)
  let scheme = call_568196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568196.url(scheme.get, call_568196.host, call_568196.base,
                         call_568196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568196, url, valid)

proc call*(call_568197: Call_NodeList_568191; apiVersion: string;
          subscriptionId: string): Recallable =
  ## nodeList
  ## Lists nodes in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568198 = newJObject()
  var query_568199 = newJObject()
  add(query_568199, "api-version", newJString(apiVersion))
  add(path_568198, "subscriptionId", newJString(subscriptionId))
  result = call_568197.call(path_568198, query_568199, nil, nil, nil)

var nodeList* = Call_NodeList_568191(name: "nodeList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServerManagement/nodes",
                                  validator: validate_NodeList_568192, base: "",
                                  url: url_NodeList_568193,
                                  schemes: {Scheme.Https})
type
  Call_GatewayListForResourceGroup_568200 = ref object of OpenApiRestCall_567657
proc url_GatewayListForResourceGroup_568202(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ServerManagement/gateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GatewayListForResourceGroup_568201(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns gateways in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568203 = path.getOrDefault("resourceGroupName")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "resourceGroupName", valid_568203
  var valid_568204 = path.getOrDefault("subscriptionId")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "subscriptionId", valid_568204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568205 = query.getOrDefault("api-version")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "api-version", valid_568205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568206: Call_GatewayListForResourceGroup_568200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns gateways in a resource group.
  ## 
  let valid = call_568206.validator(path, query, header, formData, body)
  let scheme = call_568206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568206.url(scheme.get, call_568206.host, call_568206.base,
                         call_568206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568206, url, valid)

proc call*(call_568207: Call_GatewayListForResourceGroup_568200;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## gatewayListForResourceGroup
  ## Returns gateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568208 = newJObject()
  var query_568209 = newJObject()
  add(path_568208, "resourceGroupName", newJString(resourceGroupName))
  add(query_568209, "api-version", newJString(apiVersion))
  add(path_568208, "subscriptionId", newJString(subscriptionId))
  result = call_568207.call(path_568208, query_568209, nil, nil, nil)

var gatewayListForResourceGroup* = Call_GatewayListForResourceGroup_568200(
    name: "gatewayListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/gateways",
    validator: validate_GatewayListForResourceGroup_568201, base: "",
    url: url_GatewayListForResourceGroup_568202, schemes: {Scheme.Https})
type
  Call_GatewayCreate_568236 = ref object of OpenApiRestCall_567657
proc url_GatewayCreate_568238(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/gateways/"),
               (kind: VariableSegment, value: "gatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GatewayCreate_568237(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a ManagementService gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   gatewayName: JString (required)
  ##              : The gateway name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568256 = path.getOrDefault("resourceGroupName")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "resourceGroupName", valid_568256
  var valid_568257 = path.getOrDefault("gatewayName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "gatewayName", valid_568257
  var valid_568258 = path.getOrDefault("subscriptionId")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "subscriptionId", valid_568258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
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
  ##   GatewayParameters: JObject (required)
  ##                    : Parameters supplied to the CreateOrUpdate operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568261: Call_GatewayCreate_568236; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a ManagementService gateway.
  ## 
  let valid = call_568261.validator(path, query, header, formData, body)
  let scheme = call_568261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568261.url(scheme.get, call_568261.host, call_568261.base,
                         call_568261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568261, url, valid)

proc call*(call_568262: Call_GatewayCreate_568236; resourceGroupName: string;
          apiVersion: string; gatewayName: string; subscriptionId: string;
          GatewayParameters: JsonNode): Recallable =
  ## gatewayCreate
  ## Creates or updates a ManagementService gateway.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   gatewayName: string (required)
  ##              : The gateway name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   GatewayParameters: JObject (required)
  ##                    : Parameters supplied to the CreateOrUpdate operation.
  var path_568263 = newJObject()
  var query_568264 = newJObject()
  var body_568265 = newJObject()
  add(path_568263, "resourceGroupName", newJString(resourceGroupName))
  add(query_568264, "api-version", newJString(apiVersion))
  add(path_568263, "gatewayName", newJString(gatewayName))
  add(path_568263, "subscriptionId", newJString(subscriptionId))
  if GatewayParameters != nil:
    body_568265 = GatewayParameters
  result = call_568262.call(path_568263, query_568264, nil, nil, body_568265)

var gatewayCreate* = Call_GatewayCreate_568236(name: "gatewayCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/gateways/{gatewayName}",
    validator: validate_GatewayCreate_568237, base: "", url: url_GatewayCreate_568238,
    schemes: {Scheme.Https})
type
  Call_GatewayGet_568210 = ref object of OpenApiRestCall_567657
proc url_GatewayGet_568212(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/gateways/"),
               (kind: VariableSegment, value: "gatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GatewayGet_568211(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   gatewayName: JString (required)
  ##              : The gateway name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568214 = path.getOrDefault("resourceGroupName")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "resourceGroupName", valid_568214
  var valid_568215 = path.getOrDefault("gatewayName")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "gatewayName", valid_568215
  var valid_568216 = path.getOrDefault("subscriptionId")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "subscriptionId", valid_568216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $expand: JString
  ##          : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568217 = query.getOrDefault("api-version")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "api-version", valid_568217
  var valid_568231 = query.getOrDefault("$expand")
  valid_568231 = validateParameter(valid_568231, JString, required = false,
                                 default = newJString("status"))
  if valid_568231 != nil:
    section.add "$expand", valid_568231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568232: Call_GatewayGet_568210; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a gateway.
  ## 
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_GatewayGet_568210; resourceGroupName: string;
          apiVersion: string; gatewayName: string; subscriptionId: string;
          Expand: string = "status"): Recallable =
  ## gatewayGet
  ## Gets a gateway.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   Expand: string
  ##         : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   gatewayName: string (required)
  ##              : The gateway name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  add(path_568234, "resourceGroupName", newJString(resourceGroupName))
  add(query_568235, "api-version", newJString(apiVersion))
  add(query_568235, "$expand", newJString(Expand))
  add(path_568234, "gatewayName", newJString(gatewayName))
  add(path_568234, "subscriptionId", newJString(subscriptionId))
  result = call_568233.call(path_568234, query_568235, nil, nil, nil)

var gatewayGet* = Call_GatewayGet_568210(name: "gatewayGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/gateways/{gatewayName}",
                                      validator: validate_GatewayGet_568211,
                                      base: "", url: url_GatewayGet_568212,
                                      schemes: {Scheme.Https})
type
  Call_GatewayUpdate_568277 = ref object of OpenApiRestCall_567657
proc url_GatewayUpdate_568279(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/gateways/"),
               (kind: VariableSegment, value: "gatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GatewayUpdate_568278(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a gateway belonging to a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   gatewayName: JString (required)
  ##              : The gateway name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568280 = path.getOrDefault("resourceGroupName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "resourceGroupName", valid_568280
  var valid_568281 = path.getOrDefault("gatewayName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "gatewayName", valid_568281
  var valid_568282 = path.getOrDefault("subscriptionId")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "subscriptionId", valid_568282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
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
  ##   GatewayParameters: JObject (required)
  ##                    : Parameters supplied to the Update operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568285: Call_GatewayUpdate_568277; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a gateway belonging to a resource group.
  ## 
  let valid = call_568285.validator(path, query, header, formData, body)
  let scheme = call_568285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568285.url(scheme.get, call_568285.host, call_568285.base,
                         call_568285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568285, url, valid)

proc call*(call_568286: Call_GatewayUpdate_568277; resourceGroupName: string;
          apiVersion: string; gatewayName: string; subscriptionId: string;
          GatewayParameters: JsonNode): Recallable =
  ## gatewayUpdate
  ## Updates a gateway belonging to a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   gatewayName: string (required)
  ##              : The gateway name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   GatewayParameters: JObject (required)
  ##                    : Parameters supplied to the Update operation.
  var path_568287 = newJObject()
  var query_568288 = newJObject()
  var body_568289 = newJObject()
  add(path_568287, "resourceGroupName", newJString(resourceGroupName))
  add(query_568288, "api-version", newJString(apiVersion))
  add(path_568287, "gatewayName", newJString(gatewayName))
  add(path_568287, "subscriptionId", newJString(subscriptionId))
  if GatewayParameters != nil:
    body_568289 = GatewayParameters
  result = call_568286.call(path_568287, query_568288, nil, nil, body_568289)

var gatewayUpdate* = Call_GatewayUpdate_568277(name: "gatewayUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/gateways/{gatewayName}",
    validator: validate_GatewayUpdate_568278, base: "", url: url_GatewayUpdate_568279,
    schemes: {Scheme.Https})
type
  Call_GatewayDelete_568266 = ref object of OpenApiRestCall_567657
proc url_GatewayDelete_568268(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/gateways/"),
               (kind: VariableSegment, value: "gatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GatewayDelete_568267(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a gateway from a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   gatewayName: JString (required)
  ##              : The gateway name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568269 = path.getOrDefault("resourceGroupName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "resourceGroupName", valid_568269
  var valid_568270 = path.getOrDefault("gatewayName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "gatewayName", valid_568270
  var valid_568271 = path.getOrDefault("subscriptionId")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "subscriptionId", valid_568271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
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

proc call*(call_568273: Call_GatewayDelete_568266; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a gateway from a resource group.
  ## 
  let valid = call_568273.validator(path, query, header, formData, body)
  let scheme = call_568273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568273.url(scheme.get, call_568273.host, call_568273.base,
                         call_568273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568273, url, valid)

proc call*(call_568274: Call_GatewayDelete_568266; resourceGroupName: string;
          apiVersion: string; gatewayName: string; subscriptionId: string): Recallable =
  ## gatewayDelete
  ## Deletes a gateway from a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   gatewayName: string (required)
  ##              : The gateway name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568275 = newJObject()
  var query_568276 = newJObject()
  add(path_568275, "resourceGroupName", newJString(resourceGroupName))
  add(query_568276, "api-version", newJString(apiVersion))
  add(path_568275, "gatewayName", newJString(gatewayName))
  add(path_568275, "subscriptionId", newJString(subscriptionId))
  result = call_568274.call(path_568275, query_568276, nil, nil, nil)

var gatewayDelete* = Call_GatewayDelete_568266(name: "gatewayDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/gateways/{gatewayName}",
    validator: validate_GatewayDelete_568267, base: "", url: url_GatewayDelete_568268,
    schemes: {Scheme.Https})
type
  Call_GatewayGetProfile_568290 = ref object of OpenApiRestCall_567657
proc url_GatewayGetProfile_568292(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/gateways/"),
               (kind: VariableSegment, value: "gatewayName"),
               (kind: ConstantSegment, value: "/profile")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GatewayGetProfile_568291(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a gateway profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   gatewayName: JString (required)
  ##              : The gateway name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568293 = path.getOrDefault("resourceGroupName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "resourceGroupName", valid_568293
  var valid_568294 = path.getOrDefault("gatewayName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "gatewayName", valid_568294
  var valid_568295 = path.getOrDefault("subscriptionId")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "subscriptionId", valid_568295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568296 = query.getOrDefault("api-version")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "api-version", valid_568296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568297: Call_GatewayGetProfile_568290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a gateway profile.
  ## 
  let valid = call_568297.validator(path, query, header, formData, body)
  let scheme = call_568297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568297.url(scheme.get, call_568297.host, call_568297.base,
                         call_568297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568297, url, valid)

proc call*(call_568298: Call_GatewayGetProfile_568290; resourceGroupName: string;
          apiVersion: string; gatewayName: string; subscriptionId: string): Recallable =
  ## gatewayGetProfile
  ## Gets a gateway profile.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   gatewayName: string (required)
  ##              : The gateway name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568299 = newJObject()
  var query_568300 = newJObject()
  add(path_568299, "resourceGroupName", newJString(resourceGroupName))
  add(query_568300, "api-version", newJString(apiVersion))
  add(path_568299, "gatewayName", newJString(gatewayName))
  add(path_568299, "subscriptionId", newJString(subscriptionId))
  result = call_568298.call(path_568299, query_568300, nil, nil, nil)

var gatewayGetProfile* = Call_GatewayGetProfile_568290(name: "gatewayGetProfile",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/gateways/{gatewayName}/profile",
    validator: validate_GatewayGetProfile_568291, base: "",
    url: url_GatewayGetProfile_568292, schemes: {Scheme.Https})
type
  Call_GatewayRegenerateProfile_568301 = ref object of OpenApiRestCall_567657
proc url_GatewayRegenerateProfile_568303(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/gateways/"),
               (kind: VariableSegment, value: "gatewayName"),
               (kind: ConstantSegment, value: "/regenerateprofile")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GatewayRegenerateProfile_568302(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates a gateway's profile
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   gatewayName: JString (required)
  ##              : The gateway name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568304 = path.getOrDefault("resourceGroupName")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "resourceGroupName", valid_568304
  var valid_568305 = path.getOrDefault("gatewayName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "gatewayName", valid_568305
  var valid_568306 = path.getOrDefault("subscriptionId")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "subscriptionId", valid_568306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568307 = query.getOrDefault("api-version")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "api-version", valid_568307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568308: Call_GatewayRegenerateProfile_568301; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates a gateway's profile
  ## 
  let valid = call_568308.validator(path, query, header, formData, body)
  let scheme = call_568308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568308.url(scheme.get, call_568308.host, call_568308.base,
                         call_568308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568308, url, valid)

proc call*(call_568309: Call_GatewayRegenerateProfile_568301;
          resourceGroupName: string; apiVersion: string; gatewayName: string;
          subscriptionId: string): Recallable =
  ## gatewayRegenerateProfile
  ## Regenerates a gateway's profile
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   gatewayName: string (required)
  ##              : The gateway name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568310 = newJObject()
  var query_568311 = newJObject()
  add(path_568310, "resourceGroupName", newJString(resourceGroupName))
  add(query_568311, "api-version", newJString(apiVersion))
  add(path_568310, "gatewayName", newJString(gatewayName))
  add(path_568310, "subscriptionId", newJString(subscriptionId))
  result = call_568309.call(path_568310, query_568311, nil, nil, nil)

var gatewayRegenerateProfile* = Call_GatewayRegenerateProfile_568301(
    name: "gatewayRegenerateProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/gateways/{gatewayName}/regenerateprofile",
    validator: validate_GatewayRegenerateProfile_568302, base: "",
    url: url_GatewayRegenerateProfile_568303, schemes: {Scheme.Https})
type
  Call_GatewayUpgrade_568312 = ref object of OpenApiRestCall_567657
proc url_GatewayUpgrade_568314(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/gateways/"),
               (kind: VariableSegment, value: "gatewayName"),
               (kind: ConstantSegment, value: "/upgradetolatest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GatewayUpgrade_568313(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Upgrades a gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   gatewayName: JString (required)
  ##              : The gateway name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568315 = path.getOrDefault("resourceGroupName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "resourceGroupName", valid_568315
  var valid_568316 = path.getOrDefault("gatewayName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "gatewayName", valid_568316
  var valid_568317 = path.getOrDefault("subscriptionId")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "subscriptionId", valid_568317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568318 = query.getOrDefault("api-version")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "api-version", valid_568318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568319: Call_GatewayUpgrade_568312; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Upgrades a gateway.
  ## 
  let valid = call_568319.validator(path, query, header, formData, body)
  let scheme = call_568319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568319.url(scheme.get, call_568319.host, call_568319.base,
                         call_568319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568319, url, valid)

proc call*(call_568320: Call_GatewayUpgrade_568312; resourceGroupName: string;
          apiVersion: string; gatewayName: string; subscriptionId: string): Recallable =
  ## gatewayUpgrade
  ## Upgrades a gateway.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   gatewayName: string (required)
  ##              : The gateway name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568321 = newJObject()
  var query_568322 = newJObject()
  add(path_568321, "resourceGroupName", newJString(resourceGroupName))
  add(query_568322, "api-version", newJString(apiVersion))
  add(path_568321, "gatewayName", newJString(gatewayName))
  add(path_568321, "subscriptionId", newJString(subscriptionId))
  result = call_568320.call(path_568321, query_568322, nil, nil, nil)

var gatewayUpgrade* = Call_GatewayUpgrade_568312(name: "gatewayUpgrade",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/gateways/{gatewayName}/upgradetolatest",
    validator: validate_GatewayUpgrade_568313, base: "", url: url_GatewayUpgrade_568314,
    schemes: {Scheme.Https})
type
  Call_NodeListForResourceGroup_568323 = ref object of OpenApiRestCall_567657
proc url_NodeListForResourceGroup_568325(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ServerManagement/nodes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodeListForResourceGroup_568324(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists nodes in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568326 = path.getOrDefault("resourceGroupName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "resourceGroupName", valid_568326
  var valid_568327 = path.getOrDefault("subscriptionId")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "subscriptionId", valid_568327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568328 = query.getOrDefault("api-version")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "api-version", valid_568328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568329: Call_NodeListForResourceGroup_568323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists nodes in a resource group.
  ## 
  let valid = call_568329.validator(path, query, header, formData, body)
  let scheme = call_568329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568329.url(scheme.get, call_568329.host, call_568329.base,
                         call_568329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568329, url, valid)

proc call*(call_568330: Call_NodeListForResourceGroup_568323;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## nodeListForResourceGroup
  ## Lists nodes in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568331 = newJObject()
  var query_568332 = newJObject()
  add(path_568331, "resourceGroupName", newJString(resourceGroupName))
  add(query_568332, "api-version", newJString(apiVersion))
  add(path_568331, "subscriptionId", newJString(subscriptionId))
  result = call_568330.call(path_568331, query_568332, nil, nil, nil)

var nodeListForResourceGroup* = Call_NodeListForResourceGroup_568323(
    name: "nodeListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/nodes",
    validator: validate_NodeListForResourceGroup_568324, base: "",
    url: url_NodeListForResourceGroup_568325, schemes: {Scheme.Https})
type
  Call_NodeCreate_568344 = ref object of OpenApiRestCall_567657
proc url_NodeCreate_568346(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/nodes/"),
               (kind: VariableSegment, value: "nodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodeCreate_568345(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a management node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   nodeName: JString (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568347 = path.getOrDefault("resourceGroupName")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "resourceGroupName", valid_568347
  var valid_568348 = path.getOrDefault("nodeName")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "nodeName", valid_568348
  var valid_568349 = path.getOrDefault("subscriptionId")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "subscriptionId", valid_568349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568350 = query.getOrDefault("api-version")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "api-version", valid_568350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   GatewayParameters: JObject (required)
  ##                    : Parameters supplied to the CreateOrUpdate operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568352: Call_NodeCreate_568344; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a management node.
  ## 
  let valid = call_568352.validator(path, query, header, formData, body)
  let scheme = call_568352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568352.url(scheme.get, call_568352.host, call_568352.base,
                         call_568352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568352, url, valid)

proc call*(call_568353: Call_NodeCreate_568344; resourceGroupName: string;
          apiVersion: string; nodeName: string; subscriptionId: string;
          GatewayParameters: JsonNode): Recallable =
  ## nodeCreate
  ## Creates or updates a management node.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   nodeName: string (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   GatewayParameters: JObject (required)
  ##                    : Parameters supplied to the CreateOrUpdate operation.
  var path_568354 = newJObject()
  var query_568355 = newJObject()
  var body_568356 = newJObject()
  add(path_568354, "resourceGroupName", newJString(resourceGroupName))
  add(query_568355, "api-version", newJString(apiVersion))
  add(path_568354, "nodeName", newJString(nodeName))
  add(path_568354, "subscriptionId", newJString(subscriptionId))
  if GatewayParameters != nil:
    body_568356 = GatewayParameters
  result = call_568353.call(path_568354, query_568355, nil, nil, body_568356)

var nodeCreate* = Call_NodeCreate_568344(name: "nodeCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/nodes/{nodeName}",
                                      validator: validate_NodeCreate_568345,
                                      base: "", url: url_NodeCreate_568346,
                                      schemes: {Scheme.Https})
type
  Call_NodeGet_568333 = ref object of OpenApiRestCall_567657
proc url_NodeGet_568335(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/nodes/"),
               (kind: VariableSegment, value: "nodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodeGet_568334(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a management node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   nodeName: JString (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568336 = path.getOrDefault("resourceGroupName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "resourceGroupName", valid_568336
  var valid_568337 = path.getOrDefault("nodeName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "nodeName", valid_568337
  var valid_568338 = path.getOrDefault("subscriptionId")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "subscriptionId", valid_568338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568339 = query.getOrDefault("api-version")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "api-version", valid_568339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568340: Call_NodeGet_568333; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a management node.
  ## 
  let valid = call_568340.validator(path, query, header, formData, body)
  let scheme = call_568340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568340.url(scheme.get, call_568340.host, call_568340.base,
                         call_568340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568340, url, valid)

proc call*(call_568341: Call_NodeGet_568333; resourceGroupName: string;
          apiVersion: string; nodeName: string; subscriptionId: string): Recallable =
  ## nodeGet
  ## Gets a management node.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   nodeName: string (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568342 = newJObject()
  var query_568343 = newJObject()
  add(path_568342, "resourceGroupName", newJString(resourceGroupName))
  add(query_568343, "api-version", newJString(apiVersion))
  add(path_568342, "nodeName", newJString(nodeName))
  add(path_568342, "subscriptionId", newJString(subscriptionId))
  result = call_568341.call(path_568342, query_568343, nil, nil, nil)

var nodeGet* = Call_NodeGet_568333(name: "nodeGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/nodes/{nodeName}",
                                validator: validate_NodeGet_568334, base: "",
                                url: url_NodeGet_568335, schemes: {Scheme.Https})
type
  Call_NodeUpdate_568368 = ref object of OpenApiRestCall_567657
proc url_NodeUpdate_568370(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/nodes/"),
               (kind: VariableSegment, value: "nodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodeUpdate_568369(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a management node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   nodeName: JString (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568371 = path.getOrDefault("resourceGroupName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "resourceGroupName", valid_568371
  var valid_568372 = path.getOrDefault("nodeName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "nodeName", valid_568372
  var valid_568373 = path.getOrDefault("subscriptionId")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "subscriptionId", valid_568373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568374 = query.getOrDefault("api-version")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "api-version", valid_568374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   NodeParameters: JObject (required)
  ##                 : Parameters supplied to the CreateOrUpdate operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568376: Call_NodeUpdate_568368; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a management node.
  ## 
  let valid = call_568376.validator(path, query, header, formData, body)
  let scheme = call_568376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568376.url(scheme.get, call_568376.host, call_568376.base,
                         call_568376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568376, url, valid)

proc call*(call_568377: Call_NodeUpdate_568368; resourceGroupName: string;
          apiVersion: string; nodeName: string; subscriptionId: string;
          NodeParameters: JsonNode): Recallable =
  ## nodeUpdate
  ## Updates a management node.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   nodeName: string (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   NodeParameters: JObject (required)
  ##                 : Parameters supplied to the CreateOrUpdate operation.
  var path_568378 = newJObject()
  var query_568379 = newJObject()
  var body_568380 = newJObject()
  add(path_568378, "resourceGroupName", newJString(resourceGroupName))
  add(query_568379, "api-version", newJString(apiVersion))
  add(path_568378, "nodeName", newJString(nodeName))
  add(path_568378, "subscriptionId", newJString(subscriptionId))
  if NodeParameters != nil:
    body_568380 = NodeParameters
  result = call_568377.call(path_568378, query_568379, nil, nil, body_568380)

var nodeUpdate* = Call_NodeUpdate_568368(name: "nodeUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/nodes/{nodeName}",
                                      validator: validate_NodeUpdate_568369,
                                      base: "", url: url_NodeUpdate_568370,
                                      schemes: {Scheme.Https})
type
  Call_NodeDelete_568357 = ref object of OpenApiRestCall_567657
proc url_NodeDelete_568359(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/nodes/"),
               (kind: VariableSegment, value: "nodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodeDelete_568358(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a management node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   nodeName: JString (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568360 = path.getOrDefault("resourceGroupName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "resourceGroupName", valid_568360
  var valid_568361 = path.getOrDefault("nodeName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "nodeName", valid_568361
  var valid_568362 = path.getOrDefault("subscriptionId")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "subscriptionId", valid_568362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568363 = query.getOrDefault("api-version")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "api-version", valid_568363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568364: Call_NodeDelete_568357; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a management node.
  ## 
  let valid = call_568364.validator(path, query, header, formData, body)
  let scheme = call_568364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568364.url(scheme.get, call_568364.host, call_568364.base,
                         call_568364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568364, url, valid)

proc call*(call_568365: Call_NodeDelete_568357; resourceGroupName: string;
          apiVersion: string; nodeName: string; subscriptionId: string): Recallable =
  ## nodeDelete
  ## Deletes a management node.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   nodeName: string (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568366 = newJObject()
  var query_568367 = newJObject()
  add(path_568366, "resourceGroupName", newJString(resourceGroupName))
  add(query_568367, "api-version", newJString(apiVersion))
  add(path_568366, "nodeName", newJString(nodeName))
  add(path_568366, "subscriptionId", newJString(subscriptionId))
  result = call_568365.call(path_568366, query_568367, nil, nil, nil)

var nodeDelete* = Call_NodeDelete_568357(name: "nodeDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/nodes/{nodeName}",
                                      validator: validate_NodeDelete_568358,
                                      base: "", url: url_NodeDelete_568359,
                                      schemes: {Scheme.Https})
type
  Call_SessionCreate_568393 = ref object of OpenApiRestCall_567657
proc url_SessionCreate_568395(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/sessions/"),
               (kind: VariableSegment, value: "session")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SessionCreate_568394(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a session for a node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: JString (required)
  ##          : The sessionId from the user.
  ##   nodeName: JString (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568396 = path.getOrDefault("resourceGroupName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "resourceGroupName", valid_568396
  var valid_568397 = path.getOrDefault("session")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "session", valid_568397
  var valid_568398 = path.getOrDefault("nodeName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "nodeName", valid_568398
  var valid_568399 = path.getOrDefault("subscriptionId")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "subscriptionId", valid_568399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
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
  ## parameters in `body` object:
  ##   SessionParameters: JObject (required)
  ##                    : Parameters supplied to the CreateOrUpdate operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568402: Call_SessionCreate_568393; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a session for a node.
  ## 
  let valid = call_568402.validator(path, query, header, formData, body)
  let scheme = call_568402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568402.url(scheme.get, call_568402.host, call_568402.base,
                         call_568402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568402, url, valid)

proc call*(call_568403: Call_SessionCreate_568393; resourceGroupName: string;
          session: string; apiVersion: string; nodeName: string;
          SessionParameters: JsonNode; subscriptionId: string): Recallable =
  ## sessionCreate
  ## Creates a session for a node.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: string (required)
  ##          : The sessionId from the user.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   nodeName: string (required)
  ##           : The node name (256 characters maximum).
  ##   SessionParameters: JObject (required)
  ##                    : Parameters supplied to the CreateOrUpdate operation.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568404 = newJObject()
  var query_568405 = newJObject()
  var body_568406 = newJObject()
  add(path_568404, "resourceGroupName", newJString(resourceGroupName))
  add(path_568404, "session", newJString(session))
  add(query_568405, "api-version", newJString(apiVersion))
  add(path_568404, "nodeName", newJString(nodeName))
  if SessionParameters != nil:
    body_568406 = SessionParameters
  add(path_568404, "subscriptionId", newJString(subscriptionId))
  result = call_568403.call(path_568404, query_568405, nil, nil, body_568406)

var sessionCreate* = Call_SessionCreate_568393(name: "sessionCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/nodes/{nodeName}/sessions/{session}",
    validator: validate_SessionCreate_568394, base: "", url: url_SessionCreate_568395,
    schemes: {Scheme.Https})
type
  Call_SessionGet_568381 = ref object of OpenApiRestCall_567657
proc url_SessionGet_568383(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/sessions/"),
               (kind: VariableSegment, value: "session")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SessionGet_568382(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a session for a node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: JString (required)
  ##          : The sessionId from the user.
  ##   nodeName: JString (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568384 = path.getOrDefault("resourceGroupName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "resourceGroupName", valid_568384
  var valid_568385 = path.getOrDefault("session")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "session", valid_568385
  var valid_568386 = path.getOrDefault("nodeName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "nodeName", valid_568386
  var valid_568387 = path.getOrDefault("subscriptionId")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "subscriptionId", valid_568387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568388 = query.getOrDefault("api-version")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "api-version", valid_568388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568389: Call_SessionGet_568381; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a session for a node.
  ## 
  let valid = call_568389.validator(path, query, header, formData, body)
  let scheme = call_568389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568389.url(scheme.get, call_568389.host, call_568389.base,
                         call_568389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568389, url, valid)

proc call*(call_568390: Call_SessionGet_568381; resourceGroupName: string;
          session: string; apiVersion: string; nodeName: string;
          subscriptionId: string): Recallable =
  ## sessionGet
  ## Gets a session for a node.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: string (required)
  ##          : The sessionId from the user.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   nodeName: string (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568391 = newJObject()
  var query_568392 = newJObject()
  add(path_568391, "resourceGroupName", newJString(resourceGroupName))
  add(path_568391, "session", newJString(session))
  add(query_568392, "api-version", newJString(apiVersion))
  add(path_568391, "nodeName", newJString(nodeName))
  add(path_568391, "subscriptionId", newJString(subscriptionId))
  result = call_568390.call(path_568391, query_568392, nil, nil, nil)

var sessionGet* = Call_SessionGet_568381(name: "sessionGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/nodes/{nodeName}/sessions/{session}",
                                      validator: validate_SessionGet_568382,
                                      base: "", url: url_SessionGet_568383,
                                      schemes: {Scheme.Https})
type
  Call_SessionDelete_568407 = ref object of OpenApiRestCall_567657
proc url_SessionDelete_568409(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/sessions/"),
               (kind: VariableSegment, value: "session")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SessionDelete_568408(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a session for a node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: JString (required)
  ##          : The sessionId from the user.
  ##   nodeName: JString (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568410 = path.getOrDefault("resourceGroupName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "resourceGroupName", valid_568410
  var valid_568411 = path.getOrDefault("session")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "session", valid_568411
  var valid_568412 = path.getOrDefault("nodeName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "nodeName", valid_568412
  var valid_568413 = path.getOrDefault("subscriptionId")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "subscriptionId", valid_568413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568414 = query.getOrDefault("api-version")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "api-version", valid_568414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568415: Call_SessionDelete_568407; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a session for a node.
  ## 
  let valid = call_568415.validator(path, query, header, formData, body)
  let scheme = call_568415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568415.url(scheme.get, call_568415.host, call_568415.base,
                         call_568415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568415, url, valid)

proc call*(call_568416: Call_SessionDelete_568407; resourceGroupName: string;
          session: string; apiVersion: string; nodeName: string;
          subscriptionId: string): Recallable =
  ## sessionDelete
  ## Deletes a session for a node.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: string (required)
  ##          : The sessionId from the user.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   nodeName: string (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568417 = newJObject()
  var query_568418 = newJObject()
  add(path_568417, "resourceGroupName", newJString(resourceGroupName))
  add(path_568417, "session", newJString(session))
  add(query_568418, "api-version", newJString(apiVersion))
  add(path_568417, "nodeName", newJString(nodeName))
  add(path_568417, "subscriptionId", newJString(subscriptionId))
  result = call_568416.call(path_568417, query_568418, nil, nil, nil)

var sessionDelete* = Call_SessionDelete_568407(name: "sessionDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/nodes/{nodeName}/sessions/{session}",
    validator: validate_SessionDelete_568408, base: "", url: url_SessionDelete_568409,
    schemes: {Scheme.Https})
type
  Call_PowerShellListSession_568419 = ref object of OpenApiRestCall_567657
proc url_PowerShellListSession_568421(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/sessions/"),
               (kind: VariableSegment, value: "session"), (kind: ConstantSegment,
        value: "/features/powerShellConsole/pssessions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PowerShellListSession_568420(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of the active sessions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: JString (required)
  ##          : The sessionId from the user.
  ##   nodeName: JString (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568422 = path.getOrDefault("resourceGroupName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "resourceGroupName", valid_568422
  var valid_568423 = path.getOrDefault("session")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "session", valid_568423
  var valid_568424 = path.getOrDefault("nodeName")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "nodeName", valid_568424
  var valid_568425 = path.getOrDefault("subscriptionId")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "subscriptionId", valid_568425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_568427: Call_PowerShellListSession_568419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of the active sessions.
  ## 
  let valid = call_568427.validator(path, query, header, formData, body)
  let scheme = call_568427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568427.url(scheme.get, call_568427.host, call_568427.base,
                         call_568427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568427, url, valid)

proc call*(call_568428: Call_PowerShellListSession_568419;
          resourceGroupName: string; session: string; apiVersion: string;
          nodeName: string; subscriptionId: string): Recallable =
  ## powerShellListSession
  ## Gets a list of the active sessions.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: string (required)
  ##          : The sessionId from the user.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   nodeName: string (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568429 = newJObject()
  var query_568430 = newJObject()
  add(path_568429, "resourceGroupName", newJString(resourceGroupName))
  add(path_568429, "session", newJString(session))
  add(query_568430, "api-version", newJString(apiVersion))
  add(path_568429, "nodeName", newJString(nodeName))
  add(path_568429, "subscriptionId", newJString(subscriptionId))
  result = call_568428.call(path_568429, query_568430, nil, nil, nil)

var powerShellListSession* = Call_PowerShellListSession_568419(
    name: "powerShellListSession", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/nodes/{nodeName}/sessions/{session}/features/powerShellConsole/pssessions",
    validator: validate_PowerShellListSession_568420, base: "",
    url: url_PowerShellListSession_568421, schemes: {Scheme.Https})
type
  Call_PowerShellCreateSession_568445 = ref object of OpenApiRestCall_567657
proc url_PowerShellCreateSession_568447(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "session" in path, "`session` is a required path parameter"
  assert "pssession" in path, "`pssession` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/sessions/"),
               (kind: VariableSegment, value: "session"), (kind: ConstantSegment,
        value: "/features/powerShellConsole/pssessions/"),
               (kind: VariableSegment, value: "pssession")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PowerShellCreateSession_568446(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a PowerShell session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: JString (required)
  ##          : The sessionId from the user.
  ##   nodeName: JString (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   pssession: JString (required)
  ##            : The PowerShell sessionId from the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568448 = path.getOrDefault("resourceGroupName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "resourceGroupName", valid_568448
  var valid_568449 = path.getOrDefault("session")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "session", valid_568449
  var valid_568450 = path.getOrDefault("nodeName")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "nodeName", valid_568450
  var valid_568451 = path.getOrDefault("subscriptionId")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "subscriptionId", valid_568451
  var valid_568452 = path.getOrDefault("pssession")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "pssession", valid_568452
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_568454: Call_PowerShellCreateSession_568445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a PowerShell session.
  ## 
  let valid = call_568454.validator(path, query, header, formData, body)
  let scheme = call_568454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568454.url(scheme.get, call_568454.host, call_568454.base,
                         call_568454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568454, url, valid)

proc call*(call_568455: Call_PowerShellCreateSession_568445;
          resourceGroupName: string; session: string; apiVersion: string;
          nodeName: string; subscriptionId: string; pssession: string): Recallable =
  ## powerShellCreateSession
  ## Creates a PowerShell session.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: string (required)
  ##          : The sessionId from the user.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   nodeName: string (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   pssession: string (required)
  ##            : The PowerShell sessionId from the user.
  var path_568456 = newJObject()
  var query_568457 = newJObject()
  add(path_568456, "resourceGroupName", newJString(resourceGroupName))
  add(path_568456, "session", newJString(session))
  add(query_568457, "api-version", newJString(apiVersion))
  add(path_568456, "nodeName", newJString(nodeName))
  add(path_568456, "subscriptionId", newJString(subscriptionId))
  add(path_568456, "pssession", newJString(pssession))
  result = call_568455.call(path_568456, query_568457, nil, nil, nil)

var powerShellCreateSession* = Call_PowerShellCreateSession_568445(
    name: "powerShellCreateSession", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/nodes/{nodeName}/sessions/{session}/features/powerShellConsole/pssessions/{pssession}",
    validator: validate_PowerShellCreateSession_568446, base: "",
    url: url_PowerShellCreateSession_568447, schemes: {Scheme.Https})
type
  Call_PowerShellGetCommandStatus_568431 = ref object of OpenApiRestCall_567657
proc url_PowerShellGetCommandStatus_568433(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "session" in path, "`session` is a required path parameter"
  assert "pssession" in path, "`pssession` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/sessions/"),
               (kind: VariableSegment, value: "session"), (kind: ConstantSegment,
        value: "/features/powerShellConsole/pssessions/"),
               (kind: VariableSegment, value: "pssession")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PowerShellGetCommandStatus_568432(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of a command.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: JString (required)
  ##          : The sessionId from the user.
  ##   nodeName: JString (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   pssession: JString (required)
  ##            : The PowerShell sessionId from the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568434 = path.getOrDefault("resourceGroupName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "resourceGroupName", valid_568434
  var valid_568435 = path.getOrDefault("session")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "session", valid_568435
  var valid_568436 = path.getOrDefault("nodeName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "nodeName", valid_568436
  var valid_568437 = path.getOrDefault("subscriptionId")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "subscriptionId", valid_568437
  var valid_568438 = path.getOrDefault("pssession")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "pssession", valid_568438
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $expand: JString
  ##          : Gets current output from an ongoing call.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568439 = query.getOrDefault("api-version")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "api-version", valid_568439
  var valid_568440 = query.getOrDefault("$expand")
  valid_568440 = validateParameter(valid_568440, JString, required = false,
                                 default = newJString("output"))
  if valid_568440 != nil:
    section.add "$expand", valid_568440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568441: Call_PowerShellGetCommandStatus_568431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of a command.
  ## 
  let valid = call_568441.validator(path, query, header, formData, body)
  let scheme = call_568441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568441.url(scheme.get, call_568441.host, call_568441.base,
                         call_568441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568441, url, valid)

proc call*(call_568442: Call_PowerShellGetCommandStatus_568431;
          resourceGroupName: string; session: string; apiVersion: string;
          nodeName: string; subscriptionId: string; pssession: string;
          Expand: string = "output"): Recallable =
  ## powerShellGetCommandStatus
  ## Gets the status of a command.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: string (required)
  ##          : The sessionId from the user.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   Expand: string
  ##         : Gets current output from an ongoing call.
  ##   nodeName: string (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   pssession: string (required)
  ##            : The PowerShell sessionId from the user.
  var path_568443 = newJObject()
  var query_568444 = newJObject()
  add(path_568443, "resourceGroupName", newJString(resourceGroupName))
  add(path_568443, "session", newJString(session))
  add(query_568444, "api-version", newJString(apiVersion))
  add(query_568444, "$expand", newJString(Expand))
  add(path_568443, "nodeName", newJString(nodeName))
  add(path_568443, "subscriptionId", newJString(subscriptionId))
  add(path_568443, "pssession", newJString(pssession))
  result = call_568442.call(path_568443, query_568444, nil, nil, nil)

var powerShellGetCommandStatus* = Call_PowerShellGetCommandStatus_568431(
    name: "powerShellGetCommandStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/nodes/{nodeName}/sessions/{session}/features/powerShellConsole/pssessions/{pssession}",
    validator: validate_PowerShellGetCommandStatus_568432, base: "",
    url: url_PowerShellGetCommandStatus_568433, schemes: {Scheme.Https})
type
  Call_PowerShellUpdateCommand_568458 = ref object of OpenApiRestCall_567657
proc url_PowerShellUpdateCommand_568460(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "session" in path, "`session` is a required path parameter"
  assert "pssession" in path, "`pssession` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/sessions/"),
               (kind: VariableSegment, value: "session"), (kind: ConstantSegment,
        value: "/features/powerShellConsole/pssessions/"),
               (kind: VariableSegment, value: "pssession")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PowerShellUpdateCommand_568459(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## updates a running PowerShell command with more data.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: JString (required)
  ##          : The sessionId from the user.
  ##   nodeName: JString (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   pssession: JString (required)
  ##            : The PowerShell sessionId from the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568461 = path.getOrDefault("resourceGroupName")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "resourceGroupName", valid_568461
  var valid_568462 = path.getOrDefault("session")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "session", valid_568462
  var valid_568463 = path.getOrDefault("nodeName")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "nodeName", valid_568463
  var valid_568464 = path.getOrDefault("subscriptionId")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "subscriptionId", valid_568464
  var valid_568465 = path.getOrDefault("pssession")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "pssession", valid_568465
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_568467: Call_PowerShellUpdateCommand_568458; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## updates a running PowerShell command with more data.
  ## 
  let valid = call_568467.validator(path, query, header, formData, body)
  let scheme = call_568467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568467.url(scheme.get, call_568467.host, call_568467.base,
                         call_568467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568467, url, valid)

proc call*(call_568468: Call_PowerShellUpdateCommand_568458;
          resourceGroupName: string; session: string; apiVersion: string;
          nodeName: string; subscriptionId: string; pssession: string): Recallable =
  ## powerShellUpdateCommand
  ## updates a running PowerShell command with more data.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: string (required)
  ##          : The sessionId from the user.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   nodeName: string (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   pssession: string (required)
  ##            : The PowerShell sessionId from the user.
  var path_568469 = newJObject()
  var query_568470 = newJObject()
  add(path_568469, "resourceGroupName", newJString(resourceGroupName))
  add(path_568469, "session", newJString(session))
  add(query_568470, "api-version", newJString(apiVersion))
  add(path_568469, "nodeName", newJString(nodeName))
  add(path_568469, "subscriptionId", newJString(subscriptionId))
  add(path_568469, "pssession", newJString(pssession))
  result = call_568468.call(path_568469, query_568470, nil, nil, nil)

var powerShellUpdateCommand* = Call_PowerShellUpdateCommand_568458(
    name: "powerShellUpdateCommand", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/nodes/{nodeName}/sessions/{session}/features/powerShellConsole/pssessions/{pssession}",
    validator: validate_PowerShellUpdateCommand_568459, base: "",
    url: url_PowerShellUpdateCommand_568460, schemes: {Scheme.Https})
type
  Call_PowerShellCancelCommand_568471 = ref object of OpenApiRestCall_567657
proc url_PowerShellCancelCommand_568473(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "session" in path, "`session` is a required path parameter"
  assert "pssession" in path, "`pssession` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/sessions/"),
               (kind: VariableSegment, value: "session"), (kind: ConstantSegment,
        value: "/features/powerShellConsole/pssessions/"),
               (kind: VariableSegment, value: "pssession"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PowerShellCancelCommand_568472(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a PowerShell command.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: JString (required)
  ##          : The sessionId from the user.
  ##   nodeName: JString (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   pssession: JString (required)
  ##            : The PowerShell sessionId from the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568474 = path.getOrDefault("resourceGroupName")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "resourceGroupName", valid_568474
  var valid_568475 = path.getOrDefault("session")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "session", valid_568475
  var valid_568476 = path.getOrDefault("nodeName")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "nodeName", valid_568476
  var valid_568477 = path.getOrDefault("subscriptionId")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "subscriptionId", valid_568477
  var valid_568478 = path.getOrDefault("pssession")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "pssession", valid_568478
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
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

proc call*(call_568480: Call_PowerShellCancelCommand_568471; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a PowerShell command.
  ## 
  let valid = call_568480.validator(path, query, header, formData, body)
  let scheme = call_568480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568480.url(scheme.get, call_568480.host, call_568480.base,
                         call_568480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568480, url, valid)

proc call*(call_568481: Call_PowerShellCancelCommand_568471;
          resourceGroupName: string; session: string; apiVersion: string;
          nodeName: string; subscriptionId: string; pssession: string): Recallable =
  ## powerShellCancelCommand
  ## Cancels a PowerShell command.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: string (required)
  ##          : The sessionId from the user.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   nodeName: string (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   pssession: string (required)
  ##            : The PowerShell sessionId from the user.
  var path_568482 = newJObject()
  var query_568483 = newJObject()
  add(path_568482, "resourceGroupName", newJString(resourceGroupName))
  add(path_568482, "session", newJString(session))
  add(query_568483, "api-version", newJString(apiVersion))
  add(path_568482, "nodeName", newJString(nodeName))
  add(path_568482, "subscriptionId", newJString(subscriptionId))
  add(path_568482, "pssession", newJString(pssession))
  result = call_568481.call(path_568482, query_568483, nil, nil, nil)

var powerShellCancelCommand* = Call_PowerShellCancelCommand_568471(
    name: "powerShellCancelCommand", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/nodes/{nodeName}/sessions/{session}/features/powerShellConsole/pssessions/{pssession}/cancel",
    validator: validate_PowerShellCancelCommand_568472, base: "",
    url: url_PowerShellCancelCommand_568473, schemes: {Scheme.Https})
type
  Call_PowerShellInvokeCommand_568484 = ref object of OpenApiRestCall_567657
proc url_PowerShellInvokeCommand_568486(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "session" in path, "`session` is a required path parameter"
  assert "pssession" in path, "`pssession` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/sessions/"),
               (kind: VariableSegment, value: "session"), (kind: ConstantSegment,
        value: "/features/powerShellConsole/pssessions/"),
               (kind: VariableSegment, value: "pssession"),
               (kind: ConstantSegment, value: "/invokeCommand")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PowerShellInvokeCommand_568485(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a PowerShell script and invokes it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: JString (required)
  ##          : The sessionId from the user.
  ##   nodeName: JString (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   pssession: JString (required)
  ##            : The PowerShell sessionId from the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568487 = path.getOrDefault("resourceGroupName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "resourceGroupName", valid_568487
  var valid_568488 = path.getOrDefault("session")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "session", valid_568488
  var valid_568489 = path.getOrDefault("nodeName")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "nodeName", valid_568489
  var valid_568490 = path.getOrDefault("subscriptionId")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "subscriptionId", valid_568490
  var valid_568491 = path.getOrDefault("pssession")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "pssession", valid_568491
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568492 = query.getOrDefault("api-version")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "api-version", valid_568492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   PowerShellCommandParameters: JObject (required)
  ##                              : Parameters supplied to the Invoke PowerShell Command operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568494: Call_PowerShellInvokeCommand_568484; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a PowerShell script and invokes it.
  ## 
  let valid = call_568494.validator(path, query, header, formData, body)
  let scheme = call_568494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568494.url(scheme.get, call_568494.host, call_568494.base,
                         call_568494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568494, url, valid)

proc call*(call_568495: Call_PowerShellInvokeCommand_568484;
          resourceGroupName: string; session: string; apiVersion: string;
          nodeName: string; subscriptionId: string;
          PowerShellCommandParameters: JsonNode; pssession: string): Recallable =
  ## powerShellInvokeCommand
  ## Creates a PowerShell script and invokes it.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: string (required)
  ##          : The sessionId from the user.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   nodeName: string (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   PowerShellCommandParameters: JObject (required)
  ##                              : Parameters supplied to the Invoke PowerShell Command operation.
  ##   pssession: string (required)
  ##            : The PowerShell sessionId from the user.
  var path_568496 = newJObject()
  var query_568497 = newJObject()
  var body_568498 = newJObject()
  add(path_568496, "resourceGroupName", newJString(resourceGroupName))
  add(path_568496, "session", newJString(session))
  add(query_568497, "api-version", newJString(apiVersion))
  add(path_568496, "nodeName", newJString(nodeName))
  add(path_568496, "subscriptionId", newJString(subscriptionId))
  if PowerShellCommandParameters != nil:
    body_568498 = PowerShellCommandParameters
  add(path_568496, "pssession", newJString(pssession))
  result = call_568495.call(path_568496, query_568497, nil, nil, body_568498)

var powerShellInvokeCommand* = Call_PowerShellInvokeCommand_568484(
    name: "powerShellInvokeCommand", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/nodes/{nodeName}/sessions/{session}/features/powerShellConsole/pssessions/{pssession}/invokeCommand",
    validator: validate_PowerShellInvokeCommand_568485, base: "",
    url: url_PowerShellInvokeCommand_568486, schemes: {Scheme.Https})
type
  Call_PowerShellTabCompletion_568499 = ref object of OpenApiRestCall_567657
proc url_PowerShellTabCompletion_568501(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "session" in path, "`session` is a required path parameter"
  assert "pssession" in path, "`pssession` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServerManagement/nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/sessions/"),
               (kind: VariableSegment, value: "session"), (kind: ConstantSegment,
        value: "/features/powerShellConsole/pssessions/"),
               (kind: VariableSegment, value: "pssession"),
               (kind: ConstantSegment, value: "/tab")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PowerShellTabCompletion_568500(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets tab completion values for a command.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: JString (required)
  ##          : The sessionId from the user.
  ##   nodeName: JString (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   pssession: JString (required)
  ##            : The PowerShell sessionId from the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568502 = path.getOrDefault("resourceGroupName")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "resourceGroupName", valid_568502
  var valid_568503 = path.getOrDefault("session")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "session", valid_568503
  var valid_568504 = path.getOrDefault("nodeName")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "nodeName", valid_568504
  var valid_568505 = path.getOrDefault("subscriptionId")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "subscriptionId", valid_568505
  var valid_568506 = path.getOrDefault("pssession")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "pssession", valid_568506
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568507 = query.getOrDefault("api-version")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "api-version", valid_568507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   PowerShellTabCompletionParamters: JObject (required)
  ##                                   : Parameters supplied to the tab completion call.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568509: Call_PowerShellTabCompletion_568499; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets tab completion values for a command.
  ## 
  let valid = call_568509.validator(path, query, header, formData, body)
  let scheme = call_568509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568509.url(scheme.get, call_568509.host, call_568509.base,
                         call_568509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568509, url, valid)

proc call*(call_568510: Call_PowerShellTabCompletion_568499;
          resourceGroupName: string; session: string; apiVersion: string;
          nodeName: string; subscriptionId: string; pssession: string;
          PowerShellTabCompletionParamters: JsonNode): Recallable =
  ## powerShellTabCompletion
  ## Gets tab completion values for a command.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name uniquely identifies the resource group within the user subscriptionId.
  ##   session: string (required)
  ##          : The sessionId from the user.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   nodeName: string (required)
  ##           : The node name (256 characters maximum).
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   pssession: string (required)
  ##            : The PowerShell sessionId from the user.
  ##   PowerShellTabCompletionParamters: JObject (required)
  ##                                   : Parameters supplied to the tab completion call.
  var path_568511 = newJObject()
  var query_568512 = newJObject()
  var body_568513 = newJObject()
  add(path_568511, "resourceGroupName", newJString(resourceGroupName))
  add(path_568511, "session", newJString(session))
  add(query_568512, "api-version", newJString(apiVersion))
  add(path_568511, "nodeName", newJString(nodeName))
  add(path_568511, "subscriptionId", newJString(subscriptionId))
  add(path_568511, "pssession", newJString(pssession))
  if PowerShellTabCompletionParamters != nil:
    body_568513 = PowerShellTabCompletionParamters
  result = call_568510.call(path_568511, query_568512, nil, nil, body_568513)

var powerShellTabCompletion* = Call_PowerShellTabCompletion_568499(
    name: "powerShellTabCompletion", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServerManagement/nodes/{nodeName}/sessions/{session}/features/powerShellConsole/pssessions/{pssession}/tab",
    validator: validate_PowerShellTabCompletion_568500, base: "",
    url: url_PowerShellTabCompletion_568501, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
