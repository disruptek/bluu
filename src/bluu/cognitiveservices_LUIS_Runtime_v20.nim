
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Language Understanding Intelligent Service (LUIS) Endpoint API for running predictions and extracting user intentions and entities from utterances.
## version: v2.0
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
  macServiceName = "cognitiveservices-LUIS-Runtime"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PredictionResolve_564089 = ref object of OpenApiRestCall_563556
proc url_PredictionResolve_564091(protocol: Scheme; host: string; base: string;
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

proc validate_PredictionResolve_564090(path: JsonNode; query: JsonNode;
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
  var valid_564101 = path.getOrDefault("appId")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "appId", valid_564101
  result.add "path", section
  ## parameters in `query` object:
  ##   bing-spell-check-subscription-key: JString
  ##                                    : The subscription key to use when enabling bing spell check
  ##   verbose: JBool
  ##          : If true, return all intents instead of just the top scoring intent.
  ##   log: JBool
  ##      : Log query (default is true)
  ##   staging: JBool
  ##          : Use the staging endpoint slot.
  ##   spellCheck: JBool
  ##             : Enable spell checking.
  ##   timezoneOffset: JFloat
  ##                 : The timezone offset for the location of the request.
  section = newJObject()
  var valid_564102 = query.getOrDefault("bing-spell-check-subscription-key")
  valid_564102 = validateParameter(valid_564102, JString, required = false,
                                 default = nil)
  if valid_564102 != nil:
    section.add "bing-spell-check-subscription-key", valid_564102
  var valid_564103 = query.getOrDefault("verbose")
  valid_564103 = validateParameter(valid_564103, JBool, required = false, default = nil)
  if valid_564103 != nil:
    section.add "verbose", valid_564103
  var valid_564104 = query.getOrDefault("log")
  valid_564104 = validateParameter(valid_564104, JBool, required = false, default = nil)
  if valid_564104 != nil:
    section.add "log", valid_564104
  var valid_564105 = query.getOrDefault("staging")
  valid_564105 = validateParameter(valid_564105, JBool, required = false, default = nil)
  if valid_564105 != nil:
    section.add "staging", valid_564105
  var valid_564106 = query.getOrDefault("spellCheck")
  valid_564106 = validateParameter(valid_564106, JBool, required = false, default = nil)
  if valid_564106 != nil:
    section.add "spellCheck", valid_564106
  var valid_564107 = query.getOrDefault("timezoneOffset")
  valid_564107 = validateParameter(valid_564107, JFloat, required = false,
                                 default = nil)
  if valid_564107 != nil:
    section.add "timezoneOffset", valid_564107
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

proc call*(call_564109: Call_PredictionResolve_564089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ## 
  let valid = call_564109.validator(path, query, header, formData, body)
  let scheme = call_564109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564109.url(scheme.get, call_564109.host, call_564109.base,
                         call_564109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564109, url, valid)

proc call*(call_564110: Call_PredictionResolve_564089; q: JsonNode; appId: string;
          bingSpellCheckSubscriptionKey: string = ""; verbose: bool = false;
          log: bool = false; staging: bool = false; spellCheck: bool = false;
          timezoneOffset: float = 0.0): Recallable =
  ## predictionResolve
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ##   bingSpellCheckSubscriptionKey: string
  ##                                : The subscription key to use when enabling bing spell check
  ##   verbose: bool
  ##          : If true, return all intents instead of just the top scoring intent.
  ##   q: JString (required)
  ##    : The utterance to predict.
  ##   log: bool
  ##      : Log query (default is true)
  ##   staging: bool
  ##          : Use the staging endpoint slot.
  ##   appId: string (required)
  ##        : The LUIS application ID (Guid).
  ##   spellCheck: bool
  ##             : Enable spell checking.
  ##   timezoneOffset: float
  ##                 : The timezone offset for the location of the request.
  var path_564111 = newJObject()
  var query_564112 = newJObject()
  var body_564113 = newJObject()
  add(query_564112, "bing-spell-check-subscription-key",
      newJString(bingSpellCheckSubscriptionKey))
  add(query_564112, "verbose", newJBool(verbose))
  if q != nil:
    body_564113 = q
  add(query_564112, "log", newJBool(log))
  add(query_564112, "staging", newJBool(staging))
  add(path_564111, "appId", newJString(appId))
  add(query_564112, "spellCheck", newJBool(spellCheck))
  add(query_564112, "timezoneOffset", newJFloat(timezoneOffset))
  result = call_564110.call(path_564111, query_564112, nil, nil, body_564113)

var predictionResolve* = Call_PredictionResolve_564089(name: "predictionResolve",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/{appId}",
    validator: validate_PredictionResolve_564090, base: "/luis/v2.0/apps",
    url: url_PredictionResolve_564091, schemes: {Scheme.Https})
type
  Call_PredictionResolve2_563778 = ref object of OpenApiRestCall_563556
proc url_PredictionResolve2_563780(protocol: Scheme; host: string; base: string;
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

proc validate_PredictionResolve2_563779(path: JsonNode; query: JsonNode;
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
  var valid_563942 = path.getOrDefault("appId")
  valid_563942 = validateParameter(valid_563942, JString, required = true,
                                 default = nil)
  if valid_563942 != nil:
    section.add "appId", valid_563942
  result.add "path", section
  ## parameters in `query` object:
  ##   q: JString (required)
  ##    : The utterance to predict.
  ##   bing-spell-check-subscription-key: JString
  ##                                    : The subscription key to use when enabling bing spell check
  ##   verbose: JBool
  ##          : If true, return all intents instead of just the top scoring intent.
  ##   log: JBool
  ##      : Log query (default is true)
  ##   staging: JBool
  ##          : Use the staging endpoint slot.
  ##   spellCheck: JBool
  ##             : Enable spell checking.
  ##   timezoneOffset: JFloat
  ##                 : The timezone offset for the location of the request.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_563943 = query.getOrDefault("q")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "q", valid_563943
  var valid_563944 = query.getOrDefault("bing-spell-check-subscription-key")
  valid_563944 = validateParameter(valid_563944, JString, required = false,
                                 default = nil)
  if valid_563944 != nil:
    section.add "bing-spell-check-subscription-key", valid_563944
  var valid_563945 = query.getOrDefault("verbose")
  valid_563945 = validateParameter(valid_563945, JBool, required = false, default = nil)
  if valid_563945 != nil:
    section.add "verbose", valid_563945
  var valid_563946 = query.getOrDefault("log")
  valid_563946 = validateParameter(valid_563946, JBool, required = false, default = nil)
  if valid_563946 != nil:
    section.add "log", valid_563946
  var valid_563947 = query.getOrDefault("staging")
  valid_563947 = validateParameter(valid_563947, JBool, required = false, default = nil)
  if valid_563947 != nil:
    section.add "staging", valid_563947
  var valid_563948 = query.getOrDefault("spellCheck")
  valid_563948 = validateParameter(valid_563948, JBool, required = false, default = nil)
  if valid_563948 != nil:
    section.add "spellCheck", valid_563948
  var valid_563949 = query.getOrDefault("timezoneOffset")
  valid_563949 = validateParameter(valid_563949, JFloat, required = false,
                                 default = nil)
  if valid_563949 != nil:
    section.add "timezoneOffset", valid_563949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563976: Call_PredictionResolve2_563778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ## 
  let valid = call_563976.validator(path, query, header, formData, body)
  let scheme = call_563976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563976.url(scheme.get, call_563976.host, call_563976.base,
                         call_563976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563976, url, valid)

proc call*(call_564047: Call_PredictionResolve2_563778; q: string; appId: string;
          bingSpellCheckSubscriptionKey: string = ""; verbose: bool = false;
          log: bool = false; staging: bool = false; spellCheck: bool = false;
          timezoneOffset: float = 0.0): Recallable =
  ## predictionResolve2
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ##   q: string (required)
  ##    : The utterance to predict.
  ##   bingSpellCheckSubscriptionKey: string
  ##                                : The subscription key to use when enabling bing spell check
  ##   verbose: bool
  ##          : If true, return all intents instead of just the top scoring intent.
  ##   log: bool
  ##      : Log query (default is true)
  ##   staging: bool
  ##          : Use the staging endpoint slot.
  ##   appId: string (required)
  ##        : The LUIS application ID (guid).
  ##   spellCheck: bool
  ##             : Enable spell checking.
  ##   timezoneOffset: float
  ##                 : The timezone offset for the location of the request.
  var path_564048 = newJObject()
  var query_564050 = newJObject()
  add(query_564050, "q", newJString(q))
  add(query_564050, "bing-spell-check-subscription-key",
      newJString(bingSpellCheckSubscriptionKey))
  add(query_564050, "verbose", newJBool(verbose))
  add(query_564050, "log", newJBool(log))
  add(query_564050, "staging", newJBool(staging))
  add(path_564048, "appId", newJString(appId))
  add(query_564050, "spellCheck", newJBool(spellCheck))
  add(query_564050, "timezoneOffset", newJFloat(timezoneOffset))
  result = call_564047.call(path_564048, query_564050, nil, nil, nil)

var predictionResolve2* = Call_PredictionResolve2_563778(
    name: "predictionResolve2", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/{appId}", validator: validate_PredictionResolve2_563779,
    base: "/luis/v2.0/apps", url: url_PredictionResolve2_563780,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
