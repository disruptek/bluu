
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

  OpenApiRestCall_574458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574458): Option[Scheme] {.used.} =
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
  Call_PredictionResolve_574989 = ref object of OpenApiRestCall_574458
proc url_PredictionResolve_574991(protocol: Scheme; host: string; base: string;
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

proc validate_PredictionResolve_574990(path: JsonNode; query: JsonNode;
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
  var valid_575001 = path.getOrDefault("appId")
  valid_575001 = validateParameter(valid_575001, JString, required = true,
                                 default = nil)
  if valid_575001 != nil:
    section.add "appId", valid_575001
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
  var valid_575002 = query.getOrDefault("verbose")
  valid_575002 = validateParameter(valid_575002, JBool, required = false, default = nil)
  if valid_575002 != nil:
    section.add "verbose", valid_575002
  var valid_575003 = query.getOrDefault("staging")
  valid_575003 = validateParameter(valid_575003, JBool, required = false, default = nil)
  if valid_575003 != nil:
    section.add "staging", valid_575003
  var valid_575004 = query.getOrDefault("log")
  valid_575004 = validateParameter(valid_575004, JBool, required = false, default = nil)
  if valid_575004 != nil:
    section.add "log", valid_575004
  var valid_575005 = query.getOrDefault("spellCheck")
  valid_575005 = validateParameter(valid_575005, JBool, required = false, default = nil)
  if valid_575005 != nil:
    section.add "spellCheck", valid_575005
  var valid_575006 = query.getOrDefault("bing-spell-check-subscription-key")
  valid_575006 = validateParameter(valid_575006, JString, required = false,
                                 default = nil)
  if valid_575006 != nil:
    section.add "bing-spell-check-subscription-key", valid_575006
  var valid_575007 = query.getOrDefault("timezoneOffset")
  valid_575007 = validateParameter(valid_575007, JFloat, required = false,
                                 default = nil)
  if valid_575007 != nil:
    section.add "timezoneOffset", valid_575007
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

proc call*(call_575009: Call_PredictionResolve_574989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ## 
  let valid = call_575009.validator(path, query, header, formData, body)
  let scheme = call_575009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575009.url(scheme.get, call_575009.host, call_575009.base,
                         call_575009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575009, url, valid)

proc call*(call_575010: Call_PredictionResolve_574989; appId: string; q: JsonNode;
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
  var path_575011 = newJObject()
  var query_575012 = newJObject()
  var body_575013 = newJObject()
  add(query_575012, "verbose", newJBool(verbose))
  add(path_575011, "appId", newJString(appId))
  add(query_575012, "staging", newJBool(staging))
  add(query_575012, "log", newJBool(log))
  if q != nil:
    body_575013 = q
  add(query_575012, "spellCheck", newJBool(spellCheck))
  add(query_575012, "bing-spell-check-subscription-key",
      newJString(bingSpellCheckSubscriptionKey))
  add(query_575012, "timezoneOffset", newJFloat(timezoneOffset))
  result = call_575010.call(path_575011, query_575012, nil, nil, body_575013)

var predictionResolve* = Call_PredictionResolve_574989(name: "predictionResolve",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/{appId}",
    validator: validate_PredictionResolve_574990, base: "/luis/v2.0/apps",
    url: url_PredictionResolve_574991, schemes: {Scheme.Https})
type
  Call_PredictionResolve2_574680 = ref object of OpenApiRestCall_574458
proc url_PredictionResolve2_574682(protocol: Scheme; host: string; base: string;
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

proc validate_PredictionResolve2_574681(path: JsonNode; query: JsonNode;
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
  var valid_574842 = path.getOrDefault("appId")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = nil)
  if valid_574842 != nil:
    section.add "appId", valid_574842
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
  var valid_574843 = query.getOrDefault("verbose")
  valid_574843 = validateParameter(valid_574843, JBool, required = false, default = nil)
  if valid_574843 != nil:
    section.add "verbose", valid_574843
  var valid_574844 = query.getOrDefault("staging")
  valid_574844 = validateParameter(valid_574844, JBool, required = false, default = nil)
  if valid_574844 != nil:
    section.add "staging", valid_574844
  var valid_574845 = query.getOrDefault("log")
  valid_574845 = validateParameter(valid_574845, JBool, required = false, default = nil)
  if valid_574845 != nil:
    section.add "log", valid_574845
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_574846 = query.getOrDefault("q")
  valid_574846 = validateParameter(valid_574846, JString, required = true,
                                 default = nil)
  if valid_574846 != nil:
    section.add "q", valid_574846
  var valid_574847 = query.getOrDefault("spellCheck")
  valid_574847 = validateParameter(valid_574847, JBool, required = false, default = nil)
  if valid_574847 != nil:
    section.add "spellCheck", valid_574847
  var valid_574848 = query.getOrDefault("bing-spell-check-subscription-key")
  valid_574848 = validateParameter(valid_574848, JString, required = false,
                                 default = nil)
  if valid_574848 != nil:
    section.add "bing-spell-check-subscription-key", valid_574848
  var valid_574849 = query.getOrDefault("timezoneOffset")
  valid_574849 = validateParameter(valid_574849, JFloat, required = false,
                                 default = nil)
  if valid_574849 != nil:
    section.add "timezoneOffset", valid_574849
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574876: Call_PredictionResolve2_574680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ## 
  let valid = call_574876.validator(path, query, header, formData, body)
  let scheme = call_574876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574876.url(scheme.get, call_574876.host, call_574876.base,
                         call_574876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574876, url, valid)

proc call*(call_574947: Call_PredictionResolve2_574680; appId: string; q: string;
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
  var path_574948 = newJObject()
  var query_574950 = newJObject()
  add(query_574950, "verbose", newJBool(verbose))
  add(path_574948, "appId", newJString(appId))
  add(query_574950, "staging", newJBool(staging))
  add(query_574950, "log", newJBool(log))
  add(query_574950, "q", newJString(q))
  add(query_574950, "spellCheck", newJBool(spellCheck))
  add(query_574950, "bing-spell-check-subscription-key",
      newJString(bingSpellCheckSubscriptionKey))
  add(query_574950, "timezoneOffset", newJFloat(timezoneOffset))
  result = call_574947.call(path_574948, query_574950, nil, nil, nil)

var predictionResolve2* = Call_PredictionResolve2_574680(
    name: "predictionResolve2", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/{appId}", validator: validate_PredictionResolve2_574681,
    base: "/luis/v2.0/apps", url: url_PredictionResolve2_574682,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
