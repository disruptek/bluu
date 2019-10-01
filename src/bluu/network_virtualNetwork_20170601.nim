
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2017-06-01
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
  macServiceName = "network-virtualNetwork"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VirtualNetworksListAll_567879 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworksListAll_567881(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Network/virtualNetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksListAll_567880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all virtual networks in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client API version.
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

proc call*(call_568078: Call_VirtualNetworksListAll_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all virtual networks in a subscription.
  ## 
  let valid = call_568078.validator(path, query, header, formData, body)
  let scheme = call_568078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568078.url(scheme.get, call_568078.host, call_568078.base,
                         call_568078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568078, url, valid)

proc call*(call_568149: Call_VirtualNetworksListAll_567879; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualNetworksListAll
  ## Gets all virtual networks in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568150 = newJObject()
  var query_568152 = newJObject()
  add(query_568152, "api-version", newJString(apiVersion))
  add(path_568150, "subscriptionId", newJString(subscriptionId))
  result = call_568149.call(path_568150, query_568152, nil, nil, nil)

var virtualNetworksListAll* = Call_VirtualNetworksListAll_567879(
    name: "virtualNetworksListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualNetworks",
    validator: validate_VirtualNetworksListAll_567880, base: "",
    url: url_VirtualNetworksListAll_567881, schemes: {Scheme.Https})
type
  Call_VirtualNetworksList_568191 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworksList_568193(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Network/virtualNetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksList_568192(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets all virtual networks in a resource group.
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
  var valid_568194 = path.getOrDefault("resourceGroupName")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "resourceGroupName", valid_568194
  var valid_568195 = path.getOrDefault("subscriptionId")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "subscriptionId", valid_568195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568196 = query.getOrDefault("api-version")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "api-version", valid_568196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568197: Call_VirtualNetworksList_568191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all virtual networks in a resource group.
  ## 
  let valid = call_568197.validator(path, query, header, formData, body)
  let scheme = call_568197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568197.url(scheme.get, call_568197.host, call_568197.base,
                         call_568197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568197, url, valid)

proc call*(call_568198: Call_VirtualNetworksList_568191; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworksList
  ## Gets all virtual networks in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568199 = newJObject()
  var query_568200 = newJObject()
  add(path_568199, "resourceGroupName", newJString(resourceGroupName))
  add(query_568200, "api-version", newJString(apiVersion))
  add(path_568199, "subscriptionId", newJString(subscriptionId))
  result = call_568198.call(path_568199, query_568200, nil, nil, nil)

var virtualNetworksList* = Call_VirtualNetworksList_568191(
    name: "virtualNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks",
    validator: validate_VirtualNetworksList_568192, base: "",
    url: url_VirtualNetworksList_568193, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCreateOrUpdate_568214 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworksCreateOrUpdate_568216(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksCreateOrUpdate_568215(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a virtual network in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568234 = path.getOrDefault("resourceGroupName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "resourceGroupName", valid_568234
  var valid_568235 = path.getOrDefault("subscriptionId")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "subscriptionId", valid_568235
  var valid_568236 = path.getOrDefault("virtualNetworkName")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "virtualNetworkName", valid_568236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568237 = query.getOrDefault("api-version")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "api-version", valid_568237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update virtual network operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568239: Call_VirtualNetworksCreateOrUpdate_568214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a virtual network in the specified resource group.
  ## 
  let valid = call_568239.validator(path, query, header, formData, body)
  let scheme = call_568239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568239.url(scheme.get, call_568239.host, call_568239.base,
                         call_568239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568239, url, valid)

proc call*(call_568240: Call_VirtualNetworksCreateOrUpdate_568214;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string; parameters: JsonNode): Recallable =
  ## virtualNetworksCreateOrUpdate
  ## Creates or updates a virtual network in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update virtual network operation
  var path_568241 = newJObject()
  var query_568242 = newJObject()
  var body_568243 = newJObject()
  add(path_568241, "resourceGroupName", newJString(resourceGroupName))
  add(query_568242, "api-version", newJString(apiVersion))
  add(path_568241, "subscriptionId", newJString(subscriptionId))
  add(path_568241, "virtualNetworkName", newJString(virtualNetworkName))
  if parameters != nil:
    body_568243 = parameters
  result = call_568240.call(path_568241, query_568242, nil, nil, body_568243)

var virtualNetworksCreateOrUpdate* = Call_VirtualNetworksCreateOrUpdate_568214(
    name: "virtualNetworksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksCreateOrUpdate_568215, base: "",
    url: url_VirtualNetworksCreateOrUpdate_568216, schemes: {Scheme.Https})
type
  Call_VirtualNetworksGet_568201 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworksGet_568203(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksGet_568202(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the specified virtual network by resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568205 = path.getOrDefault("resourceGroupName")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "resourceGroupName", valid_568205
  var valid_568206 = path.getOrDefault("subscriptionId")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "subscriptionId", valid_568206
  var valid_568207 = path.getOrDefault("virtualNetworkName")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "virtualNetworkName", valid_568207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568208 = query.getOrDefault("api-version")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "api-version", valid_568208
  var valid_568209 = query.getOrDefault("$expand")
  valid_568209 = validateParameter(valid_568209, JString, required = false,
                                 default = nil)
  if valid_568209 != nil:
    section.add "$expand", valid_568209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568210: Call_VirtualNetworksGet_568201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified virtual network by resource group.
  ## 
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_VirtualNetworksGet_568201; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; virtualNetworkName: string;
          Expand: string = ""): Recallable =
  ## virtualNetworksGet
  ## Gets the specified virtual network by resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Expands referenced resources.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_568212 = newJObject()
  var query_568213 = newJObject()
  add(path_568212, "resourceGroupName", newJString(resourceGroupName))
  add(query_568213, "api-version", newJString(apiVersion))
  add(query_568213, "$expand", newJString(Expand))
  add(path_568212, "subscriptionId", newJString(subscriptionId))
  add(path_568212, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_568211.call(path_568212, query_568213, nil, nil, nil)

var virtualNetworksGet* = Call_VirtualNetworksGet_568201(
    name: "virtualNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksGet_568202, base: "",
    url: url_VirtualNetworksGet_568203, schemes: {Scheme.Https})
type
  Call_VirtualNetworksDelete_568244 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworksDelete_568246(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksDelete_568245(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
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
  var valid_568249 = path.getOrDefault("virtualNetworkName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "virtualNetworkName", valid_568249
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
  if body != nil:
    result.add "body", body

proc call*(call_568251: Call_VirtualNetworksDelete_568244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified virtual network.
  ## 
  let valid = call_568251.validator(path, query, header, formData, body)
  let scheme = call_568251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568251.url(scheme.get, call_568251.host, call_568251.base,
                         call_568251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568251, url, valid)

proc call*(call_568252: Call_VirtualNetworksDelete_568244;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string): Recallable =
  ## virtualNetworksDelete
  ## Deletes the specified virtual network.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_568253 = newJObject()
  var query_568254 = newJObject()
  add(path_568253, "resourceGroupName", newJString(resourceGroupName))
  add(query_568254, "api-version", newJString(apiVersion))
  add(path_568253, "subscriptionId", newJString(subscriptionId))
  add(path_568253, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_568252.call(path_568253, query_568254, nil, nil, nil)

var virtualNetworksDelete* = Call_VirtualNetworksDelete_568244(
    name: "virtualNetworksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksDelete_568245, base: "",
    url: url_VirtualNetworksDelete_568246, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCheckIPAddressAvailability_568255 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworksCheckIPAddressAvailability_568257(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/CheckIPAddressAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksCheckIPAddressAvailability_568256(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether a private IP address is available for use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568258 = path.getOrDefault("resourceGroupName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "resourceGroupName", valid_568258
  var valid_568259 = path.getOrDefault("subscriptionId")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "subscriptionId", valid_568259
  var valid_568260 = path.getOrDefault("virtualNetworkName")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "virtualNetworkName", valid_568260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   ipAddress: JString
  ##            : The private IP address to be verified.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568261 = query.getOrDefault("api-version")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "api-version", valid_568261
  var valid_568262 = query.getOrDefault("ipAddress")
  valid_568262 = validateParameter(valid_568262, JString, required = false,
                                 default = nil)
  if valid_568262 != nil:
    section.add "ipAddress", valid_568262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568263: Call_VirtualNetworksCheckIPAddressAvailability_568255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether a private IP address is available for use.
  ## 
  let valid = call_568263.validator(path, query, header, formData, body)
  let scheme = call_568263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568263.url(scheme.get, call_568263.host, call_568263.base,
                         call_568263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568263, url, valid)

proc call*(call_568264: Call_VirtualNetworksCheckIPAddressAvailability_568255;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string; ipAddress: string = ""): Recallable =
  ## virtualNetworksCheckIPAddressAvailability
  ## Checks whether a private IP address is available for use.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   ipAddress: string
  ##            : The private IP address to be verified.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_568265 = newJObject()
  var query_568266 = newJObject()
  add(path_568265, "resourceGroupName", newJString(resourceGroupName))
  add(query_568266, "api-version", newJString(apiVersion))
  add(query_568266, "ipAddress", newJString(ipAddress))
  add(path_568265, "subscriptionId", newJString(subscriptionId))
  add(path_568265, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_568264.call(path_568265, query_568266, nil, nil, nil)

var virtualNetworksCheckIPAddressAvailability* = Call_VirtualNetworksCheckIPAddressAvailability_568255(
    name: "virtualNetworksCheckIPAddressAvailability", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/CheckIPAddressAvailability",
    validator: validate_VirtualNetworksCheckIPAddressAvailability_568256,
    base: "", url: url_VirtualNetworksCheckIPAddressAvailability_568257,
    schemes: {Scheme.Https})
type
  Call_SubnetsList_568267 = ref object of OpenApiRestCall_567657
proc url_SubnetsList_568269(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/subnets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubnetsList_568268(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all subnets in a virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568270 = path.getOrDefault("resourceGroupName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "resourceGroupName", valid_568270
  var valid_568271 = path.getOrDefault("subscriptionId")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "subscriptionId", valid_568271
  var valid_568272 = path.getOrDefault("virtualNetworkName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "virtualNetworkName", valid_568272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568273 = query.getOrDefault("api-version")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "api-version", valid_568273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568274: Call_SubnetsList_568267; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all subnets in a virtual network.
  ## 
  let valid = call_568274.validator(path, query, header, formData, body)
  let scheme = call_568274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568274.url(scheme.get, call_568274.host, call_568274.base,
                         call_568274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568274, url, valid)

proc call*(call_568275: Call_SubnetsList_568267; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; virtualNetworkName: string): Recallable =
  ## subnetsList
  ## Gets all subnets in a virtual network.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_568276 = newJObject()
  var query_568277 = newJObject()
  add(path_568276, "resourceGroupName", newJString(resourceGroupName))
  add(query_568277, "api-version", newJString(apiVersion))
  add(path_568276, "subscriptionId", newJString(subscriptionId))
  add(path_568276, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_568275.call(path_568276, query_568277, nil, nil, nil)

var subnetsList* = Call_SubnetsList_568267(name: "subnetsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets",
                                        validator: validate_SubnetsList_568268,
                                        base: "", url: url_SubnetsList_568269,
                                        schemes: {Scheme.Https})
type
  Call_SubnetsCreateOrUpdate_568291 = ref object of OpenApiRestCall_567657
proc url_SubnetsCreateOrUpdate_568293(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  assert "subnetName" in path, "`subnetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/subnets/"),
               (kind: VariableSegment, value: "subnetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubnetsCreateOrUpdate_568292(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a subnet in the specified virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subnetName: JString (required)
  ##             : The name of the subnet.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568294 = path.getOrDefault("resourceGroupName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "resourceGroupName", valid_568294
  var valid_568295 = path.getOrDefault("subnetName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "subnetName", valid_568295
  var valid_568296 = path.getOrDefault("subscriptionId")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "subscriptionId", valid_568296
  var valid_568297 = path.getOrDefault("virtualNetworkName")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "virtualNetworkName", valid_568297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568298 = query.getOrDefault("api-version")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "api-version", valid_568298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   subnetParameters: JObject (required)
  ##                   : Parameters supplied to the create or update subnet operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568300: Call_SubnetsCreateOrUpdate_568291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a subnet in the specified virtual network.
  ## 
  let valid = call_568300.validator(path, query, header, formData, body)
  let scheme = call_568300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568300.url(scheme.get, call_568300.host, call_568300.base,
                         call_568300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568300, url, valid)

proc call*(call_568301: Call_SubnetsCreateOrUpdate_568291;
          resourceGroupName: string; subnetName: string; apiVersion: string;
          subscriptionId: string; virtualNetworkName: string;
          subnetParameters: JsonNode): Recallable =
  ## subnetsCreateOrUpdate
  ## Creates or updates a subnet in the specified virtual network.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   subnetName: string (required)
  ##             : The name of the subnet.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  ##   subnetParameters: JObject (required)
  ##                   : Parameters supplied to the create or update subnet operation.
  var path_568302 = newJObject()
  var query_568303 = newJObject()
  var body_568304 = newJObject()
  add(path_568302, "resourceGroupName", newJString(resourceGroupName))
  add(path_568302, "subnetName", newJString(subnetName))
  add(query_568303, "api-version", newJString(apiVersion))
  add(path_568302, "subscriptionId", newJString(subscriptionId))
  add(path_568302, "virtualNetworkName", newJString(virtualNetworkName))
  if subnetParameters != nil:
    body_568304 = subnetParameters
  result = call_568301.call(path_568302, query_568303, nil, nil, body_568304)

var subnetsCreateOrUpdate* = Call_SubnetsCreateOrUpdate_568291(
    name: "subnetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsCreateOrUpdate_568292, base: "",
    url: url_SubnetsCreateOrUpdate_568293, schemes: {Scheme.Https})
type
  Call_SubnetsGet_568278 = ref object of OpenApiRestCall_567657
proc url_SubnetsGet_568280(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  assert "subnetName" in path, "`subnetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/subnets/"),
               (kind: VariableSegment, value: "subnetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubnetsGet_568279(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified subnet by virtual network and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subnetName: JString (required)
  ##             : The name of the subnet.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568281 = path.getOrDefault("resourceGroupName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "resourceGroupName", valid_568281
  var valid_568282 = path.getOrDefault("subnetName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "subnetName", valid_568282
  var valid_568283 = path.getOrDefault("subscriptionId")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "subscriptionId", valid_568283
  var valid_568284 = path.getOrDefault("virtualNetworkName")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "virtualNetworkName", valid_568284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568285 = query.getOrDefault("api-version")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "api-version", valid_568285
  var valid_568286 = query.getOrDefault("$expand")
  valid_568286 = validateParameter(valid_568286, JString, required = false,
                                 default = nil)
  if valid_568286 != nil:
    section.add "$expand", valid_568286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568287: Call_SubnetsGet_568278; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified subnet by virtual network and resource group.
  ## 
  let valid = call_568287.validator(path, query, header, formData, body)
  let scheme = call_568287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568287.url(scheme.get, call_568287.host, call_568287.base,
                         call_568287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568287, url, valid)

proc call*(call_568288: Call_SubnetsGet_568278; resourceGroupName: string;
          subnetName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string; Expand: string = ""): Recallable =
  ## subnetsGet
  ## Gets the specified subnet by virtual network and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   subnetName: string (required)
  ##             : The name of the subnet.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Expands referenced resources.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_568289 = newJObject()
  var query_568290 = newJObject()
  add(path_568289, "resourceGroupName", newJString(resourceGroupName))
  add(path_568289, "subnetName", newJString(subnetName))
  add(query_568290, "api-version", newJString(apiVersion))
  add(query_568290, "$expand", newJString(Expand))
  add(path_568289, "subscriptionId", newJString(subscriptionId))
  add(path_568289, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_568288.call(path_568289, query_568290, nil, nil, nil)

var subnetsGet* = Call_SubnetsGet_568278(name: "subnetsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
                                      validator: validate_SubnetsGet_568279,
                                      base: "", url: url_SubnetsGet_568280,
                                      schemes: {Scheme.Https})
type
  Call_SubnetsDelete_568305 = ref object of OpenApiRestCall_567657
proc url_SubnetsDelete_568307(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  assert "subnetName" in path, "`subnetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/subnets/"),
               (kind: VariableSegment, value: "subnetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubnetsDelete_568306(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified subnet.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subnetName: JString (required)
  ##             : The name of the subnet.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568308 = path.getOrDefault("resourceGroupName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "resourceGroupName", valid_568308
  var valid_568309 = path.getOrDefault("subnetName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "subnetName", valid_568309
  var valid_568310 = path.getOrDefault("subscriptionId")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "subscriptionId", valid_568310
  var valid_568311 = path.getOrDefault("virtualNetworkName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "virtualNetworkName", valid_568311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_568313: Call_SubnetsDelete_568305; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified subnet.
  ## 
  let valid = call_568313.validator(path, query, header, formData, body)
  let scheme = call_568313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568313.url(scheme.get, call_568313.host, call_568313.base,
                         call_568313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568313, url, valid)

proc call*(call_568314: Call_SubnetsDelete_568305; resourceGroupName: string;
          subnetName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string): Recallable =
  ## subnetsDelete
  ## Deletes the specified subnet.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   subnetName: string (required)
  ##             : The name of the subnet.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_568315 = newJObject()
  var query_568316 = newJObject()
  add(path_568315, "resourceGroupName", newJString(resourceGroupName))
  add(path_568315, "subnetName", newJString(subnetName))
  add(query_568316, "api-version", newJString(apiVersion))
  add(path_568315, "subscriptionId", newJString(subscriptionId))
  add(path_568315, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_568314.call(path_568315, query_568316, nil, nil, nil)

var subnetsDelete* = Call_SubnetsDelete_568305(name: "subnetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsDelete_568306, base: "", url: url_SubnetsDelete_568307,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworksListUsage_568317 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworksListUsage_568319(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksListUsage_568318(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists usage stats.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
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
  var valid_568322 = path.getOrDefault("virtualNetworkName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "virtualNetworkName", valid_568322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_568324: Call_VirtualNetworksListUsage_568317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists usage stats.
  ## 
  let valid = call_568324.validator(path, query, header, formData, body)
  let scheme = call_568324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568324.url(scheme.get, call_568324.host, call_568324.base,
                         call_568324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568324, url, valid)

proc call*(call_568325: Call_VirtualNetworksListUsage_568317;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string): Recallable =
  ## virtualNetworksListUsage
  ## Lists usage stats.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_568326 = newJObject()
  var query_568327 = newJObject()
  add(path_568326, "resourceGroupName", newJString(resourceGroupName))
  add(query_568327, "api-version", newJString(apiVersion))
  add(path_568326, "subscriptionId", newJString(subscriptionId))
  add(path_568326, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_568325.call(path_568326, query_568327, nil, nil, nil)

var virtualNetworksListUsage* = Call_VirtualNetworksListUsage_568317(
    name: "virtualNetworksListUsage", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/usages",
    validator: validate_VirtualNetworksListUsage_568318, base: "",
    url: url_VirtualNetworksListUsage_568319, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsList_568328 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkPeeringsList_568330(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/virtualNetworkPeerings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkPeeringsList_568329(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all virtual network peerings in a virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
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
  var valid_568333 = path.getOrDefault("virtualNetworkName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "virtualNetworkName", valid_568333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568334 = query.getOrDefault("api-version")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "api-version", valid_568334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568335: Call_VirtualNetworkPeeringsList_568328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all virtual network peerings in a virtual network.
  ## 
  let valid = call_568335.validator(path, query, header, formData, body)
  let scheme = call_568335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568335.url(scheme.get, call_568335.host, call_568335.base,
                         call_568335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568335, url, valid)

proc call*(call_568336: Call_VirtualNetworkPeeringsList_568328;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string): Recallable =
  ## virtualNetworkPeeringsList
  ## Gets all virtual network peerings in a virtual network.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_568337 = newJObject()
  var query_568338 = newJObject()
  add(path_568337, "resourceGroupName", newJString(resourceGroupName))
  add(query_568338, "api-version", newJString(apiVersion))
  add(path_568337, "subscriptionId", newJString(subscriptionId))
  add(path_568337, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_568336.call(path_568337, query_568338, nil, nil, nil)

var virtualNetworkPeeringsList* = Call_VirtualNetworkPeeringsList_568328(
    name: "virtualNetworkPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings",
    validator: validate_VirtualNetworkPeeringsList_568329, base: "",
    url: url_VirtualNetworkPeeringsList_568330, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsCreateOrUpdate_568351 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkPeeringsCreateOrUpdate_568353(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  assert "virtualNetworkPeeringName" in path,
        "`virtualNetworkPeeringName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/virtualNetworkPeerings/"),
               (kind: VariableSegment, value: "virtualNetworkPeeringName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkPeeringsCreateOrUpdate_568352(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a peering in the specified virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  ##   virtualNetworkPeeringName: JString (required)
  ##                            : The name of the peering.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568354 = path.getOrDefault("resourceGroupName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "resourceGroupName", valid_568354
  var valid_568355 = path.getOrDefault("subscriptionId")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "subscriptionId", valid_568355
  var valid_568356 = path.getOrDefault("virtualNetworkName")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "virtualNetworkName", valid_568356
  var valid_568357 = path.getOrDefault("virtualNetworkPeeringName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "virtualNetworkPeeringName", valid_568357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## parameters in `body` object:
  ##   VirtualNetworkPeeringParameters: JObject (required)
  ##                                  : Parameters supplied to the create or update virtual network peering operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568360: Call_VirtualNetworkPeeringsCreateOrUpdate_568351;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a peering in the specified virtual network.
  ## 
  let valid = call_568360.validator(path, query, header, formData, body)
  let scheme = call_568360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568360.url(scheme.get, call_568360.host, call_568360.base,
                         call_568360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568360, url, valid)

proc call*(call_568361: Call_VirtualNetworkPeeringsCreateOrUpdate_568351;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string; virtualNetworkPeeringName: string;
          VirtualNetworkPeeringParameters: JsonNode): Recallable =
  ## virtualNetworkPeeringsCreateOrUpdate
  ## Creates or updates a peering in the specified virtual network.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  ##   virtualNetworkPeeringName: string (required)
  ##                            : The name of the peering.
  ##   VirtualNetworkPeeringParameters: JObject (required)
  ##                                  : Parameters supplied to the create or update virtual network peering operation.
  var path_568362 = newJObject()
  var query_568363 = newJObject()
  var body_568364 = newJObject()
  add(path_568362, "resourceGroupName", newJString(resourceGroupName))
  add(query_568363, "api-version", newJString(apiVersion))
  add(path_568362, "subscriptionId", newJString(subscriptionId))
  add(path_568362, "virtualNetworkName", newJString(virtualNetworkName))
  add(path_568362, "virtualNetworkPeeringName",
      newJString(virtualNetworkPeeringName))
  if VirtualNetworkPeeringParameters != nil:
    body_568364 = VirtualNetworkPeeringParameters
  result = call_568361.call(path_568362, query_568363, nil, nil, body_568364)

var virtualNetworkPeeringsCreateOrUpdate* = Call_VirtualNetworkPeeringsCreateOrUpdate_568351(
    name: "virtualNetworkPeeringsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings/{virtualNetworkPeeringName}",
    validator: validate_VirtualNetworkPeeringsCreateOrUpdate_568352, base: "",
    url: url_VirtualNetworkPeeringsCreateOrUpdate_568353, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsGet_568339 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkPeeringsGet_568341(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  assert "virtualNetworkPeeringName" in path,
        "`virtualNetworkPeeringName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/virtualNetworkPeerings/"),
               (kind: VariableSegment, value: "virtualNetworkPeeringName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkPeeringsGet_568340(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified virtual network peering.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  ##   virtualNetworkPeeringName: JString (required)
  ##                            : The name of the virtual network peering.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568342 = path.getOrDefault("resourceGroupName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "resourceGroupName", valid_568342
  var valid_568343 = path.getOrDefault("subscriptionId")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "subscriptionId", valid_568343
  var valid_568344 = path.getOrDefault("virtualNetworkName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "virtualNetworkName", valid_568344
  var valid_568345 = path.getOrDefault("virtualNetworkPeeringName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "virtualNetworkPeeringName", valid_568345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568346 = query.getOrDefault("api-version")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "api-version", valid_568346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568347: Call_VirtualNetworkPeeringsGet_568339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified virtual network peering.
  ## 
  let valid = call_568347.validator(path, query, header, formData, body)
  let scheme = call_568347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568347.url(scheme.get, call_568347.host, call_568347.base,
                         call_568347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568347, url, valid)

proc call*(call_568348: Call_VirtualNetworkPeeringsGet_568339;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string; virtualNetworkPeeringName: string): Recallable =
  ## virtualNetworkPeeringsGet
  ## Gets the specified virtual network peering.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  ##   virtualNetworkPeeringName: string (required)
  ##                            : The name of the virtual network peering.
  var path_568349 = newJObject()
  var query_568350 = newJObject()
  add(path_568349, "resourceGroupName", newJString(resourceGroupName))
  add(query_568350, "api-version", newJString(apiVersion))
  add(path_568349, "subscriptionId", newJString(subscriptionId))
  add(path_568349, "virtualNetworkName", newJString(virtualNetworkName))
  add(path_568349, "virtualNetworkPeeringName",
      newJString(virtualNetworkPeeringName))
  result = call_568348.call(path_568349, query_568350, nil, nil, nil)

var virtualNetworkPeeringsGet* = Call_VirtualNetworkPeeringsGet_568339(
    name: "virtualNetworkPeeringsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings/{virtualNetworkPeeringName}",
    validator: validate_VirtualNetworkPeeringsGet_568340, base: "",
    url: url_VirtualNetworkPeeringsGet_568341, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsDelete_568365 = ref object of OpenApiRestCall_567657
proc url_VirtualNetworkPeeringsDelete_568367(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  assert "virtualNetworkPeeringName" in path,
        "`virtualNetworkPeeringName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/virtualNetworkPeerings/"),
               (kind: VariableSegment, value: "virtualNetworkPeeringName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkPeeringsDelete_568366(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified virtual network peering.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  ##   virtualNetworkPeeringName: JString (required)
  ##                            : The name of the virtual network peering.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568368 = path.getOrDefault("resourceGroupName")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "resourceGroupName", valid_568368
  var valid_568369 = path.getOrDefault("subscriptionId")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "subscriptionId", valid_568369
  var valid_568370 = path.getOrDefault("virtualNetworkName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "virtualNetworkName", valid_568370
  var valid_568371 = path.getOrDefault("virtualNetworkPeeringName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "virtualNetworkPeeringName", valid_568371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568372 = query.getOrDefault("api-version")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "api-version", valid_568372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568373: Call_VirtualNetworkPeeringsDelete_568365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified virtual network peering.
  ## 
  let valid = call_568373.validator(path, query, header, formData, body)
  let scheme = call_568373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568373.url(scheme.get, call_568373.host, call_568373.base,
                         call_568373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568373, url, valid)

proc call*(call_568374: Call_VirtualNetworkPeeringsDelete_568365;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string; virtualNetworkPeeringName: string): Recallable =
  ## virtualNetworkPeeringsDelete
  ## Deletes the specified virtual network peering.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  ##   virtualNetworkPeeringName: string (required)
  ##                            : The name of the virtual network peering.
  var path_568375 = newJObject()
  var query_568376 = newJObject()
  add(path_568375, "resourceGroupName", newJString(resourceGroupName))
  add(query_568376, "api-version", newJString(apiVersion))
  add(path_568375, "subscriptionId", newJString(subscriptionId))
  add(path_568375, "virtualNetworkName", newJString(virtualNetworkName))
  add(path_568375, "virtualNetworkPeeringName",
      newJString(virtualNetworkPeeringName))
  result = call_568374.call(path_568375, query_568376, nil, nil, nil)

var virtualNetworkPeeringsDelete* = Call_VirtualNetworkPeeringsDelete_568365(
    name: "virtualNetworkPeeringsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings/{virtualNetworkPeeringName}",
    validator: validate_VirtualNetworkPeeringsDelete_568366, base: "",
    url: url_VirtualNetworkPeeringsDelete_568367, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
