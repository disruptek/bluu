
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Personalizer Client
## version: v1.0
## termsOfService: (not provided)
## license: (not provided)
## 
## Personalizer Service is an Azure Cognitive Service that makes it easy to target content and experiences without complex pre-analysis or cleanup of past data. Given a context and featurized content, the Personalizer Service returns your content in a ranked list. As rewards are sent in response to the ranked list, the reinforcement learning algorithm will improve the model and improve performance of future rank calls.
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
  macServiceName = "cognitiveservices-Personalizer"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_EventsActivate_567880 = ref object of OpenApiRestCall_567658
proc url_EventsActivate_567882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "eventId" in path, "`eventId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/events/"),
               (kind: VariableSegment, value: "eventId"),
               (kind: ConstantSegment, value: "/activate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsActivate_567881(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eventId: JString (required)
  ##          : The event ID this activation applies to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `eventId` field"
  var valid_568042 = path.getOrDefault("eventId")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "eventId", valid_568042
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568069: Call_EventsActivate_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568069.validator(path, query, header, formData, body)
  let scheme = call_568069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568069.url(scheme.get, call_568069.host, call_568069.base,
                         call_568069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568069, url, valid)

proc call*(call_568140: Call_EventsActivate_567880; eventId: string): Recallable =
  ## eventsActivate
  ##   eventId: string (required)
  ##          : The event ID this activation applies to.
  var path_568141 = newJObject()
  add(path_568141, "eventId", newJString(eventId))
  result = call_568140.call(path_568141, nil, nil, nil, nil)

var eventsActivate* = Call_EventsActivate_567880(name: "eventsActivate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/events/{eventId}/activate", validator: validate_EventsActivate_567881,
    base: "/personalizer/v1.0", url: url_EventsActivate_567882,
    schemes: {Scheme.Https})
type
  Call_EventsReward_568181 = ref object of OpenApiRestCall_567658
proc url_EventsReward_568183(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "eventId" in path, "`eventId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/events/"),
               (kind: VariableSegment, value: "eventId"),
               (kind: ConstantSegment, value: "/reward")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsReward_568182(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eventId: JString (required)
  ##          : The event id this reward applies to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `eventId` field"
  var valid_568193 = path.getOrDefault("eventId")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "eventId", valid_568193
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   reward: JObject (required)
  ##         : The reward should be a floating point number.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568195: Call_EventsReward_568181; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568195.validator(path, query, header, formData, body)
  let scheme = call_568195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568195.url(scheme.get, call_568195.host, call_568195.base,
                         call_568195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568195, url, valid)

proc call*(call_568196: Call_EventsReward_568181; eventId: string; reward: JsonNode): Recallable =
  ## eventsReward
  ##   eventId: string (required)
  ##          : The event id this reward applies to.
  ##   reward: JObject (required)
  ##         : The reward should be a floating point number.
  var path_568197 = newJObject()
  var body_568198 = newJObject()
  add(path_568197, "eventId", newJString(eventId))
  if reward != nil:
    body_568198 = reward
  result = call_568196.call(path_568197, nil, nil, nil, body_568198)

var eventsReward* = Call_EventsReward_568181(name: "eventsReward",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/events/{eventId}/reward", validator: validate_EventsReward_568182,
    base: "/personalizer/v1.0", url: url_EventsReward_568183,
    schemes: {Scheme.Https})
type
  Call_Rank_568199 = ref object of OpenApiRestCall_567658
proc url_Rank_568201(protocol: Scheme; host: string; base: string; route: string;
                    path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_Rank_568200(path: JsonNode; query: JsonNode; header: JsonNode;
                         formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   rankRequest: JObject (required)
  ##              : A Personalizer request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568203: Call_Rank_568199; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568203.validator(path, query, header, formData, body)
  let scheme = call_568203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568203.url(scheme.get, call_568203.host, call_568203.base,
                         call_568203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568203, url, valid)

proc call*(call_568204: Call_Rank_568199; rankRequest: JsonNode): Recallable =
  ## rank
  ##   rankRequest: JObject (required)
  ##              : A Personalizer request.
  var body_568205 = newJObject()
  if rankRequest != nil:
    body_568205 = rankRequest
  result = call_568204.call(nil, nil, nil, nil, body_568205)

var rank* = Call_Rank_568199(name: "rank", meth: HttpMethod.HttpPost,
                          host: "azure.local", route: "/rank",
                          validator: validate_Rank_568200,
                          base: "/personalizer/v1.0", url: url_Rank_568201,
                          schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
