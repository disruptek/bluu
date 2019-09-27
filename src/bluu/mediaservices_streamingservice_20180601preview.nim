
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Media Services
## version: 2018-06-01-preview
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
  macServiceName = "mediaservices-streamingservice"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LiveEventsList_593647 = ref object of OpenApiRestCall_593425
proc url_LiveEventsList_593649(protocol: Scheme; host: string; base: string;
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

proc validate_LiveEventsList_593648(path: JsonNode; query: JsonNode;
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
  var valid_593822 = path.getOrDefault("resourceGroupName")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "resourceGroupName", valid_593822
  var valid_593823 = path.getOrDefault("subscriptionId")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "subscriptionId", valid_593823
  var valid_593824 = path.getOrDefault("accountName")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "accountName", valid_593824
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593825 = query.getOrDefault("api-version")
  valid_593825 = validateParameter(valid_593825, JString, required = true,
                                 default = nil)
  if valid_593825 != nil:
    section.add "api-version", valid_593825
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593848: Call_LiveEventsList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Live Events in the account.
  ## 
  let valid = call_593848.validator(path, query, header, formData, body)
  let scheme = call_593848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593848.url(scheme.get, call_593848.host, call_593848.base,
                         call_593848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593848, url, valid)

proc call*(call_593919: Call_LiveEventsList_593647; resourceGroupName: string;
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
  var path_593920 = newJObject()
  var query_593922 = newJObject()
  add(path_593920, "resourceGroupName", newJString(resourceGroupName))
  add(query_593922, "api-version", newJString(apiVersion))
  add(path_593920, "subscriptionId", newJString(subscriptionId))
  add(path_593920, "accountName", newJString(accountName))
  result = call_593919.call(path_593920, query_593922, nil, nil, nil)

var liveEventsList* = Call_LiveEventsList_593647(name: "liveEventsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents",
    validator: validate_LiveEventsList_593648, base: "", url: url_LiveEventsList_593649,
    schemes: {Scheme.Https})
type
  Call_LiveEventsCreate_593973 = ref object of OpenApiRestCall_593425
proc url_LiveEventsCreate_593975(protocol: Scheme; host: string; base: string;
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

proc validate_LiveEventsCreate_593974(path: JsonNode; query: JsonNode;
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
  var valid_593993 = path.getOrDefault("resourceGroupName")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "resourceGroupName", valid_593993
  var valid_593994 = path.getOrDefault("subscriptionId")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "subscriptionId", valid_593994
  var valid_593995 = path.getOrDefault("liveEventName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "liveEventName", valid_593995
  var valid_593996 = path.getOrDefault("accountName")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "accountName", valid_593996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  ##   autoStart: JBool
  ##            : The flag indicates if auto start the Live Event.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593997 = query.getOrDefault("api-version")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "api-version", valid_593997
  var valid_593998 = query.getOrDefault("autoStart")
  valid_593998 = validateParameter(valid_593998, JBool, required = false, default = nil)
  if valid_593998 != nil:
    section.add "autoStart", valid_593998
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

proc call*(call_594000: Call_LiveEventsCreate_593973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Live Event.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_LiveEventsCreate_593973; resourceGroupName: string;
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
  ##            : The flag indicates if auto start the Live Event.
  ##   liveEventName: string (required)
  ##                : The name of the Live Event.
  ##   parameters: JObject (required)
  ##             : Live Event properties needed for creation.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  var body_594004 = newJObject()
  add(path_594002, "resourceGroupName", newJString(resourceGroupName))
  add(query_594003, "api-version", newJString(apiVersion))
  add(path_594002, "subscriptionId", newJString(subscriptionId))
  add(query_594003, "autoStart", newJBool(autoStart))
  add(path_594002, "liveEventName", newJString(liveEventName))
  if parameters != nil:
    body_594004 = parameters
  add(path_594002, "accountName", newJString(accountName))
  result = call_594001.call(path_594002, query_594003, nil, nil, body_594004)

var liveEventsCreate* = Call_LiveEventsCreate_593973(name: "liveEventsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}",
    validator: validate_LiveEventsCreate_593974, base: "",
    url: url_LiveEventsCreate_593975, schemes: {Scheme.Https})
type
  Call_LiveEventsGet_593961 = ref object of OpenApiRestCall_593425
proc url_LiveEventsGet_593963(protocol: Scheme; host: string; base: string;
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

proc validate_LiveEventsGet_593962(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593964 = path.getOrDefault("resourceGroupName")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "resourceGroupName", valid_593964
  var valid_593965 = path.getOrDefault("subscriptionId")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "subscriptionId", valid_593965
  var valid_593966 = path.getOrDefault("liveEventName")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "liveEventName", valid_593966
  var valid_593967 = path.getOrDefault("accountName")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "accountName", valid_593967
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
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

proc call*(call_593969: Call_LiveEventsGet_593961; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Live Event.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_LiveEventsGet_593961; resourceGroupName: string;
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
  var path_593971 = newJObject()
  var query_593972 = newJObject()
  add(path_593971, "resourceGroupName", newJString(resourceGroupName))
  add(query_593972, "api-version", newJString(apiVersion))
  add(path_593971, "subscriptionId", newJString(subscriptionId))
  add(path_593971, "liveEventName", newJString(liveEventName))
  add(path_593971, "accountName", newJString(accountName))
  result = call_593970.call(path_593971, query_593972, nil, nil, nil)

var liveEventsGet* = Call_LiveEventsGet_593961(name: "liveEventsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}",
    validator: validate_LiveEventsGet_593962, base: "", url: url_LiveEventsGet_593963,
    schemes: {Scheme.Https})
type
  Call_LiveEventsUpdate_594017 = ref object of OpenApiRestCall_593425
proc url_LiveEventsUpdate_594019(protocol: Scheme; host: string; base: string;
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

proc validate_LiveEventsUpdate_594018(path: JsonNode; query: JsonNode;
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
  var valid_594020 = path.getOrDefault("resourceGroupName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "resourceGroupName", valid_594020
  var valid_594021 = path.getOrDefault("subscriptionId")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "subscriptionId", valid_594021
  var valid_594022 = path.getOrDefault("liveEventName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "liveEventName", valid_594022
  var valid_594023 = path.getOrDefault("accountName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "accountName", valid_594023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594024 = query.getOrDefault("api-version")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "api-version", valid_594024
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

proc call*(call_594026: Call_LiveEventsUpdate_594017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a existing Live Event.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_LiveEventsUpdate_594017; resourceGroupName: string;
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
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  var body_594030 = newJObject()
  add(path_594028, "resourceGroupName", newJString(resourceGroupName))
  add(query_594029, "api-version", newJString(apiVersion))
  add(path_594028, "subscriptionId", newJString(subscriptionId))
  add(path_594028, "liveEventName", newJString(liveEventName))
  if parameters != nil:
    body_594030 = parameters
  add(path_594028, "accountName", newJString(accountName))
  result = call_594027.call(path_594028, query_594029, nil, nil, body_594030)

var liveEventsUpdate* = Call_LiveEventsUpdate_594017(name: "liveEventsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}",
    validator: validate_LiveEventsUpdate_594018, base: "",
    url: url_LiveEventsUpdate_594019, schemes: {Scheme.Https})
type
  Call_LiveEventsDelete_594005 = ref object of OpenApiRestCall_593425
proc url_LiveEventsDelete_594007(protocol: Scheme; host: string; base: string;
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

proc validate_LiveEventsDelete_594006(path: JsonNode; query: JsonNode;
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
  var valid_594008 = path.getOrDefault("resourceGroupName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "resourceGroupName", valid_594008
  var valid_594009 = path.getOrDefault("subscriptionId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "subscriptionId", valid_594009
  var valid_594010 = path.getOrDefault("liveEventName")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "liveEventName", valid_594010
  var valid_594011 = path.getOrDefault("accountName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "accountName", valid_594011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594012 = query.getOrDefault("api-version")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "api-version", valid_594012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594013: Call_LiveEventsDelete_594005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Live Event.
  ## 
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_LiveEventsDelete_594005; resourceGroupName: string;
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
  var path_594015 = newJObject()
  var query_594016 = newJObject()
  add(path_594015, "resourceGroupName", newJString(resourceGroupName))
  add(query_594016, "api-version", newJString(apiVersion))
  add(path_594015, "subscriptionId", newJString(subscriptionId))
  add(path_594015, "liveEventName", newJString(liveEventName))
  add(path_594015, "accountName", newJString(accountName))
  result = call_594014.call(path_594015, query_594016, nil, nil, nil)

var liveEventsDelete* = Call_LiveEventsDelete_594005(name: "liveEventsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}",
    validator: validate_LiveEventsDelete_594006, base: "",
    url: url_LiveEventsDelete_594007, schemes: {Scheme.Https})
type
  Call_LiveOutputsList_594031 = ref object of OpenApiRestCall_593425
proc url_LiveOutputsList_594033(protocol: Scheme; host: string; base: string;
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

proc validate_LiveOutputsList_594032(path: JsonNode; query: JsonNode;
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
  var valid_594034 = path.getOrDefault("resourceGroupName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "resourceGroupName", valid_594034
  var valid_594035 = path.getOrDefault("subscriptionId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "subscriptionId", valid_594035
  var valid_594036 = path.getOrDefault("liveEventName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "liveEventName", valid_594036
  var valid_594037 = path.getOrDefault("accountName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "accountName", valid_594037
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594038 = query.getOrDefault("api-version")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "api-version", valid_594038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594039: Call_LiveOutputsList_594031; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Live Outputs in the Live Event.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_LiveOutputsList_594031; resourceGroupName: string;
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
  var path_594041 = newJObject()
  var query_594042 = newJObject()
  add(path_594041, "resourceGroupName", newJString(resourceGroupName))
  add(query_594042, "api-version", newJString(apiVersion))
  add(path_594041, "subscriptionId", newJString(subscriptionId))
  add(path_594041, "liveEventName", newJString(liveEventName))
  add(path_594041, "accountName", newJString(accountName))
  result = call_594040.call(path_594041, query_594042, nil, nil, nil)

var liveOutputsList* = Call_LiveOutputsList_594031(name: "liveOutputsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/liveOutputs",
    validator: validate_LiveOutputsList_594032, base: "", url: url_LiveOutputsList_594033,
    schemes: {Scheme.Https})
type
  Call_LiveOutputsCreate_594056 = ref object of OpenApiRestCall_593425
proc url_LiveOutputsCreate_594058(protocol: Scheme; host: string; base: string;
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

proc validate_LiveOutputsCreate_594057(path: JsonNode; query: JsonNode;
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
  var valid_594059 = path.getOrDefault("resourceGroupName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "resourceGroupName", valid_594059
  var valid_594060 = path.getOrDefault("subscriptionId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "subscriptionId", valid_594060
  var valid_594061 = path.getOrDefault("liveEventName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "liveEventName", valid_594061
  var valid_594062 = path.getOrDefault("liveOutputName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "liveOutputName", valid_594062
  var valid_594063 = path.getOrDefault("accountName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "accountName", valid_594063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594064 = query.getOrDefault("api-version")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "api-version", valid_594064
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

proc call*(call_594066: Call_LiveOutputsCreate_594056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Live Output.
  ## 
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_LiveOutputsCreate_594056; resourceGroupName: string;
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
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  var body_594070 = newJObject()
  add(path_594068, "resourceGroupName", newJString(resourceGroupName))
  add(query_594069, "api-version", newJString(apiVersion))
  add(path_594068, "subscriptionId", newJString(subscriptionId))
  add(path_594068, "liveEventName", newJString(liveEventName))
  add(path_594068, "liveOutputName", newJString(liveOutputName))
  if parameters != nil:
    body_594070 = parameters
  add(path_594068, "accountName", newJString(accountName))
  result = call_594067.call(path_594068, query_594069, nil, nil, body_594070)

var liveOutputsCreate* = Call_LiveOutputsCreate_594056(name: "liveOutputsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/liveOutputs/{liveOutputName}",
    validator: validate_LiveOutputsCreate_594057, base: "",
    url: url_LiveOutputsCreate_594058, schemes: {Scheme.Https})
type
  Call_LiveOutputsGet_594043 = ref object of OpenApiRestCall_593425
proc url_LiveOutputsGet_594045(protocol: Scheme; host: string; base: string;
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

proc validate_LiveOutputsGet_594044(path: JsonNode; query: JsonNode;
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
  var valid_594046 = path.getOrDefault("resourceGroupName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "resourceGroupName", valid_594046
  var valid_594047 = path.getOrDefault("subscriptionId")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "subscriptionId", valid_594047
  var valid_594048 = path.getOrDefault("liveEventName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "liveEventName", valid_594048
  var valid_594049 = path.getOrDefault("liveOutputName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "liveOutputName", valid_594049
  var valid_594050 = path.getOrDefault("accountName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "accountName", valid_594050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594051 = query.getOrDefault("api-version")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "api-version", valid_594051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594052: Call_LiveOutputsGet_594043; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Live Output.
  ## 
  let valid = call_594052.validator(path, query, header, formData, body)
  let scheme = call_594052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594052.url(scheme.get, call_594052.host, call_594052.base,
                         call_594052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594052, url, valid)

proc call*(call_594053: Call_LiveOutputsGet_594043; resourceGroupName: string;
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
  var path_594054 = newJObject()
  var query_594055 = newJObject()
  add(path_594054, "resourceGroupName", newJString(resourceGroupName))
  add(query_594055, "api-version", newJString(apiVersion))
  add(path_594054, "subscriptionId", newJString(subscriptionId))
  add(path_594054, "liveEventName", newJString(liveEventName))
  add(path_594054, "liveOutputName", newJString(liveOutputName))
  add(path_594054, "accountName", newJString(accountName))
  result = call_594053.call(path_594054, query_594055, nil, nil, nil)

var liveOutputsGet* = Call_LiveOutputsGet_594043(name: "liveOutputsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/liveOutputs/{liveOutputName}",
    validator: validate_LiveOutputsGet_594044, base: "", url: url_LiveOutputsGet_594045,
    schemes: {Scheme.Https})
type
  Call_LiveOutputsDelete_594071 = ref object of OpenApiRestCall_593425
proc url_LiveOutputsDelete_594073(protocol: Scheme; host: string; base: string;
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

proc validate_LiveOutputsDelete_594072(path: JsonNode; query: JsonNode;
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
  var valid_594074 = path.getOrDefault("resourceGroupName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "resourceGroupName", valid_594074
  var valid_594075 = path.getOrDefault("subscriptionId")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "subscriptionId", valid_594075
  var valid_594076 = path.getOrDefault("liveEventName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "liveEventName", valid_594076
  var valid_594077 = path.getOrDefault("liveOutputName")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "liveOutputName", valid_594077
  var valid_594078 = path.getOrDefault("accountName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "accountName", valid_594078
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
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
  if body != nil:
    result.add "body", body

proc call*(call_594080: Call_LiveOutputsDelete_594071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Live Output.
  ## 
  let valid = call_594080.validator(path, query, header, formData, body)
  let scheme = call_594080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594080.url(scheme.get, call_594080.host, call_594080.base,
                         call_594080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594080, url, valid)

proc call*(call_594081: Call_LiveOutputsDelete_594071; resourceGroupName: string;
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
  var path_594082 = newJObject()
  var query_594083 = newJObject()
  add(path_594082, "resourceGroupName", newJString(resourceGroupName))
  add(query_594083, "api-version", newJString(apiVersion))
  add(path_594082, "subscriptionId", newJString(subscriptionId))
  add(path_594082, "liveEventName", newJString(liveEventName))
  add(path_594082, "liveOutputName", newJString(liveOutputName))
  add(path_594082, "accountName", newJString(accountName))
  result = call_594081.call(path_594082, query_594083, nil, nil, nil)

var liveOutputsDelete* = Call_LiveOutputsDelete_594071(name: "liveOutputsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/liveOutputs/{liveOutputName}",
    validator: validate_LiveOutputsDelete_594072, base: "",
    url: url_LiveOutputsDelete_594073, schemes: {Scheme.Https})
type
  Call_LiveEventsReset_594084 = ref object of OpenApiRestCall_593425
proc url_LiveEventsReset_594086(protocol: Scheme; host: string; base: string;
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

proc validate_LiveEventsReset_594085(path: JsonNode; query: JsonNode;
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
  var valid_594087 = path.getOrDefault("resourceGroupName")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "resourceGroupName", valid_594087
  var valid_594088 = path.getOrDefault("subscriptionId")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "subscriptionId", valid_594088
  var valid_594089 = path.getOrDefault("liveEventName")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "liveEventName", valid_594089
  var valid_594090 = path.getOrDefault("accountName")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "accountName", valid_594090
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594091 = query.getOrDefault("api-version")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "api-version", valid_594091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594092: Call_LiveEventsReset_594084; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets an existing Live Event.
  ## 
  let valid = call_594092.validator(path, query, header, formData, body)
  let scheme = call_594092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594092.url(scheme.get, call_594092.host, call_594092.base,
                         call_594092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594092, url, valid)

proc call*(call_594093: Call_LiveEventsReset_594084; resourceGroupName: string;
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
  var path_594094 = newJObject()
  var query_594095 = newJObject()
  add(path_594094, "resourceGroupName", newJString(resourceGroupName))
  add(query_594095, "api-version", newJString(apiVersion))
  add(path_594094, "subscriptionId", newJString(subscriptionId))
  add(path_594094, "liveEventName", newJString(liveEventName))
  add(path_594094, "accountName", newJString(accountName))
  result = call_594093.call(path_594094, query_594095, nil, nil, nil)

var liveEventsReset* = Call_LiveEventsReset_594084(name: "liveEventsReset",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/reset",
    validator: validate_LiveEventsReset_594085, base: "", url: url_LiveEventsReset_594086,
    schemes: {Scheme.Https})
type
  Call_LiveEventsStart_594096 = ref object of OpenApiRestCall_593425
proc url_LiveEventsStart_594098(protocol: Scheme; host: string; base: string;
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

proc validate_LiveEventsStart_594097(path: JsonNode; query: JsonNode;
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
  var valid_594099 = path.getOrDefault("resourceGroupName")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "resourceGroupName", valid_594099
  var valid_594100 = path.getOrDefault("subscriptionId")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "subscriptionId", valid_594100
  var valid_594101 = path.getOrDefault("liveEventName")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "liveEventName", valid_594101
  var valid_594102 = path.getOrDefault("accountName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "accountName", valid_594102
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594103 = query.getOrDefault("api-version")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "api-version", valid_594103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594104: Call_LiveEventsStart_594096; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an existing Live Event.
  ## 
  let valid = call_594104.validator(path, query, header, formData, body)
  let scheme = call_594104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594104.url(scheme.get, call_594104.host, call_594104.base,
                         call_594104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594104, url, valid)

proc call*(call_594105: Call_LiveEventsStart_594096; resourceGroupName: string;
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
  var path_594106 = newJObject()
  var query_594107 = newJObject()
  add(path_594106, "resourceGroupName", newJString(resourceGroupName))
  add(query_594107, "api-version", newJString(apiVersion))
  add(path_594106, "subscriptionId", newJString(subscriptionId))
  add(path_594106, "liveEventName", newJString(liveEventName))
  add(path_594106, "accountName", newJString(accountName))
  result = call_594105.call(path_594106, query_594107, nil, nil, nil)

var liveEventsStart* = Call_LiveEventsStart_594096(name: "liveEventsStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/start",
    validator: validate_LiveEventsStart_594097, base: "", url: url_LiveEventsStart_594098,
    schemes: {Scheme.Https})
type
  Call_LiveEventsStop_594108 = ref object of OpenApiRestCall_593425
proc url_LiveEventsStop_594110(protocol: Scheme; host: string; base: string;
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

proc validate_LiveEventsStop_594109(path: JsonNode; query: JsonNode;
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
  var valid_594111 = path.getOrDefault("resourceGroupName")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "resourceGroupName", valid_594111
  var valid_594112 = path.getOrDefault("subscriptionId")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "subscriptionId", valid_594112
  var valid_594113 = path.getOrDefault("liveEventName")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "liveEventName", valid_594113
  var valid_594114 = path.getOrDefault("accountName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "accountName", valid_594114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594115 = query.getOrDefault("api-version")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "api-version", valid_594115
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

proc call*(call_594117: Call_LiveEventsStop_594108; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops an existing Live Event.
  ## 
  let valid = call_594117.validator(path, query, header, formData, body)
  let scheme = call_594117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594117.url(scheme.get, call_594117.host, call_594117.base,
                         call_594117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594117, url, valid)

proc call*(call_594118: Call_LiveEventsStop_594108; resourceGroupName: string;
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
  var path_594119 = newJObject()
  var query_594120 = newJObject()
  var body_594121 = newJObject()
  add(path_594119, "resourceGroupName", newJString(resourceGroupName))
  add(query_594120, "api-version", newJString(apiVersion))
  add(path_594119, "subscriptionId", newJString(subscriptionId))
  add(path_594119, "liveEventName", newJString(liveEventName))
  if parameters != nil:
    body_594121 = parameters
  add(path_594119, "accountName", newJString(accountName))
  result = call_594118.call(path_594119, query_594120, nil, nil, body_594121)

var liveEventsStop* = Call_LiveEventsStop_594108(name: "liveEventsStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/liveEvents/{liveEventName}/stop",
    validator: validate_LiveEventsStop_594109, base: "", url: url_LiveEventsStop_594110,
    schemes: {Scheme.Https})
type
  Call_StreamingEndpointsList_594122 = ref object of OpenApiRestCall_593425
proc url_StreamingEndpointsList_594124(protocol: Scheme; host: string; base: string;
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

proc validate_StreamingEndpointsList_594123(path: JsonNode; query: JsonNode;
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
  var valid_594125 = path.getOrDefault("resourceGroupName")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "resourceGroupName", valid_594125
  var valid_594126 = path.getOrDefault("subscriptionId")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "subscriptionId", valid_594126
  var valid_594127 = path.getOrDefault("accountName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "accountName", valid_594127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594128 = query.getOrDefault("api-version")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "api-version", valid_594128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594129: Call_StreamingEndpointsList_594122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the StreamingEndpoints in the account.
  ## 
  let valid = call_594129.validator(path, query, header, formData, body)
  let scheme = call_594129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594129.url(scheme.get, call_594129.host, call_594129.base,
                         call_594129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594129, url, valid)

proc call*(call_594130: Call_StreamingEndpointsList_594122;
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
  var path_594131 = newJObject()
  var query_594132 = newJObject()
  add(path_594131, "resourceGroupName", newJString(resourceGroupName))
  add(query_594132, "api-version", newJString(apiVersion))
  add(path_594131, "subscriptionId", newJString(subscriptionId))
  add(path_594131, "accountName", newJString(accountName))
  result = call_594130.call(path_594131, query_594132, nil, nil, nil)

var streamingEndpointsList* = Call_StreamingEndpointsList_594122(
    name: "streamingEndpointsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints",
    validator: validate_StreamingEndpointsList_594123, base: "",
    url: url_StreamingEndpointsList_594124, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsCreate_594145 = ref object of OpenApiRestCall_593425
proc url_StreamingEndpointsCreate_594147(protocol: Scheme; host: string;
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

proc validate_StreamingEndpointsCreate_594146(path: JsonNode; query: JsonNode;
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
  var valid_594148 = path.getOrDefault("resourceGroupName")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "resourceGroupName", valid_594148
  var valid_594149 = path.getOrDefault("streamingEndpointName")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "streamingEndpointName", valid_594149
  var valid_594150 = path.getOrDefault("subscriptionId")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "subscriptionId", valid_594150
  var valid_594151 = path.getOrDefault("accountName")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "accountName", valid_594151
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  ##   autoStart: JBool
  ##            : The flag indicates if auto start the Live Event.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594152 = query.getOrDefault("api-version")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "api-version", valid_594152
  var valid_594153 = query.getOrDefault("autoStart")
  valid_594153 = validateParameter(valid_594153, JBool, required = false, default = nil)
  if valid_594153 != nil:
    section.add "autoStart", valid_594153
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

proc call*(call_594155: Call_StreamingEndpointsCreate_594145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a StreamingEndpoint.
  ## 
  let valid = call_594155.validator(path, query, header, formData, body)
  let scheme = call_594155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594155.url(scheme.get, call_594155.host, call_594155.base,
                         call_594155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594155, url, valid)

proc call*(call_594156: Call_StreamingEndpointsCreate_594145;
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
  ##            : The flag indicates if auto start the Live Event.
  ##   parameters: JObject (required)
  ##             : StreamingEndpoint properties needed for creation.
  ##   accountName: string (required)
  ##              : The Media Services account name.
  var path_594157 = newJObject()
  var query_594158 = newJObject()
  var body_594159 = newJObject()
  add(path_594157, "resourceGroupName", newJString(resourceGroupName))
  add(query_594158, "api-version", newJString(apiVersion))
  add(path_594157, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_594157, "subscriptionId", newJString(subscriptionId))
  add(query_594158, "autoStart", newJBool(autoStart))
  if parameters != nil:
    body_594159 = parameters
  add(path_594157, "accountName", newJString(accountName))
  result = call_594156.call(path_594157, query_594158, nil, nil, body_594159)

var streamingEndpointsCreate* = Call_StreamingEndpointsCreate_594145(
    name: "streamingEndpointsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}",
    validator: validate_StreamingEndpointsCreate_594146, base: "",
    url: url_StreamingEndpointsCreate_594147, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsGet_594133 = ref object of OpenApiRestCall_593425
proc url_StreamingEndpointsGet_594135(protocol: Scheme; host: string; base: string;
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

proc validate_StreamingEndpointsGet_594134(path: JsonNode; query: JsonNode;
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
  var valid_594136 = path.getOrDefault("resourceGroupName")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "resourceGroupName", valid_594136
  var valid_594137 = path.getOrDefault("streamingEndpointName")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "streamingEndpointName", valid_594137
  var valid_594138 = path.getOrDefault("subscriptionId")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "subscriptionId", valid_594138
  var valid_594139 = path.getOrDefault("accountName")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "accountName", valid_594139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594140 = query.getOrDefault("api-version")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "api-version", valid_594140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594141: Call_StreamingEndpointsGet_594133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a StreamingEndpoint.
  ## 
  let valid = call_594141.validator(path, query, header, formData, body)
  let scheme = call_594141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594141.url(scheme.get, call_594141.host, call_594141.base,
                         call_594141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594141, url, valid)

proc call*(call_594142: Call_StreamingEndpointsGet_594133;
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
  var path_594143 = newJObject()
  var query_594144 = newJObject()
  add(path_594143, "resourceGroupName", newJString(resourceGroupName))
  add(query_594144, "api-version", newJString(apiVersion))
  add(path_594143, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_594143, "subscriptionId", newJString(subscriptionId))
  add(path_594143, "accountName", newJString(accountName))
  result = call_594142.call(path_594143, query_594144, nil, nil, nil)

var streamingEndpointsGet* = Call_StreamingEndpointsGet_594133(
    name: "streamingEndpointsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}",
    validator: validate_StreamingEndpointsGet_594134, base: "",
    url: url_StreamingEndpointsGet_594135, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsUpdate_594172 = ref object of OpenApiRestCall_593425
proc url_StreamingEndpointsUpdate_594174(protocol: Scheme; host: string;
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

proc validate_StreamingEndpointsUpdate_594173(path: JsonNode; query: JsonNode;
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
  var valid_594175 = path.getOrDefault("resourceGroupName")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "resourceGroupName", valid_594175
  var valid_594176 = path.getOrDefault("streamingEndpointName")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "streamingEndpointName", valid_594176
  var valid_594177 = path.getOrDefault("subscriptionId")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "subscriptionId", valid_594177
  var valid_594178 = path.getOrDefault("accountName")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "accountName", valid_594178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594179 = query.getOrDefault("api-version")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "api-version", valid_594179
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

proc call*(call_594181: Call_StreamingEndpointsUpdate_594172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a existing StreamingEndpoint.
  ## 
  let valid = call_594181.validator(path, query, header, formData, body)
  let scheme = call_594181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594181.url(scheme.get, call_594181.host, call_594181.base,
                         call_594181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594181, url, valid)

proc call*(call_594182: Call_StreamingEndpointsUpdate_594172;
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
  var path_594183 = newJObject()
  var query_594184 = newJObject()
  var body_594185 = newJObject()
  add(path_594183, "resourceGroupName", newJString(resourceGroupName))
  add(query_594184, "api-version", newJString(apiVersion))
  add(path_594183, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_594183, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594185 = parameters
  add(path_594183, "accountName", newJString(accountName))
  result = call_594182.call(path_594183, query_594184, nil, nil, body_594185)

var streamingEndpointsUpdate* = Call_StreamingEndpointsUpdate_594172(
    name: "streamingEndpointsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}",
    validator: validate_StreamingEndpointsUpdate_594173, base: "",
    url: url_StreamingEndpointsUpdate_594174, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsDelete_594160 = ref object of OpenApiRestCall_593425
proc url_StreamingEndpointsDelete_594162(protocol: Scheme; host: string;
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

proc validate_StreamingEndpointsDelete_594161(path: JsonNode; query: JsonNode;
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
  var valid_594163 = path.getOrDefault("resourceGroupName")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "resourceGroupName", valid_594163
  var valid_594164 = path.getOrDefault("streamingEndpointName")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "streamingEndpointName", valid_594164
  var valid_594165 = path.getOrDefault("subscriptionId")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "subscriptionId", valid_594165
  var valid_594166 = path.getOrDefault("accountName")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "accountName", valid_594166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594167 = query.getOrDefault("api-version")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "api-version", valid_594167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594168: Call_StreamingEndpointsDelete_594160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a StreamingEndpoint.
  ## 
  let valid = call_594168.validator(path, query, header, formData, body)
  let scheme = call_594168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594168.url(scheme.get, call_594168.host, call_594168.base,
                         call_594168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594168, url, valid)

proc call*(call_594169: Call_StreamingEndpointsDelete_594160;
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
  var path_594170 = newJObject()
  var query_594171 = newJObject()
  add(path_594170, "resourceGroupName", newJString(resourceGroupName))
  add(query_594171, "api-version", newJString(apiVersion))
  add(path_594170, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_594170, "subscriptionId", newJString(subscriptionId))
  add(path_594170, "accountName", newJString(accountName))
  result = call_594169.call(path_594170, query_594171, nil, nil, nil)

var streamingEndpointsDelete* = Call_StreamingEndpointsDelete_594160(
    name: "streamingEndpointsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}",
    validator: validate_StreamingEndpointsDelete_594161, base: "",
    url: url_StreamingEndpointsDelete_594162, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsScale_594186 = ref object of OpenApiRestCall_593425
proc url_StreamingEndpointsScale_594188(protocol: Scheme; host: string; base: string;
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

proc validate_StreamingEndpointsScale_594187(path: JsonNode; query: JsonNode;
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
  var valid_594189 = path.getOrDefault("resourceGroupName")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "resourceGroupName", valid_594189
  var valid_594190 = path.getOrDefault("streamingEndpointName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "streamingEndpointName", valid_594190
  var valid_594191 = path.getOrDefault("subscriptionId")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "subscriptionId", valid_594191
  var valid_594192 = path.getOrDefault("accountName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "accountName", valid_594192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : StreamingEndpoint scale parameters
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594195: Call_StreamingEndpointsScale_594186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scales an existing StreamingEndpoint.
  ## 
  let valid = call_594195.validator(path, query, header, formData, body)
  let scheme = call_594195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594195.url(scheme.get, call_594195.host, call_594195.base,
                         call_594195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594195, url, valid)

proc call*(call_594196: Call_StreamingEndpointsScale_594186;
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
  var path_594197 = newJObject()
  var query_594198 = newJObject()
  var body_594199 = newJObject()
  add(path_594197, "resourceGroupName", newJString(resourceGroupName))
  add(query_594198, "api-version", newJString(apiVersion))
  add(path_594197, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_594197, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594199 = parameters
  add(path_594197, "accountName", newJString(accountName))
  result = call_594196.call(path_594197, query_594198, nil, nil, body_594199)

var streamingEndpointsScale* = Call_StreamingEndpointsScale_594186(
    name: "streamingEndpointsScale", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}/scale",
    validator: validate_StreamingEndpointsScale_594187, base: "",
    url: url_StreamingEndpointsScale_594188, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsStart_594200 = ref object of OpenApiRestCall_593425
proc url_StreamingEndpointsStart_594202(protocol: Scheme; host: string; base: string;
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

proc validate_StreamingEndpointsStart_594201(path: JsonNode; query: JsonNode;
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
  var valid_594203 = path.getOrDefault("resourceGroupName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "resourceGroupName", valid_594203
  var valid_594204 = path.getOrDefault("streamingEndpointName")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "streamingEndpointName", valid_594204
  var valid_594205 = path.getOrDefault("subscriptionId")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "subscriptionId", valid_594205
  var valid_594206 = path.getOrDefault("accountName")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "accountName", valid_594206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594207 = query.getOrDefault("api-version")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "api-version", valid_594207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594208: Call_StreamingEndpointsStart_594200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an existing StreamingEndpoint.
  ## 
  let valid = call_594208.validator(path, query, header, formData, body)
  let scheme = call_594208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594208.url(scheme.get, call_594208.host, call_594208.base,
                         call_594208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594208, url, valid)

proc call*(call_594209: Call_StreamingEndpointsStart_594200;
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
  var path_594210 = newJObject()
  var query_594211 = newJObject()
  add(path_594210, "resourceGroupName", newJString(resourceGroupName))
  add(query_594211, "api-version", newJString(apiVersion))
  add(path_594210, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_594210, "subscriptionId", newJString(subscriptionId))
  add(path_594210, "accountName", newJString(accountName))
  result = call_594209.call(path_594210, query_594211, nil, nil, nil)

var streamingEndpointsStart* = Call_StreamingEndpointsStart_594200(
    name: "streamingEndpointsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}/start",
    validator: validate_StreamingEndpointsStart_594201, base: "",
    url: url_StreamingEndpointsStart_594202, schemes: {Scheme.Https})
type
  Call_StreamingEndpointsStop_594212 = ref object of OpenApiRestCall_593425
proc url_StreamingEndpointsStop_594214(protocol: Scheme; host: string; base: string;
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

proc validate_StreamingEndpointsStop_594213(path: JsonNode; query: JsonNode;
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
  var valid_594215 = path.getOrDefault("resourceGroupName")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "resourceGroupName", valid_594215
  var valid_594216 = path.getOrDefault("streamingEndpointName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "streamingEndpointName", valid_594216
  var valid_594217 = path.getOrDefault("subscriptionId")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "subscriptionId", valid_594217
  var valid_594218 = path.getOrDefault("accountName")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "accountName", valid_594218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594219 = query.getOrDefault("api-version")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "api-version", valid_594219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594220: Call_StreamingEndpointsStop_594212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops an existing StreamingEndpoint.
  ## 
  let valid = call_594220.validator(path, query, header, formData, body)
  let scheme = call_594220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594220.url(scheme.get, call_594220.host, call_594220.base,
                         call_594220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594220, url, valid)

proc call*(call_594221: Call_StreamingEndpointsStop_594212;
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
  var path_594222 = newJObject()
  var query_594223 = newJObject()
  add(path_594222, "resourceGroupName", newJString(resourceGroupName))
  add(query_594223, "api-version", newJString(apiVersion))
  add(path_594222, "streamingEndpointName", newJString(streamingEndpointName))
  add(path_594222, "subscriptionId", newJString(subscriptionId))
  add(path_594222, "accountName", newJString(accountName))
  result = call_594221.call(path_594222, query_594223, nil, nil, nil)

var streamingEndpointsStop* = Call_StreamingEndpointsStop_594212(
    name: "streamingEndpointsStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Media/mediaservices/{accountName}/streamingEndpoints/{streamingEndpointName}/stop",
    validator: validate_StreamingEndpointsStop_594213, base: "",
    url: url_StreamingEndpointsStop_594214, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
