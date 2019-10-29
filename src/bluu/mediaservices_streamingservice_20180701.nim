
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Media Services
## version: 2018-07-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Streaming resource management client for Azure Media Services
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
  macServiceName = "mediaservices-streamingservice"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LiveEventsList_563778 = ref object of OpenApiRestCall_563556
proc url_LiveEventsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/liveEvents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LiveEventsList_563779(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists the Live Events in the account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563955 = path.getOrDefault("subscriptionId")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "subscriptionId", valid_563955
  var valid_563956 = path.getOrDefault("resourceGroupName")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "resourceGroupName", valid_563956
  var valid_563957 = path.getOrDefault("accountName")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "accountName", valid_563957
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563958 = query.getOrDefault("api-version")
  valid_563958 = validateParameter(valid_563958, JString, required = true,
                                 default = nil)
  if valid_563958 != nil:
    section.add "api-version", valid_563958
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563981: Call_LiveEventsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Live Events in the account.
  ## 
  let valid = call_563981.validator(path, query, header, formData, body)
  let scheme = call_563981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563981.url(scheme.get, call_563981.host, call_563981.base,
                         call_563981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563981, url, valid)

proc call*(call_564052: Call_LiveEventsList_563778; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## liveEventsList
  ## Lists the Live Events in the account.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564053 = newJObject()
  var query_564055 = newJObject()
  add(query_564055, "api-version", newJString(apiVersion))
  add(path_564053, "subscriptionId", newJString(subscriptionId))
  add(path_564053, "resourceGroupName", newJString(resourceGroupName))
  add(path_564053, "accountName", newJString(accountName))
  result = call_564052.call(path_564053, query_564055, nil, nil, nil)

var liveEventsList* = Call_LiveEventsList_563778(name: "liveEventsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents",
    validator: validate_LiveEventsList_563779, base: "", url: url_LiveEventsList_563780,
    schemes: {Scheme.Https})
type
  Call_LiveEventsCreate_564106 = ref object of OpenApiRestCall_563556
proc url_LiveEventsCreate_564108(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "liveEventName" in path, "`liveEventName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/liveEvents/"),
               (kind: VariableSegment, value: "liveEventName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LiveEventsCreate_564107(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates a Live Event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564126 = path.getOrDefault("subscriptionId")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "subscriptionId", valid_564126
  var valid_564127 = path.getOrDefault("liveEventName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "liveEventName", valid_564127
  var valid_564128 = path.getOrDefault("resourceGroupName")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "resourceGroupName", valid_564128
  var valid_564129 = path.getOrDefault("accountName")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "accountName", valid_564129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  ##   autoStart: JBool
  ##            : The flag indicates if the resource should be automatically started on creation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564130 = query.getOrDefault("api-version")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "api-version", valid_564130
  var valid_564131 = query.getOrDefault("autoStart")
  valid_564131 = validateParameter(valid_564131, JBool, required = false, default = nil)
  if valid_564131 != nil:
    section.add "autoStart", valid_564131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Live Event properties needed for creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564133: Call_LiveEventsCreate_564106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Live Event.
  ## 
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_LiveEventsCreate_564106; apiVersion: string;
          subscriptionId: string; liveEventName: string; resourceGroupName: string;
          parameters: JsonNode; accountName: string; autoStart: bool = false): Recallable =
  ## liveEventsCreate
  ## Creates a Live Event.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   autoStart: bool
  ##            : The flag indicates if the resource should be automatically started on creation.
  ##   parameters: JObject (required)
  ##             : Live Event properties needed for creation.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  var body_564137 = newJObject()
  add(query_564136, "api-version", newJString(apiVersion))
  add(path_564135, "subscriptionId", newJString(subscriptionId))
  add(path_564135, "liveEventName", newJString(liveEventName))
  add(path_564135, "resourceGroupName", newJString(resourceGroupName))
  add(query_564136, "autoStart", newJBool(autoStart))
  if parameters != nil:
    body_564137 = parameters
  add(path_564135, "accountName", newJString(accountName))
  result = call_564134.call(path_564135, query_564136, nil, nil, body_564137)

var liveEventsCreate* = Call_LiveEventsCreate_564106(name: "liveEventsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}",
    validator: validate_LiveEventsCreate_564107, base: "",
    url: url_LiveEventsCreate_564108, schemes: {Scheme.Https})
type
  Call_LiveEventsGet_564094 = ref object of OpenApiRestCall_563556
proc url_LiveEventsGet_564096(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "liveEventName" in path, "`liveEventName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/liveEvents/"),
               (kind: VariableSegment, value: "liveEventName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LiveEventsGet_564095(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a Live Event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564097 = path.getOrDefault("subscriptionId")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "subscriptionId", valid_564097
  var valid_564098 = path.getOrDefault("liveEventName")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "liveEventName", valid_564098
  var valid_564099 = path.getOrDefault("resourceGroupName")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "resourceGroupName", valid_564099
  var valid_564100 = path.getOrDefault("accountName")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "accountName", valid_564100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
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

proc call*(call_564102: Call_LiveEventsGet_564094; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Live Event.
  ## 
  let valid = call_564102.validator(path, query, header, formData, body)
  let scheme = call_564102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564102.url(scheme.get, call_564102.host, call_564102.base,
                         call_564102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564102, url, valid)

proc call*(call_564103: Call_LiveEventsGet_564094; apiVersion: string;
          subscriptionId: string; liveEventName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## liveEventsGet
  ## Gets a Live Event.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564104 = newJObject()
  var query_564105 = newJObject()
  add(query_564105, "api-version", newJString(apiVersion))
  add(path_564104, "subscriptionId", newJString(subscriptionId))
  add(path_564104, "liveEventName", newJString(liveEventName))
  add(path_564104, "resourceGroupName", newJString(resourceGroupName))
  add(path_564104, "accountName", newJString(accountName))
  result = call_564103.call(path_564104, query_564105, nil, nil, nil)

var liveEventsGet* = Call_LiveEventsGet_564094(name: "liveEventsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}",
    validator: validate_LiveEventsGet_564095, base: "", url: url_LiveEventsGet_564096,
    schemes: {Scheme.Https})
type
  Call_LiveEventsUpdate_564150 = ref object of OpenApiRestCall_563556
proc url_LiveEventsUpdate_564152(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "liveEventName" in path, "`liveEventName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/liveEvents/"),
               (kind: VariableSegment, value: "liveEventName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LiveEventsUpdate_564151(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a existing Live Event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564153 = path.getOrDefault("subscriptionId")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "subscriptionId", valid_564153
  var valid_564154 = path.getOrDefault("liveEventName")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "liveEventName", valid_564154
  var valid_564155 = path.getOrDefault("resourceGroupName")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "resourceGroupName", valid_564155
  var valid_564156 = path.getOrDefault("accountName")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "accountName", valid_564156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564157 = query.getOrDefault("api-version")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "api-version", valid_564157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Live Event properties needed for creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564159: Call_LiveEventsUpdate_564150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a existing Live Event.
  ## 
  let valid = call_564159.validator(path, query, header, formData, body)
  let scheme = call_564159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564159.url(scheme.get, call_564159.host, call_564159.base,
                         call_564159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564159, url, valid)

proc call*(call_564160: Call_LiveEventsUpdate_564150; apiVersion: string;
          subscriptionId: string; liveEventName: string; resourceGroupName: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## liveEventsUpdate
  ## Updates a existing Live Event.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : Live Event properties needed for creation.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564161 = newJObject()
  var query_564162 = newJObject()
  var body_564163 = newJObject()
  add(query_564162, "api-version", newJString(apiVersion))
  add(path_564161, "subscriptionId", newJString(subscriptionId))
  add(path_564161, "liveEventName", newJString(liveEventName))
  add(path_564161, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564163 = parameters
  add(path_564161, "accountName", newJString(accountName))
  result = call_564160.call(path_564161, query_564162, nil, nil, body_564163)

var liveEventsUpdate* = Call_LiveEventsUpdate_564150(name: "liveEventsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}",
    validator: validate_LiveEventsUpdate_564151, base: "",
    url: url_LiveEventsUpdate_564152, schemes: {Scheme.Https})
type
  Call_LiveEventsDelete_564138 = ref object of OpenApiRestCall_563556
proc url_LiveEventsDelete_564140(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "liveEventName" in path, "`liveEventName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/liveEvents/"),
               (kind: VariableSegment, value: "liveEventName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LiveEventsDelete_564139(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a Live Event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564141 = path.getOrDefault("subscriptionId")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "subscriptionId", valid_564141
  var valid_564142 = path.getOrDefault("liveEventName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "liveEventName", valid_564142
  var valid_564143 = path.getOrDefault("resourceGroupName")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "resourceGroupName", valid_564143
  var valid_564144 = path.getOrDefault("accountName")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "accountName", valid_564144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
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
  if body != nil:
    result.add "body", body

proc call*(call_564146: Call_LiveEventsDelete_564138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Live Event.
  ## 
  let valid = call_564146.validator(path, query, header, formData, body)
  let scheme = call_564146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564146.url(scheme.get, call_564146.host, call_564146.base,
                         call_564146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564146, url, valid)

proc call*(call_564147: Call_LiveEventsDelete_564138; apiVersion: string;
          subscriptionId: string; liveEventName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## liveEventsDelete
  ## Deletes a Live Event.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564148 = newJObject()
  var query_564149 = newJObject()
  add(query_564149, "api-version", newJString(apiVersion))
  add(path_564148, "subscriptionId", newJString(subscriptionId))
  add(path_564148, "liveEventName", newJString(liveEventName))
  add(path_564148, "resourceGroupName", newJString(resourceGroupName))
  add(path_564148, "accountName", newJString(accountName))
  result = call_564147.call(path_564148, query_564149, nil, nil, nil)

var liveEventsDelete* = Call_LiveEventsDelete_564138(name: "liveEventsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}",
    validator: validate_LiveEventsDelete_564139, base: "",
    url: url_LiveEventsDelete_564140, schemes: {Scheme.Https})
type
  Call_LiveOutputsList_564164 = ref object of OpenApiRestCall_563556
proc url_LiveOutputsList_564166(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "liveEventName" in path, "`liveEventName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/liveEvents/"),
               (kind: VariableSegment, value: "liveEventName"),
               (kind: ConstantSegment, value: "/liveOutputs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LiveOutputsList_564165(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists the Live Outputs in the Live Event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564167 = path.getOrDefault("subscriptionId")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "subscriptionId", valid_564167
  var valid_564168 = path.getOrDefault("liveEventName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "liveEventName", valid_564168
  var valid_564169 = path.getOrDefault("resourceGroupName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "resourceGroupName", valid_564169
  var valid_564170 = path.getOrDefault("accountName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "accountName", valid_564170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564171 = query.getOrDefault("api-version")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "api-version", valid_564171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564172: Call_LiveOutputsList_564164; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Live Outputs in the Live Event.
  ## 
  let valid = call_564172.validator(path, query, header, formData, body)
  let scheme = call_564172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564172.url(scheme.get, call_564172.host, call_564172.base,
                         call_564172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564172, url, valid)

proc call*(call_564173: Call_LiveOutputsList_564164; apiVersion: string;
          subscriptionId: string; liveEventName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## liveOutputsList
  ## Lists the Live Outputs in the Live Event.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564174 = newJObject()
  var query_564175 = newJObject()
  add(query_564175, "api-version", newJString(apiVersion))
  add(path_564174, "subscriptionId", newJString(subscriptionId))
  add(path_564174, "liveEventName", newJString(liveEventName))
  add(path_564174, "resourceGroupName", newJString(resourceGroupName))
  add(path_564174, "accountName", newJString(accountName))
  result = call_564173.call(path_564174, query_564175, nil, nil, nil)

var liveOutputsList* = Call_LiveOutputsList_564164(name: "liveOutputsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/liveOutputs",
    validator: validate_LiveOutputsList_564165, base: "", url: url_LiveOutputsList_564166,
    schemes: {Scheme.Https})
type
  Call_LiveOutputsCreate_564189 = ref object of OpenApiRestCall_563556
proc url_LiveOutputsCreate_564191(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "liveEventName" in path, "`liveEventName` is a required path parameter"
  assert "liveOutputName" in path, "`liveOutputName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/liveEvents/"),
               (kind: VariableSegment, value: "liveEventName"),
               (kind: ConstantSegment, value: "/liveOutputs/"),
               (kind: VariableSegment, value: "liveOutputName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LiveOutputsCreate_564190(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a Live Output.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   liveOutputName: JString (required)
  ##                 : The name of the Live Output.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564192 = path.getOrDefault("subscriptionId")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "subscriptionId", valid_564192
  var valid_564193 = path.getOrDefault("liveEventName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "liveEventName", valid_564193
  var valid_564194 = path.getOrDefault("resourceGroupName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "resourceGroupName", valid_564194
  var valid_564195 = path.getOrDefault("liveOutputName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "liveOutputName", valid_564195
  var valid_564196 = path.getOrDefault("accountName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "accountName", valid_564196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564197 = query.getOrDefault("api-version")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "api-version", valid_564197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Live Output properties needed for creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564199: Call_LiveOutputsCreate_564189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Live Output.
  ## 
  let valid = call_564199.validator(path, query, header, formData, body)
  let scheme = call_564199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564199.url(scheme.get, call_564199.host, call_564199.base,
                         call_564199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564199, url, valid)

proc call*(call_564200: Call_LiveOutputsCreate_564189; apiVersion: string;
          subscriptionId: string; liveEventName: string; resourceGroupName: string;
          liveOutputName: string; parameters: JsonNode; accountName: string): Recallable =
  ## liveOutputsCreate
  ## Creates a Live Output.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   liveOutputName: string (required)
  ##                 : The name of the Live Output.
  ##   parameters: JObject (required)
  ##             : Live Output properties needed for creation.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564201 = newJObject()
  var query_564202 = newJObject()
  var body_564203 = newJObject()
  add(query_564202, "api-version", newJString(apiVersion))
  add(path_564201, "subscriptionId", newJString(subscriptionId))
  add(path_564201, "liveEventName", newJString(liveEventName))
  add(path_564201, "resourceGroupName", newJString(resourceGroupName))
  add(path_564201, "liveOutputName", newJString(liveOutputName))
  if parameters != nil:
    body_564203 = parameters
  add(path_564201, "accountName", newJString(accountName))
  result = call_564200.call(path_564201, query_564202, nil, nil, body_564203)

var liveOutputsCreate* = Call_LiveOutputsCreate_564189(name: "liveOutputsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/liveOutputs/{liveOutputName}",
    validator: validate_LiveOutputsCreate_564190, base: "",
    url: url_LiveOutputsCreate_564191, schemes: {Scheme.Https})
type
  Call_LiveOutputsGet_564176 = ref object of OpenApiRestCall_563556
proc url_LiveOutputsGet_564178(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "liveEventName" in path, "`liveEventName` is a required path parameter"
  assert "liveOutputName" in path, "`liveOutputName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/liveEvents/"),
               (kind: VariableSegment, value: "liveEventName"),
               (kind: ConstantSegment, value: "/liveOutputs/"),
               (kind: VariableSegment, value: "liveOutputName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LiveOutputsGet_564177(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a Live Output.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   liveOutputName: JString (required)
  ##                 : The name of the Live Output.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564179 = path.getOrDefault("subscriptionId")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "subscriptionId", valid_564179
  var valid_564180 = path.getOrDefault("liveEventName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "liveEventName", valid_564180
  var valid_564181 = path.getOrDefault("resourceGroupName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "resourceGroupName", valid_564181
  var valid_564182 = path.getOrDefault("liveOutputName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "liveOutputName", valid_564182
  var valid_564183 = path.getOrDefault("accountName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "accountName", valid_564183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564184 = query.getOrDefault("api-version")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "api-version", valid_564184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564185: Call_LiveOutputsGet_564176; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Live Output.
  ## 
  let valid = call_564185.validator(path, query, header, formData, body)
  let scheme = call_564185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564185.url(scheme.get, call_564185.host, call_564185.base,
                         call_564185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564185, url, valid)

proc call*(call_564186: Call_LiveOutputsGet_564176; apiVersion: string;
          subscriptionId: string; liveEventName: string; resourceGroupName: string;
          liveOutputName: string; accountName: string): Recallable =
  ## liveOutputsGet
  ## Gets a Live Output.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   liveOutputName: string (required)
  ##                 : The name of the Live Output.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564187 = newJObject()
  var query_564188 = newJObject()
  add(query_564188, "api-version", newJString(apiVersion))
  add(path_564187, "subscriptionId", newJString(subscriptionId))
  add(path_564187, "liveEventName", newJString(liveEventName))
  add(path_564187, "resourceGroupName", newJString(resourceGroupName))
  add(path_564187, "liveOutputName", newJString(liveOutputName))
  add(path_564187, "accountName", newJString(accountName))
  result = call_564186.call(path_564187, query_564188, nil, nil, nil)

var liveOutputsGet* = Call_LiveOutputsGet_564176(name: "liveOutputsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/liveOutputs/{liveOutputName}",
    validator: validate_LiveOutputsGet_564177, base: "", url: url_LiveOutputsGet_564178,
    schemes: {Scheme.Https})
type
  Call_LiveOutputsDelete_564204 = ref object of OpenApiRestCall_563556
proc url_LiveOutputsDelete_564206(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "liveEventName" in path, "`liveEventName` is a required path parameter"
  assert "liveOutputName" in path, "`liveOutputName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/liveEvents/"),
               (kind: VariableSegment, value: "liveEventName"),
               (kind: ConstantSegment, value: "/liveOutputs/"),
               (kind: VariableSegment, value: "liveOutputName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LiveOutputsDelete_564205(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a Live Output.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   liveOutputName: JString (required)
  ##                 : The name of the Live Output.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564207 = path.getOrDefault("subscriptionId")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "subscriptionId", valid_564207
  var valid_564208 = path.getOrDefault("liveEventName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "liveEventName", valid_564208
  var valid_564209 = path.getOrDefault("resourceGroupName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "resourceGroupName", valid_564209
  var valid_564210 = path.getOrDefault("liveOutputName")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "liveOutputName", valid_564210
  var valid_564211 = path.getOrDefault("accountName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "accountName", valid_564211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
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

proc call*(call_564213: Call_LiveOutputsDelete_564204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Live Output.
  ## 
  let valid = call_564213.validator(path, query, header, formData, body)
  let scheme = call_564213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564213.url(scheme.get, call_564213.host, call_564213.base,
                         call_564213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564213, url, valid)

proc call*(call_564214: Call_LiveOutputsDelete_564204; apiVersion: string;
          subscriptionId: string; liveEventName: string; resourceGroupName: string;
          liveOutputName: string; accountName: string): Recallable =
  ## liveOutputsDelete
  ## Deletes a Live Output.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   liveOutputName: string (required)
  ##                 : The name of the Live Output.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564215 = newJObject()
  var query_564216 = newJObject()
  add(query_564216, "api-version", newJString(apiVersion))
  add(path_564215, "subscriptionId", newJString(subscriptionId))
  add(path_564215, "liveEventName", newJString(liveEventName))
  add(path_564215, "resourceGroupName", newJString(resourceGroupName))
  add(path_564215, "liveOutputName", newJString(liveOutputName))
  add(path_564215, "accountName", newJString(accountName))
  result = call_564214.call(path_564215, query_564216, nil, nil, nil)

var liveOutputsDelete* = Call_LiveOutputsDelete_564204(name: "liveOutputsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/liveOutputs/{liveOutputName}",
    validator: validate_LiveOutputsDelete_564205, base: "",
    url: url_LiveOutputsDelete_564206, schemes: {Scheme.Https})
type
  Call_LiveEventsReset_564217 = ref object of OpenApiRestCall_563556
proc url_LiveEventsReset_564219(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "liveEventName" in path, "`liveEventName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/liveEvents/"),
               (kind: VariableSegment, value: "liveEventName"),
               (kind: ConstantSegment, value: "/reset")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LiveEventsReset_564218(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Resets an existing Live Event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564220 = path.getOrDefault("subscriptionId")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "subscriptionId", valid_564220
  var valid_564221 = path.getOrDefault("liveEventName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "liveEventName", valid_564221
  var valid_564222 = path.getOrDefault("resourceGroupName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "resourceGroupName", valid_564222
  var valid_564223 = path.getOrDefault("accountName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "accountName", valid_564223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
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

proc call*(call_564225: Call_LiveEventsReset_564217; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets an existing Live Event.
  ## 
  let valid = call_564225.validator(path, query, header, formData, body)
  let scheme = call_564225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564225.url(scheme.get, call_564225.host, call_564225.base,
                         call_564225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564225, url, valid)

proc call*(call_564226: Call_LiveEventsReset_564217; apiVersion: string;
          subscriptionId: string; liveEventName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## liveEventsReset
  ## Resets an existing Live Event.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564227 = newJObject()
  var query_564228 = newJObject()
  add(query_564228, "api-version", newJString(apiVersion))
  add(path_564227, "subscriptionId", newJString(subscriptionId))
  add(path_564227, "liveEventName", newJString(liveEventName))
  add(path_564227, "resourceGroupName", newJString(resourceGroupName))
  add(path_564227, "accountName", newJString(accountName))
  result = call_564226.call(path_564227, query_564228, nil, nil, nil)

var liveEventsReset* = Call_LiveEventsReset_564217(name: "liveEventsReset",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/reset",
    validator: validate_LiveEventsReset_564218, base: "", url: url_LiveEventsReset_564219,
    schemes: {Scheme.Https})
type
  Call_LiveEventsStart_564229 = ref object of OpenApiRestCall_563556
proc url_LiveEventsStart_564231(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "liveEventName" in path, "`liveEventName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/liveEvents/"),
               (kind: VariableSegment, value: "liveEventName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LiveEventsStart_564230(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Starts an existing Live Event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564232 = path.getOrDefault("subscriptionId")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "subscriptionId", valid_564232
  var valid_564233 = path.getOrDefault("liveEventName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "liveEventName", valid_564233
  var valid_564234 = path.getOrDefault("resourceGroupName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "resourceGroupName", valid_564234
  var valid_564235 = path.getOrDefault("accountName")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "accountName", valid_564235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
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
  if body != nil:
    result.add "body", body

proc call*(call_564237: Call_LiveEventsStart_564229; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an existing Live Event.
  ## 
  let valid = call_564237.validator(path, query, header, formData, body)
  let scheme = call_564237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564237.url(scheme.get, call_564237.host, call_564237.base,
                         call_564237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564237, url, valid)

proc call*(call_564238: Call_LiveEventsStart_564229; apiVersion: string;
          subscriptionId: string; liveEventName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## liveEventsStart
  ## Starts an existing Live Event.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564239 = newJObject()
  var query_564240 = newJObject()
  add(query_564240, "api-version", newJString(apiVersion))
  add(path_564239, "subscriptionId", newJString(subscriptionId))
  add(path_564239, "liveEventName", newJString(liveEventName))
  add(path_564239, "resourceGroupName", newJString(resourceGroupName))
  add(path_564239, "accountName", newJString(accountName))
  result = call_564238.call(path_564239, query_564240, nil, nil, nil)

var liveEventsStart* = Call_LiveEventsStart_564229(name: "liveEventsStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/start",
    validator: validate_LiveEventsStart_564230, base: "", url: url_LiveEventsStart_564231,
    schemes: {Scheme.Https})
type
  Call_LiveEventsStop_564241 = ref object of OpenApiRestCall_563556
proc url_LiveEventsStop_564243(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "liveEventName" in path, "`liveEventName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/liveEvents/"),
               (kind: VariableSegment, value: "liveEventName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LiveEventsStop_564242(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Stops an existing Live Event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564244 = path.getOrDefault("subscriptionId")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "subscriptionId", valid_564244
  var valid_564245 = path.getOrDefault("liveEventName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "liveEventName", valid_564245
  var valid_564246 = path.getOrDefault("resourceGroupName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "resourceGroupName", valid_564246
  var valid_564247 = path.getOrDefault("accountName")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "accountName", valid_564247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564248 = query.getOrDefault("api-version")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "api-version", valid_564248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : LiveEvent stop parameters
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564250: Call_LiveEventsStop_564241; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops an existing Live Event.
  ## 
  let valid = call_564250.validator(path, query, header, formData, body)
  let scheme = call_564250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564250.url(scheme.get, call_564250.host, call_564250.base,
                         call_564250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564250, url, valid)

proc call*(call_564251: Call_LiveEventsStop_564241; apiVersion: string;
          subscriptionId: string; liveEventName: string; resourceGroupName: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## liveEventsStop
  ## Stops an existing Live Event.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   parameters: JObject (required)
  ##             : LiveEvent stop parameters
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564252 = newJObject()
  var query_564253 = newJObject()
  var body_564254 = newJObject()
  add(query_564253, "api-version", newJString(apiVersion))
  add(path_564252, "subscriptionId", newJString(subscriptionId))
  add(path_564252, "liveEventName", newJString(liveEventName))
  add(path_564252, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564254 = parameters
  add(path_564252, "accountName", newJString(accountName))
  result = call_564251.call(path_564252, query_564253, nil, nil, body_564254)

var liveEventsStop* = Call_LiveEventsStop_564241(name: "liveEventsStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/stop",
    validator: validate_LiveEventsStop_564242, base: "", url: url_LiveEventsStop_564243,
    schemes: {Scheme.Https})
type
  Call_StreamingEndpointsList_564255 = ref object of OpenApiRestCall_563556
proc url_StreamingEndpointsList_564257(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/streamingEndpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreamingEndpointsList_564256(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the StreamingEndpoints in the account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564258 = path.getOrDefault("subscriptionId")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "subscriptionId", valid_564258
  var valid_564259 = path.getOrDefault("resourceGroupName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "resourceGroupName", valid_564259
  var valid_564260 = path.getOrDefault("accountName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "accountName", valid_564260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564261 = query.getOrDefault("api-version")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "api-version", valid_564261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564262: Call_StreamingEndpointsList_564255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the StreamingEndpoints in the account.
  ## 
  let valid = call_564262.validator(path, query, header, formData, body)
  let scheme = call_564262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564262.url(scheme.get, call_564262.host, call_564262.base,
                         call_564262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564262, url, valid)

proc call*(call_564263: Call_StreamingEndpointsList_564255; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## streamingEndpointsList
  ## Lists the StreamingEndpoints in the account.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564264 = newJObject()
  var query_564265 = newJObject()
  add(query_564265, "api-version", newJString(apiVersion))
  add(path_564264, "subscriptionId", newJString(subscriptionId))
  add(path_564264, "resourceGroupName", newJString(resourceGroupName))
  add(path_564264, "accountName", newJString(accountName))
  result = call_564263.call(path_564264, query_564265, nil, nil, nil)

var streamingEndpointsList* = Call_StreamingEndpointsList_564255(
    name: "streamingEndpointsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints",
    validator: validate_StreamingEndpointsList_564256, base: "",
    url: url_StreamingEndpointsList_564257, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsCreate_564278 = ref object of OpenApiRestCall_563556
proc url_StreamingEndpointsCreate_564280(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "streamingEndpointName" in path,
        "`streamingEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/streamingEndpoints/"),
               (kind: VariableSegment, value: "streamingEndpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreamingEndpointsCreate_564279(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a StreamingEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: JString (required)
  ##                        : The name of the StreamingEndpoint.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564281 = path.getOrDefault("subscriptionId")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "subscriptionId", valid_564281
  var valid_564282 = path.getOrDefault("resourceGroupName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "resourceGroupName", valid_564282
  var valid_564283 = path.getOrDefault("streamingEndpointName")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "streamingEndpointName", valid_564283
  var valid_564284 = path.getOrDefault("accountName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "accountName", valid_564284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  ##   autoStart: JBool
  ##            : The flag indicates if the resource should be automatically started on creation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564285 = query.getOrDefault("api-version")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "api-version", valid_564285
  var valid_564286 = query.getOrDefault("autoStart")
  valid_564286 = validateParameter(valid_564286, JBool, required = false, default = nil)
  if valid_564286 != nil:
    section.add "autoStart", valid_564286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : StreamingEndpoint properties needed for creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564288: Call_StreamingEndpointsCreate_564278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a StreamingEndpoint.
  ## 
  let valid = call_564288.validator(path, query, header, formData, body)
  let scheme = call_564288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564288.url(scheme.get, call_564288.host, call_564288.base,
                         call_564288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564288, url, valid)

proc call*(call_564289: Call_StreamingEndpointsCreate_564278; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          streamingEndpointName: string; parameters: JsonNode; accountName: string;
          autoStart: bool = false): Recallable =
  ## streamingEndpointsCreate
  ## Creates a StreamingEndpoint.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: string (required)
  ##                        : The name of the StreamingEndpoint.
  ##   autoStart: bool
  ##            : The flag indicates if the resource should be automatically started on creation.
  ##   parameters: JObject (required)
  ##             : StreamingEndpoint properties needed for creation.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564290 = newJObject()
  var query_564291 = newJObject()
  var body_564292 = newJObject()
  add(query_564291, "api-version", newJString(apiVersion))
  add(path_564290, "subscriptionId", newJString(subscriptionId))
  add(path_564290, "resourceGroupName", newJString(resourceGroupName))
  add(path_564290, "streamingEndpointName", newJString(streamingEndpointName))
  add(query_564291, "autoStart", newJBool(autoStart))
  if parameters != nil:
    body_564292 = parameters
  add(path_564290, "accountName", newJString(accountName))
  result = call_564289.call(path_564290, query_564291, nil, nil, body_564292)

var streamingEndpointsCreate* = Call_StreamingEndpointsCreate_564278(
    name: "streamingEndpointsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}",
    validator: validate_StreamingEndpointsCreate_564279, base: "",
    url: url_StreamingEndpointsCreate_564280, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsGet_564266 = ref object of OpenApiRestCall_563556
proc url_StreamingEndpointsGet_564268(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "streamingEndpointName" in path,
        "`streamingEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/streamingEndpoints/"),
               (kind: VariableSegment, value: "streamingEndpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreamingEndpointsGet_564267(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a StreamingEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: JString (required)
  ##                        : The name of the StreamingEndpoint.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564269 = path.getOrDefault("subscriptionId")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "subscriptionId", valid_564269
  var valid_564270 = path.getOrDefault("resourceGroupName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "resourceGroupName", valid_564270
  var valid_564271 = path.getOrDefault("streamingEndpointName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "streamingEndpointName", valid_564271
  var valid_564272 = path.getOrDefault("accountName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "accountName", valid_564272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564273 = query.getOrDefault("api-version")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "api-version", valid_564273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564274: Call_StreamingEndpointsGet_564266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a StreamingEndpoint.
  ## 
  let valid = call_564274.validator(path, query, header, formData, body)
  let scheme = call_564274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564274.url(scheme.get, call_564274.host, call_564274.base,
                         call_564274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564274, url, valid)

proc call*(call_564275: Call_StreamingEndpointsGet_564266; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          streamingEndpointName: string; accountName: string): Recallable =
  ## streamingEndpointsGet
  ## Gets a StreamingEndpoint.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: string (required)
  ##                        : The name of the StreamingEndpoint.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564276 = newJObject()
  var query_564277 = newJObject()
  add(query_564277, "api-version", newJString(apiVersion))
  add(path_564276, "subscriptionId", newJString(subscriptionId))
  add(path_564276, "resourceGroupName", newJString(resourceGroupName))
  add(path_564276, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_564276, "accountName", newJString(accountName))
  result = call_564275.call(path_564276, query_564277, nil, nil, nil)

var streamingEndpointsGet* = Call_StreamingEndpointsGet_564266(
    name: "streamingEndpointsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}",
    validator: validate_StreamingEndpointsGet_564267, base: "",
    url: url_StreamingEndpointsGet_564268, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsUpdate_564305 = ref object of OpenApiRestCall_563556
proc url_StreamingEndpointsUpdate_564307(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "streamingEndpointName" in path,
        "`streamingEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/streamingEndpoints/"),
               (kind: VariableSegment, value: "streamingEndpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreamingEndpointsUpdate_564306(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a existing StreamingEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: JString (required)
  ##                        : The name of the StreamingEndpoint.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564308 = path.getOrDefault("subscriptionId")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "subscriptionId", valid_564308
  var valid_564309 = path.getOrDefault("resourceGroupName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "resourceGroupName", valid_564309
  var valid_564310 = path.getOrDefault("streamingEndpointName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "streamingEndpointName", valid_564310
  var valid_564311 = path.getOrDefault("accountName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "accountName", valid_564311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564312 = query.getOrDefault("api-version")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "api-version", valid_564312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : StreamingEndpoint properties needed for creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564314: Call_StreamingEndpointsUpdate_564305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a existing StreamingEndpoint.
  ## 
  let valid = call_564314.validator(path, query, header, formData, body)
  let scheme = call_564314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564314.url(scheme.get, call_564314.host, call_564314.base,
                         call_564314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564314, url, valid)

proc call*(call_564315: Call_StreamingEndpointsUpdate_564305; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          streamingEndpointName: string; parameters: JsonNode; accountName: string): Recallable =
  ## streamingEndpointsUpdate
  ## Updates a existing StreamingEndpoint.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: string (required)
  ##                        : The name of the StreamingEndpoint.
  ##   parameters: JObject (required)
  ##             : StreamingEndpoint properties needed for creation.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564316 = newJObject()
  var query_564317 = newJObject()
  var body_564318 = newJObject()
  add(query_564317, "api-version", newJString(apiVersion))
  add(path_564316, "subscriptionId", newJString(subscriptionId))
  add(path_564316, "resourceGroupName", newJString(resourceGroupName))
  add(path_564316, "streamingEndpointName", newJString(streamingEndpointName))
  if parameters != nil:
    body_564318 = parameters
  add(path_564316, "accountName", newJString(accountName))
  result = call_564315.call(path_564316, query_564317, nil, nil, body_564318)

var streamingEndpointsUpdate* = Call_StreamingEndpointsUpdate_564305(
    name: "streamingEndpointsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}",
    validator: validate_StreamingEndpointsUpdate_564306, base: "",
    url: url_StreamingEndpointsUpdate_564307, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsDelete_564293 = ref object of OpenApiRestCall_563556
proc url_StreamingEndpointsDelete_564295(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "streamingEndpointName" in path,
        "`streamingEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/streamingEndpoints/"),
               (kind: VariableSegment, value: "streamingEndpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreamingEndpointsDelete_564294(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a StreamingEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: JString (required)
  ##                        : The name of the StreamingEndpoint.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
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
  var valid_564298 = path.getOrDefault("streamingEndpointName")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "streamingEndpointName", valid_564298
  var valid_564299 = path.getOrDefault("accountName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "accountName", valid_564299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564300 = query.getOrDefault("api-version")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "api-version", valid_564300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564301: Call_StreamingEndpointsDelete_564293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a StreamingEndpoint.
  ## 
  let valid = call_564301.validator(path, query, header, formData, body)
  let scheme = call_564301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564301.url(scheme.get, call_564301.host, call_564301.base,
                         call_564301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564301, url, valid)

proc call*(call_564302: Call_StreamingEndpointsDelete_564293; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          streamingEndpointName: string; accountName: string): Recallable =
  ## streamingEndpointsDelete
  ## Deletes a StreamingEndpoint.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: string (required)
  ##                        : The name of the StreamingEndpoint.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564303 = newJObject()
  var query_564304 = newJObject()
  add(query_564304, "api-version", newJString(apiVersion))
  add(path_564303, "subscriptionId", newJString(subscriptionId))
  add(path_564303, "resourceGroupName", newJString(resourceGroupName))
  add(path_564303, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_564303, "accountName", newJString(accountName))
  result = call_564302.call(path_564303, query_564304, nil, nil, nil)

var streamingEndpointsDelete* = Call_StreamingEndpointsDelete_564293(
    name: "streamingEndpointsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}",
    validator: validate_StreamingEndpointsDelete_564294, base: "",
    url: url_StreamingEndpointsDelete_564295, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsScale_564319 = ref object of OpenApiRestCall_563556
proc url_StreamingEndpointsScale_564321(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "streamingEndpointName" in path,
        "`streamingEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/streamingEndpoints/"),
               (kind: VariableSegment, value: "streamingEndpointName"),
               (kind: ConstantSegment, value: "/scale")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreamingEndpointsScale_564320(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Scales an existing StreamingEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: JString (required)
  ##                        : The name of the StreamingEndpoint.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
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
  var valid_564324 = path.getOrDefault("streamingEndpointName")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "streamingEndpointName", valid_564324
  var valid_564325 = path.getOrDefault("accountName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "accountName", valid_564325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564326 = query.getOrDefault("api-version")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "api-version", valid_564326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : StreamingEndpoint scale parameters
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564328: Call_StreamingEndpointsScale_564319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scales an existing StreamingEndpoint.
  ## 
  let valid = call_564328.validator(path, query, header, formData, body)
  let scheme = call_564328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564328.url(scheme.get, call_564328.host, call_564328.base,
                         call_564328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564328, url, valid)

proc call*(call_564329: Call_StreamingEndpointsScale_564319; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          streamingEndpointName: string; parameters: JsonNode; accountName: string): Recallable =
  ## streamingEndpointsScale
  ## Scales an existing StreamingEndpoint.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: string (required)
  ##                        : The name of the StreamingEndpoint.
  ##   parameters: JObject (required)
  ##             : StreamingEndpoint scale parameters
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564330 = newJObject()
  var query_564331 = newJObject()
  var body_564332 = newJObject()
  add(query_564331, "api-version", newJString(apiVersion))
  add(path_564330, "subscriptionId", newJString(subscriptionId))
  add(path_564330, "resourceGroupName", newJString(resourceGroupName))
  add(path_564330, "streamingEndpointName", newJString(streamingEndpointName))
  if parameters != nil:
    body_564332 = parameters
  add(path_564330, "accountName", newJString(accountName))
  result = call_564329.call(path_564330, query_564331, nil, nil, body_564332)

var streamingEndpointsScale* = Call_StreamingEndpointsScale_564319(
    name: "streamingEndpointsScale", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}/scale",
    validator: validate_StreamingEndpointsScale_564320, base: "",
    url: url_StreamingEndpointsScale_564321, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsStart_564333 = ref object of OpenApiRestCall_563556
proc url_StreamingEndpointsStart_564335(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "streamingEndpointName" in path,
        "`streamingEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/streamingEndpoints/"),
               (kind: VariableSegment, value: "streamingEndpointName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreamingEndpointsStart_564334(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts an existing StreamingEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: JString (required)
  ##                        : The name of the StreamingEndpoint.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564336 = path.getOrDefault("subscriptionId")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "subscriptionId", valid_564336
  var valid_564337 = path.getOrDefault("resourceGroupName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "resourceGroupName", valid_564337
  var valid_564338 = path.getOrDefault("streamingEndpointName")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "streamingEndpointName", valid_564338
  var valid_564339 = path.getOrDefault("accountName")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "accountName", valid_564339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564340 = query.getOrDefault("api-version")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "api-version", valid_564340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564341: Call_StreamingEndpointsStart_564333; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an existing StreamingEndpoint.
  ## 
  let valid = call_564341.validator(path, query, header, formData, body)
  let scheme = call_564341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564341.url(scheme.get, call_564341.host, call_564341.base,
                         call_564341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564341, url, valid)

proc call*(call_564342: Call_StreamingEndpointsStart_564333; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          streamingEndpointName: string; accountName: string): Recallable =
  ## streamingEndpointsStart
  ## Starts an existing StreamingEndpoint.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: string (required)
  ##                        : The name of the StreamingEndpoint.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564343 = newJObject()
  var query_564344 = newJObject()
  add(query_564344, "api-version", newJString(apiVersion))
  add(path_564343, "subscriptionId", newJString(subscriptionId))
  add(path_564343, "resourceGroupName", newJString(resourceGroupName))
  add(path_564343, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_564343, "accountName", newJString(accountName))
  result = call_564342.call(path_564343, query_564344, nil, nil, nil)

var streamingEndpointsStart* = Call_StreamingEndpointsStart_564333(
    name: "streamingEndpointsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}/start",
    validator: validate_StreamingEndpointsStart_564334, base: "",
    url: url_StreamingEndpointsStart_564335, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsStop_564345 = ref object of OpenApiRestCall_563556
proc url_StreamingEndpointsStop_564347(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "streamingEndpointName" in path,
        "`streamingEndpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Media/mediaservices/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/streamingEndpoints/"),
               (kind: VariableSegment, value: "streamingEndpointName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreamingEndpointsStop_564346(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops an existing StreamingEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: JString (required)
  ##                        : The name of the StreamingEndpoint.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564348 = path.getOrDefault("subscriptionId")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "subscriptionId", valid_564348
  var valid_564349 = path.getOrDefault("resourceGroupName")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "resourceGroupName", valid_564349
  var valid_564350 = path.getOrDefault("streamingEndpointName")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "streamingEndpointName", valid_564350
  var valid_564351 = path.getOrDefault("accountName")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "accountName", valid_564351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564352 = query.getOrDefault("api-version")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "api-version", valid_564352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564353: Call_StreamingEndpointsStop_564345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops an existing StreamingEndpoint.
  ## 
  let valid = call_564353.validator(path, query, header, formData, body)
  let scheme = call_564353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564353.url(scheme.get, call_564353.host, call_564353.base,
                         call_564353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564353, url, valid)

proc call*(call_564354: Call_StreamingEndpointsStop_564345; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          streamingEndpointName: string; accountName: string): Recallable =
  ## streamingEndpointsStop
  ## Stops an existing StreamingEndpoint.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: string (required)
  ##                        : The name of the StreamingEndpoint.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_564355 = newJObject()
  var query_564356 = newJObject()
  add(query_564356, "api-version", newJString(apiVersion))
  add(path_564355, "subscriptionId", newJString(subscriptionId))
  add(path_564355, "resourceGroupName", newJString(resourceGroupName))
  add(path_564355, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_564355, "accountName", newJString(accountName))
  result = call_564354.call(path_564355, query_564356, nil, nil, nil)

var streamingEndpointsStop* = Call_StreamingEndpointsStop_564345(
    name: "streamingEndpointsStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}/stop",
    validator: validate_StreamingEndpointsStop_564346, base: "",
    url: url_StreamingEndpointsStop_564347, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
