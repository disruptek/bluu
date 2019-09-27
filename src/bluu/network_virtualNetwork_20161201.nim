
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2016-12-01
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_VirtualNetworksListAll_593630 = ref object of OpenApiRestCall_593408
proc url_VirtualNetworksListAll_593632(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksListAll_593631(path: JsonNode; query: JsonNode;
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
  var valid_593805 = path.getOrDefault("subscriptionId")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "subscriptionId", valid_593805
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593806 = query.getOrDefault("api-version")
  valid_593806 = validateParameter(valid_593806, JString, required = true,
                                 default = nil)
  if valid_593806 != nil:
    section.add "api-version", valid_593806
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593829: Call_VirtualNetworksListAll_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all virtual networks in a subscription.
  ## 
  let valid = call_593829.validator(path, query, header, formData, body)
  let scheme = call_593829.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593829.url(scheme.get, call_593829.host, call_593829.base,
                         call_593829.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593829, url, valid)

proc call*(call_593900: Call_VirtualNetworksListAll_593630; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualNetworksListAll
  ## Gets all virtual networks in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593901 = newJObject()
  var query_593903 = newJObject()
  add(query_593903, "api-version", newJString(apiVersion))
  add(path_593901, "subscriptionId", newJString(subscriptionId))
  result = call_593900.call(path_593901, query_593903, nil, nil, nil)

var virtualNetworksListAll* = Call_VirtualNetworksListAll_593630(
    name: "virtualNetworksListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualNetworks",
    validator: validate_VirtualNetworksListAll_593631, base: "",
    url: url_VirtualNetworksListAll_593632, schemes: {Scheme.Https})
type
  Call_VirtualNetworksList_593942 = ref object of OpenApiRestCall_593408
proc url_VirtualNetworksList_593944(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksList_593943(path: JsonNode; query: JsonNode;
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
  var valid_593945 = path.getOrDefault("resourceGroupName")
  valid_593945 = validateParameter(valid_593945, JString, required = true,
                                 default = nil)
  if valid_593945 != nil:
    section.add "resourceGroupName", valid_593945
  var valid_593946 = path.getOrDefault("subscriptionId")
  valid_593946 = validateParameter(valid_593946, JString, required = true,
                                 default = nil)
  if valid_593946 != nil:
    section.add "subscriptionId", valid_593946
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593947 = query.getOrDefault("api-version")
  valid_593947 = validateParameter(valid_593947, JString, required = true,
                                 default = nil)
  if valid_593947 != nil:
    section.add "api-version", valid_593947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593948: Call_VirtualNetworksList_593942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all virtual networks in a resource group.
  ## 
  let valid = call_593948.validator(path, query, header, formData, body)
  let scheme = call_593948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593948.url(scheme.get, call_593948.host, call_593948.base,
                         call_593948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593948, url, valid)

proc call*(call_593949: Call_VirtualNetworksList_593942; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworksList
  ## Gets all virtual networks in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593950 = newJObject()
  var query_593951 = newJObject()
  add(path_593950, "resourceGroupName", newJString(resourceGroupName))
  add(query_593951, "api-version", newJString(apiVersion))
  add(path_593950, "subscriptionId", newJString(subscriptionId))
  result = call_593949.call(path_593950, query_593951, nil, nil, nil)

var virtualNetworksList* = Call_VirtualNetworksList_593942(
    name: "virtualNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks",
    validator: validate_VirtualNetworksList_593943, base: "",
    url: url_VirtualNetworksList_593944, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCreateOrUpdate_593965 = ref object of OpenApiRestCall_593408
proc url_VirtualNetworksCreateOrUpdate_593967(protocol: Scheme; host: string;
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

proc validate_VirtualNetworksCreateOrUpdate_593966(path: JsonNode; query: JsonNode;
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
  var valid_593985 = path.getOrDefault("resourceGroupName")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "resourceGroupName", valid_593985
  var valid_593986 = path.getOrDefault("subscriptionId")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "subscriptionId", valid_593986
  var valid_593987 = path.getOrDefault("virtualNetworkName")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "virtualNetworkName", valid_593987
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593988 = query.getOrDefault("api-version")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "api-version", valid_593988
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

proc call*(call_593990: Call_VirtualNetworksCreateOrUpdate_593965; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a virtual network in the specified resource group.
  ## 
  let valid = call_593990.validator(path, query, header, formData, body)
  let scheme = call_593990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593990.url(scheme.get, call_593990.host, call_593990.base,
                         call_593990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593990, url, valid)

proc call*(call_593991: Call_VirtualNetworksCreateOrUpdate_593965;
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
  var path_593992 = newJObject()
  var query_593993 = newJObject()
  var body_593994 = newJObject()
  add(path_593992, "resourceGroupName", newJString(resourceGroupName))
  add(query_593993, "api-version", newJString(apiVersion))
  add(path_593992, "subscriptionId", newJString(subscriptionId))
  add(path_593992, "virtualNetworkName", newJString(virtualNetworkName))
  if parameters != nil:
    body_593994 = parameters
  result = call_593991.call(path_593992, query_593993, nil, nil, body_593994)

var virtualNetworksCreateOrUpdate* = Call_VirtualNetworksCreateOrUpdate_593965(
    name: "virtualNetworksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksCreateOrUpdate_593966, base: "",
    url: url_VirtualNetworksCreateOrUpdate_593967, schemes: {Scheme.Https})
type
  Call_VirtualNetworksGet_593952 = ref object of OpenApiRestCall_593408
proc url_VirtualNetworksGet_593954(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksGet_593953(path: JsonNode; query: JsonNode;
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
  var valid_593956 = path.getOrDefault("resourceGroupName")
  valid_593956 = validateParameter(valid_593956, JString, required = true,
                                 default = nil)
  if valid_593956 != nil:
    section.add "resourceGroupName", valid_593956
  var valid_593957 = path.getOrDefault("subscriptionId")
  valid_593957 = validateParameter(valid_593957, JString, required = true,
                                 default = nil)
  if valid_593957 != nil:
    section.add "subscriptionId", valid_593957
  var valid_593958 = path.getOrDefault("virtualNetworkName")
  valid_593958 = validateParameter(valid_593958, JString, required = true,
                                 default = nil)
  if valid_593958 != nil:
    section.add "virtualNetworkName", valid_593958
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593959 = query.getOrDefault("api-version")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "api-version", valid_593959
  var valid_593960 = query.getOrDefault("$expand")
  valid_593960 = validateParameter(valid_593960, JString, required = false,
                                 default = nil)
  if valid_593960 != nil:
    section.add "$expand", valid_593960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593961: Call_VirtualNetworksGet_593952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified virtual network by resource group.
  ## 
  let valid = call_593961.validator(path, query, header, formData, body)
  let scheme = call_593961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593961.url(scheme.get, call_593961.host, call_593961.base,
                         call_593961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593961, url, valid)

proc call*(call_593962: Call_VirtualNetworksGet_593952; resourceGroupName: string;
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
  var path_593963 = newJObject()
  var query_593964 = newJObject()
  add(path_593963, "resourceGroupName", newJString(resourceGroupName))
  add(query_593964, "api-version", newJString(apiVersion))
  add(query_593964, "$expand", newJString(Expand))
  add(path_593963, "subscriptionId", newJString(subscriptionId))
  add(path_593963, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_593962.call(path_593963, query_593964, nil, nil, nil)

var virtualNetworksGet* = Call_VirtualNetworksGet_593952(
    name: "virtualNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksGet_593953, base: "",
    url: url_VirtualNetworksGet_593954, schemes: {Scheme.Https})
type
  Call_VirtualNetworksDelete_593995 = ref object of OpenApiRestCall_593408
proc url_VirtualNetworksDelete_593997(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksDelete_593996(path: JsonNode; query: JsonNode;
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
  var valid_593998 = path.getOrDefault("resourceGroupName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "resourceGroupName", valid_593998
  var valid_593999 = path.getOrDefault("subscriptionId")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "subscriptionId", valid_593999
  var valid_594000 = path.getOrDefault("virtualNetworkName")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "virtualNetworkName", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594002: Call_VirtualNetworksDelete_593995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified virtual network.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_VirtualNetworksDelete_593995;
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
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  add(path_594004, "resourceGroupName", newJString(resourceGroupName))
  add(query_594005, "api-version", newJString(apiVersion))
  add(path_594004, "subscriptionId", newJString(subscriptionId))
  add(path_594004, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_594003.call(path_594004, query_594005, nil, nil, nil)

var virtualNetworksDelete* = Call_VirtualNetworksDelete_593995(
    name: "virtualNetworksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksDelete_593996, base: "",
    url: url_VirtualNetworksDelete_593997, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCheckIPAddressAvailability_594006 = ref object of OpenApiRestCall_593408
proc url_VirtualNetworksCheckIPAddressAvailability_594008(protocol: Scheme;
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

proc validate_VirtualNetworksCheckIPAddressAvailability_594007(path: JsonNode;
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
  var valid_594009 = path.getOrDefault("resourceGroupName")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "resourceGroupName", valid_594009
  var valid_594010 = path.getOrDefault("subscriptionId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "subscriptionId", valid_594010
  var valid_594011 = path.getOrDefault("virtualNetworkName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "virtualNetworkName", valid_594011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   ipAddress: JString
  ##            : The private IP address to be verified.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594012 = query.getOrDefault("api-version")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "api-version", valid_594012
  var valid_594013 = query.getOrDefault("ipAddress")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "ipAddress", valid_594013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594014: Call_VirtualNetworksCheckIPAddressAvailability_594006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether a private IP address is available for use.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_VirtualNetworksCheckIPAddressAvailability_594006;
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
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  add(path_594016, "resourceGroupName", newJString(resourceGroupName))
  add(query_594017, "api-version", newJString(apiVersion))
  add(query_594017, "ipAddress", newJString(ipAddress))
  add(path_594016, "subscriptionId", newJString(subscriptionId))
  add(path_594016, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_594015.call(path_594016, query_594017, nil, nil, nil)

var virtualNetworksCheckIPAddressAvailability* = Call_VirtualNetworksCheckIPAddressAvailability_594006(
    name: "virtualNetworksCheckIPAddressAvailability", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/CheckIPAddressAvailability",
    validator: validate_VirtualNetworksCheckIPAddressAvailability_594007,
    base: "", url: url_VirtualNetworksCheckIPAddressAvailability_594008,
    schemes: {Scheme.Https})
type
  Call_SubnetsList_594018 = ref object of OpenApiRestCall_593408
proc url_SubnetsList_594020(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsList_594019(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594021 = path.getOrDefault("resourceGroupName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "resourceGroupName", valid_594021
  var valid_594022 = path.getOrDefault("subscriptionId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "subscriptionId", valid_594022
  var valid_594023 = path.getOrDefault("virtualNetworkName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "virtualNetworkName", valid_594023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594024 = query.getOrDefault("api-version")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "api-version", valid_594024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594025: Call_SubnetsList_594018; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all subnets in a virtual network.
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_SubnetsList_594018; resourceGroupName: string;
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
  var path_594027 = newJObject()
  var query_594028 = newJObject()
  add(path_594027, "resourceGroupName", newJString(resourceGroupName))
  add(query_594028, "api-version", newJString(apiVersion))
  add(path_594027, "subscriptionId", newJString(subscriptionId))
  add(path_594027, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_594026.call(path_594027, query_594028, nil, nil, nil)

var subnetsList* = Call_SubnetsList_594018(name: "subnetsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets",
                                        validator: validate_SubnetsList_594019,
                                        base: "", url: url_SubnetsList_594020,
                                        schemes: {Scheme.Https})
type
  Call_SubnetsCreateOrUpdate_594042 = ref object of OpenApiRestCall_593408
proc url_SubnetsCreateOrUpdate_594044(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsCreateOrUpdate_594043(path: JsonNode; query: JsonNode;
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
  var valid_594045 = path.getOrDefault("resourceGroupName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "resourceGroupName", valid_594045
  var valid_594046 = path.getOrDefault("subnetName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "subnetName", valid_594046
  var valid_594047 = path.getOrDefault("subscriptionId")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "subscriptionId", valid_594047
  var valid_594048 = path.getOrDefault("virtualNetworkName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "virtualNetworkName", valid_594048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594049 = query.getOrDefault("api-version")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "api-version", valid_594049
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

proc call*(call_594051: Call_SubnetsCreateOrUpdate_594042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a subnet in the specified virtual network.
  ## 
  let valid = call_594051.validator(path, query, header, formData, body)
  let scheme = call_594051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594051.url(scheme.get, call_594051.host, call_594051.base,
                         call_594051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594051, url, valid)

proc call*(call_594052: Call_SubnetsCreateOrUpdate_594042;
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
  var path_594053 = newJObject()
  var query_594054 = newJObject()
  var body_594055 = newJObject()
  add(path_594053, "resourceGroupName", newJString(resourceGroupName))
  add(path_594053, "subnetName", newJString(subnetName))
  add(query_594054, "api-version", newJString(apiVersion))
  add(path_594053, "subscriptionId", newJString(subscriptionId))
  add(path_594053, "virtualNetworkName", newJString(virtualNetworkName))
  if subnetParameters != nil:
    body_594055 = subnetParameters
  result = call_594052.call(path_594053, query_594054, nil, nil, body_594055)

var subnetsCreateOrUpdate* = Call_SubnetsCreateOrUpdate_594042(
    name: "subnetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsCreateOrUpdate_594043, base: "",
    url: url_SubnetsCreateOrUpdate_594044, schemes: {Scheme.Https})
type
  Call_SubnetsGet_594029 = ref object of OpenApiRestCall_593408
proc url_SubnetsGet_594031(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SubnetsGet_594030(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594032 = path.getOrDefault("resourceGroupName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "resourceGroupName", valid_594032
  var valid_594033 = path.getOrDefault("subnetName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "subnetName", valid_594033
  var valid_594034 = path.getOrDefault("subscriptionId")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "subscriptionId", valid_594034
  var valid_594035 = path.getOrDefault("virtualNetworkName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "virtualNetworkName", valid_594035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594036 = query.getOrDefault("api-version")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "api-version", valid_594036
  var valid_594037 = query.getOrDefault("$expand")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "$expand", valid_594037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594038: Call_SubnetsGet_594029; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified subnet by virtual network and resource group.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_SubnetsGet_594029; resourceGroupName: string;
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
  var path_594040 = newJObject()
  var query_594041 = newJObject()
  add(path_594040, "resourceGroupName", newJString(resourceGroupName))
  add(path_594040, "subnetName", newJString(subnetName))
  add(query_594041, "api-version", newJString(apiVersion))
  add(query_594041, "$expand", newJString(Expand))
  add(path_594040, "subscriptionId", newJString(subscriptionId))
  add(path_594040, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_594039.call(path_594040, query_594041, nil, nil, nil)

var subnetsGet* = Call_SubnetsGet_594029(name: "subnetsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
                                      validator: validate_SubnetsGet_594030,
                                      base: "", url: url_SubnetsGet_594031,
                                      schemes: {Scheme.Https})
type
  Call_SubnetsDelete_594056 = ref object of OpenApiRestCall_593408
proc url_SubnetsDelete_594058(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsDelete_594057(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594059 = path.getOrDefault("resourceGroupName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "resourceGroupName", valid_594059
  var valid_594060 = path.getOrDefault("subnetName")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "subnetName", valid_594060
  var valid_594061 = path.getOrDefault("subscriptionId")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "subscriptionId", valid_594061
  var valid_594062 = path.getOrDefault("virtualNetworkName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "virtualNetworkName", valid_594062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594063 = query.getOrDefault("api-version")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "api-version", valid_594063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594064: Call_SubnetsDelete_594056; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified subnet.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_SubnetsDelete_594056; resourceGroupName: string;
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
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  add(path_594066, "resourceGroupName", newJString(resourceGroupName))
  add(path_594066, "subnetName", newJString(subnetName))
  add(query_594067, "api-version", newJString(apiVersion))
  add(path_594066, "subscriptionId", newJString(subscriptionId))
  add(path_594066, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_594065.call(path_594066, query_594067, nil, nil, nil)

var subnetsDelete* = Call_SubnetsDelete_594056(name: "subnetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsDelete_594057, base: "", url: url_SubnetsDelete_594058,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsList_594068 = ref object of OpenApiRestCall_593408
proc url_VirtualNetworkPeeringsList_594070(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkPeeringsList_594069(path: JsonNode; query: JsonNode;
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
  var valid_594071 = path.getOrDefault("resourceGroupName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "resourceGroupName", valid_594071
  var valid_594072 = path.getOrDefault("subscriptionId")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "subscriptionId", valid_594072
  var valid_594073 = path.getOrDefault("virtualNetworkName")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "virtualNetworkName", valid_594073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594074 = query.getOrDefault("api-version")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "api-version", valid_594074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594075: Call_VirtualNetworkPeeringsList_594068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all virtual network peerings in a virtual network.
  ## 
  let valid = call_594075.validator(path, query, header, formData, body)
  let scheme = call_594075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594075.url(scheme.get, call_594075.host, call_594075.base,
                         call_594075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594075, url, valid)

proc call*(call_594076: Call_VirtualNetworkPeeringsList_594068;
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
  var path_594077 = newJObject()
  var query_594078 = newJObject()
  add(path_594077, "resourceGroupName", newJString(resourceGroupName))
  add(query_594078, "api-version", newJString(apiVersion))
  add(path_594077, "subscriptionId", newJString(subscriptionId))
  add(path_594077, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_594076.call(path_594077, query_594078, nil, nil, nil)

var virtualNetworkPeeringsList* = Call_VirtualNetworkPeeringsList_594068(
    name: "virtualNetworkPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings",
    validator: validate_VirtualNetworkPeeringsList_594069, base: "",
    url: url_VirtualNetworkPeeringsList_594070, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsCreateOrUpdate_594091 = ref object of OpenApiRestCall_593408
proc url_VirtualNetworkPeeringsCreateOrUpdate_594093(protocol: Scheme;
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

proc validate_VirtualNetworkPeeringsCreateOrUpdate_594092(path: JsonNode;
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
  var valid_594094 = path.getOrDefault("resourceGroupName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "resourceGroupName", valid_594094
  var valid_594095 = path.getOrDefault("subscriptionId")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "subscriptionId", valid_594095
  var valid_594096 = path.getOrDefault("virtualNetworkName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "virtualNetworkName", valid_594096
  var valid_594097 = path.getOrDefault("virtualNetworkPeeringName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "virtualNetworkPeeringName", valid_594097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594098 = query.getOrDefault("api-version")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "api-version", valid_594098
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

proc call*(call_594100: Call_VirtualNetworkPeeringsCreateOrUpdate_594091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a peering in the specified virtual network.
  ## 
  let valid = call_594100.validator(path, query, header, formData, body)
  let scheme = call_594100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594100.url(scheme.get, call_594100.host, call_594100.base,
                         call_594100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594100, url, valid)

proc call*(call_594101: Call_VirtualNetworkPeeringsCreateOrUpdate_594091;
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
  var path_594102 = newJObject()
  var query_594103 = newJObject()
  var body_594104 = newJObject()
  add(path_594102, "resourceGroupName", newJString(resourceGroupName))
  add(query_594103, "api-version", newJString(apiVersion))
  add(path_594102, "subscriptionId", newJString(subscriptionId))
  add(path_594102, "virtualNetworkName", newJString(virtualNetworkName))
  add(path_594102, "virtualNetworkPeeringName",
      newJString(virtualNetworkPeeringName))
  if VirtualNetworkPeeringParameters != nil:
    body_594104 = VirtualNetworkPeeringParameters
  result = call_594101.call(path_594102, query_594103, nil, nil, body_594104)

var virtualNetworkPeeringsCreateOrUpdate* = Call_VirtualNetworkPeeringsCreateOrUpdate_594091(
    name: "virtualNetworkPeeringsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings/{virtualNetworkPeeringName}",
    validator: validate_VirtualNetworkPeeringsCreateOrUpdate_594092, base: "",
    url: url_VirtualNetworkPeeringsCreateOrUpdate_594093, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsGet_594079 = ref object of OpenApiRestCall_593408
proc url_VirtualNetworkPeeringsGet_594081(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkPeeringsGet_594080(path: JsonNode; query: JsonNode;
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
  var valid_594082 = path.getOrDefault("resourceGroupName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "resourceGroupName", valid_594082
  var valid_594083 = path.getOrDefault("subscriptionId")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "subscriptionId", valid_594083
  var valid_594084 = path.getOrDefault("virtualNetworkName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "virtualNetworkName", valid_594084
  var valid_594085 = path.getOrDefault("virtualNetworkPeeringName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "virtualNetworkPeeringName", valid_594085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594086 = query.getOrDefault("api-version")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "api-version", valid_594086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594087: Call_VirtualNetworkPeeringsGet_594079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified virtual network peering.
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_VirtualNetworkPeeringsGet_594079;
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
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  add(path_594089, "resourceGroupName", newJString(resourceGroupName))
  add(query_594090, "api-version", newJString(apiVersion))
  add(path_594089, "subscriptionId", newJString(subscriptionId))
  add(path_594089, "virtualNetworkName", newJString(virtualNetworkName))
  add(path_594089, "virtualNetworkPeeringName",
      newJString(virtualNetworkPeeringName))
  result = call_594088.call(path_594089, query_594090, nil, nil, nil)

var virtualNetworkPeeringsGet* = Call_VirtualNetworkPeeringsGet_594079(
    name: "virtualNetworkPeeringsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings/{virtualNetworkPeeringName}",
    validator: validate_VirtualNetworkPeeringsGet_594080, base: "",
    url: url_VirtualNetworkPeeringsGet_594081, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsDelete_594105 = ref object of OpenApiRestCall_593408
proc url_VirtualNetworkPeeringsDelete_594107(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkPeeringsDelete_594106(path: JsonNode; query: JsonNode;
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
  var valid_594108 = path.getOrDefault("resourceGroupName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "resourceGroupName", valid_594108
  var valid_594109 = path.getOrDefault("subscriptionId")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "subscriptionId", valid_594109
  var valid_594110 = path.getOrDefault("virtualNetworkName")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "virtualNetworkName", valid_594110
  var valid_594111 = path.getOrDefault("virtualNetworkPeeringName")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "virtualNetworkPeeringName", valid_594111
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594112 = query.getOrDefault("api-version")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "api-version", valid_594112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594113: Call_VirtualNetworkPeeringsDelete_594105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified virtual network peering.
  ## 
  let valid = call_594113.validator(path, query, header, formData, body)
  let scheme = call_594113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594113.url(scheme.get, call_594113.host, call_594113.base,
                         call_594113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594113, url, valid)

proc call*(call_594114: Call_VirtualNetworkPeeringsDelete_594105;
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
  var path_594115 = newJObject()
  var query_594116 = newJObject()
  add(path_594115, "resourceGroupName", newJString(resourceGroupName))
  add(query_594116, "api-version", newJString(apiVersion))
  add(path_594115, "subscriptionId", newJString(subscriptionId))
  add(path_594115, "virtualNetworkName", newJString(virtualNetworkName))
  add(path_594115, "virtualNetworkPeeringName",
      newJString(virtualNetworkPeeringName))
  result = call_594114.call(path_594115, query_594116, nil, nil, nil)

var virtualNetworkPeeringsDelete* = Call_VirtualNetworkPeeringsDelete_594105(
    name: "virtualNetworkPeeringsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings/{virtualNetworkPeeringName}",
    validator: validate_VirtualNetworkPeeringsDelete_594106, base: "",
    url: url_VirtualNetworkPeeringsDelete_594107, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
