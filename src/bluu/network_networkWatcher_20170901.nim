
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2017-09-01
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
  var valid_593835 = path.getOrDefault("subscriptionId")
  valid_593835 = validateParameter(valid_593835, JString, required = true,
                                 default = nil)
  if valid_593835 != nil:
    section.add "subscriptionId", valid_593835
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593836 = query.getOrDefault("api-version")
  valid_593836 = validateParameter(valid_593836, JString, required = true,
                                 default = nil)
  if valid_593836 != nil:
    section.add "api-version", valid_593836
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593859: Call_NetworkWatchersListAll_593660; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all network watchers by subscription.
  ## 
  let valid = call_593859.validator(path, query, header, formData, body)
  let scheme = call_593859.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593859.url(scheme.get, call_593859.host, call_593859.base,
                         call_593859.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593859, url, valid)

proc call*(call_593930: Call_NetworkWatchersListAll_593660; apiVersion: string;
          subscriptionId: string): Recallable =
  ## networkWatchersListAll
  ## Gets all network watchers by subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593931 = newJObject()
  var query_593933 = newJObject()
  add(query_593933, "api-version", newJString(apiVersion))
  add(path_593931, "subscriptionId", newJString(subscriptionId))
  result = call_593930.call(path_593931, query_593933, nil, nil, nil)

var networkWatchersListAll* = Call_NetworkWatchersListAll_593660(
    name: "networkWatchersListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/networkWatchers",
    validator: validate_NetworkWatchersListAll_593661, base: "",
    url: url_NetworkWatchersListAll_593662, schemes: {Scheme.Https})
type
  Call_NetworkWatchersList_593972 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersList_593974(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkWatchersList_593973(path: JsonNode; query: JsonNode;
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
  var valid_593975 = path.getOrDefault("resourceGroupName")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "resourceGroupName", valid_593975
  var valid_593976 = path.getOrDefault("subscriptionId")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "subscriptionId", valid_593976
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593977 = query.getOrDefault("api-version")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "api-version", valid_593977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593978: Call_NetworkWatchersList_593972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all network watchers by resource group.
  ## 
  let valid = call_593978.validator(path, query, header, formData, body)
  let scheme = call_593978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593978.url(scheme.get, call_593978.host, call_593978.base,
                         call_593978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593978, url, valid)

proc call*(call_593979: Call_NetworkWatchersList_593972; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## networkWatchersList
  ## Gets all network watchers by resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593980 = newJObject()
  var query_593981 = newJObject()
  add(path_593980, "resourceGroupName", newJString(resourceGroupName))
  add(query_593981, "api-version", newJString(apiVersion))
  add(path_593980, "subscriptionId", newJString(subscriptionId))
  result = call_593979.call(path_593980, query_593981, nil, nil, nil)

var networkWatchersList* = Call_NetworkWatchersList_593972(
    name: "networkWatchersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers",
    validator: validate_NetworkWatchersList_593973, base: "",
    url: url_NetworkWatchersList_593974, schemes: {Scheme.Https})
type
  Call_NetworkWatchersCreateOrUpdate_593993 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersCreateOrUpdate_593995(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersCreateOrUpdate_593994(path: JsonNode; query: JsonNode;
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

proc call*(call_594018: Call_NetworkWatchersCreateOrUpdate_593993; path: JsonNode;
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

proc call*(call_594019: Call_NetworkWatchersCreateOrUpdate_593993;
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

var networkWatchersCreateOrUpdate* = Call_NetworkWatchersCreateOrUpdate_593993(
    name: "networkWatchersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}",
    validator: validate_NetworkWatchersCreateOrUpdate_593994, base: "",
    url: url_NetworkWatchersCreateOrUpdate_593995, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGet_593982 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersGet_593984(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkWatchersGet_593983(path: JsonNode; query: JsonNode;
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
  var valid_593987 = path.getOrDefault("networkWatcherName")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "networkWatcherName", valid_593987
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
  if body != nil:
    result.add "body", body

proc call*(call_593989: Call_NetworkWatchersGet_593982; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified network watcher by resource group.
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_NetworkWatchersGet_593982; resourceGroupName: string;
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
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  add(path_593991, "resourceGroupName", newJString(resourceGroupName))
  add(query_593992, "api-version", newJString(apiVersion))
  add(path_593991, "subscriptionId", newJString(subscriptionId))
  add(path_593991, "networkWatcherName", newJString(networkWatcherName))
  result = call_593990.call(path_593991, query_593992, nil, nil, nil)

var networkWatchersGet* = Call_NetworkWatchersGet_593982(
    name: "networkWatchersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}",
    validator: validate_NetworkWatchersGet_593983, base: "",
    url: url_NetworkWatchersGet_593984, schemes: {Scheme.Https})
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
  ## Configures flow log on a specified resource.
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
  ## Configures flow log on a specified resource.
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
  ## Configures flow log on a specified resource.
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
  Call_NetworkWatchersCheckConnectivity_594086 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersCheckConnectivity_594088(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersCheckConnectivity_594087(path: JsonNode;
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters that determine how the connectivity check will be performed.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594094: Call_NetworkWatchersCheckConnectivity_594086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies the possibility of establishing a direct TCP connection from a virtual machine to a given endpoint including another VM or an arbitrary remote server.
  ## 
  let valid = call_594094.validator(path, query, header, formData, body)
  let scheme = call_594094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594094.url(scheme.get, call_594094.host, call_594094.base,
                         call_594094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594094, url, valid)

proc call*(call_594095: Call_NetworkWatchersCheckConnectivity_594086;
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
  var path_594096 = newJObject()
  var query_594097 = newJObject()
  var body_594098 = newJObject()
  add(path_594096, "resourceGroupName", newJString(resourceGroupName))
  add(query_594097, "api-version", newJString(apiVersion))
  add(path_594096, "subscriptionId", newJString(subscriptionId))
  add(path_594096, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594098 = parameters
  result = call_594095.call(path_594096, query_594097, nil, nil, body_594098)

var networkWatchersCheckConnectivity* = Call_NetworkWatchersCheckConnectivity_594086(
    name: "networkWatchersCheckConnectivity", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/connectivityCheck",
    validator: validate_NetworkWatchersCheckConnectivity_594087, base: "",
    url: url_NetworkWatchersCheckConnectivity_594088, schemes: {Scheme.Https})
type
  Call_NetworkWatchersVerifyIPFlow_594099 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersVerifyIPFlow_594101(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersVerifyIPFlow_594100(path: JsonNode; query: JsonNode;
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
  var valid_594102 = path.getOrDefault("resourceGroupName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "resourceGroupName", valid_594102
  var valid_594103 = path.getOrDefault("subscriptionId")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "subscriptionId", valid_594103
  var valid_594104 = path.getOrDefault("networkWatcherName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "networkWatcherName", valid_594104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594105 = query.getOrDefault("api-version")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "api-version", valid_594105
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

proc call*(call_594107: Call_NetworkWatchersVerifyIPFlow_594099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verify IP flow from the specified VM to a location given the currently configured NSG rules.
  ## 
  let valid = call_594107.validator(path, query, header, formData, body)
  let scheme = call_594107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594107.url(scheme.get, call_594107.host, call_594107.base,
                         call_594107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594107, url, valid)

proc call*(call_594108: Call_NetworkWatchersVerifyIPFlow_594099;
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
  var path_594109 = newJObject()
  var query_594110 = newJObject()
  var body_594111 = newJObject()
  add(path_594109, "resourceGroupName", newJString(resourceGroupName))
  add(query_594110, "api-version", newJString(apiVersion))
  add(path_594109, "subscriptionId", newJString(subscriptionId))
  add(path_594109, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594111 = parameters
  result = call_594108.call(path_594109, query_594110, nil, nil, body_594111)

var networkWatchersVerifyIPFlow* = Call_NetworkWatchersVerifyIPFlow_594099(
    name: "networkWatchersVerifyIPFlow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/ipFlowVerify",
    validator: validate_NetworkWatchersVerifyIPFlow_594100, base: "",
    url: url_NetworkWatchersVerifyIPFlow_594101, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetNextHop_594112 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersGetNextHop_594114(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetNextHop_594113(path: JsonNode; query: JsonNode;
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
  var valid_594115 = path.getOrDefault("resourceGroupName")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "resourceGroupName", valid_594115
  var valid_594116 = path.getOrDefault("subscriptionId")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "subscriptionId", valid_594116
  var valid_594117 = path.getOrDefault("networkWatcherName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "networkWatcherName", valid_594117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594118 = query.getOrDefault("api-version")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "api-version", valid_594118
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

proc call*(call_594120: Call_NetworkWatchersGetNextHop_594112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the next hop from the specified VM.
  ## 
  let valid = call_594120.validator(path, query, header, formData, body)
  let scheme = call_594120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594120.url(scheme.get, call_594120.host, call_594120.base,
                         call_594120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594120, url, valid)

proc call*(call_594121: Call_NetworkWatchersGetNextHop_594112;
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
  var path_594122 = newJObject()
  var query_594123 = newJObject()
  var body_594124 = newJObject()
  add(path_594122, "resourceGroupName", newJString(resourceGroupName))
  add(query_594123, "api-version", newJString(apiVersion))
  add(path_594122, "subscriptionId", newJString(subscriptionId))
  add(path_594122, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594124 = parameters
  result = call_594121.call(path_594122, query_594123, nil, nil, body_594124)

var networkWatchersGetNextHop* = Call_NetworkWatchersGetNextHop_594112(
    name: "networkWatchersGetNextHop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/nextHop",
    validator: validate_NetworkWatchersGetNextHop_594113, base: "",
    url: url_NetworkWatchersGetNextHop_594114, schemes: {Scheme.Https})
type
  Call_PacketCapturesList_594125 = ref object of OpenApiRestCall_593438
proc url_PacketCapturesList_594127(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesList_594126(path: JsonNode; query: JsonNode;
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
  var valid_594128 = path.getOrDefault("resourceGroupName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "resourceGroupName", valid_594128
  var valid_594129 = path.getOrDefault("subscriptionId")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "subscriptionId", valid_594129
  var valid_594130 = path.getOrDefault("networkWatcherName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "networkWatcherName", valid_594130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594131 = query.getOrDefault("api-version")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "api-version", valid_594131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594132: Call_PacketCapturesList_594125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all packet capture sessions within the specified resource group.
  ## 
  let valid = call_594132.validator(path, query, header, formData, body)
  let scheme = call_594132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594132.url(scheme.get, call_594132.host, call_594132.base,
                         call_594132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594132, url, valid)

proc call*(call_594133: Call_PacketCapturesList_594125; resourceGroupName: string;
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
  var path_594134 = newJObject()
  var query_594135 = newJObject()
  add(path_594134, "resourceGroupName", newJString(resourceGroupName))
  add(query_594135, "api-version", newJString(apiVersion))
  add(path_594134, "subscriptionId", newJString(subscriptionId))
  add(path_594134, "networkWatcherName", newJString(networkWatcherName))
  result = call_594133.call(path_594134, query_594135, nil, nil, nil)

var packetCapturesList* = Call_PacketCapturesList_594125(
    name: "packetCapturesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures",
    validator: validate_PacketCapturesList_594126, base: "",
    url: url_PacketCapturesList_594127, schemes: {Scheme.Https})
type
  Call_PacketCapturesCreate_594148 = ref object of OpenApiRestCall_593438
proc url_PacketCapturesCreate_594150(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesCreate_594149(path: JsonNode; query: JsonNode;
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
  var valid_594151 = path.getOrDefault("resourceGroupName")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "resourceGroupName", valid_594151
  var valid_594152 = path.getOrDefault("subscriptionId")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "subscriptionId", valid_594152
  var valid_594153 = path.getOrDefault("networkWatcherName")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "networkWatcherName", valid_594153
  var valid_594154 = path.getOrDefault("packetCaptureName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "packetCaptureName", valid_594154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594155 = query.getOrDefault("api-version")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "api-version", valid_594155
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

proc call*(call_594157: Call_PacketCapturesCreate_594148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create and start a packet capture on the specified VM.
  ## 
  let valid = call_594157.validator(path, query, header, formData, body)
  let scheme = call_594157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594157.url(scheme.get, call_594157.host, call_594157.base,
                         call_594157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594157, url, valid)

proc call*(call_594158: Call_PacketCapturesCreate_594148;
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
  var path_594159 = newJObject()
  var query_594160 = newJObject()
  var body_594161 = newJObject()
  add(path_594159, "resourceGroupName", newJString(resourceGroupName))
  add(query_594160, "api-version", newJString(apiVersion))
  add(path_594159, "subscriptionId", newJString(subscriptionId))
  add(path_594159, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594161 = parameters
  add(path_594159, "packetCaptureName", newJString(packetCaptureName))
  result = call_594158.call(path_594159, query_594160, nil, nil, body_594161)

var packetCapturesCreate* = Call_PacketCapturesCreate_594148(
    name: "packetCapturesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}",
    validator: validate_PacketCapturesCreate_594149, base: "",
    url: url_PacketCapturesCreate_594150, schemes: {Scheme.Https})
type
  Call_PacketCapturesGet_594136 = ref object of OpenApiRestCall_593438
proc url_PacketCapturesGet_594138(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesGet_594137(path: JsonNode; query: JsonNode;
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
  var valid_594139 = path.getOrDefault("resourceGroupName")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "resourceGroupName", valid_594139
  var valid_594140 = path.getOrDefault("subscriptionId")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "subscriptionId", valid_594140
  var valid_594141 = path.getOrDefault("networkWatcherName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "networkWatcherName", valid_594141
  var valid_594142 = path.getOrDefault("packetCaptureName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "packetCaptureName", valid_594142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594143 = query.getOrDefault("api-version")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "api-version", valid_594143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594144: Call_PacketCapturesGet_594136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a packet capture session by name.
  ## 
  let valid = call_594144.validator(path, query, header, formData, body)
  let scheme = call_594144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594144.url(scheme.get, call_594144.host, call_594144.base,
                         call_594144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594144, url, valid)

proc call*(call_594145: Call_PacketCapturesGet_594136; resourceGroupName: string;
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
  var path_594146 = newJObject()
  var query_594147 = newJObject()
  add(path_594146, "resourceGroupName", newJString(resourceGroupName))
  add(query_594147, "api-version", newJString(apiVersion))
  add(path_594146, "subscriptionId", newJString(subscriptionId))
  add(path_594146, "networkWatcherName", newJString(networkWatcherName))
  add(path_594146, "packetCaptureName", newJString(packetCaptureName))
  result = call_594145.call(path_594146, query_594147, nil, nil, nil)

var packetCapturesGet* = Call_PacketCapturesGet_594136(name: "packetCapturesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}",
    validator: validate_PacketCapturesGet_594137, base: "",
    url: url_PacketCapturesGet_594138, schemes: {Scheme.Https})
type
  Call_PacketCapturesDelete_594162 = ref object of OpenApiRestCall_593438
proc url_PacketCapturesDelete_594164(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesDelete_594163(path: JsonNode; query: JsonNode;
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
  var valid_594165 = path.getOrDefault("resourceGroupName")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "resourceGroupName", valid_594165
  var valid_594166 = path.getOrDefault("subscriptionId")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "subscriptionId", valid_594166
  var valid_594167 = path.getOrDefault("networkWatcherName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "networkWatcherName", valid_594167
  var valid_594168 = path.getOrDefault("packetCaptureName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "packetCaptureName", valid_594168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594169 = query.getOrDefault("api-version")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "api-version", valid_594169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594170: Call_PacketCapturesDelete_594162; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified packet capture session.
  ## 
  let valid = call_594170.validator(path, query, header, formData, body)
  let scheme = call_594170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594170.url(scheme.get, call_594170.host, call_594170.base,
                         call_594170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594170, url, valid)

proc call*(call_594171: Call_PacketCapturesDelete_594162;
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
  var path_594172 = newJObject()
  var query_594173 = newJObject()
  add(path_594172, "resourceGroupName", newJString(resourceGroupName))
  add(query_594173, "api-version", newJString(apiVersion))
  add(path_594172, "subscriptionId", newJString(subscriptionId))
  add(path_594172, "networkWatcherName", newJString(networkWatcherName))
  add(path_594172, "packetCaptureName", newJString(packetCaptureName))
  result = call_594171.call(path_594172, query_594173, nil, nil, nil)

var packetCapturesDelete* = Call_PacketCapturesDelete_594162(
    name: "packetCapturesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}",
    validator: validate_PacketCapturesDelete_594163, base: "",
    url: url_PacketCapturesDelete_594164, schemes: {Scheme.Https})
type
  Call_PacketCapturesGetStatus_594174 = ref object of OpenApiRestCall_593438
proc url_PacketCapturesGetStatus_594176(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesGetStatus_594175(path: JsonNode; query: JsonNode;
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
  var valid_594177 = path.getOrDefault("resourceGroupName")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "resourceGroupName", valid_594177
  var valid_594178 = path.getOrDefault("subscriptionId")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "subscriptionId", valid_594178
  var valid_594179 = path.getOrDefault("networkWatcherName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "networkWatcherName", valid_594179
  var valid_594180 = path.getOrDefault("packetCaptureName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "packetCaptureName", valid_594180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594181 = query.getOrDefault("api-version")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "api-version", valid_594181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594182: Call_PacketCapturesGetStatus_594174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the status of a running packet capture session.
  ## 
  let valid = call_594182.validator(path, query, header, formData, body)
  let scheme = call_594182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594182.url(scheme.get, call_594182.host, call_594182.base,
                         call_594182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594182, url, valid)

proc call*(call_594183: Call_PacketCapturesGetStatus_594174;
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
  var path_594184 = newJObject()
  var query_594185 = newJObject()
  add(path_594184, "resourceGroupName", newJString(resourceGroupName))
  add(query_594185, "api-version", newJString(apiVersion))
  add(path_594184, "subscriptionId", newJString(subscriptionId))
  add(path_594184, "networkWatcherName", newJString(networkWatcherName))
  add(path_594184, "packetCaptureName", newJString(packetCaptureName))
  result = call_594183.call(path_594184, query_594185, nil, nil, nil)

var packetCapturesGetStatus* = Call_PacketCapturesGetStatus_594174(
    name: "packetCapturesGetStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}/queryStatus",
    validator: validate_PacketCapturesGetStatus_594175, base: "",
    url: url_PacketCapturesGetStatus_594176, schemes: {Scheme.Https})
type
  Call_PacketCapturesStop_594186 = ref object of OpenApiRestCall_593438
proc url_PacketCapturesStop_594188(protocol: Scheme; host: string; base: string;
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

proc validate_PacketCapturesStop_594187(path: JsonNode; query: JsonNode;
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
  var valid_594189 = path.getOrDefault("resourceGroupName")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "resourceGroupName", valid_594189
  var valid_594190 = path.getOrDefault("subscriptionId")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "subscriptionId", valid_594190
  var valid_594191 = path.getOrDefault("networkWatcherName")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "networkWatcherName", valid_594191
  var valid_594192 = path.getOrDefault("packetCaptureName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "packetCaptureName", valid_594192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594193 = query.getOrDefault("api-version")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "api-version", valid_594193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594194: Call_PacketCapturesStop_594186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a specified packet capture session.
  ## 
  let valid = call_594194.validator(path, query, header, formData, body)
  let scheme = call_594194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594194.url(scheme.get, call_594194.host, call_594194.base,
                         call_594194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594194, url, valid)

proc call*(call_594195: Call_PacketCapturesStop_594186; resourceGroupName: string;
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
  var path_594196 = newJObject()
  var query_594197 = newJObject()
  add(path_594196, "resourceGroupName", newJString(resourceGroupName))
  add(query_594197, "api-version", newJString(apiVersion))
  add(path_594196, "subscriptionId", newJString(subscriptionId))
  add(path_594196, "networkWatcherName", newJString(networkWatcherName))
  add(path_594196, "packetCaptureName", newJString(packetCaptureName))
  result = call_594195.call(path_594196, query_594197, nil, nil, nil)

var packetCapturesStop* = Call_PacketCapturesStop_594186(
    name: "packetCapturesStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/packetCaptures/{packetCaptureName}/stop",
    validator: validate_PacketCapturesStop_594187, base: "",
    url: url_PacketCapturesStop_594188, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetFlowLogStatus_594198 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersGetFlowLogStatus_594200(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetFlowLogStatus_594199(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries status of flow log on a specified resource.
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
  var valid_594201 = path.getOrDefault("resourceGroupName")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "resourceGroupName", valid_594201
  var valid_594202 = path.getOrDefault("subscriptionId")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "subscriptionId", valid_594202
  var valid_594203 = path.getOrDefault("networkWatcherName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "networkWatcherName", valid_594203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594204 = query.getOrDefault("api-version")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "api-version", valid_594204
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

proc call*(call_594206: Call_NetworkWatchersGetFlowLogStatus_594198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries status of flow log on a specified resource.
  ## 
  let valid = call_594206.validator(path, query, header, formData, body)
  let scheme = call_594206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594206.url(scheme.get, call_594206.host, call_594206.base,
                         call_594206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594206, url, valid)

proc call*(call_594207: Call_NetworkWatchersGetFlowLogStatus_594198;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkWatcherName: string; parameters: JsonNode): Recallable =
  ## networkWatchersGetFlowLogStatus
  ## Queries status of flow log on a specified resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the network watcher resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkWatcherName: string (required)
  ##                     : The name of the network watcher resource.
  ##   parameters: JObject (required)
  ##             : Parameters that define a resource to query flow log status.
  var path_594208 = newJObject()
  var query_594209 = newJObject()
  var body_594210 = newJObject()
  add(path_594208, "resourceGroupName", newJString(resourceGroupName))
  add(query_594209, "api-version", newJString(apiVersion))
  add(path_594208, "subscriptionId", newJString(subscriptionId))
  add(path_594208, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594210 = parameters
  result = call_594207.call(path_594208, query_594209, nil, nil, body_594210)

var networkWatchersGetFlowLogStatus* = Call_NetworkWatchersGetFlowLogStatus_594198(
    name: "networkWatchersGetFlowLogStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/queryFlowLogStatus",
    validator: validate_NetworkWatchersGetFlowLogStatus_594199, base: "",
    url: url_NetworkWatchersGetFlowLogStatus_594200, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetTroubleshootingResult_594211 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersGetTroubleshootingResult_594213(protocol: Scheme;
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

proc validate_NetworkWatchersGetTroubleshootingResult_594212(path: JsonNode;
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
  var valid_594214 = path.getOrDefault("resourceGroupName")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "resourceGroupName", valid_594214
  var valid_594215 = path.getOrDefault("subscriptionId")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "subscriptionId", valid_594215
  var valid_594216 = path.getOrDefault("networkWatcherName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "networkWatcherName", valid_594216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594217 = query.getOrDefault("api-version")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "api-version", valid_594217
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

proc call*(call_594219: Call_NetworkWatchersGetTroubleshootingResult_594211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the last completed troubleshooting result on a specified resource
  ## 
  let valid = call_594219.validator(path, query, header, formData, body)
  let scheme = call_594219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594219.url(scheme.get, call_594219.host, call_594219.base,
                         call_594219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594219, url, valid)

proc call*(call_594220: Call_NetworkWatchersGetTroubleshootingResult_594211;
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
  var path_594221 = newJObject()
  var query_594222 = newJObject()
  var body_594223 = newJObject()
  add(path_594221, "resourceGroupName", newJString(resourceGroupName))
  add(query_594222, "api-version", newJString(apiVersion))
  add(path_594221, "subscriptionId", newJString(subscriptionId))
  add(path_594221, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594223 = parameters
  result = call_594220.call(path_594221, query_594222, nil, nil, body_594223)

var networkWatchersGetTroubleshootingResult* = Call_NetworkWatchersGetTroubleshootingResult_594211(
    name: "networkWatchersGetTroubleshootingResult", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/queryTroubleshootResult",
    validator: validate_NetworkWatchersGetTroubleshootingResult_594212, base: "",
    url: url_NetworkWatchersGetTroubleshootingResult_594213,
    schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetVMSecurityRules_594224 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersGetVMSecurityRules_594226(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetVMSecurityRules_594225(path: JsonNode;
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
  var valid_594227 = path.getOrDefault("resourceGroupName")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "resourceGroupName", valid_594227
  var valid_594228 = path.getOrDefault("subscriptionId")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "subscriptionId", valid_594228
  var valid_594229 = path.getOrDefault("networkWatcherName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "networkWatcherName", valid_594229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594230 = query.getOrDefault("api-version")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "api-version", valid_594230
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

proc call*(call_594232: Call_NetworkWatchersGetVMSecurityRules_594224;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the configured and effective security group rules on the specified VM.
  ## 
  let valid = call_594232.validator(path, query, header, formData, body)
  let scheme = call_594232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594232.url(scheme.get, call_594232.host, call_594232.base,
                         call_594232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594232, url, valid)

proc call*(call_594233: Call_NetworkWatchersGetVMSecurityRules_594224;
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
  var path_594234 = newJObject()
  var query_594235 = newJObject()
  var body_594236 = newJObject()
  add(path_594234, "resourceGroupName", newJString(resourceGroupName))
  add(query_594235, "api-version", newJString(apiVersion))
  add(path_594234, "subscriptionId", newJString(subscriptionId))
  add(path_594234, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594236 = parameters
  result = call_594233.call(path_594234, query_594235, nil, nil, body_594236)

var networkWatchersGetVMSecurityRules* = Call_NetworkWatchersGetVMSecurityRules_594224(
    name: "networkWatchersGetVMSecurityRules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/securityGroupView",
    validator: validate_NetworkWatchersGetVMSecurityRules_594225, base: "",
    url: url_NetworkWatchersGetVMSecurityRules_594226, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetTopology_594237 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersGetTopology_594239(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetTopology_594238(path: JsonNode; query: JsonNode;
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
  var valid_594240 = path.getOrDefault("resourceGroupName")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "resourceGroupName", valid_594240
  var valid_594241 = path.getOrDefault("subscriptionId")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "subscriptionId", valid_594241
  var valid_594242 = path.getOrDefault("networkWatcherName")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "networkWatcherName", valid_594242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594243 = query.getOrDefault("api-version")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "api-version", valid_594243
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

proc call*(call_594245: Call_NetworkWatchersGetTopology_594237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current network topology by resource group.
  ## 
  let valid = call_594245.validator(path, query, header, formData, body)
  let scheme = call_594245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594245.url(scheme.get, call_594245.host, call_594245.base,
                         call_594245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594245, url, valid)

proc call*(call_594246: Call_NetworkWatchersGetTopology_594237;
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
  var path_594247 = newJObject()
  var query_594248 = newJObject()
  var body_594249 = newJObject()
  add(path_594247, "resourceGroupName", newJString(resourceGroupName))
  add(query_594248, "api-version", newJString(apiVersion))
  add(path_594247, "subscriptionId", newJString(subscriptionId))
  add(path_594247, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594249 = parameters
  result = call_594246.call(path_594247, query_594248, nil, nil, body_594249)

var networkWatchersGetTopology* = Call_NetworkWatchersGetTopology_594237(
    name: "networkWatchersGetTopology", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/topology",
    validator: validate_NetworkWatchersGetTopology_594238, base: "",
    url: url_NetworkWatchersGetTopology_594239, schemes: {Scheme.Https})
type
  Call_NetworkWatchersGetTroubleshooting_594250 = ref object of OpenApiRestCall_593438
proc url_NetworkWatchersGetTroubleshooting_594252(protocol: Scheme; host: string;
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

proc validate_NetworkWatchersGetTroubleshooting_594251(path: JsonNode;
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
  var valid_594253 = path.getOrDefault("resourceGroupName")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "resourceGroupName", valid_594253
  var valid_594254 = path.getOrDefault("subscriptionId")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "subscriptionId", valid_594254
  var valid_594255 = path.getOrDefault("networkWatcherName")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "networkWatcherName", valid_594255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594256 = query.getOrDefault("api-version")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "api-version", valid_594256
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

proc call*(call_594258: Call_NetworkWatchersGetTroubleshooting_594250;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Initiate troubleshooting on a specified resource
  ## 
  let valid = call_594258.validator(path, query, header, formData, body)
  let scheme = call_594258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594258.url(scheme.get, call_594258.host, call_594258.base,
                         call_594258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594258, url, valid)

proc call*(call_594259: Call_NetworkWatchersGetTroubleshooting_594250;
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
  var path_594260 = newJObject()
  var query_594261 = newJObject()
  var body_594262 = newJObject()
  add(path_594260, "resourceGroupName", newJString(resourceGroupName))
  add(query_594261, "api-version", newJString(apiVersion))
  add(path_594260, "subscriptionId", newJString(subscriptionId))
  add(path_594260, "networkWatcherName", newJString(networkWatcherName))
  if parameters != nil:
    body_594262 = parameters
  result = call_594259.call(path_594260, query_594261, nil, nil, body_594262)

var networkWatchersGetTroubleshooting* = Call_NetworkWatchersGetTroubleshooting_594250(
    name: "networkWatchersGetTroubleshooting", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkWatchers/{networkWatcherName}/troubleshoot",
    validator: validate_NetworkWatchersGetTroubleshooting_594251, base: "",
    url: url_NetworkWatchersGetTroubleshooting_594252, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
