
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AzureAnalysisServices
## version: 2016-05-16
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure Analysis Services Web API provides a RESTful set of web services that enables users to create, retrieve, update, and delete Analysis Services servers
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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
  macServiceName = "analysisservices"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServersCheckNameAvailability_593647 = ref object of OpenApiRestCall_593425
proc url_ServersCheckNameAvailability_593649(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AnalysisServices/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersCheckNameAvailability_593648(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the name availability in the target location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The region name which the operation will lookup into.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593822 = path.getOrDefault("subscriptionId")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "subscriptionId", valid_593822
  var valid_593823 = path.getOrDefault("location")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "location", valid_593823
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593824 = query.getOrDefault("api-version")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "api-version", valid_593824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   serverParameters: JObject (required)
  ##                   : Contains the information used to provision the Analysis Services server.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593848: Call_ServersCheckNameAvailability_593647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check the name availability in the target location.
  ## 
  let valid = call_593848.validator(path, query, header, formData, body)
  let scheme = call_593848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593848.url(scheme.get, call_593848.host, call_593848.base,
                         call_593848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593848, url, valid)

proc call*(call_593919: Call_ServersCheckNameAvailability_593647;
          apiVersion: string; subscriptionId: string; location: string;
          serverParameters: JsonNode): Recallable =
  ## serversCheckNameAvailability
  ## Check the name availability in the target location.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The region name which the operation will lookup into.
  ##   serverParameters: JObject (required)
  ##                   : Contains the information used to provision the Analysis Services server.
  var path_593920 = newJObject()
  var query_593922 = newJObject()
  var body_593923 = newJObject()
  add(query_593922, "api-version", newJString(apiVersion))
  add(path_593920, "subscriptionId", newJString(subscriptionId))
  add(path_593920, "location", newJString(location))
  if serverParameters != nil:
    body_593923 = serverParameters
  result = call_593919.call(path_593920, query_593922, nil, nil, body_593923)

var serversCheckNameAvailability* = Call_ServersCheckNameAvailability_593647(
    name: "serversCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AnalysisServices/locations/{location}/checkNameAvailability",
    validator: validate_ServersCheckNameAvailability_593648, base: "",
    url: url_ServersCheckNameAvailability_593649, schemes: {Scheme.Https})
type
  Call_ServersListOperationResults_593962 = ref object of OpenApiRestCall_593425
proc url_ServersListOperationResults_593964(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AnalysisServices/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/operationresults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersListOperationResults_593963(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the result of the specified operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   operationId: JString (required)
  ##              : The target operation Id.
  ##   location: JString (required)
  ##           : The region name which the operation will lookup into.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593965 = path.getOrDefault("subscriptionId")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "subscriptionId", valid_593965
  var valid_593966 = path.getOrDefault("operationId")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "operationId", valid_593966
  var valid_593967 = path.getOrDefault("location")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "location", valid_593967
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_593969: Call_ServersListOperationResults_593962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the result of the specified operation.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_ServersListOperationResults_593962;
          apiVersion: string; subscriptionId: string; operationId: string;
          location: string): Recallable =
  ## serversListOperationResults
  ## List the result of the specified operation.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   operationId: string (required)
  ##              : The target operation Id.
  ##   location: string (required)
  ##           : The region name which the operation will lookup into.
  var path_593971 = newJObject()
  var query_593972 = newJObject()
  add(query_593972, "api-version", newJString(apiVersion))
  add(path_593971, "subscriptionId", newJString(subscriptionId))
  add(path_593971, "operationId", newJString(operationId))
  add(path_593971, "location", newJString(location))
  result = call_593970.call(path_593971, query_593972, nil, nil, nil)

var serversListOperationResults* = Call_ServersListOperationResults_593962(
    name: "serversListOperationResults", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AnalysisServices/locations/{location}/operationresults/{operationId}",
    validator: validate_ServersListOperationResults_593963, base: "",
    url: url_ServersListOperationResults_593964, schemes: {Scheme.Https})
type
  Call_ServersListOperationStatuses_593973 = ref object of OpenApiRestCall_593425
proc url_ServersListOperationStatuses_593975(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AnalysisServices/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/operationstatuses/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersListOperationStatuses_593974(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the status of operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   operationId: JString (required)
  ##              : The target operation Id.
  ##   location: JString (required)
  ##           : The region name which the operation will lookup into.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593976 = path.getOrDefault("subscriptionId")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "subscriptionId", valid_593976
  var valid_593977 = path.getOrDefault("operationId")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "operationId", valid_593977
  var valid_593978 = path.getOrDefault("location")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "location", valid_593978
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_593980: Call_ServersListOperationStatuses_593973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the status of operation.
  ## 
  let valid = call_593980.validator(path, query, header, formData, body)
  let scheme = call_593980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593980.url(scheme.get, call_593980.host, call_593980.base,
                         call_593980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593980, url, valid)

proc call*(call_593981: Call_ServersListOperationStatuses_593973;
          apiVersion: string; subscriptionId: string; operationId: string;
          location: string): Recallable =
  ## serversListOperationStatuses
  ## List the status of operation.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   operationId: string (required)
  ##              : The target operation Id.
  ##   location: string (required)
  ##           : The region name which the operation will lookup into.
  var path_593982 = newJObject()
  var query_593983 = newJObject()
  add(query_593983, "api-version", newJString(apiVersion))
  add(path_593982, "subscriptionId", newJString(subscriptionId))
  add(path_593982, "operationId", newJString(operationId))
  add(path_593982, "location", newJString(location))
  result = call_593981.call(path_593982, query_593983, nil, nil, nil)

var serversListOperationStatuses* = Call_ServersListOperationStatuses_593973(
    name: "serversListOperationStatuses", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AnalysisServices/locations/{location}/operationstatuses/{operationId}",
    validator: validate_ServersListOperationStatuses_593974, base: "",
    url: url_ServersListOperationStatuses_593975, schemes: {Scheme.Https})
type
  Call_ServersList_593984 = ref object of OpenApiRestCall_593425
proc url_ServersList_593986(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.AnalysisServices/servers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersList_593985(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the Analysis Services servers for the given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593987 = path.getOrDefault("subscriptionId")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "subscriptionId", valid_593987
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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

proc call*(call_593989: Call_ServersList_593984; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Analysis Services servers for the given subscription.
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_ServersList_593984; apiVersion: string;
          subscriptionId: string): Recallable =
  ## serversList
  ## Lists all the Analysis Services servers for the given subscription.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  add(query_593992, "api-version", newJString(apiVersion))
  add(path_593991, "subscriptionId", newJString(subscriptionId))
  result = call_593990.call(path_593991, query_593992, nil, nil, nil)

var serversList* = Call_ServersList_593984(name: "serversList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AnalysisServices/servers",
                                        validator: validate_ServersList_593985,
                                        base: "", url: url_ServersList_593986,
                                        schemes: {Scheme.Https})
type
  Call_ServersListSkusForNew_593993 = ref object of OpenApiRestCall_593425
proc url_ServersListSkusForNew_593995(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.AnalysisServices/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersListSkusForNew_593994(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists eligible SKUs for Analysis Services resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593996 = path.getOrDefault("subscriptionId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "subscriptionId", valid_593996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593997 = query.getOrDefault("api-version")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "api-version", valid_593997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593998: Call_ServersListSkusForNew_593993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists eligible SKUs for Analysis Services resource provider.
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_ServersListSkusForNew_593993; apiVersion: string;
          subscriptionId: string): Recallable =
  ## serversListSkusForNew
  ## Lists eligible SKUs for Analysis Services resource provider.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594000 = newJObject()
  var query_594001 = newJObject()
  add(query_594001, "api-version", newJString(apiVersion))
  add(path_594000, "subscriptionId", newJString(subscriptionId))
  result = call_593999.call(path_594000, query_594001, nil, nil, nil)

var serversListSkusForNew* = Call_ServersListSkusForNew_593993(
    name: "serversListSkusForNew", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AnalysisServices/skus",
    validator: validate_ServersListSkusForNew_593994, base: "",
    url: url_ServersListSkusForNew_593995, schemes: {Scheme.Https})
type
  Call_ServersListByResourceGroup_594002 = ref object of OpenApiRestCall_593425
proc url_ServersListByResourceGroup_594004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.AnalysisServices/servers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersListByResourceGroup_594003(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the Analysis Services servers for the given resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594005 = path.getOrDefault("resourceGroupName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "resourceGroupName", valid_594005
  var valid_594006 = path.getOrDefault("subscriptionId")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "subscriptionId", valid_594006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594008: Call_ServersListByResourceGroup_594002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the Analysis Services servers for the given resource group.
  ## 
  let valid = call_594008.validator(path, query, header, formData, body)
  let scheme = call_594008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594008.url(scheme.get, call_594008.host, call_594008.base,
                         call_594008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594008, url, valid)

proc call*(call_594009: Call_ServersListByResourceGroup_594002;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## serversListByResourceGroup
  ## Gets all the Analysis Services servers for the given resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594010 = newJObject()
  var query_594011 = newJObject()
  add(path_594010, "resourceGroupName", newJString(resourceGroupName))
  add(query_594011, "api-version", newJString(apiVersion))
  add(path_594010, "subscriptionId", newJString(subscriptionId))
  result = call_594009.call(path_594010, query_594011, nil, nil, nil)

var serversListByResourceGroup* = Call_ServersListByResourceGroup_594002(
    name: "serversListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers",
    validator: validate_ServersListByResourceGroup_594003, base: "",
    url: url_ServersListByResourceGroup_594004, schemes: {Scheme.Https})
type
  Call_ServersCreate_594023 = ref object of OpenApiRestCall_593425
proc url_ServersCreate_594025(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AnalysisServices/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersCreate_594024(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Provisions the specified Analysis Services server based on the configuration specified in the request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  ##   serverName: JString (required)
  ##             : The name of the Analysis Services server. It must be a minimum of 3 characters, and a maximum of 63.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594026 = path.getOrDefault("resourceGroupName")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "resourceGroupName", valid_594026
  var valid_594027 = path.getOrDefault("serverName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "serverName", valid_594027
  var valid_594028 = path.getOrDefault("subscriptionId")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "subscriptionId", valid_594028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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
  ## parameters in `body` object:
  ##   serverParameters: JObject (required)
  ##                   : Contains the information used to provision the Analysis Services server.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594031: Call_ServersCreate_594023; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provisions the specified Analysis Services server based on the configuration specified in the request.
  ## 
  let valid = call_594031.validator(path, query, header, formData, body)
  let scheme = call_594031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594031.url(scheme.get, call_594031.host, call_594031.base,
                         call_594031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594031, url, valid)

proc call*(call_594032: Call_ServersCreate_594023; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          serverParameters: JsonNode): Recallable =
  ## serversCreate
  ## Provisions the specified Analysis Services server based on the configuration specified in the request.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   serverName: string (required)
  ##             : The name of the Analysis Services server. It must be a minimum of 3 characters, and a maximum of 63.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serverParameters: JObject (required)
  ##                   : Contains the information used to provision the Analysis Services server.
  var path_594033 = newJObject()
  var query_594034 = newJObject()
  var body_594035 = newJObject()
  add(path_594033, "resourceGroupName", newJString(resourceGroupName))
  add(query_594034, "api-version", newJString(apiVersion))
  add(path_594033, "serverName", newJString(serverName))
  add(path_594033, "subscriptionId", newJString(subscriptionId))
  if serverParameters != nil:
    body_594035 = serverParameters
  result = call_594032.call(path_594033, query_594034, nil, nil, body_594035)

var serversCreate* = Call_ServersCreate_594023(name: "serversCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers/{serverName}",
    validator: validate_ServersCreate_594024, base: "", url: url_ServersCreate_594025,
    schemes: {Scheme.Https})
type
  Call_ServersGetDetails_594012 = ref object of OpenApiRestCall_593425
proc url_ServersGetDetails_594014(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AnalysisServices/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersGetDetails_594013(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets details about the specified Analysis Services server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  ##   serverName: JString (required)
  ##             : The name of the Analysis Services server. It must be a minimum of 3 characters, and a maximum of 63.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594015 = path.getOrDefault("resourceGroupName")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "resourceGroupName", valid_594015
  var valid_594016 = path.getOrDefault("serverName")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "serverName", valid_594016
  var valid_594017 = path.getOrDefault("subscriptionId")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "subscriptionId", valid_594017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594018 = query.getOrDefault("api-version")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "api-version", valid_594018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594019: Call_ServersGetDetails_594012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details about the specified Analysis Services server.
  ## 
  let valid = call_594019.validator(path, query, header, formData, body)
  let scheme = call_594019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594019.url(scheme.get, call_594019.host, call_594019.base,
                         call_594019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594019, url, valid)

proc call*(call_594020: Call_ServersGetDetails_594012; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string): Recallable =
  ## serversGetDetails
  ## Gets details about the specified Analysis Services server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   serverName: string (required)
  ##             : The name of the Analysis Services server. It must be a minimum of 3 characters, and a maximum of 63.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594021 = newJObject()
  var query_594022 = newJObject()
  add(path_594021, "resourceGroupName", newJString(resourceGroupName))
  add(query_594022, "api-version", newJString(apiVersion))
  add(path_594021, "serverName", newJString(serverName))
  add(path_594021, "subscriptionId", newJString(subscriptionId))
  result = call_594020.call(path_594021, query_594022, nil, nil, nil)

var serversGetDetails* = Call_ServersGetDetails_594012(name: "serversGetDetails",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers/{serverName}",
    validator: validate_ServersGetDetails_594013, base: "",
    url: url_ServersGetDetails_594014, schemes: {Scheme.Https})
type
  Call_ServersUpdate_594047 = ref object of OpenApiRestCall_593425
proc url_ServersUpdate_594049(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AnalysisServices/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersUpdate_594048(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the current state of the specified Analysis Services server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  ##   serverName: JString (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594050 = path.getOrDefault("resourceGroupName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "resourceGroupName", valid_594050
  var valid_594051 = path.getOrDefault("serverName")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "serverName", valid_594051
  var valid_594052 = path.getOrDefault("subscriptionId")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "subscriptionId", valid_594052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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
  ##   serverUpdateParameters: JObject (required)
  ##                         : Request object that contains the updated information for the server.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594055: Call_ServersUpdate_594047; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the current state of the specified Analysis Services server.
  ## 
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_ServersUpdate_594047; resourceGroupName: string;
          apiVersion: string; serverName: string; serverUpdateParameters: JsonNode;
          subscriptionId: string): Recallable =
  ## serversUpdate
  ## Updates the current state of the specified Analysis Services server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   serverName: string (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   serverUpdateParameters: JObject (required)
  ##                         : Request object that contains the updated information for the server.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594057 = newJObject()
  var query_594058 = newJObject()
  var body_594059 = newJObject()
  add(path_594057, "resourceGroupName", newJString(resourceGroupName))
  add(query_594058, "api-version", newJString(apiVersion))
  add(path_594057, "serverName", newJString(serverName))
  if serverUpdateParameters != nil:
    body_594059 = serverUpdateParameters
  add(path_594057, "subscriptionId", newJString(subscriptionId))
  result = call_594056.call(path_594057, query_594058, nil, nil, body_594059)

var serversUpdate* = Call_ServersUpdate_594047(name: "serversUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers/{serverName}",
    validator: validate_ServersUpdate_594048, base: "", url: url_ServersUpdate_594049,
    schemes: {Scheme.Https})
type
  Call_ServersDelete_594036 = ref object of OpenApiRestCall_593425
proc url_ServersDelete_594038(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AnalysisServices/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersDelete_594037(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified Analysis Services server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  ##   serverName: JString (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594039 = path.getOrDefault("resourceGroupName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "resourceGroupName", valid_594039
  var valid_594040 = path.getOrDefault("serverName")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "serverName", valid_594040
  var valid_594041 = path.getOrDefault("subscriptionId")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "subscriptionId", valid_594041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594042 = query.getOrDefault("api-version")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "api-version", valid_594042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594043: Call_ServersDelete_594036; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Analysis Services server.
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_ServersDelete_594036; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string): Recallable =
  ## serversDelete
  ## Deletes the specified Analysis Services server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   serverName: string (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594045 = newJObject()
  var query_594046 = newJObject()
  add(path_594045, "resourceGroupName", newJString(resourceGroupName))
  add(query_594046, "api-version", newJString(apiVersion))
  add(path_594045, "serverName", newJString(serverName))
  add(path_594045, "subscriptionId", newJString(subscriptionId))
  result = call_594044.call(path_594045, query_594046, nil, nil, nil)

var serversDelete* = Call_ServersDelete_594036(name: "serversDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers/{serverName}",
    validator: validate_ServersDelete_594037, base: "", url: url_ServersDelete_594038,
    schemes: {Scheme.Https})
type
  Call_ServersResume_594060 = ref object of OpenApiRestCall_593425
proc url_ServersResume_594062(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AnalysisServices/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/resume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersResume_594061(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Resumes operation of the specified Analysis Services server instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  ##   serverName: JString (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594063 = path.getOrDefault("resourceGroupName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "resourceGroupName", valid_594063
  var valid_594064 = path.getOrDefault("serverName")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "serverName", valid_594064
  var valid_594065 = path.getOrDefault("subscriptionId")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "subscriptionId", valid_594065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_594067: Call_ServersResume_594060; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resumes operation of the specified Analysis Services server instance.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_ServersResume_594060; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string): Recallable =
  ## serversResume
  ## Resumes operation of the specified Analysis Services server instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   serverName: string (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  add(path_594069, "resourceGroupName", newJString(resourceGroupName))
  add(query_594070, "api-version", newJString(apiVersion))
  add(path_594069, "serverName", newJString(serverName))
  add(path_594069, "subscriptionId", newJString(subscriptionId))
  result = call_594068.call(path_594069, query_594070, nil, nil, nil)

var serversResume* = Call_ServersResume_594060(name: "serversResume",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers/{serverName}/resume",
    validator: validate_ServersResume_594061, base: "", url: url_ServersResume_594062,
    schemes: {Scheme.Https})
type
  Call_ServersListSkusForExisting_594071 = ref object of OpenApiRestCall_593425
proc url_ServersListSkusForExisting_594073(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AnalysisServices/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersListSkusForExisting_594072(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists eligible SKUs for an Analysis Services resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  ##   serverName: JString (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594074 = path.getOrDefault("resourceGroupName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "resourceGroupName", valid_594074
  var valid_594075 = path.getOrDefault("serverName")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "serverName", valid_594075
  var valid_594076 = path.getOrDefault("subscriptionId")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "subscriptionId", valid_594076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594077 = query.getOrDefault("api-version")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "api-version", valid_594077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594078: Call_ServersListSkusForExisting_594071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists eligible SKUs for an Analysis Services resource.
  ## 
  let valid = call_594078.validator(path, query, header, formData, body)
  let scheme = call_594078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594078.url(scheme.get, call_594078.host, call_594078.base,
                         call_594078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594078, url, valid)

proc call*(call_594079: Call_ServersListSkusForExisting_594071;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## serversListSkusForExisting
  ## Lists eligible SKUs for an Analysis Services resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   serverName: string (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594080 = newJObject()
  var query_594081 = newJObject()
  add(path_594080, "resourceGroupName", newJString(resourceGroupName))
  add(query_594081, "api-version", newJString(apiVersion))
  add(path_594080, "serverName", newJString(serverName))
  add(path_594080, "subscriptionId", newJString(subscriptionId))
  result = call_594079.call(path_594080, query_594081, nil, nil, nil)

var serversListSkusForExisting* = Call_ServersListSkusForExisting_594071(
    name: "serversListSkusForExisting", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers/{serverName}/skus",
    validator: validate_ServersListSkusForExisting_594072, base: "",
    url: url_ServersListSkusForExisting_594073, schemes: {Scheme.Https})
type
  Call_ServersSuspend_594082 = ref object of OpenApiRestCall_593425
proc url_ServersSuspend_594084(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AnalysisServices/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/suspend")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersSuspend_594083(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Suspends operation of the specified Analysis Services server instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  ##   serverName: JString (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594085 = path.getOrDefault("resourceGroupName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "resourceGroupName", valid_594085
  var valid_594086 = path.getOrDefault("serverName")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "serverName", valid_594086
  var valid_594087 = path.getOrDefault("subscriptionId")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "subscriptionId", valid_594087
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594088 = query.getOrDefault("api-version")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "api-version", valid_594088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594089: Call_ServersSuspend_594082; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspends operation of the specified Analysis Services server instance.
  ## 
  let valid = call_594089.validator(path, query, header, formData, body)
  let scheme = call_594089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594089.url(scheme.get, call_594089.host, call_594089.base,
                         call_594089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594089, url, valid)

proc call*(call_594090: Call_ServersSuspend_594082; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string): Recallable =
  ## serversSuspend
  ## Suspends operation of the specified Analysis Services server instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   serverName: string (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594091 = newJObject()
  var query_594092 = newJObject()
  add(path_594091, "resourceGroupName", newJString(resourceGroupName))
  add(query_594092, "api-version", newJString(apiVersion))
  add(path_594091, "serverName", newJString(serverName))
  add(path_594091, "subscriptionId", newJString(subscriptionId))
  result = call_594090.call(path_594091, query_594092, nil, nil, nil)

var serversSuspend* = Call_ServersSuspend_594082(name: "serversSuspend",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers/{serverName}/suspend",
    validator: validate_ServersSuspend_594083, base: "", url: url_ServersSuspend_594084,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
