
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2017-08-01
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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  macServiceName = "network-networkWatcher"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_NetworkWatchersListAll_563778 = ref object of OpenApiRestCall_563556
proc url_NetworkWatchersListAll_563780(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Network/networkWatchers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkWatchersListAll_563779(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all network watchers by subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563955 = path.getOrDefault("subscriptionId")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "subscriptionId", valid_563955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563956 = query.getOrDefault("api-version")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "api-version", valid_563956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563979: Call_NetworkWatchersListAll_563778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all network watchers by subscription.
  ## 
  let valid = call_563979.validator(path, query, header, formData, body)
  let scheme = call_563979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563979.url(scheme.get, call_563979.host, call_563979.base,
                         call_563979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563979, url, valid)

proc call*(call_564050: Call_NetworkWatchersListAll_563778; apiVersion: string;
          subscriptionId: string): Recallable =
  ## networkWatchersListAll
  ## Gets all network watchers by subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564051 = newJObject()
  var query_564053 = newJObject()
  add(query_564053, "api-version", newJString(apiVersion))
  add(path_564051, "subscriptionId", newJString(subscriptionId))
  result = call_564050.call(path_564051, query_564053, nil, nil, nil)

var networkWatchersListAll* = Call_NetworkWatchersListAll_563778(
    name: "networkWatchersListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/networkWatchers",
    validator: validate_NetworkWatchersListAll_563779, base: "",
    url: url_NetworkWatchersListAll_563780, schemes: {Scheme.Https})
type
  Call_NetworkWatchersList_564092 = ref object of OpenApiRestCall_563556
proc url_NetworkWatchersList_564094(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Network/networkWatchers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkWatchersList_564093(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets all network watchers by resource group.
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
  var valid_564095 = path.getOrDefault("subscriptionId")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "subscriptionId", valid_564095
  var valid_564096 = path.getOrDefault("resourceGroupName")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "resourceGroupName", valid_564096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564097 = query.getOrDefault("api-version")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "api-version", valid_564097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564098: Call_NetworkWatchersList_564092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all network watchers by resource group.
  ## 
  let valid = call_564098.validator(path, query, header, formData, body)
  let scheme = call_564098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564098.url(scheme.get, call_564098.host, call_564098.base,
                         call_564098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564098, url, valid)

proc call*(call_564099: Call_NetworkWatchersList_564092; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## networkWatchersList
  ## Gets all network watchers by resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564100 = newJObject()
  var query_564101 = newJObject()
  add(query_564101, "api-version", newJString(apiVersion))
  add(path_564100, "subscriptionId", newJString(subscriptionId))
  add(path_564100, "resourceGroupName", newJString(resourceGroupName))
  result = call_564099.call(path_564100, query_564101, nil, nil, nil)

var networkWatchersList* = Call_NetworkWatchersList_564092(
    name: "networkWatchersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers",
    validator: validate_NetworkWatchersList_564093, base: "",
    url: url_NetworkWatchersList_564094, schemes: {Scheme.Https})
type
  Call_NetworkWatchersCreateOrUpdate_564113 = ref object of OpenApiRestCall_563556
proc url_NetworkWatchersCreateOrUpdate_564115(protocol: Scheme; host: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkWatchersCreateOrUpdate_564114(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a network watcher in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564133 = path.getOrDefault("networkWatcherName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "networkWatcherName", valid_564133
  var valid_564134 = path.getOrDefault("subscriptionId")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "subscriptionId", valid_564134
  var valid_564135 = path.getOrDefault("resourceGroupName")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "resourceGroupName", valid_564135
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564136 = query.getOrDefault("api-version")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "api-version", valid_564136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that define the network watcher resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564138: Call_NetworkWatchersCreateOrUpdate_564113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a network watcher in the specified resource group.
  ## 
  let valid = call_564138.validator(path, query, header, formData, body)
  let scheme = call_564138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564138.url(scheme.get, call_564138.host, call_564138.base,
                         call_564138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564138, url, valid)

proc call*(call_564139: Call_NetworkWatchersCreateOrUpdate_564113;
          apiVersion: string; networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## networkWatchersCreateOrUpdate
  ## Creates or updates a network watcher in the specified resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters that define the network watcher resource.
  var path_564140 = newJObject()
  var query_564141 = newJObject()
  var body_564142 = newJObject()
  add(query_564141, "api-version", newJString(apiVersion))
  add(path_564140, "networkWatcherName", newJString(networkWatcherName))
  add(path_564140, "subscriptionId", newJString(subscriptionId))
  add(path_564140, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564142 = parameters
  result = call_564139.call(path_564140, query_564141, nil, nil, body_564142)

var networkWatchersCreateOrUpdate* = Call_NetworkWatchersCreateOrUpdate_564113(
    name: "networkWatchersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}",
    validator: validate_NetworkWatchersCreateOrUpdate_564114, base: "",
    url: url_NetworkWatchersCreateOrUpdate_564115, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGet_564102 = ref object of OpenApiRestCall_563556
proc url_NetworkWatchersGet_564104(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "networkWatcherName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkWatchersGet_564103(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the specified network watcher by resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564105 = path.getOrDefault("networkWatcherName")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "networkWatcherName", valid_564105
  var valid_564106 = path.getOrDefault("subscriptionId")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "subscriptionId", valid_564106
  var valid_564107 = path.getOrDefault("resourceGroupName")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "resourceGroupName", valid_564107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564108 = query.getOrDefault("api-version")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "api-version", valid_564108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564109: Call_NetworkWatchersGet_564102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified network watcher by resource group.
  ## 
  let valid = call_564109.validator(path, query, header, formData, body)
  let scheme = call_564109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564109.url(scheme.get, call_564109.host, call_564109.base,
                         call_564109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564109, url, valid)

proc call*(call_564110: Call_NetworkWatchersGet_564102; apiVersion: string;
          networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## networkWatchersGet
  ## Gets the specified network watcher by resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564111 = newJObject()
  var query_564112 = newJObject()
  add(query_564112, "api-version", newJString(apiVersion))
  add(path_564111, "networkWatcherName", newJString(networkWatcherName))
  add(path_564111, "subscriptionId", newJString(subscriptionId))
  add(path_564111, "resourceGroupName", newJString(resourceGroupName))
  result = call_564110.call(path_564111, query_564112, nil, nil, nil)

var networkWatchersGet* = Call_NetworkWatchersGet_564102(
    name: "networkWatchersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}",
    validator: validate_NetworkWatchersGet_564103, base: "",
    url: url_NetworkWatchersGet_564104, schemes: {Scheme.Https})
type
  Call_NetworkWatchersDelete_564143 = ref object of OpenApiRestCall_563556
proc url_NetworkWatchersDelete_564145(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "networkWatcherName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkWatchersDelete_564144(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified network watcher resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564146 = path.getOrDefault("networkWatcherName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "networkWatcherName", valid_564146
  var valid_564147 = path.getOrDefault("subscriptionId")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "subscriptionId", valid_564147
  var valid_564148 = path.getOrDefault("resourceGroupName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "resourceGroupName", valid_564148
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564149 = query.getOrDefault("api-version")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "api-version", valid_564149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564150: Call_NetworkWatchersDelete_564143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified network watcher resource.
  ## 
  let valid = call_564150.validator(path, query, header, formData, body)
  let scheme = call_564150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564150.url(scheme.get, call_564150.host, call_564150.base,
                         call_564150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564150, url, valid)

proc call*(call_564151: Call_NetworkWatchersDelete_564143; apiVersion: string;
          networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## networkWatchersDelete
  ## Deletes the specified network watcher resource.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564152 = newJObject()
  var query_564153 = newJObject()
  add(query_564153, "api-version", newJString(apiVersion))
  add(path_564152, "networkWatcherName", newJString(networkWatcherName))
  add(path_564152, "subscriptionId", newJString(subscriptionId))
  add(path_564152, "resourceGroupName", newJString(resourceGroupName))
  result = call_564151.call(path_564152, query_564153, nil, nil, nil)

var networkWatchersDelete* = Call_NetworkWatchersDelete_564143(
    name: "networkWatchersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}",
    validator: validate_NetworkWatchersDelete_564144, base: "",
    url: url_NetworkWatchersDelete_564145, schemes: {Scheme.Https})
type
  Call_NetworkWatchersSetFlowLogConfiguration_564154 = ref object of OpenApiRestCall_563556
proc url_NetworkWatchersSetFlowLogConfiguration_564156(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/configureFlowLog")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkWatchersSetFlowLogConfiguration_564155(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Configures flow log on a specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher resource.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the network watcher resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564157 = path.getOrDefault("networkWatcherName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "networkWatcherName", valid_564157
  var valid_564158 = path.getOrDefault("subscriptionId")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "subscriptionId", valid_564158
  var valid_564159 = path.getOrDefault("resourceGroupName")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "resourceGroupName", valid_564159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564160 = query.getOrDefault("api-version")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "api-version", valid_564160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that define the configuration of flow log.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564162: Call_NetworkWatchersSetFlowLogConfiguration_564154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Configures flow log on a specified resource.
  ## 
  let valid = call_564162.validator(path, query, header, formData, body)
  let scheme = call_564162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564162.url(scheme.get, call_564162.host, call_564162.base,
                         call_564162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564162, url, valid)

proc call*(call_564163: Call_NetworkWatchersSetFlowLogConfiguration_564154;
          apiVersion: string; networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## networkWatchersSetFlowLogConfiguration
  ## Configures flow log on a specified resource.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher resource.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the network watcher resource group.
  ##   parameters: JObject (required)
  ##             : Parameters that define the configuration of flow log.
  var path_564164 = newJObject()
  var query_564165 = newJObject()
  var body_564166 = newJObject()
  add(query_564165, "api-version", newJString(apiVersion))
  add(path_564164, "networkWatcherName", newJString(networkWatcherName))
  add(path_564164, "subscriptionId", newJString(subscriptionId))
  add(path_564164, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564166 = parameters
  result = call_564163.call(path_564164, query_564165, nil, nil, body_564166)

var networkWatchersSetFlowLogConfiguration* = Call_NetworkWatchersSetFlowLogConfiguration_564154(
    name: "networkWatchersSetFlowLogConfiguration", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/configureFlowLog",
    validator: validate_NetworkWatchersSetFlowLogConfiguration_564155, base: "",
    url: url_NetworkWatchersSetFlowLogConfiguration_564156,
    schemes: {Scheme.Https})
type
  Call_NetworkWatchersCheckConnectivity_564167 = ref object of OpenApiRestCall_563556
proc url_NetworkWatchersCheckConnectivity_564169(protocol: Scheme; host: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/connectivityCheck")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkWatchersCheckConnectivity_564168(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verifies the possibility of establishing a direct TCP connection from a virtual machine to a given endpoint including another VM or an arbitrary remote server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher resource.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the network watcher resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564170 = path.getOrDefault("networkWatcherName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "networkWatcherName", valid_564170
  var valid_564171 = path.getOrDefault("subscriptionId")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "subscriptionId", valid_564171
  var valid_564172 = path.getOrDefault("resourceGroupName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "resourceGroupName", valid_564172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564173 = query.getOrDefault("api-version")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "api-version", valid_564173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that determine how the connectivity check will be performed.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564175: Call_NetworkWatchersCheckConnectivity_564167;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies the possibility of establishing a direct TCP connection from a virtual machine to a given endpoint including another VM or an arbitrary remote server.
  ## 
  let valid = call_564175.validator(path, query, header, formData, body)
  let scheme = call_564175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564175.url(scheme.get, call_564175.host, call_564175.base,
                         call_564175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564175, url, valid)

proc call*(call_564176: Call_NetworkWatchersCheckConnectivity_564167;
          apiVersion: string; networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## networkWatchersCheckConnectivity
  ## Verifies the possibility of establishing a direct TCP connection from a virtual machine to a given endpoint including another VM or an arbitrary remote server.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher resource.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the network watcher resource group.
  ##   parameters: JObject (required)
  ##             : Parameters that determine how the connectivity check will be performed.
  var path_564177 = newJObject()
  var query_564178 = newJObject()
  var body_564179 = newJObject()
  add(query_564178, "api-version", newJString(apiVersion))
  add(path_564177, "networkWatcherName", newJString(networkWatcherName))
  add(path_564177, "subscriptionId", newJString(subscriptionId))
  add(path_564177, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564179 = parameters
  result = call_564176.call(path_564177, query_564178, nil, nil, body_564179)

var networkWatchersCheckConnectivity* = Call_NetworkWatchersCheckConnectivity_564167(
    name: "networkWatchersCheckConnectivity", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectivityCheck",
    validator: validate_NetworkWatchersCheckConnectivity_564168, base: "",
    url: url_NetworkWatchersCheckConnectivity_564169, schemes: {Scheme.Https})
type
  Call_NetworkWatchersVerifyIPFlow_564180 = ref object of OpenApiRestCall_563556
proc url_NetworkWatchersVerifyIPFlow_564182(protocol: Scheme; host: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/ipFlowVerify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkWatchersVerifyIPFlow_564181(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verify IP flow from the specified VM to a location given the currently configured NSG rules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564183 = path.getOrDefault("networkWatcherName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "networkWatcherName", valid_564183
  var valid_564184 = path.getOrDefault("subscriptionId")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "subscriptionId", valid_564184
  var valid_564185 = path.getOrDefault("resourceGroupName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "resourceGroupName", valid_564185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564186 = query.getOrDefault("api-version")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "api-version", valid_564186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that define the IP flow to be verified.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564188: Call_NetworkWatchersVerifyIPFlow_564180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verify IP flow from the specified VM to a location given the currently configured NSG rules.
  ## 
  let valid = call_564188.validator(path, query, header, formData, body)
  let scheme = call_564188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564188.url(scheme.get, call_564188.host, call_564188.base,
                         call_564188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564188, url, valid)

proc call*(call_564189: Call_NetworkWatchersVerifyIPFlow_564180;
          apiVersion: string; networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## networkWatchersVerifyIPFlow
  ## Verify IP flow from the specified VM to a location given the currently configured NSG rules.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters that define the IP flow to be verified.
  var path_564190 = newJObject()
  var query_564191 = newJObject()
  var body_564192 = newJObject()
  add(query_564191, "api-version", newJString(apiVersion))
  add(path_564190, "networkWatcherName", newJString(networkWatcherName))
  add(path_564190, "subscriptionId", newJString(subscriptionId))
  add(path_564190, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564192 = parameters
  result = call_564189.call(path_564190, query_564191, nil, nil, body_564192)

var networkWatchersVerifyIPFlow* = Call_NetworkWatchersVerifyIPFlow_564180(
    name: "networkWatchersVerifyIPFlow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/ipFlowVerify",
    validator: validate_NetworkWatchersVerifyIPFlow_564181, base: "",
    url: url_NetworkWatchersVerifyIPFlow_564182, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetNextHop_564193 = ref object of OpenApiRestCall_563556
proc url_NetworkWatchersGetNextHop_564195(protocol: Scheme; host: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/nextHop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkWatchersGetNextHop_564194(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the next hop from the specified VM.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564196 = path.getOrDefault("networkWatcherName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "networkWatcherName", valid_564196
  var valid_564197 = path.getOrDefault("subscriptionId")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "subscriptionId", valid_564197
  var valid_564198 = path.getOrDefault("resourceGroupName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "resourceGroupName", valid_564198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564199 = query.getOrDefault("api-version")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "api-version", valid_564199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that define the source and destination endpoint.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564201: Call_NetworkWatchersGetNextHop_564193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the next hop from the specified VM.
  ## 
  let valid = call_564201.validator(path, query, header, formData, body)
  let scheme = call_564201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564201.url(scheme.get, call_564201.host, call_564201.base,
                         call_564201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564201, url, valid)

proc call*(call_564202: Call_NetworkWatchersGetNextHop_564193; apiVersion: string;
          networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetNextHop
  ## Gets the next hop from the specified VM.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters that define the source and destination endpoint.
  var path_564203 = newJObject()
  var query_564204 = newJObject()
  var body_564205 = newJObject()
  add(query_564204, "api-version", newJString(apiVersion))
  add(path_564203, "networkWatcherName", newJString(networkWatcherName))
  add(path_564203, "subscriptionId", newJString(subscriptionId))
  add(path_564203, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564205 = parameters
  result = call_564202.call(path_564203, query_564204, nil, nil, body_564205)

var networkWatchersGetNextHop* = Call_NetworkWatchersGetNextHop_564193(
    name: "networkWatchersGetNextHop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/nextHop",
    validator: validate_NetworkWatchersGetNextHop_564194, base: "",
    url: url_NetworkWatchersGetNextHop_564195, schemes: {Scheme.Https})
type
  Call_PacketCapturesList_564206 = ref object of OpenApiRestCall_563556
proc url_PacketCapturesList_564208(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/packetCaptures")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PacketCapturesList_564207(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all packet capture sessions within the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564209 = path.getOrDefault("networkWatcherName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "networkWatcherName", valid_564209
  var valid_564210 = path.getOrDefault("subscriptionId")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "subscriptionId", valid_564210
  var valid_564211 = path.getOrDefault("resourceGroupName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "resourceGroupName", valid_564211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564212 = query.getOrDefault("api-version")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "api-version", valid_564212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564213: Call_PacketCapturesList_564206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all packet capture sessions within the specified resource group.
  ## 
  let valid = call_564213.validator(path, query, header, formData, body)
  let scheme = call_564213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564213.url(scheme.get, call_564213.host, call_564213.base,
                         call_564213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564213, url, valid)

proc call*(call_564214: Call_PacketCapturesList_564206; apiVersion: string;
          networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## packetCapturesList
  ## Lists all packet capture sessions within the specified resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564215 = newJObject()
  var query_564216 = newJObject()
  add(query_564216, "api-version", newJString(apiVersion))
  add(path_564215, "networkWatcherName", newJString(networkWatcherName))
  add(path_564215, "subscriptionId", newJString(subscriptionId))
  add(path_564215, "resourceGroupName", newJString(resourceGroupName))
  result = call_564214.call(path_564215, query_564216, nil, nil, nil)

var packetCapturesList* = Call_PacketCapturesList_564206(
    name: "packetCapturesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures",
    validator: validate_PacketCapturesList_564207, base: "",
    url: url_PacketCapturesList_564208, schemes: {Scheme.Https})
type
  Call_PacketCapturesCreate_564229 = ref object of OpenApiRestCall_563556
proc url_PacketCapturesCreate_564231(protocol: Scheme; host: string; base: string;
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
  assert "packetCaptureName" in path,
        "`packetCaptureName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/packetCaptures/"),
               (kind: VariableSegment, value: "packetCaptureName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PacketCapturesCreate_564230(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create and start a packet capture on the specified VM.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packetCaptureName: JString (required)
  ##                    : The name of the packet capture session.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packetCaptureName` field"
  var valid_564232 = path.getOrDefault("packetCaptureName")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "packetCaptureName", valid_564232
  var valid_564233 = path.getOrDefault("networkWatcherName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "networkWatcherName", valid_564233
  var valid_564234 = path.getOrDefault("subscriptionId")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "subscriptionId", valid_564234
  var valid_564235 = path.getOrDefault("resourceGroupName")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "resourceGroupName", valid_564235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564236 = query.getOrDefault("api-version")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "api-version", valid_564236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that define the create packet capture operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564238: Call_PacketCapturesCreate_564229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create and start a packet capture on the specified VM.
  ## 
  let valid = call_564238.validator(path, query, header, formData, body)
  let scheme = call_564238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564238.url(scheme.get, call_564238.host, call_564238.base,
                         call_564238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564238, url, valid)

proc call*(call_564239: Call_PacketCapturesCreate_564229;
          packetCaptureName: string; apiVersion: string; networkWatcherName: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## packetCapturesCreate
  ## Create and start a packet capture on the specified VM.
  ##   packetCaptureName: string (required)
  ##                    : The name of the packet capture session.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters that define the create packet capture operation.
  var path_564240 = newJObject()
  var query_564241 = newJObject()
  var body_564242 = newJObject()
  add(path_564240, "packetCaptureName", newJString(packetCaptureName))
  add(query_564241, "api-version", newJString(apiVersion))
  add(path_564240, "networkWatcherName", newJString(networkWatcherName))
  add(path_564240, "subscriptionId", newJString(subscriptionId))
  add(path_564240, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564242 = parameters
  result = call_564239.call(path_564240, query_564241, nil, nil, body_564242)

var packetCapturesCreate* = Call_PacketCapturesCreate_564229(
    name: "packetCapturesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}",
    validator: validate_PacketCapturesCreate_564230, base: "",
    url: url_PacketCapturesCreate_564231, schemes: {Scheme.Https})
type
  Call_PacketCapturesGet_564217 = ref object of OpenApiRestCall_563556
proc url_PacketCapturesGet_564219(protocol: Scheme; host: string; base: string;
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
  assert "packetCaptureName" in path,
        "`packetCaptureName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/packetCaptures/"),
               (kind: VariableSegment, value: "packetCaptureName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PacketCapturesGet_564218(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a packet capture session by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packetCaptureName: JString (required)
  ##                    : The name of the packet capture session.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packetCaptureName` field"
  var valid_564220 = path.getOrDefault("packetCaptureName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "packetCaptureName", valid_564220
  var valid_564221 = path.getOrDefault("networkWatcherName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "networkWatcherName", valid_564221
  var valid_564222 = path.getOrDefault("subscriptionId")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "subscriptionId", valid_564222
  var valid_564223 = path.getOrDefault("resourceGroupName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "resourceGroupName", valid_564223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564224 = query.getOrDefault("api-version")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "api-version", valid_564224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564225: Call_PacketCapturesGet_564217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a packet capture session by name.
  ## 
  let valid = call_564225.validator(path, query, header, formData, body)
  let scheme = call_564225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564225.url(scheme.get, call_564225.host, call_564225.base,
                         call_564225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564225, url, valid)

proc call*(call_564226: Call_PacketCapturesGet_564217; packetCaptureName: string;
          apiVersion: string; networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## packetCapturesGet
  ## Gets a packet capture session by name.
  ##   packetCaptureName: string (required)
  ##                    : The name of the packet capture session.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564227 = newJObject()
  var query_564228 = newJObject()
  add(path_564227, "packetCaptureName", newJString(packetCaptureName))
  add(query_564228, "api-version", newJString(apiVersion))
  add(path_564227, "networkWatcherName", newJString(networkWatcherName))
  add(path_564227, "subscriptionId", newJString(subscriptionId))
  add(path_564227, "resourceGroupName", newJString(resourceGroupName))
  result = call_564226.call(path_564227, query_564228, nil, nil, nil)

var packetCapturesGet* = Call_PacketCapturesGet_564217(name: "packetCapturesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}",
    validator: validate_PacketCapturesGet_564218, base: "",
    url: url_PacketCapturesGet_564219, schemes: {Scheme.Https})
type
  Call_PacketCapturesDelete_564243 = ref object of OpenApiRestCall_563556
proc url_PacketCapturesDelete_564245(protocol: Scheme; host: string; base: string;
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
  assert "packetCaptureName" in path,
        "`packetCaptureName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/packetCaptures/"),
               (kind: VariableSegment, value: "packetCaptureName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PacketCapturesDelete_564244(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified packet capture session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packetCaptureName: JString (required)
  ##                    : The name of the packet capture session.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packetCaptureName` field"
  var valid_564246 = path.getOrDefault("packetCaptureName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "packetCaptureName", valid_564246
  var valid_564247 = path.getOrDefault("networkWatcherName")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "networkWatcherName", valid_564247
  var valid_564248 = path.getOrDefault("subscriptionId")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "subscriptionId", valid_564248
  var valid_564249 = path.getOrDefault("resourceGroupName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "resourceGroupName", valid_564249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564250 = query.getOrDefault("api-version")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "api-version", valid_564250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564251: Call_PacketCapturesDelete_564243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified packet capture session.
  ## 
  let valid = call_564251.validator(path, query, header, formData, body)
  let scheme = call_564251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564251.url(scheme.get, call_564251.host, call_564251.base,
                         call_564251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564251, url, valid)

proc call*(call_564252: Call_PacketCapturesDelete_564243;
          packetCaptureName: string; apiVersion: string; networkWatcherName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## packetCapturesDelete
  ## Deletes the specified packet capture session.
  ##   packetCaptureName: string (required)
  ##                    : The name of the packet capture session.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564253 = newJObject()
  var query_564254 = newJObject()
  add(path_564253, "packetCaptureName", newJString(packetCaptureName))
  add(query_564254, "api-version", newJString(apiVersion))
  add(path_564253, "networkWatcherName", newJString(networkWatcherName))
  add(path_564253, "subscriptionId", newJString(subscriptionId))
  add(path_564253, "resourceGroupName", newJString(resourceGroupName))
  result = call_564252.call(path_564253, query_564254, nil, nil, nil)

var packetCapturesDelete* = Call_PacketCapturesDelete_564243(
    name: "packetCapturesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}",
    validator: validate_PacketCapturesDelete_564244, base: "",
    url: url_PacketCapturesDelete_564245, schemes: {Scheme.Https})
type
  Call_PacketCapturesGetStatus_564255 = ref object of OpenApiRestCall_563556
proc url_PacketCapturesGetStatus_564257(protocol: Scheme; host: string; base: string;
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
  assert "packetCaptureName" in path,
        "`packetCaptureName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/packetCaptures/"),
               (kind: VariableSegment, value: "packetCaptureName"),
               (kind: ConstantSegment, value: "/queryStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PacketCapturesGetStatus_564256(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query the status of a running packet capture session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packetCaptureName: JString (required)
  ##                    : The name given to the packet capture session.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packetCaptureName` field"
  var valid_564258 = path.getOrDefault("packetCaptureName")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "packetCaptureName", valid_564258
  var valid_564259 = path.getOrDefault("networkWatcherName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "networkWatcherName", valid_564259
  var valid_564260 = path.getOrDefault("subscriptionId")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "subscriptionId", valid_564260
  var valid_564261 = path.getOrDefault("resourceGroupName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "resourceGroupName", valid_564261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564262 = query.getOrDefault("api-version")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "api-version", valid_564262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564263: Call_PacketCapturesGetStatus_564255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the status of a running packet capture session.
  ## 
  let valid = call_564263.validator(path, query, header, formData, body)
  let scheme = call_564263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564263.url(scheme.get, call_564263.host, call_564263.base,
                         call_564263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564263, url, valid)

proc call*(call_564264: Call_PacketCapturesGetStatus_564255;
          packetCaptureName: string; apiVersion: string; networkWatcherName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## packetCapturesGetStatus
  ## Query the status of a running packet capture session.
  ##   packetCaptureName: string (required)
  ##                    : The name given to the packet capture session.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564265 = newJObject()
  var query_564266 = newJObject()
  add(path_564265, "packetCaptureName", newJString(packetCaptureName))
  add(query_564266, "api-version", newJString(apiVersion))
  add(path_564265, "networkWatcherName", newJString(networkWatcherName))
  add(path_564265, "subscriptionId", newJString(subscriptionId))
  add(path_564265, "resourceGroupName", newJString(resourceGroupName))
  result = call_564264.call(path_564265, query_564266, nil, nil, nil)

var packetCapturesGetStatus* = Call_PacketCapturesGetStatus_564255(
    name: "packetCapturesGetStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}/queryStatus",
    validator: validate_PacketCapturesGetStatus_564256, base: "",
    url: url_PacketCapturesGetStatus_564257, schemes: {Scheme.Https})
type
  Call_PacketCapturesStop_564267 = ref object of OpenApiRestCall_563556
proc url_PacketCapturesStop_564269(protocol: Scheme; host: string; base: string;
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
  assert "packetCaptureName" in path,
        "`packetCaptureName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/packetCaptures/"),
               (kind: VariableSegment, value: "packetCaptureName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PacketCapturesStop_564268(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Stops a specified packet capture session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packetCaptureName: JString (required)
  ##                    : The name of the packet capture session.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packetCaptureName` field"
  var valid_564270 = path.getOrDefault("packetCaptureName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "packetCaptureName", valid_564270
  var valid_564271 = path.getOrDefault("networkWatcherName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "networkWatcherName", valid_564271
  var valid_564272 = path.getOrDefault("subscriptionId")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "subscriptionId", valid_564272
  var valid_564273 = path.getOrDefault("resourceGroupName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "resourceGroupName", valid_564273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564274 = query.getOrDefault("api-version")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "api-version", valid_564274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564275: Call_PacketCapturesStop_564267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a specified packet capture session.
  ## 
  let valid = call_564275.validator(path, query, header, formData, body)
  let scheme = call_564275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564275.url(scheme.get, call_564275.host, call_564275.base,
                         call_564275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564275, url, valid)

proc call*(call_564276: Call_PacketCapturesStop_564267; packetCaptureName: string;
          apiVersion: string; networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## packetCapturesStop
  ## Stops a specified packet capture session.
  ##   packetCaptureName: string (required)
  ##                    : The name of the packet capture session.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564277 = newJObject()
  var query_564278 = newJObject()
  add(path_564277, "packetCaptureName", newJString(packetCaptureName))
  add(query_564278, "api-version", newJString(apiVersion))
  add(path_564277, "networkWatcherName", newJString(networkWatcherName))
  add(path_564277, "subscriptionId", newJString(subscriptionId))
  add(path_564277, "resourceGroupName", newJString(resourceGroupName))
  result = call_564276.call(path_564277, query_564278, nil, nil, nil)

var packetCapturesStop* = Call_PacketCapturesStop_564267(
    name: "packetCapturesStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}/stop",
    validator: validate_PacketCapturesStop_564268, base: "",
    url: url_PacketCapturesStop_564269, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetFlowLogStatus_564279 = ref object of OpenApiRestCall_563556
proc url_NetworkWatchersGetFlowLogStatus_564281(protocol: Scheme; host: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/queryFlowLogStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkWatchersGetFlowLogStatus_564280(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries status of flow log on a specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher resource.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the network watcher resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564282 = path.getOrDefault("networkWatcherName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "networkWatcherName", valid_564282
  var valid_564283 = path.getOrDefault("subscriptionId")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "subscriptionId", valid_564283
  var valid_564284 = path.getOrDefault("resourceGroupName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "resourceGroupName", valid_564284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564285 = query.getOrDefault("api-version")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "api-version", valid_564285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that define a resource to query flow log status.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564287: Call_NetworkWatchersGetFlowLogStatus_564279;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries status of flow log on a specified resource.
  ## 
  let valid = call_564287.validator(path, query, header, formData, body)
  let scheme = call_564287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564287.url(scheme.get, call_564287.host, call_564287.base,
                         call_564287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564287, url, valid)

proc call*(call_564288: Call_NetworkWatchersGetFlowLogStatus_564279;
          apiVersion: string; networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetFlowLogStatus
  ## Queries status of flow log on a specified resource.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher resource.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the network watcher resource group.
  ##   parameters: JObject (required)
  ##             : Parameters that define a resource to query flow log status.
  var path_564289 = newJObject()
  var query_564290 = newJObject()
  var body_564291 = newJObject()
  add(query_564290, "api-version", newJString(apiVersion))
  add(path_564289, "networkWatcherName", newJString(networkWatcherName))
  add(path_564289, "subscriptionId", newJString(subscriptionId))
  add(path_564289, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564291 = parameters
  result = call_564288.call(path_564289, query_564290, nil, nil, body_564291)

var networkWatchersGetFlowLogStatus* = Call_NetworkWatchersGetFlowLogStatus_564279(
    name: "networkWatchersGetFlowLogStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/queryFlowLogStatus",
    validator: validate_NetworkWatchersGetFlowLogStatus_564280, base: "",
    url: url_NetworkWatchersGetFlowLogStatus_564281, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetTroubleshootingResult_564292 = ref object of OpenApiRestCall_563556
proc url_NetworkWatchersGetTroubleshootingResult_564294(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/queryTroubleshootResult")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkWatchersGetTroubleshootingResult_564293(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the last completed troubleshooting result on a specified resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher resource.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564295 = path.getOrDefault("networkWatcherName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "networkWatcherName", valid_564295
  var valid_564296 = path.getOrDefault("subscriptionId")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "subscriptionId", valid_564296
  var valid_564297 = path.getOrDefault("resourceGroupName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "resourceGroupName", valid_564297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564298 = query.getOrDefault("api-version")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "api-version", valid_564298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that define the resource to query the troubleshooting result.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564300: Call_NetworkWatchersGetTroubleshootingResult_564292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the last completed troubleshooting result on a specified resource
  ## 
  let valid = call_564300.validator(path, query, header, formData, body)
  let scheme = call_564300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564300.url(scheme.get, call_564300.host, call_564300.base,
                         call_564300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564300, url, valid)

proc call*(call_564301: Call_NetworkWatchersGetTroubleshootingResult_564292;
          apiVersion: string; networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetTroubleshootingResult
  ## Get the last completed troubleshooting result on a specified resource
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher resource.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters that define the resource to query the troubleshooting result.
  var path_564302 = newJObject()
  var query_564303 = newJObject()
  var body_564304 = newJObject()
  add(query_564303, "api-version", newJString(apiVersion))
  add(path_564302, "networkWatcherName", newJString(networkWatcherName))
  add(path_564302, "subscriptionId", newJString(subscriptionId))
  add(path_564302, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564304 = parameters
  result = call_564301.call(path_564302, query_564303, nil, nil, body_564304)

var networkWatchersGetTroubleshootingResult* = Call_NetworkWatchersGetTroubleshootingResult_564292(
    name: "networkWatchersGetTroubleshootingResult", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/queryTroubleshootResult",
    validator: validate_NetworkWatchersGetTroubleshootingResult_564293, base: "",
    url: url_NetworkWatchersGetTroubleshootingResult_564294,
    schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetVMSecurityRules_564305 = ref object of OpenApiRestCall_563556
proc url_NetworkWatchersGetVMSecurityRules_564307(protocol: Scheme; host: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/securityGroupView")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkWatchersGetVMSecurityRules_564306(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the configured and effective security group rules on the specified VM.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564308 = path.getOrDefault("networkWatcherName")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "networkWatcherName", valid_564308
  var valid_564309 = path.getOrDefault("subscriptionId")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "subscriptionId", valid_564309
  var valid_564310 = path.getOrDefault("resourceGroupName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "resourceGroupName", valid_564310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564311 = query.getOrDefault("api-version")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "api-version", valid_564311
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that define the VM to check security groups for.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564313: Call_NetworkWatchersGetVMSecurityRules_564305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the configured and effective security group rules on the specified VM.
  ## 
  let valid = call_564313.validator(path, query, header, formData, body)
  let scheme = call_564313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564313.url(scheme.get, call_564313.host, call_564313.base,
                         call_564313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564313, url, valid)

proc call*(call_564314: Call_NetworkWatchersGetVMSecurityRules_564305;
          apiVersion: string; networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetVMSecurityRules
  ## Gets the configured and effective security group rules on the specified VM.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters that define the VM to check security groups for.
  var path_564315 = newJObject()
  var query_564316 = newJObject()
  var body_564317 = newJObject()
  add(query_564316, "api-version", newJString(apiVersion))
  add(path_564315, "networkWatcherName", newJString(networkWatcherName))
  add(path_564315, "subscriptionId", newJString(subscriptionId))
  add(path_564315, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564317 = parameters
  result = call_564314.call(path_564315, query_564316, nil, nil, body_564317)

var networkWatchersGetVMSecurityRules* = Call_NetworkWatchersGetVMSecurityRules_564305(
    name: "networkWatchersGetVMSecurityRules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/securityGroupView",
    validator: validate_NetworkWatchersGetVMSecurityRules_564306, base: "",
    url: url_NetworkWatchersGetVMSecurityRules_564307, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetTopology_564318 = ref object of OpenApiRestCall_563556
proc url_NetworkWatchersGetTopology_564320(protocol: Scheme; host: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/topology")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkWatchersGetTopology_564319(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the current network topology by resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564321 = path.getOrDefault("networkWatcherName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "networkWatcherName", valid_564321
  var valid_564322 = path.getOrDefault("subscriptionId")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "subscriptionId", valid_564322
  var valid_564323 = path.getOrDefault("resourceGroupName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "resourceGroupName", valid_564323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564324 = query.getOrDefault("api-version")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "api-version", valid_564324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that define the representation of topology.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564326: Call_NetworkWatchersGetTopology_564318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current network topology by resource group.
  ## 
  let valid = call_564326.validator(path, query, header, formData, body)
  let scheme = call_564326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564326.url(scheme.get, call_564326.host, call_564326.base,
                         call_564326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564326, url, valid)

proc call*(call_564327: Call_NetworkWatchersGetTopology_564318; apiVersion: string;
          networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetTopology
  ## Gets the current network topology by resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters that define the representation of topology.
  var path_564328 = newJObject()
  var query_564329 = newJObject()
  var body_564330 = newJObject()
  add(query_564329, "api-version", newJString(apiVersion))
  add(path_564328, "networkWatcherName", newJString(networkWatcherName))
  add(path_564328, "subscriptionId", newJString(subscriptionId))
  add(path_564328, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564330 = parameters
  result = call_564327.call(path_564328, query_564329, nil, nil, body_564330)

var networkWatchersGetTopology* = Call_NetworkWatchersGetTopology_564318(
    name: "networkWatchersGetTopology", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/topology",
    validator: validate_NetworkWatchersGetTopology_564319, base: "",
    url: url_NetworkWatchersGetTopology_564320, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetTroubleshooting_564331 = ref object of OpenApiRestCall_563556
proc url_NetworkWatchersGetTroubleshooting_564333(protocol: Scheme; host: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"),
               (kind: ConstantSegment, value: "/troubleshoot")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkWatchersGetTroubleshooting_564332(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Initiate troubleshooting on a specified resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher resource.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564334 = path.getOrDefault("networkWatcherName")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "networkWatcherName", valid_564334
  var valid_564335 = path.getOrDefault("subscriptionId")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "subscriptionId", valid_564335
  var valid_564336 = path.getOrDefault("resourceGroupName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "resourceGroupName", valid_564336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564337 = query.getOrDefault("api-version")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "api-version", valid_564337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that define the resource to troubleshoot.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564339: Call_NetworkWatchersGetTroubleshooting_564331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Initiate troubleshooting on a specified resource
  ## 
  let valid = call_564339.validator(path, query, header, formData, body)
  let scheme = call_564339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564339.url(scheme.get, call_564339.host, call_564339.base,
                         call_564339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564339, url, valid)

proc call*(call_564340: Call_NetworkWatchersGetTroubleshooting_564331;
          apiVersion: string; networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetTroubleshooting
  ## Initiate troubleshooting on a specified resource
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher resource.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters that define the resource to troubleshoot.
  var path_564341 = newJObject()
  var query_564342 = newJObject()
  var body_564343 = newJObject()
  add(query_564342, "api-version", newJString(apiVersion))
  add(path_564341, "networkWatcherName", newJString(networkWatcherName))
  add(path_564341, "subscriptionId", newJString(subscriptionId))
  add(path_564341, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564343 = parameters
  result = call_564340.call(path_564341, query_564342, nil, nil, body_564343)

var networkWatchersGetTroubleshooting* = Call_NetworkWatchersGetTroubleshooting_564331(
    name: "networkWatchersGetTroubleshooting", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/troubleshoot",
    validator: validate_NetworkWatchersGetTroubleshooting_564332, base: "",
    url: url_NetworkWatchersGetTroubleshooting_564333, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
