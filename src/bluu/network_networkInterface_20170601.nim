
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "network-networkInterface"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_NetworkInterfacesListAll_593646 = ref object of OpenApiRestCall_593424
proc url_NetworkInterfacesListAll_593648(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkInterfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesListAll_593647(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all network interfaces in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593821 = path.getOrDefault("subscriptionId")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "subscriptionId", valid_593821
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593822 = query.getOrDefault("api-version")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "api-version", valid_593822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_NetworkInterfacesListAll_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all network interfaces in a subscription.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_NetworkInterfacesListAll_593646; apiVersion: string;
          subscriptionId: string): Recallable =
  ## networkInterfacesListAll
  ## Gets all network interfaces in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593917 = newJObject()
  var query_593919 = newJObject()
  add(query_593919, "api-version", newJString(apiVersion))
  add(path_593917, "subscriptionId", newJString(subscriptionId))
  result = call_593916.call(path_593917, query_593919, nil, nil, nil)

var networkInterfacesListAll* = Call_NetworkInterfacesListAll_593646(
    name: "networkInterfacesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/networkInterfaces",
    validator: validate_NetworkInterfacesListAll_593647, base: "",
    url: url_NetworkInterfacesListAll_593648, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesList_593958 = ref object of OpenApiRestCall_593424
proc url_NetworkInterfacesList_593960(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Network/networkInterfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesList_593959(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all network interfaces in a resource group.
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
  var valid_593961 = path.getOrDefault("resourceGroupName")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "resourceGroupName", valid_593961
  var valid_593962 = path.getOrDefault("subscriptionId")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "subscriptionId", valid_593962
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593963 = query.getOrDefault("api-version")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "api-version", valid_593963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593964: Call_NetworkInterfacesList_593958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all network interfaces in a resource group.
  ## 
  let valid = call_593964.validator(path, query, header, formData, body)
  let scheme = call_593964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593964.url(scheme.get, call_593964.host, call_593964.base,
                         call_593964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593964, url, valid)

proc call*(call_593965: Call_NetworkInterfacesList_593958;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## networkInterfacesList
  ## Gets all network interfaces in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593966 = newJObject()
  var query_593967 = newJObject()
  add(path_593966, "resourceGroupName", newJString(resourceGroupName))
  add(query_593967, "api-version", newJString(apiVersion))
  add(path_593966, "subscriptionId", newJString(subscriptionId))
  result = call_593965.call(path_593966, query_593967, nil, nil, nil)

var networkInterfacesList* = Call_NetworkInterfacesList_593958(
    name: "networkInterfacesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces",
    validator: validate_NetworkInterfacesList_593959, base: "",
    url: url_NetworkInterfacesList_593960, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesCreateOrUpdate_593981 = ref object of OpenApiRestCall_593424
proc url_NetworkInterfacesCreateOrUpdate_593983(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkInterfaceName" in path,
        "`networkInterfaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesCreateOrUpdate_593982(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a network interface.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594001 = path.getOrDefault("resourceGroupName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "resourceGroupName", valid_594001
  var valid_594002 = path.getOrDefault("subscriptionId")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "subscriptionId", valid_594002
  var valid_594003 = path.getOrDefault("networkInterfaceName")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "networkInterfaceName", valid_594003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594004 = query.getOrDefault("api-version")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "api-version", valid_594004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update network interface operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594006: Call_NetworkInterfacesCreateOrUpdate_593981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a network interface.
  ## 
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_NetworkInterfacesCreateOrUpdate_593981;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkInterfaceName: string; parameters: JsonNode): Recallable =
  ## networkInterfacesCreateOrUpdate
  ## Creates or updates a network interface.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update network interface operation.
  var path_594008 = newJObject()
  var query_594009 = newJObject()
  var body_594010 = newJObject()
  add(path_594008, "resourceGroupName", newJString(resourceGroupName))
  add(query_594009, "api-version", newJString(apiVersion))
  add(path_594008, "subscriptionId", newJString(subscriptionId))
  add(path_594008, "networkInterfaceName", newJString(networkInterfaceName))
  if parameters != nil:
    body_594010 = parameters
  result = call_594007.call(path_594008, query_594009, nil, nil, body_594010)

var networkInterfacesCreateOrUpdate* = Call_NetworkInterfacesCreateOrUpdate_593981(
    name: "networkInterfacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesCreateOrUpdate_593982, base: "",
    url: url_NetworkInterfacesCreateOrUpdate_593983, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesGet_593968 = ref object of OpenApiRestCall_593424
proc url_NetworkInterfacesGet_593970(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkInterfaceName" in path,
        "`networkInterfaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesGet_593969(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified network interface.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593972 = path.getOrDefault("resourceGroupName")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "resourceGroupName", valid_593972
  var valid_593973 = path.getOrDefault("subscriptionId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "subscriptionId", valid_593973
  var valid_593974 = path.getOrDefault("networkInterfaceName")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "networkInterfaceName", valid_593974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  var valid_593976 = query.getOrDefault("$expand")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "$expand", valid_593976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593977: Call_NetworkInterfacesGet_593968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified network interface.
  ## 
  let valid = call_593977.validator(path, query, header, formData, body)
  let scheme = call_593977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593977.url(scheme.get, call_593977.host, call_593977.base,
                         call_593977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593977, url, valid)

proc call*(call_593978: Call_NetworkInterfacesGet_593968;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkInterfaceName: string; Expand: string = ""): Recallable =
  ## networkInterfacesGet
  ## Gets information about the specified network interface.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Expands referenced resources.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  var path_593979 = newJObject()
  var query_593980 = newJObject()
  add(path_593979, "resourceGroupName", newJString(resourceGroupName))
  add(query_593980, "api-version", newJString(apiVersion))
  add(query_593980, "$expand", newJString(Expand))
  add(path_593979, "subscriptionId", newJString(subscriptionId))
  add(path_593979, "networkInterfaceName", newJString(networkInterfaceName))
  result = call_593978.call(path_593979, query_593980, nil, nil, nil)

var networkInterfacesGet* = Call_NetworkInterfacesGet_593968(
    name: "networkInterfacesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesGet_593969, base: "",
    url: url_NetworkInterfacesGet_593970, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesDelete_594011 = ref object of OpenApiRestCall_593424
proc url_NetworkInterfacesDelete_594013(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkInterfaceName" in path,
        "`networkInterfaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesDelete_594012(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified network interface.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594014 = path.getOrDefault("resourceGroupName")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "resourceGroupName", valid_594014
  var valid_594015 = path.getOrDefault("subscriptionId")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "subscriptionId", valid_594015
  var valid_594016 = path.getOrDefault("networkInterfaceName")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "networkInterfaceName", valid_594016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594017 = query.getOrDefault("api-version")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "api-version", valid_594017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594018: Call_NetworkInterfacesDelete_594011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified network interface.
  ## 
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_NetworkInterfacesDelete_594011;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkInterfaceName: string): Recallable =
  ## networkInterfacesDelete
  ## Deletes the specified network interface.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  var path_594020 = newJObject()
  var query_594021 = newJObject()
  add(path_594020, "resourceGroupName", newJString(resourceGroupName))
  add(query_594021, "api-version", newJString(apiVersion))
  add(path_594020, "subscriptionId", newJString(subscriptionId))
  add(path_594020, "networkInterfaceName", newJString(networkInterfaceName))
  result = call_594019.call(path_594020, query_594021, nil, nil, nil)

var networkInterfacesDelete* = Call_NetworkInterfacesDelete_594011(
    name: "networkInterfacesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesDelete_594012, base: "",
    url: url_NetworkInterfacesDelete_594013, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListEffectiveNetworkSecurityGroups_594022 = ref object of OpenApiRestCall_593424
proc url_NetworkInterfacesListEffectiveNetworkSecurityGroups_594024(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkInterfaceName" in path,
        "`networkInterfaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName"), (
        kind: ConstantSegment, value: "/effectiveNetworkSecurityGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesListEffectiveNetworkSecurityGroups_594023(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets all network security groups applied to a network interface.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594025 = path.getOrDefault("resourceGroupName")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "resourceGroupName", valid_594025
  var valid_594026 = path.getOrDefault("subscriptionId")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "subscriptionId", valid_594026
  var valid_594027 = path.getOrDefault("networkInterfaceName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "networkInterfaceName", valid_594027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594028 = query.getOrDefault("api-version")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "api-version", valid_594028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594029: Call_NetworkInterfacesListEffectiveNetworkSecurityGroups_594022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all network security groups applied to a network interface.
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_NetworkInterfacesListEffectiveNetworkSecurityGroups_594022;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkInterfaceName: string): Recallable =
  ## networkInterfacesListEffectiveNetworkSecurityGroups
  ## Gets all network security groups applied to a network interface.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  add(path_594031, "resourceGroupName", newJString(resourceGroupName))
  add(query_594032, "api-version", newJString(apiVersion))
  add(path_594031, "subscriptionId", newJString(subscriptionId))
  add(path_594031, "networkInterfaceName", newJString(networkInterfaceName))
  result = call_594030.call(path_594031, query_594032, nil, nil, nil)

var networkInterfacesListEffectiveNetworkSecurityGroups* = Call_NetworkInterfacesListEffectiveNetworkSecurityGroups_594022(
    name: "networkInterfacesListEffectiveNetworkSecurityGroups",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}/effectiveNetworkSecurityGroups",
    validator: validate_NetworkInterfacesListEffectiveNetworkSecurityGroups_594023,
    base: "", url: url_NetworkInterfacesListEffectiveNetworkSecurityGroups_594024,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesGetEffectiveRouteTable_594033 = ref object of OpenApiRestCall_593424
proc url_NetworkInterfacesGetEffectiveRouteTable_594035(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkInterfaceName" in path,
        "`networkInterfaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName"),
               (kind: ConstantSegment, value: "/effectiveRouteTable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesGetEffectiveRouteTable_594034(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all route tables applied to a network interface.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594036 = path.getOrDefault("resourceGroupName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "resourceGroupName", valid_594036
  var valid_594037 = path.getOrDefault("subscriptionId")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "subscriptionId", valid_594037
  var valid_594038 = path.getOrDefault("networkInterfaceName")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "networkInterfaceName", valid_594038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594039 = query.getOrDefault("api-version")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "api-version", valid_594039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594040: Call_NetworkInterfacesGetEffectiveRouteTable_594033;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all route tables applied to a network interface.
  ## 
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_NetworkInterfacesGetEffectiveRouteTable_594033;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkInterfaceName: string): Recallable =
  ## networkInterfacesGetEffectiveRouteTable
  ## Gets all route tables applied to a network interface.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  var path_594042 = newJObject()
  var query_594043 = newJObject()
  add(path_594042, "resourceGroupName", newJString(resourceGroupName))
  add(query_594043, "api-version", newJString(apiVersion))
  add(path_594042, "subscriptionId", newJString(subscriptionId))
  add(path_594042, "networkInterfaceName", newJString(networkInterfaceName))
  result = call_594041.call(path_594042, query_594043, nil, nil, nil)

var networkInterfacesGetEffectiveRouteTable* = Call_NetworkInterfacesGetEffectiveRouteTable_594033(
    name: "networkInterfacesGetEffectiveRouteTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}/effectiveRouteTable",
    validator: validate_NetworkInterfacesGetEffectiveRouteTable_594034, base: "",
    url: url_NetworkInterfacesGetEffectiveRouteTable_594035,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfaceIPConfigurationsList_594044 = ref object of OpenApiRestCall_593424
proc url_NetworkInterfaceIPConfigurationsList_594046(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkInterfaceName" in path,
        "`networkInterfaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName"),
               (kind: ConstantSegment, value: "/ipConfigurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfaceIPConfigurationsList_594045(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all ip configurations in a network interface
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594047 = path.getOrDefault("resourceGroupName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "resourceGroupName", valid_594047
  var valid_594048 = path.getOrDefault("subscriptionId")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "subscriptionId", valid_594048
  var valid_594049 = path.getOrDefault("networkInterfaceName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "networkInterfaceName", valid_594049
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594050 = query.getOrDefault("api-version")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "api-version", valid_594050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594051: Call_NetworkInterfaceIPConfigurationsList_594044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all ip configurations in a network interface
  ## 
  let valid = call_594051.validator(path, query, header, formData, body)
  let scheme = call_594051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594051.url(scheme.get, call_594051.host, call_594051.base,
                         call_594051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594051, url, valid)

proc call*(call_594052: Call_NetworkInterfaceIPConfigurationsList_594044;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkInterfaceName: string): Recallable =
  ## networkInterfaceIPConfigurationsList
  ## Get all ip configurations in a network interface
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  var path_594053 = newJObject()
  var query_594054 = newJObject()
  add(path_594053, "resourceGroupName", newJString(resourceGroupName))
  add(query_594054, "api-version", newJString(apiVersion))
  add(path_594053, "subscriptionId", newJString(subscriptionId))
  add(path_594053, "networkInterfaceName", newJString(networkInterfaceName))
  result = call_594052.call(path_594053, query_594054, nil, nil, nil)

var networkInterfaceIPConfigurationsList* = Call_NetworkInterfaceIPConfigurationsList_594044(
    name: "networkInterfaceIPConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}/ipConfigurations",
    validator: validate_NetworkInterfaceIPConfigurationsList_594045, base: "",
    url: url_NetworkInterfaceIPConfigurationsList_594046, schemes: {Scheme.Https})
type
  Call_NetworkInterfaceIPConfigurationsGet_594055 = ref object of OpenApiRestCall_593424
proc url_NetworkInterfaceIPConfigurationsGet_594057(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkInterfaceName" in path,
        "`networkInterfaceName` is a required path parameter"
  assert "ipConfigurationName" in path,
        "`ipConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName"),
               (kind: ConstantSegment, value: "/ipConfigurations/"),
               (kind: VariableSegment, value: "ipConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfaceIPConfigurationsGet_594056(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified network interface ip configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ipConfigurationName: JString (required)
  ##                      : The name of the ip configuration name.
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594058 = path.getOrDefault("resourceGroupName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "resourceGroupName", valid_594058
  var valid_594059 = path.getOrDefault("subscriptionId")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "subscriptionId", valid_594059
  var valid_594060 = path.getOrDefault("ipConfigurationName")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "ipConfigurationName", valid_594060
  var valid_594061 = path.getOrDefault("networkInterfaceName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "networkInterfaceName", valid_594061
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594062 = query.getOrDefault("api-version")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "api-version", valid_594062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594063: Call_NetworkInterfaceIPConfigurationsGet_594055;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified network interface ip configuration.
  ## 
  let valid = call_594063.validator(path, query, header, formData, body)
  let scheme = call_594063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594063.url(scheme.get, call_594063.host, call_594063.base,
                         call_594063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594063, url, valid)

proc call*(call_594064: Call_NetworkInterfaceIPConfigurationsGet_594055;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          ipConfigurationName: string; networkInterfaceName: string): Recallable =
  ## networkInterfaceIPConfigurationsGet
  ## Gets the specified network interface ip configuration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ipConfigurationName: string (required)
  ##                      : The name of the ip configuration name.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  var path_594065 = newJObject()
  var query_594066 = newJObject()
  add(path_594065, "resourceGroupName", newJString(resourceGroupName))
  add(query_594066, "api-version", newJString(apiVersion))
  add(path_594065, "subscriptionId", newJString(subscriptionId))
  add(path_594065, "ipConfigurationName", newJString(ipConfigurationName))
  add(path_594065, "networkInterfaceName", newJString(networkInterfaceName))
  result = call_594064.call(path_594065, query_594066, nil, nil, nil)

var networkInterfaceIPConfigurationsGet* = Call_NetworkInterfaceIPConfigurationsGet_594055(
    name: "networkInterfaceIPConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}/ipConfigurations/{ipConfigurationName}",
    validator: validate_NetworkInterfaceIPConfigurationsGet_594056, base: "",
    url: url_NetworkInterfaceIPConfigurationsGet_594057, schemes: {Scheme.Https})
type
  Call_NetworkInterfaceLoadBalancersList_594067 = ref object of OpenApiRestCall_593424
proc url_NetworkInterfaceLoadBalancersList_594069(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkInterfaceName" in path,
        "`networkInterfaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName"),
               (kind: ConstantSegment, value: "/loadBalancers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfaceLoadBalancersList_594068(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all load balancers in a network interface
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594070 = path.getOrDefault("resourceGroupName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "resourceGroupName", valid_594070
  var valid_594071 = path.getOrDefault("subscriptionId")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "subscriptionId", valid_594071
  var valid_594072 = path.getOrDefault("networkInterfaceName")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "networkInterfaceName", valid_594072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594073 = query.getOrDefault("api-version")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "api-version", valid_594073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594074: Call_NetworkInterfaceLoadBalancersList_594067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all load balancers in a network interface
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_NetworkInterfaceLoadBalancersList_594067;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkInterfaceName: string): Recallable =
  ## networkInterfaceLoadBalancersList
  ## Get all load balancers in a network interface
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  add(path_594076, "resourceGroupName", newJString(resourceGroupName))
  add(query_594077, "api-version", newJString(apiVersion))
  add(path_594076, "subscriptionId", newJString(subscriptionId))
  add(path_594076, "networkInterfaceName", newJString(networkInterfaceName))
  result = call_594075.call(path_594076, query_594077, nil, nil, nil)

var networkInterfaceLoadBalancersList* = Call_NetworkInterfaceLoadBalancersList_594067(
    name: "networkInterfaceLoadBalancersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}/loadBalancers",
    validator: validate_NetworkInterfaceLoadBalancersList_594068, base: "",
    url: url_NetworkInterfaceLoadBalancersList_594069, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
