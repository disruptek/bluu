
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2016-09-01
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "network-virtualNetwork"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VirtualNetworksListAll_563761 = ref object of OpenApiRestCall_563539
proc url_VirtualNetworksListAll_563763(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksListAll_563762(path: JsonNode; query: JsonNode;
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
  var valid_563938 = path.getOrDefault("subscriptionId")
  valid_563938 = validateParameter(valid_563938, JString, required = true,
                                 default = nil)
  if valid_563938 != nil:
    section.add "subscriptionId", valid_563938
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563939 = query.getOrDefault("api-version")
  valid_563939 = validateParameter(valid_563939, JString, required = true,
                                 default = nil)
  if valid_563939 != nil:
    section.add "api-version", valid_563939
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563962: Call_VirtualNetworksListAll_563761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all virtual networks in a subscription.
  ## 
  let valid = call_563962.validator(path, query, header, formData, body)
  let scheme = call_563962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563962.url(scheme.get, call_563962.host, call_563962.base,
                         call_563962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563962, url, valid)

proc call*(call_564033: Call_VirtualNetworksListAll_563761; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualNetworksListAll
  ## Gets all virtual networks in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564034 = newJObject()
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  add(path_564034, "subscriptionId", newJString(subscriptionId))
  result = call_564033.call(path_564034, query_564036, nil, nil, nil)

var virtualNetworksListAll* = Call_VirtualNetworksListAll_563761(
    name: "virtualNetworksListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualNetworks",
    validator: validate_VirtualNetworksListAll_563762, base: "",
    url: url_VirtualNetworksListAll_563763, schemes: {Scheme.Https})
type
  Call_VirtualNetworksList_564075 = ref object of OpenApiRestCall_563539
proc url_VirtualNetworksList_564077(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksList_564076(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets all virtual networks in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564078 = path.getOrDefault("subscriptionId")
  valid_564078 = validateParameter(valid_564078, JString, required = true,
                                 default = nil)
  if valid_564078 != nil:
    section.add "subscriptionId", valid_564078
  var valid_564079 = path.getOrDefault("resourceGroupName")
  valid_564079 = validateParameter(valid_564079, JString, required = true,
                                 default = nil)
  if valid_564079 != nil:
    section.add "resourceGroupName", valid_564079
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564080 = query.getOrDefault("api-version")
  valid_564080 = validateParameter(valid_564080, JString, required = true,
                                 default = nil)
  if valid_564080 != nil:
    section.add "api-version", valid_564080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564081: Call_VirtualNetworksList_564075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all virtual networks in a resource group.
  ## 
  let valid = call_564081.validator(path, query, header, formData, body)
  let scheme = call_564081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564081.url(scheme.get, call_564081.host, call_564081.base,
                         call_564081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564081, url, valid)

proc call*(call_564082: Call_VirtualNetworksList_564075; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualNetworksList
  ## Gets all virtual networks in a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564083 = newJObject()
  var query_564084 = newJObject()
  add(query_564084, "api-version", newJString(apiVersion))
  add(path_564083, "subscriptionId", newJString(subscriptionId))
  add(path_564083, "resourceGroupName", newJString(resourceGroupName))
  result = call_564082.call(path_564083, query_564084, nil, nil, nil)

var virtualNetworksList* = Call_VirtualNetworksList_564075(
    name: "virtualNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks",
    validator: validate_VirtualNetworksList_564076, base: "",
    url: url_VirtualNetworksList_564077, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCreateOrUpdate_564098 = ref object of OpenApiRestCall_563539
proc url_VirtualNetworksCreateOrUpdate_564100(protocol: Scheme; host: string;
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

proc validate_VirtualNetworksCreateOrUpdate_564099(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a virtual network in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564118 = path.getOrDefault("subscriptionId")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "subscriptionId", valid_564118
  var valid_564119 = path.getOrDefault("resourceGroupName")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "resourceGroupName", valid_564119
  var valid_564120 = path.getOrDefault("virtualNetworkName")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "virtualNetworkName", valid_564120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564121 = query.getOrDefault("api-version")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "api-version", valid_564121
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

proc call*(call_564123: Call_VirtualNetworksCreateOrUpdate_564098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a virtual network in the specified resource group.
  ## 
  let valid = call_564123.validator(path, query, header, formData, body)
  let scheme = call_564123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564123.url(scheme.get, call_564123.host, call_564123.base,
                         call_564123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564123, url, valid)

proc call*(call_564124: Call_VirtualNetworksCreateOrUpdate_564098;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          virtualNetworkName: string; parameters: JsonNode): Recallable =
  ## virtualNetworksCreateOrUpdate
  ## Creates or updates a virtual network in the specified resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update virtual network operation
  var path_564125 = newJObject()
  var query_564126 = newJObject()
  var body_564127 = newJObject()
  add(query_564126, "api-version", newJString(apiVersion))
  add(path_564125, "subscriptionId", newJString(subscriptionId))
  add(path_564125, "resourceGroupName", newJString(resourceGroupName))
  add(path_564125, "virtualNetworkName", newJString(virtualNetworkName))
  if parameters != nil:
    body_564127 = parameters
  result = call_564124.call(path_564125, query_564126, nil, nil, body_564127)

var virtualNetworksCreateOrUpdate* = Call_VirtualNetworksCreateOrUpdate_564098(
    name: "virtualNetworksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksCreateOrUpdate_564099, base: "",
    url: url_VirtualNetworksCreateOrUpdate_564100, schemes: {Scheme.Https})
type
  Call_VirtualNetworksGet_564085 = ref object of OpenApiRestCall_563539
proc url_VirtualNetworksGet_564087(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksGet_564086(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the specified virtual network by resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564089 = path.getOrDefault("subscriptionId")
  valid_564089 = validateParameter(valid_564089, JString, required = true,
                                 default = nil)
  if valid_564089 != nil:
    section.add "subscriptionId", valid_564089
  var valid_564090 = path.getOrDefault("resourceGroupName")
  valid_564090 = validateParameter(valid_564090, JString, required = true,
                                 default = nil)
  if valid_564090 != nil:
    section.add "resourceGroupName", valid_564090
  var valid_564091 = path.getOrDefault("virtualNetworkName")
  valid_564091 = validateParameter(valid_564091, JString, required = true,
                                 default = nil)
  if valid_564091 != nil:
    section.add "virtualNetworkName", valid_564091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564092 = query.getOrDefault("api-version")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = nil)
  if valid_564092 != nil:
    section.add "api-version", valid_564092
  var valid_564093 = query.getOrDefault("$expand")
  valid_564093 = validateParameter(valid_564093, JString, required = false,
                                 default = nil)
  if valid_564093 != nil:
    section.add "$expand", valid_564093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564094: Call_VirtualNetworksGet_564085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified virtual network by resource group.
  ## 
  let valid = call_564094.validator(path, query, header, formData, body)
  let scheme = call_564094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564094.url(scheme.get, call_564094.host, call_564094.base,
                         call_564094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564094, url, valid)

proc call*(call_564095: Call_VirtualNetworksGet_564085; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          virtualNetworkName: string; Expand: string = ""): Recallable =
  ## virtualNetworksGet
  ## Gets the specified virtual network by resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Expands referenced resources.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_564096 = newJObject()
  var query_564097 = newJObject()
  add(query_564097, "api-version", newJString(apiVersion))
  add(query_564097, "$expand", newJString(Expand))
  add(path_564096, "subscriptionId", newJString(subscriptionId))
  add(path_564096, "resourceGroupName", newJString(resourceGroupName))
  add(path_564096, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_564095.call(path_564096, query_564097, nil, nil, nil)

var virtualNetworksGet* = Call_VirtualNetworksGet_564085(
    name: "virtualNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksGet_564086, base: "",
    url: url_VirtualNetworksGet_564087, schemes: {Scheme.Https})
type
  Call_VirtualNetworksDelete_564128 = ref object of OpenApiRestCall_563539
proc url_VirtualNetworksDelete_564130(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksDelete_564129(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564131 = path.getOrDefault("subscriptionId")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "subscriptionId", valid_564131
  var valid_564132 = path.getOrDefault("resourceGroupName")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "resourceGroupName", valid_564132
  var valid_564133 = path.getOrDefault("virtualNetworkName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "virtualNetworkName", valid_564133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564134 = query.getOrDefault("api-version")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "api-version", valid_564134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564135: Call_VirtualNetworksDelete_564128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified virtual network.
  ## 
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_VirtualNetworksDelete_564128; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          virtualNetworkName: string): Recallable =
  ## virtualNetworksDelete
  ## Deletes the specified virtual network.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_564137 = newJObject()
  var query_564138 = newJObject()
  add(query_564138, "api-version", newJString(apiVersion))
  add(path_564137, "subscriptionId", newJString(subscriptionId))
  add(path_564137, "resourceGroupName", newJString(resourceGroupName))
  add(path_564137, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_564136.call(path_564137, query_564138, nil, nil, nil)

var virtualNetworksDelete* = Call_VirtualNetworksDelete_564128(
    name: "virtualNetworksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksDelete_564129, base: "",
    url: url_VirtualNetworksDelete_564130, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCheckIPAddressAvailability_564139 = ref object of OpenApiRestCall_563539
proc url_VirtualNetworksCheckIPAddressAvailability_564141(protocol: Scheme;
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

proc validate_VirtualNetworksCheckIPAddressAvailability_564140(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether a private IP address is available for use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564142 = path.getOrDefault("subscriptionId")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "subscriptionId", valid_564142
  var valid_564143 = path.getOrDefault("resourceGroupName")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "resourceGroupName", valid_564143
  var valid_564144 = path.getOrDefault("virtualNetworkName")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "virtualNetworkName", valid_564144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   ipAddress: JString
  ##            : The private IP address to be verified.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564145 = query.getOrDefault("api-version")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "api-version", valid_564145
  var valid_564146 = query.getOrDefault("ipAddress")
  valid_564146 = validateParameter(valid_564146, JString, required = false,
                                 default = nil)
  if valid_564146 != nil:
    section.add "ipAddress", valid_564146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564147: Call_VirtualNetworksCheckIPAddressAvailability_564139;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether a private IP address is available for use.
  ## 
  let valid = call_564147.validator(path, query, header, formData, body)
  let scheme = call_564147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564147.url(scheme.get, call_564147.host, call_564147.base,
                         call_564147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564147, url, valid)

proc call*(call_564148: Call_VirtualNetworksCheckIPAddressAvailability_564139;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          virtualNetworkName: string; ipAddress: string = ""): Recallable =
  ## virtualNetworksCheckIPAddressAvailability
  ## Checks whether a private IP address is available for use.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ipAddress: string
  ##            : The private IP address to be verified.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_564149 = newJObject()
  var query_564150 = newJObject()
  add(query_564150, "api-version", newJString(apiVersion))
  add(path_564149, "subscriptionId", newJString(subscriptionId))
  add(query_564150, "ipAddress", newJString(ipAddress))
  add(path_564149, "resourceGroupName", newJString(resourceGroupName))
  add(path_564149, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_564148.call(path_564149, query_564150, nil, nil, nil)

var virtualNetworksCheckIPAddressAvailability* = Call_VirtualNetworksCheckIPAddressAvailability_564139(
    name: "virtualNetworksCheckIPAddressAvailability", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/CheckIPAddressAvailability",
    validator: validate_VirtualNetworksCheckIPAddressAvailability_564140,
    base: "", url: url_VirtualNetworksCheckIPAddressAvailability_564141,
    schemes: {Scheme.Https})
type
  Call_SubnetsList_564151 = ref object of OpenApiRestCall_563539
proc url_SubnetsList_564153(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsList_564152(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all subnets in a virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564154 = path.getOrDefault("subscriptionId")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "subscriptionId", valid_564154
  var valid_564155 = path.getOrDefault("resourceGroupName")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "resourceGroupName", valid_564155
  var valid_564156 = path.getOrDefault("virtualNetworkName")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "virtualNetworkName", valid_564156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564157 = query.getOrDefault("api-version")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "api-version", valid_564157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564158: Call_SubnetsList_564151; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all subnets in a virtual network.
  ## 
  let valid = call_564158.validator(path, query, header, formData, body)
  let scheme = call_564158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564158.url(scheme.get, call_564158.host, call_564158.base,
                         call_564158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564158, url, valid)

proc call*(call_564159: Call_SubnetsList_564151; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          virtualNetworkName: string): Recallable =
  ## subnetsList
  ## Gets all subnets in a virtual network.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_564160 = newJObject()
  var query_564161 = newJObject()
  add(query_564161, "api-version", newJString(apiVersion))
  add(path_564160, "subscriptionId", newJString(subscriptionId))
  add(path_564160, "resourceGroupName", newJString(resourceGroupName))
  add(path_564160, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_564159.call(path_564160, query_564161, nil, nil, nil)

var subnetsList* = Call_SubnetsList_564151(name: "subnetsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets",
                                        validator: validate_SubnetsList_564152,
                                        base: "", url: url_SubnetsList_564153,
                                        schemes: {Scheme.Https})
type
  Call_SubnetsCreateOrUpdate_564175 = ref object of OpenApiRestCall_563539
proc url_SubnetsCreateOrUpdate_564177(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsCreateOrUpdate_564176(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a subnet in the specified virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subnetName: JString (required)
  ##             : The name of the subnet.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564178 = path.getOrDefault("subscriptionId")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "subscriptionId", valid_564178
  var valid_564179 = path.getOrDefault("resourceGroupName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "resourceGroupName", valid_564179
  var valid_564180 = path.getOrDefault("subnetName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "subnetName", valid_564180
  var valid_564181 = path.getOrDefault("virtualNetworkName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "virtualNetworkName", valid_564181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564182 = query.getOrDefault("api-version")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "api-version", valid_564182
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

proc call*(call_564184: Call_SubnetsCreateOrUpdate_564175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a subnet in the specified virtual network.
  ## 
  let valid = call_564184.validator(path, query, header, formData, body)
  let scheme = call_564184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564184.url(scheme.get, call_564184.host, call_564184.base,
                         call_564184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564184, url, valid)

proc call*(call_564185: Call_SubnetsCreateOrUpdate_564175; apiVersion: string;
          subnetParameters: JsonNode; subscriptionId: string;
          resourceGroupName: string; subnetName: string; virtualNetworkName: string): Recallable =
  ## subnetsCreateOrUpdate
  ## Creates or updates a subnet in the specified virtual network.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subnetParameters: JObject (required)
  ##                   : Parameters supplied to the create or update subnet operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   subnetName: string (required)
  ##             : The name of the subnet.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_564186 = newJObject()
  var query_564187 = newJObject()
  var body_564188 = newJObject()
  add(query_564187, "api-version", newJString(apiVersion))
  if subnetParameters != nil:
    body_564188 = subnetParameters
  add(path_564186, "subscriptionId", newJString(subscriptionId))
  add(path_564186, "resourceGroupName", newJString(resourceGroupName))
  add(path_564186, "subnetName", newJString(subnetName))
  add(path_564186, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_564185.call(path_564186, query_564187, nil, nil, body_564188)

var subnetsCreateOrUpdate* = Call_SubnetsCreateOrUpdate_564175(
    name: "subnetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsCreateOrUpdate_564176, base: "",
    url: url_SubnetsCreateOrUpdate_564177, schemes: {Scheme.Https})
type
  Call_SubnetsGet_564162 = ref object of OpenApiRestCall_563539
proc url_SubnetsGet_564164(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SubnetsGet_564163(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified subnet by virtual network and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subnetName: JString (required)
  ##             : The name of the subnet.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564165 = path.getOrDefault("subscriptionId")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "subscriptionId", valid_564165
  var valid_564166 = path.getOrDefault("resourceGroupName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "resourceGroupName", valid_564166
  var valid_564167 = path.getOrDefault("subnetName")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "subnetName", valid_564167
  var valid_564168 = path.getOrDefault("virtualNetworkName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "virtualNetworkName", valid_564168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564169 = query.getOrDefault("api-version")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "api-version", valid_564169
  var valid_564170 = query.getOrDefault("$expand")
  valid_564170 = validateParameter(valid_564170, JString, required = false,
                                 default = nil)
  if valid_564170 != nil:
    section.add "$expand", valid_564170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564171: Call_SubnetsGet_564162; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified subnet by virtual network and resource group.
  ## 
  let valid = call_564171.validator(path, query, header, formData, body)
  let scheme = call_564171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564171.url(scheme.get, call_564171.host, call_564171.base,
                         call_564171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564171, url, valid)

proc call*(call_564172: Call_SubnetsGet_564162; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; subnetName: string;
          virtualNetworkName: string; Expand: string = ""): Recallable =
  ## subnetsGet
  ## Gets the specified subnet by virtual network and resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Expands referenced resources.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   subnetName: string (required)
  ##             : The name of the subnet.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_564173 = newJObject()
  var query_564174 = newJObject()
  add(query_564174, "api-version", newJString(apiVersion))
  add(query_564174, "$expand", newJString(Expand))
  add(path_564173, "subscriptionId", newJString(subscriptionId))
  add(path_564173, "resourceGroupName", newJString(resourceGroupName))
  add(path_564173, "subnetName", newJString(subnetName))
  add(path_564173, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_564172.call(path_564173, query_564174, nil, nil, nil)

var subnetsGet* = Call_SubnetsGet_564162(name: "subnetsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
                                      validator: validate_SubnetsGet_564163,
                                      base: "", url: url_SubnetsGet_564164,
                                      schemes: {Scheme.Https})
type
  Call_SubnetsDelete_564189 = ref object of OpenApiRestCall_563539
proc url_SubnetsDelete_564191(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsDelete_564190(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified subnet.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subnetName: JString (required)
  ##             : The name of the subnet.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564192 = path.getOrDefault("subscriptionId")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "subscriptionId", valid_564192
  var valid_564193 = path.getOrDefault("resourceGroupName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "resourceGroupName", valid_564193
  var valid_564194 = path.getOrDefault("subnetName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "subnetName", valid_564194
  var valid_564195 = path.getOrDefault("virtualNetworkName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "virtualNetworkName", valid_564195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564196 = query.getOrDefault("api-version")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "api-version", valid_564196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564197: Call_SubnetsDelete_564189; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified subnet.
  ## 
  let valid = call_564197.validator(path, query, header, formData, body)
  let scheme = call_564197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564197.url(scheme.get, call_564197.host, call_564197.base,
                         call_564197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564197, url, valid)

proc call*(call_564198: Call_SubnetsDelete_564189; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; subnetName: string;
          virtualNetworkName: string): Recallable =
  ## subnetsDelete
  ## Deletes the specified subnet.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   subnetName: string (required)
  ##             : The name of the subnet.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_564199 = newJObject()
  var query_564200 = newJObject()
  add(query_564200, "api-version", newJString(apiVersion))
  add(path_564199, "subscriptionId", newJString(subscriptionId))
  add(path_564199, "resourceGroupName", newJString(resourceGroupName))
  add(path_564199, "subnetName", newJString(subnetName))
  add(path_564199, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_564198.call(path_564199, query_564200, nil, nil, nil)

var subnetsDelete* = Call_SubnetsDelete_564189(name: "subnetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsDelete_564190, base: "", url: url_SubnetsDelete_564191,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsList_564201 = ref object of OpenApiRestCall_563539
proc url_VirtualNetworkPeeringsList_564203(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkPeeringsList_564202(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all virtual network peerings in a virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564204 = path.getOrDefault("subscriptionId")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "subscriptionId", valid_564204
  var valid_564205 = path.getOrDefault("resourceGroupName")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "resourceGroupName", valid_564205
  var valid_564206 = path.getOrDefault("virtualNetworkName")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "virtualNetworkName", valid_564206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564207 = query.getOrDefault("api-version")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "api-version", valid_564207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564208: Call_VirtualNetworkPeeringsList_564201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all virtual network peerings in a virtual network.
  ## 
  let valid = call_564208.validator(path, query, header, formData, body)
  let scheme = call_564208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564208.url(scheme.get, call_564208.host, call_564208.base,
                         call_564208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564208, url, valid)

proc call*(call_564209: Call_VirtualNetworkPeeringsList_564201; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          virtualNetworkName: string): Recallable =
  ## virtualNetworkPeeringsList
  ## Gets all virtual network peerings in a virtual network.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_564210 = newJObject()
  var query_564211 = newJObject()
  add(query_564211, "api-version", newJString(apiVersion))
  add(path_564210, "subscriptionId", newJString(subscriptionId))
  add(path_564210, "resourceGroupName", newJString(resourceGroupName))
  add(path_564210, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_564209.call(path_564210, query_564211, nil, nil, nil)

var virtualNetworkPeeringsList* = Call_VirtualNetworkPeeringsList_564201(
    name: "virtualNetworkPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings",
    validator: validate_VirtualNetworkPeeringsList_564202, base: "",
    url: url_VirtualNetworkPeeringsList_564203, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsCreateOrUpdate_564224 = ref object of OpenApiRestCall_563539
proc url_VirtualNetworkPeeringsCreateOrUpdate_564226(protocol: Scheme;
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

proc validate_VirtualNetworkPeeringsCreateOrUpdate_564225(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a peering in the specified virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   virtualNetworkPeeringName: JString (required)
  ##                            : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `virtualNetworkPeeringName` field"
  var valid_564227 = path.getOrDefault("virtualNetworkPeeringName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "virtualNetworkPeeringName", valid_564227
  var valid_564228 = path.getOrDefault("subscriptionId")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "subscriptionId", valid_564228
  var valid_564229 = path.getOrDefault("resourceGroupName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "resourceGroupName", valid_564229
  var valid_564230 = path.getOrDefault("virtualNetworkName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "virtualNetworkName", valid_564230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564231 = query.getOrDefault("api-version")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "api-version", valid_564231
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

proc call*(call_564233: Call_VirtualNetworkPeeringsCreateOrUpdate_564224;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a peering in the specified virtual network.
  ## 
  let valid = call_564233.validator(path, query, header, formData, body)
  let scheme = call_564233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564233.url(scheme.get, call_564233.host, call_564233.base,
                         call_564233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564233, url, valid)

proc call*(call_564234: Call_VirtualNetworkPeeringsCreateOrUpdate_564224;
          virtualNetworkPeeringName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          VirtualNetworkPeeringParameters: JsonNode; virtualNetworkName: string): Recallable =
  ## virtualNetworkPeeringsCreateOrUpdate
  ## Creates or updates a peering in the specified virtual network.
  ##   virtualNetworkPeeringName: string (required)
  ##                            : The name of the peering.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   VirtualNetworkPeeringParameters: JObject (required)
  ##                                  : Parameters supplied to the create or update virtual network peering operation.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_564235 = newJObject()
  var query_564236 = newJObject()
  var body_564237 = newJObject()
  add(path_564235, "virtualNetworkPeeringName",
      newJString(virtualNetworkPeeringName))
  add(query_564236, "api-version", newJString(apiVersion))
  add(path_564235, "subscriptionId", newJString(subscriptionId))
  add(path_564235, "resourceGroupName", newJString(resourceGroupName))
  if VirtualNetworkPeeringParameters != nil:
    body_564237 = VirtualNetworkPeeringParameters
  add(path_564235, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_564234.call(path_564235, query_564236, nil, nil, body_564237)

var virtualNetworkPeeringsCreateOrUpdate* = Call_VirtualNetworkPeeringsCreateOrUpdate_564224(
    name: "virtualNetworkPeeringsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings/{virtualNetworkPeeringName}",
    validator: validate_VirtualNetworkPeeringsCreateOrUpdate_564225, base: "",
    url: url_VirtualNetworkPeeringsCreateOrUpdate_564226, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsGet_564212 = ref object of OpenApiRestCall_563539
proc url_VirtualNetworkPeeringsGet_564214(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkPeeringsGet_564213(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified virtual network peering.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   virtualNetworkPeeringName: JString (required)
  ##                            : The name of the virtual network peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `virtualNetworkPeeringName` field"
  var valid_564215 = path.getOrDefault("virtualNetworkPeeringName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "virtualNetworkPeeringName", valid_564215
  var valid_564216 = path.getOrDefault("subscriptionId")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "subscriptionId", valid_564216
  var valid_564217 = path.getOrDefault("resourceGroupName")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "resourceGroupName", valid_564217
  var valid_564218 = path.getOrDefault("virtualNetworkName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "virtualNetworkName", valid_564218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564219 = query.getOrDefault("api-version")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "api-version", valid_564219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564220: Call_VirtualNetworkPeeringsGet_564212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified virtual network peering.
  ## 
  let valid = call_564220.validator(path, query, header, formData, body)
  let scheme = call_564220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564220.url(scheme.get, call_564220.host, call_564220.base,
                         call_564220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564220, url, valid)

proc call*(call_564221: Call_VirtualNetworkPeeringsGet_564212;
          virtualNetworkPeeringName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          virtualNetworkName: string): Recallable =
  ## virtualNetworkPeeringsGet
  ## Gets the specified virtual network peering.
  ##   virtualNetworkPeeringName: string (required)
  ##                            : The name of the virtual network peering.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_564222 = newJObject()
  var query_564223 = newJObject()
  add(path_564222, "virtualNetworkPeeringName",
      newJString(virtualNetworkPeeringName))
  add(query_564223, "api-version", newJString(apiVersion))
  add(path_564222, "subscriptionId", newJString(subscriptionId))
  add(path_564222, "resourceGroupName", newJString(resourceGroupName))
  add(path_564222, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_564221.call(path_564222, query_564223, nil, nil, nil)

var virtualNetworkPeeringsGet* = Call_VirtualNetworkPeeringsGet_564212(
    name: "virtualNetworkPeeringsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings/{virtualNetworkPeeringName}",
    validator: validate_VirtualNetworkPeeringsGet_564213, base: "",
    url: url_VirtualNetworkPeeringsGet_564214, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsDelete_564238 = ref object of OpenApiRestCall_563539
proc url_VirtualNetworkPeeringsDelete_564240(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkPeeringsDelete_564239(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified virtual network peering.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   virtualNetworkPeeringName: JString (required)
  ##                            : The name of the virtual network peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `virtualNetworkPeeringName` field"
  var valid_564241 = path.getOrDefault("virtualNetworkPeeringName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "virtualNetworkPeeringName", valid_564241
  var valid_564242 = path.getOrDefault("subscriptionId")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "subscriptionId", valid_564242
  var valid_564243 = path.getOrDefault("resourceGroupName")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "resourceGroupName", valid_564243
  var valid_564244 = path.getOrDefault("virtualNetworkName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "virtualNetworkName", valid_564244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564245 = query.getOrDefault("api-version")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "api-version", valid_564245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564246: Call_VirtualNetworkPeeringsDelete_564238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified virtual network peering.
  ## 
  let valid = call_564246.validator(path, query, header, formData, body)
  let scheme = call_564246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564246.url(scheme.get, call_564246.host, call_564246.base,
                         call_564246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564246, url, valid)

proc call*(call_564247: Call_VirtualNetworkPeeringsDelete_564238;
          virtualNetworkPeeringName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          virtualNetworkName: string): Recallable =
  ## virtualNetworkPeeringsDelete
  ## Deletes the specified virtual network peering.
  ##   virtualNetworkPeeringName: string (required)
  ##                            : The name of the virtual network peering.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_564248 = newJObject()
  var query_564249 = newJObject()
  add(path_564248, "virtualNetworkPeeringName",
      newJString(virtualNetworkPeeringName))
  add(query_564249, "api-version", newJString(apiVersion))
  add(path_564248, "subscriptionId", newJString(subscriptionId))
  add(path_564248, "resourceGroupName", newJString(resourceGroupName))
  add(path_564248, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_564247.call(path_564248, query_564249, nil, nil, nil)

var virtualNetworkPeeringsDelete* = Call_VirtualNetworkPeeringsDelete_564238(
    name: "virtualNetworkPeeringsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings/{virtualNetworkPeeringName}",
    validator: validate_VirtualNetworkPeeringsDelete_564239, base: "",
    url: url_VirtualNetworkPeeringsDelete_564240, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
