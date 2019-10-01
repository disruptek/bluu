
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2015-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## API spec for Microsoft.Security (Azure Security Center) resource provider
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "security-applicationWhitelistings"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdaptiveApplicationControlsList_567879 = ref object of OpenApiRestCall_567657
proc url_AdaptiveApplicationControlsList_567881(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/applicationWhitelistings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdaptiveApplicationControlsList_567880(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of application control VM/server groups for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568054 = path.getOrDefault("subscriptionId")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = nil)
  if valid_568054 != nil:
    section.add "subscriptionId", valid_568054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   summary: JBool
  ##          : Return output in a summarized form
  ##   includePathRecommendations: JBool
  ##                             : Include the policy rules
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568055 = query.getOrDefault("api-version")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "api-version", valid_568055
  var valid_568056 = query.getOrDefault("summary")
  valid_568056 = validateParameter(valid_568056, JBool, required = false, default = nil)
  if valid_568056 != nil:
    section.add "summary", valid_568056
  var valid_568057 = query.getOrDefault("includePathRecommendations")
  valid_568057 = validateParameter(valid_568057, JBool, required = false, default = nil)
  if valid_568057 != nil:
    section.add "includePathRecommendations", valid_568057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568080: Call_AdaptiveApplicationControlsList_567879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of application control VM/server groups for the subscription.
  ## 
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_AdaptiveApplicationControlsList_567879;
          apiVersion: string; subscriptionId: string; summary: bool = false;
          includePathRecommendations: bool = false): Recallable =
  ## adaptiveApplicationControlsList
  ## Gets a list of application control VM/server groups for the subscription.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   summary: bool
  ##          : Return output in a summarized form
  ##   includePathRecommendations: bool
  ##                             : Include the policy rules
  var path_568152 = newJObject()
  var query_568154 = newJObject()
  add(query_568154, "api-version", newJString(apiVersion))
  add(path_568152, "subscriptionId", newJString(subscriptionId))
  add(query_568154, "summary", newJBool(summary))
  add(query_568154, "includePathRecommendations",
      newJBool(includePathRecommendations))
  result = call_568151.call(path_568152, query_568154, nil, nil, nil)

var adaptiveApplicationControlsList* = Call_AdaptiveApplicationControlsList_567879(
    name: "adaptiveApplicationControlsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/applicationWhitelistings",
    validator: validate_AdaptiveApplicationControlsList_567880, base: "",
    url: url_AdaptiveApplicationControlsList_567881, schemes: {Scheme.Https})
type
  Call_AdaptiveApplicationControlsPut_568204 = ref object of OpenApiRestCall_567657
proc url_AdaptiveApplicationControlsPut_568206(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/applicationWhitelistings/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdaptiveApplicationControlsPut_568205(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an application control VM/server group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   groupName: JString (required)
  ##            : Name of an application control VM/server group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_568207 = path.getOrDefault("ascLocation")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "ascLocation", valid_568207
  var valid_568208 = path.getOrDefault("subscriptionId")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "subscriptionId", valid_568208
  var valid_568209 = path.getOrDefault("groupName")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "groupName", valid_568209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568210 = query.getOrDefault("api-version")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "api-version", valid_568210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The updated VM/server group data
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568212: Call_AdaptiveApplicationControlsPut_568204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an application control VM/server group
  ## 
  let valid = call_568212.validator(path, query, header, formData, body)
  let scheme = call_568212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568212.url(scheme.get, call_568212.host, call_568212.base,
                         call_568212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568212, url, valid)

proc call*(call_568213: Call_AdaptiveApplicationControlsPut_568204;
          apiVersion: string; ascLocation: string; subscriptionId: string;
          groupName: string; body: JsonNode): Recallable =
  ## adaptiveApplicationControlsPut
  ## Update an application control VM/server group
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   groupName: string (required)
  ##            : Name of an application control VM/server group
  ##   body: JObject (required)
  ##       : The updated VM/server group data
  var path_568214 = newJObject()
  var query_568215 = newJObject()
  var body_568216 = newJObject()
  add(query_568215, "api-version", newJString(apiVersion))
  add(path_568214, "ascLocation", newJString(ascLocation))
  add(path_568214, "subscriptionId", newJString(subscriptionId))
  add(path_568214, "groupName", newJString(groupName))
  if body != nil:
    body_568216 = body
  result = call_568213.call(path_568214, query_568215, nil, nil, body_568216)

var adaptiveApplicationControlsPut* = Call_AdaptiveApplicationControlsPut_568204(
    name: "adaptiveApplicationControlsPut", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/applicationWhitelistings/{groupName}",
    validator: validate_AdaptiveApplicationControlsPut_568205, base: "",
    url: url_AdaptiveApplicationControlsPut_568206, schemes: {Scheme.Https})
type
  Call_AdaptiveApplicationControlsGet_568193 = ref object of OpenApiRestCall_567657
proc url_AdaptiveApplicationControlsGet_568195(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/applicationWhitelistings/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdaptiveApplicationControlsGet_568194(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an application control VM/server group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   groupName: JString (required)
  ##            : Name of an application control VM/server group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_568196 = path.getOrDefault("ascLocation")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "ascLocation", valid_568196
  var valid_568197 = path.getOrDefault("subscriptionId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "subscriptionId", valid_568197
  var valid_568198 = path.getOrDefault("groupName")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "groupName", valid_568198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568199 = query.getOrDefault("api-version")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "api-version", valid_568199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568200: Call_AdaptiveApplicationControlsGet_568193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an application control VM/server group.
  ## 
  let valid = call_568200.validator(path, query, header, formData, body)
  let scheme = call_568200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568200.url(scheme.get, call_568200.host, call_568200.base,
                         call_568200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568200, url, valid)

proc call*(call_568201: Call_AdaptiveApplicationControlsGet_568193;
          apiVersion: string; ascLocation: string; subscriptionId: string;
          groupName: string): Recallable =
  ## adaptiveApplicationControlsGet
  ## Gets an application control VM/server group.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   groupName: string (required)
  ##            : Name of an application control VM/server group
  var path_568202 = newJObject()
  var query_568203 = newJObject()
  add(query_568203, "api-version", newJString(apiVersion))
  add(path_568202, "ascLocation", newJString(ascLocation))
  add(path_568202, "subscriptionId", newJString(subscriptionId))
  add(path_568202, "groupName", newJString(groupName))
  result = call_568201.call(path_568202, query_568203, nil, nil, nil)

var adaptiveApplicationControlsGet* = Call_AdaptiveApplicationControlsGet_568193(
    name: "adaptiveApplicationControlsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/applicationWhitelistings/{groupName}",
    validator: validate_AdaptiveApplicationControlsGet_568194, base: "",
    url: url_AdaptiveApplicationControlsGet_568195, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
