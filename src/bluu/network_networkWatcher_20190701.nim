
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

  OpenApiRestCall_573667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573667): Option[Scheme] {.used.} =
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
  macServiceName = "network-networkWatcher"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_NetworkWatchersListAll_573889 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersListAll_573891(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkWatchersListAll_573890(path: JsonNode; query: JsonNode;
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
  var valid_574051 = path.getOrDefault("subscriptionId")
  valid_574051 = validateParameter(valid_574051, JString, required = true,
                                 default = nil)
  if valid_574051 != nil:
    section.add "subscriptionId", valid_574051
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574052 = query.getOrDefault("api-version")
  valid_574052 = validateParameter(valid_574052, JString, required = true,
                                 default = nil)
  if valid_574052 != nil:
    section.add "api-version", valid_574052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574079: Call_NetworkWatchersListAll_573889; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all network watchers by subscription.
  ## 
  let valid = call_574079.validator(path, query, header, formData, body)
  let scheme = call_574079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574079.url(scheme.get, call_574079.host, call_574079.base,
                         call_574079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574079, url, valid)

proc call*(call_574150: Call_NetworkWatchersListAll_573889; apiVersion: string;
          subscriptionId: string): Recallable =
  ## networkWatchersListAll
  ## Gets all network watchers by subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574151 = newJObject()
  var query_574153 = newJObject()
  add(query_574153, "api-version", newJString(apiVersion))
  add(path_574151, "subscriptionId", newJString(subscriptionId))
  result = call_574150.call(path_574151, query_574153, nil, nil, nil)

var networkWatchersListAll* = Call_NetworkWatchersListAll_573889(
    name: "networkWatchersListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/networkWatchers",
    validator: validate_NetworkWatchersListAll_573890, base: "",
    url: url_NetworkWatchersListAll_573891, schemes: {Scheme.Https})
type
  Call_NetworkWatchersList_574192 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersList_574194(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkWatchersList_574193(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets all network watchers by resource group.
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574197 = query.getOrDefault("api-version")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "api-version", valid_574197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574198: Call_NetworkWatchersList_574192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all network watchers by resource group.
  ## 
  let valid = call_574198.validator(path, query, header, formData, body)
  let scheme = call_574198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574198.url(scheme.get, call_574198.host, call_574198.base,
                         call_574198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574198, url, valid)

proc call*(call_574199: Call_NetworkWatchersList_574192; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## networkWatchersList
  ## Gets all network watchers by resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574200 = newJObject()
  var query_574201 = newJObject()
  add(path_574200, "resourceGroupName", newJString(resourceGroupName))
  add(query_574201, "api-version", newJString(apiVersion))
  add(path_574200, "subscriptionId", newJString(subscriptionId))
  result = call_574199.call(path_574200, query_574201, nil, nil, nil)

var networkWatchersList* = Call_NetworkWatchersList_574192(
    name: "networkWatchersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers",
    validator: validate_NetworkWatchersList_574193, base: "",
    url: url_NetworkWatchersList_574194, schemes: {Scheme.Https})
type
  Call_NetworkWatchersCreateOrUpdate_574213 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersCreateOrUpdate_574215(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersCreateOrUpdate_574214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a network watcher in the specified resource group.
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
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574242 = path.getOrDefault("resourceGroupName")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "resourceGroupName", valid_574242
  var valid_574243 = path.getOrDefault("subscriptionId")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "subscriptionId", valid_574243
  var valid_574244 = path.getOrDefault("networkWatcherName")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "networkWatcherName", valid_574244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574245 = query.getOrDefault("api-version")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "api-version", valid_574245
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

proc call*(call_574247: Call_NetworkWatchersCreateOrUpdate_574213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a network watcher in the specified resource group.
  ## 
  let valid = call_574247.validator(path, query, header, formData, body)
  let scheme = call_574247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574247.url(scheme.get, call_574247.host, call_574247.base,
                         call_574247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574247, url, valid)

proc call*(call_574248: Call_NetworkWatchersCreateOrUpdate_574213;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersCreateOrUpdate
  ## Creates or updates a network watcher in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   parameters: JObject (required)
  ##             : Parameters that define the network watcher resource.
  var path_574249 = newJObject()
  var query_574250 = newJObject()
  var body_574251 = newJObject()
  add(path_574249, "resourceGroupName", newJString(resourceGroupName))
  add(query_574250, "api-version", newJString(apiVersion))
  add(path_574249, "subscriptionId", newJString(subscriptionId))
  add(path_574249, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_574251 = parameters
  result = call_574248.call(path_574249, query_574250, nil, nil, body_574251)

var networkWatchersCreateOrUpdate* = Call_NetworkWatchersCreateOrUpdate_574213(
    name: "networkWatchersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}",
    validator: validate_NetworkWatchersCreateOrUpdate_574214, base: "",
    url: url_NetworkWatchersCreateOrUpdate_574215, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGet_574202 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersGet_574204(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkWatchersGet_574203(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the specified network watcher by resource group.
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
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574205 = path.getOrDefault("resourceGroupName")
  valid_574205 = validateParameter(valid_574205, JString, required = true,
                                 default = nil)
  if valid_574205 != nil:
    section.add "resourceGroupName", valid_574205
  var valid_574206 = path.getOrDefault("subscriptionId")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = nil)
  if valid_574206 != nil:
    section.add "subscriptionId", valid_574206
  var valid_574207 = path.getOrDefault("networkWatcherName")
  valid_574207 = validateParameter(valid_574207, JString, required = true,
                                 default = nil)
  if valid_574207 != nil:
    section.add "networkWatcherName", valid_574207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574208 = query.getOrDefault("api-version")
  valid_574208 = validateParameter(valid_574208, JString, required = true,
                                 default = nil)
  if valid_574208 != nil:
    section.add "api-version", valid_574208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574209: Call_NetworkWatchersGet_574202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified network watcher by resource group.
  ## 
  let valid = call_574209.validator(path, query, header, formData, body)
  let scheme = call_574209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574209.url(scheme.get, call_574209.host, call_574209.base,
                         call_574209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574209, url, valid)

proc call*(call_574210: Call_NetworkWatchersGet_574202; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; networkWatcherName: string): Recallable =
  ## networkWatchersGet
  ## Gets the specified network watcher by resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  var path_574211 = newJObject()
  var query_574212 = newJObject()
  add(path_574211, "resourceGroupName", newJString(resourceGroupName))
  add(query_574212, "api-version", newJString(apiVersion))
  add(path_574211, "subscriptionId", newJString(subscriptionId))
  add(path_574211, "networkWatcherName", newJString(networkWatcherName))
  result = call_574210.call(path_574211, query_574212, nil, nil, nil)

var networkWatchersGet* = Call_NetworkWatchersGet_574202(
    name: "networkWatchersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}",
    validator: validate_NetworkWatchersGet_574203, base: "",
    url: url_NetworkWatchersGet_574204, schemes: {Scheme.Https})
type
  Call_NetworkWatchersUpdateTags_574263 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersUpdateTags_574265(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersUpdateTags_574264(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a network watcher tags.
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574269 = query.getOrDefault("api-version")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "api-version", valid_574269
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

proc call*(call_574271: Call_NetworkWatchersUpdateTags_574263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a network watcher tags.
  ## 
  let valid = call_574271.validator(path, query, header, formData, body)
  let scheme = call_574271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574271.url(scheme.get, call_574271.host, call_574271.base,
                         call_574271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574271, url, valid)

proc call*(call_574272: Call_NetworkWatchersUpdateTags_574263;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersUpdateTags
  ## Updates a network watcher tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update network watcher tags.
  var path_574273 = newJObject()
  var query_574274 = newJObject()
  var body_574275 = newJObject()
  add(path_574273, "resourceGroupName", newJString(resourceGroupName))
  add(query_574274, "api-version", newJString(apiVersion))
  add(path_574273, "subscriptionId", newJString(subscriptionId))
  add(path_574273, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_574275 = parameters
  result = call_574272.call(path_574273, query_574274, nil, nil, body_574275)

var networkWatchersUpdateTags* = Call_NetworkWatchersUpdateTags_574263(
    name: "networkWatchersUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}",
    validator: validate_NetworkWatchersUpdateTags_574264, base: "",
    url: url_NetworkWatchersUpdateTags_574265, schemes: {Scheme.Https})
type
  Call_NetworkWatchersDelete_574252 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersDelete_574254(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkWatchersDelete_574253(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified network watcher resource.
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
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574255 = path.getOrDefault("resourceGroupName")
  valid_574255 = validateParameter(valid_574255, JString, required = true,
                                 default = nil)
  if valid_574255 != nil:
    section.add "resourceGroupName", valid_574255
  var valid_574256 = path.getOrDefault("subscriptionId")
  valid_574256 = validateParameter(valid_574256, JString, required = true,
                                 default = nil)
  if valid_574256 != nil:
    section.add "subscriptionId", valid_574256
  var valid_574257 = path.getOrDefault("networkWatcherName")
  valid_574257 = validateParameter(valid_574257, JString, required = true,
                                 default = nil)
  if valid_574257 != nil:
    section.add "networkWatcherName", valid_574257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574258 = query.getOrDefault("api-version")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "api-version", valid_574258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574259: Call_NetworkWatchersDelete_574252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified network watcher resource.
  ## 
  let valid = call_574259.validator(path, query, header, formData, body)
  let scheme = call_574259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574259.url(scheme.get, call_574259.host, call_574259.base,
                         call_574259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574259, url, valid)

proc call*(call_574260: Call_NetworkWatchersDelete_574252;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string): Recallable =
  ## networkWatchersDelete
  ## Deletes the specified network watcher resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  var path_574261 = newJObject()
  var query_574262 = newJObject()
  add(path_574261, "resourceGroupName", newJString(resourceGroupName))
  add(query_574262, "api-version", newJString(apiVersion))
  add(path_574261, "subscriptionId", newJString(subscriptionId))
  add(path_574261, "networkWatcherName", newJString(networkWatcherName))
  result = call_574260.call(path_574261, query_574262, nil, nil, nil)

var networkWatchersDelete* = Call_NetworkWatchersDelete_574252(
    name: "networkWatchersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}",
    validator: validate_NetworkWatchersDelete_574253, base: "",
    url: url_NetworkWatchersDelete_574254, schemes: {Scheme.Https})
type
  Call_NetworkWatchersListAvailableProviders_574276 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersListAvailableProviders_574278(protocol: Scheme;
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

proc validate_NetworkWatchersListAvailableProviders_574277(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all available internet service providers for a specified Azure region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the network watcher resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher resource.
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
  var valid_574281 = path.getOrDefault("networkWatcherName")
  valid_574281 = validateParameter(valid_574281, JString, required = true,
                                 default = nil)
  if valid_574281 != nil:
    section.add "networkWatcherName", valid_574281
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that scope the list of available providers.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574284: Call_NetworkWatchersListAvailableProviders_574276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available internet service providers for a specified Azure region.
  ## 
  let valid = call_574284.validator(path, query, header, formData, body)
  let scheme = call_574284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574284.url(scheme.get, call_574284.host, call_574284.base,
                         call_574284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574284, url, valid)

proc call*(call_574285: Call_NetworkWatchersListAvailableProviders_574276;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersListAvailableProviders
  ## Lists all available internet service providers for a specified Azure region.
  ##   resourceGroupName: string (required)
  ##                    : The name of the network watcher resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher resource.
  ##   parameters: JObject (required)
  ##             : Parameters that scope the list of available providers.
  var path_574286 = newJObject()
  var query_574287 = newJObject()
  var body_574288 = newJObject()
  add(path_574286, "resourceGroupName", newJString(resourceGroupName))
  add(query_574287, "api-version", newJString(apiVersion))
  add(path_574286, "subscriptionId", newJString(subscriptionId))
  add(path_574286, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_574288 = parameters
  result = call_574285.call(path_574286, query_574287, nil, nil, body_574288)

var networkWatchersListAvailableProviders* = Call_NetworkWatchersListAvailableProviders_574276(
    name: "networkWatchersListAvailableProviders", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/availableProvidersList",
    validator: validate_NetworkWatchersListAvailableProviders_574277, base: "",
    url: url_NetworkWatchersListAvailableProviders_574278, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetAzureReachabilityReport_574289 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersGetAzureReachabilityReport_574291(protocol: Scheme;
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

proc validate_NetworkWatchersGetAzureReachabilityReport_574290(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the relative latency score for internet service providers from a specified location to Azure regions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the network watcher resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574292 = path.getOrDefault("resourceGroupName")
  valid_574292 = validateParameter(valid_574292, JString, required = true,
                                 default = nil)
  if valid_574292 != nil:
    section.add "resourceGroupName", valid_574292
  var valid_574293 = path.getOrDefault("subscriptionId")
  valid_574293 = validateParameter(valid_574293, JString, required = true,
                                 default = nil)
  if valid_574293 != nil:
    section.add "subscriptionId", valid_574293
  var valid_574294 = path.getOrDefault("networkWatcherName")
  valid_574294 = validateParameter(valid_574294, JString, required = true,
                                 default = nil)
  if valid_574294 != nil:
    section.add "networkWatcherName", valid_574294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574295 = query.getOrDefault("api-version")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "api-version", valid_574295
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

proc call*(call_574297: Call_NetworkWatchersGetAzureReachabilityReport_574289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the relative latency score for internet service providers from a specified location to Azure regions.
  ## 
  let valid = call_574297.validator(path, query, header, formData, body)
  let scheme = call_574297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574297.url(scheme.get, call_574297.host, call_574297.base,
                         call_574297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574297, url, valid)

proc call*(call_574298: Call_NetworkWatchersGetAzureReachabilityReport_574289;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetAzureReachabilityReport
  ## Gets the relative latency score for internet service providers from a specified location to Azure regions.
  ##   resourceGroupName: string (required)
  ##                    : The name of the network watcher resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher resource.
  ##   parameters: JObject (required)
  ##             : Parameters that determine Azure reachability report configuration.
  var path_574299 = newJObject()
  var query_574300 = newJObject()
  var body_574301 = newJObject()
  add(path_574299, "resourceGroupName", newJString(resourceGroupName))
  add(query_574300, "api-version", newJString(apiVersion))
  add(path_574299, "subscriptionId", newJString(subscriptionId))
  add(path_574299, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_574301 = parameters
  result = call_574298.call(path_574299, query_574300, nil, nil, body_574301)

var networkWatchersGetAzureReachabilityReport* = Call_NetworkWatchersGetAzureReachabilityReport_574289(
    name: "networkWatchersGetAzureReachabilityReport", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/azureReachabilityReport",
    validator: validate_NetworkWatchersGetAzureReachabilityReport_574290,
    base: "", url: url_NetworkWatchersGetAzureReachabilityReport_574291,
    schemes: {Scheme.Https})
type
  Call_NetworkWatchersSetFlowLogConfiguration_574302 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersSetFlowLogConfiguration_574304(protocol: Scheme;
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

proc validate_NetworkWatchersSetFlowLogConfiguration_574303(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Configures flow log and traffic analytics (optional) on a specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the network watcher resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574305 = path.getOrDefault("resourceGroupName")
  valid_574305 = validateParameter(valid_574305, JString, required = true,
                                 default = nil)
  if valid_574305 != nil:
    section.add "resourceGroupName", valid_574305
  var valid_574306 = path.getOrDefault("subscriptionId")
  valid_574306 = validateParameter(valid_574306, JString, required = true,
                                 default = nil)
  if valid_574306 != nil:
    section.add "subscriptionId", valid_574306
  var valid_574307 = path.getOrDefault("networkWatcherName")
  valid_574307 = validateParameter(valid_574307, JString, required = true,
                                 default = nil)
  if valid_574307 != nil:
    section.add "networkWatcherName", valid_574307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574308 = query.getOrDefault("api-version")
  valid_574308 = validateParameter(valid_574308, JString, required = true,
                                 default = nil)
  if valid_574308 != nil:
    section.add "api-version", valid_574308
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

proc call*(call_574310: Call_NetworkWatchersSetFlowLogConfiguration_574302;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Configures flow log and traffic analytics (optional) on a specified resource.
  ## 
  let valid = call_574310.validator(path, query, header, formData, body)
  let scheme = call_574310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574310.url(scheme.get, call_574310.host, call_574310.base,
                         call_574310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574310, url, valid)

proc call*(call_574311: Call_NetworkWatchersSetFlowLogConfiguration_574302;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersSetFlowLogConfiguration
  ## Configures flow log and traffic analytics (optional) on a specified resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the network watcher resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher resource.
  ##   parameters: JObject (required)
  ##             : Parameters that define the configuration of flow log.
  var path_574312 = newJObject()
  var query_574313 = newJObject()
  var body_574314 = newJObject()
  add(path_574312, "resourceGroupName", newJString(resourceGroupName))
  add(query_574313, "api-version", newJString(apiVersion))
  add(path_574312, "subscriptionId", newJString(subscriptionId))
  add(path_574312, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_574314 = parameters
  result = call_574311.call(path_574312, query_574313, nil, nil, body_574314)

var networkWatchersSetFlowLogConfiguration* = Call_NetworkWatchersSetFlowLogConfiguration_574302(
    name: "networkWatchersSetFlowLogConfiguration", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/configureFlowLog",
    validator: validate_NetworkWatchersSetFlowLogConfiguration_574303, base: "",
    url: url_NetworkWatchersSetFlowLogConfiguration_574304,
    schemes: {Scheme.Https})
type
  Call_NetworkWatchersCheckConnectivity_574315 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersCheckConnectivity_574317(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersCheckConnectivity_574316(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verifies the possibility of establishing a direct TCP connection from a virtual machine to a given endpoint including another VM or an arbitrary remote server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the network watcher resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574318 = path.getOrDefault("resourceGroupName")
  valid_574318 = validateParameter(valid_574318, JString, required = true,
                                 default = nil)
  if valid_574318 != nil:
    section.add "resourceGroupName", valid_574318
  var valid_574319 = path.getOrDefault("subscriptionId")
  valid_574319 = validateParameter(valid_574319, JString, required = true,
                                 default = nil)
  if valid_574319 != nil:
    section.add "subscriptionId", valid_574319
  var valid_574320 = path.getOrDefault("networkWatcherName")
  valid_574320 = validateParameter(valid_574320, JString, required = true,
                                 default = nil)
  if valid_574320 != nil:
    section.add "networkWatcherName", valid_574320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574321 = query.getOrDefault("api-version")
  valid_574321 = validateParameter(valid_574321, JString, required = true,
                                 default = nil)
  if valid_574321 != nil:
    section.add "api-version", valid_574321
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

proc call*(call_574323: Call_NetworkWatchersCheckConnectivity_574315;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies the possibility of establishing a direct TCP connection from a virtual machine to a given endpoint including another VM or an arbitrary remote server.
  ## 
  let valid = call_574323.validator(path, query, header, formData, body)
  let scheme = call_574323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574323.url(scheme.get, call_574323.host, call_574323.base,
                         call_574323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574323, url, valid)

proc call*(call_574324: Call_NetworkWatchersCheckConnectivity_574315;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersCheckConnectivity
  ## Verifies the possibility of establishing a direct TCP connection from a virtual machine to a given endpoint including another VM or an arbitrary remote server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the network watcher resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher resource.
  ##   parameters: JObject (required)
  ##             : Parameters that determine how the connectivity check will be performed.
  var path_574325 = newJObject()
  var query_574326 = newJObject()
  var body_574327 = newJObject()
  add(path_574325, "resourceGroupName", newJString(resourceGroupName))
  add(query_574326, "api-version", newJString(apiVersion))
  add(path_574325, "subscriptionId", newJString(subscriptionId))
  add(path_574325, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_574327 = parameters
  result = call_574324.call(path_574325, query_574326, nil, nil, body_574327)

var networkWatchersCheckConnectivity* = Call_NetworkWatchersCheckConnectivity_574315(
    name: "networkWatchersCheckConnectivity", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectivityCheck",
    validator: validate_NetworkWatchersCheckConnectivity_574316, base: "",
    url: url_NetworkWatchersCheckConnectivity_574317, schemes: {Scheme.Https})
type
  Call_NetworkWatchersVerifyIPFlow_574328 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersVerifyIPFlow_574330(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersVerifyIPFlow_574329(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verify IP flow from the specified VM to a location given the currently configured NSG rules.
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
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574331 = path.getOrDefault("resourceGroupName")
  valid_574331 = validateParameter(valid_574331, JString, required = true,
                                 default = nil)
  if valid_574331 != nil:
    section.add "resourceGroupName", valid_574331
  var valid_574332 = path.getOrDefault("subscriptionId")
  valid_574332 = validateParameter(valid_574332, JString, required = true,
                                 default = nil)
  if valid_574332 != nil:
    section.add "subscriptionId", valid_574332
  var valid_574333 = path.getOrDefault("networkWatcherName")
  valid_574333 = validateParameter(valid_574333, JString, required = true,
                                 default = nil)
  if valid_574333 != nil:
    section.add "networkWatcherName", valid_574333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574334 = query.getOrDefault("api-version")
  valid_574334 = validateParameter(valid_574334, JString, required = true,
                                 default = nil)
  if valid_574334 != nil:
    section.add "api-version", valid_574334
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

proc call*(call_574336: Call_NetworkWatchersVerifyIPFlow_574328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verify IP flow from the specified VM to a location given the currently configured NSG rules.
  ## 
  let valid = call_574336.validator(path, query, header, formData, body)
  let scheme = call_574336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574336.url(scheme.get, call_574336.host, call_574336.base,
                         call_574336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574336, url, valid)

proc call*(call_574337: Call_NetworkWatchersVerifyIPFlow_574328;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersVerifyIPFlow
  ## Verify IP flow from the specified VM to a location given the currently configured NSG rules.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   parameters: JObject (required)
  ##             : Parameters that define the IP flow to be verified.
  var path_574338 = newJObject()
  var query_574339 = newJObject()
  var body_574340 = newJObject()
  add(path_574338, "resourceGroupName", newJString(resourceGroupName))
  add(query_574339, "api-version", newJString(apiVersion))
  add(path_574338, "subscriptionId", newJString(subscriptionId))
  add(path_574338, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_574340 = parameters
  result = call_574337.call(path_574338, query_574339, nil, nil, body_574340)

var networkWatchersVerifyIPFlow* = Call_NetworkWatchersVerifyIPFlow_574328(
    name: "networkWatchersVerifyIPFlow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/ipFlowVerify",
    validator: validate_NetworkWatchersVerifyIPFlow_574329, base: "",
    url: url_NetworkWatchersVerifyIPFlow_574330, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetNetworkConfigurationDiagnostic_574341 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersGetNetworkConfigurationDiagnostic_574343(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkWatchers/"),
               (kind: VariableSegment, value: "networkWatcherName"), (
        kind: ConstantSegment, value: "/networkConfigurationDiagnostic")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkWatchersGetNetworkConfigurationDiagnostic_574342(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets Network Configuration Diagnostic data to help customers understand and debug network behavior. It provides detailed information on what security rules were applied to a specified traffic flow and the result of evaluating these rules. Customers must provide details of a flow like source, destination, protocol, etc. The API returns whether traffic was allowed or denied, the rules evaluated for the specified flow and the evaluation results.
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
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574344 = path.getOrDefault("resourceGroupName")
  valid_574344 = validateParameter(valid_574344, JString, required = true,
                                 default = nil)
  if valid_574344 != nil:
    section.add "resourceGroupName", valid_574344
  var valid_574345 = path.getOrDefault("subscriptionId")
  valid_574345 = validateParameter(valid_574345, JString, required = true,
                                 default = nil)
  if valid_574345 != nil:
    section.add "subscriptionId", valid_574345
  var valid_574346 = path.getOrDefault("networkWatcherName")
  valid_574346 = validateParameter(valid_574346, JString, required = true,
                                 default = nil)
  if valid_574346 != nil:
    section.add "networkWatcherName", valid_574346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574347 = query.getOrDefault("api-version")
  valid_574347 = validateParameter(valid_574347, JString, required = true,
                                 default = nil)
  if valid_574347 != nil:
    section.add "api-version", valid_574347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to get network configuration diagnostic.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574349: Call_NetworkWatchersGetNetworkConfigurationDiagnostic_574341;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets Network Configuration Diagnostic data to help customers understand and debug network behavior. It provides detailed information on what security rules were applied to a specified traffic flow and the result of evaluating these rules. Customers must provide details of a flow like source, destination, protocol, etc. The API returns whether traffic was allowed or denied, the rules evaluated for the specified flow and the evaluation results.
  ## 
  let valid = call_574349.validator(path, query, header, formData, body)
  let scheme = call_574349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574349.url(scheme.get, call_574349.host, call_574349.base,
                         call_574349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574349, url, valid)

proc call*(call_574350: Call_NetworkWatchersGetNetworkConfigurationDiagnostic_574341;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetNetworkConfigurationDiagnostic
  ## Gets Network Configuration Diagnostic data to help customers understand and debug network behavior. It provides detailed information on what security rules were applied to a specified traffic flow and the result of evaluating these rules. Customers must provide details of a flow like source, destination, protocol, etc. The API returns whether traffic was allowed or denied, the rules evaluated for the specified flow and the evaluation results.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   parameters: JObject (required)
  ##             : Parameters to get network configuration diagnostic.
  var path_574351 = newJObject()
  var query_574352 = newJObject()
  var body_574353 = newJObject()
  add(path_574351, "resourceGroupName", newJString(resourceGroupName))
  add(query_574352, "api-version", newJString(apiVersion))
  add(path_574351, "subscriptionId", newJString(subscriptionId))
  add(path_574351, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_574353 = parameters
  result = call_574350.call(path_574351, query_574352, nil, nil, body_574353)

var networkWatchersGetNetworkConfigurationDiagnostic* = Call_NetworkWatchersGetNetworkConfigurationDiagnostic_574341(
    name: "networkWatchersGetNetworkConfigurationDiagnostic",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/networkConfigurationDiagnostic",
    validator: validate_NetworkWatchersGetNetworkConfigurationDiagnostic_574342,
    base: "", url: url_NetworkWatchersGetNetworkConfigurationDiagnostic_574343,
    schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetNextHop_574354 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersGetNextHop_574356(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetNextHop_574355(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the next hop from the specified VM.
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
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574357 = path.getOrDefault("resourceGroupName")
  valid_574357 = validateParameter(valid_574357, JString, required = true,
                                 default = nil)
  if valid_574357 != nil:
    section.add "resourceGroupName", valid_574357
  var valid_574358 = path.getOrDefault("subscriptionId")
  valid_574358 = validateParameter(valid_574358, JString, required = true,
                                 default = nil)
  if valid_574358 != nil:
    section.add "subscriptionId", valid_574358
  var valid_574359 = path.getOrDefault("networkWatcherName")
  valid_574359 = validateParameter(valid_574359, JString, required = true,
                                 default = nil)
  if valid_574359 != nil:
    section.add "networkWatcherName", valid_574359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574360 = query.getOrDefault("api-version")
  valid_574360 = validateParameter(valid_574360, JString, required = true,
                                 default = nil)
  if valid_574360 != nil:
    section.add "api-version", valid_574360
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

proc call*(call_574362: Call_NetworkWatchersGetNextHop_574354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the next hop from the specified VM.
  ## 
  let valid = call_574362.validator(path, query, header, formData, body)
  let scheme = call_574362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574362.url(scheme.get, call_574362.host, call_574362.base,
                         call_574362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574362, url, valid)

proc call*(call_574363: Call_NetworkWatchersGetNextHop_574354;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetNextHop
  ## Gets the next hop from the specified VM.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   parameters: JObject (required)
  ##             : Parameters that define the source and destination endpoint.
  var path_574364 = newJObject()
  var query_574365 = newJObject()
  var body_574366 = newJObject()
  add(path_574364, "resourceGroupName", newJString(resourceGroupName))
  add(query_574365, "api-version", newJString(apiVersion))
  add(path_574364, "subscriptionId", newJString(subscriptionId))
  add(path_574364, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_574366 = parameters
  result = call_574363.call(path_574364, query_574365, nil, nil, body_574366)

var networkWatchersGetNextHop* = Call_NetworkWatchersGetNextHop_574354(
    name: "networkWatchersGetNextHop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/nextHop",
    validator: validate_NetworkWatchersGetNextHop_574355, base: "",
    url: url_NetworkWatchersGetNextHop_574356, schemes: {Scheme.Https})
type
  Call_PacketCapturesList_574367 = ref object of OpenApiRestCall_573667
proc url_PacketCapturesList_574369(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesList_574368(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all packet capture sessions within the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574370 = path.getOrDefault("resourceGroupName")
  valid_574370 = validateParameter(valid_574370, JString, required = true,
                                 default = nil)
  if valid_574370 != nil:
    section.add "resourceGroupName", valid_574370
  var valid_574371 = path.getOrDefault("subscriptionId")
  valid_574371 = validateParameter(valid_574371, JString, required = true,
                                 default = nil)
  if valid_574371 != nil:
    section.add "subscriptionId", valid_574371
  var valid_574372 = path.getOrDefault("networkWatcherName")
  valid_574372 = validateParameter(valid_574372, JString, required = true,
                                 default = nil)
  if valid_574372 != nil:
    section.add "networkWatcherName", valid_574372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574373 = query.getOrDefault("api-version")
  valid_574373 = validateParameter(valid_574373, JString, required = true,
                                 default = nil)
  if valid_574373 != nil:
    section.add "api-version", valid_574373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574374: Call_PacketCapturesList_574367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all packet capture sessions within the specified resource group.
  ## 
  let valid = call_574374.validator(path, query, header, formData, body)
  let scheme = call_574374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574374.url(scheme.get, call_574374.host, call_574374.base,
                         call_574374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574374, url, valid)

proc call*(call_574375: Call_PacketCapturesList_574367; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; networkWatcherName: string): Recallable =
  ## packetCapturesList
  ## Lists all packet capture sessions within the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  var path_574376 = newJObject()
  var query_574377 = newJObject()
  add(path_574376, "resourceGroupName", newJString(resourceGroupName))
  add(query_574377, "api-version", newJString(apiVersion))
  add(path_574376, "subscriptionId", newJString(subscriptionId))
  add(path_574376, "networkWatcherName", newJString(networkWatcherName))
  result = call_574375.call(path_574376, query_574377, nil, nil, nil)

var packetCapturesList* = Call_PacketCapturesList_574367(
    name: "packetCapturesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures",
    validator: validate_PacketCapturesList_574368, base: "",
    url: url_PacketCapturesList_574369, schemes: {Scheme.Https})
type
  Call_PacketCapturesCreate_574390 = ref object of OpenApiRestCall_573667
proc url_PacketCapturesCreate_574392(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesCreate_574391(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create and start a packet capture on the specified VM.
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
  ##   packetCaptureName: JString (required)
  ##                    : The name of the packet capture session.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574393 = path.getOrDefault("resourceGroupName")
  valid_574393 = validateParameter(valid_574393, JString, required = true,
                                 default = nil)
  if valid_574393 != nil:
    section.add "resourceGroupName", valid_574393
  var valid_574394 = path.getOrDefault("subscriptionId")
  valid_574394 = validateParameter(valid_574394, JString, required = true,
                                 default = nil)
  if valid_574394 != nil:
    section.add "subscriptionId", valid_574394
  var valid_574395 = path.getOrDefault("networkWatcherName")
  valid_574395 = validateParameter(valid_574395, JString, required = true,
                                 default = nil)
  if valid_574395 != nil:
    section.add "networkWatcherName", valid_574395
  var valid_574396 = path.getOrDefault("packetCaptureName")
  valid_574396 = validateParameter(valid_574396, JString, required = true,
                                 default = nil)
  if valid_574396 != nil:
    section.add "packetCaptureName", valid_574396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574397 = query.getOrDefault("api-version")
  valid_574397 = validateParameter(valid_574397, JString, required = true,
                                 default = nil)
  if valid_574397 != nil:
    section.add "api-version", valid_574397
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

proc call*(call_574399: Call_PacketCapturesCreate_574390; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create and start a packet capture on the specified VM.
  ## 
  let valid = call_574399.validator(path, query, header, formData, body)
  let scheme = call_574399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574399.url(scheme.get, call_574399.host, call_574399.base,
                         call_574399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574399, url, valid)

proc call*(call_574400: Call_PacketCapturesCreate_574390;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode;
          packetCaptureName: string): Recallable =
  ## packetCapturesCreate
  ## Create and start a packet capture on the specified VM.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   parameters: JObject (required)
  ##             : Parameters that define the create packet capture operation.
  ##   packetCaptureName: string (required)
  ##                    : The name of the packet capture session.
  var path_574401 = newJObject()
  var query_574402 = newJObject()
  var body_574403 = newJObject()
  add(path_574401, "resourceGroupName", newJString(resourceGroupName))
  add(query_574402, "api-version", newJString(apiVersion))
  add(path_574401, "subscriptionId", newJString(subscriptionId))
  add(path_574401, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_574403 = parameters
  add(path_574401, "packetCaptureName", newJString(packetCaptureName))
  result = call_574400.call(path_574401, query_574402, nil, nil, body_574403)

var packetCapturesCreate* = Call_PacketCapturesCreate_574390(
    name: "packetCapturesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}",
    validator: validate_PacketCapturesCreate_574391, base: "",
    url: url_PacketCapturesCreate_574392, schemes: {Scheme.Https})
type
  Call_PacketCapturesGet_574378 = ref object of OpenApiRestCall_573667
proc url_PacketCapturesGet_574380(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesGet_574379(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a packet capture session by name.
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
  ##   packetCaptureName: JString (required)
  ##                    : The name of the packet capture session.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574381 = path.getOrDefault("resourceGroupName")
  valid_574381 = validateParameter(valid_574381, JString, required = true,
                                 default = nil)
  if valid_574381 != nil:
    section.add "resourceGroupName", valid_574381
  var valid_574382 = path.getOrDefault("subscriptionId")
  valid_574382 = validateParameter(valid_574382, JString, required = true,
                                 default = nil)
  if valid_574382 != nil:
    section.add "subscriptionId", valid_574382
  var valid_574383 = path.getOrDefault("networkWatcherName")
  valid_574383 = validateParameter(valid_574383, JString, required = true,
                                 default = nil)
  if valid_574383 != nil:
    section.add "networkWatcherName", valid_574383
  var valid_574384 = path.getOrDefault("packetCaptureName")
  valid_574384 = validateParameter(valid_574384, JString, required = true,
                                 default = nil)
  if valid_574384 != nil:
    section.add "packetCaptureName", valid_574384
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574385 = query.getOrDefault("api-version")
  valid_574385 = validateParameter(valid_574385, JString, required = true,
                                 default = nil)
  if valid_574385 != nil:
    section.add "api-version", valid_574385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574386: Call_PacketCapturesGet_574378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a packet capture session by name.
  ## 
  let valid = call_574386.validator(path, query, header, formData, body)
  let scheme = call_574386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574386.url(scheme.get, call_574386.host, call_574386.base,
                         call_574386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574386, url, valid)

proc call*(call_574387: Call_PacketCapturesGet_574378; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; networkWatcherName: string;
          packetCaptureName: string): Recallable =
  ## packetCapturesGet
  ## Gets a packet capture session by name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   packetCaptureName: string (required)
  ##                    : The name of the packet capture session.
  var path_574388 = newJObject()
  var query_574389 = newJObject()
  add(path_574388, "resourceGroupName", newJString(resourceGroupName))
  add(query_574389, "api-version", newJString(apiVersion))
  add(path_574388, "subscriptionId", newJString(subscriptionId))
  add(path_574388, "networkWatcherName", newJString(networkWatcherName))
  add(path_574388, "packetCaptureName", newJString(packetCaptureName))
  result = call_574387.call(path_574388, query_574389, nil, nil, nil)

var packetCapturesGet* = Call_PacketCapturesGet_574378(name: "packetCapturesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}",
    validator: validate_PacketCapturesGet_574379, base: "",
    url: url_PacketCapturesGet_574380, schemes: {Scheme.Https})
type
  Call_PacketCapturesDelete_574404 = ref object of OpenApiRestCall_573667
proc url_PacketCapturesDelete_574406(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesDelete_574405(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified packet capture session.
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
  ##   packetCaptureName: JString (required)
  ##                    : The name of the packet capture session.
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
  var valid_574409 = path.getOrDefault("networkWatcherName")
  valid_574409 = validateParameter(valid_574409, JString, required = true,
                                 default = nil)
  if valid_574409 != nil:
    section.add "networkWatcherName", valid_574409
  var valid_574410 = path.getOrDefault("packetCaptureName")
  valid_574410 = validateParameter(valid_574410, JString, required = true,
                                 default = nil)
  if valid_574410 != nil:
    section.add "packetCaptureName", valid_574410
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

proc call*(call_574412: Call_PacketCapturesDelete_574404; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified packet capture session.
  ## 
  let valid = call_574412.validator(path, query, header, formData, body)
  let scheme = call_574412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574412.url(scheme.get, call_574412.host, call_574412.base,
                         call_574412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574412, url, valid)

proc call*(call_574413: Call_PacketCapturesDelete_574404;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; packetCaptureName: string): Recallable =
  ## packetCapturesDelete
  ## Deletes the specified packet capture session.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   packetCaptureName: string (required)
  ##                    : The name of the packet capture session.
  var path_574414 = newJObject()
  var query_574415 = newJObject()
  add(path_574414, "resourceGroupName", newJString(resourceGroupName))
  add(query_574415, "api-version", newJString(apiVersion))
  add(path_574414, "subscriptionId", newJString(subscriptionId))
  add(path_574414, "networkWatcherName", newJString(networkWatcherName))
  add(path_574414, "packetCaptureName", newJString(packetCaptureName))
  result = call_574413.call(path_574414, query_574415, nil, nil, nil)

var packetCapturesDelete* = Call_PacketCapturesDelete_574404(
    name: "packetCapturesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}",
    validator: validate_PacketCapturesDelete_574405, base: "",
    url: url_PacketCapturesDelete_574406, schemes: {Scheme.Https})
type
  Call_PacketCapturesGetStatus_574416 = ref object of OpenApiRestCall_573667
proc url_PacketCapturesGetStatus_574418(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesGetStatus_574417(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query the status of a running packet capture session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the Network Watcher resource.
  ##   packetCaptureName: JString (required)
  ##                    : The name given to the packet capture session.
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
  var valid_574421 = path.getOrDefault("networkWatcherName")
  valid_574421 = validateParameter(valid_574421, JString, required = true,
                                 default = nil)
  if valid_574421 != nil:
    section.add "networkWatcherName", valid_574421
  var valid_574422 = path.getOrDefault("packetCaptureName")
  valid_574422 = validateParameter(valid_574422, JString, required = true,
                                 default = nil)
  if valid_574422 != nil:
    section.add "packetCaptureName", valid_574422
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
  if body != nil:
    result.add "body", body

proc call*(call_574424: Call_PacketCapturesGetStatus_574416; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the status of a running packet capture session.
  ## 
  let valid = call_574424.validator(path, query, header, formData, body)
  let scheme = call_574424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574424.url(scheme.get, call_574424.host, call_574424.base,
                         call_574424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574424, url, valid)

proc call*(call_574425: Call_PacketCapturesGetStatus_574416;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; packetCaptureName: string): Recallable =
  ## packetCapturesGetStatus
  ## Query the status of a running packet capture session.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the Network Watcher resource.
  ##   packetCaptureName: string (required)
  ##                    : The name given to the packet capture session.
  var path_574426 = newJObject()
  var query_574427 = newJObject()
  add(path_574426, "resourceGroupName", newJString(resourceGroupName))
  add(query_574427, "api-version", newJString(apiVersion))
  add(path_574426, "subscriptionId", newJString(subscriptionId))
  add(path_574426, "networkWatcherName", newJString(networkWatcherName))
  add(path_574426, "packetCaptureName", newJString(packetCaptureName))
  result = call_574425.call(path_574426, query_574427, nil, nil, nil)

var packetCapturesGetStatus* = Call_PacketCapturesGetStatus_574416(
    name: "packetCapturesGetStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}/queryStatus",
    validator: validate_PacketCapturesGetStatus_574417, base: "",
    url: url_PacketCapturesGetStatus_574418, schemes: {Scheme.Https})
type
  Call_PacketCapturesStop_574428 = ref object of OpenApiRestCall_573667
proc url_PacketCapturesStop_574430(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesStop_574429(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Stops a specified packet capture session.
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
  ##   packetCaptureName: JString (required)
  ##                    : The name of the packet capture session.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574431 = path.getOrDefault("resourceGroupName")
  valid_574431 = validateParameter(valid_574431, JString, required = true,
                                 default = nil)
  if valid_574431 != nil:
    section.add "resourceGroupName", valid_574431
  var valid_574432 = path.getOrDefault("subscriptionId")
  valid_574432 = validateParameter(valid_574432, JString, required = true,
                                 default = nil)
  if valid_574432 != nil:
    section.add "subscriptionId", valid_574432
  var valid_574433 = path.getOrDefault("networkWatcherName")
  valid_574433 = validateParameter(valid_574433, JString, required = true,
                                 default = nil)
  if valid_574433 != nil:
    section.add "networkWatcherName", valid_574433
  var valid_574434 = path.getOrDefault("packetCaptureName")
  valid_574434 = validateParameter(valid_574434, JString, required = true,
                                 default = nil)
  if valid_574434 != nil:
    section.add "packetCaptureName", valid_574434
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574435 = query.getOrDefault("api-version")
  valid_574435 = validateParameter(valid_574435, JString, required = true,
                                 default = nil)
  if valid_574435 != nil:
    section.add "api-version", valid_574435
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574436: Call_PacketCapturesStop_574428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a specified packet capture session.
  ## 
  let valid = call_574436.validator(path, query, header, formData, body)
  let scheme = call_574436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574436.url(scheme.get, call_574436.host, call_574436.base,
                         call_574436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574436, url, valid)

proc call*(call_574437: Call_PacketCapturesStop_574428; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; networkWatcherName: string;
          packetCaptureName: string): Recallable =
  ## packetCapturesStop
  ## Stops a specified packet capture session.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   packetCaptureName: string (required)
  ##                    : The name of the packet capture session.
  var path_574438 = newJObject()
  var query_574439 = newJObject()
  add(path_574438, "resourceGroupName", newJString(resourceGroupName))
  add(query_574439, "api-version", newJString(apiVersion))
  add(path_574438, "subscriptionId", newJString(subscriptionId))
  add(path_574438, "networkWatcherName", newJString(networkWatcherName))
  add(path_574438, "packetCaptureName", newJString(packetCaptureName))
  result = call_574437.call(path_574438, query_574439, nil, nil, nil)

var packetCapturesStop* = Call_PacketCapturesStop_574428(
    name: "packetCapturesStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}/stop",
    validator: validate_PacketCapturesStop_574429, base: "",
    url: url_PacketCapturesStop_574430, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetFlowLogStatus_574440 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersGetFlowLogStatus_574442(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetFlowLogStatus_574441(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries status of flow log and traffic analytics (optional) on a specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the network watcher resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574443 = path.getOrDefault("resourceGroupName")
  valid_574443 = validateParameter(valid_574443, JString, required = true,
                                 default = nil)
  if valid_574443 != nil:
    section.add "resourceGroupName", valid_574443
  var valid_574444 = path.getOrDefault("subscriptionId")
  valid_574444 = validateParameter(valid_574444, JString, required = true,
                                 default = nil)
  if valid_574444 != nil:
    section.add "subscriptionId", valid_574444
  var valid_574445 = path.getOrDefault("networkWatcherName")
  valid_574445 = validateParameter(valid_574445, JString, required = true,
                                 default = nil)
  if valid_574445 != nil:
    section.add "networkWatcherName", valid_574445
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574446 = query.getOrDefault("api-version")
  valid_574446 = validateParameter(valid_574446, JString, required = true,
                                 default = nil)
  if valid_574446 != nil:
    section.add "api-version", valid_574446
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that define a resource to query flow log and traffic analytics (optional) status.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574448: Call_NetworkWatchersGetFlowLogStatus_574440;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries status of flow log and traffic analytics (optional) on a specified resource.
  ## 
  let valid = call_574448.validator(path, query, header, formData, body)
  let scheme = call_574448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574448.url(scheme.get, call_574448.host, call_574448.base,
                         call_574448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574448, url, valid)

proc call*(call_574449: Call_NetworkWatchersGetFlowLogStatus_574440;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetFlowLogStatus
  ## Queries status of flow log and traffic analytics (optional) on a specified resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the network watcher resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher resource.
  ##   parameters: JObject (required)
  ##             : Parameters that define a resource to query flow log and traffic analytics (optional) status.
  var path_574450 = newJObject()
  var query_574451 = newJObject()
  var body_574452 = newJObject()
  add(path_574450, "resourceGroupName", newJString(resourceGroupName))
  add(query_574451, "api-version", newJString(apiVersion))
  add(path_574450, "subscriptionId", newJString(subscriptionId))
  add(path_574450, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_574452 = parameters
  result = call_574449.call(path_574450, query_574451, nil, nil, body_574452)

var networkWatchersGetFlowLogStatus* = Call_NetworkWatchersGetFlowLogStatus_574440(
    name: "networkWatchersGetFlowLogStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/queryFlowLogStatus",
    validator: validate_NetworkWatchersGetFlowLogStatus_574441, base: "",
    url: url_NetworkWatchersGetFlowLogStatus_574442, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetTroubleshootingResult_574453 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersGetTroubleshootingResult_574455(protocol: Scheme;
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

proc validate_NetworkWatchersGetTroubleshootingResult_574454(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the last completed troubleshooting result on a specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574456 = path.getOrDefault("resourceGroupName")
  valid_574456 = validateParameter(valid_574456, JString, required = true,
                                 default = nil)
  if valid_574456 != nil:
    section.add "resourceGroupName", valid_574456
  var valid_574457 = path.getOrDefault("subscriptionId")
  valid_574457 = validateParameter(valid_574457, JString, required = true,
                                 default = nil)
  if valid_574457 != nil:
    section.add "subscriptionId", valid_574457
  var valid_574458 = path.getOrDefault("networkWatcherName")
  valid_574458 = validateParameter(valid_574458, JString, required = true,
                                 default = nil)
  if valid_574458 != nil:
    section.add "networkWatcherName", valid_574458
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574459 = query.getOrDefault("api-version")
  valid_574459 = validateParameter(valid_574459, JString, required = true,
                                 default = nil)
  if valid_574459 != nil:
    section.add "api-version", valid_574459
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

proc call*(call_574461: Call_NetworkWatchersGetTroubleshootingResult_574453;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the last completed troubleshooting result on a specified resource.
  ## 
  let valid = call_574461.validator(path, query, header, formData, body)
  let scheme = call_574461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574461.url(scheme.get, call_574461.host, call_574461.base,
                         call_574461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574461, url, valid)

proc call*(call_574462: Call_NetworkWatchersGetTroubleshootingResult_574453;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetTroubleshootingResult
  ## Get the last completed troubleshooting result on a specified resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher resource.
  ##   parameters: JObject (required)
  ##             : Parameters that define the resource to query the troubleshooting result.
  var path_574463 = newJObject()
  var query_574464 = newJObject()
  var body_574465 = newJObject()
  add(path_574463, "resourceGroupName", newJString(resourceGroupName))
  add(query_574464, "api-version", newJString(apiVersion))
  add(path_574463, "subscriptionId", newJString(subscriptionId))
  add(path_574463, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_574465 = parameters
  result = call_574462.call(path_574463, query_574464, nil, nil, body_574465)

var networkWatchersGetTroubleshootingResult* = Call_NetworkWatchersGetTroubleshootingResult_574453(
    name: "networkWatchersGetTroubleshootingResult", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/queryTroubleshootResult",
    validator: validate_NetworkWatchersGetTroubleshootingResult_574454, base: "",
    url: url_NetworkWatchersGetTroubleshootingResult_574455,
    schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetVMSecurityRules_574466 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersGetVMSecurityRules_574468(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetVMSecurityRules_574467(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the configured and effective security group rules on the specified VM.
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
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574469 = path.getOrDefault("resourceGroupName")
  valid_574469 = validateParameter(valid_574469, JString, required = true,
                                 default = nil)
  if valid_574469 != nil:
    section.add "resourceGroupName", valid_574469
  var valid_574470 = path.getOrDefault("subscriptionId")
  valid_574470 = validateParameter(valid_574470, JString, required = true,
                                 default = nil)
  if valid_574470 != nil:
    section.add "subscriptionId", valid_574470
  var valid_574471 = path.getOrDefault("networkWatcherName")
  valid_574471 = validateParameter(valid_574471, JString, required = true,
                                 default = nil)
  if valid_574471 != nil:
    section.add "networkWatcherName", valid_574471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574472 = query.getOrDefault("api-version")
  valid_574472 = validateParameter(valid_574472, JString, required = true,
                                 default = nil)
  if valid_574472 != nil:
    section.add "api-version", valid_574472
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

proc call*(call_574474: Call_NetworkWatchersGetVMSecurityRules_574466;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the configured and effective security group rules on the specified VM.
  ## 
  let valid = call_574474.validator(path, query, header, formData, body)
  let scheme = call_574474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574474.url(scheme.get, call_574474.host, call_574474.base,
                         call_574474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574474, url, valid)

proc call*(call_574475: Call_NetworkWatchersGetVMSecurityRules_574466;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetVMSecurityRules
  ## Gets the configured and effective security group rules on the specified VM.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   parameters: JObject (required)
  ##             : Parameters that define the VM to check security groups for.
  var path_574476 = newJObject()
  var query_574477 = newJObject()
  var body_574478 = newJObject()
  add(path_574476, "resourceGroupName", newJString(resourceGroupName))
  add(query_574477, "api-version", newJString(apiVersion))
  add(path_574476, "subscriptionId", newJString(subscriptionId))
  add(path_574476, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_574478 = parameters
  result = call_574475.call(path_574476, query_574477, nil, nil, body_574478)

var networkWatchersGetVMSecurityRules* = Call_NetworkWatchersGetVMSecurityRules_574466(
    name: "networkWatchersGetVMSecurityRules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/securityGroupView",
    validator: validate_NetworkWatchersGetVMSecurityRules_574467, base: "",
    url: url_NetworkWatchersGetVMSecurityRules_574468, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetTopology_574479 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersGetTopology_574481(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetTopology_574480(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the current network topology by resource group.
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
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574482 = path.getOrDefault("resourceGroupName")
  valid_574482 = validateParameter(valid_574482, JString, required = true,
                                 default = nil)
  if valid_574482 != nil:
    section.add "resourceGroupName", valid_574482
  var valid_574483 = path.getOrDefault("subscriptionId")
  valid_574483 = validateParameter(valid_574483, JString, required = true,
                                 default = nil)
  if valid_574483 != nil:
    section.add "subscriptionId", valid_574483
  var valid_574484 = path.getOrDefault("networkWatcherName")
  valid_574484 = validateParameter(valid_574484, JString, required = true,
                                 default = nil)
  if valid_574484 != nil:
    section.add "networkWatcherName", valid_574484
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574485 = query.getOrDefault("api-version")
  valid_574485 = validateParameter(valid_574485, JString, required = true,
                                 default = nil)
  if valid_574485 != nil:
    section.add "api-version", valid_574485
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

proc call*(call_574487: Call_NetworkWatchersGetTopology_574479; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current network topology by resource group.
  ## 
  let valid = call_574487.validator(path, query, header, formData, body)
  let scheme = call_574487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574487.url(scheme.get, call_574487.host, call_574487.base,
                         call_574487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574487, url, valid)

proc call*(call_574488: Call_NetworkWatchersGetTopology_574479;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetTopology
  ## Gets the current network topology by resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher.
  ##   parameters: JObject (required)
  ##             : Parameters that define the representation of topology.
  var path_574489 = newJObject()
  var query_574490 = newJObject()
  var body_574491 = newJObject()
  add(path_574489, "resourceGroupName", newJString(resourceGroupName))
  add(query_574490, "api-version", newJString(apiVersion))
  add(path_574489, "subscriptionId", newJString(subscriptionId))
  add(path_574489, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_574491 = parameters
  result = call_574488.call(path_574489, query_574490, nil, nil, body_574491)

var networkWatchersGetTopology* = Call_NetworkWatchersGetTopology_574479(
    name: "networkWatchersGetTopology", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/topology",
    validator: validate_NetworkWatchersGetTopology_574480, base: "",
    url: url_NetworkWatchersGetTopology_574481, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetTroubleshooting_574492 = ref object of OpenApiRestCall_573667
proc url_NetworkWatchersGetTroubleshooting_574494(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetTroubleshooting_574493(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Initiate troubleshooting on a specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: JString (required)
  ##                     : The name of the network watcher resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574495 = path.getOrDefault("resourceGroupName")
  valid_574495 = validateParameter(valid_574495, JString, required = true,
                                 default = nil)
  if valid_574495 != nil:
    section.add "resourceGroupName", valid_574495
  var valid_574496 = path.getOrDefault("subscriptionId")
  valid_574496 = validateParameter(valid_574496, JString, required = true,
                                 default = nil)
  if valid_574496 != nil:
    section.add "subscriptionId", valid_574496
  var valid_574497 = path.getOrDefault("networkWatcherName")
  valid_574497 = validateParameter(valid_574497, JString, required = true,
                                 default = nil)
  if valid_574497 != nil:
    section.add "networkWatcherName", valid_574497
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574498 = query.getOrDefault("api-version")
  valid_574498 = validateParameter(valid_574498, JString, required = true,
                                 default = nil)
  if valid_574498 != nil:
    section.add "api-version", valid_574498
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

proc call*(call_574500: Call_NetworkWatchersGetTroubleshooting_574492;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Initiate troubleshooting on a specified resource.
  ## 
  let valid = call_574500.validator(path, query, header, formData, body)
  let scheme = call_574500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574500.url(scheme.get, call_574500.host, call_574500.base,
                         call_574500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574500, url, valid)

proc call*(call_574501: Call_NetworkWatchersGetTroubleshooting_574492;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetTroubleshooting
  ## Initiate troubleshooting on a specified resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher resource.
  ##   parameters: JObject (required)
  ##             : Parameters that define the resource to troubleshoot.
  var path_574502 = newJObject()
  var query_574503 = newJObject()
  var body_574504 = newJObject()
  add(path_574502, "resourceGroupName", newJString(resourceGroupName))
  add(query_574503, "api-version", newJString(apiVersion))
  add(path_574502, "subscriptionId", newJString(subscriptionId))
  add(path_574502, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_574504 = parameters
  result = call_574501.call(path_574502, query_574503, nil, nil, body_574504)

var networkWatchersGetTroubleshooting* = Call_NetworkWatchersGetTroubleshooting_574492(
    name: "networkWatchersGetTroubleshooting", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/troubleshoot",
    validator: validate_NetworkWatchersGetTroubleshooting_574493, base: "",
    url: url_NetworkWatchersGetTroubleshooting_574494, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
