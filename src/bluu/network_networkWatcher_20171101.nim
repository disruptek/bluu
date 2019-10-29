
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2017-11-01
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

  OpenApiRestCall_563565 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563565](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563565): Option[Scheme] {.used.} =
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
  Call_NetworkWatchersListAll_563787 = ref object of OpenApiRestCall_563565
proc url_NetworkWatchersListAll_563789(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkWatchersListAll_563788(path: JsonNode; query: JsonNode;
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
  var valid_563964 = path.getOrDefault("subscriptionId")
  valid_563964 = validateParameter(valid_563964, JString, required = true,
                                 default = nil)
  if valid_563964 != nil:
    section.add "subscriptionId", valid_563964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563965 = query.getOrDefault("api-version")
  valid_563965 = validateParameter(valid_563965, JString, required = true,
                                 default = nil)
  if valid_563965 != nil:
    section.add "api-version", valid_563965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563988: Call_NetworkWatchersListAll_563787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all network watchers by subscription.
  ## 
  let valid = call_563988.validator(path, query, header, formData, body)
  let scheme = call_563988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563988.url(scheme.get, call_563988.host, call_563988.base,
                         call_563988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563988, url, valid)

proc call*(call_564059: Call_NetworkWatchersListAll_563787; apiVersion: string;
          subscriptionId: string): Recallable =
  ## networkWatchersListAll
  ## Gets all network watchers by subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564060 = newJObject()
  var query_564062 = newJObject()
  add(query_564062, "api-version", newJString(apiVersion))
  add(path_564060, "subscriptionId", newJString(subscriptionId))
  result = call_564059.call(path_564060, query_564062, nil, nil, nil)

var networkWatchersListAll* = Call_NetworkWatchersListAll_563787(
    name: "networkWatchersListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/networkWatchers",
    validator: validate_NetworkWatchersListAll_563788, base: "",
    url: url_NetworkWatchersListAll_563789, schemes: {Scheme.Https})
type
  Call_NetworkWatchersList_564101 = ref object of OpenApiRestCall_563565
proc url_NetworkWatchersList_564103(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkWatchersList_564102(path: JsonNode; query: JsonNode;
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
  var valid_564104 = path.getOrDefault("subscriptionId")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "subscriptionId", valid_564104
  var valid_564105 = path.getOrDefault("resourceGroupName")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "resourceGroupName", valid_564105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564106 = query.getOrDefault("api-version")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "api-version", valid_564106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564107: Call_NetworkWatchersList_564101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all network watchers by resource group.
  ## 
  let valid = call_564107.validator(path, query, header, formData, body)
  let scheme = call_564107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564107.url(scheme.get, call_564107.host, call_564107.base,
                         call_564107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564107, url, valid)

proc call*(call_564108: Call_NetworkWatchersList_564101; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## networkWatchersList
  ## Gets all network watchers by resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564109 = newJObject()
  var query_564110 = newJObject()
  add(query_564110, "api-version", newJString(apiVersion))
  add(path_564109, "subscriptionId", newJString(subscriptionId))
  add(path_564109, "resourceGroupName", newJString(resourceGroupName))
  result = call_564108.call(path_564109, query_564110, nil, nil, nil)

var networkWatchersList* = Call_NetworkWatchersList_564101(
    name: "networkWatchersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers",
    validator: validate_NetworkWatchersList_564102, base: "",
    url: url_NetworkWatchersList_564103, schemes: {Scheme.Https})
type
  Call_NetworkWatchersCreateOrUpdate_564122 = ref object of OpenApiRestCall_563565
proc url_NetworkWatchersCreateOrUpdate_564124(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersCreateOrUpdate_564123(path: JsonNode; query: JsonNode;
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
  var valid_564142 = path.getOrDefault("networkWatcherName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "networkWatcherName", valid_564142
  var valid_564143 = path.getOrDefault("subscriptionId")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "subscriptionId", valid_564143
  var valid_564144 = path.getOrDefault("resourceGroupName")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "resourceGroupName", valid_564144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564145 = query.getOrDefault("api-version")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "api-version", valid_564145
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

proc call*(call_564147: Call_NetworkWatchersCreateOrUpdate_564122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a network watcher in the specified resource group.
  ## 
  let valid = call_564147.validator(path, query, header, formData, body)
  let scheme = call_564147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564147.url(scheme.get, call_564147.host, call_564147.base,
                         call_564147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564147, url, valid)

proc call*(call_564148: Call_NetworkWatchersCreateOrUpdate_564122;
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
  var path_564149 = newJObject()
  var query_564150 = newJObject()
  var body_564151 = newJObject()
  add(query_564150, "api-version", newJString(apiVersion))
  add(path_564149, "networkWatcherName", newJString(networkWatcherName))
  add(path_564149, "subscriptionId", newJString(subscriptionId))
  add(path_564149, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564151 = parameters
  result = call_564148.call(path_564149, query_564150, nil, nil, body_564151)

var networkWatchersCreateOrUpdate* = Call_NetworkWatchersCreateOrUpdate_564122(
    name: "networkWatchersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}",
    validator: validate_NetworkWatchersCreateOrUpdate_564123, base: "",
    url: url_NetworkWatchersCreateOrUpdate_564124, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGet_564111 = ref object of OpenApiRestCall_563565
proc url_NetworkWatchersGet_564113(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkWatchersGet_564112(path: JsonNode; query: JsonNode;
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
  var valid_564114 = path.getOrDefault("networkWatcherName")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "networkWatcherName", valid_564114
  var valid_564115 = path.getOrDefault("subscriptionId")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "subscriptionId", valid_564115
  var valid_564116 = path.getOrDefault("resourceGroupName")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "resourceGroupName", valid_564116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564117 = query.getOrDefault("api-version")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "api-version", valid_564117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564118: Call_NetworkWatchersGet_564111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified network watcher by resource group.
  ## 
  let valid = call_564118.validator(path, query, header, formData, body)
  let scheme = call_564118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564118.url(scheme.get, call_564118.host, call_564118.base,
                         call_564118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564118, url, valid)

proc call*(call_564119: Call_NetworkWatchersGet_564111; apiVersion: string;
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
  var path_564120 = newJObject()
  var query_564121 = newJObject()
  add(query_564121, "api-version", newJString(apiVersion))
  add(path_564120, "networkWatcherName", newJString(networkWatcherName))
  add(path_564120, "subscriptionId", newJString(subscriptionId))
  add(path_564120, "resourceGroupName", newJString(resourceGroupName))
  result = call_564119.call(path_564120, query_564121, nil, nil, nil)

var networkWatchersGet* = Call_NetworkWatchersGet_564111(
    name: "networkWatchersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}",
    validator: validate_NetworkWatchersGet_564112, base: "",
    url: url_NetworkWatchersGet_564113, schemes: {Scheme.Https})
type
  Call_NetworkWatchersUpdateTags_564163 = ref object of OpenApiRestCall_563565
proc url_NetworkWatchersUpdateTags_564165(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersUpdateTags_564164(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a network watcher tags.
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
  var valid_564166 = path.getOrDefault("networkWatcherName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "networkWatcherName", valid_564166
  var valid_564167 = path.getOrDefault("subscriptionId")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "subscriptionId", valid_564167
  var valid_564168 = path.getOrDefault("resourceGroupName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "resourceGroupName", valid_564168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564169 = query.getOrDefault("api-version")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "api-version", valid_564169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update network watcher tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564171: Call_NetworkWatchersUpdateTags_564163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a network watcher tags.
  ## 
  let valid = call_564171.validator(path, query, header, formData, body)
  let scheme = call_564171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564171.url(scheme.get, call_564171.host, call_564171.base,
                         call_564171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564171, url, valid)

proc call*(call_564172: Call_NetworkWatchersUpdateTags_564163; apiVersion: string;
          networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## networkWatchersUpdateTags
  ## Updates a network watcher tags.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update network watcher tags.
  var path_564173 = newJObject()
  var query_564174 = newJObject()
  var body_564175 = newJObject()
  add(query_564174, "api-version", newJString(apiVersion))
  add(path_564173, "networkWatcherName", newJString(networkWatcherName))
  add(path_564173, "subscriptionId", newJString(subscriptionId))
  add(path_564173, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564175 = parameters
  result = call_564172.call(path_564173, query_564174, nil, nil, body_564175)

var networkWatchersUpdateTags* = Call_NetworkWatchersUpdateTags_564163(
    name: "networkWatchersUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}",
    validator: validate_NetworkWatchersUpdateTags_564164, base: "",
    url: url_NetworkWatchersUpdateTags_564165, schemes: {Scheme.Https})
type
  Call_NetworkWatchersDelete_564152 = ref object of OpenApiRestCall_563565
proc url_NetworkWatchersDelete_564154(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkWatchersDelete_564153(path: JsonNode; query: JsonNode;
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
  var valid_564155 = path.getOrDefault("networkWatcherName")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "networkWatcherName", valid_564155
  var valid_564156 = path.getOrDefault("subscriptionId")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "subscriptionId", valid_564156
  var valid_564157 = path.getOrDefault("resourceGroupName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "resourceGroupName", valid_564157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564158 = query.getOrDefault("api-version")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "api-version", valid_564158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564159: Call_NetworkWatchersDelete_564152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified network watcher resource.
  ## 
  let valid = call_564159.validator(path, query, header, formData, body)
  let scheme = call_564159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564159.url(scheme.get, call_564159.host, call_564159.base,
                         call_564159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564159, url, valid)

proc call*(call_564160: Call_NetworkWatchersDelete_564152; apiVersion: string;
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
  var path_564161 = newJObject()
  var query_564162 = newJObject()
  add(query_564162, "api-version", newJString(apiVersion))
  add(path_564161, "networkWatcherName", newJString(networkWatcherName))
  add(path_564161, "subscriptionId", newJString(subscriptionId))
  add(path_564161, "resourceGroupName", newJString(resourceGroupName))
  result = call_564160.call(path_564161, query_564162, nil, nil, nil)

var networkWatchersDelete* = Call_NetworkWatchersDelete_564152(
    name: "networkWatchersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}",
    validator: validate_NetworkWatchersDelete_564153, base: "",
    url: url_NetworkWatchersDelete_564154, schemes: {Scheme.Https})
type
  Call_NetworkWatchersListAvailableProviders_564176 = ref object of OpenApiRestCall_563565
proc url_NetworkWatchersListAvailableProviders_564178(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/availableProvidersList")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkWatchersListAvailableProviders_564177(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all available internet service providers for a specified Azure region.
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
  var valid_564179 = path.getOrDefault("networkWatcherName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "networkWatcherName", valid_564179
  var valid_564180 = path.getOrDefault("subscriptionId")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "subscriptionId", valid_564180
  var valid_564181 = path.getOrDefault("resourceGroupName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "resourceGroupName", valid_564181
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
  ##   parameters: JObject (required)
  ##             : Parameters that scope the list of available providers.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564184: Call_NetworkWatchersListAvailableProviders_564176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available internet service providers for a specified Azure region.
  ## 
  let valid = call_564184.validator(path, query, header, formData, body)
  let scheme = call_564184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564184.url(scheme.get, call_564184.host, call_564184.base,
                         call_564184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564184, url, valid)

proc call*(call_564185: Call_NetworkWatchersListAvailableProviders_564176;
          apiVersion: string; networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## networkWatchersListAvailableProviders
  ## Lists all available internet service providers for a specified Azure region.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher resource.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the network watcher resource group.
  ##   parameters: JObject (required)
  ##             : Parameters that scope the list of available providers.
  var path_564186 = newJObject()
  var query_564187 = newJObject()
  var body_564188 = newJObject()
  add(query_564187, "api-version", newJString(apiVersion))
  add(path_564186, "networkWatcherName", newJString(networkWatcherName))
  add(path_564186, "subscriptionId", newJString(subscriptionId))
  add(path_564186, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564188 = parameters
  result = call_564185.call(path_564186, query_564187, nil, nil, body_564188)

var networkWatchersListAvailableProviders* = Call_NetworkWatchersListAvailableProviders_564176(
    name: "networkWatchersListAvailableProviders", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/availableProvidersList",
    validator: validate_NetworkWatchersListAvailableProviders_564177, base: "",
    url: url_NetworkWatchersListAvailableProviders_564178, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetAzureReachabilityReport_564189 = ref object of OpenApiRestCall_563565
proc url_NetworkWatchersGetAzureReachabilityReport_564191(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/azureReachabilityReport")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkWatchersGetAzureReachabilityReport_564190(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the relative latency score for internet service providers from a specified location to Azure regions.
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
  var valid_564192 = path.getOrDefault("networkWatcherName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "networkWatcherName", valid_564192
  var valid_564193 = path.getOrDefault("subscriptionId")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "subscriptionId", valid_564193
  var valid_564194 = path.getOrDefault("resourceGroupName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "resourceGroupName", valid_564194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564195 = query.getOrDefault("api-version")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "api-version", valid_564195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that determine Azure reachability report configuration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564197: Call_NetworkWatchersGetAzureReachabilityReport_564189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the relative latency score for internet service providers from a specified location to Azure regions.
  ## 
  let valid = call_564197.validator(path, query, header, formData, body)
  let scheme = call_564197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564197.url(scheme.get, call_564197.host, call_564197.base,
                         call_564197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564197, url, valid)

proc call*(call_564198: Call_NetworkWatchersGetAzureReachabilityReport_564189;
          apiVersion: string; networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetAzureReachabilityReport
  ## Gets the relative latency score for internet service providers from a specified location to Azure regions.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher resource.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the network watcher resource group.
  ##   parameters: JObject (required)
  ##             : Parameters that determine Azure reachability report configuration.
  var path_564199 = newJObject()
  var query_564200 = newJObject()
  var body_564201 = newJObject()
  add(query_564200, "api-version", newJString(apiVersion))
  add(path_564199, "networkWatcherName", newJString(networkWatcherName))
  add(path_564199, "subscriptionId", newJString(subscriptionId))
  add(path_564199, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564201 = parameters
  result = call_564198.call(path_564199, query_564200, nil, nil, body_564201)

var networkWatchersGetAzureReachabilityReport* = Call_NetworkWatchersGetAzureReachabilityReport_564189(
    name: "networkWatchersGetAzureReachabilityReport", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/azureReachabilityReport",
    validator: validate_NetworkWatchersGetAzureReachabilityReport_564190,
    base: "", url: url_NetworkWatchersGetAzureReachabilityReport_564191,
    schemes: {Scheme.Https})
type
  Call_NetworkWatchersSetFlowLogConfiguration_564202 = ref object of OpenApiRestCall_563565
proc url_NetworkWatchersSetFlowLogConfiguration_564204(protocol: Scheme;
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

proc validate_NetworkWatchersSetFlowLogConfiguration_564203(path: JsonNode;
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
  var valid_564205 = path.getOrDefault("networkWatcherName")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "networkWatcherName", valid_564205
  var valid_564206 = path.getOrDefault("subscriptionId")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "subscriptionId", valid_564206
  var valid_564207 = path.getOrDefault("resourceGroupName")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "resourceGroupName", valid_564207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564208 = query.getOrDefault("api-version")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "api-version", valid_564208
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

proc call*(call_564210: Call_NetworkWatchersSetFlowLogConfiguration_564202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Configures flow log on a specified resource.
  ## 
  let valid = call_564210.validator(path, query, header, formData, body)
  let scheme = call_564210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564210.url(scheme.get, call_564210.host, call_564210.base,
                         call_564210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564210, url, valid)

proc call*(call_564211: Call_NetworkWatchersSetFlowLogConfiguration_564202;
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
  var path_564212 = newJObject()
  var query_564213 = newJObject()
  var body_564214 = newJObject()
  add(query_564213, "api-version", newJString(apiVersion))
  add(path_564212, "networkWatcherName", newJString(networkWatcherName))
  add(path_564212, "subscriptionId", newJString(subscriptionId))
  add(path_564212, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564214 = parameters
  result = call_564211.call(path_564212, query_564213, nil, nil, body_564214)

var networkWatchersSetFlowLogConfiguration* = Call_NetworkWatchersSetFlowLogConfiguration_564202(
    name: "networkWatchersSetFlowLogConfiguration", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/configureFlowLog",
    validator: validate_NetworkWatchersSetFlowLogConfiguration_564203, base: "",
    url: url_NetworkWatchersSetFlowLogConfiguration_564204,
    schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsList_564215 = ref object of OpenApiRestCall_563565
proc url_ConnectionMonitorsList_564217(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectionMonitorsList_564216(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all connection monitors for the specified Network Watcher.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing Network Watcher.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564218 = path.getOrDefault("networkWatcherName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "networkWatcherName", valid_564218
  var valid_564219 = path.getOrDefault("subscriptionId")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "subscriptionId", valid_564219
  var valid_564220 = path.getOrDefault("resourceGroupName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "resourceGroupName", valid_564220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564221 = query.getOrDefault("api-version")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "api-version", valid_564221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564222: Call_ConnectionMonitorsList_564215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all connection monitors for the specified Network Watcher.
  ## 
  let valid = call_564222.validator(path, query, header, formData, body)
  let scheme = call_564222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564222.url(scheme.get, call_564222.host, call_564222.base,
                         call_564222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564222, url, valid)

proc call*(call_564223: Call_ConnectionMonitorsList_564215; apiVersion: string;
          networkWatcherName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## connectionMonitorsList
  ## Lists all connection monitors for the specified Network Watcher.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing Network Watcher.
  var path_564224 = newJObject()
  var query_564225 = newJObject()
  add(query_564225, "api-version", newJString(apiVersion))
  add(path_564224, "networkWatcherName", newJString(networkWatcherName))
  add(path_564224, "subscriptionId", newJString(subscriptionId))
  add(path_564224, "resourceGroupName", newJString(resourceGroupName))
  result = call_564223.call(path_564224, query_564225, nil, nil, nil)

var connectionMonitorsList* = Call_ConnectionMonitorsList_564215(
    name: "connectionMonitorsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors",
    validator: validate_ConnectionMonitorsList_564216, base: "",
    url: url_ConnectionMonitorsList_564217, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsCreateOrUpdate_564238 = ref object of OpenApiRestCall_563565
proc url_ConnectionMonitorsCreateOrUpdate_564240(protocol: Scheme; host: string;
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

proc validate_ConnectionMonitorsCreateOrUpdate_564239(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a connection monitor.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionMonitorName: JString (required)
  ##                        : The name of the connection monitor.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing Network Watcher.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564241 = path.getOrDefault("networkWatcherName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "networkWatcherName", valid_564241
  var valid_564242 = path.getOrDefault("subscriptionId")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "subscriptionId", valid_564242
  var valid_564243 = path.getOrDefault("connectionMonitorName")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "connectionMonitorName", valid_564243
  var valid_564244 = path.getOrDefault("resourceGroupName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "resourceGroupName", valid_564244
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that define the operation to create a connection monitor.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564247: Call_ConnectionMonitorsCreateOrUpdate_564238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a connection monitor.
  ## 
  let valid = call_564247.validator(path, query, header, formData, body)
  let scheme = call_564247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564247.url(scheme.get, call_564247.host, call_564247.base,
                         call_564247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564247, url, valid)

proc call*(call_564248: Call_ConnectionMonitorsCreateOrUpdate_564238;
          apiVersion: string; networkWatcherName: string; subscriptionId: string;
          connectionMonitorName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## connectionMonitorsCreateOrUpdate
  ## Create or update a connection monitor.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionMonitorName: string (required)
  ##                        : The name of the connection monitor.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing Network Watcher.
  ##   parameters: JObject (required)
  ##             : Parameters that define the operation to create a connection monitor.
  var path_564249 = newJObject()
  var query_564250 = newJObject()
  var body_564251 = newJObject()
  add(query_564250, "api-version", newJString(apiVersion))
  add(path_564249, "networkWatcherName", newJString(networkWatcherName))
  add(path_564249, "subscriptionId", newJString(subscriptionId))
  add(path_564249, "connectionMonitorName", newJString(connectionMonitorName))
  add(path_564249, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564251 = parameters
  result = call_564248.call(path_564249, query_564250, nil, nil, body_564251)

var connectionMonitorsCreateOrUpdate* = Call_ConnectionMonitorsCreateOrUpdate_564238(
    name: "connectionMonitorsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}",
    validator: validate_ConnectionMonitorsCreateOrUpdate_564239, base: "",
    url: url_ConnectionMonitorsCreateOrUpdate_564240, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsGet_564226 = ref object of OpenApiRestCall_563565
proc url_ConnectionMonitorsGet_564228(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectionMonitorsGet_564227(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a connection monitor by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionMonitorName: JString (required)
  ##                        : The name of the connection monitor.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing Network Watcher.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564229 = path.getOrDefault("networkWatcherName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "networkWatcherName", valid_564229
  var valid_564230 = path.getOrDefault("subscriptionId")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "subscriptionId", valid_564230
  var valid_564231 = path.getOrDefault("connectionMonitorName")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "connectionMonitorName", valid_564231
  var valid_564232 = path.getOrDefault("resourceGroupName")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "resourceGroupName", valid_564232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564233 = query.getOrDefault("api-version")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "api-version", valid_564233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564234: Call_ConnectionMonitorsGet_564226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a connection monitor by name.
  ## 
  let valid = call_564234.validator(path, query, header, formData, body)
  let scheme = call_564234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564234.url(scheme.get, call_564234.host, call_564234.base,
                         call_564234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564234, url, valid)

proc call*(call_564235: Call_ConnectionMonitorsGet_564226; apiVersion: string;
          networkWatcherName: string; subscriptionId: string;
          connectionMonitorName: string; resourceGroupName: string): Recallable =
  ## connectionMonitorsGet
  ## Gets a connection monitor by name.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionMonitorName: string (required)
  ##                        : The name of the connection monitor.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing Network Watcher.
  var path_564236 = newJObject()
  var query_564237 = newJObject()
  add(query_564237, "api-version", newJString(apiVersion))
  add(path_564236, "networkWatcherName", newJString(networkWatcherName))
  add(path_564236, "subscriptionId", newJString(subscriptionId))
  add(path_564236, "connectionMonitorName", newJString(connectionMonitorName))
  add(path_564236, "resourceGroupName", newJString(resourceGroupName))
  result = call_564235.call(path_564236, query_564237, nil, nil, nil)

var connectionMonitorsGet* = Call_ConnectionMonitorsGet_564226(
    name: "connectionMonitorsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}",
    validator: validate_ConnectionMonitorsGet_564227, base: "",
    url: url_ConnectionMonitorsGet_564228, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsDelete_564252 = ref object of OpenApiRestCall_563565
proc url_ConnectionMonitorsDelete_564254(protocol: Scheme; host: string;
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

proc validate_ConnectionMonitorsDelete_564253(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified connection monitor.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionMonitorName: JString (required)
  ##                        : The name of the connection monitor.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing Network Watcher.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564255 = path.getOrDefault("networkWatcherName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "networkWatcherName", valid_564255
  var valid_564256 = path.getOrDefault("subscriptionId")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "subscriptionId", valid_564256
  var valid_564257 = path.getOrDefault("connectionMonitorName")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "connectionMonitorName", valid_564257
  var valid_564258 = path.getOrDefault("resourceGroupName")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "resourceGroupName", valid_564258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564259 = query.getOrDefault("api-version")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "api-version", valid_564259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564260: Call_ConnectionMonitorsDelete_564252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified connection monitor.
  ## 
  let valid = call_564260.validator(path, query, header, formData, body)
  let scheme = call_564260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564260.url(scheme.get, call_564260.host, call_564260.base,
                         call_564260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564260, url, valid)

proc call*(call_564261: Call_ConnectionMonitorsDelete_564252; apiVersion: string;
          networkWatcherName: string; subscriptionId: string;
          connectionMonitorName: string; resourceGroupName: string): Recallable =
  ## connectionMonitorsDelete
  ## Deletes the specified connection monitor.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionMonitorName: string (required)
  ##                        : The name of the connection monitor.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing Network Watcher.
  var path_564262 = newJObject()
  var query_564263 = newJObject()
  add(query_564263, "api-version", newJString(apiVersion))
  add(path_564262, "networkWatcherName", newJString(networkWatcherName))
  add(path_564262, "subscriptionId", newJString(subscriptionId))
  add(path_564262, "connectionMonitorName", newJString(connectionMonitorName))
  add(path_564262, "resourceGroupName", newJString(resourceGroupName))
  result = call_564261.call(path_564262, query_564263, nil, nil, nil)

var connectionMonitorsDelete* = Call_ConnectionMonitorsDelete_564252(
    name: "connectionMonitorsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}",
    validator: validate_ConnectionMonitorsDelete_564253, base: "",
    url: url_ConnectionMonitorsDelete_564254, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsQuery_564264 = ref object of OpenApiRestCall_563565
proc url_ConnectionMonitorsQuery_564266(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectionMonitorsQuery_564265(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query a snapshot of the most recent connection states.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionMonitorName: JString (required)
  ##                        : The name given to the connection monitor.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing Network Watcher.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564267 = path.getOrDefault("networkWatcherName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "networkWatcherName", valid_564267
  var valid_564268 = path.getOrDefault("subscriptionId")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "subscriptionId", valid_564268
  var valid_564269 = path.getOrDefault("connectionMonitorName")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "connectionMonitorName", valid_564269
  var valid_564270 = path.getOrDefault("resourceGroupName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "resourceGroupName", valid_564270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564271 = query.getOrDefault("api-version")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "api-version", valid_564271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564272: Call_ConnectionMonitorsQuery_564264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query a snapshot of the most recent connection states.
  ## 
  let valid = call_564272.validator(path, query, header, formData, body)
  let scheme = call_564272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564272.url(scheme.get, call_564272.host, call_564272.base,
                         call_564272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564272, url, valid)

proc call*(call_564273: Call_ConnectionMonitorsQuery_564264; apiVersion: string;
          networkWatcherName: string; subscriptionId: string;
          connectionMonitorName: string; resourceGroupName: string): Recallable =
  ## connectionMonitorsQuery
  ## Query a snapshot of the most recent connection states.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionMonitorName: string (required)
  ##                        : The name given to the connection monitor.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing Network Watcher.
  var path_564274 = newJObject()
  var query_564275 = newJObject()
  add(query_564275, "api-version", newJString(apiVersion))
  add(path_564274, "networkWatcherName", newJString(networkWatcherName))
  add(path_564274, "subscriptionId", newJString(subscriptionId))
  add(path_564274, "connectionMonitorName", newJString(connectionMonitorName))
  add(path_564274, "resourceGroupName", newJString(resourceGroupName))
  result = call_564273.call(path_564274, query_564275, nil, nil, nil)

var connectionMonitorsQuery* = Call_ConnectionMonitorsQuery_564264(
    name: "connectionMonitorsQuery", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}/query",
    validator: validate_ConnectionMonitorsQuery_564265, base: "",
    url: url_ConnectionMonitorsQuery_564266, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsStart_564276 = ref object of OpenApiRestCall_563565
proc url_ConnectionMonitorsStart_564278(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectionMonitorsStart_564277(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts the specified connection monitor.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionMonitorName: JString (required)
  ##                        : The name of the connection monitor.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing Network Watcher.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564279 = path.getOrDefault("networkWatcherName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "networkWatcherName", valid_564279
  var valid_564280 = path.getOrDefault("subscriptionId")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "subscriptionId", valid_564280
  var valid_564281 = path.getOrDefault("connectionMonitorName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "connectionMonitorName", valid_564281
  var valid_564282 = path.getOrDefault("resourceGroupName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "resourceGroupName", valid_564282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564283 = query.getOrDefault("api-version")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "api-version", valid_564283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564284: Call_ConnectionMonitorsStart_564276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts the specified connection monitor.
  ## 
  let valid = call_564284.validator(path, query, header, formData, body)
  let scheme = call_564284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564284.url(scheme.get, call_564284.host, call_564284.base,
                         call_564284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564284, url, valid)

proc call*(call_564285: Call_ConnectionMonitorsStart_564276; apiVersion: string;
          networkWatcherName: string; subscriptionId: string;
          connectionMonitorName: string; resourceGroupName: string): Recallable =
  ## connectionMonitorsStart
  ## Starts the specified connection monitor.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionMonitorName: string (required)
  ##                        : The name of the connection monitor.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing Network Watcher.
  var path_564286 = newJObject()
  var query_564287 = newJObject()
  add(query_564287, "api-version", newJString(apiVersion))
  add(path_564286, "networkWatcherName", newJString(networkWatcherName))
  add(path_564286, "subscriptionId", newJString(subscriptionId))
  add(path_564286, "connectionMonitorName", newJString(connectionMonitorName))
  add(path_564286, "resourceGroupName", newJString(resourceGroupName))
  result = call_564285.call(path_564286, query_564287, nil, nil, nil)

var connectionMonitorsStart* = Call_ConnectionMonitorsStart_564276(
    name: "connectionMonitorsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}/start",
    validator: validate_ConnectionMonitorsStart_564277, base: "",
    url: url_ConnectionMonitorsStart_564278, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsStop_564288 = ref object of OpenApiRestCall_563565
proc url_ConnectionMonitorsStop_564290(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectionMonitorsStop_564289(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops the specified connection monitor.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionMonitorName: JString (required)
  ##                        : The name of the connection monitor.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing Network Watcher.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkWatcherName` field"
  var valid_564291 = path.getOrDefault("networkWatcherName")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "networkWatcherName", valid_564291
  var valid_564292 = path.getOrDefault("subscriptionId")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "subscriptionId", valid_564292
  var valid_564293 = path.getOrDefault("connectionMonitorName")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "connectionMonitorName", valid_564293
  var valid_564294 = path.getOrDefault("resourceGroupName")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "resourceGroupName", valid_564294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564295 = query.getOrDefault("api-version")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "api-version", valid_564295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564296: Call_ConnectionMonitorsStop_564288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops the specified connection monitor.
  ## 
  let valid = call_564296.validator(path, query, header, formData, body)
  let scheme = call_564296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564296.url(scheme.get, call_564296.host, call_564296.base,
                         call_564296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564296, url, valid)

proc call*(call_564297: Call_ConnectionMonitorsStop_564288; apiVersion: string;
          networkWatcherName: string; subscriptionId: string;
          connectionMonitorName: string; resourceGroupName: string): Recallable =
  ## connectionMonitorsStop
  ## Stops the specified connection monitor.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionMonitorName: string (required)
  ##                        : The name of the connection monitor.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing Network Watcher.
  var path_564298 = newJObject()
  var query_564299 = newJObject()
  add(query_564299, "api-version", newJString(apiVersion))
  add(path_564298, "networkWatcherName", newJString(networkWatcherName))
  add(path_564298, "subscriptionId", newJString(subscriptionId))
  add(path_564298, "connectionMonitorName", newJString(connectionMonitorName))
  add(path_564298, "resourceGroupName", newJString(resourceGroupName))
  result = call_564297.call(path_564298, query_564299, nil, nil, nil)

var connectionMonitorsStop* = Call_ConnectionMonitorsStop_564288(
    name: "connectionMonitorsStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}/stop",
    validator: validate_ConnectionMonitorsStop_564289, base: "",
    url: url_ConnectionMonitorsStop_564290, schemes: {Scheme.Https})
type
  Call_NetworkWatchersCheckConnectivity_564300 = ref object of OpenApiRestCall_563565
proc url_NetworkWatchersCheckConnectivity_564302(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersCheckConnectivity_564301(path: JsonNode;
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
  var valid_564303 = path.getOrDefault("networkWatcherName")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "networkWatcherName", valid_564303
  var valid_564304 = path.getOrDefault("subscriptionId")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "subscriptionId", valid_564304
  var valid_564305 = path.getOrDefault("resourceGroupName")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "resourceGroupName", valid_564305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564306 = query.getOrDefault("api-version")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "api-version", valid_564306
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

proc call*(call_564308: Call_NetworkWatchersCheckConnectivity_564300;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies the possibility of establishing a direct TCP connection from a virtual machine to a given endpoint including another VM or an arbitrary remote server.
  ## 
  let valid = call_564308.validator(path, query, header, formData, body)
  let scheme = call_564308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564308.url(scheme.get, call_564308.host, call_564308.base,
                         call_564308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564308, url, valid)

proc call*(call_564309: Call_NetworkWatchersCheckConnectivity_564300;
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
  var path_564310 = newJObject()
  var query_564311 = newJObject()
  var body_564312 = newJObject()
  add(query_564311, "api-version", newJString(apiVersion))
  add(path_564310, "networkWatcherName", newJString(networkWatcherName))
  add(path_564310, "subscriptionId", newJString(subscriptionId))
  add(path_564310, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564312 = parameters
  result = call_564309.call(path_564310, query_564311, nil, nil, body_564312)

var networkWatchersCheckConnectivity* = Call_NetworkWatchersCheckConnectivity_564300(
    name: "networkWatchersCheckConnectivity", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectivityCheck",
    validator: validate_NetworkWatchersCheckConnectivity_564301, base: "",
    url: url_NetworkWatchersCheckConnectivity_564302, schemes: {Scheme.Https})
type
  Call_NetworkWatchersVerifyIPFlow_564313 = ref object of OpenApiRestCall_563565
proc url_NetworkWatchersVerifyIPFlow_564315(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersVerifyIPFlow_564314(path: JsonNode; query: JsonNode;
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
  var valid_564316 = path.getOrDefault("networkWatcherName")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "networkWatcherName", valid_564316
  var valid_564317 = path.getOrDefault("subscriptionId")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "subscriptionId", valid_564317
  var valid_564318 = path.getOrDefault("resourceGroupName")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "resourceGroupName", valid_564318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564319 = query.getOrDefault("api-version")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "api-version", valid_564319
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

proc call*(call_564321: Call_NetworkWatchersVerifyIPFlow_564313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verify IP flow from the specified VM to a location given the currently configured NSG rules.
  ## 
  let valid = call_564321.validator(path, query, header, formData, body)
  let scheme = call_564321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564321.url(scheme.get, call_564321.host, call_564321.base,
                         call_564321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564321, url, valid)

proc call*(call_564322: Call_NetworkWatchersVerifyIPFlow_564313;
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
  var path_564323 = newJObject()
  var query_564324 = newJObject()
  var body_564325 = newJObject()
  add(query_564324, "api-version", newJString(apiVersion))
  add(path_564323, "networkWatcherName", newJString(networkWatcherName))
  add(path_564323, "subscriptionId", newJString(subscriptionId))
  add(path_564323, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564325 = parameters
  result = call_564322.call(path_564323, query_564324, nil, nil, body_564325)

var networkWatchersVerifyIPFlow* = Call_NetworkWatchersVerifyIPFlow_564313(
    name: "networkWatchersVerifyIPFlow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/ipFlowVerify",
    validator: validate_NetworkWatchersVerifyIPFlow_564314, base: "",
    url: url_NetworkWatchersVerifyIPFlow_564315, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetNextHop_564326 = ref object of OpenApiRestCall_563565
proc url_NetworkWatchersGetNextHop_564328(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetNextHop_564327(path: JsonNode; query: JsonNode;
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
  var valid_564329 = path.getOrDefault("networkWatcherName")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "networkWatcherName", valid_564329
  var valid_564330 = path.getOrDefault("subscriptionId")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "subscriptionId", valid_564330
  var valid_564331 = path.getOrDefault("resourceGroupName")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "resourceGroupName", valid_564331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564332 = query.getOrDefault("api-version")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "api-version", valid_564332
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

proc call*(call_564334: Call_NetworkWatchersGetNextHop_564326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the next hop from the specified VM.
  ## 
  let valid = call_564334.validator(path, query, header, formData, body)
  let scheme = call_564334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564334.url(scheme.get, call_564334.host, call_564334.base,
                         call_564334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564334, url, valid)

proc call*(call_564335: Call_NetworkWatchersGetNextHop_564326; apiVersion: string;
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
  var path_564336 = newJObject()
  var query_564337 = newJObject()
  var body_564338 = newJObject()
  add(query_564337, "api-version", newJString(apiVersion))
  add(path_564336, "networkWatcherName", newJString(networkWatcherName))
  add(path_564336, "subscriptionId", newJString(subscriptionId))
  add(path_564336, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564338 = parameters
  result = call_564335.call(path_564336, query_564337, nil, nil, body_564338)

var networkWatchersGetNextHop* = Call_NetworkWatchersGetNextHop_564326(
    name: "networkWatchersGetNextHop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/nextHop",
    validator: validate_NetworkWatchersGetNextHop_564327, base: "",
    url: url_NetworkWatchersGetNextHop_564328, schemes: {Scheme.Https})
type
  Call_PacketCapturesList_564339 = ref object of OpenApiRestCall_563565
proc url_PacketCapturesList_564341(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesList_564340(path: JsonNode; query: JsonNode;
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
  var valid_564342 = path.getOrDefault("networkWatcherName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "networkWatcherName", valid_564342
  var valid_564343 = path.getOrDefault("subscriptionId")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "subscriptionId", valid_564343
  var valid_564344 = path.getOrDefault("resourceGroupName")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "resourceGroupName", valid_564344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564345 = query.getOrDefault("api-version")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "api-version", valid_564345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564346: Call_PacketCapturesList_564339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all packet capture sessions within the specified resource group.
  ## 
  let valid = call_564346.validator(path, query, header, formData, body)
  let scheme = call_564346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564346.url(scheme.get, call_564346.host, call_564346.base,
                         call_564346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564346, url, valid)

proc call*(call_564347: Call_PacketCapturesList_564339; apiVersion: string;
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
  var path_564348 = newJObject()
  var query_564349 = newJObject()
  add(query_564349, "api-version", newJString(apiVersion))
  add(path_564348, "networkWatcherName", newJString(networkWatcherName))
  add(path_564348, "subscriptionId", newJString(subscriptionId))
  add(path_564348, "resourceGroupName", newJString(resourceGroupName))
  result = call_564347.call(path_564348, query_564349, nil, nil, nil)

var packetCapturesList* = Call_PacketCapturesList_564339(
    name: "packetCapturesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures",
    validator: validate_PacketCapturesList_564340, base: "",
    url: url_PacketCapturesList_564341, schemes: {Scheme.Https})
type
  Call_PacketCapturesCreate_564362 = ref object of OpenApiRestCall_563565
proc url_PacketCapturesCreate_564364(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesCreate_564363(path: JsonNode; query: JsonNode;
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
  var valid_564365 = path.getOrDefault("packetCaptureName")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "packetCaptureName", valid_564365
  var valid_564366 = path.getOrDefault("networkWatcherName")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "networkWatcherName", valid_564366
  var valid_564367 = path.getOrDefault("subscriptionId")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "subscriptionId", valid_564367
  var valid_564368 = path.getOrDefault("resourceGroupName")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "resourceGroupName", valid_564368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564369 = query.getOrDefault("api-version")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "api-version", valid_564369
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

proc call*(call_564371: Call_PacketCapturesCreate_564362; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create and start a packet capture on the specified VM.
  ## 
  let valid = call_564371.validator(path, query, header, formData, body)
  let scheme = call_564371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564371.url(scheme.get, call_564371.host, call_564371.base,
                         call_564371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564371, url, valid)

proc call*(call_564372: Call_PacketCapturesCreate_564362;
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
  var path_564373 = newJObject()
  var query_564374 = newJObject()
  var body_564375 = newJObject()
  add(path_564373, "packetCaptureName", newJString(packetCaptureName))
  add(query_564374, "api-version", newJString(apiVersion))
  add(path_564373, "networkWatcherName", newJString(networkWatcherName))
  add(path_564373, "subscriptionId", newJString(subscriptionId))
  add(path_564373, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564375 = parameters
  result = call_564372.call(path_564373, query_564374, nil, nil, body_564375)

var packetCapturesCreate* = Call_PacketCapturesCreate_564362(
    name: "packetCapturesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}",
    validator: validate_PacketCapturesCreate_564363, base: "",
    url: url_PacketCapturesCreate_564364, schemes: {Scheme.Https})
type
  Call_PacketCapturesGet_564350 = ref object of OpenApiRestCall_563565
proc url_PacketCapturesGet_564352(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesGet_564351(path: JsonNode; query: JsonNode;
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
  var valid_564353 = path.getOrDefault("packetCaptureName")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "packetCaptureName", valid_564353
  var valid_564354 = path.getOrDefault("networkWatcherName")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "networkWatcherName", valid_564354
  var valid_564355 = path.getOrDefault("subscriptionId")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "subscriptionId", valid_564355
  var valid_564356 = path.getOrDefault("resourceGroupName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "resourceGroupName", valid_564356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564357 = query.getOrDefault("api-version")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "api-version", valid_564357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564358: Call_PacketCapturesGet_564350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a packet capture session by name.
  ## 
  let valid = call_564358.validator(path, query, header, formData, body)
  let scheme = call_564358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564358.url(scheme.get, call_564358.host, call_564358.base,
                         call_564358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564358, url, valid)

proc call*(call_564359: Call_PacketCapturesGet_564350; packetCaptureName: string;
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
  var path_564360 = newJObject()
  var query_564361 = newJObject()
  add(path_564360, "packetCaptureName", newJString(packetCaptureName))
  add(query_564361, "api-version", newJString(apiVersion))
  add(path_564360, "networkWatcherName", newJString(networkWatcherName))
  add(path_564360, "subscriptionId", newJString(subscriptionId))
  add(path_564360, "resourceGroupName", newJString(resourceGroupName))
  result = call_564359.call(path_564360, query_564361, nil, nil, nil)

var packetCapturesGet* = Call_PacketCapturesGet_564350(name: "packetCapturesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}",
    validator: validate_PacketCapturesGet_564351, base: "",
    url: url_PacketCapturesGet_564352, schemes: {Scheme.Https})
type
  Call_PacketCapturesDelete_564376 = ref object of OpenApiRestCall_563565
proc url_PacketCapturesDelete_564378(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesDelete_564377(path: JsonNode; query: JsonNode;
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
  var valid_564379 = path.getOrDefault("packetCaptureName")
  valid_564379 = validateParameter(valid_564379, JString, required = true,
                                 default = nil)
  if valid_564379 != nil:
    section.add "packetCaptureName", valid_564379
  var valid_564380 = path.getOrDefault("networkWatcherName")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "networkWatcherName", valid_564380
  var valid_564381 = path.getOrDefault("subscriptionId")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "subscriptionId", valid_564381
  var valid_564382 = path.getOrDefault("resourceGroupName")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "resourceGroupName", valid_564382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564383 = query.getOrDefault("api-version")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "api-version", valid_564383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564384: Call_PacketCapturesDelete_564376; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified packet capture session.
  ## 
  let valid = call_564384.validator(path, query, header, formData, body)
  let scheme = call_564384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564384.url(scheme.get, call_564384.host, call_564384.base,
                         call_564384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564384, url, valid)

proc call*(call_564385: Call_PacketCapturesDelete_564376;
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
  var path_564386 = newJObject()
  var query_564387 = newJObject()
  add(path_564386, "packetCaptureName", newJString(packetCaptureName))
  add(query_564387, "api-version", newJString(apiVersion))
  add(path_564386, "networkWatcherName", newJString(networkWatcherName))
  add(path_564386, "subscriptionId", newJString(subscriptionId))
  add(path_564386, "resourceGroupName", newJString(resourceGroupName))
  result = call_564385.call(path_564386, query_564387, nil, nil, nil)

var packetCapturesDelete* = Call_PacketCapturesDelete_564376(
    name: "packetCapturesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}",
    validator: validate_PacketCapturesDelete_564377, base: "",
    url: url_PacketCapturesDelete_564378, schemes: {Scheme.Https})
type
  Call_PacketCapturesGetStatus_564388 = ref object of OpenApiRestCall_563565
proc url_PacketCapturesGetStatus_564390(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesGetStatus_564389(path: JsonNode; query: JsonNode;
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
  var valid_564391 = path.getOrDefault("packetCaptureName")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "packetCaptureName", valid_564391
  var valid_564392 = path.getOrDefault("networkWatcherName")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "networkWatcherName", valid_564392
  var valid_564393 = path.getOrDefault("subscriptionId")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "subscriptionId", valid_564393
  var valid_564394 = path.getOrDefault("resourceGroupName")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "resourceGroupName", valid_564394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564395 = query.getOrDefault("api-version")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "api-version", valid_564395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564396: Call_PacketCapturesGetStatus_564388; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the status of a running packet capture session.
  ## 
  let valid = call_564396.validator(path, query, header, formData, body)
  let scheme = call_564396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564396.url(scheme.get, call_564396.host, call_564396.base,
                         call_564396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564396, url, valid)

proc call*(call_564397: Call_PacketCapturesGetStatus_564388;
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
  var path_564398 = newJObject()
  var query_564399 = newJObject()
  add(path_564398, "packetCaptureName", newJString(packetCaptureName))
  add(query_564399, "api-version", newJString(apiVersion))
  add(path_564398, "networkWatcherName", newJString(networkWatcherName))
  add(path_564398, "subscriptionId", newJString(subscriptionId))
  add(path_564398, "resourceGroupName", newJString(resourceGroupName))
  result = call_564397.call(path_564398, query_564399, nil, nil, nil)

var packetCapturesGetStatus* = Call_PacketCapturesGetStatus_564388(
    name: "packetCapturesGetStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}/queryStatus",
    validator: validate_PacketCapturesGetStatus_564389, base: "",
    url: url_PacketCapturesGetStatus_564390, schemes: {Scheme.Https})
type
  Call_PacketCapturesStop_564400 = ref object of OpenApiRestCall_563565
proc url_PacketCapturesStop_564402(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesStop_564401(path: JsonNode; query: JsonNode;
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
  var valid_564403 = path.getOrDefault("packetCaptureName")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "packetCaptureName", valid_564403
  var valid_564404 = path.getOrDefault("networkWatcherName")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "networkWatcherName", valid_564404
  var valid_564405 = path.getOrDefault("subscriptionId")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "subscriptionId", valid_564405
  var valid_564406 = path.getOrDefault("resourceGroupName")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "resourceGroupName", valid_564406
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564407 = query.getOrDefault("api-version")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "api-version", valid_564407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564408: Call_PacketCapturesStop_564400; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a specified packet capture session.
  ## 
  let valid = call_564408.validator(path, query, header, formData, body)
  let scheme = call_564408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564408.url(scheme.get, call_564408.host, call_564408.base,
                         call_564408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564408, url, valid)

proc call*(call_564409: Call_PacketCapturesStop_564400; packetCaptureName: string;
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
  var path_564410 = newJObject()
  var query_564411 = newJObject()
  add(path_564410, "packetCaptureName", newJString(packetCaptureName))
  add(query_564411, "api-version", newJString(apiVersion))
  add(path_564410, "networkWatcherName", newJString(networkWatcherName))
  add(path_564410, "subscriptionId", newJString(subscriptionId))
  add(path_564410, "resourceGroupName", newJString(resourceGroupName))
  result = call_564409.call(path_564410, query_564411, nil, nil, nil)

var packetCapturesStop* = Call_PacketCapturesStop_564400(
    name: "packetCapturesStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}/stop",
    validator: validate_PacketCapturesStop_564401, base: "",
    url: url_PacketCapturesStop_564402, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetFlowLogStatus_564412 = ref object of OpenApiRestCall_563565
proc url_NetworkWatchersGetFlowLogStatus_564414(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetFlowLogStatus_564413(path: JsonNode;
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
  var valid_564415 = path.getOrDefault("networkWatcherName")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "networkWatcherName", valid_564415
  var valid_564416 = path.getOrDefault("subscriptionId")
  valid_564416 = validateParameter(valid_564416, JString, required = true,
                                 default = nil)
  if valid_564416 != nil:
    section.add "subscriptionId", valid_564416
  var valid_564417 = path.getOrDefault("resourceGroupName")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "resourceGroupName", valid_564417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564418 = query.getOrDefault("api-version")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "api-version", valid_564418
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

proc call*(call_564420: Call_NetworkWatchersGetFlowLogStatus_564412;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries status of flow log on a specified resource.
  ## 
  let valid = call_564420.validator(path, query, header, formData, body)
  let scheme = call_564420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564420.url(scheme.get, call_564420.host, call_564420.base,
                         call_564420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564420, url, valid)

proc call*(call_564421: Call_NetworkWatchersGetFlowLogStatus_564412;
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
  var path_564422 = newJObject()
  var query_564423 = newJObject()
  var body_564424 = newJObject()
  add(query_564423, "api-version", newJString(apiVersion))
  add(path_564422, "networkWatcherName", newJString(networkWatcherName))
  add(path_564422, "subscriptionId", newJString(subscriptionId))
  add(path_564422, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564424 = parameters
  result = call_564421.call(path_564422, query_564423, nil, nil, body_564424)

var networkWatchersGetFlowLogStatus* = Call_NetworkWatchersGetFlowLogStatus_564412(
    name: "networkWatchersGetFlowLogStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/queryFlowLogStatus",
    validator: validate_NetworkWatchersGetFlowLogStatus_564413, base: "",
    url: url_NetworkWatchersGetFlowLogStatus_564414, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetTroubleshootingResult_564425 = ref object of OpenApiRestCall_563565
proc url_NetworkWatchersGetTroubleshootingResult_564427(protocol: Scheme;
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

proc validate_NetworkWatchersGetTroubleshootingResult_564426(path: JsonNode;
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
  var valid_564428 = path.getOrDefault("networkWatcherName")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "networkWatcherName", valid_564428
  var valid_564429 = path.getOrDefault("subscriptionId")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "subscriptionId", valid_564429
  var valid_564430 = path.getOrDefault("resourceGroupName")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "resourceGroupName", valid_564430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564431 = query.getOrDefault("api-version")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "api-version", valid_564431
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

proc call*(call_564433: Call_NetworkWatchersGetTroubleshootingResult_564425;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the last completed troubleshooting result on a specified resource
  ## 
  let valid = call_564433.validator(path, query, header, formData, body)
  let scheme = call_564433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564433.url(scheme.get, call_564433.host, call_564433.base,
                         call_564433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564433, url, valid)

proc call*(call_564434: Call_NetworkWatchersGetTroubleshootingResult_564425;
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
  var path_564435 = newJObject()
  var query_564436 = newJObject()
  var body_564437 = newJObject()
  add(query_564436, "api-version", newJString(apiVersion))
  add(path_564435, "networkWatcherName", newJString(networkWatcherName))
  add(path_564435, "subscriptionId", newJString(subscriptionId))
  add(path_564435, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564437 = parameters
  result = call_564434.call(path_564435, query_564436, nil, nil, body_564437)

var networkWatchersGetTroubleshootingResult* = Call_NetworkWatchersGetTroubleshootingResult_564425(
    name: "networkWatchersGetTroubleshootingResult", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/queryTroubleshootResult",
    validator: validate_NetworkWatchersGetTroubleshootingResult_564426, base: "",
    url: url_NetworkWatchersGetTroubleshootingResult_564427,
    schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetVMSecurityRules_564438 = ref object of OpenApiRestCall_563565
proc url_NetworkWatchersGetVMSecurityRules_564440(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetVMSecurityRules_564439(path: JsonNode;
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
  var valid_564441 = path.getOrDefault("networkWatcherName")
  valid_564441 = validateParameter(valid_564441, JString, required = true,
                                 default = nil)
  if valid_564441 != nil:
    section.add "networkWatcherName", valid_564441
  var valid_564442 = path.getOrDefault("subscriptionId")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "subscriptionId", valid_564442
  var valid_564443 = path.getOrDefault("resourceGroupName")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "resourceGroupName", valid_564443
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564444 = query.getOrDefault("api-version")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "api-version", valid_564444
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

proc call*(call_564446: Call_NetworkWatchersGetVMSecurityRules_564438;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the configured and effective security group rules on the specified VM.
  ## 
  let valid = call_564446.validator(path, query, header, formData, body)
  let scheme = call_564446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564446.url(scheme.get, call_564446.host, call_564446.base,
                         call_564446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564446, url, valid)

proc call*(call_564447: Call_NetworkWatchersGetVMSecurityRules_564438;
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
  var path_564448 = newJObject()
  var query_564449 = newJObject()
  var body_564450 = newJObject()
  add(query_564449, "api-version", newJString(apiVersion))
  add(path_564448, "networkWatcherName", newJString(networkWatcherName))
  add(path_564448, "subscriptionId", newJString(subscriptionId))
  add(path_564448, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564450 = parameters
  result = call_564447.call(path_564448, query_564449, nil, nil, body_564450)

var networkWatchersGetVMSecurityRules* = Call_NetworkWatchersGetVMSecurityRules_564438(
    name: "networkWatchersGetVMSecurityRules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/securityGroupView",
    validator: validate_NetworkWatchersGetVMSecurityRules_564439, base: "",
    url: url_NetworkWatchersGetVMSecurityRules_564440, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetTopology_564451 = ref object of OpenApiRestCall_563565
proc url_NetworkWatchersGetTopology_564453(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetTopology_564452(path: JsonNode; query: JsonNode;
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
  var valid_564454 = path.getOrDefault("networkWatcherName")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "networkWatcherName", valid_564454
  var valid_564455 = path.getOrDefault("subscriptionId")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "subscriptionId", valid_564455
  var valid_564456 = path.getOrDefault("resourceGroupName")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "resourceGroupName", valid_564456
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564457 = query.getOrDefault("api-version")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "api-version", valid_564457
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

proc call*(call_564459: Call_NetworkWatchersGetTopology_564451; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current network topology by resource group.
  ## 
  let valid = call_564459.validator(path, query, header, formData, body)
  let scheme = call_564459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564459.url(scheme.get, call_564459.host, call_564459.base,
                         call_564459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564459, url, valid)

proc call*(call_564460: Call_NetworkWatchersGetTopology_564451; apiVersion: string;
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
  var path_564461 = newJObject()
  var query_564462 = newJObject()
  var body_564463 = newJObject()
  add(query_564462, "api-version", newJString(apiVersion))
  add(path_564461, "networkWatcherName", newJString(networkWatcherName))
  add(path_564461, "subscriptionId", newJString(subscriptionId))
  add(path_564461, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564463 = parameters
  result = call_564460.call(path_564461, query_564462, nil, nil, body_564463)

var networkWatchersGetTopology* = Call_NetworkWatchersGetTopology_564451(
    name: "networkWatchersGetTopology", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/topology",
    validator: validate_NetworkWatchersGetTopology_564452, base: "",
    url: url_NetworkWatchersGetTopology_564453, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetTroubleshooting_564464 = ref object of OpenApiRestCall_563565
proc url_NetworkWatchersGetTroubleshooting_564466(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetTroubleshooting_564465(path: JsonNode;
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
  var valid_564467 = path.getOrDefault("networkWatcherName")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "networkWatcherName", valid_564467
  var valid_564468 = path.getOrDefault("subscriptionId")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "subscriptionId", valid_564468
  var valid_564469 = path.getOrDefault("resourceGroupName")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "resourceGroupName", valid_564469
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564470 = query.getOrDefault("api-version")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "api-version", valid_564470
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

proc call*(call_564472: Call_NetworkWatchersGetTroubleshooting_564464;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Initiate troubleshooting on a specified resource
  ## 
  let valid = call_564472.validator(path, query, header, formData, body)
  let scheme = call_564472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564472.url(scheme.get, call_564472.host, call_564472.base,
                         call_564472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564472, url, valid)

proc call*(call_564473: Call_NetworkWatchersGetTroubleshooting_564464;
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
  var path_564474 = newJObject()
  var query_564475 = newJObject()
  var body_564476 = newJObject()
  add(query_564475, "api-version", newJString(apiVersion))
  add(path_564474, "networkWatcherName", newJString(networkWatcherName))
  add(path_564474, "subscriptionId", newJString(subscriptionId))
  add(path_564474, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564476 = parameters
  result = call_564473.call(path_564474, query_564475, nil, nil, body_564476)

var networkWatchersGetTroubleshooting* = Call_NetworkWatchersGetTroubleshooting_564464(
    name: "networkWatchersGetTroubleshooting", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/troubleshoot",
    validator: validate_NetworkWatchersGetTroubleshooting_564465, base: "",
    url: url_NetworkWatchersGetTroubleshooting_564466, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
