
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2018-06-01
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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
  macServiceName = "network-networkWatcher"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_NetworkWatchersListAll_593660 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersListAll_593662(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkWatchersListAll_593661(path: JsonNode; query: JsonNode;
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
  var valid_593822 = path.getOrDefault("subscriptionId")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "subscriptionId", valid_593822
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593823 = query.getOrDefault("api-version")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "api-version", valid_593823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593850: Call_NetworkWatchersListAll_593660; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all network watchers by subscription.
  ## 
  let valid = call_593850.validator(path, query, header, formData, body)
  let scheme = call_593850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593850.url(scheme.get, call_593850.host, call_593850.base,
                         call_593850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593850, url, valid)

proc call*(call_593921: Call_NetworkWatchersListAll_593660; apiVersion: string;
          subscriptionId: string): Recallable =
  ## networkWatchersListAll
  ## Gets all network watchers by subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593922 = newJObject()
  var query_593924 = newJObject()
  add(query_593924, "api-version", newJString(apiVersion))
  add(path_593922, "subscriptionId", newJString(subscriptionId))
  result = call_593921.call(path_593922, query_593924, nil, nil, nil)

var networkWatchersListAll* = Call_NetworkWatchersListAll_593660(
    name: "networkWatchersListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/networkWatchers",
    validator: validate_NetworkWatchersListAll_593661, base: "",
    url: url_NetworkWatchersListAll_593662, schemes: {Scheme.Https})
type
  Call_NetworkWatchersList_593963 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersList_593965(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkWatchersList_593964(path: JsonNode; query: JsonNode;
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
  var valid_593966 = path.getOrDefault("resourceGroupName")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "resourceGroupName", valid_593966
  var valid_593967 = path.getOrDefault("subscriptionId")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "subscriptionId", valid_593967
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593968 = query.getOrDefault("api-version")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "api-version", valid_593968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593969: Call_NetworkWatchersList_593963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all network watchers by resource group.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_NetworkWatchersList_593963; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## networkWatchersList
  ## Gets all network watchers by resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593971 = newJObject()
  var query_593972 = newJObject()
  add(path_593971, "resourceGroupName", newJString(resourceGroupName))
  add(query_593972, "api-version", newJString(apiVersion))
  add(path_593971, "subscriptionId", newJString(subscriptionId))
  result = call_593970.call(path_593971, query_593972, nil, nil, nil)

var networkWatchersList* = Call_NetworkWatchersList_593963(
    name: "networkWatchersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers",
    validator: validate_NetworkWatchersList_593964, base: "",
    url: url_NetworkWatchersList_593965, schemes: {Scheme.Https})
type
  Call_NetworkWatchersCreateOrUpdate_593984 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersCreateOrUpdate_593986(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersCreateOrUpdate_593985(path: JsonNode; query: JsonNode;
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
  var valid_594013 = path.getOrDefault("resourceGroupName")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "resourceGroupName", valid_594013
  var valid_594014 = path.getOrDefault("subscriptionId")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "subscriptionId", valid_594014
  var valid_594015 = path.getOrDefault("networkWatcherName")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "networkWatcherName", valid_594015
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594016 = query.getOrDefault("api-version")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "api-version", valid_594016
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

proc call*(call_594018: Call_NetworkWatchersCreateOrUpdate_593984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a network watcher in the specified resource group.
  ## 
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_NetworkWatchersCreateOrUpdate_593984;
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
  var path_594020 = newJObject()
  var query_594021 = newJObject()
  var body_594022 = newJObject()
  add(path_594020, "resourceGroupName", newJString(resourceGroupName))
  add(query_594021, "api-version", newJString(apiVersion))
  add(path_594020, "subscriptionId", newJString(subscriptionId))
  add(path_594020, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594022 = parameters
  result = call_594019.call(path_594020, query_594021, nil, nil, body_594022)

var networkWatchersCreateOrUpdate* = Call_NetworkWatchersCreateOrUpdate_593984(
    name: "networkWatchersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}",
    validator: validate_NetworkWatchersCreateOrUpdate_593985, base: "",
    url: url_NetworkWatchersCreateOrUpdate_593986, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGet_593973 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersGet_593975(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkWatchersGet_593974(path: JsonNode; query: JsonNode;
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
  var valid_593976 = path.getOrDefault("resourceGroupName")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "resourceGroupName", valid_593976
  var valid_593977 = path.getOrDefault("subscriptionId")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "subscriptionId", valid_593977
  var valid_593978 = path.getOrDefault("networkWatcherName")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "networkWatcherName", valid_593978
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593979 = query.getOrDefault("api-version")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "api-version", valid_593979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593980: Call_NetworkWatchersGet_593973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified network watcher by resource group.
  ## 
  let valid = call_593980.validator(path, query, header, formData, body)
  let scheme = call_593980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593980.url(scheme.get, call_593980.host, call_593980.base,
                         call_593980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593980, url, valid)

proc call*(call_593981: Call_NetworkWatchersGet_593973; resourceGroupName: string;
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
  var path_593982 = newJObject()
  var query_593983 = newJObject()
  add(path_593982, "resourceGroupName", newJString(resourceGroupName))
  add(query_593983, "api-version", newJString(apiVersion))
  add(path_593982, "subscriptionId", newJString(subscriptionId))
  add(path_593982, "networkWatcherName", newJString(networkWatcherName))
  result = call_593981.call(path_593982, query_593983, nil, nil, nil)

var networkWatchersGet* = Call_NetworkWatchersGet_593973(
    name: "networkWatchersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}",
    validator: validate_NetworkWatchersGet_593974, base: "",
    url: url_NetworkWatchersGet_593975, schemes: {Scheme.Https})
type
  Call_NetworkWatchersUpdateTags_594034 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersUpdateTags_594036(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersUpdateTags_594035(path: JsonNode; query: JsonNode;
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
  var valid_594037 = path.getOrDefault("resourceGroupName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "resourceGroupName", valid_594037
  var valid_594038 = path.getOrDefault("subscriptionId")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "subscriptionId", valid_594038
  var valid_594039 = path.getOrDefault("networkWatcherName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "networkWatcherName", valid_594039
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594040 = query.getOrDefault("api-version")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "api-version", valid_594040
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

proc call*(call_594042: Call_NetworkWatchersUpdateTags_594034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a network watcher tags.
  ## 
  let valid = call_594042.validator(path, query, header, formData, body)
  let scheme = call_594042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594042.url(scheme.get, call_594042.host, call_594042.base,
                         call_594042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594042, url, valid)

proc call*(call_594043: Call_NetworkWatchersUpdateTags_594034;
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
  var path_594044 = newJObject()
  var query_594045 = newJObject()
  var body_594046 = newJObject()
  add(path_594044, "resourceGroupName", newJString(resourceGroupName))
  add(query_594045, "api-version", newJString(apiVersion))
  add(path_594044, "subscriptionId", newJString(subscriptionId))
  add(path_594044, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594046 = parameters
  result = call_594043.call(path_594044, query_594045, nil, nil, body_594046)

var networkWatchersUpdateTags* = Call_NetworkWatchersUpdateTags_594034(
    name: "networkWatchersUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}",
    validator: validate_NetworkWatchersUpdateTags_594035, base: "",
    url: url_NetworkWatchersUpdateTags_594036, schemes: {Scheme.Https})
type
  Call_NetworkWatchersDelete_594023 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersDelete_594025(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkWatchersDelete_594024(path: JsonNode; query: JsonNode;
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
  var valid_594026 = path.getOrDefault("resourceGroupName")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "resourceGroupName", valid_594026
  var valid_594027 = path.getOrDefault("subscriptionId")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "subscriptionId", valid_594027
  var valid_594028 = path.getOrDefault("networkWatcherName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "networkWatcherName", valid_594028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594029 = query.getOrDefault("api-version")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "api-version", valid_594029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594030: Call_NetworkWatchersDelete_594023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified network watcher resource.
  ## 
  let valid = call_594030.validator(path, query, header, formData, body)
  let scheme = call_594030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594030.url(scheme.get, call_594030.host, call_594030.base,
                         call_594030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594030, url, valid)

proc call*(call_594031: Call_NetworkWatchersDelete_594023;
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
  var path_594032 = newJObject()
  var query_594033 = newJObject()
  add(path_594032, "resourceGroupName", newJString(resourceGroupName))
  add(query_594033, "api-version", newJString(apiVersion))
  add(path_594032, "subscriptionId", newJString(subscriptionId))
  add(path_594032, "networkWatcherName", newJString(networkWatcherName))
  result = call_594031.call(path_594032, query_594033, nil, nil, nil)

var networkWatchersDelete* = Call_NetworkWatchersDelete_594023(
    name: "networkWatchersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}",
    validator: validate_NetworkWatchersDelete_594024, base: "",
    url: url_NetworkWatchersDelete_594025, schemes: {Scheme.Https})
type
  Call_NetworkWatchersListAvailableProviders_594047 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersListAvailableProviders_594049(protocol: Scheme;
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

proc validate_NetworkWatchersListAvailableProviders_594048(path: JsonNode;
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
  var valid_594050 = path.getOrDefault("resourceGroupName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "resourceGroupName", valid_594050
  var valid_594051 = path.getOrDefault("subscriptionId")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "subscriptionId", valid_594051
  var valid_594052 = path.getOrDefault("networkWatcherName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "networkWatcherName", valid_594052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594053 = query.getOrDefault("api-version")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "api-version", valid_594053
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

proc call*(call_594055: Call_NetworkWatchersListAvailableProviders_594047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available internet service providers for a specified Azure region.
  ## 
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_NetworkWatchersListAvailableProviders_594047;
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
  var path_594057 = newJObject()
  var query_594058 = newJObject()
  var body_594059 = newJObject()
  add(path_594057, "resourceGroupName", newJString(resourceGroupName))
  add(query_594058, "api-version", newJString(apiVersion))
  add(path_594057, "subscriptionId", newJString(subscriptionId))
  add(path_594057, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594059 = parameters
  result = call_594056.call(path_594057, query_594058, nil, nil, body_594059)

var networkWatchersListAvailableProviders* = Call_NetworkWatchersListAvailableProviders_594047(
    name: "networkWatchersListAvailableProviders", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/availableProvidersList",
    validator: validate_NetworkWatchersListAvailableProviders_594048, base: "",
    url: url_NetworkWatchersListAvailableProviders_594049, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetAzureReachabilityReport_594060 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersGetAzureReachabilityReport_594062(protocol: Scheme;
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

proc validate_NetworkWatchersGetAzureReachabilityReport_594061(path: JsonNode;
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
  var valid_594063 = path.getOrDefault("resourceGroupName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "resourceGroupName", valid_594063
  var valid_594064 = path.getOrDefault("subscriptionId")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "subscriptionId", valid_594064
  var valid_594065 = path.getOrDefault("networkWatcherName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "networkWatcherName", valid_594065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594066 = query.getOrDefault("api-version")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "api-version", valid_594066
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

proc call*(call_594068: Call_NetworkWatchersGetAzureReachabilityReport_594060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the relative latency score for internet service providers from a specified location to Azure regions.
  ## 
  let valid = call_594068.validator(path, query, header, formData, body)
  let scheme = call_594068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594068.url(scheme.get, call_594068.host, call_594068.base,
                         call_594068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594068, url, valid)

proc call*(call_594069: Call_NetworkWatchersGetAzureReachabilityReport_594060;
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
  var path_594070 = newJObject()
  var query_594071 = newJObject()
  var body_594072 = newJObject()
  add(path_594070, "resourceGroupName", newJString(resourceGroupName))
  add(query_594071, "api-version", newJString(apiVersion))
  add(path_594070, "subscriptionId", newJString(subscriptionId))
  add(path_594070, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594072 = parameters
  result = call_594069.call(path_594070, query_594071, nil, nil, body_594072)

var networkWatchersGetAzureReachabilityReport* = Call_NetworkWatchersGetAzureReachabilityReport_594060(
    name: "networkWatchersGetAzureReachabilityReport", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/azureReachabilityReport",
    validator: validate_NetworkWatchersGetAzureReachabilityReport_594061,
    base: "", url: url_NetworkWatchersGetAzureReachabilityReport_594062,
    schemes: {Scheme.Https})
type
  Call_NetworkWatchersSetFlowLogConfiguration_594073 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersSetFlowLogConfiguration_594075(protocol: Scheme;
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

proc validate_NetworkWatchersSetFlowLogConfiguration_594074(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Configures flow log  and traffic analytics (optional) on a specified resource.
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
  var valid_594076 = path.getOrDefault("resourceGroupName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "resourceGroupName", valid_594076
  var valid_594077 = path.getOrDefault("subscriptionId")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "subscriptionId", valid_594077
  var valid_594078 = path.getOrDefault("networkWatcherName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "networkWatcherName", valid_594078
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594079 = query.getOrDefault("api-version")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "api-version", valid_594079
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

proc call*(call_594081: Call_NetworkWatchersSetFlowLogConfiguration_594073;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Configures flow log  and traffic analytics (optional) on a specified resource.
  ## 
  let valid = call_594081.validator(path, query, header, formData, body)
  let scheme = call_594081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594081.url(scheme.get, call_594081.host, call_594081.base,
                         call_594081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594081, url, valid)

proc call*(call_594082: Call_NetworkWatchersSetFlowLogConfiguration_594073;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersSetFlowLogConfiguration
  ## Configures flow log  and traffic analytics (optional) on a specified resource.
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
  var path_594083 = newJObject()
  var query_594084 = newJObject()
  var body_594085 = newJObject()
  add(path_594083, "resourceGroupName", newJString(resourceGroupName))
  add(query_594084, "api-version", newJString(apiVersion))
  add(path_594083, "subscriptionId", newJString(subscriptionId))
  add(path_594083, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594085 = parameters
  result = call_594082.call(path_594083, query_594084, nil, nil, body_594085)

var networkWatchersSetFlowLogConfiguration* = Call_NetworkWatchersSetFlowLogConfiguration_594073(
    name: "networkWatchersSetFlowLogConfiguration", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/configureFlowLog",
    validator: validate_NetworkWatchersSetFlowLogConfiguration_594074, base: "",
    url: url_NetworkWatchersSetFlowLogConfiguration_594075,
    schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsList_594086 = ref object of OpenApiRestCall_593438
proc url_ConnectionMonitorsList_594088(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectionMonitorsList_594087(path: JsonNode; query: JsonNode;
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
  var valid_594089 = path.getOrDefault("resourceGroupName")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "resourceGroupName", valid_594089
  var valid_594090 = path.getOrDefault("subscriptionId")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "subscriptionId", valid_594090
  var valid_594091 = path.getOrDefault("networkWatcherName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "networkWatcherName", valid_594091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594092 = query.getOrDefault("api-version")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "api-version", valid_594092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594093: Call_ConnectionMonitorsList_594086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all connection monitors for the specified Network Watcher.
  ## 
  let valid = call_594093.validator(path, query, header, formData, body)
  let scheme = call_594093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594093.url(scheme.get, call_594093.host, call_594093.base,
                         call_594093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594093, url, valid)

proc call*(call_594094: Call_ConnectionMonitorsList_594086;
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
  var path_594095 = newJObject()
  var query_594096 = newJObject()
  add(path_594095, "resourceGroupName", newJString(resourceGroupName))
  add(query_594096, "api-version", newJString(apiVersion))
  add(path_594095, "subscriptionId", newJString(subscriptionId))
  add(path_594095, "networkWatcherName", newJString(networkWatcherName))
  result = call_594094.call(path_594095, query_594096, nil, nil, nil)

var connectionMonitorsList* = Call_ConnectionMonitorsList_594086(
    name: "connectionMonitorsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors",
    validator: validate_ConnectionMonitorsList_594087, base: "",
    url: url_ConnectionMonitorsList_594088, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsCreateOrUpdate_594109 = ref object of OpenApiRestCall_593438
proc url_ConnectionMonitorsCreateOrUpdate_594111(protocol: Scheme; host: string;
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

proc validate_ConnectionMonitorsCreateOrUpdate_594110(path: JsonNode;
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
  var valid_594112 = path.getOrDefault("resourceGroupName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "resourceGroupName", valid_594112
  var valid_594113 = path.getOrDefault("subscriptionId")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "subscriptionId", valid_594113
  var valid_594114 = path.getOrDefault("networkWatcherName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "networkWatcherName", valid_594114
  var valid_594115 = path.getOrDefault("connectionMonitorName")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "connectionMonitorName", valid_594115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594116 = query.getOrDefault("api-version")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "api-version", valid_594116
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

proc call*(call_594118: Call_ConnectionMonitorsCreateOrUpdate_594109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a connection monitor.
  ## 
  let valid = call_594118.validator(path, query, header, formData, body)
  let scheme = call_594118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594118.url(scheme.get, call_594118.host, call_594118.base,
                         call_594118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594118, url, valid)

proc call*(call_594119: Call_ConnectionMonitorsCreateOrUpdate_594109;
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
  var path_594120 = newJObject()
  var query_594121 = newJObject()
  var body_594122 = newJObject()
  add(path_594120, "resourceGroupName", newJString(resourceGroupName))
  add(query_594121, "api-version", newJString(apiVersion))
  add(path_594120, "subscriptionId", newJString(subscriptionId))
  add(path_594120, "networkWatcherName", newJString(networkWatcherName))
  add(path_594120, "connectionMonitorName", newJString(connectionMonitorName))
  if parameters != nil:
    body_594122 = parameters
  result = call_594119.call(path_594120, query_594121, nil, nil, body_594122)

var connectionMonitorsCreateOrUpdate* = Call_ConnectionMonitorsCreateOrUpdate_594109(
    name: "connectionMonitorsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}",
    validator: validate_ConnectionMonitorsCreateOrUpdate_594110, base: "",
    url: url_ConnectionMonitorsCreateOrUpdate_594111, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsGet_594097 = ref object of OpenApiRestCall_593438
proc url_ConnectionMonitorsGet_594099(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectionMonitorsGet_594098(path: JsonNode; query: JsonNode;
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
  var valid_594100 = path.getOrDefault("resourceGroupName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "resourceGroupName", valid_594100
  var valid_594101 = path.getOrDefault("subscriptionId")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "subscriptionId", valid_594101
  var valid_594102 = path.getOrDefault("networkWatcherName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "networkWatcherName", valid_594102
  var valid_594103 = path.getOrDefault("connectionMonitorName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "connectionMonitorName", valid_594103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594104 = query.getOrDefault("api-version")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "api-version", valid_594104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594105: Call_ConnectionMonitorsGet_594097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a connection monitor by name.
  ## 
  let valid = call_594105.validator(path, query, header, formData, body)
  let scheme = call_594105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594105.url(scheme.get, call_594105.host, call_594105.base,
                         call_594105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594105, url, valid)

proc call*(call_594106: Call_ConnectionMonitorsGet_594097;
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
  var path_594107 = newJObject()
  var query_594108 = newJObject()
  add(path_594107, "resourceGroupName", newJString(resourceGroupName))
  add(query_594108, "api-version", newJString(apiVersion))
  add(path_594107, "subscriptionId", newJString(subscriptionId))
  add(path_594107, "networkWatcherName", newJString(networkWatcherName))
  add(path_594107, "connectionMonitorName", newJString(connectionMonitorName))
  result = call_594106.call(path_594107, query_594108, nil, nil, nil)

var connectionMonitorsGet* = Call_ConnectionMonitorsGet_594097(
    name: "connectionMonitorsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}",
    validator: validate_ConnectionMonitorsGet_594098, base: "",
    url: url_ConnectionMonitorsGet_594099, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsDelete_594123 = ref object of OpenApiRestCall_593438
proc url_ConnectionMonitorsDelete_594125(protocol: Scheme; host: string;
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

proc validate_ConnectionMonitorsDelete_594124(path: JsonNode; query: JsonNode;
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
  var valid_594126 = path.getOrDefault("resourceGroupName")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "resourceGroupName", valid_594126
  var valid_594127 = path.getOrDefault("subscriptionId")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "subscriptionId", valid_594127
  var valid_594128 = path.getOrDefault("networkWatcherName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "networkWatcherName", valid_594128
  var valid_594129 = path.getOrDefault("connectionMonitorName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "connectionMonitorName", valid_594129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594130 = query.getOrDefault("api-version")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "api-version", valid_594130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594131: Call_ConnectionMonitorsDelete_594123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified connection monitor.
  ## 
  let valid = call_594131.validator(path, query, header, formData, body)
  let scheme = call_594131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594131.url(scheme.get, call_594131.host, call_594131.base,
                         call_594131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594131, url, valid)

proc call*(call_594132: Call_ConnectionMonitorsDelete_594123;
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
  var path_594133 = newJObject()
  var query_594134 = newJObject()
  add(path_594133, "resourceGroupName", newJString(resourceGroupName))
  add(query_594134, "api-version", newJString(apiVersion))
  add(path_594133, "subscriptionId", newJString(subscriptionId))
  add(path_594133, "networkWatcherName", newJString(networkWatcherName))
  add(path_594133, "connectionMonitorName", newJString(connectionMonitorName))
  result = call_594132.call(path_594133, query_594134, nil, nil, nil)

var connectionMonitorsDelete* = Call_ConnectionMonitorsDelete_594123(
    name: "connectionMonitorsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}",
    validator: validate_ConnectionMonitorsDelete_594124, base: "",
    url: url_ConnectionMonitorsDelete_594125, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsQuery_594135 = ref object of OpenApiRestCall_593438
proc url_ConnectionMonitorsQuery_594137(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectionMonitorsQuery_594136(path: JsonNode; query: JsonNode;
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
  var valid_594138 = path.getOrDefault("resourceGroupName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "resourceGroupName", valid_594138
  var valid_594139 = path.getOrDefault("subscriptionId")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "subscriptionId", valid_594139
  var valid_594140 = path.getOrDefault("networkWatcherName")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "networkWatcherName", valid_594140
  var valid_594141 = path.getOrDefault("connectionMonitorName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "connectionMonitorName", valid_594141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594142 = query.getOrDefault("api-version")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "api-version", valid_594142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594143: Call_ConnectionMonitorsQuery_594135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query a snapshot of the most recent connection states.
  ## 
  let valid = call_594143.validator(path, query, header, formData, body)
  let scheme = call_594143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594143.url(scheme.get, call_594143.host, call_594143.base,
                         call_594143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594143, url, valid)

proc call*(call_594144: Call_ConnectionMonitorsQuery_594135;
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
  var path_594145 = newJObject()
  var query_594146 = newJObject()
  add(path_594145, "resourceGroupName", newJString(resourceGroupName))
  add(query_594146, "api-version", newJString(apiVersion))
  add(path_594145, "subscriptionId", newJString(subscriptionId))
  add(path_594145, "networkWatcherName", newJString(networkWatcherName))
  add(path_594145, "connectionMonitorName", newJString(connectionMonitorName))
  result = call_594144.call(path_594145, query_594146, nil, nil, nil)

var connectionMonitorsQuery* = Call_ConnectionMonitorsQuery_594135(
    name: "connectionMonitorsQuery", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}/query",
    validator: validate_ConnectionMonitorsQuery_594136, base: "",
    url: url_ConnectionMonitorsQuery_594137, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsStart_594147 = ref object of OpenApiRestCall_593438
proc url_ConnectionMonitorsStart_594149(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectionMonitorsStart_594148(path: JsonNode; query: JsonNode;
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
  var valid_594150 = path.getOrDefault("resourceGroupName")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "resourceGroupName", valid_594150
  var valid_594151 = path.getOrDefault("subscriptionId")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "subscriptionId", valid_594151
  var valid_594152 = path.getOrDefault("networkWatcherName")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "networkWatcherName", valid_594152
  var valid_594153 = path.getOrDefault("connectionMonitorName")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "connectionMonitorName", valid_594153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594154 = query.getOrDefault("api-version")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "api-version", valid_594154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594155: Call_ConnectionMonitorsStart_594147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts the specified connection monitor.
  ## 
  let valid = call_594155.validator(path, query, header, formData, body)
  let scheme = call_594155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594155.url(scheme.get, call_594155.host, call_594155.base,
                         call_594155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594155, url, valid)

proc call*(call_594156: Call_ConnectionMonitorsStart_594147;
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
  var path_594157 = newJObject()
  var query_594158 = newJObject()
  add(path_594157, "resourceGroupName", newJString(resourceGroupName))
  add(query_594158, "api-version", newJString(apiVersion))
  add(path_594157, "subscriptionId", newJString(subscriptionId))
  add(path_594157, "networkWatcherName", newJString(networkWatcherName))
  add(path_594157, "connectionMonitorName", newJString(connectionMonitorName))
  result = call_594156.call(path_594157, query_594158, nil, nil, nil)

var connectionMonitorsStart* = Call_ConnectionMonitorsStart_594147(
    name: "connectionMonitorsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}/start",
    validator: validate_ConnectionMonitorsStart_594148, base: "",
    url: url_ConnectionMonitorsStart_594149, schemes: {Scheme.Https})
type
  Call_ConnectionMonitorsStop_594159 = ref object of OpenApiRestCall_593438
proc url_ConnectionMonitorsStop_594161(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectionMonitorsStop_594160(path: JsonNode; query: JsonNode;
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
  var valid_594162 = path.getOrDefault("resourceGroupName")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "resourceGroupName", valid_594162
  var valid_594163 = path.getOrDefault("subscriptionId")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "subscriptionId", valid_594163
  var valid_594164 = path.getOrDefault("networkWatcherName")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "networkWatcherName", valid_594164
  var valid_594165 = path.getOrDefault("connectionMonitorName")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "connectionMonitorName", valid_594165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594166 = query.getOrDefault("api-version")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "api-version", valid_594166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594167: Call_ConnectionMonitorsStop_594159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops the specified connection monitor.
  ## 
  let valid = call_594167.validator(path, query, header, formData, body)
  let scheme = call_594167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594167.url(scheme.get, call_594167.host, call_594167.base,
                         call_594167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594167, url, valid)

proc call*(call_594168: Call_ConnectionMonitorsStop_594159;
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
  var path_594169 = newJObject()
  var query_594170 = newJObject()
  add(path_594169, "resourceGroupName", newJString(resourceGroupName))
  add(query_594170, "api-version", newJString(apiVersion))
  add(path_594169, "subscriptionId", newJString(subscriptionId))
  add(path_594169, "networkWatcherName", newJString(networkWatcherName))
  add(path_594169, "connectionMonitorName", newJString(connectionMonitorName))
  result = call_594168.call(path_594169, query_594170, nil, nil, nil)

var connectionMonitorsStop* = Call_ConnectionMonitorsStop_594159(
    name: "connectionMonitorsStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectionMonitors/{connectionMonitorName}/stop",
    validator: validate_ConnectionMonitorsStop_594160, base: "",
    url: url_ConnectionMonitorsStop_594161, schemes: {Scheme.Https})
type
  Call_NetworkWatchersCheckConnectivity_594171 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersCheckConnectivity_594173(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersCheckConnectivity_594172(path: JsonNode;
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
  var valid_594174 = path.getOrDefault("resourceGroupName")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "resourceGroupName", valid_594174
  var valid_594175 = path.getOrDefault("subscriptionId")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "subscriptionId", valid_594175
  var valid_594176 = path.getOrDefault("networkWatcherName")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "networkWatcherName", valid_594176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594177 = query.getOrDefault("api-version")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "api-version", valid_594177
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

proc call*(call_594179: Call_NetworkWatchersCheckConnectivity_594171;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies the possibility of establishing a direct TCP connection from a virtual machine to a given endpoint including another VM or an arbitrary remote server.
  ## 
  let valid = call_594179.validator(path, query, header, formData, body)
  let scheme = call_594179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594179.url(scheme.get, call_594179.host, call_594179.base,
                         call_594179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594179, url, valid)

proc call*(call_594180: Call_NetworkWatchersCheckConnectivity_594171;
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
  var path_594181 = newJObject()
  var query_594182 = newJObject()
  var body_594183 = newJObject()
  add(path_594181, "resourceGroupName", newJString(resourceGroupName))
  add(query_594182, "api-version", newJString(apiVersion))
  add(path_594181, "subscriptionId", newJString(subscriptionId))
  add(path_594181, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594183 = parameters
  result = call_594180.call(path_594181, query_594182, nil, nil, body_594183)

var networkWatchersCheckConnectivity* = Call_NetworkWatchersCheckConnectivity_594171(
    name: "networkWatchersCheckConnectivity", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectivityCheck",
    validator: validate_NetworkWatchersCheckConnectivity_594172, base: "",
    url: url_NetworkWatchersCheckConnectivity_594173, schemes: {Scheme.Https})
type
  Call_NetworkWatchersVerifyIPFlow_594184 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersVerifyIPFlow_594186(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersVerifyIPFlow_594185(path: JsonNode; query: JsonNode;
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
  var valid_594187 = path.getOrDefault("resourceGroupName")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "resourceGroupName", valid_594187
  var valid_594188 = path.getOrDefault("subscriptionId")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "subscriptionId", valid_594188
  var valid_594189 = path.getOrDefault("networkWatcherName")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "networkWatcherName", valid_594189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594190 = query.getOrDefault("api-version")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "api-version", valid_594190
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

proc call*(call_594192: Call_NetworkWatchersVerifyIPFlow_594184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verify IP flow from the specified VM to a location given the currently configured NSG rules.
  ## 
  let valid = call_594192.validator(path, query, header, formData, body)
  let scheme = call_594192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594192.url(scheme.get, call_594192.host, call_594192.base,
                         call_594192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594192, url, valid)

proc call*(call_594193: Call_NetworkWatchersVerifyIPFlow_594184;
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
  var path_594194 = newJObject()
  var query_594195 = newJObject()
  var body_594196 = newJObject()
  add(path_594194, "resourceGroupName", newJString(resourceGroupName))
  add(query_594195, "api-version", newJString(apiVersion))
  add(path_594194, "subscriptionId", newJString(subscriptionId))
  add(path_594194, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594196 = parameters
  result = call_594193.call(path_594194, query_594195, nil, nil, body_594196)

var networkWatchersVerifyIPFlow* = Call_NetworkWatchersVerifyIPFlow_594184(
    name: "networkWatchersVerifyIPFlow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/ipFlowVerify",
    validator: validate_NetworkWatchersVerifyIPFlow_594185, base: "",
    url: url_NetworkWatchersVerifyIPFlow_594186, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetNetworkConfigurationDiagnostic_594197 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersGetNetworkConfigurationDiagnostic_594199(
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

proc validate_NetworkWatchersGetNetworkConfigurationDiagnostic_594198(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get network configuration diagnostic.
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
  var valid_594200 = path.getOrDefault("resourceGroupName")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "resourceGroupName", valid_594200
  var valid_594201 = path.getOrDefault("subscriptionId")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "subscriptionId", valid_594201
  var valid_594202 = path.getOrDefault("networkWatcherName")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "networkWatcherName", valid_594202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594203 = query.getOrDefault("api-version")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "api-version", valid_594203
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

proc call*(call_594205: Call_NetworkWatchersGetNetworkConfigurationDiagnostic_594197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get network configuration diagnostic.
  ## 
  let valid = call_594205.validator(path, query, header, formData, body)
  let scheme = call_594205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594205.url(scheme.get, call_594205.host, call_594205.base,
                         call_594205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594205, url, valid)

proc call*(call_594206: Call_NetworkWatchersGetNetworkConfigurationDiagnostic_594197;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetNetworkConfigurationDiagnostic
  ## Get network configuration diagnostic.
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
  var path_594207 = newJObject()
  var query_594208 = newJObject()
  var body_594209 = newJObject()
  add(path_594207, "resourceGroupName", newJString(resourceGroupName))
  add(query_594208, "api-version", newJString(apiVersion))
  add(path_594207, "subscriptionId", newJString(subscriptionId))
  add(path_594207, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594209 = parameters
  result = call_594206.call(path_594207, query_594208, nil, nil, body_594209)

var networkWatchersGetNetworkConfigurationDiagnostic* = Call_NetworkWatchersGetNetworkConfigurationDiagnostic_594197(
    name: "networkWatchersGetNetworkConfigurationDiagnostic",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/networkConfigurationDiagnostic",
    validator: validate_NetworkWatchersGetNetworkConfigurationDiagnostic_594198,
    base: "", url: url_NetworkWatchersGetNetworkConfigurationDiagnostic_594199,
    schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetNextHop_594210 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersGetNextHop_594212(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetNextHop_594211(path: JsonNode; query: JsonNode;
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
  var valid_594213 = path.getOrDefault("resourceGroupName")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "resourceGroupName", valid_594213
  var valid_594214 = path.getOrDefault("subscriptionId")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "subscriptionId", valid_594214
  var valid_594215 = path.getOrDefault("networkWatcherName")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "networkWatcherName", valid_594215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594216 = query.getOrDefault("api-version")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "api-version", valid_594216
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

proc call*(call_594218: Call_NetworkWatchersGetNextHop_594210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the next hop from the specified VM.
  ## 
  let valid = call_594218.validator(path, query, header, formData, body)
  let scheme = call_594218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594218.url(scheme.get, call_594218.host, call_594218.base,
                         call_594218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594218, url, valid)

proc call*(call_594219: Call_NetworkWatchersGetNextHop_594210;
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
  var path_594220 = newJObject()
  var query_594221 = newJObject()
  var body_594222 = newJObject()
  add(path_594220, "resourceGroupName", newJString(resourceGroupName))
  add(query_594221, "api-version", newJString(apiVersion))
  add(path_594220, "subscriptionId", newJString(subscriptionId))
  add(path_594220, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594222 = parameters
  result = call_594219.call(path_594220, query_594221, nil, nil, body_594222)

var networkWatchersGetNextHop* = Call_NetworkWatchersGetNextHop_594210(
    name: "networkWatchersGetNextHop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/nextHop",
    validator: validate_NetworkWatchersGetNextHop_594211, base: "",
    url: url_NetworkWatchersGetNextHop_594212, schemes: {Scheme.Https})
type
  Call_PacketCapturesList_594223 = ref object of OpenApiRestCall_593438
proc url_PacketCapturesList_594225(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesList_594224(path: JsonNode; query: JsonNode;
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
  var valid_594226 = path.getOrDefault("resourceGroupName")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "resourceGroupName", valid_594226
  var valid_594227 = path.getOrDefault("subscriptionId")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "subscriptionId", valid_594227
  var valid_594228 = path.getOrDefault("networkWatcherName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "networkWatcherName", valid_594228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594229 = query.getOrDefault("api-version")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "api-version", valid_594229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594230: Call_PacketCapturesList_594223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all packet capture sessions within the specified resource group.
  ## 
  let valid = call_594230.validator(path, query, header, formData, body)
  let scheme = call_594230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594230.url(scheme.get, call_594230.host, call_594230.base,
                         call_594230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594230, url, valid)

proc call*(call_594231: Call_PacketCapturesList_594223; resourceGroupName: string;
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
  var path_594232 = newJObject()
  var query_594233 = newJObject()
  add(path_594232, "resourceGroupName", newJString(resourceGroupName))
  add(query_594233, "api-version", newJString(apiVersion))
  add(path_594232, "subscriptionId", newJString(subscriptionId))
  add(path_594232, "networkWatcherName", newJString(networkWatcherName))
  result = call_594231.call(path_594232, query_594233, nil, nil, nil)

var packetCapturesList* = Call_PacketCapturesList_594223(
    name: "packetCapturesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures",
    validator: validate_PacketCapturesList_594224, base: "",
    url: url_PacketCapturesList_594225, schemes: {Scheme.Https})
type
  Call_PacketCapturesCreate_594246 = ref object of OpenApiRestCall_593438
proc url_PacketCapturesCreate_594248(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesCreate_594247(path: JsonNode; query: JsonNode;
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
  var valid_594249 = path.getOrDefault("resourceGroupName")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "resourceGroupName", valid_594249
  var valid_594250 = path.getOrDefault("subscriptionId")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "subscriptionId", valid_594250
  var valid_594251 = path.getOrDefault("networkWatcherName")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "networkWatcherName", valid_594251
  var valid_594252 = path.getOrDefault("packetCaptureName")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "packetCaptureName", valid_594252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594253 = query.getOrDefault("api-version")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "api-version", valid_594253
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

proc call*(call_594255: Call_PacketCapturesCreate_594246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create and start a packet capture on the specified VM.
  ## 
  let valid = call_594255.validator(path, query, header, formData, body)
  let scheme = call_594255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594255.url(scheme.get, call_594255.host, call_594255.base,
                         call_594255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594255, url, valid)

proc call*(call_594256: Call_PacketCapturesCreate_594246;
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
  var path_594257 = newJObject()
  var query_594258 = newJObject()
  var body_594259 = newJObject()
  add(path_594257, "resourceGroupName", newJString(resourceGroupName))
  add(query_594258, "api-version", newJString(apiVersion))
  add(path_594257, "subscriptionId", newJString(subscriptionId))
  add(path_594257, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594259 = parameters
  add(path_594257, "packetCaptureName", newJString(packetCaptureName))
  result = call_594256.call(path_594257, query_594258, nil, nil, body_594259)

var packetCapturesCreate* = Call_PacketCapturesCreate_594246(
    name: "packetCapturesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}",
    validator: validate_PacketCapturesCreate_594247, base: "",
    url: url_PacketCapturesCreate_594248, schemes: {Scheme.Https})
type
  Call_PacketCapturesGet_594234 = ref object of OpenApiRestCall_593438
proc url_PacketCapturesGet_594236(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesGet_594235(path: JsonNode; query: JsonNode;
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
  var valid_594237 = path.getOrDefault("resourceGroupName")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "resourceGroupName", valid_594237
  var valid_594238 = path.getOrDefault("subscriptionId")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "subscriptionId", valid_594238
  var valid_594239 = path.getOrDefault("networkWatcherName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "networkWatcherName", valid_594239
  var valid_594240 = path.getOrDefault("packetCaptureName")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "packetCaptureName", valid_594240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594241 = query.getOrDefault("api-version")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "api-version", valid_594241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594242: Call_PacketCapturesGet_594234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a packet capture session by name.
  ## 
  let valid = call_594242.validator(path, query, header, formData, body)
  let scheme = call_594242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594242.url(scheme.get, call_594242.host, call_594242.base,
                         call_594242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594242, url, valid)

proc call*(call_594243: Call_PacketCapturesGet_594234; resourceGroupName: string;
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
  var path_594244 = newJObject()
  var query_594245 = newJObject()
  add(path_594244, "resourceGroupName", newJString(resourceGroupName))
  add(query_594245, "api-version", newJString(apiVersion))
  add(path_594244, "subscriptionId", newJString(subscriptionId))
  add(path_594244, "networkWatcherName", newJString(networkWatcherName))
  add(path_594244, "packetCaptureName", newJString(packetCaptureName))
  result = call_594243.call(path_594244, query_594245, nil, nil, nil)

var packetCapturesGet* = Call_PacketCapturesGet_594234(name: "packetCapturesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}",
    validator: validate_PacketCapturesGet_594235, base: "",
    url: url_PacketCapturesGet_594236, schemes: {Scheme.Https})
type
  Call_PacketCapturesDelete_594260 = ref object of OpenApiRestCall_593438
proc url_PacketCapturesDelete_594262(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesDelete_594261(path: JsonNode; query: JsonNode;
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
  var valid_594263 = path.getOrDefault("resourceGroupName")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "resourceGroupName", valid_594263
  var valid_594264 = path.getOrDefault("subscriptionId")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "subscriptionId", valid_594264
  var valid_594265 = path.getOrDefault("networkWatcherName")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "networkWatcherName", valid_594265
  var valid_594266 = path.getOrDefault("packetCaptureName")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "packetCaptureName", valid_594266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594267 = query.getOrDefault("api-version")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "api-version", valid_594267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594268: Call_PacketCapturesDelete_594260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified packet capture session.
  ## 
  let valid = call_594268.validator(path, query, header, formData, body)
  let scheme = call_594268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594268.url(scheme.get, call_594268.host, call_594268.base,
                         call_594268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594268, url, valid)

proc call*(call_594269: Call_PacketCapturesDelete_594260;
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
  var path_594270 = newJObject()
  var query_594271 = newJObject()
  add(path_594270, "resourceGroupName", newJString(resourceGroupName))
  add(query_594271, "api-version", newJString(apiVersion))
  add(path_594270, "subscriptionId", newJString(subscriptionId))
  add(path_594270, "networkWatcherName", newJString(networkWatcherName))
  add(path_594270, "packetCaptureName", newJString(packetCaptureName))
  result = call_594269.call(path_594270, query_594271, nil, nil, nil)

var packetCapturesDelete* = Call_PacketCapturesDelete_594260(
    name: "packetCapturesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}",
    validator: validate_PacketCapturesDelete_594261, base: "",
    url: url_PacketCapturesDelete_594262, schemes: {Scheme.Https})
type
  Call_PacketCapturesGetStatus_594272 = ref object of OpenApiRestCall_593438
proc url_PacketCapturesGetStatus_594274(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesGetStatus_594273(path: JsonNode; query: JsonNode;
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
  var valid_594275 = path.getOrDefault("resourceGroupName")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "resourceGroupName", valid_594275
  var valid_594276 = path.getOrDefault("subscriptionId")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "subscriptionId", valid_594276
  var valid_594277 = path.getOrDefault("networkWatcherName")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "networkWatcherName", valid_594277
  var valid_594278 = path.getOrDefault("packetCaptureName")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "packetCaptureName", valid_594278
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594279 = query.getOrDefault("api-version")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "api-version", valid_594279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594280: Call_PacketCapturesGetStatus_594272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the status of a running packet capture session.
  ## 
  let valid = call_594280.validator(path, query, header, formData, body)
  let scheme = call_594280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594280.url(scheme.get, call_594280.host, call_594280.base,
                         call_594280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594280, url, valid)

proc call*(call_594281: Call_PacketCapturesGetStatus_594272;
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
  var path_594282 = newJObject()
  var query_594283 = newJObject()
  add(path_594282, "resourceGroupName", newJString(resourceGroupName))
  add(query_594283, "api-version", newJString(apiVersion))
  add(path_594282, "subscriptionId", newJString(subscriptionId))
  add(path_594282, "networkWatcherName", newJString(networkWatcherName))
  add(path_594282, "packetCaptureName", newJString(packetCaptureName))
  result = call_594281.call(path_594282, query_594283, nil, nil, nil)

var packetCapturesGetStatus* = Call_PacketCapturesGetStatus_594272(
    name: "packetCapturesGetStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}/queryStatus",
    validator: validate_PacketCapturesGetStatus_594273, base: "",
    url: url_PacketCapturesGetStatus_594274, schemes: {Scheme.Https})
type
  Call_PacketCapturesStop_594284 = ref object of OpenApiRestCall_593438
proc url_PacketCapturesStop_594286(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesStop_594285(path: JsonNode; query: JsonNode;
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
  var valid_594287 = path.getOrDefault("resourceGroupName")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "resourceGroupName", valid_594287
  var valid_594288 = path.getOrDefault("subscriptionId")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "subscriptionId", valid_594288
  var valid_594289 = path.getOrDefault("networkWatcherName")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "networkWatcherName", valid_594289
  var valid_594290 = path.getOrDefault("packetCaptureName")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "packetCaptureName", valid_594290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594291 = query.getOrDefault("api-version")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "api-version", valid_594291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594292: Call_PacketCapturesStop_594284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a specified packet capture session.
  ## 
  let valid = call_594292.validator(path, query, header, formData, body)
  let scheme = call_594292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594292.url(scheme.get, call_594292.host, call_594292.base,
                         call_594292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594292, url, valid)

proc call*(call_594293: Call_PacketCapturesStop_594284; resourceGroupName: string;
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
  var path_594294 = newJObject()
  var query_594295 = newJObject()
  add(path_594294, "resourceGroupName", newJString(resourceGroupName))
  add(query_594295, "api-version", newJString(apiVersion))
  add(path_594294, "subscriptionId", newJString(subscriptionId))
  add(path_594294, "networkWatcherName", newJString(networkWatcherName))
  add(path_594294, "packetCaptureName", newJString(packetCaptureName))
  result = call_594293.call(path_594294, query_594295, nil, nil, nil)

var packetCapturesStop* = Call_PacketCapturesStop_594284(
    name: "packetCapturesStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}/stop",
    validator: validate_PacketCapturesStop_594285, base: "",
    url: url_PacketCapturesStop_594286, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetFlowLogStatus_594296 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersGetFlowLogStatus_594298(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetFlowLogStatus_594297(path: JsonNode;
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
  var valid_594299 = path.getOrDefault("resourceGroupName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "resourceGroupName", valid_594299
  var valid_594300 = path.getOrDefault("subscriptionId")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "subscriptionId", valid_594300
  var valid_594301 = path.getOrDefault("networkWatcherName")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "networkWatcherName", valid_594301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594302 = query.getOrDefault("api-version")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "api-version", valid_594302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that define a resource to query flow log and traffic analytics (optional)  status.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594304: Call_NetworkWatchersGetFlowLogStatus_594296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries status of flow log and traffic analytics (optional) on a specified resource.
  ## 
  let valid = call_594304.validator(path, query, header, formData, body)
  let scheme = call_594304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594304.url(scheme.get, call_594304.host, call_594304.base,
                         call_594304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594304, url, valid)

proc call*(call_594305: Call_NetworkWatchersGetFlowLogStatus_594296;
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
  ##             : Parameters that define a resource to query flow log and traffic analytics (optional)  status.
  var path_594306 = newJObject()
  var query_594307 = newJObject()
  var body_594308 = newJObject()
  add(path_594306, "resourceGroupName", newJString(resourceGroupName))
  add(query_594307, "api-version", newJString(apiVersion))
  add(path_594306, "subscriptionId", newJString(subscriptionId))
  add(path_594306, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594308 = parameters
  result = call_594305.call(path_594306, query_594307, nil, nil, body_594308)

var networkWatchersGetFlowLogStatus* = Call_NetworkWatchersGetFlowLogStatus_594296(
    name: "networkWatchersGetFlowLogStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/queryFlowLogStatus",
    validator: validate_NetworkWatchersGetFlowLogStatus_594297, base: "",
    url: url_NetworkWatchersGetFlowLogStatus_594298, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetTroubleshootingResult_594309 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersGetTroubleshootingResult_594311(protocol: Scheme;
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

proc validate_NetworkWatchersGetTroubleshootingResult_594310(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the last completed troubleshooting result on a specified resource
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
  var valid_594312 = path.getOrDefault("resourceGroupName")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "resourceGroupName", valid_594312
  var valid_594313 = path.getOrDefault("subscriptionId")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "subscriptionId", valid_594313
  var valid_594314 = path.getOrDefault("networkWatcherName")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "networkWatcherName", valid_594314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594315 = query.getOrDefault("api-version")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "api-version", valid_594315
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

proc call*(call_594317: Call_NetworkWatchersGetTroubleshootingResult_594309;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the last completed troubleshooting result on a specified resource
  ## 
  let valid = call_594317.validator(path, query, header, formData, body)
  let scheme = call_594317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594317.url(scheme.get, call_594317.host, call_594317.base,
                         call_594317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594317, url, valid)

proc call*(call_594318: Call_NetworkWatchersGetTroubleshootingResult_594309;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetTroubleshootingResult
  ## Get the last completed troubleshooting result on a specified resource
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
  var path_594319 = newJObject()
  var query_594320 = newJObject()
  var body_594321 = newJObject()
  add(path_594319, "resourceGroupName", newJString(resourceGroupName))
  add(query_594320, "api-version", newJString(apiVersion))
  add(path_594319, "subscriptionId", newJString(subscriptionId))
  add(path_594319, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594321 = parameters
  result = call_594318.call(path_594319, query_594320, nil, nil, body_594321)

var networkWatchersGetTroubleshootingResult* = Call_NetworkWatchersGetTroubleshootingResult_594309(
    name: "networkWatchersGetTroubleshootingResult", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/queryTroubleshootResult",
    validator: validate_NetworkWatchersGetTroubleshootingResult_594310, base: "",
    url: url_NetworkWatchersGetTroubleshootingResult_594311,
    schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetVMSecurityRules_594322 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersGetVMSecurityRules_594324(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetVMSecurityRules_594323(path: JsonNode;
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
  var valid_594325 = path.getOrDefault("resourceGroupName")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "resourceGroupName", valid_594325
  var valid_594326 = path.getOrDefault("subscriptionId")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "subscriptionId", valid_594326
  var valid_594327 = path.getOrDefault("networkWatcherName")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "networkWatcherName", valid_594327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594328 = query.getOrDefault("api-version")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "api-version", valid_594328
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

proc call*(call_594330: Call_NetworkWatchersGetVMSecurityRules_594322;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the configured and effective security group rules on the specified VM.
  ## 
  let valid = call_594330.validator(path, query, header, formData, body)
  let scheme = call_594330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594330.url(scheme.get, call_594330.host, call_594330.base,
                         call_594330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594330, url, valid)

proc call*(call_594331: Call_NetworkWatchersGetVMSecurityRules_594322;
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
  var path_594332 = newJObject()
  var query_594333 = newJObject()
  var body_594334 = newJObject()
  add(path_594332, "resourceGroupName", newJString(resourceGroupName))
  add(query_594333, "api-version", newJString(apiVersion))
  add(path_594332, "subscriptionId", newJString(subscriptionId))
  add(path_594332, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594334 = parameters
  result = call_594331.call(path_594332, query_594333, nil, nil, body_594334)

var networkWatchersGetVMSecurityRules* = Call_NetworkWatchersGetVMSecurityRules_594322(
    name: "networkWatchersGetVMSecurityRules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/securityGroupView",
    validator: validate_NetworkWatchersGetVMSecurityRules_594323, base: "",
    url: url_NetworkWatchersGetVMSecurityRules_594324, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetTopology_594335 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersGetTopology_594337(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetTopology_594336(path: JsonNode; query: JsonNode;
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
  var valid_594338 = path.getOrDefault("resourceGroupName")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "resourceGroupName", valid_594338
  var valid_594339 = path.getOrDefault("subscriptionId")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "subscriptionId", valid_594339
  var valid_594340 = path.getOrDefault("networkWatcherName")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "networkWatcherName", valid_594340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594341 = query.getOrDefault("api-version")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "api-version", valid_594341
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

proc call*(call_594343: Call_NetworkWatchersGetTopology_594335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current network topology by resource group.
  ## 
  let valid = call_594343.validator(path, query, header, formData, body)
  let scheme = call_594343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594343.url(scheme.get, call_594343.host, call_594343.base,
                         call_594343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594343, url, valid)

proc call*(call_594344: Call_NetworkWatchersGetTopology_594335;
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
  var path_594345 = newJObject()
  var query_594346 = newJObject()
  var body_594347 = newJObject()
  add(path_594345, "resourceGroupName", newJString(resourceGroupName))
  add(query_594346, "api-version", newJString(apiVersion))
  add(path_594345, "subscriptionId", newJString(subscriptionId))
  add(path_594345, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594347 = parameters
  result = call_594344.call(path_594345, query_594346, nil, nil, body_594347)

var networkWatchersGetTopology* = Call_NetworkWatchersGetTopology_594335(
    name: "networkWatchersGetTopology", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/topology",
    validator: validate_NetworkWatchersGetTopology_594336, base: "",
    url: url_NetworkWatchersGetTopology_594337, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetTroubleshooting_594348 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersGetTroubleshooting_594350(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetTroubleshooting_594349(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Initiate troubleshooting on a specified resource
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
  var valid_594351 = path.getOrDefault("resourceGroupName")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "resourceGroupName", valid_594351
  var valid_594352 = path.getOrDefault("subscriptionId")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "subscriptionId", valid_594352
  var valid_594353 = path.getOrDefault("networkWatcherName")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "networkWatcherName", valid_594353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594354 = query.getOrDefault("api-version")
  valid_594354 = validateParameter(valid_594354, JString, required = true,
                                 default = nil)
  if valid_594354 != nil:
    section.add "api-version", valid_594354
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

proc call*(call_594356: Call_NetworkWatchersGetTroubleshooting_594348;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Initiate troubleshooting on a specified resource
  ## 
  let valid = call_594356.validator(path, query, header, formData, body)
  let scheme = call_594356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594356.url(scheme.get, call_594356.host, call_594356.base,
                         call_594356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594356, url, valid)

proc call*(call_594357: Call_NetworkWatchersGetTroubleshooting_594348;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetTroubleshooting
  ## Initiate troubleshooting on a specified resource
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
  var path_594358 = newJObject()
  var query_594359 = newJObject()
  var body_594360 = newJObject()
  add(path_594358, "resourceGroupName", newJString(resourceGroupName))
  add(query_594359, "api-version", newJString(apiVersion))
  add(path_594358, "subscriptionId", newJString(subscriptionId))
  add(path_594358, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594360 = parameters
  result = call_594357.call(path_594358, query_594359, nil, nil, body_594360)

var networkWatchersGetTroubleshooting* = Call_NetworkWatchersGetTroubleshooting_594348(
    name: "networkWatchersGetTroubleshooting", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/troubleshoot",
    validator: validate_NetworkWatchersGetTroubleshooting_594349, base: "",
    url: url_NetworkWatchersGetTroubleshooting_594350, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
