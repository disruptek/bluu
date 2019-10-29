
import
  json, options, hashes, uri, rest, os, uri, httpcore

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
  macServiceName = "analysisservices"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServersCheckNameAvailability_563778 = ref object of OpenApiRestCall_563556
proc url_ServersCheckNameAvailability_563780(protocol: Scheme; host: string;
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

proc validate_ServersCheckNameAvailability_563779(path: JsonNode; query: JsonNode;
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
  var valid_563955 = path.getOrDefault("subscriptionId")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "subscriptionId", valid_563955
  var valid_563956 = path.getOrDefault("location")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "location", valid_563956
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563957 = query.getOrDefault("api-version")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "api-version", valid_563957
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

proc call*(call_563981: Call_ServersCheckNameAvailability_563778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check the name availability in the target location.
  ## 
  let valid = call_563981.validator(path, query, header, formData, body)
  let scheme = call_563981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563981.url(scheme.get, call_563981.host, call_563981.base,
                         call_563981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563981, url, valid)

proc call*(call_564052: Call_ServersCheckNameAvailability_563778;
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
  var path_564053 = newJObject()
  var query_564055 = newJObject()
  var body_564056 = newJObject()
  add(query_564055, "api-version", newJString(apiVersion))
  add(path_564053, "subscriptionId", newJString(subscriptionId))
  add(path_564053, "location", newJString(location))
  if serverParameters != nil:
    body_564056 = serverParameters
  result = call_564052.call(path_564053, query_564055, nil, nil, body_564056)

var serversCheckNameAvailability* = Call_ServersCheckNameAvailability_563778(
    name: "serversCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AnalysisServices/locations/{location}/checkNameAvailability",
    validator: validate_ServersCheckNameAvailability_563779, base: "",
    url: url_ServersCheckNameAvailability_563780, schemes: {Scheme.Https})
type
  Call_ServersListOperationResults_564095 = ref object of OpenApiRestCall_563556
proc url_ServersListOperationResults_564097(protocol: Scheme; host: string;
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

proc validate_ServersListOperationResults_564096(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the result of the specified operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : The target operation Id.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The region name which the operation will lookup into.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_564098 = path.getOrDefault("operationId")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "operationId", valid_564098
  var valid_564099 = path.getOrDefault("subscriptionId")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "subscriptionId", valid_564099
  var valid_564100 = path.getOrDefault("location")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "location", valid_564100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564101 = query.getOrDefault("api-version")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "api-version", valid_564101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564102: Call_ServersListOperationResults_564095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the result of the specified operation.
  ## 
  let valid = call_564102.validator(path, query, header, formData, body)
  let scheme = call_564102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564102.url(scheme.get, call_564102.host, call_564102.base,
                         call_564102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564102, url, valid)

proc call*(call_564103: Call_ServersListOperationResults_564095;
          apiVersion: string; operationId: string; subscriptionId: string;
          location: string): Recallable =
  ## serversListOperationResults
  ## List the result of the specified operation.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   operationId: string (required)
  ##              : The target operation Id.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The region name which the operation will lookup into.
  var path_564104 = newJObject()
  var query_564105 = newJObject()
  add(query_564105, "api-version", newJString(apiVersion))
  add(path_564104, "operationId", newJString(operationId))
  add(path_564104, "subscriptionId", newJString(subscriptionId))
  add(path_564104, "location", newJString(location))
  result = call_564103.call(path_564104, query_564105, nil, nil, nil)

var serversListOperationResults* = Call_ServersListOperationResults_564095(
    name: "serversListOperationResults", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AnalysisServices/locations/{location}/operationresults/{operationId}",
    validator: validate_ServersListOperationResults_564096, base: "",
    url: url_ServersListOperationResults_564097, schemes: {Scheme.Https})
type
  Call_ServersListOperationStatuses_564106 = ref object of OpenApiRestCall_563556
proc url_ServersListOperationStatuses_564108(protocol: Scheme; host: string;
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

proc validate_ServersListOperationStatuses_564107(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the status of operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : The target operation Id.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The region name which the operation will lookup into.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_564109 = path.getOrDefault("operationId")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "operationId", valid_564109
  var valid_564110 = path.getOrDefault("subscriptionId")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "subscriptionId", valid_564110
  var valid_564111 = path.getOrDefault("location")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "location", valid_564111
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564112 = query.getOrDefault("api-version")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "api-version", valid_564112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564113: Call_ServersListOperationStatuses_564106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the status of operation.
  ## 
  let valid = call_564113.validator(path, query, header, formData, body)
  let scheme = call_564113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564113.url(scheme.get, call_564113.host, call_564113.base,
                         call_564113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564113, url, valid)

proc call*(call_564114: Call_ServersListOperationStatuses_564106;
          apiVersion: string; operationId: string; subscriptionId: string;
          location: string): Recallable =
  ## serversListOperationStatuses
  ## List the status of operation.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   operationId: string (required)
  ##              : The target operation Id.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The region name which the operation will lookup into.
  var path_564115 = newJObject()
  var query_564116 = newJObject()
  add(query_564116, "api-version", newJString(apiVersion))
  add(path_564115, "operationId", newJString(operationId))
  add(path_564115, "subscriptionId", newJString(subscriptionId))
  add(path_564115, "location", newJString(location))
  result = call_564114.call(path_564115, query_564116, nil, nil, nil)

var serversListOperationStatuses* = Call_ServersListOperationStatuses_564106(
    name: "serversListOperationStatuses", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AnalysisServices/locations/{location}/operationstatuses/{operationId}",
    validator: validate_ServersListOperationStatuses_564107, base: "",
    url: url_ServersListOperationStatuses_564108, schemes: {Scheme.Https})
type
  Call_ServersList_564117 = ref object of OpenApiRestCall_563556
proc url_ServersList_564119(protocol: Scheme; host: string; base: string;
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

proc validate_ServersList_564118(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564120 = path.getOrDefault("subscriptionId")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "subscriptionId", valid_564120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564122: Call_ServersList_564117; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Analysis Services servers for the given subscription.
  ## 
  let valid = call_564122.validator(path, query, header, formData, body)
  let scheme = call_564122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564122.url(scheme.get, call_564122.host, call_564122.base,
                         call_564122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564122, url, valid)

proc call*(call_564123: Call_ServersList_564117; apiVersion: string;
          subscriptionId: string): Recallable =
  ## serversList
  ## Lists all the Analysis Services servers for the given subscription.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564124 = newJObject()
  var query_564125 = newJObject()
  add(query_564125, "api-version", newJString(apiVersion))
  add(path_564124, "subscriptionId", newJString(subscriptionId))
  result = call_564123.call(path_564124, query_564125, nil, nil, nil)

var serversList* = Call_ServersList_564117(name: "serversList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AnalysisServices/servers",
                                        validator: validate_ServersList_564118,
                                        base: "", url: url_ServersList_564119,
                                        schemes: {Scheme.Https})
type
  Call_ServersListSkusForNew_564126 = ref object of OpenApiRestCall_563556
proc url_ServersListSkusForNew_564128(protocol: Scheme; host: string; base: string;
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

proc validate_ServersListSkusForNew_564127(path: JsonNode; query: JsonNode;
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
  var valid_564129 = path.getOrDefault("subscriptionId")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "subscriptionId", valid_564129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564130 = query.getOrDefault("api-version")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "api-version", valid_564130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564131: Call_ServersListSkusForNew_564126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists eligible SKUs for Analysis Services resource provider.
  ## 
  let valid = call_564131.validator(path, query, header, formData, body)
  let scheme = call_564131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564131.url(scheme.get, call_564131.host, call_564131.base,
                         call_564131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564131, url, valid)

proc call*(call_564132: Call_ServersListSkusForNew_564126; apiVersion: string;
          subscriptionId: string): Recallable =
  ## serversListSkusForNew
  ## Lists eligible SKUs for Analysis Services resource provider.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564133 = newJObject()
  var query_564134 = newJObject()
  add(query_564134, "api-version", newJString(apiVersion))
  add(path_564133, "subscriptionId", newJString(subscriptionId))
  result = call_564132.call(path_564133, query_564134, nil, nil, nil)

var serversListSkusForNew* = Call_ServersListSkusForNew_564126(
    name: "serversListSkusForNew", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AnalysisServices/skus",
    validator: validate_ServersListSkusForNew_564127, base: "",
    url: url_ServersListSkusForNew_564128, schemes: {Scheme.Https})
type
  Call_ServersListByResourceGroup_564135 = ref object of OpenApiRestCall_563556
proc url_ServersListByResourceGroup_564137(protocol: Scheme; host: string;
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

proc validate_ServersListByResourceGroup_564136(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the Analysis Services servers for the given resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564138 = path.getOrDefault("subscriptionId")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "subscriptionId", valid_564138
  var valid_564139 = path.getOrDefault("resourceGroupName")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "resourceGroupName", valid_564139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564140 = query.getOrDefault("api-version")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "api-version", valid_564140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564141: Call_ServersListByResourceGroup_564135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the Analysis Services servers for the given resource group.
  ## 
  let valid = call_564141.validator(path, query, header, formData, body)
  let scheme = call_564141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564141.url(scheme.get, call_564141.host, call_564141.base,
                         call_564141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564141, url, valid)

proc call*(call_564142: Call_ServersListByResourceGroup_564135; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## serversListByResourceGroup
  ## Gets all the Analysis Services servers for the given resource group.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  var path_564143 = newJObject()
  var query_564144 = newJObject()
  add(query_564144, "api-version", newJString(apiVersion))
  add(path_564143, "subscriptionId", newJString(subscriptionId))
  add(path_564143, "resourceGroupName", newJString(resourceGroupName))
  result = call_564142.call(path_564143, query_564144, nil, nil, nil)

var serversListByResourceGroup* = Call_ServersListByResourceGroup_564135(
    name: "serversListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers",
    validator: validate_ServersListByResourceGroup_564136, base: "",
    url: url_ServersListByResourceGroup_564137, schemes: {Scheme.Https})
type
  Call_ServersCreate_564156 = ref object of OpenApiRestCall_563556
proc url_ServersCreate_564158(protocol: Scheme; host: string; base: string;
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

proc validate_ServersCreate_564157(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Provisions the specified Analysis Services server based on the configuration specified in the request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the Analysis Services server. It must be a minimum of 3 characters, and a maximum of 63.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564159 = path.getOrDefault("serverName")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "serverName", valid_564159
  var valid_564160 = path.getOrDefault("subscriptionId")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "subscriptionId", valid_564160
  var valid_564161 = path.getOrDefault("resourceGroupName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "resourceGroupName", valid_564161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564162 = query.getOrDefault("api-version")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "api-version", valid_564162
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

proc call*(call_564164: Call_ServersCreate_564156; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provisions the specified Analysis Services server based on the configuration specified in the request.
  ## 
  let valid = call_564164.validator(path, query, header, formData, body)
  let scheme = call_564164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564164.url(scheme.get, call_564164.host, call_564164.base,
                         call_564164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564164, url, valid)

proc call*(call_564165: Call_ServersCreate_564156; apiVersion: string;
          serverName: string; subscriptionId: string; serverParameters: JsonNode;
          resourceGroupName: string): Recallable =
  ## serversCreate
  ## Provisions the specified Analysis Services server based on the configuration specified in the request.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   serverName: string (required)
  ##             : The name of the Analysis Services server. It must be a minimum of 3 characters, and a maximum of 63.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serverParameters: JObject (required)
  ##                   : Contains the information used to provision the Analysis Services server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  var path_564166 = newJObject()
  var query_564167 = newJObject()
  var body_564168 = newJObject()
  add(query_564167, "api-version", newJString(apiVersion))
  add(path_564166, "serverName", newJString(serverName))
  add(path_564166, "subscriptionId", newJString(subscriptionId))
  if serverParameters != nil:
    body_564168 = serverParameters
  add(path_564166, "resourceGroupName", newJString(resourceGroupName))
  result = call_564165.call(path_564166, query_564167, nil, nil, body_564168)

var serversCreate* = Call_ServersCreate_564156(name: "serversCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers/{serverName}",
    validator: validate_ServersCreate_564157, base: "", url: url_ServersCreate_564158,
    schemes: {Scheme.Https})
type
  Call_ServersGetDetails_564145 = ref object of OpenApiRestCall_563556
proc url_ServersGetDetails_564147(protocol: Scheme; host: string; base: string;
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

proc validate_ServersGetDetails_564146(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets details about the specified Analysis Services server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the Analysis Services server. It must be a minimum of 3 characters, and a maximum of 63.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564148 = path.getOrDefault("serverName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "serverName", valid_564148
  var valid_564149 = path.getOrDefault("subscriptionId")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "subscriptionId", valid_564149
  var valid_564150 = path.getOrDefault("resourceGroupName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "resourceGroupName", valid_564150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564151 = query.getOrDefault("api-version")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "api-version", valid_564151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564152: Call_ServersGetDetails_564145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details about the specified Analysis Services server.
  ## 
  let valid = call_564152.validator(path, query, header, formData, body)
  let scheme = call_564152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564152.url(scheme.get, call_564152.host, call_564152.base,
                         call_564152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564152, url, valid)

proc call*(call_564153: Call_ServersGetDetails_564145; apiVersion: string;
          serverName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## serversGetDetails
  ## Gets details about the specified Analysis Services server.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   serverName: string (required)
  ##             : The name of the Analysis Services server. It must be a minimum of 3 characters, and a maximum of 63.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  var path_564154 = newJObject()
  var query_564155 = newJObject()
  add(query_564155, "api-version", newJString(apiVersion))
  add(path_564154, "serverName", newJString(serverName))
  add(path_564154, "subscriptionId", newJString(subscriptionId))
  add(path_564154, "resourceGroupName", newJString(resourceGroupName))
  result = call_564153.call(path_564154, query_564155, nil, nil, nil)

var serversGetDetails* = Call_ServersGetDetails_564145(name: "serversGetDetails",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers/{serverName}",
    validator: validate_ServersGetDetails_564146, base: "",
    url: url_ServersGetDetails_564147, schemes: {Scheme.Https})
type
  Call_ServersUpdate_564180 = ref object of OpenApiRestCall_563556
proc url_ServersUpdate_564182(protocol: Scheme; host: string; base: string;
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

proc validate_ServersUpdate_564181(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the current state of the specified Analysis Services server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564183 = path.getOrDefault("serverName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "serverName", valid_564183
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
  ##              : The client API version.
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
  ##   serverUpdateParameters: JObject (required)
  ##                         : Request object that contains the updated information for the server.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564188: Call_ServersUpdate_564180; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the current state of the specified Analysis Services server.
  ## 
  let valid = call_564188.validator(path, query, header, formData, body)
  let scheme = call_564188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564188.url(scheme.get, call_564188.host, call_564188.base,
                         call_564188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564188, url, valid)

proc call*(call_564189: Call_ServersUpdate_564180;
          serverUpdateParameters: JsonNode; apiVersion: string; serverName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## serversUpdate
  ## Updates the current state of the specified Analysis Services server.
  ##   serverUpdateParameters: JObject (required)
  ##                         : Request object that contains the updated information for the server.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   serverName: string (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  var path_564190 = newJObject()
  var query_564191 = newJObject()
  var body_564192 = newJObject()
  if serverUpdateParameters != nil:
    body_564192 = serverUpdateParameters
  add(query_564191, "api-version", newJString(apiVersion))
  add(path_564190, "serverName", newJString(serverName))
  add(path_564190, "subscriptionId", newJString(subscriptionId))
  add(path_564190, "resourceGroupName", newJString(resourceGroupName))
  result = call_564189.call(path_564190, query_564191, nil, nil, body_564192)

var serversUpdate* = Call_ServersUpdate_564180(name: "serversUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers/{serverName}",
    validator: validate_ServersUpdate_564181, base: "", url: url_ServersUpdate_564182,
    schemes: {Scheme.Https})
type
  Call_ServersDelete_564169 = ref object of OpenApiRestCall_563556
proc url_ServersDelete_564171(protocol: Scheme; host: string; base: string;
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

proc validate_ServersDelete_564170(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified Analysis Services server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564172 = path.getOrDefault("serverName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "serverName", valid_564172
  var valid_564173 = path.getOrDefault("subscriptionId")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "subscriptionId", valid_564173
  var valid_564174 = path.getOrDefault("resourceGroupName")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "resourceGroupName", valid_564174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564175 = query.getOrDefault("api-version")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "api-version", valid_564175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564176: Call_ServersDelete_564169; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Analysis Services server.
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_ServersDelete_564169; apiVersion: string;
          serverName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## serversDelete
  ## Deletes the specified Analysis Services server.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   serverName: string (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  var path_564178 = newJObject()
  var query_564179 = newJObject()
  add(query_564179, "api-version", newJString(apiVersion))
  add(path_564178, "serverName", newJString(serverName))
  add(path_564178, "subscriptionId", newJString(subscriptionId))
  add(path_564178, "resourceGroupName", newJString(resourceGroupName))
  result = call_564177.call(path_564178, query_564179, nil, nil, nil)

var serversDelete* = Call_ServersDelete_564169(name: "serversDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers/{serverName}",
    validator: validate_ServersDelete_564170, base: "", url: url_ServersDelete_564171,
    schemes: {Scheme.Https})
type
  Call_ServersResume_564193 = ref object of OpenApiRestCall_563556
proc url_ServersResume_564195(protocol: Scheme; host: string; base: string;
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

proc validate_ServersResume_564194(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Resumes operation of the specified Analysis Services server instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564196 = path.getOrDefault("serverName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "serverName", valid_564196
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
  ##              : The client API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564200: Call_ServersResume_564193; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resumes operation of the specified Analysis Services server instance.
  ## 
  let valid = call_564200.validator(path, query, header, formData, body)
  let scheme = call_564200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564200.url(scheme.get, call_564200.host, call_564200.base,
                         call_564200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564200, url, valid)

proc call*(call_564201: Call_ServersResume_564193; apiVersion: string;
          serverName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## serversResume
  ## Resumes operation of the specified Analysis Services server instance.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   serverName: string (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  var path_564202 = newJObject()
  var query_564203 = newJObject()
  add(query_564203, "api-version", newJString(apiVersion))
  add(path_564202, "serverName", newJString(serverName))
  add(path_564202, "subscriptionId", newJString(subscriptionId))
  add(path_564202, "resourceGroupName", newJString(resourceGroupName))
  result = call_564201.call(path_564202, query_564203, nil, nil, nil)

var serversResume* = Call_ServersResume_564193(name: "serversResume",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers/{serverName}/resume",
    validator: validate_ServersResume_564194, base: "", url: url_ServersResume_564195,
    schemes: {Scheme.Https})
type
  Call_ServersListSkusForExisting_564204 = ref object of OpenApiRestCall_563556
proc url_ServersListSkusForExisting_564206(protocol: Scheme; host: string;
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

proc validate_ServersListSkusForExisting_564205(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists eligible SKUs for an Analysis Services resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564207 = path.getOrDefault("serverName")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "serverName", valid_564207
  var valid_564208 = path.getOrDefault("subscriptionId")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "subscriptionId", valid_564208
  var valid_564209 = path.getOrDefault("resourceGroupName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "resourceGroupName", valid_564209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564210 = query.getOrDefault("api-version")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "api-version", valid_564210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564211: Call_ServersListSkusForExisting_564204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists eligible SKUs for an Analysis Services resource.
  ## 
  let valid = call_564211.validator(path, query, header, formData, body)
  let scheme = call_564211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564211.url(scheme.get, call_564211.host, call_564211.base,
                         call_564211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564211, url, valid)

proc call*(call_564212: Call_ServersListSkusForExisting_564204; apiVersion: string;
          serverName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## serversListSkusForExisting
  ## Lists eligible SKUs for an Analysis Services resource.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   serverName: string (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  var path_564213 = newJObject()
  var query_564214 = newJObject()
  add(query_564214, "api-version", newJString(apiVersion))
  add(path_564213, "serverName", newJString(serverName))
  add(path_564213, "subscriptionId", newJString(subscriptionId))
  add(path_564213, "resourceGroupName", newJString(resourceGroupName))
  result = call_564212.call(path_564213, query_564214, nil, nil, nil)

var serversListSkusForExisting* = Call_ServersListSkusForExisting_564204(
    name: "serversListSkusForExisting", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers/{serverName}/skus",
    validator: validate_ServersListSkusForExisting_564205, base: "",
    url: url_ServersListSkusForExisting_564206, schemes: {Scheme.Https})
type
  Call_ServersSuspend_564215 = ref object of OpenApiRestCall_563556
proc url_ServersSuspend_564217(protocol: Scheme; host: string; base: string;
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

proc validate_ServersSuspend_564216(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Suspends operation of the specified Analysis Services server instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: JString (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564218 = path.getOrDefault("serverName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "serverName", valid_564218
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
  ##              : The client API version.
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

proc call*(call_564222: Call_ServersSuspend_564215; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspends operation of the specified Analysis Services server instance.
  ## 
  let valid = call_564222.validator(path, query, header, formData, body)
  let scheme = call_564222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564222.url(scheme.get, call_564222.host, call_564222.base,
                         call_564222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564222, url, valid)

proc call*(call_564223: Call_ServersSuspend_564215; apiVersion: string;
          serverName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## serversSuspend
  ## Suspends operation of the specified Analysis Services server instance.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   serverName: string (required)
  ##             : The name of the Analysis Services server. It must be at least 3 characters in length, and no more than 63.
  ##   subscriptionId: string (required)
  ##                 : A unique identifier for a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Azure Resource group of which a given Analysis Services server is part. This name must be at least 1 character in length, and no more than 90.
  var path_564224 = newJObject()
  var query_564225 = newJObject()
  add(query_564225, "api-version", newJString(apiVersion))
  add(path_564224, "serverName", newJString(serverName))
  add(path_564224, "subscriptionId", newJString(subscriptionId))
  add(path_564224, "resourceGroupName", newJString(resourceGroupName))
  result = call_564223.call(path_564224, query_564225, nil, nil, nil)

var serversSuspend* = Call_ServersSuspend_564215(name: "serversSuspend",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AnalysisServices/servers/{serverName}/suspend",
    validator: validate_ServersSuspend_564216, base: "", url: url_ServersSuspend_564217,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
