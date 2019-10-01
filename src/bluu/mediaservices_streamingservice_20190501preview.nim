
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Media Services
## version: 2019-05-01-preview
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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "mediaservices-streamingservice"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LiveEventsList_567880 = ref object of OpenApiRestCall_567658
proc url_LiveEventsList_567882(protocol: Scheme; host: string; base: string;
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

proc validate_LiveEventsList_567881(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists the Live Events in the account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568055 = path.getOrDefault("resourceGroupName")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "resourceGroupName", valid_568055
  var valid_568056 = path.getOrDefault("subscriptionId")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "subscriptionId", valid_568056
  var valid_568057 = path.getOrDefault("accountName")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "accountName", valid_568057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568058 = query.getOrDefault("api-version")
  valid_568058 = validateParameter(valid_568058, JString, required = true,
                                 default = nil)
  if valid_568058 != nil:
    section.add "api-version", valid_568058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568081: Call_LiveEventsList_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Live Events in the account.
  ## 
  let valid = call_568081.validator(path, query, header, formData, body)
  let scheme = call_568081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568081.url(scheme.get, call_568081.host, call_568081.base,
                         call_568081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568081, url, valid)

proc call*(call_568152: Call_LiveEventsList_567880; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## liveEventsList
  ## Lists the Live Events in the account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568153 = newJObject()
  var query_568155 = newJObject()
  add(path_568153, "resourceGroupName", newJString(resourceGroupName))
  add(query_568155, "api-version", newJString(apiVersion))
  add(path_568153, "subscriptionId", newJString(subscriptionId))
  add(path_568153, "accountName", newJString(accountName))
  result = call_568152.call(path_568153, query_568155, nil, nil, nil)

var liveEventsList* = Call_LiveEventsList_567880(name: "liveEventsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents",
    validator: validate_LiveEventsList_567881, base: "", url: url_LiveEventsList_567882,
    schemes: {Scheme.Https})
type
  Call_LiveEventsCreate_568206 = ref object of OpenApiRestCall_567658
proc url_LiveEventsCreate_568208(protocol: Scheme; host: string; base: string;
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

proc validate_LiveEventsCreate_568207(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates a Live Event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568226 = path.getOrDefault("resourceGroupName")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "resourceGroupName", valid_568226
  var valid_568227 = path.getOrDefault("subscriptionId")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "subscriptionId", valid_568227
  var valid_568228 = path.getOrDefault("liveEventName")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "liveEventName", valid_568228
  var valid_568229 = path.getOrDefault("accountName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "accountName", valid_568229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  ##   autoStart: JBool
  ##            : The flag indicates if the resource should be automatically started on creation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568230 = query.getOrDefault("api-version")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "api-version", valid_568230
  var valid_568231 = query.getOrDefault("autoStart")
  valid_568231 = validateParameter(valid_568231, JBool, required = false, default = nil)
  if valid_568231 != nil:
    section.add "autoStart", valid_568231
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

proc call*(call_568233: Call_LiveEventsCreate_568206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Live Event.
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_LiveEventsCreate_568206; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; liveEventName: string;
          parameters: JsonNode; accountName: string; autoStart: bool = false): Recallable =
  ## liveEventsCreate
  ## Creates a Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   autoStart: bool
  ##            : The flag indicates if the resource should be automatically started on creation.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   parameters: JObject (required)
  ##             : Live Event properties needed for creation.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  var body_568237 = newJObject()
  add(path_568235, "resourceGroupName", newJString(resourceGroupName))
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  add(query_568236, "autoStart", newJBool(autoStart))
  add(path_568235, "liveEventName", newJString(liveEventName))
  if parameters != nil:
    body_568237 = parameters
  add(path_568235, "accountName", newJString(accountName))
  result = call_568234.call(path_568235, query_568236, nil, nil, body_568237)

var liveEventsCreate* = Call_LiveEventsCreate_568206(name: "liveEventsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}",
    validator: validate_LiveEventsCreate_568207, base: "",
    url: url_LiveEventsCreate_568208, schemes: {Scheme.Https})
type
  Call_LiveEventsGet_568194 = ref object of OpenApiRestCall_567658
proc url_LiveEventsGet_568196(protocol: Scheme; host: string; base: string;
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

proc validate_LiveEventsGet_568195(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a Live Event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568197 = path.getOrDefault("resourceGroupName")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "resourceGroupName", valid_568197
  var valid_568198 = path.getOrDefault("subscriptionId")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "subscriptionId", valid_568198
  var valid_568199 = path.getOrDefault("liveEventName")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "liveEventName", valid_568199
  var valid_568200 = path.getOrDefault("accountName")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "accountName", valid_568200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568201 = query.getOrDefault("api-version")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "api-version", valid_568201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568202: Call_LiveEventsGet_568194; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Live Event.
  ## 
  let valid = call_568202.validator(path, query, header, formData, body)
  let scheme = call_568202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568202.url(scheme.get, call_568202.host, call_568202.base,
                         call_568202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568202, url, valid)

proc call*(call_568203: Call_LiveEventsGet_568194; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; liveEventName: string;
          accountName: string): Recallable =
  ## liveEventsGet
  ## Gets a Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568204 = newJObject()
  var query_568205 = newJObject()
  add(path_568204, "resourceGroupName", newJString(resourceGroupName))
  add(query_568205, "api-version", newJString(apiVersion))
  add(path_568204, "subscriptionId", newJString(subscriptionId))
  add(path_568204, "liveEventName", newJString(liveEventName))
  add(path_568204, "accountName", newJString(accountName))
  result = call_568203.call(path_568204, query_568205, nil, nil, nil)

var liveEventsGet* = Call_LiveEventsGet_568194(name: "liveEventsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}",
    validator: validate_LiveEventsGet_568195, base: "", url: url_LiveEventsGet_568196,
    schemes: {Scheme.Https})
type
  Call_LiveEventsUpdate_568250 = ref object of OpenApiRestCall_567658
proc url_LiveEventsUpdate_568252(protocol: Scheme; host: string; base: string;
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

proc validate_LiveEventsUpdate_568251(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a existing Live Event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568253 = path.getOrDefault("resourceGroupName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "resourceGroupName", valid_568253
  var valid_568254 = path.getOrDefault("subscriptionId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "subscriptionId", valid_568254
  var valid_568255 = path.getOrDefault("liveEventName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "liveEventName", valid_568255
  var valid_568256 = path.getOrDefault("accountName")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "accountName", valid_568256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568257 = query.getOrDefault("api-version")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "api-version", valid_568257
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

proc call*(call_568259: Call_LiveEventsUpdate_568250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a existing Live Event.
  ## 
  let valid = call_568259.validator(path, query, header, formData, body)
  let scheme = call_568259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568259.url(scheme.get, call_568259.host, call_568259.base,
                         call_568259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568259, url, valid)

proc call*(call_568260: Call_LiveEventsUpdate_568250; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; liveEventName: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## liveEventsUpdate
  ## Updates a existing Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   parameters: JObject (required)
  ##             : Live Event properties needed for creation.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568261 = newJObject()
  var query_568262 = newJObject()
  var body_568263 = newJObject()
  add(path_568261, "resourceGroupName", newJString(resourceGroupName))
  add(query_568262, "api-version", newJString(apiVersion))
  add(path_568261, "subscriptionId", newJString(subscriptionId))
  add(path_568261, "liveEventName", newJString(liveEventName))
  if parameters != nil:
    body_568263 = parameters
  add(path_568261, "accountName", newJString(accountName))
  result = call_568260.call(path_568261, query_568262, nil, nil, body_568263)

var liveEventsUpdate* = Call_LiveEventsUpdate_568250(name: "liveEventsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}",
    validator: validate_LiveEventsUpdate_568251, base: "",
    url: url_LiveEventsUpdate_568252, schemes: {Scheme.Https})
type
  Call_LiveEventsDelete_568238 = ref object of OpenApiRestCall_567658
proc url_LiveEventsDelete_568240(protocol: Scheme; host: string; base: string;
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

proc validate_LiveEventsDelete_568239(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a Live Event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568241 = path.getOrDefault("resourceGroupName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "resourceGroupName", valid_568241
  var valid_568242 = path.getOrDefault("subscriptionId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "subscriptionId", valid_568242
  var valid_568243 = path.getOrDefault("liveEventName")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "liveEventName", valid_568243
  var valid_568244 = path.getOrDefault("accountName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "accountName", valid_568244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568245 = query.getOrDefault("api-version")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "api-version", valid_568245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568246: Call_LiveEventsDelete_568238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Live Event.
  ## 
  let valid = call_568246.validator(path, query, header, formData, body)
  let scheme = call_568246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568246.url(scheme.get, call_568246.host, call_568246.base,
                         call_568246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568246, url, valid)

proc call*(call_568247: Call_LiveEventsDelete_568238; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; liveEventName: string;
          accountName: string): Recallable =
  ## liveEventsDelete
  ## Deletes a Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568248 = newJObject()
  var query_568249 = newJObject()
  add(path_568248, "resourceGroupName", newJString(resourceGroupName))
  add(query_568249, "api-version", newJString(apiVersion))
  add(path_568248, "subscriptionId", newJString(subscriptionId))
  add(path_568248, "liveEventName", newJString(liveEventName))
  add(path_568248, "accountName", newJString(accountName))
  result = call_568247.call(path_568248, query_568249, nil, nil, nil)

var liveEventsDelete* = Call_LiveEventsDelete_568238(name: "liveEventsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}",
    validator: validate_LiveEventsDelete_568239, base: "",
    url: url_LiveEventsDelete_568240, schemes: {Scheme.Https})
type
  Call_LiveOutputsList_568264 = ref object of OpenApiRestCall_567658
proc url_LiveOutputsList_568266(protocol: Scheme; host: string; base: string;
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

proc validate_LiveOutputsList_568265(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists the Live Outputs in the Live Event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568267 = path.getOrDefault("resourceGroupName")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "resourceGroupName", valid_568267
  var valid_568268 = path.getOrDefault("subscriptionId")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "subscriptionId", valid_568268
  var valid_568269 = path.getOrDefault("liveEventName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "liveEventName", valid_568269
  var valid_568270 = path.getOrDefault("accountName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "accountName", valid_568270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568271 = query.getOrDefault("api-version")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "api-version", valid_568271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568272: Call_LiveOutputsList_568264; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Live Outputs in the Live Event.
  ## 
  let valid = call_568272.validator(path, query, header, formData, body)
  let scheme = call_568272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568272.url(scheme.get, call_568272.host, call_568272.base,
                         call_568272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568272, url, valid)

proc call*(call_568273: Call_LiveOutputsList_568264; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; liveEventName: string;
          accountName: string): Recallable =
  ## liveOutputsList
  ## Lists the Live Outputs in the Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568274 = newJObject()
  var query_568275 = newJObject()
  add(path_568274, "resourceGroupName", newJString(resourceGroupName))
  add(query_568275, "api-version", newJString(apiVersion))
  add(path_568274, "subscriptionId", newJString(subscriptionId))
  add(path_568274, "liveEventName", newJString(liveEventName))
  add(path_568274, "accountName", newJString(accountName))
  result = call_568273.call(path_568274, query_568275, nil, nil, nil)

var liveOutputsList* = Call_LiveOutputsList_568264(name: "liveOutputsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/liveOutputs",
    validator: validate_LiveOutputsList_568265, base: "", url: url_LiveOutputsList_568266,
    schemes: {Scheme.Https})
type
  Call_LiveOutputsCreate_568289 = ref object of OpenApiRestCall_567658
proc url_LiveOutputsCreate_568291(protocol: Scheme; host: string; base: string;
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

proc validate_LiveOutputsCreate_568290(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a Live Output.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   liveOutputName: JString (required)
  ##                 : The name of the Live Output.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568292 = path.getOrDefault("resourceGroupName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "resourceGroupName", valid_568292
  var valid_568293 = path.getOrDefault("subscriptionId")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "subscriptionId", valid_568293
  var valid_568294 = path.getOrDefault("liveEventName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "liveEventName", valid_568294
  var valid_568295 = path.getOrDefault("liveOutputName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "liveOutputName", valid_568295
  var valid_568296 = path.getOrDefault("accountName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "accountName", valid_568296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568297 = query.getOrDefault("api-version")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "api-version", valid_568297
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

proc call*(call_568299: Call_LiveOutputsCreate_568289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Live Output.
  ## 
  let valid = call_568299.validator(path, query, header, formData, body)
  let scheme = call_568299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568299.url(scheme.get, call_568299.host, call_568299.base,
                         call_568299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568299, url, valid)

proc call*(call_568300: Call_LiveOutputsCreate_568289; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; liveEventName: string;
          liveOutputName: string; parameters: JsonNode; accountName: string): Recallable =
  ## liveOutputsCreate
  ## Creates a Live Output.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   liveOutputName: string (required)
  ##                 : The name of the Live Output.
  ##   parameters: JObject (required)
  ##             : Live Output properties needed for creation.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568301 = newJObject()
  var query_568302 = newJObject()
  var body_568303 = newJObject()
  add(path_568301, "resourceGroupName", newJString(resourceGroupName))
  add(query_568302, "api-version", newJString(apiVersion))
  add(path_568301, "subscriptionId", newJString(subscriptionId))
  add(path_568301, "liveEventName", newJString(liveEventName))
  add(path_568301, "liveOutputName", newJString(liveOutputName))
  if parameters != nil:
    body_568303 = parameters
  add(path_568301, "accountName", newJString(accountName))
  result = call_568300.call(path_568301, query_568302, nil, nil, body_568303)

var liveOutputsCreate* = Call_LiveOutputsCreate_568289(name: "liveOutputsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/liveOutputs/{liveOutputName}",
    validator: validate_LiveOutputsCreate_568290, base: "",
    url: url_LiveOutputsCreate_568291, schemes: {Scheme.Https})
type
  Call_LiveOutputsGet_568276 = ref object of OpenApiRestCall_567658
proc url_LiveOutputsGet_568278(protocol: Scheme; host: string; base: string;
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

proc validate_LiveOutputsGet_568277(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a Live Output.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   liveOutputName: JString (required)
  ##                 : The name of the Live Output.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568279 = path.getOrDefault("resourceGroupName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "resourceGroupName", valid_568279
  var valid_568280 = path.getOrDefault("subscriptionId")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "subscriptionId", valid_568280
  var valid_568281 = path.getOrDefault("liveEventName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "liveEventName", valid_568281
  var valid_568282 = path.getOrDefault("liveOutputName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "liveOutputName", valid_568282
  var valid_568283 = path.getOrDefault("accountName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "accountName", valid_568283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568284 = query.getOrDefault("api-version")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "api-version", valid_568284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568285: Call_LiveOutputsGet_568276; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Live Output.
  ## 
  let valid = call_568285.validator(path, query, header, formData, body)
  let scheme = call_568285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568285.url(scheme.get, call_568285.host, call_568285.base,
                         call_568285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568285, url, valid)

proc call*(call_568286: Call_LiveOutputsGet_568276; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; liveEventName: string;
          liveOutputName: string; accountName: string): Recallable =
  ## liveOutputsGet
  ## Gets a Live Output.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   liveOutputName: string (required)
  ##                 : The name of the Live Output.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568287 = newJObject()
  var query_568288 = newJObject()
  add(path_568287, "resourceGroupName", newJString(resourceGroupName))
  add(query_568288, "api-version", newJString(apiVersion))
  add(path_568287, "subscriptionId", newJString(subscriptionId))
  add(path_568287, "liveEventName", newJString(liveEventName))
  add(path_568287, "liveOutputName", newJString(liveOutputName))
  add(path_568287, "accountName", newJString(accountName))
  result = call_568286.call(path_568287, query_568288, nil, nil, nil)

var liveOutputsGet* = Call_LiveOutputsGet_568276(name: "liveOutputsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/liveOutputs/{liveOutputName}",
    validator: validate_LiveOutputsGet_568277, base: "", url: url_LiveOutputsGet_568278,
    schemes: {Scheme.Https})
type
  Call_LiveOutputsDelete_568304 = ref object of OpenApiRestCall_567658
proc url_LiveOutputsDelete_568306(protocol: Scheme; host: string; base: string;
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

proc validate_LiveOutputsDelete_568305(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a Live Output.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   liveOutputName: JString (required)
  ##                 : The name of the Live Output.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568307 = path.getOrDefault("resourceGroupName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "resourceGroupName", valid_568307
  var valid_568308 = path.getOrDefault("subscriptionId")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "subscriptionId", valid_568308
  var valid_568309 = path.getOrDefault("liveEventName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "liveEventName", valid_568309
  var valid_568310 = path.getOrDefault("liveOutputName")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "liveOutputName", valid_568310
  var valid_568311 = path.getOrDefault("accountName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "accountName", valid_568311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568312 = query.getOrDefault("api-version")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "api-version", valid_568312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568313: Call_LiveOutputsDelete_568304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Live Output.
  ## 
  let valid = call_568313.validator(path, query, header, formData, body)
  let scheme = call_568313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568313.url(scheme.get, call_568313.host, call_568313.base,
                         call_568313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568313, url, valid)

proc call*(call_568314: Call_LiveOutputsDelete_568304; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; liveEventName: string;
          liveOutputName: string; accountName: string): Recallable =
  ## liveOutputsDelete
  ## Deletes a Live Output.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   liveOutputName: string (required)
  ##                 : The name of the Live Output.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568315 = newJObject()
  var query_568316 = newJObject()
  add(path_568315, "resourceGroupName", newJString(resourceGroupName))
  add(query_568316, "api-version", newJString(apiVersion))
  add(path_568315, "subscriptionId", newJString(subscriptionId))
  add(path_568315, "liveEventName", newJString(liveEventName))
  add(path_568315, "liveOutputName", newJString(liveOutputName))
  add(path_568315, "accountName", newJString(accountName))
  result = call_568314.call(path_568315, query_568316, nil, nil, nil)

var liveOutputsDelete* = Call_LiveOutputsDelete_568304(name: "liveOutputsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/liveOutputs/{liveOutputName}",
    validator: validate_LiveOutputsDelete_568305, base: "",
    url: url_LiveOutputsDelete_568306, schemes: {Scheme.Https})
type
  Call_LiveEventsReset_568317 = ref object of OpenApiRestCall_567658
proc url_LiveEventsReset_568319(protocol: Scheme; host: string; base: string;
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

proc validate_LiveEventsReset_568318(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Resets an existing Live Event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568320 = path.getOrDefault("resourceGroupName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "resourceGroupName", valid_568320
  var valid_568321 = path.getOrDefault("subscriptionId")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "subscriptionId", valid_568321
  var valid_568322 = path.getOrDefault("liveEventName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "liveEventName", valid_568322
  var valid_568323 = path.getOrDefault("accountName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "accountName", valid_568323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568324 = query.getOrDefault("api-version")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "api-version", valid_568324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568325: Call_LiveEventsReset_568317; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets an existing Live Event.
  ## 
  let valid = call_568325.validator(path, query, header, formData, body)
  let scheme = call_568325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568325.url(scheme.get, call_568325.host, call_568325.base,
                         call_568325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568325, url, valid)

proc call*(call_568326: Call_LiveEventsReset_568317; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; liveEventName: string;
          accountName: string): Recallable =
  ## liveEventsReset
  ## Resets an existing Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568327 = newJObject()
  var query_568328 = newJObject()
  add(path_568327, "resourceGroupName", newJString(resourceGroupName))
  add(query_568328, "api-version", newJString(apiVersion))
  add(path_568327, "subscriptionId", newJString(subscriptionId))
  add(path_568327, "liveEventName", newJString(liveEventName))
  add(path_568327, "accountName", newJString(accountName))
  result = call_568326.call(path_568327, query_568328, nil, nil, nil)

var liveEventsReset* = Call_LiveEventsReset_568317(name: "liveEventsReset",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/reset",
    validator: validate_LiveEventsReset_568318, base: "", url: url_LiveEventsReset_568319,
    schemes: {Scheme.Https})
type
  Call_LiveEventsStart_568329 = ref object of OpenApiRestCall_567658
proc url_LiveEventsStart_568331(protocol: Scheme; host: string; base: string;
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

proc validate_LiveEventsStart_568330(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Starts an existing Live Event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568332 = path.getOrDefault("resourceGroupName")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "resourceGroupName", valid_568332
  var valid_568333 = path.getOrDefault("subscriptionId")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "subscriptionId", valid_568333
  var valid_568334 = path.getOrDefault("liveEventName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "liveEventName", valid_568334
  var valid_568335 = path.getOrDefault("accountName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "accountName", valid_568335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568336 = query.getOrDefault("api-version")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "api-version", valid_568336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568337: Call_LiveEventsStart_568329; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an existing Live Event.
  ## 
  let valid = call_568337.validator(path, query, header, formData, body)
  let scheme = call_568337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568337.url(scheme.get, call_568337.host, call_568337.base,
                         call_568337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568337, url, valid)

proc call*(call_568338: Call_LiveEventsStart_568329; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; liveEventName: string;
          accountName: string): Recallable =
  ## liveEventsStart
  ## Starts an existing Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568339 = newJObject()
  var query_568340 = newJObject()
  add(path_568339, "resourceGroupName", newJString(resourceGroupName))
  add(query_568340, "api-version", newJString(apiVersion))
  add(path_568339, "subscriptionId", newJString(subscriptionId))
  add(path_568339, "liveEventName", newJString(liveEventName))
  add(path_568339, "accountName", newJString(accountName))
  result = call_568338.call(path_568339, query_568340, nil, nil, nil)

var liveEventsStart* = Call_LiveEventsStart_568329(name: "liveEventsStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/start",
    validator: validate_LiveEventsStart_568330, base: "", url: url_LiveEventsStart_568331,
    schemes: {Scheme.Https})
type
  Call_LiveEventsStop_568341 = ref object of OpenApiRestCall_567658
proc url_LiveEventsStop_568343(protocol: Scheme; host: string; base: string;
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

proc validate_LiveEventsStop_568342(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Stops an existing Live Event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: JString (required)
  ##                : The name of the Live Event.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568344 = path.getOrDefault("resourceGroupName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "resourceGroupName", valid_568344
  var valid_568345 = path.getOrDefault("subscriptionId")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "subscriptionId", valid_568345
  var valid_568346 = path.getOrDefault("liveEventName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "liveEventName", valid_568346
  var valid_568347 = path.getOrDefault("accountName")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "accountName", valid_568347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568348 = query.getOrDefault("api-version")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "api-version", valid_568348
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

proc call*(call_568350: Call_LiveEventsStop_568341; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops an existing Live Event.
  ## 
  let valid = call_568350.validator(path, query, header, formData, body)
  let scheme = call_568350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568350.url(scheme.get, call_568350.host, call_568350.base,
                         call_568350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568350, url, valid)

proc call*(call_568351: Call_LiveEventsStop_568341; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; liveEventName: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## liveEventsStop
  ## Stops an existing Live Event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   parameters: JObject (required)
  ##             : LiveEvent stop parameters
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568352 = newJObject()
  var query_568353 = newJObject()
  var body_568354 = newJObject()
  add(path_568352, "resourceGroupName", newJString(resourceGroupName))
  add(query_568353, "api-version", newJString(apiVersion))
  add(path_568352, "subscriptionId", newJString(subscriptionId))
  add(path_568352, "liveEventName", newJString(liveEventName))
  if parameters != nil:
    body_568354 = parameters
  add(path_568352, "accountName", newJString(accountName))
  result = call_568351.call(path_568352, query_568353, nil, nil, body_568354)

var liveEventsStop* = Call_LiveEventsStop_568341(name: "liveEventsStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/stop",
    validator: validate_LiveEventsStop_568342, base: "", url: url_LiveEventsStop_568343,
    schemes: {Scheme.Https})
type
  Call_StreamingEndpointsList_568355 = ref object of OpenApiRestCall_567658
proc url_StreamingEndpointsList_568357(protocol: Scheme; host: string; base: string;
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

proc validate_StreamingEndpointsList_568356(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the StreamingEndpoints in the account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568358 = path.getOrDefault("resourceGroupName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "resourceGroupName", valid_568358
  var valid_568359 = path.getOrDefault("subscriptionId")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "subscriptionId", valid_568359
  var valid_568360 = path.getOrDefault("accountName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "accountName", valid_568360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568361 = query.getOrDefault("api-version")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "api-version", valid_568361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568362: Call_StreamingEndpointsList_568355; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the StreamingEndpoints in the account.
  ## 
  let valid = call_568362.validator(path, query, header, formData, body)
  let scheme = call_568362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568362.url(scheme.get, call_568362.host, call_568362.base,
                         call_568362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568362, url, valid)

proc call*(call_568363: Call_StreamingEndpointsList_568355;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## streamingEndpointsList
  ## Lists the StreamingEndpoints in the account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568364 = newJObject()
  var query_568365 = newJObject()
  add(path_568364, "resourceGroupName", newJString(resourceGroupName))
  add(query_568365, "api-version", newJString(apiVersion))
  add(path_568364, "subscriptionId", newJString(subscriptionId))
  add(path_568364, "accountName", newJString(accountName))
  result = call_568363.call(path_568364, query_568365, nil, nil, nil)

var streamingEndpointsList* = Call_StreamingEndpointsList_568355(
    name: "streamingEndpointsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints",
    validator: validate_StreamingEndpointsList_568356, base: "",
    url: url_StreamingEndpointsList_568357, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsCreate_568378 = ref object of OpenApiRestCall_567658
proc url_StreamingEndpointsCreate_568380(protocol: Scheme; host: string;
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

proc validate_StreamingEndpointsCreate_568379(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a StreamingEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: JString (required)
  ##                        : The name of the StreamingEndpoint.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568381 = path.getOrDefault("resourceGroupName")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "resourceGroupName", valid_568381
  var valid_568382 = path.getOrDefault("streamingEndpointName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "streamingEndpointName", valid_568382
  var valid_568383 = path.getOrDefault("subscriptionId")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "subscriptionId", valid_568383
  var valid_568384 = path.getOrDefault("accountName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "accountName", valid_568384
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  ##   autoStart: JBool
  ##            : The flag indicates if the resource should be automatically started on creation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568385 = query.getOrDefault("api-version")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "api-version", valid_568385
  var valid_568386 = query.getOrDefault("autoStart")
  valid_568386 = validateParameter(valid_568386, JBool, required = false, default = nil)
  if valid_568386 != nil:
    section.add "autoStart", valid_568386
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

proc call*(call_568388: Call_StreamingEndpointsCreate_568378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a StreamingEndpoint.
  ## 
  let valid = call_568388.validator(path, query, header, formData, body)
  let scheme = call_568388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568388.url(scheme.get, call_568388.host, call_568388.base,
                         call_568388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568388, url, valid)

proc call*(call_568389: Call_StreamingEndpointsCreate_568378;
          resourceGroupName: string; apiVersion: string;
          streamingEndpointName: string; subscriptionId: string;
          parameters: JsonNode; accountName: string; autoStart: bool = false): Recallable =
  ## streamingEndpointsCreate
  ## Creates a StreamingEndpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   streamingEndpointName: string (required)
  ##                        : The name of the StreamingEndpoint.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   autoStart: bool
  ##            : The flag indicates if the resource should be automatically started on creation.
  ##   parameters: JObject (required)
  ##             : StreamingEndpoint properties needed for creation.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568390 = newJObject()
  var query_568391 = newJObject()
  var body_568392 = newJObject()
  add(path_568390, "resourceGroupName", newJString(resourceGroupName))
  add(query_568391, "api-version", newJString(apiVersion))
  add(path_568390, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_568390, "subscriptionId", newJString(subscriptionId))
  add(query_568391, "autoStart", newJBool(autoStart))
  if parameters != nil:
    body_568392 = parameters
  add(path_568390, "accountName", newJString(accountName))
  result = call_568389.call(path_568390, query_568391, nil, nil, body_568392)

var streamingEndpointsCreate* = Call_StreamingEndpointsCreate_568378(
    name: "streamingEndpointsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}",
    validator: validate_StreamingEndpointsCreate_568379, base: "",
    url: url_StreamingEndpointsCreate_568380, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsGet_568366 = ref object of OpenApiRestCall_567658
proc url_StreamingEndpointsGet_568368(protocol: Scheme; host: string; base: string;
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

proc validate_StreamingEndpointsGet_568367(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a StreamingEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: JString (required)
  ##                        : The name of the StreamingEndpoint.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568369 = path.getOrDefault("resourceGroupName")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "resourceGroupName", valid_568369
  var valid_568370 = path.getOrDefault("streamingEndpointName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "streamingEndpointName", valid_568370
  var valid_568371 = path.getOrDefault("subscriptionId")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "subscriptionId", valid_568371
  var valid_568372 = path.getOrDefault("accountName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "accountName", valid_568372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568373 = query.getOrDefault("api-version")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "api-version", valid_568373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568374: Call_StreamingEndpointsGet_568366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a StreamingEndpoint.
  ## 
  let valid = call_568374.validator(path, query, header, formData, body)
  let scheme = call_568374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568374.url(scheme.get, call_568374.host, call_568374.base,
                         call_568374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568374, url, valid)

proc call*(call_568375: Call_StreamingEndpointsGet_568366;
          resourceGroupName: string; apiVersion: string;
          streamingEndpointName: string; subscriptionId: string; accountName: string): Recallable =
  ## streamingEndpointsGet
  ## Gets a StreamingEndpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   streamingEndpointName: string (required)
  ##                        : The name of the StreamingEndpoint.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568376 = newJObject()
  var query_568377 = newJObject()
  add(path_568376, "resourceGroupName", newJString(resourceGroupName))
  add(query_568377, "api-version", newJString(apiVersion))
  add(path_568376, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_568376, "subscriptionId", newJString(subscriptionId))
  add(path_568376, "accountName", newJString(accountName))
  result = call_568375.call(path_568376, query_568377, nil, nil, nil)

var streamingEndpointsGet* = Call_StreamingEndpointsGet_568366(
    name: "streamingEndpointsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}",
    validator: validate_StreamingEndpointsGet_568367, base: "",
    url: url_StreamingEndpointsGet_568368, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsUpdate_568405 = ref object of OpenApiRestCall_567658
proc url_StreamingEndpointsUpdate_568407(protocol: Scheme; host: string;
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

proc validate_StreamingEndpointsUpdate_568406(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a existing StreamingEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: JString (required)
  ##                        : The name of the StreamingEndpoint.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568408 = path.getOrDefault("resourceGroupName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "resourceGroupName", valid_568408
  var valid_568409 = path.getOrDefault("streamingEndpointName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "streamingEndpointName", valid_568409
  var valid_568410 = path.getOrDefault("subscriptionId")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "subscriptionId", valid_568410
  var valid_568411 = path.getOrDefault("accountName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "accountName", valid_568411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568412 = query.getOrDefault("api-version")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "api-version", valid_568412
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

proc call*(call_568414: Call_StreamingEndpointsUpdate_568405; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a existing StreamingEndpoint.
  ## 
  let valid = call_568414.validator(path, query, header, formData, body)
  let scheme = call_568414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568414.url(scheme.get, call_568414.host, call_568414.base,
                         call_568414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568414, url, valid)

proc call*(call_568415: Call_StreamingEndpointsUpdate_568405;
          resourceGroupName: string; apiVersion: string;
          streamingEndpointName: string; subscriptionId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## streamingEndpointsUpdate
  ## Updates a existing StreamingEndpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   streamingEndpointName: string (required)
  ##                        : The name of the StreamingEndpoint.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   parameters: JObject (required)
  ##             : StreamingEndpoint properties needed for creation.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568416 = newJObject()
  var query_568417 = newJObject()
  var body_568418 = newJObject()
  add(path_568416, "resourceGroupName", newJString(resourceGroupName))
  add(query_568417, "api-version", newJString(apiVersion))
  add(path_568416, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_568416, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568418 = parameters
  add(path_568416, "accountName", newJString(accountName))
  result = call_568415.call(path_568416, query_568417, nil, nil, body_568418)

var streamingEndpointsUpdate* = Call_StreamingEndpointsUpdate_568405(
    name: "streamingEndpointsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}",
    validator: validate_StreamingEndpointsUpdate_568406, base: "",
    url: url_StreamingEndpointsUpdate_568407, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsDelete_568393 = ref object of OpenApiRestCall_567658
proc url_StreamingEndpointsDelete_568395(protocol: Scheme; host: string;
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

proc validate_StreamingEndpointsDelete_568394(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a StreamingEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: JString (required)
  ##                        : The name of the StreamingEndpoint.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568396 = path.getOrDefault("resourceGroupName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "resourceGroupName", valid_568396
  var valid_568397 = path.getOrDefault("streamingEndpointName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "streamingEndpointName", valid_568397
  var valid_568398 = path.getOrDefault("subscriptionId")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "subscriptionId", valid_568398
  var valid_568399 = path.getOrDefault("accountName")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "accountName", valid_568399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568400 = query.getOrDefault("api-version")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "api-version", valid_568400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568401: Call_StreamingEndpointsDelete_568393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a StreamingEndpoint.
  ## 
  let valid = call_568401.validator(path, query, header, formData, body)
  let scheme = call_568401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568401.url(scheme.get, call_568401.host, call_568401.base,
                         call_568401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568401, url, valid)

proc call*(call_568402: Call_StreamingEndpointsDelete_568393;
          resourceGroupName: string; apiVersion: string;
          streamingEndpointName: string; subscriptionId: string; accountName: string): Recallable =
  ## streamingEndpointsDelete
  ## Deletes a StreamingEndpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   streamingEndpointName: string (required)
  ##                        : The name of the StreamingEndpoint.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568403 = newJObject()
  var query_568404 = newJObject()
  add(path_568403, "resourceGroupName", newJString(resourceGroupName))
  add(query_568404, "api-version", newJString(apiVersion))
  add(path_568403, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_568403, "subscriptionId", newJString(subscriptionId))
  add(path_568403, "accountName", newJString(accountName))
  result = call_568402.call(path_568403, query_568404, nil, nil, nil)

var streamingEndpointsDelete* = Call_StreamingEndpointsDelete_568393(
    name: "streamingEndpointsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}",
    validator: validate_StreamingEndpointsDelete_568394, base: "",
    url: url_StreamingEndpointsDelete_568395, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsScale_568419 = ref object of OpenApiRestCall_567658
proc url_StreamingEndpointsScale_568421(protocol: Scheme; host: string; base: string;
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

proc validate_StreamingEndpointsScale_568420(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Scales an existing StreamingEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: JString (required)
  ##                        : The name of the StreamingEndpoint.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568422 = path.getOrDefault("resourceGroupName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "resourceGroupName", valid_568422
  var valid_568423 = path.getOrDefault("streamingEndpointName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "streamingEndpointName", valid_568423
  var valid_568424 = path.getOrDefault("subscriptionId")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "subscriptionId", valid_568424
  var valid_568425 = path.getOrDefault("accountName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "accountName", valid_568425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568426 = query.getOrDefault("api-version")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "api-version", valid_568426
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

proc call*(call_568428: Call_StreamingEndpointsScale_568419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scales an existing StreamingEndpoint.
  ## 
  let valid = call_568428.validator(path, query, header, formData, body)
  let scheme = call_568428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568428.url(scheme.get, call_568428.host, call_568428.base,
                         call_568428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568428, url, valid)

proc call*(call_568429: Call_StreamingEndpointsScale_568419;
          resourceGroupName: string; apiVersion: string;
          streamingEndpointName: string; subscriptionId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## streamingEndpointsScale
  ## Scales an existing StreamingEndpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   streamingEndpointName: string (required)
  ##                        : The name of the StreamingEndpoint.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   parameters: JObject (required)
  ##             : StreamingEndpoint scale parameters
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568430 = newJObject()
  var query_568431 = newJObject()
  var body_568432 = newJObject()
  add(path_568430, "resourceGroupName", newJString(resourceGroupName))
  add(query_568431, "api-version", newJString(apiVersion))
  add(path_568430, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_568430, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568432 = parameters
  add(path_568430, "accountName", newJString(accountName))
  result = call_568429.call(path_568430, query_568431, nil, nil, body_568432)

var streamingEndpointsScale* = Call_StreamingEndpointsScale_568419(
    name: "streamingEndpointsScale", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}/scale",
    validator: validate_StreamingEndpointsScale_568420, base: "",
    url: url_StreamingEndpointsScale_568421, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsStart_568433 = ref object of OpenApiRestCall_567658
proc url_StreamingEndpointsStart_568435(protocol: Scheme; host: string; base: string;
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

proc validate_StreamingEndpointsStart_568434(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts an existing StreamingEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: JString (required)
  ##                        : The name of the StreamingEndpoint.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568436 = path.getOrDefault("resourceGroupName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "resourceGroupName", valid_568436
  var valid_568437 = path.getOrDefault("streamingEndpointName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "streamingEndpointName", valid_568437
  var valid_568438 = path.getOrDefault("subscriptionId")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "subscriptionId", valid_568438
  var valid_568439 = path.getOrDefault("accountName")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "accountName", valid_568439
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568440 = query.getOrDefault("api-version")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "api-version", valid_568440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568441: Call_StreamingEndpointsStart_568433; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an existing StreamingEndpoint.
  ## 
  let valid = call_568441.validator(path, query, header, formData, body)
  let scheme = call_568441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568441.url(scheme.get, call_568441.host, call_568441.base,
                         call_568441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568441, url, valid)

proc call*(call_568442: Call_StreamingEndpointsStart_568433;
          resourceGroupName: string; apiVersion: string;
          streamingEndpointName: string; subscriptionId: string; accountName: string): Recallable =
  ## streamingEndpointsStart
  ## Starts an existing StreamingEndpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   streamingEndpointName: string (required)
  ##                        : The name of the StreamingEndpoint.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568443 = newJObject()
  var query_568444 = newJObject()
  add(path_568443, "resourceGroupName", newJString(resourceGroupName))
  add(query_568444, "api-version", newJString(apiVersion))
  add(path_568443, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_568443, "subscriptionId", newJString(subscriptionId))
  add(path_568443, "accountName", newJString(accountName))
  result = call_568442.call(path_568443, query_568444, nil, nil, nil)

var streamingEndpointsStart* = Call_StreamingEndpointsStart_568433(
    name: "streamingEndpointsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}/start",
    validator: validate_StreamingEndpointsStart_568434, base: "",
    url: url_StreamingEndpointsStart_568435, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsStop_568445 = ref object of OpenApiRestCall_567658
proc url_StreamingEndpointsStop_568447(protocol: Scheme; host: string; base: string;
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

proc validate_StreamingEndpointsStop_568446(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops an existing StreamingEndpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   streamingEndpointName: JString (required)
  ##                        : The name of the StreamingEndpoint.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   accountName: JString (required)
  ##              : The Media Services account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568448 = path.getOrDefault("resourceGroupName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "resourceGroupName", valid_568448
  var valid_568449 = path.getOrDefault("streamingEndpointName")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "streamingEndpointName", valid_568449
  var valid_568450 = path.getOrDefault("subscriptionId")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "subscriptionId", valid_568450
  var valid_568451 = path.getOrDefault("accountName")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "accountName", valid_568451
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568452 = query.getOrDefault("api-version")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "api-version", valid_568452
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568453: Call_StreamingEndpointsStop_568445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops an existing StreamingEndpoint.
  ## 
  let valid = call_568453.validator(path, query, header, formData, body)
  let scheme = call_568453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568453.url(scheme.get, call_568453.host, call_568453.base,
                         call_568453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568453, url, valid)

proc call*(call_568454: Call_StreamingEndpointsStop_568445;
          resourceGroupName: string; apiVersion: string;
          streamingEndpointName: string; subscriptionId: string; accountName: string): Recallable =
  ## streamingEndpointsStop
  ## Stops an existing StreamingEndpoint.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : The Version of the API to be used with the client request.
  ##   streamingEndpointName: string (required)
  ##                        : The name of the StreamingEndpoint.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_568455 = newJObject()
  var query_568456 = newJObject()
  add(path_568455, "resourceGroupName", newJString(resourceGroupName))
  add(query_568456, "api-version", newJString(apiVersion))
  add(path_568455, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_568455, "subscriptionId", newJString(subscriptionId))
  add(path_568455, "accountName", newJString(accountName))
  result = call_568454.call(path_568455, query_568456, nil, nil, nil)

var streamingEndpointsStop* = Call_StreamingEndpointsStop_568445(
    name: "streamingEndpointsStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}/stop",
    validator: validate_StreamingEndpointsStop_568446, base: "",
    url: url_StreamingEndpointsStop_568447, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
