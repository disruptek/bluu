
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
  macServiceName = "network-virtualNetwork"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VirtualNetworksListAll_573879 = ref object of OpenApiRestCall_573657
proc url_VirtualNetworksListAll_573881(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksListAll_573880(path: JsonNode; query: JsonNode;
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

proc call*(call_574069: Call_VirtualNetworksListAll_573879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all virtual networks in a subscription.
  ## 
  let valid = call_574069.validator(path, query, header, formData, body)
  let scheme = call_574069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574069.url(scheme.get, call_574069.host, call_574069.base,
                         call_574069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574069, url, valid)

proc call*(call_574140: Call_VirtualNetworksListAll_573879; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualNetworksListAll
  ## Gets all virtual networks in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574141 = newJObject()
  var query_574143 = newJObject()
  add(query_574143, "api-version", newJString(apiVersion))
  add(path_574141, "subscriptionId", newJString(subscriptionId))
  result = call_574140.call(path_574141, query_574143, nil, nil, nil)

var virtualNetworksListAll* = Call_VirtualNetworksListAll_573879(
    name: "virtualNetworksListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualNetworks",
    validator: validate_VirtualNetworksListAll_573880, base: "",
    url: url_VirtualNetworksListAll_573881, schemes: {Scheme.Https})
type
  Call_VirtualNetworksList_574182 = ref object of OpenApiRestCall_573657
proc url_VirtualNetworksList_574184(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksList_574183(path: JsonNode; query: JsonNode;
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

proc call*(call_574188: Call_VirtualNetworksList_574182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all virtual networks in a resource group.
  ## 
  let valid = call_574188.validator(path, query, header, formData, body)
  let scheme = call_574188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574188.url(scheme.get, call_574188.host, call_574188.base,
                         call_574188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574188, url, valid)

proc call*(call_574189: Call_VirtualNetworksList_574182; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworksList
  ## Gets all virtual networks in a resource group.
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

var virtualNetworksList* = Call_VirtualNetworksList_574182(
    name: "virtualNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks",
    validator: validate_VirtualNetworksList_574183, base: "",
    url: url_VirtualNetworksList_574184, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCreateOrUpdate_574205 = ref object of OpenApiRestCall_573657
proc url_VirtualNetworksCreateOrUpdate_574207(protocol: Scheme; host: string;
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

proc validate_VirtualNetworksCreateOrUpdate_574206(path: JsonNode; query: JsonNode;
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
  var valid_574234 = path.getOrDefault("resourceGroupName")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "resourceGroupName", valid_574234
  var valid_574235 = path.getOrDefault("subscriptionId")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "subscriptionId", valid_574235
  var valid_574236 = path.getOrDefault("virtualNetworkName")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "virtualNetworkName", valid_574236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574237 = query.getOrDefault("api-version")
  valid_574237 = validateParameter(valid_574237, JString, required = true,
                                 default = nil)
  if valid_574237 != nil:
    section.add "api-version", valid_574237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update virtual network operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574239: Call_VirtualNetworksCreateOrUpdate_574205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a virtual network in the specified resource group.
  ## 
  let valid = call_574239.validator(path, query, header, formData, body)
  let scheme = call_574239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574239.url(scheme.get, call_574239.host, call_574239.base,
                         call_574239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574239, url, valid)

proc call*(call_574240: Call_VirtualNetworksCreateOrUpdate_574205;
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
  ##             : Parameters supplied to the create or update virtual network operation.
  var path_574241 = newJObject()
  var query_574242 = newJObject()
  var body_574243 = newJObject()
  add(path_574241, "resourceGroupName", newJString(resourceGroupName))
  add(query_574242, "api-version", newJString(apiVersion))
  add(path_574241, "subscriptionId", newJString(subscriptionId))
  add(path_574241, "virtualNetworkName", newJString(virtualNetworkName))
  if parameters != nil:
    body_574243 = parameters
  result = call_574240.call(path_574241, query_574242, nil, nil, body_574243)

var virtualNetworksCreateOrUpdate* = Call_VirtualNetworksCreateOrUpdate_574205(
    name: "virtualNetworksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksCreateOrUpdate_574206, base: "",
    url: url_VirtualNetworksCreateOrUpdate_574207, schemes: {Scheme.Https})
type
  Call_VirtualNetworksGet_574192 = ref object of OpenApiRestCall_573657
proc url_VirtualNetworksGet_574194(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksGet_574193(path: JsonNode; query: JsonNode;
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
  var valid_574196 = path.getOrDefault("resourceGroupName")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "resourceGroupName", valid_574196
  var valid_574197 = path.getOrDefault("subscriptionId")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "subscriptionId", valid_574197
  var valid_574198 = path.getOrDefault("virtualNetworkName")
  valid_574198 = validateParameter(valid_574198, JString, required = true,
                                 default = nil)
  if valid_574198 != nil:
    section.add "virtualNetworkName", valid_574198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574199 = query.getOrDefault("api-version")
  valid_574199 = validateParameter(valid_574199, JString, required = true,
                                 default = nil)
  if valid_574199 != nil:
    section.add "api-version", valid_574199
  var valid_574200 = query.getOrDefault("$expand")
  valid_574200 = validateParameter(valid_574200, JString, required = false,
                                 default = nil)
  if valid_574200 != nil:
    section.add "$expand", valid_574200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574201: Call_VirtualNetworksGet_574192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified virtual network by resource group.
  ## 
  let valid = call_574201.validator(path, query, header, formData, body)
  let scheme = call_574201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574201.url(scheme.get, call_574201.host, call_574201.base,
                         call_574201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574201, url, valid)

proc call*(call_574202: Call_VirtualNetworksGet_574192; resourceGroupName: string;
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
  var path_574203 = newJObject()
  var query_574204 = newJObject()
  add(path_574203, "resourceGroupName", newJString(resourceGroupName))
  add(query_574204, "api-version", newJString(apiVersion))
  add(query_574204, "$expand", newJString(Expand))
  add(path_574203, "subscriptionId", newJString(subscriptionId))
  add(path_574203, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_574202.call(path_574203, query_574204, nil, nil, nil)

var virtualNetworksGet* = Call_VirtualNetworksGet_574192(
    name: "virtualNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksGet_574193, base: "",
    url: url_VirtualNetworksGet_574194, schemes: {Scheme.Https})
type
  Call_VirtualNetworksUpdateTags_574255 = ref object of OpenApiRestCall_573657
proc url_VirtualNetworksUpdateTags_574257(protocol: Scheme; host: string;
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

proc validate_VirtualNetworksUpdateTags_574256(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a virtual network tags.
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
  var valid_574258 = path.getOrDefault("resourceGroupName")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "resourceGroupName", valid_574258
  var valid_574259 = path.getOrDefault("subscriptionId")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "subscriptionId", valid_574259
  var valid_574260 = path.getOrDefault("virtualNetworkName")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "virtualNetworkName", valid_574260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574261 = query.getOrDefault("api-version")
  valid_574261 = validateParameter(valid_574261, JString, required = true,
                                 default = nil)
  if valid_574261 != nil:
    section.add "api-version", valid_574261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update virtual network tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574263: Call_VirtualNetworksUpdateTags_574255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a virtual network tags.
  ## 
  let valid = call_574263.validator(path, query, header, formData, body)
  let scheme = call_574263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574263.url(scheme.get, call_574263.host, call_574263.base,
                         call_574263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574263, url, valid)

proc call*(call_574264: Call_VirtualNetworksUpdateTags_574255;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string; parameters: JsonNode): Recallable =
  ## virtualNetworksUpdateTags
  ## Updates a virtual network tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update virtual network tags.
  var path_574265 = newJObject()
  var query_574266 = newJObject()
  var body_574267 = newJObject()
  add(path_574265, "resourceGroupName", newJString(resourceGroupName))
  add(query_574266, "api-version", newJString(apiVersion))
  add(path_574265, "subscriptionId", newJString(subscriptionId))
  add(path_574265, "virtualNetworkName", newJString(virtualNetworkName))
  if parameters != nil:
    body_574267 = parameters
  result = call_574264.call(path_574265, query_574266, nil, nil, body_574267)

var virtualNetworksUpdateTags* = Call_VirtualNetworksUpdateTags_574255(
    name: "virtualNetworksUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksUpdateTags_574256, base: "",
    url: url_VirtualNetworksUpdateTags_574257, schemes: {Scheme.Https})
type
  Call_VirtualNetworksDelete_574244 = ref object of OpenApiRestCall_573657
proc url_VirtualNetworksDelete_574246(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksDelete_574245(path: JsonNode; query: JsonNode;
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
  var valid_574247 = path.getOrDefault("resourceGroupName")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "resourceGroupName", valid_574247
  var valid_574248 = path.getOrDefault("subscriptionId")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "subscriptionId", valid_574248
  var valid_574249 = path.getOrDefault("virtualNetworkName")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "virtualNetworkName", valid_574249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574250 = query.getOrDefault("api-version")
  valid_574250 = validateParameter(valid_574250, JString, required = true,
                                 default = nil)
  if valid_574250 != nil:
    section.add "api-version", valid_574250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574251: Call_VirtualNetworksDelete_574244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified virtual network.
  ## 
  let valid = call_574251.validator(path, query, header, formData, body)
  let scheme = call_574251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574251.url(scheme.get, call_574251.host, call_574251.base,
                         call_574251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574251, url, valid)

proc call*(call_574252: Call_VirtualNetworksDelete_574244;
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
  var path_574253 = newJObject()
  var query_574254 = newJObject()
  add(path_574253, "resourceGroupName", newJString(resourceGroupName))
  add(query_574254, "api-version", newJString(apiVersion))
  add(path_574253, "subscriptionId", newJString(subscriptionId))
  add(path_574253, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_574252.call(path_574253, query_574254, nil, nil, nil)

var virtualNetworksDelete* = Call_VirtualNetworksDelete_574244(
    name: "virtualNetworksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksDelete_574245, base: "",
    url: url_VirtualNetworksDelete_574246, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCheckIPAddressAvailability_574268 = ref object of OpenApiRestCall_573657
proc url_VirtualNetworksCheckIPAddressAvailability_574270(protocol: Scheme;
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

proc validate_VirtualNetworksCheckIPAddressAvailability_574269(path: JsonNode;
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
  var valid_574271 = path.getOrDefault("resourceGroupName")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "resourceGroupName", valid_574271
  var valid_574272 = path.getOrDefault("subscriptionId")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "subscriptionId", valid_574272
  var valid_574273 = path.getOrDefault("virtualNetworkName")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "virtualNetworkName", valid_574273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   ipAddress: JString (required)
  ##            : The private IP address to be verified.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574274 = query.getOrDefault("api-version")
  valid_574274 = validateParameter(valid_574274, JString, required = true,
                                 default = nil)
  if valid_574274 != nil:
    section.add "api-version", valid_574274
  var valid_574275 = query.getOrDefault("ipAddress")
  valid_574275 = validateParameter(valid_574275, JString, required = true,
                                 default = nil)
  if valid_574275 != nil:
    section.add "ipAddress", valid_574275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574276: Call_VirtualNetworksCheckIPAddressAvailability_574268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether a private IP address is available for use.
  ## 
  let valid = call_574276.validator(path, query, header, formData, body)
  let scheme = call_574276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574276.url(scheme.get, call_574276.host, call_574276.base,
                         call_574276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574276, url, valid)

proc call*(call_574277: Call_VirtualNetworksCheckIPAddressAvailability_574268;
          resourceGroupName: string; apiVersion: string; ipAddress: string;
          subscriptionId: string; virtualNetworkName: string): Recallable =
  ## virtualNetworksCheckIPAddressAvailability
  ## Checks whether a private IP address is available for use.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   ipAddress: string (required)
  ##            : The private IP address to be verified.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_574278 = newJObject()
  var query_574279 = newJObject()
  add(path_574278, "resourceGroupName", newJString(resourceGroupName))
  add(query_574279, "api-version", newJString(apiVersion))
  add(query_574279, "ipAddress", newJString(ipAddress))
  add(path_574278, "subscriptionId", newJString(subscriptionId))
  add(path_574278, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_574277.call(path_574278, query_574279, nil, nil, nil)

var virtualNetworksCheckIPAddressAvailability* = Call_VirtualNetworksCheckIPAddressAvailability_574268(
    name: "virtualNetworksCheckIPAddressAvailability", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/CheckIPAddressAvailability",
    validator: validate_VirtualNetworksCheckIPAddressAvailability_574269,
    base: "", url: url_VirtualNetworksCheckIPAddressAvailability_574270,
    schemes: {Scheme.Https})
type
  Call_SubnetsList_574280 = ref object of OpenApiRestCall_573657
proc url_SubnetsList_574282(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsList_574281(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574283 = path.getOrDefault("resourceGroupName")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "resourceGroupName", valid_574283
  var valid_574284 = path.getOrDefault("subscriptionId")
  valid_574284 = validateParameter(valid_574284, JString, required = true,
                                 default = nil)
  if valid_574284 != nil:
    section.add "subscriptionId", valid_574284
  var valid_574285 = path.getOrDefault("virtualNetworkName")
  valid_574285 = validateParameter(valid_574285, JString, required = true,
                                 default = nil)
  if valid_574285 != nil:
    section.add "virtualNetworkName", valid_574285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574286 = query.getOrDefault("api-version")
  valid_574286 = validateParameter(valid_574286, JString, required = true,
                                 default = nil)
  if valid_574286 != nil:
    section.add "api-version", valid_574286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574287: Call_SubnetsList_574280; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all subnets in a virtual network.
  ## 
  let valid = call_574287.validator(path, query, header, formData, body)
  let scheme = call_574287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574287.url(scheme.get, call_574287.host, call_574287.base,
                         call_574287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574287, url, valid)

proc call*(call_574288: Call_SubnetsList_574280; resourceGroupName: string;
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
  var path_574289 = newJObject()
  var query_574290 = newJObject()
  add(path_574289, "resourceGroupName", newJString(resourceGroupName))
  add(query_574290, "api-version", newJString(apiVersion))
  add(path_574289, "subscriptionId", newJString(subscriptionId))
  add(path_574289, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_574288.call(path_574289, query_574290, nil, nil, nil)

var subnetsList* = Call_SubnetsList_574280(name: "subnetsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets",
                                        validator: validate_SubnetsList_574281,
                                        base: "", url: url_SubnetsList_574282,
                                        schemes: {Scheme.Https})
type
  Call_SubnetsCreateOrUpdate_574304 = ref object of OpenApiRestCall_573657
proc url_SubnetsCreateOrUpdate_574306(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsCreateOrUpdate_574305(path: JsonNode; query: JsonNode;
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
  var valid_574307 = path.getOrDefault("resourceGroupName")
  valid_574307 = validateParameter(valid_574307, JString, required = true,
                                 default = nil)
  if valid_574307 != nil:
    section.add "resourceGroupName", valid_574307
  var valid_574308 = path.getOrDefault("subnetName")
  valid_574308 = validateParameter(valid_574308, JString, required = true,
                                 default = nil)
  if valid_574308 != nil:
    section.add "subnetName", valid_574308
  var valid_574309 = path.getOrDefault("subscriptionId")
  valid_574309 = validateParameter(valid_574309, JString, required = true,
                                 default = nil)
  if valid_574309 != nil:
    section.add "subscriptionId", valid_574309
  var valid_574310 = path.getOrDefault("virtualNetworkName")
  valid_574310 = validateParameter(valid_574310, JString, required = true,
                                 default = nil)
  if valid_574310 != nil:
    section.add "virtualNetworkName", valid_574310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574311 = query.getOrDefault("api-version")
  valid_574311 = validateParameter(valid_574311, JString, required = true,
                                 default = nil)
  if valid_574311 != nil:
    section.add "api-version", valid_574311
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

proc call*(call_574313: Call_SubnetsCreateOrUpdate_574304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a subnet in the specified virtual network.
  ## 
  let valid = call_574313.validator(path, query, header, formData, body)
  let scheme = call_574313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574313.url(scheme.get, call_574313.host, call_574313.base,
                         call_574313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574313, url, valid)

proc call*(call_574314: Call_SubnetsCreateOrUpdate_574304;
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
  var path_574315 = newJObject()
  var query_574316 = newJObject()
  var body_574317 = newJObject()
  add(path_574315, "resourceGroupName", newJString(resourceGroupName))
  add(path_574315, "subnetName", newJString(subnetName))
  add(query_574316, "api-version", newJString(apiVersion))
  add(path_574315, "subscriptionId", newJString(subscriptionId))
  add(path_574315, "virtualNetworkName", newJString(virtualNetworkName))
  if subnetParameters != nil:
    body_574317 = subnetParameters
  result = call_574314.call(path_574315, query_574316, nil, nil, body_574317)

var subnetsCreateOrUpdate* = Call_SubnetsCreateOrUpdate_574304(
    name: "subnetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsCreateOrUpdate_574305, base: "",
    url: url_SubnetsCreateOrUpdate_574306, schemes: {Scheme.Https})
type
  Call_SubnetsGet_574291 = ref object of OpenApiRestCall_573657
proc url_SubnetsGet_574293(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SubnetsGet_574292(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574294 = path.getOrDefault("resourceGroupName")
  valid_574294 = validateParameter(valid_574294, JString, required = true,
                                 default = nil)
  if valid_574294 != nil:
    section.add "resourceGroupName", valid_574294
  var valid_574295 = path.getOrDefault("subnetName")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "subnetName", valid_574295
  var valid_574296 = path.getOrDefault("subscriptionId")
  valid_574296 = validateParameter(valid_574296, JString, required = true,
                                 default = nil)
  if valid_574296 != nil:
    section.add "subscriptionId", valid_574296
  var valid_574297 = path.getOrDefault("virtualNetworkName")
  valid_574297 = validateParameter(valid_574297, JString, required = true,
                                 default = nil)
  if valid_574297 != nil:
    section.add "virtualNetworkName", valid_574297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574298 = query.getOrDefault("api-version")
  valid_574298 = validateParameter(valid_574298, JString, required = true,
                                 default = nil)
  if valid_574298 != nil:
    section.add "api-version", valid_574298
  var valid_574299 = query.getOrDefault("$expand")
  valid_574299 = validateParameter(valid_574299, JString, required = false,
                                 default = nil)
  if valid_574299 != nil:
    section.add "$expand", valid_574299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574300: Call_SubnetsGet_574291; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified subnet by virtual network and resource group.
  ## 
  let valid = call_574300.validator(path, query, header, formData, body)
  let scheme = call_574300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574300.url(scheme.get, call_574300.host, call_574300.base,
                         call_574300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574300, url, valid)

proc call*(call_574301: Call_SubnetsGet_574291; resourceGroupName: string;
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
  var path_574302 = newJObject()
  var query_574303 = newJObject()
  add(path_574302, "resourceGroupName", newJString(resourceGroupName))
  add(path_574302, "subnetName", newJString(subnetName))
  add(query_574303, "api-version", newJString(apiVersion))
  add(query_574303, "$expand", newJString(Expand))
  add(path_574302, "subscriptionId", newJString(subscriptionId))
  add(path_574302, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_574301.call(path_574302, query_574303, nil, nil, nil)

var subnetsGet* = Call_SubnetsGet_574291(name: "subnetsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
                                      validator: validate_SubnetsGet_574292,
                                      base: "", url: url_SubnetsGet_574293,
                                      schemes: {Scheme.Https})
type
  Call_SubnetsDelete_574318 = ref object of OpenApiRestCall_573657
proc url_SubnetsDelete_574320(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsDelete_574319(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574321 = path.getOrDefault("resourceGroupName")
  valid_574321 = validateParameter(valid_574321, JString, required = true,
                                 default = nil)
  if valid_574321 != nil:
    section.add "resourceGroupName", valid_574321
  var valid_574322 = path.getOrDefault("subnetName")
  valid_574322 = validateParameter(valid_574322, JString, required = true,
                                 default = nil)
  if valid_574322 != nil:
    section.add "subnetName", valid_574322
  var valid_574323 = path.getOrDefault("subscriptionId")
  valid_574323 = validateParameter(valid_574323, JString, required = true,
                                 default = nil)
  if valid_574323 != nil:
    section.add "subscriptionId", valid_574323
  var valid_574324 = path.getOrDefault("virtualNetworkName")
  valid_574324 = validateParameter(valid_574324, JString, required = true,
                                 default = nil)
  if valid_574324 != nil:
    section.add "virtualNetworkName", valid_574324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574325 = query.getOrDefault("api-version")
  valid_574325 = validateParameter(valid_574325, JString, required = true,
                                 default = nil)
  if valid_574325 != nil:
    section.add "api-version", valid_574325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574326: Call_SubnetsDelete_574318; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified subnet.
  ## 
  let valid = call_574326.validator(path, query, header, formData, body)
  let scheme = call_574326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574326.url(scheme.get, call_574326.host, call_574326.base,
                         call_574326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574326, url, valid)

proc call*(call_574327: Call_SubnetsDelete_574318; resourceGroupName: string;
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
  var path_574328 = newJObject()
  var query_574329 = newJObject()
  add(path_574328, "resourceGroupName", newJString(resourceGroupName))
  add(path_574328, "subnetName", newJString(subnetName))
  add(query_574329, "api-version", newJString(apiVersion))
  add(path_574328, "subscriptionId", newJString(subscriptionId))
  add(path_574328, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_574327.call(path_574328, query_574329, nil, nil, nil)

var subnetsDelete* = Call_SubnetsDelete_574318(name: "subnetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsDelete_574319, base: "", url: url_SubnetsDelete_574320,
    schemes: {Scheme.Https})
type
  Call_SubnetsPrepareNetworkPolicies_574330 = ref object of OpenApiRestCall_573657
proc url_SubnetsPrepareNetworkPolicies_574332(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "subnetName"),
               (kind: ConstantSegment, value: "/PrepareNetworkPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubnetsPrepareNetworkPolicies_574331(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Prepares a subnet by applying network intent policies.
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
  var valid_574333 = path.getOrDefault("resourceGroupName")
  valid_574333 = validateParameter(valid_574333, JString, required = true,
                                 default = nil)
  if valid_574333 != nil:
    section.add "resourceGroupName", valid_574333
  var valid_574334 = path.getOrDefault("subnetName")
  valid_574334 = validateParameter(valid_574334, JString, required = true,
                                 default = nil)
  if valid_574334 != nil:
    section.add "subnetName", valid_574334
  var valid_574335 = path.getOrDefault("subscriptionId")
  valid_574335 = validateParameter(valid_574335, JString, required = true,
                                 default = nil)
  if valid_574335 != nil:
    section.add "subscriptionId", valid_574335
  var valid_574336 = path.getOrDefault("virtualNetworkName")
  valid_574336 = validateParameter(valid_574336, JString, required = true,
                                 default = nil)
  if valid_574336 != nil:
    section.add "virtualNetworkName", valid_574336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574337 = query.getOrDefault("api-version")
  valid_574337 = validateParameter(valid_574337, JString, required = true,
                                 default = nil)
  if valid_574337 != nil:
    section.add "api-version", valid_574337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   prepareNetworkPoliciesRequestParameters: JObject (required)
  ##                                          : Parameters supplied to prepare subnet by applying network intent policies.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574339: Call_SubnetsPrepareNetworkPolicies_574330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Prepares a subnet by applying network intent policies.
  ## 
  let valid = call_574339.validator(path, query, header, formData, body)
  let scheme = call_574339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574339.url(scheme.get, call_574339.host, call_574339.base,
                         call_574339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574339, url, valid)

proc call*(call_574340: Call_SubnetsPrepareNetworkPolicies_574330;
          resourceGroupName: string; subnetName: string; apiVersion: string;
          subscriptionId: string; virtualNetworkName: string;
          prepareNetworkPoliciesRequestParameters: JsonNode): Recallable =
  ## subnetsPrepareNetworkPolicies
  ## Prepares a subnet by applying network intent policies.
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
  ##   prepareNetworkPoliciesRequestParameters: JObject (required)
  ##                                          : Parameters supplied to prepare subnet by applying network intent policies.
  var path_574341 = newJObject()
  var query_574342 = newJObject()
  var body_574343 = newJObject()
  add(path_574341, "resourceGroupName", newJString(resourceGroupName))
  add(path_574341, "subnetName", newJString(subnetName))
  add(query_574342, "api-version", newJString(apiVersion))
  add(path_574341, "subscriptionId", newJString(subscriptionId))
  add(path_574341, "virtualNetworkName", newJString(virtualNetworkName))
  if prepareNetworkPoliciesRequestParameters != nil:
    body_574343 = prepareNetworkPoliciesRequestParameters
  result = call_574340.call(path_574341, query_574342, nil, nil, body_574343)

var subnetsPrepareNetworkPolicies* = Call_SubnetsPrepareNetworkPolicies_574330(
    name: "subnetsPrepareNetworkPolicies", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}/PrepareNetworkPolicies",
    validator: validate_SubnetsPrepareNetworkPolicies_574331, base: "",
    url: url_SubnetsPrepareNetworkPolicies_574332, schemes: {Scheme.Https})
type
  Call_ResourceNavigationLinksList_574344 = ref object of OpenApiRestCall_573657
proc url_ResourceNavigationLinksList_574346(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "subnetName"),
               (kind: ConstantSegment, value: "/ResourceNavigationLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceNavigationLinksList_574345(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of resource navigation links for a subnet.
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
  var valid_574347 = path.getOrDefault("resourceGroupName")
  valid_574347 = validateParameter(valid_574347, JString, required = true,
                                 default = nil)
  if valid_574347 != nil:
    section.add "resourceGroupName", valid_574347
  var valid_574348 = path.getOrDefault("subnetName")
  valid_574348 = validateParameter(valid_574348, JString, required = true,
                                 default = nil)
  if valid_574348 != nil:
    section.add "subnetName", valid_574348
  var valid_574349 = path.getOrDefault("subscriptionId")
  valid_574349 = validateParameter(valid_574349, JString, required = true,
                                 default = nil)
  if valid_574349 != nil:
    section.add "subscriptionId", valid_574349
  var valid_574350 = path.getOrDefault("virtualNetworkName")
  valid_574350 = validateParameter(valid_574350, JString, required = true,
                                 default = nil)
  if valid_574350 != nil:
    section.add "virtualNetworkName", valid_574350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574351 = query.getOrDefault("api-version")
  valid_574351 = validateParameter(valid_574351, JString, required = true,
                                 default = nil)
  if valid_574351 != nil:
    section.add "api-version", valid_574351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574352: Call_ResourceNavigationLinksList_574344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of resource navigation links for a subnet.
  ## 
  let valid = call_574352.validator(path, query, header, formData, body)
  let scheme = call_574352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574352.url(scheme.get, call_574352.host, call_574352.base,
                         call_574352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574352, url, valid)

proc call*(call_574353: Call_ResourceNavigationLinksList_574344;
          resourceGroupName: string; subnetName: string; apiVersion: string;
          subscriptionId: string; virtualNetworkName: string): Recallable =
  ## resourceNavigationLinksList
  ## Gets a list of resource navigation links for a subnet.
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
  var path_574354 = newJObject()
  var query_574355 = newJObject()
  add(path_574354, "resourceGroupName", newJString(resourceGroupName))
  add(path_574354, "subnetName", newJString(subnetName))
  add(query_574355, "api-version", newJString(apiVersion))
  add(path_574354, "subscriptionId", newJString(subscriptionId))
  add(path_574354, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_574353.call(path_574354, query_574355, nil, nil, nil)

var resourceNavigationLinksList* = Call_ResourceNavigationLinksList_574344(
    name: "resourceNavigationLinksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}/ResourceNavigationLinks",
    validator: validate_ResourceNavigationLinksList_574345, base: "",
    url: url_ResourceNavigationLinksList_574346, schemes: {Scheme.Https})
type
  Call_ServiceAssociationLinksList_574356 = ref object of OpenApiRestCall_573657
proc url_ServiceAssociationLinksList_574358(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "subnetName"),
               (kind: ConstantSegment, value: "/ServiceAssociationLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceAssociationLinksList_574357(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of service association links for a subnet.
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
  var valid_574359 = path.getOrDefault("resourceGroupName")
  valid_574359 = validateParameter(valid_574359, JString, required = true,
                                 default = nil)
  if valid_574359 != nil:
    section.add "resourceGroupName", valid_574359
  var valid_574360 = path.getOrDefault("subnetName")
  valid_574360 = validateParameter(valid_574360, JString, required = true,
                                 default = nil)
  if valid_574360 != nil:
    section.add "subnetName", valid_574360
  var valid_574361 = path.getOrDefault("subscriptionId")
  valid_574361 = validateParameter(valid_574361, JString, required = true,
                                 default = nil)
  if valid_574361 != nil:
    section.add "subscriptionId", valid_574361
  var valid_574362 = path.getOrDefault("virtualNetworkName")
  valid_574362 = validateParameter(valid_574362, JString, required = true,
                                 default = nil)
  if valid_574362 != nil:
    section.add "virtualNetworkName", valid_574362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574363 = query.getOrDefault("api-version")
  valid_574363 = validateParameter(valid_574363, JString, required = true,
                                 default = nil)
  if valid_574363 != nil:
    section.add "api-version", valid_574363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574364: Call_ServiceAssociationLinksList_574356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of service association links for a subnet.
  ## 
  let valid = call_574364.validator(path, query, header, formData, body)
  let scheme = call_574364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574364.url(scheme.get, call_574364.host, call_574364.base,
                         call_574364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574364, url, valid)

proc call*(call_574365: Call_ServiceAssociationLinksList_574356;
          resourceGroupName: string; subnetName: string; apiVersion: string;
          subscriptionId: string; virtualNetworkName: string): Recallable =
  ## serviceAssociationLinksList
  ## Gets a list of service association links for a subnet.
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
  var path_574366 = newJObject()
  var query_574367 = newJObject()
  add(path_574366, "resourceGroupName", newJString(resourceGroupName))
  add(path_574366, "subnetName", newJString(subnetName))
  add(query_574367, "api-version", newJString(apiVersion))
  add(path_574366, "subscriptionId", newJString(subscriptionId))
  add(path_574366, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_574365.call(path_574366, query_574367, nil, nil, nil)

var serviceAssociationLinksList* = Call_ServiceAssociationLinksList_574356(
    name: "serviceAssociationLinksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}/ServiceAssociationLinks",
    validator: validate_ServiceAssociationLinksList_574357, base: "",
    url: url_ServiceAssociationLinksList_574358, schemes: {Scheme.Https})
type
  Call_SubnetsUnprepareNetworkPolicies_574368 = ref object of OpenApiRestCall_573657
proc url_SubnetsUnprepareNetworkPolicies_574370(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "subnetName"),
               (kind: ConstantSegment, value: "/UnprepareNetworkPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubnetsUnprepareNetworkPolicies_574369(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unprepares a subnet by removing network intent policies.
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
  var valid_574371 = path.getOrDefault("resourceGroupName")
  valid_574371 = validateParameter(valid_574371, JString, required = true,
                                 default = nil)
  if valid_574371 != nil:
    section.add "resourceGroupName", valid_574371
  var valid_574372 = path.getOrDefault("subnetName")
  valid_574372 = validateParameter(valid_574372, JString, required = true,
                                 default = nil)
  if valid_574372 != nil:
    section.add "subnetName", valid_574372
  var valid_574373 = path.getOrDefault("subscriptionId")
  valid_574373 = validateParameter(valid_574373, JString, required = true,
                                 default = nil)
  if valid_574373 != nil:
    section.add "subscriptionId", valid_574373
  var valid_574374 = path.getOrDefault("virtualNetworkName")
  valid_574374 = validateParameter(valid_574374, JString, required = true,
                                 default = nil)
  if valid_574374 != nil:
    section.add "virtualNetworkName", valid_574374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574375 = query.getOrDefault("api-version")
  valid_574375 = validateParameter(valid_574375, JString, required = true,
                                 default = nil)
  if valid_574375 != nil:
    section.add "api-version", valid_574375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   unprepareNetworkPoliciesRequestParameters: JObject (required)
  ##                                            : Parameters supplied to unprepare subnet to remove network intent policies.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574377: Call_SubnetsUnprepareNetworkPolicies_574368;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unprepares a subnet by removing network intent policies.
  ## 
  let valid = call_574377.validator(path, query, header, formData, body)
  let scheme = call_574377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574377.url(scheme.get, call_574377.host, call_574377.base,
                         call_574377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574377, url, valid)

proc call*(call_574378: Call_SubnetsUnprepareNetworkPolicies_574368;
          resourceGroupName: string; subnetName: string; apiVersion: string;
          subscriptionId: string;
          unprepareNetworkPoliciesRequestParameters: JsonNode;
          virtualNetworkName: string): Recallable =
  ## subnetsUnprepareNetworkPolicies
  ## Unprepares a subnet by removing network intent policies.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   subnetName: string (required)
  ##             : The name of the subnet.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   unprepareNetworkPoliciesRequestParameters: JObject (required)
  ##                                            : Parameters supplied to unprepare subnet to remove network intent policies.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_574379 = newJObject()
  var query_574380 = newJObject()
  var body_574381 = newJObject()
  add(path_574379, "resourceGroupName", newJString(resourceGroupName))
  add(path_574379, "subnetName", newJString(subnetName))
  add(query_574380, "api-version", newJString(apiVersion))
  add(path_574379, "subscriptionId", newJString(subscriptionId))
  if unprepareNetworkPoliciesRequestParameters != nil:
    body_574381 = unprepareNetworkPoliciesRequestParameters
  add(path_574379, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_574378.call(path_574379, query_574380, nil, nil, body_574381)

var subnetsUnprepareNetworkPolicies* = Call_SubnetsUnprepareNetworkPolicies_574368(
    name: "subnetsUnprepareNetworkPolicies", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}/UnprepareNetworkPolicies",
    validator: validate_SubnetsUnprepareNetworkPolicies_574369, base: "",
    url: url_SubnetsUnprepareNetworkPolicies_574370, schemes: {Scheme.Https})
type
  Call_VirtualNetworksListUsage_574382 = ref object of OpenApiRestCall_573657
proc url_VirtualNetworksListUsage_574384(protocol: Scheme; host: string;
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

proc validate_VirtualNetworksListUsage_574383(path: JsonNode; query: JsonNode;
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
  var valid_574385 = path.getOrDefault("resourceGroupName")
  valid_574385 = validateParameter(valid_574385, JString, required = true,
                                 default = nil)
  if valid_574385 != nil:
    section.add "resourceGroupName", valid_574385
  var valid_574386 = path.getOrDefault("subscriptionId")
  valid_574386 = validateParameter(valid_574386, JString, required = true,
                                 default = nil)
  if valid_574386 != nil:
    section.add "subscriptionId", valid_574386
  var valid_574387 = path.getOrDefault("virtualNetworkName")
  valid_574387 = validateParameter(valid_574387, JString, required = true,
                                 default = nil)
  if valid_574387 != nil:
    section.add "virtualNetworkName", valid_574387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574388 = query.getOrDefault("api-version")
  valid_574388 = validateParameter(valid_574388, JString, required = true,
                                 default = nil)
  if valid_574388 != nil:
    section.add "api-version", valid_574388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574389: Call_VirtualNetworksListUsage_574382; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists usage stats.
  ## 
  let valid = call_574389.validator(path, query, header, formData, body)
  let scheme = call_574389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574389.url(scheme.get, call_574389.host, call_574389.base,
                         call_574389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574389, url, valid)

proc call*(call_574390: Call_VirtualNetworksListUsage_574382;
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
  var path_574391 = newJObject()
  var query_574392 = newJObject()
  add(path_574391, "resourceGroupName", newJString(resourceGroupName))
  add(query_574392, "api-version", newJString(apiVersion))
  add(path_574391, "subscriptionId", newJString(subscriptionId))
  add(path_574391, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_574390.call(path_574391, query_574392, nil, nil, nil)

var virtualNetworksListUsage* = Call_VirtualNetworksListUsage_574382(
    name: "virtualNetworksListUsage", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/usages",
    validator: validate_VirtualNetworksListUsage_574383, base: "",
    url: url_VirtualNetworksListUsage_574384, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsList_574393 = ref object of OpenApiRestCall_573657
proc url_VirtualNetworkPeeringsList_574395(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkPeeringsList_574394(path: JsonNode; query: JsonNode;
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
  var valid_574396 = path.getOrDefault("resourceGroupName")
  valid_574396 = validateParameter(valid_574396, JString, required = true,
                                 default = nil)
  if valid_574396 != nil:
    section.add "resourceGroupName", valid_574396
  var valid_574397 = path.getOrDefault("subscriptionId")
  valid_574397 = validateParameter(valid_574397, JString, required = true,
                                 default = nil)
  if valid_574397 != nil:
    section.add "subscriptionId", valid_574397
  var valid_574398 = path.getOrDefault("virtualNetworkName")
  valid_574398 = validateParameter(valid_574398, JString, required = true,
                                 default = nil)
  if valid_574398 != nil:
    section.add "virtualNetworkName", valid_574398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574399 = query.getOrDefault("api-version")
  valid_574399 = validateParameter(valid_574399, JString, required = true,
                                 default = nil)
  if valid_574399 != nil:
    section.add "api-version", valid_574399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574400: Call_VirtualNetworkPeeringsList_574393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all virtual network peerings in a virtual network.
  ## 
  let valid = call_574400.validator(path, query, header, formData, body)
  let scheme = call_574400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574400.url(scheme.get, call_574400.host, call_574400.base,
                         call_574400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574400, url, valid)

proc call*(call_574401: Call_VirtualNetworkPeeringsList_574393;
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
  var path_574402 = newJObject()
  var query_574403 = newJObject()
  add(path_574402, "resourceGroupName", newJString(resourceGroupName))
  add(query_574403, "api-version", newJString(apiVersion))
  add(path_574402, "subscriptionId", newJString(subscriptionId))
  add(path_574402, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_574401.call(path_574402, query_574403, nil, nil, nil)

var virtualNetworkPeeringsList* = Call_VirtualNetworkPeeringsList_574393(
    name: "virtualNetworkPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings",
    validator: validate_VirtualNetworkPeeringsList_574394, base: "",
    url: url_VirtualNetworkPeeringsList_574395, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsCreateOrUpdate_574416 = ref object of OpenApiRestCall_573657
proc url_VirtualNetworkPeeringsCreateOrUpdate_574418(protocol: Scheme;
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

proc validate_VirtualNetworkPeeringsCreateOrUpdate_574417(path: JsonNode;
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
  var valid_574419 = path.getOrDefault("resourceGroupName")
  valid_574419 = validateParameter(valid_574419, JString, required = true,
                                 default = nil)
  if valid_574419 != nil:
    section.add "resourceGroupName", valid_574419
  var valid_574420 = path.getOrDefault("subscriptionId")
  valid_574420 = validateParameter(valid_574420, JString, required = true,
                                 default = nil)
  if valid_574420 != nil:
    section.add "subscriptionId", valid_574420
  var valid_574421 = path.getOrDefault("virtualNetworkName")
  valid_574421 = validateParameter(valid_574421, JString, required = true,
                                 default = nil)
  if valid_574421 != nil:
    section.add "virtualNetworkName", valid_574421
  var valid_574422 = path.getOrDefault("virtualNetworkPeeringName")
  valid_574422 = validateParameter(valid_574422, JString, required = true,
                                 default = nil)
  if valid_574422 != nil:
    section.add "virtualNetworkPeeringName", valid_574422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574423 = query.getOrDefault("api-version")
  valid_574423 = validateParameter(valid_574423, JString, required = true,
                                 default = nil)
  if valid_574423 != nil:
    section.add "api-version", valid_574423
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

proc call*(call_574425: Call_VirtualNetworkPeeringsCreateOrUpdate_574416;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a peering in the specified virtual network.
  ## 
  let valid = call_574425.validator(path, query, header, formData, body)
  let scheme = call_574425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574425.url(scheme.get, call_574425.host, call_574425.base,
                         call_574425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574425, url, valid)

proc call*(call_574426: Call_VirtualNetworkPeeringsCreateOrUpdate_574416;
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
  var path_574427 = newJObject()
  var query_574428 = newJObject()
  var body_574429 = newJObject()
  add(path_574427, "resourceGroupName", newJString(resourceGroupName))
  add(query_574428, "api-version", newJString(apiVersion))
  add(path_574427, "subscriptionId", newJString(subscriptionId))
  add(path_574427, "virtualNetworkName", newJString(virtualNetworkName))
  add(path_574427, "virtualNetworkPeeringName",
      newJString(virtualNetworkPeeringName))
  if VirtualNetworkPeeringParameters != nil:
    body_574429 = VirtualNetworkPeeringParameters
  result = call_574426.call(path_574427, query_574428, nil, nil, body_574429)

var virtualNetworkPeeringsCreateOrUpdate* = Call_VirtualNetworkPeeringsCreateOrUpdate_574416(
    name: "virtualNetworkPeeringsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings/{virtualNetworkPeeringName}",
    validator: validate_VirtualNetworkPeeringsCreateOrUpdate_574417, base: "",
    url: url_VirtualNetworkPeeringsCreateOrUpdate_574418, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsGet_574404 = ref object of OpenApiRestCall_573657
proc url_VirtualNetworkPeeringsGet_574406(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkPeeringsGet_574405(path: JsonNode; query: JsonNode;
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
  var valid_574407 = path.getOrDefault("resourceGroupName")
  valid_574407 = validateParameter(valid_574407, JString, required = true,
                                 default = nil)
  if valid_574407 != nil:
    section.add "resourceGroupName", valid_574407
  var valid_574408 = path.getOrDefault("subscriptionId")
  valid_574408 = validateParameter(valid_574408, JString, required = true,
                                 default = nil)
  if valid_574408 != nil:
    section.add "subscriptionId", valid_574408
  var valid_574409 = path.getOrDefault("virtualNetworkName")
  valid_574409 = validateParameter(valid_574409, JString, required = true,
                                 default = nil)
  if valid_574409 != nil:
    section.add "virtualNetworkName", valid_574409
  var valid_574410 = path.getOrDefault("virtualNetworkPeeringName")
  valid_574410 = validateParameter(valid_574410, JString, required = true,
                                 default = nil)
  if valid_574410 != nil:
    section.add "virtualNetworkPeeringName", valid_574410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574411 = query.getOrDefault("api-version")
  valid_574411 = validateParameter(valid_574411, JString, required = true,
                                 default = nil)
  if valid_574411 != nil:
    section.add "api-version", valid_574411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574412: Call_VirtualNetworkPeeringsGet_574404; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified virtual network peering.
  ## 
  let valid = call_574412.validator(path, query, header, formData, body)
  let scheme = call_574412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574412.url(scheme.get, call_574412.host, call_574412.base,
                         call_574412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574412, url, valid)

proc call*(call_574413: Call_VirtualNetworkPeeringsGet_574404;
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
  var path_574414 = newJObject()
  var query_574415 = newJObject()
  add(path_574414, "resourceGroupName", newJString(resourceGroupName))
  add(query_574415, "api-version", newJString(apiVersion))
  add(path_574414, "subscriptionId", newJString(subscriptionId))
  add(path_574414, "virtualNetworkName", newJString(virtualNetworkName))
  add(path_574414, "virtualNetworkPeeringName",
      newJString(virtualNetworkPeeringName))
  result = call_574413.call(path_574414, query_574415, nil, nil, nil)

var virtualNetworkPeeringsGet* = Call_VirtualNetworkPeeringsGet_574404(
    name: "virtualNetworkPeeringsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings/{virtualNetworkPeeringName}",
    validator: validate_VirtualNetworkPeeringsGet_574405, base: "",
    url: url_VirtualNetworkPeeringsGet_574406, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsDelete_574430 = ref object of OpenApiRestCall_573657
proc url_VirtualNetworkPeeringsDelete_574432(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkPeeringsDelete_574431(path: JsonNode; query: JsonNode;
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
  var valid_574433 = path.getOrDefault("resourceGroupName")
  valid_574433 = validateParameter(valid_574433, JString, required = true,
                                 default = nil)
  if valid_574433 != nil:
    section.add "resourceGroupName", valid_574433
  var valid_574434 = path.getOrDefault("subscriptionId")
  valid_574434 = validateParameter(valid_574434, JString, required = true,
                                 default = nil)
  if valid_574434 != nil:
    section.add "subscriptionId", valid_574434
  var valid_574435 = path.getOrDefault("virtualNetworkName")
  valid_574435 = validateParameter(valid_574435, JString, required = true,
                                 default = nil)
  if valid_574435 != nil:
    section.add "virtualNetworkName", valid_574435
  var valid_574436 = path.getOrDefault("virtualNetworkPeeringName")
  valid_574436 = validateParameter(valid_574436, JString, required = true,
                                 default = nil)
  if valid_574436 != nil:
    section.add "virtualNetworkPeeringName", valid_574436
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
  if body != nil:
    result.add "body", body

proc call*(call_574438: Call_VirtualNetworkPeeringsDelete_574430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified virtual network peering.
  ## 
  let valid = call_574438.validator(path, query, header, formData, body)
  let scheme = call_574438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574438.url(scheme.get, call_574438.host, call_574438.base,
                         call_574438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574438, url, valid)

proc call*(call_574439: Call_VirtualNetworkPeeringsDelete_574430;
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
  var path_574440 = newJObject()
  var query_574441 = newJObject()
  add(path_574440, "resourceGroupName", newJString(resourceGroupName))
  add(query_574441, "api-version", newJString(apiVersion))
  add(path_574440, "subscriptionId", newJString(subscriptionId))
  add(path_574440, "virtualNetworkName", newJString(virtualNetworkName))
  add(path_574440, "virtualNetworkPeeringName",
      newJString(virtualNetworkPeeringName))
  result = call_574439.call(path_574440, query_574441, nil, nil, nil)

var virtualNetworkPeeringsDelete* = Call_VirtualNetworkPeeringsDelete_574430(
    name: "virtualNetworkPeeringsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings/{virtualNetworkPeeringName}",
    validator: validate_VirtualNetworkPeeringsDelete_574431, base: "",
    url: url_VirtualNetworkPeeringsDelete_574432, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
