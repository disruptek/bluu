
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2019-06-01
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

  OpenApiRestCall_573658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573658): Option[Scheme] {.used.} =
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
  macServiceName = "network-networkWatcherConnectionMonitorV1"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ConnectionMonitorsList_573880 = ref object of OpenApiRestCall_573658
proc url_ConnectionMonitorsList_573882(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkWatcherName" in path,
        "`networkWatcherName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/connectionMonitors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionMonitorsList_573881(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all connection monitors for the specified Network Watcher.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing Network Watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574042 = path.getOrDefault("resourceGroupName")
  valid_574042 = validateParameter(valid_574042, JString, required = true,
                                 default = nil)
  if valid_574042 != nil:
    section.add "resourceGroupName", valid_574042
  var valid_574043 = path.getOrDefault("subscriptionId")
  valid_574043 = validateParameter(valid_574043, JString, required = true,
                                 default = nil)
  if valid_574043 != nil:
    section.add "subscriptionId", valid_574043
  var valid_574044 = path.getOrDefault("networkWatcherName")
  valid_574044 = validateParameter(valid_574044, JString, required = true,
                                 default = nil)
  if valid_574044 != nil:
    section.add "networkWatcherName", valid_574044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574045 = query.getOrDefault("api-version")
  valid_574045 = validateParameter(valid_574045, JString, required = true,
                                 default = nil)
  if valid_574045 != nil:
    section.add "api-version", valid_574045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574072: Call_ConnectionMonitorsList_573880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all connection monitors for the specified Network Watcher.
  ## 
  let valid = call_574072.validator(path, query, header, formData, body)
  let scheme = call_574072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574072.url(scheme.get, call_574072.host, call_574072.base,
                         call_574072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574072, url, valid)

proc call*(call_574143: Call_ConnectionMonitorsList_573880;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string): Recallable =
  ## connectionMonitorsList
  ## Lists all connection monitors for the specified Network Watcher.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing Network Watcher.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  var path_574144 = newJObject()
  var query_574146 = newJObject()
  add(path_574144, "resourceGroupName", newJString(resourceGroupName))
  add(query_574146, "api-version", newJString(apiVersion))
  add(path_574144, "subscriptionId", newJString(subscriptionId))
  add(path_574144, "networkWatcherName", newJString(networkWatcherName))
  result = call_574143.call(path_574144, query_574146, nil, nil, nil)

var connectionMonitorsList* = Call_ConnectionMonitorsList_573880(
    name: "connectionMonitorsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors",
    validator: validate_ConnectionMonitorsList_573881, base: "",
    url: url_ConnectionMonitorsList_573882, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsCreateOrUpdate_574197 = ref object of OpenApiRestCall_573658
proc url_ConnectionMonitorsCreateOrUpdate_574199(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkWatcherName" in path,
        "`networkWatcherName` is a required path parameter"
  assert "connectionMonitorName" in path,
        "`connectionMonitorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/connectionMonitors/"),
               (kind: VariableSegment, value: "connectionMonitorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionMonitorsCreateOrUpdate_574198(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a connection monitor.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing Network Watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  ##   connectionMonitorName: JString (required)
  ##                        : The name of the connection monitor.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574226 = path.getOrDefault("resourceGroupName")
  valid_574226 = validateParameter(valid_574226, JString, required = true,
                                 default = nil)
  if valid_574226 != nil:
    section.add "resourceGroupName", valid_574226
  var valid_574227 = path.getOrDefault("subscriptionId")
  valid_574227 = validateParameter(valid_574227, JString, required = true,
                                 default = nil)
  if valid_574227 != nil:
    section.add "subscriptionId", valid_574227
  var valid_574228 = path.getOrDefault("networkWatcherName")
  valid_574228 = validateParameter(valid_574228, JString, required = true,
                                 default = nil)
  if valid_574228 != nil:
    section.add "networkWatcherName", valid_574228
  var valid_574229 = path.getOrDefault("connectionMonitorName")
  valid_574229 = validateParameter(valid_574229, JString, required = true,
                                 default = nil)
  if valid_574229 != nil:
    section.add "connectionMonitorName", valid_574229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574230 = query.getOrDefault("api-version")
  valid_574230 = validateParameter(valid_574230, JString, required = true,
                                 default = nil)
  if valid_574230 != nil:
    section.add "api-version", valid_574230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that define the operation to create a connection monitor.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574232: Call_ConnectionMonitorsCreateOrUpdate_574197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a connection monitor.
  ## 
  let valid = call_574232.validator(path, query, header, formData, body)
  let scheme = call_574232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574232.url(scheme.get, call_574232.host, call_574232.base,
                         call_574232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574232, url, valid)

proc call*(call_574233: Call_ConnectionMonitorsCreateOrUpdate_574197;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; connectionMonitorName: string;
          parameters: JsonNode): Recallable =
  ## connectionMonitorsCreateOrUpdate
  ## Create or update a connection monitor.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing Network Watcher.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  ##   connectionMonitorName: string (required)
  ##                        : The name of the connection monitor.
  ##   parameters: JObject (required)
  ##             : Parameters that define the operation to create a connection monitor.
  var path_574234 = newJObject()
  var query_574235 = newJObject()
  var body_574236 = newJObject()
  add(path_574234, "resourceGroupName", newJString(resourceGroupName))
  add(query_574235, "api-version", newJString(apiVersion))
  add(path_574234, "subscriptionId", newJString(subscriptionId))
  add(path_574234, "networkWatcherName", newJString(networkWatcherName))
  add(path_574234, "connectionMonitorName", newJString(connectionMonitorName))
  if parameters != nil:
    body_574236 = parameters
  result = call_574233.call(path_574234, query_574235, nil, nil, body_574236)

var connectionMonitorsCreateOrUpdate* = Call_ConnectionMonitorsCreateOrUpdate_574197(
    name: "connectionMonitorsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}",
    validator: validate_ConnectionMonitorsCreateOrUpdate_574198, base: "",
    url: url_ConnectionMonitorsCreateOrUpdate_574199, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsGet_574185 = ref object of OpenApiRestCall_573658
proc url_ConnectionMonitorsGet_574187(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkWatcherName" in path,
        "`networkWatcherName` is a required path parameter"
  assert "connectionMonitorName" in path,
        "`connectionMonitorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/connectionMonitors/"),
               (kind: VariableSegment, value: "connectionMonitorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionMonitorsGet_574186(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a connection monitor by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing Network Watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  ##   connectionMonitorName: JString (required)
  ##                        : The name of the connection monitor.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574188 = path.getOrDefault("resourceGroupName")
  valid_574188 = validateParameter(valid_574188, JString, required = true,
                                 default = nil)
  if valid_574188 != nil:
    section.add "resourceGroupName", valid_574188
  var valid_574189 = path.getOrDefault("subscriptionId")
  valid_574189 = validateParameter(valid_574189, JString, required = true,
                                 default = nil)
  if valid_574189 != nil:
    section.add "subscriptionId", valid_574189
  var valid_574190 = path.getOrDefault("networkWatcherName")
  valid_574190 = validateParameter(valid_574190, JString, required = true,
                                 default = nil)
  if valid_574190 != nil:
    section.add "networkWatcherName", valid_574190
  var valid_574191 = path.getOrDefault("connectionMonitorName")
  valid_574191 = validateParameter(valid_574191, JString, required = true,
                                 default = nil)
  if valid_574191 != nil:
    section.add "connectionMonitorName", valid_574191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574192 = query.getOrDefault("api-version")
  valid_574192 = validateParameter(valid_574192, JString, required = true,
                                 default = nil)
  if valid_574192 != nil:
    section.add "api-version", valid_574192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574193: Call_ConnectionMonitorsGet_574185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a connection monitor by name.
  ## 
  let valid = call_574193.validator(path, query, header, formData, body)
  let scheme = call_574193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574193.url(scheme.get, call_574193.host, call_574193.base,
                         call_574193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574193, url, valid)

proc call*(call_574194: Call_ConnectionMonitorsGet_574185;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; connectionMonitorName: string): Recallable =
  ## connectionMonitorsGet
  ## Gets a connection monitor by name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing Network Watcher.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  ##   connectionMonitorName: string (required)
  ##                        : The name of the connection monitor.
  var path_574195 = newJObject()
  var query_574196 = newJObject()
  add(path_574195, "resourceGroupName", newJString(resourceGroupName))
  add(query_574196, "api-version", newJString(apiVersion))
  add(path_574195, "subscriptionId", newJString(subscriptionId))
  add(path_574195, "networkWatcherName", newJString(networkWatcherName))
  add(path_574195, "connectionMonitorName", newJString(connectionMonitorName))
  result = call_574194.call(path_574195, query_574196, nil, nil, nil)

var connectionMonitorsGet* = Call_ConnectionMonitorsGet_574185(
    name: "connectionMonitorsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}",
    validator: validate_ConnectionMonitorsGet_574186, base: "",
    url: url_ConnectionMonitorsGet_574187, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsUpdateTags_574249 = ref object of OpenApiRestCall_573658
proc url_ConnectionMonitorsUpdateTags_574251(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkWatcherName" in path,
        "`networkWatcherName` is a required path parameter"
  assert "connectionMonitorName" in path,
        "`connectionMonitorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/connectionMonitors/"),
               (kind: VariableSegment, value: "connectionMonitorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionMonitorsUpdateTags_574250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update tags of the specified connection monitor.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher.
  ##   connectionMonitorName: JString (required)
  ##                        : The name of the connection monitor.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574252 = path.getOrDefault("resourceGroupName")
  valid_574252 = validateParameter(valid_574252, JString, required = true,
                                 default = nil)
  if valid_574252 != nil:
    section.add "resourceGroupName", valid_574252
  var valid_574253 = path.getOrDefault("subscriptionId")
  valid_574253 = validateParameter(valid_574253, JString, required = true,
                                 default = nil)
  if valid_574253 != nil:
    section.add "subscriptionId", valid_574253
  var valid_574254 = path.getOrDefault("networkWatcherName")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "networkWatcherName", valid_574254
  var valid_574255 = path.getOrDefault("connectionMonitorName")
  valid_574255 = validateParameter(valid_574255, JString, required = true,
                                 default = nil)
  if valid_574255 != nil:
    section.add "connectionMonitorName", valid_574255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574256 = query.getOrDefault("api-version")
  valid_574256 = validateParameter(valid_574256, JString, required = true,
                                 default = nil)
  if valid_574256 != nil:
    section.add "api-version", valid_574256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update connection monitor tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574258: Call_ConnectionMonitorsUpdateTags_574249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update tags of the specified connection monitor.
  ## 
  let valid = call_574258.validator(path, query, header, formData, body)
  let scheme = call_574258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574258.url(scheme.get, call_574258.host, call_574258.base,
                         call_574258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574258, url, valid)

proc call*(call_574259: Call_ConnectionMonitorsUpdateTags_574249;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; connectionMonitorName: string;
          parameters: JsonNode): Recallable =
  ## connectionMonitorsUpdateTags
  ## Update tags of the specified connection monitor.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   connectionMonitorName: string (required)
  ##                        : The name of the connection monitor.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update connection monitor tags.
  var path_574260 = newJObject()
  var query_574261 = newJObject()
  var body_574262 = newJObject()
  add(path_574260, "resourceGroupName", newJString(resourceGroupName))
  add(query_574261, "api-version", newJString(apiVersion))
  add(path_574260, "subscriptionId", newJString(subscriptionId))
  add(path_574260, "networkWatcherName", newJString(networkWatcherName))
  add(path_574260, "connectionMonitorName", newJString(connectionMonitorName))
  if parameters != nil:
    body_574262 = parameters
  result = call_574259.call(path_574260, query_574261, nil, nil, body_574262)

var connectionMonitorsUpdateTags* = Call_ConnectionMonitorsUpdateTags_574249(
    name: "connectionMonitorsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}",
    validator: validate_ConnectionMonitorsUpdateTags_574250, base: "",
    url: url_ConnectionMonitorsUpdateTags_574251, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsDelete_574237 = ref object of OpenApiRestCall_573658
proc url_ConnectionMonitorsDelete_574239(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkWatcherName" in path,
        "`networkWatcherName` is a required path parameter"
  assert "connectionMonitorName" in path,
        "`connectionMonitorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/connectionMonitors/"),
               (kind: VariableSegment, value: "connectionMonitorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionMonitorsDelete_574238(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified connection monitor.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing Network Watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  ##   connectionMonitorName: JString (required)
  ##                        : The name of the connection monitor.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574240 = path.getOrDefault("resourceGroupName")
  valid_574240 = validateParameter(valid_574240, JString, required = true,
                                 default = nil)
  if valid_574240 != nil:
    section.add "resourceGroupName", valid_574240
  var valid_574241 = path.getOrDefault("subscriptionId")
  valid_574241 = validateParameter(valid_574241, JString, required = true,
                                 default = nil)
  if valid_574241 != nil:
    section.add "subscriptionId", valid_574241
  var valid_574242 = path.getOrDefault("networkWatcherName")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "networkWatcherName", valid_574242
  var valid_574243 = path.getOrDefault("connectionMonitorName")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "connectionMonitorName", valid_574243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574244 = query.getOrDefault("api-version")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "api-version", valid_574244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574245: Call_ConnectionMonitorsDelete_574237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified connection monitor.
  ## 
  let valid = call_574245.validator(path, query, header, formData, body)
  let scheme = call_574245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574245.url(scheme.get, call_574245.host, call_574245.base,
                         call_574245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574245, url, valid)

proc call*(call_574246: Call_ConnectionMonitorsDelete_574237;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; connectionMonitorName: string): Recallable =
  ## connectionMonitorsDelete
  ## Deletes the specified connection monitor.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing Network Watcher.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  ##   connectionMonitorName: string (required)
  ##                        : The name of the connection monitor.
  var path_574247 = newJObject()
  var query_574248 = newJObject()
  add(path_574247, "resourceGroupName", newJString(resourceGroupName))
  add(query_574248, "api-version", newJString(apiVersion))
  add(path_574247, "subscriptionId", newJString(subscriptionId))
  add(path_574247, "networkWatcherName", newJString(networkWatcherName))
  add(path_574247, "connectionMonitorName", newJString(connectionMonitorName))
  result = call_574246.call(path_574247, query_574248, nil, nil, nil)

var connectionMonitorsDelete* = Call_ConnectionMonitorsDelete_574237(
    name: "connectionMonitorsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}",
    validator: validate_ConnectionMonitorsDelete_574238, base: "",
    url: url_ConnectionMonitorsDelete_574239, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsQuery_574263 = ref object of OpenApiRestCall_573658
proc url_ConnectionMonitorsQuery_574265(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkWatcherName" in path,
        "`networkWatcherName` is a required path parameter"
  assert "connectionMonitorName" in path,
        "`connectionMonitorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/connectionMonitors/"),
               (kind: VariableSegment, value: "connectionMonitorName"),
               (kind: ConstantSegment, value: "/query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionMonitorsQuery_574264(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query a snapshot of the most recent connection states.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing Network Watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  ##   connectionMonitorName: JString (required)
  ##                        : The name given to the connection monitor.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574266 = path.getOrDefault("resourceGroupName")
  valid_574266 = validateParameter(valid_574266, JString, required = true,
                                 default = nil)
  if valid_574266 != nil:
    section.add "resourceGroupName", valid_574266
  var valid_574267 = path.getOrDefault("subscriptionId")
  valid_574267 = validateParameter(valid_574267, JString, required = true,
                                 default = nil)
  if valid_574267 != nil:
    section.add "subscriptionId", valid_574267
  var valid_574268 = path.getOrDefault("networkWatcherName")
  valid_574268 = validateParameter(valid_574268, JString, required = true,
                                 default = nil)
  if valid_574268 != nil:
    section.add "networkWatcherName", valid_574268
  var valid_574269 = path.getOrDefault("connectionMonitorName")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "connectionMonitorName", valid_574269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574270 = query.getOrDefault("api-version")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "api-version", valid_574270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574271: Call_ConnectionMonitorsQuery_574263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query a snapshot of the most recent connection states.
  ## 
  let valid = call_574271.validator(path, query, header, formData, body)
  let scheme = call_574271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574271.url(scheme.get, call_574271.host, call_574271.base,
                         call_574271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574271, url, valid)

proc call*(call_574272: Call_ConnectionMonitorsQuery_574263;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; connectionMonitorName: string): Recallable =
  ## connectionMonitorsQuery
  ## Query a snapshot of the most recent connection states.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing Network Watcher.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  ##   connectionMonitorName: string (required)
  ##                        : The name given to the connection monitor.
  var path_574273 = newJObject()
  var query_574274 = newJObject()
  add(path_574273, "resourceGroupName", newJString(resourceGroupName))
  add(query_574274, "api-version", newJString(apiVersion))
  add(path_574273, "subscriptionId", newJString(subscriptionId))
  add(path_574273, "networkWatcherName", newJString(networkWatcherName))
  add(path_574273, "connectionMonitorName", newJString(connectionMonitorName))
  result = call_574272.call(path_574273, query_574274, nil, nil, nil)

var connectionMonitorsQuery* = Call_ConnectionMonitorsQuery_574263(
    name: "connectionMonitorsQuery", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}/query",
    validator: validate_ConnectionMonitorsQuery_574264, base: "",
    url: url_ConnectionMonitorsQuery_574265, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsStart_574275 = ref object of OpenApiRestCall_573658
proc url_ConnectionMonitorsStart_574277(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkWatcherName" in path,
        "`networkWatcherName` is a required path parameter"
  assert "connectionMonitorName" in path,
        "`connectionMonitorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/connectionMonitors/"),
               (kind: VariableSegment, value: "connectionMonitorName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionMonitorsStart_574276(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts the specified connection monitor.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing Network Watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  ##   connectionMonitorName: JString (required)
  ##                        : The name of the connection monitor.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574278 = path.getOrDefault("resourceGroupName")
  valid_574278 = validateParameter(valid_574278, JString, required = true,
                                 default = nil)
  if valid_574278 != nil:
    section.add "resourceGroupName", valid_574278
  var valid_574279 = path.getOrDefault("subscriptionId")
  valid_574279 = validateParameter(valid_574279, JString, required = true,
                                 default = nil)
  if valid_574279 != nil:
    section.add "subscriptionId", valid_574279
  var valid_574280 = path.getOrDefault("networkWatcherName")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = nil)
  if valid_574280 != nil:
    section.add "networkWatcherName", valid_574280
  var valid_574281 = path.getOrDefault("connectionMonitorName")
  valid_574281 = validateParameter(valid_574281, JString, required = true,
                                 default = nil)
  if valid_574281 != nil:
    section.add "connectionMonitorName", valid_574281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574282 = query.getOrDefault("api-version")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "api-version", valid_574282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574283: Call_ConnectionMonitorsStart_574275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts the specified connection monitor.
  ## 
  let valid = call_574283.validator(path, query, header, formData, body)
  let scheme = call_574283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574283.url(scheme.get, call_574283.host, call_574283.base,
                         call_574283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574283, url, valid)

proc call*(call_574284: Call_ConnectionMonitorsStart_574275;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; connectionMonitorName: string): Recallable =
  ## connectionMonitorsStart
  ## Starts the specified connection monitor.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing Network Watcher.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  ##   connectionMonitorName: string (required)
  ##                        : The name of the connection monitor.
  var path_574285 = newJObject()
  var query_574286 = newJObject()
  add(path_574285, "resourceGroupName", newJString(resourceGroupName))
  add(query_574286, "api-version", newJString(apiVersion))
  add(path_574285, "subscriptionId", newJString(subscriptionId))
  add(path_574285, "networkWatcherName", newJString(networkWatcherName))
  add(path_574285, "connectionMonitorName", newJString(connectionMonitorName))
  result = call_574284.call(path_574285, query_574286, nil, nil, nil)

var connectionMonitorsStart* = Call_ConnectionMonitorsStart_574275(
    name: "connectionMonitorsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}/start",
    validator: validate_ConnectionMonitorsStart_574276, base: "",
    url: url_ConnectionMonitorsStart_574277, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsStop_574287 = ref object of OpenApiRestCall_573658
proc url_ConnectionMonitorsStop_574289(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkWatcherName" in path,
        "`networkWatcherName` is a required path parameter"
  assert "connectionMonitorName" in path,
        "`connectionMonitorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/connectionMonitors/"),
               (kind: VariableSegment, value: "connectionMonitorName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectionMonitorsStop_574288(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops the specified connection monitor.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing Network Watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  ##   connectionMonitorName: JString (required)
  ##                        : The name of the connection monitor.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574290 = path.getOrDefault("resourceGroupName")
  valid_574290 = validateParameter(valid_574290, JString, required = true,
                                 default = nil)
  if valid_574290 != nil:
    section.add "resourceGroupName", valid_574290
  var valid_574291 = path.getOrDefault("subscriptionId")
  valid_574291 = validateParameter(valid_574291, JString, required = true,
                                 default = nil)
  if valid_574291 != nil:
    section.add "subscriptionId", valid_574291
  var valid_574292 = path.getOrDefault("networkWatcherName")
  valid_574292 = validateParameter(valid_574292, JString, required = true,
                                 default = nil)
  if valid_574292 != nil:
    section.add "networkWatcherName", valid_574292
  var valid_574293 = path.getOrDefault("connectionMonitorName")
  valid_574293 = validateParameter(valid_574293, JString, required = true,
                                 default = nil)
  if valid_574293 != nil:
    section.add "connectionMonitorName", valid_574293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574294 = query.getOrDefault("api-version")
  valid_574294 = validateParameter(valid_574294, JString, required = true,
                                 default = nil)
  if valid_574294 != nil:
    section.add "api-version", valid_574294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574295: Call_ConnectionMonitorsStop_574287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops the specified connection monitor.
  ## 
  let valid = call_574295.validator(path, query, header, formData, body)
  let scheme = call_574295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574295.url(scheme.get, call_574295.host, call_574295.base,
                         call_574295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574295, url, valid)

proc call*(call_574296: Call_ConnectionMonitorsStop_574287;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; connectionMonitorName: string): Recallable =
  ## connectionMonitorsStop
  ## Stops the specified connection monitor.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing Network Watcher.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  ##   connectionMonitorName: string (required)
  ##                        : The name of the connection monitor.
  var path_574297 = newJObject()
  var query_574298 = newJObject()
  add(path_574297, "resourceGroupName", newJString(resourceGroupName))
  add(query_574298, "api-version", newJString(apiVersion))
  add(path_574297, "subscriptionId", newJString(subscriptionId))
  add(path_574297, "networkWatcherName", newJString(networkWatcherName))
  add(path_574297, "connectionMonitorName", newJString(connectionMonitorName))
  result = call_574296.call(path_574297, query_574298, nil, nil, nil)

var connectionMonitorsStop* = Call_ConnectionMonitorsStop_574287(
    name: "connectionMonitorsStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}/stop",
    validator: validate_ConnectionMonitorsStop_574288, base: "",
    url: url_ConnectionMonitorsStop_574289, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
