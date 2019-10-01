
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Language Understanding Intelligent Service (LUIS) Endpoint API for running predictions and extracting user intentions and entities from utterances.
## version: v2.0 preview
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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
  macServiceName = "cognitiveservices-LUIS-Runtime"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PredictionResolve_568189 = ref object of OpenApiRestCall_567658
proc url_PredictionResolve_568191(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "appId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionResolve_568190(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The LUIS application ID (Guid).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568201 = path.getOrDefault("appId")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "appId", valid_568201
  result.add "path", section
  ## parameters in `query` object:
  ##   verbose: JBool
  ##          : If true, return all intents instead of just the top scoring intent.
  ##   staging: JBool
  ##          : Use the staging endpoint slot.
  ##   log: JBool
  ##      : Log query (default is true)
  ##   spellCheck: JBool
  ##             : Enable spell checking.
  ##   bing-spell-check-subscription-key: JString
  ##                                    : The subscription key to use when enabling bing spell check
  ##   timezoneOffset: JFloat
  ##                 : The timezone offset for the location of the request.
  section = newJObject()
  var valid_568202 = query.getOrDefault("verbose")
  valid_568202 = validateParameter(valid_568202, JBool, required = false, default = nil)
  if valid_568202 != nil:
    section.add "verbose", valid_568202
  var valid_568203 = query.getOrDefault("staging")
  valid_568203 = validateParameter(valid_568203, JBool, required = false, default = nil)
  if valid_568203 != nil:
    section.add "staging", valid_568203
  var valid_568204 = query.getOrDefault("log")
  valid_568204 = validateParameter(valid_568204, JBool, required = false, default = nil)
  if valid_568204 != nil:
    section.add "log", valid_568204
  var valid_568205 = query.getOrDefault("spellCheck")
  valid_568205 = validateParameter(valid_568205, JBool, required = false, default = nil)
  if valid_568205 != nil:
    section.add "spellCheck", valid_568205
  var valid_568206 = query.getOrDefault("bing-spell-check-subscription-key")
  valid_568206 = validateParameter(valid_568206, JString, required = false,
                                 default = nil)
  if valid_568206 != nil:
    section.add "bing-spell-check-subscription-key", valid_568206
  var valid_568207 = query.getOrDefault("timezoneOffset")
  valid_568207 = validateParameter(valid_568207, JFloat, required = false,
                                 default = nil)
  if valid_568207 != nil:
    section.add "timezoneOffset", valid_568207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   q: JString (required)
  ##    : The utterance to predict.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JString, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568209: Call_PredictionResolve_568189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ## 
  let valid = call_568209.validator(path, query, header, formData, body)
  let scheme = call_568209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568209.url(scheme.get, call_568209.host, call_568209.base,
                         call_568209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568209, url, valid)

proc call*(call_568210: Call_PredictionResolve_568189; appId: string; q: JsonNode;
          verbose: bool = false; staging: bool = false; log: bool = false;
          spellCheck: bool = false; bingSpellCheckSubscriptionKey: string = "";
          timezoneOffset: float = 0.0): Recallable =
  ## predictionResolve
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ##   verbose: bool
  ##          : If true, return all intents instead of just the top scoring intent.
  ##   appId: string (required)
  ##        : The LUIS application ID (Guid).
  ##   staging: bool
  ##          : Use the staging endpoint slot.
  ##   log: bool
  ##      : Log query (default is true)
  ##   q: JString (required)
  ##    : The utterance to predict.
  ##   spellCheck: bool
  ##             : Enable spell checking.
  ##   bingSpellCheckSubscriptionKey: string
  ##                                : The subscription key to use when enabling bing spell check
  ##   timezoneOffset: float
  ##                 : The timezone offset for the location of the request.
  var path_568211 = newJObject()
  var query_568212 = newJObject()
  var body_568213 = newJObject()
  add(query_568212, "verbose", newJBool(verbose))
  add(path_568211, "appId", newJString(appId))
  add(query_568212, "staging", newJBool(staging))
  add(query_568212, "log", newJBool(log))
  if q != nil:
    body_568213 = q
  add(query_568212, "spellCheck", newJBool(spellCheck))
  add(query_568212, "bing-spell-check-subscription-key",
      newJString(bingSpellCheckSubscriptionKey))
  add(query_568212, "timezoneOffset", newJFloat(timezoneOffset))
  result = call_568210.call(path_568211, query_568212, nil, nil, body_568213)

var predictionResolve* = Call_PredictionResolve_568189(name: "predictionResolve",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/{appId}",
    validator: validate_PredictionResolve_568190, base: "/luis/v2.0/apps",
    url: url_PredictionResolve_568191, schemes: {Scheme.Https})
type
  Call_PredictionResolve2_567880 = ref object of OpenApiRestCall_567658
proc url_PredictionResolve2_567882(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "appId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionResolve2_567881(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The LUIS application ID (guid).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568042 = path.getOrDefault("appId")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "appId", valid_568042
  result.add "path", section
  ## parameters in `query` object:
  ##   verbose: JBool
  ##          : If true, return all intents instead of just the top scoring intent.
  ##   staging: JBool
  ##          : Use the staging endpoint slot.
  ##   log: JBool
  ##      : Log query (default is true)
  ##   q: JString (required)
  ##    : The utterance to predict.
  ##   spellCheck: JBool
  ##             : Enable spell checking.
  ##   bing-spell-check-subscription-key: JString
  ##                                    : The subscription key to use when enabling bing spell check
  ##   timezoneOffset: JFloat
  ##                 : The timezone offset for the location of the request.
  section = newJObject()
  var valid_568043 = query.getOrDefault("verbose")
  valid_568043 = validateParameter(valid_568043, JBool, required = false, default = nil)
  if valid_568043 != nil:
    section.add "verbose", valid_568043
  var valid_568044 = query.getOrDefault("staging")
  valid_568044 = validateParameter(valid_568044, JBool, required = false, default = nil)
  if valid_568044 != nil:
    section.add "staging", valid_568044
  var valid_568045 = query.getOrDefault("log")
  valid_568045 = validateParameter(valid_568045, JBool, required = false, default = nil)
  if valid_568045 != nil:
    section.add "log", valid_568045
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_568046 = query.getOrDefault("q")
  valid_568046 = validateParameter(valid_568046, JString, required = true,
                                 default = nil)
  if valid_568046 != nil:
    section.add "q", valid_568046
  var valid_568047 = query.getOrDefault("spellCheck")
  valid_568047 = validateParameter(valid_568047, JBool, required = false, default = nil)
  if valid_568047 != nil:
    section.add "spellCheck", valid_568047
  var valid_568048 = query.getOrDefault("bing-spell-check-subscription-key")
  valid_568048 = validateParameter(valid_568048, JString, required = false,
                                 default = nil)
  if valid_568048 != nil:
    section.add "bing-spell-check-subscription-key", valid_568048
  var valid_568049 = query.getOrDefault("timezoneOffset")
  valid_568049 = validateParameter(valid_568049, JFloat, required = false,
                                 default = nil)
  if valid_568049 != nil:
    section.add "timezoneOffset", valid_568049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568076: Call_PredictionResolve2_567880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ## 
  let valid = call_568076.validator(path, query, header, formData, body)
  let scheme = call_568076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568076.url(scheme.get, call_568076.host, call_568076.base,
                         call_568076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568076, url, valid)

proc call*(call_568147: Call_PredictionResolve2_567880; appId: string; q: string;
          verbose: bool = false; staging: bool = false; log: bool = false;
          spellCheck: bool = false; bingSpellCheckSubscriptionKey: string = "";
          timezoneOffset: float = 0.0): Recallable =
  ## predictionResolve2
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ##   verbose: bool
  ##          : If true, return all intents instead of just the top scoring intent.
  ##   appId: string (required)
  ##        : The LUIS application ID (guid).
  ##   staging: bool
  ##          : Use the staging endpoint slot.
  ##   log: bool
  ##      : Log query (default is true)
  ##   q: string (required)
  ##    : The utterance to predict.
  ##   spellCheck: bool
  ##             : Enable spell checking.
  ##   bingSpellCheckSubscriptionKey: string
  ##                                : The subscription key to use when enabling bing spell check
  ##   timezoneOffset: float
  ##                 : The timezone offset for the location of the request.
  var path_568148 = newJObject()
  var query_568150 = newJObject()
  add(query_568150, "verbose", newJBool(verbose))
  add(path_568148, "appId", newJString(appId))
  add(query_568150, "staging", newJBool(staging))
  add(query_568150, "log", newJBool(log))
  add(query_568150, "q", newJString(q))
  add(query_568150, "spellCheck", newJBool(spellCheck))
  add(query_568150, "bing-spell-check-subscription-key",
      newJString(bingSpellCheckSubscriptionKey))
  add(query_568150, "timezoneOffset", newJFloat(timezoneOffset))
  result = call_568147.call(path_568148, query_568150, nil, nil, nil)

var predictionResolve2* = Call_PredictionResolve2_567880(
    name: "predictionResolve2", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/{appId}", validator: validate_PredictionResolve2_567881,
    base: "/luis/v2.0/apps", url: url_PredictionResolve2_567882,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
